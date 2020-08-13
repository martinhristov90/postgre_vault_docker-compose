## Simple repository used for reproduction - Vault + Postgre

### How to use it :

- Clone the repo : `git clone https://github.com/martinhristov90/postgre_vault_docker-compose.git`

- Run `docker-compose up` to run the containers.

- Open second terminal

- Create the `admin` role for the Postgre DB with : `docker-compose exec postgre psql -c "CREATE ROLE admin WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD '1234';"`

- Execute : `docker-compose exec vault /vault/provision/provision.sh` to setup Vault's database secrets engine and create simple role named `dba`. The script also requests sample credentials

- Wait one minute till the dynamic creds expire and looks at the docker-compose logs, you should see logs similar to this one (different lease ID) :

```
vault_1    | 2020-08-13T07:16:06.064Z [INFO]  expiration: revoked lease: lease_id=database/creds/dba/Fwh4hRUIlfapgDDFfSPJBmkQ
```

That notifies the Vault operator that the revocation of the dynamically created creds is successful and the revoke statement is correct.

- To simulate a failure in the revocation statement, lets request another set of credentials and immediately drop he role `bnpp-apps-base` role from Postgre. This should result in an error because the revocation statement, which looks like:

```
REASSIGN OWNED BY "{{name}}" to "bnpp-apps-base";
DROP ROLE IF EXISTS "{{name}}" ;
```

Will try to `REASSIGN` everything owned by the dynamically created role by Vault to `bnpp-apps-base`, but the role is delate by `docker-compose exec postgre psql -c 'DROP ROLE "bnpp-apps-base"'`

The here is the series of the commands to simulate failure : `docker-compose exec vault /vault/provision/request_creds.sh && docker-compose exec postgre psql -c 'DROP ROLE "bnpp-apps-base"'`

- In the docker-compose logs you can see that Vault container reports failure upon revocation of the dynamically created credentials.