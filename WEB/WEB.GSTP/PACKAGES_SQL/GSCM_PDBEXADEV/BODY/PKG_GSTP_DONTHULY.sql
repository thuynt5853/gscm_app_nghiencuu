--------------------------------------------------------
--  DDL for Package Body PKG_GSTP_DONTHULY
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GSTP_DONTHULY" AS
PROCEDURE GSTP_HOME_ST_DON(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE,
  CurReturn OUT sys_refcursor
) AS
BEGIN
  OPEN CurReturn FOR 
  SELECT *
  FROM TABLE(PKG_GSTP_DONTHULY.FUN_GSTP_HOME_ST_DON(inToaAnID,inCapToa,vHienTai_TuNgay,vHienTai_DenNgay,vTruoc_TuNgay,vTruoc_DenNgay));  
END GSTP_HOME_ST_DON;

FUNCTION FUN_GSTP_HOME_ST_DON 
(
  inToaAnID IN NUMBER,
  inCapToa IN VARCHAR2,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
) RETURN GSTP_HOME_ST_DON_T PIPELINED 
AS
  v_CAPTOA VARCHAR2(25) DEFAULT NULL;
  v_ARRAY GSTP_HOME_ST_DON_T;
BEGIN
  v_CAPTOA:=inCapToa;
  -- Nếu inToaAnID=0 và v_CAPTOA=NULL => cả nước
  IF v_CAPTOA || ' '=' ' THEN --> Lấy tất cả các tòa xét xử sơ thẩm
    SELECT GSTP_HOME_ST_DON_R(
      V_STT => ROW_NUMBER() OVER(ORDER BY T1.ID),
      V_TOAAN => T1.ID,
      V_TONGDON =>0,
      V_TONGDON_CU =>0,
      V_GIAIQUYET =>0,
      V_GIAIQUYET_CU =>0,
      V_GIAIQUYET_KHAC =>0,
      V_GIAIQUYET_KHAC_CU =>0,
      V_CHUAGIAIQUYET =>0,
      V_CHUAGIAIQUYET_CU =>0,
      V_TSQUALUATDINH =>0,
      V_TSQUALUATDINH_CU =>0
    ) BULK COLLECT INTO v_ARRAY
    FROM DM_TOAAN T1
    WHERE INSTR('CAPTINH,CAPHUYEN,QSQUANKHU,QSKHUVUC',T1.LOAITOA)>0
          AND T1.HIEULUC=1;
  ELSE --> Tính sơ thẩm của đơn vị LOGIN
    SELECT GSTP_HOME_ST_DON_R(
      V_STT => ROW_NUMBER() OVER(ORDER BY T1.ID),
      V_TOAAN => T1.ID,
      V_TONGDON =>0,
      V_TONGDON_CU =>0,
      V_GIAIQUYET =>0,
      V_GIAIQUYET_CU =>0,
      V_GIAIQUYET_KHAC =>0,
      V_GIAIQUYET_KHAC_CU =>0,
      V_CHUAGIAIQUYET =>0,
      V_CHUAGIAIQUYET_CU =>0,
      V_TSQUALUATDINH =>0,
      V_TSQUALUATDINH_CU =>0
    ) BULK COLLECT INTO v_ARRAY
    FROM DM_TOAAN T1
    WHERE T1.ID=inToaAnID;
  END IF;
  -- Các tòa khác sẽ gọi
  IF INSTR('CAPTINH,CAPHUYEN,QSQUANKHU,QSKHUVUC',v_CAPTOA)>0 OR v_CAPTOA || ' '=' ' THEN
    PKG_GSTP_DONTHULY.FILL_GSTP_HOME_ST_DON(v_ARRAY,vHienTai_TuNgay,vHienTai_DenNgay,vTruoc_TuNgay,vTruoc_DenNgay);
  END IF;

  FOR ITEM IN 
  (SELECT 
    SUM(V_TONGDON) V_TONGDON,
    SUM(V_GIAIQUYET) V_GIAIQUYET,
    SUM(V_GIAIQUYET_KHAC) V_GIAIQUYET_KHAC,
    SUM(V_CHUAGIAIQUYET) V_CHUAGIAIQUYET,
    SUM(V_TONGDON_CU) V_TONGDON_CU,
    SUM(V_GIAIQUYET_CU) V_GIAIQUYET_CU,
    SUM(V_GIAIQUYET_KHAC_CU) V_GIAIQUYET_KHAC_CU,
    SUM(V_CHUAGIAIQUYET_CU) V_CHUAGIAIQUYET_CU,
    SUM(V_TSQUALUATDINH) V_TSQUALUATDINH,
    SUM(V_TSQUALUATDINH_CU) V_TSQUALUATDINH_CU
  FROM TABLE(v_ARRAY) T1
  ) LOOP
    PIPE ROW(GSTP_HOME_ST_DON_R(1,inToaAnID,ITEM.V_TONGDON,ITEM.V_TONGDON_CU
                                         ,ITEM.V_GIAIQUYET,ITEM.V_GIAIQUYET_CU
                                         ,ITEM.V_GIAIQUYET_KHAC,ITEM.V_GIAIQUYET_KHAC_CU
                                         ,ITEM.V_CHUAGIAIQUYET ,ITEM.V_CHUAGIAIQUYET_CU
                                         ,ITEM.V_TSQUALUATDINH, ITEM.V_TSQUALUATDINH_CU
                                         ));
  END LOOP;
