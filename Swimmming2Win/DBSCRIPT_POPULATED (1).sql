USE master
GO
/****** Object:  Database AP     ******/
IF DB_ID('dunnmj4') IS NOT NULL
DROP DATABASE dunnmj4
GO

/*
Swimming2Win DB

Authors:
	- Matt Dunn
	- Jacob Peloquin
	- Brian Rodgers Vargo
	- Nick Ward
*/

CREATE DATABASE dunnmj4
GO
USE dunnmj4
GO 
--======================== Create Tables

/*
	Table 1. Users
	Fields:
		- userID
		- userName
		- password
		- email
*/

CREATE TABLE [dbo].[Users] (
    [userID]       INT          IDENTITY (1, 1) NOT NULL,
    [userName]     VARCHAR (99) NOT NULL,
    [password]     Varchar (64) NOT NULL,
    [email]        VARCHAR (99) NOT NULL,
    [fName]        VARCHAR (99) NOT NULL,
    [lName]        VARCHAR (99) NOT NULL,
    [gender]       VARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([userID] ASC)
);

/*
	Table 2. Workouts
	Fields:
		- workoutID
		- workoutTitle
		- date
		- userID
		- locationID
*/

CREATE TABLE [dbo].[Workouts] (
    [workoutID]    INT          IDENTITY (1, 1) NOT NULL,
    [workoutTitle] VARCHAR (100) NULL,
    [workoutDate]  DATE         NULL,
    [userID]       INT          NOT NULL,
    [locationID]   INT          NULL,
    PRIMARY KEY CLUSTERED ([workoutID] ASC),
    FOREIGN KEY ([userID]) REFERENCES [dbo].[Users] ([userID])
);



/*
	Table 3. WorkoutSets
	Fields:
		- workoutSetID
		- workoutID
		- name
		- time
		- distance
		- description
*/

CREATE TABLE [dbo].[WorkoutSets] (
    [workoutSetID]   INT           IDENTITY (1, 1) NOT NULL,
    [workoutID]      INT           NOT NULL,
    [setName]        VARCHAR (99)  NOT NULL,
    [setTime]        INT      NOT NULL,
    [distance]       INT           NOT NULL,
    [setDescription] NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([workoutSetID] ASC),
    FOREIGN KEY ([workoutID]) REFERENCES [dbo].[Workouts] ([workoutID])
);

/*
	Table 4. Locations
	Fields:
		- locationID
		- address
		- city
		- state
		- locationName
		- userID
		- poolType
*/


CREATE TABLE [dbo].[Locations] (
    [locationID]   INT           IDENTITY (1, 1) NOT NULL,
    [locationName] VARCHAR (100)  NOT NULL,
    [address]      VARCHAR (255) NOT NULL,
    [city]         VARCHAR (100)  NOT NULL,
    [state]        VARCHAR (10)   NOT NULL,
    [poolType]     VARCHAR (100)  NOT NULL,
    PRIMARY KEY CLUSTERED ([locationID] ASC)
);



--======================== Create Stored Proceedures ... inserting 

/*
	SP 1. spAddUser - w/PasswordHash encryption
*/


GO
CREATE PROCEDURE spAddUser
	@Username	VARCHAR(99),
	@Password	VARCHAR(99),
	@email		VARCHAR(99),
	@fName		VARCHAR(99),
	@lName		VARCHAR(99),
	@gender		VARCHAR(10)

AS BEGIN

	BEGIN TRY

		INSERT INTO Users (userName, 
						   password, 
						   email, 
						   fName, 
						   lName, 
						   gender)

		VALUES (@Username, 
				HASHBYTES('SHA2_512', @Password), 
				@email, 
				@fName,
				@lName,
				@gender)

	SELECT TOP 1 * 
	FROM dbo.Users AS u 
	ORDER BY u.userID DESC
	FOR  JSON PATH

	END TRY

	BEGIN CATCH
		PRINT ERROR_MESSAGE()
	END CATCH
END


/*
	SP 2. spAddWorkout
*/


