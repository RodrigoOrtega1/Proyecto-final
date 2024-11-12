DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS Persona CASCADE;
CREATE TABLE IF NOT EXISTS Persona(
   idpersona   INTEGER  NOT NULL PRIMARY KEY
  ,esVisitante BOOLEAN NOT NULL
  ,nomPersona  VARCHAR(50) NOT NULL
  ,apPaterno   VARCHAR(50) NOT NULL
  ,apMaterno   VARCHAR(50) NOT NULL
  ,genero      VARCHAR(1) NOT  NULL
  ,fechaDeNacimiento DATE NOT NULL
  ,notificacion  VARCHAR(100)
);
-- RESTRICCIONES DE DOMINIO
ALTER TABLE Persona ADD CONSTRAINT persona_d1 CHECK (idpersona > 0);
ALTER TABLE Persona ADD CONSTRAINT persona_d2 CHECK (UPPER(genero) IN ('H','M'));
ALTER TABLE Persona ADD CONSTRAINT persona_d3 UNIQUE (idPersona);
ALTER TABLE Persona ADD CONSTRAINT persona_d4 CHECK (nomPersona <> '');
ALTER TABLE Persona ADD CONSTRAINT persona_d5 CHECK (apPaterno <> '');
ALTER TABLE Persona ADD CONSTRAINT persona_d6 CHECK (apMaterno <> '');
-- COMENTARIOS
-- COMENTARIOS DE COLUMNA
COMMENT ON TABLE Persona IS 'Tabla que contiene los datos de las personas que visitan el zoologico';
COMMENT ON COLUMN Persona.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Persona.esVisitante IS 'Indica si la persona es visitante o trabajador';
COMMENT ON COLUMN Persona.nomPersona IS 'Nombre de la persona';
COMMENT ON COLUMN Persona.apPaterno IS 'Apellido paterno de la persona';
COMMENT ON COLUMN Persona.apMaterno IS 'Apellido materno de la persona';
COMMENT ON COLUMN Persona.genero IS 'Genero de la persona';
COMMENT ON COLUMN Persona.fechaDeNacimiento IS 'Fecha de nacimiento de la persona';
COMMENT ON COLUMN Persona.notificacion IS 'Notificaciones del zoo';
-- COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT persona_d1 ON Persona IS 'El id de la persona debe ser mayor a 0';
COMMENT ON CONSTRAINT persona_d2 ON Persona IS 'El genero de la persona debe ser H o M';
COMMENT ON CONSTRAINT persona_d3 ON Persona IS 'El id de la persona debe ser unico';
COMMENT ON CONSTRAINT persona_d4 ON Persona IS 'El nombre de la persona no debe estar vacio';
COMMENT ON CONSTRAINT persona_d5 ON Persona IS 'El apellido paterno de la persona no debe estar vacio';
COMMENT ON CONSTRAINT persona_d6 ON Persona IS 'El apellido materno de la persona no debe estar vacio';


