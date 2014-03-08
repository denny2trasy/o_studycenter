class BroadRecord < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :schedule
end
