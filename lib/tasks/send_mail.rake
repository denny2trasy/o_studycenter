#send progress to students
task :send_study_progress_mail,[:conditions] =>:environment do |t,a|
  template_content = MailTemplate.find_by_name(COURSE_PROGRESS_STATUS_TEMPLATE_NAME)
  notice = Notice.where(:display =>true)
  User.all(:conditions=>a.conditions).each do |user|
    package = user.current_course_package
    if package
      Time.zone = user.time_zone
      I18n.locale = user.locale
      title = COURSE_PROGRESS_STATUS_MAIL_TITLE
      from = COURSE_PROGRESS_STATUS_MAIL_FROM
      to = user.mail
      table1 = ""
      table2 = ""
      now = Time.now
      time_from = now.beginning_of_week
      time_end = now.end_of_week
      customer = package.customer
      s_records = StudyRecord.where("user_id = ? and created_at >= ? and created_at <= ?", user.id, time_from, time_end)
      w_records = WebexRecord.where("user_id = ? and join_at >= ? and join_at <= ?", user.id, time_from, time_end)
      t_records = Examination.where("user_id = ? and created_at >= ? and created_at <= ?", user.id, time_from, time_end)
      schedules = customer.schedules.where("course_start_at >= ? and course_start_at <= ?", time_from.next_week, time_end.next_week.end_of_week)
      7.times do |d|
        time_f = time_from+d.days
        time_e = time_from+(d+1).days
        sr = s_records.where("created_at >= ? and created_at <= ?", time_f, time_e)
        wr = w_records.where("join_at >= ? and join_at <= ?", time_f, time_e)
        tr = t_records.where("created_at >= ? and created_at <= ?", time_f, time_e)
        table1 += %Q{<tr><td class="date">#{time_f.strftime("%A")}</td>}
      
        table1 += "<td>"
        wr.each do |r|
          table1 += %Q{<span style="color:#F00; margin-right:3px; "> #{r.join_at.to_s(:time)}</span>}
          table1 += "#{r.schedule.title}</br>"
        end
        table1 += "</td>"
      
        table1 += "<td>"
        sr.each do |r|
          table1 += %Q{<span style="color:#F00; margin-right:3px; "> #{r.created_at.to_s(:time)}</span>}
          table1 += "#{r.item.content.name}</br>"
        end
        table1 += "</td>"
      

        table1 += "<td>"
        tr.each do |r|
          table1 += %Q{<span style="color:#F00; margin-right:3px; "> #{r.created_at.to_s(:time)}</span>}
          table1 += "#{r.item_group.name}</br>"
        end
        table1 += "</td>"
      end
      table1 += "</tr>"
    
    
      7.times do |d|
        time_f = time_from+(d+7).days
        time_e = time_from+(d+8).days
        sc = schedules.where("course_start_at >= ? and course_start_at <= ?", time_f, time_e)
        table2 += %Q{<tr><td class="netxweek_date">#{time_f.strftime("%A")}</td>}
        table2 += "<td>"
        sc.each do |r|
          table2 += %Q{<span style="color:#F00; margin-right:3px; "> #{r.course_start_at.to_s(:time)}</span>}
          table2 += "#{r.title}</br>"
        end
        table2 += "</td>"
        table2 += "<td></td><td></td>"
      end
      table2 += "</tr>"
    
      variables = {:student_name =>user.login,:time_from =>time_from.to_s(:date), :time_to =>time_end.to_s(:date), :notice => notice.last ? notice.last.content : "", :table1 =>table1, :table2 =>table2}
      MailTemplate.send_mail(template_content, title, from, to, {:variables =>variables})
      puts "send to "+user.login+" success!"
    end
  end
end