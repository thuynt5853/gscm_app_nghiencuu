create or replace NONEDITIONABLE PROCEDURE        "AHN_SOTHAM_THULY_GETLIST" 
( vDONID in number,
	curReturn OUT sys_refcursor
)
IS 
 CheckBanAnST number;
 CheckPhanCongTP number;
 CheckNguoiTienHanhTT number;
BEGIN
   select count(ID) into CheckBanAnST from AHN_SOTHAM_BANAN where DonID = vDONID;
   select count(ID) into CheckPhanCongTP from AHN_DON_THAMPHAN where DonID = vDONID and mavaitro like 'VTTP_GIAIQUYETSOTHAM'; 
   select count(ID) into CheckNguoiTienHanhTT from AHN_SOTHAM_HDXX where DonID = vDONID; 
    OPEN curReturn FOR  
      Select t.ID,t.MATHULY,
        (CASE t.TRUONGHOPTHULY WHEN 1 THEN 'Thụ lý mới' 
                               WHen 2 then 'Thụ lý từ Tòa án khác chuyển đến' 
                               When 3 then 'Thụ lý xét xử lại (do Tạm đình chỉ)' END) as TENTRUONGHOPTHULY,
        /*qhpl.TEN as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK*/
        t.QUANHEPHAPLUAT_NAME as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK
        ,t.NGAYTHULY,t.SOTHULY,f.TENFILE,t.FILEID
        ,t.THOIHANTUNGAY,t.THOIHANDENNGAY,t.NGAYTAO,t.NGUOITAO
        , NVL(CheckBanAnST,0) CheckBanAnST
        , NVL(CheckPhanCongTP,0) CheckPhanCongTP
        , NVL(CheckNguoiTienHanhTT,0) CheckNguoiTienHanhTT
        ,t.TOA_GIAIQUYET_ID
      From AHN_SOTHAM_THULY t
      left join AHN_FILE f on t.FILEID=f.ID
      /*left join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID*/
      inner join DM_QHPL_TK qhpltk on qhpltk.ID=t.QHPLTKID
      Where t.DONID=vDONID
      ORder by t.NGAYTHULY desc;
END AHN_SOTHAM_THULY_GETLIST;