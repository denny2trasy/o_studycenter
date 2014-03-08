class Notifier < ActionMailer::Base
  default :from => "eleutiancs@163.com"
  
  def notifier(subject,from,to,content,options={})
    @content = content
    mail(:subject =>subject,:to =>to,:bcc =>options[:bcc] || "",:cc =>options[:cc] || "",:from =>from) do |format|
      format.html
    end
  end
  
  def welcome(recipient)
    # @account = recipient
    mail(:to => "denny@eleutian.com") do |format|
      format.html
      format.text {render :text=>"welcome to eqenglish"}
    end
  end
end
