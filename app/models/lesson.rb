class Lesson < ActiveRecord::Base
  # acts_as_readonly :ellis
  # has_one :script_screen
  
  has_many :schedules, :as => :content
  has_one :item, :as => :content
end
