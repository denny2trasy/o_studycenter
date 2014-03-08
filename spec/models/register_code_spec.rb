require 'spec_helper'

describe RegisterCode do
  before  :all do
    @course_package = Factory(:course_package)
    @register_code_1 = Factory(:register_code,:course_package=>@course_package,:code => "ZASW-3EDR-4RYT-KI89")
    @register_code_2 = Factory(:register_code,:course_package=>@course_package,:code => "ZATG-3EDR-4RYT-KI89")
    @course_package_user = Factory(:course_package_user,:register_code => @register_code_2)
  end
  
  describe "register_code_valid?(code)" do
    it "should be false when register code not equal code" do
      @register_code_1.register_code_valid?("ZASW-3EDR-4RYT-KI98").should be_false
    end
    it "should be false when register code be used" do
      @register_code_2.register_code_valid?("ZATG-3EDR-4RYT-KI89").should be_false
    end
    it "should be true when register code be used" do
      @register_code_1.register_code_valid?("ZASW-3EDR-4RYT-KI89").should be_true
    end
  end
  

end