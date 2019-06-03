*STAT 224 Final Project;

*Step 1: Read in Data;

proc format;
	invalue GPA
	"A" = 4.0
	"A-" = 3.7
	"B+" = 3.4
	"B" = 3.0
	"B-" = 2.7
	
	"D-" = .7
	other=0
	;
run;

DATA final;
	infile "/home/jward4/my_content/*.txt" dlm="@" dsd missover;
	length ID $ 5 Date 3 Course $ 10;
	input ID $ Date Course $ Credit Grade $;
	*if Grade = "A" then GPAgrade = 4.0;
	*if Grade = "A-" then GPAgrade = 3.7;
	GPAgrade = input(Grade, GPA.);
run;

*Semester GPA;
proc sql;
	create table semesterGPA as
	select ID, Date, sum(Credit*GPAgrade)/sum(Credit) as semGPA,
		sum(Credit) as SemesterCredsForGPA
	from final
	where Grade not in ("P" "W" "I")
	group by ID, Date
	;
run;

*The start of Cumulative GPA;	
DATA CumGPA;
	set semesterGPA;
	BY ID;
	weight = SemesterCredsForGPA * semGPA;
	if first.ID then CumCreds = SemesterCredsForGPA;
	else CumCreds + SemesterCredsForGPA;
run;
	
*SQL to get total As;
Proc SQL;
	Create table Totals as
	select ID, sum(case when substr(Grade,1,1) = "A" then 1 else 0 end) as TotalAs 
		/* case when Grade in ("A" "A-") then   */
	from final
	Group by ID
	;
quit;
