--------------------------------------------------------
--  DDL for Package Body PKG_STPT_SEARCH_ALL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_SEARCH_ALL" AS
PROCEDURE HS_DS_EXT_SEARCH_ALL
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
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
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_STPT_6LOAIAN;
BEGIN	
     v_table := T_STPT_6LOAIAN();
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
  IF(V_LOAIAN_ID IS NULL) THEN
              ------HS
             FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_HS.AHS_VUAN_GETALLPAGING_ITEM(V_CAP_XET_XU_LOGIN,v_ten_vu_an,v_toidanh,v_ma_vu_an,v_bi_can,v_Capxx,
                   v_toaan_id,v_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,v_SOTHULY,v_TINHTRANG_GIAIQUYET,
                   V_TUNGAY,V_DENNGAY,v_KETQUA,v_so_qd,v_ngay_qd,v_thamphan_id,
                   v_thuky_id, v_THOIHAN_GQ, v_QD_TAMGIAM,V_UTTP,Page_Index,Page_Size) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;
                -----ds
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_DS.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;
                -----HNGD
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_HNGD.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
                -----AKT
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_KINHTE.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
                -----ALD
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_LAODONG.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;  
              -----AHC
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_HANHCHINH.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
      ELSIF(V_LOAIAN_ID='2,3,4,5,6') THEN
          -----ds
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_DS.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;
                -----HNGD
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_HNGD.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
                -----AKT
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_KINHTE.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
                -----ALD
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_LAODONG.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;  
              -----AHC
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_HANHCHINH.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;
      ELSIF(V_LOAIAN_ID='1') THEN
           ------HS-----
             FOR item IN (
                  SELECT PA.* FROM  TABLE(PKG_STPT_HS.AHS_VUAN_GETALLPAGING_ITEM(V_CAP_XET_XU_LOGIN,v_ten_vu_an,v_toidanh,v_ma_vu_an,v_bi_can,v_Capxx,
                   v_toaan_id,v_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,v_SOTHULY,v_TINHTRANG_GIAIQUYET,
                   V_TUNGAY,V_DENNGAY,v_KETQUA,v_so_qd,v_ngay_qd,v_thamphan_id,
                   v_thuky_id, v_THOIHAN_GQ, v_QD_TAMGIAM,V_UTTP,Page_Index,Page_Size) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;
     ELSIF(V_LOAIAN_ID='2') THEN    
           -----ds----
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_DS.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;
    ELSIF(V_LOAIAN_ID='3') THEN    
            -----HNGD
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_HNGD.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
     ELSIF(V_LOAIAN_ID='4') THEN  
            -----AKT
               FOR item IN (
                   SELECT PA.* FROM  TABLE(PKG_STPT_KINHTE.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                    V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                    V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                    V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP; 
   ELSIF(V_LOAIAN_ID='5') THEN
              -----ALD
           FOR item IN (
               SELECT PA.* FROM  TABLE(PKG_STPT_LAODONG.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
            )
            LOOP
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_6LOAIAN(
                    item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                    item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                    item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                    );   
            END LOOP; 
  ELSIF(V_LOAIAN_ID='6') THEN
           -----AHC
           FOR item IN (
               SELECT PA.* FROM  TABLE(PKG_STPT_HANHCHINH.DON_SEARCH_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,V_UTTP,Page_Index,Page_Size ) ) PA 
            )
            LOOP
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_6LOAIAN(
                    item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                    item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                    item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                    );   
            END LOOP;  
      END IF;
      ---------- 
      OPEN curReturn FOR
    select tt.* from (   
        SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAY_TAO desc) STT,COUNT(*) OVER () as CountAll,A.*
            ,LA.LOAI_AN_TEN FROM TABLE(v_table)A
        LEFT JOIN DM_LOAIAN LA ON LA.ID=A.LOAIAN_ID
        WHERE (V_LOAIAN_ID IS NULL OR instr(','||V_LOAIAN_ID||',',','||A.LOAIAN_ID||',')>0)
     )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex; 
END HS_DS_EXT_SEARCH_ALL;
FUNCTION HS_DS_AN_DATHULY
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
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
    Page_Index in	int,
    Page_Size	in	int
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; 
BEGIN	
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
     if(V_LOAIAN_ID='1')THEN --hs
      V_CURSOR:=PKG_PCTP_HS.AHS_VUAN_GETALLPAGING_PRINT_ITEM(V_CAP_XET_XU_LOGIN,v_ten_vu_an,v_toidanh,v_ma_vu_an,v_bi_can,v_Capxx,
                   v_toaan_id,v_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,v_SOTHULY,v_TINHTRANG_GIAIQUYET,
                   V_TUNGAY,V_DENNGAY,v_KETQUA,v_so_qd,v_ngay_qd,v_thamphan_id,
                   v_thuky_id, v_THOIHAN_GQ, v_QD_TAMGIAM,Page_Index,Page_Size);
      elsif(V_LOAIAN_ID='2')THEN  --ds
         V_CURSOR:=PKG_PCTP_DS.DON_SEARCH_PRINT_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
                V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
                V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
                V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,Page_Index,Page_Size );
      elsif(V_LOAIAN_ID='3')THEN  --hn
     V_CURSOR:=PKG_PCTP_HNGD.DON_SEARCH_PRINT_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,Page_Index,Page_Size );   
      elsif(V_LOAIAN_ID='4')THEN  --kt
     V_CURSOR:=PKG_PCTP_KINHTE.DON_SEARCH_PRINT_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,Page_Index,Page_Size );  
       elsif(V_LOAIAN_ID='5')THEN  --ld
     V_CURSOR:=PKG_PCTP_LAODONG.DON_SEARCH_PRINT_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,Page_Index,Page_Size );           
     elsif(V_LOAIAN_ID='6')THEN  --hc
     V_CURSOR:=PKG_PCTP_HANHCHINH.DON_SEARCH_PRINT_ITEM(V_CAP_XET_XU_LOGIN,V_TEN_VU_AN,v_toidanh,V_MA_VU_AN,v_bi_can,V_CAPXX,
            V_TOAAN_ID,V_TINHTRANG_THULY,V_NGAYTHULY_TU,V_NGAYTHULY_DEN,V_SOTHULY,V_THAMPHAN_ID,
            V_TINHTRANG_GIAIQUYET,V_TUNGAY,V_DENNGAY,V_KETQUA,V_SO_QD,V_NGAY_QD,
            V_THUKY_ID,V_THOIHAN_GQ,NULL,NULL,NULL,Page_Index,Page_Size );         
      END IF;      
      RETURN V_CURSOR;       
 END HS_DS_AN_DATHULY; 
 

