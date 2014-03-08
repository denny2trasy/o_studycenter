class QuestionResult < ActiveRecord::Base
  belongs_to  :test_result
  belongs_to  :user
  belongs_to  :question
  belongs_to  :answer
  
  scope :skill_results, lambda { |skill| where(:evaluation_activity_id => skill) }
  scope :answered, where("answer_id is not null")
  scope :corrected, where(:is_correct => true)  
  
  
end
