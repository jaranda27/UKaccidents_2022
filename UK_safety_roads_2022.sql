CREATE schema ukaccidents;
 USE ukaccidents;
 CREATE TABLE ukaccidents(
	accident_id VARCHAR(13),
    accident_sev INT
);
    
CREATE TABLE vehicles(
	accident_id VARCHAR(13),
    vehicle_type VARCHAR(50)
);
    
CREATE TABLE vehicle_types(
	vehicle_code INT,
	vehicle_type VARCHAR(10)
);
/* Load table data */
LOAD DATA LOCAL INFILE 'C:\\Users\\jorge\\Desktop\\SQL files\\Accidents_2022.csv'
INTO TABLE ukaccidents
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(@col1, @dummy, @dummy, @dummy, @dummy, 
@dummy, @col2, @dummy, @dummy, @dummy, 
@dummy, @dummy, @dummy, @dummy, @dummy, 
@dummy, @dummy, @dummy, @dummy, @dummy, 
@dummy, @dummy, @dummy, @dummy, @dummy, 
@dummy, @dummy, @dummy, @dummy, @dummy, 
@dummy, @dummy)
SET accident_id=@col1, 
	accident_sev=@col2;

LOAD DATA LOCAL INFILE 'C:\\Users\\jorge\\Desktop\\SQL files\\Vehicles_2022.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(@col1, @dummy, @col2, @dummy, @dummy,
 @dummy, @dummy, @dummy, @dummy, @dummy,
 @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy, @dummy, @dummy, @dummy, @dummy, 
 @dummy, @dummy)
 SET accident_id=@col1, vehicle_type=@col2;
 
 LOAD DATA LOCAL INFILE 'C:\\Users\\jorge\\Desktop\\SQL files\\vehicle_types.csv'
 INTO TABLE vehicle_types
 FIELDS TERMINATED BY ','
 ENCLOSED BY '"'
 LINES TERMINATED BY '\n'
 IGNORE 1 LINES;
 
/* Indexig to speed up exceution */
CREATE INDEX accident_id
ON ukaccidents(accident_id);

CREATE INDEX accident_id
ON vehicles(accident_id);

/* Total ammount of accidents per type of vehicle and severity of accident */
SELECT vet.vehicle_type AS Vehicle_type, uka.accident_sev AS Severity, COUNT(vet.vehicle_type) AS Total
FROM ukaccidents AS uka
INNER JOIN vehicles AS veh ON uka.accident_id = veh.accident_id
INNER JOIN vehicle_types AS vet ON veh.vehicle_type = vet.vehicle_code
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Total ammount of accidents by level of severity */
SELECT uka.accident_sev AS Severity, COUNT(vet.vehicle_type) AS Total
FROM ukaccidents AS uka
INNER JOIN vehicles AS veh ON uka.accident_id = veh.accident_id
INNER JOIN vehicle_types AS vet ON veh.vehicle_type = vet.vehicle_code
GROUP BY 1
ORDER BY 2 DESC;

/* Create table to build chart on Average severity by type of vehicle and total accidents*/
CREATE TABLE Avg_severity 
SELECT vet.vehicle_type AS Vehicle_type, AVG(uka.accident_sev) AS AVG_Severity, COUNT(vet.vehicle_type) AS Total
FROM ukaccidents AS uka
INNER JOIN vehicles AS veh ON uka.accident_id = veh.accident_id
INNER JOIN vehicle_types AS vet ON veh.vehicle_type = vet.vehicle_code
GROUP BY 1
ORDER BY 3 DESC;

/* Average severity and total accidents where motorcylces are involved*/
SELECT vet.vehicle_type AS Vehicle_type, AVG(uka.accident_sev) AS Avg_severity, COUNT(vet.vehicle_type) AS Total
FROM ukaccidents AS uka
INNER JOIN vehicles AS veh ON uka.accident_id = veh.accident_id
INNER JOIN vehicle_types AS vet ON veh.vehicle_type = vet.vehicle_code
WHERE vet.vehicle_type LIKE 'Motorcycle'
GROUP BY 1
ORDER BY 2 DESC;








