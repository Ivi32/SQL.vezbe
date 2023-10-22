--*33. Prikazati u kom mestu je odeljenje koje ima najvecu prosecnu platu medju  odeljenjima,
--racunajuci prosek sa tacnoscu od dve decimale. 
--(paziti DOOOBROOO sta vam se ovde tacno trazi!) 
--(Resenje: 'Banovo Brdo')

SELECT mesto FROM (SELECT o.mesto, ROUND(AVG(r.plata),2)
FROM odeljenje as o
JOIN radnik as r
ON o.broj_odeljenja = r.broj_odeljenja
GROUP BY o.mesto
ORDER BY 2 DESC
LIMIT 1)AS tabela;

--*32. Prikazati par razlicitih imena koji rade na istoj poziciji
--i zavrsavaju se na slovo 'o' 
--poredjanih leksikografski od najveceg ka najmanjem po prvom imenu 
--a leksikografski od najmanjeg ka najvecem po drugom imenu

SELECT r1.ime, r2.ime 
FROM radnik as r1
JOIN radnik as r2
ON r1.posao= r2.posao
WHERE r1.posao = r2.posao
AND r1.ime > r2.ime
AND r1.ime LIKE '%o'
AND r2.ime LIKE '%o'
ORDER BY r1.ime DESC, r2.ime ASC;


--29*. Za svaku funkciju prikazati ono mesto na kome radi najvise radnika.

SELECT u.funkcija, o.mesto, COUNT(r.idbr) AS broj_radnika
FROM ucesce AS u
JOIN radnik AS r
	ON u.idbr = r.idbr
JOIN odeljenje AS o
	ON r.broj_odeljenja = o.broj_odeljenja
JOIN (SELECT funkcija, MAX(broj_radnika) AS najveci_broj_radnika 
	  FROM (SELECT u.funkcija, o.mesto, COUNT(r.idbr) AS broj_radnika
  			FROM ucesce AS u
			JOIN radnik AS r
			ON u.idbr = r.idbr
			JOIN odeljenje AS o
			ON r.broj_odeljenja = o.broj_odeljenja
			GROUP BY u.funkcija, o.mesto) as tab1
		GROUP BY funkcija
	 )as tab2 ON tab2.funkcija = u.funkcija
GROUP BY u.funkcija, o.mesto, tab2.najveci_broj_radnika
HAVING COUNT(r.idbr) = tab2.najveci_broj_radnika
ORDER BY u.funkcija;

--*31. Prikazati za svako odeljenje ime radnika koji ima najvise odradjenih broja sati 
--a koji nije na projektu 'izvoz', 


SELECT o.ime_odeljenja, r.ime, SUM(u.broj_sati) as broj_sati, tab3.max_broj_sati 			  
FROM odeljenje as o 
JOIN radnik as r
	ON o.broj_odeljenja=r.broj_odeljenja
JOIN ucesce as u
	ON u.idbr=r.idbr
JOIN projekat as p
	ON u.broj_projekta=p.broj_projekta
JOIN (SELECT o.ime_odeljenja, r.ime, p.imeproj, tab2.max_broj_sati
	    FROM odeljenje as o 
		JOIN radnik as r
			ON o.broj_odeljenja=r.broj_odeljenja
		JOIN ucesce as u
			ON u.idbr=r.idbr
		JOIN projekat as p
			ON u.broj_projekta=p.broj_projekta 
	 	JOIN (SELECT ime_odeljenja, MAX(broj_sati)as max_broj_sati 
			  FROM (SELECT o.ime_odeljenja, r.idbr, SUM(u.broj_sati) as broj_sati 			  
					FROM odeljenje as o 
					JOIN radnik as r
						ON o.broj_odeljenja=r.broj_odeljenja
					JOIN ucesce as u
						ON u.idbr=r.idbr
					JOIN projekat as p
						ON u.broj_projekta=p.broj_projekta
					GROUP BY o.ime_odeljenja, r.idbr) as tab1
			  GROUP BY ime_odeljenja) as tab2
			  ON o.ime_odeljenja= tab2.ime_odeljenja		  
WHERE p.imeproj != 'izvoz') as tab3
	ON o.ime_odeljenja=tab3.ime_odeljenja

GROUP BY o.ime_odeljenja,r.ime, tab3.max_broj_sati

--mladen
SELECT o.ime_odeljenja, r.ime, tab2.max_broj_sati ,SUM(u.broj_sati)
FROM odeljenje as o 
JOIN radnik as r
	ON o.broj_odeljenja=r.broj_odeljenja
JOIN ucesce as u
	ON u.idbr=r.idbr
JOIN projekat as p
	ON u.broj_projekta=p.broj_projekta 
JOIN (SELECT ime_odeljenja, MAX(broj_sati)as max_broj_sati 
	  FROM (SELECT o.ime_odeljenja, r.idbr, SUM(u.broj_sati) as broj_sati 			  
			FROM odeljenje as o 
			JOIN radnik as r
				ON o.broj_odeljenja=r.broj_odeljenja
			JOIN ucesce as u
				ON u.idbr=r.idbr
			JOIN projekat as p
				ON u.broj_projekta=p.broj_projekta
			WHERE p.imeproj != 'izvoz' and r.premija > 0
			GROUP BY o.ime_odeljenja, r.idbr) as tab1
	  GROUP BY ime_odeljenja) as tab2
	  ON o.ime_odeljenja= tab2.ime_odeljenja	
WHERE p.imeproj != 'izvoz' and r.premija > 0
GROUP BY o.ime_odeljenja, r.ime, tab2.max_broj_sati
HAVING tab2.max_broj_sati = SUM(u.broj_sati)
ORDER BY o.ime_odeljenja