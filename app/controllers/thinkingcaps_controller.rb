class ThinkingcapsController < BaseController
  def show
    @item = Item.find(params[:id])
    @thinkingcap = @item.content
    if @thinkingcap.is_a?(Thinkingcap)
      @course_package = @item.item_group.course_package
      @study_record = current_user.add_study_record(@item)
      thinking = ThinkingCap.instance
      if not thinking.is_enrolled(current_user,@thinkingcap)
         thinking.enroll_student_with_duedate(current_user,@thinkingcap,@course_package.valid_for) 
      end
      redirect_to thinking.get_auto_login_url(current_user,@thinkingcap)
    else
      redirect_to home_path
    end
  end
end
