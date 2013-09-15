# encoding: UTF-8
class OdpowiedzUzytkownika < ActiveRecord::Base
    self.table_name = 'odpowiedz_uzytkownika'
    belongs_to :pytanie, :foreign_key => :id_pyt, :class_name => "Pytanie"
end
