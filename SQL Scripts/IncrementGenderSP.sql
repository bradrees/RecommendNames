Alter Procedure IncrementGender
 @Name nvarchar(50), 
 @IsMale bit
AS 

SET NOCOUNT ON;

update FirstName set 
MaleCount = case when @IsMale = 1 then MaleCount + 1 else MaleCount end,
FemaleCount = case when @IsMale = 0 then FemaleCount + 1 else FemaleCount end
where Name = @Name