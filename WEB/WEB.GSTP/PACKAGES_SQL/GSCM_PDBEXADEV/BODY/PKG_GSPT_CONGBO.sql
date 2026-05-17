--------------------------------------------------------
--  DDL for Package Body PKG_GSPT_CONGBO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GSPT_CONGBO" AS

PROCEDURE DBLINK_GET_LIST_TC_CRIMINALS_LIST_FRONT_END
(
  V_TIMES  IN VARCHAR2 DEFAULT NULL , 
  ITEMS_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN ITEMS_CURSOR FOR
          SELECT CR.ID,CR.CHAPTER_ID,CR.CRIMINAL_ID,CR.CRIMINAL_ID||'.'|| CR.CRIMINAL_NAME||' ('||TCR.TIME_NAME||')' CRIMINAL_NAME ,CR.YOUTH,CR.DEATH
          FROM TC_CRIMINALS@DBLINK_CBBA.TOAAN.GOV.VN CR 
          INNER JOIN TC_CHAPTERS@DBLINK_CBBA.TOAAN.GOV.VN CH ON CR.CHAPTER_ID=CH.ID
          LEFT JOIN TC_TIME_CRIMINALS@DBLINK_CBBA.TOAAN.GOV.VN TCR ON TCR.ID=CH.TIMES
          WHERE ((CH.TIMES=V_TIMES AND V_TIMES IS NOT NULL) OR (V_TIMES IS NULL))
          ORDER BY CR.CRIMINAL_ID;                    
END;

PROCEDURE DBLINK_GET_LIST_TC_CASES_LIST_FULL
(
  V_STYLES NUMBER, 
  ITEMS_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN ITEMS_CURSOR FOR
                SELECT TC.ID,TC.CASE_ID,( lpad('--------',2*(level-1))|| TC.CASE_NAME) CASE_NAME,TC.STYLES,TC.OPTIONS,TC.DESCRIPTIONS,TC.PARENT_ID,TC.ORDERS,TC.ENABLE            
                 FROM  TC_CASES@DBLINK_CBBA.TOAAN.GOV.VN TC
                 start with TC.PARENT_ID=0 AND TC.STYLES =V_STYLES AND TC.ENABLE=1
                    CONNECT BY PRIOR TC.ID=TC.PARENT_ID AND TC.ENABLE=1
                    ORDER SIBLINGS by ORDERS;
END;


PROCEDURE  DBLINK_GET_LIST_ANLE
(
    curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR 
        SELECT V.* FROM PUBLIC_DATA_AN_LE@DBLINK_CBBA.TOAAN.GOV.VN V order by v.SO_ANLE;
END DBLINK_GET_LIST_ANLE;


FUNCTION DBLINK_GET_TOAANID_CONGBO (
    TOAANID NUMBER
) RETURN NUMBER AS
    VMADONGBO         VARCHAR2(1000 CHAR);
    VTOAANID_CONGBO   NUMBER;
BEGIN
    BEGIN
        SELECT NVL(DM.madongbo, '') 
        INTO VMADONGBO
        FROM dm_toaan DM
        WHERE TOAANID = DM.ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL; -- hoặc -1, tùy nghiệp vụ
    END;

    BEGIN
        SELECT V.ID 
        INTO VTOAANID_CONGBO
        FROM ROOM_COURTS@DBLINK_CBBA.TOAAN.GOV.VN V
        WHERE VMADONGBO = V.MADONGBO;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL; -- hoặc -1, tùy nghiệp vụ
    END;

    RETURN VTOAANID_CONGBO;
END DBLINK_GET_TOAANID_CONGBO;



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
    V_TRANGTHAI_CONGBO IN DECIMAL,
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_STPT_6LOAIAN;
    L_STATEMENT VARCHAR2(2000);
    V_CONGBO_TABLE BAQD_CONGBO_EXT;
BEGIN	
     v_table := T_STPT_6LOAIAN();
     V_CONGBO_TABLE := BAQD_CONGBO_EXT();
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
                --XLHC
               FOR item IN (
                   SELECT PA.* FROM
                   PKG_STPT_XLHC.DON_SEARCH_ITEM(
                        VDONVIID => V_TOAAN_ID,
                        VTENVIEC => V_TEN_VU_AN,
                        VQUANHEPHAPLUAT => '',
                        VMAVIEC => V_MA_VU_AN,
                        VDOITUONGAPDUNGBPXLHC => '',
                        VCAPXETXU => V_CAPXX,
                        VTOAXETXU => V_TOAAN_ID,
                        VTINHTRANGTHULY => V_TINHTRANG_THULY,
                        VTUNGAYTHULY => V_NGAYTHULY_TU,
                        VDENNGAYTHULY => V_NGAYTHULY_DEN,
                        VSOTHULY => V_SOTHULY,
                        VTINHTRANGGQ => V_THOIHAN_GQ,
                        VTUNGAYGQ => V_TUNGAY,
                        VDENNGAYGQ => V_DENNGAY,
                        VTHAMPHAN => V_THAMPHAN_ID,
                        VTHOIHANGQ => '',
                        VSOQD => V_SO_QD,
                        VNGAYQD => V_NGAY_QD,
                        VTHUKY => V_THUKY_ID,
                        VPTRUTKINHNGHIEM => '',
                        PAGE_INDEX => NULL,
                        PAGE_SIZE => NULL

                  ) PA 
                )
                LOOP
                       v_table.extend;
                        v_table(v_table.count) := R_STPT_6LOAIAN(
                        item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                        item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                        item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                        );   
                END LOOP;  
           -----APS
           FOR item IN (
               SELECT PA.* FROM
                PKG_STPT_PS.DON_SEARCH_ITEM(
                    V_CAPXETXULOGIN => NULL,
                    VDONVIID => V_TOAAN_ID,
                    VTENVIEC => V_TEN_VU_AN,
                    VLOAIHINHDOANHNGHIEP => NULL,
                    VMAVIEC => V_MA_VU_AN,
                    VDUONGSU_NGUOITHAMGIATOTUNG => v_bi_can,
                    VCAPXETXU => V_CAPXX,
                    VTOAXETXU => V_TOAAN_ID,
                    VTINHTRANGTHULY => V_TINHTRANG_THULY,
                    VTUNGAYTHULY => V_NGAYTHULY_TU,
                    VDENNGAYTHULY => V_NGAYTHULY_DEN,
                    VSOTHULY => V_SOTHULY,
                    VTINHTRANGGQ => V_TINHTRANG_GIAIQUYET,
                    VTUNGAYTINHTRANGGQ => V_TUNGAY,
                    VDENNGAYTINHTRANGGQ => V_DENNGAY,
                    VTHAMPHAN => V_THAMPHAN_ID,
                    VTHOIHANGQ => V_THOIHAN_GQ,
                    VSOQD => V_SO_QD,
                    VNGAYQD => V_NGAY_QD,
                    VTHUKY => V_THUKY_ID,
                    VGQDON => NULL,
                    VUYTHACTUPHAP => V_UTTP,
                    VPTRUTKINHNGHIEM => NULL,
                    VCHECKTK => 0,
                    V_VAITRO_THAMPHAN => NULL,
                    V_CHECK_HOAGIAI => NULL,
                    PAGE_INDEX => NULL,
                    PAGE_SIZE => NULL
                  ) PA 
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
  ELSIF(V_LOAIAN_ID='7') THEN
           -----APS
           FOR item IN (
               SELECT PA.* FROM
                PKG_STPT_PS.DON_SEARCH_ITEM(
                    V_CAPXETXULOGIN => NULL,
                    VDONVIID => V_TOAAN_ID,
                    VTENVIEC => V_TEN_VU_AN,
                    VLOAIHINHDOANHNGHIEP => NULL,
                    VMAVIEC => V_MA_VU_AN,
                    VDUONGSU_NGUOITHAMGIATOTUNG => v_bi_can,
                    VCAPXETXU => V_CAPXX,
                    VTOAXETXU => V_TOAAN_ID,
                    VTINHTRANGTHULY => V_TINHTRANG_THULY,
                    VTUNGAYTHULY => V_NGAYTHULY_TU,
                    VDENNGAYTHULY => V_NGAYTHULY_DEN,
                    VSOTHULY => V_SOTHULY,
                    VTINHTRANGGQ => V_TINHTRANG_GIAIQUYET,
                    VTUNGAYTINHTRANGGQ => V_TUNGAY,
                    VDENNGAYTINHTRANGGQ => V_DENNGAY,
                    VTHAMPHAN => V_THAMPHAN_ID,
                    VTHOIHANGQ => V_THOIHAN_GQ,
                    VSOQD => V_SO_QD,
                    VNGAYQD => V_NGAY_QD,
                    VTHUKY => V_THUKY_ID,
                    VGQDON => NULL,
                    VUYTHACTUPHAP => V_UTTP,
                    VPTRUTKINHNGHIEM => NULL,
                    VCHECKTK => 0,
                    V_VAITRO_THAMPHAN => NULL,
                    V_CHECK_HOAGIAI => NULL,
                    PAGE_INDEX => NULL,
                    PAGE_SIZE => NULL
                  ) PA 
            )
            LOOP
                   v_table.extend;
                    v_table(v_table.count) := R_STPT_6LOAIAN(
                    item.ID,item.MAVUAN,item.TENVUAN,item.NGAYTAO,item.NGAY_TAO,item.NGUOITAO,item.MAGIAIDOAN,
                    item.HOTENBICAN,item.TENTOASOTHAM,item.TRUONGHOPGIAONHAN,item.GIAIDOANVUVIEC,item.BANAN_QD_ST,item.KHANGNGHI_ST,
                    item.TINHTRANG_GQ,item.CHECK_THULY,item.LOAIAN_ID
                    );   
            END LOOP;  
  ELSIF(V_LOAIAN_ID='8') THEN
           -----XLHC
           FOR item IN (
               SELECT PA.* FROM
               PKG_STPT_XLHC.DON_SEARCH_ITEM(
                    VDONVIID => V_TOAAN_ID,
                    VTENVIEC => V_TEN_VU_AN,
                    VQUANHEPHAPLUAT => '',
                    VMAVIEC => V_MA_VU_AN,
                    VDOITUONGAPDUNGBPXLHC => '',
                    VCAPXETXU => V_CAPXX,
                    VTOAXETXU => V_TOAAN_ID,
                    VTINHTRANGTHULY => V_TINHTRANG_THULY,
                    VTUNGAYTHULY => V_NGAYTHULY_TU,
                    VDENNGAYTHULY => V_NGAYTHULY_DEN,
                    VSOTHULY => V_SOTHULY,
                    VTINHTRANGGQ => V_THOIHAN_GQ,
                    VTUNGAYGQ => V_TUNGAY,
                    VDENNGAYGQ => V_DENNGAY,
                    VTHAMPHAN => V_THAMPHAN_ID,
                    VTHOIHANGQ => '',
                    VSOQD => V_SO_QD,
                    VNGAYQD => V_NGAY_QD,
                    VTHUKY => V_THUKY_ID,
                    VPTRUTKINHNGHIEM => '',
                    PAGE_INDEX => NULL,
                    PAGE_SIZE => NULL

              ) PA 
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
    L_STATEMENT:= 'SELECT BAQD_CONGBO_T(cb.ID,cb.LOAIANID,cb.TRANGTHAI,cb.MAVUAN,cb.VUVIECID) FROM BAQD_CONGBO cb';
    L_STATEMENT:=L_STATEMENT|| ' WHERE cb.CAPXETXU = '|| V_CAPXX;
    IF(V_TRANGTHAI_CONGBO IS NOT NULL) THEN 
        -- Chưa công bố trạng thái sẽ là null hoặc 1
        IF(V_TRANGTHAI_CONGBO = 1) THEN
            L_STATEMENT := L_STATEMENT || ' and ( cb.TRANGTHAI='||V_TRANGTHAI_CONGBO|| ' or cb.TRANGTHAI is null )';
        ELSE
        -- Các trường hợp còn lại đều có mã trạng thái kèm theo
            L_STATEMENT := L_STATEMENT || ' and cb.TRANGTHAI='||V_TRANGTHAI_CONGBO;
        END IF;
    END IF;
    EXECUTE IMMEDIATE L_STATEMENT BULK COLLECT INTO V_CONGBO_TABLE;
      --OPEN curReturn FOR L_STATEMENT;
    OPEN curReturn FOR
    select tt.* from (   
        SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAY_TAO desc) STT,COUNT(*) OVER () as CountAll,A.*
            ,LA.LOAI_AN_TEN,cb.ID BAQD_CONGBO_ID,
            cb.TRANGTHAI TT_CB_ID,
            CASE cb.TRANGTHAI
              WHEN 2 THEN 'Đã công bố'
              WHEN 3 THEN 'Không công bố'
              WHEN 4 THEN 'Hạ/Hủy/Gỡ công bố'
              ELSE 'Chưa công bố'
            END TT_CB_ID_TEXT
        FROM TABLE(v_table)A
        LEFT JOIN DM_LOAIAN LA ON LA.ID=A.LOAIAN_ID
        inner join TABLE(V_CONGBO_TABLE) cb
        --inner join BAQD_CONGBO cb
            ON cb.LOAIANID = LA.ID
            --AND cb.MAVUAN = A.MAVUAN
            AND cb.VUVIECID = A.ID
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
)RETURN SYS_REFCURSOR AS
  BEGIN
    -- TODO: Implementation required for FUNCTION PKG_GSPT_CONGBO.HS_DS_AN_DATHULY
    RETURN NULL;
  END HS_DS_AN_DATHULY;

  FUNCTION NHAPLIEU_HS_DS_EXT_ALL
(
    vDonViID  IN number,
    v_TINHTRANG_THULY IN VARCHAR2,
    v_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR AS
  BEGIN
    -- TODO: Implementation required for FUNCTION PKG_GSPT_CONGBO.NHAPLIEU_HS_DS_EXT_ALL
    RETURN NULL;
  END NHAPLIEU_HS_DS_EXT_ALL;

  FUNCTION HS_DS_AN_CHUYENVKS
(
    V_DON_ID  IN varchar2,
    V_DONVIID IN NUMBER
)RETURN SYS_REFCURSOR AS
  BEGIN
    -- TODO: Implementation required for FUNCTION PKG_GSPT_CONGBO.HS_DS_AN_CHUYENVKS
    RETURN NULL;
  END HS_DS_AN_CHUYENVKS;

  PROCEDURE HS_DS_GIAO_HOSO_VKS
(
    V_DON_ID  IN varchar2,
    curReturn OUT sys_refcursor
) AS
  BEGIN
    -- TODO: Implementation required for PROCEDURE PKG_GSPT_CONGBO.HS_DS_GIAO_HOSO_VKS
    NULL;
  END HS_DS_GIAO_HOSO_VKS;

PROCEDURE BAQD_FILE_GET_WHERE_BAQD_CONGBO_ID
(
    BAQDCONGBOID  IN int,
    curReturn OUT sys_refcursor
)AS
  BEGIN
  OPEN curReturn FOR Select b.*,
  CASE b.LoaiFile WHEN 1 THEN 'Tệp gốc'
   WHEN 2 THEN 'Tệp đã mã hóa'
   ELSE 'Tệp đã đóng dấu' END LoaiFileText from BAQD_FILE b
        inner join (
            SELECT MAX(baf.ID) ID,baf.LOAIFILE FROM BAQD_FILE baf
            Where baf.BAQD_CONGBO_ID = BAQDCONGBOID
            GROUP BY baf.LOAIFILE
        ) f
        on f.ID = b.ID
        Order by b.loaifile;
  END BAQD_FILE_GET_WHERE_BAQD_CONGBO_ID;

PROCEDURE BAQD_CONGBO_LICHSU_LIST
(
    IN_BAQD_CONGBO_ID  IN int,
    Page_Index in	int,
    Page_Size	in	int,
    curReturn OUT sys_refcursor
)AS
    MinIndex number; MaxIndex number;
BEGIN
    --BAQD_CONGBO_ID:= 637024362;
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    OPEN curReturn FOR
    select tt.*,
           DECODE (tt.HANHDONG, 
            'ADD_FILE_GOC', 'Thêm tệp gốc', 
            'ADD_FILE_DA_MA_HOA', 'Thêm tệp đã mã hóa', 
            'ADD_FILE_DONG_DAU', 'Thêm tệp đã đóng dấu', 
            'UPDATE_FILE_GOC', 'Cập nhật tệp gốc', 
            'UPDATE_FILE_DA_MA_HOA', 'Cập nhật tệp đã mã hóa', 
            'UPDATE_FILE_DONG_DAU', 'Cập nhật tệp đã đóng dấu', 
            'DELETE_FILE_GOC', 'Xóa tệp gốc', 
            'DELETE_FILE_DA_MA_HOA', 'Xóa tệp đã mã hóa', 
            'DELETE_FILE_DONG_DAU', 'Xóa tệp đã đóng dấu', 
            'KHONGCONGBO', 'Chuyển trạng thái thành không công bố', 
            'UPDATE_KHONGCONGBO', 'Cập nhật lý do không công bố', 
            'DELETE_KHONGCONGBO', 'Xóa trạng thái không công bố',  
            'CONGBO', 'Trạng thái được chuyển thành công bố',
            'INSERT_CONGBO','BA/QĐ đủ điều kiện công bố',
                                '') HANHDONG_MOTA 
    from (   
        SELECT  ROW_NUMBER() OVER (ORDER BY ls.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll,ls.*
        FROM 
        (
            SELECT * FROM BAQD_CONGBO_LICHSU WHERE BAQD_CONGBO_ID = IN_BAQD_CONGBO_ID
            UNION 
            Select 0 ID,cb.ID BAQD_CONGBO_ID,'INSERT_CONGBO' HANHDONG, null FILESERVER_ID_OLD,null FILESERVER_ID_NEW,'Hệ thống' NGUOITAO,nvl(cb.NGAYTAO,to_date('01/01/2000 00:00:00' ,'mm/dd/yyyy hh24:mi:ss')) NGAYTAO
            from BAQD_CONGBO cb
            where ID = IN_BAQD_CONGBO_ID AND ROWNUM = 1
        ) ls
     )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex; 
END BAQD_CONGBO_LICHSU_LIST;

END PKG_GSPT_CONGBO;

/
