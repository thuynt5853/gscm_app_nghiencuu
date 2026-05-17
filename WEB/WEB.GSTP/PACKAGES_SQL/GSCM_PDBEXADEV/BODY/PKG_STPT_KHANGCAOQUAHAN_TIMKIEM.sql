--------------------------------------------------------
--  DDL for Package Body PKG_STPT_KHANGCAOQUAHAN_TIMKIEM
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_KHANGCAOQUAHAN_TIMKIEM" AS

PROCEDURE        ADS_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--
    ITEM_THONGTINVUVIEC     VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_1                 VARCHAR(2000);
    ITEM_NGUOI_2                 VARCHAR(2000);
    ITEM_NGUOI_3                 VARCHAR(2000);
    ITEM_NGUOI_4                 VARCHAR(2000);
    ITEM_NGUOI_5                 VARCHAR(2000);

BEGIN
        ITEM_LOAIAN := 'DS';

        BEGIN        
            SELECT TA.TEN, UPPER(TA.TEN) INTO ITEM_TENTOAAN, ITEM_TENTOAANHOA
            FROM DM_TOAAN TA
            WHERE TA.ID = VTOAANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENTOAAN := ''; ITEM_TENTOAANHOA := '';
        END;

        BEGIN
            SELECT SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD), NVL(LYDOKCQH,'') INTO ITEM_SOQD, ITEM_LYDOKCQH
            FROM KHANGCAOQUAHAN_QUYETDINH QD
            WHERE QD.DONID = VDONID AND QD.THULYID = VTHULY_KCQH_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_SOQD := ''; ITEM_LYDOKCQH := 0;
        END;

        BEGIN
            SELECT 'ngày ' || EXTRACT(DAY FROM  KC.NGAYKHANGCAO) || ' tháng ' || EXTRACT(MONTH FROM  KC.NGAYKHANGCAO) || ' năm ' || EXTRACT(YEAR FROM  KC.NGAYKHANGCAO),
                   KC.NOIDUNGKHANGCAO,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.TCTTNGUOIKC, DS1.TCTTNGUOIKC) AS TCTTNGUOIKC,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.HOTENNGUOIKC, DS1.HOTENNGUOIKC) AS HOTENNGUOIKC,
                   DECODE(DS1.DIACHI, NULL, DS2.DIACHI, DS1.DIACHI) AS DIACHINGUOIKC,
                   DECODE(KC.LOAIKHANGCAO, 0, 'Bản án', 'Quyết định'),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.NGAYBA , QD.NGAYQD),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.SOBANAN, QD.SOQD),
                   TA.TEN,
                   '"' || DON.QUANHEPHAPLUAT_NAME || '"',
                   'giữa Nguyên đơn là ' || NGUYENDON.HOTEN ||  ' và Bị đơn là ' || BIDON.HOTEN

                   INTO ITEM_NGAYKC, ITEM_YEUCAUKHANGCAO, ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC, ITEM_DIACHINGUOIKC,
                        ITEM_LOAIBAQD, ITEM_NGAYBAQDST, ITEM_SOBAQD, 
                        ITEM_TENTOAANST, ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC

            FROM ADS_SOTHAM_KHANGCAO KC

                LEFT JOIN ADS_DON DON ON DON.ID = KC.DONID

                LEFT JOIN DM_TOAAN TA ON TA.ID = KC.TOAANRAQDID

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYTUYENAN) || ' tháng ' || EXTRACT(MONTH FROM  NGAYTUYENAN) || ' năm ' || EXTRACT(YEAR FROM  NGAYTUYENAN) AS NGAYBA, ID, SOBANAN || '/' || EXTRACT(YEAR FROM NGAYTUYENAN) AS SOBANAN
                           FROM ADS_SOTHAM_BANAN BA) BA ON BA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 0

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD) AS SOQD
                           FROM ADS_SOTHAM_QUYETDINH) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO > 0

                --Lấy tên nguyên đơn
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM ADS_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'NGUYENDON' AND DUONGSU.ISDAIDIEN = 1) NGUYENDON ON NGUYENDON.DONID = KC.DONID
                --Lấy tên bị đơn           
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM ADS_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'BIDON' AND DUONGSU.ISDAIDIEN = 1) BIDON ON BIDON.DONID = KC.DONID

                -- Lấy thông tin người kháng cáo        
                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.TENDUONGSU AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM ADS_DON_DUONGSU DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTOTUNG_MA
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS1 ON DS1.ID = KC.DUONGSUID AND DS1.DONID = KC.DONID

                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.HOTEN AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM ADS_DON_THAMGIATOTUNG DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS2 ON DS2.ID = KC.DUONGSUID AND DS2.DONID = KC.DONID

            WHERE KC.ID = VKHANGCAOID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_NGAYKC := ''; ITEM_YEUCAUKHANGCAO := '';
        END;

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN, A.NGUOIKY  INTO CHECKNUMBER, ITEM_HOTENTPCHUTOA, ITEM_NGUOIKY
            FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER ,
                         DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN, CB.HOTEN AS NGUOIKY
                  FROM KHANGCAOQUAHAN_HDXX TP
                      LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                  WHERE TP.THULYID = VTHULY_KCQH_ID AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHAN') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_HOTENTPCHUTOA := ''; ITEM_NGUOIKY := '';
        END;     

        BEGIN 
            SELECT A.ROWNUMBER, A.HOTEN  INTO CHECKNUMBER, ITEM_HOTENTP1
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN--INTO ITEM_HOTENTPCHUTOA
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP1 := '';
        END; 

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN INTO CHECKNUMBER, ITEM_HOTENTP2
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 2; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP2 := '';
        END;

        BEGIN     
            SELECT TEN INTO ITEM_TENVKSND
            FROM DM_VKS 
            WHERE ID = VTOAANID;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENVKSND := '';
        END;         

        BEGIN     
            SELECT A.ROWNUMBER, A.HOTENKSV  INTO CHECKNUMBER, ITEM_HOTENKSV
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.NGAYNHANPHANCONG, TP.ID) ROWNUMBER,
                           DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN  AS HOTENKSV
                    FROM KHANGCAOQUAHAN_HDXX TP
                        LEFT JOIN DM_CANBOVKS CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'KSV') A
            WHERE A.ROWNUMBER = 1;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENKSV := '';
        END; 

        CHECKNUMBER := 0;
        SELECT COUNT('X') INTO CHECKNUMBER FROM KHANGCAOQUAHAN_QUYETDINH WHERE THULYID = VTHULY_KCQH_ID AND KETQUA = 2;
        IF(CHECKNUMBER > 0) THEN

            BEGIN
            -- Lấy Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_1.ITEM_NGUOI_1 INTO ITEM_NGUOI_1
                FROM ADS_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_1
                               FROM ADS_DON_THAMGIATOTUNG TGTT
                                   LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                               WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                               GROUP BY TGTT.DONID, TGTT.DUONGSUID
                               ) NGUOI_1 ON NGUOI_1.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_1.DONID
                WHERE KC.ID = VKHANGCAOID;
                ITEM_NGUOI_1 := 'a';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_1 := 'a';
            END;

            BEGIN
            -- Lấy Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            */   
                SELECT NGUOI_2.ITEM_NGUOI_2 INTO ITEM_NGUOI_2
                FROM ADS_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_2
                                FROM ADS_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_2 ON NGUOI_2.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_2.DONID
                WHERE KC.ID = VKHANGCAOID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_2 := '';
            END;

            BEGIN
            -- Lấy Người có quyền lợi, nghĩa vụ liên quan  
                SELECT NGUOI_3.ITEM_NGUOI_3 INTO ITEM_NGUOI_3
                FROM ADS_SOTHAM_KHANGCAO KC     
                    LEFT JOIN (SELECT DS.DONID, LISTAGG(DS.TENDUONGSU /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN))*/, ', ') WITHIN GROUP (ORDER BY DS.ID) AS ITEM_NGUOI_3
                                FROM ADS_DON_DUONGSU DS
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.HKTTID
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID
                                ) NGUOI_3 ON NGUOI_3.DONID = KC.DONID
                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_3 := '';
            END;

            BEGIN
            --Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_4.ITEM_NGUOI_4 INTO ITEM_NGUOI_4
                FROM ADS_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM ADS_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_4
                                FROM ADS_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_4 ON NGUOI_4.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%' AND KC.DONID = NGUOI_4.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_4 := '';
            END;

            BEGIN
            --Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            ĐƯỢC GÁN VỚI DUONGSUID CỦA NGƯỜI CÓ QLNVLQ
            */
                SELECT NGUOI_5.ITEM_NGUOI_5 INTO ITEM_NGUOI_5
                FROM ADS_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM ADS_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_5
                                FROM ADS_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_5 ON NGUOI_5.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%'   AND KC.DONID = NGUOI_5.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_5 := '';
            END;            

        END IF;

    OPEN CURRETURN FOR      
        SELECT ITEM_TENTOAAN AS ITEM_TENTOAAN, ITEM_TENTOAANHOA AS ITEM_TENTOAANHOA, ITEM_LOAIAN AS ITEM_LOAIAN,

                ITEM_SOQD AS ITEM_SOQD, ITEM_NGAYKC AS ITEM_NGAYKC, ITEM_LYDOKCQH AS ITEM_LYDOKCQH,

                ITEM_NGUOIKY AS ITEM_NGUOIKY, ITEM_HOTENTPCHUTOA AS ITEM_HOTENTPCHUTOA, ITEM_HOTENTP1 AS ITEM_HOTENTP1, ITEM_HOTENTP2 AS ITEM_HOTENTP2,

                ITEM_TENVKSND AS ITEM_TENVKSND, ITEM_HOTENKSV AS ITEM_HOTENKSV,

                ITEM_TCTTNGUOIKC AS ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC AS ITEM_HOTENNGUOIKC, ITEM_YEUCAUKHANGCAO AS ITEM_YEUCAUKHANGCAO, ITEM_DIACHINGUOIKC AS ITEM_DIACHINGUOIKC,
                ITEM_TCTTNGUOIBK AS ITEM_TCTTNGUOIBK, ITEM_HOTENNGUOIBK AS ITEM_HOTENNGUOIBK,

                ITEM_LOAIBAQD AS ITEM_LOAIBAQD, ITEM_NGAYBAQDST AS ITEM_NGAYBAQDST, ITEM_SOBAQD AS ITEM_SOBAQD, ITEM_TENTOAANST AS ITEM_TENTOAANST,
                ITEM_QHPLTEXT AS ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC AS ITEM_THONGTINVUVIEC,

                ITEM_NGUOI_1 AS ITEM_NGUOI_1, ITEM_NGUOI_2 AS ITEM_NGUOI_2, ITEM_NGUOI_3 AS ITEM_NGUOI_3, ITEM_NGUOI_4 AS ITEM_NGUOI_4, ITEM_NGUOI_5 AS ITEM_NGUOI_5
        FROM DUAL;

END ADS_PT_KCQUAHAN_PRINT;

PROCEDURE        AHC_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--
    ITEM_THONGTINVUVIEC     VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_1                 VARCHAR(2000);
    ITEM_NGUOI_2                 VARCHAR(2000);
    ITEM_NGUOI_3                 VARCHAR(2000);
    ITEM_NGUOI_4                 VARCHAR(2000);
    ITEM_NGUOI_5                 VARCHAR(2000);

