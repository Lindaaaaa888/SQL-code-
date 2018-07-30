

-- question 1

SELECT DISTINCT m1.snum, sname \
FROM student s, mark m1, mark m2, enrollment e \
WHERE e.snum = m1.snum \
AND s.snum = e.snum \
AND e.snum = m2.snum \
AND m1.cnum LIKE 'CS1__' \
AND m2.cnum LIKE 'CS1__' \
AND m2.cnum != m1.cnum \
AND s.year = 2 \
AND m1.grade < 65 \
AND m2.grade < 65


-- question 2



WITH current AS \
( ( SELECT DISTINCT e.term \
FROM enrollment e ) \
EXCEPT \
( SELECT DISTINCT e.term \
	FROM enrollment e, mark m \
	WHERE e.term = m.term \
	AND e.cnum = m.cnum \
	AND e.section = m.section \
	AND e.snum = m.snum ) ) \
( SELECT DISTINCT p.pnum, p.pname \
FROM class c, professor p, current cur \
WHERE c.term = cur.term \
AND c.pnum = p.pnum \
AND c.cnum = 'CS245' \
AND p.dept != 'PM' ) \
INTERSECT \
( SELECT DISTINCT p.pnum, p.pname \
FROM class c, professor p \
WHERE p.dept != 'PM' \
AND p.pnum NOT IN \
( SELECT DISTINCT p.pnum \
	FROM professor p, class c, current cur \
	WHERE c.term != cur.term \
	AND c.pnum = p.pnum \
	AND c.cnum = 'CS245' ) ) 




-- question 3



-- my understnading for within 5 marks of the highest ever means that students who have grade > 95 
SELECT DISTINCT s.snum, s.sname, s.year \
FROM student s, enrollment e, mark m \
WHERE e.cnum = 'CS240' \
AND m.grade > 95 \
AND s.snum = e.snum \
AND e.cnum = m.cnum \
AND e.snum = m.snum \
AND e.term = m.term \
AND e.section = m.section 




-- question 4


( SELECT DISTINCT stu.snum, stu.sname \
FROM student stu \
WHERE stu.year > 2 \
EXCEPT \
SELECT DISTINCT stud.snum, stud.sname \
FROM student stud, enrollment enr, class cla, professor p3 \
WHERE stud.snum = enr.snum \
AND stud.year > 2 \
AND enr.cnum = cla.cnum \
AND enr.term = cla.term \
AND enr.section = cla.section \
AND cla.pnum = p3.pnum \
AND  p3.dept = 'CO') \
INTERSECT ( \ 
( SELECT DISTINCT s.snum, s.sname \
FROM student s, enrollment e3, mark m3 \
WHERE s.snum = e3.snum \
AND s.year > 2 \
AND e3.cnum = m3.cnum \
AND e3.term = m3.term \
AND e3.section = m3.section \
AND e3.snum = m3.snum \
AND m3.cnum LIKE 'CS___' ) \
EXCEPT \
( SELECT DISTINCT st.snum, st.sname \ 
FROM student st, enrollment e, mark m \
WHERE st.snum = e.snum \
AND st.year > 2 \
AND e.cnum = m.cnum \
AND e.term = m.term \
AND e.section = m.section \
AND e.snum = m.snum \
AND m.grade < 85 \
AND m.cnum LIKE 'CS___' ) )


-- question 5


WITH current AS \
( ( SELECT DISTINCT e.term \
FROM enrollment e ) \
EXCEPT \
( SELECT DISTINCT e.term \
	FROM enrollment e, mark m \
	WHERE e.term = m.term \
	AND e.cnum = m.cnum \
	AND e.section = m.section \
	AND e.snum = m.snum ) ) \