GO
CREATE PROCEDURE spAddWorkout
	@workoutTitle VARCHAR(99),
	@workoutDate  DATE,
	@userID		  INT,
	@locationID	  INT

AS
BEGIN	

BEGIN TRY
	
	INSERT INTO Workouts (
		workoutTitle,
		workoutDate,
		userID,
		locationID
	)
	VALUES (
		@workoutTitle,
		@workoutDate,
		@userID,
		@locationID
	)
	SELECT TOP 1 * 
	FROM dbo.Workouts AS w 
	ORDER BY w.workoutID DESC
	FOR  JSON PATH
END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

END
GO



/*
	SP 3. spAddLocation
*/


GO
CREATE PROCEDURE spAddLocation
	@locationName	VARCHAR(99),
	@address		VARCHAR(255),
	@city			VARCHAR(99),
	@state			VARCHAR(2),
	@poolType		VARCHAR(99)

AS
BEGIN

BEGIN TRY

	INSERT INTO Locations (
		locationName,
		address,
		city,
		state,
		poolType
	
	)
	VALUES (
		@locationName,
		@address,
		@city,
		@state,
		@poolType
		
	)
	SELECT TOP 1 * 
	FROM dbo.Locations AS l 
	ORDER BY l.locationID DESC
	FOR  JSON PATH

END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH

END


/*
	SP 4. spAddLocation
*/

GO
CREATE PROCEDURE spAddWorkoutSet
	@workoutID		INT,
	@setName		VARCHAR(99),
	@setTime		INT,
	@distance		INT,
	@setDescription	VARCHAR(255)

AS 
BEGIN

BEGIN TRY

	INSERT INTO WorkoutSets(
		workoutID,
		setName,
		setTime,
		distance,
		setDescription
	)
	VALUES(
		@workoutID,
		@setName,
		@setTime,
		@distance,
		@setDescription
	)
	SELECT TOP 1 * 
	FROM dbo.WorkoutSets AS ws
	ORDER BY ws.workoutSetID DESC
	FOR  JSON PATH
END TRY

BEGIN CATCH
	PRINT ERROR_MESSAGE()
END CATCH


END

/*
	SP 1. spGetUserPastLocationsByState
*/

GO 
CREATE PROCEDURE spGetUserPastLocationsByState 
		 
		@userID INT, 
		@state VARCHAR(2) 
AS
BEGIN 
	SELECT l.locationName 
	FROM	dbo.Users AS u
		JOIN Workouts AS w ON	w.userID = u.userID 
		JOIN dbo.Locations l ON l.locationID = w.locationID
	WHERE	@state = l.state AND 
			@userID = u.userID
	FOR JSON PATH 
			
END
GO 

/*
	SP 2. spGetUserPastLocationsByCity
*/
GO 
CREATE PROCEDURE spGetUserPastLocationsByCity	
		@userID INT,
		@city VARCHAR(99)
AS
BEGIN 
	SELECT l.locationName
	FROM	dbo.Users AS u
		JOIN Workouts AS w ON	w.userID = u.userID 
		JOIN dbo.Locations l ON l.locationID = w.locationID
	WHERE @city = city AND 
		@userID = u.userID
	FOR JSON PATH 
END 
GO 


/*
	SP 3. spGetPastSetsBySetName
*/
GO 
CREATE PROCEDURE spGetPastSetsBySetName
		@setName VARCHAR(99), 
		@userID INT 
AS
BEGIN 
	SELECT * 
	FROM	dbo.WorkoutSets ws
		JOIN dbo.Workouts w ON w.workoutID = ws.workoutID
		JOIN dbo.Users u ON u.userID = w.userID
	WHERE	@setName = setName AND 
			@userID = u.userID
					
END 
GO 

/*
	SP 4. spGetPastSetsByDistance
*/
GO 
CREATE PROCEDURE spGetPastSetsByDistance
		@distance VARCHAR(99) ,
		@userID INT 
