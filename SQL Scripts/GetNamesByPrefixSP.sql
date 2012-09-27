Alter Procedure GetNamesByPrefix
 @StartsWith nvarchar(50)
AS 

SET NOCOUNT ON;

select TOP 30 Name, [Sum]
from FirstName
where Name like @StartsWith + '%'
order by [Sum] desc