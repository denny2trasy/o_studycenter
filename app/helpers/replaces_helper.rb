module ReplacesHelper

  def show_question_audio(file)
    return "" if file.blank?
    url = "http://cdn.eleutian.asia/Courses/ellis/1/audio/#{file}"
    src = (Rails.env == "development" ? "/flash/musicplayer.swf" : "/el_studycenter/flash/musicplayer.swf")
    show_info = "<embed src='#{src}' quality='high' pluginspage='http://www.macromedia.com/go/getflashplayer' wmode='transparent' type='application/x-shockwave-flash' align='middle' allowScriptAccess='sameDomain' flashvars='song_url=#{url}' width='17' height='17'/>"
    return show_info.html_safe
  end
  
  def show_skill(id)
    return "" if id.blank?
    a = {"214" => "Vocabulary","215" => "Grammar","216" =>"Listening"}
    return a[id.to_s]
  end

end