require 'spec_helper'

describe Schedule do
  before do
    @schedule = Factory(:schedule)
  end

  describe ".next_schedule" do
    it "get 1th one" do
      s1 = Factory(:schedule, :course_time => Time.current + 1.days)
      s2 = Factory(:schedule, :course_time => Time.current + 2.days)

      Schedule.next_schedule.should == s1
    end

    it "get 2nd one" do
      s1 = Factory(:schedule, :course_time => Time.current - 1.days)
      s2 = Factory(:schedule, :course_time => Time.current + 2.days)

      Schedule.next_schedule.should == s2
    end
  end
end
