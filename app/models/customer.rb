class Customer < ActiveRecord::Base
  # acts_as_readonly :el_course
  
  has_many :customer_schedules
  has_many :course_packages
  
  def schedules
    ids =[]
    self.customer_schedules.each do |cs|
      ids << cs.schedule_id
    end
    Schedule.where(:id =>ids)
  end
  
  # valid_length :coments,:size=>1200
  
  def self.list_select
    res = []
    Customer.all.each do |c|
      res << "#{c.id} - #{c.company_name}"
    end
    return res
  end
  
end
