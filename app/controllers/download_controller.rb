class DownloadController < ApplicationController
  ignore_login :only => [:file]
  def file
    send_file "#{RAILS_ROOT}/public/files/"+params[:filename] unless params[:filename].blank? 
  end
end