SELECT DISTINCT p1.dept \
FROM professor p1, professor p2,class c1, class c2, schedule s1, schedule s2, current cur \
WHERE p1.pnum = c1.pnum \
AND p2.pnum = c2.pnum \
AND p1.dept = p2.dept \
AND c1.cnum = s1.cnum \
AND c1.term = s1.term \
AND c2.cnum = s2.cnum \
AND c2.term = s2.term \
AND c1.section = s1.section \
AND c2.section = s2.section \
AND c1.term = cur.term \
AND c2.term = cur.term \
AND s1.day = 'Monday' \
AND s2.day = 'Friday' \
AND ( s1.time LIKE '11___' \
OR s1.time LIKE '10___' \
OR s1.time LIKE '09___' \
OR s1.time LIKE '08___' \
OR s1.time LIKE '07___' \
OR s1.time LIKE '06___' \
OR s1.time LIKE '05___' \
OR s1.time LIKE '04___' \
OR s1.time LIKE '03___' \
OR s1.time LIKE '02___' \
OR s1.time LIKE '01___' \
OR s1.time LIKE '00___' ) \
AND ( s2.time LIKE '12___' \
OR s2.time LIKE '13___' \
OR s2.time LIKE '14___' \
OR s2.time LIKE '15___' \
OR s2.time LIKE '16___' \
OR s2.time LIKE '17___' \
OR s2.time LIKE '18___' \
OR s2.time LIKE '19___' \
OR s2.time LIKE '20___' \
OR s2.time LIKE '21___' \
OR s2.time LIKE '22___' \
OR s2.time LIKE '23___' ) \
ORDER BY p1.dept


-- question 6



WITH pm1 AS \
( SELECT DISTINCT 100.0 * count (DISTINCT p.pnum)  AS num1 \
		FROM professor p, class c, mark m \
		WHERE p.pnum = c.pnum \
		AND c.cnum = m.cnum \
		AND c.term = m.term \
		AND c.section = m.section \
		GROUP BY p.pnum \
		HAVING MIN( m.grade ) < 65 ) , \
cs2 AS ( SELECT DISTINCT count (DISTINCT pt.pnum) AS num2 \
		FROM professor pt, class c, mark m \
		WHERE pt.pnum = c.pnum \
		AND c.cnum = m.cnum \
		AND c.term = m.term \
		AND c.section = m.section \
		AND pt.dept = 'CS' \
		HAVING MIN( m.grade ) < 65 ) \
SELECT num1 / num2 AS ratio \
FROM pm1 , cs2



-- question 7

WITH current AS \
( ( SELECT DISTINCT e.term \
FROM enrollment e ) \
EXCEPT \
( SELECT DISTINCT e.term \
	FROM enrollment e, mark m \
	WHERE e.term = m.term \
	AND e.cnum = m.cnum \
	AND e.section = m.section \
	AND e.snum = m.snum ) ) , \
total_enrollment AS \
( SELECT DISTINCT p.pnum, count ( m.snum ) AS enrol_num \
FROM professor p, class c, enrollment e,  mark m, current cur \
WHERE c.cnum = e.cnum \
AND c.term = e.term \
AND c.term != cur.term \
AND c.cnum = m.cnum \
AND c.term = m.term \
AND e.snum = m.snum \
AND p.pnum = c.pnum \
GROUP BY p.pnum ) , \
taught_courses AS \
( SELECT DISTINCT c.pnum, c.cnum, count ( c.cnum ) AS num_of_courses \ 
FROM professor p, class c \
WHERE p.pnum = c.pnum \
GROUP BY c.pnum, c.cnum ) , \
total_marks AS \
( SELECT DISTINCT p.pnum, c.cnum, sum ( m.grade ) AS all_marks \
FROM professor p, class c, mark m,current cur \
WHERE c.term != cur.term \
AND c.cnum = m.cnum \
AND c.term = m.term \
AND p.pnum = c.pnum \
GROUP BY p.pnum, c.cnum ) , \
c_enr AS ( SELECT DISTINCT p.pnum, c.cnum, count ( m.snum ) AS course_enrollment \
FROM professor p, class c, mark m, current cur \
WHERE c.term != cur.term \
AND c.cnum = m.cnum \
AND c.term = m.term \
AND p.pnum = c.pnum \
GROUP BY p.pnum, c.cnum ) \
SELECT DISTINCT p.pnum, p.pname, p.dept, c.cnum, t.enrol_num / taught.num_of_courses AS avg_enrollment, ms.all_marks / er.course_enrollment AS course_avg \
FROM professor p, class c, total_enrollment t, taught_courses taught, total_marks ms, c_enr er \ 
WHERE p.pnum = c.pnum \
AND er.cnum = ms.cnum \
AND t.pnum = c.pnum \
AND t.cnum = er.cnum \
AND t.cnum = taught.cnum \
AND t.cnum = p.cnum \
AND p.cnum = c.cnum



