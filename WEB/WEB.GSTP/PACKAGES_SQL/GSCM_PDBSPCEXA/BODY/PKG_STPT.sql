--------------------------------------------------------
--  DDL for Package Body PKG_STPT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT" AS
PROCEDURE GET_TONG_SO_TOI
(
  VBANANID IN VARCHAR2,
  VBICANID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
   KETQUA VARCHAR2(100);
BEGIN
        SELECT COUNT(*) INTO KETQUA  FROM DM_BOLUAT_TOIDANH TD 
        WHERE EXISTS (SELECT 'X' FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT WHERE CT.TOIDANHID=TD.ID AND CT.bananid=VBANANID and CT.bicanid=VBICANID)
        AND KHOAN IS NOT NULL ;
       IF(KETQUA<10) THEN 
          KETQUA:='0'||KETQUA;
        END IF;
 OPEN CURRETURN FOR
  SELECT KETQUA KETQUAS FROM DUAL;
END GET_TONG_SO_TOI;
PROCEDURE GET_CT_TAMGIAM
(
  VVUAN_ID IN VARCHAR2,
  VHIEULUCTUNGAY IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
   KETQUA VARCHAR2(100);V_NGAYTHULY DATE;
BEGIN
        SELECT NGAYTHULY into V_NGAYTHULY FROM AHS_PHUCTHAM_THULY WHERE vuanid=VVUAN_ID;
        KETQUA:=90-(TO_DATE(VHIEULUCTUNGAY,'dd/MM/yyyy')-V_NGAYTHULY);
    OPEN CURRETURN FOR
    SELECT KETQUA KETQUAS FROM DUAL;
END GET_CT_TAMGIAM;
PROCEDURE DM_CANBO_GETALLTHUKY_TTV_CV
(
  VDONVIID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
--13 CHUCVU --12 chức danh  
OPEN CURRETURN FOR
      /*SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN || DECODE(b.toaanid,null, null,' (Biệt phái)') AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
        left join DM_CANBO_BIETPHAI b on b.CANBOID=a.id and b.toaanid = vDonViID --lấy những cán bộ được biệt phái
        INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12 
                    AND  C.MA IN ('TTV','TTVC','TTVCC','TK','TKVC','C008','C009','C010')
                    )B ON B.ID=A.CHUCDANHID
        LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON D.ID=A.CHUCVUID
      WHERE (A.TOAANID=VDONVIID AND A.HIEULUC=1) or (b.toaanid=VDONVIID and TO_CHAR(b.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') and (TO_CHAR(b.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or b.denngay is null)) ORDER BY A.HOTEN;*/
      SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
        INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12 
                    AND  C.MA IN ('TTV','TTVC','TTVCC','TK','TK1','TKVC','C008','C009','C010')
                    )B ON B.ID=A.CHUCDANHID
        LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON D.ID=A.CHUCVUID
      WHERE (A.TOAANID=VDONVIID AND A.HIEULUC=1) 
      UNION
      SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN || ' (Biệt phái)' AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
        left join DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = VDONVIID --lấy những cán bộ được biệt phái
        INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12 
                    AND  C.MA IN ('TTV','TTVC','TTVCC','TK','TK1','TKVC','C008','C009','C010')
                    )B ON (bp.CHUCDANH IS NOT NULL AND B.ID=bp.CHUCDANH)  OR (bp.CHUCDANH IS NULL AND B.ID=A.CHUCDANHID)
        LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON (bp.CHUCVU IS NOT NULL AND D.ID=bp.CHUCVU)  OR (bp.CHUCVU IS NULL AND D.ID=A.CHUCVUID)
      WHERE A.HIEULUC=1 AND (bp.toaanid=VDONVIID and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null))       
      ORDER BY HOTEN;
END DM_CANBO_GETALLTHUKY_TTV_CV;
PROCEDURE  DM_CANBO_GETBYDONVI_byCHUCVU 
(
  vDonViID in number,
  v_VuAnID in number,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select a.ID,a.HOTEN,a.HOTEN || DECODE(d.TEN,NULL,NULL, '-' || d.TEN) MA_TEN
  from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    left join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID --and (c.MA='CA' Or c.MA='PCA' or c.MA in ('0011','052')) 
                ) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID 
  --And a.HIEULUC=1
  order by  a.HIEULUC desc, d.ThuTu;
END DM_CANBO_GETBYDONVI_byCHUCVU;
PROCEDURE    SOLUONGDONKK_TOAKHAC 
(
    v_toa_an_id IN VARCHAR2,
    curReturn    OUT   sys_refcursor
)
AS
	counts number;
BEGIN
 SELECT  count(*) into counts 
 FROM (
    select A.* from ADS_DON_XULY a 
    where A.CDTN_TOAANID=v_toa_an_id 
    and not EXISTS(select 'x' from ADS_DON_XULY where TOAANID=v_toa_an_id and DONID=A.DONID)

    UNION ALL
    select A.* from AHN_DON_XULY a 
    where A.CDTN_TOAANID=v_toa_an_id 
    and not EXISTS(select 'x' from AHN_DON_XULY where TOAANID=v_toa_an_id and DONID=A.DONID)

    UNION ALL
    select A.* from AKT_DON_XULY a 
    where A.CDTN_TOAANID=v_toa_an_id 
    and not EXISTS(select 'x' from AKT_DON_XULY where TOAANID=v_toa_an_id and DONID=A.DONID)

    UNION ALL
    select A.* from ALD_DON_XULY a 
    where A.CDTN_TOAANID=v_toa_an_id 
    and not EXISTS(select 'x' from ALD_DON_XULY where TOAANID=v_toa_an_id and DONID=A.DONID)

    UNION ALL
    select A.* from AHC_DON_XULY a 
    where A.CDTN_TOAANID=v_toa_an_id 
    and not EXISTS(select 'x' from AHC_DON_XULY where TOAANID=v_toa_an_id and DONID=A.DONID)
    );
    OPEN CurReturn FOR
	select  counts CountAll from dual;  
END;
PROCEDURE  GAIDOAN_UP
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOAPHUCTHAMID IN NUMBER,
    V_TOACAPCAOID IN NUMBER,
    V_TOANTOICAOID IN NUMBER,
    V_PHONGBANID IN NUMBER
)
IS 
  V_COUNT_CHECK NUMBER;V_TOAANID_ST NUMBER;
BEGIN
    -- DM_LOAIAN
    --1 hình sự
    IF(V_LOAI_AN='1') THEN 
       SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHS_VUAN_GIAIDOAN GD
       WHERE GD.VUANID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
       -----
       IF(V_COUNT_CHECK>0)THEN
           IF(V_MAGIAIDOAN=2)THEN 
                UPDATE AHS_VUAN_GIAIDOAN
                SET TOAANID=V_TOAANID
                WHERE VUANID=V_VUAN_DONID AND MAGIAIDOAN=V_MAGIAIDOAN;
           END IF;
       END IF;
   --2 dân sự    
    ELSIF(V_LOAI_AN='2') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ADS_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;
          -----
        IF(V_COUNT_CHECK>0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                UPDATE ADS_DON_GIAIDOAN
                SET  TOAANID=V_TOAANID
                WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN=V_MAGIAIDOAN; 
           END IF;
         END IF;
    --3 hôn nhân gia đình     
      ELSIF(V_LOAI_AN='3') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHN_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK>0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
               UPDATE AHN_DON_GIAIDOAN
                SET  TOAANID=V_TOAANID
                WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN=V_MAGIAIDOAN; 
           END IF;
         END IF;
     ----4 kinh tế    
     ELSIF(V_LOAI_AN='4') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AKT_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK>0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                UPDATE AKT_DON_GIAIDOAN
                SET  TOAANID=V_TOAANID
                WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN=V_MAGIAIDOAN; 
           END IF;
        END IF;
     --5 lao động   
     ELSIF(V_LOAI_AN='5') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ALD_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK>0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                UPDATE ALD_DON_GIAIDOAN
                SET  TOAANID=V_TOAANID
                WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN=V_MAGIAIDOAN; 
           END IF;
         END IF;
     --6 hành chính    
     ELSIF(V_LOAI_AN='6') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHC_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK>0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                UPDATE AHC_DON_GIAIDOAN
                SET  TOAANID=V_TOAANID
                WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN=V_MAGIAIDOAN; 
           END IF;
         END IF;
        ----------
      --phá sản 07
      --biện pháp xử lý hành chính 08
      --án GDTTT 09
      --AN_THA 10
    END IF;
END;
PROCEDURE  GAIDOAN_DELETE
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER
)
IS 
BEGIN
    IF(V_LOAI_AN='1') THEN 
        DELETE FROM AHS_VUAN_GIAIDOAN WHERE VUANID=V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
     ELSIF(V_LOAI_AN='2') THEN 
       DELETE FROM ADS_DON_GIAIDOAN WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
     ELSIF(V_LOAI_AN='3') THEN 
       DELETE FROM AHN_DON_GIAIDOAN WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
     ELSIF(V_LOAI_AN='4') THEN 
       DELETE FROM AKT_DON_GIAIDOAN WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;   
     ELSIF(V_LOAI_AN='5') THEN 
       DELETE FROM ALD_DON_GIAIDOAN WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
     ELSIF(V_LOAI_AN='6') THEN 
      DELETE FROM AHC_DON_GIAIDOAN WHERE DONID=V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
    END IF;
