class MessagesController < BaseController
  layout :set_layout_loged

  
  def index
    @messages = Message.where(:schedule_id => params[:id], :msg_type => false)
    @ask_msgs = Message.where(:schedule_id => params[:id], :msg_type => true)
    
    render :layout => false
  end

  def create
    @message = current_user.messages.build(params[:message])
    @message.save

    render :text => 'success'
  end
  
  def ask_msgs
    @ask_msgs = Message.where(:schedule_id => params[:id], :msg_type => 1)
    
    render :layout => false
  end

end
