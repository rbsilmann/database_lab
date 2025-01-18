pg_createcluster 17 main
pg_ctlcluster 17 main start

vi /etc/postgresql/17/main/postgresql.conf
archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/17/backups/archives/%f'
wal_level = replica
wal_keep_size = 128MB

vi /etc/postgresql/17/main/pg_hba.conf

mkdir -p /var/lib/postgresql/17/backups/archives
mkdir -p /var/lib/postgresql/17/backups/base
chown postgres:postgres -R /var/lib/postgresql/17/backups
chmod 700 -R /var/lib/postgresql/17/backups

systemctl restart postgresql@17-main

pg_basebackup -D /var/lib/postgresql/17/backups/base -Fp -Xs -P -U postgres
#pg_basebackup -D /var/lib/postgresql/17/backups/base -c fast -X stream -U postgres

psql -U postgres
CREATE DATABASE teste1;
\c teste1
CREATE TABLE a_test AS SELECT * FROM generate_series(1, 1000000);
SELECT * FROM a_test;
\q

STATE_0=$(date "+%Y-%m-%d %H:%M:%S %Z")

# Espere uns 2 minutos

psql -U postgres
\c teste1
DELETE FROM a_test WHERE generate_series < 100;
\q

SELECT pg_is_in_recovery();
SELECT pg_wal_replay_resume();

systemctl stop postgresql@17-main

vi /etc/postgresql/17/main/postgresql.conf

rm -rf /var/lib/postgresql/17/main
cp -R /var/lib/postgresql/17/backups/base /var/lib/postgresql/17/main
sudo touch /var/lib/postgresql/17/main/recovery.signal
chown postgres:postgres -R /var/lib/postgresql/17/main
chmod 700 -R /var/lib/postgresql/17/main

vi /etc/postgresql/17/main/postgresql.conf

restore_command = 'cp /var/lib/postgresql/17/backups/archives/%f %p'
recovery_target_time = '2025-01-18 00:20:00'
# recovery_target_time = '2025-01-17 23:32:00'
# archive_cleanup_command = 'pg_archivecleanup /var/lib/postgresql/17/backups/archives %r'

sudo systemctl start postgresql@17-main