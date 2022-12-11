SELECT industry, t.year, COUNT(company_id) AS num_unicorns, ROUND(AVG(valuation_in_bn),2) AS average_valuation_billions
FROM
(SELECT
		company_id,
		EXTRACT(year FROM date_joined) AS year
FROM dates
WHERE 
		EXTRACT(year FROM date_joined) IN (2019, 2020, 2021)
ORDER BY 1) AS t
LEFT JOIN
	(SELECT
			a.company_id,
			b.valuation_in_bn,
			a.industry
	FROM industries AS a
	INNER JOIN
			(SELECT 
				company_id,
				ROUND((valuation/1000000000),2) AS valuation_in_bn
			FROM funding
			ORDER BY 1,2 DESC) AS b
	USING (company_id)
	ORDER BY 1,2 DESC) AS u
USING(company_id)
WHERE industry IN ('Fintech', 'Internet software & services', 'E-commerce & direct-to-consumer')
GROUP BY 1,2  
ORDER BY 1,2 DESC
  ;