END;
PROCEDURE  CHECK_CHUCDANH_THUKY_USER
(
  vDonViID in number,
  vChucDanh in varchar2,
  vCanBoID in number,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
   select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';

    open CurReturn for
        select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN as MA_TEN,d.TEN as ChucVu from DM_CANBO a
          inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID and c.MA=vChucDanh) b on b.ID=a.CHUCDANHID
          left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
        where a.TOAANID=vDonViID And a.HIEULUC=1 and a.ID=vCanBoID Order by a.HOTEN;

END CHECK_CHUCDANH_THUKY_USER;

-- Bản trước khi up của toàn cầu (đợi test xong thì xóa)
--PROCEDURE  GAIDOAN_IN_UP
--( 
--    V_LOAI_AN IN VARCHAR2,
--    V_VUAN_DONID IN NUMBER,
--    V_MAGIAIDOAN IN NUMBER,
--    V_TOAANID IN NUMBER,
--    V_TOAPHUCTHAMID IN NUMBER,
--    V_TOACAPCAOID IN NUMBER,
--    V_TOANTOICAOID IN NUMBER,
--    V_PHONGBANID IN NUMBER
--)
--IS 
--  V_COUNT_CHECK NUMBER;V_TOAANID_ST NUMBER;
--BEGIN
--    -- DM_LOAIAN
--    --1 hình sự
--    IF(V_LOAI_AN='1') THEN 
--       SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHS_VUAN_GIAIDOAN GD
--       WHERE GD.VUANID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
--       -----
--       IF(V_COUNT_CHECK=0)THEN
--           IF(V_MAGIAIDOAN=2)THEN 
--                INSERT INTO AHS_VUAN_GIAIDOAN
--                       (VUANID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
--           ELSIF(V_MAGIAIDOAN=3)THEN
--                   SELECT TOAANID INTO V_TOAANID_ST FROM AHS_VUAN_GIAIDOAN GD 
--                   WHERE GD.VUANID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
--                   FETCH FIRST 1 ROWS ONLY;
--                  --------
--                  INSERT INTO AHS_VUAN_GIAIDOAN
--                       (VUANID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
--           END IF;
--       END IF;
--   --2 dân sự    
--    ELSIF(V_LOAI_AN='2') THEN 
--          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ADS_DON_GIAIDOAN GD 
--          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;
--          -----
--        IF(V_COUNT_CHECK=0)THEN 
--          IF(V_MAGIAIDOAN=2)THEN 
--                INSERT INTO ADS_DON_GIAIDOAN
--                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
--           ELSIF(V_MAGIAIDOAN=3)THEN
----              SELECT TOAANID INTO V_TOAANID_ST FROM ADS_DON_GIAIDOAN GD 
----                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
----                  FETCH FIRST 1 ROWS ONLY;
--                    V_TOAANID_ST := V_TOAANID;
--                  ---------    
--                  INSERT INTO ADS_DON_GIAIDOAN
--                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
--           END IF;
--         END IF;
--    --3 hôn nhân gia đình     
--      ELSIF(V_LOAI_AN='3') THEN 
--          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHN_DON_GIAIDOAN GD 
--          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
--          -----
--        IF(V_COUNT_CHECK=0)THEN 
--          IF(V_MAGIAIDOAN=2)THEN 
--                INSERT INTO AHN_DON_GIAIDOAN
--                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
--           ELSIF(V_MAGIAIDOAN=3)THEN
--                  SELECT TOAANID INTO V_TOAANID_ST FROM AHN_DON_GIAIDOAN GD 
--                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
--                  FETCH FIRST 1 ROWS ONLY;
--                  ---------    
--                  INSERT INTO AHN_DON_GIAIDOAN
--                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
--           END IF;
--         END IF;
--     ----4 kinh tế    
--     ELSIF(V_LOAI_AN='4') THEN 
--          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AKT_DON_GIAIDOAN GD 
--          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
--          -----
--        IF(V_COUNT_CHECK=0)THEN 
--          IF(V_MAGIAIDOAN=2)THEN 
--                INSERT INTO AKT_DON_GIAIDOAN
--                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
--           ELSIF(V_MAGIAIDOAN=3)THEN
--                  SELECT TOAANID INTO V_TOAANID_ST FROM AKT_DON_GIAIDOAN GD 
--                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
--                  FETCH FIRST 1 ROWS ONLY;
--                  ---------    
--                  INSERT INTO AKT_DON_GIAIDOAN
--                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
--           END IF;
--        END IF;
--     --5 lao động   
--     ELSIF(V_LOAI_AN='5') THEN 
--          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ALD_DON_GIAIDOAN GD 
--          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
--          -----
--        IF(V_COUNT_CHECK=0)THEN 
--          IF(V_MAGIAIDOAN=2)THEN 
--                INSERT INTO ALD_DON_GIAIDOAN
--                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
--           ELSIF(V_MAGIAIDOAN=3)THEN
--                  SELECT TOAANID INTO V_TOAANID_ST FROM ALD_DON_GIAIDOAN GD 
--                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
--                  FETCH FIRST 1 ROWS ONLY;
--                  ---------    
--                  INSERT INTO ALD_DON_GIAIDOAN
--                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
--           END IF;
--         END IF;
--     --6 hành chính    
--     ELSIF(V_LOAI_AN='6') THEN 
--          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHC_DON_GIAIDOAN GD 
--          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
--          -----
--        IF(V_COUNT_CHECK=0)THEN 
--          IF(V_MAGIAIDOAN=2)THEN 
--                INSERT INTO AHC_DON_GIAIDOAN
--                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
--           ELSIF(V_MAGIAIDOAN=3)THEN
--                  SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD 
--                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
--                  FETCH FIRST 1 ROWS ONLY;
--                  ---------    
--                  INSERT INTO AHC_DON_GIAIDOAN
--                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
--                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
--           END IF;
--         END IF;
--        ----------
--      --phá sản 07
--      --biện pháp xử lý hành chính 08
--      --án GDTTT 09
--      --AN_THA 10
--    END IF;
--END;
PROCEDURE  GAIDOAN_IN_UP
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOAPHUCTHAMID IN NUMBER,
    V_TOACAPCAOID IN NUMBER,
    V_TOANTOICAOID IN NUMBER,
    V_PHONGBANID IN NUMBER
)
IS 
  V_COUNT_CHECK NUMBER;V_TOAANID_ST NUMBER;
BEGIN
    -- DM_LOAIAN
    --1 hình sự
    IF(V_LOAI_AN='1') THEN 
       SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHS_VUAN_GIAIDOAN GD
       WHERE GD.VUANID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
       -----
       IF(V_COUNT_CHECK=0)THEN
           IF(V_MAGIAIDOAN=2)THEN 
                INSERT INTO AHS_VUAN_GIAIDOAN
                       (VUANID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
           ELSIF(V_MAGIAIDOAN=3)THEN
                   SELECT TOAANID INTO V_TOAANID_ST FROM AHS_VUAN_GIAIDOAN GD 
                   WHERE GD.VUANID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                   FETCH FIRST 1 ROWS ONLY;
                  --------
                  INSERT INTO AHS_VUAN_GIAIDOAN
                       (VUANID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
           --toancau-anhnt thêm insert cho phúc thẩm quyết đinh
           ELSIF(V_MAGIAIDOAN=7)THEN
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO AHS_VUAN_GIAIDOAN
                        (VUANID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,7,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
           
       END IF;
   --2 dân sự    
    ELSIF(V_LOAI_AN='2') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ADS_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                INSERT INTO ADS_DON_GIAIDOAN
                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
           ELSIF(V_MAGIAIDOAN=3)THEN
--              SELECT TOAANID INTO V_TOAANID_ST FROM ADS_DON_GIAIDOAN GD 
--                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
--                  FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO ADS_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
            --toancau-anhnt thêm insert cho phúc thẩm quyết đinh
           ELSIF(V_MAGIAIDOAN=7)THEN
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO ADS_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,7,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
        --toancau-anhnt thêm insert cho ptqdk
           END IF;
         END IF;
    --3 hôn nhân gia đình     
      ELSIF(V_LOAI_AN='3') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHN_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                INSERT INTO AHN_DON_GIAIDOAN
                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
           ELSIF(V_MAGIAIDOAN=3)THEN
                  SELECT TOAANID INTO V_TOAANID_ST FROM AHN_DON_GIAIDOAN GD 
                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                  FETCH FIRST 1 ROWS ONLY;
                  ---------    
                  INSERT INTO AHN_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
           --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           ELSIF(V_MAGIAIDOAN=7)THEN
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO AHN_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,7,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
        --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           END IF;
         END IF;
     ----4 kinh tế    
     ELSIF(V_LOAI_AN='4') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AKT_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                INSERT INTO AKT_DON_GIAIDOAN
                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
           ELSIF(V_MAGIAIDOAN=3)THEN
                  SELECT TOAANID INTO V_TOAANID_ST FROM AKT_DON_GIAIDOAN GD 
                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                  FETCH FIRST 1 ROWS ONLY;
                  ---------    
                  INSERT INTO AKT_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
                 --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           ELSIF(V_MAGIAIDOAN=7)THEN
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO AKT_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,7,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
        --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           END IF;
        END IF;
     --5 lao động   
     ELSIF(V_LOAI_AN='5') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ALD_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                INSERT INTO ALD_DON_GIAIDOAN
                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
           ELSIF(V_MAGIAIDOAN=3)THEN
                  SELECT TOAANID INTO V_TOAANID_ST FROM ALD_DON_GIAIDOAN GD 
                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                  FETCH FIRST 1 ROWS ONLY;
                  ---------    
                  INSERT INTO ALD_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           ELSIF(V_MAGIAIDOAN=7)THEN
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO ALD_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,7,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
        --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           END IF;
         END IF;
     --6 hành chính    
     ELSIF(V_LOAI_AN='6') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHC_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=2)THEN 
                INSERT INTO AHC_DON_GIAIDOAN
                       (DONID,MAGIAIDOAN,TOAANID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,2,V_TOAANID,sysdate,sysdate);
           ELSIF(V_MAGIAIDOAN=3)THEN
                  SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD 
                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                  FETCH FIRST 1 ROWS ONLY;
                  ---------    
                  INSERT INTO AHC_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
            --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           ELSIF(V_MAGIAIDOAN=7)THEN
                    V_TOAANID_ST := V_TOAANID;
                  ---------    
                  INSERT INTO AHC_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,7,V_TOAANID_ST,V_TOAPHUCTHAMID,sysdate,sysdate);
        --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
           END IF;
         END IF;
        ----------
      --phá sản 07
      --biện pháp xử lý hành chính 08
      --án GDTTT 09
      --AN_THA 10
    END IF;
END;
PROCEDURE  GAIDOAN_IN_UP_XXLAI_PHUCTHAM
( 
    V_LOAI_AN IN VARCHAR2,
    V_VUAN_DONID IN NUMBER,
    V_MAGIAIDOAN IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOAPHUCTHAMID IN NUMBER,
    V_TOACAPCAOID IN NUMBER,
    V_TOANTOICAOID IN NUMBER,
    V_PHONGBANID IN NUMBER
)
IS 
  V_COUNT_CHECK NUMBER;
BEGIN
    -- DM_LOAIAN
    --1 hình sự
    IF(V_LOAI_AN='1') THEN 
           SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHS_VUAN_GIAIDOAN GD
           WHERE GD.VUANID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
           -----
        IF(V_COUNT_CHECK=0)THEN
           IF(V_MAGIAIDOAN=3)THEN
                  INSERT INTO AHS_VUAN_GIAIDOAN
                       (VUANID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
       END IF;
   --2 dân sự    
    ELSIF(V_LOAI_AN='2') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ADS_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=3)THEN 
                  INSERT INTO ADS_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
         END IF;
    --3 hôn nhân gia đình     
      ELSIF(V_LOAI_AN='3') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHN_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=3)THEN 
                  INSERT INTO AHN_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
         END IF;
     ----4 kinh tế    
     ELSIF(V_LOAI_AN='4') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AKT_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=3)THEN  
                  INSERT INTO AKT_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
        END IF;
     --5 lao động   
     ELSIF(V_LOAI_AN='5') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM ALD_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=3)THEN 
                  INSERT INTO ALD_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
         END IF;
     --6 hành chính    
     ELSIF(V_LOAI_AN='6') THEN 
          SELECT COUNT(*) INTO  V_COUNT_CHECK FROM AHC_DON_GIAIDOAN GD 
          WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=V_MAGIAIDOAN;
          -----
        IF(V_COUNT_CHECK=0)THEN 
          IF(V_MAGIAIDOAN=3)THEN
                  INSERT INTO AHC_DON_GIAIDOAN
                        (DONID,MAGIAIDOAN,TOAANID,TOAPHUCTHAMID,NGAYTAO,NGAYSUA)
                 VALUES(V_VUAN_DONID,3,V_TOAANID,V_TOAPHUCTHAMID,sysdate,sysdate);
           END IF;
         END IF;
        ----------
      --phá sản 07
      --biện pháp xử lý hành chính 08
      --án GDTTT 09
      --AN_THA 10
    END IF;
