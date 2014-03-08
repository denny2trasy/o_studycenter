class ScenariosController < BaseController
  layout :set_layout_loged
  
  
  def show
    #@scenario_id = params[:id] || "836"
    @item = Item.find(params[:id])
    @scenario = @item.content
    @scenario_id = @scenario.show_scenario_id
    #@scenario = Scenario.find_by_show_scenario_id(@scenario_id)
    #@course_package = params[:package_id].nil? ? current_user.current_course_package : CoursePackage.find(params[:package_id]) 
    
    if @scenario.is_a?(Scenario) and current_user.has_lesson?(@item)
      @study_record = current_user.add_study_record(@item)    
    else
      redirect_to home_path
    end
  end
end
