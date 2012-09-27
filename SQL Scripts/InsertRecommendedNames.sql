-- define the last customer ID handled
DECLARE @LastNameId int
SET @LastNameId = -1

select top 1 @LastNameId = n.NameId - 1 from RecommendNames.dbo.RelatedNames
inner join NameOrdered n on RelatedNames.Seed = n.Name
order by n.NameId desc

-- define the name ID to be handled now
DECLARE @NameIdToHandle int
SET @NameIdToHandle = @LastNameId + 1

DECLARE @NameToHandle nvarchar(50)

-- as long as we have names......    
WHILE @LastNameId <> @NameIdToHandle
BEGIN  
  SET @LastNameId = @NameIdToHandle
  -- select the next name to handle    
  SELECT TOP 1 @NameIdToHandle = NameId, @NameToHandle = Name
  FROM NameOrdered
  WHERE NameId > @LastNameId 
  ORDER BY NameId

  IF @NameIdToHandle <> @LastNameId
  BEGIN
	declare @popularityMax int, @popularityMin int

select @popularityMax = Max([Count]), @popularityMin = Min([Count])
from FirstName
where Name = @NameToHandle

--select @NameToHandle, @NameIdToHandle, @popularityMax, @popularityMin

insert into RecommendNames.dbo.RelatedNames (Seed, Result, ResultSum, ResultCount, Weight)

select top 100 @NameToHandle, First, LocalSum, LocalCount, 1 
+ ROW_NUMBER() OVER(ORDER BY TotalSum) /* Gets popular global names */
+ ROW_NUMBER() OVER(ORDER BY LocalSum DESC) /* Gets popular names in local set */ /* Gets similar sounding */
--+ ROW_NUMBER() OVER(ORDER BY PercentDiversity DESC) /* Gets the correlation between people per surname in the total set, versus people per surname with the same surname as the current name. In other words are the most popular occurances given. */
--+ ROW_NUMBER() OVER(ORDER BY TotalCount) /* Gets number of surnames in total set */
+ ROW_NUMBER() OVER(ORDER BY LocalCount DESC) /* Gets number of surnames in common */
+ ROW_NUMBER() OVER(ORDER BY PercentCount DESC) /* Gets percentage of common surnames compared to total number of surnames in the set */
as [Order] from
(
	select /*TOP (@diversity)*/ *, [PercentSum] / [PercentCount]  as PercentTotal, TotalDiversity / LocalDiversity as PercentDiversity from 
	(
		Select n.[first]
		, SUM(n.Count) as [LocalSum]
		, Count(n.Count) as [LocalCount]
		, SUM(n.Count) * 1.0 / Count(n.Count) as [LocalDiversity] -- unique people per surname
		, AVG(CAST(totalCount.[Sum] as bigint)) as [TotalSum]
		, AVG(CAST(totalCount.[Count] as bigint)) as [TotalCount]
		, AVG(CAST(totalCount.[Sum] as bigint)) * 1.0 / AVG(CAST(totalCount.[Count] as bigint)) as [TotalDiversity] -- 
		, (1.0 * SUM(n.Count)) / AVG(CAST(totalCount.[Sum] as bigint)) as [PercentSum]
		, (1.0 * Count(n.Count)) / AVG(CAST(totalCount.[Count] as bigint)) as [PercentCount]
		--, Count(n.count)
		from Names as n
		inner join Names as lastJoin on lastJoin.Last = n.Last
		inner join FirstName totalCount on totalCount.Name = n.First		
		where 
		lastJoin.First = @NameToHandle --in (select Name from @name) --('brad', 'jen') --  --@name
		group by n.First
		) as temp
	where 
	[LocalCount] > @popularityMin / 10
	) as temp2
Order by [Order] --desc
  END


END