FUNCTION NHAPLIEU_HS_DS_EXT_ALL
(
    vDonViID  IN number,
    v_TINHTRANG_THULY IN VARCHAR2,
    v_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;VV_TUNGAY DATE;VV_DENNGAY DATE;V_TOAAN_NAME NVARCHAR2(250 CHAR);V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;
    SOLUONGCHUAGQ number;
    v_ArrSapXep varchar2(250);
    v_Tongcong number;
    v_STT number;
    v_LOAITOA varchar2(250);
BEGIN	
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    ----
     SELECT TA.TEN,TA.LOAITOA INTO V_TOAAN_NAME, v_LOAITOA FROM DM_TOAAN TA WHERE TA.ID=vDonViID;
     ----
     select ARRSAPXEP into v_ArrSapXep from DM_TOAAN where ID=vDonViID;
     -------------
     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vDonViID AND TA.HANHCHINHID=HC.ID);
     ----
     
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
     
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="10" style="text-align: center; vertical-align: top; font-size: 11pt">TÒA ÁN NHÂN DÂN TỐI CAO</td>
                <td colspan="2"></td>
                <th colspan="12" style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <th colspan="10" style="vertical-align: top; font-size: 11pt;">'||UPPER(V_TOAAN_NAME)||'</th>
                <td colspan="2"></td>
                <th colspan="12" style="vertical-align: top; font-size: 13pt;">Độc lập - Tự do - Hạnh phúc </th>
            </tr>
            <tr>
                
                <td colspan="24" style="line-height: 100%; font-size: 13pt; text-align: center; height: 80px;"><b>BÁO CÁO NHẬP LIỆU TẠI CÁC ĐƠN VỊ</b></td>
            </tr>
            <tr>
                <td colspan="24" style="line-height: 100%; font-size: 13pt; text-align: center; height: 60px; font-style: italic;">Tính từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</td>
            </tr>
            <tr>
            <td></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px" rowspan="2">TT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Đơn Vị</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan ="3">Hình sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan ="3">Dân sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">HN&GĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">Hành Chính</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">KDTM</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">Lao động</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">Phá sản</td>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Tổng</th>
            </tr>
             <tr style="font-weight: bold;">
             
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>  
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>
                
            </tr>
                 '); 
        v_Tongcong:=0;
        v_STT := 0;
       FOR v_DM_TOAAN In (
                 SELECT TC.* FROM  
                 (SELECT CO.* FROM DM_TOAAN CO 
                        LEFT JOIN DM_TOAAN CC ON CC.ID=CO.CAPCHAID
                          WHERE (((CO.ID IN( SELECT SS.ID 
                                              FROM DM_TOAAN SS
                                              LEFT JOIN DM_TOAAN K ON K.ID=SS.CAPCHAID
                                              CONNECT BY PRIOR SS.CAPCHAID = SS.ID
                                            )  
                                      ))
                                )  AND CO.HIEULUC = 1
                                AND (instr(','||v_TOAANID||',',','||CO.ID||',')>0 AND v_TOAANID IS NOT NULL)
--                                 AND ( (v_SearchAll=1 and ((CO.ARRSAPXEP like '%'||v_ArrSapXep||'%') 
--                                                                                or CO.ID=vDonViID)) 
--                                                   Or (v_SearchAll=0
--                                                   and CO.ID=vDonViID))
                  ) TC
                    ORDER BY TC.ARRTHUTU 
--                  start with TC.LOAITOA IN (v_LOAITOA)
--                 CONNECT BY PRIOR TC.ID=TC.CAPCHAID 
--                 ORDER SIBLINGS by TC.CAPCHAID,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TC.TEN,'Tòa án nhân dân',''),'tỉnh',''),'thành phố',''),'huyện',''),'thị xã',''),'quận','')      
                )
            LOOP
            v_Tongcong:=0;
            v_STT := v_STT + 1;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:50px">'||v_STT||'</td>');
            IF (v_DM_TOAAN.LOAITOA = 'CAPHUYEN') THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width:600px">'||v_DM_TOAAN.MA_TEN||'</td>');
            ELSE       
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DM_TOAAN.TEN||'</th>');
            END IF;
