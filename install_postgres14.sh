#!/bin/bash

echo -n Postgres Password: 
read -s password
echo

sudo yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo yum -y update 

sudo yum install -y postgresql14-server postgresql14
sudo /usr/pgsql-14/bin/postgresql-14-setup initdb
sudo systemctl enable --now postgresql-14

mkdir -p /var/lib/pgsql/14/data/
echo "# TYPE  DATABASE        USER            ADDRESS                 METHOD" > /var/lib/pgsql/14/data/pg_hba.conf
echo "local   all             all                                     peer" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "host    all             all             localhost               trust" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "host    all             all             127.0.0.1/32            trust" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "host    all             all             ::1/128                 trust" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "host    all             all             0.0.0.0/0               md5" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "local   replication     all                                     peer" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "host    replication     all             127.0.0.1/32            scram-sha-256" >> /var/lib/pgsql/14/data/pg_hba.conf
echo "host    replication     all             ::1/128                 scram-sha-256" >> /var/lib/pgsql/14/data/pg_hba.conf

echo "listen_addresses = '*'" >> /var/lib/pgsql/14/data/postgresql.conf

sudo -u postgres -H -- psql -d postgres -c "alter user postgres with password '$password'"

systemctl restart postgresql-14
