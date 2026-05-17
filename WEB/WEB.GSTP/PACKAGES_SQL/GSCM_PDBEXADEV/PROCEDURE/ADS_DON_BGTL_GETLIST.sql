CREATE OR REPLACE PROCEDURE GSCM."ADS_DON_BGTL_GETLIST" 
(
  vDonID IN NUMBER,
  CurReturn OUT sys_refcursor
) AS 
vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
    /*select b.ID,b.DONID,b.NGAYBANGIAO,e.NguoiNhan,b.NGUOINHANID,b.LOAIDOITUONG,b.TENFILE,b.TENTAILIEU,
      case when b.LOAIDOITUONG=0 then 'Đương sự'
           when b.LOAIDOITUONG=1 then 'Người tham gia tố tụng' else '' end as TenLoaiDoiTuong,
      case when b.LOAIDOITUONG=0 then ds.ID
           when b.LOAIDOITUONG=1 then tt.ID else 0 end as NGUOIBANGIAOID,
      case when b.LOAIDOITUONG=0 then ds.TENDUONGSU
           when b.LOAIDOITUONG=1 then tt.HOTEN else N'' end as NGUOIBANGIAO
    from ADS_DON_TAILIEU b
    left join( select a.ID,a.HOTEN || ' - ' || d.TEN as NguoiNhan from DM_CANBO a
                left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucVuID) d on d.ID=a.CHUCVUID
              ) e on b.NGUOINHANID=e.ID
    left join (select a.ID,a.TENDUONGSU from ADS_DON_DUONGSU a) ds on ds.ID=b.NGUOIBANGIAO
    left join (select a.ID,a.HOTEN from ADS_DON_THAMGIATOTUNG a) tt on tt.ID=b.NGUOIBANGIAO        
    where b.DONID=vDonID
    order by b.NGAYBANGIAO desc;
    */  
   select b.ID,b.DONID,b.NGAYBANGIAO
    , case when d.ChucVu is not null then  (e.HoTen || ' - ' || d.ChucVu)
           when d.ChucVu is null then e.HoTen 
        end as NguoiNhan
    , b.NGUOINHANID,b.LOAIDOITUONG,b.TENFILE,b.TENTAILIEU
    , Decode(b.LoaiDoiTuong, 0, u'\0110\01b0\01a1ng s\1ef1' , 1, u'Ng\01b0\1eddi tham gia t\1ed1 t\1ee5ng' , '' )  TenLoaiDoiTuong
     , Decode(b.LoaiDoiTuong, 0, ds.ID , 1, tt.ID , 0 )  NGUOIBANGIAOID
      , Decode(b.LoaiDoiTuong, 0,ds.TENDUONGSU , 1, tt.HOTEN , '' )  NGUOIBANGIAO,b.TOA_GIAIQUYET_ID
  from ADS_DON_TAILIEU b
    left join (select ID, HoTen, ChucVuID from DM_CanBo) e on b.NguoiNhanID = e.ID
    left join (select ID, Ten ChucVu from DM_DataItem where GroupID = vGroupChucVuID) d on e.ChucVuID = d.ID
    left join (select a.ID,a.TENDUONGSU from ADS_DON_DUONGSU a) ds on ds.ID=b.NGUOIBANGIAO
    left join (select a.ID,a.HOTEN from ADS_DON_THAMGIATOTUNG a) tt on tt.ID=b.NGUOIBANGIAO  
  where b.DONID=vDonID
  order by b.NGAYBANGIAO desc;
END ADS_DON_BGTL_GETLIST;