

module ThinkingCap

  class SDK
    
    def initialize(url,login,password)
      @api_url = url
      @login = login
      @password = password
    end
    
    def register_student_with_language(student)
      api_url = "#{@api_url}/RegisterStudentWithLanguage"
      params = {}
      params["firstName"] = student.given_name
      params["lastName"] = student.surname
      params["title"] = "Student"
      params["email"] = student.mail
      params["studentpassword"] = "eleutian_abc"
      params["language"] = "zh"
      doc = post_request(api_url,params,true)
      suuid = doc.root.get_text.value
      student.update_attributes(:thinkingcap_student => suuid)
    end
    
    def add_to_program(student,program)
      register_student_with_language(student) if student.thinkingcap_student.blank?
      api_url = "#{@api_url}/AddToProgram"
      params = {}
      params["StudentID"] = student.thinkingcap_student
      params["ProgarmID"] = program.thinkingcap_program
      post_request(api_url,params,false)
    end
    
    def enroll_student_with_duedate(student,course,days)
      register_student_with_language(student) if student.thinkingcap_student.blank?
      api_url = "#{@api_url}/EnrollStudentWithDueDate"
      params = {}
      params["StudentID"] = student.thinkingcap_student
      params["CourseID"] = course.show_course_id
      params["DaysToCompletion"] = days
      # return api_url + "?" + {"login" => @login,"password" => @password}.merge(params).to_param
      post_request(api_url,params,false)     
    end
    
    def is_enrolled(student,course)
      register_student_with_language(student) if student.thinkingcap_student.blank?
      api_url = "#{@api_url}/IsEnrolled"
      params = {}
      params["StudentID"] = student.thinkingcap_student
      params["CourseID"] = course.show_course_id
      doc = post_request(api_url,params,true)
      return ((doc.blank? || doc.root.blank?) ? false : doc.root.get_text.value)
      # return doc.root.get_text.value    
    end
    
    def get_auto_login_url(student,course)
      register_student_with_language(student) if student.thinkingcap_student.blank?
      api_url = "#{@api_url}/GetAutoLoginURL"
      params = {}
      params["StudentID"] = student.thinkingcap_student
      params["CourseID"] = course.show_course_id
      params["ModuleID"] = ""
      doc = post_request(api_url,params,true)
      return ((doc.blank? || doc.root.blank?) ? nil : doc.root.get_text.value)
      # return doc.root.get_text.value      
    end
    
    protected
    
    # return response body's xml style
    def post_request(api_url,params,is_back)
      
      uri = URI.parse(api_url)
      http = Net::HTTP.new(uri.host,uri.port)
      # http.use_ssl = true if uri.scheme == "https"
      # http.verify_mode = OpenSSL::SSL::VERIFY_NONE    

      data = {"login" => @login,"password" => @password}.merge(params).to_param

      http.start {
        http.request_post(uri.path,data) { |res|
          if is_back          
            return REXML::Document.new(res.body)
          else
            return res.code
          end        
        }
      }

    end
    
  
  end
  
end