--------------------------------------------------------
--  DDL for Package Body PKG_STPT_DANHSACH
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_DANHSACH" AS
PROCEDURE DANHSACH_AN_DANSUMORONG
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_Capxx in varchar2,
    v_toaan_id in varchar2, 
    v_TINHTRANG_THULY in varchar2,
    V_NGAYTHULY_TU in varchar2,
    V_NGAYTHULY_DEN in varchar2,
    v_SOTHULY in varchar2,
    v_TINHTRANG_GIAIQUYET in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_KETQUA in varchar2,
    v_so_qd in varchar2,
    v_ngay_qd in varchar2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2, 
    v_THOIHAN_GQ in varchar2, 
    v_QD_TAMGIAM in varchar2,
    V_UTTP IN VARCHAR2,
    V_LOAIAN_ID IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int,
    curReturn OUT sys_refcursor)
AS
    V_TABLE_EXPORT T_DANHSACH_ADS_MORONG_DAXU;
    V_TABLE_EXPORT_HS T_DANHSACH_AHS_DAXU;
    V_EXPORT_TEXT CLOB;
    TEN_LOAI_AN_DA_XU VARCHAR2(250);
    V_TINHTRANGGIAQUYET VARCHAR2(250) DEFAULT '';
    VV_TUNGAY date;VV_DENNGAY date;
