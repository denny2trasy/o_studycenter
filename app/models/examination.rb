class Examination < ActiveRecord::Base
  
  has_many :examination_quizzes,:order=>"position"
  belongs_to :user
  belongs_to :item_group
  
  
  def generate_examination(level,num)
    
    ActiveRecord::Base.transaction do 
      begin
        quizzes = Quiz.find(:all,:conditions =>{:level=>level},:limit =>num,:order =>"RAND()")
        params=[]
        position=0
        quizzes.each do |quiz|
          position += 1
          e_quiz = {}
          e_quiz[:examination_id] = self.id
          e_quiz[:position] = position
          e_quiz[:quiz_id] = quiz.id
          e_quiz[:level_id] = level
          params.push(e_quiz)
        end  
        
        ExaminationQuiz.create(params)
      rescue
        return false
      end
    end
    
  end
end
