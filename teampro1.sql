----------------------- ȸ������ member
DROP TABLE member;

-- ȸ�����̺� ����
CREATE TABLE member (
  mId VARCHAR2(20) PRIMARY KEY,
  mPw VARCHAR2(25) NOT NULL,
  mName VARCHAR2(20) NOT NULL,
  mPhone1 VARCHAR2(30) NOT NULL,
  mPhone2 VARCHAR2(30) NOT NULL,
  mPhone3 VARCHAR2(30) NOT NULL,
  mEmail VARCHAR2(60) NOT NULL,
  mAddress1 VARCHAR2(100),
  mAddress2 VARCHAR2(100),
  mAddress3 VARCHAR2(100),
  mOut NUMBER DEFAULT 1
);
-- ȸ������
INSERT INTO  member 
  VALUES ('user', '1234','ȫ�浿', '010', '1234', '1234', 'abcd@naver.com', '05055', '�����', '������', 1);
  
-- ȸ����������
SELECT *
  FROM MEMBER
  WHERE MID='user' AND MOUT=1;

-- ȸ����������
UPDATE MEMBER
  SET MPW='1111', MPHONE1='017', MPHONE2='3333', MPHONE3='4444', MEMAIL='a@a.com', MADDRESS1='01', MADDRESS2='���', MADDRESS3='�߱�'
  WHERE MID='user';

-- ȸ��Ż��
UPDATE MEMBER
  SET MPW='1111', MPHONE1='017', MPHONE2='3333', MPHONE3='4444', MEMAIL='a@a.com', MADDRESS1='01', MADDRESS2='���', MADDRESS3='�߱�', MOUT=0
  WHERE MID='user';

-- ���̵�ã��
SELECT *
  FROM MEMBER
  WHERE MEMAIL='abcd@naver.com' and MPHONE1='010' AND MPHONE2='1234' AND MPHONE3='1234' and MOUT=1;

-- ���ã��
SELECT *
  FROM MEMBER
  WHERE MID='user' and MEMAIL='abcd@naver.com' and MOUT=1;
  
-----------------------------������ team
DROP TABLE team;

CREATE TABLE team(
  tId number(10) PRIMARY KEY,
  tName varchar2(50) NOT NULL); 

DROP SEQUENCE tId_SQ;

CREATE SEQUENCE tId_SQ;

----------------------------ȸ��_�� tm_conn
DROP TABLE tm_conn;

CREATE TABLE tm_conn (
  tId NUMBER(10) REFERENCES team(tId),
  mId VARCHAR2(25) REFERENCES member(mId),
  tmLeader NUMBER(1) DEFAULT 0,
  tmOk NUMBER(1) DEFAULT 0); 

--- ��ü �� ��� ���
SELECT * 
  FROM TEAM
  ORDER BY TID DESC;

--- �� ����
INSERT INTO TEAM VALUES(tId_SQ.NEXTVAL, '��1');

--- �� ��ü
DELETE FROM team WHERE tId=1;

--- ����: �������Ҷ� tmConn insert
INSERT INTO TM_CONN VALUES ((select tId from TEAM where tName='��1'), 'user14', 1, 1);

--- mId�� �����ϰ� �ִ� �� ��� ���
SELECT * 
  FROM TM_CONN TM, TEAM T 
  WHERE TM.TID=T.TID AND TM.MID='user14' AND TM.TMOK=1 
  ORDER BY T.TID DESC;
  
--- ����: ����ü�Ҷ� tmConn delete
DELETE FROM TM_CONN WHERE tId=1 AND mId='user14' AND tmLeader=1;

--- mId�� �������� �ִ� �� ����Ʈ ���
SELECT T.TID, T.TNAME 
  FROM TEAM T, TM_CONN TM 
  WHERE T.TID=TM.TID AND TM.MID='user14' AND TM.TMLEADER=1;

--- ����: �� ������û ������ 
INSERT INTO TM_CONN 
  VALUES (3,'user10', 0, 0); 

--- ����: �� ������û ����
UPDATE TM_CONN 
  SET TMOK=1 
  WHERE MID='user2' AND TID=1;

--- ����: �� ������û �ź� 
DELETE 
  FROM TM_CONN 
  WHERE MID='user2' AND TID=1;
  
--- ���� �� Ż��
DELETE FROM TM_CONN WHERE MID='user15' AND TID=1;

