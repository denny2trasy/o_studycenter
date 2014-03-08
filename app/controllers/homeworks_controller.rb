class HomeworksController < ApplicationController
  layout "bootstrap"
  def index
    #params[:lesson_id]
    @current_course_package = current_user.current_course_package
    @item_groups = @current_course_package.item_groups.where("quiz_level is not null")
  end
  
  def list
    @examinations = current_user.examinations.where("item_group_id = ?",params[:group_id])
    if @examinations.blank?
      redirect_to generate_homeworks_path(:group_id=>params[:group_id])
    end
  end
  
  def show
    @examination = current_user.examinations.where("id = ?",params[:id]).first
    @examination_quizzes = @examination.examination_quizzes
    @total = @examination_quizzes.count
    id = (params[:NO] || "0").to_i
    if params[:commit] == "Next"
      @index = id < @total ? (id + 1) : id
    elsif params[:commit] == "Prev"
      @index = id > 1 ? (id - 1) : 1
    else
      @index = (id > 0 && id < @total) ? id : 1
    end
    
    @examination_quiz = @examination_quizzes.find_by_position(@index) || @examination_quizzes.first
    @quiz = @examination_quiz.quiz
    
    if params[:NO].to_i == @total
      redirect_to :action =>:result,:exam_id =>@examination.id
    end
  end
  
  def result
    @examination = current_user.examinations.where("id = ?",params[:exam_id]).first
    @examination_quizzes = @examination.examination_quizzes.order("position")
  end
  
  def generate
    @examination = Examination.create(:user_id => current_user.id,:lesson_id => params[:lesson_id],:item_group_id=>params[:group_id])
    @level = ItemGroup.find(params[:group_id]).quiz_level
    @examination_quizzes = @examination.generate_examination(1,2)
    #redirect_to :action => :index,:examination => @examination.id
    redirect_to homework_path(@examination.id)
  end
  
  def submit
    @examination_quiz = ExaminationQuiz.find(params[:exam_quiz])
    if params[:answer] == '' 
      redirect_to :action =>:show,:id=>@examination_quiz.examination_id,:NO =>params[:NO],:commit =>params[:commit]
    else
      #@is_correct = SubQuizAnswer.find(params[:answer_id]).is_correct
      @is_correct = @examination_quiz.quiz.check_answer(params[:answer])
      if @examination_quiz.update_attributes(:submit_answer =>params[:answer],:is_correct =>@is_correct)
        redirect_to :action =>:show,:id=>@examination_quiz.examination_id,:NO =>params[:NO],:commit =>params[:commit]
      else
        redirect_to :action =>:show,:id=>@examination_quiz.examination_id,:NO =>params[:NO]
      end
    end
  end
  
  def drag
    render :layout=>"bootstrap"
  end

end
