--------------------------------------------------------
--  DDL for Package Body PKG_STPT_AHS_GS2
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_AHS_GS2" AS

    FUNCTION AHS_CHECK_NHAN_AN (
        V_VUANID    NUMBER,
        V_TOAANID   NUMBER,
        V_MESSAGE   VARCHAR2
    ) RETURN VARCHAR2 AS

        L_COUNT_BICAO_DANG_XU_LY   NUMBER;
        L_COUNT_BICAO              NUMBER;
        L_COUNT_QDVA_DANG_XU_LY    NUMBER;
        L_MESSAGE                  VARCHAR2(2000);
        L_CHUYENNHANAN_ID          NUMBER;
        L_MAP_VUANID_NEW           NUMBER;
        L_TOANHANID                NUMBER;
        L_ID_AN_PTTDC              NUMBER;
    BEGIN
        BEGIN
            --Lấy lần chuyển án cuối cùng
            SELECT
                ID,
                MAP_VUANID_NEW,
                TOANHANID
            INTO
                L_CHUYENNHANAN_ID,
                L_MAP_VUANID_NEW,
                L_TOANHANID
            FROM
                AHS_CHUYEN_NHAN_AN
            WHERE
                VUANID = V_VUANID
                AND TRANGTHAI = 1
            ORDER BY
                ID DESC
            FETCH FIRST 1 ROW ONLY;
            --Nếu không có sẽ nhảy xuống exception dưới cùng return '';




            --Lấy MESSAGE trả lại theo toà án

            SELECT
                'Án đã được '
                || TA.MA_TEN
                || ' nhận. '
                || V_MESSAGE
            INTO L_MESSAGE
            FROM
                DM_TOAAN TA
            WHERE
                TA.ID = L_TOANHANID;

            IF V_TOAANID > 0 THEN -- Nếu toà án truyền vào > 0
                IF L_MAP_VUANID_NEW > 0 THEN -- Khi nhận án tạo án mới- TH1: PT => ST; TH2: ST => PTTDC
                    BEGIN
                        -- Check xem vụ án chuyển lại có thuộc án TĐC hay không
                        SELECT
                            ID
                        INTO L_ID_AN_PTTDC
                        FROM
                            AHS_CHUYEN_NHAN_AN
                        WHERE
                            VUANID = L_MAP_VUANID_NEW
                            AND TRANGTHAI = 1
                            AND ID > L_CHUYENNHANAN_ID;
                        -- Check xem vụ án chuyển lại có thuộc án TĐC hay không

                        SELECT
                            ID
                        INTO L_ID_AN_PTTDC
                        FROM
                            AHS_VUAN
                        WHERE
                            ID = L_MAP_VUANID_NEW
                            AND MAGIAIDOAN = 7;

                    EXCEPTION
                        --Nếu không sẽ trả lại. TH án là PT => ST
                        WHEN NO_DATA_FOUND THEN
                            RETURN L_MESSAGE;
                    END;
                    -- TH là án PTTDC => ST

                    IF L_ID_AN_PTTDC > 0 THEN
                        RETURN NULL;
