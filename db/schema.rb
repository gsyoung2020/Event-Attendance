# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20_210_827_131_512) do
=======
ActiveRecord::Schema.define(version: 20_210_821_031_149) do
>>>>>>> parent of 4e67cbc... <database>removed unnecessary "start" and "end" columns because event model already has "start_time" and "end_time" columns
=======
ActiveRecord::Schema.define(version: 20_210_821_031_149) do
>>>>>>> parent of 4e67cbc... <database>removed unnecessary "start" and "end" columns because event model already has "start_time" and "end_time" columns
  create_table 'events', force: :cascade do |t|
    t.string 'description'
    t.string 'event_location'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'frequency'
<<<<<<< HEAD
<<<<<<< HEAD
=======
    t.datetime 'start'
    t.datetime 'end'
>>>>>>> parent of 4e67cbc... <database>removed unnecessary "start" and "end" columns because event model already has "start_time" and "end_time" columns
=======
    t.datetime 'start'
    t.datetime 'end'
>>>>>>> parent of 4e67cbc... <database>removed unnecessary "start" and "end" columns because event model already has "start_time" and "end_time" columns
    t.datetime 'start_time'
    t.datetime 'end_time'
  end

  create_table 'events_members', force: :cascade do |t|
    t.integer 'event_id', null: false
    t.integer 'member_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['event_id'], name: 'index_events_members_on_event_id'
    t.index ['member_id'], name: 'index_events_members_on_member_id'
  end

  create_table 'members', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'phone'
    t.date 'birthday'
    t.date 'anniversary'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'events_members', 'events'
  add_foreign_key 'events_members', 'members'
end