END;
PROCEDURE  DM_CANBO_GETBYDONVI_CHUCDANH
(
  vDonViID in number,
  vChucDanh in varchar2,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
   select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
   if(vChucDanh='TP') then
       open CurReturn for
          select a.ID,a.HOTEN ||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN,a.HOTEN || '-' || b.TEN||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu,
          a.HOTEN|| '-' || b.TEN|| DECODE(d.TEN,NULL,NULL,'-'||d.TEN) ||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL)||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN_STATUS,a.HIEULUC from DM_CANBO a
           left join DM_CANBO_QUATRINH qt on qt.CANBOID=a.id --30/10/2019 lấy những thẩm phán đã điều chuyển 
            inner join (select c.ID,c.TEN from DM_DATAITEM c 
                        where c.GROUPID=vGroupChucDanhID and c.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) b on b.ID=a.CHUCDANHID
            left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
          where (qt.TOAANID=vDonViID or a.TOAANID=vDonViID)--30/10/2019 lấy những thẩm phán đã điều chuyển
           --And a.HIEULUC=1  
           group by a.ID,a.HOTEN,b.TEN,d.TEN,a.HIEULUC,a.NGAYSINH
          UNION
          select a.ID,a.HOTEN ||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy')|| ' (Biệt phái)' as HOTEN,a.HOTEN || '-' || b.TEN || ' (Biệt phái)'||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu,
          a.HOTEN|| '-' || b.TEN|| DECODE(d.TEN,NULL,NULL,'-'||d.TEN) || ' (Biệt phái)'|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN_STATUS, a.HIEULUC from DM_CANBO a
           inner join DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID --19/01/2022 lấy những thẩm phán biệt phái 
            inner join (select c.ID,c.TEN from DM_DATAITEM c 
                        where c.GROUPID=vGroupChucDanhID and c.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) b on (bp.CHUCDANH IS NOT NULL AND B.ID=bp.CHUCDANH)  OR (bp.CHUCDANH IS NULL AND B.ID=A.CHUCDANHID) --b.ID=bp.CHUCDANH
            left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on (bp.CHUCVU IS NOT NULL AND D.ID=bp.CHUCVU)  OR (bp.CHUCVU IS NULL AND D.ID=A.CHUCVUID) --d.ID=bp.CHUCVU
          where bp.toaanid=vDonViID and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
          And a.HIEULUC=1  
          Order by HIEULUC desc,HOTEN;
   elsif(vChucDanh='TTV') then
       open CurReturn for
          select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu from DM_CANBO a
            inner join (select c.ID,c.TEN from DM_DATAITEM c 
                        where c.GROUPID=vGroupChucDanhID and c.MA in ('TTV','TTVC','TTVCC')) b on b.ID=a.CHUCDANHID
            left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
          where a.TOAANID=vDonViID --And a.HIEULUC=1 
          Order by a.HOTEN;
   elsif(vChucDanh='TK') then
       open CurReturn for
          select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu from DM_CANBO a
            inner join (select c.ID,c.TEN from DM_DATAITEM c 
                        where c.GROUPID=vGroupChucDanhID and c.MA in ('TK','TKVC','TKCC')) b on b.ID=a.CHUCDANHID
            left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
          where a.TOAANID=vDonViID --And a.HIEULUC=1 
          Order by a.HOTEN;    
    elsif(vChucDanh='LTV') then
       open CurReturn for
          select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu from DM_CANBO a
            inner join (select c.ID,c.TEN from DM_DATAITEM c 
                        where c.GROUPID=vGroupChucDanhID and c.MA in ('C018','C019','C029','C030')) b on b.ID=a.CHUCDANHID
            left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
          where a.TOAANID=vDonViID --And a.HIEULUC=1 
          Order by a.HOTEN; 
  else
    open CurReturn for
        select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu from DM_CANBO a
          inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID and c.MA=vChucDanh) b on b.ID=a.CHUCDANHID
          left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
        where a.TOAANID=vDonViID And a.HIEULUC=1  Order by a.HOTEN;
  end if;
