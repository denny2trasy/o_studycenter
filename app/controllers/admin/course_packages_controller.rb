class Admin::CoursePackagesController < Admin::BaseController
  before_filter :get_customer, :except => [:set_item_position]
  in_place_edit_for :item, :position
  in_place_edit_for :course_package, :name
  in_place_edit_for :course_package, :valid_for
  in_place_edit_for :course_package, :description
  in_place_edit_for :course_package, :eleutian_course
  in_place_edit_for :course_package, :thinkingcap_program
  in_place_edit_for :course_package, :course_type
  in_place_edit_for :register_code, :desc
  in_place_edit_for :course_package, :customer_id
  in_place_edit_for :scenario, :position
  in_place_edit_for :scenario, :name
  in_place_edit_for :scenario, :show_scenario_id
  in_place_edit_for :item_group, :position
  in_place_edit_for :item_group, :name
  in_place_edit_for :item_group, :course_type
  in_place_edit_for :item_group, :quiz_level
  in_place_edit_for :third_content, :position
  in_place_edit_for :third_content, :name
  in_place_edit_for :third_content, :show_content_id
  in_place_edit_for :third_content, :show_link
  in_place_edit_for :third_content, :thinkingcap_course
  

  def index
    @course_packages = CoursePackage.combo_search(params) || CoursePackage.all
  end
  
  def new
    @course_package = CoursePackage.new(:customer_id=>@customer.id, :course_type => "oenglish")
  end
  
  def create
    flash[:notice] =  CoursePackage.create(params[:course_package]) ? "Success" : "Fail"
    #flash[:notice] = (package = CoursePackage.create(params[:course_package])) ? "Success" : "Fail"
    #params[:course_package][:number_of_users].to_i.times do
    #  RegisterCode.create(:course_package_id=>package.id,:status=>true)
    #end
    redirect_to admin_course_packages_path(:q => {:customer_id => params[:course_package][:customer_id]})
  end
  
  def show
    @package = CoursePackage.find_by_id(params[:id])
    page = params[:page] || 1    
    @item = params[:item] || "item_groups"
    conditions = "course_package_id = #{@package.id}"
    if @item == "item_groups"
      @contents = ItemGroup.page(page).per(20).where(conditions)
    elsif @item == "register_codes"
      @contents = RegisterCode.page(page).per(100).where(conditions)
    else
      @contents = SessionCredit.page(page).per(20).where(conditions)
    end
  end
  
  def destroy
    flash[:notice] = CoursePackage.find_by_id(params[:id]).destroy ? "Success" : "Fail"
    redirect_to admin_course_packages_path(:q => {:customer_id => @customer.id})
  end
  
  def code
    @package_id = params[:package_id]
  end
  
  def code_create
    @register_codes = []
    params[:number_of_users].to_i.times do 
      @register_codes << RegisterCode.create(:course_package_id=>params[:package_id],:status=>true)
    end
    
    #redirect_to :action=>"index"
  end
  
  # duplicate this course package to other 
  def copy
    # debugger
    @course_package = CoursePackage.find_by_id(params[:id])
    flash[:notice] = CoursePackage.copy(@course_package) ? "Success" : "Fail"
    redirect_to admin_course_packages_path(:q => {:customer_id => @customer.id})
  end
  
  private
  def get_customer
    @customer = Customer.find_by_id(params[:customer_id])
  end
  
end
