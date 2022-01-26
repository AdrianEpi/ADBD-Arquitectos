# Modelo Objeto-Relacional Arquitectos

* Autor: Adrián Epifanio Rodríguez Hernández


[UML](./Arquitectos%20UML.png).


### Script Postgres
```sql
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

```


### Pruebas Ejecución:
```
postgres-# DROP TABLE IF EXISTS Linea ;
DROP TABLE
postgres=# DROP TYPE IF EXISTS Punto_ ;
DROP TYPE
postgres=# DROP TABLE IF EXISTS Poligono ;
DROP TABLE
postgres=# DROP TRIGGER IF EXISTS Figura_AFTER_INSERT ON Figura;
DROP TRIGGER
postgres=# DROP TABLE IF EXISTS Figura ;
DROP TABLE
postgres=# DROP TABLE IF EXISTS Plano ;
igura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (11, 'Sustitucion', 'Marron-Chocolate', NULL, NULL, 8);
INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (12, 'Igualacion', 'Negro', NULL, NULL, 8);

SELECT * FROM Figura;

-- DROP TABLE IF EXISTS Poligono ;
CREATE TABLE IF NOT EXISTS PoligDROP TABLE
postgres=# DROP TABLE IF EXISTS Proyecto ;
DROP TABLE
postgres=# DROP TABLE IF EXISTS JefeProyecto ;
DROP TABLE
postgres=# DROP TYPE IF EXISTS Direccion_ ;
DROP TYPE
postgres=#
postgres=#
postgres=# -- DROP TYPE IF EXISTS Direccion_ ;
postgres=# CREATE TYPE Direccion_ AS
postgres-# (
postgres(#   Tipo_Via VARCHAR,
postgres(#   Nombre_Via VARCHAR,
postgres(#   Poblacion VARCHAR,
postgres(#   CP INTEGER,
postgres(#   Provincia VARCHAR
postgres(# );
CREATE TYPE
postgres=#
postgres=#
postgres=# -- DROP TABLE IF EXISTS JefeProyecto ;
postgres=# CREATE TABLE IF NOT EXISTS JefeProyecto
postgres-# (
postgres(#   Cod_JefeProyecto INTEGER,
postgres(#   Nombre VARCHAR,
postgres(#   Direccion Direccion_,
postgres(#   Telefono VARCHAR(10),
postgres(#   PRIMARY KEY (Cod_JefeProyecto),
postgres(#   UNIQUE (Cod_JefeProyecto, Nombre)
postgres(# );
CREATE TABLE
postgres=#
postgres=# INSERT INTO JefeProyecto (Cod_JefeProyecto, Nombre, Direccion, Telefono) VALUES (001, 'Pedro pica piedra', ROW('AAA', 'BBB', 'CCC', 123, 'DDD'), 0101);
INSERT 0 1
postgres=# INSERT INTO JefeProyecto (Cod_JefeProyecto, Nombre, Direccion, Telefono) VALUES (002, 'Pedro pica marmol', ROW('AAA', 'BBB', 'CCC', 123, 'DDD'), 0101);
INSERT 0 1
postgres=# INSERT INTO JefeProyecto (Cod_JefeProyecto, Nombre, Direccion, Telefono) VALUES (003, 'Pedro pica lava', ROW('AAA', 'BBB', 'CCC', 123, 'DDD'), 0101);
INSERT 0 1
postgres=#
postgres=# SELECT * FROM JefeProyecto;
 cod_jefeproyecto |      nombre       |       direccion       | telefono
------------------+-------------------+-----------------------+----------
                1 | Pedro pica piedra | (AAA,BBB,CCC,123,DDD) | 101
                2 | Pedro pica marmol | (AAA,BBB,CCC,123,DDD) | 101
                3 | Pedro pica lava   | (AAA,BBB,CCC,123,DDD) | 101
(3 rows)

postgres=#
postgres=# -- DROP TABLE IF EXISTS Proyecto ;
postgres=# CREATE TABLE IF NOT EXISTS Proyecto
postgres-# (
postgres(#   Cod_Proyecto INTEGER,
postgres(#   Nombre VARCHAR,
postgres(#   JefeProyecto_Cod_JefeProyecto INTEGER,
postgres(#   PRIMARY KEY (Cod_Proyecto),
postgres(#   CONSTRAINT fk_Proyecto_JefeProyecto
postgres(#     FOREIGN KEY (JefeProyecto_Cod_JefeProyecto)
postgres(#     REFERENCES JefeProyecto (Cod_JefeProyecto)
postgres(#     ON DELETE NO ACTION
postgres(#     ON UPDATE NO ACTION
postgres(# );
CREATE TABLE
postgres=#
postgres=# INSERT INTO Proyecto (Cod_Proyecto, Nombre, JefeProyecto_Cod_JefeProyecto) VALUES (4, 'ProyectoAprobar', 001);
INSERT 0 1
postgres=# INSERT INTO Proyecto (Cod_Proyecto, Nombre, JefeProyecto_Cod_JefeProyecto) VALUES (5, 'ProyectoAprobarADBD', 002);
INSERT 0 1
postgres=# INSERT INTO Proyecto (Cod_Proyecto, Nombre, JefeProyecto_Cod_JefeProyecto) VALUES (6, 'ProyectoAprobarPorFavor', 003);
INSERT 0 1
postgres=#
postgres=# SELECT * FROM Proyecto;
 cod_proyecto |         nombre          | jefeproyecto_cod_jefeproyecto
--------------+-------------------------+-------------------------------
            4 | ProyectoAprobar         |                             1
            5 | ProyectoAprobarADBD     |                             2
            6 | ProyectoAprobarPorFavor |                             3
(3 rows)

postgres=#
postgres=# -- DibujoPlano es varchar donde se almacena la Ruta de la imagen
postgres=# -- DROP TABLE IF EXISTS Plano ;
postgres=# CREATE TABLE IF NOT EXISTS Plano
postgres-# (
postgres(#   Cod_Plano INTEGER,
postgres(#   Fecha_Entrega DATE,
postgres(#   Arquitectos VARCHAR[],
postgres(#   DibujoPlano VARCHAR,
postgres(#   Num_Figuras INTEGER,
postgres(#   Proyecto_Cod_Proyecto INTEGER,
postgres(#   PRIMARY KEY (Cod_Plano),
postgres(#   CONSTRAINT fk_Plano_Proyecto
postgres(#     FOREIGN KEY (Proyecto_Cod_Proyecto)
postgres(#     REFERENCES Proyecto (Cod_Proyecto)
postgres(#     ON DELETE NO ACTION
postgres(#     ON UPDATE NO ACTION
postgres(# );
CREATE TABLE
postgres=#
postgres=# INSERT INTO Plano (Cod_Plano, Fecha_Entrega, Arquitectos, DibujoPlano, Num_Figuras, Proyecto_Cod_Proyecto) VALUES (7, '10-10-2010', '{"Esclavo1", "Esclavo2"}', 'dibujitoBonito', 7, 4);
INSERT 0 1
postgres=# INSERT INTO Plano (Cod_Plano, Fecha_Entrega, Arquitectos, DibujoPlano, Num_Figuras, Proyecto_Cod_Proyecto) VALUES (8, '10-10-2010', '{"Esclavo3", "Esclavo4"}', 'dibujitoBonito', 7, 5);
INSERT 0 1
postgres=# INSERT INTO Plano (Cod_Plano, Fecha_Entrega, Arquitectos, DibujoPlano, Num_Figuras, Proyecto_Cod_Proyecto) VALUES (9, '10-10-2010', '{"Esclavo5", "Esclavo6"}', 'dibujitoBonito', 7, 6);
INSERT 0 1
postgres=#
postgres=# SELECT * FROM Plano;
 cod_plano | fecha_entrega |     arquitectos     |  dibujoplano   | num_figuras | proyecto_cod_proyecto
-----------+---------------+---------------------+----------------+-------------+-----------------------
         7 | 2010-10-10    | {Esclavo1,Esclavo2} | dibujitoBonito |           7 |                     4
         8 | 2010-10-10    | {Esclavo3,Esclavo4} | dibujitoBonito |           7 |                     5
         9 | 2010-10-10    | {Esclavo5,Esclavo6} | dibujitoBonito |           7 |                     6
(3 rows)

postgres=#
postgres=# -- DROP TABLE IF EXISTS Figura ;
postgres=# CREATE TABLE IF NOT EXISTS Figura
postgres-# (
postgres(#   Figura_ID INTEGER,
postgres(#   Nombre VARCHAR,
postgres(#   Color VARCHAR,
postgres(#   Area DECIMAL,
postgres(#   Perimetro DECIMAL,
postgres(#   Plano_Cod_Plano INTEGER,
postgres(#   PRIMARY KEY (Figura_ID),
postgres(#   UNIQUE (Nombre),
postgres(#   CONSTRAINT fk_Figura_Plano
postgres(#     FOREIGN KEY (Plano_Cod_Plano)
postgres(#     REFERENCES Plano (Cod_Plano)
postgres(#     ON DELETE NO ACTION
postgres(#     ON UPDATE NO ACTION
postgres(# );
CREATE TABLE
postgres=#
postgres=# CREATE OR REPLACE FUNCTION figuraAfter() RETURNS TRIGGER AS $figuraAfter$
postgres$#   BEGIN
postgres$#       UPDATE Plano
postgres$#       SET Num_Figuras = Plano.Num_Figuras + 1 WHERE new.Plano_Cod_Plano = Plano.Cod_Plano;
postgres$#       RETURN NEW;
postgres$#   END;
postgres$# $figuraAfter$ LANGUAGE plpgsql;
CREATE FUNCTION
postgres=#
postgres=#
postgres=# -- DROP TRIGGER IF EXISTS Figura_AFTER_INSERT ON Figura;
postgres=# CREATE TRIGGER Figura_AFTER_INSERT
postgres-#   AFTER INSERT ON Figura
postgres-#   FOR EACH ROW EXECUTE PROCEDURE figuraAfter();
CREATE TRIGGER
postgres=#
postgres=#
postgres=# INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (10, 'Sumision', 'Marron', NULL, NULL, 7);
INSERT 0 1
postgres=# INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (11, 'Sustitucion', 'Marron-Chocolate', NULL, NULL, 8);
INSERT 0 1
postgres=# INSERT INTO Figura (Figura_ID, Nombre, Color, Area, Perimetro, Plano_Cod_Plano) VALUES (12, 'Igualacion', 'Negro', NULL, NULL, 8);
INSERT 0 1
postgres=#
postgres=# SELECT * FROM Figura;
 figura_id |   nombre    |      color       | area | perimetro | plano_cod_plano
-----------+-------------+------------------+------+-----------+-----------------
        10 | Sumision    | Marron           |      |           |               7
        11 | Sustitucion | Marron-Chocolate |      |           |               8
        12 | Igualacion  | Negro            |      |           |               8
(3 rows)

postgres=#
postgres=# -- DROP TABLE IF EXISTS Poligono ;
postgres=# CREATE TABLE IF NOT EXISTS Poligono
postgres-# (
postgres(#   Num_lineas INTEGER,
postgres(#   Lineas INTEGER[],
postgres(#   Figura_Figura_ID INTEGER,
postgres(#   PRIMARY KEY (Num_lineas),
postgres(#   CONSTRAINT fk_Poligono_Figura
postgres(#     FOREIGN KEY (Figura_Figura_ID)
postgres(#     REFERENCES Figura (Figura_ID)
postgres(#     ON DELETE NO ACTION
postgres(#     ON UPDATE NO ACTION
postgres(# );
CREATE TABLE
postgres=#
postgres=# INSERT INTO Poligono (Num_lineas, Lineas, Figura_Figura_ID) VALUES (5, '{1, 3, 4}', 10);
INSERT 0 1
postgres=# INSERT INTO Poligono (Num_lineas, Lineas, Figura_Figura_ID) VALUES (7, '{1, 7, 9, 6, 21}', 11);
INSERT 0 1
postgres=# INSERT INTO Poligono (Num_lineas, Lineas, Figura_Figura_ID) VALUES (25, '{3, 4}', 12);
INSERT 0 1
postgres=#
postgres=# SELECT * FROM Poligono;
 num_lineas |    lineas    | figura_figura_id
------------+--------------+------------------
          5 | {1,3,4}      |               10
          7 | {1,7,9,6,21} |               11
         25 | {3,4}        |               12
(3 rows)

postgres=#
postgres=# -- DROP TYPE IF EXISTS Punto_ ;
postgres=# CREATE TYPE Punto_ AS
postgres-# (
postgres(#   Coord_X INTEGER,
postgres(#   Coord_Y INTEGER
postgres(# );
CREATE TYPE
postgres=#
postgres=# -- DROP TABLE IF EXISTS Linea ;
postgres=# CREATE TABLE IF NOT EXISTS Linea
postgres-# (
postgres(#   ID_Linea INTEGER,
postgres(#   Longitud INTEGER,
postgres(#   Puntos Punto_[],
postgres(#   PRIMARY KEY (ID_Linea)
postgres(# );
CREATE TABLE
postgres=#
postgres=# SELECT * FROM Linea;
 id_linea | longitud | puntos
----------+----------+--------
(0 rows)
```