END DM_CANBO_GETBYDONVI_CHUCDANH;
PROCEDURE  DM_CANBO_GETBYDONVI_2CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
  /*select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select a.ID,a.HOTEN,a.HOTEN || ' - ' ||d.TEN as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS from DM_CANBO a
    left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    left join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2 or c.MA in ('0011','052')) 
                ) d on d.ID=a.CHUCVUID
    left join (SELECT qq.* FROM DM_CANBO_QUATRINH qq where qq.CHUCVUID in (45,74,436,446) ) qt on qt.CANBOID=a.id  --and qt.CHUCVUID in ('0011','052')  
    -- (45,74,436,446)Chánh án,Phó Chánh án,Quyền Chánh án,Phó Chánh án phụ trách
  where (qt.TOAANID=vDonViID or a.TOAANID=vDonViID) 
  group by a.ID,a.HOTEN,d.TEN,a.HIEULUC,d.ThuTu
  --And a.HIEULUC=1
  order by  a.HIEULUC desc,d.ThuTu;*/


   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  /*select a.ID,a.HOTEN,a.HOTEN || '-' || d.TEN as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS  from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2 or c.MA in ('0011','052'))) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID 
  --And a.HIEULUC=1
  order by  a.HIEULUC desc,d.ThuTu;*/
  select a.ID,a.HOTEN ||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN,a.HOTEN || '-' || d.TEN  ||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL)||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN_STATUS, a.hieuluc, d.thutu  from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2 or c.MA in ('0011','052'))) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID 
  --And a.HIEULUC=1
  UNION 
  select a.ID,a.HOTEN ||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN,a.HOTEN || '-' || d.TEN || ' (Biệt phái)' ||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN || ' (Biệt phái)'||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN_STATUS, a.hieuluc, d.thutu  from DM_CANBO a
    inner join DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID
    left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on (bp.CHUCDANH IS NOT NULL AND b.ID=bp.CHUCDANH)  OR (bp.CHUCDANH IS NULL AND b.ID=A.CHUCDANHID)
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2 or c.MA in ('0011','052'))) d on (bp.CHUCVU IS NOT NULL AND d.ID=bp.CHUCVU)  OR (bp.CHUCVU IS NULL AND d.ID=A.CHUCVUID)
  where a.HIEULUC=1 AND bp.toaanid=vDonViID and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
  order by  HIEULUC desc,ThuTu,HOTEN;
END DM_CANBO_GETBYDONVI_2CHUCVU;

PROCEDURE  DM_CANBO_GETBYDONVI_3CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  vChucVu3 in varchar2,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
 Select a.ID,a.HOTEN,a.HOTEN || '-' || (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END) as MA_TEN,(CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END) as ChucVu,a.HOTEN || '-' || CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END ||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL)||' -  '|| to_char(a.NGAYSINH,'dd/MM/yyyy') HOTEN_STATUS 
from DM_CANBO a
    LEFT join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where (c.MA=vChucVu1 Or c.MA=vChucVu2 or c.MA in ('0011','052'))) d on d.ID=a.CHUCVUID
    LEFT join (select c.ID,c.TEN from DM_DATAITEM c 
        where C.MA IN(select (regexp_substr(vChucVu3,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vChucVu3, '[^,]+', 1, level) is not null )
                        ) b on b.ID=a.CHUCDANHID
WHERE (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END) IS NOT NULL AND a.TOAANID=vDonViID 
  --And a.HIEULUC=1
  order by  a.HIEULUC desc,d.ThuTu;
END DM_CANBO_GETBYDONVI_3CHUCVU;




PROCEDURE  DM_CANBO_GETBYDONVI
(
  VDONVIID IN VARCHAR2,
  CurReturn OUT sys_refcursor  
) AS 
BEGIN
   OPEN CURRETURN FOR
      SELECT A.ID,A.HOTEN || '-' || 'Chánh án' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID=45) OR (bp.ID is not null AND (bp.CHUCVU=45 OR ( bp.CHUCVU is null AND A.CHUCVUID=45)))) AND A.HIEULUC=1 
      UNION ALL
      SELECT A.ID,A.HOTEN || '-' || 'Phó chánh án' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID=74) OR (bp.ID is not null AND (bp.CHUCVU=74 OR ( bp.CHUCVU is null AND A.CHUCVUID=74)))) AND A.HIEULUC=1
      UNION ALL
      SELECT A.ID,A.HOTEN || '-' || 'Quyền chánh án' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID=436) OR (bp.ID is not null AND (bp.CHUCVU=436 OR ( bp.CHUCVU is null AND A.CHUCVUID=436)))) AND A.HIEULUC=1 
      UNION ALL
      SELECT A.ID,A.HOTEN || '-' || 'Chánh văn phòng' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID=444) OR (bp.ID is not null AND (bp.CHUCVU=444 OR ( bp.CHUCVU is null AND A.CHUCVUID=444)))) AND A.HIEULUC=1
      UNION ALL
      SELECT A.ID,A.HOTEN || '-' || 'Phó chánh văn phòng' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID=425) OR (bp.ID is not null AND (bp.CHUCVU=425 OR ( bp.CHUCVU is null AND A.CHUCVUID=425)))) AND A.HIEULUC=1 
      UNION ALL
      SELECT A.ID,A.HOTEN || '-' || 'Quyền chánh văn phòng' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID=435) OR (bp.ID is not null AND (bp.CHUCVU=435 OR ( bp.CHUCVU is null AND A.CHUCVUID=435)))) AND A.HIEULUC=1
      UNION ALL
      SELECT A.ID,A.HOTEN || '-' || 'Chánh tòa' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND A.CHUCVUID = 466 AND A.CHUCDANHID in (383,487,507)) OR (bp.ID is not null AND ((bp.CHUCVU=466 AND bp.CHUCDANH in (383,487,507))OR ( bp.CHUCVU is null AND A.CHUCVUID = 466 AND A.CHUCDANHID in (383,487,507))))) AND A.HIEULUC=1
      UNION ALL      
      SELECT A.ID,A.HOTEN || '-' || 'Thẩm phán' || DECODE(bp.ID, null, '', ' (Biệt phái)') AS MA_TEN FROM DM_CANBO A
      LEFT JOIN DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID 
      and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
      and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)
      WHERE ((A.TOAANID=VDONVIID AND (A.CHUCVUID not in(45,74,436,444,425,435,466) OR A.CHUCVUID IS NULL) AND A.CHUCDANHID in (383,487,507)) OR (bp.ID is not null AND (( (bp.CHUCVU not in(45,74,436,444,425,435,466) OR BP.CHUCVU IS NULL) AND bp.CHUCDANH in (383,487,507)) OR ( bp.CHUCVU is null AND bp.CHUCDANH is null AND (A.CHUCVUID not in(45,74,436,444,425,435,466) OR A.CHUCVUID IS NULL) AND A.CHUCDANHID in (383,487,507))))) AND A.HIEULUC=1;
END DM_CANBO_GETBYDONVI;
PROCEDURE DM_TOAAN_GETBY_PARENT
( 
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    V_LOAITOA in VARCHAR2,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
 OPEN curReturn FOR 
    Select t.ID,t.MA,t.TEN,t.MA_TEN,
          ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || t.MA_TEN) as arrTEN,
          case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi
    from DM_TOAAN t
    Where --t.HIEULUC=1 
     ( (V_CAPXX IS NULL AND t.id= V_DONVIID)
          OR (V_CAPXX='2' AND t.id= V_DONVIID)
          OR (V_CAPXX='3' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
    )
--    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
--                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
--                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
--                           )

    Order by t.ARRTHUTU;

END DM_TOAAN_GETBY_PARENT;

PROCEDURE DM_TOAAN_GETBY_PARENT_HC
( 
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    V_LOAITOA in VARCHAR2,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
 OPEN curReturn FOR 
    Select t.ID,t.MA,t.TEN,t.MA_TEN,
          ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || t.MA_TEN) as arrTEN,
          case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi
    from DM_TOAAN t
    Where --t.HIEULUC=1 
     ( (V_CAPXX IS NULL AND t.id= V_DONVIID)
          OR (V_CAPXX='2' AND t.id= V_DONVIID)
          OR (V_CAPXX='3' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID
                                OR t.CAPCHAID = (select b.id from dm_toaan b where t.capchaid = b.id and b.capchaid = V_DONVIID)          
                              )
             )
    )
    Order by t.ARRTHUTU;