DROP TABLE IF EXISTS Trabajador CASCADE;
CREATE TABLE IF NOT EXISTS Trabajador(
   idPersona     INTEGER  NOT NULL PRIMARY KEY 
  ,estado        VARCHAR(50) NOT NULL
  ,rfcTrabajador VARCHAR(13) NOT NULL
  ,colonia       VARCHAR(50) NOT NULL
  ,calle         VARCHAR(50) NOT NULL
  ,numInterior   INTEGER  NOT NULL
  ,numExterior   INTEGER  NOT NULL
  ,nacimiento    DATE NOT NULL
  ,FOREIGN KEY (idPersona) REFERENCES Persona(idpersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R1 CHECK(CHAR_LENGTH(rfcTrabajador) = 13);
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R2 CHECK(numInterior > 0);
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R3 CHECK(numExterior > 0);
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R4 CHECK(estado <> '');
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R5 CHECK(rfcTrabajador <> '');
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R6 CHECK(colonia <> '');
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R7 CHECK(calle <> '');
ALTER TABLE Trabajador ADD CONSTRAINT trabajador_R8 CHECK(AGE(nacimiento::date)>= INTERVAL '18 years');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Trabajador IS 'Tabla que contiene los datos de los trabajadores del zoologico';
COMMENT ON COLUMN Trabajador.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Trabajador.estado IS 'Estado donde vive el trabajador';
COMMENT ON COLUMN Trabajador.rfcTrabajador IS 'RFC del trabajador';
COMMENT ON COLUMN Trabajador.colonia IS 'Colonia donde vive el trabajador';
COMMENT ON COLUMN Trabajador.calle IS 'Calle donde vive el trabajador';
COMMENT ON COLUMN Trabajador.numInterior IS 'Numero interior de la casa del trabajador';
COMMENT ON COLUMN Trabajador.numExterior IS 'Numero exterior de la casa del trabajador';
COMMENT ON COLUMN Trabajador.nacimiento IS 'Fecha de Nacimiento del trabajador';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT trabajador_R1 ON Trabajador IS 'El rfc del trabajador debe tener 13 caracteres';
COMMENT ON CONSTRAINT trabajador_R2 ON Trabajador IS 'El numero interior de la casa del trabajador debe ser mayor a 0';
COMMENT ON CONSTRAINT trabajador_R3 ON Trabajador IS 'El numero exterior de la casa del trabajador debe ser mayor a 0';
COMMENT ON CONSTRAINT trabajador_R4 ON Trabajador IS 'El estado donde vive el trabajador no debe estar vacio';
COMMENT ON CONSTRAINT trabajador_R5 ON Trabajador IS 'El rfc del trabajador no debe estar vacio';
COMMENT ON CONSTRAINT trabajador_R6 ON Trabajador IS 'La colonia donde vive el trabajador no debe estar vacia';
COMMENT ON CONSTRAINT trabajador_R7 ON Trabajador IS 'La calle donde vive el trabajador no debe estar vacia';
COMMENT ON CONSTRAINT trabajador_R8 ON Trabajador IS 'Verificamos que el trabajador tenga al menos 18 años';


DROP TABLE IF EXISTS Proveedor CASCADE;
CREATE TABLE IF NOT EXISTS Proveedor(
   idProveedor         INTEGER  NOT NULL PRIMARY KEY,
   idPersona           INTEGER  NOT NULL,
   frecuenciaServicio  INTEGER  NOT NULL,
   costo               NUMERIC(8,2) NOT NULL,
   FOREIGN KEY (idPersona) REFERENCES Trabajador(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_R1 CHECK (idProveedor > 0);
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_R2 CHECK (costo > 0);
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_R3 CHECK (frecuenciaServicio > 0);
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_R4 UNIQUE (idProveedor, idPersona);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Proveedor IS 'Tabla que contiene los datos de los proveedores del zoologico';
COMMENT ON COLUMN Proveedor.idProveedor IS 'Identificador del proveedor';
COMMENT ON COLUMN Proveedor.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Proveedor.frecuenciaServicio IS 'Frecuencia con la que el proveedor da servicio';
COMMENT ON COLUMN Proveedor.costo IS 'Costo del servicio del proveedor';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT proveedor_R1 ON Proveedor IS 'El id del proveedor debe ser mayor a 0';
COMMENT ON CONSTRAINT proveedor_R2 ON Proveedor IS 'El costo del servicio del proveedor debe ser mayor a 0';
COMMENT ON CONSTRAINT proveedor_R3 ON Proveedor IS 'La frecuencia con la que el proveedor da servicio debe ser mayor a 0';
COMMENT ON CONSTRAINT proveedor_R4 ON Proveedor IS 'El id del proveedor debe ser unico';


DROP TABLE IF EXISTS Veterinario CASCADE;
CREATE TABLE IF NOT EXISTS Veterinario(
   idVeterinario      INTEGER  NOT NULL PRIMARY KEY
  ,idPersona          INTEGER  NOT NULL 
  ,especialidad       VARCHAR(15) NOT NULL
  ,salarioVeterinario NUMERIC(8,2) NOT NULL
  ,FOREIGN KEY (idPersona) REFERENCES Trabajador(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Veterinario ADD CONSTRAINT veterinario_R1 CHECK (idVeterinario > 0);
ALTER TABLE Veterinario ADD CONSTRAINT veterinario_R2 CHECK (salarioVeterinario > 0);
ALTER TABLE Veterinario ADD CONSTRAINT veterinario_R3 UNIQUE (idVeterinario, idPersona);
ALTER TABLE Veterinario ADD CONSTRAINT veterinario_R4 CHECK (especialidad <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Veterinario IS 'Tabla que contiene los datos de los veterinarios del zoologico';
COMMENT ON COLUMN Veterinario.idVeterinario IS 'Identificador del veterinario';
COMMENT ON COLUMN Veterinario.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Veterinario.especialidad IS 'Especialidad del veterinario';
COMMENT ON COLUMN Veterinario.salarioVeterinario IS 'Salario del veterinario';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT veterinario_R1 ON Veterinario IS 'El id del veterinario debe ser mayor a 0';
COMMENT ON CONSTRAINT veterinario_R2 ON Veterinario IS 'El salario del veterinario debe ser mayor a 0';
COMMENT ON CONSTRAINT veterinario_R3 ON Veterinario IS 'El id del veterinario debe ser unico';
COMMENT ON CONSTRAINT veterinario_R4 ON Veterinario IS 'La especialidad del veterinario no debe estar vacia';


DROP TABLE IF EXISTS Cuidador CASCADE;
CREATE TABLE IF NOT EXISTS Cuidador(
   idCuidador      INTEGER  NOT NULL PRIMARY KEY
  ,idPersona       INTEGER  NOT NULL
  ,salarioCuidador NUMERIC(8,2) NOT NULL
  ,FOREIGN KEY (idPersona) REFERENCES Trabajador(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Cuidador ADD CONSTRAINT cuidador_R1 CHECK (idCuidador > 0);
ALTER TABLE Cuidador ADD CONSTRAINT cuidador_R2 CHECK (salarioCuidador > 0);
ALTER TABLE Cuidador ADD CONSTRAINT cuidador_R3 UNIQUE (idCuidador, idPersona);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Cuidador IS 'Tabla que contiene los datos de los cuidadores del zoologico';
COMMENT ON COLUMN Cuidador.idCuidador IS 'Identificador del cuidador';
COMMENT ON COLUMN Cuidador.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Cuidador.salarioCuidador IS 'Salario del cuidador';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT cuidador_R1 ON Cuidador IS 'El id del cuidador debe ser mayor a 0';
COMMENT ON CONSTRAINT cuidador_R2 ON Cuidador IS 'El salario del cuidador debe ser mayor a 0';
COMMENT ON CONSTRAINT cuidador_R3 ON Cuidador IS 'El id del cuidador debe ser unico';


DROP TABLE IF EXISTS Bioma CASCADE;
CREATE TABLE IF NOT EXISTS Bioma(
   idBioma   INTEGER  NOT NULL PRIMARY KEY 
  ,tipoBioma VARCHAR(50) NOT NULL
  ,servicios VARCHAR(50) NOT NULL
);
ALTER TABLE Bioma ADD CONSTRAINT bioma_R1 CHECK (idBioma > 0);
ALTER TABLE Bioma ADD CONSTRAINT bioma_R2 UNIQUE (idBioma);
ALTER TABLE Bioma ADD CONSTRAINT bioma_R3 CHECK (tipoBioma <> '');
ALTER TABLE Bioma ADD CONSTRAINT bioma_R4 CHECK (servicios <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Bioma IS 'Tabla que contiene los datos de los biomas del zoologico';
COMMENT ON COLUMN Bioma.idBioma IS 'Identificador del bioma';
COMMENT ON COLUMN Bioma.tipoBioma IS 'Tipo de bioma';
COMMENT ON COLUMN Bioma.servicios IS 'Servicios que ofrece el bioma';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT bioma_R1 ON Bioma IS 'El id del bioma debe ser mayor a 0';
COMMENT ON CONSTRAINT bioma_R2 ON Bioma IS 'El id del bioma debe ser unico';
COMMENT ON CONSTRAINT bioma_R3 ON Bioma IS 'El tipo de bioma no debe estar vacio';
COMMENT ON CONSTRAINT bioma_R4 ON Bioma IS 'Los servicios que ofrece el bioma no deben estar vacios';


DROP TABLE IF EXISTS Jaula;
CREATE TABLE IF NOT EXISTS Jaula(
   numJaula INTEGER  NOT NULL PRIMARY KEY 
  ,idBioma  INTEGER  NOT NULL
  ,FOREIGN KEY (idBioma) REFERENCES Bioma(idBioma) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Jaula ADD CONSTRAINT jaula_R1 CHECK (numJaula > 0);
ALTER TABLE Jaula ADD CONSTRAINT jaula_R2 UNIQUE (numJaula);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Jaula IS 'Tabla que contiene los datos de las jaulas del zoologico';
COMMENT ON COLUMN Jaula.numJaula IS 'Numero de la jaula';
COMMENT ON COLUMN Jaula.idBioma IS 'Identificador del bioma';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT jaula_R1 ON Jaula IS 'El numero de la jaula debe ser mayor a 0';
COMMENT ON CONSTRAINT jaula_R2 ON Jaula IS 'El numero de la jaula debe ser unico';


DROP TABLE IF EXISTS Animal CASCADE;
CREATE TABLE IF NOT EXISTS Animal(
   idAnimal     INTEGER  NOT NULL PRIMARY KEY 
  ,idCuidador   INTEGER  NOT NULL
  ,idPersona    INTEGER  NOT NULL
  ,numJaula     INTEGER  NOT NULL
  ,nombreAnimal VARCHAR(50) NOT NULL
  ,especie      VARCHAR(50) NOT NULL
  ,peso         NUMERIC(6,2) NOT NULL
  ,altura       NUMERIC(4,2) NOT NULL
  ,sexo         VARCHAR(1) NOT NULL
  ,alimentacion VARCHAR(9) NOT NULL
  ,FOREIGN KEY (idCuidador, idPersona) REFERENCES Cuidador(idCuidador, idPersona) ON DELETE CASCADE ON UPDATE CASCADE
  ,FOREIGN KEY (numJaula) REFERENCES Jaula(numJaula) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Animal ADD CONSTRAINT animal_R1 CHECK (idAnimal > 0);
ALTER TABLE Animal ADD CONSTRAINT animal_R2 CHECK (peso > 0);
ALTER TABLE Animal ADD CONSTRAINT animal_R3 CHECK (altura > 0);
ALTER TABLE Animal ADD CONSTRAINT animal_R4 CHECK (UPPER(sexo) = 'M' OR UPPER(sexo) = 'H');
ALTER TABLE Animal ADD CONSTRAINT animal_R5 UNIQUE (idAnimal);
ALTER TABLE Animal ADD CONSTRAINT animal_R6 CHECK (nombreAnimal <> '');
ALTER TABLE Animal ADD CONSTRAINT animal_R7 CHECK (especie <> '');
ALTER TABLE Animal ADD CONSTRAINT animal_R8 CHECK (alimentacion <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Animal IS 'Tabla que contiene los datos de los animales del zoologico';
COMMENT ON COLUMN Animal.idAnimal IS 'Identificador del animal';
COMMENT ON COLUMN Animal.idCuidador IS 'Identificador del cuidador';
COMMENT ON COLUMN Animal.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Animal.numJaula IS 'Numero de la jaula';
COMMENT ON COLUMN Animal.nombreAnimal IS 'Nombre del animal';
COMMENT ON COLUMN Animal.especie IS 'Especie del animal';  
COMMENT ON COLUMN Animal.peso IS 'Peso del animal';
COMMENT ON COLUMN Animal.altura IS 'Altura del animal';
COMMENT ON COLUMN Animal.sexo IS 'Sexo del animal';
COMMENT ON COLUMN Animal.alimentacion IS 'Alimentacion del animal';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT animal_R1 ON Animal IS 'El id del animal debe ser mayor a 0';
COMMENT ON CONSTRAINT animal_R2 ON Animal IS 'El peso del animal debe ser mayor a 0';
COMMENT ON CONSTRAINT animal_R3 ON Animal IS 'La altura del animal debe ser mayor a 0';
COMMENT ON CONSTRAINT animal_R4 ON Animal IS 'El sexo del animal debe ser H o M';
COMMENT ON CONSTRAINT animal_R5 ON Animal IS 'El id del animal debe ser unico';
COMMENT ON CONSTRAINT animal_R6 ON Animal IS 'El nombre del animal no debe estar vacio';
COMMENT ON CONSTRAINT animal_R7 ON Animal IS 'La especie del animal no debe estar vacia';
COMMENT ON CONSTRAINT animal_R8 ON Animal IS 'La alimentacion del animal no debe estar vacia';


DROP TABLE IF EXISTS Evento CASCADE;
CREATE TABLE IF NOT EXISTS Evento(
   idEvento    INTEGER  NOT NULL PRIMARY KEY 
  ,fechaEvento DATE  NOT NULL
  ,tipoEvento  VARCHAR(50) NOT NULL
  ,capacidad   INTEGER  NOT NULL
);
-- RESTRICCIONES DE DOMINIO
ALTER TABLE Evento ADD CONSTRAINT Evento_d1 CHECK (idEvento > 0);
ALTER TABLE Evento ADD CONSTRAINT Evento_d2 CHECK (capacidad > 0);
ALTER TABLE Evento ADD CONSTRAINT Evento_d3 UNIQUE (idEvento);
ALTER TABLE Evento ADD CONSTRAINT Evento_d4 CHECK (tipoEvento <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Evento IS 'Tabla que contiene los datos de los eventos del zoologico';
COMMENT ON COLUMN Evento.idEvento IS 'Identificador del evento';
COMMENT ON COLUMN Evento.fechaEvento IS 'Fecha del evento';
COMMENT ON COLUMN Evento.tipoEvento IS 'Tipo de evento';
COMMENT ON COLUMN Evento.capacidad IS 'Capacidad del evento';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT Evento_d1 ON Evento IS 'El id del evento debe ser mayor a 0';
COMMENT ON CONSTRAINT Evento_d2 ON Evento IS 'La capacidad del evento debe ser mayor a 0';
COMMENT ON CONSTRAINT Evento_d3 ON Evento IS 'El id del evento debe ser unico';
COMMENT ON CONSTRAINT Evento_d4 ON Evento IS 'El tipo de evento no debe estar vacio';


DROP TABLE IF EXISTS Insumo CASCADE;
CREATE TABLE IF NOT EXISTS Insumo(
   idInsumo       INTEGER  NOT NULL PRIMARY KEY 
  ,nombreInsumo   VARCHAR(50) NOT NULL
  ,refrigeración  BOOLEAN NOT NULL
  ,fechaCaducidad DATE  NOT NULL
  ,esMedicina     BOOLEAN NOT NULL
  ,esAlimento     BOOLEAN NOT NULL
  ,tipoAlimento   VARCHAR(50)
  ,lote           VARCHAR(50)
  ,labProcedencia VARCHAR(50)
);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d1 CHECK(idInsumo > 0);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d3 CHECK(esMedicina <> esAlimento);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d4 CHECK(nombreInsumo <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d7 UNIQUE(idInsumo);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d2 CHECK((esMedicina AND lote IS NOT NULL AND labProcedencia IS NOT NULL AND tipoAlimento IS NULL) OR NOT esMedicina);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d5 CHECK((esAlimento AND tipoAlimento IS NOT NULL AND lote IS NULL AND labProcedencia IS NULL) OR NOT esAlimento);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Insumo IS 'Tabla que contiene los datos de los insumos del zoologico';
COMMENT ON COLUMN Insumo.idInsumo IS 'Identificador del insumo';
COMMENT ON COLUMN Insumo.nombreInsumo IS 'Nombre del insumo';
COMMENT ON COLUMN Insumo.refrigeración IS 'Indica si el insumo necesita refrigeracion';
COMMENT ON COLUMN Insumo.fechaCaducidad IS 'Fecha de caducidad del insumo';
COMMENT ON COLUMN Insumo.esMedicina IS 'Indica si el insumo es medicina';
COMMENT ON COLUMN Insumo.esAlimento IS 'Indica si el insumo es alimento';
COMMENT ON COLUMN Insumo.tipoAlimento IS 'Tipo de alimento';
COMMENT ON COLUMN Insumo.lote IS 'Lote del insumo';
COMMENT ON COLUMN Insumo.labProcedencia IS 'Laboratorio de procedencia del insumo';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT insumo_d1 ON Insumo IS 'El id del insumo debe ser mayor a 0';
COMMENT ON CONSTRAINT insumo_d3 ON Insumo IS 'El insumo no puede ser alimento y medicina al mismo tiempo';
COMMENT ON CONSTRAINT insumo_d4 ON Insumo IS 'El nombre del insumo no debe estar vacio';
COMMENT ON CONSTRAINT insumo_d7 ON Insumo IS 'El id del insumo debe ser unico';
COMMENT ON CONSTRAINT insumo_d2 ON Insumo IS 'Checa que si esMedicina es True, lote y labProcedencia este llenado y tipoAlimento no lo este';
COMMENT ON CONSTRAINT insumo_d5 ON Insumo IS 'Checa que si esAlimento es True, tipoAlimento este llenado y lote y labProcedencia no lo esten';


DROP TABLE IF EXISTS Ticket CASCADE;
CREATE TABLE IF NOT EXISTS Ticket(
   idPersona     INTEGER  NOT NULL
  ,idTicket      INTEGER  NOT NULL
  ,descAplicado  INTEGER  NOT NULL
  ,tipoServicio  VARCHAR(50) NOT NULL
  ,fechaServicio DATE  NOT NULL
  ,costoServicio INTEGER  NOT NULL
  ,PRIMARY KEY(idPersona,idTicket)
  ,FOREIGN KEY(idPersona) REFERENCES Persona(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d1 CHECK(idTicket > 0);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d2 CHECK(descAplicado >= 0 AND descAplicado <= 100);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d3 CHECK(costoServicio >= 0);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d4 UNIQUE (idTicket);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d5 CHECK (tipoServicio <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Ticket IS 'Tabla que contiene los datos de los tickets del zoologico';
COMMENT ON COLUMN Ticket.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Ticket.idTicket IS 'Identificador del ticket';
COMMENT ON COLUMN Ticket.descAplicado IS 'Descuento aplicado al ticket';
COMMENT ON COLUMN Ticket.tipoServicio IS 'Tipo de servicio';
COMMENT ON COLUMN Ticket.fechaServicio IS 'Fecha del servicio';
COMMENT ON COLUMN Ticket.costoServicio IS 'Costo del servicio';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT ticket_d1 ON Ticket IS 'El id del ticket debe ser mayor a 0';
COMMENT ON CONSTRAINT ticket_d2 ON Ticket IS 'El descuento aplicado al ticket debe ser mayor o igual a 0 y menor o igual a 100';
COMMENT ON CONSTRAINT ticket_d3 ON Ticket IS 'El costo del servicio debe ser mayor o igual a 0';
COMMENT ON CONSTRAINT ticket_d4 ON Ticket IS 'El id del ticket debe ser unico';
COMMENT ON CONSTRAINT ticket_d5 ON Ticket IS 'El tipo de servicio no debe estar vacio';


DROP TABLE IF EXISTS Telefonos CASCADE;
CREATE TABLE IF NOT EXISTS Telefonos(
   telefonoPersona VARCHAR(50)  NOT NULL
  ,idPersona       INTEGER  NOT NULL
  ,PRIMARY KEY(telefonoPersona,idPersona)
  ,FOREIGN KEY (idPersona) REFERENCES Persona(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Telefonos ADD CONSTRAINT telefonos_d1 UNIQUE (telefonoPersona);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Telefonos IS 'Tabla que contiene los datos de los telefonos del zoologico';
COMMENT ON COLUMN Telefonos.telefonoPersona IS 'Telefono de la persona';
COMMENT ON COLUMN Telefonos.idPersona IS 'Identificador de la persona';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT telefonos_d1 ON Telefonos IS 'El telefono de la persona debe ser unico';


DROP TABLE IF EXISTS Contrato CASCADE;
CREATE TABLE IF NOT EXISTS Contrato(
   idContrato     INTEGER  NOT NULL
  ,idPersona      INTEGER  NOT NULL
  ,inicioContrato DATE  NOT NULL
  ,finContrato    DATE  NOT NULL
  ,PRIMARY KEY(idContrato,idPersona)
  ,FOREIGN KEY (idPersona) REFERENCES Trabajador(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Contrato ADD CONSTRAINT contrato_R1 CHECK (idContrato > 0);
ALTER TABLE Contrato ADD CONSTRAINT contrato_R2 CHECK (inicioContrato < finContrato);
ALTER TABLE Contrato ADD CONSTRAINT contrato_R3 UNIQUE (idContrato);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Contrato IS 'Tabla que contiene los datos de los contratos del zoologico';
COMMENT ON COLUMN Contrato.idContrato IS 'Identificador del contrato';
COMMENT ON COLUMN Contrato.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Contrato.inicioContrato IS 'Fecha de inicio del contrato';
COMMENT ON COLUMN Contrato.finContrato IS 'Fecha de fin del contrato';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT contrato_R1 ON Contrato IS 'El id del contrato debe ser mayor a 0';
COMMENT ON CONSTRAINT contrato_R2 ON Contrato IS 'La fecha de inicio del contrato debe ser menor a la fecha de fin del contrato';
COMMENT ON CONSTRAINT contrato_R3 ON Contrato IS 'El id del contrato debe ser unico';


DROP TABLE IF EXISTS HorarioCuidador;
CREATE TABLE IF NOT EXISTS HorarioCuidador(
   idCuidador    INTEGER  NOT NULL
  ,idPersona    INTEGER  NOT NULL
  ,diaTrabajo    VARCHAR(10) NOT NULL
  ,horarioInicio TIME NOT NULL
  ,horarioFin    TIME NOT NULL
  ,PRIMARY KEY(idCuidador,diaTrabajo)
  ,FOREIGN KEY (idCuidador, idPersona) REFERENCES Cuidador(idCuidador, idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Horariocuidador ADD CONSTRAINT horariocuidador_R1 CHECK (LOWER(diaTrabajo) IN ('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'));
ALTER TABLE Horariocuidador ADD CONSTRAINT horariocuidador_R2 CHECK (horarioInicio < horarioFin);
ALTER TABLE Horariocuidador ADD CONSTRAINT horariocuidador_R3 CHECK (diaTrabajo <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE HorarioCuidador IS 'Tabla que contiene los datos de los horarios de los cuidadores del zoologico';
COMMENT ON COLUMN HorarioCuidador.idCuidador IS 'Identificador del cuidador';
COMMENT ON COLUMN HorarioCuidador.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN HorarioCuidador.diaTrabajo IS 'Dia de trabajo del cuidador';
COMMENT ON COLUMN HorarioCuidador.horarioInicio IS 'Horario de inicio del cuidador';
COMMENT ON COLUMN HorarioCuidador.horarioFin IS 'Horario de fin del cuidador';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT horariocuidador_R1 ON HorarioCuidador IS 'El dia de trabajo del cuidador debe ser lunes, martes, miercoles, jueves, viernes, sabado o domingo';
COMMENT ON CONSTRAINT horariocuidador_R2 ON HorarioCuidador IS 'El horario de inicio del cuidador debe ser menor al horario de fin del cuidador';
COMMENT ON CONSTRAINT horariocuidador_R3 ON HorarioCuidador IS 'El dia de trabajo del cuidador no debe estar vacio';


DROP TABLE IF EXISTS Correos;
CREATE TABLE IF NOT EXISTS Correos(
   correo    VARCHAR(50) NOT NULL
  ,idPersona INTEGER  NOT NULL
  ,PRIMARY KEY(correo,idPersona)
  ,FOREIGN KEY (idPersona) REFERENCES Persona(idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Correos ADD CONSTRAINT correos_d1 CHECK(correo LIKE '%_@_%._%');
ALTER TABLE Correos ADD CONSTRAINT correos_d2 UNIQUE (correo);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Correos IS 'Tabla que contiene los datos de los correos del zoologico';
COMMENT ON COLUMN Correos.correo IS 'Correo de la persona';
COMMENT ON COLUMN Correos.idPersona IS 'Identificador de la persona';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT correos_d1 ON Correos IS 'El correo de la persona debe tener el formato correcto';
COMMENT ON CONSTRAINT correos_d2 ON Correos IS 'El correo de la persona debe ser unico';


DROP TABLE IF EXISTS Proveer;
CREATE TABLE IF NOT EXISTS Proveer(
   idProveedor INTEGER  NOT NULL
  ,idPersona INTEGER  NOT NULL
  ,idInsumo    INTEGER  NOT NULL
  ,FOREIGN KEY (idProveedor, idPersona) REFERENCES Proveedor(idProveedor, idPersona) ON DELETE CASCADE ON UPDATE CASCADE
  ,FOREIGN KEY (idInsumo) REFERENCES Insumo(idInsumo) ON DELETE CASCADE ON UPDATE CASCADE
);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Proveer IS 'Tabla que contiene los datos de los insumos proveidos al zoologico';
COMMENT ON COLUMN Proveer.idProveedor IS 'Identificador del proveedor';
COMMENT ON COLUMN Proveer.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Proveer.idInsumo IS 'Identificador del insumo';


DROP TABLE IF EXISTS DistribuirAlimento;
CREATE TABLE IF NOT EXISTS DistribuirAlimento(
   idInsumo INTEGER  NOT NULL
  ,idBioma  INTEGER  NOT NULL
  ,FOREIGN KEY (idInsumo) REFERENCES Insumo(idInsumo) ON DELETE CASCADE ON UPDATE CASCADE
  ,FOREIGN KEY (idBioma) REFERENCES Bioma(idBioma) ON DELETE CASCADE ON UPDATE CASCADE
);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE DistribuirAlimento IS 'Tabla que contiene los datos de la distribucion de alimento en los biomas del zoologico';
COMMENT ON COLUMN DistribuirAlimento.idInsumo IS 'Identificador del insumo';
COMMENT ON COLUMN DistribuirAlimento.idBioma IS 'Identificador del bioma';


DROP TABLE IF EXISTS DistribuirMedicina;
CREATE TABLE IF NOT EXISTS DistribuirMedicina(
   idInsumo INTEGER  NOT NULL
  ,idBioma  INTEGER  NOT NULL
  ,FOREIGN KEY (idInsumo) REFERENCES Insumo(idInsumo) ON DELETE CASCADE ON UPDATE CASCADE
  ,FOREIGN KEY (idBioma) REFERENCES Bioma(idBioma) ON DELETE CASCADE ON UPDATE CASCADE
);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE DistribuirMedicina IS 'Tabla que contiene los datos de la distribucion de medicina en los biomas del zoologico';
COMMENT ON COLUMN DistribuirMedicina.idInsumo IS 'Identificador del insumo';
COMMENT ON COLUMN DistribuirMedicina.idBioma IS 'Identificador del bioma';


DROP TABLE IF EXISTS Trabajar;
CREATE TABLE IF NOT EXISTS Trabajar(
   idVeterinario INTEGER  NOT NULL
  ,idPersona INTEGER  NOT NULL
  ,idBioma       INTEGER  NOT NULL
  ,FOREIGN KEY (idBioma) REFERENCES Bioma(idBioma) ON DELETE CASCADE ON UPDATE CASCADE
  ,FOREIGN KEY (idVeterinario, idPersona) REFERENCES Veterinario(idVeterinario, idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Trabajar IS 'Tabla que contiene los datos de los veterinarios que trabajan en los biomas del zoologico';
COMMENT ON COLUMN Trabajar.idVeterinario IS 'Identificador del veterinario';
COMMENT ON COLUMN Trabajar.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Trabajar.idBioma IS 'Identificador del bioma';


DROP TABLE IF EXISTS Tratar;
CREATE TABLE IF NOT EXISTS Tratar(
   idAnimal      INTEGER  NOT NULL
  ,idPersona INTEGER  NOT NULL
  ,idVeterinario INTEGER  NOT NULL
  ,indicMedicas  VARCHAR(50)
  ,FOREIGN KEY (idAnimal) REFERENCES Animal(idAnimal) ON DELETE CASCADE ON UPDATE CASCADE
  ,FOREIGN KEY (idVeterinario, idPersona) REFERENCES Veterinario(idVeterinario, idPersona) ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE Tratar ADD CONSTRAINT tratar_R1 CHECK (indicMedicas <> '');
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE Tratar IS 'Tabla que contiene los datos de los tratamientos de los animales del zoologico';
COMMENT ON COLUMN Tratar.idAnimal IS 'Identificador del animal';
COMMENT ON COLUMN Tratar.idPersona IS 'Identificador de la persona';
COMMENT ON COLUMN Tratar.idVeterinario IS 'Identificador del veterinario';
COMMENT ON COLUMN Tratar.indicMedicas IS 'Indicaciones medicas del tratamiento';
--COMENTARIOS DE RESTRICCIONES
COMMENT ON CONSTRAINT tratar_R1 ON Tratar IS 'Las indicaciones medicas del tratamiento no deben estar vacias';


DROP TABLE IF EXISTS irEvento;
CREATE TABLE IF NOT EXISTS irEvento(
   idEvento  INTEGER  NOT NULL,
   idPersona INTEGER  NOT NULL,
   FOREIGN KEY (idEvento) REFERENCES Evento(idEvento) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (idPersona) REFERENCES Persona(idpersona) ON DELETE CASCADE ON UPDATE CASCADE
);
--COMENTARIOS
--COMENTARIOS DE COLUMNA
COMMENT ON TABLE irEvento IS 'Tabla que contiene los datos de los eventos a los que asisten las personas del zoologico';
COMMENT ON COLUMN irEvento.idEvento IS 'Identificador del evento';
COMMENT ON COLUMN irEvento.idPersona IS 'Identificador de la persona';

DROP TABLE IF EXISTS Estar;
CREATE TABLE IF NOT EXISTS Estar(
   idCuidador INTEGER NOT NULL,
   idBioma    INTEGER NOT NULL,
   FOREIGN KEY (idCuidador) REFERENCES Cuidador(idCuidador) ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (idBioma) REFERENCES Bioma(idBioma) ON DELETE CASCADE ON UPDATE CASCADE
);
-- COMENTARIOS
-- COMENTARIOS DE COLUMNA 
COMMENT ON TABLE Estar IS 'Tabla que contiene los cuidadores y los Biomas en los que trabajan';
COMMENT ON COLUMN Estar.idCuidador IS 'Identificador del cuidador';
COMMENT ON COLUMN Estar.idBioma IS 'Identificador del Bioma en el que trabaja';
