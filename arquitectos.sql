/*
* @Author: Adrián Epifanio
* @Date:   2022-01-22 12:02:47
* @Last Modified by:   Adrián Epifanio
* @Last Modified time: 2022-01-26 10:52:50
*/


DROP TABLE IF EXISTS Linea ;
DROP TYPE IF EXISTS Punto_ ;
DROP TABLE IF EXISTS Poligono ;
DROP TRIGGER IF EXISTS Figura_AFTER_INSERT ON Figura;
DROP TABLE IF EXISTS Figura ;
DROP TABLE IF EXISTS Plano ;
DROP TABLE IF EXISTS Proyecto ;
DROP TABLE IF EXISTS JefeProyecto ;
DROP TYPE IF EXISTS Direccion_ ;


-- DROP TYPE IF EXISTS Direccion_ ;
CREATE TYPE Direccion_ AS
(
  Tipo_Via VARCHAR,
  Nombre_Via VARCHAR,
  Poblacion VARCHAR,
  CP INTEGER,
  Provincia VARCHAR
);


-- DROP TABLE IF EXISTS JefeProyecto ;
CREATE TABLE IF NOT EXISTS JefeProyecto 
(
  Cod_JefeProyecto INTEGER,
  Nombre VARCHAR,
  Direccion Direccion_,
  Telefono VARCHAR(10),
  PRIMARY KEY (Cod_JefeProyecto),
  UNIQUE (Cod_JefeProyecto, Nombre)
);

INSERT INTO JefeProyecto (Cod_JefeProyecto, Nombre, Direccion, Telefono) VALUES (001, 'Pedro pica piedra', ROW('AAA', 'BBB', 'CCC', 123, 'DDD'), 0101);
INSERT INTO JefeProyecto (Cod_JefeProyecto, Nombre, Direccion, Telefono) VALUES (002, 'Pedro pica marmol', ROW('AAA', 'BBB', 'CCC', 123, 'DDD'), 0101);
INSERT INTO JefeProyecto (Cod_JefeProyecto, Nombre, Direccion, Telefono) VALUES (003, 'Pedro pica lava', ROW('AAA', 'BBB', 'CCC', 123, 'DDD'), 0101);

SELECT * FROM JefeProyecto;

