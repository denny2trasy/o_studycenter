class Teacher::WebexsController < Teacher::BaseController
  
  def index
    @start_day = params[:start_day].nil? ?  Time.now : params[:start_day].to_time
    @day = params[:day].nil? ? Time.now : params[:day].to_time
    @schedules = Schedule.where("teacher_id = #{current_user.id}")
    @classes = @schedules.select{|a| a.course_start_at >= @day.beginning_of_day && a.course_start_at <= @day.tomorrow.beginning_of_day}
  end
end

