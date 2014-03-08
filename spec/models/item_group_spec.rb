require 'spec_helper'

describe ItemGroup do

  describe "#lessons" do
    it "successfully return" do
      @item_group = Factory(:item_group)
      @lesson = Factory(:lesson)
      @item = Factory(:item, :lesson => @lesson, :item_group => @item_group)

      @item_group.lessons.should == [@lesson]
    end
  end
end
