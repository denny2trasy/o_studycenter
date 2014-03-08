class Admin::MailRecordsController < Admin::BaseController
  
  def index
    @mail_records = MailRecord.combo_search(params, :default => :all, :order => "created_at DESC")
  end
  
  def show
    @mail_record = MailRecord.find(params[:id])
    @content = @mail_record.content
    render :text => @content
  end
end
