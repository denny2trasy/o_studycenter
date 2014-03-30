class Admin::RegisterCodesController < Admin::BaseController
    ignore_login :only => %w{active}
    
  def new
    @package_id = params[:course_package_id]
  end
  
  def create
    message = RegisterCode.batch_create(params)
    flash[:notice] = message
    redirect_to admin_course_package_path(:id => params[:package_id],:item => "register_codes")
    
    # @register_codes = []
    # begin
    #   h_params = {}
    #   h_params[:course_package_id] = params[:package_id]
    #   h_params[:valid_time] = params[:register_code]['valid_time(1i)']+'-'+params[:register_code]['valid_time(2i)']+'-'+params[:register_code]['valid_time(3i)']
    #   h_params[:status] = true 
    #   h_params[:desc] = params[:desc]
    #   params[:number_of_users].to_i.times do 
    #     @register_codes << RegisterCode.create(h_params)
    #   end
    #   message = "Success"
    # rescue
    #   message = "Fail"
    # end
    # flash[:notice] = message
    # redirect_to course_package_path(:id => params[:package_id],:item => "register_codes")
  end
  
  def destroy
    flash[:notice] = RegisterCode.find_by_id(params[:id]).destroy ? "Success" : "Fail"
    redirect_to admin_course_package_path(:id => params[:course_package_id],:item => "register_codes")
  end
  
  def show
    @package = CoursePackage.find_by_id(params[:id])
    
    @filename = "register_code_#{@package.name}.csv"    
    headers["Content-Type"] = 'text/csv'
    headers["Content-Disposition"] = "attachment; filename=\"#{@filename}\"" 
    
    out = ["Code","Valid Time","Desc","Created At"].join(',') + "\n"
    @package.register_codes.each do |code|
      row = []
      row << code.code
      row << code.valid_time.try(:to_s,:long)
      row << code.desc
      row << code.created_at.try(:to_s,:long)
      out << row.join(',') + "\n"
    end

    render :text=>out    
    
  end
  
  def active
    @register_code = RegisterCode.find_by_code(params[:code])
    if @register_code.update_attributes(:user_id => params[:user_id],:status => false)
      render :text =>true
    else
      render :text =>false
    end
  end
end
