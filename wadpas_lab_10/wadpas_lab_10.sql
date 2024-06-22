-- task1 
CREATE TABLESPACE lob_space
  DATAFILE 'C:\Tablespaces\lob_tablespace.dbf' SIZE 100M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;
-- task2    
--DROP DIRECTORY lob_documents;
CREATE DIRECTORY lob_documents AS 'C:/documents_lob';
-- task3
CREATE USER lob_user IDENTIFIED BY password;
GRANT CREATE SESSION TO lob_user;
GRANT RESOURCE TO lob_user;
GRANT CONNECT, CREATE TABLE TO lob_user;
--task4 
ALTER USER lob_user QUOTA UNLIMITED ON lob_space;
--task5
CREATE TABLE lob_table (
  FOTO BLOB,
  DOC BFILE
);
--task 6
DECLARE
  v_blob BLOB;
  v_bfile BFILE;
BEGIN
  v_bfile := BFILENAME('LOB_DOCUMENTS', 'stud_card_1.jpg');
  DBMS_LOB.fileopen(v_bfile, DBMS_LOB.file_readonly);
  DBMS_LOB.createtemporary(v_blob, TRUE);
  DBMS_LOB.loadfromfile(v_blob, v_bfile, DBMS_LOB.getlength(v_bfile));
  INSERT INTO lob_table (FOTO) VALUES (v_blob);

  DBMS_LOB.fileclose(v_bfile);
END;
/

INSERT INTO lob_table (DOC) VALUES (BFILENAME('LOB_DOCUMENTS', 'Lab_1_Python_Statistic.pdf'));
INSERT INTO lob_table (DOC) VALUES (BFILENAME('LOB_DOCUMENTS', 'Lab_2_data preprocessing.pdf'));

SELECT BFILENAME('LOB_DOCUMENTS', 'Lab_1_Python_Statistic.pdf') AS file_path
FROM lob_table;

INSERT INTO lob_table (DOC) VALUES (BFILENAME('LOB_DOCUMENTS', 'doc.docx'));

ALTER TABLE your_table
  ADD (YOUR_CLOB_COLUMN CLOB);
/

/
--nclob

ALTER TABLE lob_table
  ADD (NCLOB_COL NCLOB);

DECLARE
  v_nclob_pdf NCLOB;
  v_bfile BFILE;
BEGIN
  DBMS_LOB.createtemporary(v_nclob_pdf, TRUE);
  v_bfile := BFILENAME('LOB_DOCUMENTS', 'Lab_1_Python_Statistic.pdf');
  DBMS_LOB.fileopen(v_bfile, DBMS_LOB.file_readonly);
  DECLARE
    v_file_length NUMBER;
  BEGIN
    v_file_length := DBMS_LOB.getlength(v_bfile);
    DBMS_LOB.loadfromfile(v_nclob_pdf, v_bfile, v_file_length);

    DBMS_LOB.fileclose(v_bfile);
    INSERT INTO lob_table (NCLOB_COL) VALUES (v_nclob_pdf);
  END;
END;
/
