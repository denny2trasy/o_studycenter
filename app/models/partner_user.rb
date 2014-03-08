class PartnerUser < ActiveRecord::Base
  acts_as_readonly :el_user, :table_name => "partner_profiles"
  
  belongs_to :user,:foreign_key => :user_id
  delegate :login,:given_name, :to => :user, :allow_nil => true

end