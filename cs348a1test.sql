drop table course
create table course ( \
    cnum        varchar(5) not null, \
    cname       varchar(40) not null, \
    primary key (cnum) )

insert into course values ('CS448', 'Introduction to Databases')

drop table professor
create table professor ( \
    pnum        integer not null, \
    pname       varchar(20) not null, \
    office      varchar(10) not null, \
    dept        varchar(30) not null, \
    primary key (pnum) )

insert into professor values (1, 'Weddell, Grant', 'DC3346', 'CS')
insert into professor values (2, 'Ilyas, Ihab', 'DC3348', 'CO')

drop table student
create table student ( \
    snum        integer not null, \
    sname       varchar(20) not null, \
    year        integer not null, \
    primary key (snum) )

insert into student values (1, 'Jones, Fred', 4)

drop table class
create table class ( \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    pnum        integer not null, \
    primary key (cnum, term, section), \
    foreign key (cnum) references course (cnum), \
    foreign key (pnum) references professor (pnum) )

insert into class values ('CS448', 'S2006', 1, 1)
insert into class values ('CS448', 'S2006', 2, 1)

drop table enrollment
create table enrollment ( \
    snum        integer not null, \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    primary key (snum, cnum, term, section), \
    foreign key (snum) references student (snum), \
    foreign key (cnum, term, section) references class (cnum, term, section) )



drop table mark
create table mark ( \
    snum        integer not null, \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    grade       integer not null, \
    primary key (snum, cnum, term, section), \
    foreign key (snum, cnum, term, section) \
    references enrollment (snum, cnum, term, section) )

drop table schedule
create table schedule ( \
    cnum        varchar(5) not null, \
    term        varchar(5) not null, \
    section     integer not null, \
    day         varchar(10) not null, \
    time        varchar(5) not null, \
    room        varchar(10) not null, \
    primary key (cnum, term, section, day, time), \
    foreign key (cnum, term, section) \
    references class (cnum, term, section) )


insert into course values ('CS135', '135')
insert into course values ('CS136', '136')
insert into course values ('CS140', '130')
insert into course values ('CS250', '250')
insert into course values ('CS370', '370')
insert into course values ('CS447', '447')
insert into course values ('EO101', 'ECON101')

insert into professor values (3, 'PM Prof', 'DC3346', 'PM')
insert into professor values (4, 'CON Prof', 'DC3341', 'EO')
insert into professor values (5, 'ECON Prof', 'DC3346', 'CS')
insert into professor values (6, 'IlyIhab', 'DC3348', 'CS')
insert into class values ('CS135', 'W2017', 1, 1)
insert into class values ('CS135', 'W2017', 2, 1)

insert into class values ('CS136', 'W2014', 1, 5)

insert into class values ('CS136', 'W2016', 1, 1)


insert into class values ('CS140', 'W2015', 1, 1)

insert into class values ('CS250', 'F2016', 1, 2)

insert into class values ('CS370', 'F2016', 1, 2)
insert into class values ('CS370', 'F2016', 2, 3)

insert into class values ('CS447', 'W2017', 1, 1)




insert into student values (2, 's2-y2', 2)
insert into student values (3, 's3-y2', 2)
insert into student values (4, 's4-y2', 2)
insert into student values (5, 's5-y2', 2)




insert into mark values (2, 'CS136', 'W2014', 1, 60)
insert into mark values (2, 'CS140', 'W2015', 1, 64)
insert into mark values (2, 'CS370', 'F2016', 1, 60)

insert into mark values (3, 'CS136', 'W2014', 1, 60)
insert into mark values (3, 'CS140', 'W2015', 1, 60)

insert into mark values (4, 'CS136', 'W2014', 1, 60)
insert into mark values (4, 'CS140', 'W2015', 1, 60)

insert into mark values (1, 'CS136', 'W2014', 1, 60)
insert into mark values (1, 'CS140', 'W2015', 1, 60)

-- q2
-- prof5--CS--CS245 first time
-- prof6--PM--CS245 first time
-- prof7--CO--CS245 second time
-- prof8--CS--CS245 not this term but before
-- student1,2 enrolled for prof5
-- student2,3 enrolled for prof6
-- student1   enrolled for prof8

insert into course values ('CS245', '245')

insert into professor values (7, 'PM Prof', 'DC3346', 'CO')
insert into professor values (8, 'PM Prof', 'DC3346', 'CS')

