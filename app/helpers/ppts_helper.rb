module PptsHelper
  
  def ellis_sort(slides)
    res = ""
    slides.each do |slide|
      cls = ""
      name = slide.name
      if name =~ /\([9|1|2|3]/
        re = $&
        if re.size > 0
          cls = "speakeng#{re[1]}"
        end
      end
      res << "<li class='#{cls}'><a href='#' onclick='get_ppt(#{slide.id}); return false;'>#{slide.name}</a></li>"
		end
		return res.html_safe
  end
  
  def lets_go_sort(slides)
    res = ""
    slides.each do |slide|
      res << "<li class='speakeng1'><a href='#' onclick='get_ppt(#{slide.id}); return false;'>#{slide.name}</a></li>"
		end
		return res.html_safe
  end
  
  def bus_venture_sort(slides)
     res = ""
     slides.each do |slide|
       res << "<li class='speakeng2'><a href='#' onclick='get_ppt(#{slide.id}); return false;'>#{slide.name}</a></li>"
 		end
 		return res.html_safe
   end
   
   def has_course_type(course_packages,type)
     flag = false
     course_packages.each do |package|
       flag =true if package.course_type == type
     end
     return flag
   end
end