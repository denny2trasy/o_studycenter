require 'spec_helper'

describe "User::Passwords" do
  before(:each) do
    @user = Factory(:user)
    # controller.should_receive(:current_user).at_least(:once).and_return(@user)
  end
  
  it "should change password for current user when confirmation matches" do
    # controller.stub!(:current_user).and_return(@user)
    visit password_path
    debugger
    page.all("input")
    fill_in "original_password",  :with =>  @user.password
    fill_in "password", :with => "123456"
    fill_in "password_confirmation", :with => "12345"
    click_button "user_submit"
    page.should have_content("sss")
    fill_in "original_password", :with =>  @user.password
    fill_in "password", :with => "123456"
    fill_in "password_confirmation", :with => "123456"
    current_path.should eq("/el_user/password_services/0")
    page.should have_content("fff")
  end

end
