class User::SessionsController < ApplicationController
  before_filter :logined?,  :except => [:sso]
  skip_before_filter :verify_authenticity_token, :only => [:sso_back]
  ignore_login :all
  layout :set_layout
  
  def logined?
    if current_user
      redirect_to (request.domain == "eleutian.com" ? ehome_index_path : home_path)
    end
  end

  def new
    @user = User.new
    @from_partner = auto_partner    
    if request.domain == "es123.com" || request.domain(2) == "es123.eleutian.asia"
      @locale = "zh"
      I18n.locale = "zh"
      render 'english_salon'
    elsif request.domain == "eleutian.com"
      @locale = "en"
      I18n.locale = "en"
      render 'el_com' 
    elsif request.domain == "kooke.org" || request.domain(2) == "kooke.eleutian.asia"
      @locale = "zh"
      I18n.locale = "zh"
      render 'cambridge_login' 
    else
      @locale = "zh"
      I18n.locale = "zh"
      render 'el_login_v2' 
    end
  end
  
  def show
    @user = User.new
    @locale = params[:id] || "zh"
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
      I18n.locale = "zh"
    end
    if request.domain == "es123.com" || request.domain(2) == "es123.eleutian.asia"
      @locale = "zh"
      render 'english_salon'
    elsif request.domain == "tyjdb.com"
      @locale = "zh"
      render 'jdb_login'
    elsif request.domain == "eleutian.com"
      @locale = "en"
      render 'el_com'
    elsif request.domain == "kooke.org" || request.domain(2) == "es123.eleutian.asia"
      @locale = "zh"
      render 'cambridge_login' 
    else
      @locale = "zh"
      render 'el_login_v2' 
    end
    
  end
  
  def sso    
    url = SpeakengUtility.new.sso_login(current_user) 
    redirect_to url
  end
  
  # back from eleutian
  # http://www.veecue.com/el_studycenter/sso_back?userToken=denny&requestToken=Q3xzaACkC0eRDK7CEN0AvA
  
  def sso_back
    s = SpeakengUtility.new
    user = params[:userToken]
    if params[:requestToken] == s.request_token
      render :text => "username=#{user}&responseToken=#{s.response_token}"
    else
      render :text => "error!"
    end

  end
  
end
