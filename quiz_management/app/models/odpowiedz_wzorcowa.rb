class OdpowiedzWzorcowa < ActiveRecord::Base
  self.table_name = 'odpowiedz_wzorcowa'
  belongs_to :pytanie


end
