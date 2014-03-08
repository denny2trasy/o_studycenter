require 'spec_helper'

describe PartnerApisController do

  describe "GET 'activate'" do
    it "should be successful" do
      get 'activate'
      response.should be_success
    end
  end

end