--- ���Կ�û�ߺ�: ���Կ�û�� ������
SELECT COUNT(*) 
  FROM TM_CONN 
  WHERE MID='user15' AND TID=1 AND TMOK=0;

--- ���Կ�û�ߺ�: �̹� ���ԵǾ����� 
SELECT COUNT(*) 
  FROM TM_CONN 
  WHERE MID='user15' AND TID=1 AND TMOK=1;

--- tId �� ���� ��û ���
SELECT M.MID, M.MNAME, M.MEMAIL, TM.TID 
  FROM MEMBER M, TM_CONN TM 
  WHERE M.MID=TM.MID AND 
      TM.TID IN (SELECT TID
                FROM TM_CONN
                WHERE MID='user14' AND TMLEADER=1) 
      AND TM.TMOK=0;

--- tId ����ó���
SELECT *
  FROM member m, tm_conn TM , team t 
  WHERE m.mId = tm.mId and t.tId = tm.tId and tmOk=1 and tm.tId=1;
  
--- �� �̸� �˻�
SELECT * FROM TEAM WHERE LOWER(TNAME) LIKE (LOWER('%��%'));

--- ������û �˸�(user14�� �������� �ִ� ��� ���� ���� ��û ����)
SELECT COUNT(*)
  FROM TM_CONN
  WHERE TID IN (SELECT TID FROM TM_CONN
                WHERE MID='user14' AND TMLEADER=1) AND TMOK=0;
                
--- user12�� ��id=1�� �������� �ƴ��� TMOK�����
SELECT TMOK FROM TM_CONN
  WHERE MID='user12' AND TID=1;


--- ������û �˸� 
    
SELECT COUNT(*) FROM TM_CONN
  WHERE (MID='user14' AND TMOK=2)
  OR (TID IN (SELECT TID FROM TM_CONN WHERE MID='user14' AND TMLEADER=1) AND TMOK=0);
  
                
------------------------------------- �Խ��� ����(Board)
DROP TABLE Board;
CREATE TABLE Board(
  mId varchar2(20) REFERENCES MEMBER(mId),
  tId number(10) REFERENCES TEAM(tId),
  bId NUMBER(10) PRIMARY KEY,
  bContent VARCHAR(500),
  bDate timestamp NOT NULL,
  bNo number(2) NOT NULL,
  bfId number(10),
  bfName varchar2(50),
  biId number(10),
  biName varchar2(50),
  bStart timestamp,
  bEnd timestamp,
  bTitle varchar2(100),
  bLoc varchar2(100),
  bMemo varchar2(100));

DROP SEQUENCE bId_sq;
CREATE SEQUENCE bId_SQ;

DROP SEQUENCE bfId_SQ;
CREATE SEQUENCE bfId_SQ;

DROP SEQUENCE biId_SQ;
CREATE SEQUENCE biId_SQ;

DROP TABLE BOARD_RE;
CREATE TABLE BOARD_RE(
  bId NUMBER(10) REFERENCES BOARD(bId), -- �Խù� ��ȣ
  mId varchar2(20) REFERENCES MEMBER(mId), -- �ۼ���
  brId NUMBER(10) PRIMARY KEY, -- ��۹�ȣ
  bRcontent VARCHAR2(500), -- ��۳���
  bRDate timestamp DEFAULT sysdate, -- �ۼ�����
  brDeleteYN CHAR(1 BYTE) DEFAULT 'n',-- ��������  
  brParent NUMBER(10), --�θ���
  brDepth number(10) DEFAULT 0, --����
  brOrder number(10) DEFAULT 1 --����
); 

DROP SEQUENCE brId_SQ;
CREATE SEQUENCE brId_SQ; --brId_SQ ������

SELECT * FROM
  (SELECT ROWNUM RN, A.* 
   FROM (SELECT * FROM Board ORDER BY bId) A)
   WHERE RN BETWEEN #{startRow} AND #{endRow};
   SELECT * FROM board;
INSERT INTO Board
  VALUES('user', 1, bId_SQ.NEXTVAL, '����Ŀ�', sysdate, 1, bfId_SQ.NEXTVAL, 'sdsds', 0, '', sysdate,sysdate,'','','');
INSERT INTO EMP VALUES(#{empno}, #{ename}, #{job}, #{mgr}, #{hiredate}, #{sal}, #{comm}, #{deptno});
ROLLBACK;
commit;
UPDATE board SET BCONTENT='�並���̤�', BFNAME='�����̴�', BINAME='�̹�����' WHERE BID=8; 
