class OenglishsController < ApplicationController
  
  def show
    #@scenario_id = params[:id] || "836"
    @item = Item.find(params[:id])
    @oenglish = @item.content
  
    if @oenglish.is_a?(Oenglish) and current_user.has_lesson?(@item)
      @study_record = current_user.add_study_record(@item)    
    else
      redirect_to home_path
    end
  end
  
  
end
