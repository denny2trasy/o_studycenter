class SubQuiz < ActiveRecord::Base
  belongs_to :quiz
  has_many :sub_quiz_answers
end
