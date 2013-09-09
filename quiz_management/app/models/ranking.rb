class Ranking < ActiveRecord::Base
  self.primary_keys = :id_uz, :id_grupy

  #Byc moze to zle modelowanie.

  has_one :uzytkownik, :foreign_key => 'id_uz', :class_name => "Uzytkownik"
  belongs_to :grupa, :foreign_key => 'id_grupy', :class_name => "GrupaQuizowa"
  self.table_name = 'ranking'




end
