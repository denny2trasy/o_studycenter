class BaseController < ApplicationController
    before_filter :login_required?
    before_filter :set_locale
    before_filter :set_time_zone
    
    #ignore_login :all
    
    
    def set_locale
      I18n.locale = current_user.locale || 'zh'
    end
    
    def set_layout_loged
      (name = current_user.layout_name) ? name : "application"
    end
    
    def set_time_zone
      Time.zone = current_user.time_zone
    end

    private
    def login_required?
      if current_user.blank?
        redirect_to signin_path()
      else
        return true
      end
    end
    
end
