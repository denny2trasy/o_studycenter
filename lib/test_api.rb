require "uri"
require "net/http"
require 'digest/md5'

class TestApi
  REGIST_URL = "http://www.eleutian.asia/el_studycenter/partner_apis/register"
  ACTIVE_URL = "http://www.eleutian.asia/el_studycenter/partner_apis/activate"
  LOGIN_URL = "http://www.eleutian.asia/el_studycenter/partner_apis/login"
  PWD = "eleuidap8n"
  
  def register(userId,partnerName,coursePackageID,email)
    
    api_url = REGIST_URL

    key = Digest::MD5.hexdigest(userId + partnerName + coursePackageID + PWD)

    params = {"UserID" => userId, "PartnerName" => partnerName, "CoursePackageID" => coursePackageID, "Key" => key, "Email" => email}
    
    do_post(api_url,params)    
    
  end
  
  def login(userId,partnerName,coursePackageID,email)

    key = Digest::MD5.hexdigest(userId + partnerName + coursePackageID + PWD)

    params = {"UserID" => userId, "PartnerName" => partnerName, "CoursePackageID" => coursePackageID, "Key" => key, "Email" => email, "forward" => "http://www.eleutian.asia"}
    
    do_post(LOGIN_URL,params)
  end
  
  
  def activate(userId,partnerName,coursePackageID,email,registerCode)
    
    key = Digest::MD5.hexdigest(userId + partnerName + coursePackageID + PWD)

    params = {"UserID" => userId, "PartnerName" => partnerName, "CoursePackageID" => coursePackageID, "Key" => key, "Email" => email, "RegisterCode" => registerCode}
    
    do_post(ACTIVE_URL,params)
    
  end
  
  
  def do_post(api_url,params)
    url = URI.parse(api_url)
    if not params.empty?
      req = Net::HTTP::Post.new(url.path)
      req.set_form_data(params)
    else
      req = Net::HTTP::Get.new(url.path)
    end


    http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = true if @api_url.start_with?("https")
    
    puts "url = #{url}"
    puts "url.path = #{url.path}"
    puts "url.host = #{url.host}"
    puts "url.port = #{url.port}"
    puts "params = #{params}"
    
    puts "req = #{req}"
    
    res = http.start {|http| http.request(req)}
    # debugger
    case res
      
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      doc = res.read_body
      # doc = REXML::Document.new(res.read_body)
      puts res
      return doc
    else
      puts res.error!
    end
  end
  
end

#TestApi.new.register("001","17zuoye","2","001@17zuoye.com")
#TestApi.new.login("001","17zuoye","2","001@17zuoye.com")
#TestApi.new.activate("001","17zuoye","48","001@17zuoye.com","OVVD-7GG5-7AGA-AQLK")