--  An Hinh Su       Tong so an So tham 
                        select count(hs.id) into SOLUONGCHUAGQ from GSCM.ahs_sotham_thuly hs                                
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                LEFT JOIN GSCM.AHS_SOTHAM_BANAN T2 ON v.id=T2.vuanid
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID 
                                                        FROM GSCM.AHS_SOTHAM_QUYETDINH_VUAN Q 
                                                                LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid
                                    where 
                                    v.toaanid = v_DM_TOAAN.ID
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYBANAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;
                    
                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
--                Phuc tham   
                    select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahs_phuctham_thuly hs
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id
                                LEFT JOIN GSCM.AHS_PHUCTHAM_BANAN T2 ON v.id=T2.vuanid
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID 
                                                      FROM GSCM.AHS_PHUCTHAM_QUYETDINH_VUAN Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                            WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid
                                 where 
                                    v.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYBANAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
--                GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');

--    An Dan su
  
                    select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                               FROM GSCM.ADS_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid                                 
                                where 
                                    d.toaanid = v_DM_TOAAN.ID
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                                    
                             v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;               
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                   select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ads_phuctham_thuly hs 
                                 LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                 LEFT JOIN GSCM.ADS_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                 LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.ADS_PHUCTHAM_QUYETDINH Q 
                                                                  LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                                WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                  where 
                                    d.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;
      
                                  
                             v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;               
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');                     
                    
               --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                      AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
     
                    
