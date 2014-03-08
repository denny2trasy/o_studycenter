module WebexsHelper
  def show_current_class(current_day)
    #return "" if item.blank?
    res = ''
    res << "<td style='#{'background: #FFC;' if current_day == Time.now.beginning_of_day }'><div class='webexsclasslist_month'>#{current_day.day}</div> "
    res << "<div class='webexsclasslist'><ul>"
    current_classes  = @classes.select{|a| a.course_start_at > current_day && a.course_start_at < current_day.tomorrow}
    current_classes.each do |c|
      if c.webex_id.present?
        res << "<li><a class='schedule_#{c.id}'>#{c.title} </a></br>"
        res << "#{c.course_start_at.to_s(:time)}-#{c.course_end_at.to_s(:time)}</li>"
      end
    end
    res << "</ul></div></td>"
    return res.html_safe
  end
  
  def class_content_js
    script =""
    script << %(
      this.imagePreview = function(){ 
          xOffset = 10;
          yOffset = 30;)
    @classes.each do |c|
       script << %(
       $("a.schedule_#{c.id}").hover(function(e){
          $("body").append("<div id='schedule_#{c.id}' style='position:absolute;background-color:#FFFFE6;font-size:12px;padding:3px;border:1px solid #FFCC99;display:none'>#{c.description} </div>");         
          $("#schedule_#{c.id}")
           .css("top",(e.pageY - xOffset) + "px")
           .css("left",(e.pageX + yOffset) + "px")
           .fadeIn("slow");      
           },
       function(){
          $("#schedule_#{c.id}").fadeOut("fast");
           }); 
       $("a.schedule_#{c.id}").mousemove(function(e){
          $("#schedule_#{c.id}")
           .css("top",(e.pageY - xOffset) + "px")
           .css("left",(e.pageX + yOffset) + "px");
       });)
     end
     script << "};"
     script << %(
        $(document).ready(function(){
          imagePreview();
          });
     )
     javascript_tag(script)
      
  end
end