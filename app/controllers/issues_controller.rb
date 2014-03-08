class IssuesController < BaseController
  
  def new
    @issue = Issue.new
    render :layout => false    
  end
  
  def index
    @issues = Issue.page(params[:page]).per(20).combo_search(params)
    render :layout => "admin"
  end
  
  def create
    flash[:report] = current_user.issues.create(params[:issue]) ? "Success" : "Fail"
    redirect_to course_packages_path
  end
  
  def show
    @issue = Issue.find_by_id(params[:id])
    render :layout => "admin"
  end
  
end
