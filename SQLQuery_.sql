/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
SELECT A.*, (SELECT top 1 *  from (select *, cast(TDate as datetime) + cast(TTime as datetime) as MDate
			 from [ETFData].[dbo].[ETFTickData] )B
 where B.MDate < A.MDate and B.ETFID = A.CommodityId ORDER by MDate desc)  s
FROM [DeriPosition].[dbo].[TradeHty] A
where A.TradeDate = '20230222' and A.CommodityId = '00878'


WITH CTE AS (
    SELECT [MDate], [TradeDate], [TraderId], [IAccountId], [CommodityId], [BS], [Qty], [Price]
    FROM [DeriPosition].[dbo].[TradeHty] A
    WHERE A.TradeDate = '20230222' AND A.CommodityId = '00878' AND TraderId = 'K36'
), CTE2 AS (
    SELECT *,
           CAST([TDate] AS DATETIME) + CAST([TTime] AS DATETIME) AS quote_time
    FROM [ETFData].[dbo].[ETFTickData]
    WHERE ETFID = '00878' AND TDate = '20230222'
)