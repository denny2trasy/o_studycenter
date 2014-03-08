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
      return Webex.instance.join_enroll_meeting(webexs_url(:SID=>c.id),c.webex_id,en.enroll_id,c.webex_pwd)
    else
      if c.webex_id.present?
        return Webex.instance.enroll_url(current_user.mail,f_name,"TC",c.webex_id,"eleuid",enroll_webexs_url(:SID => c.id,:WID=>c.webex_id,:PWD=>c.webex_pwd)) 
      end
    end
  end
end