-- question 8

WITH current AS \
( ( SELECT DISTINCT e.term \
FROM enrollment e ) \
EXCEPT \
( SELECT DISTINCT e.term \
	FROM enrollment e, mark m \
	WHERE e.term = m.term \
	AND e.cnum = m.cnum \
	AND e.section = m.section \
	AND e.snum = m.snum ) ) \
SELECT DISTINCT p.dept, c.cnum, count ( DISTINCT e.snum ) AS said_count \
FROM professor p, class c, enrollment e, current cur \
WHERE ( p.dept = 'PM' \
OR p.dept = 'CS' ) \
AND e.term != cur.term \
AND c.cnum = e.cnum \
AND c.term = e.term \
AND p.pnum = c.pnum \
GROUP BY p.dept, c.cnum \
ORDER BY said_count DESC



-- question 9
-- note: the minimum and maximum final grades are the course maximum and minimum final grades, which might taught by this professor since there are cases tnat several profs taught the different sections of the same course.
WITH current AS \
( ( SELECT DISTINCT e.term \
FROM enrollment e ) \
EXCEPT \
( SELECT DISTINCT e.term \
	FROM enrollment e, mark m \
	WHERE e.term = m.term \
	AND e.cnum = m.cnum \
	AND e.section = m.section \
	AND e.snum = m.snum ) ) \
SELECT DISTINCT p.pnum, p.pname, co.cname, c.cnum, c.term, c.section, \
 max ( m.grade ) AS max_grade, min ( m.grade ) AS min_grade \
FROM professor p, class c, course co, schedule s, mark m, current cur \
WHERE p.pnum = c.pnum \
AND c.cnum = s.cnum \
AND c.term = s.term \
AND c.section = s.section \
AND ( s.day = 'Monday' \
OR s.day = 'Friday' ) \
AND p.dept = 'CS' \
AND c.term != cur.term \
AND co.cnum = c.cnum \
AND c.cnum = m.cnum \
AND c.term = m.term \
AND c.section = m.section \
GROUP BY p.pnum, p.pname, co.cname, c.cnum, c.term, c.section


-- question 10

WITH current AS \
( ( SELECT DISTINCT e.term \
FROM enrollment e ) \
EXCEPT \
( SELECT DISTINCT e.term \
	FROM enrollment e, mark m \
	WHERE e.term = m.term \
	AND e.cnum = m.cnum \
	AND e.section = m.section \
	AND e.snum = m.snum ) ) , \
SUM AS \
( SELECT DISTINCT p.pnum \
	FROM professor p ) , \
THIS_term AS \
( SELECT DISTINCT p.pnum \
	FROM professor p, class c, current cur \
	WHERE c.term = cur.term \
	AND c.pnum = c.pnum \
	AND p.dept = 'CS' ) , \
taught_two_classes AS \
( SELECT DISTINCT p.pnum \
FROM professor p, class c1, class c2, current cur \
WHERE p.pnum = c1.pnum \
AND p.pnum = c2.pnum \
AND c1.term != cur.term \
AND c1.cnum != c2.cnum \
AND c1.term = c2.term ) , \
matched AS ( ( ( SELECT DISTINCT pnum \
FROM SUM ) \
 EXCEPT \
 ( SELECT DISTINCT pnum \
 FROM THIS_term ) ) \
  INTERSECT \
  ( ( SELECT DISTINCT pnum \
  FROM SUM ) \
  EXCEPT \
  ( SELECT DISTINCT pnum \
  FROM taught_two_classes ) ) ) \
SELECT DISTINCT \
 count ( DISTINCT m.pnum ) * 100.0 / count ( DISTINCT s.pnum ) AS percentage \
FROM matched m , SUM s 



