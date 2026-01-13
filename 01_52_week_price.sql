USE NASDAQ;

-- 52주(1년)동안 최고가, 최저가, 그리고 그 차이, 비율 구하기
SELECT 
	symbol, 
	CONVERT(DECIMAL(18,2), MIN([close]))AS min_price,
	CONVERT(DECIMAL(18,2),MAX([close]))AS max_price,
	CONVERT(DECIMAL(18,2),MAX([close])-MIN([close])) AS diff,
	CONVERT(DECIMAL(18,2),(MAX([close])-MIN([close]))/(MIN([close])*100) AS diff_ratio
FROM stock 
WHERE date > = DATEADD(week,-52,'2021-10-04') AND date<='2021-10-04'
GROUP BY symbol;

-- 서브쿼리 이용
SELECT 
	X.symbol,
	min_price,
	max_price,
	max_price-min_price AS diff_price,
	CONVERT(DECIMAL(18,2),
	CASE 
		WHEN min_price>0 THEN (max_price-min_price)/(min_price*100)
		ELSE 0 
	END
	)AS diff_ratio
FROM (
	SELECT 
		symbol, 
		CONVERT(DECIMAL(18,2),MIN([close]))AS min_price,
		CONVERT(DECIMAL(18,2),MAX([close]))AS max_price
	FROM stock
	WHERE date > = DATEADD(week,-52,'2021-10-04') AND date<='2021-10-04'
	GROUP BY symbol
) AS X
ORDER BY diff_ratio DESC;