--Prikazati ime i posao svih radnika koji rade na Novom Beogradu.

SELECT broj_odeljenja FROM odeljenje WHERE mesto= 'Novi Beograd';
SELECT ime, posao FROM radnik WHERE broj_odeljenja=10;

SELECT ime, posao FROM radnik WHERE broj_odeljenja IN (SELECT broj_odeljenja FROM odeljenje 
													   WHERE mesto= 'Novi Beograd')
SELECT r.ime, r.posao
FROM radnik as r
JOIN odeljenje as o
ON r.broj_odeljenja = o.broj_odeljenja
WHERE mesto = 'Novi Beograd';

--	Prikazati ime i kvalifikaciju svih radnika koji rade na istim projektima kao Marko.


SELECT DISTINCT r.ime, r.kvalifikacija
FROM radnik AS r
JOIN ucesce as u
ON r.idbr = u.idbr 
WHERE u.broj_projekta IN (SELECT broj_projekta
							FROM (SELECT r.ime, r.kvalifikacija, u.broj_projekta 
	  						FROM radnik AS r
							JOIN ucesce as u
							ON r.idbr = u.idbr)as tabela
							WHERE ime = 'Marko');							
							



SELECT idbr FROM radnik WHERE ime='Marko';
SELECT broj_projekta FROM ucesce WHERE idbr=6234;
SELECT idbr FROM ucesce WHERE broj_projekta IN(100,200,300);

SELECT ime, kvalifikacija 
FROM radnik 
WHERE idbr IN(
	SELECT idbr 
	FROM ucesce 
	WHERE broj_projekta IN(
		SELECT broj_projekta FROM ucesce 
		WHERE idbr IN(SELECT idbr FROM radnik WHERE ime='Marko')));
																						 
--Prikazati sve podatke o zaposlenima koji ne rade ni na jednom projektu.


SELECT * FROM radnik WHERE idbr NOT IN (SELECT idbr FROM ucesce);

--Prikazati sve radnike koji rade na odeljenju sa nazivom ‘Komercijala’

SELECT r.ime FROM radnik AS r
JOIN odeljenje AS o
ON r.broj_odeljenja=o.broj_odeljenja
WHERE o.ime_odeljenja='Komercijala';

SELECT broj_odeljenja FROM odeljenje WHERE ime_odeljenja = 'Komercijala';
SELECT ime FROM radnik WHERE broj_odeljenja = 10;
SELECT ime FROM radnik WHERE broj_odeljenja IN (SELECT broj_odeljenja 
												FROM odeljenje 
												WHERE ime_odeljenja = 'Komercijala');




--5.Prikazati ime radnika, platu i mesto u kome rade za sve radnike 
--čija je plata između 1 500 i 2 500 (uključujući i te vrednosti) 
--i čije ime ne sadrži slovo e. 
--Rezultate poređati po plati u opadajućem, a zatim po imenu u rastućem redosledu.

SELECT r.ime, r.plata, o.mesto 
FROM radnik AS r
JOIN odeljenje AS o
ON r.broj_odeljenja=o.broj_odeljenja
WHERE r.plata BETWEEN 1500 AND 2500
AND r.ime NOT ILIKE '%e%'
ORDER BY r.plata DESC, r.ime ASC;


