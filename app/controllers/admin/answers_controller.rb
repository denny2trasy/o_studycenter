class Admin::AnswersController < Admin::BaseController
  before_filter :get_question
  
  def index
    @answers = @question.answers
  end
  
  private
  def get_question
    @question = Question.find_by_id(params[:question_id])
  end
end
