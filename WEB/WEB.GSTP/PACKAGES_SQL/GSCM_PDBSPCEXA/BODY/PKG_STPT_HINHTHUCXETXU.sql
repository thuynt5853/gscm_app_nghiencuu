--------------------------------------------------------
--  DDL for Package Body PKG_STPT_HINHTHUCXETXU
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_HINHTHUCXETXU" AS

FUNCTION BAOCAO_XETXUTRUCTUYEN
(
    VDONVIID  IN number,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR
AS
    VV_STT NUMBER DEFAULT 0;
    VV_CAP_DONVIID VARCHAR(20);
    VV_TENTOAANCHAPCHA VARCHAR(250);
    VV_TUNGAY DATE;    VV_DENNGAY DATE;

    VV_SUM_STHS NUMBER DEFAULT 0; VV_SUM_PTHS NUMBER DEFAULT 0;
    VV_SUM_STHC NUMBER DEFAULT 0; VV_SUM_PTHC NUMBER DEFAULT 0;
    VV_SUM_STDS NUMBER DEFAULT 0; VV_SUM_PTDS NUMBER DEFAULT 0;
    VV_SUM_STHN NUMBER DEFAULT 0; VV_SUM_PTHN NUMBER DEFAULT 0;
    VV_SUM_STLD NUMBER DEFAULT 0; VV_SUM_PTLD NUMBER DEFAULT 0;
    VV_SUM_STKT NUMBER DEFAULT 0; VV_SUM_PTKT NUMBER DEFAULT 0;
    VV_SUM_ANKHAC NUMBER DEFAULT 0;

    VV_SUM_ROW_SUM NUMBER DEFAULT 0;

    V_ROW_BAOCAO_XETXUTRUCTUYEN T_BAOCAO_XETXUTRUCTUYEN;

    V_EXPORT_TEXT CLOB;
    V_EXPORT_TEXT_HEAD1 CLOB;
    V_EXPORT_TEXT_HEAD2 CLOB;

    V_EXPORT_TEXT_BODY CLOB;
    V_EXPORT_TEXT_CAPCAO CLOB;

    V_EXPORT_TEXT_FOOTER CLOB;
    V_CURSOR sys_refcursor;
BEGIN
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_HEAD1,true);
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_HEAD2,true);
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_BODY,true);
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_CAPCAO,true);
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_FOOTER,true);

     V_ROW_BAOCAO_XETXUTRUCTUYEN := T_BAOCAO_XETXUTRUCTUYEN();

     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;

     DBMS_LOB.APPEND(V_EXPORT_TEXT_HEAD1,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
             <tr style="line-height: 100%; font-size: 24pt; text-align: center; font-style: bold;" height="40px">
                <td colspan="17">Tổng số vụ đã xét xử từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</td>
             </tr>
             <tr style="line-height: 100%; font-size: 13pt; text-align: center; font-weight: bold; vertical-align: middle;">
                <td colspan= "1" rowspan= "3" style="border: 0.1pt solid #000000;">STT</td>
                <td colspan= "2" rowspan= "3" style="border: 0.1pt solid #000000; text-align: left;">Đơn vị toà án</td>
                <td colspan= "14" rowspan= "1"style="border: 0.1pt solid #000000;">Số vụ án đã xét xử trực tuyến</td>');

      DBMS_LOB.APPEND(V_EXPORT_TEXT_HEAD2,'
             </tr>
             <tr style="line-height: 100%; font-size: 13pt; text-align: center; font-weight: bold; vertical-align: middle;">
                <td colspan ="2" style="border: 0.1pt solid #000000;">Hình sự</td>
                <td colspan ="2" style="border: 0.1pt solid #000000;">Hành Chính</td>
                <td colspan ="2" style="border: 0.1pt solid #000000;">Dân sự</td>
                <td colspan ="2" style="border: 0.1pt solid #000000;">HN</td>
                <td colspan ="2" style="border: 0.1pt solid #000000;">Lao động</td>
                <td colspan ="2" style="border: 0.1pt solid #000000;">KDTM</td>
                <td colspan ="1" rowspan ="2" style="border: 0.1pt solid #000000;">Án khác</td>
                <td colspan ="1" rowspan ="2" style="border: 0.1pt solid #000000;">Tổng số vụ án</td>
             </tr>
             <tr style="line-height: 100%; font-size: 13pt; text-align: center; font-weight: bold; vertical-align: middle;">
                <td colspan ="1" style="border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td colspan ="1" style="border: 0.1pt solid #000000;">Phúc thẩm</td>

                <td colspan ="1" style="border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td colspan ="1" style="border: 0.1pt solid #000000;">Phúc thẩm</td>

                <td colspan ="1" style="border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td colspan ="1" style="border: 0.1pt solid #000000;">Phúc thẩm</td>

                <td colspan ="1" style="border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td colspan ="1" style="border: 0.1pt solid #000000;">Phúc thẩm</td>

                <td colspan ="1" style="border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td colspan ="1" style="border: 0.1pt solid #000000;">Phúc thẩm</td>

                <td colspan ="1" style="border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td colspan ="1" style="border: 0.1pt solid #000000;">Phúc thẩm</td>
            </tr>
                 '); 

       -- Nếu là cấp huyện gọi báo cáo thì chỉ láy riêng mình huyện
       SELECT LOAITOA INTO VV_CAP_DONVIID FROM DM_TOAAN WHERE ID = VDONVIID;

       FOR v_DM_TOAAN In (  SELECT * FROM (
                            SELECT  DECODE(JJ.LOAITOA, 'CAPTINH', JJ.ID, 'CAPHUYEN', JJ.TOANAID_CAPCHA_CUAHUYEN) AS ARR_2CAP, 
                                    DECODE(JJ.LOAITOA, 'CAPTINH', 1, 'CAPHUYEN', 1 , 'CAPCAO' , 3, 'TOICAO', 2) AS ARR_CAPLOAITOA,
                                    DECODE(JJ.LOAITOA, 'CAPTINH', 2, 'CAPHUYEN', 2 , 'CAPCAO' , 4, 'TOICAO', 3) AS ARR_THUTUHIENTHI,
                                    JJ.MA_TEN, JJ.ARRSAPXEP,
                                    --Các cột dữ liệu
--                                    JJ.STHS, JJ.PTHS, JJ.STHC, JJ.PTHC, JJ.STDS, JJ.PTDS,
--                                    JJ.STHN, JJ.PTHN, JJ.STLD, JJ.PTLD, JJ.STKT, JJ.PTKT,
--                                    JJ.STPS, JJ.PTPS, JJ.STXLHC, JJ.PTXLHC, 
--                                    JJ.STPS + JJ.PTPS + JJ.STXLHC + JJ.PTXLHC AS ANKHAC,
--                                    JJ.STHS + JJ.PTHS + JJ.STHC + JJ.PTHC + JJ.STDS + JJ.PTDS + JJ.STHN + JJ.PTHN + JJ.STLD + JJ.PTLD + JJ.STKT + JJ.PTKT + JJ.STPS + JJ.PTPS + JJ.STXLHC + JJ.PTXLHC AS ROW_SUM

                                    JJ.STHS, JJ.PTHS, JJ.STHC, JJ.PTHC, JJ.STDS, JJ.PTDS,
                                    JJ.STHN, JJ.PTHN, JJ.STLD, JJ.PTLD, JJ.STKT, JJ.PTKT,
                                    JJ.STPS + jj.STPS_BOSUNG, JJ.PTPS + jj.PTPS_BOSUNG, JJ.STXLHC + jj.STXLHC_BOSUNG, JJ.PTXLHC + jj.PTXLHC_BOSUNG, 
                                    JJ.STPS + JJ.PTPS + JJ.STXLHC + JJ.PTXLHC  + jj.STPS_BOSUNG + jj.PTPS_BOSUNG + jj.STXLHC_BOSUNG + jj.PTXLHC_BOSUNG AS ANKHAC,
                                    JJ.STHS + JJ.PTHS + JJ.STHC + JJ.PTHC + JJ.STDS + JJ.PTDS + 
                                    JJ.STHN + JJ.PTHN + JJ.STLD + JJ.PTLD + JJ.STKT + JJ.PTKT + 
                                    JJ.STPS + JJ.PTPS + JJ.STXLHC + JJ.PTXLHC  + jj.STPS_BOSUNG + jj.PTPS_BOSUNG + jj.STXLHC_BOSUNG + jj.PTXLHC_BOSUNG AS ROW_SUM


                            FROM (SELECT DMTA.ID, DMTA.MA_TEN, DMTA.LOAITOA, DMTA.ARRSAPXEP

                                       ,DECODE(DMTACAPCHA.LOAITOA, 'CAPTINH', DMTACAPCHA.ID) AS TOANAID_CAPCHA_CUAHUYEN
                                       ,DECODE(AHS_ST_QD.SL, NULL,0, AHS_ST_QD.SL) AS STHS, DECODE(AHS_PT_QD.SL, NULL,0, AHS_PT_QD.SL) AS PTHS
                                       ,DECODE(AHC_ST_QD.SL, NULL,0, AHC_ST_QD.SL) AS STHC, DECODE(AHC_PT_QD.SL, NULL,0, AHC_PT_QD.SL) AS PTHC
                                       ,DECODE(ADS_ST_QD.SL, NULL,0, ADS_ST_QD.SL) AS STDS, DECODE(ADS_PT_QD.SL, NULL,0, ADS_PT_QD.SL) AS PTDS
                                       ,DECODE(AHN_ST_QD.SL, NULL,0, AHN_ST_QD.SL) AS STHN, DECODE(AHN_PT_QD.SL, NULL,0, AHN_PT_QD.SL) AS PTHN
                                       ,DECODE(ALD_ST_QD.SL, NULL,0, ALD_ST_QD.SL) AS STLD, DECODE(ALD_PT_QD.SL, NULL,0, ALD_PT_QD.SL) AS PTLD
                                       ,DECODE(AKT_ST_QD.SL, NULL,0, AKT_ST_QD.SL) AS STKT, DECODE(AKT_PT_QD.SL, NULL,0, AKT_PT_QD.SL) AS PTKT
                                       ,DECODE(APS_ST_QD.SL, NULL,0, APS_ST_QD.SL) AS STPS, DECODE(APS_PT_QD.SL, NULL,0, APS_PT_QD.SL) AS PTPS
                                       ,DECODE(XLHC_ST_QD.SL, NULL,0, XLHC_ST_QD.SL) AS STXLHC, DECODE(XLHC_PT_QD.SL, NULL,0, XLHC_PT_QD.SL) AS PTXLHC

                                       --Bảng bổ sung
                                       ,DECODE(STPS_BOSUNG.SL, NULL,0, STPS_BOSUNG.SL) AS STPS_BOSUNG, DECODE(PTPS_BOSUNG.SL, NULL,0, PTPS_BOSUNG.SL) AS PTPS_BOSUNG
                                       ,DECODE(STXLHC_BOSUNG.SL, NULL,0, STXLHC_BOSUNG.SL) AS STXLHC_BOSUNG, DECODE(PTXLHC_BOSUNG.SL, NULL,0, PTXLHC_BOSUNG.SL) AS PTXLHC_BOSUNG
                                    FROM DM_TOAAN DMTA

                                        LEFT JOIN DM_TOAAN DMTACAPCHA ON DMTACAPCHA.ID = DMTA.CAPCHAID -- Lấy tên tỉnh cho cấp huyện  
                                        --Hình sự
                                        LEFT JOIN (SELECT QD.DONVIID, COUNT('X') AS SL FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE QD.VUANID = BA.VUANID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QD2 
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.VUANID = QD2.VUANID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.DONVIID) AHS_ST_QD ON AHS_ST_QD.DONVIID = DMTA.ID  

                                        LEFT JOIN (SELECT QD.DONVIID, COUNT('X') AS SL FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE QD.VUANID = BA.VUANID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD2 
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.VUANID = QD2.VUANID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.DONVIID) AHS_PT_QD ON AHS_PT_QD.DONVIID = DMTA.ID


                                        --Dân sự
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ADS_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ADS_ST_QD ON ADS_ST_QD.TOAANID = DMTA.ID                                    
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ADS_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ADS_PT_QD ON ADS_PT_QD.TOAANID = DMTA.ID


                                        --Hành chính
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHC_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3)  AND (EXISTS (SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHC_ST_QD ON AHC_ST_QD.TOAANID = DMTA.ID      

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHC_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHC_PT_QD ON AHC_PT_QD.TOAANID = DMTA.ID

                                        --Hôn nhân
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHN_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHN_ST_QD ON AHN_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHN_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHN_PT_QD ON AHN_PT_QD.TOAANID = DMTA.ID

                                        --Lao động
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ALD_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ALD_ST_QD ON ALD_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ALD_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ALD_PT_QD ON ALD_PT_QD.TOAANID = DMTA.ID
                                        --Kinh tế
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AKT_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AKT_ST_QD ON AKT_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AKT_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AKT_PT_QD ON AKT_PT_QD.TOAANID = DMTA.ID  
                                        --Án khác  
                                        --Phá sản
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM APS_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM APS_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM APS_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                  GROUP BY QD.TOAANID) APS_ST_QD ON APS_ST_QD.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM APS_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM APS_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) APS_PT_QD ON APS_PT_QD.TOAANID = DMTA.ID

                                        -- Xử lý hành chính                                           
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM XLHC_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM XLHC_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) XLHC_ST_QD ON XLHC_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM XLHC_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM XLHC_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) XLHC_PT_QD ON XLHC_PT_QD.TOAANID = DMTA.ID


                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM APS_CAPNHAT_HTXX WHERE MAGIAIDOAN = 2 AND TRANGTHAI = 1 AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) STPS_BOSUNG ON STPS_BOSUNG.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM APS_CAPNHAT_HTXX WHERE MAGIAIDOAN = 3 AND TRANGTHAI = 1 AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) PTPS_BOSUNG ON PTPS_BOSUNG.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM XLHC_CAPNHAT_HTXX WHERE MAGIAIDOAN = 2 AND TRANGTHAI = 1 AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) STXLHC_BOSUNG ON STXLHC_BOSUNG.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM XLHC_CAPNHAT_HTXX WHERE MAGIAIDOAN = 3 AND TRANGTHAI = 1 AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) PTXLHC_BOSUNG ON PTXLHC_BOSUNG.TOAANID = DMTA.ID



                                    WHERE DMTA.HIEULUC = 1 AND DMTA.LOAITOA IN ('CAPTINH','CAPHUYEN') --, 'CAPCAO') 
                                                           AND DMTA.ID NOT IN (109,1531,1470,1510,1511,1530) --AND DMTA.TEN NOT LIKE '%Test%' AND DMTA.TEN NOT LIKE '%Sông Bé%' AND DMTA.TEN NOT LIKE '%Phục Hòa
                                                           AND (instr(','||v_TOAANID||',',','||DMTA.ID||',')>0 )

                                    ) JJ
                                )
                            ORDER BY ARR_CAPLOAITOA, ARR_2CAP, ROW_SUM DESC, ARRSAPXEP)
            LOOP

                V_ROW_BAOCAO_XETXUTRUCTUYEN.extend;
                V_ROW_BAOCAO_XETXUTRUCTUYEN(V_ROW_BAOCAO_XETXUTRUCTUYEN.COUNT) := R_BAOCAO_XETXUTRUCTUYEN(v_DM_TOAAN.ARR_2CAP,v_DM_TOAAN.MA_TEN,
                                                                                    v_DM_TOAAN.STHS,v_DM_TOAAN.PTHS,v_DM_TOAAN.STHC,v_DM_TOAAN.PTHC,
                                                                                    v_DM_TOAAN.STDS,v_DM_TOAAN.PTDS,v_DM_TOAAN.STHN,v_DM_TOAAN.PTHN,
                                                                                    v_DM_TOAAN.STLD,v_DM_TOAAN.PTLD,v_DM_TOAAN.STKT,v_DM_TOAAN.PTKT,
                                                                                    v_DM_TOAAN.ANKHAC,v_DM_TOAAN.ROW_SUM,v_DM_TOAAN.ARR_THUTUHIENTHI);


                VV_SUM_STHS := VV_SUM_STHS + v_DM_TOAAN.STHS; 
                VV_SUM_PTHS := VV_SUM_PTHS + v_DM_TOAAN.PTHS; 
                VV_SUM_STHC := VV_SUM_STHC + v_DM_TOAAN.STHC; 
                VV_SUM_PTHC := VV_SUM_PTHC + v_DM_TOAAN.PTHC; 
                VV_SUM_STDS := VV_SUM_STDS + v_DM_TOAAN.STDS; 
                VV_SUM_PTDS := VV_SUM_PTDS + v_DM_TOAAN.PTDS; 
                VV_SUM_STHN := VV_SUM_STHN + v_DM_TOAAN.STHN; 
                VV_SUM_PTHN := VV_SUM_PTHN + v_DM_TOAAN.PTHN; 
                VV_SUM_STLD := VV_SUM_STLD + v_DM_TOAAN.STLD; 
                VV_SUM_PTLD := VV_SUM_PTLD + v_DM_TOAAN.PTLD; 
                VV_SUM_STKT := VV_SUM_STKT + v_DM_TOAAN.STKT; 
                VV_SUM_PTKT := VV_SUM_PTKT + v_DM_TOAAN.PTKT;
                VV_SUM_ANKHAC := VV_SUM_ANKHAC + v_DM_TOAAN.ANKHAC;
                VV_SUM_ROW_SUM := VV_SUM_ROW_SUM + v_DM_TOAAN.ROW_SUM;

        END LOOP;

        -- THÊM HÀNG TỔNG CỦA 2 CẤP
        FOR ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN IN (SELECT DISTINCT ARR_2CAP, SUM(VV_STHS) AS STHS,SUM(VV_PTHS) AS PTHS, SUM(VV_STHC) AS STHC, SUM(VV_PTHC) AS PTHC,
                                                                          SUM(VV_STDS) AS STDS, SUM(VV_PTDS) AS PTDS, SUM(VV_STHN) AS STHN, SUM(VV_PTHN) AS PTHN,
                                                                          SUM(VV_STLD) AS STLD, SUM(VV_PTLD) AS PTLD, SUM(VV_STKT) AS STKT, SUM(VV_PTKT) AS PTKT,
                                                                          SUM(VV_ANKHAC) AS ANKHAC,SUM(VV_SUM_ROW_SUM) AS SUM_ROW_SUM
                                                FROM TABLE(V_ROW_BAOCAO_XETXUTRUCTUYEN)
                                                GROUP BY ARR_2CAP)
        LOOP

                SELECT REPLACE(TEN,'Tòa án nhân dân ', '') INTO VV_TENTOAANCHAPCHA FROM DM_TOAAN WHERE ID = ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.ARR_2CAP;

                V_ROW_BAOCAO_XETXUTRUCTUYEN.extend;
                V_ROW_BAOCAO_XETXUTRUCTUYEN(V_ROW_BAOCAO_XETXUTRUCTUYEN.COUNT) := R_BAOCAO_XETXUTRUCTUYEN(
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.ARR_2CAP,'TAND hai cấp ' || VV_TENTOAANCHAPCHA,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.STHS,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.PTHS,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.STHC,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.PTHC,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.STDS,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.PTDS,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.STHN,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.PTHN,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.STLD,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.PTLD,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.STKT,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.PTKT,
                                                                            ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.ANKHAC,ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.SUM_ROW_SUM, 1);
        END LOOP;

        -- ORDER
        FOR ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN_TONGSO IN (SELECT  ARR_2CAP
                                                       FROM TABLE(V_ROW_BAOCAO_XETXUTRUCTUYEN)
                                                       WHERE VV_ARR_THUTUHIENTHI = 1
                                                       ORDER BY VV_SUM_ROW_SUM DESC)
        LOOP
                FOR ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN IN (SELECT  ARR_2CAP, VV_MA_TEN,
                                                                VV_STHS ,VV_PTHS ,VV_STHC ,VV_PTHC,
                                                                VV_STDS, VV_PTDS, VV_STHN, VV_PTHN,
                                                                VV_STLD, VV_PTLD, VV_STKT, VV_PTKT,
                                                                VV_ANKHAC, VV_SUM_ROW_SUM, VV_ARR_THUTUHIENTHI
                                                        FROM TABLE(V_ROW_BAOCAO_XETXUTRUCTUYEN)
                                                        WHERE ARR_2CAP = ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN_TONGSO.ARR_2CAP
                                                        ORDER BY ARR_2CAP, VV_ARR_THUTUHIENTHI , VV_SUM_ROW_SUM DESC)
                LOOP
                    IF(ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_ARR_THUTUHIENTHI = 1) THEN 
                            VV_STT:= 0;
                        ELSE VV_STT:= VV_STT + 1;
                    END IF;

                        -- DECODE(JJ.LOAITOA, 'CAPTINH', 2, 'CAPHUYEN', 2 , 'CAPCAO' , 4, 'TOICAO', 3) AS ARR_THUTUHIENTHI
                        IF(ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_ARR_THUTUHIENTHI = 1)  
                            THEN DBMS_LOB.APPEND(V_EXPORT_TEXT,
                                '<tr style="text-align: center; vertical-align: middle; height:50px; font-weight:bold;">
                                    <td style="border: 0.1pt solid #000000;"></td>
                                    <td style="border: 0.1pt solid #000000; text-align: left;" colspan="2">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_MA_TEN||'</td>');
                            ELSIF (ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_ARR_THUTUHIENTHI = 2)  THEN
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,
                                '<tr style="text-align: center; vertical-align: middle; height:50px">
                                    <td style="border: 0.1pt solid #000000;">'||VV_STT||'</td>
                                    <td style="border: 0.1pt solid #000000; text-align: left;" colspan="2">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_MA_TEN||'</td>');
