# encoding:utf-8
class Admin::UsersController < Admin::BaseController
  include ApplicationHelper

  in_place_edit_for :course_package_user, :expired_at

  def index
    # conditions = format_params_to_conditions(params)
    # @course_package_users = CoursePackageUser.page(params[:page]).per(10).where(conditions).order("created_at DESC").includes([:user, :customer, :course_package])
    register_user_ids = CoursePackageUser.all(:select=>"distinct user_id").map(&:user_id)
    # cond1 = register_user_ids.blank? ? "1=1" : "id in (#{register_user_ids.join(',')})"
    conditions = (params[:search].blank? or params[:search][:login].blank? ? "1=1" : ("login like '%#{params[:search][:login]}%'"))
    @users = User.page(params[:page]).per(10).search(:id_in=>register_user_ids).where(conditions).order("updated_at desc")
  end

  def show
    @user = User.find(params[:id])
  end
end