END DM_TOAAN_GETBY_PARENT_HC;



PROCEDURE DM_CANBO_GETALLTHUKY_TTV
(
  VDONVIID IN VARCHAR2,
  VCHUCDANH IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
--13 CHUCVU --12 chức danh  

OPEN CURRETURN FOR
      SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
        INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12 
                    AND ( 
                            ((trim(vChucDanh) IS NULL ) AND C.MA IN ('TTV','TTVC','TTVCC','TK1','C027','TK','TKVC'))--'TK1','C027','TK','TKVC' Thư ký,Thư ký Tòa án ko ÐHL,Thư ký Tòa án,Thư ký viên chính
                         OR (instr(','||trim(vChucDanh)||',',','||C.MA||',')>0)
                        )
                    ) B ON B.ID=A.CHUCDANHID
        LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON D.ID=A.CHUCVUID
      WHERE (A.TOAANID=VDONVIID AND A.HIEULUC=1) 
      UNION 
      SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN || ' (Biệt phái)' AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
        inner join DM_CANBO_BIETPHAI bp on bp.CANBOID=a.id and bp.toaanid = vDonViID --lấy những cán bộ được biệt phái
        INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12 
                    AND ( 
                            ((trim(vChucDanh) IS NULL ) AND C.MA IN ('TTV','TTVC','TTVCC','TK1','C027','TK','TKVC'))--'TK1','C027','TK','TKVC' Thư ký,Thư ký Tòa án ko ÐHL,Thư ký Tòa án,Thư ký viên chính
                         OR (instr(','||trim(vChucDanh)||',',','||C.MA||',')>0)
                        )
                    ) B ON (bp.CHUCDANH IS NOT NULL AND B.ID=bp.CHUCDANH)  OR (bp.CHUCDANH IS NULL AND B.ID=A.CHUCDANHID)
        LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON (bp.CHUCVU IS NOT NULL AND D.ID=bp.CHUCVU)  OR (bp.CHUCVU IS NULL AND D.ID=A.CHUCVUID)--D.ID=bp.CHUCVU
      WHERE A.HIEULUC=1 AND(bp.toaanid=VDONVIID and TO_CHAR(bp.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') and (TO_CHAR(bp.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or bp.denngay is null)) 
      ORDER BY HOTEN;
END DM_CANBO_GETALLTHUKY_TTV;
PROCEDURE DM_CANBO_GETALL
(
  VDONVIID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
--13 CHUCVU --12 chức danh      
OPEN CURRETURN FOR
      SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN||DECODE(D.TEN,NULL,NULL,'-'||D.TEN) AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
        INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12) B ON B.ID=A.CHUCDANHID
        LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON D.ID=A.CHUCVUID
      WHERE A.TOAANID=VDONVIID AND A.HIEULUC=1 ORDER BY A.HOTEN;
END DM_CANBO_GETALL;
FUNCTION CHUYENAN_KTT_QUYEN_UPDATE
(
 V_ID VARCHAR2,
 V_LOAI_AN VARCHAR2
)
 RETURN SYS_REFCURSOR
 IS
  V_CURSOR sys_refcursor;V_THANHCONG VARCHAR2(255);
BEGIN
      --Những dữ liệu đã chuyển và đã nhận
      --update lại sự sai lệch về đơn vị,và update thành chưa nhận để nhận lại sẽ ok theo quy trình mới
      V_THANHCONG:=NULL;
        ------------AHS_
      IF(V_LOAI_AN IS NULL OR (V_LOAI_AN='1' AND V_LOAI_AN IS NOT NULL )) THEN 
      FOR rec IN (
            SELECT TA.TEN,TA1.TEN TEN_TOA_CHUYEN,VA.ID,VA.MAVUAN,VA.TOAANID,CN.TOACHUYENID,CN.TOANHANID 
            FROM AHS_VUAN VA 
            INNER JOIN AHS_CHUYEN_NHAN_AN CN ON CN.VUANID=VA.ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=VA.TOAANID
            LEFT JOIN DM_TOAAN TA1 ON TA1.ID=CN.TOACHUYENID
            WHERE CN.TRUONGHOPGIAONHANID=266 
            AND(V_ID IS NULL OR (VA.ID=V_ID AND V_ID IS NOT NULL))
            --TRUONGHOP_GIAONHAN
            --266 Không thuộc thẩm quyền xét xử
            --271 Không thuộc thẩm quyền giải quyết
            )
        LOOP
           UPDATE AHS_VUAN
           SET TOAANID=rec.TOACHUYENID
           where ID=REC.ID;
            -----------     
            UPDATE AHS_VUAN_GIAIDOAN
            SET TOAANID=rec.TOACHUYENID
            WHERE VUANID=REC.ID;
            -----------
            UPDATE AHS_CHUYEN_NHAN_AN
            SET TRANGTHAI=0,NGAYNHAN =NULL,MAP_VUANID_NEW=NULL
            WHERE VUANID=REC.ID;
            -----------
            COMMIT;
        END LOOP;
          V_THANHCONG:='1';
     END IF;
      ------------ADS_
      IF(V_LOAI_AN IS NULL OR (V_LOAI_AN='2' AND V_LOAI_AN IS NOT NULL )) THEN 
      FOR rec IN (
            SELECT TA.TEN,TA1.TEN TEN_TOA_CHUYEN,DON.ID,DON.MAVUVIEC,DON.TOAANID,CN.TOACHUYENID,CN.TOANHANID 
            FROM ADS_DON DON 
            INNER JOIN ADS_CHUYEN_NHAN_AN CN ON CN.VUANID=DON.ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=DON.TOAANID
            LEFT JOIN DM_TOAAN TA1 ON TA1.ID=CN.TOACHUYENID
            WHERE CN.TRUONGHOPGIAONHANID=266 
            AND(V_ID IS NULL OR (DON.ID=V_ID AND V_ID IS NOT NULL))
            )
        LOOP
           UPDATE ADS_DON
           SET TOAANID=rec.TOACHUYENID
           where ID=REC.ID;
            -----------     
            UPDATE ADS_DON_GIAIDOAN
            SET TOAANID=rec.TOACHUYENID
            WHERE DONID=REC.ID;
            -----------
            UPDATE ADS_CHUYEN_NHAN_AN
            SET TRANGTHAI=0,NGAYNHAN =NULL,MAP_VUANID_NEW=NULL
            WHERE VUANID=REC.ID;
            -----------
            COMMIT;
        END LOOP;
          V_THANHCONG:=V_THANHCONG||','||'2';
     END IF;
      --------AHN_------------
       IF(V_LOAI_AN IS NULL OR (V_LOAI_AN='3' AND V_LOAI_AN IS NOT NULL )) THEN 
      FOR rec IN (
            SELECT TA.TEN,TA1.TEN TEN_TOA_CHUYEN,DON.ID,DON.MAVUVIEC,DON.TOAANID,CN.TOACHUYENID,CN.TOANHANID 
            FROM AHN_DON DON 
            INNER JOIN AHN_CHUYEN_NHAN_AN CN ON CN.VUANID=DON.ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=DON.TOAANID
            LEFT JOIN DM_TOAAN TA1 ON TA1.ID=CN.TOACHUYENID
            WHERE CN.TRUONGHOPGIAONHANID=266 
            AND(V_ID IS NULL OR (DON.ID=V_ID AND V_ID IS NOT NULL))
            )
        LOOP
           UPDATE AHN_DON
           SET TOAANID=rec.TOACHUYENID
           where ID=REC.ID;
            -----------     
            UPDATE AHN_DON_GIAIDOAN
            SET TOAANID=rec.TOACHUYENID
            WHERE DONID=REC.ID;
            -----------
            UPDATE AHN_CHUYEN_NHAN_AN
            SET TRANGTHAI=0,NGAYNHAN =NULL,MAP_VUANID_NEW=NULL
            WHERE VUANID=REC.ID;
            -----------
            COMMIT;
        END LOOP;
         V_THANHCONG:=V_THANHCONG||','||'3';
      END IF;   
        --------AKT_------------
       IF(V_LOAI_AN IS NULL OR (V_LOAI_AN='4' AND V_LOAI_AN IS NOT NULL )) THEN   
      FOR rec IN (
            SELECT TA.TEN,TA1.TEN TEN_TOA_CHUYEN,DON.ID,DON.MAVUVIEC,DON.TOAANID,CN.TOACHUYENID,CN.TOANHANID 
            FROM AKT_DON DON 
            INNER JOIN AKT_CHUYEN_NHAN_AN CN ON CN.VUANID=DON.ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=DON.TOAANID
            LEFT JOIN DM_TOAAN TA1 ON TA1.ID=CN.TOACHUYENID
            WHERE CN.TRUONGHOPGIAONHANID=266 
            AND(V_ID IS NULL OR (DON.ID=V_ID AND V_ID IS NOT NULL))
            )
        LOOP
           UPDATE AKT_DON
           SET TOAANID=rec.TOACHUYENID
           where ID=REC.ID;
            -----------     
            UPDATE AKT_DON_GIAIDOAN
            SET TOAANID=rec.TOACHUYENID
            WHERE DONID=REC.ID;
            -----------
            UPDATE AKT_CHUYEN_NHAN_AN
            SET TRANGTHAI=0,NGAYNHAN =NULL,MAP_VUANID_NEW=NULL
            WHERE VUANID=REC.ID;
            -----------
            COMMIT;
        END LOOP;
         V_THANHCONG:=V_THANHCONG||','||'4';
      END IF;   
         IF(V_LOAI_AN IS NULL OR (V_LOAI_AN='5' AND V_LOAI_AN IS NOT NULL )) THEN 
            --------ALD_------------
      FOR rec IN (
            SELECT TA.TEN,TA1.TEN TEN_TOA_CHUYEN,DON.ID,DON.MAVUVIEC,DON.TOAANID,CN.TOACHUYENID,CN.TOANHANID 
            FROM ALD_DON DON 
            INNER JOIN ALD_CHUYEN_NHAN_AN CN ON CN.VUANID=DON.ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=DON.TOAANID
            LEFT JOIN DM_TOAAN TA1 ON TA1.ID=CN.TOACHUYENID
            WHERE CN.TRUONGHOPGIAONHANID=266 
            AND(V_ID IS NULL OR (DON.ID=V_ID AND V_ID IS NOT NULL))
            )
        LOOP
           UPDATE ALD_DON
           SET TOAANID=rec.TOACHUYENID
           where ID=REC.ID;
            -----------     
            UPDATE ALD_DON_GIAIDOAN
            SET TOAANID=rec.TOACHUYENID
            WHERE DONID=REC.ID;
            -----------
            UPDATE ALD_CHUYEN_NHAN_AN
            SET TRANGTHAI=0,NGAYNHAN =NULL,MAP_VUANID_NEW=NULL
            WHERE VUANID=REC.ID;
            -----------
            COMMIT;
        END LOOP;
        V_THANHCONG:=V_THANHCONG||','||'5';
    END IF;     
        IF(V_LOAI_AN IS NULL OR (V_LOAI_AN='6' AND V_LOAI_AN IS NOT NULL )) THEN 
            --------AHC_------------
      FOR rec IN (
            SELECT TA.TEN,TA1.TEN TEN_TOA_CHUYEN,DON.ID,DON.MAVUVIEC,DON.TOAANID,CN.TOACHUYENID,CN.TOANHANID 
            FROM AHC_DON DON 
            INNER JOIN AHC_CHUYEN_NHAN_AN CN ON CN.VUANID=DON.ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=DON.TOAANID
            LEFT JOIN DM_TOAAN TA1 ON TA1.ID=CN.TOACHUYENID
            WHERE CN.TRUONGHOPGIAONHANID=266 
            AND(V_ID IS NULL OR (DON.ID=V_ID AND V_ID IS NOT NULL))
            )
        LOOP
           UPDATE AHC_DON
           SET TOAANID=rec.TOACHUYENID
           where ID=REC.ID;
            -----------     
            UPDATE AHC_DON_GIAIDOAN
            SET TOAANID=rec.TOACHUYENID
            WHERE DONID=REC.ID;
            -----------
            UPDATE AHC_CHUYEN_NHAN_AN
            SET TRANGTHAI=0,NGAYNHAN =NULL,MAP_VUANID_NEW=NULL
            WHERE VUANID=REC.ID;
            -----------
            COMMIT;
        END LOOP;
        V_THANHCONG:=V_THANHCONG||','||'6';
     END IF;
        --------------------
         OPEN V_CURSOR FOR
           SELECT V_THANHCONG THANHCONG FROM DUAL;
       RETURN V_CURSOR;   
END CHUYENAN_KTT_QUYEN_UPDATE;
PROCEDURE DM_TOAAN_GETBY_PARENT_CHECK
( 
    V_CANBOID in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    V_LOAITOA in VARCHAR2,
	curReturn    OUT       sys_refcursor
)
IS 
    V_COUNT_CA NUMBER;
    V_COUNT_PCA NUMBER;
    V_COUNT_CAPDUOI NUMBER;
BEGIN
   -- Kiem tra xem can bo co phải CA không
     SELECT COUNT(*) INTO V_COUNT_CA FROM DM_CANBO cb 
        WHERE cb.id=V_CANBOID 
            and EXISTS(SELECT C.ID,C.ten FROM dm_dataitem C WHERE C.groupid=13 AND C.ID IN (45) AND CB.CHUCVUID=c.id);
    -- Kieam tra xem co  phai PCA khong
     SELECT COUNT(*) INTO V_COUNT_PCA FROM DM_CANBO cb 
        WHERE cb.id=V_CANBOID 
            and EXISTS(SELECT C.ID,C.ten FROM dm_dataitem C WHERE C.groupid=13 AND C.ID IN (74,446,436) AND CB.CHUCVUID=c.id);
     -- Kiem tra xem co thuoc nhom quyen xem du lieu cap duoi khong
     Select COUNT(*) INTO V_COUNT_CAPDUOI 
            from QT_NGUOISUDUNG nsd
            left join QT_NHOMNGUOIDUNG nh on nh.ID=nsd.NHOMNSDID
            Where  nsd.canboid = V_CANBOID
                and nsd.DONVIID = V_DONVIID
               and nh.loai = 1;
    --45 Chánh án,74 Phó Chánh án,436 Quyền Chánh án,446 Phó Chánh án phụ trách
    --and EXISTS(SELECT 'X' FROM STPT_PCA_DIABAN db WHERE db.)
 OPEN curReturn FOR 
    Select t.ID,t.MA,t.TEN,t.MA_TEN,
          ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || t.MA_TEN) as arrTEN,
          case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi
    from DM_TOAAN t
    Where --t.HIEULUC=1 
     ( (V_CAPXX IS NULL AND t.id= V_DONVIID)
          OR (V_CAPXX IS NULL 
                        AND ((V_COUNT_CA>0 AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
                             OR (V_COUNT_PCA>0 AND (t.id= V_DONVIID 
                                    OR (t.id in (SELECT db.TOAANID FROM STPT_PCA_DIABAN db WHERE db.DONVIID = V_DONVIID AND db.PCAID = V_CANBOID))))
                             OR (V_COUNT_CAPDUOI>0 AND V_COUNT_PCA = 0 AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))

                            )
                )
          OR (V_CAPXX='2' --AND t.id= V_DONVIID 
                          AND(     (t.id= V_DONVIID AND V_COUNT_CA=0)
                                OR ((t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID) AND V_COUNT_CA>0)
                                OR ((t.id= V_DONVIID 
                                        OR (t.id in (SELECT db.TOAANID FROM STPT_PCA_DIABAN db WHERE db.DONVIID = V_DONVIID AND db.PCAID = V_CANBOID))
--                                        OR T.CAPCHAID=V_DONVIID
                                    ) AND V_COUNT_PCA>0)
                                Or ((t.id= V_DONVIID 
                                        OR (t.id in (SELECT db.TOAANID FROM STPT_PCA_DIABAN db WHERE db.DONVIID = V_DONVIID AND db.PCAID = V_CANBOID))
                                    ) AND V_COUNT_CAPDUOI>0)

                             )--đang làm dở mai thêm chọn tất cả cho chánh án
            )
          OR (V_CAPXX='3' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
        )
--    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
--                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
--                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
--                           )
    Order by t.ARRTHUTU;
END DM_TOAAN_GETBY_PARENT_CHECK;   
PROCEDURE DM_PCA_BYTOAAN
    ( 
        V_DONVIID in VARCHAR2,
        curReturn    OUT       sys_refcursor
    )
    IS 
        vGroupChucVuID number;
    BEGIN
         select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
        open CurReturn for  
            select a.ID,'PCA.'||a.hoten hoten,b.Ten TenChucVu
            from dm_canbo a
            --manhnd bo không cần phải có tài khoản trên phần mềm để hiển thị
            --inner join QT_NGUOISUDUNG c on c.canboid=a.id
            inner join dm_dataitem b on a.ChucVuID = b.ID
            inner join DM_TOAAN t on t.id = a.TOAANID
              where t.id=V_DONVIID
                and b.GroupId =vGroupChucVuID 
                and b.hieuluc=1 
                and b.Ma in ('PCA') 
                --anhvh add 08/04/2020 loại bỏ chánh án tối cao, khhông hiển thị báo cáo login này
                and not exists(select 'x' from DM_DATAITEM i  where i.MA in ('TPTATC') and i.GROUPID=12 and i.id=a.CHUCDANHID)
                 ;


    END DM_PCA_BYTOAAN;

    PROCEDURE DM_TOAAN_DIABAN
    ( 
        V_CANBOID in VARCHAR2,
        V_DONVIID in VARCHAR2,
        curReturn    OUT       sys_refcursor
    )
    IS 
        V_COUNT_CB NUMBER;
    BEGIN
     SELECT COUNT(*) INTO V_COUNT_CB FROM DM_CANBO cb WHERE cb.id=V_CANBOID and
                EXISTS(SELECT C.ID,C.ten FROM dm_dataitem C WHERE C.groupid=13 AND C.ID IN (74,446,436) AND CB.CHUCVUID=c.id);
    --45 Chánh án,74 Phó Chánh án,436 Quyền Chánh án,446 Phó Chánh án phụ trách
     OPEN curReturn FOR 
        Select t.ID,t.MA,t.TEN,t.MA_TEN,
              ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || t.MA_TEN) as arrTEN,
              case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi
        from DM_TOAAN t
        Where --t.HIEULUC=1 
         t.CAPCHAID= V_DONVIID
    --    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
    --                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
    --                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
    --                           )
        Order by t.ARRTHUTU;

    END DM_TOAAN_DIABAN;

    PROCEDURE PCA_AND_DIABAN
    ( 
        V_DONVIID in VARCHAR2,
        vCanboID  in VARCHAR2,
        vToaanID  in VARCHAR2,
        curReturn    OUT       sys_refcursor
    )
    IS 
        V_COUNT_CB NUMBER;
    BEGIN

     OPEN curReturn FOR 
        Select ROW_NUMBER() OVER(ORDER BY t.TEN) AS TT,t.ID,t.MA,t.TEN,t.MA_TEN,
              ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || t.MA_TEN) as arrTEN,
              case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TenDonVi,
              c.PCAID,t.ID TOAANID, to_char(c.NGAYPHANCONG,'dd/MM/yyyy') NGAYPHANCONG
        from DM_TOAAN t
        left join (select PCAID, DONVIID, TOAANID,NGAYPHANCONG from STPT_PCA_DIABAN
                     WHERE NVL(DONVIID,0)>0 and DONVIID=V_DONVIID
                    ) c on c.TOAANID = t.ID
        Where --t.HIEULUC=1 
             t.CAPCHAID= V_DONVIID
            And (vCanboID = 0 or c.PCAID = vCanboID)
            And (vToaanID = 0 or t.id = vToaanID)
    --    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
    --                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
    --                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
    --                           )
        Order by t.TEN;
    ---STPT_PCA_DIABAN_SEQ
    END PCA_AND_DIABAN;