AS
BEGIN 
	SELECT * 
	FROM	dbo.WorkoutSets ws
		JOIN dbo.Workouts w ON w.workoutID = ws.workoutID
		JOIN dbo.Users u ON u.userID = w.userID
	WHERE @distance = distance AND 
			@userID = u.userID
END 
GO 



/*
	SP 6. spGetPastWorkoutsByDate
*/
GO
CREATE PROCEDURE spGetUsersPastWorkoutsByDate
	@workoutDate	VARCHAR(99),
	@userID			INT
AS 
	BEGIN 
		SELECT	w.workoutTitle,
				u.fName + ' ' + u.lName AS [User]
		FROM dbo.Workouts AS w
			JOIN dbo.Users AS u
				ON u.userID = w.userID
		WHERE @workoutDate = workoutDate AND @userId = u.userID
		FOR JSON PATH
	END
--=========
GO

CREATE PROCEDURE spGetUserList
	@page INT = 1
AS
	SET NOCOUNT ON  -- what does this do?
	SET @page = @page-1;

	   DECLARE @takeRows int = 5
	declare @skipRows int = @takeRows * @page
    declare @count int = 0

	SELECT	u.fName,
			u.lName,
			u.email,
			u.userName,
			u.gender,
			u.userID,
			Count(*) Over() AS TotalRows,
			[pages] = (Count(*) Over() / @takeRows) + iif(Count(*) Over() % @takeRows > 0 ,1,0)
		   
	FROM dbo.Users AS u
	WHERE u.userID IN ( SELECT 
		userID 
		FROM Workouts
	)
	ORDER BY u.lName
	OFFSET @skipRows ROWS
	FETCH NEXT @takeRows ROWS ONLY;
GO

--=======
CREATE PROCEDURE spGetSetDetails 
	@userID INT 
AS 
	SET NOCOUNT ON 
	
	SELECT	u.fName + ' ' + u.lName AS [User],
			[Workouts] = (
			SELECT	w.workoutID,
					w.workoutTitle,
					w.workoutDate,
					[Sets] = (
						SELECT	ws.workoutSetID,
								ws.setName,
								ws.setTime,
								ws.distance,
								ws.setDescription
						FROM dbo.WorkoutSets AS ws
								WHERE workoutID = w.workoutID
								FOR JSON PATH
								)
			FROM dbo.Workouts AS w 
			WHERE userID = u.userID
			FOR JSON PATH 
			)
	FROM dbo.Users AS u
	WHERE u.userID = @userID 
	ORDER BY u.lName
	FOR JSON PATH

GO
--=====
CREATE PROCEDURE spGetWorkoutDetails
	@userID INT 
AS 
	SET NOCOUNT ON 

	SELECT u.fName + ' ' + u.lName AS [User],
	[Workouts] = (
			SELECT	w.workoutID,
					w.workoutTitle,
					w.workoutDate,
					l.locationName
			FROM dbo.Workouts w 
				JOIN dbo.Locations l ON l.locationID = w.locationID
			WHERE u.userID = w.userID
			FOR JSON PATH 
			)
	FROM users u
	WHERE u.userID = @userID
	ORDER BY u.lName
	FOR JSON PATH

--=======
GO
CREATE PROCEDURE spGetUserIdByEmail
	@email VARCHAR(100)
AS 
	SET NOCOUNT ON 

	SELECT u.userID
	FROM users AS u
	WHERE u.email = @email
	FOR JSON PATH
	
--========
GO 
CREATE PROCEDURE spGetSetDetailsbyUserName
	@userName VARCHAR(100)
AS 
	SET NOCOUNT ON 
	
	SELECT	u.fName + ' ' + u.lName AS [User],
			[Workouts] = (
			SELECT	w.workoutID,
					w.workoutTitle,
					w.workoutDate,
					[Sets] = (
						SELECT	ws.workoutSetID,
								ws.setName,
								ws.setTime,
								ws.distance,
								ws.setDescription
						FROM dbo.WorkoutSets AS ws
								WHERE workoutID = w.workoutID
								FOR JSON PATH
								)
			FROM dbo.Workouts AS w 
			WHERE userID = u.userID
			FOR JSON PATH 
			)
	FROM dbo.Users AS u
	WHERE u.fName + ' ' + u.lName = @userName
	ORDER BY u.lName
	FOR JSON PATH
