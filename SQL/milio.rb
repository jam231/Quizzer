#gem install jdbc-postgres
#gem install sequel

require 'Sequel'
require 'jdbc/postgres'

DB = Sequel.connect('jdbc:postgresql://localhost:5432/quizy?user=postgres&password=password')

class Quiz < Sequel::Model(:quiz)

end

class Pytanie < Sequel::Model(:pytanie)

end

class OdpowiedzWzorcowa < Sequel::Model(:odpowiedz_wzorcowa)

end



f = File.open('milionerzy')


puts "INSERT INTO kategoria(nazwa) VALUES('milionerzy');"
typ = DB[:typ].where(:liczba_odp => 4, :wielokrotnego_wyboru => false).first[:id_typu]

quiz = Quiz.create(:id_wlasciciela => 1, :nazwa => 'Milionerzy', :id_grupy => 1, :ukryty => false)

puts 'utworzono quiz '+quiz.id_quizu.to_s


while not f.eof?
	pytanie = Pytanie.create(:tresc => f.gets.strip, :id_typu => typ, :id_autora => 1, :id_quizu => quiz.id_quizu, :id_kategorii => 1)
	#puts "INSERT INTO pytanie(tresc, id_typu, id_autora, pkt, id_quizu, id_kategorii) VALUES('#{f.gets.strip}',#{typ},1,1,1,@QUIZ_MILIONERZY@,1);"
#	puts "Pytanie :" + pytanie
	OdpowiedzWzorcowa.create(:id_pyt => pytanie.id_pyt, :tresc_odp => f.gets.strip, :poziom_poprawnosci => 100)

	3.times { OdpowiedzWzorcowa.create(:id_pyt => pytanie.id_pyt, :tresc_odp => f.gets.strip, :poziom_poprawnosci => 0)}
end

=begin
 id_pyt |                  tresc                   | id_typu | id_autora | pkt |
 id_quizu | id_kategorii | ukryty
--------+------------------------------------------+---------+-----------+-----+

 id_odp_w | id_pyt |        tresc_odp         | poziom_poprawnosci |
  komentarz               |     ost_modyfikacja
  
  
  quiz 
  id_quizu | id_wlasciciela |    nazwa     | id_grupy | limit_podejsc | limit_cza
sowy |     data_utworzenia     | ukryty
=end