declare @name nvarchar(50), @diversity int
set @name = 'zoe'
select @diversity = Count(Names.count) / (SUM(Names.count)/Count(Names.count))
from Names
where First = @name

--select @diversity

select *, 1 
-- + ROW_NUMBER() OVER(ORDER BY TotalSum) /* Gets popular global names */
--+ ROW_NUMBER() OVER(ORDER BY LocalSum DESC) /* Gets popular names in local set */ /* Gets similar sounding */
--+ ROW_NUMBER() OVER(ORDER BY PercentDiversity DESC) /* Gets the correlation between people per surname in the total set, versus people per surname with the same surname as the current name. In other words are the most popular occurances given. */
--+ ROW_NUMBER() OVER(ORDER BY TotalCount DESC) /* Gets number of surnames in total set */
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
		, AVG(totalCount.total) as [TotalSum]
		, AVG(totalCount.totalCount) as [TotalCount]
		, AVG(totalCount.total) * 1.0 / AVG(totalCount.totalCount) as [TotalDiversity] -- 
		, (1.0 * SUM(n.Count)) / AVG(totalCount.total) as [PercentSum]
		, (1.0 * Count(n.Count)) / AVG(totalCount.totalCount) as [PercentCount]
		--, Count(n.count)
		from Names as n
		inner join Names as lastJoin on lastJoin.Last = n.Last
		inner join 
			(select Names.First as [first], CAST(SUM(Names.count) as bigint) as [total], CAST(COUNT(Names.First) as bigint) as [totalCount]
			from Names
			--where First = 'tabitha'
			group by Names.First) as totalCount on totalCount.first = n.First
		--inner join Names as countJoin on countJoin.First = lastJoin.First
		where lastJoin.First = @name
		group by n.First
		--order by (1.0 * SUM(n.Count)) / AVG(totalCount.total)
		) as temp
	where 
	[LocalCount] > @diversity / 2
	--and TotalCount > 100
	--and Score > 0.3
	--and Score2 > 0.3
	--Order by PercentSum desc, TotalCount desc
) as temp2
Order by [Order] --desc