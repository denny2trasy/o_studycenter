class TestResult < ActiveRecord::Base
  belongs_to :user
  has_many  :question_results
  has_many  :skill_results
  
  scope :valid_result,  :conditions => "level is not null"
  
  
  def update_result
    
    skill_levels = self.skill_results.map(&:level)
    
    if skill_levels.size > 0
    
      level = skill_levels.sum/skill_levels.size
      score = calculate_course_score_by_level(level)
    
      self.update_attributes(:score => score, :level => level)
    end
    
  end
  
  def calculate_course_score_by_level(level)
    score = case level
    when 10..12
      301
    when 8..9
      201
    when 6..7
      102
    when 3..5
      101
    when 0..2
      99
    else
      302
    end
  end
  
  
  def update_skill_result(skill)
    
    ability = determine_ability_logit(skill)
    
    score = calculate_score_by_ability(ability)
    level = calculate_level_by_ability(ability)
    
    
    skill_result = self.skill_results.find_or_create_by_evaluation_activity_id(skill)
    
    skill_result.update_attributes(:score => score, :level => level) 
    
    # self.update_attributes(:skill_name => skill, :skill_score => score, :skill_level => level)    

        
  end
  
  def determine_ability_logit(skill)
    questions = self.question_results.skill_results(skill)
    # answers = self.question_results.skill_results(skill).answered
    number_of_corrected = self.question_results.skill_results(skill).answered.corrected.size
    number_of_answered = self.question_results.skill_results(skill).answered.size
    
    if number_of_answered < 4
      return -6.0 + number_of_corrected
    end
    
    # if number_of_answered == 0
    #   return -6.0
    # end
    
    
    logit = []
    questions.each do |q_result|
      question = q_result.question
      logit << question.logit
    end
    
    test_width = calculate_test_width(logit)
    
    proportion_correct = calculate_proportion(number_of_corrected,number_of_answered)
    
    sum_difficulty = logit.sum
    
    test_difficulty = sum_difficulty/number_of_answered
    
    formula_a = calculate_a(test_width,proportion_correct)
    
    formula_b = calculate_b(test_width,proportion_correct)
    
    ability = test_difficulty + test_width * (proportion_correct - 0.5) + Math.log(formula_a/formula_b)
    
    return 6.0 if ability > 6.0
    return -6.0 if ability < -6.0
    return ability
    
  end
  
  def calculate_test_width(logit)
    
    min = logit.min
    max = logit.max
    num = logit.size
    
    temp = logit - [min,max]
    
    s_min = temp.min
    s_max = temp.max
    
    return ((max + s_max) - (min + s_min))/2.0*(num/(num-2).to_f)
    
  end
  
  def calculate_proportion(corrected,total)
    pro = (corrected/total.to_f).round(1)
    return 0.01 if pro == 0.0
    return 0.99 if pro == 1.0
    return pro
  end
  
  def calculate_a(test_width,proportion_correct)
    return 1.0 - Math.exp(-1.0 * test_width * proportion_correct)
  end
  
  def calculate_b(test_width,proportion_correct)
    return 1.0 - Math.exp(-1.0 * test_width * (1.0 - proportion_correct))
  end
  
  def calculate_score_by_ability(ability)
      return ((ability.round(1) + 6.0) * 10.0 * 5.0) + 5;
  end
  
  def calculate_level_by_ability(ability)
    logitValue = ability.round(1) * 10
    level = case logitValue
    when (-60)..(-50)
      1
    when (-49)..(-35)
      2
    when (-34)..(-27)
      3
    when (-26)..(-20)
      4
    when (-19)..(-12)
      5
    when (-11)..(-5)
      6
    when (-4)..0
      7
    when 1..10
      8
    when 11..20
      9
    when 21..30
      10
    when 31..45
      11
    when 46..60
      12
    else
      0
    end      
  end
  
end
