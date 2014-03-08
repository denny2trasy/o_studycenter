class Admin::NoticesController < Admin::BaseController
  in_place_edit_for :notice, :title
  in_place_edit_for :notice, :content
  in_place_edit_for :notice, :display
  
  def index
    @notices =  Notice.page(params[:page]).per(20).combo_search(params).order("updated_at DESC")
  end
  
  def new
    @notice = Notice.new
  end
  
  def create
    @notice = Notice.create(params[:notice])
    redirect_to :action => :index
  end
  
  def destroy
    @notice = Notice.find(params[:id])
    flash[:flag] = "successful" if @notice.destroy
    redirect_to :action => :index
  end
end