--    An Hon Nhan                      
                    select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ahn_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                  FROM GSCM.AHN_SOTHAM_QUYETDINH Q 
                                                                       LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                  WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.toaanid = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;                   
                  
                                v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                     select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                            FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                 LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;
                    
                                v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');         
             --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
     

--      An Hanh chinh                      
                        select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ahc_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                            FROM GSCM.AHC_SOTHAM_QUYETDINH Q 
                                                                 LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                            WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.toaanid = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  
                   
                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                            
                     select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.AHC_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;
                                    
                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
            
                        --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
     
         
--         an kinh te   
                            
                      select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                              FROM GSCM.AKT_SOTHAM_QUYETDINH Q 
                                                                       LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                             WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.toaanid = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  
                                    
                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                     
                  select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AKT_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.AKT_PHUCTHAM_QUYETDINH Q 
                                                                     LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                               WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ; 
                                    
                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
              --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY;

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
     
  
       
--       An Lao dong
                select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ALD_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.ALD_SOTHAM_QUYETDINH Q 
                                                                   LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                               WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.toaanid = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  
              
                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                   
                   select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ALD_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM  GSCM.ALD_PHUCTHAM_QUYETDINH Q 
                                                                   LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                  WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ; 
                                    
                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');         
              --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
     

        
--    An Pha san                        
                    select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                             FROM GSCM.APS_SOTHAM_QUYETDINH Q 
                                                                   LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.toaanid = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  
                                    
                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td> ');
                         
                        select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.APS_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                        FROM GSCM.APS_PHUCTHAM_QUYETDINH Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                         WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    d.TOAPHUCTHAMID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;
                                    
                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>
                   ');
              --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
     
                   
                   
                   
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_Tongcong||'</th>
                      </tr>
                   '); 
        END LOOP;
        
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="height: 1px;">
                <td style="width: 50px"></td>
                <td style="width: 500px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                
                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>
                                
                <td style="width: 80px"></td>
            </tr>
        </table>
      ');
        
    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  
   
END NHAPLIEU_HS_DS_EXT_ALL;
  
  
FUNCTION HS_DS_AN_CHUYENVKS
(
    V_DON_ID  IN varchar2,
    V_DONVIID IN NUMBER
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; 
    V_TABLE T_STPT_6LOAIAN_GIAOVKS;
     V_LOAIAN_ID varchar2(100); vDonid number; vDon_id varchar2(200); vLoaian_id varchar2(100);Don_loaian varchar2(200);
     CountAll_S number;
     V_TENDONVI varchar2(250);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);
     V_TENDONVI_CHA varchar2(250);V_CAP  varchar2(250);
