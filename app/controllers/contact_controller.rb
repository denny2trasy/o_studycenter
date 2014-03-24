class ContactController < ApplicationController
  ignore_login :only => [:index,:salon,:jidebao,:acgem,:requirements,:about_us,:introductions]
  layout :set_layout
  
  

  def index
  end
  
  def salon
  end
  
  def jidebao
  end
  
  def acgem
  end
  
  def requirements
    I18n.locale = current_user.try(:locale) || 'zh'
  end
  
  def about_us
    render :layout=>false
  end 
  
  def introductions
    #render :layout=>false
  end
end
