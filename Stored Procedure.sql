Drop Procedure If Exists IntoTable1;
Drop Table Table1;

CREATE TABLE Table1 (
    ID int NOT NULL AUTO_INCREMENT,
    FName char(255) NOT NULL,
    Age int,
    DefaultAge int,
    PRIMARY KEY (ID)
);


DELIMITER //

Create Procedure IntoTable1 (IN FN CHAR(255), IN Ag INT, IN Dg INT, OUT pq INT)
BEGIN
	DECLARE xy INT DEFAULT 0;
    Set xy = 5;
    
    Case Dg
		When 2 Then
			Set Ag = 30;
		When 3 Then
			Set Ag = 40;
		Else
			Set Ag = 25;
	End case;
    
    
	If Dg = 1 Then
		Set Ag = 20;
	End IF;
    
    
    If Dg > xy Then
		Set Dg = xy;
	End IF;
    
    
    insert into Table1 (FName, Age, DefaultAge) values (FN, Ag, Dg);
    
    select count(*) into pq from Table1;
    select sum(Age*DefaultAge) from Table1;
    
END //

DELIMITER ;


Call IntoTable1 ("Saad", 24, 0,@pq);
Call IntoTable1 ("Fahad", 26, 1,@pq);
Call IntoTable1 ("Umar", 27, 2,@pq);
Call IntoTable1 ("Talha", 27, 3,@pq);
Call IntoTable1 ("Adil", 27, 0,@pq);
Call IntoTable1 ("Ranu", 27, 3,@pq);
Call IntoTable1 ("Musa", 22, 7,@pq);

Call IntoTable1 ("This is default age", 25, 1,@pq);
Call IntoTable1 ("This is not a default age", 25, 2,@pq);

select * from Table1 order by Age;
select @pq;

select routine_name from information_schema.routines where routine_type = 'PROCEDURE' AND routine_schema = 'sakila'; 



# ----------------------------------------------  Example of For Loop  ----------------------------------------------  

DROP PROCEDURE If Exists LoopDemo;

DELIMITER //
CREATE PROCEDURE LoopDemo()
BEGIN
	DECLARE x  INT;
	DECLARE str  VARCHAR(255);
        
	SET x = 1;
	SET str =  '';
        
	loop_label:  LOOP
		IF  x > 10 THEN 
			LEAVE  loop_label;
		END  IF;
            
		SET  x = x + 1;
		
        IF  (x mod 2) THEN
			ITERATE  loop_label;
		ELSE
			SET  str = CONCAT(str,x,',');
		END  IF;
	END LOOP;
	
    SELECT str;
END//

DELIMITER ;

Call LoopDemo();





# ----------------------------------------------  Example of While Loop  ----------------------------------------------  

Drop Procedure If Exists InsertCalendar;
Drop Procedure If Exists LoadCalendars;
Drop Table If Exists calendars;

CREATE TABLE calendars(
    id INT AUTO_INCREMENT,
    fulldate DATE UNIQUE,
    day TINYINT NOT NULL,
    month TINYINT NOT NULL,
    quarter TINYINT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY(id)
);


DELIMITER //

CREATE PROCEDURE InsertCalendar(dt DATE)
BEGIN
    INSERT INTO calendars(
        fulldate,
        day,
        month,
        quarter,
        year
    )
    VALUES(
        dt, 
        EXTRACT(DAY FROM dt),
        EXTRACT(MONTH FROM dt),
        EXTRACT(QUARTER FROM dt),
        EXTRACT(YEAR FROM dt)
    );
END//

DELIMITER ;


DELIMITER //

CREATE PROCEDURE LoadCalendars(
    startDate DATE, 
    day INT
)
BEGIN
    
    DECLARE counter INT DEFAULT 1;
    DECLARE dt DATE DEFAULT startDate;

    WHILE counter <= day DO
        CALL InsertCalendar(dt);
        SET counter = counter + 1;
        SET dt = DATE_ADD(dt,INTERVAL 1 day);
    END WHILE;
	
    select * from calendars;
END //

DELIMITER ;

CALL LoadCalendars('2019-01-01',31);


# Note: 'Leave' statement is used to exit a stored program or 
# terminate a loop. For Example: If (so and so condition) fulfills
# then Leave [loop_label]; 


