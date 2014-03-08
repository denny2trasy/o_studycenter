require 'spec_helper'

describe "User::Signins" do
  before  :all do
    @current_user = Factory(:user)
  end

    it "reset password successful" do
      visit signin_path
      fill_in "login", :with => @current_user.login
      click_button "user_submit"
      current_path.should eq("/el_user/session_services")
      page.should have_content("sidebar")
    end
end