BEGIN
        ITEM_LOAIAN := 'HC';

        BEGIN        
            SELECT TA.TEN, UPPER(TA.TEN) INTO ITEM_TENTOAAN, ITEM_TENTOAANHOA
            FROM DM_TOAAN TA
            WHERE TA.ID = VTOAANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENTOAAN := ''; ITEM_TENTOAANHOA := '';
        END;

        BEGIN
            SELECT SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD), NVL(LYDOKCQH,'') INTO ITEM_SOQD, ITEM_LYDOKCQH
            FROM KHANGCAOQUAHAN_QUYETDINH QD
            WHERE QD.DONID = VDONID AND QD.THULYID = VTHULY_KCQH_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_SOQD := ''; ITEM_LYDOKCQH := 0;
        END;

        BEGIN
            SELECT 'ngày ' || EXTRACT(DAY FROM  KC.NGAYKHANGCAO) || ' tháng ' || EXTRACT(MONTH FROM  KC.NGAYKHANGCAO) || ' năm ' || EXTRACT(YEAR FROM  KC.NGAYKHANGCAO),
                   KC.NOIDUNGKHANGCAO,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.TCTTNGUOIKC, DS1.TCTTNGUOIKC) AS TCTTNGUOIKC,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.HOTENNGUOIKC, DS1.HOTENNGUOIKC) AS HOTENNGUOIKC,
                   DECODE(DS1.DIACHI, NULL, DS2.DIACHI, DS1.DIACHI) AS DIACHINGUOIKC,
                   DECODE(KC.LOAIKHANGCAO, 0, 'Bản án', 'Quyết định'),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.NGAYBA , QD.NGAYQD),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.SOBANAN, QD.SOQD),
                   TA.TEN,
                   '"' || DON.QUANHEPHAPLUAT_NAME || '"',
                   'giữa Nguyên đơn là ' || NGUYENDON.HOTEN ||  ' và Bị đơn là ' || BIDON.HOTEN

                   INTO ITEM_NGAYKC, ITEM_YEUCAUKHANGCAO, ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC, ITEM_DIACHINGUOIKC,
                        ITEM_LOAIBAQD, ITEM_NGAYBAQDST, ITEM_SOBAQD, 
                        ITEM_TENTOAANST, ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC

            FROM AHC_SOTHAM_KHANGCAO KC

                LEFT JOIN AHC_DON DON ON DON.ID = KC.DONID

                LEFT JOIN DM_TOAAN TA ON TA.ID = KC.TOAANRAQDID

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYTUYENAN) || ' tháng ' || EXTRACT(MONTH FROM  NGAYTUYENAN) || ' năm ' || EXTRACT(YEAR FROM  NGAYTUYENAN) AS NGAYBA, ID, SOBANAN || '/' || EXTRACT(YEAR FROM NGAYTUYENAN) AS SOBANAN
                           FROM AHC_SOTHAM_BANAN BA) BA ON BA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 0

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD) AS SOQD
                           FROM AHC_SOTHAM_QUYETDINH) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO > 0

                --Lấy tên nguyên đơn
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM AHC_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'NGUYENDON' AND DUONGSU.ISDAIDIEN = 1) NGUYENDON ON NGUYENDON.DONID = KC.DONID
                --Lấy tên bị đơn           
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM AHC_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'BIDON' AND DUONGSU.ISDAIDIEN = 1) BIDON ON BIDON.DONID = KC.DONID

                -- Lấy thông tin người kháng cáo        
                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.TENDUONGSU AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM AHC_DON_DUONGSU DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTOTUNG_MA
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS1 ON DS1.ID = KC.DUONGSUID AND DS1.DONID = KC.DONID

                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.HOTEN AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM AHC_DON_THAMGIATOTUNG DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS2 ON DS2.ID = KC.DUONGSUID AND DS2.DONID = KC.DONID

            WHERE KC.ID = VKHANGCAOID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_NGAYKC := ''; ITEM_YEUCAUKHANGCAO := '';
        END;

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN, A.NGUOIKY  INTO CHECKNUMBER, ITEM_HOTENTPCHUTOA, ITEM_NGUOIKY
            FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER ,
                         DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN, CB.HOTEN AS NGUOIKY
                  FROM KHANGCAOQUAHAN_HDXX TP
                      LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                  WHERE TP.THULYID = VTHULY_KCQH_ID AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHAN') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_HOTENTPCHUTOA := ''; ITEM_NGUOIKY := '';
        END; 

        BEGIN 
            SELECT A.ROWNUMBER, A.HOTEN  INTO CHECKNUMBER, ITEM_HOTENTP1
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN--INTO ITEM_HOTENTPCHUTOA
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP1 := '';
        END; 

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN INTO CHECKNUMBER, ITEM_HOTENTP2
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 2; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP2 := '';
        END;

        BEGIN     
            SELECT TEN INTO ITEM_TENVKSND
            FROM DM_VKS 
            WHERE ID = VTOAANID;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENVKSND := '';
        END;         

        BEGIN     
            SELECT A.ROWNUMBER, A.HOTENKSV  INTO CHECKNUMBER, ITEM_HOTENKSV
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.NGAYNHANPHANCONG, TP.ID) ROWNUMBER,
                           DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN  AS HOTENKSV
                    FROM KHANGCAOQUAHAN_HDXX TP
                        LEFT JOIN DM_CANBOVKS CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'KSV') A
            WHERE A.ROWNUMBER = 1;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENKSV := '';
        END; 

        CHECKNUMBER := 0;
        SELECT COUNT('X') INTO CHECKNUMBER FROM KHANGCAOQUAHAN_QUYETDINH WHERE THULYID = VTHULY_KCQH_ID AND KETQUA = 2;
        IF(CHECKNUMBER > 0) THEN

            BEGIN
            -- Lấy Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_1.ITEM_NGUOI_1 INTO ITEM_NGUOI_1
                FROM AHC_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_1
                               FROM AHC_DON_THAMGIATOTUNG TGTT
                                   LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                               WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                               GROUP BY TGTT.DONID, TGTT.DUONGSUID
                               ) NGUOI_1 ON NGUOI_1.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_1.DONID
                WHERE KC.ID = VKHANGCAOID;
                ITEM_NGUOI_1 := 'a';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_1 := 'a';
            END;

            BEGIN
            -- Lấy Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            */   
                SELECT NGUOI_2.ITEM_NGUOI_2 INTO ITEM_NGUOI_2
                FROM AHC_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_2
                                FROM AHC_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_2 ON NGUOI_2.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_2.DONID
                WHERE KC.ID = VKHANGCAOID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_2 := '';
            END;

            BEGIN
            -- Lấy Người có quyền lợi, nghĩa vụ liên quan  
                SELECT NGUOI_3.ITEM_NGUOI_3 INTO ITEM_NGUOI_3
                FROM AHC_SOTHAM_KHANGCAO KC     
                    LEFT JOIN (SELECT DS.DONID, LISTAGG(DS.TENDUONGSU /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN))*/, ', ') WITHIN GROUP (ORDER BY DS.ID) AS ITEM_NGUOI_3
                                FROM AHC_DON_DUONGSU DS
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.HKTTID
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID
                                ) NGUOI_3 ON NGUOI_3.DONID = KC.DONID
                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_3 := '';
            END;

            BEGIN
            --Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_4.ITEM_NGUOI_4 INTO ITEM_NGUOI_4
                FROM AHC_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM AHC_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_4
                                FROM AHC_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_4 ON NGUOI_4.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%' AND KC.DONID = NGUOI_4.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_4 := '';
            END;

            BEGIN
            --Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            ĐƯỢC GÁN VỚI DUONGSUID CỦA NGƯỜI CÓ QLNVLQ
            */
                SELECT NGUOI_5.ITEM_NGUOI_5 INTO ITEM_NGUOI_5
                FROM AHC_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM AHC_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_5
                                FROM AHC_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_5 ON NGUOI_5.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%'   AND KC.DONID = NGUOI_5.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_5 := '';
            END;            

        END IF;

    OPEN CURRETURN FOR      
        SELECT ITEM_TENTOAAN AS ITEM_TENTOAAN, ITEM_TENTOAANHOA AS ITEM_TENTOAANHOA, ITEM_LOAIAN AS ITEM_LOAIAN,

                ITEM_SOQD AS ITEM_SOQD, ITEM_NGAYKC AS ITEM_NGAYKC, ITEM_LYDOKCQH AS ITEM_LYDOKCQH,

                ITEM_NGUOIKY AS ITEM_NGUOIKY, ITEM_HOTENTPCHUTOA AS ITEM_HOTENTPCHUTOA, ITEM_HOTENTP1 AS ITEM_HOTENTP1, ITEM_HOTENTP2 AS ITEM_HOTENTP2,

                ITEM_TENVKSND AS ITEM_TENVKSND, ITEM_HOTENKSV AS ITEM_HOTENKSV,

                ITEM_TCTTNGUOIKC AS ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC AS ITEM_HOTENNGUOIKC, ITEM_YEUCAUKHANGCAO AS ITEM_YEUCAUKHANGCAO, ITEM_DIACHINGUOIKC AS ITEM_DIACHINGUOIKC,
                ITEM_TCTTNGUOIBK AS ITEM_TCTTNGUOIBK, ITEM_HOTENNGUOIBK AS ITEM_HOTENNGUOIBK,

                ITEM_LOAIBAQD AS ITEM_LOAIBAQD, ITEM_NGAYBAQDST AS ITEM_NGAYBAQDST, ITEM_SOBAQD AS ITEM_SOBAQD, ITEM_TENTOAANST AS ITEM_TENTOAANST,
                ITEM_QHPLTEXT AS ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC AS ITEM_THONGTINVUVIEC,

                ITEM_NGUOI_1 AS ITEM_NGUOI_1, ITEM_NGUOI_2 AS ITEM_NGUOI_2, ITEM_NGUOI_3 AS ITEM_NGUOI_3, ITEM_NGUOI_4 AS ITEM_NGUOI_4, ITEM_NGUOI_5 AS ITEM_NGUOI_5
        FROM DUAL;

END AHC_PT_KCQUAHAN_PRINT;

PROCEDURE        AHN_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--
    ITEM_THONGTINVUVIEC     VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_1                 VARCHAR(2000);
    ITEM_NGUOI_2                 VARCHAR(2000);
    ITEM_NGUOI_3                 VARCHAR(2000);
    ITEM_NGUOI_4                 VARCHAR(2000);
    ITEM_NGUOI_5                 VARCHAR(2000);

