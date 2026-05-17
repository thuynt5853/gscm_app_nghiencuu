CREATE OR REPLACE PROCEDURE GSCM."ADS_DON_DUONGSU_NOTDAIDIEN_DONCHA" 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select d.ID,d.TENDUONGSU,(CASE LOAIDUONGSU WHEN 1 THEN 'Cá nhân' WHen 2 then 'Cơ quan' When 3 then 'Tổ chức' END) as TENLOAIDS
        ,(CASE ISDAIDIEN WHEN 1 THEN 'X' Else '' END) as DAIDIEN
        ,(CASE LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) as DIACHIDS
        , d.TUCACHTOTUNG_MA, i.TEN as TENTCTT , d.SoCMND, d.QuocTichID
        ,d.NGUOITAO,d.NGAYTAO
        ,(d.TENDUONGSU || ' - ' || (CASE LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) || ' - ' || i.TEN) as ARRDUONGSU
        ,d.TOA_GIAIQUYET_ID
  From ADS_DON_DUONGSU d 
  left join DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA
  left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
  left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID
  Where d.DONID=vDONID
    And d.ISDON=1 and d.ISDAIDIEN=0 and (d.isdonchitiet is null or d.isdonchitiet = 0)
  ORder by d.TENDUONGSU;
END ADS_DON_DUONGSU_NOTDAIDIEN_DONCHA;