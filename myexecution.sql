set serverouput on
@createtable
@populate
--change this to populate.sql
@tgr
@fun
@pro
--CHECKING FUNCTIONS
DECLARE
       	answers NUMBER;
BEGIN
answers := fun_issue_book(11, 10,to_date('21/2/2016','DD/MM/YYYY'));
answers := fun_issue_book(11, 11,to_date('21/3/2016','DD/MM/YYYY'));
answers := fun_issue_book(11, 16,to_date('21/3/2016','DD/MM/YYYY'));
answers := fun_issue_book(12, 18,to_date('21/2/2016','DD/MM/YYYY'));
answers := fun_issue_book(12, 17,to_date('21/3/2016','DD/MM/YYYY'));

answers := fun_issue_anyedition(2, 'DATA MANAGEMENT', 'C.J. DATES', (TO_DATE('2016/03/03', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(4, 'CALCULUS', 'H. ANTON', (TO_DATE('2016/03/04', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(5, 'ORACLE', 'ORACLE PRESS', (TO_DATE('2016/03/04', 'yyyy/mm/dd'))); 
answers := fun_issue_anyedition(10, 'IEEE MULTIMEDIA', 'IEEE', (TO_DATE('2016/02/27', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(2, 'MIS MANAGEMENT', 'C.J. CATES', (TO_DATE('2016/05/03', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(4, 'CALCULUS II', 'H. ANTON', (TO_DATE('2016/03/04', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(10, 'ORACLE', 'ORACLE PRESS', (TO_DATE('2016/03/04', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(5, 'IEEE MULTIMEDIA', 'IEEE', (TO_DATE('2016/03/03', 'yyyy/mm/dd')));
--answers := fun_issue_anyedition(2, 'DATA STRUCTURE', 'W. GATES', (TO_DATE('2016/03/03', 'yyyy/mm/dd')));
--Students can't borrow more than 2 books. Trigger will be activated on above line.
answers := fun_issue_anyedition(4, 'CALCULUS III', 'H. ANTON', (TO_DATE('2016/04/04', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(11, 'ORACLE', 'ORACLE PRESS', (TO_DATE('2016/03/08', 'yyyy/mm/dd')));
answers := fun_issue_anyedition(6, 'IEEE MULTIMEDIA', 'IEEE', (TO_DATE('2016/02/17', 'yyyy/mm/dd')));
END;
.
RUN;

EXECUTE pro_print_borrower();
EXECUTE pro_print_fine(SYSDATE);

DECLARE 
	answers2 NUMBER;
BEGIN
	answers2 := fun_return_book(1,SYSDATE);
	answers2 := fun_return_book(2,SYSDATE);
     	answers2 := fun_return_book(4,SYSDATE);
     	answers2 := fun_return_book(10,SYSDATE);

END;
.
RUN;

SELECT *
FROM Issue;
SELECT *
FROM Pending_request;

EXECUTE pro_listborr_mon(11,2,2016);
EXECUTE pro_listborr_mon(12,3,2016);
EXECUTE pro_listborr();
EXECUTE pro_list_popular(2016);

insert into Pending_request values(14, 7, to_date('21/1/2014','DD/MM/YYYY'), SYSDATE);

CREATE OR REPLACE procedure waitTime IS
days NUMBER;

BEGIN
	SELECT AVG(P.issue_date-P.request_date) INTO days
	FROM Pending_request P
	WHERE P.issue_date IS NOT NULL;
	DBMS_OUTPUT.PUT_LINE('The average waiting time is '||days||' days');
END waitTime;
.
RUN;

EXECUTE waitTime();

CREATE OR REPLACE procedure longestTime IS
days NUMBER;
name_ varchar2(20);
id_ NUMBER;

BEGIN
	SELECT MAX(P.issue_date	- P.request_date) INTO days
        FROM Pending_request P
        WHERE P.issue_date IS NOT NULL;
	
	SELECT B.name, B.borrower_id INTO name_, id_
	FROM Borrower B, Pending_request P
	WHERE B.borrower_id = P.requester_id AND (P.issue_date - P.request_date) = days;
	DBMS_OUTPUT.PUT_LINE('The longest waiting time is of '||name_||', ID '||id_||'. It is '||floor(days)||' days.');
END longestTime;
.
RUN;
EXECUTE longestTime;

@dropall
--change this to dropall
