--Napisati upit koji vraća ime i broj odeljenja zaposlenih koji rade u odeljenju 10 ili 20, 
--a kvalifikacija im je VKV.

SELECT ime, broj_odeljenja
FROM radnik
WHERE broj_odeljenja IN (10,20)
AND kvalifikacija='VKV';

Napisati upit koji vraća ime i posao zaposlenih koji nemaju svog rukovodioca.

SELECT ime, posao
FROM radnik
WHERE rukovodilac IS NULL;

SELECT * FROM radnik;

--Napisati upit koji za svaku kvalifikaciju vraća minimalnu i maksimalnu platu. 
--U proračun uključiti samo radnike iz odeljenja 10 i 20.

SELECT kvalifikacija, MIN(plata), MAX(plata)
FROM radnik
WHERE broj_odeljenja IN(10,20)
GROUP BY kvalifikacija;

--Napisati upit koji vraća za svako odeljenje ukupan broj radnika koji primaju premiju (veća od 0).

SELECT broj_odeljenja, COUNT(idbr)
FROM radnik
WHERE premija>0
GROUP BY broj_odeljenja;

--Prikazati ime, posao i kvalifikaciju zaposlenih koji su zaposleni 17.12.1990 godine.

SELECT ime, posao, kvalifikacija
FROM radnik
WHERE datum_zaposlenja = '1990-12-17';

--Prikazati ime, datum zaposlenja, platu, premiju i broj odeljenja 
--za zaposlene koji imaju platu između 1 000 i 2 000 (uključujući i te vrednosti).

SELECT ime, datum_zaposlenja, plata, premija, broj_odeljenja
FROM radnik
WHERE plata BETWEEN 1000 AND 2000;
--Prikazati broj odeljenja, ime odeljenja i mesto 
--za odeljenja čije mesto počinje slovom P ili slovom D.

SELECT broj_odeljenja, ime_odeljenja, mesto
FROM odeljenje
WHERE mesto LIKE 'P%'
OR mesto LIKE 'D%';

--Prikazati za svaki posao ukupnu platu radnika koji ga obavljaju. 
--Rezultate urediti po ukupnim primanjima u opadajućem redosledu.

SELECT posao, SUM(plata)
FROM radnik
GROUP BY posao
ORDER BY 2 DESC;
--Napisati upit koji vraća ime zaposlenog, posao zaposlenog i broj sati učećšća na projektu,
--ali samo za učešća čiji je broj sati manji od 1500. (JOIN)

SELECT r.ime, r.posao, u.broj_sati
FROM radnik as r
JOIN ucesce as u
ON r.idbr=u.idbr
WHERE u.broj_sati < 1500;
--Napisati upit koji prikazuje ime projekta i prosečan broj sati učešća (zaokružen na 2 decimale) 
--svih zaposlenih za projekte na kojima je ukupan broj sati angažovanja između 5000 i 10000. (JOIN)

SELECT p.imeproj, ROUND(AVG(u.broj_sati),2)
FROM projekat AS p
JOIN ucesce AS u
ON p.broj_projekta=u.broj_projekta
GROUP BY p.imeproj
HAVING SUM(u.broj_sati) BETWEEN 5000 AND 10000;
--Prikazati imena zaposlenih i imena projekata 
--za zaposlene koji imaju funkciju savetnika na projektu 
--i čija je plata veća od srednje vrednosti plate zaposlenih u odeljenju 30. (JOIN)
SELECT AVG(plata) 
FROM radnik
WHERE broj_odeljenja=30


SELECT r.ime, p.imeproj
FROM radnik as r
JOIN ucesce as u
ON r.idbr=u.idbr
JOIN projekat as p
ON u.broj_projekta=p.broj_projekta
WHERE r.posao='savetnik'
GROUP BY r.ime, p.imeproj, r.plata
HAVING r.plata > (SELECT AVG(plata) 
FROM radnik
WHERE broj_odeljenja=30);

select * from radnik





















































