# encoding:utf-8
class Admin::SlidesController < Admin::BaseController
  
  def index
    if params[:name]
      @slides = Slide.where("name LIKE ?", "%#{params[:name]}%").page(params[:page]).per(10)
    else
      @slides = Slide.page(params[:page]).per(10)
    end
  end
  
  def new
    @slide = Slide.new
  end
  
  def create
    @slide = Slide.new(params[:slide].merge :user => current_user)
    if @slide.save
      redirect_to admin_slides_path, :notice => "创建成功！"
    else
      render "new"
    end
  end
  
  def edit
    @slide = Slide.find(params[:id])
  end
  
  def destroy
    @slide = Slide.find(params[:id])
    @slide.destroy
    redirect_to admin_slides_path, :notice => "删除成功！"
  end
  
  def update
    @slide = Slide.find(params[:id])
    if @slide.update_attributes(params[:slide])
      redirect_to admin_slides_path, :notice => "修改成功！"
    else
      render "edit"
    end
  end
end