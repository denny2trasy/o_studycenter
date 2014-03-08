class ContentsController < ApplicationController
  
  def get_items
    if params[:content_type] == "Lesson"
      @items = Lesson.all
    elsif params[:content_type] == "Scenario"
      @items = Scenario.all
    elsif params[:content_type] == "Chinacache"
      @items = Chinacache.all
    elsif params[:content_type] == "Thinkingcap"
      @items = Thinkingcap.all
    else
      @items = []
    end
    js = []
    @items.each do |item|
      js << { :id => item.id,:name => item.name}
    end
    render :json => js
  end
   
end
