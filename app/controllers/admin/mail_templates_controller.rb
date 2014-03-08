class Admin::MailTemplatesController < Admin::BaseController
   in_place_edit_for :mail_template, :name
   in_place_edit_for :mail_template, :variables
   in_place_edit_for :mail_template, :in_use
   in_place_edit_for :mail_template, :used_by
   in_place_edit_for :mail_template, :description
  
  def index
    @templates = MailTemplate.combo_search(params, :default => :all, :per_page => 20, :page => params[:page], :order => "id DESC")
  end

  def show
    @mail_template = MailTemplate.find_by_id(params[:id])
  end

  def new
    render :layout => false
  end
  
  def edit
    @mail_template = MailTemplate.find_by_id(params[:id])
  end
  
  def update
     @mail_template = MailTemplate.find_by_id(params[:id])
     @mail_template.update_attributes(:content => params[:mail_content]) if @mail_template
     redirect_to admin_mail_template_path(@mail_template)
  end
  
  def create
    @template = MailTemplate.create(params[:template])
    if @template.save
      redirect_to admin_mail_templates_path
    else
      render :new, :layout=>true
    end
  end

  def destroy
    @template = MailTemplate.find_by_id(params[:id])
    unless @template.blank?
      @template.destroy
    end
    redirect_to admin_mail_templates_path
  end
  
  def preview
    @mail_template = MailTemplate.find_by_id(params[:id])
    render :layout => false
  end
  
  
end
