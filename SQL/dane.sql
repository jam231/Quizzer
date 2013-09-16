DELETE FROM grupa_quizowa;
SELECT setval('grupa_quizowa_id_grupy_seq',1,false);

INSERT INTO grupa_quizowa(id_grupy, id_wlasciciela,nazwa,na_zaproszenie) VALUES(0, 0,'LIMBO',false);
INSERT INTO dostep_grupa(id_grupy,id_uz,prawa_dost) VALUES(0,1,B'1111111111111111');
INSERT INTO grupa_quizowa(id_wlasciciela,nazwa,na_zaproszenie) VALUES(1,'public',false);
INSERT INTO grupa_quizowa(id_wlasciciela,nazwa,na_zaproszenie) VALUES(1,'testowa',false);


INSERT INTO typ(nazwa, liczba_odp) VALUES('jednokrotny 2', 2);
INSERT INTO typ(nazwa, liczba_odp) VALUES('jednokrotny 3', 3);
INSERT INTO typ(nazwa, liczba_odp) VALUES('jednokrotny 4', 4);
INSERT INTO typ(nazwa, liczba_odp) VALUES('jednokrotny 5', 5);
INSERT INTO typ(nazwa, liczba_odp) VALUES('jednokrotny 6', 6);

INSERT INTO typ(nazwa, liczba_odp,wielokrotnego_wyboru) VALUES('wielokrotny 2', 2,true);
INSERT INTO typ(nazwa, liczba_odp,wielokrotnego_wyboru) VALUES('wielokrotny 3', 3,true);
INSERT INTO typ(nazwa, liczba_odp,wielokrotnego_wyboru) VALUES('wielokrotny 4', 4,true);
INSERT INTO typ(nazwa, liczba_odp,wielokrotnego_wyboru) VALUES('wielokrotny 5', 5,true);
INSERT INTO typ(nazwa, liczba_odp,wielokrotnego_wyboru) VALUES('wielokrotny 6', 6,true);

INSERT INTO typ(nazwa, liczba_odp) VALUES('otwarte', 1);


INSERT INTO kategoria(nazwa) VALUES('Pytania');

INSERT INTO quiz(id_wlasciciela, nazwa, id_grupy) VALUES(1, 'quiz testowy', 1);
INSERT INTO quiz(id_wlasciciela, nazwa, id_grupy) VALUES(1, 'quiz testowy', 2);

INSERT INTO pytanie(tresc,id_typu,id_autora,id_quizu,id_kategorii) VALUES('ABCD: zaznacz A',3,1,1,1);
INSERT INTO odpowiedz_wzorcowa(id_pyt, tresc_odp, poziom_poprawnosci) 
VALUES
(1,'A',100),
(1,'B',0),
(1,'C',0),
(1,'D',0);


INSERT INTO pytanie(tresc,id_typu,id_autora,id_quizu,id_kategorii) VALUES('ABC++: zaznacz BB',2,1,1,1);
INSERT INTO odpowiedz_wzorcowa(id_pyt, tresc_odp, poziom_poprawnosci) 
VALUES
(2,'AA',0),
(2,'BB',100),
(2,'CC',0),
(2,'DD',0);

INSERT INTO pytanie(tresc,id_typu,id_autora,id_quizu,id_kategorii) VALUES('wpisz abc',11,1,1,1);
INSERT INTO odpowiedz_wzorcowa(id_pyt, tresc_odp, poziom_poprawnosci) 
VALUES
(3,'abc',100),
(3,'cde',0),
(3,'efg',0),
(3,'ghi',40);