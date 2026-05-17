--------------------------------------------------------
--  DDL for Package Body PKG_STPT_QLCS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_QLCS" AS
PROCEDURE QLA_ST_PT_CheckSoQD
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSoQD in varchar2,
  vLoaiQD in  varchar2,
	curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
-----DS--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
--Số QĐ thuận tình ly hôn (41:40-DS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_SOTHAM_QUYETDINH t 
          Where t.TOAANID=vdonviID and t.SoQD = vSoQD
            and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))
                 or (vLoaiQD in (147) and QuyetdinhID in (147))
                 );
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_PHUCTHAM_QUYETDINH t
          Where t.TOAANID=vdonviID and t.SoQD = vSoQD
            and t.NGAYQD between vFromDate and vToDate
            and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                 or (vLoaiQD in (145,146) and QuyetdinhID in (145,146)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );
-----HS--------
--Số QĐ đình chỉ (77:39-HS và 78:40-HS);
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (79:36-HS và 80:37-HS; 128:38-HS)
---------------------------QuyetdinhID
     elsif vLoaiAn='AHS' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_SOTHAM_QUYETDINH_VUAn t inner join AHS_VUAN d on d.ID=t.VUANID
            Where d.TOAANID=vdonviID and t.SoQuyetDinh =vSoQD
              and t.NGAYQD between vFromDate and vToDate
              and ((vLoaiQD in (77,78) and QuyetdinhID in (77,78))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (79,80,128) and QuyetdinhID in (79,80,128))
                 or (vLoaiQD in (206) and QuyetdinhID in (206))
                 );
     elsif vLoaiAn='AHS_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_PHUCTHAM_QUYETDINH_VuAn t 
            Where t.DONVIID=vdonviID and t.SoQuyetDinh = vSoQD
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (127,203) and QuyetdinhID in (127,203))
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 or (vLoaiQD in (206) and QuyetdinhID in (206))
                 );
-----HNGD--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
--Số QĐ thuận tình ly hôn (41:40-DS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_SOTHAM_QUYETDINH t 
          Where t.TOAANID=vdonviID and t.SoQD = vSoQD
            and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))
                 or (vLoaiQD in (147) and QuyetdinhID in (147))
                 );
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_PHUCTHAM_QUYETDINH t 
          Where t.TOAANID=vdonviID and t.SoQD = vSoQD
            and t.NGayQD between vFromDate and vToDate
             and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                 or (vLoaiQD in (145,146) and QuyetdinhID in (145,146)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );
-----HC--------
--Số QĐ đình chỉ (102:14-HC và 103:15-HC); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (104:10-HC và 105:11-HC)
---------------------------QuyetdinhID
     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHC_SOTHAM_QUYETDINH t 
          Where t.TOAANID=vdonviID and t.SoQD = vSoQD
            and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (101) and QuyetdinhID in (101))
                 or (vLoaiQD in (102,103) and QuyetdinhID in (102,103))
                 or (vLoaiQD in (104,105) and QuyetdinhID in (104,105))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 );
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHC_PHUCTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (106,107) and QuyetdinhID in (106,107))
                 or (vLoaiQD in (108,109) and QuyetdinhID in (108,109))
                 or (vLoaiQD in (110) and QuyetdinhID in (110)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );
-----LD--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS);  
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_SOTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))
                 or (vLoaiQD in (147) and QuyetdinhID in (147))
                 );
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_PHUCTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
               and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                 or (vLoaiQD in (145,146) and QuyetdinhID in (145,146)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );
-----KDTM--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS);  
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_SOTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))
                 or (vLoaiQD in (147) and QuyetdinhID in (147))
                 );
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_PHUCTHAM_QUYETDINH t
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
               and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                 or (vLoaiQD in (145,146) and QuyetdinhID in (145,146)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );
-----PS--------
--Số QĐ đình chỉ (125:03-PS và 126:04-PS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
---------------------------QuyetdinhID
      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_SOTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))
                 or (vLoaiQD in (147) and QuyetdinhID in (147))
                 );
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_PHUCTHAM_QUYETDINH t
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
               and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                 or (vLoaiQD in (145,146) and QuyetdinhID in (145,146)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );
