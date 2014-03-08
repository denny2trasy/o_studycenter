module ProgressHelper
  def progress_bar(rate)
    res = "<div class='progress_self_bg'><div class='#{bar_class(rate)}' style='width: #{rate*100}%'></div></div>"
    res.html_safe
  end
  
  def bar_class(rate)
    if rate*3.0 < 1
      return "progress_self_red"
    elsif rate*3.0 < 2
      return "progress_self_yellow"
    else
      return "progress_self_green"
    end 
  end
  
  # def record_link(group_id,type,disabled)
  #   res = ""
  #   if disabled
  #     res = "#{t(:details)}"
  #   res = "<a href='#item_group_#{group.id}_study} onclick='getStudyRecord(#{group.id});'>查看</a>"
  #   
  # end
end