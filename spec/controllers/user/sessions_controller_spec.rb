require 'spec_helper'

describe User::SessionsController do

  describe "GET new" do
    it "render when not login" do
      get :new

      response.should be_success
    end

    it "redirect to course_packages page when logined" do
      login_as Factory(:user)

      get :new

      response.should redirect_to(home_url)
    end
  end
end