-----XLHC--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
--Số QĐ thuận tình ly hôn (41:40-DS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
      elsif vLoaiAn='XLHC' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From XLHC_SOTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))
                 or (vLoaiQD in (147) and QuyetdinhID in (147))
                 );
     elsif vLoaiAn='XLHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From XLHC_PHUCTHAM_QUYETDINH t 
            Where t.TOAANID=vdonviID and t.SoQD = vSoQD
              and t.NGayQD between vFromDate and vToDate
               and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                 or (vLoaiQD in (145,146) and QuyetdinhID in (145,146)) 
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 );   
  end if;  
END QLA_ST_PT_CheckSoQD;

--PROCEDURE QLA_ST_PT_GetSoQDnew
--( vLoaiAn in varchar2,
--  vdonviID in number,
--  vFromDate in DATE,
--  vToDate in DATE,
--  vLoaiQD in  varchar2,
--	curReturn    OUT       sys_refcursor
--)
--IS
--  vReturnID number;
--BEGIN  
-------DS--------
----Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
----Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
----Số QĐ thuận tình ly hôn (41:40-DS); 
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
-----------------------------QuyetdinhID
--    if vLoaiAn='ADS' then 
--      OPEN curReturn FOR  
--          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--          From ADS_SOTHAM_QUYETDINH t 
--          inner join ADS_DON d on d.ID=t.DONID
--              Where d.TOAANID=vdonviID 
--                and t.NGayQD between vFromDate and vToDate
--                and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                     or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
--                     or (vLoaiQD in (41) and QuyetdinhID in (41))
--                     or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                     or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                     );
--    elsif vLoaiAn='ADS_PT' then 
--      OPEN curReturn FOR  
--          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--          From ADS_PHUCTHAM_QUYETDINH t 
--            inner join ADS_DON d on d.ID=t.DONID
--              Where d.TOAANID=vdonviID 
--                and t.NGAYQD between vFromDate and vToDate
--                and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
--                     or (vLoaiQD in (145,146) and QuyetdinhID in (145,146))
--                     );
-------HS_ST--------
----Số QĐ đình chỉ (77:39-HS và 78:40-HS);
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (79:36-HS và 80:37-HS; 128:38-HS)
-----------------------------QuyetdinhID
--     elsif vLoaiAn='AHS' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQuyetDinh,1,DECODE(INSTR(t.SoQuyetDinh, '/'),0,LENGTH(t.SoQuyetDinh),INSTR(t.SoQuyetDinh, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From AHS_SOTHAM_QUYETDINH_VUAn t inner join AHS_VUAN d on d.ID=t.VUANID
--            Where d.TOAANID=vdonviID 
--              and t.NGAYQD between vFromDate and vToDate
--              and ((vLoaiQD in (77,78) and QuyetdinhID in (77,78))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (79,80,128) and QuyetdinhID in (79,80,128)) 
--                 );
-----HS_PT------------
-----127:51-HS. Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Thẩm phán chủ tọa phiên tòa)
-----203:52-HS. Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Hội đồng xét xử)
--     elsif vLoaiAn='AHS_PT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQuyetDinh,1,DECODE(INSTR(t.SoQuyetDinh, '/'),0,LENGTH(t.SoQuyetDinh),INSTR(t.SoQuyetDinh, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From AHS_PHUCTHAM_QUYETDINH_VuAn t inner join AHS_VUAN d on d.ID=t.VUANID
--            Where d.TOAANID=vdonviID 
--              and t.NGayQD between vFromDate and vToDate
--              and ((vLoaiQD in (127,203) and QuyetdinhID in (127,203))
--                 or (vLoaiQD in (61) and QuyetdinhID in (61))
--                 );
-------HNGD--------
----Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
----Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
----Số QĐ thuận tình ly hôn (41:40-DS); 
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
-----------------------------QuyetdinhID
--    elsif vLoaiAn='AHN' then 
--      OPEN curReturn FOR  
--          Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--          From AHN_SOTHAM_QUYETDINH t inner join AHN_DON d on d.ID=t.DONID
--          Where d.TOAANID=vdonviID 
--            and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
--                 or (vLoaiQD in (41) and QuyetdinhID in (41))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
--                 
--     elsif vLoaiAn='AHN_PT' then 
--      OPEN curReturn FOR  
--          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--          From AHN_PHUCTHAM_QUYETDINH t inner join AHN_DON d on d.ID=t.DONID
--          Where d.TOAANID=vdonviID
--            and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
--                 or (vLoaiQD in (41) and QuyetdinhID in (41))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
-------HC--------
---- Sơ Thẩm
----Số QĐ đình chỉ (102:14-HC và 103:15-HC); 
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (104:10-HC và 105:11-HC)
-----------------------------QuyetdinhID
--     elsif vLoaiAn='AHC' then 
--      OPEN curReturn FOR  
--          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--          From AHC_SOTHAM_QUYETDINH t inner join AHC_DON d on d.ID=t.DONID
--          Where d.TOAANID=vdonviID 
--            and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (102,103) and QuyetdinhID in (102,103))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (104,105) and QuyetdinhID in (104,105)) 
--                 );
----Phuc Tham
----Số QĐ đình chỉ (108:40-HC); 
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (106:38-HC và 107:39-HC)
--      elsif vLoaiAn='AHC_PT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From AHC_PHUCTHAM_QUYETDINH t inner join AHC_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID 
--              and t.NGayQD between vFromDate and vToDate
--              and ((vLoaiQD in (108) and QuyetdinhID in (108))
--                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
--                 or (vLoaiQD in (106,107) and QuyetdinhID in (106,107)) 
--                 );
-------LD--------
----Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
----Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS);  
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
-----------------------------QuyetdinhID
--      elsif vLoaiAn='ALD' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From ALD_SOTHAM_QUYETDINH t inner join ALD_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID 
--              and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
--      elsif vLoaiAn='ALD_PT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From ALD_PHUCTHAM_QUYETDINH t inner join ALD_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID 
--              and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
-------KDTM--------
----Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
----Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS);  
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
-----------------------------QuyetdinhID
--      elsif vLoaiAn='AKT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From AKT_SOTHAM_QUYETDINH t inner join AKT_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID
--              and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
--      elsif vLoaiAn='AKT_PT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From AKT_PHUCTHAM_QUYETDINH t inner join AKT_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID 
--              and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
-------PS--------
----Số QĐ đình chỉ (125:03-PS và 126:04-PS); 
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
-----------------------------QuyetdinhID
--      elsif vLoaiAn='APS' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From APS_SOTHAM_QUYETDINH t inner join APS_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID
--              and t.NGayQD between vFromDate and vToDate
--            and ((vLoaiQD in (125,126) and QuyetdinhID in (125,126))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                   or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) --toancau thêm QuyetdinhID 42,45
--                 );
--       elsif vLoaiAn='APS_PT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From APS_PHUCTHAM_QUYETDINH t inner join APS_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID
--              and t.NGayQD between vFromDate and vToDate
--              and ((vLoaiQD in (125,126) and QuyetdinhID in (125,126))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                   or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))  --toancau thêm QuyetdinhID 42,45
--                 );
-------XLHC--------
----Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
----Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
----Số QĐ thuận tình ly hôn (41:40-DS); 
----Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
----Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
-----------------------------QuyetdinhID
--      elsif vLoaiAn='XLHC' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From XLHC_SOTHAM_QUYETDINH t inner join XLHC_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID
--              and t.NGayQD between vFromDate and vToDate
--              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
--                 or (vLoaiQD in (41) and QuyetdinhID in (41))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );
--     elsif vLoaiAn='XLHC_PT' then 
--        OPEN curReturn FOR  
--            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
--                    into vReturnID
--            From XLHC_PHUCTHAM_QUYETDINH t inner join XLHC_DON d on d.ID=t.DONID
--            Where d.TOAANID=vdonviID
--              and t.NGayQD between vFromDate and vToDate
--              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
--                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
--                 or (vLoaiQD in (41) and QuyetdinhID in (41))
--                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
--                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
--                 );   
--  end if;  
--END QLA_ST_PT_GetSoQDnew;