BEGIN   
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    V_TABLE_EXPORT := T_DANHSACH_ADS_MORONG_DAXU();
    V_TABLE_EXPORT_HS := T_DANHSACH_AHS_DAXU();

     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     
        IF(V_LOAIAN_ID='1') THEN -- HINH SU
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_HS(V_CAP_XET_XU_LOGIN,v_ten_vu_an,v_toidanh,v_ma_vu_an,v_bi_can,v_Capxx,
                           v_toaan_id,v_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,v_SOTHULY,v_TINHTRANG_GIAIQUYET,
                           V_TUNGAY,V_DENNGAY,v_KETQUA,v_so_qd,v_ngay_qd,v_thamphan_id,
                           v_thuky_id, v_THOIHAN_GQ, v_QD_TAMGIAM,V_UTTP,Page_Index,Page_Size) ) PA )
                LOOP
                        V_TABLE_EXPORT_HS.EXTEND;
                        V_TABLE_EXPORT_HS(V_TABLE_EXPORT_HS.COUNT) := R_DANHSACH_AHS_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                          item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                          item.V_HOTEN,item.V_SO_BC,item.V_KCKN,item.V_TOIDANH,item.V_MUCAN_ST,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                          item.V_DIACHI,item.V_KETQUAXXPT);                          
                END LOOP;  
                TEN_LOAI_AN_DA_XU := 'HÌNH SỰ';
        ELSIF(V_LOAIAN_ID='2,3,4,5,6') THEN -- DS
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_DS(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP; 
                --HC
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_HC(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                --HN
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_HN(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                --KT
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_KT(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                --LD
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_LD(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                TEN_LOAI_AN_DA_XU := 'DÂN SỰ CÁC LOẠI';
        ELSIF(V_LOAIAN_ID = '2') THEN -- DAN SU
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_DS(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                TEN_LOAI_AN_DA_XU := 'DÂN SỰ';
        ELSIF(V_LOAIAN_ID='3') THEN -- HON NHAN
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_HN(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;    
                TEN_LOAI_AN_DA_XU := 'HÔN NHÂN VÀ GIA ĐÌNH';
        ELSIF(V_LOAIAN_ID='4') THEN -- KINH DOANH
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_KT(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                TEN_LOAI_AN_DA_XU := 'KINH DOANH, THƯƠNG MẠI';
        ELSIF(V_LOAIAN_ID='5') THEN -- LAO DONG
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_LD(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT); 
                END LOOP;
                TEN_LOAI_AN_DA_XU := 'LAO ĐỘNG';
        ELSIF(V_LOAIAN_ID='6') THEN -- HANH CHINH
                FOR item IN (SELECT PA.* FROM  TABLE(PKG_STPT_DANHSACH.DON_SEARCH_ITEM_HC(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA )
                LOOP
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(item.V_CHUTOA,item.V_THANHVIEN,item.V_THUKY,
                                                                                        item.V_LOAIAN,item.V_SOAN,item.V_NGAYXU,item.V_SOTHULY,item.V_NGAYTHULY,
                                                                                        item.V_NGUYENDON,item.V_BIDON,item.V_VUVIEC,ITEM.V_SOBAQD_ST,ITEM.V_NGAYBA_QD_ST,
                                                                                        item.V_DIACHI,item.V_KCKN,item.V_KETQUAXXPT);
                END LOOP;   
                TEN_LOAI_AN_DA_XU := 'HÀNH CHÍNH';
        END IF;
        
        IF( v_TINHTRANG_GIAIQUYET = '1') THEN V_TINHTRANGGIAQUYET := 'CHƯA GIẢI QUYẾT XONG';
           ELSIF( v_TINHTRANG_GIAIQUYET = '2') THEN V_TINHTRANGGIAQUYET := 'CHƯA PHÂN CÔNG THẨM PHÁN';
           ELSIF( v_TINHTRANG_GIAIQUYET = '3') THEN V_TINHTRANGGIAQUYET := 'ĐÃ PHÂN CÔNG THẨM PHÁN';
           ELSIF( v_TINHTRANG_GIAIQUYET = '4') THEN V_TINHTRANGGIAQUYET := 'ĐÃ LÊN LỊCH XÉT XỬ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '5') THEN V_TINHTRANGGIAQUYET := 'ĐÃ HOÃN';
           ELSIF( v_TINHTRANG_GIAIQUYET = '6') THEN V_TINHTRANGGIAQUYET := 'ĐANG TẠM ĐÌNH CHỈ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '7') THEN V_TINHTRANGGIAQUYET := 'ĐÃ GIẢI QUYẾT XONG';
           ELSIF( v_TINHTRANG_GIAIQUYET = '8') THEN V_TINHTRANGGIAQUYET := 'ĐÃ XÉT XỬ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '9') THEN V_TINHTRANGGIAQUYET := 'ĐÌNH CHỈ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '10') THEN V_TINHTRANGGIAQUYET := 'CHUYỂN VỤ ÁN';
           ELSE V_TINHTRANGGIAQUYET := '';
        END IF;

    IF(V_LOAIAN_ID='1') THEN
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
                <tr align="center" style="text-align: center;">
                    <td colspan="13" style="text-align: center; vertical-align: top; font-size: 12pt"><b>ÁN HÌNH SỰ '||V_TINHTRANGGIAQUYET||' TỪ NGÀY '||TO_CHAR(VV_TUNGAY,'dd/mm/rrrr')||' ĐẾN NGÀY '||TO_CHAR(VV_DENNGAY,'dd/mm/rrrr')||' </b></td>
                </tr>
                <tr style="height: 3px;">
                </tr>
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Chủ toạ</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Thành viên</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Thư ký</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số BA/QĐ PT</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Ngày BA/QĐ PT</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số/Ngày TL</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Họ và tên</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số BC</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">KC/KN</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Tội danh</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Mức án ST</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số BA/QĐ ST</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Ngày BA/QĐ ST</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Tỉnh/TP</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Kết quả XXPT</td>
                </tr>');
        FOR item IN(SELECT COUNT(*) OVER (ORDER BY PA.V_NGAYXU ASC) as CountAll,PA.*  FROM TABLE(V_TABLE_EXPORT_HS) PA)
        LOOP
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||UPPER(ITEM.V_CHUTOA)||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_THANHVIEN||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_THUKY||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_SOAN||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.V_NGAYXU,'dd/mm/rrrr')||'</td>                    
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_SOTHULY||'<br style="mso-data-placement:same-cell;" />'||TO_CHAR(ITEM.V_NGAYTHULY,'dd/mm/rrrr')||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_HOTEN||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_SO_BC||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_KCKN||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_TOIDANH||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_MUCAN_ST||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_SOBAQD_ST||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.V_NGAYBA_QD_ST,'dd/mm/rrrr')||'</td>  
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_DIACHI||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.V_KETQUAXXPT||'</td>
                </tr>');
        END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr style="height: 0px;">
                <td style="width: 66px"></td>
                <td style="width: 66px"></td>
                <td style="width: 66px"></td>
                <td style="width: 42px"></td>
                <td style="width: 62px"></td>
                <td style="width: 62px"></td>
                <td style="width: 100px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 105px"></td>
                <td style="width: 105px"></td>
                <td style="width: 42px"></td> 
                <td style="width: 62px"></td> 
                <td style="width: 80px"></td>
                <td style="width: 105px"></td>
            </tr>
        </table>');
    ELSE
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
            <tr align="center" style="text-align: center;">
                <td colspan="13" style="text-align: center; vertical-align: top; font-size: 12pt">ÁN '||TEN_LOAI_AN_DA_XU||' '||V_TINHTRANGGIAQUYET||' TỪ NGÀY '||TO_CHAR(VV_TUNGAY,'dd/mm/rrrr')||' ĐẾN NGÀY '||TO_CHAR(VV_DENNGAY,'dd/mm/rrrr')||' </td>
            </tr>
            <tr style="height: 3px;">
            </tr>
            <tr align="center" style="text-align: center;"> 
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Chủ toạ</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Thành viên</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Thư ký</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Loại án</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Số án</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Ngày xử</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Số/Ngày TL</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Nguyên đơn</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Bị đơn</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Vụ việc</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Số BA/QĐ ST</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Ngày BA/QĐ ST</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Tỉnh/TP</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">KC/KN</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Kết quả XXPT</td>
            </tr>');
    FOR item IN(SELECT COUNT(*) OVER (ORDER BY PA.V_NGAYXU ASC) as CountAll,PA.*  FROM TABLE(V_TABLE_EXPORT) PA)
    LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_CHUTOA||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_THANHVIEN||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_THUKY||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_LOAIAN||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.V_SOAN||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.V_NGAYXU,'dd/mm/rrrr')||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_SOTHULY||'<br style="mso-data-placement:same-cell;" />'||TO_CHAR(ITEM.V_NGAYTHULY,'dd/mm/rrrr')||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_NGUYENDON||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_BIDON||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_VUVIEC||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.V_SOBAQD_ST||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.V_NGAYBA_QD_ST,'dd/mm/rrrr')||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_DIACHI||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_KCKN||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.V_KETQUAXXPT||'</td>
                </tr>');
    END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr style="height: 0px;">
                    <td style="width: 75px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 65px"></td>
                    <td style="width: 65px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 65px"></td>
                    <td style="width: 85px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 100px"></td>
                </tr>
            </table>');
    END IF;
    OPEN curReturn FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
            dbms_lob.freetemporary(V_EXPORT_TEXT);
END DANHSACH_AN_DANSUMORONG;
FUNCTION DON_SEARCH_ITEM_DS
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int
)RETURN T_DANHSACH_ADS_MORONG_DAXU
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_EXPORT T_DANHSACH_ADS_MORONG_DAXU;
    VCHUTOA_TEN VARCHAR2(250);
    VVUVIEC VARCHAR2(500);
    VSOBAQDST VARCHAR2(250); VNGAYBAQDST VARCHAR2(250);VKETQUAXXPT VARCHAR(500);
BEGIN
     V_TABLE_EXPORT := T_DANHSACH_ADS_MORONG_DAXU();
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     
 FOR item_ds IN (
      SELECT A.ID,A.MAVUVIEC MAVUAN,'<i style="margin-right: 3px">Vụ việc:</i><b>'||A.TENVUVIEC||'</b>'TENVUAN,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO,a.NgayTao NGAY_TAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN,  A.MAGIAIDOAN
            ,TENCHUTOA.HOTEN VCHUTOA,PCTP_GQ.HOTEN THAMPHAN_TEN,            
            TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
            BANAN.SOBANAN VSOAN,BANAN.NGAYTUYENAN VNGAYXU,
            TLPT.SOTHULY VSOTHULY, TLPT.NGAYTHULY VNGAYTHULY,
            PTBA.QUANHEPHAPLUAT_NAME VVUVIECBA_NAME,DMPTBA.TEN VVUVIECBA_ID,PTTL.QUANHEPHAPLUAT_NAME VVUVIECTL_NAME,DMPTBA.TEN VVUVIECTL_ID,A.QUANHEPHAPLUAT_NAME VVUVIECDON_NAME,DMDON.TEN VVUVIECDON_ID,
            KETQUAXXPT.TEN VKETQUAXXPT,
            REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
            DS_ND.TENNGUYENDON VNGUYENDON,DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO ||NDKNS.NOIDUNGKN VKCKN,
            QDVA.SOQD, QDVA.NGAYQD, QDVA.TEN TENQD,
            QDVAST.SOQD SOQDST, QDVAST.NGAYQD NGAYQDST, QDVAST.TEN TENQDST,
            BANANST.SOBANAN SOBAST, BANANST.NGAYTUYENAN NGAYBAST
      FROM ADS_DON A
            INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
            
            --------------------------Quyết định gây kết thúc Sơ thẩm và Phúc thẩm-------------------------- 
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM ADS_SOTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID --ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVAST ON QDVAST.DONID = A.ID
                                
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM ADS_PHUCTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID--ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVA ON QDVA.DONID = A.ID
            LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM ADS_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 
                                                                
            left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM ADS_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM ADS_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3  
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3       
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM ADS_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3     
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3                
            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
             LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
                  )GN ON  GN.VUANID=a.ID
                --TEN TOA AN SO THAM 
                  LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                -- VU VIEC 
                  LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTBA.QUANHEPHAPLUATID=DMPTBA.ID

                  LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTTL.QUANHEPHAPLUATID=DMPTBA.ID

                  left join DM_DATAITEM DMDON on DMDON.ID=A.QUANHEPHAPLUATID
                -- THAM PHAN CHU TOA 
                  LEFT JOIN (SELECT DMCANBO.HOTEN, DONID FROM ADS_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                            WHERE D.MAVAITRO LIKE 'THAMPHAN') TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                  LEFT JOIN (SELECT NNPC.HOTEN,NPC.HOTEN HOTEN_LD,GG.* FROM ADS_DON_THAMPHAN GG
                                INNER JOIN (
                                            SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID
                                                FROM (
                                                SELECT TP.DONID ,
                                                LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                                FROM ADS_DON_THAMPHAN TP
                                                WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                                AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                                GROUP BY TP.DONID )TT
                                         )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                         LEFT JOIN DM_CANBO NPC ON NPC.ID=GG.NGUOIPHANCONGID
                      )PCTP_GQ ON PCTP_GQ.DONID=A.ID
                 -- THAM PHAN THANH VIEN HDXX
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN FROM ADS_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                        GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                      
                 -- NỘI DUNG KHÁNG CÁO KHÁNG NGHỊ     
                    LEFT JOIN (     
                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                    from ADS_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                   )F
                                              GROUP BY F.DON_ND
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID
                    LEFT JOIN (SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM ADS_SOTHAM_KHANGNGHI KC
                             )NDKN  GROUP BY NDKN.DONID
                    )NDKNS ON NDKNS.DONID=A.ID  
                -- THU KY
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY FROM ADS_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THUKY'
                        GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID
                -- SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ 
                    LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM ADS_PHUCTHAM_BANAN) BANAN ON BANAN.DONID = A.ID 
                -- TÊN ĐƯƠNG SỤ
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON FROM ADS_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
                          GROUP BY  DONID ) DS_ND ON DS_ND.DONID = A.ID 
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON FROM ADS_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'BIDON'
                          GROUP BY  DONID ) DS_BD ON DS_BD.DONID = A.ID           
                -- KẾT QUẢ PHÚC THẨM
                    LEFT JOIN(SELECT DMKQPT.TEN, DONID FROM ADS_PHUCTHAM_BANAN D
                            LEFT JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID) KETQUAXXPT ON KETQUAXXPT.DONID = A.ID 
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (
                                                SELECT 'X' FROM ADS_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)
                                            )
                                    )
                 )
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM ADS_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    )
                ) 
            AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
            AND (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID))  
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )        
            AND (V_SOTHULY IS NULL OR(UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
            AND (V_THAMPHAN_ID IS NULL
             OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
             )
            --GQ đơn;V_GQDON -- -- 
            AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
            AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from ADS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from ADS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                     )
                )
            ------Loại đơn
            AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
            --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
            AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('01',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('04,06',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )      
             )   
            --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
            --/////////////đối với sơ thẩm          
            AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (  --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr('DC,CVA,HPT,GHTHXX',QDL.MA)>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA) IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA)IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
            --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
            AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND ( EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT  EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
            --Tình trạng GQ;
            AND( (v_TINHTRANG_GIAIQUYET IS NULL AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
              OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND(TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM ADS_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND ((PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                      --Đang hoãn phuc tham                 
                        EXISTS (
                            SELECT  'X' FROM   ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   ( 
                     --phuc tham Đang tạm đình chỉ                
                         EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND ( EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('CVA',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
             --là con của chưa giải quyết xong 
            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                     AND ( EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end            
     )
    LOOP
        VCHUTOA_TEN := NULL;
        VVUVIEC := NULL;
         IF(item_ds.VVUVIECBA_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_NAME;
            ELSIF(item_ds.VVUVIECBA_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_ID;
            ELSIF(item_ds.VVUVIECTL_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_NAME;
            ELSIF(item_ds.VVUVIECTL_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_ID;
            ELSE
                VVUVIEC := item_ds.VVUVIECDON_NAME;
            END IF;        

        IF(item_ds.VCHUTOA IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.VCHUTOA;
        ELSIF(item_ds.THAMPHAN_TEN IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.THAMPHAN_TEN;
            END IF;  
        V_TABLE_EXPORT.extend;
        
        IF(item_ds.SOQDST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOQDST;
        ELSIF(item_ds.SOBAST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOBAST;
            END IF;  
        
        IF(item_ds.NGAYQDST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYQDST;
        ELSIF(item_ds.NGAYBAST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYBAST;
            END IF;
               
        IF( item_ds.SOQD IS NOT NULL or item_ds.NGAYQD IS NOT NULL or item_ds.TENQD IS NOT NULL) THEN 
            IF (item_ds.TENQD like '%Quyết định đình chỉ%') THEN
                VKETQUAXXPT := 'QĐ đình chỉ'; 
            ELSIF (item_ds.TENQD like '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN
                
                SELECT LYDOKETQUAID INTO VKETQUAXXPT
                    FROM ADS_PHUCTHAM_QUYETDINH PT_QD
                    WHERE DONID = item_ds.ID;
                    
                IF(VKETQUAXXPT IS NOT NULL) THEN 
                    SELECT TEN INTO VKETQUAXXPT
                    FROM ADS_PHUCTHAM_QUYETDINH PT_QD
                        INNER JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DM_KQ_LD ON DM_KQ_LD.ID = PT_QD.KETQUAID
                    WHERE DONID = item_ds.ID;
                END IF;
            ELSE
                SELECT decode(instr(item_ds.TENQD,'. '), 0, item_ds.TENQD, SUBSTR(item_ds.TENQD, instr(item_ds.TENQD,'. ')+2)) INTO VKETQUAXXPT FROM DUAL; 
            END IF; 
            
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                            'Dân sự',item_ds.SOQD,item_ds.NGAYQD,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                            item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                            item_ds.VDIACHI,item_ds.VKCKN,VKETQUAXXPT); 
     
        ELSE 
        V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                        'Dân sự',item_ds.VSOAN,item_ds.VNGAYXU,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                        item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                        item_ds.VDIACHI,item_ds.VKCKN,item_ds.VKETQUAXXPT);
        END IF;
    END LOOP;
  RETURN V_TABLE_EXPORT;   
END DON_SEARCH_ITEM_DS;
FUNCTION DON_SEARCH_ITEM_HC
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int
)RETURN T_DANHSACH_ADS_MORONG_DAXU
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_EXPORT T_DANHSACH_ADS_MORONG_DAXU;
    VCHUTOA_TEN VARCHAR2(250);
    VTHANHVIEN VARCHAR2(250);
    VVUVIEC VARCHAR2(500);
    VSOBAQDST VARCHAR2(250); VNGAYBAQDST VARCHAR2(250);VKETQUAXXPT VARCHAR(500);
BEGIN
     V_TABLE_EXPORT := T_DANHSACH_ADS_MORONG_DAXU();
     --
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
 FOR item_ds IN (
      SELECT A.ID,A.MAVUVIEC MAVUAN,'<i style="margin-right: 3px">Vụ việc:</i><b>'||A.TENVUVIEC||'</b>'TENVUAN,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO,a.NgayTao NGAY_TAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN, A.MAGIAIDOAN
        ,TENCHUTOA.HOTEN VCHUTOA,PCTP_GQ.HOTEN THAMPHAN_TEN,            
        TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
        BANAN.SOBANAN VSOAN,BANAN.NGAYTUYENAN VNGAYXU,
        TLPT.SOTHULY VSOTHULY, TLPT.NGAYTHULY VNGAYTHULY,
        PTBA.QUANHEPHAPLUAT_NAME VVUVIECBA_NAME,DMPTBA.TEN VVUVIECBA_ID,PTTL.QUANHEPHAPLUAT_NAME VVUVIECTL_NAME,DMPTBA.TEN VVUVIECTL_ID,A.QUANHEPHAPLUAT_NAME VVUVIECDON_NAME,DMDON.TEN VVUVIECDON_ID,
        KETQUAXXPT.TEN VKETQUAXXPT,
        REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
        DS_ND.TENNGUYENDON VNGUYENDON,DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO || NDKNS.NOIDUNGKN VKCKN,
        QDVA.SOQD, QDVA.NGAYQD, QDVA.TEN TENQD,
            QDVAST.SOQD SOQDST, QDVAST.NGAYQD NGAYQDST, QDVAST.TEN TENQDST,
            BANANST.SOBANAN SOBAST, BANANST.NGAYTUYENAN NGAYBAST
      FROM AHC_DON A
            INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
                                
            --------------------------Quyết định gây kết thúc Sơ thẩm và Phúc thẩm-------------------------- 
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM AHC_SOTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID --ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVAST ON QDVAST.DONID = A.ID
                                
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM AHC_PHUCTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID--ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVA ON QDVA.DONID = A.ID  
            LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM AHC_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 
                                   
            left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3   
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3  
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3      
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AHC_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3     
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3                
            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
             LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
                  )GN ON  GN.VUANID=a.ID
                --TEN TOA AN SO THAM 
                  LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                -- VU VIEC 
                  LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTBA.QUANHEPHAPLUATID=DMPTBA.ID

                  LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTTL.QUANHEPHAPLUATID=DMPTBA.ID

                  left join DM_DATAITEM DMDON on DMDON.ID=A.QUANHEPHAPLUATID
                -- THAM PHAN CHU TOA 
                  LEFT JOIN (SELECT DMCANBO.HOTEN, DONID FROM AHC_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                            WHERE D.MAVAITRO LIKE 'THAMPHAN') TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                  LEFT JOIN (SELECT NNPC.HOTEN,NPC.HOTEN HOTEN_LD,GG.* FROM AHC_DON_THAMPHAN GG
                                INNER JOIN (
                                            SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID
                                                FROM (
                                                SELECT TP.DONID ,
                                                LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                                FROM AHC_DON_THAMPHAN TP
                                                WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                                AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                                GROUP BY TP.DONID )TT
                                         )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                         LEFT JOIN DM_CANBO NPC ON NPC.ID=GG.NGUOIPHANCONGID
                      )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                 -- THAM PHAN THANH VIEN HDXX
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN FROM AHC_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                        GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                      
                 -- NỘI DUNG KHÁNG CÁO KHÁNG NGHỊ     
                    LEFT JOIN (     
                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                    from AHC_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                   )F
                                              GROUP BY F.DON_ND
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID

                    LEFT JOIN (SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AHC_SOTHAM_KHANGNGHI KC
                             )NDKN  GROUP BY NDKN.DONID
                    )NDKNS ON NDKNS.DONID=A.ID  
                -- THU KY
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY FROM AHC_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THUKY'
                        GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID
                -- SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ 
                    LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM AHC_PHUCTHAM_BANAN) BANAN ON BANAN.DONID = A.ID 
--                    LEFT JOIN(SELECT SOTHULY,DONID, NGAYTHULY FROM AHC_PHUCTHAM_THULY) THULY ON BANAN.DONID = A.ID 
                -- TÊN ĐƯƠNG SỤ
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON FROM AHC_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
                          GROUP BY  DONID ) DS_ND ON DS_ND.DONID = A.ID 
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON FROM AHC_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'BIDON'
                          GROUP BY  DONID ) DS_BD ON DS_BD.DONID = A.ID           
                -- KẾT QUẢ PHÚC THẨM
                    LEFT JOIN(SELECT DMKQPT.TEN, DONID FROM AHC_PHUCTHAM_BANAN D
                            LEFT JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID) KETQUAXXPT ON KETQUAXXPT.DONID = A.ID 
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND ( EXISTS (
                                                SELECT 'X' FROM AHC_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)
                                            )
                                    )
                 )
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    )
                ) 
            AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
            AND (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID))  
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )        
            AND (V_SOTHULY IS NULL OR(UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
            AND (V_THAMPHAN_ID IS NULL
             OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
             )
            --GQ đơn;V_GQDON -- -- 
            AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
            AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                     )
                )
            ------Loại đơn
            AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
            --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
            AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('01',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('04,06',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )      
             )   
            --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
            --/////////////đối với sơ thẩm          
            AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (  
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr('DC,CVA,HPT,GHTHXX',QDL.MA)>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA) IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA)IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
            --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
            AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND ( EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT  EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
            --Tình trạng GQ;
            AND( (v_TINHTRANG_GIAIQUYET IS NULL AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
              OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND( TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                      --Đang hoãn phuc tham                 
                        EXISTS (
                            SELECT  'X' FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (
                     --phuc tham Đang tạm đình chỉ                
                        EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (   
                            EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND (EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('CVA',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
             --là con của chưa giải quyết xong 
            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                     AND (EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end            
     )
    LOOP
        VCHUTOA_TEN := NULL;
        VVUVIEC := NULL;
         IF(item_ds.VVUVIECBA_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_NAME;
            ELSIF(item_ds.VVUVIECBA_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_ID;
            ELSIF(item_ds.VVUVIECTL_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_NAME;
            ELSIF(item_ds.VVUVIECTL_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_ID;
            ELSE
                VVUVIEC := item_ds.VVUVIECDON_NAME;
            END IF;        

        IF(item_ds.VCHUTOA IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.VCHUTOA;
        ELSIF(item_ds.THAMPHAN_TEN IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.THAMPHAN_TEN;
            END IF;  
        V_TABLE_EXPORT.extend;
                      
        IF(item_ds.SOQDST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOQDST;
        ELSIF(item_ds.SOBAST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOBAST;
            END IF;  
        
        IF(item_ds.NGAYQDST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYQDST;
        ELSIF(item_ds.NGAYBAST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYBAST;
            END IF;
     
        IF( item_ds.SOQD IS NOT NULL or item_ds.NGAYQD IS NOT NULL or item_ds.TENQD IS NOT NULL) THEN 
            IF (item_ds.TENQD like '%Quyết định đình chỉ%') THEN
                VKETQUAXXPT := 'QĐ đình chỉ'; 
            ELSIF (item_ds.TENQD like '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN
                
                SELECT LYDOKETQUAID INTO VKETQUAXXPT
                    FROM AHC_PHUCTHAM_QUYETDINH PT_QD
                    WHERE DONID = item_ds.ID;
                    
                IF(VKETQUAXXPT IS NOT NULL) THEN 
                    SELECT TEN INTO VKETQUAXXPT
                    FROM AHC_PHUCTHAM_QUYETDINH PT_QD
                        INNER JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DM_KQ_LD ON DM_KQ_LD.ID = PT_QD.KETQUAID
                    WHERE DONID = item_ds.ID;
                END IF;
            ELSE
                SELECT decode(instr(item_ds.TENQD,'. '), 0, item_ds.TENQD, SUBSTR(item_ds.TENQD, instr(item_ds.TENQD,'. ')+2)) INTO VKETQUAXXPT FROM DUAL; 
            END IF; 
            
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                            'Hành chính',item_ds.SOQD,item_ds.NGAYQD,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                            item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                            item_ds.VDIACHI,item_ds.VKCKN,VKETQUAXXPT);   
        ELSE 
        V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                        'Hành chính',item_ds.VSOAN,item_ds.VNGAYXU,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                        item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                        item_ds.VDIACHI,item_ds.VKCKN,item_ds.VKETQUAXXPT);
        END IF;
    END LOOP;
  RETURN V_TABLE_EXPORT;   
END DON_SEARCH_ITEM_HC;
FUNCTION DON_SEARCH_ITEM_HN
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int
)RETURN T_DANHSACH_ADS_MORONG_DAXU
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_EXPORT T_DANHSACH_ADS_MORONG_DAXU;
    VCHUTOA_TEN VARCHAR2(250);
    VVUVIEC VARCHAR2(500);
    VSOBAQDST VARCHAR2(250); VNGAYBAQDST VARCHAR2(250);VKETQUAXXPT VARCHAR(500);
BEGIN
     V_TABLE_EXPORT := T_DANHSACH_ADS_MORONG_DAXU();
     
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  

 FOR item_ds IN (
      SELECT A.ID,A.MAVUVIEC MAVUAN,'<i style="margin-right: 3px">Vụ việc:</i><b>'||A.TENVUVIEC||'</b>'TENVUAN,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO,a.NgayTao NGAY_TAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN,A.MAGIAIDOAN
        ,TENCHUTOA.HOTEN VCHUTOA,PCTP_GQ.HOTEN THAMPHAN_TEN,            
        TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
        BANAN.SOBANAN VSOAN,BANAN.NGAYTUYENAN VNGAYXU,
        TLPT.SOTHULY VSOTHULY, TLPT.NGAYTHULY VNGAYTHULY,
        PTBA.QUANHEPHAPLUAT_NAME VVUVIECBA_NAME,DMPTBA.TEN VVUVIECBA_ID,PTTL.QUANHEPHAPLUAT_NAME VVUVIECTL_NAME,DMPTBA.TEN VVUVIECTL_ID,A.QUANHEPHAPLUAT_NAME VVUVIECDON_NAME,DMDON.TEN VVUVIECDON_ID,
        KETQUAXXPT.TEN VKETQUAXXPT,
        REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
        DS_ND.TENNGUYENDON VNGUYENDON,DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO || NDKNS.NOIDUNGKN VKCKN,
        QDVA.SOQD, QDVA.NGAYQD, QDVA.TEN TENQD,
            QDVAST.SOQD SOQDST, QDVAST.NGAYQD NGAYQDST, QDVAST.TEN TENQDST,
            BANANST.SOBANAN SOBAST, BANANST.NGAYTUYENAN NGAYBAST
      FROM AHN_DON A
            INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID           
            --------------------------Quyết định gây kết thúc Sơ thẩm và Phúc thẩm-------------------------- 
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM AHN_SOTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID --ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVAST ON QDVAST.DONID = A.ID
                                
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM AHN_PHUCTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID--ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVA ON QDVA.DONID = A.ID  
            LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM AHN_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 
                                
            left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
            ------Trạng thái giải quyết trong danh sách 
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHN_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHN_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3  
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3      
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AHN_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3     
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3                
            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
             LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
                  )GN ON  GN.VUANID=a.ID
                --TEN TOA AN SO THAM 
                  LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                -- VU VIEC 
                  LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTBA.QUANHEPHAPLUATID=DMPTBA.ID

                  LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTTL.QUANHEPHAPLUATID=DMPTBA.ID

                  left join DM_DATAITEM DMDON on DMDON.ID=A.QUANHEPHAPLUATID
                -- THAM PHAN CHU TOA 
                  LEFT JOIN (SELECT DMCANBO.HOTEN, DONID FROM AHN_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                            WHERE D.MAVAITRO LIKE 'THAMPHAN') TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                  LEFT JOIN (SELECT NNPC.HOTEN,NPC.HOTEN HOTEN_LD,GG.* FROM AHN_DON_THAMPHAN GG
                                INNER JOIN (
                                            SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID
                                                FROM (
                                                SELECT TP.DONID ,
                                                LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                                FROM AHN_DON_THAMPHAN TP
                                                WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                                AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                                GROUP BY TP.DONID )TT
                                         )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                         LEFT JOIN DM_CANBO NPC ON NPC.ID=GG.NGUOIPHANCONGID
                      )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                 -- THAM PHAN THANH VIEN HDXX
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN FROM AHN_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                        GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                      
                 -- NỘI DUNG KHÁNG CÁO KHÁNG NGHỊ     
                    LEFT JOIN (     
                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                    from AHN_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN AHN_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                   )F
                                              GROUP BY F.DON_ND
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID

                    LEFT JOIN (SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AHN_SOTHAM_KHANGNGHI KC
                             )NDKN  GROUP BY NDKN.DONID
                    )NDKNS ON NDKNS.DONID=A.ID  
                -- THU KY
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY FROM AHN_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THUKY'
                        GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID
                -- SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ 
                    LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM AHN_PHUCTHAM_BANAN) BANAN ON BANAN.DONID = A.ID 
                -- TÊN ĐƯƠNG SỤ
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON FROM AHN_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
                          GROUP BY  DONID ) DS_ND ON DS_ND.DONID = A.ID 
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON FROM AHN_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'BIDON'
                          GROUP BY  DONID ) DS_BD ON DS_BD.DONID = A.ID           
                -- KẾT QUẢ PHÚC THẨM
                    LEFT JOIN(SELECT DMKQPT.TEN, DONID FROM AHN_PHUCTHAM_BANAN D
                            LEFT JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID) KETQUAXXPT ON KETQUAXXPT.DONID = A.ID 
         WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (
                                                SELECT 'X' FROM AHN_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)
                                            )
                                    )
                 )
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHN_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    )
                ) 
            AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
            AND (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID))  
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )        
            AND (V_SOTHULY IS NULL OR(UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
            AND (V_THAMPHAN_ID IS NULL
             OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
             )
            --GQ đơn;V_GQDON -- -- 
            AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
            AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                     )
                )
            ------Loại đơn
            AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
            --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
            AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('01',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('04,06',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )      
             )   
            --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
            --/////////////đối với sơ thẩm          
            AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (  
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr('DC,CVA,HPT,GHTHXX',QDL.MA)>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA) IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA)IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
            --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
            AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND (  EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT  EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
            --Tình trạng GQ;
            AND( (v_TINHTRANG_GIAIQUYET IS NULL AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
              OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND( TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                      --Đang hoãn phuc tham                 
                        EXISTS (
                            SELECT  'X' FROM   AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  
                     --phuc tham Đang tạm đình chỉ                
                     EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (  EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND (  EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND (  EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('CVA',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
             --là con của chưa giải quyết xong 
            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                     AND (EXISTS (
                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end            
     )
    LOOP
        VCHUTOA_TEN := NULL;
        VVUVIEC := NULL;
         IF(item_ds.VVUVIECBA_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_NAME;
            ELSIF(item_ds.VVUVIECBA_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_ID;
            ELSIF(item_ds.VVUVIECTL_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_NAME;
            ELSIF(item_ds.VVUVIECTL_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_ID;
            ELSE
                VVUVIEC := item_ds.VVUVIECDON_NAME;
            END IF;        

        IF(item_ds.VCHUTOA IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.VCHUTOA;
        ELSIF(item_ds.THAMPHAN_TEN IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.THAMPHAN_TEN;
            END IF;  

        V_TABLE_EXPORT.extend;
             
        IF(item_ds.SOQDST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOQDST;
        ELSIF(item_ds.SOBAST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOBAST;
            END IF;  
        
        IF(item_ds.NGAYQDST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYQDST;
        ELSIF(item_ds.NGAYBAST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYBAST;
            END IF;

        IF( item_ds.SOQD IS NOT NULL or item_ds.NGAYQD IS NOT NULL or item_ds.TENQD IS NOT NULL) THEN 
            IF (item_ds.TENQD like '%Quyết định đình chỉ%') THEN
                VKETQUAXXPT := 'QĐ đình chỉ'; 
            ELSIF (item_ds.TENQD like '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN
                
                SELECT LYDOKETQUAID INTO VKETQUAXXPT
                    FROM AHN_PHUCTHAM_QUYETDINH PT_QD
                    WHERE DONID = item_ds.ID;
                    
                IF(VKETQUAXXPT IS NOT NULL) THEN 
                    SELECT TEN INTO VKETQUAXXPT
                    FROM AHN_PHUCTHAM_QUYETDINH PT_QD
                        INNER JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DM_KQ_LD ON DM_KQ_LD.ID = PT_QD.KETQUAID
                    WHERE DONID = item_ds.ID;
                END IF;
            ELSE
                SELECT decode(instr(item_ds.TENQD,'. '), 0, item_ds.TENQD, SUBSTR(item_ds.TENQD, instr(item_ds.TENQD,'. ')+2)) INTO VKETQUAXXPT FROM DUAL; 
            END IF; 
            
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                            'Hôn nhân và gia đình',item_ds.SOQD,item_ds.NGAYQD,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                            item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                            item_ds.VDIACHI,item_ds.VKCKN,VKETQUAXXPT);   
        ELSE 
        V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                        'Hôn nhân và gia đình',item_ds.VSOAN,item_ds.VNGAYXU,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                        item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                        item_ds.VDIACHI,item_ds.VKCKN,item_ds.VKETQUAXXPT);
        END IF;
    END LOOP;

  RETURN V_TABLE_EXPORT;   
END DON_SEARCH_ITEM_HN;
FUNCTION DON_SEARCH_ITEM_KT
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int
)RETURN T_DANHSACH_ADS_MORONG_DAXU
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_EXPORT T_DANHSACH_ADS_MORONG_DAXU;
    VCHUTOA_TEN VARCHAR2(250);
    VVUVIEC VARCHAR2(500);
    VSOBAQDST VARCHAR2(250); VNGAYBAQDST VARCHAR2(250);VKETQUAXXPT VARCHAR(500);
BEGIN
     V_TABLE_EXPORT := T_DANHSACH_ADS_MORONG_DAXU();
     --
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  

 FOR item_ds IN (
      SELECT A.ID,A.MAVUVIEC MAVUAN,'<i style="margin-right: 3px">Vụ việc:</i><b>'||A.TENVUVIEC||'</b>'TENVUAN,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO,a.NgayTao NGAY_TAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN,A.MAGIAIDOAN
            ,TENCHUTOA.HOTEN VCHUTOA,PCTP_GQ.HOTEN THAMPHAN_TEN,            
            TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
            BANAN.SOBANAN VSOAN,BANAN.NGAYTUYENAN VNGAYXU,
            TLPT.SOTHULY VSOTHULY, TLPT.NGAYTHULY VNGAYTHULY,
            PTBA.QUANHEPHAPLUAT_NAME VVUVIECBA_NAME,DMPTBA.TEN VVUVIECBA_ID,PTTL.QUANHEPHAPLUAT_NAME VVUVIECTL_NAME,DMPTBA.TEN VVUVIECTL_ID,A.QUANHEPHAPLUAT_NAME VVUVIECDON_NAME,DMDON.TEN VVUVIECDON_ID,
            KETQUAXXPT.TEN VKETQUAXXPT,
            REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
            DS_ND.TENNGUYENDON VNGUYENDON,DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO || NDKNS.NOIDUNGKN VKCKN,
            QDVA.SOQD, QDVA.NGAYQD, QDVA.TEN TENQD,
            QDVAST.SOQD SOQDST, QDVAST.NGAYQD NGAYQDST, QDVAST.TEN TENQDST,
            BANANST.SOBANAN SOBAST, BANANST.NGAYTUYENAN NGAYBAST
      FROM AKT_DON A
            INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
            --------------------------Quyết định gây kết thúc Sơ thẩm và Phúc thẩm-------------------------- 
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM AKT_SOTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID --ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVAST ON QDVAST.DONID = A.ID
                                
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM AKT_PHUCTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID--ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVA ON QDVA.DONID = A.ID 
            LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM AKT_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 
                                
            left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AKT_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AKT_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3       
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3       
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AKT_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3                 
            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
             LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
                  )GN ON  GN.VUANID=a.ID
                --TEN TOA AN SO THAM 
                  LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                -- VU VIEC 
                  LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTBA.QUANHEPHAPLUATID=DMPTBA.ID

                  LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTTL.QUANHEPHAPLUATID=DMPTBA.ID

                  left join DM_DATAITEM DMDON on DMDON.ID=A.QUANHEPHAPLUATID
                -- THAM PHAN CHU TOA 
                  LEFT JOIN (SELECT DMCANBO.HOTEN, DONID FROM AKT_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                            WHERE D.MAVAITRO LIKE 'THAMPHAN') TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                  LEFT JOIN (SELECT NNPC.HOTEN,NPC.HOTEN HOTEN_LD,GG.* FROM AKT_DON_THAMPHAN GG
                                INNER JOIN (
                                            SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID
                                                FROM (
                                                SELECT TP.DONID ,
                                                LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                                FROM AKT_DON_THAMPHAN TP
                                                WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                                AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                                GROUP BY TP.DONID )TT
                                         )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                         LEFT JOIN DM_CANBO NPC ON NPC.ID=GG.NGUOIPHANCONGID
                      )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                 -- THAM PHAN THANH VIEN HDXX
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN FROM AKT_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                        GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                      
                 -- NỘI DUNG KHÁNG CÁO KHÁNG NGHỊ     
                    LEFT JOIN (     
                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                    from AKT_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN AKT_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                   )F
                                              GROUP BY F.DON_ND
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID

                    LEFT JOIN (SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AKT_SOTHAM_KHANGNGHI KC
                             )NDKN  GROUP BY NDKN.DONID
                    )NDKNS ON NDKNS.DONID=A.ID  
                -- THU KY
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY FROM AKT_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THUKY'
                        GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID
                -- SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ 
                    LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM AKT_PHUCTHAM_BANAN) BANAN ON BANAN.DONID = A.ID 
--                    LEFT JOIN(SELECT SOTHULY,DONID, NGAYTHULY FROM AKT_PHUCTHAM_THULY) THULY ON BANAN.DONID = A.ID 
                -- TÊN ĐƯƠNG SỤ
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON FROM AKT_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
                          GROUP BY  DONID ) DS_ND ON DS_ND.DONID = A.ID 
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON FROM AKT_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'BIDON'
                          GROUP BY  DONID ) DS_BD ON DS_BD.DONID = A.ID           
                -- KẾT QUẢ PHÚC THẨM
                    LEFT JOIN(SELECT DMKQPT.TEN, DONID FROM AKT_PHUCTHAM_BANAN D
                            LEFT JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID) KETQUAXXPT ON KETQUAXXPT.DONID = A.ID              
                    
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (
                                                SELECT 'X' FROM AKT_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)
                                            )
                                    )
                 )
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AKT_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    )
                ) 
            AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
            AND (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID))  
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )        
            AND (V_SOTHULY IS NULL OR(UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
            AND (V_THAMPHAN_ID IS NULL
             OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
             )
            --GQ đơn;V_GQDON -- -- 
            AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
            AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AKT_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AKT_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                     )
                )
            ------Loại đơn
            AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
            --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
            AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('01',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('04,06',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )      
             )   
            --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
            --/////////////đối với sơ thẩm          
            AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr('DC,CVA,HPT,GHTHXX',QDL.MA)>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA) IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA)IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
            --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
            AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND ( EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT  EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
            --Tình trạng GQ;
            AND( (v_TINHTRANG_GIAIQUYET IS NULL AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
              OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND( TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                      --Đang hoãn phuc tham                 
                        EXISTS (
                            SELECT  'X' FROM   AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  
                     --phuc tham Đang tạm đình chỉ                
                     EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (  EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND (  EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('CVA',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
             --là con của chưa giải quyết xong 
            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                     AND (EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end            
     )
    LOOP
        VCHUTOA_TEN := NULL;
        VVUVIEC := NULL;
         IF(item_ds.VVUVIECBA_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_NAME;
            ELSIF(item_ds.VVUVIECBA_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_ID;
            ELSIF(item_ds.VVUVIECTL_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_NAME;
            ELSIF(item_ds.VVUVIECTL_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_ID;
            ELSE
                VVUVIEC := item_ds.VVUVIECDON_NAME;
            END IF;        

        IF(item_ds.VCHUTOA IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.VCHUTOA;
        ELSIF(item_ds.THAMPHAN_TEN IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.THAMPHAN_TEN;
            END IF;  
        V_TABLE_EXPORT.extend;   
        
        IF(item_ds.SOQDST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOQDST;
        ELSIF(item_ds.SOBAST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOBAST;
            END IF;  
        
        IF(item_ds.NGAYQDST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYQDST;
        ELSIF(item_ds.NGAYBAST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYBAST;
            END IF;
  
        IF( item_ds.SOQD IS NOT NULL or item_ds.NGAYQD IS NOT NULL or item_ds.TENQD IS NOT NULL) THEN 
            IF (item_ds.TENQD like '%Quyết định đình chỉ%') THEN
                VKETQUAXXPT := 'QĐ đình chỉ'; 
            ELSIF (item_ds.TENQD like '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN
                
                SELECT LYDOKETQUAID INTO VKETQUAXXPT
                    FROM AKT_PHUCTHAM_QUYETDINH PT_QD
                    WHERE DONID = item_ds.ID;
                    
                IF(VKETQUAXXPT IS NOT NULL) THEN 
                    SELECT TEN INTO VKETQUAXXPT
                    FROM AKT_PHUCTHAM_QUYETDINH PT_QD
                        INNER JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DM_KQ_LD ON DM_KQ_LD.ID = PT_QD.KETQUAID
                    WHERE DONID = item_ds.ID;
                END IF;
            ELSE
                SELECT decode(instr(item_ds.TENQD,'. '), 0, item_ds.TENQD, SUBSTR(item_ds.TENQD, instr(item_ds.TENQD,'. ')+2)) INTO VKETQUAXXPT FROM DUAL; 
            END IF; 
            
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                            'Kinh doanh, thương mại',item_ds.SOQD,item_ds.NGAYQD,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                            item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                            item_ds.VDIACHI,item_ds.VKCKN,VKETQUAXXPT); 
        ELSE 
        V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                        'Kinh doanh, thương mại',item_ds.VSOAN,item_ds.VNGAYXU,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                        item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                        item_ds.VDIACHI,item_ds.VKCKN,item_ds.VKETQUAXXPT);
        END IF;
    END LOOP;
  RETURN V_TABLE_EXPORT;   
END DON_SEARCH_ITEM_KT;
FUNCTION DON_SEARCH_ITEM_LD
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int
)RETURN T_DANHSACH_ADS_MORONG_DAXU
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_EXPORT T_DANHSACH_ADS_MORONG_DAXU;
    VCHUTOA_TEN VARCHAR2(250);
    VVUVIEC VARCHAR2(500);
    VSOBAQDST VARCHAR2(250); VNGAYBAQDST VARCHAR2(250);VKETQUAXXPT VARCHAR(500);
BEGIN
     V_TABLE_EXPORT := T_DANHSACH_ADS_MORONG_DAXU();
     --
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  

 FOR item_ds IN (
      SELECT A.ID,A.MAVUVIEC MAVUAN,'<i style="margin-right: 3px">Vụ việc:</i><b>'||A.TENVUVIEC||'</b>'TENVUAN,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO,a.NgayTao NGAY_TAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN, A.MAGIAIDOAN
            ,TENCHUTOA.HOTEN VCHUTOA,PCTP_GQ.HOTEN THAMPHAN_TEN,            
            TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
            BANAN.SOBANAN VSOAN,BANAN.NGAYTUYENAN VNGAYXU,
            TLPT.SOTHULY VSOTHULY, TLPT.NGAYTHULY VNGAYTHULY,
            PTBA.QUANHEPHAPLUAT_NAME VVUVIECBA_NAME,DMPTBA.TEN VVUVIECBA_ID,PTTL.QUANHEPHAPLUAT_NAME VVUVIECTL_NAME,DMPTBA.TEN VVUVIECTL_ID,A.QUANHEPHAPLUAT_NAME VVUVIECDON_NAME,DMDON.TEN VVUVIECDON_ID,
            KETQUAXXPT.TEN VKETQUAXXPT,
            REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
            DS_ND.TENNGUYENDON VNGUYENDON,DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO || NDKNS.NOIDUNGKN VKCKN,
            QDVA.SOQD, QDVA.NGAYQD, QDVA.TEN TENQD,
            QDVAST.SOQD SOQDST, QDVAST.NGAYQD NGAYQDST, QDVAST.TEN TENQDST,
            BANANST.SOBANAN SOBAST, BANANST.NGAYTUYENAN NGAYBAST
      FROM ALD_DON A
            INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
            --------------------------Quyết định gây kết thúc Sơ thẩm và Phúc thẩm-------------------------- 
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM ALD_SOTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID --ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVAST ON QDVAST.DONID = A.ID
                                
            LEFT JOIN (SELECT SOQD, NGAYQD, DONID, TEN FROM ALD_PHUCTHAM_QUYETDINH
                inner join (select id, TEN from dm_qd_quyetdinh 
                                            where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID--ten like '%Quyết định đình chỉ%') dmqd on dmqd.id = QUYETDINHID
                                ) QDVA ON QDVA.DONID = A.ID                                 
            LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM ALD_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 
                                
            left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM ALD_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM ALD_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3  
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3    
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM ALD_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3                
            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
             LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
                  )GN ON  GN.VUANID=a.ID
                --TEN TOA AN SO THAM 
                  LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                -- VU VIEC 
                  LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTBA.QUANHEPHAPLUATID=DMPTBA.ID
                  LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID = A.ID
                  left join DM_DATAITEM DMPTBA on PTTL.QUANHEPHAPLUATID=DMPTBA.ID
                  left join DM_DATAITEM DMDON on DMDON.ID=A.QUANHEPHAPLUATID
                -- THAM PHAN CHU TOA 
                  LEFT JOIN (SELECT DMCANBO.HOTEN, DONID FROM ALD_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                            WHERE D.MAVAITRO LIKE 'THAMPHAN') TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                  LEFT JOIN (SELECT NNPC.HOTEN,NPC.HOTEN HOTEN_LD,GG.* FROM ALD_DON_THAMPHAN GG
                                INNER JOIN (
                                            SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID
                                                FROM (
                                                SELECT TP.DONID ,
                                                LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                                FROM ALD_DON_THAMPHAN TP
                                                WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                                AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                                GROUP BY TP.DONID )TT
                                         )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                         LEFT JOIN DM_CANBO NPC ON NPC.ID=GG.NGUOIPHANCONGID
                      )PCTP_GQ ON PCTP_GQ.DONID=A.ID
                 -- THAM PHAN THANH VIEN HDXX
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN FROM ALD_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                        GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                      
                 -- NỘI DUNG KHÁNG CÁO KHÁNG NGHỊ     
                    LEFT JOIN (     
                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                    from ALD_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN ALD_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                   )F
                                              GROUP BY F.DON_ND
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID

                    LEFT JOIN (SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM ALD_SOTHAM_KHANGNGHI KC
                             )NDKN  GROUP BY NDKN.DONID
                    )NDKNS ON NDKNS.DONID=A.ID  
                -- THU KY
                    LEFT JOIN(SELECT DONID,LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY FROM ALD_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THUKY'
                        GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID
                -- SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ 
                    LEFT JOIN(SELECT SOBANAN,DONID, NGAYTUYENAN FROM ALD_PHUCTHAM_BANAN) BANAN ON BANAN.DONID = A.ID 
                -- TÊN ĐƯƠNG SỤ
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON FROM ALD_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
                          GROUP BY  DONID ) DS_ND ON DS_ND.DONID = A.ID 
                    LEFT JOIN(SELECT DONID,LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON FROM ALD_DON_DUONGSU
                          WHERE TUCACHTOTUNG_MA = 'BIDON'
                          GROUP BY  DONID ) DS_BD ON DS_BD.DONID = A.ID  
                -- KẾT QUẢ PHÚC THẨM
                    LEFT JOIN(SELECT DMKQPT.TEN, DONID FROM ALD_PHUCTHAM_BANAN D
                            LEFT JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID) KETQUAXXPT ON KETQUAXXPT.DONID = A.ID                         
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (
                                                SELECT 'X' FROM ALD_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)
                                            )
                                    )
                 )
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM ALD_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    )
                ) 
            AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
            AND (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID))  
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )        
            AND (V_SOTHULY IS NULL OR(UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
            AND (V_THAMPHAN_ID IS NULL
             OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
             )
            --GQ đơn;V_GQDON -- -- 
            AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
            AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from ALD_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from ALD_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                     )
                )
            ------Loại đơn
            AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
            --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
            AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('01',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('04,06',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )      
             )   
            --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
            --/////////////đối với sơ thẩm          
            AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (  
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr('DC,CVA,HPT,GHTHXX',QDL.MA)>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                          --phúc thẩm   
                             EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA) IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                          --phúc thẩm   
                            EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr('DC,CVA,HPT,GHTHXX',QDL.MA)=0 OR instr('DC,CVA,HPT,GHTHXX',QDL.MA)IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
            --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
            AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND ( EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND (  NOT  EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
            --Tình trạng GQ;
            AND( 
            
            (v_TINHTRANG_GIAIQUYET IS NULL AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
             OR (v_TINHTRANG_GIAIQUYET = 0 AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
            
              OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    ( EXISTS (
                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND( TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND ((PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                      --Đang hoãn phuc tham                 
                         EXISTS (
                            SELECT  'X' FROM   ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   ( 
                     --phuc tham Đang tạm đình chỉ                
                        EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND ( EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND (  EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('DC',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                    WHERE  instr('CVA',QDL.MA)>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
             --là con của chưa giải quyết xong 
            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                     AND ( EXISTS (
                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end            
     )
    LOOP
        VCHUTOA_TEN := NULL;
        VVUVIEC := NULL;
         IF(item_ds.VVUVIECBA_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_NAME;
            ELSIF(item_ds.VVUVIECBA_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECBA_ID;
            ELSIF(item_ds.VVUVIECTL_NAME IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_NAME;
            ELSIF(item_ds.VVUVIECTL_ID IS NOT NULL) THEN
                VVUVIEC := item_ds.VVUVIECTL_ID;
            ELSE
                VVUVIEC := item_ds.VVUVIECDON_NAME;
            END IF;        

        IF(item_ds.VCHUTOA IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.VCHUTOA;
        ELSIF(item_ds.THAMPHAN_TEN IS NOT NULL) THEN
            VCHUTOA_TEN := item_ds.THAMPHAN_TEN;
            END IF;  

        V_TABLE_EXPORT.extend;
                
        IF(item_ds.SOQDST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOQDST;
        ELSIF(item_ds.SOBAST IS NOT NULL) THEN
            VSOBAQDST := item_ds.SOBAST;
            END IF;  
        
        IF(item_ds.NGAYQDST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYQDST;
        ELSIF(item_ds.NGAYBAST IS NOT NULL) THEN
            VNGAYBAQDST := item_ds.NGAYBAST;
            END IF;
  
        IF( item_ds.SOQD IS NOT NULL or item_ds.NGAYQD IS NOT NULL or item_ds.TENQD IS NOT NULL) THEN 
            IF (item_ds.TENQD like '%Quyết định đình chỉ%') THEN
                VKETQUAXXPT := 'QĐ đình chỉ'; 
            ELSIF (item_ds.TENQD like '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN
                
                SELECT LYDOKETQUAID INTO VKETQUAXXPT
                    FROM ALD_PHUCTHAM_QUYETDINH PT_QD
                    WHERE DONID = item_ds.ID;
                    
                IF(VKETQUAXXPT IS NOT NULL) THEN 
                    SELECT TEN INTO VKETQUAXXPT
                    FROM ALD_PHUCTHAM_QUYETDINH PT_QD
                        INNER JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DM_KQ_LD ON DM_KQ_LD.ID = PT_QD.KETQUAID
                    WHERE DONID = item_ds.ID;
                END IF;
            ELSE
                SELECT decode(instr(item_ds.TENQD,'. '), 0, item_ds.TENQD, SUBSTR(item_ds.TENQD, instr(item_ds.TENQD,'. ')+2)) INTO VKETQUAXXPT FROM DUAL; 
            END IF; 
            
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                            'Lao động',item_ds.SOQD,item_ds.NGAYQD,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                            item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                            item_ds.VDIACHI,item_ds.VKCKN,VKETQUAXXPT); 
        ELSE 
        V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_ADS_MORONG_DAXU(VCHUTOA_TEN,item_ds.VTHANHVIEN,item_ds.VTHUKY,
                                                                        'Lao động',item_ds.VSOAN,item_ds.VNGAYXU,item_ds.VSOTHULY,item_ds.VNGAYTHULY,
                                                                        item_ds.VNGUYENDON,item_ds.VBIDON,VVUVIEC,VSOBAQDST,VNGAYBAQDST,
                                                                        item_ds.VDIACHI,item_ds.VKCKN,item_ds.VKETQUAXXPT);
        END IF;
    END LOOP;

  RETURN V_TABLE_EXPORT;   
END DON_SEARCH_ITEM_LD;
FUNCTION DON_SEARCH_ITEM_HS
(   V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_Capxx in varchar2,
    v_toaan_id in varchar2, 
    v_TINHTRANG_THULY in varchar2,
    V_NGAYTHULY_TU in varchar2,
    V_NGAYTHULY_DEN in varchar2,
    v_SOTHULY in varchar2,
    v_TINHTRANG_GIAIQUYET in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_KETQUA in varchar2,
    v_so_qd in varchar2,
    v_ngay_qd in varchar2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2, 
    v_THOIHAN_GQ in varchar2, 
    v_QD_TAMGIAM in varchar2,
    V_UTTP IN VARCHAR2,
    Page_Index in   int,
    Page_Size   in  int
)RETURN T_DANHSACH_AHS_DAXU
AS
    TotalItem number;  MinIndex number; MaxIndex number;
    VV_TUNGAY DATE;VV_DENNGAY DATE;  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;  
    V_TABLE_EXPORT T_DANHSACH_AHS_DAXU;
    VCHUTOA_TEN VARCHAR2(250);
    V_CURSOR sys_refcursor; 
    V_KQXXPT CLOB;
    V_KQXXST CLOB;
    V_HOTEN CLOB DEFAULT '';
    V_TENTOIDANH CLOB DEFAULT '';
    V_SOBCKC NUMBER DEFAULT 0;
    VSOBAQDST VARCHAR2(250); VNGAYBAQDST VARCHAR2(250); VKETQUAXXPT VARCHAR(500);
    
----------------------------------------------------------------------------    
    VVCHUTOA VARCHAR2(250); 
    VTHAMPHAN_TEN VARCHAR2(2000);
    VV_THUKY VARCHAR2(2000);
    VV_THANHVIEN VARCHAR2(2000);
    VV_KCKN CLOB; -- Kháng cáo kháng nghị
    VSOQUYETDINH VARCHAR2(50);
    VNGAYQD VARCHAR2(250);
    VTENQD VARCHAR2(250);
    VSOQDST VARCHAR2(250);
    VNGAYQDST VARCHAR2(250);
----------------------------------------------------------------------------   
    
    
    ----------------------------------------------------------------------------  
    V_TABLE_TLST T_QUYETDINH;V_TABLE_TLPT T_QUYETDINH;
    V_TABLE_HDXX_ST T_QUYETDINH;V_TABLE_HDXX_PT T_QUYETDINH;  
    V_TABLE_TP T_QUYETDINH;
    V_TABLE_ST T_QUYETDINH;V_TABLE_PT T_QUYETDINH;
    V_TABLE_BC T_AHS_BICANBICAO; V_TABLE_BC_KC T_AHS_BICANBICAO; 
    ----------------------------------------------------------------------------
    
BEGIN   
        V_TABLE_EXPORT := T_DANHSACH_AHS_DAXU();

        if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
        if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
        --
        if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
        if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
        
        
       ----------------------------------------------------------------------------
       V_TABLE_TLST := T_QUYETDINH();  V_TABLE_TLPT := T_QUYETDINH();
       V_TABLE_HDXX_ST := T_QUYETDINH(); V_TABLE_HDXX_PT := T_QUYETDINH();   
       V_TABLE_TP := T_QUYETDINH();
       V_TABLE_ST := T_QUYETDINH();V_TABLE_PT := T_QUYETDINH();
       V_TABLE_BC := T_AHS_BICANBICAO();V_TABLE_BC_KC := T_AHS_BICANBICAO();
       
       
       ------------------tao bang tam lay 1 ban ghi moi nhat
      --AHS_SOTHAM_THULY
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHS_SOTHAM_THULY 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;
         --AHS_PHUCTHAM_THULY
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHS_PHUCTHAM_THULY 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;   
        --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(CANBOID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC) ID
                 FROM  AHS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(CANBOID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC) ID
                 FROM  AHS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;  
        ---THAMPHAN giai quyet
       SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  AHS_THAMPHANGIAIQUYET 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;    
      --AHS_SOTHAM_QUYETDINH_VUAN
      SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.VUANID,TT.ID,TT.MA FROM (  
                  SELECT PQD.VUANID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.VUANID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHS_SOTHAM_QUYETDINH_VUAN PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.VUANID,TT.ID,TT.MA
                )TTS;
         --AHS_PHUCTHAM_QUYETDINH_VUAN
         SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.VUANID,TT.ID,TT.MA FROM (  
                  SELECT PQD.VUANID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.VUANID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.VUANID,TT.ID,TT.MA
                )TTS;
      ---V_TABLE_BC; tạo bảng lấy <=3 bị cáo: 1 đầu vụ và 2 bị cáo tiếp theo     
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT ID,VUANID,HOTEN,BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY VUANID ORDER BY BICANDAUVU DESC,NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO 
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=3
            )TTS;       
      ---V_TABLE_BC; tạo bảng  lấy <=3 bị cáo khang cao
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT DISTINCT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO B
                        WHERE EXISTS(SELECT 'X' FROM AHS_SOTHAM_KHANGCAO KC WHERE KC.NGUOIKCID=B.ID AND KC.VUANID=B.VUANID)
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=3
            )TTS;             
       ----------------------------------------------------------------------------
        
    ------------------
     FOR item_hs IN (
      SELECT 
            A.ID VUANID
            ,BAST.SOBANAN SOBAST, BAST.NGAYBANAN NGAYBAST
            ,BAPT.SOBANAN V_SOAN, BAPT.NGAYBANAN V_NGAYXU
            ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)V_SOTHULY
            ,DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY)V_NGAYTHULY
            ,REPLACE(B.TEN,'Tòa án nhân dân t', 'T') V_DIACHI
            
            FROM AHS_VUAN A
            
            --INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
            INNER JOIN (SELECT G.* FROM AHS_VUAN_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.VUANID
            LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (
                       SELECT TL.VUANID,TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy') NGAYTHULY,'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                           TINHTRANG_GQ FROM AHS_SOTHAM_THULY TL
                           WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=TL.ID)
                           GROUP BY TL.VUANID,TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy'),'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                       )TLS ON A.ID=TLS.VUANID AND GD.MAGIAIDOAN=2

            LEFT JOIN ( SELECT TL.VUANID,TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')NGAYTHULY,'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                          TINHTRANG_GQ FROM AHS_PHUCTHAM_THULY TL 
                          WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=TL.ID)
                          GROUP BY TL.VUANID,TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy'),'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                      )TLPT ON A.ID=TLPT.VUANID AND GD.MAGIAIDOAN=3

            LEFT JOIN ( SELECT TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AHS_THAMPHANGIAIQUYET TP
                        LEFT JOIN (SELECT VUANID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.VUANID=TP.VUANID
                          ----anhvh add 08/07/2021 hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHS_THAMPHANGIAIQUYET GG
                                     WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                    )PCTP_GQ ON PCTP_GQ.VUANID=TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                       )TPPC ON TPPC.VUANID=A.ID AND GD.MAGIAIDOAN=2

            LEFT JOIN (  SELECT TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AHS_THAMPHANGIAIQUYET TP
                        LEFT JOIN (SELECT VUANID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.VUANID=TP.VUANID
                        LEFT JOIN (SELECT GG.* FROM AHS_THAMPHANGIAIQUYET GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.VUANID=TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                       )TPPCPT ON TPPCPT.VUANID=A.ID AND GD.MAGIAIDOAN=3

            LEFT JOIN (SELECT QSV.VUANID,'</br>- QĐ HPT số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.VUANID,'</br>- QĐ HPT số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                      )HPT ON HPT.VUANID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN ( SELECT PTQDVA.VUANID,'</br>- QĐ HPT số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.VUANID,'</br>- QĐ HPT số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.VUANID=A.id  AND GD.MAGIAIDOAN=3
            LEFT JOIN (
                        SELECT QSV.VUANID,'</br>- QĐ TĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND  instr(',TDC,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.VUANID,'</br>- QĐ TĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )TDC ON  TDC.VUANID=A.id AND GD.MAGIAIDOAN=2

            LEFT JOIN ( SELECT PTQDVA.VUANID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                        FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND instr(',TDC,',','||QDL.MA||',')>0  ) 
                        GROUP BY PTQDVA.VUANID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                       )TDCPT ON  TDCPT.VUANID=A.id AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                        SELECT BA.VUANID,BA.SOBANAN,BA.NGAYBANAN,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy') TINHTRANG_GQ FROM AHS_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.VUANID,BA.SOBANAN,BA.NGAYBANAN,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy')
                        )BAST ON  BAST.VUANID=a.id-- AND GD.MAGIAIDOAN=2

             LEFT JOIN ( SELECT PTBA.VUANID,PTBA.SOBANAN,PTBA.NGAYBANAN,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYBANAN,'dd/MM/yyyy') TINHTRANG_GQ FROM AHS_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.VUANID,PTBA.SOBANAN,PTBA.NGAYBANAN,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYBANAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.VUANID=a.id --AND GD.MAGIAIDOAN=3

             LEFT JOIN (SELECT QSV.VUANID,'</br>- QĐ ĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.VUANID,'</br>- QĐ ĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.VUANID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.VUANID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.VUANID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.VUANID=a.id AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                   SELECT QSV.VUANID,'</br>- QĐ CVA số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                   FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                   WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                   GROUP BY QSV.VUANID,'</br>- QĐ CVA số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )CST ON  CST.VUANID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                  SELECT PTQDVA.VUANID,'</br>- QĐ CVA số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                  FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                  WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                  GROUP BY PTQDVA.VUANID,'</br>- QĐ CVA số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                 )CPT ON  CPT.VUANID=a.id AND GD.MAGIAIDOAN=3  

           -------Đã chuyển vụ án; trường hợp giao nhận add vào cột trạng thái          
           LEFT JOIN (SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2             

            -------trường hợp giao nhân dùng cho sơ thẩm với viện kiểm sát
            LEFT JOIN (SELECT A1.ID, DECODE(A1.TruongHopGiaoNhan,1, 'VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm',2,'Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung',3, 'Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung',''
                       ) TruongHopGiaoNhan  FROM AHS_VUAN A1) AA ON AA.ID=A.ID

            -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
                      )GN ON  GN.VUANID=a.ID

            ------bị cáo lấy cho sơ thẩm
            LEFT JOIN( SELECT BC.VUANID,'<br/><i>Bị cáo:</i> <br />'
                        ||LISTAGG(DECODE(BC.BICANDAUVU,1,'<b>'||BC.HOTEN ||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)||' (đầu vụ)</b>',BC.HOTEN||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)),'<br/>') 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)HOTEN FROM  TABLE(V_TABLE_BC) BC
                        GROUP BY BC.VUANID   
                 ) BC2 ON BC2.VUANID=A.ID      

             ------bị cáo kháng cáo lấy cho phúc thẩm 
            LEFT JOIN(SELECT BC.VUANID,'<br/><i>Bị cáo kháng cáo:</i> <br />'
                        ||LISTAGG(DECODE(BC.BICANDAUVU,1,'<b>'||BC.HOTEN ||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)||' (đầu vụ)</b>',BC.HOTEN||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)),'<br/>') 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)HOTEN FROM  TABLE(V_TABLE_BC_KC) BC
                        GROUP BY BC.VUANID 
                 )BC3 ON BC3.VUANID=A.ID
           
            ------- lấy thông tin số ngày kháng nghị
--           LEFT JOIN ( SELECT KN.VUANID,
--                     '<br /><i>Kháng nghị:</i> <br />'|| 
--                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
--                      FROM  AHS_SOTHAM_KHANGNGHI KN
--                      GROUP BY KN.VUANID
--              )STKN ON STKN.VUANID=A.ID 
            LEFT JOIN (SELECT NDKN.VUANID,LISTAGG(NDKN.NOIDUNGKN, ', ')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (
                                    SELECT KC.VUANID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN
                                    FROM AHS_SOTHAM_KHANGNGHI KC
                                    LEFT JOIN AHS_SOTHAM_KHANGCAO_YEUCAU T5 ON T5.KHANGCAOID=KC.ID
                             )NDKN  GROUP BY NDKN.VUANID
               )STKN ON STKN.VUANID=A.ID
               
               
               
                           ------- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.VUANID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHS_SOTHAM_BANAN BA)STBA ON STBA.VUANID=A.ID 

            -------
            WHERE (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )
                 AND (V_UTTP IS NULL
                         OR (V_UTTP IS NOT NULL 
                          AND ( EXISTS ( SELECT 'X' FROM AHS_SOTHAM_THULY TL
                                            WHERE TL.UTTPDI = to_number(V_UTTP) and TL.VUANID = A.ID AND GD.MAGIAIDOAN=2)
                                       OR  EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_THULY TLPT 
                                          WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.VUANID = A.ID AND GD.MAGIAIDOAN=3)
                            )  ) )
                AND (V_TOIDANH IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TOIDANH)||'%' ) )--tìm tội danh đã được gắn vào tên vụ án
                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
                 AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  LOWER(V_MA_VU_AN) ) )
                AND (V_BI_CAN IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_BI_CAN))||'%' AND BC.VUANID=A.ID)
                    )                
            -----
                  AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))
                    OR(v_TINHTRANG_THULY=1 --đã thụ lý
                         AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                                           ) 
                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                          )   )  ) 
                    OR(v_TINHTRANG_THULY=2 --chưa thụ lý
                     AND ( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
                        )
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)      
                    )
                )
              -----
              AND (v_SOTHULY IS NULL
                OR(    EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
                    OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
                  )
               )
              AND (V_SO_QD IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                     )
                 )
              AND (v_ngay_qd IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                     )
                 )    
              --KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=PTTL.VUANID --QUYẾT ĐỊNH 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT HP ON HP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PTBA.KETQUAPHUCTHAMID 
                                WHERE KQPT.MA='01'--HP.MAHINHPHAT!='TUHINH' AND
                                AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                OR (v_KETQUA=2 --Tăng hình phạt
                    AND ( EXISTS(
                                SELECT 'X' FROM  AHS_PHUCTHAM_THULY PTTL
                                LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                WHERE STHP.LOAIHINHPHAT=PTHP.LOAIHINHPHAT--PTHP.MAHINHPHAT!='TUHINH' AND -- tương đương với trường hợp bắt buộc phải nhập hình phạt
                                AND STHP.ID=PTHP.ID
                                AND( (STBACT.SH_VALUE <PTBACT.SH_VALUE OR STBACT.TG_NAM+STBACT.TG_THANG/12+STBACT.TG_NGAY/365<PTBACT.TG_NAM+PTBACT.TG_THANG/12+PTBACT.TG_NGAY/365) --SO SÁNH TỐNG ÁN PHẠT (tăng)
                                     OR(STHP.MUCDO <PTHP.MUCDO)
                                   )
                                   --Tăng hình phạt --Chuyển hình phạt khác nặng hơn
                                AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                          )
                    OR EXISTS (--Tăng lên hình phạt tử hình
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                LEFT JOIN  AHS_BICANBICAO BC ON PTTL.VUANID=BC.VUANID -- BỊ CAN 
                                LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                WHERE STHP.MAHINHPHAT!='TUHINH' AND PTHP.MAHINHPHAT='TUHINH'
                                AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                             )
                       ) 
                   )
                   OR (v_KETQUA=3 --Giảm hình phạt
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                    LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                    LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                    LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                    WHERE --PTHP.MAHINHPHAT!='TUHINH' AND
                                     STHP.LOAIHINHPHAT=PTHP.LOAIHINHPHAT
                                    AND STHP.ID=PTHP.ID
                                    AND (   (STBACT.SH_VALUE >PTBACT.SH_VALUE OR STBACT.TG_NAM+STBACT.TG_THANG/12+STBACT.TG_NGAY/365>PTBACT.TG_NAM+PTBACT.TG_THANG/12+PTBACT.TG_NGAY/365) --SO SÁNH TỐNG ÁN PHẠT (giảm)--SO SÁNH TỐNG ÁN PHẠT (giảm)
                                        OR (STHP.MUCDO >PTHP.MUCDO)
                                        )
                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                    AND PTTL.VUANID=A.ID AND GD.MAGIAIDOAN=3  
                                )
                             OR EXISTS (
                                        SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                        LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                        LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                        LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                        LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                        LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                        WHERE STHP.MAHINHPHAT='TUHINH' AND PTHP.MAHINHPHAT!='TUHINH'
                                        AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                        AND PTTL.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                    )
                            )
                     )
                  OR (v_KETQUA=4 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=PTTL.VUANID --QUYẾT ĐỊNH 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT HP ON HP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PTBA.KETQUAPHUCTHAMID 
                                WHERE --HP.MAHINHPHAT!='TUHINH' AND
                                KQPT.MA IN ('03','04','06','13','14','12')
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTTL.VUANID=A.ID AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=5
                     --Sửa phần dân sự bao gồm (Sửa phần bồi thường thiệt hại và quyết định xử lý vật chứng;Sửa các phần khác)
                     --các tiêu chí này tại cột 51 và 52 của báo cáo thống kê mẫu 1 
                   AND EXISTS(
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=PTTL.VUANID --QUYẾT ĐỊNH 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT HP ON HP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                WHERE --HP.MAHINHPHAT!='TUHINH' AND -- tương đương với trường hợp bắt buộc phải nhập hình phạt
                                 (PTBA.TK_BOITHUONGTH=1 OR PTBA.TK_SUAKHAC=1)
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )  
                )
           AND (v_thamphan_id is null
                   OR(    
                       EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
                      -- OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID) 
                       OR 
                       EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
                     )
                )
           AND (v_thuky_id is null
                   OR( EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID) 
                      -- OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID)
                        OR EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tsp where tsp.THUKYID = v_thuky_id and tsp.VuAnID=a.ID)
                     )
                )
          --v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
           --/////////////đối với sơ thẩm     
          --Mức độ nghiêm trọng:
          --ít nghiêm trọng >45 ngày là hết hạn; nghiêm trọng >60 ngày; rất nghiêm trọng >90 ngày; 
          --đặc biệt nghiêm trọng >120 ngày
          ---->mốc để tính quá hạn là ngày bản án, hoặc quyết định kết thúc vụ án, hoặc quyết định gia hạn
          --Quyết định gia hạn chưa cần cộng thêm vào mốc ngày bắt đầu vì nếu có gia hạn thì cũng vẫn trong khoảng giới hạn mặc đinh đã có ví dụ 45 là ngày hạn mặc đinh
          --////đối với phúc thẩm chỉ cần so sánh ngày thụ lý với ngày hiện tại >90 ngày thì là đã hết hạn
          AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                      AND(
                           --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS( SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =TL.VUANID
                                    WHERE
                                    (
                                        ( BA.ID IS NOT NULL
                                           AND (   ( (BA.NGAYBANAN-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                                  )
                                        )
                                        OR( (BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0)
                                          AND (        ( (SYSDATE-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                             )
                                         )
                                    )
                                    --AND TL.ID IS NOT NULL 
                                    AND VA.ID =a.id AND GD.MAGIAIDOAN=2
                                  )
                             --dùng ngày quyết định đình chỉ vụ án     
                            OR  EXISTS (
                                        SELECT 'X' FROM  AHS_VUAN VA
                                        INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                        LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                       (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                        AND  (   ( (QSV.NGAYQD-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89  )
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                          )
                                       )
                                       OR
                                        (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0
                                      AND  (   ( (SYSDATE-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                         )
                                       )
                                    )
                                  --AND TL.ID IS NOT NULL 
                                  AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                 )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (PTBA.ID IS NOT NULL  AND  (PTBA.NGAYBANAN-TL.NGAYTHULY)>90 )
                                     OR (PTBA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
--                                     AND TL.ID IS NOT NULL 
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=3
                                    ) 
                             --dùng ngày QĐ phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE
                                     --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(PTQDVA.NGAYQD-TL.NGAYTHULY)>90 )
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
--                                     AND TL.ID IS NOT NULL 
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    )               
                        )
                  )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                      AND(
                           --Sơ thẩm
                            EXISTS(SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =VA.ID
                                    LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (   ( (SYSDATE-TL.NGAYTHULY)>=35 AND (SYSDATE-TL.NGAYTHULY)<45  AND VA.LOAITOIPHAMID=89  )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=50 AND (SYSDATE-TL.NGAYTHULY)<60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=110 AND (SYSDATE-TL.NGAYTHULY)<120 AND VA.LOAITOIPHAMID=92)
                                          )
                                    AND BA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                  )
                              --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND PTBA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    ) 
                           )
                  )
                   OR (v_THOIHAN_GQ=3   AND(--Còn thời hạn dưới 20 ngày
                           --Sơ thẩm
                            EXISTS(SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =VA.ID
                                    LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (   ( (SYSDATE-TL.NGAYTHULY)>=25 AND (SYSDATE-TL.NGAYTHULY)<45  AND VA.LOAITOIPHAMID=89  )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=40 AND (SYSDATE-TL.NGAYTHULY)<60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=100 AND (SYSDATE-TL.NGAYTHULY)<120 AND VA.LOAITOIPHAMID=92)
                                          )
                                    AND BA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                  )
                              --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND PTBA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    ) 
                           )
              )
          )  
          --BTG bắt tạm giam
          AND (v_QD_TAMGIAM IS NULL
               OR ( v_QD_TAMGIAM=1
                   AND(  EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                            LEFT JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM ( SELECT QSV.* FROM AHS_SOTHAM_QUYETDINH_BICAN QSV
                                                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                            WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                            ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                              (QSV2.HIEULUCDEN-SYSDATE)<0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=2
                            )
                         OR EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_VUAN_GIAIDOAN VGD ON VA.ID=VGD.VUANID
                            INNER JOIN AHS_PHUCTHAM_THULY TL ON VA.ID=TL.VUANID 
                            INNER JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM 
                                                         ( SELECT QSV.* FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV
                                                           LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                                           LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                           WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                           ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                             (QSV2.HIEULUCDEN-SYSDATE)<0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=3
                            )   
                      )
                   )
                 --Còn thời hạn dưới 10 ngày  
                OR ( v_QD_TAMGIAM=2
                   AND(  EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                            LEFT JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM ( SELECT QSV.* FROM AHS_SOTHAM_QUYETDINH_BICAN QSV
                                                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                            WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                            ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                              (QSV2.HIEULUCDEN-SYSDATE)<10 AND (QSV2.HIEULUCDEN-SYSDATE)>0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=2
                            )
                         OR EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_PHUCTHAM_THULY TL ON VA.ID=TL.VUANID 
                            INNER JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM 
                                                         ( SELECT QSV.* FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV
                                                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                            WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                            ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                             (QSV2.HIEULUCDEN-SYSDATE)<10  AND (QSV2.HIEULUCDEN-SYSDATE)>0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=3
                            )   
                      )
                   )   
              )
            -----------------v_TINHTRANG_GIAIQUYET
            AND ( (v_TINHTRANG_GIAIQUYET IS NULL  AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
                OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    ( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,TRAHS,',','||QDL.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,TRAHS,',','||QDL.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                   )
                 OR(v_TINHTRANG_GIAIQUYET=11 --chưa chuyển Ho so qua VKS và chưa ket thuc
                    AND NOT EXISTS (
                                SELECT 'x' FROM HOSO_PT hs
                                WHERE hs.VUANID=A.ID 
                                AND hs.LOAIAN = 1 -- an Hinh su
                                AND hs.LOAI_CN = 1 -- chuyển VKS
                                AND (V_TUNGAY IS NULL OR  hs.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR hs.NGAY_NC<=VV_DENNGAY)
                            )
                        
                    ) 
                
                 OR(v_TINHTRANG_GIAIQUYET=12 --Đã chuyển Ho so qua VKS và chưa ket thuc
                    AND EXISTS (
                                SELECT 'x' FROM HOSO_PT hs
                                WHERE hs.VUANID=A.ID 
                                AND hs.LOAIAN = 1 -- an Hinh su
                                AND hs.LOAI_CN = 1 -- chuyển VKS
                                AND (V_TUNGAY IS NULL OR  hs.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR hs.NGAY_NC<=VV_DENNGAY)
                            )
                    ) 
                  OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                    AND NOT EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )
                       AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) 
                    )
                   OR(v_TINHTRANG_GIAIQUYET=3 --Đã phân công Thẩm phán
                    AND  EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND (
                                     (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                                AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)       
                               )
                    )  
                OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                     EXISTS (
                                SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE INSTR(',HPT,',','||QDL.MA||',')>0 --hoãn phiên tòa
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.VUANID=a.id  AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT 'X' FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR(',HPT,',','||QDL.MA||',')>0 --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=a.id  AND GD.MAGIAIDOAN=3
                        ) 
                    )
                )
                OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR(',TDC,',','||QDL.MA||',')>0 -- 'TDC' Tam dinh chi
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.VUANID =A.ID  AND GD.MAGIAIDOAN=2
                             )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE INSTR(',TDC,',','||QDL.MA||',')>0 --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                        )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (   
                           EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                                WHERE BA.ID IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  BA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYBANAN<=VV_DENNGAY)
                                    AND BA.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                     SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE    instr(',DC,CVA,TRAHS,',','||QDL.MA||',')>0
                                          AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                          AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                          AND QSV.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_BANAN PTBA
                                    WHERE  PTBA.ID IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                    AND PTBA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,TRAHS,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                     OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHS_SOTHAM_BANAN BA
                                    WHERE BA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR  BA.NGAYBANAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR BA.NGAYBANAN<=VV_DENNGAY)
                                        AND BA.VUANID=a.id AND GD.MAGIAIDOAN=2
                                 )
                             OR EXISTS (
                                    SELECT 'X' FROM  AHS_PHUCTHAM_BANAN PTBA 
                                    WHERE   PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                    AND PTBA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )    
                            )
                     )
                  OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE   instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.VUANID =A.ID AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                WHERE  instr(',DC,',','||QDL.MA||',')>0
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTQDVA.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )
                      OR(v_TINHTRANG_GIAIQUYET=10 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE  QDL.MA='CVA'
                                    AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.VUANID =A.ID AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AHS_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id  AND GD.MAGIAIDOAN=2)
                         OR EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE  instr(',CVA,',','||QDL.MA||',')>0
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTQDVA.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )
              )
              -- END v_TINHTRANG_GIAIQUYET
               --là con của chưa giải quyết xong  
               AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                    AND( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                    )   
                )
        )
     LOOP 
        PKG_STPT_HS_TONGHOPHINHPHAT.AHS_RETURN_ALL_HINHPHAT_BICAN(item_hs.VUANID,V_CURSOR);
        LOOP 
        FETCH V_CURSOR 
            INTO      V_KQXXST,V_KQXXPT,V_HOTEN,V_TENTOIDANH,V_SOBCKC;
            EXIT WHEN V_CURSOR%NOTFOUND;
        END LOOP;    
        CLOSE V_CURSOR;
        
            ----------------------------------------------------------------------------
            SELECT TENCHUTOA.HOTEN, PCTP_GQ.HOTEN, TENTHUKY.HOTENTHUKY, TENTPHDXX.HOTEN, BC_KC.BCKC||', '||STKN.NOIDUNGKN -- Kháng cáo kháng nghị
              INTO VVCHUTOA, VTHAMPHAN_TEN, VV_THUKY, VV_THANHVIEN, VV_KCKN -- Kháng cáo kháng nghị
            FROM AHS_VUAN A
                -- TEN CHU TOA      
                
            LEFT JOIN (SELECT * FROM (
                       SELECT DMCANBO.HOTEN, VUANID, 
                              ROW_NUMBER() OVER (PARTITION BY D.VUANID ORDER BY D.NGAYPHANCONG DESC) AS  R
                       FROM AHS_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                            WHERE D.MAVAITRO LIKE 'THAMPHAN'
                            )
                        WHERE R = 1) TENCHUTOA ON TENCHUTOA.VUANID = A.ID 
                            
            LEFT JOIN ( SELECT NNPC.HOTEN,GG.* FROM AHS_THAMPHANGIAIQUYET GG
                        INNER JOIN (
                                    SELECT TT.VUANID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên mới nhất
                                        FROM (
                                        SELECT TP.VUANID ,
                                        LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                        FROM AHS_THAMPHANGIAIQUYET TP 
                                        WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                        AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                        GROUP BY TP.VUANID  )TT
                                 )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID   
                      )PCTP_GQ ON PCTP_GQ.VUANID=A.ID
                 -- THAM PHAN THANH VIEN HDXX
            LEFT JOIN(SELECT VUANID,LISTAGG(DMCANBO.HOTEN,',<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN FROM AHS_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                        GROUP BY VUANID) TENTPHDXX ON TENTPHDXX.VUANID = A.ID  
                -- THU KY
            LEFT JOIN(SELECT VUANID,LISTAGG(DMCANBO.HOTEN,',<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY FROM AHS_PHUCTHAM_HDXX D
                            LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                        WHERE D.MAVAITRO LIKE 'THUKY'
                        GROUP BY VUANID) TENTHUKY ON TENTHUKY.VUANID = A.ID
                -- BI CAO KHANG CAO
            LEFT JOIN( SELECT NDBD.VUANID,LISTAGG(NDBD.NOIDUNGKHANGCAO, ', ')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) BCKC
                           FROM (
                                    SELECT  TO_NUMBER(SUBSTR(FF.VUAN_ND,0,INSTR(FF.VUAN_ND,';')-1))VUANID,
                                            SUBSTR(FF.VUAN_ND,INSTR(FF.VUAN_ND,';')+1, LENGTH(FF.VUAN_ND))NOIDUNGKHANGCAO
                                    FROM (   
                                                    SELECT F.VUAN_ND FROM (
                                                         SELECT KC.VUANID||';'||count(*)||' '
                                                                ||DECODE(KC.NGUOIKCLOAI,0,'BC',1,I.TEN)||' k/c'
                                                                 VUAN_ND 
                                                        FROM AHS_SOTHAM_KHANGCAO KC
                                                        LEFT JOIN AHS_NGUOITHAMGIATOTUNG TT ON KC.NGUOIKCID=TT.ID
                                                        LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID=TT.ID
                                                        LEFT JOIN DM_DataItem I ON I.ID=TC.TUCACHID
                                                        GROUP BY KC.VUANID,KC.NGUOIKCLOAI,I.TEN
                                                    )F
                                                    GROUP BY F.VUAN_ND
                                    )FF
                                 )NDBD  GROUP BY NDBD.VUANID )BC_KC ON BC_KC.VUANID=A.ID
                ------- lấy thông tin số ngày kháng nghị 
            LEFT JOIN (SELECT NDKN.VUANID,LISTAGG(NDKN.NOIDUNGKN, ', ')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (
                                    SELECT KC.VUANID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN
                                    FROM AHS_SOTHAM_KHANGNGHI KC
                                    LEFT JOIN AHS_SOTHAM_KHANGCAO_YEUCAU T5 ON T5.KHANGCAOID=KC.ID
                             )NDKN  GROUP BY NDKN.VUANID)STKN ON STKN.VUANID=A.ID
            WHERE A.ID = ITEM_HS.VUANID;  
        ----------------------------------------------------------------------------
        
        IF(VVCHUTOA IS NOT NULL)             THEN    VCHUTOA_TEN := VVCHUTOA;
            ELSIF(VTHAMPHAN_TEN IS NOT NULL) THEN    VCHUTOA_TEN := VTHAMPHAN_TEN;
        END IF;  
        V_TABLE_EXPORT.extend;
         
        IF( V_SOBCKC = 0) THEN V_SOBCKC := NULL; END IF;
        
        IF(item_hs.SOBAST IS NOT NULL) THEN
            VSOBAQDST := item_hs.SOBAST;
            VNGAYBAQDST := item_hs.NGAYBAST;
        ELSIF(VSOQDST IS NOT NULL and VSOQDST not like '') THEN
            
            
            SELECT QDVA.SOQUYETDINH, QDVA.NGAYQD, QDVA.TEN, QDVAST.SOQUYETDINH, QDVAST.NGAYQD
              INTO VSOQUYETDINH, VNGAYQD, VTENQD, VSOQDST, VNGAYQDST
            FROM AHS_VUAN A
                --------------------------Quyết định gây kết thúc Sơ thẩm và Phúc thẩm--------------------------            
                LEFT JOIN (SELECT VA.SOQUYETDINH, VA.NGAYQD, VA.VUANID, dmqd.TEN
                                FROM AHS_SOTHAM_QUYETDINH_VUAN VA
                                inner JOIN (SELECT id,ten from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                ORDER BY VA.NGAYQD DESC
                                ) QDVAST ON QDVAST.VUANID = A.ID                             
                       
                LEFT JOIN (SELECT VA.SOQUYETDINH, VA.NGAYQD, VA.VUANID, dmqd.TEN
                                FROM AHS_PHUCTHAM_QUYETDINH_VUAN VA
                                inner JOIN (SELECT id,ten from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                ORDER BY VA.NGAYQD DESC
                                ) QDVA ON QDVA.VUANID = A.ID
                WHERE A.ID = ITEM_HS.VUANID AND ROWNUM = 1; 
                
            VSOBAQDST := VSOQDST;            
            VNGAYBAQDST := VNGAYQDST;
        END IF;  
        
        IF( VSOQUYETDINH IS NOT NULL or VNGAYQD IS NOT NULL or VTENQD IS NOT NULL) THEN  
            IF (VTENQD like '%Quyết định đình chỉ%') THEN
                VKETQUAXXPT := 'QĐ đình chỉ'; 
            ELSIF (VTENQD like '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN
                
                SELECT LYDOKETQUAID INTO VKETQUAXXPT
                    FROM AHS_PHUCTHAM_QUYETDINH_VUAN PT_QD
                    WHERE VUANID = item_hs.VUANID;
                    
                IF(VKETQUAXXPT IS NOT NULL) THEN 
                    SELECT TEN INTO VKETQUAXXPT
                    FROM AHS_PHUCTHAM_QUYETDINH_VUAN PT_QD
                        INNER JOIN (SELECT ID,TEN FROM DM_KETQUA_PHUCTHAM) DM_KQ_LD ON DM_KQ_LD.ID = PT_QD.KETQUAID
                    WHERE VUANID = item_hs.VUANID;
                END IF;
            ELSE
                SELECT decode(instr(VTENQD,'. '), 0, VTENQD, SUBSTR(VTENQD, instr(VTENQD,'. ')+2)) INTO VKETQUAXXPT FROM DUAL; 
            END IF; 
            
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_AHS_DAXU(
                   VCHUTOA_TEN,VV_THANHVIEN,VV_THUKY,VSOQUYETDINH,VNGAYQD,item_hs.V_SOTHULY,TO_DATE(item_hs.V_NGAYTHULY, 'dd/mm/yyyy'),
                   V_HOTEN,V_SOBCKC,VV_KCKN,V_TENTOIDANH,V_KQXXST,VSOBAQDST,VNGAYBAQDST
                   ,item_hs.V_DIACHI,VKETQUAXXPT
                   ); 
        ELSE 
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_AHS_DAXU(
                           VCHUTOA_TEN,VV_THANHVIEN,VV_THUKY,item_hs.V_SOAN,item_hs.V_NGAYXU,item_hs.V_SOTHULY,TO_DATE(item_hs.V_NGAYTHULY, 'dd/mm/yyyy'),
                           V_HOTEN,V_SOBCKC,VV_KCKN,V_TENTOIDANH,V_KQXXST,VSOBAQDST,VNGAYBAQDST
                           ,item_hs.V_DIACHI,V_KQXXPT
                           ); 
        END IF;
     END LOOP;
   RETURN V_TABLE_EXPORT;   
END DON_SEARCH_ITEM_HS;

END PKG_STPT_DANHSACH;
