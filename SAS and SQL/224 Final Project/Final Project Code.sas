/* STAT 224 Final Project */

/**** SECTION I ****/
/* Setup and Data Reads */
ods html file="/folders/myfolders/sasuser.v94/224 Final Project/Final Report.html";
options nodate orientation=landscape;

/* Part 1: Setup */
proc format; * format for calculating GPA from letter grade;
	invalue GPA
	"A" = 4.0
	"A-" = 3.7
	"B+" = 3.4
	"B" = 3.0
	"B-" = 2.7
	"C+" = 2.4
	"C" = 2.0
	"C-" = 1.7
	"D+" = 1.4
	"D" = 1.0
	"D-" = .7
	"E" = 0
	"WE" = 0
	"UW" = 0
	"IE" = 0
	other=. 
	; *other captures all non graded classes (P,W,T);
run;

proc format; * format for class standing;
	value Standing
	0.5 - 29.9 = "Freshman"
	29.9 <- 59.9 = "Sophomore"
	59.9 - 89.9 = "Junior"
	90.0 - 500.0 = "Senior"
	;
run;

/* Part 2: Read Data */
/* Create two base data sets. One with all the rows and
/* another with just for only math and stat courses */
data GeneralRawGrades; 
	infile "/folders/myfolders/sasuser.v94/224 Final Project/Final_Data/*.txt" dlm="@" dsd missover;
	length id $ 5 date 3 course $ 10;
	input id $ date course $ credit grade $;
	courseGPA = input(Grade, GPA.);
run;

data StatRawGrades;
	set GeneralRawGrades;
	where course contains "MATH" or course contains "STAT";
run;

/**** SECTION II ****/
/* Create Macro program to run all of reports one and two in one block */
%MACRO GenerateReports(baseData);
/* Prep: Fix the way dates work so it will calculate correctly */
data RawGrades;
	set &baseData.RawGrades;
	if date < 200 then do; 
		semester="Winter";
		year = 1900 + date - 100;
		newDate = (date - 100) * 10+ 1;
	end;
	else if date < 300 then do; 
		semester="Winter";
		year = 1900 + date - 200;
		newDate = (date - 200) * 10 + 2;
	end;
	else if date < 400 then do;
		semester="Spring";
		year = 1900 + date - 300;
		newDate = (date - 300) * 10 + 3;
	end;
	else if date < 500 then do;
		semester="Summer";
		year = 1900 + date - 400;
		newDate = (date - 400) * 10 + 4;
	end;
	else if date < 600 then do; 
		semester="Fall";
		year = 1900 + date - 500;
		newDate = (date - 500) * 10 + 5;
	end;
	else if date < 700 then do;
		semester="Fall";
		year = 1900 + date - 600;
		newDate = (date - 600) * 10 + 6;
	end;
run;


/* Report 1: Students by Semesters */
/* Part 1: Get Credit Hours Earned & Graded Credit Hours by class */
proc sql; 
	create table RawGrades2 as
	select case when grade contains "W" then 0 
		when grade="E" then 0
	    else credit end as earnedCredit, 
	case when grade contains "W" then 0
   	    when grade="E" then 0
		when grade="P" then 0
	    else credit end as gradedCredit,
	*
	from RawGrades
	;
quit;

/* Part 2: Get semesterly GPA */
proc means data=RawGrades mean noprint;
	var courseGPA;
	class id newDate;
	weight credit;
	id semester year;
	ways 2;
	output out=Semester_GPA (drop = _TYPE_ _FREQ_) 
		mean = semesterGPA;
run;

/* Part 3: Get total credits earned by semester */
%MACRO GetHours(type);
proc means data=RawGrades2 sum noprint;
	var &type.credit;
	class id newDate;
	ways 2;
	output out=Semester_&type.Credits (drop = _TYPE_ _FREQ_)
		sum = semester&type.Credits;
run;
%MEND GetHours;

%GetHours(earned);
%GetHours(graded);

/* Part 4: Bind GPA and credits by semester*/
proc sql;
	create table Semester_GPA_Credits as
	select g.id, g.newdate, semester, year, semesterGPA, semesterearnedCredits, semestergradedCredits
	from Semester_GPA as g inner join Semester_earnedCredits as e 
	on g.id = e.id and g.newdate = e.newdate
	inner join Semester_gradedCredits as c
	on g.id = c.id and g.newdate = c.newdate
	;
quit;

/* Part 5: Get Cumulative GPA, Credits, and Class Standing */
*Before calculating sort data by new date;
proc sort data=semester_GPA_Credits;
	by id newdate;
