class User::SchedulesController < BaseController
  include SchedulesHelper
  before_filter :set_time_zone
  
  def set_time_zone
    Time.zone=current_user.time_zone
  end
  
  def index
  end
  
  def get_my_course
    @current_course_package = current_user.current_course_package
    @customer_id = @current_course_package.nil? ? 0 : @current_course_package.customer_id
    broadcasts = my_schedules(@customer_id)
    @events = broadcasts.select{|a| a.course_start_at >= Time.at(params['start'].to_i) && a.course_start_at <= Time.at(params['end'].to_i)}
    events = [] 
    @events.each do |event|
      events << {:id => event.id, :title => event.title? ? event.title : event.slide.name,:description => event.description || "Some cool description here...", :start => "#{event.course_start_at.iso8601}", :end => "#{event.course_end_at.iso8601}", :allDay => false, :recurring => false}
    end
    render :text => events.to_json
  end
  
  def get_tc_course
    @events = Schedule.find(:all, :conditions => ["course_start_at >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and course_end_at <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}' and teacher_id = #{current_user.id} "] )
    events = [] 
    @events.each do |event|
      events << {:id => event.id, :title => event.title ,:description => event.description || "Some cool description here...", :start => "#{event.course_start_at.iso8601}", :end => "#{event.course_end_at.iso8601}", :allDay => false, :recurring => (1==2)? true: false}
    end
    render :text => events.to_json
  end
  
end
