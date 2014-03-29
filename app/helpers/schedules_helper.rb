module SchedulesHelper
  
  def my_schedules(customer_id = 0)
    broadcasts = []
    if current_user.user_type.downcase == "admin"
      broadcasts = Schedule.all
    else
      customer_schedules = Customer.try(:find_by_id,customer_id).try(:customer_schedules)
      customer_schedules.try(:each) do |item|
        broadcasts << item.schedule if not item.schedule.nil?
      end
      broadcasts = broadcasts.sort{|x,y| x.course_end_at <=> y.course_end_at}
    end
    return broadcasts
  end
  
  def next_lesson(broadcasts)
    broadcasts.find{|a| a.course_start_at >=Time.now}
  end
  
  def prev_lesson(broadcasts)
    broadcasts.reverse.find{|a| a.course_start_at <Time.now}
  end
  
  def lesson(broadcasts)
    broadcasts.find{|a| a.course_end_at >= Time.now && a.course_start_at <=Time.now}
  end
  
  def webex_login_url(c)
    f_name = current_user.given_name.blank? ? current_user.login : current_user.given_name
    if en = EnrollWebex.find(:first,:conditions =>{:user_id => current_user.id,:schedule_id => c.id})
      
      if Rails.env.production?
        url = "http://www.oenglish.net/#{webexs_path(:SID=>c.id)}"
      else
        url = webexs_url(:SID=>c.id)
      end
      
      return Webex.instance.join_enroll_meeting(url,c.webex_id,en.enroll_id,c.webex_pwd)
    else
      if c.webex_id.present?
        
        if Rails.env.production?
          enroll_url = "http://www.oenglish.net/#{enroll_webexs_path(:SID => c.id,:WID=>c.webex_id,:PWD=>c.webex_pwd)}"
        else
          enroll_url = enroll_webexs_url(:SID => c.id,:WID=>c.webex_id,:PWD=>c.webex_pwd)
        end
        
        return Webex.instance.enroll_url(current_user.mail,f_name,"TC",c.webex_id,"eleuid",enroll_url) 
      end
    end
  end
end