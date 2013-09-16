# encoding: UTF-8
class OdpowiedzWzorcowa < ActiveRecord::Base
  self.table_name = 'odpowiedz_wzorcowa'
  self.primary_key = :id_odp_w
  belongs_to :pytanie, :foreign_key => :id_pyt, :class_name => "Pytanie"

  attr_accessible :ost_modyfikacja, :komentarz, :poziom_poprawnosci, :id_pyt, :tresc_odp, :id_odp_w

  validates_presence_of :tresc_odp, :message => "Treść odpowiedzi nie może być pusta"
  validates_presence_of :poziom_poprawnosci, :message => "Poziom poprawności musi być określony"
  validates_inclusion_of :poziom_poprawnosci, :in => 0..100, :message => "Poziom poprawności musi być wartością między 0 a 100"
end
