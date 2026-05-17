CREATE OR REPLACE PROCEDURE GSCM."THA_CVDON_THULY_GETBYBIAN" 
(
       vu_an_id in number
     , bi_an_id in number
     , curReturn OUT sys_refcursor
)
as
BEGIN
OPEN curReturn FOR
select d.*
from  (select a.Id
            ,(CASE WHEN a.LoaiDon=0 then u'C\00f4ng v\0103n'  Else u'\0110\01a1n' END) LoaiDon
            ,(CASE WHEN a.NguoiLamDon=0 then u'B\1ecb \00e1n'  Else u'Ng\01b0\1eddi th\00e2n b\1ecb \00e1n' END) NguoiLamDon
            ,(CASE WHEN a.LoaiDon=0 then CV_So  Else a.SoThuLy END) SoCV_Don
            ,(CASE WHEN a.LoaiDon=0 then CV_Ngay  Else a.NgayThuLy END) NgayCV_Don
            , a.YeuCauID, b.Ten TenYeuCau, a.TOA_GIAIQUYET_ID,
           a.QT_FILE_ID AS FILE_ID -- vnpt 180925
       from THA_CVdon_ThuLy a
                left join (select ID, Ma, Ten from DM_DataItem) b on a.YeuCauID = b.ID
       where a.VuAnID = vu_an_id and a.BiAnID = bi_an_id
      )d order by d.NgayCV_Don;
end THA_CVDON_THULY_GetByBiAn;