#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    GRANT ALL PRIVILEGES ON DATABASE postgres TO $DB_USER;
    CREATE SCHEMA $DB_SCHEMA;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    
    GRANT USAGE ON SCHEMA $DB_SCHEMA TO $DB_USER ;
    ALTER DEFAULT PRIVILEGES IN SCHEMA $DB_SCHEMA GRANT ALL ON TABLES TO $DB_USER;
    
    CREATE TABLE $DB_SCHEMA.application_user(
       id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
       username TEXT,
       password TEXT
    );

    CREATE TABLE $DB_SCHEMA.application_role(
       id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
       name TEXT,
       description TEXT
    );

    CREATE TABLE $DB_SCHEMA.user_role(
       user_id UUID,
       role_id UUID
    );

    INSERT INTO $DB_SCHEMA.application_user (username, password) VALUES ('admin', '\$2a\$10\$M2.V3GszAJWobGSYfj3qbO9XzhVhe4JQD9h0bzlVWLhhAUXkDtFFS');
    INSERT INTO $DB_SCHEMA.application_user (username, password) VALUES ('user', '\$2a\$10\$M2.V3GszAJWobGSYfj3qbO9XzhVhe4JQD9h0bzlVWLhhAUXkDtFFS');
    INSERT INTO $DB_SCHEMA.application_user (username, password) VALUES ('dummy', '\$2a\$10\$M2.V3GszAJWobGSYfj3qbO9XzhVhe4JQD9h0bzlVWLhhAUXkDtFFS');

    INSERT INTO $DB_SCHEMA.application_role (name, description) VALUES ('ADMIN', 'Admin user');
    INSERT INTO $DB_SCHEMA.application_role (name, description) VALUES ('USER', 'Simple user');
    INSERT INTO $DB_SCHEMA.application_role (name, description) VALUES ('DUMMY', 'Dummy user');

    INSERT INTO $DB_SCHEMA.user_role select app_user.id, app_role.id from $DB_SCHEMA.application_user app_user, $DB_SCHEMA.application_role app_role 
    where app_role.name = 'ADMIN' and app_user.username = 'admin';

    INSERT INTO $DB_SCHEMA.user_role select app_user.id, app_role.id from $DB_SCHEMA.application_user app_user, $DB_SCHEMA.application_role app_role 
    where app_role.name = 'USER' and app_user.username = 'user';

    INSERT INTO $DB_SCHEMA.user_role select app_user.id, app_role.id from $DB_SCHEMA.application_user app_user, $DB_SCHEMA.application_role app_role 
    where app_role.name = 'DUMMY' and app_user.username = 'dummy';
    INSERT INTO $DB_SCHEMA.user_role select app_user.id, app_role.id from $DB_SCHEMA.application_user app_user, $DB_SCHEMA.application_role app_role 
    where app_role.name = 'USER' and app_user.username = 'dummy';

    COMMIT;

EOSQL
