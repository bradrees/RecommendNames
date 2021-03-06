USE [RecommendNames]
GO

DECLARE	@return_value int
DECLARE @Names string50_list_tbltype
INSERT @Names(n) VALUES('zoe'),('chloe')--,('jodie'),('ellie'),('kellie')--,('james')--,('jodie')
--INSERT @mylist(n) VALUES('jennifer'),('peter'),('james')

DECLARE @NamesExcluded string50_list_tbltype
INSERT @NamesExcluded(n) VALUES('gillian')--,('colin'),('andrew'),('our')

DECLARE @NamesBlocked string50_list_tbltype
INSERT @NamesBlocked(n) VALUES('faye'),('june')

--select n from @mylist
--cross join @mylist as x

EXEC	@return_value = [dbo].[GetRelatedNames]
		@Names = @Names,
		@NamesExcluded = @NamesExcluded,
		@NamesBlocked = @NamesBlocked

SELECT	'Return Value' = @return_value

GO
