require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end

  describe "CoursePackage" do
    before do
      @course_package = Factory(:course_package)
    end

    describe "#add_course_package" do
      it "success added" do
        lambda {
          @user.add_course_package(@course_package)
        }.should change{ @user.course_packages.count }.by(1)
      end
    end

    describe "#course_packages" do
      it "successfully return non-empty array" do
        @user.add_course_package(@course_package)
        @user.course_packages.should == [@course_package]
      end

      it "when return empty array" do
        @user.course_packages.should == []
      end
    end

    describe "#course_package" do
      before do
        @course_package = Factory(:course_package)
        @user.add_course_package(@course_package)
      end

      it "successfully return" do
        @user.course_package(@course_package.id).should == @course_package
      end

      it "return nil when course_package isnot belongs the user" do
        @user.course_package(Factory(:course_package)).should be_nil
      end
    end

    describe "#current_course_package" do
      it "be nil if user have no courses" do
        @user.current_course_package.should be_nil
      end

      it "user only have one course" do
        @user.add_course_package(@course_package)

        @user.current_course_package.should == @course_package
      end

      it "return the current course" do
        @user.add_course_package(@course_package, :current => true)
        @user.add_course_package(Factory(:course_package))

        @user.current_course_package.should == @course_package
      end
    end

    describe "#current_course_package?" do
      it "true" do
        @user.add_course_package(@course_package, :current => true)

        @user.current_course_package?(@course_package).should be_true
      end

      it "false" do
        @user.add_course_package(@course_package)
        @user.add_course_package(Factory(:course_package))

        @user.current_course_package?(@course_package).should be_false
      end
    end

    describe "#set_current_course_package" do
      it "successfully" do
        @user.add_course_package(@course_package)
        @user.set_current_course_package(@course_package)
        @user.current_course_package.should == @course_package

        course_package = Factory(:course_package)
        @user.add_course_package(course_package)
        @user.set_current_course_package(course_package)
        @user.current_course_package.should == course_package
      end
    end
  end

  describe "#studied_lesson" do
    before do
      @lesson = Factory(:lesson)
    end

    it "return true" do
      @user.study_records.create(:lesson => @lesson)
      @user.studied_lesson?(@lesson).should be_true
    end

    it "return false" do
      @user.studied_lesson?(@lesson).should be_false
    end
  end
  
  describe "#add_study_record(lesson)" do
    before  do
      @lesson = Factory(:lesson)
    end
    
    it "should create new study record" do
      count = @user.study_records.count
      @user.add_study_record(@lesson)
      @user.study_records.count.should == (count + 1)
    end
  end
end