BEGIN
        ITEM_LOAIAN := 'HN';

        BEGIN        
            SELECT TA.TEN, UPPER(TA.TEN) INTO ITEM_TENTOAAN, ITEM_TENTOAANHOA
            FROM DM_TOAAN TA
            WHERE TA.ID = VTOAANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENTOAAN := ''; ITEM_TENTOAANHOA := '';
        END;

        BEGIN
            SELECT SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD), NVL(LYDOKCQH,'') INTO ITEM_SOQD, ITEM_LYDOKCQH
            FROM KHANGCAOQUAHAN_QUYETDINH QD
            WHERE QD.DONID = VDONID AND QD.THULYID = VTHULY_KCQH_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_SOQD := ''; ITEM_LYDOKCQH := 0;
        END;

        BEGIN
            SELECT 'ngày ' || EXTRACT(DAY FROM  KC.NGAYKHANGCAO) || ' tháng ' || EXTRACT(MONTH FROM  KC.NGAYKHANGCAO) || ' năm ' || EXTRACT(YEAR FROM  KC.NGAYKHANGCAO),
                   KC.NOIDUNGKHANGCAO,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.TCTTNGUOIKC, DS1.TCTTNGUOIKC) AS TCTTNGUOIKC,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.HOTENNGUOIKC, DS1.HOTENNGUOIKC) AS HOTENNGUOIKC,
                   DECODE(DS1.DIACHI, NULL, DS2.DIACHI, DS1.DIACHI) AS DIACHINGUOIKC,
                   DECODE(KC.LOAIKHANGCAO, 0, 'Bản án', 'Quyết định'),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.NGAYBA , QD.NGAYQD),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.SOBANAN, QD.SOQD),
                   TA.TEN,
                   '"' || DON.QUANHEPHAPLUAT_NAME || '"',
                   'giữa Nguyên đơn là ' || NGUYENDON.HOTEN ||  ' và Bị đơn là ' || BIDON.HOTEN

                   INTO ITEM_NGAYKC, ITEM_YEUCAUKHANGCAO, ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC, ITEM_DIACHINGUOIKC,
                        ITEM_LOAIBAQD, ITEM_NGAYBAQDST, ITEM_SOBAQD, 
                        ITEM_TENTOAANST, ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC

            FROM AHN_SOTHAM_KHANGCAO KC

                LEFT JOIN AHN_DON DON ON DON.ID = KC.DONID

                LEFT JOIN DM_TOAAN TA ON TA.ID = KC.TOAANRAQDID

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYTUYENAN) || ' tháng ' || EXTRACT(MONTH FROM  NGAYTUYENAN) || ' năm ' || EXTRACT(YEAR FROM  NGAYTUYENAN) AS NGAYBA, ID, SOBANAN || '/' || EXTRACT(YEAR FROM NGAYTUYENAN) AS SOBANAN
                           FROM AHN_SOTHAM_BANAN BA) BA ON BA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 0

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD) AS SOQD
                           FROM AHN_SOTHAM_QUYETDINH) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO > 0

                --Lấy tên nguyên đơn
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM AHN_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'NGUYENDON' AND DUONGSU.ISDAIDIEN = 1) NGUYENDON ON NGUYENDON.DONID = KC.DONID
                --Lấy tên bị đơn           
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM AHN_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'BIDON' AND DUONGSU.ISDAIDIEN = 1) BIDON ON BIDON.DONID = KC.DONID

                -- Lấy thông tin người kháng cáo        
                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.TENDUONGSU AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM AHN_DON_DUONGSU DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTOTUNG_MA
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS1 ON DS1.ID = KC.DUONGSUID AND DS1.DONID = KC.DONID

                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.HOTEN AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM AHN_DON_THAMGIATOTUNG DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS2 ON DS2.ID = KC.DUONGSUID AND DS2.DONID = KC.DONID

            WHERE KC.ID = VKHANGCAOID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_NGAYKC := ''; ITEM_YEUCAUKHANGCAO := '';
        END;

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN, A.NGUOIKY  INTO CHECKNUMBER, ITEM_HOTENTPCHUTOA, ITEM_NGUOIKY
            FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER ,
                         DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN, CB.HOTEN AS NGUOIKY
                  FROM KHANGCAOQUAHAN_HDXX TP
                      LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                  WHERE TP.THULYID = VTHULY_KCQH_ID AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHAN') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_HOTENTPCHUTOA := ''; ITEM_NGUOIKY := '';
        END;    

        BEGIN 
            SELECT A.ROWNUMBER, A.HOTEN  INTO CHECKNUMBER, ITEM_HOTENTP1
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN--INTO ITEM_HOTENTPCHUTOA
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP1 := '';
        END; 

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN INTO CHECKNUMBER, ITEM_HOTENTP2
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 2; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP2 := '';
        END;

        BEGIN     
            SELECT TEN INTO ITEM_TENVKSND
            FROM DM_VKS 
            WHERE ID = VTOAANID;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENVKSND := '';
        END;         

        BEGIN     
            SELECT A.ROWNUMBER, A.HOTENKSV  INTO CHECKNUMBER, ITEM_HOTENKSV
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.NGAYNHANPHANCONG, TP.ID) ROWNUMBER,
                           DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN  AS HOTENKSV
                    FROM KHANGCAOQUAHAN_HDXX TP
                        LEFT JOIN DM_CANBOVKS CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'KSV') A
            WHERE A.ROWNUMBER = 1;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENKSV := '';
        END; 

        CHECKNUMBER := 0;
        SELECT COUNT('X') INTO CHECKNUMBER FROM KHANGCAOQUAHAN_QUYETDINH WHERE THULYID = VTHULY_KCQH_ID AND KETQUA = 2;
        IF(CHECKNUMBER > 0) THEN

            BEGIN
            -- Lấy Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_1.ITEM_NGUOI_1 INTO ITEM_NGUOI_1
                FROM AHN_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_1
                               FROM AHN_DON_THAMGIATOTUNG TGTT
                                   LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                               WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                               GROUP BY TGTT.DONID, TGTT.DUONGSUID
                               ) NGUOI_1 ON NGUOI_1.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_1.DONID
                WHERE KC.ID = VKHANGCAOID;
                ITEM_NGUOI_1 := 'a';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_1 := 'a';
            END;

            BEGIN
            -- Lấy Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            */   
                SELECT NGUOI_2.ITEM_NGUOI_2 INTO ITEM_NGUOI_2
                FROM AHN_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_2
                                FROM AHN_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_2 ON NGUOI_2.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_2.DONID
                WHERE KC.ID = VKHANGCAOID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_2 := '';
            END;

            BEGIN
            -- Lấy Người có quyền lợi, nghĩa vụ liên quan  
                SELECT NGUOI_3.ITEM_NGUOI_3 INTO ITEM_NGUOI_3
                FROM AHN_SOTHAM_KHANGCAO KC     
                    LEFT JOIN (SELECT DS.DONID, LISTAGG(DS.TENDUONGSU /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN))*/, ', ') WITHIN GROUP (ORDER BY DS.ID) AS ITEM_NGUOI_3
                                FROM AHN_DON_DUONGSU DS
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.HKTTID
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID
                                ) NGUOI_3 ON NGUOI_3.DONID = KC.DONID
                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_3 := '';
            END;

            BEGIN
            --Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_4.ITEM_NGUOI_4 INTO ITEM_NGUOI_4
                FROM AHN_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM AHN_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_4
                                FROM AHN_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_4 ON NGUOI_4.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%' AND KC.DONID = NGUOI_4.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_4 := '';
            END;

            BEGIN
            --Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            ĐƯỢC GÁN VỚI DUONGSUID CỦA NGƯỜI CÓ QLNVLQ
            */
                SELECT NGUOI_5.ITEM_NGUOI_5 INTO ITEM_NGUOI_5
                FROM AHN_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM AHN_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_5
                                FROM AHN_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_5 ON NGUOI_5.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%'   AND KC.DONID = NGUOI_5.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_5 := '';
            END;            

        END IF;

    OPEN CURRETURN FOR      
        SELECT ITEM_TENTOAAN AS ITEM_TENTOAAN, ITEM_TENTOAANHOA AS ITEM_TENTOAANHOA, ITEM_LOAIAN AS ITEM_LOAIAN,

                ITEM_SOQD AS ITEM_SOQD, ITEM_NGAYKC AS ITEM_NGAYKC, ITEM_LYDOKCQH AS ITEM_LYDOKCQH,

                ITEM_NGUOIKY AS ITEM_NGUOIKY, ITEM_HOTENTPCHUTOA AS ITEM_HOTENTPCHUTOA, ITEM_HOTENTP1 AS ITEM_HOTENTP1, ITEM_HOTENTP2 AS ITEM_HOTENTP2,

                ITEM_TENVKSND AS ITEM_TENVKSND, ITEM_HOTENKSV AS ITEM_HOTENKSV,

                ITEM_TCTTNGUOIKC AS ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC AS ITEM_HOTENNGUOIKC, ITEM_YEUCAUKHANGCAO AS ITEM_YEUCAUKHANGCAO, ITEM_DIACHINGUOIKC AS ITEM_DIACHINGUOIKC,
                ITEM_TCTTNGUOIBK AS ITEM_TCTTNGUOIBK, ITEM_HOTENNGUOIBK AS ITEM_HOTENNGUOIBK,

                ITEM_LOAIBAQD AS ITEM_LOAIBAQD, ITEM_NGAYBAQDST AS ITEM_NGAYBAQDST, ITEM_SOBAQD AS ITEM_SOBAQD, ITEM_TENTOAANST AS ITEM_TENTOAANST,
                ITEM_QHPLTEXT AS ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC AS ITEM_THONGTINVUVIEC,

                ITEM_NGUOI_1 AS ITEM_NGUOI_1, ITEM_NGUOI_2 AS ITEM_NGUOI_2, ITEM_NGUOI_3 AS ITEM_NGUOI_3, ITEM_NGUOI_4 AS ITEM_NGUOI_4, ITEM_NGUOI_5 AS ITEM_NGUOI_5
        FROM DUAL;

END AHN_PT_KCQUAHAN_PRINT;

PROCEDURE        AHS_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_SOTHULYST          VARCHAR(250);--
    ITEM_NGAYTHULYST        VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_0                 VARCHAR(250);
    ITEM_NGUOI_1                 VARCHAR(250);
    ITEM_NGUOI_2                 VARCHAR(250);
    ITEM_NGUOI_3                 VARCHAR(250);
    ITEM_NGUOI_4                 VARCHAR(250);
    ITEM_NGUOI_5                 VARCHAR(250);

