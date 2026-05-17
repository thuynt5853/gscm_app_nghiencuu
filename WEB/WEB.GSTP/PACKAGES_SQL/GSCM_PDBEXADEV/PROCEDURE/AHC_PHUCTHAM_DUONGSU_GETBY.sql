CREATE OR REPLACE PROCEDURE GSCM."AHC_PHUCTHAM_DUONGSU_GETBY" 
( vDONID in number,
  vIsPhucTham in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select d.ID,d.TENDUONGSU,(CASE LOAIDUONGSU WHEN 1 THEN 'Cá nhân' WHen 2 then 'Cơ quan' When 3 then 'Tổ chức' END) as TENLOAIDS
        ,(CASE ISDAIDIEN WHEN 1 THEN 'X' Else '' END) as DAIDIEN
        ,(CASE LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) as DIACHIDS
        ,i.TEN as TENTCTT,d.ISPHUCTHAM
        ,d.NGUOITAO,d.NGAYTAO
        ,(d.TENDUONGSU || ' - ' || (CASE LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) || ' - ' || i.TEN) as ARRDUONGSU
        ,d.TOA_GIAIQUYET_ID
  From AHC_DON_DUONGSU d 
  left join DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA
  left join DM_HANHCHINH h1 on h1.ID=d.HKTTID
  left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID
  Where d.DONID=vDONID
  ORder by d.ISDAIDIEN desc,d.ISPHUCTHAM desc, d.TENDUONGSU;
END AHC_PHUCTHAM_DUONGSU_GETBY;