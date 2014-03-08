module ScenarioStudiesHelper
def iframe_container
  str = "<iframe id='framebox' onload='resize()' src='#{flex_source(params[:type])}' width='100%' height='550px' frameBorder='0'></iframe>"
#    if params[:type] == "standard"
#      str << time_span_on("self-study", set_time_mark_analytics_path)
#    elsif params[:type] == "extra"
#      str << time_span_on("extra", set_time_mark_analytics_path)
#    end
  return str
end

def flex_source(content_type)
  case content_type
  when "trial"
    src = url_of(:scenario, :show_preparation,
      {:scenario_id => @lesson.scenario_id,
        :type => params[:type]}.merge(basic_params))
  when "extra"
    src = url_of(:scenario, :show_extra,
      {:id => @lesson.content_id,
        :scenario_id => @lesson.content.scenario_id,
        :extra_type => @lesson.content.extra_type}.merge(basic_params))
  when "standard"
    src = 'http://www.eqenglish.com/scenario/student/previews/836/standard?lesson_index=&lesson_progress=&study_record_id=236950&lesson_flag=main_standard&key=vbrzQRu5YJUyEQe0f7%2BmcRJhthdZbB1h3KvGT3oCvw%2FqX1cJHyYGBHIc%2FyWn%0A4cL1FyxWaS2laHf%2BxGLee8kCQQ%3D%3D%0A'
  when 'exercise'
    src = url_of(:scenario, :show_tag_pages,
      {:scenario_id => @lesson.content_id,
        :ids => @lesson.content.page_ids.gsub(',', '-'),
        :type => params[:type]}.merge(basic_params))
  end
  #encode_url src
end

private
def basic_params
  {:lesson_index => params[:lesson_index] || @current_study_record.lesson_index,
    :lesson_progress => @current_study_record.lesson_progress,
    :study_record_id => @current_study_record.id,
    :lesson_flag => params[:lesson_flag]}
end
end
