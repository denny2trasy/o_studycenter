require 'spec_helper'

describe StudyRecordsController do
  before do
    @user = Factory(:user)
    @lesson = Factory(:lesson)
    @example_url = generate_example_url

    login_as @user
  end

  describe "POST create" do
    it "has no study record before" do
      lambda {
        post :create, :lesson_id => @lesson.id, :forward => @example_url
      }.should change{ @user.study_records.count }.by(1)
    end

    it "has study record already" do
      Factory(:study_record, :lesson => @lesson, :user => @user)
      lambda {
        post :create, :lesson_id => @lesson.id, :forward => @example_url
      }.should change{ @user.study_records.count }.by(0)
    end
    
    it "redirect to lesson_url" do
      post :create, :lesson_id => @lesson.id, :forward => @example_url

      response.should redirect_to(lesson_url(@lesson.id))
    end
  end
end
