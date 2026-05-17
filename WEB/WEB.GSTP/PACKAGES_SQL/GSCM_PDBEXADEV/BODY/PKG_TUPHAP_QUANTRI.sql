--------------------------------------------------------
--  DDL for Package Body PKG_TUPHAP_QUANTRI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_TUPHAP_QUANTRI" AS
FUNCTION TUPHAP_INFOR_HIS_DS
(
  vGet_chil number,
  V_DONVI_THA_ID in nvarchar2,
  PageIndex	in	int,
  PageSize	in	int
  )
RETURN SYS_REFCURSOR
IS 
 V_CURSOR sys_refcursor;
  MININDEX	number;MAXINDEX	number;
  var_arrsx  nvarchar2(250);
var_loaitoa varchar2(20);
BEGIN
  MININDEX := pagesize*(PAGEINDEX - 1) + 1;
  MAXINDEX := PAGEINDEX*pagesize ;
  if V_DONVI_THA_ID>0 then
 select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=V_DONVI_THA_ID;
  select t.LOAITOA into var_loaitoa from DM_DONVITHIHANHAN t where t.ID=V_DONVI_THA_ID;
else
  var_arrsx:='0';
end if;
 OPEN V_CURSOR FOR  
select DS.* from (
        SELECT  COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY ti.NGAY_SUA desc) STT,
        ti.DONVI_THA_ID,ti.USERID,ti.TEN_TK_THU_HUONG,ti.TEN_DONVI,ti.DIA_CHI,ti.DIEN_THOAI,ti.EMAIL,ti.MA_DINH_DANH,ti.SO_TK,
        ti.TEN_KHO_BAC,ti.MA_KHO_BAC,ti.MA_LH_THU,ti.TEN_LH_THU,ti.NGUOI_SUA,to_char(ti.NGAY_SUA,'dd/MM/yyyy HH:MM:SS')NGAY_SUA
        FROM TUPHAP_INFOR_HIS ti 
        LEFT JOIN DM_DONVITHIHANHAN mn ON mn.ID=ti.DONVI_THA_ID
        WHERE ( (mn.ID=V_DONVI_THA_ID AND vGet_chil=1) OR ( (mn.ARRSAPXEP like (var_arrsx ||'/%') or mn.ARRSAPXEP=var_arrsx) AND vGet_chil=0)  
               OR V_DONVI_THA_ID IS NULL)
  ) DS WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX;  
  RETURN v_cursor;   
END TUPHAP_INFOR_HIS_DS;
--QT_NHOMNGUOIDUNG_HETHONG;QT_NHOMNGUOIDUNG_MENU <=>anhvh chinh la bang ROLES (luu nhung thong tin phan quyen)
--tai pm an phi chi can bang QT_NHOMNGUOIDUNG_MENU vi chi co 1 phan he
FUNCTION QT_DONVI_DS
(
 vGet_chil number,
 vdonviID in number,
  PageIndex	in	int,
  PageSize	in	int
  )
RETURN SYS_REFCURSOR
IS 
 V_CURSOR sys_refcursor;
  MININDEX	number;MAXINDEX	number;
  var_arrsx  nvarchar2(250);
var_loaitoa varchar2(20);
BEGIN
  MININDEX := pagesize*(PAGEINDEX - 1) + 1;
  MAXINDEX := PAGEINDEX*pagesize ;
  if vdonviID>0 then
 select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=vdonviID;
  select t.LOAITOA into var_loaitoa from DM_DONVITHIHANHAN t where t.ID=vdonviID;
else
  var_arrsx:='0';
