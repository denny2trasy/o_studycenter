require 'spec_helper'

describe LessonsController do
  before do
    @lesson = Factory(:lesson)
  end

  describe "GET show" do
    it "should be successful" do
      get 'show', :id => @lesson.id
      response.should be_success
    end
  end

end