--                            ELSE
--                                DBMS_LOB.APPEND(V_EXPORT_TEXT,
--                                '<tr style="text-align: center; vertical-align: middle; height:50px">
--                                <td style="border: 0.1pt solid #000000;">'||VV_STT||'</td>
--                                <td style="border: 0.1pt solid #000000; color:#FF0000; text-align: left;" colspan="2"><b>'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_MA_TEN||'</b></td>');
                        END IF;

                        --<td style="border: 0.1pt solid #000000; text-align: left;" colspan="2">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_MA_TEN||'</td> 
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_STHS||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_PTHS||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_STHC||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_PTHC||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_STDS||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_PTDS||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_STHN||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_PTHN||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_STLD||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_PTLD||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_STKT||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_PTKT||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_ANKHAC||'</td>
                            <td style="border: 0.1pt solid #000000;">'||ITEMS_ROW_BAOCAO_XETXUTRUCTUYEN.VV_SUM_ROW_SUM||'</td>
                        </tr>');

                 END LOOP;
        END LOOP;

       -- Các tòa cấp cao
       IF(VDONVIID IN (1,4,5,6)) THEN
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'<tr></tr>');
       FOR v_DM_TOAAN In ( SELECT ROW_NUMBER() OVER (ORDER BY 'X' ASC) AS STT, JJ.MA_TEN,
                                    JJ.STHS, JJ.PTHS, JJ.STHC, JJ.PTHC, JJ.STDS, JJ.PTDS,
                                    JJ.STHN, JJ.PTHN, JJ.STLD, JJ.PTLD, JJ.STKT, JJ.PTKT,
                                    JJ.STPS + jj.STPS_BOSUNG, JJ.PTPS + jj.PTPS_BOSUNG, JJ.STXLHC + jj.STXLHC_BOSUNG, JJ.PTXLHC + jj.PTXLHC_BOSUNG, 
                                    JJ.STPS + JJ.PTPS + JJ.STXLHC + JJ.PTXLHC  + jj.STPS_BOSUNG + jj.PTPS_BOSUNG + jj.STXLHC_BOSUNG + jj.PTXLHC_BOSUNG AS ANKHAC,
                                    JJ.STHS + JJ.PTHS + JJ.STHC + JJ.PTHC + JJ.STDS + JJ.PTDS + 
                                    JJ.STHN + JJ.PTHN + JJ.STLD + JJ.PTLD + JJ.STKT + JJ.PTKT + 
                                    JJ.STPS + JJ.PTPS + JJ.STXLHC + JJ.PTXLHC  + jj.STPS_BOSUNG + jj.PTPS_BOSUNG + jj.STXLHC_BOSUNG + jj.PTXLHC_BOSUNG AS ROW_SUM


                            FROM (SELECT DMTA.ID, DMTA.MA_TEN

                                       ,DECODE(AHS_ST_QD.SL, NULL,0, AHS_ST_QD.SL) AS STHS, DECODE(AHS_PT_QD.SL, NULL,0, AHS_PT_QD.SL) AS PTHS
                                       ,DECODE(AHC_ST_QD.SL, NULL,0, AHC_ST_QD.SL) AS STHC, DECODE(AHC_PT_QD.SL, NULL,0, AHC_PT_QD.SL) AS PTHC
                                       ,DECODE(ADS_ST_QD.SL, NULL,0, ADS_ST_QD.SL) AS STDS, DECODE(ADS_PT_QD.SL, NULL,0, ADS_PT_QD.SL) AS PTDS
                                       ,DECODE(AHN_ST_QD.SL, NULL,0, AHN_ST_QD.SL) AS STHN, DECODE(AHN_PT_QD.SL, NULL,0, AHN_PT_QD.SL) AS PTHN
                                       ,DECODE(ALD_ST_QD.SL, NULL,0, ALD_ST_QD.SL) AS STLD, DECODE(ALD_PT_QD.SL, NULL,0, ALD_PT_QD.SL) AS PTLD
                                       ,DECODE(AKT_ST_QD.SL, NULL,0, AKT_ST_QD.SL) AS STKT, DECODE(AKT_PT_QD.SL, NULL,0, AKT_PT_QD.SL) AS PTKT
                                       ,DECODE(APS_ST_QD.SL, NULL,0, APS_ST_QD.SL) AS STPS, DECODE(APS_PT_QD.SL, NULL,0, APS_PT_QD.SL) AS PTPS
                                       ,DECODE(XLHC_ST_QD.SL, NULL,0, XLHC_ST_QD.SL) AS STXLHC, DECODE(XLHC_PT_QD.SL, NULL,0, XLHC_PT_QD.SL) AS PTXLHC

                                       --Bảng bổ sung
                                       ,DECODE(STPS_BOSUNG.SL, NULL,0, STPS_BOSUNG.SL) AS STPS_BOSUNG, DECODE(PTPS_BOSUNG.SL, NULL,0, PTPS_BOSUNG.SL) AS PTPS_BOSUNG
                                       ,DECODE(STXLHC_BOSUNG.SL, NULL,0, STXLHC_BOSUNG.SL) AS STXLHC_BOSUNG, DECODE(PTXLHC_BOSUNG.SL, NULL,0, PTXLHC_BOSUNG.SL) AS PTXLHC_BOSUNG

                                    FROM DM_TOAAN DMTA


                                        LEFT JOIN DM_TOAAN DMTACAPCHA ON DMTACAPCHA.ID = DMTA.CAPCHAID -- Lấy tên tỉnh cho cấp huyện  
                                        --Hình sự
                                        LEFT JOIN (SELECT QD.DONVIID, COUNT('X') AS SL FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE QD.VUANID = BA.VUANID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QD2 
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.VUANID = QD2.VUANID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.DONVIID) AHS_ST_QD ON AHS_ST_QD.DONVIID = DMTA.ID  

                                        LEFT JOIN (SELECT QD.DONVIID, COUNT('X') AS SL FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE QD.VUANID = BA.VUANID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD2 
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.VUANID = QD2.VUANID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.DONVIID) AHS_PT_QD ON AHS_PT_QD.DONVIID = DMTA.ID


                                        --Dân sự
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ADS_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ADS_ST_QD ON ADS_ST_QD.TOAANID = DMTA.ID                                    
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ADS_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ADS_PT_QD ON ADS_PT_QD.TOAANID = DMTA.ID


                                        --Hành chính
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHC_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3)  AND (EXISTS (SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHC_ST_QD ON AHC_ST_QD.TOAANID = DMTA.ID      

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHC_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHC_PT_QD ON AHC_PT_QD.TOAANID = DMTA.ID

                                        --Hôn nhân
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHN_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHN_ST_QD ON AHN_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHN_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AHN_PT_QD ON AHN_PT_QD.TOAANID = DMTA.ID

                                        --Lao động
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ALD_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ALD_ST_QD ON ALD_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ALD_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) ALD_PT_QD ON ALD_PT_QD.TOAANID = DMTA.ID
                                        --Kinh tế
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AKT_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AKT_ST_QD ON AKT_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AKT_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) AKT_PT_QD ON AKT_PT_QD.TOAANID = DMTA.ID  
                                        --Án khác  
                                        --Phá sản
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM APS_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM APS_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM APS_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                  GROUP BY QD.TOAANID) APS_ST_QD ON APS_ST_QD.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM APS_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM APS_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) APS_PT_QD ON APS_PT_QD.TOAANID = DMTA.ID

                                        -- Xử lý hành chính                                           
                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM XLHC_SOTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM XLHC_SOTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) XLHC_ST_QD ON XLHC_ST_QD.TOAANID = DMTA.ID

                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM XLHC_PHUCTHAM_QUYETDINH QD 
                                                       INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND (DMQD.TEN LIKE '%Quyết định mở phiên họp%' OR DMQD.LOAIID = 5)
                                                   WHERE QD.HINHTHUCXETXU IN (1,3) AND (EXISTS (SELECT 'X' FROM XLHC_PHUCTHAM_BANAN BA WHERE QD.DONID = BA.DONID AND BA.NGAYMOPHIENTOA BETWEEN VV_TUNGAY AND VV_DENNGAY ) 
                                                                                     OR EXISTS (SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH QD2
                                                                                                INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = QD2.QUYETDINHID AND DMQD2.KET_THUC = 1
                                                                                                WHERE QD.DONID = QD2.DONID AND QD2.NGAYMOPT BETWEEN VV_TUNGAY AND VV_DENNGAY))
                                                   GROUP BY QD.TOAANID) XLHC_PT_QD ON XLHC_PT_QD.TOAANID = DMTA.ID


                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM APS_CAPNHAT_HTXX WHERE MAGIAIDOAN = 2 AND TRANGTHAI = 1  AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) STPS_BOSUNG ON STPS_BOSUNG.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM APS_CAPNHAT_HTXX WHERE MAGIAIDOAN = 3 AND TRANGTHAI = 1  AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) PTPS_BOSUNG ON PTPS_BOSUNG.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM XLHC_CAPNHAT_HTXX WHERE MAGIAIDOAN = 2 AND TRANGTHAI = 1  AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) STXLHC_BOSUNG ON STXLHC_BOSUNG.TOAANID = DMTA.ID
                                        LEFT JOIN (SELECT TOAANID, COUNT('X') AS SL FROM XLHC_CAPNHAT_HTXX WHERE MAGIAIDOAN = 3 AND TRANGTHAI = 1  AND NGAYXETXU BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY TOAANID) PTXLHC_BOSUNG ON PTXLHC_BOSUNG.TOAANID = DMTA.ID



