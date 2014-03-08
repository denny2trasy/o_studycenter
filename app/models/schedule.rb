class Schedule < ActiveRecord::Base
  belongs_to :customer
  belongs_to :slide
  has_many  :broad_records
  has_many :customer_schdeules
  has_many :enroll_webexs
  has_many :webex_records
  
  belongs_to :content, :polymorphic => true
  
  validates_presence_of :title
   before_create :create_session_id
    def create_session_id
      @tokbox = OpenTok.instance
      @session_id = @tokbox.create_session("97.75.180.235")
      self.session_id = @session_id
    end

  def self.next_lesson
    #self.order("course_start_at").where(["course_start_at >= ? ", Time.current] ).all
    self.order("course_start_at").where("course_start_at >= '#{Time.current.in_time_zone("UTC").to_s(:db)}' ").first
  end
  
  def du
    ((self.course_end_at-self.course_start_at)/60).to_i
  end

end
