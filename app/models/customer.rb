class Customer < ActiveRecord::Base
  acts_as_readonly :el_course
  
  has_many :customer_schedules
  has_many :course_packages
  
  def schedules
    ids =[]
    self.customer_schedules.each do |cs|
      ids << cs.schedule_id
    end
    Schedule.where(:id =>ids)
  end
end
