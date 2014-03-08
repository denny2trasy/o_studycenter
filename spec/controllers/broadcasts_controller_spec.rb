require 'spec_helper'

describe BroadcastsController do
  before do
    @session_id = "1ecc006801647748009a1481f8fc4129788fdfa1"
    @schedule = Factory(:schedule)
  end

  describe "GET index" do
    it "render no_schedule when have no schedules" do
      Schedule.destroy_all

      get :index

      response.should render_template('no_schedule')
    end

    it "render index when normal case" do
      get :index

      response.should be_success
    end
  end

end
