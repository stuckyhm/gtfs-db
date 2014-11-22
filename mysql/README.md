# MySql #

## Creating database and tables ##

```
$ mysql -h 127.0.0.1 -u root -pAsdf1234 -e "create database gtfs;"
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs < tables_create.sql
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs -e "show tables;"
+-----------------+
| Tables_in_gtfs  |
+-----------------+
| agency          |
| calendar        |
| calendar_dates  |
| fare_attributes |
| fare_rules      |
| feed_info       |
| frequencies     |
| routes          |
| shapes          |
| stop_times      |
| stops           |
| transfers       |
| trips           |
+-----------------+
```


## Loading feed to database ##

```
Usage: ./load_feed.sh [option...]

  -?                         Display this help and exit.
  -c file                    Read extra default options from the given file.
  -d database                Databasename to import to.
  -f feed                    Directory with unzipped GTFS-Feed.
  -h hostname                Connect to host.
  -u username                User for login if not current user.
  -p password                Password to use when connecting to server.
  -t "agency,stops"          Load only these tables
  -T                         Truncate tables before loading.
  -w                         Show warnings.
```

### Examples ###

```
$ ls ../nyc-gtfs
agency.txt		calendar_dates.txt	shapes.txt		stops.txt		trips.txt
calendar.txt		routes.txt		stop_times.txt		transfers.txt
$ ./load_feed.sh -h 127.0.0.1 -u root -p Asdf1234 -d gtfs -f ../nyc-gtfs
All tables will truncated before loading.
Start loading file agency.txt with 2 lines.
Records: 1  Deleted: 0  Skipped: 0  Warnings: 0
Loading file agency.txt finished.

Start loading file calendar.txt with 11 lines.
Records: 10  Deleted: 0  Skipped: 0  Warnings: 10
Loading file calendar.txt finished.

Start loading file calendar_dates.txt with 17 lines.
Records: 16  Deleted: 0  Skipped: 0  Warnings: 0
Loading file calendar_dates.txt finished.

Ignoring missing file fare_attributes.txt.

Ignoring missing file fare_rules.txt.

Ignoring missing file frequencies.txt.

Start loading file routes.txt with 30 lines.
Records: 29  Deleted: 0  Skipped: 0  Warnings: 0
Loading file routes.txt finished.

Start loading file shapes.txt with 122383 lines.
Records: 122382  Deleted: 0  Skipped: 0  Warnings: 0
Loading file shapes.txt finished.

Start loading file stop_times.txt with 553150 lines.
Records: 553149  Deleted: 0  Skipped: 0  Warnings: 553149
Loading file stop_times.txt finished.

Start loading file stops.txt with 1498 lines.
Records: 1497  Deleted: 0  Skipped: 0  Warnings: 0
Loading file stops.txt finished.

Start loading file transfers.txt with 611 lines.
Records: 610  Deleted: 0  Skipped: 0  Warnings: 0
Loading file transfers.txt finished.

Start loading file trips.txt with 20623 lines.
Records: 20622  Deleted: 0  Skipped: 0  Warnings: 0
Loading file trips.txt finished.

EXIT(0)
```

If you don't want to expose your credentials to commandline, you can use an external file. 
```
$ cat cred.txt
[mysql]
host=127.0.0.1
user=root
password=Asdf1234

$ ./load_feed.sh -c cred.txt -d gtfs -f ../nyc-gtfs
```

You can mix these ways.
```
$ cat cred.txt
[mysql]
password=Asdf1234

$ ./load_feed.sh -h 127.0.0.1 -u root -c cred.txt -d gtfs -f ../nyc-gtfs
```

## Clean up database and tables ##

```
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs < tables_truncate.sql
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs < tables_drop.sql
$ mysql -h 127.0.0.1 -u root -pAsdf1234 -e "drop database gtfs;"
