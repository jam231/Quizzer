
milionerzy_lines = File.readlines("milionerzy").each { |line| line.strip! }

milionerzy_data = []
milionerzy_lines.each_with_index do |line, index|
	if index % 4 == 0 
		milionerzy_data[index / 4] = [line, []]
	else
		milionerzy_data[index / 4][1] << line		# [pytanie, [odpowiedz, ... ]] 
	end
end



quiz_sql = "INSERT INTO quiz(id_wlasciciela,nazwa, id_grupy) VALUES(1,'%{nazwa}',1);\n"
pytanie_sql = "INSERT INTO pytanie(tresc,id_typu,id_autora,id_quizu,id_kategorii) VALUES('%{tresc}',%{id_typu},1,%{id_quizu},1);\n"
odpowiedz_wzorcowa_sql = "INSERT INTO odpowiedz_wzorcowa(id_pyt, tresc_odp, poziom_poprawnosci) VALUES(%{id_pyt}, '%{tresc}', %{poprawnosc});\n"


id_typu_zamkniete4 = 4
id_typu_otwarte = 11


quizzes = File.new("losowe_quizy.sql", "w")

quizzes.write "--------------------------------------------- LOSOWE QUIZY --------------------------------------"
quizzes.write "\n\n"
quizzes.write "---------------------------------------------- MILIONERZY ---------------------------------------"
quizzes.write "\n"

milionerzy_liczba_quizow = 36

milionerzy_liczba_quizow.times do |i|
	quizzes.write( quiz_sql % {:nazwa => "milionerzy #{i + 1}"} )
end

# :-(
ostatnie_pytanie_id = 4
ostatni_quiz_id = 3
milionerzy_data.each_with_index do |pytanie, index|
	quizzes.write(pytanie_sql  % {:tresc => pytanie[0], 
								  :id_quizu => ostatni_quiz_id + (index % milionerzy_liczba_quizow), 
								  :id_typu => id_typu_zamkniete4})
	quizzes.write(odpowiedz_wzorcowa_sql % {:tresc => pytanie[1][0],
											:id_pyt => ostatnie_pytanie_id,
											:poprawnosc => 100})
	3.times do |i|
		quizzes.write(odpowiedz_wzorcowa_sql % {:tresc => pytanie[1][i + 1],
												:id_pyt => ostatnie_pytanie_id,
												:poprawnosc => 0})
	end
	ostatnie_pytanie_id += 1
end

ostatni_quiz_id += milionerzy_liczba_quizow

################################################################################################################################
quizzes.write "\n\n"
quizzes.write "---------------------------------------------- Nazwy filmow ---------------------------------------"
quizzes.write "\n"

nazwy_filmow_liczba_quizow = 35

nazwy_filmow_liczba_quizow.times do |i|
	quizzes.write( quiz_sql % {:nazwa => "Nazwy filmow #{i + 1}"} )
end

nazwy_filmow_lines = File.readlines("nazwy_filmow.txt").each {|line| line.strip!}
nazwy_filmow_data = []


nazwy_filmow_lines.each_with_index do |line, index|
	if index % 2 == 0 
		nazwy_filmow_data[index / 2] = [line, []]
	else
		nazwy_filmow_data[index / 2][1] << line		# [pytanie, [odpowiedz, ... ]] 
	end
end

nazwy_filmow_data.each_with_index do |pytanie, index|
	quizzes.write(pytanie_sql  % {:tresc => pytanie[0], 
								  :id_quizu => ostatni_quiz_id + (index % nazwy_filmow_liczba_quizow), 
								  :id_typu => id_typu_otwarte})
	quizzes.write(odpowiedz_wzorcowa_sql % {:tresc => pytanie[1][0],
											:id_pyt => ostatnie_pytanie_id,
											:poprawnosc => 100})
	ostatnie_pytanie_id += 1
end

ostatni_quiz_id += nazwy_filmow_liczba_quizow


################################################################################################################################
quizzes.write "\n\n"
quizzes.write "---------------------------------------------- Nazwy filmow ---------------------------------------"
quizzes.write "\n"

pierwiastki_liczba_quizow = 23

pierwiastki_liczba_quizow.times do |i|
	quizzes.write( quiz_sql % {:nazwa => "Pierwiastki #{i + 1}"} )
end

pierwiastki_lines = File.readlines("pierwiastki").each {|line| line.strip!}
pierwiastki_data = []


pierwiastki_lines.each_with_index do |line, index|
	if index % 2 == 0 
		pierwiastki_data[index / 2] = [line, []]
	else
		pierwiastki_data[index / 2][1] << line		# [pytanie, [odpowiedz, ... ]] 
	end
end

pierwiastki_data.each_with_index do |pytanie, index|
	quizzes.write(pytanie_sql  % {:tresc => pytanie[0], 
								  :id_quizu => ostatni_quiz_id + (index % pierwiastki_liczba_quizow), 
								  :id_typu => id_typu_zamkniete4})	
	quizzes.write(odpowiedz_wzorcowa_sql % {:tresc => pytanie[1][0],
											:id_pyt => ostatnie_pytanie_id,
											:poprawnosc => 100})
	ostatnie_pytanie_id += 1
end

ostatni_quiz_id += pierwiastki_liczba_quizow

puts "Wygenerowano #{ostatni_quiz_id - 3} quizow oraz #{ostatnie_pytanie_id - 4} pytan"

quizzes.close