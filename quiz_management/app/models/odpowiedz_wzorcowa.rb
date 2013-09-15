# encoding: UTF-8
class OdpowiedzWzorcowa < ActiveRecord::Base
  self.table_name = 'odpowiedz_wzorcowa'
  self.primary_key = :id_odp_w
  belongs_to :pytanie, :foreign_key => :id_pyt, :class_name => "Pytanie"

  attr_accessible :ost_modyfikacja, :komentarz, :poziom_poprawnosci, :id_pyt, :tresc_odp, :id_odp_w

end
