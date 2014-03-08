
require "ThinkingCap/sdk"

module ThinkingCap
  # API_URL = "http://eleutian.thinkingcap.com/webservice/campusregistration.asmx"
  API_URL = "http://thinkingcap.eleutian.asia/webservice/campusregistration.asmx"
  API_LOGIN = "admin@eleutian.asia"
  API_PASSWORD = "ETch1n@8"
  
  def self.instance
    ThinkingCap::SDK.new(API_URL,API_LOGIN,API_PASSWORD)
  end
  
end