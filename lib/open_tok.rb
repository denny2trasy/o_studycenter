$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

=begin
 OpenTok Ruby Library
 http://www.tokbox.com/

 Copyright 2010, TokBox, Inc.

 Last modified: 2011-02-17
=end


require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'cgi'
#require 'pp' # just for debugging purposes

Net::HTTP.version_1_2 # to make sure version 1.2 is used

module OpenTok
  VERSION = "tbrb-v0.91.2011-02-17"
  # API_URL = "https://staging.tokbox.com/hl"
  #Uncomment this line when you launch your app
  API_URL = "https://api.opentok.com/hl";
  API_KEY = 375171
  API_SECRET = "a15c9636b2fff6b015baad6c7a6ac5c91f77b6c0"

  def self.instance
    OpenTok::OpenTokSDK.new API_KEY, API_SECRET
  end
end

require 'OpenTok/Exceptions'
require 'OpenTok/OpenTokSDK'
