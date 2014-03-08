class Admin::SubQuizzesController < Admin::BaseController
  
  def new
    @sub_quiz = SubQuiz.new
    @quiz_id = params[:quiz_id]
  end
  
  def create
    @sub_quiz = SubQuiz.new(params[:sub_quiz])
    if @sub_quiz.save
       flash[:notice] = "success"
       redirect_to new_admin_sub_quiz_answer_path(:sub_quiz_id =>@sub_quiz.id)
       
    end
  end
end
