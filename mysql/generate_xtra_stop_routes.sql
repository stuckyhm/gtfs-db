DROP TABLE IF EXISTS `xtra_stop_routes`;
CREATE TABLE IF NOT EXISTS `xtra_stop_routes` (
  `agency_id` varchar(255) NOT NULL,
  `stop_id` varchar(255) NOT NULL,
  `route_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `xtra_stop_routes`
 ADD PRIMARY KEY (`agency_id`, `stop_id`, `route_id`);


INSERT INTO `xtra_stop_routes`
SELECT DISTINCT
       r.agency_id,
       st.stop_id,
       t.route_id
FROM stop_times AS st
LEFT JOIN trips AS t ON st.trip_id = t.trip_id
LEFT JOIN routes AS r ON r.route_id = t.route_id
WHERE r.route_id IS NOT NULL;
