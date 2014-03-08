require 'net/http'
require 'uri'
class PartnersController < BaseController
  include SchedulesHelper
  layout :false
  before_filter :find_current_package,:only=>[:index,:month_schedule]
  

  def index
    @start_day = params[:start_day].nil? ?  Time.now : params[:start_day].to_time
    @day = params[:day].nil? ? Time.now : params[:day].to_time(:local)
    @classes = @schedules.select{|a| a.course_start_at >= @day.beginning_of_day && a.course_start_at <= @day.tomorrow.beginning_of_day}
    @next_lesson = next_lesson(@schedules)
    @lesson = lesson(@schedules)
    @is_course_time = @lesson.present?
  end
  
  def enroll
    @enroll_webex = EnrollWebex.new
    @enroll_webex.enroll_id = params[:EI]
    @enroll_webex.schedule_id = params[:SID]
    @enroll_webex.user_id = current_user.id
    if @enroll_webex.save
      redirect_to  Webex.instance.join_enroll_meeting(webexs_url,params[:WID],params[:EI],params[:PWD])
    else
      render :text=>"enroll webex fail"
    end
      
  end
  
  def month_schedule
    @classes = @schedules.select{|a| a.course_start_at >= Time.now.beginning_of_month && a.course_start_at <= Time.now.end_of_month}
    #render :layout => false
  end
  
  protected
    def find_current_package
      if not current_user.current_course_package
        create_partner_package
      end
      @current_course_package = current_user.current_course_package
      @customer_id = @current_course_package.nil? ? 0 : @current_course_package.customer_id
      @schedules = my_schedules(@customer_id)
    end
    
    def create_partner_package
      @course_package = CoursePackage.find_by_id(params[:course_package])
      if t = CoursePackageUser.where(:user_id => current_user.id, :course_package_id => @course_package.id).blank?
        current_user.add_course_package(@course_package,{})
      end
    end
    
end