PROCEDURE QLA_ST_PT_GetSoQDnew
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vLoaiQD in  varchar2,
	curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
-----DS--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
--Số QĐ thuận tình ly hôn (41:40-DS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From ADS_SOTHAM_QUYETDINH t 
          inner join ADS_DON d on d.ID=t.DONID
              Where d.TOAANID=vdonviID 
                and t.NGayQD between vFromDate and vToDate
                and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                     or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                     or (vLoaiQD in (41) and QuyetdinhID in (41))
                     or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                     or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                     );
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From ADS_PHUCTHAM_QUYETDINH t 
            inner join ADS_DON d on d.ID=t.DONID
              Where d.TOAANID=vdonviID 
                and t.NGAYQD between vFromDate and vToDate
                and ((vLoaiQD in (143,144) and QuyetdinhID in (143,144))
                     or (vLoaiQD in (145,146) and QuyetdinhID in (145,146))
                     );
-----HS_ST--------
--Số QĐ đình chỉ (77:39-HS và 78:40-HS);
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (79:36-HS và 80:37-HS; 128:38-HS)
---------------------------QuyetdinhID
     elsif vLoaiAn='AHS' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQuyetDinh,1,DECODE(INSTR(t.SoQuyetDinh, '/'),0,LENGTH(t.SoQuyetDinh),INSTR(t.SoQuyetDinh, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AHS_SOTHAM_QUYETDINH_VUAn t inner join AHS_VUAN d on d.ID=t.VUANID
            Where d.TOAANID=vdonviID 
              and t.NGAYQD between vFromDate and vToDate
              and ((vLoaiQD in (77,78) and QuyetdinhID in (77,78))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (79,80,128) and QuyetdinhID in (79,80,128)) 
                 );
---HS_PT------------
---127:51-HS. Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Thẩm phán chủ tọa phiên tòa)
---203:52-HS. Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Hội đồng xét xử)
     elsif vLoaiAn='AHS_PT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQuyetDinh,1,DECODE(INSTR(t.SoQuyetDinh, '/'),0,LENGTH(t.SoQuyetDinh),INSTR(t.SoQuyetDinh, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AHS_PHUCTHAM_QUYETDINH_VuAn t inner join AHS_VUAN d on d.ID=t.VUANID
            Where d.TOAANID=vdonviID 
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (127,203) and QuyetdinhID in (127,203))
                 or (vLoaiQD in (61) and QuyetdinhID in (61))
                 );
