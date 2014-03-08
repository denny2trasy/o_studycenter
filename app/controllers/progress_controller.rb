class ProgressController < BaseController
  include SchedulesHelper
  
  def index
    @course_package = current_user.current_course_package
    @item_groups = @course_package.item_groups
    @studied_num = @course_package.lesson_studied(current_user.id).count
    @lesson_num = @course_package.lesson_number
    @webex_num = @course_package.webex_studied_records(current_user).count
    @exam_num = @course_package.my_examinations(current_user).count
    @next_schedule_lesson = next_lesson(my_schedules(@course_package.customer_id))
  end
  
  def group_study_records
    data=[]
    @item_group = ItemGroup.find(params[:id])
    @item_group.items.each do |item|
      if item.content.is_a?(Thinkingcap)
        records = item.thinkingcap_records(current_user)
        if records.present?
          name = item.content.name
          progress = records.present? ? records.last.progress/100 : 0
          score = records.present? ? records.last.score : 0
          time = records.present? ? (records.last.duration/60).to_i : ""
          data << {:group=>@item_group.name,:value=>{:name =>name, :progress =>format("%0.2f", progress), :score =>score, :time_at =>time}}
        end
      else
        records = item.my_study_records(current_user)
        if records.present?
          progress = (records.present? ? 1:0)
          name =item.content.name
          times = records.present? ? records.count : 0
          time = records.present? ? records.last.created_at.to_s(:db) : ""
          data << {:group=>@item_group.name,:value=>{:name =>name, :progress =>format("%0.2f", progress)  , :times =>times, :time_at =>time}}
        end
      end
    end
    render :json =>data.to_json
  end
  
  def group_webex_records
    data=[]
    @item_group = ItemGroup.find(params[:id])
    @item_group.items.each do |item|
      @item_all_time = 0
      @item_progress = 0
      @w_records=[]
      @du = 1
      item.content.schedules.each do |schedule|
        records = WebexRecord.where(:schedule_id =>schedule.id,:user_id =>current_user.id)
        all_time = WebexRecord.all_time(records)
        @item_all_time += all_time
        @du = schedule.du
        @w_records += records
      end
      @item_progress = (@du < @item_all_time) ? 1 : (@item_all_time/@du)
      if @item_all_time >0
        data << {:group=>@item_group.name,:value=>{:name =>item.content.name,:progress =>format("%0.2f", @item_progress),:all_time=>@item_all_time,:time_at =>@w_records.last.join_at.to_s(:db)}}
      end
    end
    render :json =>data.to_json
  end
  
  def group_test_records
     data=[]
     @item_group = ItemGroup.find(params[:id])
     @item_group.my_examinations(current_user).each do |exam|
		   all_num = exam.examination_quizzes.count
		   right_num = exam.examination_quizzes.where(:is_correct => true).count
		   wrong_num = exam.examination_quizzes.where(:is_correct => false).count
		   undo_num = all_num-right_num-wrong_num
		   complate_rate = (right_num+wrong_num)/(all_num == 0 ? 1 : all_num)
		   right_rate = right_num/all_num
		   data << {:group=>@item_group.name,:value=>{:name =>@item_group.name,:progress =>format("%0.2f", complate_rate),:time_at =>exam.created_at.to_s(:db),:score =>right_rate}}
	   end
	   render :json =>data.to_json
  end
end
