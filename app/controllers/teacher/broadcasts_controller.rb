class Teacher::BroadcastsController < Teacher::BaseController


  def index
    @schedule = Schedule.where("teacher_id = #{current_user.id}")
    @lesson = @schedule.find(:first,:conditions =>"course_start_at <= '#{Time.now.in_time_zone("UTC").to_s(:db)}' && '#{Time.now.in_time_zone("UTC").to_s(:db)}'<= course_end_at ")
    @next_lesson = @schedule.next_lesson
    @is_course_time = @lesson.present?
    
    if  @next_lesson.nil? && @lesson.nil?
      render 'no_schedule'
    elsif ( ! @is_course_time) and @next_lesson.present?
      render 'no_course'
    else
      @token = OpenTok.instance.generate_token(:session_id => @lesson.session_id,:role => "publisher")
    end
    @slide =@lesson.nil? ? Slide.new : @lesson.slide
    
    @broad_records = @lesson.try(:broad_records)
    
  end
  
  def create
    @schedule = Schedule.find_by_id(params[:scheduleId])
    @schedule.update_attributes(:archive_id => params[:archiveId])
    render :nothing => true
  end
  
  def show
    @schedule = Schedule.find_by_id(params[:id])
    @broad_records = @schedule.broad_records
    render :partial => "show", :layout => false
  end
  

end
