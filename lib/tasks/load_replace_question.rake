desc "Load Place Question from SpeakENG"
task  :load_place_question => :environment do
  
  Question.delete_all
  name = File.expand_path(File.join(File.dirname(__FILE__),"../source/speakeng_placement_test_questions.txt"))
  file = File.new(name,"r")
  
  file.readlines.each do |line|
  
    array = line.split("	")
    puts "*".center(80,"*")
    puts "Old ID = #{array[0]}"
    puts "Prompt = #{array[1]}"
    puts "Logit = #{array[2]}"
    puts "Exposure = #{array[3]}"
    puts "Sounds = #{array[4]}"
    puts "Ordering = #{array[5]}"
    puts "LevelId = #{array[6]}"
    puts "Bank = #{array[7]}"
    puts "InstructionSounds = #{array[8]}"

    q = Question.new
    q.old_id = array[0]
    q.prompt = (array[1] == "NULL" ? nil : array[1])
    q.logit = array[2]
    q.exposure = array[3]
    q.sounds = (array[4] == "NULL" ? nil : array[4])
    q.ordering = array[5]
    q.level_id = array[6]
    q.bank = array[7]
    q.instruction_sounds = (array[8] == "NULL\r\n" ? nil : array[8])   
    q.save
    
  end

end

task  :load_place_answer => :environment do
  
  Answer.delete_all
  name = File.expand_path(File.join(File.dirname(__FILE__),"../source/speakeng_placement_test_questions-answers.txt"))
  file = File.new(name,"r")
  
  file.readlines().each do |line|
  
    answer = line.split("	")
    puts "*".center(80,"*")
    puts "Old Id = #{answer[0]}"
    puts "Prompt = #{answer[1]}"
    puts "Option = #{answer[10]}"
    puts "IsCorrect = #{answer[11]}"
    
    question = Question.find_by_old_id(answer[0])
    
    if not question.blank?
      a = question.answers.create(:name=> answer[10],:is_correct=> (answer[11] == "1\r\n" ? true : false))
    end 
  
  end
  
end

task  :load_replace_question => :environment do 
  
  Question.delete_all

  type = %w{vocabulary grammar listening}
  
  type.each do |t_name|
    
    name = File.expand_path(File.join(File.dirname(__FILE__),"../source/#{t_name}.txt"))
    file = File.open(name,"r")
    
    file.readlines.each do |line|

      array = line.split("	")
      puts "*".center(80,"*")
      puts "Old ID = #{array[0]}"
      puts "InstructionText = #{array[1]}"
      puts "InstructionSoundFile = #{array[2]}"
      puts "PromptText = #{array[3]}"
      puts "PromptSoundFile = #{array[4]}"
      puts "EvaluationActivityId = #{array[5]}"
      puts "Logit = #{array[6]}"
      puts "Level = #{array[7]}"
      puts "Bank = #{array[8]}"

      q = Question.new
      q.old_id = array[0]
      q.instruction = (array[1] == "NULL" ? nil : array[1])
      q.instruction_sounds = (array[2] == "NULL" ? nil : array[2])
      q.prompt = (array[3] == "NULL" ? nil : array[3])
      q.sounds = (array[4] == "NULL" ? nil : array[4])
      q.evaluation_activity_id = array[5]
      q.logit = array[6]
      q.level_id = array[7]
      q.bank = array[8]
      q.save

    end
  
  end
  

  
end


task  :load_replace_answers => :environment do
  
  Answer.delete_all
  name = File.expand_path(File.join(File.dirname(__FILE__),"../source/options.txt"))
  file = File.new(name,"r")
  
  file.readlines().each do |line|
  
    answer = line.split("	")
    puts "*".center(80,"*")
    puts "Old Id = #{answer[0]}"
    puts "Prompt = #{answer[1]}"
    puts "IsCorrect = #{answer[2]}"
    
    question = Question.find_by_old_id(answer[3])
    
    if not question.blank?
      a = question.answers.create(:name=> answer[1],:is_correct=> answer[2])
    end 
  
  end
  
end