# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100314192156) do

  create_table "activities", :force => true do |t|
    t.string   "type"
    t.integer  "recruit_id"
    t.datetime "scheduled_for"
    t.datetime "completed_at"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary   "data",       :limit => 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "filename"
    t.integer  "size"
    t.string   "content_type"
    t.integer  "recruit_id"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_activities", :force => true do |t|
    t.integer "activity_id"
    t.integer "employee_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "facebook_uid"
    t.string   "facebook_session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "recruit_id"
    t.integer  "activity_id"
    t.text     "body"
    t.float    "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recruits", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "referrer"
    t.text     "how_found"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
