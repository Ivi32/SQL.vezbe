--Prikazati broj zaposlenih koji rade u odeljenju 40.

SELECT COUNT(idbr) FROM radnik WHERE broj_odeljenja=40;

--Prikazati srednju platu analitičara.

SELECT AVG(plata) FROM radnik WHERE posao='analitičar';

--Prikazati za svaki posao ukupnu platu radnika koji ga obavljaju. 
--Rezultate urediti po ukupnim primanjima u opadajućem redosledu.

SELECT posao, SUM(plata)
FROM radnik
GROUP BY posao
ORDER BY 2 DESC;

--Prikazati za svaki posao ukupnu platu radnika koji ga obavljaju. 
--U proračun uzeti u obzir upravnike, vozače i analitičare

SELECT posao, SUM(plata)
FROM radnik
WHERE posao IN ('upravnik', 'vozač','analitičar')
GROUP BY posao;

--Prikaži najmanju, najveću, srednju platu i broj zaposlenih po odeljenjima.

SELECT broj_odeljenja, MIN(plata), MAX(plata), AVG(plata), COUNT(idbr)
FROM radnik
GROUP BY broj_odeljenja
ORDER BY broj_odeljenja ASC;

--Prikazati za svaki posao ukupnu platu radnika koji ga obavljaju, 
--samo za poslove koje obavlja više od 2 radnika

SELECT posao, SUM(plata)
FROM radnik
GROUP BY posao
HAVING COUNT(idbr)>2;


--Odrediti srednju godišnju platu unutar svakog odeljenja 
--ne uzimajući u obzir plate direktora i upravnika.

SELECT broj_odeljenja, ROUND(AVG(plata*12))
FROM radnik
WHERE posao NOT IN('direktor','upravnik')
GROUP BY broj_odeljenja
ORDER BY 2;




