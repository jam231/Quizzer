# encoding: UTF-8
class OdpowiedzUzytkownika < ActiveRecord::Base
    self.table_name = 'odpowiedz_uzytkownika'
    self.primary_key = :id_odp_u

    attr_accessible :id_uz, :zaznaczona, :data_wyslania, :id_pyt, :tresc_odp, :id_odp_u
end
