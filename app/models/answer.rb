class Answer < ActiveRecord::Base
  belongs_to  :question
  named_scope :correct, :conditions => "is_correct = 1"
end
