ActionMailer::Base.add_delivery_method :active_record, ArMailerRails3::ActiveRecord, :email_class => Email
ActionMailer::Base.delivery_method = :active_record

# config_file = "#{Rails.root}/config/smtp_gmail.yml"
# raise "Sorry, you must have #{config_file}" unless File.exists?(config_file)
# 
# config_options = YAML.load_file(config_file) 
# ActionMailer::Base.smtp_settings = {
#   :address => "smtp.gmail.com",
#   :port => 587,
#   :authentication => :plain,
#   :enable_starttls_auto => true
# }.merge(config_options)