require 'spec_helper'

describe HomeController do
  before do
    @user = Factory(:user)

    @course_package = Factory(:course_package)

    login_as @user
  end

  describe "GET index" do
    it "display activation form when user have no course" do
      get :index

      response.should have_selector("form")
    end

    it "display course list when use have course" do
      @user.add_course_package(@course_package)

      get :index

      response.should_not have_selector("form")
    end
  end
end
