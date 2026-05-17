CREATE OR REPLACE PROCEDURE GSCM."AHC_DON_DSDUONGSU_GETBY" 
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS
BEGIN
OPEN curReturn FOR
Select d.ID,d.TENDUONGSU
     ,(CASE LOAIDUONGSU WHEN 1 THEN 'Cá nhân' WHen 2 then 'Cơ quan' When 3 then 'Tổ chức' END) as TENLOAIDS
     ,(CASE ISDAIDIEN WHEN 1 THEN 'X ' Else '' END) as DAIDIEN
     ,(CASE LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) as DIACHIDS
     , CASE WHEN p.SOBIENLAI is not null OR p.tinhtrang=1 then 'X ' else '' end as  THULY
     ,case d.TUCACHTOTUNG_MA
          when 'NGUYENDON' then u'Ng\01b0\1eddi kh\1edfi ki\1ec7n'
          when 'BIDON' then u'Ng\01b0\1eddi b\1ecb ki\1ec7n'
          else  i.TEN
    end as TENTCTT
     ,d.NGUOITAO,d.NGAYTAO,d.ISPHUCTHAM
     ,(d.TENDUONGSU || ' - ' || (CASE LOAIDUONGSU WHEN 1 THEN h1.MA_TEN Else h2.MA_TEN END) || ' - ' || i.TEN) as ARRDUONGSU,
    d.TUCACHTOTUNG_MA TUCACHTOTUNG --toancau-duonghv-lấy thêm trường mã tư cách tố tụng
     ,d.TOA_GIAIQUYET_ID
From AHC_DON_DUONGSU d
         left join DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA
         left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
         left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID
         left join AHC_ANPHI p ON p.duongsu_ids like '%'|| d.ID || '%'
Where d.ISDON=1 and (d.DONID=vDONID OR d.DONID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=vDONID AND IS_TACHAN IS NULL))
ORder by d.ISDAIDIEN desc, d.TENDUONGSU;
END AHC_DON_DSDUONGSU_GETBY;