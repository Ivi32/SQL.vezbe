--Dodati novog radnika Boban na mesto analiticara u odeljenje broj 30, sa identifikacionim brojem 658.

INSERT INTO radnik (idbr, ime, posao, broj_odeljenja) VALUES (658, 'Boban', 'analitičar', 30);



--Bobanu dodati datum kada se zaposlio, koja mu je plata (2500), kao I koja mu je kvalifikacija (VSS).

UPDATE radnik SET datum_zaposlenja = '1990-01-01', plata= 2500, kvalifikacija='VSS' WHERE idbr=658;

--Bobanu postaviti Marka kao neposrednog rukovodioca.
UPDATE radnik set rukovodilac = ( SELECT idbr FROM radnik WHERE ime='Marko') WHERE idbr=658;

-- druga grupa zadataka
--1.Pokazati Bobanov identifikacioni broj, platu.

SELECT idbr, plata FROM radnik
WHERE ime='Boban';

2.Prikaži ime, posao i platu zaposlenih u odeljenju 30, čija je plata veća od 2000.

SELECT ime, posao, plata 
FROM radnik 
WHERE broj_odeljenja=30 AND plata >2000;

3.Napisati upit koji vraća ime i posao zaposlenih koji nemaju svog rukovodioca.

SELECT ime, posao 
FROM radnik 
WHERE rukovodilac IS NULL;

SELECT* FROM radnik;

--treca grupa zadataka

--1.Prikazati ime, posao i kvalifikaciju zaposlenih 
--koji obavljaju posao upravnika ili savetnika, 
--a zaposleni su u odeljenju 20.

SELECT ime, posao, kvalifikacija
FROM radnik
WHERE (posao = 'upravnik' OR posao = 'savetnik')
AND broj_odeljenja=20;

--2.Prikazati imena zaposlenih čije pocetno ime ne sadrži slovo a.

SELECT ime FROM radnik WHERE ime NOT LIKE 'A%';

--3.Prikazati ime, platu i premiju zaposlenih koji obavljaju posao vozača. 
--Rezultate urediti po premiji u opadajućem redosledu.

SELECT ime, plata, premija
FROM radnik
WHERE posao = 'vozač'
ORDER BY premija DESC;

--cetvrta grupa zadataka
--1.Prikaži ime, kvalifikaciju, platu i premiju zaposlenih koji imaju premiju.
SELECT ime, kvalifikacija, plata, premija
FROM radnik
WHERE premija IS NOT NULL;

--2.Prikaži najmanju, najveću, srednju platu i broj zaposlenih u celom preduzeću, 
--sa zaokruživanjem na dve decimale.
SELECT MIN(plata), MAX(plata), ROUND(AVG(plata),2), COUNT(idbr)
FROM radnik;

--3.Napisati upit koji vraća ime, posao i broj odeljenja zaposlenih 
--čije ime počinje slovom M ili sadrži slovo a.

SELECT ime, posao, broj_odeljenja
FROM radnik
WHERE ime LIKE 'M%'
OR ime ILIKE '%a%';

--peta grupa
--1.Prikazati imena zaposlenih, platu I premiju, 
--koji nemaju premiju unesenu ili im je 0, po imenima u rastucem redosledu.
SELECT ime, plata, premija
FROM radnik
WHERE premija IS NULL OR premija = 0
ORDER BY ime ASC;

--2.Napisati upit koji za svaku kvalifikaciju vraca minimalnu I maksimalnu platu. 
--U proracun ukljuciti samo radnike iz odeljenja 10 I 20.
SELECT kvalifikacija, MIN(plata), MAX(plata)
FROM radnik 
WHERE broj_odeljenja IN (10,20)
GROUP BY kvalifikacija;

--3.Prikazati imena odeljenja u kojima su primanja svih radnika u odeljenju manja od 9000. (Nested)

