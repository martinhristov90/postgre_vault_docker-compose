#!/usr/bin/env sh

set -aex

export VAULT_ADDR="http://localhost:8200"

vault login root

vault secrets enable database

vault write database/config/my-postgresql-database \
    plugin_name=postgresql-database-plugin \
    allowed_roles="dba","dba2" \
    connection_url="postgresql://{{username}}:{{password}}@postgre:5432?sslmode=disable" \
    username="root" \
    password="secretpassword"

vault write database/roles/dba db_name=my-postgresql-database creation_statements=@/vault/provision/dba.sql revocation_statements=@/vault/provision/revoke_drop.sql default_ttl=1m max_ttl=1h

vault read database/creds/dba


