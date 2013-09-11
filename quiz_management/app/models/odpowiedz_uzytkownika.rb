# encoding: UTF-8
class OdpowiedzUzytkownika < ActiveRecord::Base
    self.table_name = 'odpowiedz_uzytkownika'

  def self.punkty(id_uz, id_pyt, data_wyslania)
    query = sanitize_sql(["select * from pkt_za_pytanie(%s,%s,'%s')", id_uz, id_pyt, data_wyslania])
    query_results = self.connection.execute(query)
    # Lol
    punkty_za_odpowiedz = query_results[0]["pkt_za_pytanie"]
		punkty_za_pytanie = Pytanie.find(id_pyt).pkt

    [punkty_za_odpowiedz, punkty_za_pytanie]
    #"(Puntacja #{query_results[0]["pkt_za_pytanie"]} / )"
  end
end
