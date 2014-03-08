require 'spec_helper'

describe MessagesController do
  before do
    @user = Factory(:user)
  end

  describe "GET index" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET create" do
    it "should be successful" do
      lambda {
        post :create, {:content => 'abc'}
      }.should change{ @user.messages.count }.by(1)
    end
  end

end