run;
*Calculate cumulating;
data Semester_cGPA;
	set semester_GPA_Credits;
	by id;
	weight = semestergradedCredits * semesterGPA;
	if first.id then do;
		ecCredits = semesterearnedCredits;
		gcCredits = semestergradedCredits;
		cGPAs = weight;
		cGPA = semesterGPA;
	end;
	else do;
		ecCredits + semesterearnedCredits;
		gcCredits + semestergradedCredits;
		cGPAs + weight;
		cGPA = cGPAs / gcCredits;
	end;
	classStanding = put(gcCredits, Standing.);
	drop weight cGPAs;
run;

/* Part 6: Determine repeat classes */
proc sql;
  create table Student_NumRepeats as
  select id, (count(Course)-count(distinct Course)) as numRepeated
  from RawGrades
  where substr(Course,10,1) not ="R"
  group by id
  ;
quit;


/* Part 7: Determine number of each grade type */
proc sql;
	create table Student_NumGradeTypes as
	select id, sum(case when Grade contains "A" then 1 else 0 end) as TotalAs,
	sum(case when Grade contains "B" then 1 else 0 end) as TotalBs,
	sum(case when Grade contains "C" then 1 else 0 end) as TotalCs,
	sum(case when Grade contains "D" then 1 else 0 end) as TotalDs,
	sum(case when Grade contains "E" or Grade="UW" then 1 else 0 end) as TotalEs,
	sum(case when Grade="W" then 1 else 0 end) as TotalWs
	from RawGrades
	group by ID
	;
quit;

/* Part 8: Print Reports */

*Report by semester by student;
data Semester_Final_&baseData.;
	set Semester_cGPA;
	label id = "Student ID"
		  semester = "Semester"
		  year = "Year"
		  semesterGPA = "Semester GPA"
		  semesterearnedCredits = "Earned Credits"
		  semestergradedCredits = "Graded Credits"
		  classStanding = "Class Standing"
		  cGPA = "Cumulative GPA"
		  ecCredits = "Cum. Earned Credits"
		  gcCredits = "Cum. Graded Credits";
	format semesterGPA 4.2
		   cGPA 4.2;
	drop newDate;
run;
title1 "Student's by Semester (&baseData.)";
proc print data=Semester_Final_&baseData. noobs label;
run;

*Report overall by student;
data Student_Cumulative; *reduce the semester table to just the final row for each student;
	set Semester_Final_&baseData.;
	by id;
	if last.id then output;
	drop semester year semesterGPA semesterearnedCredits semestergradedCredits classStanding;
run;

proc sql; *join the table from the previous step to tables created in parts 6 & 7;
	create table Student_Final_&baseData. as
	select Student_Cumulative.id, ecCredits, gcCredits, cGPA, 
		   TotalAs, TotalBs, TotalCs, TotalDs, TotalEs, TotalWs, numRepeated
	from Student_Cumulative inner join Student_NumGradeTypes
	on Student_Cumulative.id = Student_NumGradeTypes.id
	inner join Student_NumRepeats
	on Student_cumulative.id = Student_NumRepeats.id
	;
quit;

title1 "Student's Final Standing (&baseData.)";
proc print data=Student_Final_&baseData. noobs label;
	label numRepeated = "Number of Repeated Courses";
run;
	
%MEND GenerateReports;

/**** SECTION III ****/	
/* Generate reports for the both all classes and just Stats and Math */
%GenerateReports(General);
%GenerateReports(Stat);

/**** SECTION IV ****/
/* Generate report three. Top 10% of students */
data Student_Top; *filter those with credits in the acceptable range;
	set Student_Final_General;
	where ecCredits > 60 && ecCredits < 130;
run;

proc sort data=Student_Top; *sort by cGPA;
	by descending cGPA;
run;

data Student_TopTenth; *subset data to be top 10%;
	do i=1 to n/10 by 1;
	set Student_Top point=i
	nobs=n; output;
	end;
stop;

*Print Report;
title1 "Top 10% of all Students by Overall GPA";
title2 "Taken from those students with credit hours between 60 and 130";
proc report data=Student_TopTenth;
run;
	
/**** SECTION V ****/
/* Generate a plot to describe overall GPA */
/* Does not write to html b/c do not have permission */
title1 "Distribution of Student GPAs at BYU";
proc sgplot data=Student_Final_General;
  histogram cGPA;
  density cGPA  / type=kernel lineattrs=(pattern=solid);
  xaxis label="Grade Point Average";
run;

ods html close;