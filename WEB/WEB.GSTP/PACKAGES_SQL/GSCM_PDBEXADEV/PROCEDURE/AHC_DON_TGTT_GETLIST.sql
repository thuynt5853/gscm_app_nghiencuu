CREATE OR REPLACE PROCEDURE GSCM."AHC_DON_TGTT_GETLIST" 
( vDONID in number,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select d.ID,d.HOTEN
        ,i.TEN as TENTC
        --,h1.MA_TEN as Tamtru
        ,d.tamtruchitiet as Tamtru --duongph
        ,d.NGAYTHAMGIA,d.NGAYKETTHUC
        ,d.NGUOITAO,d.NGAYTAO
        ,i.ma --duongph
        ,concat(cb.hoten, '-'||d.chucvu_chucdanh) as chucvuchucdanh --duongph
        , (d.HOTEN || ' - ' || h1.MA_TEN || ' - ' || i.TEN) as arrTEN
        --, (d.HOTEN || ' - ' || d.tamtruchitiet || ' - ' || i.TEN) as arrTEN --duongph
        ,(select LISTAGG(TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY ID) AS description from AHC_DON_DUONGSU a where d.DUONGSUID like '%,'||a.ID||',%') TENDUONGSU
        , d.TOA_GIAIQUYET_ID
  From AHC_DON_THAMGIATOTUNG d 
  left join DM_DATAITEM i on i.MA=d.TUCACHTGTTID
  left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
  left join DM_CANBO cb on d.nguoiphancongid = cb.id
  Where d.DONID=vDONID OR d.DONID IN (SELECT ID FROM AHC_DON WHERE VUANGOCID=vDONID AND IS_TACHAN IS NULL) and (d.ID IN ( SELECT MAX(id) FROM AHC_DON_THAMGIATOTUNG GROUP BY HOTEN , NAMSINH, SOCMND))
  ORder by  d.HOTEN;

END AHC_DON_TGTT_GETLIST;

