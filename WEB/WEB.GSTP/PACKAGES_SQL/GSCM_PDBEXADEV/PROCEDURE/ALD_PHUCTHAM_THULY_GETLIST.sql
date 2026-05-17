CREATE OR REPLACE PROCEDURE GSCM."ALD_PHUCTHAM_THULY_GETLIST" 
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
vGroupTHGiaoNhan number;
CheckBanAnPT number;
CheckPhanCongTP number;
CheckNguoiTienHanhTT number;
BEGIN
  select ID into vGroupTHGiaoNhan from DM_DATAGROUP where MA='TRUONGHOP_GIAONHAN';
   select count(ID) into CheckBanAnPT from ALD_PHUCTHAM_BANAN where DonID = vDONID; 
   select count(ID) into CheckPhanCongTP from ALD_DON_THAMPHAN where DonID = vDONID and mavaitro like 'VTTP_GIAIQUYETPHUCTHAM'; 
   select count(ID) into CheckNguoiTienHanhTT from ALD_PHUCTHAM_HDXX where DonID = vDONID;
OPEN curReturn FOR  
  Select t.ID,t.MATHULY
    ,thtl.TEN as TENTRUONGHOPTHULY
    /*,qhpl.TEN as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK*/
    ,t.QUANHEPHAPLUAT_NAME as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK
    ,t.NGAYTHULY,t.SOTHULY,t.FILEID,f.TENFILE
    ,t.THOIHANTUNGAY,t.THOIHANDENNGAY,t.NGAYTAO,t.NGUOITAO
    , NVL(CheckBanAnPT, 0) CheckBanAnPT
    , NVL(CheckPhanCongTP,0) CheckPhanCongTP
    , NVL(CheckNguoiTienHanhTT,0) CheckNguoiTienHanhTT
    ,t.TOA_GIAIQUYET_ID
  From ALD_PHUCTHAM_THULY t
  left join ALD_FILE f on f.ID = t.FILEID 
  left join (select a.ID,a.TEN from DM_DATAITEM a where a.GROUPID=vGroupTHGiaoNhan and a.MA in ('02','03','04')) thtl on thtl.ID=t.TRUONGHOPTHULY
  /*left join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID*/
  left join DM_QHPL_TK qhpltk on qhpltk.ID=t.QHPLTKID
  Where t.DONID=vDONID
  ORder by t.NGAYTHULY desc;
END ALD_PHUCTHAM_THULY_GETLIST;