--                    --Đếm số qd vụ án đang xử lý
--
--                        SELECT
--                            COUNT(*)
--                        INTO L_COUNT_QDVA_DANG_XU_LY
--                        FROM
--                            AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST   MAPKCKN
--                            INNER JOIN AHS_SOTHAM_KHANGCAO                KC ON KC.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                 AND MAPKCKN.IS_KC = 1
--                                                                 AND NVL(KC.IS_KC_BICANBICAO, 0) = 0
--                            INNER JOIN AHS_SOTHAM_KHANGNGHI               KN ON KN.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                  AND NVL(MAPKCKN.IS_KC, 0) = 0
--                                                                  AND NVL(KN.IS_KN_BICANBICAO, 0) = 0
--                        WHERE
--                            MAPKCKN.VUANST_ID = V_VUANID
--                            AND NOT EXISTS (
--                                SELECT
--                                    'x'
--                                FROM
--                                    AHS_CHUYEN_NHAN_AN
--                                WHERE
--                                    VUANID = L_ID_AN_PTTDC
--                                    AND TRANG_THAI_ID = 1
--                                    AND TOANHANID = V_TOAANID
--                            );
--                            
--                            --Nếu có thì trả lại luôn vì qđ vụ án đang xử lý thì không được sửa
--
--                        IF L_COUNT_QDVA_DANG_XU_LY > 0 THEN
--                            RETURN L_MESSAGE;
--                        ELSE
--                            --Đếm số lượng bị cáo
--
--                            SELECT
--                                COUNT(ID)
--                            INTO L_COUNT_BICAO
--                            FROM
--                                AHS_BICANBICAO
--                            WHERE
--                                VUANID = V_VUANID;
--                            --Đếm số lượng bị cáo đang xử lý
--
--                            SELECT
--                                COUNT(DISTINCT(R.BICANID))
--                            INTO L_COUNT_BICAO_DANG_XU_LY
--                            FROM
--                                (
--                                    SELECT
--                                        QD.BICANID
--                                    FROM
--                                        AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST   MAPKCKN
--                                        INNER JOIN AHS_SOTHAM_KHANGCAO                KC ON KC.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                             AND MAPKCKN.IS_KC = 1
--                                                                             AND KC.LOAIKHANGCAO = 3
--                                                                             AND KC.LOAIKHANGCAO = 2
--                                        INNER JOIN AHS_SOTHAM_QUYETDINH_BICAN         QD ON QD.ID = KC.SOQDBA
--                                    WHERE
--                                        MAPKCKN.VUANST_ID = V_VUANID
--                                        AND NOT EXISTS (
--                                            SELECT
--                                                'x'
--                                            FROM
--                                                AHS_CHUYEN_NHAN_AN
--                                            WHERE
--                                                VUANID = MAPKCKN.VUANPT_ID
--                                                AND TRANG_THAI_ID = 1
--                                                AND TOANHANID = V_TOAANID
--                                        )
--                                    UNION
--                                    SELECT
--                                        QD.BICANID
--                                    FROM
--                                        AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST   MAPKCKN
--                                        INNER JOIN AHS_SOTHAM_KHANGNGHI               KN ON KN.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                              AND NVL(MAPKCKN.IS_KC, 0) = 0
--                                                                              AND KN.LOAIKN = 3
--                                                                              AND KN.LOAIKN = 2
--                                        INNER JOIN AHS_SOTHAM_QUYETDINH_BICAN         QD ON QD.ID = KN.BANANID
--                                    WHERE
--                                        MAPKCKN.VUANST_ID = V_VUANID
--                                        AND NOT EXISTS (
--                                            SELECT
--                                                'x'
--                                            FROM
--                                                AHS_CHUYEN_NHAN_AN
--                                            WHERE
--                                                VUANID = MAPKCKN.VUANPT_ID
--                                                AND TRANG_THAI_ID = 1
--                                                AND TOANHANID = V_TOAANID
--                                        )
--                                ) R;
--                            --Nếu số lượng = thì st ko thể sửa
--
--                            IF L_COUNT_BICAO_DANG_XU_LY = L_COUNT_BICAO THEN
--                                RETURN L_MESSAGE;
--                            ELSE
--                                RETURN '';
--                            END IF;
--                        END IF;
                    ELSE
                        RETURN L_MESSAGE;
                    END IF;
                ELSIF L_TOANHANID != V_TOAANID THEN
                    RETURN L_MESSAGE;
                END IF;
            ELSE
                -- Nếu toà án truyền vào = 0 thì trả lại
                RETURN L_MESSAGE;
            END IF;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT
                        ID,
                        MAP_VUANID_NEW,
                        TOANHANID
                    INTO
                        L_CHUYENNHANAN_ID,
                        L_MAP_VUANID_NEW,
                        L_TOANHANID
                    FROM
                        AHS_CHUYEN_NHAN_AN
                    WHERE
                        VUANID = V_VUANID
                        AND NVL(TRANGTHAI, 0) = 0
                    ORDER BY
                        ID
                    FETCH FIRST 1 ROW ONLY;

                    RETURN 'Án đã được chuyển.' || V_MESSAGE;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RETURN '';
                END;
        END;

        RETURN '';
    END AHS_CHECK_NHAN_AN;

    FUNCTION CHECK_CHUYEN_AN (
        V_VUANID    NUMBER,
        V_TOAANID   NUMBER
    ) RETURN NUMBER AS

        L_COUNT_BICAO_DANG_XU_LY   NUMBER;
        L_COUNT_BICAO              NUMBER;
        L_COUNT_QDVA_DANG_XU_LY    NUMBER;
        L_MESSAGE                  VARCHAR2(2000);
        L_CHUYENNHANAN_ID          NUMBER;
        L_MAP_VUANID_NEW           NUMBER;
        L_TOANHANID                NUMBER;
        L_ID_AN_PTTDC              NUMBER;
    BEGIN
        BEGIN
            --
            SELECT
                ID,
                MAP_VUANID_NEW,
                TOANHANID
            INTO
                L_CHUYENNHANAN_ID,
                L_MAP_VUANID_NEW,
                L_TOANHANID
            FROM
                AHS_CHUYEN_NHAN_AN
            WHERE
                VUANID = V_VUANID
                AND TRANGTHAI != 1
            ORDER BY
                ID DESC
            FETCH FIRST 1 ROW ONLY;

            IF L_CHUYENNHANAN_ID > 0 THEN
                RETURN 0;
            END IF;
            --Lấy lần chuyển án cuối cùng
            SELECT
                ID,
                MAP_VUANID_NEW,
                TOANHANID
            INTO
                L_CHUYENNHANAN_ID,
                L_MAP_VUANID_NEW,
                L_TOANHANID
            FROM
                AHS_CHUYEN_NHAN_AN
            WHERE
                VUANID = V_VUANID
                AND TRANGTHAI = 1
            ORDER BY
                ID DESC
            FETCH FIRST 1 ROW ONLY;
            --Nếu không có sẽ nhảy xuống exception dưới cùng return '';

            IF V_TOAANID > 0 THEN -- Nếu toà án truyền vào > 0
                IF L_MAP_VUANID_NEW > 0 THEN -- Khi nhận án tạo án mới- TH1: PT => ST; TH2: ST => PTTDC
                    BEGIN
                        -- Check xem vụ án chuyển lại có thuộc án TĐC hay không
                        SELECT
                            ID
                        INTO L_ID_AN_PTTDC
                        FROM
                            AHS_CHUYEN_NHAN_AN
                        WHERE
                            VUANID = L_MAP_VUANID_NEW
                            AND TRANGTHAI = 1
                            AND ID > L_CHUYENNHANAN_ID;

                        SELECT
                            ID
                        INTO L_ID_AN_PTTDC
                        FROM
                            AHS_VUAN
                        WHERE
                            ID = L_MAP_VUANID_NEW
                            AND MAGIAIDOAN = 7;

                    EXCEPTION
                        --Nếu không sẽ trả lại. TH án là PT => ST
                        WHEN NO_DATA_FOUND THEN
                            RETURN 0;
                    END;
                    -- TH là án PTTDC => ST

                    IF L_ID_AN_PTTDC > 0 THEN
                        RETURN 0;
                    --Đếm số qd vụ án đang xử lý

