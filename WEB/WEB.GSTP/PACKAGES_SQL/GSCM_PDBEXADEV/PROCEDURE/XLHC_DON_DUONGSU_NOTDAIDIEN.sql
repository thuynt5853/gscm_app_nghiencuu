CREATE OR REPLACE PROCEDURE GSCM."XLHC_DON_DUONGSU_NOTDAIDIEN" --- VNPT --Lê Bá Thọ 08-10-2025 08:30 sửa thành lấy đương sự đại diện
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS
BEGIN
OPEN curReturn FOR
Select d.ID,d.HOTEN,d.NAMSINH
     , DECODE(LOAIDOITUONG ,1, 'Người bị đề nghị ' ,2, 'Cơ quan đề nghị' ,'')  TENLOAIDS
     --,(CASE BICANDAUVU WHEN 1 THEN 'X' Else '' END) as DAIDIEN
     ,DECODE(BICANDAUVU ,1, 'X ' ,'')  DAIDIEN
--        , h1.MA_TEN as DIACHIDS
     , DECODE(LOAIDOITUONG ,1, h1.MA_TEN ,h2.MA_TEN)  DIACHIDS
     ,d.NGUOITAO,d.NGAYTAO
     ,d.TOA_GIAIQUYET_ID    --- VNPT --Lê Bá Thọ 08/10/2025 08:30
From XLHC_DUONGSU d
         left join DM_HANHCHINH h1 on h1.ID=d.TAMTRU
         left join DM_HANHCHINH h2 on h2.ID=d.NDD_DIACHIID
Where d.DONID=vDONID
--and d.BICANDAUVU=0
ORder by d.HOTEN;
END XLHC_DON_DUONGSU_NOTDAIDIEN;