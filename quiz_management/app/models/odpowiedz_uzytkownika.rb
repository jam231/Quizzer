class OdpowiedzUzytkownika < ActiveRecord::Base
    self.table_name = 'odpowiedz_uzytkownika'

  def self.punkty(id_uz, id_pyt, data_wyslania)
    self.connection.execute(sanitize_sql(["select * from pkt_za_pytanie(%s,%s,'%s')", id_uz, id_pyt, data_wyslania]))
  end
end
