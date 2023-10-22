--*7. Prikazati imena svih upravnika cije idbr rukovodilaca je 5842 
--ali cija je plata ili strogo iznad ili strogo ispod 2400 a koji nisu u odeljenju ciji je broj 30 ili 40.

SELECT ime 
FROM radnik 
WHERE posao = 'upravnik' 
	AND rukovodilac = 5842 
	AND plata != 2400 
	AND broj_odeljenja NOT IN (30,40);
	
--*11.Prikazati idbr onih koji se zovu 'Biljana' ili 'Strahinja', koji se ne zovu 'Amanda', 
--ciji broj rokuvodilaca je neki od brojeva 5555, 6666 ili 7777, 
--ali tako da im je premija strogo manja od 500 uz platu strogo vecu od 1000 
--ili tako da im je premija veca ili jednaka od 500 uz platu manju ili jednaku od 1000.

SELECT idbr 
FROM radnik
WHERE ime IN ('Strahinja', 'Biljana') AND ime != 'Amanda'
	AND rukovodilac IN (5555,6666,7777)
	AND ((premija < 500 AND plata > 1000) OR (premija >= 500 AND plata <= 1000));
	
--*13. Prikazati poslove za koje je potrebna VSS kvalifikacija (paziti dobro na rezultat ovog upita).

SELECT posao 
FROM radnik
WHERE kvalifikacija IN ('VSS')
GROUP BY posao;

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

--*23. Za svaku funkciju, za svaki broj sati prikazati maksimalni broj projekta 
--poredjano  maksimalnom broju projekata silazno

SELECT funkcija, broj_sati, MAX(broj_projekta) FROM ucesce
GROUP BY funkcija, broj_sati
ORDER BY MAX(broj_projekta) DESC;

--*25. Prikazati najvecu premiju i najmanju platu za svaki posao, 
--uzimajuci u obzir samo premije i plate onih radnika koji imaju rukovodioca.

SELECT posao, MAX(premija) AS premija, MIN(plata) AS plata
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

--29*. Za svaku funkciju prikazati ono mesto na kome radi najvise radnika.

SELECT u.funkcija, o.mesto
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
ORDER BY u.funkcija;



--*31. Prikazati za svako odeljenje ime radnika koji ima najvise odradjenih broja sati 
--a koji nije na projektu 'izvoz', 
--uzimajuci u obzir samo radnike kome je zadata neka (bilo kakva) premija.

--mogao bi da se resi kao 29. ali sam ovaj prvo radila :)

SELECT tabelaA.ime_odeljenja, tabelaB.ime
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

SELECT mesto FROM (
	SELECT o.mesto, o.ime_odeljenja, ROUND(AVG(r.plata), 2) AS prosecna
	FROM odeljenje AS o
	JOIN radnik AS r
	ON o.broj_odeljenja = r.broj_odeljenja
	GROUP BY o.mesto, o.ime_odeljenja
	ORDER BY prosecna DESC 
	LIMIT 1
) AS tabela;
