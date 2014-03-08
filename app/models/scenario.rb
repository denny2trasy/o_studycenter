class Scenario < ActiveRecord::Base
  acts_as_readonly :el_course
  
  belongs_to :item_group
  has_many :schedules, :as => :content
  has_one :item, :as => :content
end