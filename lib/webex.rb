
require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'cgi'

Net::HTTP.version_1_2

require "Webex/WebexToSDK"

module Webex
  API_URL = "https://eleutian.webex.com.cn/eleutian/"  
  API_USER = "denny"
  APE_PWD = "Idapt3d"
  MEETING_PWD = "elotian"
  
  def self.instance
    Webex::WebexToSDK.new(API_USER,APE_PWD,API_URL,MEETING_PWD)
  end
  
  
end

