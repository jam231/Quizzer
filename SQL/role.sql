----ROLE SQL
CREATE ROLE prawa_admina WITH CREATEDB CREATEROLE;
GRANT ALL ON ALL TABLES IN SCHEMA public TO prawa_admina;

CREATE ROLE prawa_moderatora;
GRANT ALL ON ALL TABLES IN SCHEMA public TO prawa_moderatora;

CREATE ROLE prawa_uzytkownika;
GRANT ALL ON ALL TABLES IN SCHEMA public TO prawa_uzytkownika;
REVOKE DELETE ON kategoria,podkategoria,typ FROM prawa_uzytkownika;
REVOKE INSERT ON kategoria,podkategoria,typ FROM prawa_uzytkownika;
REVOKE UPDATE ON kategoria,podkategoria,typ FROM prawa_uzytkownika;