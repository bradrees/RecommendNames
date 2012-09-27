--CREATE TYPE string50_list_tbltype AS TABLE (n nvarchar(50) NOT NULL PRIMARY KEY)
--GO
Alter Procedure GetRelatedNames
 @Names string50_list_tbltype READONLY, 
 @NamesExcluded string50_list_tbltype READONLY,
 @NamesBlocked string50_list_tbltype READONLY 
AS 

SET NOCOUNT ON;
Select top 25
Result
, Names.[Count] as NameCount
, Names.[Sum] as NameSum
, Names.MaleCount
, Names.FemaleCount 
, (SUM(Row) / AVG(ld.Percentage)) / (SUM(Score)) as Ranking
, SUM(Score) as Score
, SUM(Row) as Row
from
(
select TOP 100 Result, 2 as Score, ROW_NUMBER() OVER(Partition by Seed order by Weight) as Row
from RelatedNames
where seed in (SELECT n FROM @Names) and Result not in (SELECT n FROM @Names union all SELECT n FROM @NamesExcluded union all SELECT n FROM @NamesBlocked)

union all

select TOP 100 Seed as Result, 1 as Score, ROW_NUMBER() OVER(order by ResultSum desc) * 3 as Row
from RelatedNames
where result in (SELECT n FROM @Names) and Seed not in (SELECT n FROM @Names union all SELECT n FROM @NamesExcluded union all SELECT n FROM @NamesBlocked)
order by ResultSum desc

union all

select TOP 100 Result, 1 as Score, 1000 as Row
from RelatedNames
where seed in (SELECT n FROM @NamesExcluded) and Result not in (SELECT n FROM @NamesExcluded)


) as Joined
inner join FirstName as Names on Joined.Result = Names.Name
inner join LetterDistribution as ld on ld.Letter = (LEFT(Joined.Result, 1) collate SQL_Latin1_General_CP1_CI_AS)
--where Score > 0
group by Result, Names.[Count], Names.[Sum], Names.MaleCount, Names.FemaleCount
order by (SUM(Row) / AVG(ld.Percentage)) / (SUM(Score)), SUM(Score) desc, SUM(Row)