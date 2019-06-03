*STAT 224 Midterm Project;

*read in data;
data old;
	infile "/home/jward4/my_content/Form A1.csv" dlm="," dsd missover;
	input ID $ blank (q1-q150) ($);
run;

%MACRO readdata(form);

data key (keep=ID ans i) student (keep=ID stuans i);
	infile "/home/jward4/my_content/Form &form.1.csv" dlm="," dsd missover;
	input ID $ blank (q1-q150) ($);
	array A{150} $ q1-q150;
	if ID = "&form.&form.&form.&form.KEY" then do i=1 to 150;
		ans=A{i};
		output key;
	end;
	else do i=1 to 150;
		stuans=A{i};
		output student;
	end;
run;

proc sql;
	create table midterm&form. as
	select student.ID, 
		sum(case when ans=stuans then 1 else 0 end) as score,
		round(calculated score/count(student.ID), .01) as percentage
	from key inner join student
	on student.i=key.i
	group by student.ID;
quit;

/*
*alternate syntax;
proc sql;
	create table midterm as
	select student.ID, 
		sum(case when ans=stuans then 1 else 0 end) as score,
		round(calculated score/count(student.ID), .01) as percentage
	from key, student
	where student.i=key.i
	group by student.ID;
quit;
*/

*read in domains and do something similar (maybe group by ID, Domain);
	
%MEND readdata;

%readdata(A);
%readdata(B);
%readdata(C);
%readdata(D);

proc sql;
	create table midtermALL as
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
data midtermALL;
	set midtermA midtermB midtermC midtermD;
run;
*/	

*do something similar for domains;
*combine domain scores with overall for each student (any presentable format);

*we need overall averages (overall-overall and domain overall);

proc sql;
	create table overall as
	select sum(score)/count(score) as overallscore
	from midtermALL
	;
quit;
	