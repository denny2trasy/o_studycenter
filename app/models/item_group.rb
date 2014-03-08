class ItemGroup < ActiveRecord::Base
  acts_as_readonly :el_course

  belongs_to :course_package
  has_many :items, :order => "lesson_id"
  has_many :scenarios, :order => "position"
  has_many :third_contents, :order => "position"
  has_many :examinations
  

  def lessons
    Lesson.where(:id => self.items.map(&:lesson_id))
  end
  
  
  def lesson_number
    self.items.count
  end
  
  def studied_items(user)
    ids=[]
    self.lesson_studied(user).each do |record|
      ids << record.item_id
    end
    self.items.where(:id =>ids)
  end
  
  def lesson_studied(user)
    item_ids = []
    self.items.each do |item|
      item_ids << item.id
    end
    StudyRecord.find(:all,:select=>'*, count(id) as num', :conditions => {:item_id => item_ids,:user_id=> user.id} ,:group=>"item_id")
  end
  
  def webex_studied_records(user)
    s_ids=[]
    self.items.each do |item|
      item.content.schedules.each do |s|
        s_ids << s.id
      end
    end
    WebexRecord.find(:all,:select=>"*, sum(duration) as sum_suration", :conditions =>{:schedule_id =>s_ids, :user_id =>user.id}, :group =>"schedule_id")
  end
  
  def my_examinations(user)
    Examination.where(:user_id=>user.id,:item_group_id=>self.id)
  end
  
  def best_test_score(user)
    c=Examination.where(:user_id=>user.id,:item_group_id=>self.id).order("score").first
    c ? c.score : 0
  end

  
  # def lesson_number
  #   if self.course_type == "ellis" or self.course_type.blank?
  #     self.lessons.count
  #   elsif self.course_type == "scenario"
  #     self.scenarios.count
  #   elsif self.course_type == "third_content"
  #     self.third_contents.count
  #   end
  # end
  
  # def lesson_studieds(current_user_id,course_package_id)
  #   item_ids = []
  #   self.lessons.each do |lesson|
  #     item_ids << lesson.id
  #   end
  #   self.scenarios.each do |scenario|
  #     item_ids << scenario.show_scenario_id
  #   end
  #   self.third_contents.each do |content|
  #     item_ids << content.show_content_id
  #   end
  #   StudyRecord.find(:all,:select=>'*, count(DISTINCT lesson_id) ', :conditions => {:lesson_id => item_ids,:user_id=> current_user_id,:course_package_id=>course_package_id} ,:group=>"lesson_id")
  # end
end
