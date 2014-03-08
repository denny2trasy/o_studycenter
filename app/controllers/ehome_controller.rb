class EhomeController < BaseController
  layout "com"
  before_filter :teacher_logined?
  
  def teacher_logined?
      redirect_to teacher_broadcasts_path if current_user.user_type.downcase == "teacher"
  end
  
  def index
    @current_course_package = current_user.course_packages.first    
    @upcoming_sessions = current_user.upcoming_sessions(@current_course_package,5)
  end
  
end