-----HNGD--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
--Số QĐ thuận tình ly hôn (41:40-DS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From AHN_SOTHAM_QUYETDINH t inner join AHN_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID 
            and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
                 
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From AHN_PHUCTHAM_QUYETDINH t inner join AHN_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID
            and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
-----HC--------
-- Sơ Thẩm
--Số QĐ đình chỉ (102:14-HC và 103:15-HC); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (104:10-HC và 105:11-HC)
---------------------------QuyetdinhID
     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From AHC_SOTHAM_QUYETDINH t inner join AHC_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID 
            and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (102,103) and QuyetdinhID in (102,103))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (104,105) and QuyetdinhID in (104,105)) 
                 );
--Phuc Tham
--Số QĐ đình chỉ (108:40-HC); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (106:38-HC và 107:39-HC)
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AHC_PHUCTHAM_QUYETDINH t inner join AHC_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID 
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (108) and QuyetdinhID in (108))
                 or (vLoaiQD in (61) and QuyetdinhID in (61)) 
                 or (vLoaiQD in (106,107) and QuyetdinhID in (106,107)) 
                 );
-----LD--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS);  
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From ALD_SOTHAM_QUYETDINH t inner join ALD_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID 
              and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From ALD_PHUCTHAM_QUYETDINH t inner join ALD_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID 
              and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
-----KDTM--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS);  
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AKT_SOTHAM_QUYETDINH t inner join AKT_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID
              and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AKT_PHUCTHAM_QUYETDINH t inner join AKT_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID 
              and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
-----PS--------
--Số QĐ đình chỉ (125:03-PS và 126:04-PS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
---------------------------QuyetdinhID
      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From APS_SOTHAM_QUYETDINH t inner join APS_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID
              and t.NGayQD between vFromDate and vToDate
            and ((vLoaiQD in (125,126) and QuyetdinhID in (125,126))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                   or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) --toancau thêm QuyetdinhID 42,45
                 );
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From APS_PHUCTHAM_QUYETDINH t inner join APS_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (125,126) and QuyetdinhID in (125,126))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                   or (vLoaiQD in (42,45) and QuyetdinhID in (42,45))  --toancau thêm QuyetdinhID 42,45
                 );