BEGIN	
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    
    v_table := T_STPT_6LOAIAN_GIAOVKS();
    --- TEN DON VI
    SELECT REPLACE(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao',''),'Tòa án nhân dân',''),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,replace(HC.TEN,'thành phố ',''),CAPCHA.TEN,TA.SOCAP INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC,V_TENDONVI_CHA,V_CAP FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
      LEFT JOIN DM_TOAAN CAPCHA ON TA.CAPCHAID = CAPCHA.ID
     WHERE TA.ID=V_DONVIID;
    
    ---------------------------------------
    FOR item IN ( select  COLUMN_VALUE from  TABLE ( split_String(V_DON_ID,';')) 
            )
        LOOP 
            -- Duyet tung Don theo Loai an
            vDon_id := SUBSTR(item.COLUMN_VALUE,1,instr(item.COLUMN_VALUE,',')-1);
            V_LOAIAN_ID := SUBSTR(item.COLUMN_VALUE,instr(item.COLUMN_VALUE,',')+1);
                ----HS-----
                IF(TO_NUMBER(V_LOAIAN_ID) = 1) THEN
                     FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYBANAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                        FROM AHS_VUAN v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_SOTHAM_THULY TL) TLST ON V.ID=TLST.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.VUANID 
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYBANAN,TA.TEN,STBA.VUANID FROM AHS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.VUANID = V.ID
                                        where v.id = TO_NUMBER(vDon_id))
                        LOOP
                        --Lay thong tin thu ly
                        
                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUAN,'Hình sự',V_LOAIAN_ID,item.TENVUAN,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                              ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                               item.TEN,item.SOBANAN,to_char(item.NGAYBANAN,'dd/MM/yyyy'),
                               item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                        END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 2) THEN    
                       -----ds----
                       FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS  
                                        FROM ADS_DON v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ADS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                        where id = TO_NUMBER(vDon_id))
                        LOOP
                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUVIEC,'Dân sự',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);   
                        END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 3) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN , 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM AHN_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AHN_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Hôn nhân gia Đình',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                   ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                   item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                   item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);  
                            END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 4) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS  
                                            FROM AKT_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AKT_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Kinh doanh Thương mại',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                  item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                  item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);    
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 5) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS  
                                            FROM ALD_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ALD_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Lao động',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                   item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                   item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null); 
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 6) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM APS_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM APS_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Phá sản',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                   item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                   item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                            END LOOP;
                END IF;
         END LOOP;
      ---------- 
       FOR vDATA IN ( 
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAY_TAO desc) STT,COUNT(*) OVER () as CountAll,A.*
                FROM TABLE(v_table) A )
        LOOP
          CountAll_S:=vDATA.CountAll;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
            <tr><td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.SOTHULY||'<br/> '||vDATA.NGAYTHULY||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.LOAIAN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.TOAANXX||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.SOBA||'<br/> '||vDATA.NGAYBA||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.SOBUTLUC||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.GHICHU||'</td>
            </tr>
                ');
        END LOOP;

       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
                
                <tr>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-size: 12pt">');
                    IF(V_CAP = '2' OR V_CAP = '3') THEN 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'TÒA ÁN NHÂN DÂN TỐI CAO');
                    ELSE 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT, UPPER(V_TENDONVI_CHA));
                    END IF;
                    
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'</td>
                    <td></td>
                    <th colspan="2" style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                 <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 13pt;">');
                    IF(V_CAP = '2') THEN 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'TÒA ÁN NHÂN DÂN CẤP CAO');
                    ELSE 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'TÒA ÁN NHÂN DÂN '||UPPER(V_TENDONVI));
                    END IF;
                    
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'</th>
                    <td></td>
                    <th colspan="2" style="vertical-align: top;font-size: 13pt; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc</th>
                </tr>  
                <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 13pt;">');
                            IF(V_DONVIID = 4) THEN 
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,'<u>TẠI HÀ NỘI</u>');
                            ELSIF(V_DONVIID = 5) THEN 
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,'<u>TẠI ĐÀ NẴNG</u>');
                            ELSIF(V_DONVIID = 6) THEN 
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,'TẠI THÀ<u>NH PHỐ HỒ C</u>HÍ MINH');
                            END IF;
                            
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'</th>
                    <td></td>
                    <th colspan="2" style="vertical-align: top;font-size: 13pt; text-decoration: underline;"></th>
                </tr>   
                <tr>
                    <td ></td>
                    <td colspan="6" style="line-height: 100%;text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
                </tr>
            
            <tr>
                <td colspan="7" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH CÁC VỤ ÁN GIAO VIỆN KIỂM SÁT NGÀY '|| TO_CHAR(SYSDATE,'dd/MM/yyyy') ||'</b>
                </td>
            </tr>
            <tr>
                <td colspan="7" style="line-height: 100%;text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
            </tr>
            <tr>
                <td colspan="7" style="height: 15pt; text-align: left;"><b>Tổng số: ');
                IF CountAll_S <10 THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 0'||CountAll_S);
                ELSE
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' '||CountAll_S);
                END IF;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' hồ sơ</b></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="height: 20pt;text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số, ngày thụ lý</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Loại VA</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Địa phương</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số, ngày BA/QĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số bút lục</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
                 '); 
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
                <td style="width: 40px"></td>
                <td style="width: 100px"></td>
                <td style="width: 100px"></td>
                <td style="width: 200px"></td>
                <td style="width: 100px"></td>
                <td style="width: 80px"></td>
                <td style="width: 300px"></td>
            </tr>
        </table>
      ');
       OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        
        RETURN V_CURSOR;       
 END HS_DS_AN_CHUYENVKS;  
 
