class ProgressRecordsController < BaseController
  
  def index
  end
  
  # 
  # this action apply json data to highchart in index page
  # id = 1 for highstock which include all item in one chart
  # => params[item] = [selfstudy_total,selfstudy_course,onlineclass_duration,onlineclass_schedule]
  # id = 2 for studyrecord
  # => params[way] = [week,month] 
  # id = 3
  # => params[way] = [week,month]
  def show
    puts params[:id]
    # current_user = User.find(9424)
    if params[:id] == "1"
      item = params["item"] || "selfstudy_total"      
      result = current_user.progress_record(item) 
    elsif params[:id] == "2"
      # row = ['12-20','12-21','12-22','12-23','12-24','12-25','12-26','12-27','12-28','12-29','12-30','12-31']
      # total = [7, 6, 9, 14, 18, 21, 25, 26, 23, 18, 13, 9]
      # course = [4, 4, 5, 8, 3, 5, 7, 16, 14, 10, 6, 4]
      # result = {"row" => row, "total" => total, "course" => course }
      way = params[:way] || "week"
      result = current_user.selfstudy_records_for_chart_by(way)
    elsif params[:id] == "3"
      way = params[:way] || "week"
      result = current_user.online_records_for_chart_by(way) 
    else
      result = {}   
    end      
    render :json => result
  end
  
  
end