END FUN_GSTP_HOME_ST_DON;

PROCEDURE FILL_GSTP_HOME_ST_DON
(
  v_ARRAY IN OUT GSTP_HOME_ST_DON_T,
  vHienTai_TuNgay IN DATE,
  vHienTai_DenNgay IN DATE,
  vTruoc_TuNgay IN DATE,
  vTruoc_DenNgay IN DATE
) AS
  v_HienTai_TuNgay  DATE;
  v_HienTai_DenNgay DATE;
  v_Truoc_TuNgay  DATE;
  v_Truoc_DenNgay DATE;
BEGIN
--     if(vHienTai_TuNgay IS NOT NULL) then  v_HienTai_TuNgay:=to_date(trim(vHienTai_TuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
--     if(vHienTai_DenNgay IS NOT NULL) then  v_HienTai_DenNgay:=to_date(trim(v_HienTai_DenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
--     if(vTruoc_TuNgay IS NOT NULL) then  v_Truoc_TuNgay:=to_date(trim(vTruoc_TuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
--     if(vTruoc_DenNgay IS NOT NULL) then  v_Truoc_DenNgay:=to_date(trim(vTruoc_DenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
  v_HienTai_TuNgay  := vHienTai_TuNgay;
  v_HienTai_DenNgay := vHienTai_DenNgay;
  v_Truoc_TuNgay  := vTruoc_TuNgay;
  v_Truoc_DenNgay := vTruoc_DenNgay;

  --***** Tính tổng thụ lý trong kỳ --> V_TONGTHULY
  -- 8 Ngay = 3 Phai phan cong TP + 5 Tham phan phải giai quyet; Tính tu ngay Toa tiep nhan don phải giải quyết
  --- LOAIGIAIQUYET = 5 da giai quyet don; = 1 chuyen toa khac; = 3 Tra lai don; =4 yeu cau bo sung
  --- Don da nhan  Hien tai
  FOR ITEM IN
  (
    SELECT T1.V_STT, T4.V_TONGDON
        FROM TABLE(v_ARRAY) T1
        INNER JOIN (
            Select T.TOAANID, SUM(T.V_TONGDON) V_TONGDON from(
                        SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON FROM ADS_DON D
                                WHERE D.NGAYTAO BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay
                                GROUP BY D.TOAANID
                        UNION
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON FROM AHN_DON D
                                WHERE D.NGAYTAO BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay
                                GROUP BY D.TOAANID
                         UNION
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON FROM AHC_DON D
                                WHERE D.NGAYTAO BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay
                                GROUP BY D.TOAANID 
                        UNION
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON FROM AKT_DON D
                                WHERE D.NGAYTAO BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay
                                GROUP BY D.TOAANID
                        UNION
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON FROM ALD_DON D
                                WHERE D.NGAYTAO BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay
                                GROUP BY D.TOAANID
                        UNION
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON FROM APS_DON D
                                WHERE D.NGAYTAO BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay
                                GROUP BY D.TOAANID  
                        ) T GROUP BY T.TOAANID 
                    ) T4 ON T4.TOAANID=T1.V_TOAAN
  )LOOP
    v_ARRAY(ITEM.V_STT).V_TONGDON:=ITEM.V_TONGDON;
  END LOOP;

  --- Don da nhan Nam truoc
  FOR ITEM IN
  (
    SELECT T1.V_STT, T4.V_TONGDON_CU
        FROM TABLE(v_ARRAY) T1
        INNER JOIN (
                Select T.TOAANID, SUM(T.V_TONGDON_CU) V_TONGDON_CU from(
                        SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON_CU FROM ADS_DON D
                                    WHERE D.NGAYTAO BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON_CU FROM AHN_DON D
                                    WHERE D.NGAYTAO BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay
                                    GROUP BY D.TOAANID
                             UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON_CU FROM AHC_DON D
                                    WHERE D.NGAYTAO BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay
                                    GROUP BY D.TOAANID 
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON_CU FROM AKT_DON D
                                    WHERE D.NGAYTAO BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON_CU FROM ALD_DON D
                                    WHERE D.NGAYTAO BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TONGDON_CU FROM APS_DON D
                                    WHERE D.NGAYTAO BETWEEN v_Truoc_TuNgay AND v_HienTai_DenNgay
                                    GROUP BY D.TOAANID
                        ) T GROUP BY T.TOAANID 
                    ) T4 ON T4.TOAANID=T1.V_TOAAN
  )LOOP
    v_ARRAY(ITEM.V_STT).V_TONGDON_CU:=ITEM.V_TONGDON_CU;
  END LOOP;

  --- Don Da thu ly = 5 Hien tai
  FOR ITEM IN
  (
    SELECT T1.V_STT, T4.V_GIAIQUYET
        FROM TABLE(v_ARRAY) T1
        INNER JOIN (
             Select T.TOAANID, SUM(T.V_GIAIQUYET) V_GIAIQUYET from(
                        SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET FROM ADS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET FROM AHN_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AHN_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                             UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET FROM AHC_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID 
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET FROM AKT_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AKT_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET FROM ALD_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ALD_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET FROM APS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM APS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID        
                        ) T GROUP BY T.TOAANID 
                    ) T4 ON T4.TOAANID=T1.V_TOAAN
  )LOOP
    v_ARRAY(ITEM.V_STT).V_GIAIQUYET:=ITEM.V_GIAIQUYET;
  END LOOP;

   --- Don Da thu ly = 5 Nam truoc
    FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_GIAIQUYET_CU
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                Select T.TOAANID, SUM(T.V_GIAIQUYET_CU) V_GIAIQUYET_CU from(
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_CU FROM ADS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_CU FROM AHN_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AHN_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                             UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_CU FROM AHC_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID 
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_CU FROM AKT_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AKT_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_CU FROM ALD_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ALD_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_CU FROM APS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM APS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET=5 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID        
                            ) T GROUP BY T.TOAANID 
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_GIAIQUYET_CU:=ITEM.V_GIAIQUYET_CU;
      END LOOP;
--  Don da giai quyet 1,3,4 khac Nam Hien tai    
  FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_GIAIQUYET_KHAC
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                Select T.TOAANID, SUM(T.V_GIAIQUYET_KHAC) V_GIAIQUYET_KHAC from(
                        SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC FROM ADS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC FROM AHN_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AHN_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4)  
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                             UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC FROM AHC_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID 
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC FROM AKT_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AKT_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC FROM ALD_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ALD_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC FROM APS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM APS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                    GROUP BY D.TOAANID  
                            ) T GROUP BY T.TOAANID 
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_GIAIQUYET_KHAC:=ITEM.V_GIAIQUYET_KHAC;
      END LOOP;    
--  Don da giai quyet khac Nam truoc    
  FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_GIAIQUYET_KHAC_CU
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                Select T.TOAANID, SUM(T.V_GIAIQUYET_KHAC_CU) V_GIAIQUYET_KHAC_CU from(
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC_CU FROM ADS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC_CU FROM AHN_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AHN_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4)  
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                             UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC_CU FROM AHC_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID 
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC_CU FROM AKT_DON D
                                    WHERE EXISTS (SELECT 'X' FROM AKT_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC_CU FROM ALD_DON D
                                    WHERE EXISTS (SELECT 'X' FROM ALD_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID
                            UNION
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_GIAIQUYET_KHAC_CU FROM APS_DON D
                                    WHERE  EXISTS (SELECT 'X' FROM APS_DON_XULY XL 
                                                    WHERE XL.LOAIGIAIQUYET in (1,3,4) 
                                                        AND XL.DONID=D.ID 
                                                        AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                    GROUP BY D.TOAANID 
                            ) T GROUP BY T.TOAANID 
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_GIAIQUYET_KHAC_CU:=ITEM.V_GIAIQUYET_KHAC_CU;
      END LOOP;
--  Don Chưa có ket qua giai quyet Hien tai  
  FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_CHUAGIAIQUYET
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                Select T.TOAANID, SUM(T.V_CHUAGIAIQUYET) V_CHUAGIAIQUYET from(
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET FROM ADS_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET FROM AHN_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                 UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET FROM AHC_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <=  v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID 
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET FROM AKT_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET FROM ALD_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET FROM APS_DON D
                                        WHERE  NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID 
                            ) T GROUP BY T.TOAANID 
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_CHUAGIAIQUYET:=ITEM.V_CHUAGIAIQUYET;
      END LOOP;

--  Don Chưa có ket qua giai quyet Năm truoc   
  FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_CHUAGIAIQUYET_CU
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                    Select T.TOAANID, SUM(T.V_CHUAGIAIQUYET_CU) V_CHUAGIAIQUYET_CU from(
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET_CU FROM ADS_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET_CU FROM AHN_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                 UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET_CU FROM AHC_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID 
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET_CU FROM AKT_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET_CU FROM ALD_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_CHUAGIAIQUYET_CU FROM APS_DON D
                                        WHERE  NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC <= v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID        
                            ) T GROUP BY T.TOAANID
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_CHUAGIAIQUYET_CU:=ITEM.V_CHUAGIAIQUYET_CU;
      END LOOP;

     --  Don Qua luat dinh chua KQ Hien tai  
  FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_TSQUALUATDINH
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                Select T.TOAANID, SUM(T.V_TSQUALUATDINH) V_TSQUALUATDINH from(
                            SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH FROM ADS_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH FROM AHN_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                 UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH FROM AHC_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID 
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH FROM AKT_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH FROM ALD_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH FROM APS_DON D
                                        WHERE  NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_HienTai_TuNgay AND v_HienTai_DenNgay)
                                        GROUP BY D.TOAANID 
                            ) T GROUP BY T.TOAANID 
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_TSQUALUATDINH:=ITEM.V_TSQUALUATDINH;
      END LOOP;

--  Don Qua luat dinh chua KQ Năm truoc   
  FOR ITEM IN
      (
        SELECT T1.V_STT, T4.V_TSQUALUATDINH_CU
            FROM TABLE(v_ARRAY) T1
            INNER JOIN (
                    Select T.TOAANID, SUM(T.V_TSQUALUATDINH_CU) V_TSQUALUATDINH_CU from(
                                SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH_CU FROM ADS_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH_CU FROM AHN_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                 UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH_CU FROM AHC_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID 
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH_CU FROM AKT_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH_CU FROM ALD_DON D
                                        WHERE NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID
                                UNION
                                    SELECT D.TOAANID,COUNT(DISTINCT D.ID) V_TSQUALUATDINH_CU FROM APS_DON D
                                        WHERE  NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL 
                                                        WHERE  XL.DONID=D.ID 
                                                            AND XL.NGAYGQ_YC BETWEEN v_Truoc_TuNgay AND v_Truoc_DenNgay)
                                        GROUP BY D.TOAANID        
                            ) T GROUP BY T.TOAANID
                        ) T4 ON T4.TOAANID=T1.V_TOAAN
      )LOOP
        v_ARRAY(ITEM.V_STT).V_TSQUALUATDINH_CU:=ITEM.V_TSQUALUATDINH_CU;
      END LOOP; 
END;


END PKG_GSTP_DONTHULY;

/
