require "uri"
require "net/http"
class CoursePackagesController < BaseController
  layout :set_layout_loged
  
  def set_layout_loged
    (name = current_user.layout_name) ? name : "application"
  end
  
  def index
    @course_packages = current_user.course_packages
  end

  def show
    @course_package = current_user.course_package(params[:id])
    @item_group = @course_package.item_groups.find_by_id(params[:item_group_id])
  end

  def activate
    @register_code = RegisterCode.find_by_code(params[:code])

    if @register_code.blank?
      flash[:error] = t(:register_code_is_not_exist)
    elsif !@register_code.register_code_valid?(params[:code])
        flash[:error] = t(:register_code_used)
    elsif (@register_code.valid_time.nil? ? Time.now.tomorrow : @register_code.valid_time) < Time.now or not @register_code.status
        flash[:error] = t(:register_code_out_of_date)
    elsif set_code_used(@register_code)
        @course_package = CoursePackage.find_by_id(@register_code.course_package_id)
        this_package = CoursePackageUser.where(:user_id => current_user.id, :course_package_id => @course_package.id)
      if this_package.blank?
        current_user.add_course_package(@course_package,{:register_code_id => @register_code.id,:register_code_code => params[:code]})
        if Rails.env == 'production' and @course_package.is_speakeng_course and current_user.can_active?
          current_user.set_current_course_package(@course_package)
          SpeakengUtility.new.activate_course(current_user,@course_package) 
        end
        if Rails.env == 'production' and @course_package.thinkingcap_course? and current_user.can_active?
          current_user.set_current_course_package(@course_package)
          ThinkingCap.instance.add_to_program(current_user,@course_package) 
        end
      else
        this_package.first.extend_time
      end
      flash[:notice] = t(:successful)
    else
      flash[:notice] = t(:try_again)
    end
    path = ((not params[:flag].blank?) and params[:flag] == "com") ? ehome_index_path : home_path
    redirect_to path
  end

  def current
    @course_package = current_user.course_package(params[:id])
    current_user.set_current_course_package(@course_package)

    redirect_to home_url
  end
  
  def set_code_used(register_code)
    para = {:code => register_code.code,:user_id => current_user.id}
    #flag = Net::HTTP.post_form(URI.parse("http://localhost:3001/register_codes/active"), para)
    flag = Net::HTTP.post_form(URI.parse(url_of(:el_course,:active_register_code_path)), para)
    if flag.body == "true"
      return true
    else
      return false
    end
  end

end
