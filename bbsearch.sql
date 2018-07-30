
-- WHEN EXISTS ( SELECT DISTINCT pub.pubid FROM article a, proceedings pro WHERE a.pubid = pub.pubid AND a.appearsin = pro.pubid ) \
-- 			 THEN ( SELECT DISTINCT pro.pubid, NULL AS name, pro.year , pub.title FROM article a, proceedings pro \
-- 			 	WHERE a.pubid = pub.pubid AND a.appearsin = pro.pubid ) \

-- WHEN EXISTS ( SELECT DISTINCT pub.pubid FROM article a, journal j WHERE a.pubid = pub.pubid AND a.appearsin = j.pubid )  \
-- 			 THEN ( SELECT DISTINCT j.pubid, NULL AS name, j.year, pub.title \
-- 			 	FROM article a, journal j WHERE a.pubid = pub.pubid AND a.appearsin = j.pubid AND w.aorder = 1 ) \
		SELECT DISTINCT \
			CASE \
			WHEN EXISTS ( SELECT DISTINCT pub.pubid FROM article a, proceedings pro WHERE a.pubid = pub.pubid AND a.appearsin = pro.pubid ) \
			 THEN ( SELECT DISTINCT a.pubid, au.name , pro.year, pub.title FROM article a, proceedings pro \
			 	WHERE a.pubid = pub.pubid AND a.appearsin = pro.pubid AND w.aorder = 1 ) \
			WHEN EXISTS ( SELECT DISTINCT pub.pubid FROM article a, journal j WHERE a.pubid = pub.pubid AND a.appearsin = j.pubid )  \
			 THEN  ( SELECT DISTINCT a.pubid, au.name, j.year, pub.title FROM article a, journal j \
			 	WHERE a.pubid = pub.pubid AND a.appearsin = j.pubid AND w.aorder = 1 ) \
			ELSE ( SELECT DISTINCT b.pubid, au.name, b.year, pub.title FROM book b, journal j \
				WHERE b.pubid = pub.pubid AND w.aorder = 1 ) \
			 END  \
			 FROM author au, wrote w, publication pub \
			 WHERE au.aid = w.aid AND w.pubid = pub.pubid \
			 --GROUP BY .pubid, name, pro.year, pub.title \
		 	 ORDER BY year DESC, name
		-- CASE \
		-- WHEN ( pub.pubid = a.pubid AND a.appearsin = p.pubid  ) OR pub.pubid = p.pubid \
		-- THEN p.year \
		-- WHEN ( pub.pubid = a.pubid AND a.appearsin = j.pubid ) OR pub.pubid = j.pubid \
		-- THEN j.year \
		-- ELSE \
		-- b.year \

 SELECT DISTINCT x.pubid, x.name , x.year, x.title FROM \ 
			 	( SELECT DISTINCT a.pubid, au.name , min ( aorder ) AS order, pro.year, pub.title FROM article a, proceedings pro, author au, wrote w, publication pub \
			 WHERE au.aid = w.aid AND w.pubid = pub.pubid \
			 	AND a.pubid = pub.pubid AND a.appearsin = pro.pubid \ 
			 	AND EXISTS ( SELECT DISTINCT pub.pubid FROM article a, proceedings pro WHERE a.pubid = pub.pubid AND a.appearsin = pro.pubid ) \
			 	GROUP BY a.pubid,name, pro.year, pub.title ) x 


SELECT DISTINCT x.pubid, NULL AS name, x.year , x.title FROM \
			 	( SELECT DISTINCT pro.pubid, NULL , 1 AS order, pro.year , pub.title FROM article a, proceedings pro, author au, wrote w, publication pub \
			 WHERE au.aid = w.aid AND w.pubid = pub.pubid \
			 	AND \
			 	 a.pubid = pub.pubid AND a.appearsin = pro.pubid \
			 	--GROUP BY a.pubid, name, pro.year, pub.title 
			 	) x
SELECT DISTINCT x.pubid, x.name, x.year, x.title FROM \
			 ( SELECT DISTINCT a.pubid, au.name , min ( aorder ) AS order, j.year, pub.title FROM article a, journal j , author au, wrote w, publication pub \
			 	WHERE a.pubid = pub.pubid AND a.appearsin = j.pubid \
			 	AND au.aid = w.aid AND w.pubid = pub.pubid \
			 	GROUP BY a.pubid, name, j.year, pub.title ) x