insert into class values ('CS245', 'W2017', 1, 5)
insert into class values ('CS245', 'W2017', 2, 6)
insert into class values ('CS245', 'W2017', 3, 7)
insert into class values ('CS245', 'W2016', 1, 7)
insert into class values ('CS245', 'W2015', 1, 8)

insert into schedule values ('CS135', 'W2017', 1, 'Friday','18:30','MC4058')
insert into schedule values ('CS135', 'W2017', 2, 'Friday','18:30','MC4058')

insert into schedule values ('CS136', 'W2014', 1, 'Friday','18:30','MC4058')

insert into schedule values ('CS136', 'W2016', 1, 'Friday','18:30','MC4058')
insert into schedule values ('CS245', 'W2017', 1, 'Friday','18:30','MC4058')

insert into schedule values ('CS245', 'W2017', 2, 'Friday','18:30','MC4058')
insert into schedule values ('CS245', 'W2017', 3, 'Friday','18:30','MC4058')
insert into schedule values ('CS245', 'W2016', 1, 'Friday','18:30','MC4058')

insert into schedule values ('CS245', 'W2015', 1, 'Friday','18:30','MC4058')
insert into schedule values ('CS140', 'W2015', 1, 'Friday','18:30','MC4058')



--insert into schedule values (2, 'CS240', 'W2014', 'Friday','18:30','MC4058')
--insert into schedule values ('CS250', 'F2016', 1, 'Friday','18:30','MC4058')

insert into schedule values ('CS370', 'F2016', 1, 'Friday','18:30','MC4058')
insert into schedule values ('CS370', 'F2016', 2, 'Friday','18:30','MC4058')

insert into schedule values ('CS447', 'W2017', 1, 'Friday','18:30','MC4058')

insert into enrollment values (1, 'CS245', 'W2017', 1)
insert into enrollment values (2, 'CS245', 'W2017', 1)
insert into enrollment values (2, 'CS245', 'W2017', 2)
insert into enrollment values (3, 'CS245', 'W2017', 2)

insert into enrollment values (1, 'CS245', 'W2015', 1)
insert into enrollment values (2, 'CS136', 'W2014', 1)
insert into enrollment values (2, 'CS140', 'W2015', 1)
insert into enrollment values (2, 'CS370', 'F2016', 1)
insert into enrollment values (3, 'CS136', 'W2014', 1)
insert into enrollment values (3, 'CS140', 'W2015', 1)
insert into enrollment values (4, 'CS136', 'W2014', 1)
insert into enrollment values (4, 'CS140', 'W2015', 1)
insert into enrollment values (1, 'CS136', 'W2014', 1)
insert into enrollment values (1, 'CS140', 'W2015', 1)
insert into enrollment values (1, 'CS448', 'S2006', 2)
insert into enrollment values (2, 'CS240', 'W2014', 1)
insert into enrollment values (3, 'CS240', 'W2014', 1)
insert into enrollment values (4, 'CS240', 'W2014', 1)
insert into enrollment values (1, 'CS240', 'W2014', 1)
insert into enrollment values (6, 'CS370', 'F2016', 1)
insert into enrollment values (7, 'CS370', 'F2016', 2)
insert into enrollment values (6, 'CS136', 'W2014', 1)
insert into enrollment values (7, 'CS136', 'W2014', 1)
	
insert into enrollment values (2, 'CS135', 'W2017', 1)
insert into enrollment values (6, 'CS135', 'W2017', 1)

-- q3
insert into course values ('CS240', '240')
insert into class values ('CS240', 'W2014', 1, 3)



insert into mark values (2, 'CS240', 'W2014', 1, 90)
insert into mark values (3, 'CS240', 'W2014', 1, 60)
insert into mark values (4, 'CS240', 'W2014', 1, 88)
insert into mark values (1, 'CS240', 'W2014', 1, 82)

-- q4
-- student 5 没上过CO教授的课


insert into student values (6, 's6-y3', 3)
insert into mark values (6, 'CS370', 'F2016', 1, 85)

insert into mark values (6, 'CS136', 'W2014', 1, 70)

insert into student values (7, 's6-y3', 3)

insert into mark values (7, 'CS370', 'F2016', 2, 45)


insert into mark values (7, 'CS136', 'W2014', 1, 60)

-- q2










commit work

