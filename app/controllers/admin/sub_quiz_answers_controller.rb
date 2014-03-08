class Admin::SubQuizAnswersController < Admin::BaseController
  
  def new
    @sub_quiz_answer = SubQuizAnswer.new
    @sub_quiz_id = params[:sub_quiz_id]
  end
  
  def create
    @sub_quiz_answer = SubQuizAnswer.new(params[:sub_quiz_answer])
    flash[:notice] = "success" if @sub_quiz_answer.save
  end
end
