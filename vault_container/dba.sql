DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT 
      FROM   pg_roles
      WHERE  rolname = 'bnpp-apps-base') THEN
      CREATE ROLE "bnpp-apps-base" LOGIN PASSWORD '{{password}}';
   END IF;
   CREATE ROLE "{{name}}" WITH LOGIN CREATEDB PASSWORD '{{password}}' CONNECTION LIMIT 1 VALID UNTIL '{{expiration}}' IN ROLE "bnpp-apps-base",pg_monitor,pg_signal_backend;
   grant "{{name}}" to admin ;
END
$do$;