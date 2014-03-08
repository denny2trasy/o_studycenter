require 'spec_helper'

describe User::ProfilesController do

  describe "GET new" do
    it "render" do
      get :new

      response.should be_success
    end
  end

  describe "GET edit" do
    it "render" do
      login_as Factory(:user)
      get :edit

      response.should be_success
    end
  end
end
