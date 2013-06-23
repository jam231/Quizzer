class Uzytkownik < ActiveRecord::Base
  self.table_name = 'uzytkownik'
  self.primary_key = :id_uz
  has_many :quizy, :foreign_key => 'id_wlasciciela', :class_name => "Quiz"
  has_many :grupy, :foreign_key => 'id_wlasciciela', :class_name => "GrupaQuizowa"

  # Po co ?
  # Odsylam do http://blog.remarkablelabs.com/2012/12/strong-parameters-rails-4-countdown-to-2013
  attr_accessible :nazwa_uz, :login, :haslo, :email
end
