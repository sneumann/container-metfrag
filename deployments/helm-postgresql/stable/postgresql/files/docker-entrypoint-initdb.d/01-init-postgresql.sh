#!/bin/sh

psql --host localhost -U postgres <<EOF
create database metchem;
\c metchem postgres;
CREATE USER metchemro with password 'metchemro';
EOF

curl --output - https://msbi.ipb-halle.de/~sneumann/metchem-2016.sql.gz | zcat | psql --host localhost -U postgres metchem

