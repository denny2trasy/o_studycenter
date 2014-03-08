require "savon"
class ThinkingCapClient
  
  
  def initialize      
    @client = Savon.client("http://thinkingcap.eleutian.asia/webservice/campusregistration.asmx?wsdl")
    @login_hash = {:login => "admin@eleutian.asia", :password => "ETch1n@8"}      
  end
  
  # this function should be run every day
  def update_thinkingcap_record
    puts "Date := #{Time.now.to_date}"
    all_programs = CoursePackage.thinkingcap_programs
    User.students_for_thinkingcap.each do |student|
      u_programs = student.course_packages
      (u_programs && all_programs).each do |program|  # our course
        program.item_groups.each do |group|
          if (not group.course_type.blank? and group.course_type == 'Thinkingcap')
            group.items.each do |item|
              course = item.content
              if (not course.blank?) and (not course.show_course_id.blank?)
                puts "  - Student[#{student.thinkingcap_student}] - Program[#{course.name}] - Course[#{course.show_course_id}]"
                update_student_thinkingcap_record(student.thinkingcap_student,course.show_course_id)
              end
            end
          end
        end
      end
    end
  end
  
  
  # :studentID => "6bbb3d3b-dda7-4c42-8494-671a3919c595",  
  # :courseID => "9eb082e4-e506-4d00-a8c5-2aa1d3fea486"
  def update_student_thinkingcap_record(student_id,course_id)
    doc = get_student_record_summary(student_id,course_id)
    unless doc == "500"
      h_params = transfer_info_from_doc(doc)
      puts h_params
      create_thinkingcap_record(student_id,course_id,h_params)
    end
  end
  
  
  
  def get_student_record_summary(student_id,course_id)  
    begin  
      response = @client.request :get_student_record_summary, :body => @login_hash.merge({ :studentID => student_id,  :courseID => course_id })
      return REXML::Document.new(response.body[:get_student_record_summary_response][:get_student_record_summary_result])
    catch Excepiton => e
      puts e.message
    rescue
      return "500"
    end
  end
  
  def transfer_info_from_doc(doc)
    score = 0.0
    progress = 0.0
    totaltime = 0.0
    
    doc.root.elements.each do |element|
      if element.name == "score"
        score = (element.attributes["max"] == "0" ? 0 : element.attributes["scaled"].to_f) * 100
      end
      if element.name == "totaltime"
        unless element.text.blank?
          if element.text =~ /(\d*):(\d*):(\d*.\d*)/
            totaltime = ($1.to_i * 3600) + ($2.to_i * 60) + $3.to_f
          end
        end
      end
      if element.name == "item"
        element.elements.each do |sub_element|
          if sub_element.name == "score"
            progress = (sub_element.attributes["progress"].to_f * 100) unless sub_element.attributes["progress"].blank?
          end
        end
      end
      
    end
    {:score => score, :progress => progress, :duration => totaltime}
  end
  
  def create_thinkingcap_record(student_id,course_id,h_content)

    student = User.find_by_thinkingcap_student(student_id)
    thinkingcap = Thinkingcap.find_by_show_course_id(course_id)
    if (not thinkingcap.blank?) and (not student.blank?)     
      record = ThinkingcapRecord.find_or_create_by_user_id_and_third_content_id(student.id,thinkingcap.id)
      record.update_attributes(h_content.merge({:thinkingcap_course_id => course_id}))
    end
    
  end
  
end




# client = ThinkingCapClient.new
# client.update_student_thinkingcap_record("6bbb3d3b-dda7-4c42-8494-671a3919c595","9eb082e4-e506-4d00-a8c5-2aa1d3fea486")





# method1, directly parse xml 
# client = Savon.client("http://thinkingcap.eleutian.asia/webservice/campusregistration.asmx?wsdl")
# response = client.request :get_student_record_summary, :body => { :login => "admin@eleutian.asia", :password => "ETch1n@8", :studentID => "6bbb3d3b-dda7-4c42-8494-671a3919c595",  :courseID => "9eb082e4-e506-4d00-a8c5-2aa1d3fea486" }
# 
# doc  = REXML::Document.new(response.body[:get_student_record_summary_response][:get_student_record_summary_result])
# 
# score = {}
# totaltime = ""
# doc.root.elements.each do |element|
#   if element.name == "score"
#     score = element.attributes
#   end
#   if element.name == "totaltime"
#     totaltime = element.text
#   end
#   
# end
# 
# puts score.inspect
# puts "*******************************"
# puts totaltime


# method2, use gem, but not work well
# require "xml/mapping"
# root = XML::Mapping.load_object_from_xml(response.body[:get_student_record_summary_response][:get_student_record_summary_result])