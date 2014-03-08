require 'openssl'
require 'base64'
require 'uri'
require 'net/https'

module Webex

  class WebexToSDK
    attr_writer :api_url
    
    def initialize(user,pwd,url,m_pwd)
      @api_url = url
      @api_user = user
      @api_pwd = pwd
      @meeting_pwd = m_pwd
    end
    
    
    def join_meeting(back_url,meeting_key,email,f_name,l_name,join_pw)
      params = {}
      params["AT"] = "JE"
      params["BU"] = back_url
      params["MK"] = meeting_key 
      params["AE"] = email
      params["FN"] = f_name
      params["LN"] = l_name
      params["JPW"] = join_pw
      
      join_url = @api_url + "m.php?" + params.to_param
      
      return join_url
      
      # join_url = @api_url + "m.php"
      # 
      # do_request(join_url,params)
      
    end
    
    def login(back_url)
      params = {}
      params["AT"] = "LI"
      params["WID"] = @api_user
      params["PW"] = @api_pwd
      # params["MU"] = ""
      params["MU"] = back_url     
      
      login_url = @api_url + "p.php?" + params.to_param
      
      return login_url
      
      #do_request(login_url,params)      
      
    end
    
    def set_meeting_type
      params = {}
      params["AT"] = "ST"
      params["SP"] = "EC"
      set_type_url = @api_url + "o.php?" + params.to_param
      return set_type_url
    end
    
    def schedule_meeting(params)
      #params = {}
      params["AT"] = "SE"
      #params["EN"] = en
      #params["BU"] = bu
      #params["YE"] = ye
      #params["MO"] = mo  # month
      #params["DA"] = da  # day
      #params["HO"] = hour  # hour
      #params["MI"] = mi # minute      
      #params["JPW"] = jpw
      #params["DU"] = du  # duration minute
      params["ENRE"] = "1"  # enrollment is required
      params["PW"] = "eleuid"
      params["TZ"] = "45" # beijing time
      params["MT"] = "9"
      params["WIRE"] = "1" #registration is required for the event or not
      params["VP"] = "1" #Whether the event uses an Internet Phone.
      
            
      schedule_url = @api_url + "m.php?" + params.to_param
      return schedule_url
      
      #do_request(schedule_url,params)
      
    end
    
    def enroll_url(email,f_name,l_name,meeting_key,pwd,back_url)
      params = {}
      params["AT"] = "EN"
      params["AE"] = email
      params["FN"] = f_name
      params["LN"] = l_name
      params["MK"] = meeting_key
      params["PW"] = pwd
      params["BU"] = back_url
      start_url = @api_url + "m.php?" + params.to_param
    end
    
    def join_enroll_meeting(back_url,meeting_key,enroll_id,join_pw)
      params = {}
      params["AT"] = "JE"
      params["BU"] = back_url
      params["MK"] = meeting_key 
      params["EI"] = enroll_id
      params["JPW"] = join_pw
      
      join_url = @api_url + "m.php?" + params.to_param
      return join_url
    end
    
    def start_meeting(meeting_key,back_url)
      params ={}
      params["AT"] = 'TE'
      params["MK"] = meeting_key
      params["BU"] = back_url
      start_url = @api_url + "m.php?" + params.to_param
    end
    
    
    protected
    
    def do_request(api_url,params)
        url = URI.parse(api_url)
        if not params.empty?
          req = Net::HTTP::Post.new(url.path)
          req.set_form_data(params)
        else
          req = Net::HTTP::Get.new(url.path)
        end


        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if @api_url.start_with?("https")
        res = http.start {|http| http.request(req)}
        debugger
        case res
          
        when Net::HTTPSuccess, Net::HTTPRedirection
          # OK
          doc = res.read_body
          # doc = REXML::Document.new(res.read_body)
          puts res
          return doc
        else
          res.error!
        end

    end
    
  end


end