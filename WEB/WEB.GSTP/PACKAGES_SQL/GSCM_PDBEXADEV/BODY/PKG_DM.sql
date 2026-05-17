--------------------------------------------------------
--  DDL for Package Body PKG_DM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_DM" 
AS
-- Package body
PROCEDURE DM_CANBO_GETBYDONVI_V2
( donviID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,to_char(c.NGAYSINH,'dd/MM/yyyy') NGAYSINH,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || decode(d1.TEN, null, '', ' - ' || d1.TEN) || decode(d2.TEN, null, '', ' - ' || d2.TEN)) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     left join DM_DATAITEM d1  on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere 1=(case when donviID=0 then 1 when c.TOAANID=donviID then 1 Else 0 End)
      And c.HIEULUC=1 And 
--      c.Chucdanhid !=35 -- 35 la Hoi tham nhan dan

      c.CHUCDANHID IN ( 36,1417,  --thư ký
      					488, --thư ký Toà án 
      					81,47,48,59,383,487,507,2562,2563,1465,1466,1467,1503,1499,2002,2182,2722,2721,2723,2724, --các chức danh Thẩm phán
                        2338,2319,2318, --Thẩm phán các bậc
      					473,474,384,1983, --các chức danh Thẩm tra viên
      					490, --Chuyên viên
						492, --Chuyên viên chính
						475, --Nhân viên văn thư 
						485  --Thư ký Toà án không có ĐHL
      					)


      UNION
    Select c.ID,c.MACANBO,c.Hoten || ' (Biệt phái)',to_char(c.NGAYSINH,'dd/MM/yyyy') NGAYSINH,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || decode(d1.TEN, null, '', ' - ' || d1.TEN) || decode(d2.TEN, null, '', ' - ' || d2.TEN) || ' (Biệt phái)') as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
    From  DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join DM_CANBO_BIETPHAI b on c.ID=b.CANBOID
     left join DM_DATAITEM d1  on (b.CHUCDANH IS NOT NULL AND d1.ID=b.CHUCDANH)  OR (b.CHUCDANH IS NULL AND d1.ID=c.CHUCDANHID)
     left join DM_DATAITEM d2  on (b.CHUCVU IS NOT NULL AND d2.ID=b.CHUCVU)  OR (b.CHUCVU IS NULL AND d2.ID=c.CHUCVUID)
    WHere b.toaanid=donviID And
--    AND b.chucdanh !=35 
     c.CHUCDANHID IN ( 36,1417,   --thư ký
      					488, --thư ký Toà án 
      					81,47,48,59,383,487,507,2562,2563,1465,1466,1467,1503,1499,2002,2182,2722,2721,2723,2724, --các chức danh Thẩm phán
                        2338,2319,2318, --Thẩm phán các bậc
      					473,474,384,1983, --các chức danh Thẩm tra viên
      					490, --Chuyên viên
						492, --Chuyên viên chính
						475, --Nhân viên văn thư 
						485  --Thư ký Toà án không có ĐHL
      					)


    And c.HIEULUC=1 and TO_CHAR(b.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') 
    and (TO_CHAR(b.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or b.denngay is null)
    Order by HOTEN;
END DM_CANBO_GETBYDONVI_V2;

END PKG_DM;

/
