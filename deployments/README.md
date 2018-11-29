# Deployment of MetFrag on Kubernetes (K8S)

## Install postgreSQL

MetFrag can pull candidate structures from a local PostGreSQL database
with snapshots of the compound databases.

```
helm install --name metchem-postgres --set \
  postgresqlPassword=secretpassword,postgresqlDatabase=metchem,persistence.size=80Gi,persistence.storageClass=sc-pg-optimized \
  stable/postgresql
```

## Create settings

MetFrag needs a few settings, most notably with the ChemSpider API access token.
A template config file (without a valid ChemSpider token)
is provided with the sources. After modification, they are stored
within the K8S cluster as `ConfigMap`.

```
kn kubectl create configmap metfrag-settings --from-file=./settings.properties
```

Afterwards, MetFrag can be deployed via
```
kn kubectl create -f metfrag.yaml
```

It is simple to scale more replicas of the MetFrag pods,
and if the K8S cluster has sufficient resources,
capacity will scale accordingly.

```
kn kubectl scale deployment metfrag-deployment   --replicas=3
```


## Populate PostGreSQL with metchem

Database creation is currently still manual:
```
export POSTGRESQL_PASSWORD=$(kubectl get secret --namespace default metchem-postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
kubectl run metchem-postgres-postgresql-client --rm --tty -i --image bitnami/postgresql --env="PGPASSWORD=$POSTGRESQL_PASSWORD" --command -- psql --host metchem-postgres-postgresql -U postgres

create database metchem;
\c metchem postgres;
CREATE USER metchemro with password 'metchemro';
```

Now we need to restore metchem data from snapshot:
```
kubectl run metchem-postgres-postgresql-client --rm --tty -i --image bitnami/postgresql --env="PGPASSWORD=$POSTGRESQL_PASSWORD" --command -- sh -c "curl --output - https://msbi.ipb-halle.de/~sneumann/metchem-2016.sql.gz | zcat | psql --host metchem-postgres-postgresql -U postgres metchem"
```
