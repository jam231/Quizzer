# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 0) do

  create_table "dostep_grupa", :id => false, :force => true do |t|
    t.integer "id_grupy",                                                 :null => false
    t.integer "id_uz",                                                    :null => false
    t.string  "prawa_dost", :limit => 16, :default => "1100000000000000", :null => false
  end

  create_table "dyskusja", :id => false, :force => true do |t|
    t.integer  "id_quizu",                     :null => false
    t.integer  "id_uz",                        :null => false
    t.string   "tresc",         :limit => nil, :null => false
    t.datetime "data_wyslania",                :null => false
  end

  create_table "grupa_quizowa", :primary_key => "id_grupy", :force => true do |t|
    t.integer "id_wlasciciela",               :null => false
    t.string  "nazwa",          :limit => 60, :null => false
    t.boolean "na_zaproszenie",               :null => false
    t.string  "haslo",          :limit => 30
  end

  add_index "grupa_quizowa", ["nazwa"], :name => "grupa_quizowa_nazwa_key", :unique => true

  create_table "kategoria", :primary_key => "id_kategorii", :force => true do |t|
    t.string "nazwa", :limit => 60, :null => false
  end

  add_index "kategoria", ["nazwa"], :name => "kategoria_nazwa_key", :unique => true

  create_table "odpowiedz_uzytkownika", :id => false, :force => true do |t|
    t.integer  "id_uz",                        :null => false
    t.string   "tresc_odp",     :limit => nil, :null => false
    t.integer  "id_pyt",                       :null => false
    t.datetime "data_wyslania",                :null => false
    t.boolean  "zaznaczona",                   :null => false
  end

  create_table "odpowiedz_wzorcowa", :id => false, :force => true do |t|
    t.integer  "id_pyt",                            :null => false
    t.string   "tresc_odp",          :limit => nil, :null => false
    t.integer  "poziom_poprawnosci",                :null => false
    t.string   "komentarz",          :limit => nil
    t.datetime "ost_modyfikacja"
  end

  create_table "podkategoria", :id => false, :force => true do |t|
    t.integer "id_nadkategorii", :null => false
    t.integer "id_podkategorii", :null => false
  end

  add_index "podkategoria", ["id_podkategorii"], :name => "podkategoria_id_podkategorii_key", :unique => true

  create_table "pytanie", :primary_key => "id_pyt", :force => true do |t|
    t.string  "tresc",        :limit => nil,                  :null => false
    t.integer "id_typu",                                      :null => false
    t.integer "id_autora",                                    :null => false
    t.float   "pkt",                         :default => 1.0, :null => false
    t.integer "id_quizu",                                     :null => false
    t.integer "id_kategorii",                                 :null => false
  end

  create_table "quiz", :primary_key => "id_quizu", :force => true do |t|
    t.integer  "id_wlasciciela",                                :null => false
    t.string   "nazwa",           :limit => 60,                 :null => false
    t.integer  "id_grupy",                       :default => 1, :null => false
    t.integer  "limit_podejsc"
    t.string   "limit_czasowy",   :limit => nil
    t.datetime "data_utworzenia",                               :null => false
  end

  create_table "ranking", :id => false, :force => true do |t|
    t.integer "id_uz",                     :null => false
    t.integer "id_grupy",                  :null => false
    t.float   "pkt",      :default => 0.0, :null => false
  end

  create_table "typ", :primary_key => "id_typu", :force => true do |t|
    t.string  "nazwa",                :limit => 60,                    :null => false
    t.integer "liczba_odp",                                            :null => false
    t.boolean "wielokrotnego_wyboru",               :default => false, :null => false
  end

  add_index "typ", ["nazwa"], :name => "typ_nazwa_key", :unique => true

  create_table "uzytkownik", :primary_key => "id_uz", :force => true do |t|
    t.string "login",    :limit => 15,                           :null => false
    t.string "haslo",    :limit => 30,                           :null => false
    t.string "nazwa_uz", :limit => 30,                           :null => false
    t.string "email",    :limit => 60,                           :null => false
    t.string "ranga",    :limit => 30, :default => "uľytkownik", :null => false
  end

  add_index "uzytkownik", ["email"], :name => "uzytkownik_email_key", :unique => true
  add_index "uzytkownik", ["login"], :name => "uzytkownik_login_key", :unique => true
  add_index "uzytkownik", ["nazwa_uz"], :name => "uzytkownik_nazwa_uz_key", :unique => true

end
