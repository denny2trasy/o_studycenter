class EnrollWebex < ActiveRecord::Base
  
  belongs_to :schedule
  belongs_to :user
  validates_length_of :enroll_id,:in => 1..6,:on => :update
end
