# encoding:utf-8
class Admin::SchedulesController < Admin::BaseController
  
  before_filter :set_time_zone
  
  def set_time_zone
      Time.zone = current_user.time_zone
  end
  def index
    
  end

  
  def get_course
      @events = Schedule.find(:all, :conditions => ["course_start_at >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and course_end_at <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
      events = [] 
      @events.each do |event|
        events << {:id => event.id, :title =>event.title ,:description => event.description || "Some cool description here...", :start => "#{event.course_start_at.iso8601}", :end => "#{event.course_end_at.iso8601}", :allDay => false, :recurring => (1==2)? true: false}
      end
      render :text => events.to_json
  end
  def nnew
    @customers = Customer.all
    @teachers = User.find_all_by_user_type("Teacher")
    @slide = Slide.all
    @event = Schedule.new()
  end
  def create
      @event = Schedule.new(params[:schedule])
      #@event.webex_pwd = generate_code
      @create_webex = params[:video] == "webex" ? true : false
      if @create_webex
        @event.update_attributes(:customer_id=>params[:customer],:slide_id=>params[:slide],:teacher_id=>params[:teacher],:webex_pwd => generate_pwd)
      else
        @event.update_attributes(:customer_id=>params[:customer],:slide_id=>params[:slide],:teacher_id=>params[:teacher])
      end
        
  end
  
  def move
    @event = Schedule.find_by_id params[:id]
    if @event
      @event.course_start_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.course_start_at))
      @event.course_end_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.course_end_at))
      #@event.all_day = params[:all_day]
      @event.save
    end
  end
  
  def resize
    @event = Schedule.find_by_id params[:id]
    if @event
      @event.course_end_at = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.course_end_at))
      @event.save
    end    
  end
  
  def edit
    @event = Schedule.find_by_id(params[:id])
    @customers = Customer.all
    @teachers = User.find_all_by_user_type("Teacher")
    @slide = Slide.all
  end
  
  def update
    @event = Schedule.find_by_id(params[:schedule][:id])
    @event.attributes = params[:schedule]
    @event.slide_id = params[:slide]
    @event.teacher_id = params[:teacher]
    @event.save
    
    render :update do |page|
      page<<"$('#fullcalendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
  end
  
  def destroy
    @event = Schedule.find_by_id(params[:id])
    @event.destroy
    CustomerSchedule.destroy_all(:schedule_id => params[:id])
    
     render :update do |page|
        page<<"$('#fullcalendar').fullCalendar( 'refetchEvents' )"
        page<<"$('#desc_dialog').dialog('destroy')" 
      end
  end
  
  
  
  def show
    @schedule = Schedule.find_by_id(params[:id])
  end
  
  def customer_list
    @schedule = Schedule.find_by_id(params[:id])
    @customers = Customer.all
  end
  
  def customer_schedule
    @customer_schedule = CustomerSchedule.find(:first,:conditions=>{:customer_id=>params[:customer_id],:schedule_id=>params[:schedule_id]})
    if @customer_schedule
      @customer_schedule.try(:destroy)
      render :text => {:status=>"Success!",:checked =>false}.to_json
    elsif CustomerSchedule.create(:customer_id=>params[:customer_id],:schedule_id=>params[:schedule_id])
      render :text => {:status=>"Success!",:checked =>true}.to_json
    else
      render :text => {:status=>"Fail!",:checked =>''}.to_json
    end
  end
  
  def generate_pwd
    range = ("A".."Z").to_a + ("0".."9").to_a
    pwd = ""
    (1..8).each do |n|
      pwd += range[rand * range.size]
    end
    return pwd
  end
  
  
  def login
    redirect_to Webex.instance.login
  end
  
  def set_meeting
    redirect_to Webex.instance.set_meeting_type 
  end
  
  def schedule_meeting
    #[:en],ye,mo,da,ho,mi,du,jpw,bu)
    # denny edit it at 2014.3.28
    # params[:BU] = up_schedule_admin_schedules_url(:id=>params[:id])
    if Rails.env.production?
      params[:BU] = "http://www.oenglish.net/#{up_schedule_admin_schedules_path(:id=>params[:id])}"
    else
      params[:BU] = up_schedule_admin_schedules_url(:id=>params[:id])
    end
    
    redirect_to Webex.instance.schedule_meeting(params)
  end
   
  def up_schedule
    webex_id = params[:MK]
    schedule = Schedule.find(params[:id])
    if schedule.update_attributes(:webex_id=>webex_id) && webex_id.present?
      redirect_to admin_schedules_path(:status=>"success",:wid=>webex_id)
    else
      render :text => "fail to create webex!"
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def save(title,course_time,course_end_at)
    @schedule = Schedule.new
    @schedule.title=title
    @schedule.course_start_at=course_time
    @schedule.course_end_at=course_end_at
    @schedule.save
  end
  
  def upload
       @filename = save_file   
        book = Spreadsheet.open "#{RAILS_ROOT}/public/uploads/#{@filename}"
        book.worksheets
        sheet1 = book.worksheet 0
        sheet1.each do |row|
            save(row[0],row[1],row[2]) if row.idx !=0
          end
          if File.exists? ("#{RAILS_ROOT}/public/uploads/#{@filename}")
             File.delete("#{RAILS_ROOT}/public/uploads/#{@filename}")
          end
        redirect_to :action => "index"
  end
  
  def upload_file(file)   
       if !file.original_filename.empty?
             @filename=get_file_name(file.original_filename)
             File.open("#{RAILS_ROOT}/public/uploads/#{@filename}", "wb") do |f|
                     f.write(file.read)
                   end
                   return @filename
                 end
     end   

     def get_file_name(filename)   
       if !filename.nil?   
         Time.now.strftime("%Y%m%d%H%M%S") + '_' + filename   
       end   
     end   

     def save_file
       unless request.get?   
         if filename = upload_file(params[:file]['file'])   
           return filename   
         end   
       end   
     end
     def download
       send_file "public/uploads/time_template.xls"
     end
end
