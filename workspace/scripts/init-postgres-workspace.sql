-- workspace/scripts/init-postgres-workspace.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Function to automatically enable uuid for new databases
CREATE OR REPLACE FUNCTION enable_uuid_for_new_db()
RETURNS event_trigger AS $$
BEGIN
    IF tg_tag = 'CREATE DATABASE' THEN
        EXECUTE format('CREATE EXTENSION IF NOT EXISTS uuid-ossp DATABASE %I', tg_database);
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE EVENT TRIGGER enable_uuid_on_db_create
ON ddl_command_end
WHEN TAG IN ('CREATE DATABASE')
EXECUTE FUNCTION enable_uuid_for_new_db();

-- workspace/scripts/init-mysql-workspace.sql
-- Enable UUID support for MySQL 8.0+
SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //

CREATE FUNCTION IF NOT EXISTS uuid_v4()
RETURNS CHAR(36)
BEGIN
    RETURN LOWER(CONCAT(
        HEX(RANDOM_BYTES(4)),
        '-',
        HEX(RANDOM_BYTES(2)),
        '-4',
        SUBSTR(HEX(RANDOM_BYTES(2)), 2, 3),
        '-',
        HEX(FLOOR(ASCII(RANDOM_BYTES(1)) & 63) + 128),
        SUBSTR(HEX(RANDOM_BYTES(2)), 2, 3),
        '-',
        HEX(RANDOM_BYTES(6))
    ));
END //

DELIMITER ;