module CoursePackagesHelper

  def show_course_package_for_student(course)
    return "" if course.blank?
    res = "<div class='course_list'>"
    res << "  <h1 class='headline_h1a'>#{course.name}</h1>"
    course.item_groups.each do |unit|
      res <<  show_unit_for_student(unit)
    end    
    res << "</div>"
    res << "<div class='headline_bottom'><p>&nbsp;</p><p>&nbsp;</p></div>"
    return res.html_safe
  end
  
  def show_unit_for_student(unit)
    return "" if unit.blank?
    res = "<div class='unit_list'>"
    res << "  <h2>#{unit.name}</h2>"
    res << "  <ul>"
    unless unit.items.blank?
      unit.items.each do |item|
        res <<  show_lesson_for_student(item)
      end
    end
    res << "  </ul>"
    res << "</div>"
    return res.html_safe
  end
  
  def show_lesson_for_student(item) 
    return "" if item.blank?
    res = "<li>"
    res << "<a href='#{item.lesson_link}'><img src='#{item.img_link}' width='129' height='91' /></a>"
    res << "<h4><a href='#{item.lesson_link}'>Lesson #{item.position}</a></h4>"
    res << "</li>"
    return res.html_safe
  end

  def show_scenario_for_student(scenario,course_package_id)
    return "" if scenario.blank? or scenario.show_scenario_id.blank?
    res = "<li>"
    res << "<a href='/el_studycenter/scenarios/#{scenario.show_scenario_id}?package_id=#{course_package_id}'><img src='http://cdn.eleutian.com/Content/EQ/Formula#{scenario.show_scenario_id}.jpg' width='129' height='91' /></a>"
    res << "<h4><a href='/el_studycenter/scenarios/#{scenario.show_scenario_id}?package_id=#{course_package_id}'>Formula #{scenario.position}</a></h4>"
    res << "</li>"
    return res.html_safe
  end
  
  # show_content_id is for find and picture show
  
  def show_third_content_for_student(third_content,course_package_id)
    return "" if third_content.blank? or third_content.show_content_id.blank?    
    
    unless third_content.thinkingcap_course.blank?
      if third_content.show_link == "ok"
        image_src = "jianqiao/go.png"
        # image_src = "jianqiao/#{third_content.show_content_id}.png" 
      else
        image_src = "jianqiao/bv.png"
      end     
    else      
      image_src = "xinhangdao/cambridge_small.jpg" # || third_content.show_content_id
    end
    
    res = "<li>"
    res << "<a href='#{chinacach_path(third_content.show_content_id)}?package_id=#{@course_package.id}'><img src='/el_studycenter/images/el/#{image_src}' width='129' height='91' /></a>"
    res << "<h4><a href='#{chinacach_path(third_content.show_content_id)}?package_id=#{@course_package.id}'>Lesson #{third_content.position}</a></h4>"
    res << "</li>"
    return res.html_safe
  end
  
  def show_studied_records(course_packages)
    script = ""
    script << %(
    this.imagePreview = function(){ 
          xOffset = 10;
          yOffset = 30;
          )
    course_packages.each do |course_package|
      course_package.item_groups.each do |item_group|
      script << %(      
       $("td.group_#{item_group.id}").hover(function(e){
    	getRecords(#{item_group.id},#{course_package.id});
          $("#schedule_#{item_group.id}")
           .css("top",(e.pageY - xOffset) + "px")
           .css("left",(e.pageX + yOffset) + "px")
           .fadeIn("slow");      
           },
       function(){
          $("#schedule_#{item_group.id}").fadeOut("fast");
           }); 
       $("a.group_#{item_group.id}").click($("#schedule_#{item_group.id}").fadeIn("slow"));
       $("a.group_#{item_group.id}").mousemove(function(e){
          $("#schedule_#{item_group.id}")
           .css("top",(e.pageY - xOffset) + "px")
           .css("left",(e.pageX + yOffset) + "px");
       });
       )
     end
    end
       script << " };"
       javascript_tag(script) 
  end

end