PROCEDURE PCA_AND_DIABAN_IN_UP
        ( 
            V_DONVIID in NUMBER,
            vCurrCanboID  in NUMBER,
            vOLDCanboID  in NUMBER,
            vToaanID  in NUMBER,
            vNGAYPC    in DATE
        )
    IS 
            V_COUNT_CB NUMBER;
    BEGIN
        if vOLDCanboID = 0 and vCurrCanboID > 0 and  vToaanID > 0 then --insert
            INSERT INTO STPT_PCA_DIABAN 
                        (ID,PCAID, DONVIID, TOAANID,NGAYPHANCONG) 
                 VALUES (STPT_PCA_DIABAN_SEQ.NEXTVAL,vCurrCanboID,V_DONVIID,vToaanID,vNGAYPC);
        else  
            --update
            if vOLDCanboID > 0 and vCurrCanboID = 0  and vToaanID > 0 then -- Xoa cau hinh
                Delete from STPT_PCA_DIABAN 
                     where DONVIID = V_DONVIID 
                        AND PCAID = vOLDCanboID
                        AND TOAANID = vToaanID;
            elsif  vOLDCanboID > 0 and vCurrCanboID > 0  and vToaanID > 0 then
                UPDATE STPT_PCA_DIABAN 
                    SET PCAID = vCurrCanboID,
                        NGAYPHANCONG = vNGAYPC
                    where DONVIID = V_DONVIID 
                        AND PCAID = vOLDCanboID
                        AND TOAANID = vToaanID;  
            end if;
        end if;

        ---STPT_PCA_DIABAN_SEQ
    END PCA_AND_DIABAN_IN_UP;

 PROCEDURE GETBY_TAMGIAM_10NGAY
