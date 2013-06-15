insert into uzytkownik(login,haslo,nazwa_uz,email) VALUES('krzys15','konewka','Krzysztof Powazny','dat@mail.com');

insert into quiz(id_wlasciciela,nazwa,id_grupy,data_utworzenia) VALUES(2,'przykladowy quiz',1,CURRENT_TIMESTAMP);

delete from uzytkownik where id_uz=2;