BEGIN
        ITEM_LOAIAN := 'HS';

        BEGIN        
            SELECT TA.TEN, UPPER(TA.TEN) INTO ITEM_TENTOAAN, ITEM_TENTOAANHOA
            FROM DM_TOAAN TA
            WHERE TA.ID = VTOAANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENTOAAN := ''; ITEM_TENTOAANHOA := '';
        END;

        BEGIN
            SELECT SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD), NVL(LYDOKCQH,'') INTO ITEM_SOQD, ITEM_LYDOKCQH
            FROM KHANGCAOQUAHAN_QUYETDINH QD
            WHERE QD.DONID = VDONID AND QD.THULYID = VTHULY_KCQH_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_SOQD := ''; ITEM_LYDOKCQH := 0;
        END;

        BEGIN
            SELECT 'ngày ' || EXTRACT(DAY FROM  KC.NGAYKHANGCAO) || ' tháng ' || EXTRACT(MONTH FROM  KC.NGAYKHANGCAO) || ' năm ' || EXTRACT(YEAR FROM  KC.NGAYKHANGCAO),
                   YC.NOIDUNGKHANGCAO, TL.SOTHULY || '/' || EXTRACT(YEAR FROM  TL.NGAYTHULY) AS SOTHULY, 
                   'ngày ' || EXTRACT(DAY FROM  TL.NGAYTHULY) || ' tháng ' || EXTRACT(MONTH FROM  TL.NGAYTHULY) || ' năm ' || EXTRACT(YEAR FROM  TL.NGAYTHULY) AS NGAYTHULYST,
                   DECODE(BC.HOTENNGUOIKC, NULL, TGTT.TCTTNGUOIKC, BC.TCTTNGUOIKC) AS TCTTNGUOIKC,
                   DECODE(BC.HOTENNGUOIKC, NULL, TGTT.HOTENNGUOIKC, BC.HOTENNGUOIKC) AS HOTENNGUOIKC,
                   DECODE(KC.LOAIKHANGCAO, 0, 'Bản án', 'Quyết định'),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.NGAYBA , QD.NGAYQD),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.SOBANAN , QD.SOQD),
                   TA.TEN, 'Địa chỉ người kc'
                   INTO ITEM_NGAYKC, ITEM_YEUCAUKHANGCAO, ITEM_SOTHULYST, ITEM_NGAYTHULYST , ITEM_TCTTNGUOIKC
                      , ITEM_HOTENNGUOIKC, ITEM_LOAIBAQD, ITEM_NGAYBAQDST, ITEM_SOBAQD, ITEM_TENTOAANST, ITEM_DIACHINGUOIKC
            FROM AHS_SOTHAM_KHANGCAO KC

                LEFT JOIN (SELECT A.ROWNUMBER, A.SOTHULY, A.NGAYTHULY, A.VUANID
                           FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TL.NGAYTHULY ORDER BY TL.NGAYTHULY DESC, TL.ID) ROWNUMBER , TL.SOTHULY, TL.NGAYTHULY, TL.VUANID
                                 FROM AHS_SOTHAM_THULY TL 
                                 WHERE TL.VUANID = VDONID
                                 ) A
                           WHERE A.ROWNUMBER = 1) TL ON TL.VUANID = KC.VUANID

                LEFT JOIN (SELECT LISTAGG(DM.TEN, ', ') WITHIN GROUP (ORDER BY YC.ID) AS NOIDUNGKHANGCAO, YC.KHANGCAOID
                           FROM AHS_SOTHAM_KHANGCAO_YEUCAU YC
                               LEFT JOIN DM_DATAITEM DM ON DM.ID = YC.YEUCAUID
                           GROUP BY YC.KHANGCAOID) YC ON YC.KHANGCAOID = KC.ID

                LEFT JOIN DM_TOAAN TA ON TA.ID = KC.TOAANRAQDID

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYBANAN) || ' tháng ' || EXTRACT(MONTH FROM  NGAYBANAN) || ' năm ' || EXTRACT(YEAR FROM  NGAYBANAN) AS NGAYBA, ID, SOBANAN || '/' || EXTRACT(YEAR FROM NGAYBANAN) AS SOBANAN
                           FROM AHS_SOTHAM_BANAN) BA ON BA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 0

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQUYETDINH || '/' || EXTRACT(YEAR FROM NGAYQD) AS SOQD
                           FROM AHS_SOTHAM_QUYETDINH_VUAN) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO IN (1,2)

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQUYETDINH || '/' || EXTRACT(YEAR FROM NGAYQD) AS SOQD
                           FROM AHS_SOTHAM_QUYETDINH_VUAN) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO IN (3)

                LEFT JOIN (SELECT BC.ID, 'Bị cáo' AS TCTTNGUOIKC, BC.HOTEN AS HOTENNGUOIKC 
                           FROM AHS_BICANBICAO BC) BC ON BC.ID = KC.NGUOIKCID AND KC.NGUOIKCLOAI = 0 -- Bị cáo kháng cáo

                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC,
                                  DECODE(TT.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || TT.HOTEN AS HOTENNGUOIKC,
                                  TT.ID, TT.VUANID
                           FROM AHS_NGUOITHAMGIATOTUNG TT
                               LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = TT.ID
                               LEFT JOIN DM_DATAITEM DM ON DM.ID = TC.TUCACHID) TGTT ON TGTT.ID = KC.NGUOIKCID AND KC.NGUOIKCLOAI = 1 -- Người TGTT kháng cáo

            WHERE KC.ID = VKHANGCAOID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_NGAYKC := ''; ITEM_YEUCAUKHANGCAO := '';
        END;

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN, A.NGUOIKY  INTO CHECKNUMBER, ITEM_HOTENTPCHUTOA, ITEM_NGUOIKY
            FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER ,
                         DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN, CB.HOTEN AS NGUOIKY
                  FROM KHANGCAOQUAHAN_HDXX TP
                      LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                  WHERE TP.THULYID = VTHULY_KCQH_ID AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHAN') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_HOTENTPCHUTOA := ''; ITEM_NGUOIKY := '';
        END;    

        BEGIN 
            SELECT A.ROWNUMBER, A.HOTEN  INTO CHECKNUMBER, ITEM_HOTENTP1
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN--INTO ITEM_HOTENTPCHUTOA
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP1 := '';
        END; 

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN INTO CHECKNUMBER, ITEM_HOTENTP2
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 2; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP2 := '';
        END;

        BEGIN     
            SELECT TEN INTO ITEM_TENVKSND
            FROM DM_VKS 
            WHERE ID = VTOAANID;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENVKSND := '';
        END;         

        BEGIN     
            SELECT A.ROWNUMBER, A.HOTENKSV  INTO CHECKNUMBER, ITEM_HOTENKSV
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.NGAYNHANPHANCONG, TP.ID) ROWNUMBER,
                           DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN  AS HOTENKSV
                    FROM KHANGCAOQUAHAN_HDXX TP
                        LEFT JOIN DM_CANBOVKS CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'KSV') A
            WHERE A.ROWNUMBER = 1;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENKSV := '';
        END; 

        CHECKNUMBER := 0;
        SELECT COUNT('X') INTO CHECKNUMBER FROM KHANGCAOQUAHAN_QUYETDINH WHERE THULYID = VTHULY_KCQH_ID AND KETQUA = 2;
        IF(CHECKNUMBER > 0) THEN


            -- Lấy Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Người được uỷ quyền - TGTTHS_18
            Người đại diện hợp pháp của bị can, bị cáo - TGTTHS_07
            Người đại diện hợp pháp của bị hại - TGTTHS_08
            Người đại diện hợp pháp của người liên quan - TGTTHS_12 - nếu mà người liên quan là người kháng cáo
            Người đại diện của nguyên đơn dân sự - TGTTHS_14
            Người đại diện của bị đơn dân sự - TGTTHS_16
            Người kế thừa quyền và nghĩa vụ tố tụng của NĐ dân sự - TGTTHS_20
            Người kế thừa quyền và nghĩa vụ tố tụng của Người có quyền lợi nghĩa vụ liên quan - TGTTHS_21
            Người kế thừa quyền và nghĩa vụ tố tụng của BĐ dân sự - TGTTHS_19
            */
            BEGIN
                SELECT NGUOI_1.ITEM_NGUOI_1 INTO ITEM_NGUOI_1
                FROM (
                        SELECT DD.BICAO_ID
                             , LISTAGG(DD.HOTEN_TGTT, ', ') WITHIN GROUP (ORDER BY DD.TGTT_ID) AS ITEM_NGUOI_1
                        FROM AHS_SOTHAM_KHANGCAO KC

                            INNER JOIN (SELECT TGTT.ID AS TGTT_ID, DD.BICAO_ID, DD.ID_EXT, TGTT.HOTEN AS HOTEN_TGTT, TGTT.DIACHI DIACHI_TGTT
                                        FROM AHS_NGUOI_DAIDIEN DD

                                            INNER JOIN (SELECT TGTT.ID, TGTT.HOTEN, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.DIACHICHITIET || ' ' ||DMHC.MA_TEN) AS DIACHI
                                                       FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                                           LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.DIACHIID
                                                       ) TGTT ON TGTT.ID = DD.NGUOI_TGTT_ID
                                            INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT ON TCTGTT.NGUOIID = TGTT.ID AND TCTGTT.TUCACHID IN (1160, 128, 129, 133, 135, 137, 1622, 1623, 1621)

                                        ) DD ON DD.BICAO_ID = KC.NGUOIKCID AND ((KC.NGUOIKCLOAI = 0 AND DD.ID_EXT LIKE 'BC-') OR (KC.NGUOIKCLOAI = 1 AND DD.ID_EXT NOT LIKE 'BH-'))

                        WHERE KC.ID = VKHANGCAOID
                        GROUP BY DD.BICAO_ID
                ) NGUOI_1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_1 := '';
            END;


            -- Lấy Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Luật sư - TGTTHS_06
            Bào chữa viên nhân dân - TGTTHS_09
            Người bào chữa là trợ giúp viên pháp lý nhà nước - TGTTHS_02
            Người bào chữa khác - TGTTHS_17
            Người bảo vệ quyền lợi của đương sự -- nếu bảo vệ cho ng kháng cáo - TGTTHS_10
            */ 
            BEGIN  
                SELECT NGUOI_2.ITEM_NGUOI_2 INTO ITEM_NGUOI_2
                FROM (
                        SELECT DD.BICAO_ID
                             , LISTAGG(DD.HOTEN_TGTT, ', ') WITHIN GROUP (ORDER BY DD.TGTT_ID) AS ITEM_NGUOI_2
                        FROM AHS_SOTHAM_KHANGCAO KC

                            INNER JOIN (SELECT TGTT.ID AS TGTT_ID, DD.BICAO_ID, DD.ID_EXT, TGTT.HOTEN AS HOTEN_TGTT, TGTT.DIACHI DIACHI_TGTT
                                        FROM AHS_NGUOI_DAIDIEN DD

                                            INNER JOIN (SELECT TGTT.ID, TGTT.HOTEN, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.DIACHICHITIET || ' ' ||DMHC.MA_TEN) AS DIACHI
                                                       FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                                           LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.DIACHIID
                                                       ) TGTT ON TGTT.ID = DD.NGUOI_TGTT_ID
                                            INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT ON TCTGTT.NGUOIID = TGTT.ID AND TCTGTT.TUCACHID IN (127, 130, 123, 549, 131)

                                        ) DD ON DD.BICAO_ID = KC.NGUOIKCID AND ((KC.NGUOIKCLOAI = 0 AND DD.ID_EXT LIKE 'BC-') OR (KC.NGUOIKCLOAI = 1 AND DD.ID_EXT NOT LIKE 'BH-'))

                        WHERE KC.ID = VKHANGCAOID
                        GROUP BY DD.BICAO_ID
                ) NGUOI_2;    
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_2 := '';
            END;

            -- Lấy Người có quyền lợi, nghĩa vụ liên quan 
            /*Người có quyền lợi nghĩa vụ liên quan - TGTTHS_05 = 126
            */
            BEGIN

                SELECT NGUOI_3.ITEM_NGUOI_3 INTO ITEM_NGUOI_3
                FROM AHS_SOTHAM_KHANGCAO KC     
                    INNER JOIN (SELECT TGTT.VUANID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN))*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_3
                                FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                    INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT ON TCTGTT.NGUOIID = TGTT.ID AND TCTGTT.TUCACHID = 126
                                    --LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.HKTT
                                GROUP BY TGTT.VUANID
                                ) NGUOI_3 ON NGUOI_3.VUANID = KC.VUANID
                WHERE KC.ID = VKHANGCAOID; 

            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_3 := '';
            END;

            --Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Người đại diện hợp pháp của người liên quan - TGTTHS_12 - 133
            */
            BEGIN
                SELECT NGUOI_4.ITEM_NGUOI_4 INTO ITEM_NGUOI_4
                FROM (
                        SELECT DD.VUANID
                             , LISTAGG(DD.HOTEN_TGTT, ', ') WITHIN GROUP (ORDER BY DD.TGTT_ID) AS ITEM_NGUOI_4
                        FROM AHS_SOTHAM_KHANGCAO KC

                            INNER JOIN (SELECT TGTT.VUANID, 
                                               TGTT.ID AS TGTT_ID, 
                                               TGTT.HOTEN AS HOTEN_TGTT, 
                                               DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.DIACHICHITIET || ' ' ||DMHC.MA_TEN) AS DIACHI_TGTT

                                        FROM AHS_NGUOITHAMGIATOTUNG TGTT 

                                            LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.DIACHIID
                                            INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT ON TCTGTT.NGUOIID = TGTT.ID AND TCTGTT.TUCACHID IN (133)

                                        ) DD ON DD.VUANID = KC.VUANID
                        WHERE KC.ID = VKHANGCAOID
                        GROUP BY DD.VUANID
                ) NGUOI_4; 

            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_4 := '';
            END;

            --Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Luật sư - TGTTHS_06
            Bào chữa viên nhân dân - TGTTHS_09
            Người bào chữa là trợ giúp viên pháp lý nhà nước - TGTTHS_02
            Người bào chữa khác - TGTTHS_17
            Người bảo vệ quyền lợi của đương sự -- nếu bảo vệ cho ng kháng cáo - TGTTHS_10
            */ 
            BEGIN
                SELECT LISTAGG(DD.HOTEN_TGTT, ', ') WITHIN GROUP (ORDER BY DD.TGTT_ID) AS ITEM_NGUOI_5 INTO ITEM_NGUOI_5
                FROM AHS_SOTHAM_KHANGCAO KC

                    INNER JOIN (SELECT TGTT.VUANID, TGTT.ID
                                FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                    INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT ON TCTGTT.NGUOIID = TGTT.ID AND TCTGTT.TUCACHID = 126
                                ) NGUOI_3 ON NGUOI_3.VUANID = KC.VUANID

                    INNER JOIN (SELECT TGTT.ID AS TGTT_ID, DD.BICAO_ID, DD.ID_EXT, TGTT.HOTEN AS HOTEN_TGTT, TGTT.DIACHI DIACHI_TGTT
                                FROM AHS_NGUOI_DAIDIEN DD

                                    INNER JOIN (SELECT TGTT.ID, TGTT.HOTEN, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.DIACHICHITIET || ' ' ||DMHC.MA_TEN) AS DIACHI
                                               FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                                   LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.DIACHIID
                                               ) TGTT ON TGTT.ID = DD.NGUOI_TGTT_ID

                                    INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT ON TCTGTT.NGUOIID = TGTT.ID AND TCTGTT.TUCACHID IN (127, 130, 123, 549, 131)

                                ) DD ON DD.BICAO_ID = NGUOI_3.ID

                WHERE KC.ID = VKHANGCAOID
                GROUP BY DD.BICAO_ID;

            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_5 := '';
            END;            

        END IF;

        OPEN CURRETURN FOR      
        SELECT ITEM_TENTOAAN AS ITEM_TENTOAAN, ITEM_TENTOAANHOA AS ITEM_TENTOAANHOA, 'HS' AS ITEM_LOAIAN,

                ITEM_SOQD AS ITEM_SOQD, ITEM_NGAYKC AS ITEM_NGAYKC, ITEM_LYDOKCQH AS ITEM_LYDOKCQH,

                ITEM_NGUOIKY AS ITEM_NGUOIKY, ITEM_HOTENTPCHUTOA AS ITEM_HOTENTPCHUTOA, ITEM_HOTENTP1 AS ITEM_HOTENTP1, ITEM_HOTENTP2 AS ITEM_HOTENTP2,

                ITEM_TENVKSND AS ITEM_TENVKSND, ITEM_HOTENKSV AS ITEM_HOTENKSV,

                ITEM_TCTTNGUOIKC AS ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC AS ITEM_HOTENNGUOIKC, ITEM_YEUCAUKHANGCAO AS ITEM_YEUCAUKHANGCAO, ITEM_DIACHINGUOIKC AS ITEM_DIACHINGUOIKC,
                ITEM_TCTTNGUOIBK AS ITEM_TCTTNGUOIBK, ITEM_HOTENNGUOIBK AS ITEM_HOTENNGUOIBK,

                ITEM_LOAIBAQD AS ITEM_LOAIBAQD, ITEM_NGAYBAQDST AS ITEM_NGAYBAQDST, ITEM_SOBAQD AS ITEM_SOBAQD, ITEM_TENTOAANST AS ITEM_TENTOAANST,
                ITEM_QHPLTEXT AS ITEM_QHPLTEXT,

                ITEM_NGUOI_1 AS ITEM_NGUOI_1, ITEM_NGUOI_2 AS ITEM_NGUOI_2, ITEM_NGUOI_3 AS ITEM_NGUOI_3, ITEM_NGUOI_4 AS ITEM_NGUOI_4, ITEM_NGUOI_5 AS ITEM_NGUOI_5
        FROM DUAL;        
