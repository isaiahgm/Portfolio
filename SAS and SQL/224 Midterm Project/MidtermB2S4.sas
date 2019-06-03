*read in the Form A1.csv file;
%MACRO readform(form);

data key (keep= ID ans i) student (keep= ID stuans i);
	infile "/home/jward4/my_content/Form &form.1.csv" dlm="," dsd missover;
	input ID $ blank (q1-q150) ($);
	array AA{150} $ q1-q150;
	if ID="&form.&form.&form.&form.KEY" then do i = 1 to 150;
		ans=AA{i};
		output key;
	end;
	else do i = 1 to 150;
		stuans=AA{i};
		output student;
	end;
run;

proc sql;
	create table midterm&form. as
	select student.ID as ID,
		sum(case when ans=stuans then 1 else 0 end) as score,
		round(calculated score/150, .01) as percentage
	from student inner join key 
	on key.i=student.i
	group by student.ID
	order by student.ID
	;
quit;

/*
proc sql;
	create table midterm as
	select *
	from key, student
	where key.i=student.i
	;
quit;
*/

* do something similar with domains i.e. read in domains and add an sql step (group by ID, Domain);

%MEND readform;

%readform(A);
%readform(B);
%readform(C);
%readform(D);

proc sql;
	create table MidtermALL as
	select * 
	from midtermA
	union
	select * 
	from midtermB
	union
	select * 
	from midtermC
	union
	select * 
	from midtermD
	;
quit;

/*
Data MidtermALL;
	set midtermA midtermB midtermC midtermD;
run;
 */

proc sql;
	create table overallavg as
	select avg(percentage) as OverallPerc
	from MidtermALL
	;
quit;

*do something similar for domains;