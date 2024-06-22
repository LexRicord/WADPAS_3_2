--1 созд таблицу Report 2 столбца
create sequence seq
    start with 1
    increment by 1
    nocache
    nocycle;

create table Report (
    idd NUMBER,
    xm XMLTYPE);



--2 процедура генерации XML (вкл д-е из 3 табл + пром итоги + штамп t)
create or replace function CreateXML
    (table_name in varchar2,
    word in varchar2) 
return xmltype 
as
  xml xmltype;
  a      NVARCHAR2(500);
  b      NVARCHAR2(600);
begin
  a:='select SYSTIMESTAMP, COUNT(FACULTY.FACULTY), PULPIT.PULPIT, FACULTY.FACULTY from FACULTY
  inner join PULPIT
				on FACULTY.FACULTY = PULPIT.FACULTY 
			  inner join  TEACHER
				on TEACHER.PULPIT = PULPIT.PULPIT
        and PULPIT.FACULTY = ''';
   b:=a || word ||  ''' group by FACULTY.FACULTY, PULPIT.PULPIT '  ;
        
  dbms_output.put_line(b);
        
  select xmlelement("XML",
      xmlelement(evalname(table_name),
      dbms_xmlgen.getxmltype( b )))
  into xml
  from dual;
  return xml;
end CreateXML;

select CreateXML('SUBJECT', 'ЭП') from dual;
SELECT * FROM SUBJECT;
SELECT * FROM FACULTY;


---------------------------

CREATE OR REPLACE PROCEDURE insertProcedure(
    id INTEGER,
    xml IN XMLTYPE)
IS
  CTX dbms_xmlgen.ctxHandle;
  XMLData CLOB;
BEGIN
  CTX := DBMS_XMLGEN.NEWCONTEXT('select PULPIT.PULPIT, FACULTY.FACULTY from FACULTY
        inner join PULPIT
        on FACULTY.FACULTY = PULPIT.FACULTY 
        inner join TEACHER
        on TEACHER.PULPIT = PULPIT.PULPIT'); 
  XMLData := dbms_xmlgen.getXML(CTX);
  
  INSERT INTO Report (idd, xm) 
  VALUES (id, xml);
  
  COMMIT;
  
  dbms_output.put_line(XMLData);
END;

EXEC expsessions;

/

BEGIN
    insertProcedure(1, CreateXML('FACULTY', 'ИТ'));
    insertProcedure(2, CreateXML('SUBJECT', 'ХТиТ'));
    insertProcedure(3, CreateXML('SUBJECT', 'ТОВ'));
END;
/

select * from report;
select r.xm.GETSTRINGVAL() from report r;



--4. созд индекс над XML-столбцом в Report
create index xml_index on Report(extractvalue(xm,'/XML/SUBJECT/ROWSET/ROW/PULPIT[0]/text()')); 


  
--5. созд процедуру извл значений из XML столбца в Report
create or replace procedure findProcedure(word in VARCHAR2, aa out VARCHAR2 ) 
is
begin
      select r.xm.GETSTRINGVAL() xml
      into aa from report r
      where r.xm.EXISTSNODE('/XML/SUBJECT/ROWSET/ROW[FACULTY='''||word||''']')=1;
end findProcedure;
-----------
select * from report;
--------------------
select r.xm.GETSTRINGVAL() xml from report r
      where r.xm.EXISTSNODE('/XML/SUBJECT/ROWSET/ROW[FACULTY='''||'ТОВ'||''']')=1;
---------------------
DECLARE
    aa VARCHAR2(4000);
BEGIN
    findProcedure('ТОВ', aa);
    dbms_output.put_line(aa);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found');
END;

set SERVEROUTPUT ON

