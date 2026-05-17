CREATE OR REPLACE PROCEDURE GSCM."ADS_DON_DSDUONGSU_GETBY" 
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
     Select d.NgaySinh, d.NamSinh , d.ID,d.TENDUONGSU , d.NGAYSINH , d.NAMSINH
     , DECODE(LOAIDUONGSU ,1, 'Cá nhân ' ,2, 'Cơ quan' ,3, 'Tổ chức','')  TENLOAIDS
     , DECODE(ISDAIDIEN ,1, 'X ' ,'')  DAIDIEN
     , CASE WHEN p.SOBIENLAI is not null OR p.tinhtrang=1 then 'X ' else '' end as  THULY
     , DECODE(LOAIDUONGSU ,1, h1.MA_TEN ,h2.MA_TEN)  DIACHIDS
     ,i.TEN as TENTCTT ,d.NGUOITAO,d.NGAYTAO,d.ISPHUCTHAM
     ,(d.TENDUONGSU || ' - ' || DECODE(LOAIDUONGSU ,1, h1.MA_TEN ,h2.MA_TEN) || ' - ' || i.TEN) as ARRDUONGSU,
     d.TUCACHTOTUNG_MA TUCACHTOTUNG,d.TOA_GIAIQUYET_ID
    From ADS_DON_DUONGSU d 
    left join DM_DATAITEM i on i.MA=d.TUCACHTOTUNG_MA
    left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
    left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID
    left join ADS_ANPHI p ON p.duongsu_id = d.ID
    Where d.ISDON=1 and (d.DONID=vDONID OR d.DONID IN (SELECT ID FROM ADS_DON WHERE VUANGOCID=vDONID AND IS_TACHAN IS NULL))

    ORder by d.ISDAIDIEN desc, d.TENDUONGSU;
END ADS_DON_DSDUONGSU_GETBY;