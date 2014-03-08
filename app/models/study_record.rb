class StudyRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :lesson
  belongs_to :course_package
  belongs_to :item
  
 # delegate :name, :to => :lesson, :prefix => true
  delegate :name, :to => :course_package, :prefix => true
  
  def scenario
    Scenario.find_by_show_scenario_id(self.lesson_id)
  end
end
