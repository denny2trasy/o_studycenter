class ApplicationController < ActionController::Base
  protect_from_forgery
    ignore_login :all
    #   
    # 
    # def current_user
    #    return User.find_by_login("denny")
    # end
  def set_layout
    if request.domain == 'es123.com' || request.domain(2) == "es123.eleutian.asia"
      'salon'
    elsif request.domain == 'tyjdb.com'
      'jidebao'
    elsif request.domain == 'Acgemonline.com'
      'acgem'
    elsif request.domain == 'eleutian.com'
      (current_user.blank? ? 'comregister' : "com")
    elsif request.domain == 'kooke.org' || request.domain(2) == "kooke.eleutian.asia"
      'cambridge'
    else
      if current_user
        if current_user.user_type.downcase == "teacher"
          "teacher"
        else  
          'application'
        end
      else
        'application'
      end
    end
  end
  
  def auto_partner
    if request.domain == 'es123.com' || request.domain(2) == "es123.eleutian.asia"
      "english_salon"
    elsif request.domain == "tyjdb.com"
      "jidebao"
    elsif request.domain == "acgemonline.com"
      "acgem"
    elsif request.domain == "eleutian.com"
      "eleutian_com"
    elsif request.domain == "kouyu.org" || request.domain(2) == "kouyu.eleutian.asia"
      "new_channel"
    elsif request.domain == 'kooke.org' || request.domain(2) == "kooke.eleutian.asia"
      'cambridge'
    else
      ''
    end
  end
  
  def infobox(info, css_class)
    unless info.blank?
      return %Q{<div id='notice' class='#{css_class}'><span style='float:right'><a href='#' onclick='$(\\"#notice\\").hide();'>x</a></span>#{info}</div>}
    end
  end
   # Shows notice informatin. Default value if flash[:notice]
  def notice(info = flash[:notice])
    infobox(info, "noticebox")
  end

end