( 
    V_LOAITOA in VARCHAR2,
    V_DONVIID in VARCHAR2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn    OUT       sys_refcursor
)
IS 
    TotalItem number; MinIndex	number;MaxIndex	number;
    V_TABLE T_LENH_TAMGIAM;
BEGIN
    V_TABLE := T_LENH_TAMGIAM();
   ----------------------------------------------
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
     -------------------   
      FOR item IN (
                SELECT BC.HOTEN,to_char(NC.NGAYBATDAU,'dd/MM/yyyy')NGAYBATDAU,to_char(NC.NGAYKETTHUC,'dd/MM/yyyy')NGAYKETTHUC,
                VA.MAVUAN,VA.TENVUAN,'SƠ THẨM'CAPXX,TA.MA_TEN TOAAN_TEN,translate(b.TEN using char_cs)CHUCNANG 
                FROM AHS_BICANBICAO BC 
                LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN NC ON BC.ID=NC.BICANID
                LEFT JOIN (--biện pháp ngăn chặn
                          select it.ID, it.Ten from DM_DataItem it  where it.GroupID in(select g.id from DM_DataGroup g where g.Ma like 'BIENPHAPNGANCHAN')
                         )b on b.id=NC.BienPhapNganChanID
                LEFT JOIN AHS_VUAN VA ON VA.ID=BC.VUANID
                LEFT JOIN AHS_VUAN_GIAIDOAN GD ON GD.VUANID=VA.ID AND GD.MAGIAIDOAN=2
                LEFT JOIN DM_TOAAN TA ON TA.ID=GD.TOAANID
                WHERE(  (VA.TOAANID= V_DONVIID AND V_LOAITOA!='CAPCAO')
                     OR (V_LOAITOA='CAPCAO' AND EXISTS(SELECT 'X' FROM AHS_CHUYEN_NHAN_AN WHERE VUANID=VA.ID AND TOANHANID=V_DONVIID) 
                                            AND NOT EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN  WHERE BICANID=BC.ID)  
                       )
                )
                AND(ROUND(NC.NGAYKETTHUC-SYSDATE)<=5  AND SYSDATE<NC.NGAYKETTHUC)
                AND NC.BIENPHAPNGANCHANID IN (138,140)
                AND TO_DATE(to_char(NC.NGAYKETTHUC,'dd/MM/yyyy'),'dd/MM/yyyy') !=TO_DATE('01/01/0001','dd/MM/yyyy')
            )
      LOOP
         V_TABLE.extend;
         V_TABLE(V_TABLE.count) := R_LENH_TAMGIAM(
         item.HOTEN,item.NGAYBATDAU,item.NGAYKETTHUC,
         item.MAVUAN,item.TENVUAN,item.CAPXX,item.TOAAN_TEN,item.CHUCNANG);  
      END LOOP;
      ------------------------
       FOR item IN (
            SELECT  BC.HOTEN,to_char(ST.HIEULUCTU,'dd/MM/yyyy')NGAYBATDAU,to_char(ST.HIEULUCDEN,'dd/MM/yyyy')NGAYKETTHUC,
            VA.MAVUAN,VA.TENVUAN,'SƠ THẨM'CAPXX ,TA.MA_TEN TOAAN_TEN,translate(d.TEN using char_cs) CHUCNANG
            FROM AHS_BICANBICAO BC 
            LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN ST ON ST.BICANID=BC.ID
            LEFT JOIN DM_QD_QUYETDINH d on d.ID=ST.QUYETDINHID
            LEFT JOIN AHS_VUAN VA ON VA.ID=BC.VUANID
            LEFT JOIN AHS_VUAN_GIAIDOAN GD ON GD.VUANID=VA.ID AND GD.MAGIAIDOAN=2
            LEFT JOIN DM_TOAAN TA ON TA.ID=GD.TOAANID
            WHERE (  (VA.TOAANID= V_DONVIID AND V_LOAITOA!='CAPCAO')
                  OR (  V_LOAITOA='CAPCAO' AND EXISTS(SELECT 'X' FROM AHS_CHUYEN_NHAN_AN WHERE VUANID=VA.ID AND TOANHANID=V_DONVIID)
                                           AND NOT EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN  WHERE BICANID=BC.ID)
                     )
                  )
            AND ROUND(ST.HIEULUCDEN-SYSDATE)<=5 AND SYSDATE<ST.HIEULUCDEN
            AND ST.LOAIQDID=121 
            AND TO_DATE(TO_CHAR(ST.HIEULUCDEN,'dd/MM/yyyy'),'dd/MM/yyyy') !=TO_DATE('01/01/0001','dd/MM/yyyy')
            )
      LOOP
         V_TABLE.extend;
         V_TABLE(V_TABLE.count) := R_LENH_TAMGIAM(
         item.HOTEN,item.NGAYBATDAU,item.NGAYKETTHUC,
         item.MAVUAN,item.TENVUAN,item.CAPXX,item.TOAAN_TEN,item.CHUCNANG);  
      END LOOP;
      -----------------
       FOR item IN (
            SELECT  BC.HOTEN,to_char(PT.HIEULUCTU,'dd/MM/yyyy')NGAYBATDAU,to_char(PT.HIEULUCDEN,'dd/MM/yyyy')NGAYKETTHUC,
            VA.MAVUAN,VA.TENVUAN,'PHÚC THẨM'CAPXX,TA.MA_TEN TOAAN_TEN,translate(d.TEN using char_cs) CHUCNANG
            FROM AHS_BICANBICAO BC 
            LEFT JOIN AHS_PHUCTHAM_QUYETDINH_BICAN PT ON PT.BICANID=BC.ID
            LEFT JOIN DM_QD_QUYETDINH d on d.ID=PT.QUYETDINHID
            LEFT JOIN AHS_VUAN VA ON VA.ID=BC.VUANID
            LEFT JOIN AHS_VUAN_GIAIDOAN GD ON GD.VUANID=VA.ID AND GD.MAGIAIDOAN=3
            LEFT JOIN DM_TOAAN TA ON TA.ID=GD.TOAPHUCTHAMID
            WHERE VA.TOAPHUCTHAMID=V_DONVIID
            AND ROUND(PT.HIEULUCDEN-SYSDATE)<=5 AND SYSDATE<PT.HIEULUCDEN
            AND PT.LOAIQDID=121 
            AND TO_DATE(TO_CHAR(PT.HIEULUCDEN,'dd/MM/yyyy'),'dd/MM/yyyy') !=TO_DATE('01/01/0001','dd/MM/yyyy')
            )
      LOOP
         V_TABLE.extend;
         V_TABLE(V_TABLE.count) := R_LENH_TAMGIAM(
         item.HOTEN,item.NGAYBATDAU,item.NGAYKETTHUC,
         item.MAVUAN,item.TENVUAN,item.CAPXX,item.TOAAN_TEN,item.CHUCNANG);  
      END LOOP;
  -------------------              
 OPEN curReturn FOR 
 SELECT c.* FROM (
       select ROW_NUMBER() OVER (ORDER BY TO_DATE(a.NGAYKETTHUC,'dd/MM/yyyy'),a.MAVUAN) STT,COUNT(*) OVER () as CountAll,a.* from (
             SELECT PA.* FROM TABLE(V_TABLE)PA
            )a
        )c where c.STT>=MinIndex and c.STT<=MaxIndex; 
 END GETBY_TAMGIAM_10NGAY; 


 PROCEDURE Get_VUAN_by_VUANID_NGUOITAO
    ( 
        vVuAnID in number,
        vNguoiTao  in NVARCHAR2,
        curReturn    OUT       sys_refcursor
    )
    IS 
    BEGIN
     OPEN curReturn FOR 
        Select  count(*)
            from AHS_VUAN v
                Where v.ID = vVuAnID ;
                    --And v.nguoitao = vNguoiTao;          
    END Get_VUAN_by_VUANID_NGUOITAO;
