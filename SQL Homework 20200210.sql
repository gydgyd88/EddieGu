Use school;
show databases;
#1.查询" 01 "课程比" 02 "课程成绩高的学生的信息及课程分数
SELECT 
    a.*, b.s_score as 01Score, c.s_score as 02Score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.c_id = '01'
        LEFT JOIN
    Score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE
    b.s_score > c.s_score;
#1.1查询同时存在" 01 "课程和" 02 "课程的情况
SELECT 
    a.*, b.s_score AS 01Score, c.s_score AS 02Score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.c_id = '01'
        LEFT JOIN
    Score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE
    b.s_score IS NOT NULL
        AND c.s_score IS NOT NULL;

#1.2 查询存在" 01 "课程但可能不存在" 02 "课程的情况(不存在时显示为null）
SELECT 
    a.*, b.s_score AS 01Score, c.s_score AS 02Score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.c_id = '01'
        LEFT JOIN
    Score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE
    b.s_score IS NOT NULL;
#1.3 查询不存在" 01 "课程但存在" 02 "课程的情况
SELECT 
    a.*, b.s_score AS 01Score, c.s_score AS 02Score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.c_id = '01'
        LEFT JOIN
    Score c ON a.s_id = c.s_id AND c.c_id = '02'
WHERE
    b.s_score IS NULL
    And c.s_score IS NOT NUll;
    
#2. 查询平均成绩大于等于 60 分的同学的学生编号和学生姓名和平均成绩
SELECT 
    a.s_id, a.s_name, AVG(b.s_score) AS 平均成绩
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING AVG(b.s_score) > 60;

#3. 查询在 SC 表存在成绩的学生信息
SELECT 
    distinct a.*
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
        AND b.s_score IS NOT NULL;

#4. 查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩(没成绩的显示为null􏰁􏰁) 
SELECT 
    a.s_id,
    a.s_name,
    COUNT(b.c_id) AS 选课总数,
    SUM(b.s_score) AS 总成绩
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
GROUP BY a.s_id;

#4.1 查有成绩的学生信息
SELECT 
    a.s_id,
    a.s_name,
    COUNT(b.c_id) AS 选课总数,
    SUM(b.s_score) AS 总成绩
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING SUM(b.s_score) IS NOT NULL;

#5. 查询「李」姓老师的数量
SELECT 
    COUNT(t_id)
FROM
    Teacher
WHERE
    t_name LIKE '李%';

#6. 查询学过「张三」老师授课的同学的信息
SELECT 
    a.*
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
        LEFT JOIN
    Course c ON b.c_id = c.c_id
        LEFT JOIN
    Teacher d ON c.t_id = d.t_id
WHERE
    d.t_name = '张三';

#7. 查询没有学全所有课程的同学的信息
SELECT 
    a.*
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING COUNT(b.c_id) < (SELECT 
        COUNT(*)
    FROM
        Course);

#8. 查询至少有一门课与学号为" 01 "的同学所学相同的同学的信息
SELECT DISTINCT
    a.*
FROM
    Student a
        Right JOIN
    Score b ON a.s_id = b.s_id
        AND b.c_id IN (SELECT 
            distinct c_id
        FROM
            Student a
                LEFT JOIN
            Score b ON a.s_id = b.s_id AND a.s_id = '01');

#9. 查询和" 01 "号的同学学习的课程完全相同的其他同学的信息
SELECT DISTINCT
    a.*
FROM
    Student a
        RIGHT JOIN
    Score b ON a.s_id = b.s_id
        AND b.c_id IN (SELECT DISTINCT
            c_id
        FROM
            Student a
                LEFT JOIN
            Score b ON a.s_id = b.s_id AND a.s_id = '01')
GROUP BY s_id
HAVING COUNT(c_id) = (SELECT DISTINCT
        COUNT(b.c_id)
    FROM
        Student a
            LEFT JOIN
        Score b ON a.s_id = b.s_id AND a.s_id = '01');

