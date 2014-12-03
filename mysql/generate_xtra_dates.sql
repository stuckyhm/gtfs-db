DROP TABLE IF EXISTS `xtra_dates`;
CREATE TABLE IF NOT EXISTS `xtra_dates` (
  `date` DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `xtra_dates`
 ADD PRIMARY KEY (`date`);


DROP PROCEDURE IF EXISTS `generate_dates`;
DELIMITER $$
    CREATE PROCEDURE generate_dates(start_date DATE, end_date DATE)
    BEGIN
    DECLARE crt_date DATE;
    SET crt_date = start_date;
    WHILE crt_date <= end_date DO
        INSERT IGNORE INTO xtra_dates VALUES(crt_date);
        SET crt_date = ADDDATE(crt_date, INTERVAL 1 DAY);
    END WHILE;
    END$$
DELIMITER ;


DROP PROCEDURE IF EXISTS `generate_dates_from_calendar`;
DELIMITER $$
    CREATE PROCEDURE generate_dates_from_calendar()
    BEGIN
        DECLARE start_date DATE;
    	DECLARE end_date DATE;
     
    	SET start_date = (SELECT min(t.date) FROM (SELECT c.start_date AS date FROM calendar AS c UNION SELECT cd.date FROM calendar_dates AS cd) AS t);
    	SET end_date = (SELECT max(t.date) FROM (SELECT c.end_date AS date FROM calendar AS c UNION SELECT cd.date FROM calendar_dates AS cd) AS t);
    	
		CALL generate_dates(start_date, end_date);
    
    END$$
DELIMITER ;

CALL generate_dates_from_calendar();
