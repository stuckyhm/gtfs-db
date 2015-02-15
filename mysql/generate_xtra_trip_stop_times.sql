DROP TABLE IF EXISTS `xtra_trip_stop_times`;
CREATE TABLE IF NOT EXISTS `xtra_trip_stop_times` (
  `trip_id` varchar(255) NOT NULL,
  `operating_date` date NOT NULL,
  `stop_sequence` int(11) NOT NULL,
  `stop_id` varchar(255) NOT NULL,
  `timezone` varchar(255) NOT NULL,
  `arrival_utc` datetime NOT NULL,
  `departure_utc` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xtra_trip_stop_times`
 ADD PRIMARY KEY (`trip_id`, `operating_date`, `stop_sequence`),
 ADD INDEX `time` (`arrival_utc`, `departure_utc`),
 ADD INDEX `stop` (`stop_id`),
 ADD INDEX `departure_stop` (`departure_utc`, `stop_id`);


INSERT INTO `xtra_trip_stop_times`
SELECT t.trip_id,
       sd.date,
       st.stop_sequence,
       st.stop_id,
       IFNULL(s.stop_timezone, a.agency_timezone),
       convert_tz(addtime(sd.date, st.arrival_time), a.agency_timezone, '+00:00') AS arrival,
       convert_tz(addtime(sd.date, st.departure_time), a.agency_timezone, '+00:00') AS departure
FROM trips AS t
LEFT JOIN routes AS r
ON r.route_id = t.route_id
LEFT JOIN agency AS a
ON a.agency_id = r.agency_id
LEFT JOIN xtra_service_dates AS sd 
ON sd.service_id = t.service_id
LEFT JOIN stop_times AS st 
ON st.trip_id = t.trip_id
LEFT JOIN stops AS s
ON s.stop_id = st.stop_id
WHERE date(addtime(sd.date, st.arrival_time)) BETWEEN curdate() AND date_add(curdate(), interval 2 DAY)
  OR date(addtime(sd.date, st.departure_time)) BETWEEN curdate() AND date_add(curdate(), interval 2 DAY);


DROP EVENT IF EXISTS `update_trip_stop_times_daily`;
DELIMITER $$
CREATE EVENT update_trip_stop_times_daily
    ON SCHEDULE
        EVERY 1 DAY
    STARTS '2015-01-07 23:50:00'
    DO
        BEGIN
            INSERT IGNORE INTO `xtra_trip_stop_times`
            SELECT t.trip_id,
                   sd.date,
                   st.stop_sequence,
                   st.stop_id,
                   IFNULL(s.stop_timezone, a.agency_timezone),
                   convert_tz(addtime(sd.date, st.arrival_time), a.agency_timezone, '+00:00') AS arrival,
                   convert_tz(addtime(sd.date, st.departure_time), a.agency_timezone, '+00:00') AS departure
            FROM trips AS t
            LEFT JOIN routes AS r
            ON r.route_id = t.route_id
            LEFT JOIN agency AS a
            ON a.agency_id = r.agency_id
            LEFT JOIN xtra_service_dates AS sd 
            ON sd.service_id = t.service_id
            LEFT JOIN stop_times AS st 
            ON st.trip_id = t.trip_id
            LEFT JOIN stops AS s
            ON s.stop_id = st.stop_id
            WHERE date(addtime(sd.date, st.arrival_time)) = date_add(curdate(), interval 2 DAY)
                OR date(addtime(sd.date, st.departure_time)) = date_add(curdate(), interval 2 DAY);
        
            DELETE FROM `xtra_trip_stop_times` WHERE departure_utc < date_add(curdate(), interval -2 DAY);
        END $$
DELIMITER ;

SET GLOBAL event_scheduler = ON;
