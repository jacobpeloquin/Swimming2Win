CREATE PROCEDURE spGetUserList
AS 
	SET NOCOUNT ON

	SELECT	u.email,
			u.fName,
			u.gender,
			u.lName,
			u.userID,
			u.userName
	FROM dbo.Users AS u
	ORDER BY u.fName