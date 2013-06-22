CREATE TABLE uzytkownik(
	id_uz		SERIAL PRIMARY KEY,
	login		VARCHAR(15) UNIQUE NOT NULL,
	haslo		VARCHAR(30) NOT NULL,
	nazwa_uz	VARCHAR(30) UNIQUE NOT NULL,
	email		VARCHAR(60) UNIQUE NOT NULL,
	ranga		VARCHAR(30) NOT NULL DEFAULT 'użytkownik'
);

CREATE TABLE grupa_quizowa(
	id_grupy		SERIAL PRIMARY KEY,
	id_wlasciciela	INTEGER NOT NULL REFERENCES uzytkownik(id_uz),
	nazwa			VARCHAR(60) UNIQUE NOT NULL,
	na_zaproszenie	BOOLEAN NOT NULL,
	haslo			VARCHAR(30)
);

CREATE TABLE quiz(
	id_quizu		SERIAL PRIMARY KEY,
	id_wlasciciela	INTEGER NOT NULL REFERENCES uzytkownik(id_uz),
	nazwa			VARCHAR(60) NOT NULL,
	id_grupy		INTEGER NOT NULL DEFAULT 1 REFERENCES grupa_quizowa(id_grupy) ON DELETE CASCADE,
	limit_podejsc	INTEGER,
	limit_czasowy	INTERVAL,
	data_utworzenia	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
	
CREATE TABLE dyskusja(
	id_quizu		INTEGER NOT NULL REFERENCES quiz(id_quizu) ON DELETE CASCADE,
	id_uz			INTEGER NOT NULL REFERENCES uzytkownik(id_uz),
	tresc			VARCHAR NOT NULL,
	data_wyslania	TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE dostep_grupa(
	id_grupy	INTEGER NOT NULL REFERENCES grupa_quizowa(id_grupy) ON DELETE CASCADE,
	id_uz		INTEGER NOT NULL REFERENCES uzytkownik(id_uz) ON DELETE CASCADE,
	prawa_dost	BIT(16) NOT NULL DEFAULT B'1100000000000000'
	--SPECYFIKACJA PRAW DOSTEPU OD NAJWIEKSZEGO BITU (get_bit, rzutowanie dziala od najw.):
		--uczestnictwo w quizach
		--uczestnictwo w dyskusji
		--tworzenie quizow
		--modyfikacja i usuwanie quizow
		--modyfikacja i usuwanie w dyskusji
);

CREATE TABLE typ(
	id_typu		SERIAL PRIMARY KEY,
	nazwa		VARCHAR(60) UNIQUE NOT NULL,
	liczba_odp	INTEGER NOT NULL,
	wielokrotnego_wyboru BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE kategoria(
	id_kategorii	SERIAL PRIMARY KEY,
	nazwa			VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE pytanie(
	id_pyt			SERIAL PRIMARY KEY,
	tresc			VARCHAR NOT NULL,
	id_typu			INTEGER NOT NULL REFERENCES typ(id_typu),
	id_autora		INTEGER NOT NULL REFERENCES uzytkownik(id_uz),
	pkt				REAL NOT NULL DEFAULT 1.00,
	id_quizu		INTEGER NOT NULL REFERENCES quiz(id_quizu),
	id_kategorii 	INTEGER NOT NULL REFERENCES kategoria(id_kategorii)
);

CREATE TABLE podkategoria(
	id_nadkategorii INTEGER NOT NULL REFERENCES kategoria(id_kategorii),
	id_podkategorii	INTEGER NOT NULL REFERENCES kategoria(id_kategorii) UNIQUE
);

CREATE TABLE odpowiedz_wzorcowa(
	id_pyt				INTEGER NOT NULL REFERENCES pytanie(id_pyt) ON DELETE CASCADE,
	tresc_odp			VARCHAR NOT NULL,
	poziom_poprawnosci	INTEGER NOT NULL,
	komentarz			VARCHAR,
	ost_modyfikacja		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id_pyt,tresc_odp),
	CONSTRAINT wk_p_poprawnosci CHECK (poziom_poprawnosci >= 0 AND poziom_poprawnosci <= 100)
);

CREATE TABLE odpowiedz_uzytkownika(
	id_uz				INTEGER NOT NULL REFERENCES uzytkownik(id_uz) ON DELETE CASCADE,
	tresc_odp			VARCHAR NOT NULL,
	id_pyt				INTEGER NOT NULL REFERENCES pytanie(id_pyt) ON DELETE CASCADE,
	data_wyslania		TIMESTAMP NOT NULL,
	zaznaczona			BOOLEAN NOT NULL,
	CONSTRAINT fk_odp_uzytkownika FOREIGN KEY (id_pyt, tresc_odp) 
		REFERENCES odpowiedz_wzorcowa(id_pyt, tresc_odp)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE ranking(
	id_uz		INTEGER NOT NULL REFERENCES uzytkownik(id_uz) ON DELETE CASCADE,
	id_grupy	INTEGER NOT NULL REFERENCES grupa_quizowa(id_grupy) ON DELETE CASCADE,
	pkt			REAL NOT NULL DEFAULT 0.00
);


----DANE KONFLIKTUJACE Z WYZWALACZAMI
DELETE FROM uzytkownik;
INSERT INTO uzytkownik(id_uz,login,haslo,nazwa_uz,ranga,email) VALUES(0,'limbo','bardzotajemnehaslo','Uzytkownik usuniety',0,'costam');

SELECT setval('uzytkownik_id_uz_seq',1,false);
INSERT INTO uzytkownik(login,haslo,nazwa_uz,ranga,email) VALUES('admin','h_admina','Administrator',1,'pokoj42@czysciec.de');

----WYZWALACZE I FUNKCJE
CREATE OR REPLACE FUNCTION uzytkownik_on_insert() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO dostep_grupa(id_uz,id_grupy) VALUES(new.id_uz,1); --1 jest uznawane za grupe public
	return new;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER dodaj_do_public AFTER INSERT ON uzytkownik
	FOR EACH ROW EXECUTE PROCEDURE uzytkownik_on_insert();


	
CREATE OR REPLACE FUNCTION dostep_grupa_on_insert() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO ranking(id_uz,id_grupy) VALUES(new.id_uz,new.id_grupy);
	return new;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER dodaj_ranking AFTER INSERT ON dostep_grupa
	FOR EACH ROW EXECUTE PROCEDURE dostep_grupa_on_insert();


	
CREATE OR REPLACE FUNCTION kategoria_on_delete() RETURNS TRIGGER AS $$
DECLARE
	nadkategoria integer;
BEGIN
	nadkategoria := (SELECT id_nadkategorii FROM kategoria WHERE id_podkategorii=old.id_kategorii);
	UPDATE podkategoria SET id_nadkategorii=nadkategoria WHERE id_nadkategorii=old.id_kategorii;
	UPDATE pytanie_kategoria SET id_kategorii=nadkategoria WHERE id_kategorii=old.id_kategorii;
	RETURN old;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER naprawianie_kategorii BEFORE DELETE ON kategoria
	FOR EACH ROW EXECUTE PROCEDURE kategoria_on_delete();
	
	
	
	
CREATE OR REPLACE FUNCTION uzytkownik_on_delete() RETURNS TRIGGER AS $$
BEGIN
	UPDATE pytanie	SET id_autora=0 WHERE id_autora=old.id_uz;
	UPDATE dyskusja	SET id_uz=0 	WHERE id_uz=old.id_uz;
	UPDATE quiz		SET id_wlasciciela=0 WHERE  id_wlasciciela=old.id_uz;
	UPDATE grupa_quizowa	SET id_wlasciciela=0	WHERE id_wlasciciela=old.id_uz;
	RETURN old;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER zmiana_autora BEFORE DELETE ON uzytkownik
	FOR EACH ROW EXECUTE PROCEDURE uzytkownik_on_delete();
	
	
CREATE OR REPLACE FUNCTION usun_dane_uz(id integer) RETURNS VOID AS $$
BEGIN
	DELETE FROM pytanie WHERE id_autora=id;
	DELETE FROM dyskusja WHERE id_uz=id;
	DELETE FROM quiz WHERE id_wlasciciela=id;
	DELETE FROM grupa_quizowa WHERE id_wlasciciela=id;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION podlicz_punkty(uzytkownik integer,i_quiz integer,czas TIMESTAMP) RETURNS VOID AS $$
DECLARE
	suma integer;
	za_pytanie real;
	grupa integer;
	ulamek real;
	pyt integer;
BEGIN
	--PYTANIA PROSTE DO LICZENIA
	suma := (SELECT SUM(pkt) FROM 
		odpowiedz_uzytkownika ou JOIN odpowiedz_wzorcowa op ON(ou.id_pyt=op.id_pyt AND ou.tresc_odp=op.tresc_odp) 
		JOIN pytanie ON(ou.id_pyt=pytanie.id_pyt) 
		WHERE ou.id_uz=uzytkownik AND quiz.id_quizu=i_quiz AND czas=ou.data_wyslania
		AND pytanie.id_typu NOT IN (SELECT id_typu FROM typ WHERE nazwa LIKE '%wielokrotn%'));
		
	--PYTANIA WIELOKROTNEGO WYBORU
	FOR pyt IN 
		SELECT id_pyt FROM pytanie 
		WHERE id_quizu = i_quiz
		AND id_typu IN (SELECT id_typu FROM typ WHERE nazwa LIKE '%wielokrotn%')
	LOOP
		za_pytanie := (SELECT pkt::real FROM pytanie WHERE pytanie.id_pyt=pyt);
		ulamek := (SELECT za_pytanie/(liczba_odp::real) FROM pytanie JOIN typ USING(id_typu) WHERE pytanie.id_pyt=pyt);
		za_pytanie := za_pytanie -
			(SELECT 
				(CASE WHEN (zaznaczona=FALSE AND poziom_poprawnosci=100) OR (zaznaczona=TRUE AND poziom_poprawnosci=0) THEN ulamek ELSE 0.00 END) 
				FROM odpowiedz_uzytkownika ou JOIN odpowiedz_wzorcowa op ON(ou.id_pyt=op.id_pyt AND ou.tresc_odp=op.tresc_odp) 
				WHERE ou.id_pyt = pyt AND ou.id_uz=uzytkownik AND ou.data_wyslania=czas);
		suma := suma + za_pytanie;
	END LOOP;
	
	grupa := (SELECT id_grupy FROM quiz WHERE quiz.id_quizu=i_quiz);
	
	UPDATE ranking SET pkt=pkt+suma WHERE id_uz=uzytkownik AND id_grupy=grupa;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION odpowiedzi(pytanie integer) RETURNS SETOF odpowiedz_wzorcowa AS 
$$
BEGIN
	RETURN QUERY SELECT * FROM odpowiedz_wzorcowa WHERE id_pyt=pytanie ORDER BY RANDOM();
END
$$ LANGUAGE plpgsql;