-- Obtener el nombre, la especie y el tipo de bioma de los 
-- animales que están en jaulas del bioma Bosque Templado.
SELECT a.nombreAnimal, a.especie, b.tipoBioma
FROM Animal a JOIN Jaula j ON a.numJaula = j.numJaula
              JOIN Bioma b ON j.idBioma = b.idBioma
WHERE b.tipoBioma = 'Bosque Templado';

-- Obtener el nombre de los trabajadores que tienen contratos 
-- vigentes y están asignados al bioma Desierto.
SELECT p.nomPersona
FROM Persona p JOIN Trabajador t ON p.idpersona = t.idPersona
               JOIN Contrato c ON t.idPersona = c.idPersona
               JOIN Trabajar tb ON t.idPersona = tb.idPersona
               JOIN Bioma b ON tb.idBioma = b.idBioma
WHERE c.finContrato >= CURRENT_DATE AND b.tipoBioma = 'Desierto';

-- Obtener el nombre de los animales, el número de veterinarios que 
-- los han tratado y el promedio de salario de los veterinarios, 
-- agrupados por especie y habiendo al menos 2 animales 
SELECT a.especie, a.nombreAnimal, COUNT(v.idVeterinario) 
       AS num_veterinarios, AVG(v.salarioVeterinario) 
	   AS prom_salario
FROM Animal a JOIN Tratar t ON a.idAnimal = t.idAnimal
              JOIN Veterinario v ON t.idVeterinario = v.idVeterinario  
GROUP BY a.especie, a.nombreAnimal
HAVING COUNT(t.idAnimal) >= 2;