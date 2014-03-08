class MailServicesController < ApplicationController
  
  def index
    condition = params[:used_by].blank? ? "" : {:used_by => params[:used_by]}
    @template_name_lists = MailTemplate.all(:conditions => condition, :select => :name)
    unless @template_name_lists.blank?
      render :xml => @template_name_lists.to_xml
    else
      render :layout=>false,:nothing=>true, :status=>404
    end
  end

  def create
    if params[:mail_to]
      MailTemplate.send_test_mail(params[:mail_to])
      flash[:notice] = "Test mailer successfully!"
    else
      mail_template = MailTemplate.first(:conditions => {:name => params[:mail_service].delete(:template_name), :used_by => params[:mail_service].delete(:used_by), :in_use => true})
      title = params[:mail_service].delete(:title)
      from = params[:mail_service].delete(:from)
      to = params[:mail_service].delete(:to)
      cc = params[:mail_service].delete(:cc)
      bcc = params[:mail_service].delete(:bcc)
      notice_category = params[:mail_service].delete(:notice_category)
      variables = params[:mail_service]

      if params[:has_attachment].blank?
        MailTemplate.send_mail(mail_template, title, from, to, {:variables => variables, :cc => cc, :bcc => bcc, :notice_category => notice_category})
        flash[:notice] = "Send Successful"
      else
        begin
          address = MailFile.parse_on_csv(params[:file])
          MailTemplate.send_mails(mail_template, title, from, address)
        rescue Exception => e
          flash[:notice] = e.message
        end
      end
    end

    respond_to do |format|
      format.xml {
        render :layout => false, :nothing => true, :status => 200
      }
      format.js 
      format.html {
        redirect_to :back
      }
    end
  end
  
end