-----XLHC--------
--Số QĐ đình chỉ (62:45-DS và 63:46-DS); 
--Số QĐ công nhận thoả thuận (67:38-DS và 68:39-DS); 
--Số QĐ thuận tình ly hôn (41:40-DS); 
--Số QĐ chuyển hồ sơ vụ án (4: Quyết định chuyển vụ án vì không thuộc thẩm quyền và 61: Quyết định chuyển vụ án để xem xét GĐT,TT ); 
--Số QĐ tạm đình chỉ (42:41-DS và 45:45-DS)
---------------------------QuyetdinhID
      elsif vLoaiAn='XLHC' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From XLHC_SOTHAM_QUYETDINH t inner join XLHC_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );
     elsif vLoaiAn='XLHC_PT' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SoQD,1,DECODE(INSTR(t.SoQD, '/'),0,LENGTH(t.SoQD),INSTR(t.SoQD, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From XLHC_PHUCTHAM_QUYETDINH t inner join XLHC_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID
              and t.NGayQD between vFromDate and vToDate
              and ((vLoaiQD in (62,63) and QuyetdinhID in (62,63))
                 or (vLoaiQD in (67,68) and QuyetdinhID in (67,68)) 
                 or (vLoaiQD in (41) and QuyetdinhID in (41))
                 or (vLoaiQD in (4,61) and QuyetdinhID in (4,61)) 
                 or (vLoaiQD in (42,45) and QuyetdinhID in (42,45)) 
                 );   
  end if;  
END QLA_ST_PT_GetSoQDnew;

PROCEDURE QLA_ST_PT_CheckSoBA
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSoBA in nvarchar2,
	curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_SOTHAM_BANAN t inner join ADS_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
            and t.NgayTuyenAn between vFromDate and vToDate;
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_PHUCTHAM_BANAN t inner join ADS_DON d on d.ID=t.DONID
          Where d.TOAPHUCTHAMID=vdonviID and t.SOBANAN = vSoBA
            and t.NgayTuyenAn between vFromDate and vToDate;

     elsif vLoaiAn='AHS' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_SOTHAM_BANAN t inner join AHS_VUAN d on d.ID=t.VUANID
            Where d.TOAANID=vdonviID and t.SoBanAn =vSoBA
              and t.NgayBanAn between vFromDate and vToDate;
     elsif vLoaiAn='AHS_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_PHUCTHAM_BANAN t inner join AHS_VUAN d on d.ID=t.VUANID
            Where d.TOAPHUCTHAMID=vdonviID and t.SoBanAn = vSoBA
              and t.NgayBanAn between vFromDate and vToDate;

    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_SOTHAM_BANAN t inner join AHN_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
            and t.NgayTuyenAn between vFromDate and vToDate;
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_PHUCTHAM_BANAN t inner join AHN_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
            and t.NgayTuyenAn between vFromDate and vToDate;

     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHC_SOTHAM_BANAN t inner join AHC_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
            and t.NgayTuyenAn between vFromDate and vToDate;
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHC_PHUCTHAM_BANAN t inner join AHC_DON d on d.ID=t.DONID
            Where d.TOAPHUCTHAMID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_SOTHAM_BANAN t inner join ALD_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_PHUCTHAM_BANAN t inner join ALD_DON d on d.ID=t.DONID
            Where d.TOAPHUCTHAMID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_SOTHAM_BANAN t inner join AKT_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_PHUCTHAM_BANAN t inner join AKT_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_SOTHAM_BANAN t inner join APS_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_PHUCTHAM_BANAN t inner join APS_DON d on d.ID=t.DONID
            Where d.TOAPHUCTHAMID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='XLHC' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From XLHC_SOTHAM_BANAN t inner join XLHC_DON d on d.ID=t.DONID
            Where d.TOAANID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;
     elsif vLoaiAn='XLHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From XLHC_PHUCTHAM_BANAN t inner join XLHC_DON d on d.ID=t.DONID
            Where d.TOAPHUCTHAMID=vdonviID and t.SOBANAN = vSoBA
              and t.NgayTuyenAn between vFromDate and vToDate;   
  end if;      
END QLA_ST_PT_CheckSoBA;

PROCEDURE QLA_ST_PT_GETSoBA_NEW
(   vLoaiAn in varchar2,
    vdonviID in number,
    vFromDate in DATE,
    vToDate in DATE,
    curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From ADS_SOTHAM_BANAN t
          Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From ADS_PHUCTHAM_BANAN t
          Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;

     elsif vLoaiAn='AHS' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AHS_SOTHAM_BANAN t
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID)  and t.NgayBanAn between vFromDate and vToDate;
     elsif vLoaiAn='AHS_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AHS_PHUCTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayBanAn between vFromDate and vToDate;

    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From AHN_SOTHAM_BANAN t
          Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From AHN_PHUCTHAM_BANAN t 
          Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;

     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
          From AHC_SOTHAM_BANAN t
          Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AHC_PHUCTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From ALD_SOTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From ALD_PHUCTHAM_BANAN t
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AKT_SOTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From AKT_PHUCTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From APS_SOTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From APS_PHUCTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;

      elsif vLoaiAn='XLHC' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From XLHC_SOTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;
     elsif vLoaiAn='XLHC_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER((regexp_replace( SUBSTR(t.SOBANAN,1,DECODE(INSTR(t.SOBANAN, '/'),0,LENGTH(t.SOBANAN),INSTR(t.SOBANAN, '/') - 1 )), '[^0-9]', '')))),0)
                    into vReturnID
            From XLHC_PHUCTHAM_BANAN t 
            Where t.TOAANID=vdonviID and t.NgayTuyenAn between vFromDate and vToDate;   
  end if;      
END QLA_ST_PT_GETSoBA_NEW;

PROCEDURE QLA_ST_PT_CheckSoThuLy
( vLoaiAn in varchar2,
  v_thanhnien in number,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSoThuLy in nvarchar2,
	curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_SOTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
            and t.NGAYTHULY between vFromDate and vToDate;
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_PHUCTHAM_THULY t
          Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
            and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHS' and v_thanhnien=2 then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_SOTHAM_THULY t
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID) and t.sothuly = vSoThuLy
            and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHS' and v_thanhnien=1 then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_SOTHAM_THULY t
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID) and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate
              AND ( EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               OR  
                                EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));
    elsif vLoaiAn='AHS' and v_thanhnien=0 then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_SOTHAM_THULY t
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID) and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate
              AND ( NOT EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               AND  
                                NOT EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID)); 
   elsif vLoaiAn='AHS_PT' and v_thanhnien=2 then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;
   elsif vLoaiAn='AHS_PT' and v_thanhnien=1 then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate
              AND ( EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               OR  
                                EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));
     elsif vLoaiAn='AHS_PT' and v_thanhnien=0 then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHS_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate
              AND ( NOT EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               AND  
                                NOT EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));

    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
            and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_PHUCTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
            and t.NGAYTHULY between vFromDate and vToDate;

     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHC_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
            and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHC_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_PHUCTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='XLHC' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From XLHC_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='XLHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From XLHC_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothuly = vSoThuLy
              and t.NGAYTHULY between vFromDate and vToDate;   
  end if;      
