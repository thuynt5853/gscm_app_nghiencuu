--------------------------------------------------------
--  DDL for Package Body PKG_LOAD_PAGE_KHANGCAO_ST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_LOAD_PAGE_KHANGCAO_ST" AS

-- Load bản án để kháng cáo
PROCEDURE DANHSACH_KHANGCAO_BANAN
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    

    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR  
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYBANAN,'dd/MM/yyyy') AS TEN
            FROM AHS_SOTHAM_BANAN
            WHERE VUANID = VDONID
            ORDER BY NGAYBANAN;
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
        OPEN curReturn FOR
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYTUYENAN,'dd/MM/yyyy') AS TEN
            FROM ADS_SOTHAM_BANAN
            WHERE DONID = VDONID
            ORDER BY NGAYTUYENAN;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình
        OPEN curReturn FOR
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYTUYENAN,'dd/MM/yyyy') AS TEN
            FROM AHN_SOTHAM_BANAN
            WHERE DONID = VDONID
            ORDER BY NGAYTUYENAN;
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế
        OPEN curReturn FOR
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYTUYENAN,'dd/MM/yyyy') AS TEN
            FROM AKT_SOTHAM_BANAN
            WHERE DONID = VDONID
            ORDER BY NGAYTUYENAN;
    ELSIF(VLOAIAN = '5') THEN -- Lao động
        OPEN curReturn FOR
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYTUYENAN,'dd/MM/yyyy') AS TEN
            FROM ALD_SOTHAM_BANAN
            WHERE DONID = VDONID
            ORDER BY NGAYTUYENAN;
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
        OPEN curReturn FOR
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYTUYENAN,'dd/MM/yyyy') AS TEN
            FROM AHC_SOTHAM_BANAN
            WHERE DONID = VDONID
            ORDER BY NGAYTUYENAN;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản
        OPEN curReturn FOR
            SELECT ID, 'Số: ' || SOBANAN || ' - Ngày ' || TO_CHAR(NGAYTUYENAN,'dd/MM/yyyy') AS TEN
            FROM APS_SOTHAM_BANAN
            WHERE DONID = VDONID
            ORDER BY NGAYTUYENAN;
    END IF;
END DANHSACH_KHANGCAO_BANAN;

-- Load quyết định để kháng cáo (quyết định gây kết thúc)
PROCEDURE DANHSACH_KHANGCAO_QUYETDINH
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    

    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR  
            SELECT QD.ID, 'Số: ' || SOQUYETDINH || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE VUANID = VDONID
--            UNION
--            SELECT QD.ID, 'Số: ' || SOQUYETDINH || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
--            FROM AHS_SOTHAM_QUYETDINH_BICAN QD
--                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
--            WHERE VUANID = VDONID
--            ORDER BY TEN
            ;
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM ADS_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE DONID = VDONID
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AHN_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE DONID = VDONID
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AKT_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE DONID = VDONID
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '5') THEN -- Lao động
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM ALD_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE DONID = VDONID
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AHC_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE DONID = VDONID
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM APS_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 1
            WHERE DONID = VDONID
            ORDER BY NGAYQD;
    END IF;
END DANHSACH_KHANGCAO_QUYETDINH;

-- Load quyết định khác để kháng cáo (quyết định không gây kết thúc)
PROCEDURE DANHSACH_KHANGCAO_QUYETDINH_KHAC
    (
        VLOAIAN VARCHAR2,
        VDONID NUMBER,
        curReturn OUT SYS_REFCURSOR
    ) AS           
  BEGIN    

    IF(VLOAIAN = '1') THEN -- Hình sự
        OPEN curReturn FOR  
            SELECT QD.ID, 'Số: ' || SOQUYETDINH || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0
            WHERE VUANID = VDONID
--            UNION
--            SELECT QD.ID, 'Số: ' || SOQUYETDINH || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
--            FROM AHS_SOTHAM_QUYETDINH_BICAN QD
--                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0
--            WHERE VUANID = VDONID
--            ORDER BY TEN
            ;
    ELSIF(VLOAIAN = '2') THEN -- Dân sự
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM ADS_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0 AND (DMQD.ISDANSU = 1)
                INNER JOIN DM_QD_LOAI QDL ON QDL.ID = DMQD.LOAIID
            WHERE DONID = VDONID AND QDL.MA = 'TDC'  --toancau chỉ lấy QĐ tđc
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '3') THEN -- Hôn nhân và gia đình
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AHN_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0 AND (DMQD.ISHNGD = 1)
                INNER JOIN DM_QD_LOAI QDL ON QDL.ID = DMQD.LOAIID
            WHERE DONID = VDONID AND QDL.MA = 'TDC' --toancau chỉ lấy QĐ tđc
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '4') THEN -- Kinh tế
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AKT_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0 AND (DMQD.ISKDTM = 1)
                INNER JOIN DM_QD_LOAI QDL ON QDL.ID = DMQD.LOAIID
            WHERE DONID = VDONID AND QDL.MA = 'TDC'  --toancau chỉ lấy QĐ tđc
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '5') THEN -- Lao động
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM ALD_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0 AND (DMQD.ISLAODONG = 1)
                INNER JOIN DM_QD_LOAI QDL ON QDL.ID = DMQD.LOAIID
            WHERE DONID = VDONID AND QDL.MA = 'TDC'  --toancau chỉ lấy QĐ tđc
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '6') THEN -- Hành chính
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM AHC_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0 AND (DMQD.ISHANHCHINH = 1)
                INNER JOIN DM_QD_LOAI QDL ON QDL.ID = DMQD.LOAIID
            WHERE DONID = VDONID AND QDL.MA = 'TDC'  --toancau chỉ lấy QĐ tđc
            ORDER BY NGAYQD;
    ELSIF(VLOAIAN = '7') THEN -- Phá sản
        OPEN curReturn FOR
            SELECT QD.ID, 'Số: ' || SOQD || ' - Ngày ' || TO_CHAR(NGAYQD,'dd/MM/yyyy') AS TEN
            FROM APS_SOTHAM_QUYETDINH QD
                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.KET_THUC = 0 AND (DMQD.ISPHASAN = 1)
                INNER JOIN DM_QD_LOAI QDL ON QDL.ID = DMQD.LOAIID
            WHERE DONID = VDONID AND QDL.MA = 'TDC'  --toancau chỉ lấy QĐ tđc
            ORDER BY NGAYQD;
    END IF;
END DANHSACH_KHANGCAO_QUYETDINH_KHAC;

END PKG_LOAD_PAGE_KHANGCAO_ST;
