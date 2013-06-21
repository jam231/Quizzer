DELETE FROM grupa_quizowa;
SELECT setval('grupa_quizowa_id_grupy_seq',1,false);

INSERT INTO grupa_quizowa(id_wlasciciela,nazwa,na_zaproszenie) VALUES(1,'public',false);
INSERT INTO dostep_grupa(id_grupy,id_uz,prawa_dost) VALUES(1,1,B'1111111111111111');
INSERT INTO typ(nazwa, liczba_odp) VALUES('jednokrotny 4', 4);
INSERT INTO kategoria(nazwa) VALUES('Pytania');

INSERT INTO quiz(id_wlasciciela, nazwa, id_grupy) VALUES(1, 'quiz testowy', 1);

INSERT INTO pytanie(tresc,id_typu,id_autora,id_quizu,id_kategorii) VALUES('zaznacz A',1,1,1,1);

INSERT INTO odpowiedz_wzorcowa(id_pyt, tresc_odp, poziom_poprawnosci) 
VALUES
(1,'A',100),
(1,'B',100),
(1,'C',100),
(1,'D',100);