class Item < ActiveRecord::Base
  # acts_as_readonly :el_course

  belongs_to :item_group
  belongs_to :lesson
  
  belongs_to :content, :polymorphic => true
  has_many :study_records
  
  
  def lesson_link
    if self.content.is_a?(Lesson)
      #lesson_path(self)
      "/el_studycenter/lessons/#{self.id}"
    elsif self.content.is_a?(Scenario)
      #scenario_path(self)
      "/el_studycenter/scenarios/#{self.id}"
    elsif self.content.is_a?(Chinacache)
      #chinacach_path(self)
      "/el_studycenter/chinacaches/#{self.id}"
    elsif self.content.is_a?(Thinkingcap)
      #thinkingcap_path(self)
      "/el_studycenter/thinkingcaps/#{self.id}"
    else
      ""
    end
  end
  
  def img_link
    if self.content.is_a?(Lesson)
      "http://cdn.eleutian.com/Content/Lessons/#{self.content.image_url}"
    elsif self.content.is_a?(Scenario)
      "http://cdn.eleutian.com/Content/EQ/Formula#{self.content.show_scenario_id}.jpg"
    elsif self.content.is_a?(Chinacache)
      "/el_studycenter/images/el/xinhangdao/cambridge_large.jpg"
    elsif self.content.is_a?(Thinkingcap)
      "/el_studycenter/images/el/jianqiao/go_large.png"
      #"jianqiao/bv_large.png"
    else
      ""
    end
  end
  
  def thinkingcap_records(user)
    if self.content.is_a?(Thinkingcap)
      ThinkingcapRecord.where(:thinkingcap_course_id => self.content.show_course_id,:user_id=>user.id)
    else
      []
    end
  end
  
  def my_study_records(user)
    StudyRecord.where(:item_id => self.id,:user_id=>user.id)
  end
  
  def content_link
    link = ""
    # if self.content.is_a?(Lesson)
    #   link = self.content.id
    if self.content.is_a?(Scenario)
      link = self.content.show_scenario_id
    elsif self.content.is_a?(Thinkingcap)
      link = self.content.show_course_id
    elsif self.content.is_a?(Chinacache)
      link = self.content.show_chinacache_id
    elsif self.content.is_a?(Oenglish)
      link = self.content.show_oenglish_id
    end
  end
  
end
