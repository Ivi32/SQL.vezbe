--12. Prikazati imena svih radnika koji nemaju premiju.

SELECT ime FROM radnik WHERE premija IS NULL OR premija = 0;

--*13. Prikazati poslove za koje je potrebna VSS kvalifikacija (paziti dobro na rezultat ovog upita).

SELECT posao 
FROM radnik
WHERE kvalifikacija IN ('VSS')
GROUP BY posao;

SELECT DISTINCT posao 
FROM radnik
WHERE kvalifikacija = 'VSS';

--14. Prikazati funkcije koje nemaju ni tacno 100 ni tacno 300 projekata.

SELECT funkcija, COUNT(broj_projekta) FROM ucesce
GROUP BY funkcija
HAVING 2 NOT IN(100,300);
 


--15.Prikazati broj rukovodioca preimenovanu na "br rk" od vozaca.

SELECT -- DISTINCT rukovodilac AS "br rk" 
FROM radnik 
WHERE posao='vozač'
GROUP BY rukovodilac;

--16. Prikazati imena i posao svih radnika cije ime pocinje na 'S' ili 'P' 
--i ciji se posao zavrsava na "ik". 
--Imena poredjati u obrnutom leksikografskom poretku.

SELECT ime, posao FROM radnik 
WHERE (ime LIKE 'S%' OR ime LIKE 'P%' )
AND posao LIKE '%ik'
ORDER BY ime DESC;


--17. Prikazati idbr radnika koji je izmedju 5000 i 7000 
--i tako da ime radnika sa tim idbr-om ne sadrzi slovo 't'.

SELECT idbr 
FROM radnik 
WHERE idbr BETWEEN 5000 AND 7000
	AND ime NOT ILIKE '%t%';


--*18. Prikazati idbr radnika od najveceg ka najmanjem 
--cije ime ima slovo 'c' na 2. mestu u imenu 
--ili slovo 'v' na 3. mestu 
--ili  slovo 'o' na 4. mestu 
--ili da ima sekvencu 'as' negde u imenu.

SELECT idbr
FROM radnik
WHERE ime LIKE '_c%'
	OR ime LIKE '__v%'
	OR ime LIKE '___o%'
	OR ime ILIKE '%as%'
ORDER BY idbr DESC;

--19. Prikazati zbir svih brojeva odeljenja.

SELECT SUM(broj_odeljenja) FROM odeljenje;

--20. Prikazati srednju vrednost sredstava.

SELECT ROUND(AVG(sredstva)) FROM projekat;

--21. Za svaku kvalifikaciju prikazati koliko ima radnika.

SELECT kvalifikacija, COUNT(idbr) FROM radnik
GROUP BY kvalifikacija;


--22. Prikazati koja funkcija je odradila minimalni broj sat 

SELECT funkcija, MIN(broj_sati) 
FROM ucesce
GROUP BY funkcija
ORDER BY 2 ASC
LIMIT 1;

--*23. Za svaku funkciju, za svaki broj sati prikazati maksimalni broj projekta poredjano  maksimalnom broju projekata silazno

SELECT funkcija, broj_sati, MAX(broj_projekta) FROM ucesce
GROUP BY funkcija, broj_sati
ORDER BY MAX(broj_projekta) DESC;


--24. Prikazati najmanju premiju i najvecu platu medju analiticarima, ili radnicima koji su se zaposlili nakon 5. maja 1975.

SELECT MIN(premija), MAX(plata) FROM radnikh
WHERE (posao='analitičar' OR posao='radnik') 
AND datum_zaposlenja > '1975-05-05';


--*25. Prikazati najvecu premiju i najmanju platu za svaki posao, 
--uzimajuci u obzir samo premije i plate onih radnika koji imaju rukovodioca.

SELECT posao, MAX(premija), MIN(plata) 
FROM radnik
WHERE rukovodilac IS NOT NULL
GROUP BY posao;



--*26. Prikazati one poslove koji imaju strogo vise od 2 radnika.

SELECT posao FROM radnik 
GROUP BY posao
HAVING COUNT(idbr)>2;


