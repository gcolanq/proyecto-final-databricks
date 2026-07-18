-- ============================================================
-- PREPARACIÓN DEL AMBIENTE
-- Proyecto Final - Ingeniería de Datos con Databricks
-- Autor: Gustavo Gonzalo Colan Quiroga
-- ============================================================

-- ------------------------------------------------------------
-- 1. CREAR CATÁLOGO
-- ------------------------------------------------------------

CREATE CATALOG IF NOT EXISTS dbw_examen_gustavo
COMMENT 'Catálogo del proyecto final de Ingeniería de Datos';

USE CATALOG dbw_examen_gustavo;


-- ------------------------------------------------------------
-- 2. CREAR ESQUEMAS DE LA ARQUITECTURA MEDALLION
-- ------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS raw
COMMENT 'Capa de referencia para los archivos originales del Data Lake';

CREATE SCHEMA IF NOT EXISTS bronze
COMMENT 'Capa Bronze con datos ingeridos desde los archivos CSV';

CREATE SCHEMA IF NOT EXISTS silver
COMMENT 'Capa Silver con datos limpios y transformados';

CREATE SCHEMA IF NOT EXISTS gold
COMMENT 'Capa Gold con tablas analíticas para dashboards';


-- ------------------------------------------------------------
-- 3. EXTERNAL LOCATION
-- ------------------------------------------------------------
-- La external location y la credencial ya fueron creadas desde
-- la interfaz de Databricks.
--
-- Storage credential:
-- cred-storage-examen
--
-- External location:
-- ext-raw-examen
--
-- Ruta:
-- abfss://raw@stdbexamengustavo1994.dfs.core.windows.net/
--
-- El siguiente bloque se deja documentado.
-- No es necesario ejecutarlo nuevamente si el objeto ya existe.

CREATE EXTERNAL LOCATION IF NOT EXISTS `ext-raw-examen`
URL 'abfss://raw@stdbexamengustavo1994.dfs.core.windows.net/'
WITH (STORAGE CREDENTIAL `cred-storage-examen`)
COMMENT 'Ubicación externa de la capa RAW del proyecto';


-- ------------------------------------------------------------
-- 4. VERIFICAR CATÁLOGO Y ESQUEMAS
-- ------------------------------------------------------------

SHOW CATALOGS;

SHOW SCHEMAS IN dbw_examen_gustavo;


-- ------------------------------------------------------------
-- 5. CREAR TABLAS BRONZE
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.bronze.clientes
(
    Id      INT,
    Nombre  STRING,
    Ciudad  STRING
)
USING DELTA
COMMENT 'Tabla Bronze de clientes';


CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.bronze.ventas
(
    venta_id    INT,
    cliente_id  INT,
    producto    STRING,
    cantidad    INT,
    precio      DOUBLE,
    fecha       DATE
)
USING DELTA
COMMENT 'Tabla Bronze de ventas';


-- ------------------------------------------------------------
-- 6. CREAR TABLAS SILVER
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.silver.clientes
(
    cliente_id  INT,
    cliente     STRING,
    ciudad      STRING
)
USING DELTA
COMMENT 'Clientes limpios de la capa Silver';


CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.silver.ventas
(
    venta_id      INT,
    cliente_id    INT,
    producto      STRING,
    cantidad      INT,
    precio        DOUBLE,
    fecha         DATE,
    importe_total DOUBLE
)
USING DELTA
COMMENT 'Ventas transformadas de la capa Silver';


-- ------------------------------------------------------------
-- 7. CREAR TABLAS GOLD
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.gold.ventas_por_ciudad
(
    ciudad          STRING,
    venta_total     DOUBLE,
    cantidad_total  BIGINT,
    numero_ventas   BIGINT,
    ticket_promedio DOUBLE
)
USING DELTA
COMMENT 'Indicadores de ventas agrupados por ciudad';


CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.gold.ventas_por_producto
(
    producto           STRING,
    venta_total        DOUBLE,
    cantidad_total     BIGINT,
    clientes_distintos BIGINT
)
USING DELTA
COMMENT 'Indicadores de ventas agrupados por producto';


CREATE TABLE IF NOT EXISTS dbw_examen_gustavo.gold.ventas_por_cliente
(
    cliente_id         INT,
    cliente            STRING,
    ciudad             STRING,
    venta_total        DOUBLE,
    numero_compras     BIGINT,
    unidades_compradas BIGINT
)
USING DELTA
COMMENT 'Indicadores de ventas agrupados por cliente';


-- ------------------------------------------------------------
-- 8. VALIDACIÓN FINAL
-- ------------------------------------------------------------

SHOW TABLES IN dbw_examen_gustavo.bronze;
SHOW TABLES IN dbw_examen_gustavo.silver;
SHOW TABLES IN dbw_examen_gustavo.gold;