SELECT DISTINCT x.pubid, NULL, x.year, x.title \
			 	FROM \
			 	( SELECT DISTINCT j.pubid, NULL AS name, 1 AS order, j.year, pub.title \
			 	FROM article a, journal j , author au, wrote w, publication pub \
			 	WHERE a.pubid = pub.pubid AND a.appearsin = j.pubid \
			 	AND a.pubid = pub.pubid AND a.appearsin = j.pubid \
			 	--GROUP BY a.pubid, name, pro.year, pub.title 
			 	) x


	SELECT DISTINCT x.pubid, x.name, x.year, x.title FROM \
				( SELECT DISTINCT b.pubid, au.name, min ( aorder ) AS order, b.year, pub.title FROM book b, journal j, author au, wrote w, publication pub \
			 	WHERE au.aid = w.aid AND w.pubid = pub.pubid \
			 	AND \
				b.pubid = pub.pubid \
				GROUP BY b.pubid, name, b.year, pub.title ) x 

-- with \
-- 	get_pubid_and_title(pubid, title) as ( select distinct pub.pubid, pub.title from author au, wrote w, publication pub where au.aid = w.aid and w.pubid = pub.pubid ), \
-- 	get_type(pubid, type) as ( select distinct gp.pubid, case when exists ( select distinct 1 from get_pubid_and_title p, proceedings pro where p.pubid = pro.pubid ) then 'proceedings' when exists ( select distinct 1 from get_pubid_and_title p, journal j where p.pubid = j.pubid ) then 'journal' when exists ( select distinct 1 from get_pubid_and_title p, book b where p.pubid = b.pubid ) then 'book' else 'article' end as type from get_pubid_and_title gp ) \
--  select distinct gt.pubid, gt.type, au.name, b.year from wrote w, book b, author au, get_type gt where gt.pubid = w.pubid and w.aid = au.aid and gt.pubid = b.pubid and w.aorder = 1 

with \
	get_pubid_and_title(pubid, title) as ( select distinct pub.pubid, pub.title from author au, wrote w, publication pub where au.aid = w.aid and w.pubid = pub.pubid ), \
	get_type(pubid, type) as ( select distinct gp.pubid, case when exists ( select distinct 1 from get_pubid_and_title p, proceedings pro where p.pubid = pro.pubid ) then 'proceedings' when exists ( select distinct 1 from get_pubid_and_title p, journal j where p.pubid = j.pubid ) then 'journal' when exists ( select distinct 1 from get_pubid_and_title p, book b where p.pubid = b.pubid ) then 'book' else 'article' end as type from get_pubid_and_title gp ), \
	book_author(pubid, type, author, year) as ( select distinct gt.pubid, gt.type, au.name, b.year from wrote w, book b, author au, get_type gt where gt.pubid = w.pubid and w.aid = au.aid and gt.pubid = b.pubid and w.aorder = 1 ), \
	article_appearsin(pubid, type, author, appearsin) as ( select distinct gt.pubid, gt.type, au.name, a.appearsin from wrote w, article a, author au, get_type gt where gt.pubid = w.pubid and w.aid = au.aid and gt.pubid = a.pubid and w.aorder = 1 ), \
	article_author(pubid, type, author, year) as ( select distinct gt.pubid, gt.type, gt.author, proc.year from wrote w, article a, proceedings proc, author au, article_appearsin gt where gt.pubid = w.pubid and w.aid = au.aid and gt.pubid = a.pubid and gt.appearsin = proc.pubid union select distinct gt.pubid, gt.type, gt.author, j.year from wrote w, article a, journal j, author au, article_appearsin gt where gt.pubid = w.pubid and w.aid = au.aid and gt.pubid = a.pubid and gt.appearsin = j.pubid ), \
	others_author(pubid, type, author, year) as ( select distinct gt.pubid, gt.type, '' as author, p.year from article_appearsin gt, proceedings p where p.pubid = gt.appearsin union select distinct gt.pubid, gt.type, '' as author, j.year from article_appearsin gt, journal j where j.pubid = gt.appearsin ) \
select distinct * from book_author union select distinct * from article_author union select distinct * from others_author order by year DESC, author ASC




