class MailTemplate < ActiveRecord::Base
  # options:
  #   variables => {:login => 'string', :score => '14'}....
  #   bcc => 'bcc@example.com'
  #   cc => 'cc@example.com'
  def self.send_mail(mail_template, title, from, to, options = {})
    return false if to.blank?
    varia_content = []
    raise "template not found, please make sure title, in_use and used_by is correctly" and return if mail_template.nil?

    options = HashWithIndifferentAccess.new(options)
    template_content = mail_template.content.clone
    
    options['variables'].each do |key, value|
      template_content.gsub!(/&lt;/, '<')
      template_content.gsub!(/&gt;/, '>')
      template_content.gsub!(/<=( *)#{key}( *)>/, value.to_s)
      varia_content << "<=#{key}>^#{value}"
    end

    #to = APP_CONFIG["mail_to"] unless APP_CONFIG["mail_to"].blank?

    if to =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      Notifier.notifier(title, from, to, template_content, {:bcc_mail=> options['bcc'], :cc_mail=> options['cc']}).deliver
    else
      MailRecord.create("from" => from, "to" => to, "title" => title, "mail_template" => mail_template.name, "status" => false, :error_message => "invalid mail address", :varia_content => varia_content.join("&"))
    end
  rescue Exception => e
    MailRecord.create(:from => from, :to => to, :title => title, :mail_template_id => mail_template.try(:id), :status => false,
      :error_message => e.message, :varia_content => varia_content.join("&"))
  end
  
  
  def self.send_mails(mail_template, title, from, address, options={})
    raise "template not found, please make sure title, in_use and used_by is correctly" if mail_template.nil?
    address.each do |addr|
      to = addr.shift
      variables = {}
      mail_template.variables.to_s.split(',').each_with_index { |e, i| variables[e.strip] = addr[i] }
      #sleep(10 + rand(5))
      self.send_mail(mail_template, title, from, to, :variables => variables)
    end
  end
  
  def self.send_test_mail(mail_to, options = {})
    Notifier.deliver_notifier("Eleutian Mailer Testing", "no-reply@eleutian.com", mail_to, "test mail")
  end
  
end
