CREATE OR REPLACE procedure pro_print_borrower IS
days NUMBER;
issueDate DATE;
name_ varchar2(100);
bookTitle varchar2(100);
today DATE := SYSDATE;
cursor borrowerID IS
	SELECT B.name,Bks.book_title, I.issue_date
	FROM Borrower B, Books Bks, Issue I
	WHERE Bks.book_id = I.book_id AND I.borrower_id = B.borrower_id;

BEGIN
	DBMS_OUTPUT.enable;
	OPEN borrowerID;
	DBMS_OUTPUT.PUT_LINE('Borrower Name   Book Title   <=5 days   <=10 days   <=15 days   >15 days');
	
	DBMS_OUTPUT.PUT_LINE('------------    ---------    --------   ---------   ---------   --------');
	
	LOOP
		FETCH borrowerID INTO name_, bookTitle, issueDate;
		EXIT WHEN borrowerID%notfound;
		days := floor(today-issueDate);
		IF (days <=5) THEN
			DBMS_OUTPUT.PUT_LINE(name_||'  '||bookTitle||'      '||days);
		ELSIF (days <=10) THEN
                        DBMS_OUTPUT.PUT_LINE(name_||'  '||bookTitle||'                   '||days);
		ELSIF (days <=15) THEN
                        DBMS_OUTPUT.PUT_LINE(name_||'   '||bookTitle||'                              '||days);
		ELSE
                        DBMS_OUTPUT.PUT_LINE(name_||'    '||bookTitle||'                                        '||days);

                END IF;
	END LOOP;
END pro_print_borrower;
.
RUN;        

CREATE OR REPLACE procedure pro_print_fine (today DATE) IS
name_ varchar2(100);
ID number;
issueDate date;
fine number;
borrowedDays number;
returnDate DATE;
returnDays number;

cursor fine_amount IS
	SELECT B.name, Bks.book_id, I.issue_date, I.return_date 
	FROM Issue I, Borrower B, Books Bks
	WHERE  I.borrower_id = B.borrower_id AND Bks.book_id = I.book_id;

BEGIN
	OPEN fine_amount;
	LOOP
		FETCH fine_amount INTO name_,ID,issueDate,returnDate;
		EXIT WHEN fine_amount%notfound;
		borrowedDays := today - issueDate;
		returnDays := returnDate-IssueDate;
		IF (borrowedDays > 5 AND returnDate IS NULL) THEN
			fine := (borrowedDays - 5)*5;
			DBMS_OUTPUT.PUT_LINE('The borrower ' ||name_||' has been issued  book number '||ID||'. The total fine is '||floor(fine));
		ELSIF (returnDays > 5) THEN 
			fine := (returnDays - 5)*5;
                        DBMS_OUTPUT.PUT_LINE('The borrower ' ||name_||' has been issued  book number '||ID||'. The total fine is '||floor(fine)||'.');
		END IF;
	END LOOP;
END pro_print_fine;
.
RUN;

CREATE OR REPLACE procedure pro_listborr_mon
(borrowerID number, month number, year number) IS 
borrID number;
borrname varchar2(100);
bookID number;
bookTitle varchar2(100);
issueDate Date;
returnDate Date;

cursor list IS
	SELECT B.borrower_id, B.name, I.book_id,Bks.book_title, I.issue_date, I.return_date
        FROM ISSUE I, Borrower B, Books Bks
        WHERE EXTRACT(MONTH FROM I.issue_date) = month AND EXTRACT (YEAR FROM I.issue_date) = year AND
		I.book_id = Bks.book_id AND B.borrower_id = I.borrower_id AND B.borrower_id = borrowerID;
BEGIN
	OPEN list;
	LOOP
		FETCH list INTO borrID, borrname, bookID, bookTitle, issueDate, returnDate;
		EXIT WHEN list%notfound;
		DBMS_OUTPUT.PUT_LINE('BorrowerID = ' ||borrID||', BorrowerName = '||borrname||', BookID = '||bookID||', bookTitle = '||bookTitle||
				     ', issueDate = '||issueDate||', returnDate = '||returnDate||'.');
	END LOOP;
END pro_listborr_mon;
.
RUN;
	
CREATE OR REPLACE procedure pro_listborr IS
bookID number;
issueDate date;
borrName varchar2(50);

cursor listborr is 
	SELECT B.name, I.book_id, I.issue_date
	FROM Issue I, Borrower B	
	WHERE I.return_date IS NULL AND I.borrower_id = B.borrower_id;
BEGIN
	OPEN listborr;
	LOOP
		FETCH listborr INTO borrName, bookID, issueDate;
		EXIT WHEN listborr%notfound;
		DBMS_OUTPUT.PUT_LINE('Name = '||borrname||', BookID = '||bookID||', Issue date = '||issueDate);
	END LOOP;
END pro_listborr;
.
RUN;		

CREATE OR REPLACE procedure pro_list_popular (year NUMBER) IS
       	answers varchar2(500);
BEGIN
	DECLARE
	name1 varchar2(100);
BEGIN
DBMS_OUTPUT.PUT_LINE('FOR JANUARY, '||year);
answers := fun_most_popular(1, year);
DBMS_OUTPUT.PUT_LINE('FOR FEBURARY, '||year);
answers := fun_most_popular(2, year);
DBMS_OUTPUT.PUT_LINE('FOR MARCH, '||year);
answers := fun_most_popular(3, year);
DBMS_OUTPUT.PUT_LINE('FOR APRIL, '||year);
answers := fun_most_popular(4, year);
DBMS_OUTPUT.PUT_LINE('FOR MAY, '||year);
answers := fun_most_popular(5, year);
DBMS_OUTPUT.PUT_LINE('FOR JUNE, '||year);
answers := fun_most_popular(6, year);
DBMS_OUTPUT.PUT_LINE('FOR JULY, '||year);
answers := fun_most_popular(7, year);
DBMS_OUTPUT.PUT_LINE('FOR AUGUST, '||year);
answers := fun_most_popular(8, year);
DBMS_OUTPUT.PUT_LINE('FOR SEPTEMBER, '||year);
answers := fun_most_popular(9, year);
DBMS_OUTPUT.PUT_LINE('FOR OCTOBER, '||year);
answers := fun_most_popular(10, year);
DBMS_OUTPUT.PUT_LINE('FOR NOVEMBER, '||year);
answers := fun_most_popular(11, year);
DBMS_OUTPUT.PUT_LINE('FOR DECEMBER, '||year);
answers := fun_most_popular(12, year);
END;
END pro_list_popular;
.
RUN;
