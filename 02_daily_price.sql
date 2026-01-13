USE NASDAQ;

-- 하루 주가 비교( 시작가, 종가, 비율, 최저거래가, 최고거래가, 비율)
SELECT 
	symbol,
	date,
	CONVERT(DECIMAL(18,2),[open])AS [open],
	CONVERT(DECIMAL(18,2),[close])AS [close],
	CONVERT(DECIMAL(18,2),[open]-[close]) AS diff_price,
	CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100) AS diff_ratio,
	'' AS '---',
	CONVERT(DECIMAL(18,2),[low])AS [low],
	CONVERT(DECIMAL(18,2),[high])AS [high],
	CONVERT(DECIMAL(18,2),[high]-[low]) AS diff_traded_price,
	CONVERT(DECIMAL(18,2),([high]-[low])/[low]*100) AS diff_traded_ratio
FROM stock 
WHERE date ='2021-10-06';

-- 가격이 10%이상 오른 종목 검색
SELECT 
	symbol,
	date,
	CONVERT(DECIMAL(18,2),[open])AS [open],
	CONVERT(DECIMAL(18,2),[close])AS [close],
	CONVERT(DECIMAL(18,2),[open]-[close]) AS diff_price,
	CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100) AS diff_ratio,
	'' AS '---',
	CONVERT(DECIMAL(18,2),[low])AS [low],
	CONVERT(DECIMAL(18,2),[high])AS [high],
	CONVERT(DECIMAL(18,2),[high]-[low]) AS diff_traded_price,
	CONVERT(DECIMAL(18,2),([high]-[low])/[low]*100) AS diff_traded_ratio
FROM stock 
WHERE date ='2021-10-06'
	AND CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100)>=10
ORDER BY CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100) DESC;

-- nasdaq_company 테이블과 조인해 기업이름 , 산업군, 산업 종류 함께 검색
SELECT 
	date,
	a.symbol,
	b.company_name,
	b.sector,
	b.industry,
	CONVERT(DECIMAL(18,2),[open])AS [open],
	CONVERT(DECIMAL(18,2),[close])AS [close],
	CONVERT(DECIMAL(18,2),[open]-[close]) AS diff_price,
	CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100) AS diff_ratio,
	'' AS '---',
	CONVERT(DECIMAL(18,2),[low])AS [low],
	CONVERT(DECIMAL(18,2),[high])AS [high],
	CONVERT(DECIMAL(18,2),[high]-[low]) AS diff_traded_price,
	CONVERT(DECIMAL(18,2),([high]-[low])/[low]*100) AS diff_traded_ratio
FROM stock AS a
	INNER JOIN nasdaq_company AS b ON a.symbol=b.symbol
WHERE date ='2021-10-06'
	AND CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100)>=10
ORDER BY CONVERT(DECIMAL(18,2),([close]-[open])/[open]*100) DESC;


