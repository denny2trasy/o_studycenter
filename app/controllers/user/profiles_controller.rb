class User::ProfilesController < ApplicationController
  ignore_login :only => [:new,:validate_login,:validate_mail,:show]
  layout :set_layout

 
  def new
    @from_partner = auto_partner
    @user = User.new
  end
  
  def show
    if params[:id] == "zh"
      I18n.locale = "zh"
    elsif params[:id] == "tw"
      I18n.locale = "tw"
    elsif params[:id] == "ko"
      I18n.locale = "ko"
    elsif params[:id] == "pt"
      I18n.locale = "pt"
    elsif params[:id] == "es"
      I18n.locale = "es"
    else
      I18n.locale = "en"
    end
    @from_partner = auto_partner
    @user = User.new
    render 'new'
  end
  

  def edit
    @user = current_user
    @current_course_package = current_user.course_packages.first 
    I18n.locale = current_user.locale || 'zh'
  end
  
  def validate_login
    render :text => User.find_by_login(params[:login]).blank?.to_s
  end
  
  def validate_mail
    render :text => User.find_by_mail(params[:mail]).blank?.to_s
  end
end