--*27. Prikazati kvalifikacije i njihove minimalne i maximalne plate 
--uzimajuci u obzir samo plate vece do 1000 i zanemarujuci maksimalne plate manje od 2000

SELECT kvalifikacija, MIN(plata), MAX(plata)
FROM radnik
WHERE plata > 1000
GROUP BY kvalifikacija
HAVING MAX(plata)>=2000;

--28. Prikazati sve funkcije koje su ukupuno odradile vise od 15000 sati

SELECT funkcija 
FROM ucesce 
GROUP BY funkcija
HAVING SUM(broj_sati)>15000;

--29*. Za svaku funkciju prikazati ono mesto na kome radi najvise radnika.

SELECT u.funkcija, o.mesto, COUNT(r.idbr) as  broj_radnika
FROM odeljenje as o
JOIN radnik as r on r.broj_odeljenja = o.broj_odeljenja
JOIN ucesce as u on u.idbr = r.idbr
JOIN (
	SELECT funkcija,  MAX(broj_radnika) as najveci_broj_radnika FROM(
		SELECT u.funkcija, o.mesto, COUNT(*) as broj_radnika
		FROM odeljenje as o
		JOIN radnik as r on r.broj_odeljenja = o.broj_odeljenja
		JOIN ucesce as u on u.idbr = r.idbr
		GROUP BY u.funkcija, o.mesto
	) as tabela
	GROUP BY funkcija
) as tabelaA on tabelaA.funkcija = u.funkcija			
GROUP BY u.funkcija, o.mesto, tabelaA.najveci_broj_radnika 
HAVING 	tabelaA.najveci_broj_radnika = COUNT(r.idbr)
ORDER BY u.funkcija




SELECT u.funkcija, o.mesto, COUNT(u.idbr)
FROM ucesce AS u
JOIN radnik AS r ON r.idbr = u.idbr
JOIN odeljenje AS o  on o.broj_odeljenja = r.broj_odeljenja
JOIN (
	SELECT funkcija, MAX(broj_radnika) as najveci_broj_radnika FROM (
		SELECT u.funkcija, o.mesto, COUNT(u.idbr) as broj_radnika
		FROM ucesce AS u
		JOIN radnik AS r ON r.idbr = u.idbr
		JOIN odeljenje AS o  on o.broj_odeljenja = r.broj_odeljenja
		GROUP BY u.funkcija, o.mesto
	) as tabela
	GROUP BY funkcija
) as tabelaA on tabelaA.funkcija = u.funkcija
GROUP BY u.funkcija, o.mesto, najveci_broj_radnika
HAVING najveci_broj_radnika = COUNT(u.idbr)



SELECT u.funkcija, o.mesto, COUNT(u.idbr) as broj_radnika, najveci_broj_radnika
FROM ucesce AS u
JOIN radnik AS r ON r.idbr = u.idbr
JOIN odeljenje AS o  on o.broj_odeljenja = r.broj_odeljenja	
JOIN (
	SELECT funkcija, MAX(broj_radnika) AS najveci_broj_radnika
	FROM (
		SELECT u.funkcija, o.mesto, COUNT(u.idbr) as broj_radnika
		FROM ucesce AS u
		JOIN radnik AS r ON r.idbr = u.idbr
		JOIN odeljenje AS o  on o.broj_odeljenja = r.broj_odeljenja
		GROUP BY u.funkcija, o.mesto
	) as tabela
	GROUP BY funkcija
) as tabelaA ON tabelaA.funkcija = u.funkcija
GROUP BY u.funkcija, o.mesto, najveci_broj_radnika
HAVING najveci_broj_radnika = COUNT(u.idbr)
ORDER BY funkcija



--30. Prikazati za svako odeljenje ime radnika koji ima najvise odradjenih broja sati

