a = []

CoursePackageUser.all(:select=>"DATE_FORMAT(created_at,'%Y-%m-%d') as date, count(*) as num",:group=>"DATE_FORMAT(created_at,'%Y-%m-%d')",:order=>"created_at",:conditions=>"created_at > '2012-07-04 00:00:00'").each do |c|
  a << "#{c.date} - #{c.num}"
end

a.each do |b|
  puts b
end  
  