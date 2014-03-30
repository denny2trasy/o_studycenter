class Admin::OenglishsController < Admin::BaseController
  
  in_place_edit_for :oenglish,  :name
  in_place_edit_for :oenglish,  :show_oenglish_id
  in_place_edit_for :oenglish,  :video_url
  
  def index
    @oenglishs = Oenglish.combo_search(params.merge({:order=>"created_at desc"})) || Scenario.all
  end
  
  def new
    @oenglish = Oenglish.new
  end
  
  def create
    flash[:notice] = Oenglish.create(params[:oenglish]) ? "Success" : "Fail"
    redirect_to admin_oenglishs_path
  end
  
  def destroy
    flash[:notice] = Oenglish.find_by_id(params[:id]).destroy ? "Success" : "Fail"
    redirect_to admin_oenglishs_path
  end
  
  def show
    @item_group = ItemGroup.find_by_id(params[:id])
    @oenglishs = Oenglish.all
  end
  
end
