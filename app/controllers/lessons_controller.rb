class LessonsController < BaseController
  layout :set_layout_loged
  
  
  def show
     @item = Item.find(params[:id])
     @lesson = @item.content
     if @lesson.is_a?(Lesson) and current_user.has_lesson?(@item)
       @study_record = current_user.add_study_record(@item)    
     else
       redirect_to home_path
     end
    
  end


end