PROCEDURE  ADS_FILE_GETBYDON
(
  vLoaiAn in number,
  vMaGiaiDoan number,
  vDonID number,
  curReturn    OUT       sys_refcursor
)
IS 
BEGIN

If  vLoaiAn=1 Then
  OPEN curReturn FOR   Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  
  From DM_BIEUMAU b inner join (Select DISTINCT BIEUMAUID from AHS_FILE where VUANID=vDonID) f on f.BIEUMAUID=b.ID
  Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHS=1 
      AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
           OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
          )
  Order by b.THUTU;
ElsIF vLoaiAn=2 Then
  OPEN curReturn FOR  
   SELECT bb.* from (
      Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b
      inner join (Select DISTINCT BIEUMAUID from ADS_FILE where DONID=vDonID) f on f.BIEUMAUID=b.ID
      Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISADS=1 
      AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
           OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
          )
      UNION Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
          where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISADS=1 
          AND ((vMaGiaiDoan=1 and b.ISHOSO=1) OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
               OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
               ) 
      )bb Order by bb.THUTU;       
ElsIF vLoaiAn=3 Then
    OPEN curReturn FOR   
     SELECT bb.* from (
           Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU 
           From DM_BIEUMAU b inner join (Select DISTINCT BIEUMAUID from AHN_FILE where DONID=vDonID) f on f.BIEUMAUID=b.ID
           Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHN=1 
             AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
                   OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                  )
          UNION Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
              where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHN=1 
               AND ((vMaGiaiDoan=1 and b.ISHOSO=1) OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
                           OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                           ) 
       )bb Order by bb.THUTU;    
ElsIF vLoaiAn=4 Then
    OPEN curReturn FOR  
     SELECT bb.* from (
     Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU 
      From DM_BIEUMAU b inner join (Select DISTINCT BIEUMAUID from AKT_FILE where DONID=vDonID) f on f.BIEUMAUID=b.ID
      Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISAKT=1 
      AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
           OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
          )
     UNION Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
      where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAKT=1 
           AND ((vMaGiaiDoan=1 and b.ISHOSO=1) OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
                   OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                   )
        )bb Order by bb.THUTU;    
ElsIF vLoaiAn=5 Then
    OPEN curReturn FOR  
     SELECT bb.* from (
      Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU 
      From DM_BIEUMAU b inner join (Select DISTINCT BIEUMAUID from ALD_FILE where DONID=vDonID) f on f.BIEUMAUID=b.ID
      Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISALD=1 
     AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
           OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
          )
   UNION Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
      where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISALD=1 
          AND ((vMaGiaiDoan=1 and b.ISHOSO=1) OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
                   OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                   ) 
      )bb Order by bb.THUTU;    
ElsIF vLoaiAn=6 Then
    OPEN curReturn FOR 
     SELECT bb.* from (
      Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU 
      From DM_BIEUMAU b inner join (Select DISTINCT BIEUMAUID from AHC_FILE where DONID=vDonID) f on f.BIEUMAUID=b.ID
      Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHC=1 
      AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
           OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
          )
  UNION Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
      where b.ISLUONHIENTHI=1 and 
      b.ISPRINT=1 and b.ACTIVE=1 and b.ISAHC=1 
           AND ((vMaGiaiDoan=1 and b.ISHOSO=1) OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
                   OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                   ) 
      )bb Order by bb.THUTU;    
ElsIF vLoaiAn=7 Then
    OPEN curReturn FOR  
        SELECT bb.* from (
        Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU 
        From DM_BIEUMAU b inner join (Select DISTINCT BIEUMAUID from APS_FILE where DONID=vDonID) f on f.BIEUMAUID=b.ID
        Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISAPS=1 
         AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
               OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
              )
    UNION Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
      where b.ISLUONHIENTHI=1 and b.ISPRINT=1 and b.ACTIVE=1 and b.ISAPS=1 
          AND ((vMaGiaiDoan=1 and b.ISHOSO=1) OR(vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
                   OR(vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
                   )
        )bb Order by bb.THUTU;    
ElsIF vLoaiAn=8 Then
  OPEN curReturn FOR   Select b.ID,b.MABM,b.DUONGDAN,b.TENBM,b.THUTU  From DM_BIEUMAU b 
  Where b.ISPRINT=1 and b.ACTIVE=1 and b.ISXLHC=1     
  AND ( (vMaGiaiDoan=1 and b.ISHOSO=1) OR (vMaGiaiDoan=2 and (b.ISHOSO=1 Or b.ISSOTHAM=1)) 
           OR (vMaGiaiDoan=3 and b.ISPHUCTHAM=1) OR (vMaGiaiDoan=4 and b.ISGDTTT=1)
          )
  Order by b.THUTU;    
End if;
END ADS_FILE_GETBYDON;
END PKG_STPT;