END QLA_ST_PT_CheckSoThuLy;

PROCEDURE   QLA_ST_PT_STL_GETMAXTT
( vLoaiAn in varchar2,
  v_thanhnien in number,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
	curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
--NVL(MAX(d.STT),0)
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0) into vReturnID
          From ADS_SOTHAM_THULY t inner join ADS_DON d on d.ID=t.DONID
          Where d.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0) into vReturnID
          From ADS_PHUCTHAM_THULY t 
          Where t.TOAANID=vdonviID  and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHS' and v_thanhnien=2 then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0) into vReturnID
            From AHS_SOTHAM_THULY t 
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID) and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHS' and v_thanhnien=1 then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0) into vReturnID
            From AHS_SOTHAM_THULY t 
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID) and t.NGAYTHULY between vFromDate and vToDate
            AND ( EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               OR  
                                EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));
     elsif vLoaiAn='AHS' and v_thanhnien=0 then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0) into vReturnID
            From AHS_SOTHAM_THULY t 
            Where exists( select 'x' from AHS_VUAN d where d.ID=t.VUANID and d.TOAANID=vdonviID) and t.NGAYTHULY between vFromDate and vToDate
            AND ( NOT EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               AND  
                                NOT EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));
     elsif vLoaiAn='AHS_PT' and v_thanhnien=2 then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
                From AHS_PHUCTHAM_THULY t
                Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHS_PT' and v_thanhnien=1 then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
                From AHS_PHUCTHAM_THULY t
                Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate
                AND ( EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               OR  
                                EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));
    elsif vLoaiAn='AHS_PT' and v_thanhnien=0 then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
                From AHS_PHUCTHAM_THULY t
                Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate
                AND ( NOT EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                    WHERE BC.istrevithanhnien = 1 and BC.VUANID = t.VUANID)
                               AND  
                                NOT EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                  WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = t.VUANID));
    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
          From AHN_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
          From AHN_PHUCTHAM_THULY t
          Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;

     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
          From AHC_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select   NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From AHC_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From ALD_SOTHAM_THULY t 
            Where t.TOAANID=vdonviID and  t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From ALD_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From AKT_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From AKT_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From APS_SOTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From APS_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and  t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='XLHC' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From XLHC_SOTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='XLHC_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothuly,'[^0-9]'))),0)  into vReturnID
            From XLHC_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHULY between vFromDate and vToDate;   
    end if;    
