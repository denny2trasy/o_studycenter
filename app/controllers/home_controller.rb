class HomeController < BaseController
  include SchedulesHelper
  layout :set_layout_loged
  before_filter :teacher_logined?
  
  def teacher_logined?
      redirect_to teacher_webexs_path if current_user.user_type.downcase == "teacher"
  end
  
  def index
    if request.domain == "eleutian.com"
      redirect_to ehome_index_path and return
    end
    if @course_package = current_user.current_course_package
      @course_packages = current_user.course_packages
      @study_records = current_user.study_records.where(:course_package_id =>@course_package.id)
      @item = @study_records.blank? ? @course_package.items.first : @study_records.last.item
      @item_group = @item.item_group
      #@current_lesson = @item.content
      @next_item = (c = Item.find_by_position((!@item.position.nil? ? @item.position : 0 )+1)) ? c : @item
      @prev_item = (c = Item.find_by_position((!@item.position.nil? ? @item.position : 1 )-1)) ? c : @item
      
      @learn_progress = @course_package.study_progress(current_user.id)
      @notices = Notice.where("display = ?",true).order("updated_at DESC") 
      @next_schedule_lesson = next_lesson(my_schedules(@course_package.customer_id))
    end
  end

  # def indexs
  #   if request.domain == "eleutian.com"
  #     redirect_to ehome_index_path and return
  #   end
  #   if @course_package = current_user.current_course_package
  #     @course_packages = current_user.course_packages
  #     @study_records = current_user.study_records.where(:course_package_id =>@course_package.id)
  #     @ellis_records = []
  #     @scenario_records = []
  #     @third_records = []
  #     @study_records.each do |record|
  #       if record.course_type == "scenario"
  #         @scenario_records << record
  #       elsif record.course_type == "third_content"
  #         @third_records << record
  #       else
  #         @ellis_records << record
  #       end
  #     end
  #     #@course_type = @course_package.course_type
  #     @course_type = @study_records.blank? ? @course_package.first_lesson_type : @study_records.last.course_type
  #     current_lesson_id = @study_records.blank? ? @course_package.first_lesson_id : @study_records.last.lesson_id
  #     if @course_type == "ellis"
  #       lessons = @course_package.items
  #       @lesson = Lesson.find_by_id current_lesson_id
  #       @item = lessons.find{|i| i.lesson_id == current_lesson_id}
  #       @item_group = @item.item_group
  #       index = lessons.map(&:lesson_id).index(@lesson.id) || 0
  #       @prev_lesson = prev_ellis(index,lessons)
  #       @next_lesson = next_ellis(index,lessons)
  #     elsif @course_type == "scenario"
  #       scenarios = @course_package.scenarios
  #       @lesson = scenarios.find{|i| i.show_scenario_id == current_lesson_id}
  #       @item_group = @lesson.item_group
  #       index = scenarios.map(&:show_scenario_id).index(current_lesson_id) || 0
  #       @prev_lesson = prev_scenario(index,scenarios)
  #       @next_lesson = next_scenario(index,scenarios)
  #     elsif @course_type == "third_content"
  #       third_contents = @course_package.third_contents
  #       @lesson = third_contents.find{ |i| i.show_content_id == current_lesson_id.to_s}
  #       @item_group = @lesson.item_group
  #       index = third_contents.map(&:show_content_id).index(current_lesson_id) || 0
  #       #@prev_lesson = prev_scenario(index,scenarios)
  #       #@next_lesson = next_scenario(index,scenarios)
  #       
  #     end
  # 
  # 
  #     @learn_progress = @course_package.study_progress(current_user.id)
  # 
  #     package_user = CoursePackageUser.where(:user_id => current_user.id, :current => true).first
  #   
  #     if package_user.blank?
  #       current_user.set_current_course_package(@course_package)
  #       package_user = CoursePackageUser.where(:user_id => current_user.id, :current => true).first
  #     end
  #     unless package_user.blank?
  #       start_time = package_user.created_at
  #       @due_time = start_time + @course_package.valid_for.to_i.days
  # 
  #       customer_id = package_user.customer_id   
  #     end
  #     @notices = Notice.where("display = ?",true).order("updated_at DESC")
  #     #@next_schedule_lesson = next_lesson(my_schedules(customer_id))
  #     #@prev_schedule_lesson = prev_lesson(my_schedules(customer_id))
  #   end
  # end
  # 
  # 
  # def prev_ellis(index,lessons)
  #   Lesson.find_by_id(lessons[index-1].lesson_id) || 0 if index > 0
  # end
  # 
  # def next_ellis(index,lessons)
  #   Lesson.find_by_id(lessons[index+1].lesson_id) if index < lessons.length - 1
  # end
  # 
  # def prev_scenario(index,scenarios)
  #   Scenario.find_by_show_scenario_id(scenarios[index-1].show_scenario_id) if index > 0
  # end
  # 
  # def next_scenario(index,scenarios)
  #   Scenario.find_by_show_scenario_id(scenarios[index+1].show_scenario_id) if index < scenarios.length - 1
  # end
  
end