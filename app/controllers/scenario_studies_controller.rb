class ScenarioStudiesController < BaseController
  # protect_action :index
  def index
    #@lesson = current_user.current_lesson(params[:type],params[:id])
    #@current_study_record = @lesson.current_study_record unless @lesson.nil?
    #@lesson = {:content_id => params[:id],:type => params[:type]}

    render :layout => current_user.layout_name(:controller => controller_name)
  end
end
