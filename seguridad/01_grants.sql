-- =============================================
-- GRANTS DEL PROYECTO
-- =============================================

USE CATALOG dbw_examen_gustavo;

-- Permisos sobre Bronze
GRANT USE SCHEMA ON SCHEMA bronze TO `users`;
GRANT SELECT ON ALL TABLES IN SCHEMA bronze TO `users`;

-- Permisos sobre Silver
GRANT USE SCHEMA ON SCHEMA silver TO `users`;
GRANT SELECT ON ALL TABLES IN SCHEMA silver TO `users`;

-- Permisos sobre Gold
GRANT USE SCHEMA ON SCHEMA gold TO `users`;
GRANT SELECT ON ALL TABLES IN SCHEMA gold TO `users`;