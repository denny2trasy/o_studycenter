class RegisterCode < ActiveRecord::Base
  acts_as_readonly :el_course
  has_one :course_package_user
  belongs_to :course_package
  
  def register_code_valid?(code)
    self.code == code and not self.is_used?
  end

  def is_used?
    return (self.course_package_user.blank? ? false : true)
  end
end