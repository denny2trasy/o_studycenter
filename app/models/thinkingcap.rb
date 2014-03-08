class Thinkingcap < ActiveRecord::Base
  acts_as_readonly :el_course
  
  has_many :schedules, :as => :content
  has_one :item, :as => :content
  has_many :thinkingcap_records
end