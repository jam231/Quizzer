class OdpowiedzWzorcowa < ActiveRecord::Base
  self.table_name = 'odpowiedz_wzorcowa'
  self.primary_keys = :id_pyt, :tresc_odp
  belongs_to :pytanie

  attr_accessible :ost_modyfikacja, :komentarz, :poziom_poprawnosci, :id_pyt, :tresc_odp


end