--========
GO	
CREATE PROCEDURE spGetWorkoutsByLocationName
	@locName VARCHAR(100)
AS
	SET NOCOUNT ON 

	SELECT	l.locationName,
			[workouts] = (
			SELECT	w.workoutID,
					w.workoutTitle,
					w.workoutDate
			FROM dbo.Workouts AS w
				WHERE w.locationID = l.locationID
				FOR JSON PATH 
			)

	FROM dbo.Locations AS l
	WHERE l.locationName = @locName
	FOR JSON PATH
GO
--=======
CREATE PROCEDURE spGetUsersLocationsByUserID
	@userID int
AS
	SET NOCOUNT ON 

	SELECT	DISTINCT l.locationName

	FROM dbo.Locations AS l
		JOIN Workouts AS w 
			ON w.locationID = l.locationID
	JOIN dbo.Users AS u
			ON u.userID = w.userID
	WHERE u.userID = @userID
	FOR JSON PATH
	
GO
--==========
CREATE PROCEDURE spGetUsersWithsameWorkouts 
	@workoutName VARCHAR(100)
AS

	SET NOCOUNT ON 
		SELECT	w.workoutTitle,
				[users] = (
					SELECT	u.fName + ' ' + u.fName AS [Users]
					FROM dbo.Users AS u
					WHERE u.userID = w.userID
					ORDER BY u.userName
					FOR JSON PATH
					)
		FROM dbo.Workouts AS w
		WHERE w.workoutTitle = @workoutName
		FOR JSON PATH
GO
--========
CREATE PROCEDURE spGetSetDetailsbyUserID
	@userID INT 
AS 
	SET NOCOUNT ON 
	
	SELECT	u.fName + ' ' + u.lName AS [User],
			[Workouts] = (
			SELECT	w.workoutID,
					w.workoutTitle,
					w.workoutDate,
					[Sets] = (
						SELECT	ws.workoutSetID,
								ws.setName,
								ws.setTime,
								ws.distance,
								ws.setDescription
						FROM dbo.WorkoutSets AS ws
								WHERE workoutID = w.workoutID
								FOR JSON PATH
								)
			FROM dbo.Workouts AS w 
			WHERE userID = u.userID
			FOR JSON PATH 
			)
	FROM dbo.Users AS u
	WHERE u.userID = @userID
	ORDER BY u.lName
	FOR JSON PATH
	GO 
--========	
BULK INSERT dbo.Users 
	FROM 'C:/temp/Users.txt'
		WITH (
			FIRSTROW = 1,
			ROWTERMINATOR = '\n',
			FIELDTERMINATOR = ','
		)
GO
        
BULK INSERT dbo.WorkoutSets
	FROM 'C:/temp/Set.txt'
		WITH (
			FIRSTROW = 1,
			ROWTERMINATOR = '\n',
			FIELDTERMINATOR = ','
		)
BULK INSERT dbo.Locations 
	FROM 'C:/temp/Locations.txt'
		WITH (
			FIRSTROW = 1,
			ROWTERMINATOR = '\n',
			FIELDTERMINATOR = ','
		)
GO

BULK INSERT dbo.Workouts 
	FROM 'C:/temp/Workouts.txt'
		WITH (
			FIRSTROW = 1,
			ROWTERMINATOR = '\n',
			FIELDTERMINATOR = ','
		)
		