SELECT tabelaA.ime_odeljenja, tabelaB.ime, najveci_broj_sati 
FROM (
	SELECT broj_odeljenja, ime_odeljenja, MAX(ukupan_broj_sati) as najveci_broj_sati
	FROM (
		SELECT o.broj_odeljenja, o.ime_odeljenja, r.idbr, r.ime, 
				SUM(u.broj_sati) as ukupan_broj_sati
		FROM odeljenje AS o
		JOIN radnik AS r ON r.broj_odeljenja = o.broj_odeljenja
		JOIN ucesce AS u ON r.idbr = u.idbr
		GROUP BY o.broj_odeljenja, o.ime_odeljenja, r.idbr, r.ime		
	) AS tabela
	GROUP BY broj_odeljenja, ime_odeljenja
) as tabelaA
JOIN 
(
	SELECT o.broj_odeljenja, o.ime_odeljenja, r.idbr, r.ime, 
			SUM(u.broj_sati) as ukupan_broj_sati
	FROM odeljenje AS o
	JOIN radnik AS r ON r.broj_odeljenja = o.broj_odeljenja
	JOIN ucesce AS u ON r.idbr = u.idbr
	GROUP BY o.broj_odeljenja, o.ime_odeljenja, r.idbr, r.ime		
) as tabelaB
On tabelaA.broj_odeljenja = tabelaB.broj_odeljenja
	AND tabelaA.najveci_broj_sati = tabelaB.ukupan_broj_sati
	ORDER BY tabelaA.ime_odeljenja;

----*31. Prikazati za svako odeljenje ime radnika koji ima najvise odradjenih broja sati 
--a koji nije na projektu 'izvoz', 
--uzimajuci u obzir samo radnike kome je zadata neka (bilo kakva) premija.

--mogao bi da se resi kao 29. ali sam ovaj prvo radila :)

SELECT tabelaA.ime_odeljenja, tabelaB.ime, tabelab.ukupan_broj_sati
FROM( 
	SELECT broj_odeljenja, ime_odeljenja, MAX(ukupan_broj_sati) as najveci_broj_sati
	FROM(
		SELECT 
			o.broj_odeljenja, o.ime_odeljenja, 
			r.idbr, r.ime, SUM(u.broj_sati) AS ukupan_broj_sati
		FROM odeljenje AS o
		JOIN radnik AS r ON o.broj_odeljenja = r.broj_odeljenja
		JOIN ucesce AS u ON r.idbr = u.idbr
		JOIN projekat AS p ON u.broj_projekta = p.broj_projekta
		WHERE p.imeproj != 'izvoz' AND r.premija > 0
		GROUP BY o.broj_odeljenja, o.ime_odeljenja,  r.idbr, r.ime
	) AS tabela	
	GROUP BY broj_odeljenja, ime_odeljenja
) AS tabelaA
JOIN (
	SELECT 
		o.broj_odeljenja, o.ime_odeljenja, 
		r.idbr, r.ime, SUM(u.broj_sati) AS ukupan_broj_sati
	FROM odeljenje AS o
	JOIN radnik AS r ON o.broj_odeljenja = r.broj_odeljenja
	JOIN ucesce AS u ON r.idbr = u.idbr
	JOIN projekat AS p ON u.broj_projekta = p.broj_projekta
	WHERE p.imeproj != 'izvoz' AND r.premija > 0
	GROUP BY o.broj_odeljenja, o.ime_odeljenja,  r.idbr, r.ime	
) AS tabelaB 
ON tabelaA.broj_odeljenja = tabelaB.broj_odeljenja
AND tabelaA.najveci_broj_sati = tabelaB.ukupan_broj_sati
ORDER BY tabelaA.ime_odeljenja;
	
SELECT 
	o.broj_odeljenja, o.ime_odeljenja, 
	r.idbr, r.ime, SUM(u.broj_sati) AS ukupan_broj_sati