#10. 查询没学过"张三"老师讲授的任一门课程的学生姓名
select distinct a.s_name from Student a left join Score b on a.s_id = b.s_id and b.c_id not in
(SELECT 
 a.c_id
FROM
    Course a
        LEFT JOIN
    Teacher b ON a.t_id = b.t_id where b.t_name = '张三');
    
# 11. 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
SELECT DISTINCT
    a.s_id, b.s_name, AVG(a.s_score) AS 平均成绩
FROM
    Student b
        LEFT JOIN
    Score a ON b.s_id = a.s_id AND a.s_score < 60
GROUP BY b.s_id
HAVING COUNT(a.c_id) >= 2;

#12. 检索" 01 "课程分数小于 60，按分数降序排列的学生信息
SELECT 
    *
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.s_score < 60
WHERE
    b.c_id = '01'
ORDER BY b.s_score DESC;

#13. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
SELECT 
    a.s_id, a.c_id, a.s_score, b.平均成绩
FROM
    Score a
        LEFT JOIN
    (SELECT 
        s_id, AVG(s_score) AS 平均成绩
    FROM
        Score
    GROUP BY s_id
    ORDER BY AVG(s_score) DESC) b ON a.s_id = b.s_id;

/*14. 查询各科成绩最高分、最低分和平均分:
以如下形式显示:课程 ID，课程 􏰀a􏰂e，最高分，最低分，平均分，及格率，中等率， 优良率，优秀率
及格为>=60，中等为:70-80，优良为:80-90，优秀为:>=90
要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排 列*/
SELECT 
    a.c_id,b.c_name, MAX(s_score), MIN(s_score), AVG(s_score) as 平均分, 
    sum((case when a.s_score >= 60 then 1 else 0 end))/Sum((case when a.s_score>0 then 1 else 0 end)) as 及格率,
    sum((case when a.s_score >= 70 and a.s_score < 80 then 1 else 0 end))/Sum((case when a.s_score>0 then 1 else 0 end)) as 中等率,
    sum((case when a.s_score >= 80 and a.s_score < 90 then 1 else 0 end))/sum((case when a.s_score>0 then 1 else 0 end)) as 优良率,
    sum((case when a.s_score >= 90 then 1 else 0 end))/Sum((case when a.s_score>0 then 1 else 0 end)) as 优秀率
FROM
    Score a left join Course b on a.c_id = b.c_id
GROUP BY a.c_id;

#15. 按各科成绩进行排序，并显示排名， Sc􏰃re 重复时保留名次空缺
SELECT 
    a.c_id, a.s_id, a.s_score, COUNT(b.s_score) + 1 AS rank
FROM
    Score AS a
        LEFT JOIN
    Score AS b ON a.s_score < b.s_score
        AND a.c_id = b.c_id
GROUP BY a.c_id , a.s_id , a.s_score
ORDER BY a.c_id , rank ASC;

#15.1 按各科成绩进行排序，并显示排名， Sc􏰃re 重复时合并名次

#16. 查询学生的总成绩，并进行排名，总分重复时保留名次空缺

#16.1 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
set @crank = 0;
SELECT 
    a.s_id, a.总成绩, @crank:=@crank + 1 AS rank
FROM
    (SELECT 
        s_id, SUM(s_score) AS 总成绩
    FROM
        Score
    GROUP BY s_id
    ORDER BY SUM(s_score) DESC) a;

#17. 统计各科成绩各分数段人数:课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60- 0] 及所占百分比
 SELECT 
    a.c_id,
    a.分数段,
    a.分数段人数,
    a.分数段人数 / b.课程总人数 AS 所占百分比
