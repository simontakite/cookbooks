#!/bin/bash
HOST=$(hostname -s)

case "$HOST" in
intranet)
	/usr/bin/mysqldump -u backup -pbackup aigaion2 >/net/departments/it/misc_backup/dbdump/$HOST/aigaion2.sql
	/usr/bin/mysqldump -u backup -pbackup flyspray >/net/departments/it/misc_backup/dbdump/$HOST/flyspray.sql
	/usr/bin/mysqldump -u backup -pbackup testlinkdb >/net/departments/it/misc_backup/dbdump/$HOST/testlinkdb.sql
	/usr/bin/mysqldump -u backup -pbackup information_schema >/net/departments/it/misc_backup/dbdump/$HOST/information_schema.sql
	/usr/bin/mysqldump -u backup -pbackup mysql >/net/departments/it/misc_backup/dbdump/$HOST/mysql.sql
	/usr/bin/mysqldump -u backup -pbackup nrwiki >/net/departments/it/misc_backup/dbdump/$HOST/nrwiki.sql
	/usr/bin/mysqldump -u backup -pbackup intranetcalendar >/net/departments/it/misc_backup/dbdump/$HOST/intranetcalendar.sql
	/usr/bin/mysqldump -u backup -pbackup rb >/net/departments/it/misc_backup/dbdump/$HOST/rb.sql
	/usr/bin/mysqldump -u backup -pbackup rockblog >/net/departments/it/misc_backup/dbdump/$HOST/rockblog.sql
#	/usr/bin/svnadmin dump -q /var/subversion/repository/ > /net/departments/it/misc_backup/dbdump/$HOST/subversion.dmp
;;
#caracas)
#	/usr/bin/pg_dump -h caracas -o -U backup -f /net/departments/it/misc_backup/dbdump/caracas/postgres.sql postgres
#;;

bogota)
	/usr/bin/pg_dump -h bogota -o -U backup -f /net/departments/it/misc_backup/dbdump/bogota/postgres.sql postgres
;;
#santiago)
#	/usr/bin/mysqldump -u root intranetcalendar >/net/departments/it/misc_backup/dbdump/santiago/intranetcalendar.sql
#	/usr/bin/mysqldump -u root nrsd-db >/net/departments/it/misc_backup/dbdump/santiago/nrsd-db.sql
#	/usr/bin/mysqldump -u root mysql >/net/departments/it/misc_backup/dbdump/santiago/mysql.sql
#;;
esac
#chmod -R o-rwx /net/departments/it/misc_backup/dbdump
