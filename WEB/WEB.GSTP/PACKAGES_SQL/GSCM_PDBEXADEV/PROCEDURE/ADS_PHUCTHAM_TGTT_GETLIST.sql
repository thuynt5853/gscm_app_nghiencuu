CREATE OR REPLACE PROCEDURE GSCM."ADS_PHUCTHAM_TGTT_GETLIST" 
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
        ,i.ma --duongph
        ,concat(cb.hoten, '-'||d.chucvu_chucdanh) as chucvuchucdanh --duongph
        ,d.NGAYTHAMGIA,d.NGAYKETTHUC
        ,d.NGUOITAO,d.NGAYTAO
       ,(select LISTAGG(TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY ID) AS description from ADS_DON_DUONGSU a where d.DUONGSUID like '%,'||a.ID||',%') TENDUONGSU
       ,d.TOA_GIAIQUYET_ID
  From ADS_PHUCTHAM_THAMGIATOTUNG d 
  left join DM_DATAITEM i on i.MA=d.TUCACHTGTTID
  left join DM_HANHCHINH h1 on h1.ID=d.TAMTRUID
  left join DM_CANBO cb on d.nguoiphancongid = cb.id
  Where d.DONID=vDONID
  ORder by  d.HOTEN;

END ADS_PHUCTHAM_TGTT_GETLIST;