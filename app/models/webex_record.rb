class WebexRecord < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :schedule
  
  def self.all_time(records)
    sum = 0
    records.each do |s|
      sum += s.duration
    end
    return sum
  end
  def self.build_from_csv(row)
    
    user = User.find_by_mail(row[12])
    schedule = Schedule.find_by_webex_id(row[2])
    
    if not schedule.blank?    
      record = WebexRecord.new    
      record.user_id = user.try(:id)    
      record.schedule_id = schedule.try(:id)
      start_at = row[6] # => 6:00 am Denver Time Event Start At
      join_at = row[16] # => 6:06 am Denver Time Student Join At
      leave_at = row[17] # => 6:09 am Denver Time Student Leave At
      j_min = WebexRecord.time_interal(start_at,join_at)
      l_min = WebexRecord.time_interal(start_at,leave_at)
      record.join_at = schedule.course_start_at + j_min.minutes
      record.leave_at = schedule.course_start_at + l_min.minutes
      register_at = row[22] # => December 1, 2012 6:06 am Denver Time
      r_min = WebexRecord.time_interal(start_at,register_at)
      record.register_at = schedule.course_start_at + r_min.minutes
      record.duration = (row[18].gsub(" mins","").to_f + 1.0) # 2.0 mins
      record.attention_radio_1 = row[19].gsub("%","").to_f # 4%
      record.attention_radio_2 = row[20].gsub("%","").to_f # 100%
      record.ip_address = row[26]     # 221.194.13.90
      record.client_agent = row[27]   # WINDOWS,IE
      record.save
    end
  end
  
  # start_str => 6:00 am Denver Time
  # end_str => 6:06 am Denver Time
  # 6：06 - 6：00 = 6
  # 5：57 - 6：00 = -3
  # 7：01 - 6：00 = 61
  def self.time_interal(start_str,end_str)
    s_float = 0.0
    e_float = 0.0
    if start_str =~ /\d*:\d*/
      s_float = ($&.gsub(":",".").to_f * 100).to_i
    end
    if end_str =~ /\d*:\d*/
      e_float = ($&.gsub(":",".").to_f * 100).to_i
    end
    
    e_100 = e_float/100
    s_100 = s_float/100
    
    e_10 = (e_float - e_100*100)
    s_10 = (s_float - s_100*100)
    
    return ((e_100 - s_100) * 60 + (e_10 - s_10))   
  
  end
  
  
end
