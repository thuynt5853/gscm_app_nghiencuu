CREATE OR REPLACE PROCEDURE GSCM."ALD_SOTHAM_THULY_GETLIST" 
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
 CheckBanAnST number;
 CheckPhanCongTP number;
 CheckNguoiTienHanhTT number;
BEGIN
   select count(ID) into CheckBanAnST from ALD_SOTHAM_BANAN where DonID = vDONID; 
   select count(ID) into CheckPhanCongTP from ALD_DON_THAMPHAN where DonID = vDONID and mavaitro like 'VTTP_GIAIQUYETSOTHAM'; 
   select count(ID) into CheckNguoiTienHanhTT from ALD_SOTHAM_HDXX where DonID = vDONID;
    OPEN curReturn FOR  
      Select NVL(CheckBanAnST,0) CheckBanAnST
        , NVL(CheckPhanCongTP,0) CheckPhanCongTP
        , NVL(CheckNguoiTienHanhTT,0) CheckNguoiTienHanhTT
        , t.ID,t.MATHULY,
        (CASE t.TRUONGHOPTHULY WHEN 1 THEN 'Thụ lý mới' 
                               WHen 2 then 'Thụ lý từ Tòa án khác chuyển đến' 
                               When 3 then 'Thụ lý xét xử lại (do Tạm đình chỉ)' END) as TENTRUONGHOPTHULY,
        /*qhpl.TEN as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK*/
        t.QUANHEPHAPLUAT_NAME as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK
        ,t.NGAYTHULY,t.SOTHULY,f.TENFILE,t.FILEID
        ,t.THOIHANTUNGAY,t.THOIHANDENNGAY,t.NGAYTAO,t.NGUOITAO, t.TOA_GIAIQUYET_ID
      From ALD_SOTHAM_THULY t
      left join ALD_FILE f on t.FILEID=f.ID
      /*inner join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID*/
      inner join DM_QHPL_TK qhpltk on qhpltk.ID=t.QHPLTKID
      Where t.DONID=vDONID
      ORder by t.NGAYTHULY desc;
END ALD_SOTHAM_THULY_GETLIST;