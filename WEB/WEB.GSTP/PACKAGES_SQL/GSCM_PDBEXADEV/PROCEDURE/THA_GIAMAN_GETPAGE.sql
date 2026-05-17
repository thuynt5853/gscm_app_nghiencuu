CREATE OR REPLACE PROCEDURE GSCM."THA_GIAMAN_GETPAGE" 
(
   bi_an_id IN INT ,  
   CURRETURN OUT sys_refcursor
) AS
BEGIN
OPEN CURRETURN FOR
select  ROW_NUMBER() OVER (ORDER BY a.NGAYQD desc) stt
          , a.ID, a.BIANID,a.VUANID, a.SOQD, a.NGAYQD
     , a.CHHP_TINH, a.CHHP_HUYEN
     , ( case when (length(a.CHHP_CHITIET)>0) then (a.CHHP_CHITIET ||', '|| huyen.Ma_ten)
              else (huyen.Ma_ten)
    end )NoiThiHanhAn
     , a.CHUCVUID, a.NGUOIKYID
     , a.GIAM_NAM,  a.GIAM_NGAY, a.GIAM_THANG
     , a.NGAYSUA , a.NGUOISUA  , a.NGAYTAO, a.NGUOITAO, a.TOA_GIAIQUYET_ID
     , a.QT_FILE_ID AS FILE_ID -- vnpt UPDATE 180925
from THA_CVDON_GIAMAN a
         left join (select ID,  Ten, Ma_ten from DM_HanhChinh) huyen on huyen.Id = a.CHHP_HUYEN
where a.BIANID = bi_an_id;

END THA_GIAMAN_GETPAGE;