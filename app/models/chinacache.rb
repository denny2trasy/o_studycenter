class Chinacache < ActiveRecord::Base
  acts_as_readonly :el_course
  has_one :item,  :as => :content
  has_many :schedules, :as => :content
  
end