SELECT broj_odeljenja
FROM radnik 
GROUP BY broj_odeljenja
HAVING SUM(plata)<9000;

SELECT ime_odeljenja FROM odeljenje WHERE broj_odeljenja IN(10,20,30);

SELECT ime_odeljenja 
FROM odeljenje 
WHERE broj_odeljenja IN (
	SELECT broj_odeljenja 
	FROM radnik 
	GROUP BY broj_odeljenja
	HAVING SUM(plata)<9000);
						 
--1. Prikazati imena svih radnika čija je plata manja od prosečnih plate u odeljenju, 
--čije je sedište u Starom Gradu. (Nested)
SELECT broj_odeljenja  
FROM odeljenje 
WHERE mesto='Stari Grad';

SELECT AVG(plata)
FROM radnik
WHERE broj_odeljenja = 30

SELECT ime FROM radnik WHERE plata < (SELECT AVG(plata)
FROM radnik
WHERE broj_odeljenja IN (SELECT broj_odeljenja  
FROM odeljenje 
WHERE mesto='Stari Grad'));

SELECT ime 
FROM radnik 
WHERE plata<(SELECT AVG(plata) 
			 FROM radnik 
			 WHERE broj_odeljenja IN (
				 SELECT broj_odeljenja  
				 FROM odeljenje 
				 WHERE mesto='Stari Grad'));

SELECT ime 
FROM radnik 
WHERE plata < (
	SELECT AVG(plata) 
	FROM radnik 
	WHERE broj_odeljenja IN (
		SELECT broj_odeljenja 
		FROM odeljenje 
		WHERE mesto ='Stari Grad'));


--2.Izlistaj sve podatke o odeljenjima i radnicima za odeljenja čija imena počinju slovima d ili r. (Join)

SELECT o.*, r.* 
FROM odeljenje AS o
JOIN radnik AS r
ON o.broj_odeljenja=r.broj_odeljenja
WHERE o.ime_odeljenja LIKE 'D%' OR o.ime_odeljenja LIKE 'R%';

--3.Prikazati imena radnika i imena njihovih neposrednih rukovodilaca (Join)

2. SELECT o.*, r.* FROM odeljenje AS o
JOIN radnik AS r ON o.broj_odeljenja = r.broj_odeljenja
WHERE o.ime_odeljenja ILIKE 'd%' OR o.ime_odeljenja ILIKE 'r%';

--3.Prikazati imena radnika i imena njihovih neposrednih rukovodilaca (Join)

SELECT r1.ime AS radnici, r2.ime AS rukovodioci 
FROM radnik as r1
JOIN radnik AS r2 
	ON r1.rukovodilac=r2.idbr;

--Napisati upit koji prikazuje ime projekta i prosečan broj sati učešća (zaokružen na 2 decimale) 
--svih zaposlenih za projekte na kojima je ukupan broj sati angažovanja između 5000 i 10000. (Join)

SELECT p.imeproj, ROUND(AVG(u.broj_sati),2)
FROM projekat as p
JOIN ucesce as u
	ON p.broj_projekta=u.broj_projekta
GROUP BY p.imeproj
HAVING SUM(u.broj_sati) BETWEEN 5000 AND 10000;

--2.Napisati upit koji vraća ime radnika, ime projekta na kojima radi, 
--ali samo za radnike čija je kvalifikacija KV ili VKV.(Join)
SELECT r.ime, p.imeproj
FROM radnik AS r 
JOIN ucesce as u
	ON r.idbr=u.idbr
JOIN projekat as p
	ON u.broj_projekta=p.broj_projekta
WHERE r.kvalifikacija IN('KV','VKV');

--3.Napisati upit koji vraća za svako odeljenje ukupan broj radnika koji primaju premiju (veća od 0).
SELECT broj_odeljenja, COUNT(idbr)
FROM radnik
WHERE premija IS NOT NULL AND premija >0
GROUP BY broj_odeljenja;







