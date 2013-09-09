class OdpowiedzUzytkownika < ActiveRecord::Base
    self.table_name = 'odpowiedz_uzytkownika'

  def self.punkty(id_uz, id_pyt, data_wyslania)
    query = sanitize_sql(["select * from pkt_za_pytanie(%s,%s,'%s')", id_uz, id_pyt, data_wyslania])
    query_results = self.connection.execute(query)
    "("+query_results[0]["pkt_za_pytanie"].to_s+" punktow)"
  end
end
