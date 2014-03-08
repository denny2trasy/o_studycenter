require 'spec_helper'

describe CoursePackagesController do
  before do
    @user = Factory(:user)
    @register_code = "abc-def-jdy-498"
    @course_package = Factory(:course_package, :register_code => @register_code, :valid_for => 1)
    @user_course_package = Factory(:course_package)
    @user.add_course_package(@user_course_package)

    login_as @user
  end

  describe "GET index" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET show" do
    it "render" do
      get :show, :id => @user_course_package.id

      response.should be_success
    end
  end

  describe "POST activate" do
    it "success" do
      lambda {
        post :activate, :code => @register_code
      }.should change{ @user.course_packages.count }.by(1)

      response.should redirect_to(course_packages_url)
    end

    it "failure because incorrect code" do
      lambda {
        post :activate, :code => "incorrect-code"
      }.should change{ @user.course_packages.count }.by(0)

      response.should render_template('new')
    end

    it "failure because the course package has full quota" do
      @user.add_course_package(@course_package)
      lambda {
        post :activate, :code => @register_code
      }.should change{ @user.course_packages.count }.by(0)
    end
  end

  describe "PUT update" do
    it "redirect to course_packages_url" do
      put :current, :id => @user_course_package.id

      response.should redirect_to(course_packages_url)
    end
  end

end