--                                        --Hình sự
--                                        LEFT JOIN (SELECT QD.DONVIID, COUNT('X') AS SL FROM AHS_SOTHAM_QUYETDINH_VUAN QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (81) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.DONVIID) AHS_ST_QD ON AHS_ST_QD.DONVIID = DMTA.ID                                               
--                                        LEFT JOIN (SELECT QD.DONVIID, COUNT('X') AS SL FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (82) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.DONVIID) AHS_PT_QD ON AHS_PT_QD.DONVIID = DMTA.ID
--                                        --Dân sự
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ADS_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (46,65,398,426) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) ADS_ST_QD ON ADS_ST_QD.TOAANID = DMTA.ID                                    
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ADS_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (64,65) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) ADS_PT_QD ON ADS_PT_QD.TOAANID = DMTA.ID
--                                        --Hành chính
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHC_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (111,113,114) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) AHC_ST_QD ON AHC_ST_QD.TOAANID = DMTA.ID              
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHC_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (111,113,114) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) AHC_PT_QD ON AHC_PT_QD.TOAANID = DMTA.ID
--                                        --Hôn nhân
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHN_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (46,65,398,426) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) AHN_ST_QD ON AHN_ST_QD.TOAANID = DMTA.ID
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AHN_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (64,65) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) AHN_PT_QD ON AHN_PT_QD.TOAANID = DMTA.ID
--                                        --Lao động
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ALD_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (46,65,398,426) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) ALD_ST_QD ON ALD_ST_QD.TOAANID = DMTA.ID
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM ALD_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (64,65) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) ALD_PT_QD ON ALD_PT_QD.TOAANID = DMTA.ID
--                                        --Kinh tế
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AKT_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (46,65,398,426) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) AKT_ST_QD ON AKT_ST_QD.TOAANID = DMTA.ID
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM AKT_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (64,65) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) AKT_PT_QD ON AKT_PT_QD.TOAANID = DMTA.ID  
--                                        --Án khác           
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM APS_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (46,65,398,426) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) APS_ST_QD ON APS_ST_QD.TOAANID = DMTA.ID
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM APS_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (64,65) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) APS_PT_QD ON APS_PT_QD.TOAANID = DMTA.ID
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM XLHC_SOTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (46,65,398,426,441) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) XLHC_ST_QD ON XLHC_ST_QD.TOAANID = DMTA.ID
--                                        LEFT JOIN (SELECT QD.TOAANID, COUNT('X') AS SL FROM XLHC_PHUCTHAM_QUYETDINH QD WHERE QD.HINHTHUCXETXU IN (1,3) AND QD.QUYETDINHID IN (64,66) AND NGAYQD BETWEEN VV_TUNGAY AND VV_DENNGAY GROUP BY QD.TOAANID) XLHC_PT_QD ON XLHC_PT_QD.TOAANID = DMTA.ID                       

                                    WHERE DMTA.HIEULUC = 1 AND DMTA.LOAITOA IN ('CAPCAO') 
                                                           AND (instr(','||v_TOAANID||',',','||DMTA.ID||',')>0 )

                                    ) JJ

                                LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = JJ.ID
                                ORDER BY DMTA.ARRSAPXEP)
            LOOP
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr style="text-align: center; vertical-align: middle; height:50px">
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STT||'</td>');

                    IF(VDONVIID IN (1,4,5,6)) 
                        THEN DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 0.1pt solid #000000; color:#FF0000; text-align: left;" colspan="2"><b>'||v_DM_TOAAN.MA_TEN||'</b></td>');
                        ELSE DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 0.1pt solid #000000; text-align: left;" colspan="2">'||v_DM_TOAAN.MA_TEN||'</td>');
                    END IF;

                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STHS||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.PTHS||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STHC||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.PTHC||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STDS||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.PTDS||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STHN||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.PTHN||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STLD||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.PTLD||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.STKT||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.PTKT||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.ANKHAC||'</td>
                    <td style="border: 0.1pt solid #000000;">'||v_DM_TOAAN.ROW_SUM||'</td>
                </tr>');

                VV_SUM_STHS := VV_SUM_STHS + v_DM_TOAAN.STHS; 
                VV_SUM_PTHS := VV_SUM_PTHS + v_DM_TOAAN.PTHS; 
                VV_SUM_STHC := VV_SUM_STHC + v_DM_TOAAN.STHC; 
                VV_SUM_PTHC := VV_SUM_PTHC + v_DM_TOAAN.PTHC; 
                VV_SUM_STDS := VV_SUM_STDS + v_DM_TOAAN.STDS; 
                VV_SUM_PTDS := VV_SUM_PTDS + v_DM_TOAAN.PTDS; 
                VV_SUM_STHN := VV_SUM_STHN + v_DM_TOAAN.STHN; 
                VV_SUM_PTHN := VV_SUM_PTHN + v_DM_TOAAN.PTHN; 
                VV_SUM_STLD := VV_SUM_STLD + v_DM_TOAAN.STLD; 
                VV_SUM_PTLD := VV_SUM_PTLD + v_DM_TOAAN.PTLD; 
                VV_SUM_STKT := VV_SUM_STKT + v_DM_TOAAN.STKT; 
                VV_SUM_PTKT := VV_SUM_PTKT + v_DM_TOAAN.PTKT;
                VV_SUM_ANKHAC := VV_SUM_ANKHAC + v_DM_TOAAN.ANKHAC;
                VV_SUM_ROW_SUM := VV_SUM_ROW_SUM + v_DM_TOAAN.ROW_SUM;

        END LOOP;

        END IF;

        DBMS_LOB.APPEND(V_EXPORT_TEXT_FOOTER,' 
            <tr></tr>
            <tr style="text-align: center; vertical-align: middle; height:50px">
                <td style="border: 0.1pt solid #000000;" colspan ="3"><b>Tổng số vụ án: </b></td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_STHS||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_PTHS||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_STHC||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_PTHC||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_STDS||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_PTDS||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_STHN||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_PTHN||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_STLD||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_PTLD||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_STKT||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_PTKT||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_ANKHAC||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="1">'||VV_SUM_ROW_SUM||'</td>
            </tr>
            <tr style="text-align: center; vertical-align: middle; height:50px">
                <td style="border: 0.1pt solid #000000;" colspan ="3"><b>Tổng cộng: </b></td>
                <td style="border: 0.1pt solid #000000;" colspan ="2">'||(VV_SUM_STHS + VV_SUM_PTHS)||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="2">'||(VV_SUM_STHC + VV_SUM_PTHC)||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="2">'||(VV_SUM_STDS + VV_SUM_PTDS)||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="2">'||(VV_SUM_STHN + VV_SUM_PTHN)||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="2">'||(VV_SUM_STLD + VV_SUM_PTLD)||'</td>
                <td style="border: 0.1pt solid #000000;" colspan ="2">'||(VV_SUM_STKT + VV_SUM_PTKT)||'</td>
                <td style="border: 0.1pt solid #000000;">'||VV_SUM_ANKHAC||'</td>
                <td style="border: 0.1pt solid #000000;">'||VV_SUM_ROW_SUM||'</td>
            </tr>');                

        DBMS_LOB.APPEND(V_EXPORT_TEXT_FOOTER,' 
            <tr>
                <td style="width: 41px"></td>
                <td style="width: 123px"></td>
                <td style="width: 237px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
                <td style="width: 73px"></td>
            </tr>
            </table>');

    V_EXPORT_TEXT := V_EXPORT_TEXT_HEAD1 
                    || '<td colspan= "1"; rowspan= "3" color:#FFFF00; ><b>' || VV_SUM_ROW_SUM || '</b></td>' 
                    || V_EXPORT_TEXT_HEAD2

                    || V_EXPORT_TEXT

                    || V_EXPORT_TEXT_CAPCAO
                    || V_EXPORT_TEXT_FOOTER;

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT_HEAD1);
        dbms_lob.freetemporary(V_EXPORT_TEXT_HEAD2);
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        dbms_lob.freetemporary(V_EXPORT_TEXT_CAPCAO);
        dbms_lob.freetemporary(V_EXPORT_TEXT_FOOTER);
        RETURN V_CURSOR;  

END BAOCAO_XETXUTRUCTUYEN;

PROCEDURE DANHSACH_CAPNHAT_HINHTHUCXETXU
(
    VTOAANID IN NUMBER,
    VLOAIAN IN NUMBER,
    VTRANGTHAI IN NUMBER,
    VCHUTOAID IN NUMBER,
    VBAQDTUNGAY VARCHAR2,
    VBAQDDENNGAY VARCHAR2,
    curReturn OUT sys_refcursor
)
AS  
    V_BAQDTUNGAY DATE;
    V_BAQDDENNGAY DATE;
BEGIN

     if(VBAQDTUNGAY IS NOT NULL) then  V_BAQDTUNGAY:=to_date(trim(VBAQDTUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(VBAQDDENNGAY IS NOT NULL) then  V_BAQDDENNGAY:=to_date(trim(VBAQDDENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 

    -- Thêm loại án thì đổi SELECT LOAIANID và LOAIAN
    IF(VLOAIAN = 7) THEN -- PHÁ SẢN
        OPEN curReturn FOR 
            SELECT TT.*
            FROM (SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, A.ID,
                        'Phá sản' AS LOAIAN, '7' AS LOAIANID,
                        DECODE(A.MAGIAIDOAN,2,'ST-',3,'PT-','') || A.TENVUAN AS TENVUAN,
                        TO_CHAR(A.NGAYXETXU, 'DD/MM/YYYY') AS NGAYXETXU, 
                        DECODE(A.LOAIBAQD,1,'BA ', 2, 'QĐ ', '') || DECODE(A.SOBAQD,NULL, '' , 'số: ' || A.SOBAQD || ' ngày: ' || TO_CHAR(A.NGAYBAQD, 'DD/MM/YYYY') || '; ')  AS SONGAYBAQD,
                        CHUTOA.HOTEN AS TENCHUTOA,
                        (SELECT LISTAGG(c.HOTEN, ', ') WITHIN GROUP (ORDER BY c.ID) AS TENTHUKY
                         FROM   DM_CANBO c
                         WHERE  c.ID In (SELECT Regexp_Substr(A.THUKY_IDS ,'[^,]+' ,1 ,Level) IDS
                                         FROM   Dual
                                         Connect By Regexp_Substr(A.THUKY_IDS ,'[^,]+', 1,Level) Is Not Null)) as TENTHUKY,

                        DECODE(A.PHONGXETXU, NULL, '', A.PHONGXETXU || ';') || CHR(10) || DECODE(A.DIEMCAU_1 , NULL, '', A.DIEMCAU_1 || ';') || CHR(10) || DECODE(A.DIEMCAU_2 , NULL, '', A.DIEMCAU_2 || ';') AS DIEMCAU,

                        DECODE(A.TRANGTHAI, 1, 'Đã xét xử', 2, 'Hoãn xét xử', 3, 'Chưa xét xử', '') AS TRANGTHAI,
                        A.GHICHU,
                        A.NGUOITAO || CHR(10) || TO_CHAR(A.NGAYTAO, 'DD/MM/YYYY') AS NGUOITAO
                  FROM APS_CAPNHAT_HTXX A
                      INNER JOIN DM_CANBO CHUTOA ON CHUTOA.ID = A.CHUTOAID
                  WHERE A.TOAANID = VTOAANID AND A.TRANGTHAI = VTRANGTHAI
                    AND (VBAQDTUNGAY IS NULL OR A.NGAYBAQD >= V_BAQDTUNGAY)
                    AND (VBAQDDENNGAY IS NULL OR A.NGAYBAQD <= V_BAQDDENNGAY)
                    AND (VCHUTOAID = 0 OR A.CHUTOAID = VCHUTOAID)) TT;




     ELSIF(VLOAIAN = 8) THEN
        OPEN curReturn FOR 
            SELECT TT.*
            FROM (SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, A.ID,
                        'Biện pháp xử lý hành chính' AS LOAIAN, '8' AS LOAIANID,
                        DECODE(A.MAGIAIDOAN,2,'ST-',3,'PT-','') || A.TENVUAN AS TENVUAN,
                        TO_CHAR(A.NGAYXETXU, 'DD/MM/YYYY') AS NGAYXETXU,
                        DECODE(A.LOAIBAQD,1,'BA ', 2, 'QĐ ', '') || DECODE(A.SOBAQD,NULL, '' , 'số: ' || A.SOBAQD || ' ngày: ' || TO_CHAR(A.NGAYBAQD, 'DD/MM/YYYY') || '; ')  AS SONGAYBAQD,
                        CHUTOA.HOTEN AS TENCHUTOA,
                        (SELECT LISTAGG(c.HOTEN, ', ') WITHIN GROUP (ORDER BY c.ID) AS TENTHUKY
                         FROM   DM_CANBO c
                         WHERE  c.ID In (SELECT Regexp_Substr(A.THUKY_IDS ,'[^,]+' ,1 ,Level) IDS
                                         FROM   Dual
                                         Connect By Regexp_Substr(A.THUKY_IDS ,'[^,]+', 1,Level) Is Not Null)) as TENTHUKY,
                        DECODE(A.PHONGXETXU, NULL, '', A.PHONGXETXU || ';') || CHR(10) || DECODE(A.DIEMCAU_1 , NULL, '', A.DIEMCAU_1 || ';') || CHR(10) || DECODE(A.DIEMCAU_2 , NULL, '', A.DIEMCAU_2 || ';') AS DIEMCAU,

                        DECODE(A.TRANGTHAI, 1, 'Đã xét xử', 2, 'Hoãn xét xử', 3, 'Chưa xét xử', '') AS TRANGTHAI,
                        A.GHICHU,
                        A.NGUOITAO || CHR(10) || TO_CHAR(A.NGAYTAO, 'DD/MM/YYYY') AS NGUOITAO
                  FROM XLHC_CAPNHAT_HTXX A
                      INNER JOIN DM_CANBO CHUTOA ON CHUTOA.ID = A.CHUTOAID
                 WHERE A.TOAANID = VTOAANID AND A.TRANGTHAI = VTRANGTHAI
                    AND (VBAQDTUNGAY IS NULL OR A.NGAYBAQD >= V_BAQDTUNGAY)
                    AND (VBAQDDENNGAY IS NULL OR A.NGAYBAQD <= V_BAQDDENNGAY)
                    AND (VCHUTOAID = 0 OR A.CHUTOAID = VCHUTOAID)) TT;


     END IF;     


END DANHSACH_CAPNHAT_HINHTHUCXETXU;






END PKG_STPT_HINHTHUCXETXU;