end if;
 OPEN V_CURSOR FOR  
  select DS.* from (
             Select COUNT(*) OVER()COUNTALL,ROW_NUMBER() OVER (ORDER BY mn.ARRTHUTU) STT,mn.ID,mn.ARRSAPXEP,
            ((CASE (LENGTH(REPLACE(mn.ARRTHUTU,'/'))-1)/3 
                WHEN 2 THEN '..' WHEN 3 THEN'....' WHEN 4 THEN '......'
                WHEN 5 THEN '........' WHEN 6 THEN '..........' ELSE '' END) || MN.MA_TEN) as MA_TEN,
                 ((CASE (LENGTH(REPLACE(mn.ARRTHUTU,'/'))-1)/3 
                WHEN 2 THEN '..' WHEN 3 THEN'....' WHEN 4 THEN '......'
                WHEN 5 THEN '........' WHEN 6 THEN '..........' ELSE '' END) || mn.TEN) as TEN,MN.DIACHI,mn.DIENTHOAI,mn.EMAIL,mn.MA_DINH_DANH
               ,TK.SOTK_KHOBAC,TK.TENTK_KHOBAC,TK.MA_KHOBAC, TK.ID ID_TT,LH.ID ID_LHT,LH.MA MALOAIHINHTHU,LH.TEN TENLOAIHINHTHU,TK.TEN_TK_THUHUONG
            from DM_DONVITHIHANHAN mn
            LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=mn.ID
            LEFT JOIN DM_LOAIHINH_THU LH ON LH.ID=TK.MA_LOAIHINHTHU
            where 
             1=(Case when vGet_chil=1 and mn.id=vdonviID then 1 when vGet_chil=0 and (mn.ARRSAPXEP like (var_arrsx ||'/%') or mn.ARRSAPXEP=var_arrsx) then 1 else 0 End)
      ) DS WHERE DS.STT>=MININDEX AND DS.STT<=MAXINDEX;  
  RETURN v_cursor;   
END;
PROCEDURE QT_NGUOIDUNG_MENU_CHECK
( vMenuPath in nvarchar2,
  vUserID number,
	curReturn    OUT       sys_refcursor
)
IS 
vMenuID  number;
vAction  number;
vCapchaID  number;
BEGIN
   select m.ID,m.ACTION,m.CAPCHAID into vMenuID,vAction,vCapchaID 
   from (Select d.ID,d.ACTION,d.CAPCHAID from TUPHAP_MENU d where LOWER(d.DUONGDAN)=LOWER(vMenuPath)) m
   WHERE ROWNUM = 1;
if vAction=1 then
  select m.ID into vMenuID from TUPHAP_MENU m where m.ID=vCapchaID;
end if;
OPEN curReturn FOR  
    Select m.ID,m.XEM,m.TAOMOI,m.CAPNHAT,m.XOA,vMenuID as MENUID
    from TUPHAP_NHOMNGUOIDUNG_MENU m
    inner join TUPHAP_NGUOISUDUNG nsd on nsd.NHOMNSDID=m.NHOMID
    where nsd.ID=vUserID and m.MENUID=vMenuID and m.XEM=1;      
END QT_NGUOIDUNG_MENU_CHECK;
PROCEDURE        QT_CHUONGTRINH_GETBYUSER
( 
    vUSERID in number,
	curReturn    OUT       sys_refcursor
)
IS 
vNhomID  number;
vChuongTrinhID  number;
BEGIN
 select n.NHOMNSDID into vNhomID from TUPHAP_NGUOISUDUNG n where ID=vUSERID;
OPEN curReturn FOR 
    Select c.ID,c.TENMENU,C.DUONGDAN
    from TUPHAP_MENU c   
    where c.HIEULUC=1
    And c.ID in  (Select MENUID from TUPHAP_NHOMNGUOIDUNG_MENU mn where mn.NHOMID=vNhomID AND MN.XEM=1)
    AND C.CAPCHAID=0--and C.CHUONGTRINHID=1
    Order by c.THUTU;
