module User::SchedulesHelper
  def post_list(posts, with_user = false)
    c = ""
    posts.each_with_index{|t, index| c << post_tag(t, with_user, true, index==0)}
    c
  end

  def post_tag(post, with_user = false, owner = true, is_first = false)
    
    

  end

end