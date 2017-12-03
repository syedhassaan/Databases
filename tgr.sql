set serveroutput on
CREATE OR REPLACE TRIGGER trg_maxbooks
BEFORE INSERT ON Issue
FOR EACH ROW
DECLARE
	count1 NUMBER;
	member VARCHAR2(7);
	book_out_of_range EXCEPTION;
	book_out_of_range1 EXCEPTION;

BEGIN
	SELECT COUNT(I.book_id) INTO count1
	FROM ISSUE I, BORROWER B
	WHERE I.borrower_id = :new.borrower_id AND B.borrower_id = I.borrower_id AND return_date IS NULL;
	
	SELECT B.status INTO member
	FROM BORROWER B
	WHERE B.borrower_id = :new.borrower_id;
	
	IF ((count1 = 3 AND member = 'faculty')) THEN
		RAISE book_out_of_range;
	END IF;

	IF ((count1 = 2 AND member = 'student')) THEN
		RAISE book_out_of_range1;
	END IF;

	EXCEPTION
		WHEN book_out_of_range THEN
			raise_application_error(-20300, 'Sorry!Faculty only allowed 3 books');
                WHEN book_out_of_range1 THEN
                        raise_application_error(-20300, 'Sorry!Students only allowed 2 books');

END trg_maxbooks;
.
run; 

CREATE OR REPLACE TRIGGER trg_issue
AFTER INSERT ON Issue
FOR EACH ROW
BEGIN
	dbms_output.enable; 
	UPDATE Books B 
	SET B.status = 'issued'
	WHERE B.book_id = :new.book_id;
        --DBMS_OUTPUT.PUT_LINE('HERE');
END trg_issue;
.
run;

CREATE OR REPLACE TRIGGER trg_notissue
AFTER UPDATE ON Issue
--AFTER UPDATE OF return_date OR DELETE ON Issue
FOR EACH ROW
BEGIN
	dbms_output.enable;
	UPDATE Books B
	SET B.status = 'not issued'
	WHERE B.book_id = :new.book_id;
	--DBMS_OUTPUT.PUT_LINE('HERE2');
END trg_notissue;
.
run;
