class Admin::QuizzesController < Admin::BaseController
  in_place_edit_for :quiz, :prompt
  in_place_edit_for :quiz, :position
  in_place_edit_for :quiz, :level
  in_place_edit_for :quiz, :q_type
  in_place_edit_for :quiz, :sounds
  in_place_edit_for :quiz, :images
  
  def index
    @quizzes = Quiz.page(params[:page]).per(20).combo_search(params).order("updated_at DESC")
  end
  
  def new
    @quiz = Quiz.new
    #@courses = [{:id => 1,:name=>"scenario"},{:id => 2,:name=>"ellis"},{:id => 3,:name=>"cambridge"}]
  end
  
  def create
    @quiz = Quiz.new(params[:quiz])
    if @quiz.save
      redirect_to new_admin_sub_quiz_path(:quiz_id =>@quiz.id)
    end
  end
  
end
