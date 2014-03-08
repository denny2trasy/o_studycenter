class Quiz < ActiveRecord::Base
  has_many :examination_quizzes
  has_many :sub_quizzes
  
  def check_answer(json)
    status = true
    submits = ActiveSupport::JSON.decode(json)
    self.sub_quizzes.each do |sub_q|
      status = false unless SubQuizAnswer.find_by_id(submits["sub_quiz_"+sub_q.id.to_s]).is_correct
    end
    return status
  end
end