FROM
    (SELECT 
        r.c_id, r.分数段, COUNT(r.s_id) AS 分数段人数
    FROM
        (SELECT 
        a.s_id,
            a.c_id,
            b.c_name,
            CASE
                WHEN a.s_score >= 0 AND a.s_score < 60 THEN '[60- 0]'
                WHEN a.s_score >= 60 AND a.s_score < 70 THEN '[70-60]'
                WHEN a.s_score >= 70 AND a.s_score < 85 THEN '[85-70]'
                WHEN a.s_score >= 85 AND a.s_score <= 100 THEN '[100-85]'
            END '分数段'
    FROM
        Score a
    LEFT JOIN Course b ON a.c_id = b.c_id) r
    GROUP BY r.c_id , r.分数段) a
        LEFT JOIN
    (SELECT 
        c_id, COUNT(s_id) AS 课程总人数
    FROM
        Score
    GROUP BY c_id) b ON a.c_id = b.c_id;


#18. 查询各科成绩前三名的记录
SELECT 
    a.c_id, a.s_id, a.s_score, COUNT(b.s_score) + 1 AS rank
FROM
    Score AS a
        LEFT JOIN
    Score AS b ON a.s_score < b.s_score
        AND a.c_id = b.c_id
GROUP BY a.c_id , a.s_id , a.s_score
HAVING rank <= 3
ORDER BY a.c_id , rank ASC;

#19. 查询每门课程被选修的学生数
SELECT 
    a.c_id, COUNT(b.s_id) AS 选修学生数
FROM
    Course a
        LEFT JOIN
    Score b ON a.c_id = b.c_id
GROUP BY a.c_id;

#20. 查询出只选修两门课程的学生学号和姓名
SELECT 
    a.s_id, a.s_name
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING COUNT(b.c_id) = 2;

#21. 查询男生、女生人数
SELECT 
    s_sex, COUNT(*)
FROM
    Student
GROUP BY s_sex;

#22. 查询名字中含有「风」字的学生信息
SELECT 
    *
FROM
    Student
WHERE
    s_name LIKE '%风%';

#23. 查询同名同性学生名单，并统计同名人数
SELECT 
    s_name, COUNT(s_id) AS 同名同性人数
FROM
    Student
GROUP BY s_name , s_sex
HAVING COUNT(s_id) > 1;

#24. 查询 1990 年出生的学生名单
SELECT 
    *
FROM
    Student
WHERE
    YEAR(s_birth) = '1990';

#25. 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
SELECT 
    a.c_id, AVG(a.s_score) AS 平均成绩
FROM
    Score a
GROUP BY a.c_id
ORDER BY AVG(a.s_score) DESC , c_id ASC;

#26. 查询平均成绩大于等于 85 的所有学生的学号、姓名和平均成绩
SELECT 
    a.s_id, b.s_name, AVG(a.s_score) AS 平均成绩
FROM
    Score a
        LEFT JOIN
    Student b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING AVG(a.s_score) >= 85;

#27. 查询课程名称为「数学」，且分数低于 60 的学生姓名和分数
SELECT 
    a.s_name, c.c_name, b.s_score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.s_score < 60
        LEFT JOIN
    Course c ON b.c_id = c.c_id
WHERE
    c.c_name = '数学';

#28. 查询所有学生的课程及分数情况(存在学生没成绩，没选课的情况)
SELECT 
    *
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id;

#29. 查询任何一门课程成绩在 70 分以上的姓名、课程名称和分数
SELECT 
    a.s_name, c.c_name, b.s_score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id AND b.s_score > 70
        LEFT JOIN
    Course c ON b.c_id = c.c_id;

#30. 查询不及格的课程
SELECT 
    *
FROM
    Score
WHERE
    s_score < 60;

#31. 查询课程编号为 01 且课程成绩在 80 分以上的学生的学号和姓名
SELECT 
    a.s_id, a.s_name, b.c_id, b.s_score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
WHERE
    b.c_id = 01 AND b.s_score > 80;

#32. 求每门课程的学生人数
SELECT 
    c_id, COUNT(s_id) AS 学生人数
FROM
    Score
GROUP BY c_id;
#33. 成绩不重复，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息及其成绩
SELECT 
    a.*, b.c_id, b.s_score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
