desc "statistics student number every week"
task :student_number_by_period,[:start_time,:end_time] => :environment do |t,args|

  num = 0
  User.where(["updated_at between ? and ?", args[0],args[1]]).each do |user|
    num += 1 if user.course_packages.size > 0
  end
  
  puts "The number of #{start_time} - #{end_time} is #{num}"

end