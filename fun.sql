CREATE OR REPLACE function fun_issue_book
(borrowerID IN NUMBER, bookID IN NUMBER, currentDate IN DATE)
RETURN NUMBER IS 
	answer NUMBER;
	bookstatus VARCHAR2(100);	
	
	BEGIN
	SELECT B.status INTO bookstatus
	FROM Books B
	WHERE B.book_id = bookID;

	IF (bookstatus = 'issued') THEN
		answer := 0;
                insert into Pending_request values(bookID, borrowerID, currentDate, TO_DATE(NULL));
	ELSE 
		answer := 1;
		insert into Issue values(bookID, borrowerID, currentDate, TO_DATE(NULL));
	END IF;
	
	RETURN (answer);

END fun_issue_book;
.
Run;

CREATE OR REPLACE function fun_issue_anyedition
(borrowerID IN NUMBER, bookTitle IN VARCHAR2, authorName IN VARCHAR2, currentDate IN DATE)
RETURN NUMBER IS answer NUMBER;
BEGIN
	DECLARE
	book_ NUMBER;
	edition_ NUMBER;
	BEGIN
	
	SELECT MAX(B.edition) into edition_
	FROM Books B
	WHERE book_title = bookTitle AND B.status != 'issued';
	
	IF (edition_ > 0) THEN
		SELECT B.book_id into book_
		FROM Books B
		WHERE B.book_title = bookTitle and B.edition = edition_;
		insert into issue values(book_, borrowerID, currentDate, TO_DATE(NULL));
		answer := 1;
	ELSIF (edition_ IS NULL) THEN
		SELECT I.book_id into book_
		FROM Issue I, Books B
		WHERE rownum <= 1 AND I.book_id = B.book_id AND 
			B.book_title = bookTitle
		ORDER BY I.issue_date ASC;
		insert into Pending_request values(book_, borrowerID, currentDate, TO_DATE(NULL));
		answer := 0;
	END IF;
	return(answer);
	EXCEPTION WHEN NO_DATA_FOUND THEN
		return(answer);
	END;
END fun_issue_anyedition;
.
Run;

CREATE OR REPLACE function fun_most_popular(month IN NUMBER, year IN NUMBER)
RETURN varchar2 IS answer varchar2(200);
BEGIN
	dbms_output.enable;
	DECLARE
		bookID NUMBER;
		checker NUMBER := 0;
CURSOR popularBooks IS
	SELECT I.book_id
	FROM ISSUE I
	WHERE EXTRACT(MONTH FROM I.issue_date) = month AND EXTRACT (YEAR FROM I.issue_date) = year
	GROUP BY I.book_id
	HAVING COUNT(*)
	=
	(SELECT MAX(COUNT(*))
	FROM ISSUE I1
	WHERE EXTRACT(MONTH FROM I1.issue_date) = month AND EXTRACT(YEAR from I1.issue_date) = year
	GROUP BY I1.book_id);	
BEGIN
	OPEN popularBooks;
LOOP
	FETCH popularBooks INTO bookID;
	EXIT WHEN popularBooks%NOTFOUND;
	IF (CHECKER = 0) THEN
		answer := bookID;
	ELSE
		SELECT CONCAT(answer, CONCAT(', ',bookID)) INTO answer
		FROM DUAL;
	END IF;
	checker := checker + 1;
END LOOP;
	DBMS_OUTPUT.PUT_LINE('The most popular book ID is ' || answer);
	--DBMS_OUTPUT.PUT_LINE('ANSWER: '||answer);
	CLOSE popularBooks;
END;
RETURN answer;
END;
.
RUN;

CREATE OR REPLACE function fun_return_book
(bookID IN NUMBER, currentDate IN DATE)
RETURN NUMBER IS answer NUMBER := 0;
               	 requester NUMBER;
        BEGIN
                UPDATE Books B
                SET status = 'not issued'
                WHERE b.book_id = bookID;

         	UPDATE Issue
                SET return_date = currentDate
                WHERE book_id = bookID;
		answer := 1;		

                SELECT requester_id into requester
		FROM Pending_request
		WHERE request_date IN
			(SELECT MIN(request_date)
			FROM Pending_request
			WHERE issue_date IS NULL AND book_id = bookID);

                IF (requester IS NOT NULL) THEN
			UPDATE Books B
                        SET status = 'issued'
                        WHERE book_id = bookID;
			
                        UPDATE Pending_request
                        SET issue_date = currentDate
                        WHERE book_id = bookID AND requester_id = requester;

            		insert into Issue values(bookID, requester, currentDate, NULL);
       	        END IF;
	RETURN(answer);

	EXCEPTION WHEN NO_DATA_FOUND THEN
	RETURN(answer);

END fun_return_book;
.
RUN;

CREATE OR REPLACE function fun_renew_book
(borrowerID IN NUMBER, bookID IN NUMBER, currentDate IN DATE)
RETURN NUMBER IS answer NUMBER;
BEGIN
	DECLARE
		value NUMBER := 0;
		value_2 NUMBER := 0;

	BEGIN
		SELECT COUNT(*) INTO value_2
                FROM Pending_request
                WHERE book_id = bookID AND issue_date IS NULL;
		
		SELECT book_id INTO value
		FROM Issue 
		WHERE book_id = bookID AND return_date IS NULL AND borrower_id = borrowerID;
	
		IF (value < 0) THEN	
			RETURN answer;
		ELSIF (value_2 > 0) THEN		
			RETURN answer;
		ELSE
			UPDATE Issue
			SET issue_date = currentDate
			WHERE book_id = bookID AND return_date IS NULL;
			answer := 1;
		END IF;
	RETURN answer;
END;
END fun_renew_book;
.
RUN;