--                        SELECT
--                            COUNT(*)
--                        INTO L_COUNT_QDVA_DANG_XU_LY
--                        FROM
--                            AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST   MAPKCKN
--                            INNER JOIN AHS_SOTHAM_KHANGCAO                KC ON KC.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                 AND MAPKCKN.IS_KC = 1
--                                                                 AND KC.LOAIKHANGCAO = 2
--                            INNER JOIN AHS_SOTHAM_KHANGNGHI               KN ON KN.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                  AND NVL(MAPKCKN.IS_KC, 0) = 0
--                                                                  AND KN.LOAIKN =2
--                        WHERE
--                            MAPKCKN.VUANST_ID = V_VUANID
--                            AND NOT EXISTS (
--                                SELECT
--                                    'x'
--                                FROM
--                                    AHS_CHUYEN_NHAN_AN
--                                WHERE
--                                    VUANID = L_ID_AN_PTTDC
--                                    AND TRANG_THAI_ID = 1
--                                    AND TOANHANID = V_TOAANID
--                            );
--                            
--                            --Nếu có thì trả lại luôn vì qđ vụ án đang xử lý thì không được sửa
--
--                        IF L_COUNT_QDVA_DANG_XU_LY > 0 THEN
--                            RETURN 0;
--                        ELSE
--                            --Đếm số lượng bị cáo
--
--                            SELECT
--                                COUNT(ID)
--                            INTO L_COUNT_BICAO
--                            FROM
--                                AHS_BICANBICAO
--                            WHERE
--                                VUANID = V_VUANID;
--                            --Đếm số lượng bị cáo đang xử lý
--
--                            SELECT
--                                COUNT(DISTINCT(R.BICANID))
--                            INTO L_COUNT_BICAO_DANG_XU_LY
--                            FROM
--                                (
--                                    SELECT
--                                        QD.BICANID
--                                    FROM
--                                        AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST   MAPKCKN
--                                        INNER JOIN AHS_SOTHAM_KHANGCAO                KC ON KC.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                             AND MAPKCKN.IS_KC = 1
--                                                                             AND KC.LOAIKHANGCAO = 3
--                                        INNER JOIN AHS_SOTHAM_QUYETDINH_BICAN         QD ON QD.ID = KC.SOQDBA
--                                    WHERE
--                                        MAPKCKN.VUANST_ID = V_VUANID
--                                        AND NOT EXISTS (
--                                            SELECT
--                                                'x'
--                                            FROM
--                                                AHS_CHUYEN_NHAN_AN
--                                            WHERE
--                                                VUANID = MAPKCKN.VUANPT_ID
--                                                AND TRANG_THAI_ID = 1
--                                                AND TOANHANID = V_TOAANID
--                                        )
--                                    UNION
--                                    SELECT
--                                        QD.BICANID
--                                    FROM
--                                        AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST   MAPKCKN
--                                        INNER JOIN AHS_SOTHAM_KHANGNGHI               KN ON KN.ID = MAPKCKN.KCKN_SOTHAM_ID
--                                                                              AND NVL(MAPKCKN.IS_KC, 0) = 0
--                                                                              AND KN.LOAIKN = 3
--                                                                              AND KN.LOAIKN = 2
--                                        INNER JOIN AHS_SOTHAM_QUYETDINH_BICAN         QD ON QD.ID = KN.BANANID
--                                    WHERE
--                                        MAPKCKN.VUANST_ID = V_VUANID
--                                        AND NOT EXISTS (
--                                            SELECT
--                                                'x'
--                                            FROM
--                                                AHS_CHUYEN_NHAN_AN
--                                            WHERE
--                                                VUANID = MAPKCKN.VUANPT_ID
--                                                AND TRANG_THAI_ID = 1
--                                                AND TOANHANID = V_TOAANID
--                                        )
--                                ) R;
--                            --Nếu số lượng = thì st ko thể sửa
--
--                            IF L_COUNT_BICAO_DANG_XU_LY = L_COUNT_BICAO THEN
--                                RETURN 0;
--                            ELSE
--                                RETURN 1;
--                            END IF;
--                        END IF;
                    ELSE
                        RETURN 0;
                    END IF;
                ELSIF L_TOANHANID != V_TOAANID THEN
                    RETURN 0;
                END IF;
            ELSE
                -- Nếu toà án truyền vào = 0 thì trả lại
                RETURN 0;
            END IF;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 1;
        END;

        RETURN 1;
    END CHECK_CHUYEN_AN;

    FUNCTION GET_VUANID_DANG_XULY_TDC (
        V_VUANID    NUMBER,
        V_TOAANID   NUMBER
    ) RETURN NUMBER AS
        L_VUANPTID NUMBER;
    BEGIN
        BEGIN
            SELECT
                PT.ID
            INTO L_VUANPTID
            FROM
                AHS_VUAN             PT
                INNER JOIN AHS_CHUYEN_NHAN_AN   CNA ON CNA.VUANID = V_VUANID
                                                     AND CNA.TOANHANID = V_TOAANID
                                                     AND CNA.MAP_VUANID_NEW = PT.ID
            WHERE
                NOT EXISTS (
                    SELECT
                        'x'
                    FROM
                        AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN   QDVA
                        INNER JOIN DM_QD_QUYETDINH                       DMQD ON DMQD.ID = QDVA.QUYETDINHID
                                                           AND DMQD.MA IN (
                            '46-HS',
                            '51-HS',
                            '52-HS'
                        )
                                                           AND QDVA.VUANID = PT.ID
                )
                    AND PT.TOAANID = V_TOAANID
                    AND PT.MAGIAIDOAN = 7
            ORDER BY
                PT.NGAYTAO
            FETCH FIRST 1 ROW ONLY;

            RETURN L_VUANPTID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 0;
        END;

        RETURN 0;
    END GET_VUANID_DANG_XULY_TDC;

    PROCEDURE GET_CT_TAMGIAM (
        VVUAN_ID         IN    VARCHAR2,
        VHIEULUCTUNGAY   IN    VARCHAR2,
        CURRETURN        OUT   SYS_REFCURSOR
    ) AS
        KETQUA        VARCHAR2(100);
        V_NGAYTHULY   DATE;
    BEGIN
        SELECT
            NGAYTHULY
        INTO V_NGAYTHULY
        FROM
            AHS_KCKNQDK_PHUCTHAM_THULY
        WHERE
            VUANID = VVUAN_ID;

        KETQUA := 90 - ( TO_DATE(VHIEULUCTUNGAY, 'dd/MM/yyyy') - V_NGAYTHULY );
        OPEN CURRETURN FOR SELECT
                               KETQUA KETQUAS
                           FROM
                               DUAL;

    END GET_CT_TAMGIAM;

   PROCEDURE AHS_PT_KCKN_TINHTRANG_GETLIST (
        VVUANID     IN    INT,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN curReturn FOR  
  Select r.ID,d.ID as KCKNID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
        ,s.HOTEN || l.HOTEN as NguoiKCCapKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        --,d.NGAYKHANGCAO as NgayKCKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQUYETDINH END) as SO_QDBA
        --,d.NGAYQDBA as NGAYQDBA
        ,to_char(r.NGAYRUT,'dd/MM/yyyy') NGAYRUT
        ,r.TINHTRANG
        ,r.NOIDUNG
        ,d.TINHTRANG_GIAIQUYET
        ,r.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
        --,(case r.TINHTRANG when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From AHS_SOTHAM_KHANGCAO d
  left join AHS_SOTHAM_RUTKHANGCAO r on r.KHANGCAOID=d.ID
  left join (select a.ID,a.HOTEN from AHS_BICANBICAO a where a.VUANID=vVUANID) s on s.ID=d.NGUOIKCID
  left join (select l.ID,l.HOTEN from AHS_NGUOITHAMGIATOTUNG l where l.VUANID=vVUANID) l on l.ID=d.NGUOIKCID
  left join (select e.VUANID,e.SOBANAN from AHS_SOTHAM_BANAN e where e.VUANID=vVUANID) b on b.VUANID=d.VUANID
  left join (select f.VUANID,f.id,f.SOQUYETDINH,0 isbican from AHS_SOTHAM_QUYETDINH_VUAN f where f.VUANID=vVUANID
            union select f.VUANID,f.id,f.SOQUYETDINH,1 isbican from AHS_SOTHAM_QUYETDINH_BICAN f where f.VUANID=vVUANID) q on q.id=d.SOQDBA AND ((Q.ISBICAN = 1 AND D.LOAIKHANGCAO = 3) OR (Q.ISBICAN = 0 AND D.LOAIKHANGCAO in (2,1)))
  Where d.VUANID=vVUANID and nvl(d.TINHTRANG_GIAIQUYET,0)= 0
  union all
  Select r.ID,d.ID as KCKNID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
        ,(CASE d.CAPKN WHEN 0 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
        ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        --,d.NGAYKN as NgayKCKN
        ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQUYETDINH END) as SO_QDBA
        --,d.NGAYBANAN as NGAYQDBA
        ,to_char(r.NGAYRUT,'dd/MM/yyyy') NGAYRUT
        ,r.TINHTRANG
        ,r.NOIDUNG
        ,d.TINHTRANG_GIAIQUYET
        ,r.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
        --,(case r.TINHTRANG when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From AHS_SOTHAM_KHANGNGHI d 
  left join AHS_SOTHAM_RUTKHANGNGHI r on r.KHANGNGHIID=d.ID
  left join (select a.VUANID,a.SOBANAN from AHS_SOTHAM_BANAN a where a.VUANID=vVuAnID) b on b.VUANID=d.VUANID
  left join (select f.VUANID,f.id,f.SOQUYETDINH,0 isbican from AHS_SOTHAM_QUYETDINH_VUAN f where f.VUANID=vVUANID
            union select f.VUANID,f.id,f.SOQUYETDINH,1 isbican from AHS_SOTHAM_QUYETDINH_BICAN f where f.VUANID=vVUANID) q on q.id=d.bananid AND ((Q.ISBICAN = 1 AND D.LOAIKN = 3) OR (Q.ISBICAN = 0 AND D.LOAIKN in (2,1)))
  Where d.VUANID=vVuAnID and nvl(d.TINHTRANG_GIAIQUYET,0)= 0;


    END AHS_PT_KCKN_TINHTRANG_GETLIST;


    FUNCTION CHUYENAN_NOIDUNG (
        V_VUANID NUMBER,
        V_MAGIAIDOAN NUMBER,
        V_CHUYENANID NUMBER,
        V_TRANGTHAIID NUMBER,
        V_MESSAGE VARCHAR2
    ) RETURN CLOB AS
        L_NOIDUNG CLOB;
        L_NOIDUNG_KC CLOB;
        L_NOIDUNG_KN CLOB;
        L_DVKN_TEN CLOB;
        L_DVKNCT_TEN CLOB;
        L_COUNT_KC NUMBER;
    BEGIN
        BEGIN
            L_NOIDUNG_KC :='';
            L_COUNT_KC:=0;
            L_NOIDUNG_KN :='';
            L_DVKN_TEN:='';
            L_DVKNCT_TEN:='';
            IF V_MAGIAIDOAN = 2 AND V_TRANGTHAIID = 0 THEN
                FOR R_KC IN ( 
                    SELECT
                          DECODE(T2.LOAIKHANGCAO,
                                                    0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                    3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                    '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KC
                    FROM
                        AHS_SOTHAM_KHANGCAO          T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                  AND T2.LOAIKHANGCAO IN (
                            1,
                            2
                        ) --> Kháng cáo quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                     AND T2.LOAIKHANGCAO = 3
                        LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                         AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                    WHERE
                        T2.VUANID = V_VUANID
                        AND NVL(T2.TINHTRANG_GIAIQUYET,0) NOT IN (1,3))
                LOOP
                    L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                    L_COUNT_KC:=L_COUNT_KC+1;
                END LOOP;
                FOR R_KN IN ( 
                    SELECT
                          DECODE(T2.LOAIKN,
                                0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KN,
                           DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                           DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                    FROM AHS_SOTHAM_KHANGNGHI T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                        LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                        LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                    WHERE
                        T2.VUANID = V_VUANID
                        AND NVL(T2.TINHTRANG_GIAIQUYET,0) NOT IN (1,3))
                LOOP
                L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                END LOOP;
            ELSIF V_MAGIAIDOAN = 2 AND V_TRANGTHAIID = 1 THEN
                      dbms_output.put_line('V_MAGIAIDOAN = 2 AND V_TRANGTHAIID = 1');  
                      dbms_output.put_line('V_CHUYENANID = '||V_CHUYENANID);
                      dbms_output.put_line('V_VUANID = '||V_VUANID);  

                FOR R_KC IN ( 
                    SELECT
                          DECODE(T2.LOAIKHANGCAO,
                                                    0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                    3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                    '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KC
                    FROM
                        AHS_SOTHAM_KHANGCAO          T2
                        left JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                  AND T2.LOAIKHANGCAO IN (
                            1,
                            2
                        ) --> Kháng cáo quyết định
                        left JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                     AND T2.LOAIKHANGCAO = 3
                        left JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                         AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                       inner JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON V_CHUYENANID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND MAPKCKN.ISKC = 1
                    WHERE
                        T2.VUANID = V_VUANID)
                     --  AND NVL(T2.TINHTRANG_GIAIQUYET,0) NOT IN (1,3))
                LOOP
                    L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                    
            dbms_output.put_line('R_KC.BAQD_KC ' ||R_KC.BAQD_KC);
            dbms_output.put_line(L_NOIDUNG_KC);
                    L_COUNT_KC:=L_COUNT_KC+1;
                END LOOP;
                FOR R_KN IN ( 
                    SELECT
                          DECODE(T2.LOAIKN,
                                0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KN,
                           DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                           DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                    FROM AHS_SOTHAM_KHANGNGHI T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                        LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                        LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                        INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON V_CHUYENANID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND NVL(MAPKCKN.ISKC,0) = 0
                    WHERE
                        T2.VUANID = V_VUANID)
                LOOP
                L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                END LOOP;
            ELSIF V_MAGIAIDOAN = 7 THEN
                FOR R_KC IN ( 
                    SELECT
                          DECODE(T2.LOAIKHANGCAO,
                                                    0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                    3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                    '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KC
                    FROM
                        AHS_SOTHAM_KHANGCAO          T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                  AND T2.LOAIKHANGCAO IN (
                            1,
                            2
                        ) --> Kháng cáo quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                     AND T2.LOAIKHANGCAO = 3
                        LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                         AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                        INNER JOIN AHS_CHUYEN_NHAN_AN NHANAN ON NHANAN.MAP_VUANID_NEW = V_VUANID AND NHANAN.VUANID = T2.VUANID
                        INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON NHANAN.ID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND MAPKCKN.ISKC = 1
                    WHERE
                        NHANAN.MAP_VUANID_NEW = V_VUANID)
                LOOP
                L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                L_COUNT_KC:=L_COUNT_KC+1;
            END LOOP;
                FOR R_KN IN ( 
                    SELECT
                          DECODE(T2.LOAIKN,
                                0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KN,
                           DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                           DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                    FROM AHS_SOTHAM_KHANGNGHI T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                        LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                        LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                        INNER JOIN AHS_CHUYEN_NHAN_AN NHANAN ON NHANAN.MAP_VUANID_NEW = V_VUANID AND NHANAN.VUANID = T2.VUANID
                        INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON NHANAN.ID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND NVL(MAPKCKN.ISKC,0) = 0
                    WHERE
                        NHANAN.MAP_VUANID_NEW = V_VUANID)
                LOOP
                L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                END LOOP;
            ELSE
                FOR R_KC IN ( 
                    SELECT
                          DECODE(T2.LOAIKHANGCAO,
                                                    0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                    3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                    '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KC
                    FROM
                        AHS_SOTHAM_KHANGCAO          T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                  AND T2.LOAIKHANGCAO IN (
                            1,
                            2
                        ) --> Kháng cáo quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                     AND T2.LOAIKHANGCAO = 3
                        LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                         AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                    WHERE
                        T2.VUANID = V_VUANID
                        AND NVL(T2.TINHTRANG_GIAIQUYET,0) NOT IN (1,3))
                LOOP
                L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                L_COUNT_KC:=L_COUNT_KC+1;
            END LOOP;
                FOR R_KN IN ( 
                    SELECT
                          DECODE(T2.LOAIKN,
                                0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KN,
                           DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                           DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                    FROM AHS_SOTHAM_KHANGNGHI T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                        LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                        LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                    WHERE
                        T2.VUANID = V_VUANID
                        AND NVL(T2.TINHTRANG_GIAIQUYET,0) NOT IN (1,3))
                LOOP
                L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                END LOOP;
            END IF;
            dbms_output.put_line(L_NOIDUNG_KC);
            --
            L_NOIDUNG:= V_MESSAGE
                        ||L_NOIDUNG_KC
                        ||L_NOIDUNG_KN
                        ||'<br/>- Số lượng kháng cáo: ' ||L_COUNT_KC
                        ||L_DVKN_TEN
                        ||L_DVKNCT_TEN;
            RETURN L_NOIDUNG;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN '';
        END;
    END CHUYENAN_NOIDUNG;



    FUNCTION NHANAN_NOIDUNG (
        V_VUANID NUMBER,
        V_MAGIAIDOAN NUMBER,
        V_CHUYENANID NUMBER,
        V_TRANGTHAIID NUMBER,
        V_MESSAGE VARCHAR2
    ) RETURN CLOB AS
        L_NOIDUNG CLOB;
        L_NOIDUNG_KC CLOB;
        L_NOIDUNG_KN CLOB;
        L_DVKN_TEN CLOB;
        L_DVKNCT_TEN CLOB;
        L_COUNT_KC NUMBER;
        L_ISMAPKCKN NUMBER;
    BEGIN
        BEGIN
            L_NOIDUNG_KC :='';
            L_COUNT_KC:=0;
            L_NOIDUNG_KN :='';
            L_DVKN_TEN:='';
            L_DVKNCT_TEN:='';
            
            IF V_MAGIAIDOAN = 2 THEN
                BEGIN 
                    SELECT COUNT(*) INTO L_ISMAPKCKN
                    FROM AHS_CHUYEN_NHAN_AN_KCKN
                    WHERE CHUYENNHANID = V_CHUYENANID;
                EXCEPTION 
                WHEN NO_DATA_FOUND THEN 
                    L_ISMAPKCKN:=0;
                END;
                IF L_ISMAPKCKN = 0 THEN
                    FOR R_KC IN ( 
                        SELECT
                              DECODE(T2.LOAIKHANGCAO,
                                                        0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                        3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                        '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                        BAQD_KC
                        FROM
                            AHS_SOTHAM_KHANGCAO          T2
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                      AND T2.LOAIKHANGCAO IN (
                                1,
                                2
                            ) --> Kháng cáo quyết định
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                         AND T2.LOAIKHANGCAO = 3
                            LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                             AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                        WHERE
                            T2.VUANID = V_VUANID)
                    LOOP
                    L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                    L_COUNT_KC:=L_COUNT_KC+1;
                    END LOOP;
                    
                    FOR R_KN IN ( 
                        SELECT
                              DECODE(T2.LOAIKN,
                                    0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                    3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                    '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                        BAQD_KN,
                               DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                               DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                        FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                            LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                            LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                        WHERE
                            T2.VUANID = V_VUANID)
                    LOOP
                    L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                    L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                    L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                    END LOOP;
                ELSE
                    FOR R_KC IN ( 
                        SELECT
                              DECODE(T2.LOAIKHANGCAO,
                                                        0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                        3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                        '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                        BAQD_KC
                        FROM
                            AHS_SOTHAM_KHANGCAO          T2
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                      AND T2.LOAIKHANGCAO IN (
                                1,
                                2
                            ) --> Kháng cáo quyết định
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                         AND T2.LOAIKHANGCAO = 3
                            LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                             AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                            INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON V_CHUYENANID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND MAPKCKN.ISKC = 1
                        WHERE
                            T2.VUANID = V_VUANID)
                    LOOP
                    L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                    L_COUNT_KC:=L_COUNT_KC+1;
                    END LOOP;
                    
                    FOR R_KN IN ( 
                        SELECT
                              DECODE(T2.LOAIKN,
                                    0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                    3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                    '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                        BAQD_KN,
                               DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                               DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                        FROM AHS_SOTHAM_KHANGNGHI T2
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                            LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                            LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                            LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                            INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON V_CHUYENANID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND NVL(MAPKCKN.ISKC,0) = 0
                        WHERE
                            T2.VUANID = V_VUANID)
                    LOOP
                    L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                    L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                    L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                    END LOOP;
                END IF;
            ELSIF V_MAGIAIDOAN = 7 THEN
                FOR R_KC IN ( 
                    SELECT
                          DECODE(T2.LOAIKHANGCAO,
                                                    0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                    3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                    '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KC
                    FROM
                        AHS_SOTHAM_KHANGCAO          T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                  AND T2.LOAIKHANGCAO IN (
                            1,
                            2
                        ) --> Kháng cáo quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                     AND T2.LOAIKHANGCAO = 3
                        LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                         AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                        INNER JOIN AHS_CHUYEN_NHAN_AN NHANAN ON NHANAN.MAP_VUANID_NEW = V_VUANID AND NHANAN.VUANID = T2.VUANID
                        INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON NHANAN.ID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND MAPKCKN.ISKC = 1
                    WHERE
                        NHANAN.MAP_VUANID_NEW = V_VUANID)
                LOOP
                L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                L_COUNT_KC:=L_COUNT_KC+1;
                END LOOP;
                
                FOR R_KN IN ( 
                    SELECT
                          DECODE(T2.LOAIKN,
                                0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KN,
                           DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                           DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                    FROM AHS_SOTHAM_KHANGNGHI T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                        LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                        LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                        INNER JOIN AHS_CHUYEN_NHAN_AN NHANAN ON NHANAN.MAP_VUANID_NEW = V_VUANID AND NHANAN.VUANID = T2.VUANID
                        INNER JOIN AHS_CHUYEN_NHAN_AN_KCKN MAPKCKN ON NHANAN.ID = MAPKCKN.CHUYENNHANID AND MAPKCKN.KCKNID = T2.ID AND NVL(MAPKCKN.ISKC,0) = 0
                    WHERE
                        NHANAN.MAP_VUANID_NEW = V_VUANID)
                LOOP
                L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                END LOOP;
            ELSE
                FOR R_KC IN ( 
                    SELECT
                          DECODE(T2.LOAIKHANGCAO,
                                                    0,'<br/>- Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                                    3,'<br/>- Kháng cáo quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                                    '<br/>- Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KC
                    FROM
                        AHS_SOTHAM_KHANGCAO          T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QD ON QD.ID = T2.SOQDBA
                                                                  AND T2.LOAIKHANGCAO IN (
                            1,
                            2
                        ) --> Kháng cáo quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN   QDBC ON QDBC.ID = T2.SOQDBA
                                                                     AND T2.LOAIKHANGCAO = 3
                        LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.ID = T2.SOQDBA
                                                         AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                    WHERE
                        T2.VUANID = V_VUANID)
                LOOP
                L_NOIDUNG_KC := L_NOIDUNG_KC || R_KC.BAQD_KC;
                L_COUNT_KC:=L_COUNT_KC+1;
                END LOOP;
                
                FOR R_KN IN ( 
                    SELECT
                          DECODE(T2.LOAIKN,
                                0,'<br/>- Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy'),
                                3,'<br/>- Kháng nghị quyết định số: ' || QDBC.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QDBC.NGAYQD,'dd/MM/yyyy'),
                                '<br/>- Kháng nghị quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD,'dd/MM/yyyy'))
                                                    BAQD_KN,
                           DECODE(T2.CAPKN,0,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKN_TEN ,
                           DECODE(T2.CAPKN,1,'<br/><b>- Đơn vị kháng nghị: ' || T4.TEN || '</b>',NULL) DVKNCT_TEN
                    FROM AHS_SOTHAM_KHANGNGHI T2
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QD ON QD.ID=T2.BANANID AND T2.LOAIKN IN (1,2) --> Kháng N quyết định
                        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.ID = T2.BANANID AND T2.LOAIKN = 3
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.ID= T2.BANANID AND T2.LOAIKN=0--> Kháng N bản án    
                        LEFT JOIN DM_VKS T4 ON T2.TOAANRAQDID=T4.ID
                        LEFT JOIN DM_VKS T4 ON T4.ID = (SELECT CAPCHAID FROM DM_VKS WHERE ID = T2.TOAANRAQDID) AND T2.CAPKN = 1
                    WHERE
                        T2.VUANID = V_VUANID)
                LOOP
                L_NOIDUNG_KN := L_NOIDUNG_KN || R_KN.BAQD_KN;
                L_DVKN_TEN:=L_DVKN_TEN||R_KN.DVKN_TEN;
                L_DVKNCT_TEN:=L_DVKNCT_TEN||R_KN.DVKNCT_TEN;
                END LOOP;
            END IF;
            
            --
            L_NOIDUNG:= V_MESSAGE
                        ||L_NOIDUNG_KC
                        ||L_NOIDUNG_KN
                        ||'<br/>- Số lượng kháng cáo: ' ||L_COUNT_KC
                        ||L_DVKN_TEN
                        ||L_DVKNCT_TEN;
            RETURN L_NOIDUNG;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN '';
        END;
    END NHANAN_NOIDUNG;
PROCEDURE   AHS_NTGTT_GETBYVUANID
(
    vu_an_id in number,
	  PageIndex	in	int,
	  PageSize	in	int,
	  curReturn  OUT sys_refcursor
)
AS
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
    VU_AN_ID_ST NUMBER;
    --CheckDelete number;

BEGIN	
    ----------------------------------------------
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

--   select vuanid 
--   from AHS_NguoiThamGiaToTung a  
--                  inner join AHS_NguoiThamGiaToTung_TuCach b on a.ID = b.NguoiID
--                  inner join DM_DataItem c on b.TuCachID = c.ID
--                where a.VuAnId =vu_an_id  and a.ISPHUCTHAM=1
--    UNION
--    SELECT
--            VUANID
--        FROM
--            AHS_CHUYEN_NHAN_AN
--        WHERE
--            MAP_VUANID_NEW = vu_an_id
--            order by vuanid;
--            
    SELECT
            VUANID
        INTO VU_AN_ID_ST
        FROM
            AHS_CHUYEN_NHAN_AN
        WHERE
            MAP_VUANID_NEW = VU_AN_ID;
		---------------------------------------------------
    OPEN curReturn FOR 
        select c.*,c.id arrID, count(*) over()  as CountAll 
        from (	select ROW_NUMBER() OVER (ORDER BY a.LoaiDT, c.Ten asc, a.HoTen asc) stt
                    ,a.ID, a.VuAnId, a.HoTen , a.NamSinh, a.NgayThamGia
                    , a.NgayKetThuc, a.DiaChiChiTiet Diachi
                    , b.TuCachID, c.Ten TenTuCachTGTT--,c.ma
                    , DECODE(a.LoaiDT, 0,u'C\00e1 nh\00e2n', 1,u'C\01a1 quan', 2,u'T\1ed5 ch\1ee9c') DoiTuong 
                    ,DD.BICAO_DATA
                    ,concat(cb.hoten, '-'||a.chucvu_chucdanh) as chucvuchucdanh --duongph
                    , a.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
                from AHS_NguoiThamGiaToTung a 
                  inner join AHS_NguoiThamGiaToTung_TuCach b on a.ID = b.NguoiID
                  inner join DM_DataItem c on b.TuCachID = c.ID
                  left join DM_CANBO cb on a.nguoiphancongid = cb.id
                  LEFT JOIN (
                              SELECT NGUOI_TGTT_ID,LISTAGG(TEN_TCTG, ', ') WITHIN GROUP (ORDER BY TEN_TCTG) BICAO_DATA
                              FROM  (
                                     SELECT DD.NGUOI_TGTT_ID,DECODE(DD.ID_EXT,'BC-',DD.TEN_TCTG,TG.HOTEN||DECODE(DD.ID_EXT,'BH-',' - Bị Hại','QLNVLQ-','- QLNVLQ','BDDS-','- Bị đơn dân sự','NDDS-',' - Nguyên đơn dân sự'))TEN_TCTG FROM AHS_NGUOI_DAIDIEN DD
                                     LEFT JOIN AHS_NGUOITHAMGIATOTUNG TG ON TG.ID=DD.BICAO_ID
                                   )
                              GROUP BY NGUOI_TGTT_ID
                  )DD ON DD.NGUOI_TGTT_ID=A.id
                where a.VuAnId = vu_an_id and a.ISPHUCTHAM=1 
                union
                	select ROW_NUMBER() OVER (ORDER BY a.LoaiDT, c.Ten asc, a.HoTen asc) stt
                    ,a.ID, a.VuAnId, a.HoTen , a.NamSinh, a.NgayThamGia
                    , a.NgayKetThuc, a.DiaChiChiTiet Diachi
                    , b.TuCachID, c.Ten TenTuCachTGTT--,c.ma
                    , DECODE(a.LoaiDT, 0,u'C\00e1 nh\00e2n', 1,u'C\01a1 quan', 2,u'T\1ed5 ch\1ee9c') DoiTuong 
                    ,DD.BICAO_DATA
                    ,concat(cb.hoten, '-'||a.chucvu_chucdanh) as chucvuchucdanh --duongph
                    , a.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
                from AHS_NguoiThamGiaToTung a 
                  inner join AHS_NguoiThamGiaToTung_TuCach b on a.ID = b.NguoiID
                  inner join DM_DataItem c on b.TuCachID = c.ID
                  left join DM_CANBO cb on a.nguoiphancongid = cb.id
                  LEFT JOIN (
                              SELECT NGUOI_TGTT_ID,LISTAGG(TEN_TCTG, ', ') WITHIN GROUP (ORDER BY TEN_TCTG) BICAO_DATA
                              FROM  (
                                     SELECT DD.NGUOI_TGTT_ID,DECODE(DD.ID_EXT,'BC-',DD.TEN_TCTG,TG.HOTEN||DECODE(DD.ID_EXT,'BH-',' - Bị Hại','QLNVLQ-','- QLNVLQ','BDDS-','- Bị đơn dân sự','NDDS-',' - Nguyên đơn dân sự'))TEN_TCTG FROM AHS_NGUOI_DAIDIEN DD
                                     LEFT JOIN AHS_NGUOITHAMGIATOTUNG TG ON TG.ID=DD.BICAO_ID
                                   )
                              GROUP BY NGUOI_TGTT_ID
                  )DD ON DD.NGUOI_TGTT_ID=A.id
                where a.VuAnId = VU_AN_ID_ST  and a.ISPHUCTHAM=1 
              ) c where c.STT>=MinIndex and c.STT<=MaxIndex;
END AHS_NTGTT_GetByVuAnID;
END PKG_STPT_AHS_GS2;

/
