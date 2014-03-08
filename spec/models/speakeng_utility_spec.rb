require 'spec_helper'

describe SpeakengUtility do
  before(:each) do
    @user = Factory(:user,:login=>"denny",:mail => "denny@eleutian.com",:mobile => "138475", :locale => "zh-CN",:display_name => "haha",:given_name => "san",:skype => "ded",:time_zone => "Beijing")
    @course = Factory(:course_package,:eleutian_course => "931")
  end

  describe "#activate_course(user,course)" do
    it "should return false" do
      SpeakengUtility.new().activate_course(@user,@course).should be_false
    end
  end

end