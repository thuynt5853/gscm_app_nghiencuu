CREATE OR REPLACE PROCEDURE GSCM."AHC_DON_THAMPHAN_GETBY" 
( vDONID in number,
  vMaVaiTro in nvarchar2,
	curReturn    OUT       sys_refcursor
)
IS 
  CheckThuLy number;
BEGIN
  select count(ID) into CheckThuLy from AHC_SoTham_ThuLy where DonID = vDonID;
  OPEN curReturn FOR  
    Select d.ID,d.NGAYPHANCONG,d.NGAYNHANPHANCONG,d.NGAYTHAMGIA,d.NGAYKETTHUC,d.NGUOITAO,d.NGAYTAO
           , d.CANBOID,d.NGUOIPHANCONGID
           , c1.HOTEN as TENTHAMPHAN ,c2.HOTEN as THAMPHANPHANCONG,c3.HOTEN as THUKY
           , NVL(CheckThuLy ,0) CheckThuLy
           , d.TOA_GIAIQUYET_ID
    From AHC_DON_THAMPHAN d 
    left join DM_CANBO c1 on c1.ID=d.CANBOID
    left join DM_CANBO c2 on c2.ID=d.NGUOIPHANCONGID
    left join DM_CANBO c3 on c3.ID=d.THUKYID
    left join (Select MA,TEN from DM_DATAITEM
                where GROUPID=(Select ID from DM_DATAGROUP where MA='VAITROTHAMPHAN')) i on i.MA=d.MAVAITRO
    Where d.DONID=vDONID
          And 1=(case when vMaVaiTro='' then 1 when d.MAVAITRO=vMaVaiTro then 1 else 0 End);
END AHC_DON_THAMPHAN_GETBY;