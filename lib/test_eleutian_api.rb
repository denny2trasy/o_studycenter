require "uri"
require "net/http"
require 'digest/md5'

class TestEleutianApi
  def initialize
    # @url = "https://beta-api.eleutian.com/v1/students/kingsoft/test_denny"
    # @user = "13"
    # @password = "7ac35bd8ddbd402aae1b55f9389c61cd"
    @url = "https://api.eleutian.com/v1/students/kingsoft/test_denny"
    @user = "35"
    @password = "162ec215ce2c445d8f2cb81664d0b675"
    @customer = "kingsoft"
  end
  
  def create_and_update_student(fname,lname,pname,email)
    
    
    url = URI.parse(@url)
    puts url
    puts "Path = #{url.path}"
    puts "Host = #{url.host}"
    puts "Port = #{url.port}"
    content = {'FirstName' => (fname || "first_anme"), 'LastName' => (lname ||"last_name"),'PublicName' => (pname || "public_name"),'Email' => (email || "email@abc.com") , 'Locale' => "zh-Hans","TimeZone" => "China Standard Time"}
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @user, @password
    req.set_form_data(content)
      
    sock = Net::HTTP.new(url.host,url.port)
    sock.use_ssl = true
    res = sock.start{|http| http.request(req)}
    puts res
    # puts res.document
    puts "JSON := " + res.body
      
    # resp = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    # puts resp
    
    
    # http = Net::HTTP.new(url.host,url.port)
    # http.use_ssl = true if url.scheme == "https"
    # # http.verify_mode = OpenSSL::SSL::VERIFY_NONE    
    # 
    # data = {"login" => @user,"password" => @password}.merge(content).to_s
    # 
    # http.start {
    #   http.request_post(url.path,data) { |res|
    #     puts res
    #   }
    # }
    
    
    
    
    
  end
  
  
  def delete_enroll
    
    url = URI.parse("https://beta-api.eleutian.com/v1/enrollments/1530")
    
    req = Net::HTTP::Delete.new(url.path)
    req.basic_auth @user, @password
    # req.set_form_data(content)
      
    sock = Net::HTTP.new(url.host,url.port)
    sock.use_ssl = true
    res = sock.start{|http| http.request(req)}
    puts res
    # puts res.document
    puts "JSON := " + res.body
    
    
  end
  
  
  def enroll_session

    url = URI.parse("https://beta-api.eleutian.com/v1/students/kingsoft/haowjuser8/enrollments")

    content = {'SessionId' => 82571}
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth @user, @password
    req.set_form_data(content)
      
    sock = Net::HTTP.new(url.host,url.port)
    sock.use_ssl = true
    res = sock.start{|http| http.request(req)}
    puts res
    # puts res.document
    puts "JSON := " + res.body
    
  end
  
  
end

# puts "Create New Api"
t = TestEleutianApi.new
puts "call api"
t.create_and_update_student("dnny1","li1","ok_name1","test1@eleutian.com")
puts "result ----"

# t.delete_enroll 

# t.enroll_session