FROM odeljenje AS o
JOIN radnik AS r ON o.broj_odeljenja = r.broj_odeljenja
JOIN ucesce AS u ON r.idbr = u.idbr
JOIN projekat AS p ON u.broj_projekta = p.broj_projekta
JOIN (
	SELECT broj_odeljenja, ime_odeljenja, MAX(ukupan_broj_sati) as najveci_broj_sati
	FROM(
		SELECT 
			o.broj_odeljenja, o.ime_odeljenja, 
			r.idbr, r.ime, SUM(u.broj_sati) AS ukupan_broj_sati
		FROM odeljenje AS o
		JOIN radnik AS r ON o.broj_odeljenja = r.broj_odeljenja
		JOIN ucesce AS u ON r.idbr = u.idbr
		JOIN projekat AS p ON u.broj_projekta = p.broj_projekta
		WHERE p.imeproj != 'izvoz' AND r.premija > 0
		GROUP BY o.broj_odeljenja, o.ime_odeljenja,  r.idbr, r.ime
		ORDER BY o.broj_odeljenja
	) AS table1	
	GROUP BY broj_odeljenja, ime_odeljenja
) AS tabelaA on tabelaA.broj_odeljenja = o.broj_odeljenja	
WHERE p.imeproj != 'izvoz' AND r.premija > 0
GROUP BY o.broj_odeljenja, o.ime_odeljenja,  r.idbr, r.ime, tabelaA.najveci_broj_sati
HAVING  tabelaA.najveci_broj_sati = SUM(u.broj_sati)

--*32. Prikazati par razlicitih imena koji rade na istoj poziciji i zavrsavaju se na slovo 'o' 
--poredjanih leksikografski od najveceg ka najmanjem po prvom imenu 
--a leksikografski od najmanjeg ka najvecem po drugom imenu

SELECT tabelaA.ime, tabelaB.ime 
FROM
(
	SELECT ime, posao
	FROM radnik
	WHERE ime LIKE '%o'
) AS tabelaA
JOIN (
	SELECT ime, posao
	FROM radnik
	WHERE ime LIKE '%o'
) AS tabelaB
ON tabelaA.posao = tabelaB.posao
WHERE tabelaA.ime > tabelaB.ime
ORDER BY tabelaA.ime DESC, tabelaB.ime ASC;

--32. na drugi nacin cross join

SELECT a.ime, b.ime
FROM radnik as a
CROSS JOIN radnik as b 
WHERE 
	a.ime LIKE '%o' and b.ime LIKE '%o'
	AND a.posao = b.posao
	AND a.ime > b.ime
ORDER BY a.ime DESC, b.ime ASC;

--32. na treci nacin obican join
SELECT a.ime, b.ime
FROM radnik as a
JOIN radnik as b ON a.posao = b.posao
WHERE 
	a.ime LIKE '%o' and b.ime LIKE '%o'	
	AND a.ime > b.ime
ORDER BY a.ime DESC, b.ime ASC;

--*33. Prikazati u kom mestu je odeljenje koje ima najvecu prosecnu platu medju  odeljenjima,
--racunajuci prosek sa tacnoscu od dve decimale. 
--(paziti DOOOBROOO sta vam se ovde tacno trazi!) 
--(Resenje: 'Banovo Brdo')

SELECT mesto, ime_odeljenja FROM (
	SELECT o.mesto, o.ime_odeljenja, ROUND(AVG(r.plata), 2) AS prosecna
	FROM odeljenje AS o
	JOIN radnik AS r
	ON o.broj_odeljenja = r.broj_odeljenja
	GROUP BY o.mesto, o.ime_odeljenja
	ORDER BY prosecna DESC 
	LIMIT 1
) AS tabela;

--34. Prikazati ime i kvalifikaciju svih ostalih radnika koji rade na istim projektima kao i Marko.

SELECT idbr FROM radnik WHERE ime='Marko';
SELECT broj_projekta FROM ucesce WHERE idbr=6234;
SELECT idbr FROM ucesce WHERE broj_projekta IN(100,200,300);
SELECT ime, kvalifikacija 
FROM radnik 
WHERE 
ime != 'Marko'
AND idbr IN(
	SELECT idbr 
	FROM ucesce 
	WHERE broj_projekta IN(
		SELECT broj_projekta 
		FROM ucesce 
		WHERE idbr IN(
			SELECT idbr FROM radnik 
			WHERE ime='Marko')));
