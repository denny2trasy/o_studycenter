require 'fileutils'
class Slide < ActiveRecord::Base
  belongs_to :user
  has_many :schedules
  validates :name, :presence => true
  validates :ppt, :presence => true, :ppt_format => true, :on => :create
  def ppt=(file)
    @ppt = file
  end
  
  def ppt
    @ppt
  end

  def path(format = :ppt)
    Rails.root.join("public/system/#{format}/#{self.id}.#{format}")
  end
  
  def uniq_path
    Rails.root.join("public/system/ppt/#{self.ppt.original_filename.gsub(/\W+/, "")}.ppt")
  end

  def url(format = :ppt)
    path(format).sub(Rails.root.join("public").to_s, Rails.env == "production" ? "/el_studycenter" : "")
  end

  #after_save :save_ppt
  after_save :save_swf
  after_destroy :destroy_swf
  after_update :save_swf

  private
  
  def save_swf
    if self.ppt
      FileUtils.cp(self.ppt.tempfile.path, self.path(:swf))
    end
    return true
  end
  
  def destroy_swf
    FileUtils.rm self.path(:swf)
  end

  #def save_ppt
  #  if self.ppt
  #    FileUtils.cp(self.ppt.tempfile.path, self.path(:ppt))
  #    FileUtils.cp(self.ppt.tempfile.path, self.uniq_path)
  #  end
  #  return true
  #end

  #def save_swf
  #  File.delete(self.path(:swf)) if File.exist?(self.path(:swf))
  #  ConvertOffice::ConvertOfficeFormat.new.convert(self.path, self.path(:swf)) if self.ppt
  #end
end
