class PptsController < BaseController
  layout :set_layout_loged
  
  def index
    @course_packages = current_user.course_packages
    if params[:type]
     # @slides = Slide.where("name LIKE ?", "%#{params[:name]}%") #.page(params[:page]).per(10)
      @slides = Slide.where(:download=>true,:course_type=>params[:type])
      @course_type = params[:type]
    else
      @course_type = "ellis"
      @slides = Slide.where(:download=>true,:course_type=>@course_type).order("lesson_id") #Slide.page(params[:page]).per(100)
    end
  end
  
  def show
    @slide = Slide.find(params[:id])
    render :layout =>false
  end
  
  
end
