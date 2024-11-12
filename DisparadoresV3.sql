-- Disparador para checar que un veterinario trabaje a lo mas en 2 biomas
CREATE OR REPLACE FUNCTION checar_limite_bioma() RETURNS TRIGGER AS $$
BEGIN
   IF (SELECT COUNT(*) FROM Trabajar WHERE idVeterinario = NEW.idVeterinario) >= 2 THEN
      RAISE EXCEPTION 'Un veterinario solo puede trabajar en 2 biomas a lo mas';
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_limite_bioma
BEFORE INSERT OR UPDATE ON Trabajar
FOR EACH ROW EXECUTE PROCEDURE checar_limite_bioma();

COMMENT ON TRIGGER trigger_limite_bioma ON Trabajar IS 'Checa que un veterinario trabaje solo en 2 biomas.';


-- Disparador para checar que un cuidador trabaje solo en un bioma
CREATE OR REPLACE FUNCTION checar_estar_bioma() RETURNS TRIGGER AS $$
BEGIN
   IF (SELECT COUNT(*) FROM Estar WHERE idCuidador = NEW.idCuidador) > 0 THEN
      RAISE EXCEPTION 'Un cuidador solo puede trabajar en un bioma';
   END IF;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER checar_estar_bioma_trigger
BEFORE INSERT OR UPDATE ON Estar
FOR EACH ROW EXECUTE PROCEDURE checar_estar_bioma();


-- Disparador que checa si un Veterinario y un Animal estan en el mismo bioma antes de asignarlos
CREATE OR REPLACE FUNCTION checar_tratar_bioma() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Trabajar T
        JOIN Jaula J ON T.idBioma = J.idBioma
        WHERE T.idVeterinario = NEW.idVeterinario AND T.idPersona = NEW.idPersona AND J.numJaula = (
            SELECT numJaula FROM Animal WHERE idAnimal = NEW.idAnimal
        )
    ) THEN
        RAISE EXCEPTION 'El veterinario no trabaja en el bioma donde vive el animal';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER checar_tratar_bioma_trigger
BEFORE INSERT OR UPDATE ON Tratar
FOR EACH ROW EXECUTE PROCEDURE checar_tratar_bioma();

COMMENT ON TRIGGER checar_tratar_bioma_trigger ON Tratar IS 'Checa que un veterinario asignado trabaje en el bioma del animal.';


-- Disparador que checa que el Cuidador y el Animal esten en el mismo Bioma
CREATE OR REPLACE FUNCTION checar_cuidador_bioma() RETURNS TRIGGER AS $$
DECLARE
   cuidador_bioma INTEGER;
   animal_bioma INTEGER;
BEGIN
   SELECT idBioma INTO cuidador_bioma FROM Estar WHERE idCuidador = NEW.idCuidador;
   
   IF cuidador_bioma IS NOT NULL THEN
      SELECT idBioma INTO animal_bioma FROM Jaula WHERE numJaula = NEW.numJaula;
      
      IF cuidador_bioma <> animal_bioma THEN
         RAISE EXCEPTION 'El Cuidador y Animal deben estar en el mismo Bioma';
      END IF;
   END IF;
   
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER checar_cuidador_bioma_trigger
BEFORE INSERT OR UPDATE ON Animal
FOR EACH ROW EXECUTE PROCEDURE checar_cuidador_bioma();

COMMENT ON TRIGGER checar_cuidador_bioma_trigger ON Animal IS 'Checa que el Cuidador y el Animal esten en el mismo Bioma.';

-- Disparador que checa que la fecha de nacimiento de Persona coincida con los de Trabajador al agregarse
CREATE OR REPLACE FUNCTION checar_nacimiento()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.nacimiento <> (SELECT fechaDeNacimiento FROM Persona WHERE idpersona = NEW.idPersona) THEN
    RAISE EXCEPTION 'Las fechas de nacimiento en Persona y Trabajador deben de coincidir';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER checar_nacimiento_trigger
BEFORE INSERT ON Trabajador
FOR EACH ROW EXECUTE FUNCTION checar_nacimiento();

COMMENT ON TRIGGER checar_nacimiento_trigger ON Trabajador IS 'Checa que la fecha de nacimiento de Persona coincida con los de Trabajador al agregarse.';


-- Disparador que automaticamente asigna a la tabla Estar a un Cuidador al agregar un Animal si este Cuidador no tenia un Bioma asignado
CREATE OR REPLACE FUNCTION asignar_cuidador_bioma() RETURNS TRIGGER AS $$
BEGIN
   IF (SELECT COUNT(*) FROM Estar WHERE idCuidador = NEW.idCuidador) = 0 THEN
      INSERT INTO Estar(idCuidador, idBioma)
      VALUES (NEW.idCuidador, (SELECT idBioma FROM Jaula WHERE numJaula = NEW.numJaula));
   END IF;
   
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER asignar_cuidador_bioma_trigger
AFTER INSERT OR UPDATE ON Animal
FOR EACH ROW EXECUTE PROCEDURE asignar_cuidador_bioma();

COMMENT ON TRIGGER asignar_cuidador_bioma_trigger ON Animal IS 'Automaticamente asigna a la tabla Estar a un Cuidador al agregar un Animal si este Cuidador no tenia un Bioma asignado';


-- Checa que una persona sea visitante para que se le asigne una notificacion
CREATE OR REPLACE FUNCTION checar_esvisitante() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.esVisitante = FALSE AND NEW.notificacion IS NOT NULL THEN
    RAISE EXCEPTION 'Una persona no visitante no puede tener notificaciones';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER esvisitante_notificacion_trigger
BEFORE INSERT OR UPDATE ON Persona
FOR EACH ROW EXECUTE PROCEDURE checar_esvisitante();

COMMENT ON TRIGGER esvisitante_notificacion_trigger ON Persona IS 'Checa que una persona sea visitante para que se le asigne una notificacion';
