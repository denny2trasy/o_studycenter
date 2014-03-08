class CoursePackage < ActiveRecord::Base
  acts_as_readonly :el_course

  has_many :course_package_users
  has_many :item_groups,  :order => "position"
  # has_many :items, :through => :item_groups
  has_many  :register_codes
  belongs_to :customer
  
  scope  :thinkingcap_programs, where("thinkingcap_program is not null")
  
  def register_code_valid?(code)
    self.register_code == code and not self.quota_full?
  end

  def quota_full?
    self.course_package_users.count >= self.number_of_users.to_i
  end
  
  def items
    result = []
    self.item_groups.each do |g|
      result << g.items
    end
    result.flatten
  end
  
  def scenarios
    result = []
    self.item_groups.each do |g|
      result << g.scenarios
    end
    result.flatten
  end
  
  def third_contents
    result = []
    self.item_groups.each do |g|
      result << g.third_contents
    end
    result.flatten
  end
  
  def all_lesson_ids
    ids = []
    self.items.each do |g|
      ids << g.lesson_id
    end
    self.scenarios.each do |g|
      ids << g.show_scenario_id
    end
    return ids
  end
  
  def first_lesson_id
    if (third_contents = self.third_contents).present?
      third_contents.first.show_content_id
    elsif (scenarios = self.scenarios).present?
      scenarios.first.show_scenario_id
    else
      self.items.first.lesson_id
    end
  end
  
  def first_lesson_type
    if (third_contents = self.third_contents).present?
      "third_content"
    elsif (scenarios = self.scenarios).present?
      "scenario"
    else
      "ellis"
    end
  end
  
  #def course_type
  #  return self.scenarios.blank? ? "ellis" : "scenario"
  #end

  # def lesson_number
  #   ((c=self.items.count) == 0 ? false : c) || ((c=self.scenarios.count) == 0 ? false : c) || ((c=self.third_contents.count) == 0 ? 0 : c)
  # end
  
  # def lesson_studied(user_id)
  #   item_ids = []
  #   self.items.each do |item|
  #     item_ids << item.lesson_id
  #   end
  #   self.scenarios.each do |scenario|
  #     item_ids << scenario.show_scenario_id
  #   end
  #   self.third_contents.each do |content|
  #     item_ids << content.show_content_id
  #   end
  #   StudyRecord.find(:all,:select=>'*, count(DISTINCT lesson_id) ', :conditions => {:lesson_id => item_ids,:user_id=> user_id,:course_package_id=>self.id} ,:group=>"lesson_id")
  # end

  def lesson_number
    self.items.count
  end
  
  def lesson_studied(user_id)
    StudyRecord.find(:all, :select=>'*, count(DISTINCT item_id) ', :conditions =>['course_package_id = ? and user_id = ?', self.id, user_id],:group=>"item_id")
  end
  
  def is_speakeng_course
    not self.eleutian_course.blank?
  end

  def study_progress(current_user_id)

    all_lesson_number = self.items.count
    have_studied_lesson = self.lesson_studied(current_user_id).count

    return (all_lesson_number > 0 ? have_studied_lesson * 100 / all_lesson_number : 0)
  end
  
  def expired_for(user)
    cp_user = self.course_package_users.find_by_user_id(user.id)
    return cp_user.try(:expired_at) || Time.now
  end
  
  def thinkingcap_course?
    not self.thinkingcap_program.blank?
  end
  
  def webex_studied_records(user)
    ids=[]
    self.items.each do |item|
      item.content.schedules.each do |s|
        ids << s.id
      end
    end
    WebexRecord.find(:all,:select=>"*, sum(duration) as sum_suration", :conditions =>{:schedule_id =>ids, :user_id =>user.id}, :group =>"schedule_id")
  end
  
  def my_examinations(user)
    ids=[]
    self.item_groups.each do |group|
      ids << group.id
    end
    Examination.where(:user_id=>user.id,:item_group_id=>ids)
  end
  
end
