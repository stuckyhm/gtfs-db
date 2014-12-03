DROP TABLE IF EXISTS `xtra_trips_extended`;
CREATE TABLE IF NOT EXISTS `xtra_trips_extended` (
  `agency_id` varchar(255) NOT NULL,
  `service_id` varchar(255) NOT NULL,
  `route_id` varchar(255) NOT NULL,
  `trip_id` varchar(255) NOT NULL,
  `trip_headsign` varchar(255) DEFAULT NULL,
  `trip_short_name` varchar(255) DEFAULT NULL,
  `direction_id` int(11) DEFAULT NULL,
  `agency_timezone` varchar(255) DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `block_id` varchar(255) DEFAULT NULL,
  `shape_id` varchar(255) DEFAULT NULL,
  `wheelchair_accessible` int(11) DEFAULT NULL,
  `bikes_allowed` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `xtra_trips_extended`
 ADD PRIMARY KEY (`agency_id`, `service_id`, `route_id`, `trip_id`);

INSERT INTO `xtra_trips_extended`
SELECT r.agency_id,
       t.service_id,
       t.route_id,
       t.trip_id,
       t.trip_headsign,
       t.trip_short_name,
       t.direction_id,
       a.agency_timezone,
       min(st.arrival_time) AS start_time,
       max(st.departure_time) AS end_time,
       t.block_id,
       t.shape_id,
       t.wheelchair_accessible,
       t.bikes_allowed
FROM stop_times AS st
LEFT JOIN stops AS s ON st.stop_id = s.stop_id
LEFT JOIN trips AS t ON t.trip_id = st.trip_id
LEFT JOIN routes AS r ON r.route_id = t.route_id
LEFT JOIN agency AS a ON a.agency_id = r.agency_id
GROUP BY r.agency_id,
         t.service_id,
         t.route_id,
         st.trip_id,
         t.trip_headsign,
         t.trip_short_name,
         t.direction_id,
         a.agency_timezone,
         t.block_id,
         t.shape_id,
         t.wheelchair_accessible,
         t.bikes_allowed;
