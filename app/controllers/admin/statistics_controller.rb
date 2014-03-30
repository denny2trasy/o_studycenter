class Admin::StatisticsController < Admin::BaseController
  
  def index
    
    # @results = CoursePackageUser.page(params[:page]).per(10).select("customer_id,course_package_id,count(*) as c").where("customer_id is not null").group("customer_id").order("customer_id desc")
    @results = CoursePackageUser.select("customer_id,course_package_id,count(*) as c").where("customer_id is not null").group("customer_id").order("customer_id desc")
    
    @stats = CoursePackageUser.stat_result(params[:stat]) if not params[:stat].blank?
    
  end
  
  def show
    puts "*".center(80)
    cp_id = params[:id]
    @cp = CoursePackage.find_by_id(cp_id)
    @result = CoursePackageUser.activate_users_each_day_of(cp_id)
  end
  
end
