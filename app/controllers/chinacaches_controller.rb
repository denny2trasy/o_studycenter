class ChinacachesController < BaseController
  layout :set_layout_loged
  
  def show
    #@content_id = params[:id]
    @item = Item.find(params[:id])
    @chinacache = @item.content
    if @chinacache.is_a?(Chinacache)
      @study_record = current_user.add_study_record(@item)
    else
      redirect_to home_path
    end
  end
  def shows
      @content_id = params[:id] || "836"
      @third_content = ThirdContent.find_by_show_content_id(@content_id)
      @course_package = params[:package_id].nil? ? current_user.current_course_package : CoursePackage.find(params[:package_id]) 
      @study_record = current_user.add_study_record(@content_id,@third_content.name,@course_package.id,'third_content')
      
      unless @third_content.thinkingcap_course.blank?
        thinking = ThinkingCap.instance
        if not thinking.is_enrolled(current_user,@third_content)
           thinking.enroll_student_with_duedate(current_user,@third_content,@course_package.valid_for) 
        end
        redirect_to thinking.get_auto_login_url(current_user,@third_content)
      end
  end
end


