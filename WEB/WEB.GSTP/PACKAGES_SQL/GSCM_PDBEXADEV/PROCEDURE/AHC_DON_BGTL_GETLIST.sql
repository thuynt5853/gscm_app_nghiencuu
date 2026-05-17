CREATE OR REPLACE PROCEDURE GSCM."AHC_DON_BGTL_GETLIST" 
(
  vDonID IN NUMBER,
  CurReturn OUT sys_refcursor
) AS 
vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select b.ID,b.DONID,b.NGAYBANGIAO
    , case when d.ChucVu is not null then  (e.HoTen || ' - ' || d.ChucVu)
           when d.ChucVu is null then e.HoTen 
        end as NguoiNhan
    , b.NGUOINHANID,b.LOAIDOITUONG,b.TENFILE,b.TENTAILIEU
    , Decode(b.LoaiDoiTuong, 0, u'\0110\01b0\01a1ng s\1ef1' , 1, u'Ng\01b0\1eddi tham gia t\1ed1 t\1ee5ng' , '' )  TenLoaiDoiTuong
     , Decode(b.LoaiDoiTuong, 0, ds.ID , 1, tt.ID , 0 )  NGUOIBANGIAOID
      , Decode(b.LoaiDoiTuong, 0,ds.TENDUONGSU , 1, tt.HOTEN , '' )  NGUOIBANGIAO
      , b.TOA_GIAIQUYET_ID
  from AHC_DON_TAILIEU b
    left join (select ID, HoTen, ChucVuID from DM_CanBo) e on b.NguoiNhanID = e.ID
    left join (select ID, Ten ChucVu from DM_DataItem where GroupID = vGroupChucVuID) d on e.ChucVuID = d.ID
    left join (select a.ID,a.TENDUONGSU from AHC_DON_DUONGSU a) ds on ds.ID=b.NGUOIBANGIAO
    left join (select a.ID,a.HOTEN from AHC_DON_THAMGIATOTUNG a) tt on tt.ID=b.NGUOIBANGIAO        
  where b.DONID=vDonID
  order by b.NGAYBANGIAO desc;
END AHC_DON_BGTL_GETLIST;

