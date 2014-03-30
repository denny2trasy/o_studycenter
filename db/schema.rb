# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140330131855) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "name"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "broad_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "schedule_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "times",        :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_package_users", :force => true do |t|
    t.integer  "course_package_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current",            :default => false
    t.integer  "customer_id"
    t.integer  "register_code_id"
    t.string   "register_code_code"
    t.datetime "activated_at"
    t.datetime "expired_at"
  end

  add_index "course_package_users", ["course_package_id"], :name => "index_course_package_users_on_course_package_id"
  add_index "course_package_users", ["current"], :name => "index_course_package_users_on_current"
  add_index "course_package_users", ["user_id"], :name => "index_course_package_users_on_user_id"

  create_table "course_packages", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.integer  "valid_for"
    t.text     "description"
    t.string   "register_code"
    t.integer  "number_of_users"
    t.boolean  "require_address",     :default => false
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "eleutian_course"
    t.string   "thinkingcap_program"
    t.string   "course_type"
  end

  add_index "course_packages", ["customer_id"], :name => "index_course_packages_on_customer_id"

  create_table "customer_schedules", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "schedule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "short_name"
    t.string   "company_name"
    t.string   "payment_terms"
    t.string   "billing_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "enroll_webexes", :force => true do |t|
    t.string   "enroll_id"
    t.integer  "schedule_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examination_quizzes", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "examination_id"
    t.integer  "quiz_id"
    t.string   "quiz_type"
    t.integer  "submit_answer_id"
    t.string   "submit_answer"
    t.boolean  "is_correct"
    t.integer  "level_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "examinations", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.integer  "level"
    t.decimal  "score",         :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_group_id"
  end

  create_table "issues", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["user_id"], :name => "index_issues_on_user_id"

  create_table "item_groups", :force => true do |t|
    t.integer  "course_package_id"
    t.string   "name"
    t.integer  "position"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "course_type"
    t.integer  "quiz_level"
  end

  create_table "items", :force => true do |t|
    t.integer  "item_group_id"
    t.string   "name"
    t.integer  "lesson_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_id"
    t.string   "content_type"
  end

  create_table "mail_records", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.text     "mail"
    t.integer  "mail_id"
    t.boolean  "status"
    t.string   "title"
    t.string   "error_message"
    t.integer  "mail_template_id"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "varia_content"
  end

  create_table "mail_templates", :force => true do |t|
    t.string   "name"
    t.string   "variables"
    t.string   "description"
    t.text     "content"
    t.boolean  "in_use"
    t.string   "used_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_id"
    t.boolean  "msg_type"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "notices", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.boolean  "display"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oenglishes", :force => true do |t|
    t.string   "name"
    t.string   "video_url"
    t.string   "show_oenglish_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_results", :force => true do |t|
    t.integer  "test_result_id"
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.string   "answer_name"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "evaluation_activity_id"
  end

  add_index "question_results", ["test_result_id", "evaluation_activity_id"], :name => "by_test_and_skill"

  create_table "questions", :force => true do |t|
    t.string   "prompt"
    t.string   "sounds"
    t.string   "instruction_sounds"
    t.integer  "ordering"
    t.integer  "level_id"
    t.integer  "exposure"
    t.integer  "bank"
    t.decimal  "logit",                  :precision => 6, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_id"
    t.string   "instruction"
    t.integer  "evaluation_activity_id"
  end

  create_table "quizzes", :force => true do |t|
    t.string   "prompt"
    t.string   "sounds"
    t.integer  "position"
    t.integer  "level"
    t.string   "q_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "images"
    t.string   "course_type"
    t.integer  "course_id"
  end

  create_table "register_codes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "course_package_id"
    t.string   "code"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "valid_time"
    t.text     "desc1"
    t.text     "desc"
  end

  create_table "schedules", :force => true do |t|
    t.string   "title"
    t.datetime "course_start_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
    t.datetime "course_end_at"
    t.text     "description"
    t.integer  "customer_id"
    t.integer  "slide_id"
    t.integer  "teacher_id"
    t.string   "archive_id"
    t.string   "webex_id"
    t.string   "webex_pwd"
    t.integer  "content_id"
    t.string   "content_type"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "skill_results", :force => true do |t|
    t.integer  "evaluation_activity_id"
    t.integer  "level"
    t.integer  "score"
    t.integer  "test_result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slides", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lesson_id"
    t.boolean  "download"
    t.string   "course_type"
  end

  create_table "study_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_package_id"
    t.string   "course_type"
    t.string   "lesson_name"
    t.integer  "item_id"
  end

  add_index "study_records", ["lesson_id"], :name => "index_study_records_on_lesson_id"
  add_index "study_records", ["user_id"], :name => "index_study_records_on_user_id"

  create_table "sub_quiz_answers", :force => true do |t|
    t.integer  "sub_quiz_id"
    t.string   "title"
    t.boolean  "is_correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "images"
    t.string   "sounds"
  end

  create_table "sub_quizzes", :force => true do |t|
    t.integer  "quiz_id"
    t.string   "title"
    t.integer  "order_in_quiz"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "images"
    t.string   "sounds"
  end

  create_table "test_results", :force => true do |t|
    t.integer  "user_id"
    t.integer  "level"
    t.decimal  "score",       :precision => 6, :scale => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "skill_name"
    t.integer  "skill_level"
    t.integer  "skill_score"
  end

  create_table "thinkingcap_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "third_content_id"
    t.string   "thinkingcap_course_id"
    t.decimal  "score",                 :precision => 5,  :scale => 1
    t.decimal  "progress",              :precision => 5,  :scale => 1
    t.decimal  "duration",              :precision => 10, :scale => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "webex_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "schedule_id"
    t.datetime "join_at"
    t.datetime "leave_at"
    t.datetime "register_at"
    t.decimal  "duration",          :precision => 5, :scale => 1
    t.decimal  "attention_radio_1", :precision => 5, :scale => 1
    t.decimal  "attention_radio_2", :precision => 5, :scale => 1
    t.string   "ip_address"
    t.string   "client_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
