class Admin::QuestionsController < Admin::BaseController
  in_place_edit_for :question, :prompt
  
  def index
    @questions =  Question.page(params[:page]).per(20).combo_search(params)
  end
end
