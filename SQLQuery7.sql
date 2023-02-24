/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
SELECT [MDate], [TradeDate], [TraderId], [IAccountId], [CommodityId], [BS], [Qty], [Price]
FROM [DeriPosition].[dbo].[TradeHty]
where CommodityId in ('00878', '00632R') and TradeDate = '20230222' and TraderId in ('K36', 'K44')
order by MDate


WITH CTE AS (
    SELECT A.*, CAST(TDate AS DATETIME) + CAST(TTime AS DATETIME) AS MDate
    FROM [DeriPosition].[dbo].[TradeHty] A
    WHERE A.TradeDate = '20230222' AND A.CommodityId = '00878'
), CTE2 AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY CommodityId, MDate ORDER BY MDate DESC) AS RN
    FROM [ETFData].[dbo].[ETFTickData]
    WHERE ETFID = '00878'
)
SELECT CTE.*, CTE2.[NAVAsk1]
FROM CTE
LEFT JOIN CTE2 ON CTE.CommodityId = CTE2.CommodityId AND CTE.MDate > CTE2.MDate AND CTE2.RN = 1

SELECT CTE.*, CTE2.* 
FROM CTE
LEFT JOIN CTE2 ON CTE.CommodityId = CTE2.ETFID AND CTE.MDate > CTE2.quote_time 

WITH CTE AS (
    SELECT [MDate], [TradeDate], [TraderId], [IAccountId], [CommodityId], [BS], [Qty], [Price]
    FROM [DeriPosition].[dbo].[TradeHty] A
    WHERE A.TradeDate = '20230222' AND A.CommodityId = '00878' and TraderId = 'K36'
), CTE2 AS (
    SELECT *, CAST(TDate AS DATETIME) + CAST(TTime AS DATETIME) AS quote_time
    FROM [ETFData].[dbo].[ETFTickData]
    WHERE ETFID = '00878' and TDate = '20230222'
)

SELECT A.*, (SELECT TOP 1 * from CTE2) B
where B.quote_time < A.MDate and B.ETFID = A.CommodityId ORDER by MDate desc) 
FROM CTE A

SELECT A.*, (SELECT top 1 [NAVAsk1] from (select *, cast(TDate as datetime) + cast(TTime as datetime) as MDate
			 from [ETFData].[dbo].[ETFTickData] )B
 where B.MDate < A.MDate and B.ETFID = A.CommodityId ORDER by MDate desc)  s
FROM [DeriPosition].[dbo].[TradeHty] A


WITH CTE AS (
    SELECT [MDate], [TradeDate], [TraderId], [IAccountId], [CommodityId], [BS], [Qty], [Price]
    FROM [DeriPosition].[dbo].[TradeHty] A
    WHERE A.TradeDate = '20230222' AND A.CommodityId = '00878' and TraderId = 'K36'
), CTE2 AS (
    SELECT TOP 1 *, CAST(TDate AS DATETIME) + CAST(TTime AS DATETIME) AS quote_time
    FROM [ETFData].[dbo].[ETFTickData]
    WHERE ETFID = '00878' and TDate = '20230222'
    ORDER BY quote_time DESC
)

WITH CTE AS (
    SELECT [MDate], [TradeDate], [TraderId], [IAccountId], [CommodityId], [BS], [Qty], [Price],
           ROW_NUMBER() OVER (ORDER BY MDate DESC) AS rn
    FROM [DeriPosition].[dbo].[TradeHty] A
    WHERE A.TradeDate = '20230222' AND A.CommodityId = '00878' AND TraderId = 'K36'
), CTE2 AS (
    SELECT *,
           CAST([TDate] AS DATETIME) + CAST([TTime] AS DATETIME) AS quote_time,
           ROW_NUMBER() OVER (ORDER BY CAST([TDate] AS DATETIME) + CAST([TTime] AS DATETIME) ASC) AS rn
    FROM [ETFData].[dbo].[ETFTickData]
    WHERE ETFID = '00878' AND TDate = '20230222'
)

SELECT A.*, B.*
FROM CTE A
INNER JOIN CTE2 B
ON B.rn = A.rn




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
SELECT A.*, (select top 1 * from CTE2 B
where B.quote_time < A.MDate ORDER by MDate desc)s
FROM CTE A







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
SELECT A.*, (
    SELECT TOP 1 * 
    FROM CTE2 B
    WHERE B.quote_time < A.MDate AND EXISTS (
        SELECT 1 
        FROM CTE C
        WHERE B.ETFID = C.CommodityId 
        AND B.TDate = C.TradeDate 
        AND B.TTime = C.MDate 
        AND C.TraderId = 'K36'
    )
    ORDER BY MDate DESC
) AS quote
FROM CTE A