END AHS_PT_KCQUAHAN_PRINT;

PROCEDURE        AKT_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--
    ITEM_THONGTINVUVIEC     VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_1                 VARCHAR(2000);
    ITEM_NGUOI_2                 VARCHAR(2000);
    ITEM_NGUOI_3                 VARCHAR(2000);
    ITEM_NGUOI_4                 VARCHAR(2000);
    ITEM_NGUOI_5                 VARCHAR(2000);

BEGIN
        ITEM_LOAIAN := 'KT';

        BEGIN        
            SELECT TA.TEN, UPPER(TA.TEN) INTO ITEM_TENTOAAN, ITEM_TENTOAANHOA
            FROM DM_TOAAN TA
            WHERE TA.ID = VTOAANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENTOAAN := ''; ITEM_TENTOAANHOA := '';
        END;

        BEGIN
            SELECT SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD), NVL(LYDOKCQH,'') INTO ITEM_SOQD, ITEM_LYDOKCQH
            FROM KHANGCAOQUAHAN_QUYETDINH QD
            WHERE QD.DONID = VDONID AND QD.THULYID = VTHULY_KCQH_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_SOQD := ''; ITEM_LYDOKCQH := 0;
        END;

        BEGIN
            SELECT 'ngày ' || EXTRACT(DAY FROM  KC.NGAYKHANGCAO) || ' tháng ' || EXTRACT(MONTH FROM  KC.NGAYKHANGCAO) || ' năm ' || EXTRACT(YEAR FROM  KC.NGAYKHANGCAO),
                   KC.NOIDUNGKHANGCAO,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.TCTTNGUOIKC, DS1.TCTTNGUOIKC) AS TCTTNGUOIKC,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.HOTENNGUOIKC, DS1.HOTENNGUOIKC) AS HOTENNGUOIKC,
                   DECODE(DS1.DIACHI, NULL, DS2.DIACHI, DS1.DIACHI) AS DIACHINGUOIKC,
                   DECODE(KC.LOAIKHANGCAO, 0, 'Bản án', 'Quyết định'),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.NGAYBA , QD.NGAYQD),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.SOBANAN, QD.SOQD),
                   TA.TEN,
                   '"' || DON.QUANHEPHAPLUAT_NAME || '"',
                   'giữa Nguyên đơn là ' || NGUYENDON.HOTEN ||  ' và Bị đơn là ' || BIDON.HOTEN

                   INTO ITEM_NGAYKC, ITEM_YEUCAUKHANGCAO, ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC, ITEM_DIACHINGUOIKC,
                        ITEM_LOAIBAQD, ITEM_NGAYBAQDST, ITEM_SOBAQD, 
                        ITEM_TENTOAANST, ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC

            FROM AKT_SOTHAM_KHANGCAO KC

                LEFT JOIN AKT_DON DON ON DON.ID = KC.DONID

                LEFT JOIN DM_TOAAN TA ON TA.ID = KC.TOAANRAQDID

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYTUYENAN) || ' tháng ' || EXTRACT(MONTH FROM  NGAYTUYENAN) || ' năm ' || EXTRACT(YEAR FROM  NGAYTUYENAN) AS NGAYBA, ID, SOBANAN || '/' || EXTRACT(YEAR FROM NGAYTUYENAN) AS SOBANAN
                           FROM AKT_SOTHAM_BANAN BA) BA ON BA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 0

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD) AS SOQD
                           FROM AKT_SOTHAM_QUYETDINH) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO > 0

                --Lấy tên nguyên đơn
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM AKT_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'NGUYENDON' AND DUONGSU.ISDAIDIEN = 1) NGUYENDON ON NGUYENDON.DONID = KC.DONID
                --Lấy tên bị đơn           
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM AKT_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'BIDON' AND DUONGSU.ISDAIDIEN = 1) BIDON ON BIDON.DONID = KC.DONID

                -- Lấy thông tin người kháng cáo        
                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.TENDUONGSU AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM AKT_DON_DUONGSU DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTOTUNG_MA
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS1 ON DS1.ID = KC.DUONGSUID AND DS1.DONID = KC.DONID

                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.HOTEN AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM AKT_DON_THAMGIATOTUNG DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS2 ON DS2.ID = KC.DUONGSUID AND DS2.DONID = KC.DONID

            WHERE KC.ID = VKHANGCAOID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_NGAYKC := ''; ITEM_YEUCAUKHANGCAO := '';
        END;

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN, A.NGUOIKY  INTO CHECKNUMBER, ITEM_HOTENTPCHUTOA, ITEM_NGUOIKY
            FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER ,
                         DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN, CB.HOTEN AS NGUOIKY
                  FROM KHANGCAOQUAHAN_HDXX TP
                      LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                  WHERE TP.THULYID = VTHULY_KCQH_ID AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHAN') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_HOTENTPCHUTOA := ''; ITEM_NGUOIKY := '';
        END;  

        BEGIN 
            SELECT A.ROWNUMBER, A.HOTEN  INTO CHECKNUMBER, ITEM_HOTENTP1
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN--INTO ITEM_HOTENTPCHUTOA
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP1 := '';
        END; 

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN INTO CHECKNUMBER, ITEM_HOTENTP2
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 2; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP2 := '';
        END;

        BEGIN     
            SELECT TEN INTO ITEM_TENVKSND
            FROM DM_VKS 
            WHERE ID = VTOAANID;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENVKSND := '';
        END;         

        BEGIN     
            SELECT A.ROWNUMBER, A.HOTENKSV  INTO CHECKNUMBER, ITEM_HOTENKSV
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.NGAYNHANPHANCONG, TP.ID) ROWNUMBER,
                           DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN  AS HOTENKSV
                    FROM KHANGCAOQUAHAN_HDXX TP
                        LEFT JOIN DM_CANBOVKS CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'KSV') A
            WHERE A.ROWNUMBER = 1;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENKSV := '';
        END; 

        CHECKNUMBER := 0;
        SELECT COUNT('X') INTO CHECKNUMBER FROM KHANGCAOQUAHAN_QUYETDINH WHERE THULYID = VTHULY_KCQH_ID AND KETQUA = 2;
        IF(CHECKNUMBER > 0) THEN

            BEGIN
            -- Lấy Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_1.ITEM_NGUOI_1 INTO ITEM_NGUOI_1
                FROM AKT_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_1
                               FROM AKT_DON_THAMGIATOTUNG TGTT
                                   LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                               WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                               GROUP BY TGTT.DONID, TGTT.DUONGSUID
                               ) NGUOI_1 ON NGUOI_1.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_1.DONID
                WHERE KC.ID = VKHANGCAOID;
                ITEM_NGUOI_1 := 'a';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_1 := 'a';
            END;

            BEGIN
            -- Lấy Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            */   
                SELECT NGUOI_2.ITEM_NGUOI_2 INTO ITEM_NGUOI_2
                FROM AKT_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_2
                                FROM AKT_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_2 ON NGUOI_2.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_2.DONID
                WHERE KC.ID = VKHANGCAOID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_2 := '';
            END;

            BEGIN
            -- Lấy Người có quyền lợi, nghĩa vụ liên quan  
                SELECT NGUOI_3.ITEM_NGUOI_3 INTO ITEM_NGUOI_3
                FROM AKT_SOTHAM_KHANGCAO KC     
                    LEFT JOIN (SELECT DS.DONID, LISTAGG(DS.TENDUONGSU /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN))*/, ', ') WITHIN GROUP (ORDER BY DS.ID) AS ITEM_NGUOI_3
                                FROM AKT_DON_DUONGSU DS
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.HKTTID
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID
                                ) NGUOI_3 ON NGUOI_3.DONID = KC.DONID
                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_3 := '';
            END;

            BEGIN
            --Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_4.ITEM_NGUOI_4 INTO ITEM_NGUOI_4
                FROM AKT_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM AKT_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_4
                                FROM AKT_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_4 ON NGUOI_4.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%' AND KC.DONID = NGUOI_4.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_4 := '';
            END;

            BEGIN
            --Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            ĐƯỢC GÁN VỚI DUONGSUID CỦA NGƯỜI CÓ QLNVLQ
            */
                SELECT NGUOI_5.ITEM_NGUOI_5 INTO ITEM_NGUOI_5
                FROM AKT_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM AKT_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_5
                                FROM AKT_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_5 ON NGUOI_5.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%'   AND KC.DONID = NGUOI_5.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_5 := '';
            END;            

        END IF;

    OPEN CURRETURN FOR      
        SELECT ITEM_TENTOAAN AS ITEM_TENTOAAN, ITEM_TENTOAANHOA AS ITEM_TENTOAANHOA, ITEM_LOAIAN AS ITEM_LOAIAN,

                ITEM_SOQD AS ITEM_SOQD, ITEM_NGAYKC AS ITEM_NGAYKC, ITEM_LYDOKCQH AS ITEM_LYDOKCQH,

                ITEM_NGUOIKY AS ITEM_NGUOIKY, ITEM_HOTENTPCHUTOA AS ITEM_HOTENTPCHUTOA, ITEM_HOTENTP1 AS ITEM_HOTENTP1, ITEM_HOTENTP2 AS ITEM_HOTENTP2,

                ITEM_TENVKSND AS ITEM_TENVKSND, ITEM_HOTENKSV AS ITEM_HOTENKSV,

                ITEM_TCTTNGUOIKC AS ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC AS ITEM_HOTENNGUOIKC, ITEM_YEUCAUKHANGCAO AS ITEM_YEUCAUKHANGCAO, ITEM_DIACHINGUOIKC AS ITEM_DIACHINGUOIKC,
                ITEM_TCTTNGUOIBK AS ITEM_TCTTNGUOIBK, ITEM_HOTENNGUOIBK AS ITEM_HOTENNGUOIBK,

                ITEM_LOAIBAQD AS ITEM_LOAIBAQD, ITEM_NGAYBAQDST AS ITEM_NGAYBAQDST, ITEM_SOBAQD AS ITEM_SOBAQD, ITEM_TENTOAANST AS ITEM_TENTOAANST,
                ITEM_QHPLTEXT AS ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC AS ITEM_THONGTINVUVIEC,

                ITEM_NGUOI_1 AS ITEM_NGUOI_1, ITEM_NGUOI_2 AS ITEM_NGUOI_2, ITEM_NGUOI_3 AS ITEM_NGUOI_3, ITEM_NGUOI_4 AS ITEM_NGUOI_4, ITEM_NGUOI_5 AS ITEM_NGUOI_5
        FROM DUAL;

END AKT_PT_KCQUAHAN_PRINT;

