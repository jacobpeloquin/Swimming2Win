create table Buildings (
	buildingId INT	PRIMARY KEY	IDENTITY,
	address VARCHAR(50),
	city  VARCHAR(50),
	state VARCHAR(50),
	zip VARCHAR(50),
	levels  INT
);
SET IDENTITY_INSERT dbo.Buildings ON 
insert into Buildings (buildingId, address, city , state, zip, levels ) values 
(1, '9861 Russell Alley', 'Sacramento', 'CA', '95852', 7)
,(2, '17963 Goodland Trail', 'Milwaukee', 'WI', '53215', 4)
,(3, '06051 Waubesa Circle', 'Las Vegas', 'NV', '89130', 5)
,(4, '96111 Kingsford Lane', 'Washington', 'DC', '20508', 9)
,(5, '6 Thompson Pass', 'Anniston', 'AL', '36205', 5)
SET IDENTITY_INSERT  dbo.Buildings OFF 


CREATE TABLE Spots (
	spotId			INT	PRIMARY KEY IDENTITY,
	buildingId		INT, 
	buildingLevel	INT,
	carId			INT NULL DEFAULT(NULL),
	employeeId		INT NULL DEFAULT(NULL)
	)

SET IDENTITY_INSERT dbo.Spots ON 
INSERT INTO dbo.Spots
(
    spotId,
    buildingId,
    buildingLevel
)
VALUES
 
 (1,1,2)
,(2,1,2)
,(3,1,2)
,(4,1,2)
,(5,1,2)
,(6,1,2)
,(7,1,2)
,(8,1,2)
,(9,1,2)
,(10,1,2)
,(11,1,2)
,(12,1,2)
,(13,1,2)
,(14,2,1)
,(15,2,1)
,(16,2,1)
,(17,2,1)
,(18,2,1)
,(19,2,1)
,(20,2,1)
,(21,2,1)
,(22,2,1)
,(23,2,1)
,(24,2,1)
,(25,2,1)
,(26,2,1)
,(27,2,1)
,(28,2,1)
,(29,2,1)
,(30,2,1)
,(31,2,1)
,(32,3,2)
,(33,3,2)
,(34,3,2)
,(35,3,2)
,(36,3,2)
,(37,3,2)
,(38,3,2)
,(39,3,2)
,(40,3,2)
,(41,3,2)
,(42,3,2)
,(43,3,2)
,(44,3,2)
,(45,3,2)
,(46,3,2)
,(47,3,2)
,(48,3,2)
,(49,3,2)
,(50,4,4)
,(51,4,4)
,(52,4,4)
,(53,4,4)
,(54,4,4)
,(55,4,4)
,(56,4,4)
,(57,4,4)
,(58,4,4)
,(59,4,4)
,(60,4,4)
,(61,4,4)
,(62,4,4)
,(63,4,4)
,(64,4,4)
,(65,4,4)
,(66,2,4)
,(67,2,4)
,(68,2,4)
,(69,2,4)
,(70,2,4)
,(71,2,4)
,(72,2,4)
,(73,2,4)
,(74,2,4)
,(75,2,4)
,(76,2,4)
,(77,2,4)
,(78,2,4)
,(79,2,4)
,(80,2,4)
,(81,2,4)
,(82,5,3)
,(83,5,3)
,(84,5,3)
,(85,5,3)
,(86,5,3)
,(87,5,3)
,(88,5,3)
,(89,5,3)
,(90,5,3)
,(91,5,3)
,(92,5,3)
,(93,5,3)
,(94,5,3)
,(95,5,3)
,(96,5,3)


SET IDENTITY_INSERT dbo.Spots OFF 