DROP TABLE IF EXISTS `xtra_service_dates`;
CREATE TABLE IF NOT EXISTS `xtra_service_dates` (
  `date` date NOT NULL,
  `service_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xtra_service_dates`
 ADD PRIMARY KEY (`date`,`service_id`),
 ADD INDEX(`service_id`);;


INSERT INTO `xtra_service_dates` 
SELECT d.date,
       s.service_id
FROM xtra_dates AS d
INNER JOIN
  (SELECT c.service_id,
          1 AS dayofweek,
          c.start_date,
          c.end_date
   FROM calendar AS c
   WHERE c.sunday = 1
   UNION SELECT c.service_id,
                2 AS dayofweek,
                c.start_date,
                c.end_date
   FROM calendar AS c
   WHERE c.monday = 1
   UNION SELECT c.service_id,
                3 AS dayofweek,
                c.start_date,
                c.end_date
   FROM calendar AS c
   WHERE c.tuesday = 1
   UNION SELECT c.service_id,
                4 AS dayofweek,
                c.start_date,
                c.end_date
   FROM calendar AS c
   WHERE c.wednesday = 1
   UNION SELECT c.service_id,
                5 AS dayofweek,
                c.start_date,
                c.end_date
   FROM calendar AS c
   WHERE c.thursday = 1
   UNION SELECT c.service_id,
                6 AS dayofweek,
                c.start_date,
                c.end_date
   FROM calendar AS c
   WHERE c.friday = 1
   UNION SELECT c.service_id,
                7 AS dayofweek,
                c.start_date,
                c.end_date
   FROM calendar AS c
   WHERE c.saturday = 1 ) AS s ON s.dayofweek = dayofweek(d.date)
AND (d.date BETWEEN s.start_date AND s.end_date
     OR (d.date >= s.start_date
         AND s.end_date IS NULL)
     OR (s.start_date IS NULL
         AND d.date <= s.end_date)
     OR (s.start_date IS NULL
         AND s.end_date IS NULL))
WHERE (d.date,
       s.service_id) NOT IN
    (SELECT cd.date,
            cd.service_id
     FROM calendar_dates AS cd
     WHERE cd.exception_type = 2)
UNION
SELECT cd.date,
       cd.service_id
FROM calendar_dates AS cd
WHERE cd.exception_type = 1;
