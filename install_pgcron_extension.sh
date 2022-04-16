#!/bin/bash

sudo yum install -y pg_cron_14
echo shared_preload_libraries = \'pg_cron\' >> /var/lib/pgsql/14/data/postgresql.conf
echo cron.database_name = \'postgres\' >> /var/lib/pgsql/14/data/postgresql.conf
systemctl restart postgresql-14