END QT_CHUONGTRINH_GETBYUSER;
PROCEDURE QT_NHOMNGUOIDUNG_MENU_GETBY
(
    vNhomID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
 OPEN curReturn FOR  
     Select mn.ID,mn.ARRSAPXEP,
    ((CASE (LENGTH(REPLACE(mn.ARRTHUTU,'/'))-1)/3 
        WHEN 2 THEN '..' WHEN 3 THEN'....' WHEN 4 THEN '......'
        WHEN 5 THEN '........' WHEN 6 THEN '..........' ELSE '' END) || MN.TENMENU) as TENMENU,
      nh.XEM,nh.TAOMOI,nh.CAPNHAT,nh.XOA,0 as FULL
    from (Select ID,ARRSAPXEP,ARRTHUTU,TENMENU from TUPHAP_MENU where HIEULUC=1 and ACTION=0) mn          
    left join (Select MENUID,XEM,TAOMOI,CAPNHAT,XOA from TUPHAP_NHOMNGUOIDUNG_MENU where NHOMID=vNhomID) nh on mn.ID=nh.MENUID   
    Order by mn.ARRTHUTU;  
END QT_NHOMNGUOIDUNG_MENU_GETBY;

PROCEDURE QT_NHOMNGUOIDUNG_SEARCHBY
( vLOAITOA in varchar2,
  tennhom in nvarchar2,
  curReturn    OUT       sys_refcursor
)
IS 
vGroupID  number;
BEGIN
select g.ID into vGroupID from DM_DATAGROUP g where MA='LOAITOA';
 OPEN curReturn FOR  
    Select n.ID,n.DONVIID,n.TEN,n.NGUOITAO,n.NGAYTAO,n.NGUOISUA,n.NGAYSUA,k.TEN as TENDONVI       
    from TUPHAP_NHOMNGUOIDUNG n
    left join (Select ID,MA,TEN from DM_DATAITEM where GROUPID=vGroupID) d on d.MA=n.LOAITOA   
    inner join (
            SELECT 1 SOCAP,'9001' ARRTHUTU,60 ID,'TOICAO' MA,'Tổng cục thi hành án dân sự' TEN,'Tổng cục thi hành án dân sự' MA_TEN FROM DUAL
            UNION ALL
            SELECT  1 SOCAP,'9002' ARRTHUTU,61 ID,'CAPCAO' MA,'Nhóm khu vực' TEN,'Nhóm khu vực' MA_TEN  FROM DUAL
             UNION ALL
            SELECT  1 SOCAP,'9003' ARRTHUTU,62 ID,'CAPTINH' MA,'Cục thi hành án tỉnh, thành phố trực thuộc trung ương' TEN,'Cục thi hành án tỉnh, thành phố trực thuộc trung ương' MA_TEN FROM DUAL
              UNION ALL
            SELECT  1 SOCAP,'9004' ARRTHUTU,63 ID,'CAPHUYEN' MA,'Chi cục THADS huyện, quận, thị xã, thành phố thuộc tỉnh' TEN,'Chi cục THADS huyện, quận, thị xã, thành phố thuộc tỉnh' MA_TEN  FROM DUAL
      )k on d.id=k.id
    Where  1=(CASE  WHEN vLOAITOA='TATCA' then 1 WHEN n.LOAITOA=vLOAITOA then 1 else 0 END )
      and Lower(n.TEN) like ('%' || Lower(tennhom) ||'%')
    Order by n.TEN;    

END QT_NHOMNGUOIDUNG_SEARCHBY;
PROCEDURE  QT_NGUOIDUNG_SEARCH
( vdonviID in number,
  vDonvi nvarchar2,
  vLoaiUser number,
  vUserName nvarchar2,
  vHoten nvarchar2,
  curReturn    OUT       sys_refcursor
)
IS 
var_arrsx  nvarchar2(250);
var_loaitoa varchar2(20);
BEGIN
if vdonviID>0 then
 select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=vdonviID;
  select t.LOAITOA into var_loaitoa from DM_DONVITHIHANHAN t where t.ID=vdonviID;
else
  var_arrsx:='0';
end if;
if var_loaitoa='CAPCAO' then
 OPEN curReturn FOR 
    Select nsd.ID,nsd.USERNAME,nsd.HOTEN,nsd.EMAIL,nsd.DIENTHOAI,nsd.HIEULUC,nsd.LOAIUSER,
      nsd.ISACCDOMAIN,t.TEN as TenDonVi,nh.TEN as TenNhomNSD
    from TUPHAP_NGUOISUDUNG nsd
    inner join DM_DONVITHIHANHAN t on nsd.DONVITHA_ID=t.ID
    left join TUPHAP_NHOMNGUOIDUNG nh on nh.ID=nsd.NHOMNSDID
    Where  nsd.DONVITHA_ID=vdonviID
      And 1=(Case When vUserName='' then 1  when Lower(nsd.USERNAME) like ('%'|| Lower(vUserName) || '%') then 1 else 0 End)
      And (
        1=(Case When vHoten='' then 1  when Lower(nsd.HOTEN) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 
        1=(Case When vHoten='' then 1  when Lower(nsd.EMAIL) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 1=(Case When vHoten='' then 1  when Lower(nsd.DIENTHOAI) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
      )
    Order by nsd.USERNAME;
else
 OPEN curReturn FOR 
    Select nsd.ID,nsd.USERNAME,nsd.HOTEN,nsd.EMAIL,nsd.DIENTHOAI,nsd.HIEULUC,nsd.LOAIUSER,
      nsd.ISACCDOMAIN,t.TEN as TenDonVi,nh.TEN as TenNhomNSD
    from TUPHAP_NGUOISUDUNG nsd
    inner join DM_DONVITHIHANHAN t on nsd.DONVITHA_ID=t.ID
    left join TUPHAP_NHOMNGUOIDUNG nh on nh.ID=nsd.NHOMNSDID
  Where 1=(Case when vLoaiUser=1 and nsd.DONVITHA_ID=vdonviID then 1 when vLoaiUser=0 and (t.ARRSAPXEP like (var_arrsx ||'/%') or t.ARRSAPXEP=var_arrsx) then 1 else 0 End)
       And 1=(Case When vUserName='' then 1  when Lower(nsd.USERNAME) like ('%'|| Lower(vUserName) || '%') then 1 else 0 End)
      And (
        1=(Case When vHoten='' then 1  when Lower(nsd.HOTEN) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 
        1=(Case When vHoten='' then 1  when Lower(nsd.EMAIL) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 1=(Case When vHoten='' then 1  when Lower(nsd.DIENTHOAI) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
      )
     --AND NSD.USERNAME !='admin'
    Order by nsd.USERNAME;
end if;    
END QT_NGUOIDUNG_SEARCH;
PROCEDURE  QT_NGUOIDUNG_SEARCH_CLIENT
( vdonviID in number,
  vDonvi nvarchar2,
  vLoaiUser number,
  vUserName nvarchar2,
  vHoten nvarchar2,
  curReturn    OUT       sys_refcursor
)
IS 
var_arrsx  nvarchar2(250);
var_loaitoa varchar2(20);
BEGIN
if vdonviID>0 then
 select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=vdonviID;
  select t.LOAITOA into var_loaitoa from DM_DONVITHIHANHAN t where t.ID=vdonviID;
else
  var_arrsx:='0';
end if;
if var_loaitoa='CAPCAO' then
 OPEN curReturn FOR 
    Select nsd.ID,nsd.USERNAME,nsd.HOTEN,nsd.EMAIL,nsd.DIENTHOAI,nsd.HIEULUC,nsd.LOAIUSER,
      nsd.ISACCDOMAIN,t.TEN as TenDonVi,nh.TEN as TenNhomNSD
    from TUPHAP_NGUOISUDUNG nsd
    inner join DM_DONVITHIHANHAN t on nsd.DONVITHA_ID=t.ID
    left join TUPHAP_NHOMNGUOIDUNG nh on nh.ID=nsd.NHOMNSDID
    Where  nsd.DONVITHA_ID=vdonviID
      And 1=(Case When vUserName='' then 1  when Lower(nsd.USERNAME) like ('%'|| Lower(vUserName) || '%') then 1 else 0 End)
      And (
        1=(Case When vHoten='' then 1  when Lower(nsd.HOTEN) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 
        1=(Case When vHoten='' then 1  when Lower(nsd.EMAIL) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 1=(Case When vHoten='' then 1  when Lower(nsd.DIENTHOAI) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
      )
    Order by nsd.USERNAME;
else
 OPEN curReturn FOR 
    Select nsd.ID,nsd.USERNAME,nsd.HOTEN,nsd.EMAIL,nsd.DIENTHOAI,nsd.HIEULUC,nsd.LOAIUSER,
      nsd.ISACCDOMAIN,t.TEN as TenDonVi,nh.TEN as TenNhomNSD
    from TUPHAP_NGUOISUDUNG nsd
    inner join DM_DONVITHIHANHAN t on nsd.DONVITHA_ID=t.ID
    left join TUPHAP_NHOMNGUOIDUNG nh on nh.ID=nsd.NHOMNSDID
  Where 1=(Case when vLoaiUser=1 and nsd.DONVITHA_ID=vdonviID then 1 when vLoaiUser=0 and (t.ARRSAPXEP like (var_arrsx ||'/%') or t.ARRSAPXEP=var_arrsx) then 1 else 0 End)
       And 1=(Case When vUserName='' then 1  when Lower(nsd.USERNAME) like ('%'|| Lower(vUserName) || '%') then 1 else 0 End)
      And (
        1=(Case When vHoten='' then 1  when Lower(nsd.HOTEN) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 
        1=(Case When vHoten='' then 1  when Lower(nsd.EMAIL) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
        Or 1=(Case When vHoten='' then 1  when Lower(nsd.DIENTHOAI) like ('%'|| Lower(vHoten) || '%') then 1 else 0 End)
      )
     AND NSD.USERNAME !='admin'
    Order by nsd.USERNAME;
end if;    
END QT_NGUOIDUNG_SEARCH_CLIENT;
PROCEDURE  DM_TOAAN_GETBY 
(    donviID in number,
	curReturn    OUT       sys_refcursor
)
IS 
var_arrsx  nvarchar2(250);
BEGIN
if donviID>0 then
 select t.ARRSAPXEP into var_arrsx from DM_DONVITHIHANHAN t where t.ID=donviID;
else
  var_arrsx:='0';
end if;
-- if(var_arrsx is null)then
--         OPEN curReturn FOR 
--        Select t.SOCAP,t.ID,t.MA,t.TEN,t.MA_TEN,
--              ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END)
--              || t.MA_TEN ) as arrTEN,--DECODE(T.ID,1,'... Chon ...',t.MA_TEN)
--              case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi
--        from DM_DONVITHIHANHAN t
--        Where t.HIEULUC=1  AND t.SOCAP!=2--AND (t.SOCAP=3 OR t.SOCAP=4)
--        Order by t.ARRTHUTU;
--    else
        OPEN curReturn FOR 
        Select t.SOCAP,t.ID,t.MA,t.TEN,t.MA_TEN,
              ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END)
              || t.MA_TEN ) as arrTEN,--DECODE(T.ID,1,'... Chon ...',t.MA_TEN)
              case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi
        from DM_DONVITHIHANHAN t
        Where t.HIEULUC=1 and (t.ARRSAPXEP like (var_arrsx ||'/%') or t.ARRSAPXEP=var_arrsx )  AND t.SOCAP!=2--AND (t.SOCAP=3 OR t.SOCAP=4)
        Order by t.ARRTHUTU;
--    end if;
END DM_TOAAN_GETBY;
PROCEDURE  DM_DATAITEM_GETBYGROUPNAME
( vGroupName in nvarchar2,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
    SELECT i.ID,i.MA,k.TEN,((Case k.SOCAP WHen 2 then '...' when 3 then '......' else '' End)||k.Ten) MA_TEN
    FROM DM_DATAITEM i
    inner join DM_DATAGROUP g on g.ID=i.GROUPID
    inner join (
            SELECT 1 SOCAP,'9001' ARRTHUTU,60 ID,'TOICAO' MA,'Tổng cục thi hành án dân sự' TEN,'Tổng cục thi hành án dân sự' MA_TEN FROM DUAL
            UNION ALL
            SELECT  1 SOCAP,'9002' ARRTHUTU,61 ID,'CAPCAO' MA,'Nhóm khu vực' TEN,'Nhóm khu vực' MA_TEN  FROM DUAL
             UNION ALL
            SELECT  1 SOCAP,'9003' ARRTHUTU,62 ID,'CAPTINH' MA,'Cục thi hành án tỉnh, thành phố trực thuộc trung ương' TEN,'Cục thi hành án tỉnh, thành phố trực thuộc trung ương' MA_TEN FROM DUAL
              UNION ALL
            SELECT  1 SOCAP,'9004' ARRTHUTU,63 ID,'CAPHUYEN' MA,'Chi cục THADS huyện, quận, thị xã, thành phố thuộc tỉnh' TEN,'Chi cục THADS huyện, quận, thị xã, thành phố thuộc tỉnh' MA_TEN  FROM DUAL
      )k on i.id=k.id
    Where g.MA=vGroupName and i.HIEULUC=1
    Order By i.ARRTHUTU;
END DM_DATAITEM_GETBYGROUPNAME;
PROCEDURE  TUPHAP_NGUOIDUNG_CHECKLOGIN
(   
   V_USER_NAME IN NVARCHAR2,
   V_PASSWORD IN NVARCHAR2,
   CURRETURN  OUT SYS_REFCURSOR
)
IS 
BEGIN 
      OPEN CURRETURN FOR
       SELECT (CASE
               WHEN TH2.LOAITOA = 'CAPTINH' THEN
                TH2.TEN
               WHEN TH2.LOAITOA = 'CAPHUYEN' THEN
                TH1.TEN
               ELSE
                 TH2.TEN
             END) AS CAP_CUC,
             TH2.LOAITOA,
             TH2.*
        FROM DM_DONVITHIHANHAN TH1,
             (SELECT TH.CAPCHAID,
                     TH.MA_TEN,
                     TH.LOAITOA,
                     SUBSTR(TH.MA_TEN, INSTR(TH.MA_TEN, ',') + 1) AS CAP_CUC1,
                     TH.TEN,
                     NS.*
                FROM TUPHAP_NGUOISUDUNG NS
               INNER JOIN DM_DONVITHIHANHAN TH
                  ON NS.DONVITHA_ID = TH.ID
               WHERE LOWER(NS.USERNAME) = LOWER(V_USER_NAME)
                 AND PASSWORD = (V_PASSWORD)
                 AND NS.HIEULUC = 1) TH2
       WHERE TH1.ID(+) = TH2.CAPCHAID;
END TUPHAP_NGUOIDUNG_CHECKLOGIN;
PROCEDURE  SYN_CHECK_INS_AUTO
IS 
   V_COUNTS NUMBER;
BEGIN 
 BEGIN
  FOR THA IN ( SELECT tha.* FROM DM_DONVITHIHANHAN tha
    )
       LOOP
            SELECT COUNT(*) INTO V_COUNTS FROM DM_TK_THANHTOAN TK WHERE TK.THA_ID=THA.ID;
               IF(V_COUNTS=0)THEN
                   INSERT INTO DM_TK_THANHTOAN
                    (THA_ID,MA_LOAIHINHTHU)
                 VALUES (THA.ID,1);
           END IF;
       END LOOP;
      COMMIT; 
END;
END SYN_CHECK_INS_AUTO;
PROCEDURE TUPHAP_INFOR_HIS_INS
    (
    V_DONVI_THA_ID	in	NUMBER,
    V_USERID	in	NUMBER,
    V_TEN_TK_THU_HUONG	in	VARCHAR2,
    V_TEN_DONVI	in	VARCHAR2,
    V_DIA_CHI	in	VARCHAR2,
    V_DIEN_THOAI	in	VARCHAR2,
    V_EMAIL	in	VARCHAR2,
    V_MA_DINH_DANH	in	VARCHAR2,
    V_SO_TK	in	VARCHAR2,
    V_TEN_KHO_BAC	in	VARCHAR2,
    V_MA_KHO_BAC	in	VARCHAR2,
    V_MA_LH_THU	in	VARCHAR2,
    V_TEN_LH_THU	in	VARCHAR2,
    V_NGUOI_SUA	in	VARCHAR2
    )
AS
BEGIN 
    INSERT INTO TUPHAP_INFOR_HIS
     (DONVI_THA_ID,USERID,TEN_TK_THU_HUONG,TEN_DONVI,DIA_CHI,DIEN_THOAI,EMAIL,MA_DINH_DANH,SO_TK,TEN_KHO_BAC,MA_KHO_BAC,MA_LH_THU,TEN_LH_THU,NGUOI_SUA,NGAY_SUA)
    VALUES (V_DONVI_THA_ID,V_USERID,V_TEN_TK_THU_HUONG,V_TEN_DONVI,V_DIA_CHI,V_DIEN_THOAI,V_EMAIL,V_MA_DINH_DANH,V_SO_TK,V_TEN_KHO_BAC,V_MA_KHO_BAC,V_MA_LH_THU,V_TEN_LH_THU,V_NGUOI_SUA,SYSDATE);
END TUPHAP_INFOR_HIS_INS;
END PKG_TUPHAP_QUANTRI;

/
