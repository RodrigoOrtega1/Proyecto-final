-- Procedimiento Almacenado que incluye todos los detalles para un animal especifico incluyendo Bioma y Cuidador asignado
-- A LO MEJOR CAMBIARLO PARA QUE MUESTRE EL NOMBRE DEL CUIDADOR EN VEZ DEL ID
CREATE OR REPLACE FUNCTION detalles_animal(animal_id INTEGER)
RETURNS TABLE(
    idAnimal INTEGER,
    nombreAnimal VARCHAR(50),
    especie VARCHAR(50),
    peso NUMERIC(6,2),
    altura NUMERIC(4,2),
    sexo VARCHAR(1),
    alimentacion VARCHAR(9),
    idCuidador INTEGER,
    idBioma INTEGER,
    tipoBioma VARCHAR(50),
    numJaula INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
        SELECT 
            Animal.idAnimal, 
            Animal.nombreAnimal, 
            Animal.especie, 
            Animal.peso, 
            Animal.altura, 
            Animal.sexo, 
            Animal.alimentacion, 
            Cuidador.idCuidador, 
            Bioma.idBioma, 
            Bioma.tipoBioma, 
            Jaula.numJaula
        FROM 
            Animal 
            JOIN Cuidador ON Animal.idCuidador = Cuidador.idCuidador
            JOIN Jaula ON Animal.numJaula = Jaula.numJaula
            JOIN Bioma ON Jaula.idBioma = Bioma.idBioma
        WHERE 
            Animal.idAnimal = animal_id;
END;
$$;
SELECT * FROM detalles_animal(1);

COMMENT ON FUNCTION detalles_animal IS 'Regresa todos los detalles para un animal especifico incluyendo Bioma y Cuidador asignado';

-- Procedimiento Almacenado que checa si algun Insumo ya caduco
CREATE OR REPLACE FUNCTION regresar_insumos_caducos() 
RETURNS TABLE(idInsumo INTEGER, nombreInsumo VARCHAR(50), fechaCaducidad DATE) AS $$
BEGIN
    RETURN QUERY SELECT Insumo.idInsumo, Insumo.nombreInsumo, Insumo.fechaCaducidad FROM Insumo WHERE Insumo.fechaCaducidad < CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM regresar_insumos_caducos();

COMMENT ON FUNCTION regresar_insumos_caducos IS 'Regresa todos insumos caducos';


-- Procedimiento Almacenado que regresa todos los animales asignados a un cuidador en especifico
CREATE OR REPLACE FUNCTION regresar_animales_cuidador(cuidador_id INTEGER) 
RETURNS TABLE(idAnimal INTEGER, nombreAnimal VARCHAR(50)) AS $$
BEGIN
    RETURN QUERY SELECT Animal.idAnimal, Animal.nombreAnimal FROM Animal WHERE Animal.idCuidador = cuidador_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM regresar_animales_cuidador(25);

COMMENT ON FUNCTION regresar_animales_cuidador IS 'Regresa todos los animales asignados a un cuidador en especifico';
