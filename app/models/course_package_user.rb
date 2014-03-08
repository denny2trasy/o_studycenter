class CoursePackageUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :course_package
  belongs_to :customer
  belongs_to :register_code

  scope :current, where(:current => true)
  scope :valid, lambda {|time| where(["expired_at > ?",time])}
  
  delegate :given_name, :login, :created_at, :to => :user, :prefix => true
  delegate :company_name, :short_name, :to => :customer, :prefix => true, :allow_nil => true
  
  after_create  :set_to_current
  
  
  def set_to_current
    CoursePackageUser.update_all("current=0","current=1 and user_id=#{self.user_id}")
    self.update_attributes(:current => true)
  end
  
  def extend_time
    start_time = Time.now >= self.expired_at ? Time.now : self.expired_at
    e_at = start_time + (self.course_package.valid_for || 1).days
    self.update_attributes(:expired_at => e_at)
  end
  
  def self.stat_result(way)
    w = way || "weeks"
    cond = ["customer_id is not null"]
    e_day = eval("1.#{w}.ago")
    cond << "activated_at >= '" + "#{e_day.to_s(:db)}" + "'"
    cond << "activated_at <= '" + "#{Time.now.to_s(:db)}" + "'"
    
    # if not params["start"].blank?
    #   cond << "activated_at >= '" + "#{params['start']}" + "'"
    # end
    # 
    # if not params["end"].blank?
    #   cond << "activated_at <= '" + "#{params['end']}" + "'"
    # end     
    
    temp = CoursePackageUser.select("customer_id,date_format(activated_at,'%Y-%m-%d') as date,count(*) as c").where(cond.join(' and ')).group("customer_id,date_format(activated_at,'%Y-%m-%d')")
    
    row = []
    col = []
    data = {}
    
    temp.each do |user|
      row << user.customer_id
      col << user.date
      key = "#{user.customer_id}-#{user.date}"
      data[key] = user.c
    end
    
    [(row.uniq - [nil]).sort,(col.uniq - [nil]).sort,data]
    
    
    
  end
  
  def self.activate_users_each_day_of(cp_id)
    
    cond = "course_package_id = #{cp_id}"
    select = "date_format(activated_at,'%Y-%m-%d') as date,count(*) as num"
    order = "activated_at desc"
    group = "date_format(activated_at,'%Y-%m-%d')"
    temp = CoursePackageUser.select(select).where(cond).order(order).group(group)
    result = []
    temp.each do |cp|
       result << [cp.date, cp.num]
    end
    result
  end
  
  
end