PROCEDURE        ALD_PT_KCQUAHAN_PRINT
(
    VTHULY_KCQH_ID          IN NUMBER,
    VLOAIAN                 IN NUMBER,
    VDONID                  IN NUMBER,
    VTOAANID                IN NUMBER,
    VKHANGCAOID             IN NUMBER,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    CHECKNUMBER             NUMBER;
    ITEM_TENTOAAN           VARCHAR(250);--
    ITEM_TENTOAANHOA        VARCHAR(250);--

    ITEM_SOQD               VARCHAR(250);--

    ITEM_NGAYKC             VARCHAR(250);--

    ITEM_NGUOIKY            VARCHAR(250);--
    ITEM_HOTENTPCHUTOA      VARCHAR(250);--
    ITEM_HOTENTP1           VARCHAR(250);--
    ITEM_HOTENTP2           VARCHAR(250);--

    ITEM_TENVKSND           VARCHAR(250);
    ITEM_HOTENKSV           VARCHAR(250);

    ITEM_TCTTNGUOIKC        VARCHAR(250);--
    ITEM_HOTENNGUOIKC       VARCHAR(250);--
    ITEM_YEUCAUKHANGCAO     VARCHAR(250);--
    ITEM_TCTTNGUOIBK        VARCHAR(250);
    ITEM_HOTENNGUOIBK       VARCHAR(250);

    ITEM_LOAIAN             VARCHAR(250);--
    ITEM_LOAIBAQD           VARCHAR(250);--
    ITEM_NGAYBAQDST         VARCHAR(250);--
    ITEM_SOBAQD             VARCHAR(250);--
    ITEM_LYDOKCQH           VARCHAR(2000);--
    ITEM_TENTOAANST         VARCHAR(250);--
    ITEM_QHPLTEXT           VARCHAR(250);--
    ITEM_THONGTINVUVIEC     VARCHAR(250);--

    ITEM_DIACHINGUOIKC           VARCHAR(2000);
    ITEM_NGUOI_1                 VARCHAR(2000);
    ITEM_NGUOI_2                 VARCHAR(2000);
    ITEM_NGUOI_3                 VARCHAR(2000);
    ITEM_NGUOI_4                 VARCHAR(2000);
    ITEM_NGUOI_5                 VARCHAR(2000);

BEGIN
        ITEM_LOAIAN := 'LD';

        BEGIN        
            SELECT TA.TEN, UPPER(TA.TEN) INTO ITEM_TENTOAAN, ITEM_TENTOAANHOA
            FROM DM_TOAAN TA
            WHERE TA.ID = VTOAANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENTOAAN := ''; ITEM_TENTOAANHOA := '';
        END;

        BEGIN
            SELECT SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD), NVL(LYDOKCQH,'') INTO ITEM_SOQD, ITEM_LYDOKCQH
            FROM KHANGCAOQUAHAN_QUYETDINH QD
            WHERE QD.DONID = VDONID AND QD.THULYID = VTHULY_KCQH_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_SOQD := ''; ITEM_LYDOKCQH := 0;
        END;

        BEGIN
            SELECT 'ngày ' || EXTRACT(DAY FROM  KC.NGAYKHANGCAO) || ' tháng ' || EXTRACT(MONTH FROM  KC.NGAYKHANGCAO) || ' năm ' || EXTRACT(YEAR FROM  KC.NGAYKHANGCAO),
                   KC.NOIDUNGKHANGCAO,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.TCTTNGUOIKC, DS1.TCTTNGUOIKC) AS TCTTNGUOIKC,
                   DECODE(DS1.HOTENNGUOIKC, NULL, DS2.HOTENNGUOIKC, DS1.HOTENNGUOIKC) AS HOTENNGUOIKC,
                   DECODE(DS1.DIACHI, NULL, DS2.DIACHI, DS1.DIACHI) AS DIACHINGUOIKC,
                   DECODE(KC.LOAIKHANGCAO, 0, 'Bản án', 'Quyết định'),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.NGAYBA , QD.NGAYQD),
                   DECODE(KC.LOAIKHANGCAO, 0, BA.SOBANAN, QD.SOQD),
                   TA.TEN,
                   '"' || DON.QUANHEPHAPLUAT_NAME || '"',
                   'giữa Nguyên đơn là ' || NGUYENDON.HOTEN ||  ' và Bị đơn là ' || BIDON.HOTEN

                   INTO ITEM_NGAYKC, ITEM_YEUCAUKHANGCAO, ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC, ITEM_DIACHINGUOIKC,
                        ITEM_LOAIBAQD, ITEM_NGAYBAQDST, ITEM_SOBAQD, 
                        ITEM_TENTOAANST, ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC

            FROM ALD_SOTHAM_KHANGCAO KC

                LEFT JOIN ALD_DON DON ON DON.ID = KC.DONID

                LEFT JOIN DM_TOAAN TA ON TA.ID = KC.TOAANRAQDID

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYTUYENAN) || ' tháng ' || EXTRACT(MONTH FROM  NGAYTUYENAN) || ' năm ' || EXTRACT(YEAR FROM  NGAYTUYENAN) AS NGAYBA, ID, SOBANAN || '/' || EXTRACT(YEAR FROM NGAYTUYENAN) AS SOBANAN
                           FROM ALD_SOTHAM_BANAN BA) BA ON BA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 0

                LEFT JOIN (SELECT 'ngày ' || EXTRACT(DAY FROM  NGAYQD) || ' tháng ' || EXTRACT(MONTH FROM  NGAYQD) || ' năm ' || EXTRACT(YEAR FROM  NGAYQD) AS NGAYQD, ID, SOQD || '/' || EXTRACT(YEAR FROM  NGAYQD) AS SOQD
                           FROM ALD_SOTHAM_QUYETDINH) QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO > 0

                --Lấy tên nguyên đơn
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM ALD_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'NGUYENDON' AND DUONGSU.ISDAIDIEN = 1) NGUYENDON ON NGUYENDON.DONID = KC.DONID
                --Lấy tên bị đơn           
                LEFT JOIN (SELECT DECODE(DUONGSU.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DUONGSU.TENDUONGSU AS HOTEN,
                                  DUONGSU.ID, DUONGSU.DONID
                           FROM ALD_DON_DUONGSU DUONGSU
                           WHERE DUONGSU.TUCACHTOTUNG_MA LIKE 'BIDON' AND DUONGSU.ISDAIDIEN = 1) BIDON ON BIDON.DONID = KC.DONID

                -- Lấy thông tin người kháng cáo        
                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.TENDUONGSU AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM ALD_DON_DUONGSU DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTOTUNG_MA
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS1 ON DS1.ID = KC.DUONGSUID AND DS1.DONID = KC.DONID

                LEFT JOIN (SELECT DM.TEN AS TCTTNGUOIKC, DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || DS.TAMTRUCHITIET || DMHC.MA_TEN) AS DIACHI,
                                  DECODE(DS.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || DS.HOTEN AS HOTENNGUOIKC,
                                  DS.ID, DS.DONID
                           FROM ALD_DON_THAMGIATOTUNG DS
                               LEFT JOIN DM_DATAITEM DM ON DM.MA LIKE DS.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.TAMTRUID) DS2 ON DS2.ID = KC.DUONGSUID AND DS2.DONID = KC.DONID

            WHERE KC.ID = VKHANGCAOID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_NGAYKC := ''; ITEM_YEUCAUKHANGCAO := '';
        END;

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN, A.NGUOIKY  INTO CHECKNUMBER, ITEM_HOTENTPCHUTOA, ITEM_NGUOIKY
            FROM (SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER ,
                         DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN, CB.HOTEN AS NGUOIKY
                  FROM KHANGCAOQUAHAN_HDXX TP
                      LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                  WHERE TP.THULYID = VTHULY_KCQH_ID AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHAN') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_HOTENTPCHUTOA := ''; ITEM_NGUOIKY := '';
        END; 

        BEGIN 
            SELECT A.ROWNUMBER, A.HOTEN  INTO CHECKNUMBER, ITEM_HOTENTP1
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN--INTO ITEM_HOTENTPCHUTOA
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP1 := '';
        END; 

        BEGIN
            SELECT A.ROWNUMBER, A.HOTEN INTO CHECKNUMBER, ITEM_HOTENTP2
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.ID) ROWNUMBER , DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN AS HOTEN
                    FROM KHANGCAOQUAHAN_HDXX TP
                        INNER JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'THAMPHANHDXX') A
            WHERE A.ROWNUMBER = 2; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENTP2 := '';
        END;

        BEGIN     
            SELECT TEN INTO ITEM_TENVKSND
            FROM DM_VKS 
            WHERE ID = VTOAANID;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN ITEM_TENVKSND := '';
        END;         

        BEGIN     
            SELECT A.ROWNUMBER, A.HOTENKSV  INTO CHECKNUMBER, ITEM_HOTENKSV
            FROM (
                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.HIEULUC ORDER BY TP.HIEULUC DESC, TP.NGAYNHANPHANCONG, TP.ID) ROWNUMBER,
                           DECODE(CB.GIOITINH, 0, 'Bà ', 1, 'Ông ', '') || CB.HOTEN  AS HOTENKSV
                    FROM KHANGCAOQUAHAN_HDXX TP
                        LEFT JOIN DM_CANBOVKS CB ON CB.ID = TP.CANBOID
                    WHERE TP.THULYID = VTHULY_KCQH_ID 
                          AND TP.HIEULUC = 1 AND TP.MAVAITRO LIKE 'KSV') A
            WHERE A.ROWNUMBER = 1;  
        EXCEPTION
            WHEN NO_DATA_FOUND THEN CHECKNUMBER := 0; ITEM_HOTENKSV := '';
        END; 

        CHECKNUMBER := 0;
        SELECT COUNT('X') INTO CHECKNUMBER FROM KHANGCAOQUAHAN_QUYETDINH WHERE THULYID = VTHULY_KCQH_ID AND KETQUA = 2;
        IF(CHECKNUMBER > 0) THEN

            BEGIN
            -- Lấy Người đại diện hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_1.ITEM_NGUOI_1 INTO ITEM_NGUOI_1
                FROM ALD_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_1
                               FROM ALD_DON_THAMGIATOTUNG TGTT
                                   LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                               WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                               GROUP BY TGTT.DONID, TGTT.DUONGSUID
                               ) NGUOI_1 ON NGUOI_1.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_1.DONID
                WHERE KC.ID = VKHANGCAOID;
                ITEM_NGUOI_1 := 'a';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_1 := 'a';
            END;

            BEGIN
            -- Lấy Người bảo vệ quyền và lợi ích hợp pháp của người yêu cầu giải quyết việc dân sự
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            */   
                SELECT NGUOI_2.ITEM_NGUOI_2 INTO ITEM_NGUOI_2
                FROM ALD_SOTHAM_KHANGCAO KC
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_2
                                FROM ALD_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_2 ON NGUOI_2.DUONGSUID LIKE '%' || KC.DUONGSUID || '%' AND KC.DONID = NGUOI_2.DONID
                WHERE KC.ID = VKHANGCAOID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_2 := '';
            END;

            BEGIN
            -- Lấy Người có quyền lợi, nghĩa vụ liên quan  
                SELECT NGUOI_3.ITEM_NGUOI_3 INTO ITEM_NGUOI_3
                FROM ALD_SOTHAM_KHANGCAO KC     
                    LEFT JOIN (SELECT DS.DONID, LISTAGG(DS.TENDUONGSU /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN))*/, ', ') WITHIN GROUP (ORDER BY DS.ID) AS ITEM_NGUOI_3
                                FROM ALD_DON_DUONGSU DS
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = DS.HKTTID
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID
                                ) NGUOI_3 ON NGUOI_3.DONID = KC.DONID
                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_3 := '';
            END;

            BEGIN
            --Người đại diện hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Người được uỷ quyền
            Người đại diện hợp pháp của nguyên đơn
            Người đại diện hợp pháp của bị đơn
            Người đại diện hợp pháp của người có quyền lợi và nghĩa vụ liên quan
            Người đại diện theo pháp luật
            Người đại diện theo ủy quyền
            */
                SELECT NGUOI_4.ITEM_NGUOI_4 INTO ITEM_NGUOI_4
                FROM ALD_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM ALD_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_4
                                FROM ALD_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_01', 'TGTTDS_03', 'TGTTDS_04', 'TGTTDS_05', 'TGTTDS_11', 'TGTTDS_12')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_4 ON NGUOI_4.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%' AND KC.DONID = NGUOI_4.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_4 := '';
            END;

            BEGIN
            --Người bảo vệ quyền và lợi ích hợp pháp của người có quyền lợi, nghĩa vụ liên quan
            /*Luật sư
            Người bảo vệ quyền và lợi ích hợp pháp của đương sự
            Trợ giúp viên pháp lý nhà nước
            ĐƯỢC GÁN VỚI DUONGSUID CỦA NGƯỜI CÓ QLNVLQ
            */
                SELECT NGUOI_5.ITEM_NGUOI_5 INTO ITEM_NGUOI_5
                FROM ALD_SOTHAM_KHANGCAO KC
                    INNER JOIN (SELECT DS.DONID, LISTAGG(DS.ID, ', ') WITHIN GROUP (ORDER BY DS.ID) AS QUYENNVLQ
                                FROM ALD_DON_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG_MA IN ('QUYENNVLQ')
                                GROUP BY DS.DONID) QUYENNVLQ ON QUYENNVLQ.DONID = KC.DONID
                    LEFT JOIN (SELECT TGTT.DONID, TGTT.DUONGSUID, LISTAGG(TGTT.HOTEN /*|| DECODE(DMHC.MA_TEN, NULL, '', '', '', ', địa chỉ ' || TGTT.HKTTCHITIET || ' ' ||DMHC.MA_TEN)*/, ', ') WITHIN GROUP (ORDER BY TGTT.ID) AS ITEM_NGUOI_5
                                FROM ALD_DON_THAMGIATOTUNG TGTT
                                    LEFT JOIN DM_HANHCHINH DMHC ON DMHC.ID = TGTT.HKTTID
                                WHERE TGTT.TUCACHTGTTID IN ('TGTTDS_02', 'TGTTDS_07', 'TGTTDS_18')
                                GROUP BY TGTT.DONID, TGTT.DUONGSUID
                                ) NGUOI_5 ON NGUOI_5.DUONGSUID LIKE '%' || QUYENNVLQ.QUYENNVLQ || '%'   AND KC.DONID = NGUOI_5.DONID

                WHERE KC.ID = VKHANGCAOID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN ITEM_NGUOI_5 := '';
            END;            

        END IF;

    OPEN CURRETURN FOR      
        SELECT ITEM_TENTOAAN AS ITEM_TENTOAAN, ITEM_TENTOAANHOA AS ITEM_TENTOAANHOA, ITEM_LOAIAN AS ITEM_LOAIAN,

                ITEM_SOQD AS ITEM_SOQD, ITEM_NGAYKC AS ITEM_NGAYKC, ITEM_LYDOKCQH AS ITEM_LYDOKCQH,

                ITEM_NGUOIKY AS ITEM_NGUOIKY, ITEM_HOTENTPCHUTOA AS ITEM_HOTENTPCHUTOA, ITEM_HOTENTP1 AS ITEM_HOTENTP1, ITEM_HOTENTP2 AS ITEM_HOTENTP2,

                ITEM_TENVKSND AS ITEM_TENVKSND, ITEM_HOTENKSV AS ITEM_HOTENKSV,

                ITEM_TCTTNGUOIKC AS ITEM_TCTTNGUOIKC, ITEM_HOTENNGUOIKC AS ITEM_HOTENNGUOIKC, ITEM_YEUCAUKHANGCAO AS ITEM_YEUCAUKHANGCAO, ITEM_DIACHINGUOIKC AS ITEM_DIACHINGUOIKC,
                ITEM_TCTTNGUOIBK AS ITEM_TCTTNGUOIBK, ITEM_HOTENNGUOIBK AS ITEM_HOTENNGUOIBK,

                ITEM_LOAIBAQD AS ITEM_LOAIBAQD, ITEM_NGAYBAQDST AS ITEM_NGAYBAQDST, ITEM_SOBAQD AS ITEM_SOBAQD, ITEM_TENTOAANST AS ITEM_TENTOAANST,
                ITEM_QHPLTEXT AS ITEM_QHPLTEXT, ITEM_THONGTINVUVIEC AS ITEM_THONGTINVUVIEC,

                ITEM_NGUOI_1 AS ITEM_NGUOI_1, ITEM_NGUOI_2 AS ITEM_NGUOI_2, ITEM_NGUOI_3 AS ITEM_NGUOI_3, ITEM_NGUOI_4 AS ITEM_NGUOI_4, ITEM_NGUOI_5 AS ITEM_NGUOI_5
        FROM DUAL;

