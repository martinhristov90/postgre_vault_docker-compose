#!/usr/bin/env sh

set -aex

export VAULT_ADDR="http://localhost:8200"

vault read database/creds/dba
