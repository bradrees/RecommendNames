select distinct Result, count(1) as x from RelatedNames
group by Result
order by x desc