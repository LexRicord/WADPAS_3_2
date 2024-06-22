CREATE TABLE FACULTY (
  FACULTY      CHAR(10)      NOT NULL,
  FACULTY_NAME VARCHAR(50),
  CONSTRAINT PK_FACULTY PRIMARY KEY (FACULTY)
);
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('ИДиП', 'Издателькое дело и полиграфия'),
       ('ХТиТ', 'Химическая технология и техника'),
       ('ЛХФ', 'Лесохозяйственный факультет'),
       ('ИЭФ', 'Инженерно-экономический факультет'),
       ('ТТЛП', 'Технология и техника лесной промышленности'),
       ('ТОВ', 'Технология органических веществ'),
       ('ИТ', 'Факультет информационных технологий');

CREATE TABLE PULPIT (
  PULPIT      CHAR(10)      NOT NULL,
  PULPIT_NAME VARCHAR(100),
  FACULTY     CHAR(10)      NOT NULL,
  CONSTRAINT FK_PULPIT_FACULTY FOREIGN KEY (FACULTY) REFERENCES FACULTY (FACULTY),
  CONSTRAINT PK_PULPIT PRIMARY KEY (PULPIT)
);
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY )
             values  ('ИСиТ',    'Иформационный систем и технологий ',                         'ИДиП'  );
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY )
             values  ('ПОиСОИ', 'Полиграфического оборудования и систем обработки информации ', 'ИДиП'  );
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
              values  ('ЛВ',      'Лесоводства',                                                 'ЛХФ') ;         
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ОВ',      'Охотоведения',                                                 'ЛХФ') ;   
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ЛУ',      'Лесоустройства',                                              'ЛХФ');           
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ЛЗиДВ',   'Лесозащиты и древесиноведения',                               'ЛХФ');                
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ЛПиСПС',  'Ландшафтного проектирования и садово-паркового строительства','ЛХФ');                  
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ТЛ',     'Транспорта леса',                                              'ТТЛП');                        
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ЛМиЛЗ',  'Лесных машин и технологии лесозаготовок',                      'ТТЛП');                        
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                   FACULTY)
             values  ('ОХ',     'Органической химии',                                           'ТОВ');            
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                              FACULTY)
             values  ('ТНХСиППМ','Технологии нефтехимического синтеза и переработки полимерных материалов','ТОВ');             
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                      FACULTY)
             values  ('ТНВиОХТ','Технологии неорганических веществ и общей химической технологии ','ХТиТ');                    
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                                         FACULTY)
             values  ('ХТЭПиМЭЕ','Химии, технологии электрохимических производств и материалов электронной техники', 'ХТиТ');
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                      FACULTY)
             values  ('ЭТиМ',    'экономической теории и маркетинга',                              'ИЭФ');   
insert into PULPIT   (PULPIT,    PULPIT_NAME,                                                      FACULTY)
             values  ('МиЭП',   'Менеджмента и экономики природопользования',                      'ИЭФ');  

CREATE TABLE PROFESSION (
    PROFESSION CHAR(20) PRIMARY KEY,
    FACULTY CHAR(10) REFERENCES FACULTY(FACULTY),
    PROFESSION_NAME VARCHAR(100),
    QUALIFICATION VARCHAR(50)
);

CREATE TABLE GROUPS (
    IDGROUP INTEGER PRIMARY KEY AUTOINCREMENT,
    FACULTY CHAR(10) REFERENCES FACULTY(FACULTY),
    PROFESSION CHAR(20) REFERENCES PROFESSION(PROFESSION),
    YEAR_FIRST SMALLINT CHECK (YEAR_FIRST <= strftime('%Y', 'now'))
);

CREATE TABLE STUDENT (
    IDSTUDENT INTEGER PRIMARY KEY AUTOINCREMENT,
    IDGROUP INTEGER REFERENCES GROUPS(IDGROUP),
    NAME NVARCHAR(100),
    BDAY DATE,
    STAMP TIMESTAMP,
    INFO XML,
    FOTO BLOB
);
  