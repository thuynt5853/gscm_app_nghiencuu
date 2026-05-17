--------------------------------------------------------
--  DDL for Package Body PKG_HOSO_PT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_HOSO_PT" AS
PROCEDURE GETBY_COUNT_VKS
( 
    V_DONVIID in VARCHAR2,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN 
  open CurReturn for
  SELECT COUNT(*)CountAll FROM HOSO_PT HS 
  WHERE HS.LOAI_DV=2 AND HS.LOAI_CN=1 AND HS.TOAANID=29
      AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID
      AND HP.LOAI_DV=2 AND HP.LOAI_CN=2);--LOAI_CN =2 nhận hồ sơ
END GETBY_COUNT_VKS; 
PROCEDURE DELETE_HOSO_PT_ID
(    
  V_LOAIAN  IN NUMBER,
  V_ID	IN	NUMBER  
)
AS   
BEGIN  
        DELETE HOSO_PT HS WHERE HS.ID=V_ID AND HS.LOAIAN=LOAIAN;      
END;
PROCEDURE  HOSO_PT_LIST_ID
( 
  V_LOAIAN  IN NUMBER,
  V_ID IN VARCHAR2,
  curReturn OUT sys_refcursor
)
IS  
BEGIN
OPEN curReturn FOR
   SELECT HS.* FROM HOSO_PT HS WHERE HS.ID=V_ID AND HS.LOAIAN=LOAIAN;
END HOSO_PT_LIST_ID;
PROCEDURE   HOSO_PT_LIST 
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    PageIndex	in	int, 
    PageSize	in	int,
    CurReturn OUT sys_refcursor
) 
AS  
  TotalItem number;MinIndex	number;MaxIndex	number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

    open CurReturn for
      SELECT   A.* FROM (SELECT  ROW_NUMBER() OVER (ORDER BY a.LOAI_CN ASC, A.NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL,                   
               A.ID,b.HOTEN|| '-' || e.TEN TENCANBO,
               decode(a.LOAI_CN,1,'Chuyển hồ sơ đến',2,'Nhận hồ sơ từ')LOAI_CN,
               decode(A.LOAI_DV,1,TA.TEN,2,VK.TEN) DV_GUI_NHAN,
               A.GHICHU,to_char(a.NGAY_NC,'dd/MM/yyyy HH24:MI:SS')NGAY_NC
             FROM HOSO_PT A   
                LEFT JOIN DM_TOAAN TA ON TA.ID=A.DV_GUI_NHAN AND A.LOAI_DV=1
                LEFT JOIN DM_VKS VK ON VK.ID=A.DV_GUI_NHAN AND A.LOAI_DV=2
                LEFT JOIN DM_CANBO B ON A.CANBOID = B.ID
                left join (select c.ID,c.TEN,c.MA from DM_DATAITEM c where c.GROUPID=12) e on e.ID=b.CHUCDANHID
                left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=b.CHUCVUID
             WHERE A.VUANID =V_VUANID AND A.LOAIAN=LOAIAN      
      ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END HOSO_PT_LIST;
PROCEDURE  HOSO_PT_INS_UP
( 
    V_ID IN NUMBER,
    V_LOAIAN IN NUMBER,
    V_VUANID IN NUMBER,
    V_LOAI_CN IN NUMBER,
    V_CANBOID IN NUMBER,
    V_NGAY_NC  in DATE,
    V_DV_GUI_NHAN IN NUMBER,
    V_NGUOI_NHAN_VKS IN VARCHAR2,
    V_GHICHU IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_LOAI_DV IN NUMBER,
    V_TOAANID IN NUMBER
)
IS 
BEGIN
  if(V_VUANID != 0) THEN
     IF v_ID=0 THEN
       INSERT INTO HOSO_PT
         (ID,LOAIAN,VUANID,LOAI_CN,CANBOID,NGAY_NC,DV_GUI_NHAN,NGUOI_NHAN_VKS,GHICHU,NGUOITAO,LOAI_DV,TOAANID,NGAYTAO,NGUOISUA,NGAYSUA)
        VALUES (HOSO_PT_SEQ.NEXTVAL,V_LOAIAN,V_VUANID,V_LOAI_CN,V_CANBOID,V_NGAY_NC,V_DV_GUI_NHAN,V_NGUOI_NHAN_VKS,V_GHICHU,V_NGUOITAO,V_LOAI_DV,V_TOAANID,SYSDATE,V_NGUOITAO,SYSDATE);
     ELSE 
          UPDATE HOSO_PT
            SET    
                LOAI_CN=V_LOAI_CN,
                CANBOID=V_CANBOID,
                NGAY_NC=V_NGAY_NC, 
                DV_GUI_NHAN=V_DV_GUI_NHAN,
                NGUOI_NHAN_VKS=V_NGUOI_NHAN_VKS,
                GHICHU=V_GHICHU,
                NGUOISUA=V_NGUOITAO,
                LOAI_DV=V_LOAI_DV,
                NGAYSUA=SYSDATE
            WHERE ID=V_ID;
     END IF;   
  END IF;
END;
PROCEDURE  DM_CANBO_QLHS_PT
(
  vDonViID in VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
    open CurReturn for
       select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN as MA_TEN,d.TEN as ChucVu,B.MA CHUCDANH,
        a.HOTEN|| '-' || b.TEN|| DECODE(d.TEN,NULL,NULL,'-'||d.TEN) ||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS
        from DM_CANBO a
          inner join (select c.ID,c.TEN,c.MA from DM_DATAITEM c where c.GROUPID=12) b on b.ID=a.CHUCDANHID
          left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=a.CHUCVUID
        where a.TOAANID=vDonViID And a.HIEULUC=1 
        AND B.MA NOT IN('TP','TPSC','TPTC','TPCC','TPTATC','HTND') AND UPPER(B.MA) NOT LIKE ('C0%')
        Order by a.HOTEN;
END DM_CANBO_QLHS_PT;
PROCEDURE   HOSO_PT_LIST_EXORT
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    CurReturn OUT sys_refcursor
) 
AS   
BEGIN	
    open CurReturn for
       SELECT NULL TEXT_REPORT FROM DUAL;

END HOSO_PT_LIST_EXORT;
END PKG_HOSO_PT;
