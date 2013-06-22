class Uzytkownik < ActiveRecord::Base
  self.table_name = 'uzytkownik'
  self.primary_key = :id_uz
  has_many :quizy, :foreign_key => 'id_wlasciciela', :class_name => "Quiz"
  has_many :grupy, :foreign_key => 'id_wlasciciela', :class_name => "GrupaQuizowa"
end
