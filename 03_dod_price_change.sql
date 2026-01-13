-- 전일 대비 상승, 하락 종목 살펴보기
USE NASDAQ;

-- 방법 1 : SELF JOIN
SELECT
	a.symbol,
	a.date AS a_date,
	CONVERT(DECIMAL(18,2),a.[close]) AS a_close,
	'' AS'---',
	b.date AS b_date,
	CONVERT(DECIMAL(18,2),b.[close]) AS b_close,
	'' AS'---',
	CONVERT(DECIMAL(18,2),b.[close]-a.[close]) AS diff_price,
	CONVERT(DECIMAL(18,2),(b.[close]-a.[close])/b.[close]*100) AS diff_ratio
FROM stock AS A
	INNER JOIN stock AS B ON a.symbol=b.symbol AND a.date= DATEADD(day,-1,b.date)--이 부분이 정확히 뭘 하는거지?
WHERE a.date='2021-10-06'
ORDER BY diff_ratio DESC;

-- 방법 2 : LEAD
SELECT
	symbol,
	date,
	[close] AS yesterday_close,
	LEAD([close]) OVER (PARTITION BY symbol ORDER BY [date] ASC) AS today_close
FROM stock
WHERE date >='2021-10-06' AND date <= '2021-10-07'
ORDER BY symbol;

-- 근데 기준일(2021-10-06)만 남겨서 증감 결과를 보고 싶다.
-- 방법 1 : 
WITH base AS(
	SELECT
		symbol,
		date,
		[close] AS yesterday_close,
		LEAD([close]) OVER (PARTITION BY symbol ORDER BY date ASC) AS today_close
	FROM stock
)
SELECT * FROM base WHERE date='2021-10-06';

--방법 2 :
SELECT
	symbol,
	[date],
	CONVERT(DECIMAL(18,2),yesterday_close) AS yesterday_close,
	CONVERT(DECIMAL(18,2),today_close) AS today_close,
	CONVERT(DECIMAL(18,2),today_close-yesterday_close) AS diff_price,
	CONVERT(DECIMAL(18,2),(today_close-yesterday_close)/today_close*100) AS diff_ratio
FROM (
	SELECT
		symbol,
		date,
		[close] AS yesterday_close,
		LEAD([close]) OVER (PARTITION BY symbol ORDER BY [date] ASC) AS today_close
	FROM stock
	WHERE date >='2021-10-06' AND date <= '2021-10-07'
) AS X
WHERE today_close IS NOT NULL
ORDER BY symbol; 

-- 전일 대비 최대 상승 종목 상위 3개 검색하기
SELECT TOP 3
	symbol,
	[date],
	CONVERT(DECIMAL(18,2),yesterday_close) AS yesterday_close,
	CONVERT(DECIMAL(18,2),today_close) AS today_close,
	CONVERT(DECIMAL(18,2),today_close-yesterday_close) AS diff_price,
	CONVERT(DECIMAL(18,2),(today_close-yesterday_close)/today_close*100) AS diff_ratio
FROM (
	SELECT
		symbol,
		date,
		[close] AS yesterday_close,
		LEAD([close]) OVER (PARTITION BY symbol ORDER BY [date] ASC) AS today_close
	FROM stock
	WHERE date >='2021-10-06' AND date <= '2021-10-07'
) AS X
WHERE today_close IS NOT NULL
ORDER BY diff_ratio DESC;

-- 임시 테이블을 사용해서 중간 결과 저장
SELECT
	a.symbol,
	a.date AS yesterday_date,
	CONVERT(decimal(18,2),a.[close]) AS yesterday_close,
	b.date AS today_date,
	CONVERT(DECIMAL(18,2),b.[close]-a.[close]) AS diff_price,
	CONVERT(DECIMAL(18,2),(b.[close]-a.[close])/b.[close]*100) AS diff_ratio
	INTO #temp
FROM stock AS A
	INNER JOIN stock AS B ON a.symbol=b.symbol AND a.date=dateadd(day,-1,b.date)
WHERE a.date ='2021-10-06';

SELECT * FROM (SELECT TOP 3 * FROM #temp ORDER BY diff_ratio DESC) AS X
UNION ALL
SELECT * FROM (SELECT TOP 3 * FROM #temp ORDER BY diff_price ASC) AS X;