require 'spec_helper'

describe User::PasswordsController do

  describe "GET edit" do
    it "should be successful" do
      login_as Factory(:user)

      get 'edit'

      response.should be_success
    end
  end

end
