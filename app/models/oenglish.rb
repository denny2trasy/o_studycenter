class Oenglish < ActiveRecord::Base
  belongs_to :item_group
  has_one :item,  :as => :content
end
