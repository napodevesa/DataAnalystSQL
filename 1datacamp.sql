SELECT TOP 10 
	company, 
	broad_bean_origin,
	-- Calculate the length of the broad_bean_origin column
	len(broad_bean_origin) AS length
FROM ratings
--Order the results based on the new column, descending
ORDER BY length desc;

--------***----------
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0;
--------***----------

SELECT 
	first_name,
	last_name,
	email 
FROM voters
WHERE CHARINDEX('dan', first_name) > 0 
	AND CHARINDEX('z', last_name) = 0;

--------***----------
SELECT 
	first_name,
	last_name,
	email 
FROM voters
WHERE PATINDEX('%a%w%', first_name)>0 
;
--------***----------
SELECT 
	first_name,
	last_name,
	email 
FROM voters
WHERE PATINDEX('%[xwq]%', first_name)>0 
;

--------***----------

SELECT 
	company,
	bean_type,
	broad_bean_origin,
	'The company ' +  company + ' uses beans of type "' + bean_type + '", originating from ' + broad_bean_origin + '.'
FROM ratings
WHERE 
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%';

--------***----------
SELECT 
	company,
	bean_type,
	broad_bean_origin,
    -- 'company' and 'broad_bean_origin' should be in uppercase
	'The company ' +  UPPER(company) + ' uses beans of type "' + bean_type + '", originating from ' + UPPER(broad_bean_origin) + '.'
FROM ratings
WHERE 
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%'
     -- The 'bean_type' should not be unknown
    AND LOWER(bean_type) NOT LIKE '%unknown%';