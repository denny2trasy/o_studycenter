Factory.define :user do |f|
  f.sequence(:login) {|i| "user_login_#{i}"}
  f.sequence(:mail) {|i| "mail_#{i}@example.com"}
end

Factory.define :lesson do |f|
  f.sequence(:number) {|i| i}
end

Factory.define :course_package do |f|
  f.name 'SPEAKENG 99'
  f.valid_for 3
end

Factory.define :register_code do |f|
end

Factory.define :course_package_user do |f|
end

Factory.define :item_group do |f|
  f.association :course_package, :factory => :course_package
  f.name 'group'
end

Factory.define :item do |f|
  f.association :item_group, :factory => :item_group
  f.association :lesson, :factory => :lesson
  f.name 'item'
end

Factory.define :study_record do |f|
  f.association :lesson, :factory => :lesson
  f.association :user, :factory => :user
end

Factory.define :schedule do |f|
  f.session_id "1ecc006801647748009a1481f8fc4129788fdfa1"
end
