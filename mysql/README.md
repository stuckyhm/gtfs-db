## Creating the tables ##

```
$ mysql -h 127.0.0.1 -u root -pAsdf1234 -e "create database gtfs;"
$ mysql -h 127.0.0.1 -u root -pAsdf1234 gtfs < tables_create.sql
```


## Loading feed to database ##

```
Usage: ./load_feed.sh [option...]

  -?                         Display this help and exit.
  -d database                Databasename to import to.
  -f feed                    Directory with unzipped GTFS-Feed.
  -h hostname                Connect to host.
  -u username                User for login if not current user.
  -p password                Password to use when connecting to server.
  -c file                    Read extra default options from the given file.
```

### Examples ###

```
$ ls ../nyc-gtfs
agency.txt		calendar_dates.txt	shapes.txt		stops.txt		trips.txt
calendar.txt		routes.txt		stop_times.txt		transfers.txt
$ ./load.feed.sh -h 127.0.0.1 -u root -p Asdf1234 -d gtfs -f ../nyc-gtfs
```

If you don't to expose your credentials in commandline, you can use an external file. 
```
$ cat cred.txt
[mysql]
host=127.0.0.1
user=root
password=Asdf1234

$ ./load.feed.sh -c cred.txt -d gtfs -f ../nyc-gtfs
```

You can mix these ways.
```
$ cat cred.txt
[mysql]
password=Asdf1234

$ ./load.feed.sh -h 127.0.0.1 -u root -c cred.txt -d gtfs -f ../nyc-gtfs
```
