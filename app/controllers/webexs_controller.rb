require 'net/http'
require 'uri'
class WebexsController < BaseController
  include SchedulesHelper
  layout :set_layout_loged
  before_filter :find_current_package,:only=>[:index,:month_schedule]
  

  def index
    @start_day = params[:start_day].nil? ?  Time.now : params[:start_day].to_time
    @day = params[:day].nil? ? Time.now : params[:day].to_time(:local)
    @classes = @schedules.select{|a| a.course_start_at >= @day.beginning_of_day && a.course_start_at <= @day.tomorrow.beginning_of_day}
    @next_lesson = next_lesson(@schedules)
    @lesson = lesson(@schedules)
    @is_course_time = @lesson.present?
    
    @schedule_id = params[:SID].to_i      
    
    #if @current_course_package.nil?
    #  render :text=> "如果你想购买我们的课程，请联系我们"
    #end
      
      #if  @next_lesson.nil? && @lesson.nil?
       # render 'no_schedule'
      #elsif ( ! @is_course_time) and @next_lesson.present?
      #  render 'no_course'
      #else
      #  redirect_to Webex.instance.join_meeting(webexs_path,@lesson.webex_id,current_user.mail,current_user.given_name,"TC",@lesson.webex_pwd) if @lesson.webex_id.present?
      #end
    #end
  end
  
  def enroll
    @enroll_webex = EnrollWebex.new
    @enroll_webex.enroll_id = params[:EI]
    @enroll_webex.schedule_id = params[:SID]
    @enroll_webex.user_id = current_user.id
    if @enroll_webex.save
      if Rails.env.production?
        url = "http://www.oenglish.net/#{webexs_path}"
      else
        url = webexs_url
      end
      
      redirect_to  Webex.instance.join_enroll_meeting(url,params[:WID],params[:EI],params[:PWD])
    else
      render :text=>"enroll webex fail"
    end
      
  end
  
  def get_enroll_id
    @schedule_id = params[:SID]
    render :layout => false
  end
  
  def re_enroll
    @enroll_webex = EnrollWebex.find(:first,:conditions=>{:schedule_id => params[:SID].to_i,:user_id => current_user.id})
    if @enroll_webex.present? && params[:EI].present?
      @webex_id = @enroll_webex.schedule.webex_id
      @webex_pwd = @enroll_webex.schedule.webex_pwd
      if @enroll_webex.update_attributes(:enroll_id=>params[:EI])
        if Rails.env.production?
          url = "http://www.oenglish.net/#{webexs_path}"
        else
          url = webexs_url
        end
        redirect_to  Webex.instance.join_enroll_meeting(url,@webex_id,params[:EI],@webex_pwd)
      end
    else
      redirect_to webexs_path
    end
  end
  
  
  
  def month_schedule
    @classes = @schedules.select{|a| a.course_start_at >= Time.now.beginning_of_month && a.course_start_at <= Time.now.end_of_month}
    #render :layout => false
  end
  
  protected
    def find_current_package
      @current_course_package = current_user.current_course_package
      @customer_id = @current_course_package.nil? ? 0 : @current_course_package.customer_id
      @schedules = my_schedules(@customer_id)
    end
    
end
