/* 224 Midterm Project */

/* Create output file connection */
ods pdf file="/folders/myfolders/sasuser.v94/224 Midterm Project/Midterm Report.pdf";
options nodate orientation=landscape;

/* Part I: Read in data with macro */
%MACRO readform(form); * Create macro for reading;
* This macro will return a dataset that is named midterm w/ the form appended;

* Read in form;
data key (keep= ID ans i) student (keep= ID stuans i);
	infile "/folders/myfolders/sasuser.v94/224 Midterm Project/Data for Midterm/Form &form.1.csv" 
		dlm="," dsd missover;
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

* Read in domain;
data domain;
	infile "/folders/myfolders/sasuser.v94/224 Midterm Project/Data for Midterm/Domains Form &form..csv"
		dlm="," dsd missover;
	input ItemId DomainDes $ Domain Question;
run;

proc sql; *modify the data to suit our needs;
	create table midterm as
	select student.ID as ID, key.i as Question,
		case when ans=stuans then 1 else 0 end as QuestionScore,
		sum(case when ans=stuans then 1 else 0 end) as score,
		round(calculated score/150, .01) as percentage
	from student inner join key 
	on key.i=student.i
	group by student.ID
	order by student.ID
	;
quit;

proc sql; *join the domain to the dataset previously created;
	create table StudentScores&form. as
	select midterm.ID, score, percentage, domain, QuestionScore
	from midterm inner join domain
	on midterm.Question=domain.Question
	group by midterm.ID
	order by midterm.ID
	;
quit;

proc means data=StudentScores&form. mean sum noprint; *get domain scores;
	var QuestionScore;
	class ID Domain;
	id score percentage;
	ways 2;
	output out=StudentSum (drop = _TYPE_ _FREQ_) 
		   mean = StudentPercents 
		   sum = StudentScores;
run;

data StudentSummary&form.; *put each student on one row;
	set StudentSum;
	retain;
	array scores_array(*) dp1 ds1 dp2 ds2 dp3 ds3 dp4 ds4 dp5 ds5;
	by ID;
	if first.ID then i = 0;
		i + 1;
		scores_array(i) = studentPercents;
		i + 1;
		scores_array(i) = studentScores;
	if last.ID then output;
	drop domain i studentScores studentPercents;
run;

%MEND readform;

* Call Macro to Read in Data for the forms;
%readform(A);
%readform(B);
%readform(C);
%readform(D);

/* Part II: Combined Overall scores for all forms */
data overallTable; * by student;
	retain numID score percentage;
	set StudentSummaryA StudentSummaryB StudentSummaryC StudentSummaryD;
	numID = input(ID, 3.); *Converts Char ID to numeric;
	drop ID;
run;

proc sort data=overallTable;
	by numID;
run;

title "Exam Performance by Student with Domain Sub-Categories";
proc print data=overallTable label noobs;
	label numID = 'Student ID' /* Assign descriptive labels to variables */
		  percentage = 'Overall Percentage'
		  score = 'Overall Score'
		  ds1 = 'Domain 1 Score'
		  dp1 = 'Domain 1 Percentage'
		  ds2 = 'Domain 2 Score'
		  dp2 = 'Domain 2 Percentage'
		  ds3 = 'Domain 3 Score'
		  dp3 = 'Domain 3 Percentage'
		  ds4 = 'Domain 4 Score'
		  dp4 = 'Domain 4 Percentage'
		  ds5 = 'Domain 5 Score'
		  dp5 = 'Domain 5 Percentage';
	format percentage percent8.1 /* Percent formatting */
		  dp1-dp5 percent8.1;
run;


/* Part III: Produce Domain Summary Table */
data domainScores; * Table with just score and domain;
	retain Domain QuestionScore;
	set StudentScoresA StudentScoresB StudentScoresC StudentScoresD;
	drop ID score percentage;
run;

proc means data=domainScores mean noprint; * Calculate overall domain score;
	var QuestionScore;
	class Domain;
	ways 0 1;
	output out=domainSummary (drop = _TYPE_ _FREQ_) 
		   mean = DomainScore;
run;

proc sql; *Name the Domains;
	create table domainSummary2 as
	select case when Domain is missing then "Overall" 
		   when Domain=1 then "Org. and Admin Res. "  
		   when Domain=2 then "Athlete Test and Eval."  
		   when Domain=3 then "Program Des. And Dev."  
		   when Domain=4 then "Assess. Of Perf. Needs" 
		   when Domain=5 then "Athlete Edu. And Training" else "" end as DomainName, 
		   DomainScore
	from domainSummary
	;
quit;

title "Overall Performance for Each Domain";
proc print data=domainSummary2 noobs label;
	label domainScore = "Percentage" domainName = "Domain: ";
	format domainScore percent8.1;
run;


ods pdf close;	
