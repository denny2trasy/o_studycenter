module HomeHelper
  def show_current_course_for_student(item)
    return "" if item.blank?
    res = ""
    res <<"<a href=#{item.lesson_link}> <img src='#{item.img_link}' width='260' height='180' /> </a>"
    res <<"<div id='Current_courses_text'>"
    res <<"<h2>#{link_to item.content.name, item.lesson_link}</h2>"
    res <<"<h3>lesson #{item.position}</h3>"
    res <<"<p>#{item.name or item.content.name}</p>"
    res <<"<div class='study_button'>"
    res <<"#{link_to t(:start_study), item.lesson_link }"
    res <<"</div>"
    return res.html_safe
  end

  
  def show_current_course_for_students(item,course_type)
    return "" if item.blank?
    res = ''
    if course_type == "ellis"
      lesson = item
      res <<"<a href=#{lesson_path(lesson.id)}> <img src='http://cdn.eleutian.com/Content/Lessons/#{lesson.image_url}' width='260' height='180' /> </a>"
      res <<"<div id='Current_courses_text'>"
      res <<"<h2>#{link_to lesson.name, lesson_path(lesson.id)}</h2>"
      res <<"<h3>lesson #{lesson.id}</h3>"
      res <<"<p>#{lesson.script_screen.headline.blank? ? lesson.name : lesson.script_screen.headline if lesson.script_screen}</p>"
      res <<"<div class='study_button'>"
      res <<"#{link_to t(:start_study), lesson_path(lesson.id) }"
      res <<"</div>"
    elsif course_type == "scenario"
      scenario = item
      res <<"<a href=#{scenario_path(scenario.show_scenario_id)}> <img src='http://cdn.eleutian.com/Content/EQ/Formula#{scenario.show_scenario_id}.jpg' width='260' height='180' /> </a>"
      res <<"<div id='Current_courses_text'>"
      res <<"<h2>#{link_to scenario.name, scenario_path(scenario.show_scenario_id)}</h2>"
      res <<"<h3>lesson #{scenario.position}</h3>"
      res <<"<p>#{scenario.name}</p>"
      res <<"<div class='study_button'>"
      res <<"#{link_to t(:start_study), scenario_path(scenario.show_scenario_id) }"
      res <<"</div>"
    elsif course_type == "third_content"
      content = item
      unless content.thinkingcap_course.blank?
        if content.show_link == "ok"
          image_src = "jianqiao/go_large.png"
          # image_src = "jianqiao/#{content.show_content_id}_large.png"  
        else
          image_src = "jianqiao/bv_large.png"
        end    
      else      
        image_src = "xinhangdao/cambridge_large.jpg" # || third_content.show_content_id
      end
      res <<"<a href=#{chinacach_path(content.show_content_id)}> <img src='/el_studycenter/images/el/#{image_src}' width='260' height='180' /> </a>"
      res <<"<div id='Current_courses_text'>"
      res <<"<h2>#{link_to content.name, chinacach_path(content.show_content_id)}</h2>"
      res <<"<h3>lesson #{content.position}</h3>"
      res <<"<p>#{content.name}</p>"
      res <<"<div class='study_button'>"
      res <<"#{link_to t(:start_study), chinacach_path(content.show_content_id) }"
      res <<"</div>"
    end
    
    return res.html_safe
  end
  
  def show_recent_course_for_student(item,course_type)
    return "" if item.blank?
    res = ''
    if course_type == "ellis"
      lesson = item
      res << "<a href=#{lesson_path(lesson.id)}> <img src='http://cdn.eleutian.com/Content/Lessons/#{lesson.image_url}' width='124' height='87' /> </a>"
      res << "<div class='nex_nre_Lesson_text'>"
      res << "<h2>#{link_to 'lesson '+lesson.id.to_s, lesson_path(lesson.id)}</h2>"
      res << "<p>#{lesson.script_screen.headline.blank? ? lesson.name: lesson.script_screen.headline if lesson.script_screen}</p>"
      res << "<div class='study_button_small'>"
      res << "#{link_to t(:start_study), lesson_path(lesson.id)}"
      res << "</div>"
      res << "  </div>"
    elsif course_type == "scenario"
      scenario = item
      res <<"<a href=#{scenario_path(scenario.show_scenario_id)}> <img src='http://cdn.eleutian.com/Content/EQ/Formula#{scenario.show_scenario_id}.jpg' width='124' height='87' /> </a>"
      res <<"<div class='nex_nre_Lesson_text'>"
      res <<"<h2>#{link_to scenario.name, scenario_path(scenario.show_scenario_id)}</h2>"
      res <<"<h3>lesson #{scenario.show_scenario_id}</h3>"
      res <<"<div class='study_button_small'>"
      res <<"#{link_to t(:start_study), scenario_path(scenario.show_scenario_id) }"
      res <<"</div>"
      res <<"</div>"
    end
    return res.html_safe
  end
end