PROCEDURE HS_DS_GIAO_HOSO_VKS
(
    V_DON_ID  IN varchar2,
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_STPT_6LOAIAN_GIAOVKS;
    V_LOAIAN_ID varchar2(100); vDonid number; vDon_id varchar2(200); vLoaian_id varchar2(100);Don_loaian varchar2(200);
   
BEGIN	
     v_table := T_STPT_6LOAIAN_GIAOVKS();
    ---------------------------------------
    FOR item IN ( select  COLUMN_VALUE from  TABLE ( split_String(V_DON_ID,';')) 
            )
        LOOP 
            -- Duyet tung Don theo Loai an
            vDon_id := SUBSTR(item.COLUMN_VALUE,1,instr(item.COLUMN_VALUE,',')-1);
            V_LOAIAN_ID := SUBSTR(item.COLUMN_VALUE,instr(item.COLUMN_VALUE,',')+1);

               ----HS-----
                IF(TO_NUMBER(V_LOAIAN_ID) = 1) THEN
                     FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYBANAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS
                                        FROM AHS_VUAN v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_SOTHAM_THULY TL) TLST ON V.ID=TLST.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.VUANID 
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYBANAN,TA.TEN,STBA.VUANID FROM AHS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.VUANID = V.ID
                                        where v.id = TO_NUMBER(vDon_id))
                        LOOP
                        --Lay thong tin thu ly
                        
                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUAN,'Hình sự',V_LOAIAN_ID,item.TENVUAN,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                               ITEM.SOTHULY ||' </br> '||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                               item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYBANAN,'dd/MM/yyyy'),null,
                               item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                               null, null); 
                        END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 2) THEN    
                       -----ds----
                       FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN,
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS
                                        FROM ADS_DON v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ADS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                        where id = TO_NUMBER(vDon_id))
                        LOOP
                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUVIEC,'Dân sự',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                 item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                 item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                null, null);
                        END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 3) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                              HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM AHN_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AHN_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Hôn nhân gia Đình',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                   ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null); 
                            END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 4) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM AKT_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AKT_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Kinh doanh Thương mại',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 5) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                                HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM ALD_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ALD_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Lao động',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 6) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                                HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM APS_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM APS_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Phá sản',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null); 
                            END LOOP;
                END IF;
         END LOOP;
      ---------- 
      OPEN curReturn FOR
        select tt.* from (   
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAY_TAO desc) STT,COUNT(*) OVER () as CountAll,A.*
                FROM TABLE(v_table)A
         )tt ; 
END HS_DS_GIAO_HOSO_VKS;  
   

END PKG_STPT_SEARCH_ALL;
