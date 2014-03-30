class RegisterCode < ActiveRecord::Base
  # acts_as_readonly :el_course
  has_one :course_package_user
  belongs_to :course_package
  
  def register_code_valid?(code)
    self.code == code and not self.is_used?
  end

  def is_used?
    return (self.course_package_user.blank? ? false : true)
  end
  
  after_create  :update_register_code
  
  
  def update_register_code    
    self.update_attribute(:code,RegisterCode.generate_code)
  end
  
  def self.generate_code
    range = ("A".."Z").to_a + ("0".."9").to_a
    code = []
    (1..4).each do |m|
      temp = ""
      (1..4).each do |n|
        temp += range[rand * range.size]
      end
      code << temp
    end
    return code.join("-")
  end
  
  def self.batch_create(params)
    
    ActiveRecord::Base.transaction do 
      
      begin
      
        inserts = []
        valid_time = params[:register_code]['valid_time(1i)']+'-'+params[:register_code]['valid_time(2i)']+'-'+params[:register_code]['valid_time(3i)']
        params[:number_of_users].to_i.times  do
            code = RegisterCode.generate_code
            inserts.push "(#{params[:package_id]}, '#{valid_time}',1, '#{params[:desc]}', '#{code}','#{Time.now.to_s(:db)}','#{Time.now.to_s(:db)}')"
          end
        sql = "INSERT INTO register_codes (`course_package_id`,`valid_time`,`status`,`desc`,`code`,`created_at`,`updated_at`) VALUES #{inserts.join(", ")}"
        RegisterCode.connection.execute sql
        return "Success"
      rescue
        return "Fail"
      end
    end
  
    
  end
  
  
end