-- DROP TABLE IF EXISTS Proyecto ;
CREATE TABLE IF NOT EXISTS Proyecto 
(
  Cod_Proyecto INTEGER,
  Nombre VARCHAR,
  JefeProyecto_Cod_JefeProyecto INTEGER,
  PRIMARY KEY (Cod_Proyecto),
  CONSTRAINT fk_Proyecto_JefeProyecto
    FOREIGN KEY (JefeProyecto_Cod_JefeProyecto)
    REFERENCES JefeProyecto (Cod_JefeProyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO Proyecto (Cod_Proyecto, Nombre, JefeProyecto_Cod_JefeProyecto) VALUES (4, 'ProyectoAprobar', 001);
INSERT INTO Proyecto (Cod_Proyecto, Nombre, JefeProyecto_Cod_JefeProyecto) VALUES (5, 'ProyectoAprobarADBD', 002);
INSERT INTO Proyecto (Cod_Proyecto, Nombre, JefeProyecto_Cod_JefeProyecto) VALUES (6, 'ProyectoAprobarPorFavor', 003); 

SELECT * FROM Proyecto;

-- DibujoPlano es varchar donde se almacena la Ruta de la imagen
-- DROP TABLE IF EXISTS Plano ;
CREATE TABLE IF NOT EXISTS Plano 
(
  Cod_Plano INTEGER,
  Fecha_Entrega DATE,
  Arquitectos VARCHAR[],
  DibujoPlano VARCHAR, 
  Num_Figuras INTEGER,
  Proyecto_Cod_Proyecto INTEGER,
  PRIMARY KEY (Cod_Plano),
  CONSTRAINT fk_Plano_Proyecto
    FOREIGN KEY (Proyecto_Cod_Proyecto)
    REFERENCES Proyecto (Cod_Proyecto)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO Plano (Cod_Plano, Fecha_Entrega, Arquitectos, DibujoPlano, Num_Figuras, Proyecto_Cod_Proyecto) VALUES (7, '10-10-2010', '{"Esclavo1", "Esclavo2"}', 'dibujitoBonito', 7, 4);
INSERT INTO Plano (Cod_Plano, Fecha_Entrega, Arquitectos, DibujoPlano, Num_Figuras, Proyecto_Cod_Proyecto) VALUES (8, '10-10-2010', '{"Esclavo3", "Esclavo4"}', 'dibujitoBonito', 7, 5);
INSERT INTO Plano (Cod_Plano, Fecha_Entrega, Arquitectos, DibujoPlano, Num_Figuras, Proyecto_Cod_Proyecto) VALUES (9, '10-10-2010', '{"Esclavo5", "Esclavo6"}', 'dibujitoBonito', 7, 6);

SELECT * FROM Plano;

-- DROP TABLE IF EXISTS Figura ;
CREATE TABLE IF NOT EXISTS Figura 
(
  Figura_ID INTEGER,
  Nombre VARCHAR,
  Color VARCHAR,
  Area DECIMAL,
  Perimetro DECIMAL,
  Plano_Cod_Plano INTEGER,
  PRIMARY KEY (Figura_ID),
  UNIQUE (Nombre),
  CONSTRAINT fk_Figura_Plano
    FOREIGN KEY (Plano_Cod_Plano)
    REFERENCES Plano (Cod_Plano)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE OR REPLACE FUNCTION figuraAfter() RETURNS TRIGGER AS $figuraAfter$
  BEGIN
      UPDATE Plano 
      SET Num_Figuras = Plano.Num_Figuras + 1 WHERE new.Plano_Cod_Plano = Plano.Cod_Plano;
      RETURN NEW;
  END;
$figuraAfter$ LANGUAGE plpgsql;


-- DROP TRIGGER IF EXISTS Figura_AFTER_INSERT ON Figura;
CREATE TRIGGER Figura_AFTER_INSERT
  AFTER INSERT ON Figura
  FOR EACH ROW EXECUTE PROCEDURE figuraAfter();
  

INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (10, 'Sumision', 'Marron', NULL, NULL, 7);
INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (11, 'Sustitucion', 'Marron-Chocolate', NULL, NULL, 8);
INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (12, 'Igualacion', 'Negro', NULL, NULL, 8);

SELECT * FROM Figura;

-- DROP TABLE IF EXISTS Poligono ;
CREATE TABLE IF NOT EXISTS Poligono  
(
  Num_lineas INTEGER,
  Lineas INTEGER[],
  Figura_Figura_ID INTEGER,
  PRIMARY KEY (Num_lineas),
  CONSTRAINT fk_Poligono_Figura
    FOREIGN KEY (Figura_Figura_ID)
    REFERENCES Figura (Figura_ID)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO Poligono (Num_lineas, Lineas, Figura_Figura_ID) VALUES (5, '{1, 3, 4}', 10);
INSERT INTO Poligono (Num_lineas, Lineas, Figura_Figura_ID) VALUES (7, '{1, 7, 9, 6, 21}', 11);
INSERT INTO Poligono (Num_lineas, Lineas, Figura_Figura_ID) VALUES (25, '{3, 4}', 12);

SELECT * FROM Poligono;

-- DROP TYPE IF EXISTS Punto_ ;
CREATE TYPE Punto_ AS
(
  Coord_X INTEGER,
  Coord_Y INTEGER
);

-- DROP TABLE IF EXISTS Linea ;
CREATE TABLE IF NOT EXISTS Linea  
(
  ID_Linea INTEGER,
  Longitud INTEGER,
  Puntos Punto_[],
  PRIMARY KEY (ID_Linea)
);

SELECT * FROM Linea;