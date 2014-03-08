class ThirdContent < ActiveRecord::Base
  acts_as_readonly :el_course
  belongs_to :item_group
  has_many :thinkingcap_records
end

