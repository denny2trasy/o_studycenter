class RedirectsController < BaseController
  def index
      @user_type = current_user.user_type.downcase
      if @user_type == "teacher"
        redirect_to teacher_broadcasts_path
      else
        redirect_to home_path
    end
  end
end
