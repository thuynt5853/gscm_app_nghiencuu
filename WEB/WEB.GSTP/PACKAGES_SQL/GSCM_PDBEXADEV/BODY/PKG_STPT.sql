CREATE OR REPLACE PACKAGE BODY GSCM.PKG_STPT
AS
    PROCEDURE GET_TONG_SO_TOI (VBANANID    IN     VARCHAR2,
                               VBICANID    IN     VARCHAR2,
                               CurReturn      OUT SYS_REFCURSOR)
    AS
        KETQUA   VARCHAR2 (100);
    BEGIN
        SELECT COUNT (*)
          INTO KETQUA
          FROM DM_BOLUAT_TOIDANH TD
         WHERE     EXISTS
                       (SELECT 'X'
                          FROM AHS_SOTHAM_BANAN_DIEU_CHITIET CT
                         WHERE     CT.TOIDANHID = TD.ID
                               AND CT.bananid = VBANANID
                               AND CT.bicanid = VBICANID)
               AND KHOAN IS NOT NULL;

        IF (KETQUA < 10)
        THEN
            KETQUA := '0' || KETQUA;
        END IF;

        OPEN CURRETURN FOR SELECT KETQUA KETQUAS FROM DUAL;
    END GET_TONG_SO_TOI;

    PROCEDURE GET_CT_TAMGIAM (VVUAN_ID         IN     VARCHAR2,
                              VHIEULUCTUNGAY   IN     VARCHAR2,
                              CurReturn           OUT SYS_REFCURSOR)
    AS
        KETQUA        VARCHAR2 (100);
        V_NGAYTHULY   DATE;
    BEGIN
        SELECT NGAYTHULY
          INTO V_NGAYTHULY
          FROM AHS_PHUCTHAM_THULY
         WHERE vuanid = VVUAN_ID;

        KETQUA := 90 - (TO_DATE (VHIEULUCTUNGAY, 'dd/MM/yyyy') - V_NGAYTHULY);

        OPEN CURRETURN FOR SELECT KETQUA KETQUAS FROM DUAL;
    END GET_CT_TAMGIAM;

    PROCEDURE DM_CANBO_GETALLTHUKY_TTV_CV (VDONVIID    IN     VARCHAR2,
                                           CurReturn      OUT SYS_REFCURSOR)
    AS
    BEGIN
        --13 CHUCVU --12 chức danh
        OPEN CURRETURN FOR
            /*SELECT A.ID,A.HOTEN,A.HOTEN || '-' || B.TEN || DECODE(b.toaanid,null, null,' (Biệt phái)') AS MA_TEN,D.TEN AS CHUCVU FROM DM_CANBO A
              left join DM_CANBO_BIETPHAI b on b.CANBOID=a.id and b.toaanid = vDonViID --lấy những cán bộ được biệt phái
              INNER JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=12
                          AND  C.MA IN ('TTV','TTVC','TTVCC','TK','TKVC','C008','C009','C010')
                          )B ON B.ID=A.CHUCDANHID
              LEFT JOIN (SELECT C.ID,C.TEN FROM DM_DATAITEM C WHERE C.GROUPID=13) D ON D.ID=A.CHUCVUID
            WHERE (A.TOAANID=VDONVIID AND A.HIEULUC=1) or (b.toaanid=VDONVIID and TO_CHAR(b.TUNGAY,'yyyy/mm/dd') <= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') and (TO_CHAR(b.DENNGAY,'yyyy/mm/dd') >= TO_CHAR(TRUNC(SYSDATE),'yyyy/mm/dd') or b.denngay is null)) ORDER BY A.HOTEN;*/
            SELECT A.ID,
                   A.HOTEN,
                   A.HOTEN || '-' || B.TEN     AS MA_TEN,
                   D.TEN                       AS CHUCVU
              FROM DM_CANBO  A
                   INNER JOIN (SELECT C.ID, C.TEN
                                 FROM DM_DATAITEM C
                                WHERE     C.GROUPID = 12
                                      AND C.MA IN ('TTV',
                                                   'TTVC',
                                                   'TTVCC',
                                                   'TK',
                                                   'TK1',
                                                   'TKVC',
                                                   'C008',
                                                   'C009',
                                                   'C010')) B
                       ON B.ID = A.CHUCDANHID
                   LEFT JOIN (SELECT C.ID, C.TEN
                                FROM DM_DATAITEM C
                               WHERE C.GROUPID = 13) D
                       ON D.ID = A.CHUCVUID
             WHERE (A.TOAANID = VDONVIID AND A.HIEULUC = 1)
            UNION
            SELECT A.ID,
                   A.HOTEN,
                   A.HOTEN || '-' || B.TEN || ' (Biệt phái)'
                       AS MA_TEN,
                   D.TEN
                       AS CHUCVU
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON bp.CANBOID = a.id AND bp.toaanid = VDONVIID --lấy những cán bộ được biệt phái
                   INNER JOIN (SELECT C.ID, C.TEN
                                 FROM DM_DATAITEM C
                                WHERE     C.GROUPID = 12
                                      AND C.MA IN ('TTV',
                                                   'TTVC',
                                                   'TTVCC',
                                                   'TK',
                                                   'TK1',
                                                   'TKVC',
                                                   'C008',
                                                   'C009',
                                                   'C010')) B
                       ON    (bp.CHUCDANH IS NOT NULL AND B.ID = bp.CHUCDANH)
                          OR (bp.CHUCDANH IS NULL AND B.ID = A.CHUCDANHID)
                   LEFT JOIN (SELECT C.ID, C.TEN
                                FROM DM_DATAITEM C
                               WHERE C.GROUPID = 13) D
                       ON    (bp.CHUCVU IS NOT NULL AND D.ID = bp.CHUCVU)
                          OR (bp.CHUCVU IS NULL AND D.ID = A.CHUCVUID)
             WHERE     A.HIEULUC = 1
                   AND (    bp.toaanid = VDONVIID
                        AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                            TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                        AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                             OR bp.denngay IS NULL))
            ORDER BY HOTEN;
    END DM_CANBO_GETALLTHUKY_TTV_CV;

    PROCEDURE DM_CANBO_GETBYDONVI_byCHUCVU (vDonViID    IN     NUMBER,
                                            v_VuAnID    IN     NUMBER,
                                            CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
              SELECT a.ID,
                     a.HOTEN,
                     a.HOTEN || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                         MA_TEN,
                     B.MA
                         MA_CHUCDANH
                FROM DM_CANBO a
                     INNER JOIN (SELECT c.ID, c.TEN, C.MA
                                   FROM DM_DATAITEM c
                                  WHERE c.GROUPID = vGroupChucDanhID) b
                         ON b.ID = a.CHUCDANHID
                     LEFT JOIN (SELECT c.ID, c.TEN, c.ThuTu
                                  FROM DM_DATAITEM c
                                 WHERE c.GROUPID = vGroupChucVuID --and (c.MA='CA' Or c.MA='PCA' or c.MA in ('0011','052'))
                                                                 ) d
                         ON d.ID = a.CHUCVUID
               WHERE a.TOAANID = vDonViID
            --And a.HIEULUC=1
            ORDER BY a.HIEULUC DESC, d.ThuTu;
    END DM_CANBO_GETBYDONVI_byCHUCVU;

    PROCEDURE SOLUONGDONKK_TOAKHAC (v_toa_an_id   IN     VARCHAR2,
                                    curReturn        OUT SYS_REFCURSOR)
    AS
        counts   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO counts
          FROM (SELECT ID
                  FROM ADS_DON_XULY a
                 WHERE     A.CDTN_TOAANID = v_toa_an_id
                       AND NOT EXISTS
                               (SELECT 'x'
                                  FROM ADS_DON_XULY
                                 WHERE     TOAANID = v_toa_an_id
                                       AND DONID = A.DONID)
                UNION ALL
                SELECT ID
                  FROM AHN_DON_XULY a
                 WHERE     A.CDTN_TOAANID = v_toa_an_id
                       AND NOT EXISTS
                               (SELECT 'x'
                                  FROM AHN_DON_XULY
                                 WHERE     TOAANID = v_toa_an_id
                                       AND DONID = A.DONID)
                UNION ALL
                SELECT ID
                  FROM AKT_DON_XULY a
                 WHERE     A.CDTN_TOAANID = v_toa_an_id
                       AND NOT EXISTS
                               (SELECT 'x'
                                  FROM AKT_DON_XULY
                                 WHERE     TOAANID = v_toa_an_id
                                       AND DONID = A.DONID)
                UNION ALL
                SELECT ID
                  FROM ALD_DON_XULY a
                 WHERE     A.CDTN_TOAANID = v_toa_an_id
                       AND NOT EXISTS
                               (SELECT 'x'
                                  FROM ALD_DON_XULY
                                 WHERE     TOAANID = v_toa_an_id
                                       AND DONID = A.DONID)
                UNION ALL
                SELECT ID
                  FROM AHC_DON_XULY a
                 WHERE     A.CDTN_TOAANID = v_toa_an_id
                       AND NOT EXISTS
                               (SELECT 'x'
                                  FROM AHC_DON_XULY
                                 WHERE     TOAANID = v_toa_an_id
                                       AND DONID = A.DONID));

        OPEN CurReturn FOR SELECT counts CountAll FROM DUAL;
    END;

    PROCEDURE GAIDOAN_UP (V_LOAI_AN         IN VARCHAR2,
                          V_VUAN_DONID      IN NUMBER,
                          V_MAGIAIDOAN      IN NUMBER,
                          V_TOAANID         IN NUMBER,
                          V_TOAPHUCTHAMID   IN NUMBER,
                          V_TOACAPCAOID     IN NUMBER,
                          V_TOANTOICAOID    IN NUMBER,
                          V_PHONGBANID      IN NUMBER)
    IS
        V_COUNT_CHECK   NUMBER;
        V_TOAANID_ST    NUMBER;
    BEGIN
        -- DM_LOAIAN
        --1 hình sự
        IF (V_LOAI_AN = '1')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHS_VUAN_GIAIDOAN GD
             WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK > 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    UPDATE AHS_VUAN_GIAIDOAN
                       SET TOAANID = V_TOAANID
                     WHERE     VUANID = V_VUAN_DONID
                           AND MAGIAIDOAN = V_MAGIAIDOAN;
                END IF;
            END IF;
        --2 dân sự
        ELSIF (V_LOAI_AN = '2')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ADS_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;

            -----
            IF (V_COUNT_CHECK > 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    UPDATE ADS_DON_GIAIDOAN
                       SET TOAANID = V_TOAANID
                     WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
                END IF;
            END IF;
        --3 hôn nhân gia đình
        ELSIF (V_LOAI_AN = '3')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHN_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK > 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    UPDATE AHN_DON_GIAIDOAN
                       SET TOAANID = V_TOAANID
                     WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
                END IF;
            END IF;
        ----4 kinh tế
        ELSIF (V_LOAI_AN = '4')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AKT_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK > 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    UPDATE AKT_DON_GIAIDOAN
                       SET TOAANID = V_TOAANID
                     WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
                END IF;
            END IF;
        --5 lao động
        ELSIF (V_LOAI_AN = '5')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ALD_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK > 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    UPDATE ALD_DON_GIAIDOAN
                       SET TOAANID = V_TOAANID
                     WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
                END IF;
            END IF;
        --6 hành chính
        ELSIF (V_LOAI_AN = '6')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK > 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    UPDATE AHC_DON_GIAIDOAN
                       SET TOAANID = V_TOAANID
                     WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
                END IF;
            END IF;
        ----------
        --phá sản 07
        --biện pháp xử lý hành chính 08
        --án GDTTT 09
        --AN_THA 10
        END IF;
    END;

    PROCEDURE GAIDOAN_DELETE (V_LOAI_AN      IN VARCHAR2,
                              V_VUAN_DONID   IN NUMBER,
                              V_MAGIAIDOAN   IN NUMBER)
    IS
    BEGIN
        IF (V_LOAI_AN = '1')
        THEN
            DELETE FROM AHS_VUAN_GIAIDOAN
                  WHERE VUANID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '2')
        THEN
            DELETE FROM ADS_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '3')
        THEN
            DELETE FROM AHN_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '4')
        THEN
            DELETE FROM AKT_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '5')
        THEN
            DELETE FROM ALD_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '6')
        THEN
            DELETE FROM AHC_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        END IF;
    END;

    PROCEDURE CHECK_CHUCDANH_THUKY_USER (vDonViID    IN     NUMBER,
                                         vChucDanh   IN     VARCHAR2,
                                         vCanBoID    IN     NUMBER,
                                         CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
              SELECT a.ID,
                     a.HOTEN,
                     a.HOTEN || '-' || b.TEN     AS MA_TEN,
                     d.TEN                       AS ChucVu
                FROM DM_CANBO a
                     INNER JOIN
                     (SELECT c.ID, c.TEN
                        FROM DM_DATAITEM c
                       WHERE     c.GROUPID = vGroupChucDanhID
                             AND c.MA = vChucDanh) b
                         ON b.ID = a.CHUCDANHID
                     LEFT JOIN
                     (SELECT c.ID, c.TEN
                        FROM DM_DATAITEM c
                       WHERE c.GROUPID = vGroupChucVuID) d
                         ON d.ID = a.CHUCVUID
               WHERE a.TOAANID = vDonViID AND a.HIEULUC = 1 AND a.ID = vCanBoID
            ORDER BY a.HOTEN;
    END CHECK_CHUCDANH_THUKY_USER;

--    1. Người tạo/sửa: VNPT-Nguyễn Trung Kiên
--    2. Mô tả: bổ sung thêm logs database khi insert fail
--    3. Thời gian tạo/sửa: 27-09-2025
    PROCEDURE GAIDOAN_IN_UP (V_LOAI_AN         IN VARCHAR2,
                             V_VUAN_DONID      IN NUMBER,
                             V_MAGIAIDOAN      IN NUMBER,
                             V_TOAANID         IN NUMBER,
                             V_TOAPHUCTHAMID   IN NUMBER,
                             V_TOACAPCAOID     IN NUMBER,
                             V_TOANTOICAOID    IN NUMBER,
                             V_PHONGBANID      IN NUMBER)
    IS
        V_COUNT_CHECK   NUMBER;
        V_TOAANID_ST    NUMBER;
        v_tracedata     VARCHAR2 (1024);
        v_output        VARCHAR2 (512);
    BEGIN
        v_tracedata :=
               '('
            || 'V_LOAI_AN => '
            || V_LOAI_AN
            || ','
            || 'V_VUAN_DONID => '
            || V_VUAN_DONID
            || ','
            || 'V_MAGIAIDOAN => '
            || V_MAGIAIDOAN
            || ','
            || 'V_TOAANID => '
            || V_TOAANID
            || ','
            || 'V_TOAPHUCTHAMID => '
            || V_TOAPHUCTHAMID
            || ','
            || ' );';

        -- DM_LOAIAN
        --1 hình sự
        IF (V_LOAI_AN = '1')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHS_VUAN_GIAIDOAN GD
             WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                         SELECT TOAANID
                           INTO V_TOAANID_ST
                           FROM AHS_VUAN_GIAIDOAN GD
                          WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = 2
                    FETCH FIRST 1 ROWS ONLY;

                    --------
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho ptqdk
                END IF;
            END IF;
        --2 dân sự
        ELSIF (V_LOAI_AN = '2')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ADS_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --              SELECT TOAANID INTO V_TOAANID_ST FROM ADS_DON_GIAIDOAN GD
                    --                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --                  FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho ptqdk
                END IF;
            END IF;
        --3 hôn nhân gia đình
        ELSIF (V_LOAI_AN = '3')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHN_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                         SELECT TOAANID
                           INTO V_TOAANID_ST
                           FROM AHN_DON_GIAIDOAN GD
                          WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = 2
                    FETCH FIRST 1 ROWS ONLY;

                    ---------
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        ----4 kinh tế
        ELSIF (V_LOAI_AN = '4')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AKT_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AKT_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        --5 lao động
        ELSIF (V_LOAI_AN = '5')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ALD_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO ALD_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                         SELECT TOAANID
                           INTO V_TOAANID_ST
                           FROM ALD_DON_GIAIDOAN GD
                          WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = 2
                    FETCH FIRST 1 ROWS ONLY;

                    ---------
                    INSERT INTO ALD_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO ALD_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        --6 hành chính
        ELSIF (V_LOAI_AN = '6')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        ----------
        --phá sản 07
        --biện pháp xử lý hành chính 08
        ELSIF (V_LOAI_AN = '8')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM XLHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO XLHC_DON_GIAIDOAN (DONID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID); -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO XLHC_DON_GIAIDOAN (DONID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID); -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO XLHC_DON_GIAIDOAN (DONID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID); -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        --án GDTTT 09
        --AN_THA 10
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            -- Rollback in case of any exception
            ROLLBACK;

            v_output :=
                   'Finish procedure Due to Exception: Error:'
                || SQLCODE
                || ','
                || SQLERRM;
            PKG_TRACELOG.SP_INSERT_LOG_ERROR (
                p_functionname   => 'PKG_STPT.GAIDOAN_IN_UP',
                p_description    => v_output,
                p_notes          => v_tracedata);

            -- Re-raise the exception
            RAISE;
    END;

    PROCEDURE GAIDOAN_IN_UP_XXLAI_PHUCTHAM (V_LOAI_AN         IN VARCHAR2,
                                            V_VUAN_DONID      IN NUMBER,
                                            V_MAGIAIDOAN      IN NUMBER,
                                            V_TOAANID         IN NUMBER,
                                            V_TOAPHUCTHAMID   IN NUMBER,
                                            V_TOACAPCAOID     IN NUMBER,
                                            V_TOANTOICAOID    IN NUMBER,
                                            V_PHONGBANID      IN NUMBER)
    IS
        V_COUNT_CHECK   NUMBER;
    BEGIN
        -- DM_LOAIAN
        --1 hình sự
        IF (V_LOAI_AN = '1')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHS_VUAN_GIAIDOAN GD
             WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 3)
                THEN
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --2 dân sự
        ELSIF (V_LOAI_AN = '2')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ADS_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 3)
                THEN
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --3 hôn nhân gia đình
        ELSIF (V_LOAI_AN = '3')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHN_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 3)
                THEN
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        ----4 kinh tế
        ELSIF (V_LOAI_AN = '4')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AKT_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 3)
                THEN
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --5 lao động
        ELSIF (V_LOAI_AN = '5')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ALD_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 3)
                THEN
                    INSERT INTO ALD_DON_GIAIDOAN -- UPDATE 060825: them toa giai quyet id
                                                 (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --6 hành chính
        ELSIF (V_LOAI_AN = '6')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 3)
                THEN
                    INSERT INTO AHC_DON_GIAIDOAN -- UPDATE 060825 them toa giai quyet id
                                                 (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        ----------
        --phá sản 07
        --biện pháp xử lý hành chính 08
        --án GDTTT 09
        --AN_THA 10
        END IF;
    END;

    PROCEDURE GAIDOAN_IN_UP_XXLAI_SOTHAM (V_LOAI_AN         IN VARCHAR2,
                                            V_VUAN_DONID      IN NUMBER,
                                            V_MAGIAIDOAN      IN NUMBER,
                                            V_TOAANID         IN NUMBER,
                                            V_TOAPHUCTHAMID   IN NUMBER,
                                            V_TOACAPCAOID     IN NUMBER,
                                            V_TOANTOICAOID    IN NUMBER,
                                            V_PHONGBANID      IN NUMBER)
    IS
        V_COUNT_CHECK   NUMBER;
    BEGIN
        -- DM_LOAIAN
        --1 hình sự
        IF (V_LOAI_AN = '1')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHS_VUAN_GIAIDOAN GD
             WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --2 dân sự
        ELSIF (V_LOAI_AN = '2')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ADS_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --3 hôn nhân gia đình
        ELSIF (V_LOAI_AN = '3')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHN_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        ----4 kinh tế
        ELSIF (V_LOAI_AN = '4')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AKT_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --5 lao động
        ELSIF (V_LOAI_AN = '5')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ALD_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO ALD_DON_GIAIDOAN -- UPDATE 060825: them toa giai quyet id
                                                 (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --6 hành chính
        ELSIF (V_LOAI_AN = '6')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHC_DON_GIAIDOAN -- UPDATE 060825 them toa giai quyet id
                                                 (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        ----------
        --phá sản 07
        --biện pháp xử lý hành chính 08
        --án GDTTT 09
        --AN_THA 10
        END IF;
    END;
    
    PROCEDURE DM_CANBO_GETBYDONVI_CHUCDANH (vDonViID    IN     NUMBER,
                                            vChucDanh   IN     VARCHAR2,
                                            CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        IF (vChucDanh = 'TP')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                            a.HOTEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                         || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN_STATUS,
                         a.HIEULUC
                    FROM DM_CANBO a
                         LEFT JOIN DM_CANBO_QUATRINH qt ON qt.CANBOID = a.id --30/10/2019 lấy những thẩm phán đã điều chuyển
                         INNER JOIN (SELECT c.ID, c.TEN
                                       FROM DM_DATAITEM c
                                      WHERE     c.GROUPID = vGroupChucDanhID
                                            AND c.MA IN ('TP',
                                                         'TPSC',
                                                         'TPTC',
                                                         'TPCC',
                                                         'TPTATC',
                                                         'TPBAC1',
                                                         'TPBAC2',
                                                         'TPBAC3')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE (qt.TOAANID = vDonViID OR a.TOAANID = vDonViID) --30/10/2019 lấy những thẩm phán đã điều chuyển
                --And a.HIEULUC=1
                GROUP BY a.ID,
                         a.HOTEN,
                         b.TEN,
                         d.TEN,
                         a.HIEULUC,
                         a.NGAYSINH
                UNION
                SELECT a.ID,
                          a.HOTEN
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       || ' (Biệt phái)'
                           AS HOTEN,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || ' (Biệt phái)'
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           AS MA_TEN,
                       d.TEN
                           AS ChucVu,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                       || ' (Biệt phái)'
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           HOTEN_STATUS,
                       a.HIEULUC
                  FROM DM_CANBO  a
                       INNER JOIN DM_CANBO_BIETPHAI bp
                           ON bp.CANBOID = a.id AND bp.toaanid = vDonViID --19/01/2022 lấy những thẩm phán biệt phái
                       INNER JOIN (SELECT c.ID, c.TEN
                                     FROM DM_DATAITEM c
                                    WHERE     c.GROUPID = vGroupChucDanhID
                                          AND c.MA IN ('TP',
                                                       'TPSC',
                                                       'TPTC',
                                                       'TPCC',
                                                       'TPTATC',
                                                       'TPBAC1',
                                                       'TPBAC2',
                                                       'TPBAC3')) b
                           ON    (    bp.CHUCDANH IS NOT NULL
                                  AND B.ID = bp.CHUCDANH)
                              OR (bp.CHUCDANH IS NULL AND B.ID = A.CHUCDANHID) --b.ID=bp.CHUCDANH
                       LEFT JOIN (SELECT c.ID, c.TEN
                                    FROM DM_DATAITEM c
                                   WHERE c.GROUPID = vGroupChucVuID) d
                           ON    (bp.CHUCVU IS NOT NULL AND D.ID = bp.CHUCVU)
                              OR (bp.CHUCVU IS NULL AND D.ID = A.CHUCVUID) --d.ID=bp.CHUCVU
                 WHERE     bp.toaanid = vDonViID
                       AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                           TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                       AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                               TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                            OR bp.denngay IS NULL)
                       AND a.HIEULUC = 1
                ORDER BY HIEULUC DESC, HOTEN;
        ELSIF (vChucDanh = 'TTV')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN
                         (SELECT c.ID, c.TEN
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA IN ('TTV', 'TTVC', 'TTVCC')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID                --And a.HIEULUC=1
                ORDER BY a.HOTEN;
        ELSIF (vChucDanh = 'TK')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN
                         (SELECT c.ID, c.TEN
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA IN ('TK', 'TKVC', 'TKCC')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID                --And a.HIEULUC=1
                ORDER BY a.HOTEN;
        ELSIF (vChucDanh = 'LTV')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN (SELECT c.ID, c.TEN
                                       FROM DM_DATAITEM c
                                      WHERE     c.GROUPID = vGroupChucDanhID
                                            AND c.MA IN ('C018',
                                                         'C019',
                                                         'C029',
                                                         'C030')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID                --And a.HIEULUC=1
                ORDER BY a.HOTEN;
        ELSIF (vChucDanh = 'HGV')
        THEN
            OPEN CurReturn FOR   SELECT a.ID,
                                        a.HOTEN,
                                        a.HOTEN || '-' || b.TEN     AS MA_TEN,
                                        d.TEN                       AS ChucVu
                                   FROM DM_CANBO a
                                        INNER JOIN
                                        (SELECT c.ID, c.TEN
                                           FROM DM_DATAITEM c
                                          WHERE     c.GROUPID =
                                                    vGroupChucDanhID
                                                AND c.MA IN ('HGV')) b
                                            ON b.ID = a.CHUCDANHID
                                        LEFT JOIN
                                        (SELECT c.ID, c.TEN
                                           FROM DM_DATAITEM c
                                          WHERE c.GROUPID = vGroupChucVuID) d
                                            ON d.ID = a.CHUCVUID
                                  WHERE a.TOAANID = vDonViID --And a.HIEULUC=1
                               ORDER BY a.HOTEN;
        ELSE
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN
                         (SELECT c.ID, c.TEN
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA = vChucDanh) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID AND a.HIEULUC = 1
                ORDER BY a.HOTEN;
        END IF;
    END DM_CANBO_GETBYDONVI_CHUCDANH;

    PROCEDURE DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU (
        vDonViID    IN     NUMBER,
        vChucDanh   IN     VARCHAR2,
        CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        IF (vChucDanh = 'TP')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                            a.HOTEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || d.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                         || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN_STATUS,
                         a.HIEULUC
                    FROM DM_CANBO a
                         LEFT JOIN DM_CANBO_QUATRINH qt ON qt.CANBOID = a.id --30/10/2019 lấy những thẩm phán đã điều chuyển
                         INNER JOIN (SELECT c.ID, c.TEN, c.MA
                                       FROM DM_DATAITEM c
                                      WHERE c.GROUPID = vGroupChucDanhID) b
                             ON     b.ID = a.CHUCDANHID
                                AND b.MA IN ('TP',
                                             'TPSC',
                                             'TPTC',
                                             'TPCC',
                                             'TPTATC',
                                             'TPBAC1',
                                             'TPBAC2',
                                             'TPBAC3')
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE     c.GROUPID = vGroupChucVuID
                                           AND c.MA IN ('042',
                                                        '041',
                                                        'CA',
                                                        'PCA')) d
                             ON d.ID = a.CHUCVUID
                   WHERE (qt.TOAANID = vDonViID OR a.TOAANID = vDonViID) --30/10/2019 lấy những thẩm phán đã điều chuyển
                --And a.HIEULUC=1
                GROUP BY a.ID,
                         a.HOTEN,
                         b.TEN,
                         d.TEN,
                         a.HIEULUC,
                         a.NGAYSINH
                UNION
                SELECT a.ID,
                          a.HOTEN
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       || ' (Biệt phái)'
                           AS HOTEN,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || ' (Biệt phái)'
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           AS MA_TEN,
                       d.TEN
                           AS ChucVu,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                       || ' (Biệt phái)'
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           HOTEN_STATUS,
                       a.HIEULUC
                  FROM DM_CANBO  a
                       INNER JOIN DM_CANBO_BIETPHAI bp
                           ON bp.CANBOID = a.id AND bp.toaanid = vDonViID --19/01/2022 lấy những thẩm phán biệt phái
                       INNER JOIN (SELECT c.ID, c.TEN
                                     FROM DM_DATAITEM c
                                    WHERE     c.GROUPID = vGroupChucDanhID
                                          AND c.MA IN ('TP',
                                                       'TPSC',
                                                       'TPTC',
                                                       'TPCC',
                                                       'TPTATC',
                                                       'TPBAC1',
                                                       'TPBAC2',
                                                       'TPBAC3')) b
                           ON    (    bp.CHUCDANH IS NOT NULL
                                  AND B.ID = bp.CHUCDANH)
                              OR (bp.CHUCDANH IS NULL AND B.ID = A.CHUCDANHID) --b.ID=bp.CHUCDANH
                       LEFT JOIN (SELECT c.ID, c.TEN, c.MA
                                    FROM DM_DATAITEM c
                                   WHERE c.GROUPID = vGroupChucVuID) d
                           ON    (bp.CHUCVU IS NOT NULL AND D.ID = bp.CHUCVU)
                              OR     (bp.CHUCVU IS NULL AND D.ID = A.CHUCVUID)
                                 AND (   (    d.MA IN ('042', '041')
                                          AND a.TOAANID != 1)
                                      OR (d.MA IN ('CA', 'PCA'))) --d.ID=bp.CHUCVU
                 WHERE     bp.toaanid = vDonViID
                       AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                           TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                       AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                               TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                            OR bp.denngay IS NULL)
                       AND a.HIEULUC = 1
                ORDER BY HIEULUC DESC, HOTEN;
        ELSIF (vChucDanh = 'TPTATC')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                            a.HOTEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                         || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN_STATUS,
                         a.HIEULUC
                    FROM DM_CANBO a
                         LEFT JOIN DM_CANBO_QUATRINH qt ON qt.CANBOID = a.id --30/10/2019 lấy những thẩm phán đã điều chuyển
                         INNER JOIN
                         (SELECT c.ID, c.TEN, c.MA
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA = 'TPTATC') b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE (qt.TOAANID = vDonViID OR a.TOAANID = vDonViID) --30/10/2019 lấy những thẩm phán đã điều chuyển
                --And a.HIEULUC=1
                GROUP BY a.ID,
                         a.HOTEN,
                         b.TEN,
                         d.TEN,
                         a.HIEULUC,
                         a.NGAYSINH
                UNION
                SELECT a.ID,
                          a.HOTEN
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       || ' (Biệt phái)'
                           AS HOTEN,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || ' (Biệt phái)'
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           AS MA_TEN,
                       d.TEN
                           AS ChucVu,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                       || ' (Biệt phái)'
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           HOTEN_STATUS,
                       a.HIEULUC
                  FROM DM_CANBO  a
                       INNER JOIN DM_CANBO_BIETPHAI bp
                           ON bp.CANBOID = a.id AND bp.toaanid = vDonViID --19/01/2022 lấy những thẩm phán biệt phái
                       INNER JOIN
                       (SELECT c.ID, c.TEN
                          FROM DM_DATAITEM c
                         WHERE     c.GROUPID = vGroupChucDanhID
                               AND c.MA = 'TPTATC') b
                           ON    (    bp.CHUCDANH IS NOT NULL
                                  AND B.ID = bp.CHUCDANH)
                              OR (bp.CHUCDANH IS NULL AND B.ID = A.CHUCDANHID) --b.ID=bp.CHUCDANH
                       LEFT JOIN (SELECT c.ID, c.TEN
                                    FROM DM_DATAITEM c
                                   WHERE c.GROUPID = vGroupChucVuID) d
                           ON    (bp.CHUCVU IS NOT NULL AND D.ID = bp.CHUCVU)
                              OR (bp.CHUCVU IS NULL AND D.ID = A.CHUCVUID) --d.ID=bp.CHUCVU
                 WHERE     bp.toaanid = vDonViID
                       AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                           TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                       AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                               TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                            OR bp.denngay IS NULL)
                       AND a.HIEULUC = 1
                ORDER BY HIEULUC DESC, HOTEN;
        --dùng cho xử lý đơn
        ELSIF (vChucDanh = 'XULYDON')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                            a.HOTEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || d.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                         || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             HOTEN_STATUS,
                         a.HIEULUC
                    FROM DM_CANBO a
                         LEFT JOIN DM_CANBO_QUATRINH qt ON qt.CANBOID = a.id --30/10/2019 lấy những thẩm phán đã điều chuyển
                         LEFT JOIN (SELECT c.ID, c.TEN, c.MA
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucDanhID) b
                             ON     b.ID = a.CHUCDANHID
                                AND b.MA IN ('TP',
                                             'TPSC',
                                             'TPTC',
                                             'TPCC',
                                             'TPTATC',
                                             'TPBAC1',
                                             'TPBAC2',
                                             'TPBAC3')
                         INNER JOIN (SELECT c.ID, c.TEN
                                       FROM DM_DATAITEM c
                                      WHERE     c.GROUPID = vGroupChucVuID
                                            AND c.MA IN ('042',
                                                         '041',
                                                         '073',
                                                         'CA',
                                                         'PCA')) d
                             ON d.ID = a.CHUCVUID
                   WHERE (qt.TOAANID = vDonViID OR a.TOAANID = vDonViID) --30/10/2019 lấy những thẩm phán đã điều chuyển
                --And a.HIEULUC=1
                GROUP BY a.ID,
                         a.HOTEN,
                         b.TEN,
                         d.TEN,
                         a.HIEULUC,
                         a.NGAYSINH
                UNION
                SELECT a.ID,
                          a.HOTEN
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       || ' (Biệt phái)'
                           AS HOTEN,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || ' (Biệt phái)'
                       || ' -  '
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           AS MA_TEN,
                       d.TEN
                           AS ChucVu,
                          a.HOTEN
                       || '-'
                       || b.TEN
                       || DECODE (d.TEN, NULL, NULL, '-' || d.TEN)
                       || ' (Biệt phái)'
                       || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                           HOTEN_STATUS,
                       a.HIEULUC
                  FROM DM_CANBO  a
                       INNER JOIN DM_CANBO_BIETPHAI bp
                           ON bp.CANBOID = a.id AND bp.toaanid = vDonViID --19/01/2022 lấy những thẩm phán biệt phái
                       INNER JOIN (SELECT c.ID, c.TEN
                                     FROM DM_DATAITEM c
                                    WHERE     c.GROUPID = vGroupChucDanhID
                                          AND c.MA IN ('TP',
                                                       'TPSC',
                                                       'TPTC',
                                                       'TPCC',
                                                       'TPTATC',
                                                       'TPBAC1',
                                                       'TPBAC2',
                                                       'TPBAC3')) b
                           ON    (    bp.CHUCDANH IS NOT NULL
                                  AND B.ID = bp.CHUCDANH)
                              OR (bp.CHUCDANH IS NULL AND B.ID = A.CHUCDANHID) --b.ID=bp.CHUCDANH
                       LEFT JOIN (SELECT c.ID, c.TEN, c.MA
                                    FROM DM_DATAITEM c
                                   WHERE c.GROUPID = vGroupChucVuID) d
                           ON    (bp.CHUCVU IS NOT NULL AND D.ID = bp.CHUCVU)
                              OR     (bp.CHUCVU IS NULL AND D.ID = A.CHUCVUID)
                                 AND (   (    d.MA IN ('042', '041', '073')
                                          AND a.TOAANID != 1)
                                      OR (d.MA IN ('CA', 'PCA'))) --d.ID=bp.CHUCVU
                 WHERE     bp.toaanid = vDonViID
                       AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                           TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                       AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                               TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                            OR bp.denngay IS NULL)
                       AND a.HIEULUC = 1
                ORDER BY HIEULUC DESC, HOTEN;
        ELSIF (vChucDanh = 'TTV')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN
                         (SELECT c.ID, c.TEN
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA IN ('TTV', 'TTVC', 'TTVCC')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID                --And a.HIEULUC=1
                ORDER BY a.HOTEN;
        ELSIF (vChucDanh = 'TK')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN
                         (SELECT c.ID, c.TEN
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA IN ('TK', 'TKVC', 'TKCC')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID                --And a.HIEULUC=1
                ORDER BY a.HOTEN;
        ELSIF (vChucDanh = 'LTV')
        THEN
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN (SELECT c.ID, c.TEN
                                       FROM DM_DATAITEM c
                                      WHERE     c.GROUPID = vGroupChucDanhID
                                            AND c.MA IN ('C018',
                                                         'C019',
                                                         'C029',
                                                         'C030')) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID                --And a.HIEULUC=1
                ORDER BY a.HOTEN;
        ELSIF (vChucDanh = 'HGV')
        THEN
            OPEN CurReturn FOR   SELECT a.ID,
                                        a.HOTEN,
                                        a.HOTEN || '-' || b.TEN     AS MA_TEN,
                                        d.TEN                       AS ChucVu
                                   FROM DM_CANBO a
                                        INNER JOIN
                                        (SELECT c.ID, c.TEN
                                           FROM DM_DATAITEM c
                                          WHERE     c.GROUPID =
                                                    vGroupChucDanhID
                                                AND c.MA IN ('HGV')) b
                                            ON b.ID = a.CHUCDANHID
                                        LEFT JOIN
                                        (SELECT c.ID, c.TEN
                                           FROM DM_DATAITEM c
                                          WHERE c.GROUPID = vGroupChucVuID) d
                                            ON d.ID = a.CHUCVUID
                                  WHERE a.TOAANID = vDonViID --And a.HIEULUC=1
                               ORDER BY a.HOTEN;
        ELSE
            OPEN CurReturn FOR
                  SELECT a.ID,
                         a.HOTEN,
                            a.HOTEN
                         || '-'
                         || b.TEN
                         || ' -  '
                         || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                             AS MA_TEN,
                         d.TEN
                             AS ChucVu
                    FROM DM_CANBO a
                         INNER JOIN
                         (SELECT c.ID, c.TEN
                            FROM DM_DATAITEM c
                           WHERE     c.GROUPID = vGroupChucDanhID
                                 AND c.MA = vChucDanh) b
                             ON b.ID = a.CHUCDANHID
                         LEFT JOIN (SELECT c.ID, c.TEN
                                      FROM DM_DATAITEM c
                                     WHERE c.GROUPID = vGroupChucVuID) d
                             ON d.ID = a.CHUCVUID
                   WHERE a.TOAANID = vDonViID AND a.HIEULUC = 1
                ORDER BY a.HOTEN;
        END IF;
    END DM_CANBO_GETBYDONVI_CHUCDANH_CHUCVU;

    PROCEDURE DM_CANBO_GETBYDONVI_2CHUCVU (vDonViID    IN     NUMBER,
                                           vChucVu1    IN     VARCHAR2,
                                           vChucVu2    IN     VARCHAR2,
                                           CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
        vMaDonvi           VARCHAR2 (20);
        vLoaitoa           VARCHAR2 (20);
        vChucVu1New        VARCHAR2 (10);
        vChucVu2New        VARCHAR2 (10);
    BEGIN
        --Neu don vi la 03 Tòa phúc tham toi cao thi thu lanh dao la Chanh Toa
        SELECT dv.ma, dv.loaitoa
          INTO vMaDonvi, vLoaitoa
          FROM dm_toaan dv
         WHERE id = vDonViID;

        --IF vMaDonvi IN ('D01.100', 'D01.101') THEN
        -- xử lý nếu vMaDonvi là một trong các giá trị trên
        IF vLoaitoa = 'CAPCAO'
        THEN
            vChucVu1New := '073';
            vChucVu2New := '074';
        ELSE
            vChucVu1New := vChucVu1;
            vChucVu2New := vChucVu2;
        END IF;

        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
            SELECT a.ID,
                   a.HOTEN || ' -  ' || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       HOTEN,
                      a.HOTEN
                   || '-'
                   || d.TEN
                   || ' -  '
                   || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       AS MA_TEN,
                   d.TEN
                       AS ChucVu,
                      a.HOTEN
                   || '-'
                   || d.TEN
                   || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                   || ' -  '
                   || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       HOTEN_STATUS,
                   a.hieuluc,
                   d.thutu
              FROM DM_CANBO  a
                   INNER JOIN (SELECT c.ID, c.TEN
                                 FROM DM_DATAITEM c
                                WHERE c.GROUPID = vGroupChucDanhID) b
                       ON b.ID = a.CHUCDANHID
                   INNER JOIN
                   (SELECT c.ID, c.TEN, c.ThuTu
                      FROM DM_DATAITEM c
                     WHERE     c.GROUPID = vGroupChucVuID
                           AND (   c.MA = vChucVu1New
                                OR c.MA = vChucVu2New
                                OR c.MA IN ('0011', '052'))) d
                       ON d.ID = a.CHUCVUID
             WHERE a.TOAANID = vDonViID
            --And a.HIEULUC=1
            UNION
            SELECT a.ID,
                   a.HOTEN || ' -  ' || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       HOTEN,
                      a.HOTEN
                   || '-'
                   || d.TEN
                   || ' (Biệt phái)'
                   || ' -  '
                   || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       AS MA_TEN,
                   d.TEN
                       AS ChucVu,
                      a.HOTEN
                   || '-'
                   || d.TEN
                   || ' (Biệt phái)'
                   || ' -  '
                   || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                       HOTEN_STATUS,
                   a.hieuluc,
                   d.thutu
              FROM DM_CANBO  a
                   INNER JOIN DM_CANBO_BIETPHAI bp
                       ON bp.CANBOID = a.id AND bp.toaanid = vDonViID
                   LEFT JOIN (SELECT c.ID, c.TEN
                                FROM DM_DATAITEM c
                               WHERE c.GROUPID = vGroupChucDanhID) b
                       ON    (bp.CHUCDANH IS NOT NULL AND b.ID = bp.CHUCDANH)
                          OR (bp.CHUCDANH IS NULL AND b.ID = A.CHUCDANHID)
                   INNER JOIN
                   (SELECT c.ID, c.TEN, c.ThuTu
                      FROM DM_DATAITEM c
                     WHERE     c.GROUPID = vGroupChucVuID
                           AND (   c.MA = vChucVu1New
                                OR c.MA = vChucVu2New
                                OR c.MA IN ('0011', '052'))) d
                       ON    (bp.CHUCVU IS NOT NULL AND d.ID = bp.CHUCVU)
                          OR (bp.CHUCVU IS NULL AND d.ID = A.CHUCVUID)
             WHERE     a.HIEULUC = 1
                   AND bp.toaanid = vDonViID
                   AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                       TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                   AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                           TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                        OR bp.denngay IS NULL)
            ORDER BY HIEULUC DESC, ThuTu, HOTEN;
    END DM_CANBO_GETBYDONVI_2CHUCVU;

    PROCEDURE DM_CANBO_GETBYDONVI_3CHUCVU (vDonViID    IN     NUMBER,
                                           vChucVu1    IN     VARCHAR2,
                                           vChucVu2    IN     VARCHAR2,
                                           vChucVu3    IN     VARCHAR2,
                                           CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
              SELECT a.ID,
                     a.HOTEN,
                        a.HOTEN
                     || '-'
                     || (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END)
                         AS MA_TEN,
                     (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END)
                         AS ChucVu,
                        a.HOTEN
                     || '-'
                     || CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END
                     || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                     || ' -  '
                     || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                         HOTEN_STATUS
                FROM DM_CANBO a
                     LEFT JOIN
                     (SELECT c.ID, c.TEN, c.ThuTu
                        FROM DM_DATAITEM c
                       WHERE (   c.MA = vChucVu1
                              OR c.MA = vChucVu2
                              OR c.MA IN ('0011', '052'))) d
                         ON d.ID = a.CHUCVUID
                     LEFT JOIN
                     (SELECT c.ID, c.TEN
                        FROM DM_DATAITEM c
                       WHERE C.MA IN (    SELECT (REGEXP_SUBSTR (vChucVu3,
                                                                 '[^,]+',
                                                                 1,
                                                                 LEVEL))
                                            FROM DUAL
                                      CONNECT BY REGEXP_SUBSTR (vChucVu3,
                                                                '[^,]+',
                                                                1,
                                                                LEVEL)
                                                     IS NOT NULL)) b
                         ON b.ID = a.CHUCDANHID
               WHERE     (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END)
                             IS NOT NULL
                     AND a.TOAANID = vDonViID
            --And a.HIEULUC=1
            ORDER BY a.HIEULUC DESC, d.ThuTu;
    END DM_CANBO_GETBYDONVI_3CHUCVU;


    PROCEDURE DM_CANBO_GETBYDONVI_3CHUCVU_HIEULUC (
        vDonViID    IN     NUMBER,
        vChucVu1    IN     VARCHAR2,
        vChucVu2    IN     VARCHAR2,
        vChucVu3    IN     VARCHAR2,
        CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucDanhID   NUMBER;
        vGroupChucVuID     NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucDanhID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCDANH';

        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
              SELECT a.ID,
                     a.HOTEN,
                        a.HOTEN
                     || '-'
                     || (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END)
                         AS MA_TEN,
                     (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END)
                         AS ChucVu,
                        a.HOTEN
                     || '-'
                     || CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END
                     || DECODE (a.HIEULUC, 0, ' (Nghỉ công tác)', NULL)
                     || ' -  '
                     || TO_CHAR (a.NGAYSINH, 'dd/MM/yyyy')
                         HOTEN_STATUS
                FROM DM_CANBO a
                     LEFT JOIN
                     (SELECT c.ID, c.TEN, c.ThuTu
                        FROM DM_DATAITEM c
                       WHERE (   c.MA = vChucVu1
                              OR c.MA = vChucVu2
                              OR c.MA IN ('0011', '052'))) d
                         ON d.ID = a.CHUCVUID
                     LEFT JOIN
                     (SELECT c.ID, c.TEN
                        FROM DM_DATAITEM c
                       WHERE C.MA IN (    SELECT (REGEXP_SUBSTR (vChucVu3,
                                                                 '[^,]+',
                                                                 1,
                                                                 LEVEL))
                                            FROM DUAL
                                      CONNECT BY REGEXP_SUBSTR (vChucVu3,
                                                                '[^,]+',
                                                                1,
                                                                LEVEL)
                                                     IS NOT NULL)) b
                         ON b.ID = a.CHUCDANHID
               WHERE     (CASE WHEN d.TEN IS NOT NULL THEN D.TEN ELSE B.TEN END)
                             IS NOT NULL
                     AND a.TOAANID = vDonViID
                     AND a.HIEULUC = 1
            ORDER BY a.HIEULUC DESC, d.ThuTu;
    END DM_CANBO_GETBYDONVI_3CHUCVU_HIEULUC;

    PROCEDURE DM_CANBO_GETBYDONVI (VDONVIID    IN     VARCHAR2,
                                   CurReturn      OUT SYS_REFCURSOR)
    AS
    BEGIN
        OPEN CURRETURN FOR
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Chánh án'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (A.TOAANID = VDONVIID AND A.CHUCVUID = 45)
                        OR (    bp.ID IS NOT NULL
                            AND (   bp.CHUCVU = 45
                                 OR (bp.CHUCVU IS NULL AND A.CHUCVUID = 45))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Phó chánh án'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (A.TOAANID = VDONVIID AND A.CHUCVUID = 74)
                        OR (    bp.ID IS NOT NULL
                            AND (   bp.CHUCVU = 74
                                 OR (bp.CHUCVU IS NULL AND A.CHUCVUID = 74))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Quyền chánh án'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (A.TOAANID = VDONVIID AND A.CHUCVUID = 436)
                        OR (    bp.ID IS NOT NULL
                            AND (   bp.CHUCVU = 436
                                 OR (bp.CHUCVU IS NULL AND A.CHUCVUID = 436))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Chánh văn phòng'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (A.TOAANID = VDONVIID AND A.CHUCVUID = 444)
                        OR (    bp.ID IS NOT NULL
                            AND (   bp.CHUCVU = 444
                                 OR (bp.CHUCVU IS NULL AND A.CHUCVUID = 444))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Phó chánh văn phòng'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (A.TOAANID = VDONVIID AND A.CHUCVUID = 425)
                        OR (    bp.ID IS NOT NULL
                            AND (   bp.CHUCVU = 425
                                 OR (bp.CHUCVU IS NULL AND A.CHUCVUID = 425))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Quyền chánh văn phòng'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (A.TOAANID = VDONVIID AND A.CHUCVUID = 435)
                        OR (    bp.ID IS NOT NULL
                            AND (   bp.CHUCVU = 435
                                 OR (bp.CHUCVU IS NULL AND A.CHUCVUID = 435))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Chánh tòa'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (    A.TOAANID = VDONVIID
                            AND A.CHUCVUID = 466
                            AND A.CHUCDANHID IN (383,
                                                 487,
                                                 507,
                                                 2338,
                                                 2319,
                                                 2318))
                        OR (    bp.ID IS NOT NULL
                            AND (   (    bp.CHUCVU = 466
                                     AND bp.CHUCDANH IN (383,
                                                         487,
                                                         507,
                                                         2338,
                                                         2319,
                                                         2318))
                                 OR (    bp.CHUCVU IS NULL
                                     AND A.CHUCVUID = 466
                                     AND A.CHUCDANHID IN (383,
                                                          487,
                                                          507,
                                                          2338,
                                                          2319,
                                                          2318)))))
                   AND A.HIEULUC = 1
            UNION ALL
            SELECT A.ID,
                      A.HOTEN
                   || '-'
                   || 'Thẩm phán'
                   || DECODE (bp.ID, NULL, '', ' (Biệt phái)')
                       AS MA_TEN,
                   A.CHUCDANHID
              FROM DM_CANBO  A
                   LEFT JOIN DM_CANBO_BIETPHAI bp
                       ON     bp.CANBOID = a.id
                          AND bp.toaanid = vDonViID
                          AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                              TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                          AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                  TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                               OR bp.denngay IS NULL)
             WHERE     (   (    A.TOAANID = VDONVIID
                            AND (   A.CHUCVUID NOT IN (45,
                                                       74,
                                                       436,
                                                       444,
                                                       425,
                                                       435,
                                                       466)
                                 OR A.CHUCVUID IS NULL)
                            AND A.CHUCDANHID IN (383,
                                                 487,
                                                 507,
                                                 2338,
                                                 2319,
                                                 2318))
                        OR (    bp.ID IS NOT NULL
                            AND (   (    (   bp.CHUCVU NOT IN (45,
                                                               74,
                                                               436,
                                                               444,
                                                               425,
                                                               435,
                                                               466)
                                          OR BP.CHUCVU IS NULL)
                                     AND bp.CHUCDANH IN (383,
                                                         487,
                                                         507,
                                                         2338,
                                                         2319,
                                                         2318))
                                 OR (    bp.CHUCVU IS NULL
                                     AND bp.CHUCDANH IS NULL
                                     AND (   A.CHUCVUID NOT IN (45,
                                                                74,
                                                                436,
                                                                444,
                                                                425,
                                                                435,
                                                                466)
                                          OR A.CHUCVUID IS NULL)
                                     AND A.CHUCDANHID IN (383,
                                                          487,
                                                          507,
                                                          2338,
                                                          2319,
                                                          2318)))))
                   AND A.HIEULUC = 1;
    END DM_CANBO_GETBYDONVI;

    PROCEDURE DM_TOAAN_GETBY_PARENT (V_CAPXX     IN     VARCHAR2,
                                     V_DONVIID   IN     VARCHAR2,
                                     V_LOAITOA   IN     VARCHAR2,
                                     curReturn      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN curReturn FOR
              SELECT t.ID,
                     t.MA,
                     t.TEN,
                     t.MA_TEN,
                     (   (CASE t.SOCAP
                              WHEN 1 THEN ''
                              WHEN 2 THEN '..'
                              WHEN 3 THEN '....'
                              WHEN 4 THEN '......'
                          END)
                      || t.MA_TEN)
                         AS arrTEN,
                     CASE
                         WHEN ROWNUM = 1 THEN t.TEN
                         WHEN ROWNUM > 1 THEN '...' || t.TEN
                     END
                         AS TenDonVi
                FROM DM_TOAAN t
               WHERE                                             --t.HIEULUC=1
                     (   (V_CAPXX IS NULL AND t.id = V_DONVIID)
                      OR (V_CAPXX = '2' AND t.id = V_DONVIID)
                      OR (    V_CAPXX = '3'
                          AND (t.id = V_DONVIID OR T.CAPCHAID = V_DONVIID)))
            --    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
            --                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
            --                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
            --                           )

            ORDER BY t.ARRTHUTU;
    END DM_TOAAN_GETBY_PARENT;

    PROCEDURE DM_TOAAN_GETBY_PARENT_HC (V_CAPXX     IN     VARCHAR2,
                                        V_DONVIID   IN     VARCHAR2,
                                        V_LOAITOA   IN     VARCHAR2,
                                        curReturn      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN curReturn FOR
              SELECT t.ID,
                     t.MA,
                     t.TEN,
                     t.MA_TEN,
                     (   (CASE t.SOCAP
                              WHEN 1 THEN ''
                              WHEN 2 THEN '..'
                              WHEN 3 THEN '....'
                              WHEN 4 THEN '......'
                          END)
                      || t.MA_TEN)
                         AS arrTEN,
                     CASE
                         WHEN ROWNUM = 1 THEN t.TEN
                         WHEN ROWNUM > 1 THEN '...' || t.TEN
                     END
                         AS TenDonVi
                FROM DM_TOAAN t
               WHERE                                             --t.HIEULUC=1
                     (   (V_CAPXX IS NULL AND t.id = V_DONVIID)
                      OR (V_CAPXX = '2' AND t.id = V_DONVIID)
                      OR (    V_CAPXX = '3'
                          AND (   t.id = V_DONVIID
                               OR T.CAPCHAID = V_DONVIID
                               OR t.CAPCHAID =
                                  (SELECT b.id
                                     FROM dm_toaan b
                                    WHERE     t.capchaid = b.id
                                          AND b.capchaid = V_DONVIID))))
            ORDER BY t.ARRTHUTU;
    END DM_TOAAN_GETBY_PARENT_HC;



    PROCEDURE DM_CANBO_GETALLTHUKY_TTV (VDONVIID    IN     VARCHAR2,
                                        VCHUCDANH   IN     VARCHAR2,
                                        CurReturn      OUT SYS_REFCURSOR)
    AS
    BEGIN
        --13 CHUCVU --12 chức danh

        OPEN CURRETURN FOR
            SELECT A.ID,
                   A.HOTEN,
                   A.HOTEN || '-' || B.TEN     AS MA_TEN,
                   D.TEN                       AS CHUCVU
              FROM DM_CANBO  A
                   INNER JOIN
                   (SELECT C.ID, C.TEN
                      FROM DM_DATAITEM C
                     WHERE     C.GROUPID = 12
                           AND (   (    (TRIM (vChucDanh)
                                             IS NULL)
                                    AND C.MA IN ('TTV',
                                                 'TTVC',
                                                 'TTVCC',
                                                 'TK1',
                                                 'C027',
                                                 'TK',
                                                 'TKVC')) --'TK1','C027','TK','TKVC' Thư ký,Thư ký Tòa án ko ÐHL,Thư ký Tòa án,Thư ký viên chính
                                OR (INSTR (
                                           ','
                                        || TRIM (vChucDanh)
                                        || ',',
                                        ',' || C.MA || ',') >
                                    0))) B
                       ON B.ID = A.CHUCDANHID
                   LEFT JOIN (SELECT C.ID, C.TEN
                                FROM DM_DATAITEM C
                               WHERE C.GROUPID = 13) D
                       ON D.ID = A.CHUCVUID
             WHERE (A.TOAANID = VDONVIID AND A.HIEULUC = 1)
            UNION
            SELECT A.ID,
                   A.HOTEN,
                   A.HOTEN || '-' || B.TEN || ' (Biệt phái)'
                       AS MA_TEN,
                   D.TEN
                       AS CHUCVU
              FROM DM_CANBO  A
                   INNER JOIN DM_CANBO_BIETPHAI bp
                       ON bp.CANBOID = a.id AND bp.toaanid = vDonViID --lấy những cán bộ được biệt phái
                   INNER JOIN
                   (SELECT C.ID, C.TEN
                      FROM DM_DATAITEM C
                     WHERE     C.GROUPID = 12
                           AND (   (    (TRIM (vChucDanh) IS NULL)
                                    AND C.MA IN ('TTV',
                                                 'TTVC',
                                                 'TTVCC',
                                                 'TK1',
                                                 'C027',
                                                 'TK',
                                                 'TKVC')) --'TK1','C027','TK','TKVC' Thư ký,Thư ký Tòa án ko ÐHL,Thư ký Tòa án,Thư ký viên chính
                                OR (INSTR (',' || TRIM (vChucDanh) || ',',
                                           ',' || C.MA || ',') >
                                    0))) B
                       ON    (bp.CHUCDANH IS NOT NULL AND B.ID = bp.CHUCDANH)
                          OR (bp.CHUCDANH IS NULL AND B.ID = A.CHUCDANHID)
                   LEFT JOIN (SELECT C.ID, C.TEN
                                FROM DM_DATAITEM C
                               WHERE C.GROUPID = 13) D
                       ON    (bp.CHUCVU IS NOT NULL AND D.ID = bp.CHUCVU)
                          OR (bp.CHUCVU IS NULL AND D.ID = A.CHUCVUID) --D.ID=bp.CHUCVU
             WHERE     A.HIEULUC = 1
                   AND (    bp.toaanid = VDONVIID
                        AND TO_CHAR (bp.TUNGAY, 'yyyy/mm/dd') <=
                            TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                        AND (   TO_CHAR (bp.DENNGAY, 'yyyy/mm/dd') >=
                                TO_CHAR (TRUNC (SYSDATE), 'yyyy/mm/dd')
                             OR bp.denngay IS NULL))
            ORDER BY HOTEN;
    END DM_CANBO_GETALLTHUKY_TTV;

    PROCEDURE DM_CANBO_GETALL (VDONVIID    IN     VARCHAR2,
                               CurReturn      OUT SYS_REFCURSOR)
    AS
    BEGIN
        --13 CHUCVU --12 chức danh
        OPEN CURRETURN FOR
              SELECT A.ID,
                     A.HOTEN,
                        A.HOTEN
                     || '-'
                     || B.TEN
                     || DECODE (D.TEN, NULL, NULL, '-' || D.TEN)
                         AS MA_TEN,
                     D.TEN
                         AS CHUCVU
                FROM DM_CANBO A
                     INNER JOIN (SELECT C.ID, C.TEN
                                   FROM DM_DATAITEM C
                                  WHERE C.GROUPID = 12) B
                         ON B.ID = A.CHUCDANHID
                     LEFT JOIN (SELECT C.ID, C.TEN
                                  FROM DM_DATAITEM C
                                 WHERE C.GROUPID = 13) D
                         ON D.ID = A.CHUCVUID
               WHERE A.TOAANID = VDONVIID AND A.HIEULUC = 1
            ORDER BY A.HOTEN;
    END DM_CANBO_GETALL;

    FUNCTION CHUYENAN_KTT_QUYEN_UPDATE (V_ID VARCHAR2, V_LOAI_AN VARCHAR2)
        RETURN SYS_REFCURSOR
    IS
        V_CURSOR      SYS_REFCURSOR;
        V_THANHCONG   VARCHAR2 (255);
    BEGIN
        --Những dữ liệu đã chuyển và đã nhận
        --update lại sự sai lệch về đơn vị,và update thành chưa nhận để nhận lại sẽ ok theo quy trình mới
        V_THANHCONG := NULL;

        ------------AHS_
        IF (V_LOAI_AN IS NULL OR (V_LOAI_AN = '1' AND V_LOAI_AN IS NOT NULL))
        THEN
            FOR rec
                IN (SELECT TA.TEN,
                           TA1.TEN     TEN_TOA_CHUYEN,
                           VA.ID,
                           VA.MAVUAN,
                           VA.TOAANID,
                           CN.TOACHUYENID,
                           CN.TOANHANID
                      FROM AHS_VUAN  VA
                           INNER JOIN AHS_CHUYEN_NHAN_AN CN
                               ON CN.VUANID = VA.ID
                           LEFT JOIN DM_TOAAN TA ON TA.ID = VA.TOAANID
                           LEFT JOIN DM_TOAAN TA1 ON TA1.ID = CN.TOACHUYENID
                     WHERE     CN.TRUONGHOPGIAONHANID = 266
                           AND (   V_ID IS NULL
                                OR (VA.ID = V_ID AND V_ID IS NOT NULL))--TRUONGHOP_GIAONHAN
                                                                       --266 Không thuộc thẩm quyền xét xử
                                                                       --271 Không thuộc thẩm quyền giải quyết
                                                                       )
            LOOP
                UPDATE AHS_VUAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE ID = REC.ID;

                -----------
                UPDATE AHS_VUAN_GIAIDOAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE VUANID = REC.ID;

                -----------
                UPDATE AHS_CHUYEN_NHAN_AN
                   SET TRANGTHAI = 0, NGAYNHAN = NULL, MAP_VUANID_NEW = NULL
                 WHERE VUANID = REC.ID;

                -----------
                COMMIT;
            END LOOP;

            V_THANHCONG := '1';
        END IF;

        ------------ADS_
        IF (V_LOAI_AN IS NULL OR (V_LOAI_AN = '2' AND V_LOAI_AN IS NOT NULL))
        THEN
            FOR rec
                IN (SELECT TA.TEN,
                           TA1.TEN     TEN_TOA_CHUYEN,
                           DON.ID,
                           DON.MAVUVIEC,
                           DON.TOAANID,
                           CN.TOACHUYENID,
                           CN.TOANHANID
                      FROM ADS_DON  DON
                           INNER JOIN ADS_CHUYEN_NHAN_AN CN
                               ON CN.VUANID = DON.ID
                           LEFT JOIN DM_TOAAN TA ON TA.ID = DON.TOAANID
                           LEFT JOIN DM_TOAAN TA1 ON TA1.ID = CN.TOACHUYENID
                     WHERE     CN.TRUONGHOPGIAONHANID = 266
                           AND (   V_ID IS NULL
                                OR (DON.ID = V_ID AND V_ID IS NOT NULL)))
            LOOP
                UPDATE ADS_DON
                   SET TOAANID = rec.TOACHUYENID
                 WHERE ID = REC.ID;

                -----------
                UPDATE ADS_DON_GIAIDOAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE DONID = REC.ID;

                -----------
                UPDATE ADS_CHUYEN_NHAN_AN
                   SET TRANGTHAI = 0, NGAYNHAN = NULL, MAP_VUANID_NEW = NULL
                 WHERE VUANID = REC.ID;

                -----------
                COMMIT;
            END LOOP;

            V_THANHCONG := V_THANHCONG || ',' || '2';
        END IF;

        --------AHN_------------
        IF (V_LOAI_AN IS NULL OR (V_LOAI_AN = '3' AND V_LOAI_AN IS NOT NULL))
        THEN
            FOR rec
                IN (SELECT TA.TEN,
                           TA1.TEN     TEN_TOA_CHUYEN,
                           DON.ID,
                           DON.MAVUVIEC,
                           DON.TOAANID,
                           CN.TOACHUYENID,
                           CN.TOANHANID
                      FROM AHN_DON  DON
                           INNER JOIN AHN_CHUYEN_NHAN_AN CN
                               ON CN.VUANID = DON.ID
                           LEFT JOIN DM_TOAAN TA ON TA.ID = DON.TOAANID
                           LEFT JOIN DM_TOAAN TA1 ON TA1.ID = CN.TOACHUYENID
                     WHERE     CN.TRUONGHOPGIAONHANID = 266
                           AND (   V_ID IS NULL
                                OR (DON.ID = V_ID AND V_ID IS NOT NULL)))
            LOOP
                UPDATE AHN_DON
                   SET TOAANID = rec.TOACHUYENID
                 WHERE ID = REC.ID;

                -----------
                UPDATE AHN_DON_GIAIDOAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE DONID = REC.ID;

                -----------
                UPDATE AHN_CHUYEN_NHAN_AN
                   SET TRANGTHAI = 0, NGAYNHAN = NULL, MAP_VUANID_NEW = NULL
                 WHERE VUANID = REC.ID;

                -----------
                COMMIT;
            END LOOP;

            V_THANHCONG := V_THANHCONG || ',' || '3';
        END IF;

        --------AKT_------------
        IF (V_LOAI_AN IS NULL OR (V_LOAI_AN = '4' AND V_LOAI_AN IS NOT NULL))
        THEN
            FOR rec
                IN (SELECT TA.TEN,
                           TA1.TEN     TEN_TOA_CHUYEN,
                           DON.ID,
                           DON.MAVUVIEC,
                           DON.TOAANID,
                           CN.TOACHUYENID,
                           CN.TOANHANID
                      FROM AKT_DON  DON
                           INNER JOIN AKT_CHUYEN_NHAN_AN CN
                               ON CN.VUANID = DON.ID
                           LEFT JOIN DM_TOAAN TA ON TA.ID = DON.TOAANID
                           LEFT JOIN DM_TOAAN TA1 ON TA1.ID = CN.TOACHUYENID
                     WHERE     CN.TRUONGHOPGIAONHANID = 266
                           AND (   V_ID IS NULL
                                OR (DON.ID = V_ID AND V_ID IS NOT NULL)))
            LOOP
                UPDATE AKT_DON
                   SET TOAANID = rec.TOACHUYENID
                 WHERE ID = REC.ID;

                -----------
                UPDATE AKT_DON_GIAIDOAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE DONID = REC.ID;

                -----------
                UPDATE AKT_CHUYEN_NHAN_AN
                   SET TRANGTHAI = 0, NGAYNHAN = NULL, MAP_VUANID_NEW = NULL
                 WHERE VUANID = REC.ID;

                -----------
                COMMIT;
            END LOOP;

            V_THANHCONG := V_THANHCONG || ',' || '4';
        END IF;

        IF (V_LOAI_AN IS NULL OR (V_LOAI_AN = '5' AND V_LOAI_AN IS NOT NULL))
        THEN
            --------ALD_------------
            FOR rec
                IN (SELECT TA.TEN,
                           TA1.TEN     TEN_TOA_CHUYEN,
                           DON.ID,
                           DON.MAVUVIEC,
                           DON.TOAANID,
                           CN.TOACHUYENID,
                           CN.TOANHANID
                      FROM ALD_DON  DON
                           INNER JOIN ALD_CHUYEN_NHAN_AN CN
                               ON CN.VUANID = DON.ID
                           LEFT JOIN DM_TOAAN TA ON TA.ID = DON.TOAANID
                           LEFT JOIN DM_TOAAN TA1 ON TA1.ID = CN.TOACHUYENID
                     WHERE     CN.TRUONGHOPGIAONHANID = 266
                           AND (   V_ID IS NULL
                                OR (DON.ID = V_ID AND V_ID IS NOT NULL)))
            LOOP
                UPDATE ALD_DON
                   SET TOAANID = rec.TOACHUYENID
                 WHERE ID = REC.ID;

                -----------
                UPDATE ALD_DON_GIAIDOAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE DONID = REC.ID;

                -----------
                UPDATE ALD_CHUYEN_NHAN_AN
                   SET TRANGTHAI = 0, NGAYNHAN = NULL, MAP_VUANID_NEW = NULL
                 WHERE VUANID = REC.ID;

                -----------
                COMMIT;
            END LOOP;

            V_THANHCONG := V_THANHCONG || ',' || '5';
        END IF;

        IF (V_LOAI_AN IS NULL OR (V_LOAI_AN = '6' AND V_LOAI_AN IS NOT NULL))
        THEN
            --------AHC_------------
            FOR rec
                IN (SELECT TA.TEN,
                           TA1.TEN     TEN_TOA_CHUYEN,
                           DON.ID,
                           DON.MAVUVIEC,
                           DON.TOAANID,
                           CN.TOACHUYENID,
                           CN.TOANHANID
                      FROM AHC_DON  DON
                           INNER JOIN AHC_CHUYEN_NHAN_AN CN
                               ON CN.VUANID = DON.ID
                           LEFT JOIN DM_TOAAN TA ON TA.ID = DON.TOAANID
                           LEFT JOIN DM_TOAAN TA1 ON TA1.ID = CN.TOACHUYENID
                     WHERE     CN.TRUONGHOPGIAONHANID = 266
                           AND (   V_ID IS NULL
                                OR (DON.ID = V_ID AND V_ID IS NOT NULL)))
            LOOP
                UPDATE AHC_DON
                   SET TOAANID = rec.TOACHUYENID
                 WHERE ID = REC.ID;

                -----------
                UPDATE AHC_DON_GIAIDOAN
                   SET TOAANID = rec.TOACHUYENID
                 WHERE DONID = REC.ID;

                -----------
                UPDATE AHC_CHUYEN_NHAN_AN
                   SET TRANGTHAI = 0, NGAYNHAN = NULL, MAP_VUANID_NEW = NULL
                 WHERE VUANID = REC.ID;

                -----------
                COMMIT;
            END LOOP;

            V_THANHCONG := V_THANHCONG || ',' || '6';
        END IF;

        --------------------
        OPEN V_CURSOR FOR SELECT V_THANHCONG THANHCONG FROM DUAL;

        RETURN V_CURSOR;
    END CHUYENAN_KTT_QUYEN_UPDATE;

    PROCEDURE DM_TOAAN_GETBY_PARENT_CHECK (V_CANBOID   IN     VARCHAR2,
                                           V_CAPXX     IN     VARCHAR2,
                                           V_DONVIID   IN     VARCHAR2,
                                           V_LOAITOA   IN     VARCHAR2,
                                           curReturn      OUT SYS_REFCURSOR)
    IS
        V_COUNT_CA        NUMBER;
        V_COUNT_PCA       NUMBER;
        V_COUNT_CAPDUOI   NUMBER;
    BEGIN
        -- Kiem tra xem can bo co phải CA không
        SELECT COUNT (*)
          INTO V_COUNT_CA
          FROM DM_CANBO cb
         WHERE     cb.id = V_CANBOID
               AND EXISTS
                       (SELECT C.ID, C.ten
                          FROM dm_dataitem C
                         WHERE     C.groupid = 13
                               AND C.ID IN (45)
                               AND CB.CHUCVUID = c.id);

        -- Kieam tra xem co  phai PCA khong
        SELECT COUNT (*)
          INTO V_COUNT_PCA
          FROM DM_CANBO cb
         WHERE     cb.id = V_CANBOID
               AND EXISTS
                       (SELECT C.ID, C.ten
                          FROM dm_dataitem C
                         WHERE     C.groupid = 13
                               AND C.ID IN (74, 446, 436)
                               AND CB.CHUCVUID = c.id);

        -- Kiem tra xem co thuoc nhom quyen xem du lieu cap duoi khong
        SELECT COUNT (*)
          INTO V_COUNT_CAPDUOI
          FROM QT_NGUOISUDUNG  nsd
               LEFT JOIN QT_NHOMNGUOIDUNG nh ON nh.ID = nsd.NHOMNSDID
         WHERE     nsd.canboid = V_CANBOID
               AND nsd.DONVIID = V_DONVIID
               AND nh.loai = 1;

        --45 Chánh án,74 Phó Chánh án,436 Quyền Chánh án,446 Phó Chánh án phụ trách
        --and EXISTS(SELECT 'X' FROM STPT_PCA_DIABAN db WHERE db.)
        OPEN curReturn FOR
              SELECT t.ID,
                     t.MA,
                     t.TEN,
                     t.MA_TEN,
                     (   (CASE t.SOCAP
                              WHEN 1 THEN ''
                              WHEN 2 THEN '..'
                              WHEN 3 THEN '....'
                              WHEN 4 THEN '......'
                          END)
                      || t.MA_TEN)
                         AS arrTEN,
                     CASE
                         WHEN ROWNUM = 1 THEN t.TEN
                         WHEN ROWNUM > 1 THEN '...' || t.TEN
                     END
                         AS TenDonVi
                FROM DM_TOAAN t
               WHERE                                             --t.HIEULUC=1
                     (   (V_CAPXX IS NULL AND t.id = V_DONVIID)
                      OR (    V_CAPXX IS NULL
                          AND (   (    V_COUNT_CA > 0
                                   AND (   t.id = V_DONVIID
                                        OR T.CAPCHAID = V_DONVIID))
                               OR (    V_COUNT_PCA > 0
                                   AND (   t.id = V_DONVIID
                                        OR (t.id IN
                                                (SELECT db.TOAANID
                                                   FROM STPT_PCA_DIABAN db
                                                  WHERE     db.DONVIID =
                                                            V_DONVIID
                                                        AND db.PCAID =
                                                            V_CANBOID))))
                               OR (    V_COUNT_CAPDUOI > 0
                                   AND V_COUNT_PCA = 0
                                   AND (   t.id = V_DONVIID
                                        OR T.CAPCHAID = V_DONVIID))))
                      OR (    V_CAPXX = '2'              --AND t.id= V_DONVIID
                          AND (   (t.id = V_DONVIID AND V_COUNT_CA = 0)
                               OR (    (   t.id = V_DONVIID
                                        OR T.CAPCHAID = V_DONVIID)
                                   AND V_COUNT_CA > 0)
                               OR (    (   t.id = V_DONVIID
                                        OR (t.id IN
                                                (SELECT db.TOAANID
                                                   FROM STPT_PCA_DIABAN db
                                                  WHERE     db.DONVIID =
                                                            V_DONVIID
                                                        AND db.PCAID =
                                                            V_CANBOID))--                                        OR T.CAPCHAID=V_DONVIID
                                                                       )
                                   AND V_COUNT_PCA > 0)
                               OR (    (   t.id = V_DONVIID
                                        OR (t.id IN
                                                (SELECT db.TOAANID
                                                   FROM STPT_PCA_DIABAN db
                                                  WHERE     db.DONVIID =
                                                            V_DONVIID
                                                        AND db.PCAID =
                                                            V_CANBOID)))
                                   AND V_COUNT_CAPDUOI > 0)) --đang làm dở mai thêm chọn tất cả cho chánh án
                                                            )
                      OR (    V_CAPXX = '3'
                          AND (t.id = V_DONVIID OR T.CAPCHAID = V_DONVIID)))
            --    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
            --                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
            --                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
            --                           )
            ORDER BY t.ARRTHUTU;
    END DM_TOAAN_GETBY_PARENT_CHECK;

    PROCEDURE DM_PCA_BYTOAAN (V_DONVIID   IN     VARCHAR2,
                              curReturn      OUT SYS_REFCURSOR)
    IS
        vGroupChucVuID   NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
            SELECT a.ID, 'PCA.' || a.hoten hoten, b.Ten TenChucVu
              FROM dm_canbo  a
                   --manhnd bo không cần phải có tài khoản trên phần mềm để hiển thị
                   --inner join QT_NGUOISUDUNG c on c.canboid=a.id
                   INNER JOIN dm_dataitem b ON a.ChucVuID = b.ID
                   INNER JOIN DM_TOAAN t ON t.id = a.TOAANID
             WHERE     t.id = V_DONVIID
                   AND b.GroupId = vGroupChucVuID
                   AND b.hieuluc = 1
                   AND b.Ma IN ('PCA')
                   --anhvh add 08/04/2020 loại bỏ chánh án tối cao, khhông hiển thị báo cáo login này
                   AND NOT EXISTS
                           (SELECT 'x'
                              FROM DM_DATAITEM i
                             WHERE     i.MA IN ('TPTATC')
                                   AND i.GROUPID = 12
                                   AND i.id = a.CHUCDANHID);
    END DM_PCA_BYTOAAN;

    PROCEDURE DM_LANHDAO_BYTOAAN (V_DONVIID   IN     VARCHAR2,
                                  curReturn      OUT SYS_REFCURSOR)
    IS
        vGroupChucVuID   NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
              SELECT a.ID, b.Ma || '.' || a.hoten hoten, b.Ten TenChucVu
                FROM dm_canbo a
                     INNER JOIN dm_dataitem b ON a.ChucVuID = b.ID
                     INNER JOIN DM_TOAAN t ON t.id = a.TOAANID
               WHERE     t.id = V_DONVIID
                     AND b.GroupId = vGroupChucVuID
                     AND a.hieuluc = 1
                     AND b.Ma IN ('PCA', 'CA')
            ORDER BY id DESC;
    END DM_LANHDAO_BYTOAAN;


    PROCEDURE DM_TOAAN_DIABAN (V_CANBOID   IN     VARCHAR2,
                               V_DONVIID   IN     VARCHAR2,
                               curReturn      OUT SYS_REFCURSOR)
    IS
        V_COUNT_CB   NUMBER;
    BEGIN
        SELECT COUNT (*)
          INTO V_COUNT_CB
          FROM DM_CANBO cb
         WHERE     cb.id = V_CANBOID
               AND EXISTS
                       (SELECT C.ID, C.ten
                          FROM dm_dataitem C
                         WHERE     C.groupid = 13
                               AND C.ID IN (74, 446, 436)
                               AND CB.CHUCVUID = c.id);

        --45 Chánh án,74 Phó Chánh án,436 Quyền Chánh án,446 Phó Chánh án phụ trách
        OPEN curReturn FOR
              SELECT t.ID,
                     t.MA,
                     t.TEN,
                     t.MA_TEN,
                     (   (CASE t.SOCAP
                              WHEN 1 THEN ''
                              WHEN 2 THEN '..'
                              WHEN 3 THEN '....'
                              WHEN 4 THEN '......'
                          END)
                      || t.MA_TEN)
                         AS arrTEN,
                     CASE
                         WHEN ROWNUM = 1 THEN t.TEN
                         WHEN ROWNUM > 1 THEN '...' || t.TEN
                     END
                         AS TenDonVi
                FROM DM_TOAAN t
               WHERE                                             --t.HIEULUC=1
                     t.CAPCHAID = V_DONVIID
            --    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
            --                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
            --                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
            --                           )
            ORDER BY t.ARRTHUTU;
    END DM_TOAAN_DIABAN;

    PROCEDURE PCA_AND_DIABAN (V_DONVIID   IN     VARCHAR2,
                              vCanboID    IN     VARCHAR2,
                              vToaanID    IN     VARCHAR2,
                              curReturn      OUT SYS_REFCURSOR)
    IS
        V_COUNT_CB   NUMBER;
    BEGIN
        OPEN curReturn FOR
              SELECT ROW_NUMBER () OVER (ORDER BY t.TEN)
                         AS TT,
                     t.ID,
                     t.MA,
                     t.TEN,
                     t.MA_TEN,
                     (   (CASE t.SOCAP
                              WHEN 1 THEN ''
                              WHEN 2 THEN '..'
                              WHEN 3 THEN '....'
                              WHEN 4 THEN '......'
                          END)
                      || t.MA_TEN)
                         AS arrTEN,
                     CASE
                         WHEN ROWNUM = 1 THEN t.TEN
                         WHEN ROWNUM > 1 THEN '...' || t.TEN
                     END
                         AS TenDonVi,
                     c.PCAID,
                     t.ID
                         TOAANID,
                     TO_CHAR (c.NGAYPHANCONG, 'dd/MM/yyyy')
                         NGAYPHANCONG
                FROM DM_TOAAN t
                     LEFT JOIN
                     (SELECT PCAID,
                             DONVIID,
                             TOAANID,
                             NGAYPHANCONG
                        FROM STPT_PCA_DIABAN
                       WHERE NVL (DONVIID, 0) > 0 AND DONVIID = V_DONVIID) c
                         ON c.TOAANID = t.ID
               WHERE                                             --t.HIEULUC=1
                         t.CAPCHAID = V_DONVIID
                     AND (vCanboID = 0 OR c.PCAID = vCanboID)
                     AND (vToaanID = 0 OR t.id = vToaanID)
            --    and ( (V_LOAITOA!='CAPHUYEN' AND  V_LOAITOA!='CAPTINH')
            --                           OR(V_LOAITOA='CAPHUYEN' AND t.id= V_DONVIID)
            --                           or(V_LOAITOA='CAPTINH' AND (t.id= V_DONVIID OR T.CAPCHAID=V_DONVIID))
            --                           )
            ORDER BY t.TEN;
    ---STPT_PCA_DIABAN_SEQ
    END PCA_AND_DIABAN;

    PROCEDURE PCA_AND_DIABAN_IN_UP (V_DONVIID      IN NUMBER,
                                    vCurrCanboID   IN NUMBER,
                                    vOLDCanboID    IN NUMBER,
                                    vToaanID       IN NUMBER,
                                    vNGAYPC        IN DATE)
    IS
        V_COUNT_CB   NUMBER;
    BEGIN
        IF vOLDCanboID = 0 AND vCurrCanboID > 0 AND vToaanID > 0
        THEN                                                          --insert
            INSERT INTO STPT_PCA_DIABAN (ID,
                                         PCAID,
                                         DONVIID,
                                         TOAANID,
                                         NGAYPHANCONG)
                 VALUES (STPT_PCA_DIABAN_SEQ.NEXTVAL,
                         vCurrCanboID,
                         V_DONVIID,
                         vToaanID,
                         vNGAYPC);
        ELSE
            --update
            IF vOLDCanboID > 0 AND vCurrCanboID = 0 AND vToaanID > 0
            THEN                                               -- Xoa cau hinh
                DELETE FROM STPT_PCA_DIABAN
                      WHERE     DONVIID = V_DONVIID
                            AND PCAID = vOLDCanboID
                            AND TOAANID = vToaanID;
            ELSIF vOLDCanboID > 0 AND vCurrCanboID > 0 AND vToaanID > 0
            THEN
                UPDATE STPT_PCA_DIABAN
                   SET PCAID = vCurrCanboID, NGAYPHANCONG = vNGAYPC
                 WHERE     DONVIID = V_DONVIID
                       AND PCAID = vOLDCanboID
                       AND TOAANID = vToaanID;
            END IF;
        END IF;
    ---STPT_PCA_DIABAN_SEQ
    END PCA_AND_DIABAN_IN_UP;

    PROCEDURE GETBY_TAMGIAM_10NGAY (V_LOAITOA   IN     VARCHAR2,
                                    V_DONVIID   IN     VARCHAR2,
                                    PageIndex   IN     INT,
                                    PageSize    IN     INT,
                                    curReturn      OUT SYS_REFCURSOR)
    IS
        TotalItem   NUMBER;
        MinIndex    NUMBER;
        MaxIndex    NUMBER;
        V_TABLE     T_LENH_TAMGIAM;
    BEGIN
        V_TABLE := T_LENH_TAMGIAM ();
        ----------------------------------------------
        MinIndex := PageSize * (PageIndex - 1) + 1;
        MaxIndex := PageIndex * PageSize;

        -------------------
        FOR item
            IN (SELECT BC.HOTEN,
                       TO_CHAR (NC.NGAYBATDAU, 'dd/MM/yyyy')
                           NGAYBATDAU,
                       TO_CHAR (NC.NGAYKETTHUC, 'dd/MM/yyyy')
                           NGAYKETTHUC,
                       VA.MAVUAN,
                       VA.TENVUAN,
                       'SƠ THẨM'
                           CAPXX,
                       TA.MA_TEN
                           TOAAN_TEN,
                       TRANSLATE (b.TEN USING CHAR_CS)
                           CHUCNANG
                  FROM AHS_BICANBICAO  BC
                       LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN NC
                           ON BC.ID = NC.BICANID
                       LEFT JOIN
                       (                                 --biện pháp ngăn chặn
                        SELECT it.ID, it.Ten
                          FROM DM_DataItem it
                         WHERE it.GroupID IN
                                   (SELECT g.id
                                      FROM DM_DataGroup g
                                     WHERE g.Ma LIKE 'BIENPHAPNGANCHAN')) b
                           ON b.id = NC.BienPhapNganChanID
                       LEFT JOIN AHS_VUAN VA ON VA.ID = BC.VUANID
                       LEFT JOIN AHS_VUAN_GIAIDOAN GD
                           ON GD.VUANID = VA.ID AND GD.MAGIAIDOAN = 2
                       LEFT JOIN DM_TOAAN TA ON TA.ID = GD.TOAANID
                 WHERE     (   (    VA.TOAANID = V_DONVIID
                                AND V_LOAITOA != 'CAPCAO')
                            OR (    V_LOAITOA = 'CAPCAO'
                                AND EXISTS
                                        (SELECT 'X'
                                           FROM AHS_CHUYEN_NHAN_AN
                                          WHERE     VUANID = VA.ID
                                                AND TOANHANID = V_DONVIID)
                                AND NOT EXISTS
                                        (SELECT 'X'
                                           FROM AHS_PHUCTHAM_QUYETDINH_BICAN
                                          WHERE BICANID = BC.ID)))
                       AND (    ROUND (NC.NGAYKETTHUC - SYSDATE) <= 5
                            AND SYSDATE < NC.NGAYKETTHUC)
                       AND NC.BIENPHAPNGANCHANID IN (138, 140)
                       AND TO_DATE (TO_CHAR (NC.NGAYKETTHUC, 'dd/MM/yyyy'),
                                    'dd/MM/yyyy') !=
                           TO_DATE ('01/01/0001', 'dd/MM/yyyy'))
        LOOP
            V_TABLE.EXTEND;
            V_TABLE (V_TABLE.COUNT) :=
                R_LENH_TAMGIAM (item.HOTEN,
                                item.NGAYBATDAU,
                                item.NGAYKETTHUC,
                                item.MAVUAN,
                                item.TENVUAN,
                                item.CAPXX,
                                item.TOAAN_TEN,
                                item.CHUCNANG);
        END LOOP;

        ------------------------
        FOR item
            IN (SELECT BC.HOTEN,
                       TO_CHAR (ST.HIEULUCTU, 'dd/MM/yyyy')      NGAYBATDAU,
                       TO_CHAR (ST.HIEULUCDEN, 'dd/MM/yyyy')     NGAYKETTHUC,
                       VA.MAVUAN,
                       VA.TENVUAN,
                       'SƠ THẨM'                              CAPXX,
                       TA.MA_TEN                                 TOAAN_TEN,
                       TRANSLATE (d.TEN USING CHAR_CS)           CHUCNANG
                  FROM AHS_BICANBICAO  BC
                       LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN ST
                           ON ST.BICANID = BC.ID
                       LEFT JOIN DM_QD_QUYETDINH d ON d.ID = ST.QUYETDINHID
                       LEFT JOIN AHS_VUAN VA ON VA.ID = BC.VUANID
                       LEFT JOIN AHS_VUAN_GIAIDOAN GD
                           ON GD.VUANID = VA.ID AND GD.MAGIAIDOAN = 2
                       LEFT JOIN DM_TOAAN TA ON TA.ID = GD.TOAANID
                 WHERE     (   (    VA.TOAANID = V_DONVIID
                                AND V_LOAITOA != 'CAPCAO')
                            OR (    V_LOAITOA = 'CAPCAO'
                                AND EXISTS
                                        (SELECT 'X'
                                           FROM AHS_CHUYEN_NHAN_AN
                                          WHERE     VUANID = VA.ID
                                                AND TOANHANID = V_DONVIID)
                                AND NOT EXISTS
                                        (SELECT 'X'
                                           FROM AHS_PHUCTHAM_QUYETDINH_BICAN
                                          WHERE BICANID = BC.ID)))
                       AND ROUND (ST.HIEULUCDEN - SYSDATE) <= 5
                       AND SYSDATE < ST.HIEULUCDEN
                       AND ST.LOAIQDID = 121
                       AND TO_DATE (TO_CHAR (ST.HIEULUCDEN, 'dd/MM/yyyy'),
                                    'dd/MM/yyyy') !=
                           TO_DATE ('01/01/0001', 'dd/MM/yyyy'))
        LOOP
            V_TABLE.EXTEND;
            V_TABLE (V_TABLE.COUNT) :=
                R_LENH_TAMGIAM (item.HOTEN,
                                item.NGAYBATDAU,
                                item.NGAYKETTHUC,
                                item.MAVUAN,
                                item.TENVUAN,
                                item.CAPXX,
                                item.TOAAN_TEN,
                                item.CHUCNANG);
        END LOOP;

        -----------------
        FOR item
            IN (SELECT BC.HOTEN,
                       TO_CHAR (PT.HIEULUCTU, 'dd/MM/yyyy')      NGAYBATDAU,
                       TO_CHAR (PT.HIEULUCDEN, 'dd/MM/yyyy')     NGAYKETTHUC,
                       VA.MAVUAN,
                       VA.TENVUAN,
                       'PHÚC THẨM'                            CAPXX,
                       TA.MA_TEN                                 TOAAN_TEN,
                       TRANSLATE (d.TEN USING CHAR_CS)           CHUCNANG
                  FROM AHS_BICANBICAO  BC
                       LEFT JOIN AHS_PHUCTHAM_QUYETDINH_BICAN PT
                           ON PT.BICANID = BC.ID
                       LEFT JOIN DM_QD_QUYETDINH d ON d.ID = PT.QUYETDINHID
                       LEFT JOIN AHS_VUAN VA ON VA.ID = BC.VUANID
                       LEFT JOIN AHS_VUAN_GIAIDOAN GD
                           ON GD.VUANID = VA.ID AND GD.MAGIAIDOAN = 3
                       LEFT JOIN DM_TOAAN TA ON TA.ID = GD.TOAPHUCTHAMID
                 WHERE     VA.TOAPHUCTHAMID = V_DONVIID
                       AND ROUND (PT.HIEULUCDEN - SYSDATE) <= 5
                       AND SYSDATE < PT.HIEULUCDEN
                       AND PT.LOAIQDID = 121
                       AND TO_DATE (TO_CHAR (PT.HIEULUCDEN, 'dd/MM/yyyy'),
                                    'dd/MM/yyyy') !=
                           TO_DATE ('01/01/0001', 'dd/MM/yyyy'))
        LOOP
            V_TABLE.EXTEND;
            V_TABLE (V_TABLE.COUNT) :=
                R_LENH_TAMGIAM (item.HOTEN,
                                item.NGAYBATDAU,
                                item.NGAYKETTHUC,
                                item.MAVUAN,
                                item.TENVUAN,
                                item.CAPXX,
                                item.TOAAN_TEN,
                                item.CHUCNANG);
        END LOOP;

        -------------------
        OPEN curReturn FOR
            SELECT c.*
              FROM (SELECT ROW_NUMBER ()
                               OVER (
                                   ORDER BY
                                       TO_DATE (a.NGAYKETTHUC, 'dd/MM/yyyy'),
                                       a.MAVUAN)
                               STT,
                           COUNT (*) OVER ()
                               AS CountAll,
                           a.*
                      FROM (SELECT PA.*
                              FROM TABLE (V_TABLE) PA) a) c
             WHERE c.STT >= MinIndex AND c.STT <= MaxIndex;
    END GETBY_TAMGIAM_10NGAY;


    PROCEDURE Get_VUAN_by_VUANID_NGUOITAO (vVuAnID     IN     NUMBER,
                                           vNguoiTao   IN     NVARCHAR2,
                                           curReturn      OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN curReturn FOR SELECT COUNT (*)
                             FROM AHS_VUAN v
                            WHERE v.ID = vVuAnID;
    --And v.nguoitao = vNguoiTao;
    END Get_VUAN_by_VUANID_NGUOITAO;

    PROCEDURE ADS_FILE_GETBYDON (vLoaiAn       IN     NUMBER,
                                 vMaGiaiDoan          NUMBER,
                                 vDonID               NUMBER,
                                 curReturn        OUT SYS_REFCURSOR)
    IS
    BEGIN
        IF vLoaiAn = 1
        THEN
            OPEN curReturn FOR
                  SELECT b.ID,
                         b.MABM,
                         b.DUONGDAN,
                         b.TENBM,
                         b.THUTU
                    FROM DM_BIEUMAU b
                         INNER JOIN (SELECT DISTINCT BIEUMAUID
                                       FROM AHS_FILE
                                      WHERE VUANID = vDonID) f
                             ON f.BIEUMAUID = b.ID
                   WHERE     b.ISPRINT = 1
                         AND b.ACTIVE = 1
                         AND b.ISAHS = 1
                         AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                              OR (    vMaGiaiDoan = 2
                                  AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                              OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                              OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                ORDER BY b.THUTU;
        ELSIF vLoaiAn = 2
        THEN
            OPEN curReturn FOR
                  SELECT bb.*
                    FROM (SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                                 INNER JOIN
                                 (SELECT DISTINCT BIEUMAUID
                                    FROM ADS_FILE
                                   WHERE DONID = vDonID) f
                                     ON f.BIEUMAUID = b.ID
                           WHERE     b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISADS = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                          UNION
                          SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                           WHERE     b.ISLUONHIENTHI = 1
                                 AND b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISADS = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1)))
                         bb
                ORDER BY bb.THUTU;
        ELSIF vLoaiAn = 3
        THEN
            OPEN curReturn FOR
                  SELECT bb.*
                    FROM (SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                                 INNER JOIN
                                 (SELECT DISTINCT BIEUMAUID
                                    FROM AHN_FILE
                                   WHERE DONID = vDonID) f
                                     ON f.BIEUMAUID = b.ID
                           WHERE     b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAHN = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                          UNION
                          SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                           WHERE     b.ISLUONHIENTHI = 1
                                 AND b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAHN = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1)))
                         bb
                ORDER BY bb.THUTU;
        ELSIF vLoaiAn = 4
        THEN
            OPEN curReturn FOR
                  SELECT bb.*
                    FROM (SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                                 INNER JOIN
                                 (SELECT DISTINCT BIEUMAUID
                                    FROM AKT_FILE
                                   WHERE DONID = vDonID) f
                                     ON f.BIEUMAUID = b.ID
                           WHERE     b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAKT = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                          UNION
                          SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                           WHERE     b.ISLUONHIENTHI = 1
                                 AND b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAKT = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1)))
                         bb
                ORDER BY bb.THUTU;
        ELSIF vLoaiAn = 5
        THEN
            OPEN curReturn FOR
                  SELECT bb.*
                    FROM (SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                                 INNER JOIN
                                 (SELECT DISTINCT BIEUMAUID
                                    FROM ALD_FILE
                                   WHERE DONID = vDonID) f
                                     ON f.BIEUMAUID = b.ID
                           WHERE     b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISALD = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                          UNION
                          SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                           WHERE     b.ISLUONHIENTHI = 1
                                 AND b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISALD = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1)))
                         bb
                ORDER BY bb.THUTU;
        ELSIF vLoaiAn = 6
        THEN
            OPEN curReturn FOR
                  SELECT bb.*
                    FROM (SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                                 INNER JOIN
                                 (SELECT DISTINCT BIEUMAUID
                                    FROM AHC_FILE
                                   WHERE DONID = vDonID) f
                                     ON f.BIEUMAUID = b.ID
                           WHERE     b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAHC = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                          UNION
                          SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                           WHERE     b.ISLUONHIENTHI = 1
                                 AND b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAHC = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1)))
                         bb
                ORDER BY bb.THUTU;
        ELSIF vLoaiAn = 7
        THEN
            OPEN curReturn FOR
                  SELECT bb.*
                    FROM (SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                                 INNER JOIN
                                 (SELECT DISTINCT BIEUMAUID
                                    FROM APS_FILE
                                   WHERE DONID = vDonID) f
                                     ON f.BIEUMAUID = b.ID
                           WHERE     b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAPS = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                          UNION
                          SELECT b.ID,
                                 b.MABM,
                                 b.DUONGDAN,
                                 b.TENBM,
                                 b.THUTU
                            FROM DM_BIEUMAU b
                           WHERE     b.ISLUONHIENTHI = 1
                                 AND b.ISPRINT = 1
                                 AND b.ACTIVE = 1
                                 AND b.ISAPS = 1
                                 AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                                      OR (    vMaGiaiDoan = 2
                                          AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                                      OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                                      OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1)))
                         bb
                ORDER BY bb.THUTU;
        ELSIF vLoaiAn = 8
        THEN
            OPEN curReturn FOR
                  SELECT b.ID,
                         b.MABM,
                         b.DUONGDAN,
                         b.TENBM,
                         b.THUTU
                    FROM DM_BIEUMAU b
                   WHERE     b.ISPRINT = 1
                         AND b.ACTIVE = 1
                         AND b.ISXLHC = 1
                         AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                              OR (    vMaGiaiDoan = 2
                                  AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                              OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                              OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                ORDER BY b.THUTU;
        ELSIF vLoaiAn = 10
        THEN
            OPEN curReturn FOR
                  SELECT b.ID,
                         b.MABM,
                         b.DUONGDAN,
                         b.TENBM,
                         b.THUTU
                    FROM DM_BIEUMAU b
                         INNER JOIN (SELECT DISTINCT BIEUMAUID
                                       FROM THA_FILE
                                      WHERE BIANID = vDonID) f
                             ON f.BIEUMAUID = b.ID
                   WHERE     b.ISPRINT = 1
                         AND b.ACTIVE = 1
                         AND b.ISTHA = 1
                         AND (   (vMaGiaiDoan = 1 AND b.ISHOSO = 1)
                              OR (    vMaGiaiDoan = 2
                                  AND (b.ISHOSO = 1 OR b.ISSOTHAM = 1))
                              OR (vMaGiaiDoan = 3 AND b.ISPHUCTHAM = 1)
                              OR (vMaGiaiDoan = 4 AND b.ISGDTTT = 1))
                ORDER BY b.THUTU;
        END IF;
    END ADS_FILE_GETBYDON;

    PROCEDURE BAN_AN_ST_ADD_BIEUMAU_TONGDAT (vLoaiAn       IN NUMBER,
                                             vToaAnID      IN NUMBER,
                                             vDonID        IN NUMBER,
                                             vMaGiaiDoan   IN NUMBER,
                                             vLoaiFile     IN NUMBER,
                                             vNguoiTao     IN VARCHAR2)
    IS
    BEGIN
        DECLARE
            vRecordCount   NUMBER;
        BEGIN
            IF vLoaiAn = 2
            THEN
                -- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
                SELECT COUNT (*)
                  INTO vRecordCount
                  FROM ADS_FILE
                 WHERE     DONID = vDonID
                       AND TOAANID = vToaAnID
                       AND BIEUMAUID = 230;

                -- Nếu không tồn tại bản ghi, thực hiện chèn
                IF vRecordCount = 0
                THEN
                    INSERT INTO ADS_FILE (ID,
                                          TOAANID,
                                          NAM,
                                          DONID,
                                          MAGIAIDOAN,
                                          BIEUMAUID,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO)
                         VALUES (ADS_FILE_SEQ.NEXTVAL,
                                 vToaAnID,
                                 TO_CHAR (SYSDATE, 'YYYY'),
                                 vDonID,
                                 vMaGiaiDoan,
                                 230,
                                 vLoaiFile,
                                 vNguoiTao,
                                 TRUNC (SYSDATE));
                END IF;
            ELSIF vLoaiAn = 3
            THEN
                -- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
                SELECT COUNT (*)
                  INTO vRecordCount
                  FROM AHN_FILE
                 WHERE     DONID = vDonID
                       AND TOAANID = vToaAnID
                       AND BIEUMAUID = 230;

                -- Nếu không tồn tại bản ghi, thực hiện chèn
                IF vRecordCount = 0
                THEN
                    INSERT INTO AHN_FILE (ID,
                                          TOAANID,
                                          NAM,
                                          DONID,
                                          MAGIAIDOAN,
                                          BIEUMAUID,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO)
                         VALUES (AHN_FILE_SEQ.NEXTVAL,
                                 vToaAnID,
                                 TO_CHAR (SYSDATE, 'YYYY'),
                                 vDonID,
                                 vMaGiaiDoan,
                                 230,
                                 vLoaiFile,
                                 vNguoiTao,
                                 TRUNC (SYSDATE));
                END IF;
            ELSIF vLoaiAn = 4
            THEN
                -- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
                SELECT COUNT (*)
                  INTO vRecordCount
                  FROM AKT_FILE
                 WHERE     DONID = vDonID
                       AND TOAANID = vToaAnID
                       AND BIEUMAUID = 230;

                -- Nếu không tồn tại bản ghi, thực hiện chèn
                IF vRecordCount = 0
                THEN
                    INSERT INTO AKT_FILE (ID,
                                          TOAANID,
                                          NAM,
                                          DONID,
                                          MAGIAIDOAN,
                                          BIEUMAUID,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO)
                         VALUES (AKT_FILE_SEQ.NEXTVAL,
                                 vToaAnID,
                                 TO_CHAR (SYSDATE, 'YYYY'),
                                 vDonID,
                                 vMaGiaiDoan,
                                 230,
                                 vLoaiFile,
                                 vNguoiTao,
                                 TRUNC (SYSDATE));
                END IF;
            ELSIF vLoaiAn = 5
            THEN
                -- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
                SELECT COUNT (*)
                  INTO vRecordCount
                  FROM ALD_FILE
                 WHERE     DONID = vDonID
                       AND TOAANID = vToaAnID
                       AND BIEUMAUID = 230;

                -- Nếu không tồn tại bản ghi, thực hiện chèn
                IF vRecordCount = 0
                THEN
                    INSERT INTO ALD_FILE (ID,
                                          TOAANID,
                                          NAM,
                                          DONID,
                                          MAGIAIDOAN,
                                          BIEUMAUID,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO,
                                          TOA_GIAIQUYET_ID)
                         VALUES (ALD_FILE_SEQ.NEXTVAL,
                                 vToaAnID,
                                 TO_CHAR (SYSDATE, 'YYYY'),
                                 vDonID,
                                 vMaGiaiDoan,
                                 230,
                                 vLoaiFile,
                                 vNguoiTao,
                                 TRUNC (SYSDATE),
                                 vToaAnID);
                END IF;
            ELSIF vLoaiAn = 6
            THEN
                -- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
                SELECT COUNT (*)
                  INTO vRecordCount
                  FROM AHC_FILE
                 WHERE     DONID = vDonID
                       AND TOAANID = vToaAnID
                       AND BIEUMAUID = 230;

                -- Nếu không tồn tại bản ghi, thực hiện chèn
                IF vRecordCount = 0
                THEN
                    INSERT INTO AHC_FILE (ID,
                                          TOAANID,
                                          NAM,
                                          DONID,
                                          MAGIAIDOAN,
                                          BIEUMAUID,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO,
                                          TOA_GIAIQUYET_ID)
                         VALUES (AHC_FILE_SEQ.NEXTVAL,
                                 vToaAnID,
                                 TO_CHAR (SYSDATE, 'YYYY'),
                                 vDonID,
                                 vMaGiaiDoan,
                                 230,
                                 vLoaiFile,
                                 vNguoiTao,
                                 TRUNC (SYSDATE),
                                 vToaAnID);
                END IF;
            ELSIF vLoaiAn = 7
            THEN
                -- Kiểm tra xem có bản ghi nào tồn tại với các giá trị tương ứng
                SELECT COUNT (*)
                  INTO vRecordCount
                  FROM APS_FILE
                 WHERE     DONID = vDonID
                       AND TOAANID = vToaAnID
                       AND BIEUMAUID = 230;

                -- Nếu không tồn tại bản ghi, thực hiện chèn
                IF vRecordCount = 0
                THEN
                    INSERT INTO APS_FILE (ID,
                                          TOAANID,
                                          NAM,
                                          DONID,
                                          MAGIAIDOAN,
                                          BIEUMAUID,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO)
                         VALUES (APS_FILE_SEQ.NEXTVAL,
                                 vToaAnID,
                                 TO_CHAR (SYSDATE, 'YYYY'),
                                 vDonID,
                                 vMaGiaiDoan,
                                 230,
                                 vLoaiFile,
                                 vNguoiTao,
                                 TRUNC (SYSDATE));
                END IF;
            END IF;
        END;
    END BAN_AN_ST_ADD_BIEUMAU_TONGDAT;

    PROCEDURE GAIDOAN_DELETE_V2 (V_LOAI_AN      IN VARCHAR2,
                                 V_VUAN_DONID   IN NUMBER,
                                 V_MAGIAIDOAN   IN NUMBER)
    IS
    BEGIN
        IF (V_LOAI_AN = '1')
        THEN
            DELETE FROM AHS_VUAN_GIAIDOAN
                  WHERE VUANID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '2')
        THEN
            DELETE FROM ADS_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '3')
        THEN
            DELETE FROM AHN_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '4')
        THEN
            DELETE FROM AKT_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '5')
        THEN
            DELETE FROM ALD_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '6')
        THEN
            DELETE FROM AHC_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        ELSIF (V_LOAI_AN = '8')
        THEN
            DELETE FROM XLHC_DON_GIAIDOAN
                  WHERE DONID = V_VUAN_DONID AND MAGIAIDOAN = V_MAGIAIDOAN;
        END IF;
    END;

