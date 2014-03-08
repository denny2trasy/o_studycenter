class ExaminationQuiz < ActiveRecord::Base
  belongs_to :examination
  belongs_to :quiz
  belongs_to :user
end
