# MySql #

## Creating database and tables ##

```bash
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
  -t                         Truncate tables befor loading.
  -w                         Show warnings.
```

### Examples ###

```bash
$ ls ../nyc-gtfs
agency.txt		calendar_dates.txt	shapes.txt		stops.txt		trips.txt
calendar.txt		routes.txt		stop_times.txt		transfers.txt
$ ./load.feed.sh -h 127.0.0.1 -u root -p Asdf1234 -d gtfs -f ../nyc-gtfs
```

If you don't want to expose your credentials to commandline, you can use an external file. 
```bash
$ cat cred.txt
[mysql]
host=127.0.0.1
user=root
password=Asdf1234

$ ./load.feed.sh -c cred.txt -d gtfs -f ../nyc-gtfs
```

You can mix these ways.
```bash
$ cat cred.txt
[mysql]
password=Asdf1234

$ ./load.feed.sh -h 127.0.0.1 -u root -c cred.txt -d gtfs -f ../nyc-gtfs
```

## Clean up database and tables ##

```bash
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs < tables_truncate.sql
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs < tables_drop.sql
$ mysql -h 127.0.0.1 -u root -pAsdf1234 -e "drop database gtfs;"
