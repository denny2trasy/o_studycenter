class ReplacesController < BaseController
  layout :set_layout_loged
  skip_before_filter  :login_required?, :only => :sencha
  skip_before_filter  :set_locale, :only => :sencha
  skip_before_filter  :set_time_zone, :only => :sencha
  
  def index
    @test_results = current_user.test_results.valid_result
    render :layout => false
  end
  
  def show
    
    @id = params[:id]
    @skill = params[:skill] || "214"
    if @id == "0"
      test_result = current_user.test_results.create
      @id = test_result.id
      @skill = "214"
    end 

    @q_results = current_user.get_question_results(@id,@skill)
    
    
    # choose 20 question
    # @questions = Question.random_test(@skill)
  end
  
  def create
    
    @id = params[:id]
    @skill = params[:skill]

    current_user.update_question_skill_result(@id,@skill,params)
    
    if @skill.to_i < 216
      redirect_to replace_path(@id,:skill=> (@skill.to_i + 1)) 
    else
      current_user.update_test_result(@id)
      redirect_to edit_replace_path(@id)
    end 
      
    
    # current_user.create_test_result(params)
    # redirect_to course_packages_path
  end
  
  def edit
    @test_result = TestResult.find_by_id(params[:id])
  end
  
  def sencha
    # @questions = Question.all(:limit => 10) #Question.all(:limit=>10)
    # 
    # @result = []
    # @questions.each do |question|
    #   @result << { :prompt => question.prompt, :instruction => question.instruction }
    # end
    # 
    # headers["Content-Type"] = 'text/javascript; charset=utf8'
    
    # headers["Content-Type"] = 'application/x-json'
      
    # render :json => {:questions => @result}, :callback => params[:callback] #{:questions => @questions}
    
    @questions = Question.all(:limit => 10)
    
    @index = params[:no] || 1 
    
    @total = @questions.size
    
    @question = @questions[@index]
    
    
    render :layout => false
    
  end
  
  def take
    @questions = Question.all(:limit => 10)
    
    @current = (params[:no] || 1).to_i 
    
    @index = (params[:commit] == "Next" ? @current + 1 : @current - 1)
    
    @total = @questions.size
    
    @question = @questions[@index]
    
    render "sencha", :layout => false
  end
  
end