WHERE
    b.c_id = (SELECT 
            a.c_id
        FROM
            Course a
                LEFT JOIN
            Teacher b ON a.t_id = b.t_id
        WHERE
            b.t_name = '张三') 
ORDER BY b.s_score DESC limit 1;

#34. 成绩有重复的情况下，查询选修「张三」老师所授课程的学生中，成绩最高的学生信息 及其成绩
SELECT 
    a.*, b.c_id, b.s_score
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
WHERE
    b.c_id = (SELECT 
            a.c_id
        FROM
            Course a
                LEFT JOIN
            Teacher b ON a.t_id = b.t_id
        WHERE
            b.t_name = '张三') and b.s_score in 
            (
            select Max(a.s_score) from Score a left join Course b on a.c_id = b.c_id left join Teacher c on b.t_id =c.t_id where c.t_name = '张三'
            )
ORDER BY b.s_score DESC;

#35. 查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
SELECT 
    s_id, c_id, s_score
FROM
    Score
WHERE
    s_score = (SELECT 
            s_score
        FROM
            Score
        GROUP BY s_score
        HAVING COUNT(s_id) > 1);

#36. 查询每门功成绩最好的前两名
SELECT 
    a.c_id, a.s_id, a.s_score, COUNT(b.s_score) + 1 AS rank
FROM
    Score AS a
        LEFT JOIN
    Score AS b ON a.s_score < b.s_score
        AND a.c_id = b.c_id
GROUP BY a.c_id , a.s_id , a.s_score
HAVING rank <= 2
ORDER BY a.c_id , rank ASC;

#37. 统计每门课程的学生选修人数(超过 5 人的课程才统计)。
SELECT 
    a.c_id, COUNT(s_id)
FROM
    Course a
        LEFT JOIN
    Score b ON a.c_id = b.c_id
GROUP BY a.c_id
HAVING COUNT(s_id) > 5;

#38. 检索至少选修两门课程的学生学号
SELECT 
    s_id
FROM
    Score
GROUP BY s_id
HAVING COUNT(c_id) >= 2;

#39. 查询选修了全部课程的学生信息
SELECT 
    a.s_id, a.s_name, a.s_birth, a.s_sex
FROM
    Student a
        LEFT JOIN
    Score b ON a.s_id = b.s_id
GROUP BY a.s_id
HAVING COUNT(b.c_id) = (SELECT 
        COUNT(*)
    FROM
        Course);
 
#40. 查询各学生的年龄，只按年份来算
SELECT 
    s_id, s_name, YEAR(NOW()) - YEAR(s_birth) + 1 AS 年龄
FROM
    Student; 
#41. 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一 
SELECT 
    s_id,
    s_name,
    CASE
        WHEN
            NOW() < CONCAT(YEAR(NOW()),
                    '-',
                    DATE_FORMAT(s_birth, '%m-%d'))
        THEN
            YEAR(NOW()) - YEAR(s_birth)
        ELSE YEAR(NOW()) - YEAR(s_birth) + 1
    END 年龄
FROM
    Student; 
#42. 查询本周过生日的学生
SELECT 
    *
FROM
    Student
WHERE
    WEEK(CONCAT(YEAR(NOW()),
                '-',
                DATE_FORMAT(s_birth, '%m-%d'))) = WEEK(NOW());
#43. 查询下周过生日的学生
SELECT 
    *
FROM
    Student
WHERE
    WEEK(CONCAT(YEAR(NOW()),
                '-',
                DATE_FORMAT(s_birth, '%m-%d'))) = WEEK(NOW()) + 1;
#44. 查询本月过生日的学生
SELECT 
    *
FROM
    Student
WHERE
    MONTH(s_birth) = MONTH(NOW());
#45. 查询下月过生日的学生
SELECT 
    *
FROM
    Student
WHERE
    MONTH(s_birth) = MONTH(NOW()) + 1;





