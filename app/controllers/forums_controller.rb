class ForumsController < BaseController
  layout :set_layout_loged
  
  def index
    
  end
  
  def show
    @key = params[:key]
  end
end