GO
CREATE TABLE usersLogHistory(
	[userID]   INT          NOT NULL,
    [userName] VARCHAR (99)  NOT NULL,
    [password] VARCHAR (64)  NOT NULL,
    [email]    VARCHAR (99)  NOT NULL,
    [fName]    VARCHAR (99)  NOT NULL,
    [lName]    VARCHAR (99)  NOT NULL,
    [gender]   VARCHAR (100) NOT NULL,
	updatedBy  VARCHAR(100),
	updatedOn  DATETIME
)
Go
CREATE TRIGGER usersLogTrigger ON dbo.Users
	AFTER INSERT, UPDATE, DELETE
		AS 	
			BEGIN
				INSERT INTO usersLogHistory

				SELECT	i.userID,  
						i.userName,
						i.password,
						i.email,   
						i.fName, 
						i.lName, 
						i.gender,
						SUSER_NAME(),
						GETDATE()
				FROM Inserted AS i
					JOIN dbo.Users AS u 
						ON u.userID = i.userID
			END
GO 
CREATE TABLE workoutsLogHistory(
		[workoutID]			INT			NOT NULL,
		[workoutTitle]		VARCHAR(99) NOT NULL,
		[workoutDate]		DATE		NOT NULL,
		[userID]			INT			NOT NULL,
		[locationID]		INT			NOT NULL,
		updatedBy			VARCHAR(100),
		updatedOn			DATETIME
)
GO
CREATE TRIGGER workoutsLogTrigger ON dbo.Workouts
	AFTER INSERT, UPDATE, DELETE
		AS 	
			BEGIN
				INSERT INTO workoutsLogHistory

				SELECT	i.workoutID,  
						i.workoutTitle,
						i.workoutDate,
						i.userID,   
						i.locationID,
						SUSER_NAME(),
						GETDATE()
				FROM Inserted AS i
					JOIN dbo.Workouts AS w 
						ON w.workoutID = i.workoutID
			END
GO 
CREATE TABLE workoutSetsLogHistory(
	    workoutSetID 	INT			 NOT NULL,
	    workoutID		INT			 NOT NULL,
	    setName			VARCHAR(100) NOT NULL,
	    setTime			INT			 NOT NULL,
	    distance		INT			 NOT NULL,
	    setDescription	NVARCHAR(MAX) NOT NULL,
		updatedBy		VARCHAR(100),
		updatedOn		DATETIME
)
Go
CREATE TRIGGER workoutSetsLogTrigger ON dbo.WorkoutSets
	AFTER INSERT, UPDATE, DELETE
		AS 	
			BEGIN
				INSERT INTO workoutSetsLogHistory

				SELECT	i.workoutSetID,  
						i.workoutID,
						i.setName,
						i.setTime,
						i.distance,
						i.setDescription,
						SUSER_NAME(),
						GETDATE()
				FROM Inserted AS i
					JOIN dbo.WorkoutSets AS ws 
						ON ws.workoutSetID = i.workoutSetID
			END
GO 
CREATE TABLE locationsLogHistory(
	    locationID  INT			 NOT NULL,
	    locationName  VARCHAR(100)			 NOT NULL,
	    address    VARCHAR(100) NOT NULL,
	    city       VARCHAR(100)			 NOT NULL,
	    state      VARCHAR(10)			 NOT NULL,
	    poolType   VARCHAR(100) NOT NULL,
		updatedBy		VARCHAR(100),
		updatedOn		DATETIME
)
Go
CREATE TRIGGER locationsTrigger ON dbo.Locations
	AFTER INSERT, UPDATE, DELETE
		AS 	
			BEGIN
				INSERT INTO locationsLogHistory

				SELECT	i.locationID,  
						i.locationName,
						i.address,     
						i.city,        
						i.state,       
						i.poolType,   
						SUSER_NAME(),
						GETDATE()
				FROM Inserted AS i
					JOIN dbo.Locations AS l
						ON l.locationID = i.locationID
			END
GO 
CREATE PROCEDURE spDeleteUserbyUserID
	@userID INT 
AS
	BEGIN

			DELETE Users 
			WHERE dbo.Users.userID = @userID
			EXEC spShowLastEntryInUsersLogHistory;
			
	END 
			
GO 
CREATE PROCEDURE spDeleteLocationbylocationID
	@locationID INT 
AS
	BEGIN
			DELETE dbo.Locations
			WHERE Locations.locationID = @locationID

			EXEC spShowLastEntryInLocationsLogHistory;
			
			
	END
