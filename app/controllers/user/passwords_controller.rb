class User::PasswordsController < BaseController
  def edit
    @user = current_user
  end

end
