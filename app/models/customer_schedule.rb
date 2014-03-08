class CustomerSchedule < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :customer
end
