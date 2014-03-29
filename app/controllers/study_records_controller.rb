class StudyRecordsController < BaseController
  layout :set_layout_loged


  def create
    current_user.study_records.find_or_create_by_lesson_id(params[:lesson_id], params[:package_id])

    redirect_to lesson_path(params[:lesson_id])
  end
  
  def show_records
    item_studied = ItemGroup.find_by_id(params[:group_id]).lesson_studied(current_user)
    item_ids = []
    item_studied.each do |l|
    item_ids << l.item_id
    end
    @records = current_user.study_records.find(:all,:select=>'lesson_id,lesson_name,item_id,max(updated_at) as updated_at',:conditions=>{:item_id => item_ids},:order =>"updated_at desc",:group =>"item_id")
    js=[]
    @records.each do |record|
      js << {:lesson_id =>record.item.position, :lesson_name =>record.item.content.name, :updated_at=>record.updated_at.to_s(:long)}
    end
    render :text => js.to_json
  end
  
  # def show_records
  #   
  #   lesson_studied = ItemGroup.find_by_id(params[:group_id]).lesson_studied(current_user.id,params[:package_id])
  #   lesson_ids = []
  #   lesson_studied.each do |l|
  #   lesson_ids << l.lesson_id
  #   end
  #   @records = current_user.study_records.find(:all,:select=>'lesson_id,lesson_name,max(updated_at) as updated_at',:conditions=>{:lesson_id => lesson_ids,:course_package_id => params[:package_id]},:order =>"updated_at desc",:group =>"lesson_id")
  #   js=[]
  #   @records.each do |record|
  #     js << {:lesson_id =>record.lesson_id,:lesson_name =>record.lesson_name.nil? ? " " : record.lesson_name,:updated_at=>record.updated_at.to_s(:long)}
  #   end
  #   render :text => js.to_json
  # end
end
