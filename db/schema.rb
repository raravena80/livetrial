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

ActiveRecord::Schema.define(:version => 20111117182720) do

  create_table "cloud_accounts", :force => true do |t|
    t.string   "provider"
    t.string   "username"
    t.string   "apikey"
    t.string   "privatekey"
    t.string   "certificate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trials", :force => true do |t|
    t.string   "customername"
    t.string   "customeremail"
    t.string   "instancename"
    t.integer  "instanceid"
    t.integer  "imageid"
    t.integer  "imageflavor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publicipaddr"
    t.string   "cloudaccount"
    t.string   "instancepw"
    t.string   "trialpw"
    t.string   "status"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
