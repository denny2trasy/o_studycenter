class User < ActiveRecord::Base
  acts_as_readonly :el_user, :table_name => "profiles" , :readonly =>false

  has_many :course_package_users
  has_many :study_records
  has_many :messages
  has_many :slides
  has_many  :test_results
  has_many :issues
  has_many :broad_records
  has_many :enroll_webexs
  has_many :examinations
  has_many :webex_records
  
  scope  :students_for_thinkingcap,  where("thinkingcap_student is not null")

  attr_accessor :password, :password_confirmation

  def add_course_package(course_package, options = {})
    a_at = Time.now
    e_at = a_at + (course_package.valid_for || 1).days
    options = {:course_package_id => course_package.id, :customer_id => course_package.customer_id,:activated_at => a_at,:expired_at => e_at}.merge(options)
    self.course_package_users.create(options).course_package
  end

  def course_packages
    CoursePackage.where(:id => self.course_package_users.valid(Time.now).map(&:course_package_id))
  end

  def current_course_package
    self.course_package_users.valid(Time.now).current.first.try(:course_package) or self.course_package_users.valid(Time.now).last.try(:course_package)
  end

  def current_course_package?(course_package)
    current_course_package == course_package
  end

  def set_current_course_package(course_package)
    self.course_package_users.current.each {|o| o.update_attributes :current => false}
    self.course_package_users.where(:course_package_id => course_package.id).first.update_attributes(:current => true)
  end

  def course_package(course_package_id)
    self.course_package_users.where(:course_package_id => course_package_id).first.try(:course_package)
  end

  def studied_lesson?(lesson)
    self.study_records.where(:lesson_id => lesson.id).first.present?
  end
  
  # todo make it more useful
  def add_study_record(item)
    return self.study_records.create(:item_id =>item.id,:lesson_name => item.content.name, :course_package_id => item.item_group.course_package_id)
    #return self.study_records.create(:lesson_id => lesson_id,:lesson_name => lesson_name, :course_package_id => package_id, :course_type => course_type)    
  end
  
  def can_active?
    return ((not self.login.blank?) and (not self.mail.blank?))
  end
  
  def has_lesson?(item)
    self.course_packages.each do |package|
      return true if package == item.item_group.course_package
    end
    false
  end
  
  def layout_name(options = {})
    if self.from_partner == 'english_salon'
      "salon"
    elsif self.from_partner == 'jidebao'
      "jidebao"
    elsif self.from_partner == 'acgem'
      "acgem"
    elsif self.from_partner == 'eleutian_com'
      "com"
    elsif self.from_partner == 'cambridge'
      "cambridge"
    else
      "application"
    end
  end
  
  # replace result
  def create_test_result(params)
    t_result = self.test_results.create
    score = self.create_question_result(t_result,params)
    level = calculate_level_base_on(score)
    t_result.update_attributes(:score => score,:level => level)
  end
  
  def calculate_level_base_on(score)
    level = case score
    when 0..60
      99
    when 61..80
      101
    when 81..95
      201
    when 96..100
      301
    else
      99
    end
  end
  
  def create_question_result(t_result,params)
    score = 0
    number = 0
    params.keys.sort.each do |key|
      if key =~ /questions_(\d+)/
        question_id = params["questions_#{$1}"]
        answer_id = params["answers"]["#{$1}"]
        is_correct = (answer_id == Question.find_by_id(question_id).correct_answer.id.to_s)
        result = t_result.question_results.create(:user_id => self.id)
        result.question_id = question_id
        result.answer_id = answer_id
        result.is_correct = is_correct
        result.save
        score += 1 if is_correct
        number += 1
      end
    end
    return (score/number.to_f)*100.0
  end


  # new replace test at 20120209
  
  def get_question_results(t_id,skill)
    q_results = QuestionResult.all(:conditions=>["user_id = ? and test_result_id = ? and evaluation_activity_id =? ",self.id,t_id,skill])
    
    if q_results.blank?
      questions = Question.random_questions(skill)
      q_results = []
      questions.each do |q|
        result = QuestionResult.create(:user_id => self.id,:test_result_id => t_id,:question_id => q.id,:evaluation_activity_id => skill)
        q_results << result
      end
    end
    
    return q_results
  end
  
  def update_question_skill_result(t_id,skill,params)
    
    test_result = TestResult.find_by_id(t_id)
    update_questions_result(params)
    test_result.update_skill_result(skill)    

  end
  
  def update_questions_result(params)
    
    unless params["answers"].blank?
      params.keys.sort.each do |key|
        if key =~ /questions_(\d+)/
          question_result_id = params["questions_#{$1}"]
          answer_id = params["answers"]["#{$1}"]
          unless answer_id.blank?
            question_result = QuestionResult.find_by_id(question_result_id)
            is_correct = (answer_id == Question.find_by_id(question_result.question_id).correct_answer.id.to_s)
            question_result.update_attributes(:answer_id => answer_id, :is_correct => is_correct)
          end
        end
      end
    end
    
  end


  def update_test_result(t_id)
    
    test_result = TestResult.find_by_id(t_id)
    test_result.update_result
    
  end
  
  # for eleutian.com sessions
  def upcoming_sessions(course_package,num)
    return [] if course_package.blank?
    
    c_p_user = CoursePackageUser.find_by_user_id_and_course_package_id(self.id,course_package.id)
    customer = Customer.find_by_id(c_p_user.customer_id)
    
    return [] if customer.blank?
    
    broadcasts = []
    
    customer_schedules = customer.try(:customer_schedules)
    customer_schedules.try(:each) do |item|
      broadcasts << item.schedule if not item.schedule.nil? and item.schedule.course_start_at > Time.now
    end
    broadcasts = broadcasts.sort{|x,y| x.course_end_at <=> y.course_end_at}
    
    return broadcasts[0..(num-1)]
    
  end
  
  # progress record
  # item = [selfstudy_total,selfstudy_course,onlineclass_duration,onlineclass_schedule]
  def progress_record(item)
    result = []
    case item
    when "selfstudy_course"
      self.study_records.all(:select=>"str_to_date(created_at,'%Y-%m-%d') as d,count(distinct item_id) as num",:group=>"str_to_date(created_at,'%Y-%m-%d')",:order=>"created_at").each do |sr|
        result << [sr.d.to_time.to_i * 1000,sr.num]
      end
    when "onlineclass_duration"
      self.webex_records.all(:select=>"str_to_date(register_at,'%Y-%m-%d') as d,sum(duration) as num",:group=>"str_to_date(register_at,'%Y-%m-%d')",:order=>"register_at").each do |sr|
        result << [sr.d.to_time.to_i * 1000,sr.num.to_f/60]
      end
    when "onlineclass_schedule"
      self.webex_records.all(:select=>"str_to_date(register_at,'%Y-%m-%d') as d,count(distinct schedule_id) as num",:group=>"str_to_date(register_at,'%Y-%m-%d')",:order=>"register_at").each do |sr|
        result << [sr.d.to_time.to_i * 1000,sr.num]
      end
    else
      self.study_records.all(:select=>"str_to_date(created_at,'%Y-%m-%d') as d,count(*) as num",:group=>"str_to_date(created_at,'%Y-%m-%d')",:order=>"created_at").each do |sr|
        result << [sr.d.to_time.to_i * 1000,sr.num]
      end
    end
    result
  end
  
  # progress record
  # params = week,month
  # result = {"row"=>[],"total"=>[],"course"=>[]}
  def selfstudy_records_for_chart_by(way)
    d_num = (way == 'month' ? 30 : 6)
    end_date = Time.now.end_of_day
    start_date = end_date - d_num.days
    total_hash = study_records_hash_between("count(*) as num",start_date,end_date)
    course_hash = study_records_hash_between("count(distinct item_id) as num",start_date,end_date)
    row,total,course = [],[],[]
    ((start_date.to_date)..(end_date.to_date)).each do |d_time|
      d = d_time.strftime('%Y-%m-%d')      
      row << d_time.strftime('%d')
      total << (total_hash[d] || 0)
      course << (course_hash[d] || 0) 
    end
    {"row"=>row,"total"=>total,"course"=>course}
  end
  
  # study_records
  # item = {"count(*) as num","count(distinct lesson_id) as num"}
  def study_records_hash_between(item,s_date,e_date)
    result = {}
    s_item = "str_to_date(created_at,'%Y-%m-%d') as d,#{item}"
    self.study_records.all(:select=>s_item,:conditions=>["created_at between ? and ?",s_date,e_date],:group=>"str_to_date(created_at,'%Y-%m-%d')",:order=>"created_at").each do |sr|
      result[sr.d.strftime('%Y-%m-%d')] = sr.num
    end
    result
  end
  
  # total = sum duration
  # course = schudule number
  def online_records_for_chart_by(way)
    d_num = (way == 'month' ? 30 : 6)
    end_date = Time.now.end_of_day
    start_date = end_date - d_num.days
    duration_hash = webex_records_hash_between("sum(duration) as num",start_date,end_date)
    class_hash = webex_records_hash_between("count(distinct schedule_id) as num",start_date,end_date)
    row,duration,class_num = [],[],[]
    ((start_date.to_date)..(end_date.to_date)).each do |d_time|
      d = d_time.strftime('%Y-%m-%d')      
      row << d_time.strftime('%d')
      duration << (duration_hash[d] || 0)
      class_num << (class_hash[d] || 0) 
    end
    {"row"=>row,"total"=>duration,"course"=>class_num}
  end
  
  # webex_records
  # item = {"sum(duration) as num","count(distinct schedule_id) as num"}
  def webex_records_hash_between(item,s_date,e_date)
    result = {}
    s_item = "str_to_date(created_at,'%Y-%m-%d') as d,#{item}"
    self.webex_records.all(:select=>s_item,:conditions=>["register_at between ? and ?",s_date,e_date],:group=>"str_to_date(register_at,'%Y-%m-%d')",:order=>"register_at").each do |sr|
      result[sr.d.strftime('%Y-%m-%d')] = sr.num
    end
    result    
  end
  
end