--    1. Người tạo/sửa: VNPT-Nguyễn Trung Kiên
--    2. Mô tả: bổ sung thêm logs database khi insert fail
--    3. Thời gian tạo/sửa: 27-09-2025
    PROCEDURE GAIDOAN_IN_UP_V2 (V_LOAI_AN         IN VARCHAR2,
                                V_VUAN_DONID      IN NUMBER,
                                V_MAGIAIDOAN      IN NUMBER,
                                V_TOAANID         IN NUMBER,
                                V_TOAPHUCTHAMID   IN NUMBER,
                                V_TOACAPCAOID     IN NUMBER,
                                V_TOANTOICAOID    IN NUMBER,
                                V_PHONGBANID      IN NUMBER)
    IS
        V_COUNT_CHECK   NUMBER;
        V_TOAANID_ST    NUMBER;
        v_tracedata     VARCHAR2 (1024);
        v_output        VARCHAR2 (512);
    BEGIN
        v_tracedata :=
               '('
            || 'V_LOAI_AN => '
            || V_LOAI_AN
            || ','
            || 'V_VUAN_DONID => '
            || V_VUAN_DONID
            || ','
            || 'V_MAGIAIDOAN => '
            || V_MAGIAIDOAN
            || ','
            || 'V_TOAANID => '
            || V_TOAANID
            || ','
            || 'V_TOAPHUCTHAMID => '
            || V_TOAPHUCTHAMID
            || ','
            || ' );';

        --    PKG_TRACELOG.SP_INSERT_LOG_INFO(
        --              p_functionname => 'PKG_STPT.GAIDOAN_IN_UP',
        --              p_description => 'START CALL',
        --              p_notes => v_tracedata
        --          );

        -- DM_LOAIAN
        --1 hình sự
        IF (V_LOAI_AN = '1')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHS_VUAN_GIAIDOAN GD
             WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID) -- UPDATE toa_gq_id
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                         SELECT TOAANID
                           INTO V_TOAANID_ST
                           FROM AHS_VUAN_GIAIDOAN GD
                          WHERE GD.VUANID = V_VUAN_DONID AND GD.MAGIAIDOAN = 2
                    FETCH FIRST 1 ROWS ONLY;

                    --------
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- UPDATE toa_pt_gq_id
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHS_VUAN_GIAIDOAN (VUANID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- UPDATE toa_pt_gq_id
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                END IF;
            END IF;
        --2 dân sự
        ELSIF (V_LOAI_AN = '2')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ADS_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN; --AND GD.TOAANID=V_TOAANID;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --              SELECT TOAANID INTO V_TOAANID_ST FROM ADS_DON_GIAIDOAN GD
                    --                  WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --                  FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO ADS_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE);
                --toancau-anhnt thêm insert cho ptqdk
                END IF;
            END IF;
        --3 hôn nhân gia đình
        ELSIF (V_LOAI_AN = '3')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHN_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                         SELECT TOAANID
                           INTO V_TOAANID_ST
                           FROM AHN_DON_GIAIDOAN GD
                          WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = 2
                    FETCH FIRST 1 ROWS ONLY;

                    ---------
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID_ST);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHN_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID_ST);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        ----4 kinh tế
        ELSIF (V_LOAI_AN = '4')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AKT_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID) -- INSERT toa_gq_id
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AKT_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID) -- INSERT toa_gq_id
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AKT_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID) -- INSERT toa_gq_id
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        --5 lao động
        ELSIF (V_LOAI_AN = '5')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM ALD_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO ALD_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                         SELECT TOAANID
                           INTO V_TOAANID_ST
                           FROM ALD_DON_GIAIDOAN GD
                          WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = 2
                    FETCH FIRST 1 ROWS ONLY;

                    ---------
                    INSERT INTO ALD_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO ALD_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        --6 hành chính
        ELSIF (V_LOAI_AN = '6')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        ELSIF (V_LOAI_AN = '6')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM AHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO AHC_DON_GIAIDOAN (DONID,
                                                  MAGIAIDOAN,
                                                  TOAANID,
                                                  TOAPHUCTHAMID,
                                                  NGAYTAO,
                                                  NGAYSUA,
                                                  TOA_GIAIQUYET_ID,
                                                  TOA_PHUCTHAM_GIAIQUYET_ID)
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID);
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        --biện pháp xử lý hành chính 08
        ELSIF (V_LOAI_AN = '8')
        THEN
            SELECT COUNT (*)
              INTO V_COUNT_CHECK
              FROM XLHC_DON_GIAIDOAN GD
             WHERE GD.DONID = V_VUAN_DONID AND GD.MAGIAIDOAN = V_MAGIAIDOAN;

            -----
            IF (V_COUNT_CHECK = 0)
            THEN
                IF (V_MAGIAIDOAN = 2)
                THEN
                    INSERT INTO XLHC_DON_GIAIDOAN (DONID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                         VALUES (V_VUAN_DONID,
                                 2,
                                 V_TOAANID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID); -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                ELSIF (V_MAGIAIDOAN = 3)
                THEN
                    --SELECT TOAANID INTO V_TOAANID_ST FROM AHC_DON_GIAIDOAN GD
                    --WHERE GD.DONID=V_VUAN_DONID AND GD.MAGIAIDOAN=2
                    --FETCH FIRST 1 ROWS ONLY;
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO XLHC_DON_GIAIDOAN (DONID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                         VALUES (V_VUAN_DONID,
                                 3,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID); -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                ELSIF (V_MAGIAIDOAN = 7)
                THEN
                    V_TOAANID_ST := V_TOAANID;

                    ---------
                    INSERT INTO XLHC_DON_GIAIDOAN (DONID,
                                                   MAGIAIDOAN,
                                                   TOAANID,
                                                   TOAPHUCTHAMID,
                                                   NGAYTAO,
                                                   NGAYSUA,
                                                   TOA_GIAIQUYET_ID,
                                                   TOA_PHUCTHAM_GIAIQUYET_ID) -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                         VALUES (V_VUAN_DONID,
                                 7,
                                 V_TOAANID_ST,
                                 V_TOAPHUCTHAMID,
                                 SYSDATE,
                                 SYSDATE,
                                 V_TOAANID,
                                 V_TOAPHUCTHAMID); -- VNPT- Đinh Hoàng Sơn - thêm TOA_GIAIQUYET_ID, TOA_PHUCTHAM_GIAIQUYET_ID - 17-9-2025 08:00
                --toancau-anhnt thêm insert cho phúc thẩm quyết đinh khác
                END IF;
            END IF;
        ----------
        --phá sản 07
        --án GDTTT 09
        --AN_THA 10
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            -- Rollback in case of any exception
            ROLLBACK;

            v_output :=
                   'Finish procedure Due to Exception: Error:'
                || SQLCODE
                || ','
                || SQLERRM;
            PKG_TRACELOG.SP_INSERT_LOG_ERROR (
                p_functionname   => 'PKG_STPT.GAIDOAN_IN_UP',
                p_description    => v_output,
                p_notes          => v_tracedata);

            -- Re-raise the exception
            RAISE;
    END;

    PROCEDURE GET_BY_DONID_BICANDAUVU (VDONID        IN     NUMBER,
                                       VBICANDAUVU   IN     NUMBER,
                                       curReturn        OUT SYS_REFCURSOR)
    IS
    BEGIN
        -- Mở cursor và truy vấn dữ liệu
        --- VNPT --Lê Bá Thọ 09-10-2025 08:30 
        OPEN curReturn FOR
            SELECT D.*
              FROM XLHC_DUONGSU D
             WHERE D.DONID = VDONID AND D.BICANDAUVU = VBICANDAUVU AND (
        D.LOAIDOITUONG IS NULL 
        OR (D.LOAIDOITUONG = 1))
        AND D.LOAIDOITUONG != 2;
    EXCEPTION
        WHEN OTHERS
        THEN
            -- Xử lý lỗi nếu có
            RAISE;
    END GET_BY_DONID_BICANDAUVU;

    PROCEDURE SAVE_DUONGSU (VDONID              IN     NUMBER,
                            VMABICAN            IN     VARCHAR2,
                            VBICANDAUVU         IN     NUMBER,
                            VHOTEN              IN     NVARCHAR2,
                            VTENKHAC            IN     NVARCHAR2,
                            VSODINHDANHCANHAN   IN     VARCHAR2,
                            VHOCHIEU            IN     VARCHAR2,
                            VGIOITINH           IN     NUMBER,
                            VNGAYSINH           IN     DATE,
                            VTUOI               IN     NUMBER,
                            VTAMTRUTINHID       IN     NUMBER,
                            VTAMTRU             IN     NUMBER,
                            VTAMTRUCHITIET      IN     NVARCHAR2,
                            VHKTTTINHID         IN     NUMBER,
                            VHKTT               IN     NUMBER,
                            VKHTTCHITIET        IN     NVARCHAR2,
                            VDANTOCID           IN     NUMBER,
                            VTONGIAOID          IN     NUMBER,
                            VTRINHDOVANHOAID    IN     NUMBER,
                            VNGHENGHIEPID       IN     NUMBER,
                            VHOTENBO            IN     NVARCHAR2,
                            VNAMSINHBO          IN     NUMBER,
                            VHOTENME            IN     NVARCHAR2,
                            VNAMSINHME          IN     NUMBER,
                            VISTREVITHANHNIEN   IN     NUMBER,
                            VTREMOCOI           IN     NUMBER,
                            VTREBOHOC           IN     NUMBER,
                            VTRELANGTHANG       IN     NUMBER,
                            VBOMELYHON          IN     NUMBER,
                            VCONGUOIXUIGIUC     IN     NUMBER,
                            VNGHIENHUT          IN     NUMBER,
                            VTAIPHAM            IN     NUMBER,
                            VTIENAN             IN     NUMBER,
                            VTIENSU             IN     NUMBER,
                            VTOA_GIAIQUYET_ID   IN     NUMBER,--- VNPT --Lê Bá Thọ 09-10-2025 08:30 lưu toà nào giải tạo đương sự này 
                            VNGAYSUA            IN     DATE,
                            VNGUOISUA           IN     VARCHAR2,
                            VNGAYTAO            IN     DATE,
                            VNGUOITAO           IN     VARCHAR2,
                            VACTION             IN     VARCHAR2,
                            VRESULT                OUT NUMBER)
    IS
        v_count     NUMBER;
        v_mabican   VARCHAR2 (50);
    BEGIN
        VRESULT := 0;

        -- Xử lý tùy theo hành động INSERT hay UPDATE
        IF VACTION = 'INSERT'
        THEN
            -- Thêm mới đương sự
            INSERT INTO XLHC_DUONGSU (DONID,
                                      MABICAN,
                                      BICANDAUVU,
                                      HOTEN,
                                      TENKHAC,
                                      SODINHDANHCANHAN,
                                      HOCHIEU,
                                      GIOITINH,
                                      NGAYSINH,
                                      TUOI,
                                      TAMTRUTINHID,
                                      TAMTRU,
                                      TAMTRUCHITIET,
                                      HKTTTINHID,
                                      HKTT,
                                      KHTTCHITIET,
                                      DANTOCID,
                                      TONGIAOID,
                                      TRINHDOVANHOAID,
                                      NGHENGHIEPID,
                                      HOTENBO,
                                      NAMSINHBO,
                                      HOTENME,
                                      NAMSINHME,
                                      ISTREVITHANHNIEN,
                                      TREMOCOI,
                                      TREBOHOC,
                                      TRELANGTHANG,
                                      BOMELYHON,
                                      CONGUOIXUIGIUC,
                                      NGHIENHUT,
                                      TAIPHAM,
                                      TIENAN,
                                      TIENSU,
                                      TOA_GIAIQUYET_ID,--- VNPT --Lê Bá Thọ 09-10-2025 08:30 lưu toà nào giải tạo đương sự này 
                                      LOAIDOITUONG, --- VNPT --Lê Bá Thọ 09-10-2025 08:30 để lưu đương sự là người bị đề nghị 
                                      NGAYTAO,  
                                      NGUOITAO)
                 VALUES (VDONID,
                         v_mabican,
                         VBICANDAUVU,
                         VHOTEN,
                         VTENKHAC,
                         VSODINHDANHCANHAN,
                         VHOCHIEU,
                         VGIOITINH,
                         VNGAYSINH,
                         VTUOI,
                         VTAMTRUTINHID,
                         VTAMTRU,
                         VTAMTRUCHITIET,
                         VHKTTTINHID,
                         VHKTT,
                         VKHTTCHITIET,
                         VDANTOCID,
                         VTONGIAOID,
                         VTRINHDOVANHOAID,
                         VNGHENGHIEPID,
                         VHOTENBO,
                         VNAMSINHBO,
                         VHOTENME,
                         VNAMSINHME,
                         VISTREVITHANHNIEN,
                         VTREMOCOI,
                         VTREBOHOC,
                         VTRELANGTHANG,
                         VBOMELYHON,
                         VCONGUOIXUIGIUC,
                         VNGHIENHUT,
                         VTAIPHAM,
                         VTIENAN,
                         VTIENSU,
                         VTOA_GIAIQUYET_ID,--- VNPT --Lê Bá Thọ 09-10-2025 08:30 lưu toà nào giải tạo đương sự này 
                         1, --- VNPT --Lê Bá Thọ 09-10-2025 08:30 để lưu đương sự là người bị đề nghị 
                         VNGAYTAO,
                         VNGUOITAO);

            VRESULT := 1;
        ELSIF VACTION = 'UPDATE'
        THEN
            -- Cập nhật thông tin đương sự hiện có
            UPDATE XLHC_DUONGSU
               SET HOTEN = VHOTEN,
                   TENKHAC = VTENKHAC,
                   SODINHDANHCANHAN = VSODINHDANHCANHAN,
                   HOCHIEU = VHOCHIEU,
                   GIOITINH = VGIOITINH,
                   NGAYSINH = VNGAYSINH,
                   TUOI = VTUOI,
                   TAMTRUTINHID = VTAMTRUTINHID,
                   TAMTRU = VTAMTRU,
                   TAMTRUCHITIET = VTAMTRUCHITIET,
                   HKTTTINHID = VHKTTTINHID,
                   HKTT = VHKTT,
                   KHTTCHITIET = VKHTTCHITIET,
                   DANTOCID = VDANTOCID,
                   TONGIAOID = VTONGIAOID,
                   TRINHDOVANHOAID = VTRINHDOVANHOAID,
                   NGHENGHIEPID = VNGHENGHIEPID,
                   HOTENBO = VHOTENBO,
                   NAMSINHBO = VNAMSINHBO,
                   HOTENME = VHOTENME,
                   NAMSINHME = VNAMSINHME,
                   ISTREVITHANHNIEN = VISTREVITHANHNIEN,
                   TREMOCOI = VTREMOCOI,
                   TREBOHOC = VTREBOHOC,
                   TRELANGTHANG = VTRELANGTHANG,
                   BOMELYHON = VBOMELYHON,
                   CONGUOIXUIGIUC = VCONGUOIXUIGIUC,
                   NGHIENHUT = VNGHIENHUT,
                   TAIPHAM = VTAIPHAM,
                   TIENAN = VTIENAN,
                   TIENSU = VTIENSU,
                   TOA_GIAIQUYET_ID = VTOA_GIAIQUYET_ID,--- VNPT --Lê Bá Thọ 09-10-2025 08:30 Update 
                   NGAYSUA = VNGAYSUA,
                   NGUOISUA = VNGUOISUA
             WHERE DONID = VDONID AND BICANDAUVU = VBICANDAUVU AND LOAIDOITUONG = 1;

            IF SQL%ROWCOUNT > 0
            THEN
                VRESULT := 1;
            END IF;
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            -- Xử lý lỗi nếu có
            ROLLBACK;
            VRESULT := 0;
            RAISE;
    END SAVE_DUONGSU;

    PROCEDURE XLHC_GIAO_NHAN_CHUNG_CU_TAI_LIEU (
        p_ID                 IN     NUMBER,
        p_DONID              IN     NUMBER,
        p_TENTAILIEU         IN     VARCHAR2,
        p_NGUONBANGIAO       IN     NUMBER,
        p_NGAYBANGIAO        IN     DATE,
        p_NGUOIBANGIAO_NEW   IN     VARCHAR2,
        p_NGUOINHANID        IN     NUMBER,
        p_NGUOITHUCHIEN      IN     VARCHAR2,
        p_OPERATION          IN     VARCHAR2,
        p_TOA_GIAIQUYET_ID   IN     NUMBER,
        p_NOIDUNG            IN     BLOB DEFAULT NULL,
        p_TENFILE            IN     VARCHAR2 DEFAULT NULL,
        p_LOAIFILE           IN     VARCHAR2 DEFAULT NULL,
        p_RESULT                OUT NUMBER)
    AS
        v_exists   NUMBER;
    BEGIN
        p_RESULT := 0;

        IF p_OPERATION = 'INSERT'
        THEN
            INSERT INTO XLHC_DON_TAILIEU (DONID,
                                          TENTAILIEU,
                                          NGUONBANGIAO,
                                          NGAYBANGIAO,
                                          NGUOIBANGIAO_NEW,
                                          NGUOINHANID,
                                          NOIDUNG,
                                          TENFILE,
                                          LOAIFILE,
                                          NGUOITAO,
                                          NGAYTAO,
                                          TOA_GIAIQUYET_ID)
                 VALUES (p_DONID,
                         p_TENTAILIEU,
                         p_NGUONBANGIAO,
                         p_NGAYBANGIAO,
                         p_NGUOIBANGIAO_NEW,
                         p_NGUOINHANID,
                         p_NOIDUNG,
                         p_TENFILE,
                         p_LOAIFILE,
                         p_NGUOITHUCHIEN,
                         SYSDATE,
                         p_TOA_GIAIQUYET_ID);

            p_RESULT := 1;
        ELSIF p_OPERATION = 'UPDATE'
        THEN
            SELECT COUNT (*)
              INTO v_exists
              FROM XLHC_DON_TAILIEU
             WHERE ID = p_ID;

            IF v_exists > 0
            THEN
                UPDATE XLHC_DON_TAILIEU
                   SET DONID = p_DONID,
                       TENTAILIEU = p_TENTAILIEU,
                       NGUONBANGIAO = p_NGUONBANGIAO,
                       NGAYBANGIAO = p_NGAYBANGIAO,
                       NGUOIBANGIAO_NEW = p_NGUOIBANGIAO_NEW,
                       NGUOINHANID = p_NGUOINHANID,
                       NGUOISUA = p_NGUOITHUCHIEN,
                       NGAYSUA = SYSDATE,
                       NOIDUNG = p_NOIDUNG,
                       TENFILE = p_TENFILE,
                       LOAIFILE = p_LOAIFILE
                 WHERE ID = p_ID;

                p_RESULT := 1;
            END IF;
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            p_RESULT := 0;
    END XLHC_GIAO_NHAN_CHUNG_CU_TAI_LIEU;

    PROCEDURE XLHC_DON_BGTL_GETLIST_V2 (vDonID      IN     NUMBER,
                                        CurReturn      OUT SYS_REFCURSOR)
    AS
        vGroupChucVuID   NUMBER;
    BEGIN
        SELECT a.ID
          INTO vGroupChucVuID
          FROM DM_DATAGROUP a
         WHERE a.MA = 'CHUCVU';

        OPEN CurReturn FOR
              SELECT b.ID,
                     b.DONID,
                     b.NGAYBANGIAO,
                     CASE
                         WHEN d.ChucVu IS NOT NULL
                         THEN
                             (e.HoTen || ' - ' || d.ChucVu)
                         WHEN d.ChucVu IS NULL
                         THEN
                             e.HoTen
                     END
                         AS NguoiNhan,
                     b.NGUOINHANID,
                     b.LOAIDOITUONG,
                     b.TENFILE,
                     b.TENTAILIEU,
                     b.TOA_GIAIQUYET_ID,
                     DECODE (b.NGUONBANGIAO,
                             1, 'Đơn vị đề nghị',
                             2, 'Người bị đề nghị',
                             3, 'Khác',
                             '')
                         AS NGUONBANGIAO,
                     b.NGUOIBANGIAO_NEW,
                     DECODE (b.LoaiDoiTuong,
                             0, u'\0110\01b0\01a1ng s\1ef1',
                             1, u'Ng\01b0\1eddi tham gia t\1ed1 t\1ee5ng',
                             '')
                         TenLoaiDoiTuong,
                     DECODE (b.LoaiDoiTuong,  0, ds.ID,  1, tt.ID,  0)
                         NGUOIBANGIAOID,
                     DECODE (b.LoaiDoiTuong,  0, ds.HoTen,  1, tt.HOTEN,  '')
                         NGUOIBANGIAO
                FROM XLHC_DON_TAILIEU b
                     LEFT JOIN (SELECT ID, HoTen, ChucVuID FROM DM_CanBo) e
                         ON b.NguoiNhanID = e.ID
                     LEFT JOIN (SELECT ID, Ten ChucVu
                                  FROM DM_DataItem
                                 WHERE GroupID = vGroupChucVuID) d
                         ON e.ChucVuID = d.ID
                     LEFT JOIN (SELECT a.ID, a.HOTEN
                                  FROM XLHC_DUONGSU a) ds
                         ON ds.ID = b.NGUOIBANGIAO
                     LEFT JOIN (SELECT a.ID, a.HOTEN
                                  FROM XLHC_DON_THAMGIATOTUNG a) tt
                         ON tt.ID = b.NGUOIBANGIAO
               WHERE b.DONID = vDonID
            ORDER BY b.NGAYBANGIAO DESC;
    END XLHC_DON_BGTL_GETLIST_V2;
END PKG_STPT;