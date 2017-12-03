--CHECKING TRIGGERS

--insert into Issue values(11,6, TO_DATE('2016-11-25','YYYY-MM-DD'), TO_DATE(NULL));
--insert into Issue values(2,2, TO_DATE('2016-11-25','YYYY-MM-DD'), NULL);
--insert into Issue values(3,3, TO_DATE('2016-11-25','YYYY-MM-DD'), TO_DATE('2016-11-27','YYYY-MM-DD'));
insert into Issue values(1,1, TO_DATE('1989-12-15','YYYY-MM-DD'), TO_DATE('1989-12-16','YYYY-MM-DD'));
insert into Issue values(1,2, TO_DATE('1989-12-17','YYYY-MM-DD'), TO_DATE('1989-12-18','YYYY-MM-DD'));
insert into Issue values(2,3, TO_DATE('1989-12-19','YYYY-MM-DD'), TO_DATE('1989-12-20','YYYY-MM-DD'));
insert into Issue values(2,4, TO_DATE('1989-12-21','YYYY-MM-DD'), TO_DATE('1989-12-22','YYYY-MM-DD'));
insert into Issue values(3,5, TO_DATE('1989-12-23','YYYY-MM-DD'), TO_DATE('1989-12-24','YYYY-MM-DD'));
--insert into Issue values(5,8, TO_DATE('2016-11-27','YYYY-MM-DD'), TO_DATE('1989-12-18','YYYY-MM-DD'));
--insert into Issue values(10,10, TO_DATE('1989-12-17','YYYY-MM-DD'), NULL);

--UPDATE Issue
--SET return_date = TO_DATE('1989-12-09','YYYY-MM-DD')
--WHERE book_id = 2;

--SELECT *
--FROM Books;

--SELECT *
--FROM Issue;

--CHECKING FUNCTIONS
DECLARE
	answer NUMBER;
BEGIN
--answer := fun_issue_book(9, 10,to_date('21/1/2015','DD/MM/YYYY'));
--answer:= FUN_ISSUE_ANYEDITION(1, 'DATA MANAGEMENT', 'C.J. DATES', (TO_DATE('2015/03/03', 'yyyy/mm/dd'))); 
--answer:= FUN_MOST_POPULAR(12,1989);
answer:= fun_renew_book(9,10,TO_DATE('2000-3-1','YYYY-MM-DD'));
--answer:= fun_return_book(8,TO_DATE('2016-12-1','YYYY-MM-DD'));
END; 
.
RUN;

SELECT *
FROM Issue;
--SELECT *
--From Pending_request;
--EXECUTE pro_print_borrower();
--EXECUTE pro_print_fine(SYSDATE);
--EXECUTE pro_listborr_mon(6,11,2016);
--EXECUTE pro_listborr();
