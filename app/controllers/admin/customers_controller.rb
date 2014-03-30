class Admin::CustomersController < Admin::BaseController
  
  in_place_edit_for :customer,  :company_name
  in_place_edit_for :customer,  :short_name
  
  def index
    # @customers = Customer.combo_search(params)
    
    conditions = (params[:q].blank? or params[:q][:short_name].blank? ? "1=1" : ("short_name like '%#{params[:q][:short_name]}%'"))
    page = params[:page] || 1
    @customers = Customer.page(page).per(20).where(conditions).order("updated_at desc")    
    
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    
    flash[:notice] = Customer.create(params[:customer]) ? "Success" : "Fail"
    redirect_to admin_customers_path
  end
  
  def destroy
    flash[:notice] = Customer.find_by_id(params[:id]).destroy ? "Success" : "Fail"
    redirect_to admin_customers_path
  end
  
  private
  
  def valid_coment(ddd)
    (ddd.size>200)
  end
  
end
