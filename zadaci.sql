--1. Prikazati sva mesta i imena odeljenja (tim redom) iz tabele odeljenje.

SELECT mesto, ime_odeljenja FROM odeljenje;

--2. Prikazati imena odeljenja i mesta ciji je id veci od 25.

SELECT ime_odeljenja, mesto FROM odeljenje WHERE broj_odeljenja > 25;

--3. Prikazati imena svih radnika cija je premija veca od 599 i nemaju kvalifikaciju KV.

SELECT ime FROM radnik WHERE premija > 599 AND kvalifikacija != 'KV';	

--4. Prikazati idbr onih koji su na poziciji izvrsilac i imaju strogo preko 1000 broja sati ili imaju strogo manje od 400 broja projekta.

SELECT idbr FROM ucesce WHERE funkcija='IZVRŠILAC' AND (broj_sati > 1000 OR broj_projekta < 400);

----5. Prikazati imena onih odeljenja cije ime mesta se sastoji od dve reci.

SELECT ime_odeljenja FROM odeljenje WHERE mesto LIKE '% %';

--6. Prikazati imena odeljanja onih koji su na mestu 'Zemun' ili ciji je broj odeljenja 40.

SELECT ime_odeljenja FROM odeljenje WHERE mesto = 'Zemun' OR broj_odeljenja = 40;

--*7. Prikazati imena svih upravnika cije idbr rukovodilaca je 5842 
--ali cija je plata ili strogo iznad ili strogo ispod 2400 a koji nisu u odeljenju ciji je broj 30 ili 40.

SELECT ime 
FROM radnik 
WHERE posao = 'upravnik' 
	AND rukovodilac = 5842 
	AND plata != 2400 
	AND broj_odeljenja NOT IN (30,40);

--8. Prikazati imena projekata cija su sredstva veca ili jednaka od 3000000
--a manja ili jednaka od 5000000.

SELECT imeproj FROM projekat WHERE sredstva BETWEEN 3000000 AND 5000000;


--9. Prikazati ime svih radnika koji su rodjeni strogo pre 90-tih a cija je premija strogo manja od 1000.

SELECT ime FROM radnik WHERE datum_zaposlenja < '1990-01-01' AND premija < 1000;

--10.Prikazati broj projekata svih izvrsilaca koji imaju vise ili jednako od 2000 sati 
--ili broj projekta svih konsultanata koji imaju tacno 500 ili 300 sati.

SELECT broj_projekta
FROM ucesce 
WHERE (funkcija = 'IZVRŠILAC' AND broj_sati >= 2000) 
	OR (funkcija = 'KONSULTANT' AND broj_sati IN (500,300));

--*11.Prikazati idbr onih koji se zovu 'Biljana' ili 'Strahinja', koji se ne zovu 'Amanda', 
--ciji broj rokuvodilaca je neki od brojeva 5555, 6666 ili 7777, 
--ali tako da im je premija strogo manja od 500 uz platu strogo vecu od 1000 
--ili tako da im je premija veca ili jednaka od 500 uz platu manju ili jednaku od 1000.

SELECT idbr 
FROM radnik
WHERE ime IN ('Strahinja', 'Biljana') AND ime != 'Amanda'
	AND rukovodilac IN (5555,6666,7777)
	AND ((premija < 500 AND plata > 1000) OR (premija >= 500 AND plata <= 1000));