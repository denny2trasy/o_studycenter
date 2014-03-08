class BroadcastsController < BaseController
  include SchedulesHelper
  layout :set_layout_loged
  

  def index
    @current_course_package = current_user.current_course_package
    schedules = my_schedules(@current_course_package.customer_id)
    @next_lesson = next_lesson(schedules)
    @lesson = lesson(schedules)
    @is_course_time = @lesson.present?
    
    if @current_course_package.nil?
      render 'no_schedule'
    else
      if  @next_lesson.nil? && @lesson.nil?
        render 'no_schedule'
      elsif ( ! @is_course_time) and @next_lesson.present?
        render 'no_course'
      else
        @token = OpenTok.instance.generate_token(:session_id => @lesson.session_id,:role =>"subscriber")
      end
    end
    @slide =@lesson.nil? ? Slide.new : @lesson.slide
  end
  
  def qr
    render :layout => false
  end
  
  def helper
    render :layout => false
  end
  #alias_method :teacher, :index
  
  
  def create
    debugger
    u_id = params[:userId]
    s_id = params[:scheduleId]
    c_record = BroadRecord.find_or_create_by_user_id_and_schedule_id(u_id,s_id)
    flag = params[:flag]
    h = {}
    if flag == "Start"
      if c_record.started_at.blank?
        h[:started_at] = Time.now        
      else
        h[:times] = c_record.times + 1
      end
    else
      h[:completed_at] = Time.now
    end
    c_record.update_attributes(h)
    render :nothing => true
  end
  
end
