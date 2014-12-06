SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


DROP TABLE IF EXISTS `agency`;
CREATE TABLE IF NOT EXISTS `agency` (
  `agency_id` varchar(255) NOT NULL,
  `agency_name` varchar(255) NOT NULL,
  `agency_url` varchar(255) NOT NULL,
  `agency_timezone` varchar(255) DEFAULT NULL,
  `agency_lang` varchar(2) DEFAULT NULL,
  `agency_phone` varchar(255) DEFAULT NULL,
  `agency_fare_url` varchar(255) DEFAULT NULL,
  `agency_email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `calendar`;
CREATE TABLE IF NOT EXISTS `calendar` (
  `service_id` varchar(255) NOT NULL,
  `monday` int(1) DEFAULT NULL,
  `tuesday` int(1) DEFAULT NULL,
  `wednesday` int(1) DEFAULT NULL,
  `thursday` int(1) DEFAULT NULL,
  `friday` int(1) DEFAULT NULL,
  `saturday` int(1) DEFAULT NULL,
  `sunday` int(1) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `calendar_dates`;
CREATE TABLE IF NOT EXISTS `calendar_dates` (
  `service_id` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `exception_type` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `fare_attributes`;
CREATE TABLE IF NOT EXISTS `fare_attributes` (
  `fare_id` varchar(255) NOT NULL,
  `price` decimal(10,5) NOT NULL,
  `currency_type` varchar(4) NOT NULL,
  `payment_method` int(1) NOT NULL,
  `transfers` int(1) NOT NULL,
  `transfer_duration` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `fare_rules`;
CREATE TABLE IF NOT EXISTS `fare_rules` (
  `fare_id` varchar(255) NOT NULL,
  `route_id` varchar(255) DEFAULT NULL,
  `origin_id` varchar(255) DEFAULT NULL,
  `destination_id` varchar(255) DEFAULT NULL,
  `contains_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `feed_info`;
CREATE TABLE IF NOT EXISTS `feed_info` (
  `feed_publisher_name` varchar(255) NOT NULL,
  `feed_publisher_url` varchar(255) NOT NULL,
  `feed_lang` varchar(255) NOT NULL,
  `feed_start_date` date DEFAULT NULL,
  `feed_end_date` date DEFAULT NULL,
  `feed_version` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `frequencies`;
CREATE TABLE IF NOT EXISTS `frequencies` (
  `trip_id` varchar(255) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `headway_secs` int(11) NOT NULL,
  `exact_times` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `routes`;
CREATE TABLE IF NOT EXISTS `routes` (
  `route_id` varchar(255) NOT NULL,
  `agency_id` varchar(255) NOT NULL,
  `route_short_name` varchar(255) NOT NULL,
  `route_long_name` varchar(255) NOT NULL,
  `route_desc` longtext,
  `route_type` int(1) NOT NULL,
  `route_url` varchar(255) DEFAULT NULL,
  `route_color` varchar(6) DEFAULT NULL,
  `route_text_color` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `shapes`;
CREATE TABLE IF NOT EXISTS `shapes` (
  `shape_id` varchar(255) NOT NULL,
  `shape_pt_lat` double NOT NULL,
  `shape_pt_lon` double NOT NULL,
  `shape_pt_sequence` int(11) NOT NULL,
  `shape_dist_traveled` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stops`;
CREATE TABLE IF NOT EXISTS `stops` (
  `stop_id` varchar(255) NOT NULL,
  `stop_code` varchar(255) DEFAULT NULL,
  `stop_name` varchar(255) NOT NULL,
  `stop_desc` varchar(255) DEFAULT NULL,
  `stop_lat` double NOT NULL,
  `stop_lon` double NOT NULL,
  `zone_id` varchar(255) DEFAULT NULL,
  `stop_url` varchar(255) DEFAULT NULL,
  `location_type` int(1) DEFAULT NULL,
  `parent_station` varchar(255) DEFAULT NULL,
  `stop_timezone` varchar(255) DEFAULT NULL,
  `wheelchair_boarding` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `stop_times`;
CREATE TABLE IF NOT EXISTS `stop_times` (
  `trip_id` varchar(255) NOT NULL,
  `arrival_time` time NOT NULL,
  `departure_time` time NOT NULL,
  `stop_id` varchar(255) NOT NULL,
  `stop_sequence` int(11) NOT NULL,
  `stop_headsign` varchar(255) DEFAULT NULL,
  `pickup_type` int(1) DEFAULT NULL,
  `drop_off_type` int(1) DEFAULT NULL,
  `shape_dist_traveled` decimal(10,5) DEFAULT NULL,
  `timepoint` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `transfers`;
CREATE TABLE IF NOT EXISTS `transfers` (
  `from_stop_id` varchar(255) NOT NULL,
  `to_stop_id` varchar(255) NOT NULL,
  `transfer_type` int(1) NOT NULL,
  `min_transfer_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `trips`;
CREATE TABLE IF NOT EXISTS `trips` (
  `route_id` varchar(255) NOT NULL,
  `service_id` varchar(255) NOT NULL,
  `trip_id` varchar(255) NOT NULL,
  `trip_headsign` varchar(255) DEFAULT NULL,
  `trip_short_name` varchar(255) DEFAULT NULL,
  `direction_id` int(1) DEFAULT NULL,
  `block_id` varchar(255) DEFAULT NULL,
  `shape_id` varchar(255) DEFAULT NULL,
  `wheelchair_accessible` int(1) DEFAULT NULL,
  `bikes_allowed` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `agency`
 ADD PRIMARY KEY (`agency_id`);

ALTER TABLE `calendar`
 ADD PRIMARY KEY (`service_id`);

ALTER TABLE `calendar_dates`
 ADD PRIMARY KEY (`service_id`,`date`);

ALTER TABLE `fare_attributes`
 ADD PRIMARY KEY (`fare_id`);

ALTER TABLE `fare_rules`
 ADD PRIMARY KEY (`fare_id`);

ALTER TABLE `feed_info`
 ADD PRIMARY KEY(`feed_publisher_name`);

ALTER TABLE `frequencies`
 ADD PRIMARY KEY (`trip_id`,`start_time`,`end_time`);

ALTER TABLE `routes`
 ADD PRIMARY KEY (`agency_id`,`route_id`);

ALTER TABLE `shapes`
 ADD PRIMARY KEY (`shape_id`,`shape_pt_sequence`);

ALTER TABLE `stops`
 ADD PRIMARY KEY (`stop_id`),
 ADD INDEX `parent_station` (`parent_station`);

ALTER TABLE `stop_times`
 ADD PRIMARY KEY (`trip_id`, `stop_sequence`),
 ADD INDEX `stop_id` (`stop_id`);

ALTER TABLE `transfers`
 ADD PRIMARY KEY (`from_stop_id`,`to_stop_id`);

ALTER TABLE `trips`
 ADD PRIMARY KEY (`trip_id`),
 ADD INDEX `service_id` (`service_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