END QLA_ST_PT_STL_GETMAXTT;

PROCEDURE QLA_ST_PT_CheckSoThongBaoThuLy
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  vSothongbao in nvarchar2,
	curReturn    OUT       sys_refcursor
)
IS
  vReturnID number;
BEGIN  
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
            and t.NGAYTHULY between vFromDate and vToDate;
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From ADS_PHUCTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
            and t.NGAYTHULY between vFromDate and vToDate;
    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
            and t.NGAYTHULY between vFromDate and vToDate;
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHN_PHUCTHAM_THULY t
          Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
            and t.NGAYTHULY between vFromDate and vToDate;

     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select t.ID into vReturnID
          From AHC_SOTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
            and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AHC_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_SOTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From ALD_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From AKT_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;

      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select t.ID into vReturnID
            From APS_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.sothongbao = vSothongbao
              and t.NGAYTHULY between vFromDate and vToDate;
  end if;      
END QLA_ST_PT_CheckSoThongBaoThuLy;

PROCEDURE   QLA_ST_PT_STBTL_GETMAXTT
( vLoaiAn in varchar2,
  vdonviID in number,
  vFromDate in DATE,
  vToDate in DATE,
  curReturn    OUT   sys_refcursor
)
IS
  vReturnID number;
BEGIN  
--NVL(MAX(d.STT),0)
    if vLoaiAn='ADS' then 
      OPEN curReturn FOR  
          Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
          From ADS_SOTHAM_THULY t
          Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
    elsif vLoaiAn='ADS_PT' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
          From ADS_PHUCTHAM_THULY t
          Where t.TOAANID=vdonviID  and t.NGAYTHONGBAO between vFromDate and vToDate;
    elsif vLoaiAn='AHN' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
          From AHN_SOTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
     elsif vLoaiAn='AHN_PT' then 
      OPEN curReturn FOR  
          Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
          From AHN_PHUCTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;

     elsif vLoaiAn='AHC' then 
      OPEN curReturn FOR  
          Select   NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
          From AHC_SOTHAM_THULY t 
          Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
      elsif vLoaiAn='AHC_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From AHC_PHUCTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;

      elsif vLoaiAn='ALD' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From ALD_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and  t.NGAYTHONGBAO between vFromDate and vToDate;
      elsif vLoaiAn='ALD_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From ALD_PHUCTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;

      elsif vLoaiAn='AKT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From AKT_SOTHAM_THULY t
            Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
      elsif vLoaiAn='AKT_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From AKT_PHUCTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;

      elsif vLoaiAn='APS' then 
        OPEN curReturn FOR  
            Select NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From APS_SOTHAM_THULY t 
            Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
       elsif vLoaiAn='APS_PT' then 
        OPEN curReturn FOR  
            Select  NVL(MAX(TO_NUMBER(regexp_replace(t.sothongbao,'[^0-9]'))),0) into vReturnID
            From APS_PHUCTHAM_THULY t 
            Where t.TOAANID=vdonviID and  t.NGAYTHONGBAO between vFromDate and vToDate;
  end if;   