GO
CREATE PROCEDURE spDeleteWorkoutbyWorkoutID
	@workoutID INT 
AS
	BEGIN
			DELETE dbo.Workouts
			WHERE Workouts.workoutID = @workoutID
			EXEC spShowLastEntryInWorkoutsLogHistory
	END
GO
CREATE PROCEDURE spDeleteSetbySetID
	@workoutSetID INT 
AS
	BEGIN
			DELETE dbo.WorkoutSets 
			WHERE WorkoutSets.workoutSetID = @workoutSetID
			EXEC spShowLastEntryInSetsLogHistory
			
	END
GO

CREATE PROCEDURE spShowLastEntryInUsersLogHistory
	AS
	BEGIN 
		SELECT TOP 1 *
		FROM dbo.usersLogHistory
		ORDER BY updatedOn DESC
		FOR JSON PATH
	END 
GO 
CREATE PROCEDURE spShowLastEntryInLocationsLogHistory
	AS
	BEGIN 
		SELECT TOP 1 *
		FROM dbo.locationsLogHistory
		ORDER BY updatedOn DESC
		FOR JSON PATH
	END 
GO 
CREATE PROCEDURE spShowLastEntryInWorkoutsLogHistory
	AS
	BEGIN 
		SELECT TOP 1 *
		FROM dbo.workoutsLogHistory
		ORDER BY updatedOn DESC
		FOR JSON PATH
	END 
GO 
CREATE PROCEDURE spShowLastEntryInSetsLogHistory
	AS
	BEGIN 
		SELECT TOP 1 *
		FROM dbo.workoutSetsLogHistory
		ORDER BY updatedOn DESC
		FOR JSON PATH
	END 

GO 
CREATE PROCEDURE spUpdateLocations
	@locationID		INT,
	@locationName	VARCHAR(99),
	@address		VARCHAR(255),
	@city			VARCHAR(99),
	@state			VARCHAR(2),
	@poolType		VARCHAR(99)

	AS
		BEGIN

			

			UPDATE  Locations SET	locationName = @locationName,
									address = @address,
									city = @city,
									state = @state,
									poolType = @poolType
									WHERE locationID = @locationID
									EXEC spShowLastEntryInLocationsLogHistory

		END
GO
CREATE PROCEDURE spUpdateUsers
	@userID		INT,
	@Username	VARCHAR(99),
	@Password	VARCHAR(99),
	@email		VARCHAR(99),
	@fName		VARCHAR(99),
	@lName		VARCHAR(99),
	@gender		VARCHAR(10)
	AS
		BEGIN

			UPDATE  dbo.Users SET	
									userName = @Username,
									password = @Password,	
									email = @email,	
									fName = @fName,		
									lName = @lName,		
									gender = @gender	
									WHERE userID = @userID
									EXEC spShowLastEntryInUsersLogHistory
		END
GO
CREATE PROCEDURE spUpdateWorkouts
	@workoutID		INT,
	@workoutTitle	VARCHAR(99),
	@workoutDate	DATE,
	@userID			INT,
	@locationID		INT
	AS
		BEGIN

			UPDATE  dbo.Workouts SET	
								workoutTitle = @workoutTitle,
								workoutDate = @workoutDate, 
								userID = @userID,		 
								locationID = @locationID	 
									WHERE workoutID = @workoutID
									EXEC spShowLastEntryInWorkoutsLogHistory
		END
GO
CREATE PROCEDURE spUpdateWorkoutSets
	@workoutSetID	INT,
	@workoutID		INT,
	@setName		VARCHAR(99),
	@setTime		INT,
	@distance		INT,
	@setDescription	VARCHAR(255)
	AS
		BEGIN

			UPDATE  WorkoutSets SET	
								workoutID = @workoutID,
								setName = @setName,
								setTime = @setTime,
								distance = @distance,
								setDescription = @setDescription
								WHERE workoutSetID = @workoutSetID
								EXEC spShowLastEntryInSetsLogHistory
								
		END
GO


use dunnmj4
select * from Locations