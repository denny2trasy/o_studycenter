require 'net/http'
require 'uri'
require 'digest/md5' 
class SpeakengUtility
  def initialize(args=nil)
    @course_url = "http://www.eleutian.com/Portal/Partner/NewUserAndPurchase"
    @sso_url = "http://speakeng.eleutian.com/SingleSignOn/SignOn"
    # beta url just test
    # http://www.beta.eleutian.com/Portal/Partner/NewUserAndPurchase
    # http://www.beta.eleutian.com/SingleSignOn/SignOn
  end
  
  def sso_login(user)    
    return "#{@sso_url}?userToken=#{user_token(user)}&authorityToken=#{authority_token}"
  end
    
  
  def user_token(user)
    return user.login
  end
  
  def authority_token
    return "Ldv9QVyKRkmXOuRJbpJ4Hw"
  end
  
  def request_token
    return "Q3xzaACkC0eRDK7CEN0AvA"
  end
  
  def response_token
    return "n3lkDBkScEquslCoeLsXLg"
  end
  
  def partner_id
    return "Ldv9QVyKRkmXOuRJbpJ4Hw"
  end
  
  def api_key
    # return "22rj39MtK0O7Z502ulc2TQ"
    return "dIRN8FbT8kuC_1X4PbBHPw"
  end
  
  def package_id(course)
    return course.eleutian_course || "1605"
  end
  
  # user.id + course.id
  def purchase_number(user,course)
    return "#{user.id}#{course.id}"
  end
  
  def activate_course(user,course)
    url = URI.parse(@course_url)
    req = Net::HTTP::Post.new(url.path)
    params = params_for_course(user,course)
    req.set_form_data(params)
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      puts "OK"
      return true
    else
      puts res.error!
      return false
    end
  end
  
  def params_for_course(user,course)
    params = {}
    params["username"] = user.login
    params["email"] = user.mail 
    params["packageId"] = package_id(course)
    params["signature"] = create_signature(user,course) 
    params["phone"] = user.mobile
    params["locale"] = "zh-CN"
    params["nickname"] = user.display_name
    params["nativename"] = user.given_name
    params["skypename"] = user.skype
    params["timeZone"] = "China Standard Time"
    params["purchaseNumber"] = purchase_number(user,course)
    params["partnerId"] = partner_id 
    params
  end
  
  def create_signature(user,course)
    source = []
    source << user.login
    source << user.mail
    source << package_id(course)
    source << purchase_number(user,course)
    source << api_key
    return Digest::MD5.hexdigest(source.join) 
  end

  
end