class Admin::ItemsController < Admin::BaseController
  
  before_filter :get_item_group
  
  def new
    @item = Item.new
  end
  
  def create
    unless @item_group.blank?
      unless (v = params[:content]).blank?
        v.keys.each do |id|
          @item_group.items.create(:content_id => id,:content_type=>params[:content_type])
        end
      end
      redirect_to admin_course_package_path(@item_group.course_package)
    end
  end

  def destroy
    flash[:notice] = Item.find_by_id(params[:id]).destroy ? "Success" : "Fail"
    redirect_to admin_course_package_path(@item_group.course_package)
  end
  
  private
  def get_item_group
    @item_group = ItemGroup.find_by_id(params[:group_id])
  end
  
end