END QLA_ST_PT_STBTL_GETMAXTT; 

PROCEDURE   QLA_ST_PT_STB_XLDON_GETMAXTT
    ( vLoaiAn in varchar2,
      vdonviID in number,
      vFromDate in DATE,
      vToDate in DATE,
      curReturn    OUT   sys_refcursor
    )
    IS
      vReturnID number;
    BEGIN  
    --NVL(MAX(d.STT),0)
        if vLoaiAn='ADS' then 
          OPEN curReturn FOR  
              Select NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From ADS_DON_XULY t
              Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
        elsif vLoaiAn='AHN' then 
          OPEN curReturn FOR  
              Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From AHN_DON_XULY t 
              Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
        elsif vLoaiAn='AKT' then 
          OPEN curReturn FOR  
              Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From AKT_DON_XULY t 
              Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
        
         elsif vLoaiAn='AHC' then 
          OPEN curReturn FOR  
              Select   NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From AHC_DON_XULY t 
              Where t.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
          elsif vLoaiAn='ALD' then 
            OPEN curReturn FOR  
                Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
                From ALD_DON_XULY t
                Where t.TOAANID=vdonviID and  t.NGAYTHONGBAO between vFromDate and vToDate;
         elsif vLoaiAn='APS' then 
            OPEN curReturn FOR  
                Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
                From APS_DON_XULY t
                Where t.TOAANID=vdonviID and  t.NGAYTHONGBAO between vFromDate and vToDate;
      end if;  
  
END QLA_ST_PT_STB_XLDON_GETMAXTT;
PROCEDURE   QLA_ST_PT_STB_ANPHI_GETMAXTT
    ( vLoaiAn in varchar2,
      vdonviID in number,
      vFromDate in DATE,
      vToDate in DATE,
      curReturn    OUT   sys_refcursor
    )
    IS
      vReturnID number;
    BEGIN  
    --NVL(MAX(d.STT),0)
        if vLoaiAn='ADS' then 
          OPEN curReturn FOR  
              Select NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From ADS_ANPHI t
              INNER JOIN ADS_DON_XULY x ON t.DONID = x.DONID
              Where x.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
        elsif vLoaiAn='AHN' then 
          OPEN curReturn FOR  
              Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From AHN_ANPHI t 
              INNER JOIN AHN_DON_XULY x ON t.DONID = x.DONID
              Where x.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
        elsif vLoaiAn='AKT' then 
          OPEN curReturn FOR  
              Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From AKT_ANPHI t 
              INNER JOIN AKT_DON_XULY x ON t.DONID = x.DONID
              Where x.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
        
         elsif vLoaiAn='AHC' then 
          OPEN curReturn FOR  
              Select   NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
              From AHC_ANPHI t 
              INNER JOIN AHC_DON_XULY x ON t.DONID = x.DONID
              Where x.TOAANID=vdonviID and t.NGAYTHONGBAO between vFromDate and vToDate;
          elsif vLoaiAn='ALD' then 
            OPEN curReturn FOR  
                Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
                From ALD_ANPHI t
                INNER JOIN ALD_DON_XULY x ON t.DONID = x.DONID
              Where x.TOAANID=vdonviID and  t.NGAYTHONGBAO between vFromDate and vToDate;
         elsif vLoaiAn='APS' then 
            OPEN curReturn FOR  
                Select  NVL(MAX(TO_NUMBER(regexp_replace(t.SOTHONGBAO,'[^0-9]'))),0) into vReturnID
                From APS_ANPHI t
                INNER JOIN APS_DON_XULY x ON t.DONID = x.DONID
              Where x.TOAANID=vdonviID and  t.NGAYTHONGBAO between vFromDate and vToDate;
      end if;  
  
END QLA_ST_PT_STB_ANPHI_GETMAXTT;

END PKG_STPT_QLCS;
