class Admin::WebexUsersController < Admin::BaseController
  
  def index
    @schedule = params[:search].nil? ? Schedule.last : Schedule.find(params[:search][:id])
    @enroll_webexs = @schedule.enroll_webexs.order("created_at")
  end
end
