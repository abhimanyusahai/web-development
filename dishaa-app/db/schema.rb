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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170721162216) do

  create_table "attendances", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "grade_id"
    t.integer  "subject_id"
    t.date     "date"
    t.boolean  "present"
    t.boolean  "absent"
    t.boolean  "on_leave"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_attendances_on_grade_id"
    t.index ["student_id"], name: "index_attendances_on_student_id"
    t.index ["subject_id"], name: "index_attendances_on_subject_id"
  end

  create_table "eca_records", force: :cascade do |t|
    t.integer  "student_id"
    t.text     "eca_record"
    t.string   "doc_link"
    t.text     "doc_desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "teacher_id"
    t.index ["student_id"], name: "index_eca_records_on_student_id"
    t.index ["teacher_id"], name: "index_eca_records_on_teacher_id"
  end

  create_table "exam_types", force: :cascade do |t|
    t.string   "exam_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grade_subjects", force: :cascade do |t|
    t.integer  "grade_id"
    t.integer  "subject_id"
    t.integer  "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grade_id"], name: "index_grade_subjects_on_grade_id"
    t.index ["subject_id"], name: "index_grade_subjects_on_subject_id"
    t.index ["teacher_id"], name: "index_grade_subjects_on_teacher_id"
  end

  create_table "grades", force: :cascade do |t|
    t.string   "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marks", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "subject_id"
    t.integer  "exam_type_id"
    t.date     "date"
    t.float    "marks_achieved"
    t.float    "max_marks"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["exam_type_id"], name: "index_marks_on_exam_type_id"
    t.index ["student_id"], name: "index_marks_on_student_id"
    t.index ["subject_id"], name: "index_marks_on_subject_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.date     "date"
    t.string   "time"
    t.string   "venue"
    t.text     "agenda"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "grade_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "mentee_teacher_id"
    t.index ["grade_id"], name: "index_students_on_grade_id"
    t.index ["mentee_teacher_id"], name: "index_students_on_mentee_teacher_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string   "subject"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_id"
    t.string   "mobile_number"
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "address"
  end

end
