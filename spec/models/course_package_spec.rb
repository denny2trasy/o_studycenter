require 'spec_helper'

describe CoursePackage do
  before do
    @user = Factory(:user)
    @register_code = 'abc-dfj-37f-Jk4'
    @course_package = Factory(:course_package, :register_code => @register_code, :valid_for => 1)
    @course_package1 = Factory(:course_package, :eleutian_course => "91,92")
  end

  describe "#register_code_valid?" do
    it "when valid" do
      @course_package.register_code_valid?(@register_code).should be_true
    end

    it "invalid when code is wrong" do
      @course_package.register_code_valid?('invalid-code').should be_false
    end

    it "invalid when quota is full" do
      @user.add_course_package(@course_package)

      @course_package.register_code_valid?(@register_code).should be_false
    end
  end

  describe "#quota_full?" do
    it "less the quota" do
      @course_package.quota_full?.should be_false
    end

    it "equal the quota" do
      @user.add_course_package(@course_package)

      @course_package.quota_full?.should be_true
    end
  end
  
  describe "#is_speakeng_course" do
    it "need link to speakeng for session" do
      @course_package1.is_speakeng_course.should be_true
    end
    
    it "need not link to speakeng for session" do
      @course_package.is_speakeng_course.should be_false
    end
    
  end
end
