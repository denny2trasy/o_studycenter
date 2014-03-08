class Email < ActiveRecord::Base
  after_destroy :update_mail_status
  after_create :create_mail_record
  
  def create_mail_record
    MailRecord.create(:from =>self.from,:to =>self.to,:mail =>self.mail,:mail_id =>self.id)
  end
  
  def update_mail_status
    record = MailRecord.find_by_mail_id(self.id)
    record.update_attributes(:status=>true,:sent_at =>Time.now) if record
  end
end
