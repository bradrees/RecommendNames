declare @name Table (Name nvarchar(50))
declare @popularityMax int, @popularityMin int
--set @name = 'trevor'
Insert into @name 
select 'zoe'
--union all select 'georgia'
--('Andy', 'Lucy', 'emily', 'cindy', 'julie', 'Natalie')

select @popularityMax = Max([Count]), @popularityMin = Min([Count])
from FirstName
where Name in (select Name from @name)

select @popularityMax, @popularityMin

select top 100 *, 1 
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
		--	(select Names.First as [first], CAST(SUM(Names.count) as bigint) as [total], CAST(COUNT(Names.First) as bigint) as [totalCount]
		--	from Names
			--where First = 'tabitha'
		--	group by Names.First) as totalCount on totalCount.first = n.First
		--inner join Names as countJoin on countJoin.First = lastJoin.First
		where 
		-- totalCount.Name like 'b%' and
		lastJoin.First in (select Name from @name) --('brad', 'jen') --  --@name
		--and n.Count > lastJoin.Count * 4
		-- and totalCount.[Count] > SQRT(@popularityMin)
		--and lastJoin.[Count] < @popularityMax * 10
		--and lastJoin.[Count] < @popularityMin / 5 
		group by n.First
		--order by (1.0 * SUM(n.Count)) / AVG(totalCount.total)
		) as temp
	where 
	[LocalCount] > @popularityMin / 10
	--and TotalCount > 100
	--and Score > 0.3
	--and Score2 > 0.3
	--Order by PercentSum desc, TotalCount desc
	) as temp2
Order by [Order] --desc