# Update studyrecord
task :update_study_record => :environment do  
  StudyRecord.all.each do |sr|
    puts "studyrecord: #{sr.id}"
    if sr.course_package.nil?
      sr.destroy
      puts "destroy record #{sr.id}"
    elsif sr.item_id.nil?
      course_package = sr.course_package
      if sr.course_type == "ellis"
        course_package.item_groups.each do |group|
          group.items.where(:content_type=>"Lesson",:content_id=>sr.lesson_id).each do |item|
            if sr.item_id.nil?
              sr.update_attributes(:item_id =>item.id)
              puts "ellis #{sr.id} update success"
            end
          end
        end
      elsif sr.course_type == "scenario"
        course_package.item_groups.each do |group|
          group.items.where(:content_type=>"Scenario",:content_id=>Scenario.find_by_show_scenario_id(sr.lesson_id).id).each do |item|
            if sr.item_id.nil?
              sr.update_attributes(:item_id =>item.id)
              puts "scenario #{sr.id} update success"
            end
          end
        end
      elsif sr.course_type == "third_content"
        third = ThirdContent.find_by_show_content_id(sr.lesson_id)
         if third.thinkingcap_course.blank?
           course_package.item_groups.each do |group|
             group.items.where(:content_type=>"Chinacache").each do |item|
               if item.content.show_chinacache_id == third.show_link
                 sr.update_attributes(:item_id =>item.id)
                 puts "Chinacache #{sr.id} update success"
               end
             end
           end
          else
           course_package.item_groups.each do |group|
             group.items.where(:content_type=>"Thinkingcap").each do |item|
               if item.content.name == third.name
                 sr.update_attributes(:item_id =>item.id)
                 puts "thinkcap #{sr.id} update success"
               end
             end
           end
         end
      end
    end
  end
end

        
 task :update_third_content_study_record => :environment do  
   
   StudyRecord.find(:all,:conditions=>{:course_type=>"third_content"}).each do |sr|
     third = ThirdContent.find_by_show_content_id(sr.lesson_id)
     if third.thinkingcap_course.blank?
       sr.course_package.item_groups.each do |group|
         group.items.where(:content_type=>"Chinacache").each do |item|
           if item.content.show_chinacache_id == third.show_link
             sr.update_attributes(:item_id =>item.id)
             puts "Chinacache #{sr.id} update success"
           end
         end
       end
      else
       sr.course_package.item_groups.each do |group|
         group.items.where(:content_type=>"Thinkingcap").each do |item|
           if item.content.name == third.name
             sr.update_attributes(:item_id =>item.id)
             puts "thinkcap #{sr.id} update success"
           end
         end
       end
     end
   end
 end
 
 task :update_scenario_study_record => :environment do  

    StudyRecord.find(:all,:conditions=>{:course_type=>"scenario"}).each do |sr|
      if scenario = Scenario.find_by_show_scenario_id(sr.lesson_id)
      course_package = sr.course_package
      course_package.item_groups.each do |group|
        group.items.where(:content_type=>"Scenario",:content_id=>scenario.id).each do |item|
          if sr.item_id.nil?
            sr.update_attributes(:item_id =>item.id)
            puts "scenario #{sr.id} update success"
          end
        end
      end
      end
    end
  end
 