class Question < ActiveRecord::Base
  has_many  :answers, :order => "name"
  
  def correct_answer
    self.answers.correct.first
  end
  
  def self.random_test
    ordering = rand(33)
    Question.all(:conditions=>"ordering=#{ordering}")
  end
  
  def self.random_questions(skill)
    q_all = Question.all(:conditions=>["evaluation_activity_id = ?",skill])
    choose_index = Question.random_array((q_all.size-1), 20)
    result = []
    choose_index.each do |num|
      result << q_all[num]
    end
    result
  end
  
  def self.random_array(total,number)
    result = []
    (0..number).each do |i|
      temp = rand(total)
      result << temp unless result.include?(temp)
    end
    return result
  end
  
end
