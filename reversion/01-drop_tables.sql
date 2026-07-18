-- REVERSIÓN DEL PROYECTO
-- Eliminar tablas Medallion
-- ==========================================

DROP TABLE IF EXISTS gold.ventas_por_ciudad;
DROP TABLE IF EXISTS gold.ventas_por_producto;
DROP TABLE IF EXISTS gold.ventas_por_cliente;

DROP TABLE IF EXISTS silver.ventas_limpias;

DROP TABLE IF EXISTS bronze.ventas_raw;