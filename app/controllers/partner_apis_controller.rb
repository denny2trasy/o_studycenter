require "uri"
require "net/http"
class PartnerApisController < ApplicationController
  before_filter :authenticate
  ignore_login :all
  
  skip_before_filter :verify_authenticity_token
  
  def register

    flag = Net::HTTP.post_form(URI.parse(url_of(:el_user,:create_partner_sessions_path)), params)
    render :text => flag.body
  end
  
  def activate
    @register_code = RegisterCode.find_by_code(params[:RegisterCode])
    if @partner_profile = PartnerUser.find_by_partner_uid(params[:UserID])
        @user = @partner_profile.user
        
        if @register_code.blank?
          render :text => "register_code_not_exist"
        elsif !@register_code.register_code_valid?(params[:RegisterCode])
          render :text => "register_code_used"
        elsif (@register_code.valid_time.nil? ? Time.now.tomorrow : @register_code.valid_time) < Time.now or not @register_code.status
          render :text => "register_code_out_of_date"
        else
            @course_package = CoursePackage.find_by_id(@register_code.course_package_id)
          if t = CoursePackageUser.where(:user_id => @user.id, :course_package_id => @course_package.id).blank?
            @user.add_course_package(@course_package,{:register_code_id => @register_code.id,:register_code_code => params[:RegisterCode]})
            if Rails.env == 'production' and @course_package.is_speakeng_course and @user.can_active?
              @user.set_current_course_package(@course_package)
              SpeakengUtility.new.activate_course(@user,@course_package) 
            end
            if Rails.env == 'production' and @course_package.thinkingcap_course? and @user.can_active?
              @user.set_current_course_package(@course_package)
              ThinkingCap.instance.add_to_program(@user,@course_package) 
            end
            render :text => "success"
          else
            render :text => "lesson_has_been_actived"
          end
        end
        
    else
      render :text => "user_not_exist"
    end

  end
 
  
  def login
    redirect_to url_of(:el_user,:login_partner_sessions_path)+"?CoursePackageID=#{params[:CoursePackageID]}&UserID=#{params[:UserID]}&PartnerName=#{params[:PartnerName]}&Key=#{params[:Key]}&forward=#{params[:forward]}"
    
    #redirect_to url_of(:el_user,:login_partner_sessions_path,:CoursePackageID=>params[:CoursePackageID],:UserID=>params[:UserID],:PartnerName => params[:PartnerName],:Key => params[:Key])
  end
  
  protected
    def authenticate
      pwd = "eleuidap8n"
      str =  params[:UserID] + params[:PartnerName] + params[:CoursePackageID] + pwd
      Digest::MD5.hexdigest(str) == params[:Key] ? true : false
    end

end