END ALD_PT_KCQUAHAN_PRINT;



PROCEDURE        ADS_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,
    
    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,
    
    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,
    
    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,
    
    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,
    
    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;
    
    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);
    
    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Dân sự' AS LOAIAN, 
                             
                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,
                             
                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQD,''), 2 , NVL(QD1.SOQD,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(TO_CHAR(BA.NGAYTUYENAN, 'DD/MM/YYYY'),''), 1, NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), 2 , NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), '') AS NGAYBAQD,
                             
                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.TENKC, S.TENDUONGSU) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,
                             
                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA,
                                A.TOA_GIAIQUYET_ID
                            
                      FROM ADS_DON A
                      
                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID
                          
                          INNER JOIN ADS_SOTHAM_KHANGCAO B ON A.ID = B.DONID
                          
                          LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN (SELECT QD.* 
                                     FROM ADS_SOTHAM_QUYETDINH QD
                                     ) QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)
                          
                          LEFT JOIN (SELECT A.ID, A.DONID, A.TENDUONGSU||' - '|| I.TEN AS TENDUONGSU 
                                     FROM ADS_DON_DUONGSU A 
                                        LEFT JOIN DM_DATAITEM I ON I.MA = A.TUCACHTOTUNG_MA) S ON S.ID = B.DUONGSUID AND S.DONID = B.DONID
                                                        
                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM ADS_DON_THAMGIATOTUNG L 
                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = B.DUONGSUID AND LQ.DONID = B.DONID    
                                         
                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                          
                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 
                                     
                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID
                          
                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND
                            
                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND
                            
                            (VNGUOIKC IS NULL OR LOWER(S.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND                       
                            
                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND
                            
                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND
                            
                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
--                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
--                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
--                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
--                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
--                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
--                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND
                            
                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END ADS_PT_KCQUAHAN;


PROCEDURE        AHC_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,

    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,

    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,

    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,

    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,

    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;

    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);

    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 


  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Dân sự' AS LOAIAN, 

                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,

                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQD,''), 2 , NVL(QD1.SOQD,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(TO_CHAR(BA.NGAYTUYENAN, 'DD/MM/YYYY'),''), 1, NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), 2 , NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), '') AS NGAYBAQD,

                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.TENKC, S.TENDUONGSU) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,

                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA

                      FROM AHC_DON A

                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID

                          INNER JOIN AHC_SOTHAM_KHANGCAO B ON A.ID = B.DONID

                          LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN (SELECT QD.* 
                                     FROM AHC_SOTHAM_QUYETDINH QD
                                     ) QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)

                          LEFT JOIN (SELECT A.ID, A.DONID, A.TENDUONGSU||' - '|| I.TEN AS TENDUONGSU 
                                     FROM AHC_DON_DUONGSU A 
                                        LEFT JOIN DM_DATAITEM I ON I.MA = A.TUCACHTOTUNG_MA) S ON S.ID = B.DUONGSUID AND S.DONID = B.DONID

                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM AHC_DON_THAMGIATOTUNG L 
                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = B.DUONGSUID AND LQ.DONID = B.DONID    

                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID

                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND

                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND

                            (VNGUOIKC IS NULL OR LOWER(S.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND                       

                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND

                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND

                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND

                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END AHC_PT_KCQUAHAN;
PROCEDURE        AHN_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,
    
    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,
    
    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,
    
    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,
    
    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,
    
    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;
    
    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);
    
    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Dân sự' AS LOAIAN, 
                             
                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,
                             
                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQD,''), 2 , NVL(QD1.SOQD,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(TO_CHAR(BA.NGAYTUYENAN, 'DD/MM/YYYY'),''), 1, NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), 2 , NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), '') AS NGAYBAQD,
                             
                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.TENKC, S.TENDUONGSU) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,
                             
                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA
                            
                      FROM AHN_DON A
                      
                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID
                          
                          INNER JOIN AHN_SOTHAM_KHANGCAO B ON A.ID = B.DONID
                          
                          LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN (SELECT QD.* 
                                     FROM AHN_SOTHAM_QUYETDINH QD
                                     ) QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)
                          
                          LEFT JOIN (SELECT A.ID, A.DONID, A.TENDUONGSU||' - '|| I.TEN AS TENDUONGSU 
                                     FROM AHN_DON_DUONGSU A 
                                        LEFT JOIN DM_DATAITEM I ON I.MA = A.TUCACHTOTUNG_MA) S ON S.ID = B.DUONGSUID AND S.DONID = B.DONID
                                                        
                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM AHN_DON_THAMGIATOTUNG L 
                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = B.DUONGSUID AND LQ.DONID = B.DONID    
                                         
                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                          
                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 
                                     
                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID
                          
                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND
                            
                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND
                            
                            (VNGUOIKC IS NULL OR LOWER(S.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND                       
                            
                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND
                            
                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND
                            
                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND
                            
                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END AHN_PT_KCQUAHAN;
PROCEDURE        AHS_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,

    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,

    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,

    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,

    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,

    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;

    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);

    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN
  VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
  VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Hình sự' AS LOAIAN,

                             A.MAVUAN AS MAVUVIEC, A.TENVUAN AS TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ án: </b>' || A.MAVUAN || '<br><b>Tên vụ án: </b>' || A.TENVUAN || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,

                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQUYETDINH,''), 2 , NVL(QD1.SOQUYETDINH,''), 3 , NVL(QD2.SOQUYETDINH,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.NGAYBANAN,''), 1, NVL(QD1.NGAYQD,''), 2 , NVL(QD1.NGAYQD,''), 3 , NVL(QD2.NGAYQD,''), '') AS NGAYBAQD,

                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENBICAO,''), '', LQ.TENKC, S.TENBICAO) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,

                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA

                      FROM AHS_VUAN A

                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID

                          INNER JOIN AHS_SOTHAM_KHANGCAO B ON A.ID = B.VUANID

                          LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)
                          LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QD2 ON QD2.ID = B.SOQDBA AND B.LOAIKHANGCAO = 3

                          LEFT JOIN (SELECT A.ID, A.VUANID, A.HOTEN ||' - Bị cáo' AS TENBICAO 
                                     FROM AHS_BICANBICAO A ) S ON S.ID = B.NGUOIKCID AND S.VUANID = B.VUANID

                          LEFT JOIN (SELECT L.ID, L.VUANID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM AHS_NGUOITHAMGIATOTUNG L 
                                        LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = L.ID
                                        LEFT JOIN DM_DATAITEM I ON I.ID = TC.TUCACHID) LQ ON LQ.ID = B.NGUOIKCID AND LQ.VUANID = B.VUANID    

                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID

                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUAN LIKE '%' || VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUAN) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND

                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYBANAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQUYETDINH) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD2.SOQUYETDINH) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD2.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND

                            (VNGUOIKC IS NULL OR LOWER(S.TENBICAO) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND          

                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND                         

                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND

                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND
                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END AHS_PT_KCQUAHAN;

PROCEDURE        AKT_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,

    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,

    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,

    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,

    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,

    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;

    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);

    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Dân sự' AS LOAIAN, 

                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,

                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQD,''), 2 , NVL(QD1.SOQD,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(TO_CHAR(BA.NGAYTUYENAN, 'DD/MM/YYYY'),''), 1, NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), 2 , NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), '') AS NGAYBAQD,

                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.TENKC, S.TENDUONGSU) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,

                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA

                      FROM AKT_DON A

                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID

                          INNER JOIN AKT_SOTHAM_KHANGCAO B ON A.ID = B.DONID

                          LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN (SELECT QD.* 
                                     FROM AKT_SOTHAM_QUYETDINH QD
                                     ) QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)

                          LEFT JOIN (SELECT A.ID, A.DONID, A.TENDUONGSU||' - '|| I.TEN AS TENDUONGSU 
                                     FROM AKT_DON_DUONGSU A 
                                        LEFT JOIN DM_DATAITEM I ON I.MA = A.TUCACHTOTUNG_MA) S ON S.ID = B.DUONGSUID AND S.DONID = B.DONID

                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM AKT_DON_THAMGIATOTUNG L 
                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = B.DUONGSUID AND LQ.DONID = B.DONID    

                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID

                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND

                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND

                            (VNGUOIKC IS NULL OR LOWER(S.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND                       

                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND

                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND

                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND

                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END AKT_PT_KCQUAHAN;

PROCEDURE        ALD_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,

    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,

    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,

    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,

    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,

    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;

    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);

    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Dân sự' AS LOAIAN, 

                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,

                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQD,''), 2 , NVL(QD1.SOQD,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(TO_CHAR(BA.NGAYTUYENAN, 'DD/MM/YYYY'),''), 1, NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), 2 , NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), '') AS NGAYBAQD,

                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.TENKC, S.TENDUONGSU) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,

                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA

                      FROM ALD_DON A

                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID

                          INNER JOIN ALD_SOTHAM_KHANGCAO B ON A.ID = B.DONID

                          LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN (SELECT QD.* 
                                     FROM ALD_SOTHAM_QUYETDINH QD
                                     ) QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)

                          LEFT JOIN (SELECT A.ID, A.DONID, A.TENDUONGSU||' - '|| I.TEN AS TENDUONGSU 
                                     FROM ALD_DON_DUONGSU A 
                                        LEFT JOIN DM_DATAITEM I ON I.MA = A.TUCACHTOTUNG_MA) S ON S.ID = B.DUONGSUID AND S.DONID = B.DONID

                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM ALD_DON_THAMGIATOTUNG L 
                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = B.DUONGSUID AND LQ.DONID = B.DONID    

                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID

                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND

                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND

                            (VNGUOIKC IS NULL OR LOWER(S.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND                       

                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND

                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND

                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND

                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END ALD_PT_KCQUAHAN;

PROCEDURE        APS_PT_KCQUAHAN
(
    VLOAIAN         IN NUMBER,
    VDONVIID        IN NUMBER,
    VMAVUVIEC       IN VARCHAR2, 
    VTENVUVIEC      IN VARCHAR2,
    VSOBAQD         IN VARCHAR2,
    VNGAYBAQD       IN VARCHAR2,

    VNGUOIKC        IN VARCHAR2,
    VKCTUNGAY       IN VARCHAR2,
    VKCDENNGAY      IN VARCHAR2,

    VSOTL           IN VARCHAR2,
    VTLTUNGAY       IN VARCHAR2,
    VTLDENNGAY      IN VARCHAR2,

    VTRANGTHAI      IN NUMBER,
    VTUNGAY         IN VARCHAR2,
    VDENNGAY        IN VARCHAR2,

    VTHAMPHANIDID   IN NUMBER,
    VTHUKYID        IN NUMBER,

    VCHECKEDLIST    IN VARCHAR2,
    VPAGEINDEX      IN INT,
    VPAGESIZE       IN INT,
    CURRETURN       OUT SYS_REFCURSOR
) AS
    VSTT            NUMBER DEFAULT 0;
    VTOTALITEM      NUMBER DEFAULT 0;

    VV_TUNGAY       VARCHAR2(15);
    VV_DENNGAY      VARCHAR2(15);

    VMININDEX	    NUMBER;
    VMAXINDEX	    NUMBER;
BEGIN

    VMININDEX := VPAGESIZE*(VPAGEINDEX - 1) + 1;
    VMAXINDEX := VPAGEINDEX*VPAGESIZE ;

     IF(NVL(LENGTH(VTUNGAY),0) >0) THEN  
            VV_TUNGAY := VTUNGAY;  
          ELSE
             VV_TUNGAY := '01/01/0001';
     END IF;  

     IF(NVL(LENGTH(VDENNGAY),0) >0) THEN  
            VV_DENNGAY := VDENNGAY; 
          ELSE
             VV_DENNGAY := '01/01/9999';
     END IF; 

  OPEN CURRETURN FOR      
                SELECT A.* 
                FROM (SELECT COUNT(*) OVER () as COUNTALL,
                             ROW_NUMBER() OVER (ORDER BY B.NGAYKHANGCAO DESC) AS STT,
                             A.ID, 'Dân sự' AS LOAIAN, 

                             A.MAVUVIEC, A.TENVUVIEC, TA.TEN AS TENTOAAN,
                             '<b>Mã vụ việc: </b>' || A.MAVUVIEC || '<br><b>Tên vụ việc: </b>' || A.TENVUVIEC || '<br><b>Tên tòa án: </b>' ||  TA.TEN AS THONGTINVUVIEC,

                             DECODE(B.LOAIKHANGCAO, 0, NVL(BA.SOBANAN,''), 1, NVL(QD1.SOQD,''), 2 , NVL(QD1.SOQD,''), '') AS SOBAQD,
                             DECODE(B.LOAIKHANGCAO, 0, NVL(TO_CHAR(BA.NGAYTUYENAN, 'DD/MM/YYYY'),''), 1, NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), 2 , NVL(TO_CHAR(QD1.NGAYQD, 'DD/MM/YYYY'),''), '') AS NGAYBAQD,

                             B.ID AS KHANGCAO_SOTHAM_ID,
                             DECODE(NVL(S.TENDUONGSU,''), '', LQ.TENKC, S.TENDUONGSU) AS NGUOIKHANGCAO,
                             TO_CHAR(B.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,

                             DECODE(NVL(THULY.SOTHULY,''), '', '', THULY.SOTHULY) AS SOTHULY,
                             DECODE(NVL(THULY.NGAYTHULY,''), '', '', TO_CHAR(THULY.NGAYTHULY,'DD/MM/YYYY')) AS NGAYTHULY,

                             DECODE(QD.KETQUA, 1, 'Chấp nhận' , 0 , 'Không chấp nhận', 2, 'Đình chỉ' , DECODE(THULY.ID, NULL, 'Chưa giải quyết', 'Đã thụ lý')) AS KETQUA

                      FROM APS_DON A

                          INNER JOIN DM_TOAAN TA ON A.TOAANID=TA.ID

                          INNER JOIN APS_SOTHAM_KHANGCAO B ON A.ID = B.DONID

                          LEFT JOIN APS_SOTHAM_BANAN BA ON BA.ID = B.SOQDBA AND B.LOAIKHANGCAO = 0
                          LEFT JOIN (SELECT QD.* 
                                     FROM APS_SOTHAM_QUYETDINH QD
                                     ) QD1 ON QD1.ID = B.SOQDBA AND B.LOAIKHANGCAO IN (1,2)

                          LEFT JOIN (SELECT A.ID, A.DONID, A.TENDUONGSU||' - '|| I.TEN AS TENDUONGSU 
                                     FROM APS_DON_DUONGSU A 
                                        LEFT JOIN DM_DATAITEM I ON I.MA = A.TUCACHTOTUNG_MA) S ON S.ID = B.DUONGSUID AND S.DONID = B.DONID

                          LEFT JOIN (SELECT L.ID, L.DONID, L.HOTEN||' - '|| I.TEN AS TENKC 
                                     FROM APS_DON_THAMGIATOTUNG L 
                                        LEFT JOIN DM_DATAITEM I ON I.MA=L.TUCACHTGTTID) LQ ON LQ.ID = B.DUONGSUID AND LQ.DONID = B.DONID    

                          LEFT JOIN (SELECT TL.ID, TL.DONID, TL.KHANGCAOID, TL.SOTHULY, TL.NGAYTHULY
                                     FROM KHANGCAOQUAHAN_THULY TL 
                                     WHERE TL.LOAIAN = VLOAIAN) THULY ON THULY.DONID = A.ID AND B.ID = THULY.KHANGCAOID

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THAMPHAN, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THAMPHAN%'
                                     GROUP BY HDXX.THULYID) THAMPHAN ON THAMPHAN.THULYID = THULY.ID 

                          LEFT JOIN (SELECT LISTAGG(';' || HDXX.CANBOID || ';', ', ') WITHIN GROUP (ORDER BY HDXX.ID) AS THUKY, HDXX.THULYID
                                     FROM KHANGCAOQUAHAN_HDXX HDXX
                                     WHERE HDXX.LOAIAN = VLOAIAN AND HDXX.MAVAITRO LIKE 'THUKY%'
                                     GROUP BY HDXX.THULYID) THUKY ON THUKY.THULYID = THULY.ID

                          LEFT JOIN (SELECT QD.*
                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                     WHERE QD.LOAIAN = VLOAIAN) QD ON QD.THULYID = THULY.ID 

                      WHERE B.GQ_TOAANID = VDONVIID AND
                            (VMAVUVIEC IS NULL OR A.MAVUVIEC LIKE VMAVUVIEC || '%') AND
                            (VTENVUVIEC IS NULL OR LOWER(A.TENVUVIEC) LIKE '%' || LOWER(VTENVUVIEC) || '%') AND

                            (   
                                (   (VSOBAQD IS NULL OR LOWER(BA.SOBANAN) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(BA.NGAYTUYENAN, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY')     )    
                                ) 
                                OR
                                (   
                                    (VSOBAQD IS NULL OR LOWER(QD1.SOQD) LIKE LOWER(VSOBAQD) || '%') 
                                    AND (VNGAYBAQD IS NULL OR TO_DATE(QD1.NGAYQD, 'DD/MM/YYYY') LIKE TO_DATE(VNGAYBAQD, 'DD/MM/YYYY'))
                                )
                            ) AND

                            (VNGUOIKC IS NULL OR LOWER(S.TENDUONGSU) LIKE '%' || LOWER(VNGUOIKC) || '%' OR LOWER(LQ.TENKC) LIKE '%' || LOWER(VNGUOIKC) || '%') AND
                            (VKCTUNGAY IS NULL OR B.NGAYKHANGCAO >= TO_DATE(VKCTUNGAY, 'DD/MM/YYYY')  ) AND 
                            (VKCDENNGAY IS NULL OR B.NGAYKHANGCAO <= (TO_DATE(VKCDENNGAY, 'DD/MM/YYYY') +1)) AND                       

                            (VSOTL IS NULL OR LOWER(THULY.SOTHULY) LIKE '%' || LOWER(VSOTL) || '%') AND
                            (VTLTUNGAY IS NULL OR THULY.NGAYTHULY >= TO_DATE(VTLTUNGAY, 'DD/MM/YYYY')) AND 
                            (VTLDENNGAY IS NULL OR THULY.NGAYTHULY <= (TO_DATE(VTLDENNGAY, 'DD/MM/YYYY') + 1)) AND

                            (VTHAMPHANIDID IS NULL OR VTHAMPHANIDID = 0 OR THAMPHAN.THAMPHAN LIKE '%;' || VTHAMPHANIDID || ';%') AND
                            (VTHUKYID IS NULL OR VTHUKYID = 0 OR  THUKY.THUKY LIKE '%;' || VTHUKYID || ';%') AND

                            (VTRANGTHAI IS NULL OR VTRANGTHAI = 2  
                                                   OR (VTRANGTHAI = 0 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                      )
                                                      ) 
                                                   OR (VTRANGTHAI = 3 AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_THULY TL 
                                                                                     WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                           AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      )
                                                   OR (VTRANGTHAI = 4 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_THULY TL 
                                                                                 WHERE TL.DONID = A.ID AND B.ID = THULY.KHANGCAOID
                                                                                       AND (TL.NGAYTHULY >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                       AND (TL.NGAYTHULY <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1) )
                                                                                 )
                                                                      AND NOT EXISTS(SELECT * 
                                                                                     FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                     WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                     )
                                                      ) 
                                                   OR (VTRANGTHAI = 1 AND EXISTS(SELECT * 
                                                                                 FROM KHANGCAOQUAHAN_QUYETDINH QD 
                                                                                 WHERE QD.THULYID = THULY.ID
                                                                                           AND (QD.NGAYGIAIQUYET >= TO_DATE(VV_TUNGAY, 'DD/MM/YYYY'))
                                                                                           AND (QD.NGAYGIAIQUYET <= (TO_DATE(VV_DENNGAY, 'DD/MM/YYYY') +1))
                                                                                )
                                                       )
                            ) AND

                            (VCHECKEDLIST IS NULL OR VCHECKEDLIST LIKE '' OR (TO_CHAR(B.ID) || ';' IN (VCHECKEDLIST)) )
                      ORDER BY B.NGAYKHANGCAO DESC
                    ) A
                    WHERE (A.STT >= VMININDEX AND A.STT <= VMAXINDEX) OR (VPAGEINDEX = 0 AND VPAGESIZE = 0);
END APS_PT_KCQUAHAN;

END PKG_STPT_KHANGCAOQUAHAN_TIMKIEM;

/
