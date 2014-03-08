class ThinkingcapRecord < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :third_content
end
