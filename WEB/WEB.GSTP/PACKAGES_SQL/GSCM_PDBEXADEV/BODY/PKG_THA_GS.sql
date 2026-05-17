CREATE OR REPLACE PACKAGE BODY GSCM.PKG_THA_GS AS
    PROCEDURE THA_NHANUYTHAC_GETALL (
        CURRTOAANID     IN NUMBER
      , CURRTRANGTHAI   IN NUMBER
      , V_TENBIAN       IN NVARCHAR2
      , V_TENVUAN       IN NVARCHAR2
      , V_NGAYUYTHAC    IN NVARCHAR2
      , V_TOAANUYTHACID IN NUMBER
      , V_SOQD          IN NVARCHAR2
      , V_NGAYQD        IN NVARCHAR2
      , V_NGAYQDFROM    IN NVARCHAR2
      , V_NGAYQDTO      IN NVARCHAR2
      , PAGE_INDEX      IN INT
      , PAGE_SIZE       IN INT
      , CURRETURN       OUT SYS_REFCURSOR
    ) AS
        VV_NGAYQDFROM DATE;
        VV_NGAYQDTO   DATE;
        VV_NGAYQD     DATE;
        VV_NGAYUYTHAC DATE;
        MININDEX      NUMBER;
        MAXINDEX      NUMBER;
    BEGIN
        MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
        MAXINDEX := PAGE_INDEX * PAGE_SIZE;
        IF ( V_NGAYQDFROM IS NOT NULL ) THEN VV_NGAYQDFROM := TO_DATE ( TRIM(V_NGAYQDFROM) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_NGAYQDTO IS NOT NULL ) THEN VV_NGAYQDTO := TO_DATE ( TRIM(V_NGAYQDTO) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_NGAYQD IS NOT NULL ) THEN VV_NGAYQD := TO_DATE ( TRIM(V_NGAYQD) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_NGAYUYTHAC IS NOT NULL ) THEN VV_NGAYUYTHAC := TO_DATE ( TRIM(V_NGAYUYTHAC) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        OPEN CURRETURN FOR SELECT TT.*
                              FROM ( SELECT ROW_NUMBER()
                                            OVER(
                                                ORDER BY A.NGAYUYTHAC DESC
                                            )                                STT
                                          , COUNT(*) OVER()                           AS COUNTALL
                                          , A.ID
                                          , QD.MAQD
                                          , QD.SOQD
                                          , QD.TENQD
                                          , TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy') NGAYQD
                                          , QD.TOAANUYTHACID
                                          , TOA_UYTHAC.MA_TEN                TENTOAANUYTHAC
                                          , A.LOAIUYTHAC
                                          , A.LYDOID
                                          , CASE
                                                WHEN A.LOAIUYTHAC = 0 THEN u'Ủy thác vì không thuộc thẩm quyền'
                                                WHEN A.LOAIUYTHAC = 1 THEN CONCAT(u'', A.UYTHACKHAC)
                                              END                              AS TENLYDO
                                          , A.NGAYUYTHAC
                                          , A.NGUOINHAP
                                          , A.NGAYNHANUYTHAC
                                          , A.NGUOIKY                        NGUOINHANDANHAP
                                          , CB.HOTEN                         TENNGUOINHAP
                                          , QD.BIANID
                                          , QD.HOTEN                         TENBIAN
                                          , QD.TENTOIDANH                    TENTOIDANH
                                          , A.TRANGTHAI
                                            FROM ( SELECT DT.ID
                                                        , DT.NGAYUYTHAC
                                                        , DT.LOAIUYTHAC
                                                        , DT.LYDOID
                                                        , DT.QD_UYTHACTHA_ID
                                                        , DT.NGUOINHAP
                                                        , DT.NGAYNHANUYTHAC
                                                        , DT.UYTHACKHAC
                                                        , CB.HOTEN             NGUOIKY
                                                        , NVL(DT.TRANGTHAI, 0) TRANGTHAI
                                                          FROM THA_UYTHAC_DETAIL DT
                                                          LEFT JOIN DM_CANBO          CB ON DT.NGUOIKY = CB.ID
                                                   WHERE NVL(TRANGTHAI, 0) = CURRTRANGTHAI
                                                 ) A
                                            INNER JOIN ( SELECT X.ID
                                                              , X.MAQD
                                                              , X.SOQD
                                                              , X.NGAYQD
                                                              , X.TENQD
                                                              , X.TOAANNHANUYTHACID
                                                              , X.TOAANUYTHACID
                                                              , X.VUANID
                                                              , X.BIANID
                                                              , Y.HOTEN
                                                              , K.TENTOIDANH
                                                              ,
                                                --Y.TOIDANH TENTOIDANH,
                                                               Z.BA_TENVUAN
                                                                      FROM THA_UYTHAC_QUYETDINH         X
                                                                      LEFT JOIN THA_BIAN                     Y ON X.BIANID = Y.ID
                                                                      LEFT JOIN THA_SOTHAM_CAOTRANG_DIEULUAT K ON K.BICANID = Y.ID
                                                                                                                  AND
                                                                                                                  K.ISMAIN = 1
                                                --and K.VUANID=X.VUANID
                                                                      INNER JOIN THA_VUAN                     Z ON X.VUANID = Z.ID
                                                         WHERE TOAANNHANUYTHACID = CURRTOAANID
                                                       ) QD ON QD.ID = A.QD_UYTHACTHA_ID
                                            LEFT JOIN ( SELECT ID
                                                             , MA_TEN
                                                        FROM DM_TOAAN --where ID=CurrToaAnID

                                                      ) TOA_UYTHAC ON TOA_UYTHAC.ID = QD.TOAANUYTHACID
                                            LEFT JOIN ( SELECT ID
                                                             , HOTEN
                                                        FROM DM_CANBO
                                                      ) CB ON CB.ID = A.NGUOINHAP
                                            LEFT JOIN ( SELECT ID
                                                             , MA
                                                             , TEN
                                                        FROM DM_DATAITEM
                                                      ) B ON A.LYDOID = B.ID
                                     WHERE TOAANUYTHACID = NVL(NULLIF(V_TOAANUYTHACID, 0)
                                                                 , TOAANUYTHACID)           
--NVL( v_ToaAnUyThacID,ToaAnUyThacID) --ToaAnUyThac
                                     AND (( V_TENVUAN || ' ' ) = ' ' OR (LOWER(QD.BA_TENVUAN) LIKE ( '%' || LOWER(V_TENVUAN) || '%' )) )--TenVuAn
                                     AND (( V_TENBIAN || ' ' ) = ' ' OR LOWER(QD.HOTEN) LIKE ( '%' || LOWER(V_TENBIAN) || '%' ))--TenBiAn
                                     AND (( V_SOQD || ' ' ) = ' ' OR LOWER(QD.SOQD) LIKE ( '%' || LOWER(V_SOQD) || '%' )) --SoQD
--v_time IS NULL OR (v_time IS NOT NULL AND time = v_time AND time IS NOT NULL);
                                           AND ( VV_NGAYUYTHAC IS NULL
                                                 OR ( VV_NGAYUYTHAC IS NOT NULL
                                                      AND A.NGAYUYTHAC = NVL(VV_NGAYUYTHAC, A.NGAYUYTHAC) ) )
                                           AND QD.NGAYQD = NVL(VV_NGAYQD, QD.NGAYQD) --NgayQD

                                           AND QD.NGAYQD BETWEEN NVL(VV_NGAYQDFROM, QD.NGAYQD) AND NVL(VV_NGAYQDTO, QD.NGAYQD

                                           ) --NgayQDFromTo
                                   ) TT
           WHERE TT.STT >= MININDEX
                 AND TT.STT <= MAXINDEX;
    END THA_NHANUYTHAC_GETALL;
    
   -- vnpt phat trien phan ban giao thi hanh an 08/2025
  PROCEDURE THA_BIAN_GETANHSTRONGHT_PAGING(
        TOA_AN_ID   IN NUMBER,
        MA_BI_AN    IN NVARCHAR2,
        TEN_BI_AN   IN NVARCHAR2,
        MA_VU_AN    IN NVARCHAR2,
        TEN_VU_AN   IN NVARCHAR2,
        SO_BAN_AN   IN VARCHAR2,
        NGAY_BAN_AN IN DATE,
        P_TRANGTHAI   IN NUMBER,
        TRANGTHAIGQ IN NUMBER,
        V_SOCMND    IN NVARCHAR2,
        V_TUNGAY    IN NVARCHAR2,
        V_DENNGAY   IN NVARCHAR2,
        PAGEINDEX   IN NUMBER,
        PAGESIZE    IN NUMBER,
        CURRETURN   OUT SYS_REFCURSOR
    ) AS
        VV_TUNGAY  DATE;
        VV_DENNGAY DATE;
        MININDEX   NUMBER;
        MAXINDEX   NUMBER;
    BEGIN
        IF V_TUNGAY IS NOT NULL THEN
            VV_TUNGAY := TO_DATE(TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;
    
        IF V_DENNGAY IS NOT NULL THEN
            VV_DENNGAY := TO_DATE(TRIM(V_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;
    
        MININDEX := PAGESIZE * (PAGEINDEX - 1) + 1;
        MAXINDEX := PAGEINDEX * PAGESIZE;
    
        OPEN CURRETURN FOR
            SELECT
                A.*,
                CASE
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_UYTHAC_QUYETDINH UYTHAC
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                        WHERE A.BIANID = BIAN.IDBICANHETHONG
                    ) THEN 'Đã có QĐ ủy thác thi hành án'
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_CVDON_KQGQ KQ
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                        WHERE A.BIANID = BIAN.IDBICANHETHONG
                    ) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_BIAN_QUYETDINH UYTHAC
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                        WHERE A.BIANID = BIAN.IDBICANHETHONG
                    ) THEN 'Đã có QĐ thi hành án'
                    --VNPT- Lưu Quang Huy - hiển thị thêm TINHTRANGGQ - 18-09-2025 11:00
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_THULY THULY
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                        WHERE A.VUANID = THULY.VUANID
                          AND A.BIANID = BIAN.IDBICANHETHONG
                          AND THULY.IS_KHONGTHA = 1
                    ) THEN 'Không ra quyết định THA'
                    WHEN EXISTS (
                        SELECT 'x'
                        FROM THA_THULY THULY
                        INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                        WHERE A.VUANID = THULY.VUANID
                          AND A.BIANID = BIAN.IDBICANHETHONG
                    ) THEN 'Đã thụ lý'
                    ELSE 'Chưa giải quyết'
                END AS TINHTRANGGQ
            FROM (
                SELECT
                    ROW_NUMBER() OVER (ORDER BY A.NGAYHIEULUC DESC) AS STT,
                    COUNT(*) OVER () AS COUNTALL,
                    A.*
                FROM (
                    SELECT DISTINCT
                        A.ID AS IDVuAnHeThong,
                        A.MAVUAN,
                        A.TENVUAN,
                        BC.ID AS BIANID,
                        BC.MABICAN AS MABIAN,
                        BC.HOTEN AS TENBIAN,
                        A.MAGIAIDOAN,
                        DECODE(A.MAGIAIDOAN, 1, 'Hồ sơ', 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm', '') AS GIAIDOANVUVIEC,
                        ST.SOBANAN,
                        ST.NGAYBANAN,
                        ST.NGAYHIEULUCST AS NGAYHIEULUC,
                        THAVUAN.ID AS VUANID,
                        --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA - 17-09-2025 13:30
                        ATD.HOTENBIAN_TOIDANH,
                        ST.NGAYBANAN_QD,
                        ST.SOBANAN_QD,
                        '' AS HINHPHAT_TONGHOP,
                        CASE WHEN TTL.SOTHULY IS NOT NULL THEN TO_CHAR(TTL.SOTHULY) || ' - ' || TO_CHAR(TTL.NGAYTHULY, 'DD/MM/YYYY')
                        	ELSE ''
                        END AS THA_SOTHULY_NGAYTHULY,
                        THABQ.QD_SO THA_QD_SO
                        --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA - 17-09-2025 13:30
                    FROM (
                        SELECT
                            ID,
                            MAVUAN,
                            TENVUAN,
                            TOAPHUCTHAMID,
                            MAGIAIDOAN
                        FROM AHS_VUAN
                        WHERE (MAGIAIDOAN = '2' OR MAGIAIDOAN = '3')
                          AND TOAANID = TOA_AN_ID
                          AND (MA_VU_AN = '' OR (LOWER(MAVUAN) LIKE ('%' || LOWER(MA_VU_AN) || '%')))
                          AND (TEN_VU_AN = '' OR (LOWER(TENVUAN) LIKE ('%' || LOWER(TEN_VU_AN) || '%')))
                    ) A
                    INNER JOIN ( --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA - 17-09-2025 13:30
                        SELECT
                            A.ID AS BANANID,
                            A.VUANID,
                            A.NGAYBANAN,
                            COALESCE(PTBA.NGAYBANAN, PTQD.NGAYQD, A.NGAYBANAN, ASQV.NGAYQD) NGAYBANAN_QD,
                            (A.NGAYBANAN + 14) AS NGAYHIEULUCST,
                            A.SOBANAN,
                            COALESCE(PTBA.SOBANAN, PTQD.SOQUYETDINH, A.SOBANAN, ASQV.SOQUYETDINH) SOBANAN_QD
                        FROM AHS_SOTHAM_BANAN A
                        LEFT JOIN (
							SELECT ASQV.* FROM
							AHS_SOTHAM_QUYETDINH_VUAN ASQV
							INNER JOIN DM_QD_QUYETDINH DMQD1 ON DMQD1.ID = ASQV.QUYETDINHID AND DMQD1.KET_THUC = 1
						) ASQV ON A.VUANID = ASQV.VUANID
						LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID = A.VUANID
						LEFT JOIN (
							SELECT PTQD.* FROM
							AHS_PHUCTHAM_QUYETDINH_VUAN PTQD 
							INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = PTQD.QUYETDINHID AND DMQD2.KET_THUC = 1
						) PTQD ON PTQD.VUANID = A.VUANID
                        WHERE 
                        	(SO_BAN_AN = '' OR (LOWER(COALESCE(PTBA.SOBANAN, PTQD.SOQUYETDINH, A.SOBANAN, ASQV.SOQUYETDINH)) LIKE ('%' || LOWER(SO_BAN_AN) || '%')))
                          AND (NGAY_BAN_AN IS NULL OR NGAY_BAN_AN = '' OR NGAY_BAN_AN =  COALESCE(PTBA.NGAYBANAN, PTQD.NGAYQD, A.NGAYBANAN, ASQV.NGAYQD))
                    ) ST ON ST.VUANID = A.ID
                     --VNPT- Lưu Quang Huy - Sửa điều kiện lấy ra DS bị án - 18-09-2025 15:30
                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBAN ON PTBAN.VUANID = A.ID
                    LEFT JOIN (
							SELECT PTQD.* FROM
							AHS_PHUCTHAM_QUYETDINH_VUAN PTQD 
							INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = PTQD.QUYETDINHID AND DMQD2.KET_THUC = 1
						) PTQDN ON PTQDN.VUANID = A.ID
					--VNPT- Lưu Quang Huy - Sửa điều kiện lấy ra DS bị án - 18-09-2025 15:30
                    LEFT JOIN THA_VUAN THAVUAN ON A.ID = THAVUAN.IDVUANHETHONG
                   --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA - 17-09-2025 13:30
                    INNER JOIN (
                        SELECT
                            BANANID,
                            BICAOID
                        FROM AHS_SOTHAM_BANAN_BICAO
                    ) STBC ON STBC.BANANID = ST.BANANID
                    LEFT JOIN THA_BIAN THABA ON THABA.IDBICANHETHONG = STBC.BICAOID AND THABA.VUANID = THAVUAN.ID
                    LEFT JOIN THA_BIAN_QUYETDINH THABQ ON THABQ.VUANID = THABA.VUANID AND THABQ.BIANID = THABA.ID
                    LEFT JOIN THA_THULY TTL ON TTL.VUANID = THAVUAN.ID AND TTL.BIANID = THABA.ID
                    INNER JOIN (
                        SELECT
                            IDKCKN,
                            CONCAT(
                                CONCAT(
                                    LISTAGG(KC1ID, ',') WITHIN GROUP (ORDER BY KC1ID),
                                    LISTAGG(KC2ID, ',') WITHIN GROUP (ORDER BY KC2ID)
                                ),
                                LISTAGG(KNID, ',') WITHIN GROUP (ORDER BY KNID)
                            ) AS KCKN,
                            ',' || LISTAGG(BAPT, ',') WITHIN GROUP (ORDER BY BAPT) || ',' AS BAPT,
                            ',' || LISTAGG(KETQUAPHUCTHAM, ',') WITHIN GROUP (ORDER BY BAPT) || ',' AS KQPT,
                            ',' || LISTAGG(RUTKC1TINHTRANG, ',') WITHIN GROUP (ORDER BY RUTKC1TINHTRANG) || ',' AS RUTKC1TINHTRANG,
                            ',' || LISTAGG(RUTKC2TINHTRANG, ',') WITHIN GROUP (ORDER BY RUTKC2TINHTRANG) || ',' AS RUTKC2TINHTRANG,
                            ',' || LISTAGG(RUTKNTINHTRANG, ',') WITHIN GROUP (ORDER BY RUTKNTINHTRANG) || ',' AS RUTKNTINHTRANG,
                            ',' || LISTAGG(NGAYKHANGCAO1, ',') WITHIN GROUP (ORDER BY NGAYKHANGCAO1) || ',' AS NGAYKHANGCAO1,
                            ',' || LISTAGG(NGAYKHANGCAO2, ',') WITHIN GROUP (ORDER BY NGAYKHANGCAO2) || ',' AS NGAYKHANGCAO2,
                            ',' || LISTAGG(NGAYKHANGNGHI, ',') WITHIN GROUP (ORDER BY NGAYKHANGNGHI) || ',' AS NGAYKHANGNGHI,
                            ',' || LISTAGG(ISQUAHAN1, ',') WITHIN GROUP (ORDER BY ISQUAHAN1) || ',' AS ISQUAHAN1,
                            ',' || LISTAGG(ISQUAHAN2, ',') WITHIN GROUP (ORDER BY ISQUAHAN2) || ',' AS ISQUAHAN2,
                            ',' || LISTAGG(GQ_ISCHAPNHAN1, ',') WITHIN GROUP (ORDER BY GQ_ISCHAPNHAN1) || ',' AS GQ_ISCHAPNHAN1,
                            ',' || LISTAGG(GQ_ISCHAPNHAN2, ',') WITHIN GROUP (ORDER BY GQ_ISCHAPNHAN2) || ',' AS GQ_ISCHAPNHAN2,
                            ',' || LISTAGG(QUYETDINHID, ',') WITHIN GROUP (ORDER BY QUYETDINHID) || ',' AS QUYETDINHID
                        FROM (
                            SELECT
                                BC.ID AS IDKCKN,
                                KC1.ID AS KC1ID,
                                KC2.ID AS KC2ID,
                                KQPT.KETQUAPHUCTHAMID AS KETQUAPHUCTHAM,
                                KN.ID AS KNID,
                                BAPT.ID AS BAPT,
                                VUAN.TOAANID AS TOAANID,
                                RKCST1.TINHTRANG AS RUTKC1TINHTRANG,
                                RKCST2.TINHTRANG AS RUTKC2TINHTRANG,
                                RKNST.TINHTRANG AS RUTKNTINHTRANG,
                                KC1.NGAYKHANGCAO AS NGAYKHANGCAO1,
                                KC2.NGAYKHANGCAO AS NGAYKHANGCAO2,
                                KC1.ISQUAHAN AS ISQUAHAN1,
                                KC2.ISQUAHAN AS ISQUAHAN2,
                                KC1.GQ_ISCHAPNHAN AS GQ_ISCHAPNHAN1,
                                KC2.GQ_ISCHAPNHAN AS GQ_ISCHAPNHAN2,
                                KN.NGAYKN AS NGAYKHANGNGHI,
                                PTQD.QUYETDINHID AS QUYETDINHID
                            FROM AHS_BICANBICAO BC
                            LEFT JOIN AHS_SOTHAM_KHANGCAO KC1
                                ON KC1.NGUOIKCLOAI = 0
                               AND KC1.NGUOIKCID = BC.ID
                            LEFT JOIN AHS_SOTHAM_KHANGCAO KC2
                                ON KC1.NGUOIKCLOAI = 1
                               AND KC2.DSNGUOIBIKC LIKE '%' || BC.ID || ',' || '%'
                            LEFT JOIN AHS_SOTHAM_KHANGNGHI KN
                                ON KN.DSNGUOIBIKN LIKE '%' || BC.ID || ',' || '%'
                            LEFT JOIN AHS_PHUCTHAM_BANAN_BICAO BAPT
                                ON BAPT.BICAOID = BC.ID
                            LEFT JOIN AHS_SOTHAM_RUTKHANGCAO RKCST1
                                ON RKCST1.KHANGCAOID = KC1.ID
                            LEFT JOIN AHS_SOTHAM_RUTKHANGCAO RKCST2
                                ON RKCST2.KHANGCAOID = KC2.ID
                            LEFT JOIN AHS_SOTHAM_RUTKHANGNGHI RKNST
                                ON RKNST.KHANGNGHIID = KN.ID
                            LEFT JOIN AHS_VUAN VUAN
                                ON VUAN.ID = BC.VUANID
                            LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD
                                ON PTQD.VUANID = BC.VUANID
                            LEFT JOIN (
                                SELECT
                                    PTBC.BICAOID AS BICAOID,
                                    PTBA.KETQUAPHUCTHAMID AS KETQUAPHUCTHAMID
                                FROM AHS_PHUCTHAM_BANAN_BICAO PTBC
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.ID = PTBC.BANANID
                            ) KQPT ON KQPT.BICAOID = BC.ID
                            WHERE VUAN.TOAANID = TOA_AN_ID
                        )
                        GROUP BY IDKCKN
                    ) BCKCKN ON (
                        (KCKN IS NULL)
                        OR (BAPT IS NOT NULL AND BAPT NOT LIKE '%,,%' AND KCKN IS NOT NULL AND NOT REGEXP_LIKE(KQPT, ',3,|,4,|,22,|,46,|,47,|,48,|,49,'))
                        OR (BCKCKN.QUYETDINHID NOT LIKE '%,,%' AND KCKN IS NOT NULL AND REGEXP_LIKE(BCKCKN.QUYETDINHID, ',79,|,80,|,127,|,128,|,203,|,205,|,324,'))
                        OR (KCKN IS NOT NULL AND REGEXP_LIKE(RUTKC1TINHTRANG, ',2,|,1,'))
                        OR (KCKN IS NOT NULL AND REGEXP_LIKE(RUTKC2TINHTRANG, ',2,|,1,'))
                        OR (KCKN IS NOT NULL AND REGEXP_LIKE(RUTKNTINHTRANG, ',2,|,1,'))
                        OR (
                            (KCKN IS NOT NULL AND ISQUAHAN1 LIKE '%,1,%' AND GQ_ISCHAPNHAN1 LIKE '%,1,%')
                            OR (KCKN IS NOT NULL AND ISQUAHAN2 LIKE '%,1,%' AND GQ_ISCHAPNHAN2 LIKE '%,1,%')
                        )
                    )
                    AND BCKCKN.IDKCKN = STBC.BICAOID
                    INNER JOIN (
                        SELECT
                            ID,
                            VUANID,
                            MABICAN,
                            HOTEN,
                            SOCMND
                        FROM AHS_BICANBICAO BC
                        WHERE (TEN_BI_AN = '' OR TEN_BI_AN IS NULL OR (LOWER(BC.HOTEN) LIKE ('%' || LOWER(TEN_BI_AN) || '%')))
                          AND (MA_BI_AN = '' OR MA_BI_AN IS NULL OR (LOWER(BC.MABICAN) LIKE ('%' || LOWER(MA_BI_AN) || '%')))
                          AND (V_SOCMND = '' OR V_SOCMND IS NULL OR (LOWER(BC.SOCMND) LIKE ('%' || LOWER(V_SOCMND) || '%')))
                    ) BC ON BC.VUANID = A.ID
                        AND STBC.BICAOID = BC.ID
                    LEFT JOIN ( --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
                    	SELECT 
							a.ID,
							a.VUANID,
							CASE 
								WHEN c.TENTOIDANH IS NULL THEN a.HOTEN
								ELSE a.HOTEN || ' - ' || c.TENTOIDANH
							END AS HOTENBIAN_TOIDANH
						FROM
							AHS_BICANBICAO a
						LEFT JOIN AHS_SOTHAM_BANAN_BICAO b ON
							a.ID = b.BICAOID
						LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET c ON
							b.BANANID = c.BANANID
							AND b.BICAOID = c.BICANID AND c.ISMAIN = 1 
                    ) ATD ON ATD.ID = BC.ID AND ATD.VUANID = A.ID --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
                    LEFT JOIN (
                        SELECT
                            BANANID,
                            VUANID,
                            NGAYKN
                        FROM AHS_SOTHAM_KHANGNGHI
                    ) KN ON ST.BANANID = KN.BANANID
                    LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QDBC ON QDBC.BICANID = BC.ID
                    LEFT JOIN (
                        SELECT
                            ID,
                            VUANID,
                            NGAYKHANGCAO,
                            NGUOIKCID,
                            SOQDBA,
                            GQ_ISCHAPNHAN,
                            ISQUAHAN
                        FROM AHS_SOTHAM_KHANGCAO
                    ) KC ON A.ID = KC.VUANID
                        AND KC.SOQDBA = ST.BANANID
                        AND KC.NGUOIKCID = BC.ID
                    WHERE (QDBC.LOAIQDID IS NULL OR (QDBC.LOAIQDID != 3 AND QDBC.LOAIQDID != 4))
                    AND (
                              ST.NGAYBANAN <= CURRENT_DATE - 31
                              OR PTBAN.ID IS NOT NULL
                              OR PTQDN.QUYETDINHID IN (79, 80, 127, 128, 203, 205, 324)
                              OR (
                              		A.MAGIAIDOAN = 2
                              		AND 
                              		EXISTS (SELECT
										1
									FROM
										AHS_SOTHAM_BANAN_DIEU_CHITIET ahdc
									INNER JOIN AHS_SOTHAM_BANAN asb ON ahdc.BANANID = asb.ID
									INNER JOIN DM_HINHPHAT dh ON ahdc.HINHPHATID = dh.ID 
									WHERE 
										asb.VUANID = A.ID
										AND ahdc.BICANID = STBC.BICAOID
										AND dh.MAHINHPHAT = 'PHATTIEN'
										AND NOT EXISTS (SELECT 1 FROM AHS_SOTHAM_BANAN_DIEU_CHITIET A1 
											INNER JOIN AHS_SOTHAM_BANAN C1 ON A1.BANANID = C1.ID
											INNER JOIN DM_HINHPHAT DMH ON A1.HINHPHATID = DMH.ID
											WHERE
												A1.VUANID = ahdc.VUANID 
												AND A1.BICANID = ahdc.BICANID
												AND C1.VUANID = asb.VUANID
												AND asb.ID = C1.ID
												AND DMH.MAHINHPHAT <> 'PHATTIEN'
										))
                              )
                              OR (
                              		A.MAGIAIDOAN = 3
                              		AND 
                              		EXISTS (SELECT
										1
									FROM
										AHS_PHUCTHAM_BANAN_DIEU_CT ahdc
									INNER JOIN AHS_PHUCTHAM_BANAN asb ON ahdc.BANANID = asb.ID
									INNER JOIN DM_HINHPHAT dh ON ahdc.HINHPHATID = dh.ID 
									WHERE 
										asb.VUANID = A.ID
										AND ahdc.BICANID = STBC.BICAOID
										AND dh.MAHINHPHAT = 'PHATTIEN'
										AND NOT EXISTS (SELECT 1 FROM AHS_PHUCTHAM_BANAN_DIEU_CT A1 
											INNER JOIN AHS_PHUCTHAM_BANAN C1 ON A1.BANANID = C1.ID
											INNER JOIN DM_HINHPHAT DMH ON A1.HINHPHATID = DMH.ID
											WHERE
												C1.ID = asb.ID
												AND A1.BICANID = ahdc.BICANID
												AND C1.VUANID = asb.VUANID
												AND DMH.MAHINHPHAT <> 'PHATTIEN'
										))
                              )
                          )
                ) A
                WHERE
                (
                    (
                        (P_TRANGTHAI IS NULL OR P_TRANGTHAI = 0)
                        AND (V_TUNGAY IS NULL OR A.NGAYBANAN >= VV_TUNGAY)
                        AND (V_DENNGAY IS NULL OR A.NGAYBANAN <= VV_DENNGAY)
                    )
                    OR (
                        P_TRANGTHAI = 1
                        AND NOT EXISTS (
                            SELECT 'x'
                            FROM THA_THULY THULY
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE A.VUANID = THULY.VUANID
                              AND BIAN.ID = THULY.BIANID
                        )
                        AND (V_TUNGAY IS NULL OR A.NGAYBANAN >= VV_TUNGAY)
                        AND (V_DENNGAY IS NULL OR A.NGAYBANAN <= VV_DENNGAY)
                    )
                    OR (
                        P_TRANGTHAI = 2
                        AND EXISTS (
                            SELECT 'x'
                            FROM THA_THULY THULY
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE A.VUANID = THULY.VUANID
                              AND BIAN.ID = THULY.BIANID
                              AND (V_TUNGAY IS NULL OR THULY.NGAYTHULY >= VV_TUNGAY)
                              AND (V_DENNGAY IS NULL OR THULY.NGAYTHULY <= VV_DENNGAY)
                        )
                        AND NOT EXISTS (
                            SELECT 'x'
                            FROM THA_UYTHAC_DETAIL UYTHAC
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE BIAN.ID = UYTHAC.BIANID
                        )
                        AND NOT EXISTS (
                            SELECT 'x'
                            FROM THA_CVDON_KQGQ KQ
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE A.VUANID = KQ.VUANID
                              AND BIAN.ID = KQ.BIANID
                        )
                    )
                    OR (
                        P_TRANGTHAI = 3
                        AND EXISTS (
                            SELECT 'x'
                            FROM THA_BIAN_QUYETDINH QD
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE A.VUANID = QD.VUANID
                              AND BIAN.ID = QD.BIANID
                              AND (V_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                              AND (V_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                        )
                    )
                    OR (
                        P_TRANGTHAI = 4
                        AND EXISTS (
                            SELECT 'x'
                            FROM THA_UYTHAC_QUYETDINH UYTHAC
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE A.VUANID = UYTHAC.VUANID
                              AND BIAN.ID = UYTHAC.BIANID
                              AND (V_TUNGAY IS NULL OR UYTHAC.NGAYQD >= VV_TUNGAY)
                              AND (V_DENNGAY IS NULL OR UYTHAC.NGAYQD <= VV_DENNGAY)
                        )
                    )
                    OR (
                        P_TRANGTHAI = 5
                        AND EXISTS (
                            SELECT 'x'
                            FROM THA_CVDON_KQGQ KQ
                            INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                            WHERE A.VUANID = KQ.VUANID
                              AND BIAN.ID = KQ.BIANID
                              AND (V_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                              AND (V_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                        )
                    )
                    OR (
                        P_TRANGTHAI = 6
                        AND (
                            EXISTS (
                                SELECT 'x'
                                FROM THA_UYTHAC_QUYETDINH UYTHAC
                                INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                WHERE A.VUANID = UYTHAC.VUANID
                                  AND BIAN.ID = UYTHAC.BIANID
                                  AND (V_TUNGAY IS NULL OR UYTHAC.NGAYQD >= VV_TUNGAY)
                                  AND (V_DENNGAY IS NULL OR UYTHAC.NGAYQD <= VV_DENNGAY)
                            )
                            OR EXISTS (
                                SELECT 'x'
                                FROM THA_THULY THULY
                                INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                WHERE A.VUANID = THULY.VUANID
                                  AND BIAN.ID = THULY.BIANID
                                  AND (V_TUNGAY IS NULL OR THULY.NGAYTHULY >= VV_TUNGAY)
                                  AND (V_DENNGAY IS NULL OR THULY.NGAYTHULY <= VV_DENNGAY)
                            )
                            OR EXISTS (
                                SELECT 'x'
                                FROM THA_CVDON_KQGQ KQ
                                INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                WHERE A.VUANID = KQ.VUANID
                                  AND BIAN.ID = KQ.BIANID
                                  AND (V_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                  AND (V_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                            )
                            OR EXISTS (
                                SELECT 'x'
                                FROM THA_BIAN_QUYETDINH QD
                                INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                WHERE A.VUANID = QD.VUANID
                                  AND BIAN.ID = QD.BIANID
                                  AND (V_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                  AND (V_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                            )
                        )
                    )
                    OR (
                    --VNPT- Lưu Quang Huy - thêm filter trường hợp không THA - 18-09-2025 10:00
                        P_TRANGTHAI = 7
                        AND (
                            EXISTS (
                                SELECT 'x'
                                FROM THA_THULY TTL
                                INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                WHERE A.VUANID = TTL.VUANID
                                  AND BIAN.ID = TTL.BIANID
                                  AND TTL.IS_KHONGTHA = 1
                                  AND (V_TUNGAY IS NULL OR TTL.NGAYTHONGKE >= VV_TUNGAY)
                                  AND (V_DENNGAY IS NULL OR TTL.NGAYTHONGKE <= VV_DENNGAY)
                            )
                        )
                    )
                )
                AND (
                         (
                            TRANGTHAIGQ = 1 AND (
                                EXISTS (
                                    SELECT 'x'
                                    FROM THA_BIAN_QUYETDINH QD
                                    INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                    WHERE A.VUANID = QD.VUANID
                                      AND BIAN.ID = QD.BIANID
                                      AND TOA_AN_ID  <>  QD.TOA_GIAIQUYET_ID
                                      AND (V_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                      AND (V_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                                )
                                OR EXISTS (
                                    SELECT 'x'
                                    FROM THA_CVDON_KQGQ KQ
                                    INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                    WHERE A.VUANID = KQ.VUANID
                                      AND BIAN.ID = KQ.BIANID
                                      AND TOA_AN_ID  <>  KQ.TOA_GIAIQUYET_ID
                                      AND (V_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                      AND (V_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                                )
                            )
                        )                    
                        OR ( TRANGTHAIGQ = 0 AND (
                                NOT EXISTS (
                                    SELECT 'x'
                                    FROM THA_BIAN_QUYETDINH QD
                                    INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                    WHERE A.VUANID = QD.VUANID
                                      AND BIAN.ID = QD.BIANID
                                      AND TOA_AN_ID  <>  QD.TOA_GIAIQUYET_ID
                                      AND (V_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                      AND (V_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                                )
                                AND NOT EXISTS (
                                    SELECT 'x'
                                    FROM THA_CVDON_KQGQ KQ
                                    INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                    WHERE A.VUANID = KQ.VUANID
                                      AND BIAN.ID = KQ.BIANID
                                      AND TOA_AN_ID  <>  KQ.TOA_GIAIQUYET_ID
                                      AND (V_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                      AND (V_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                                ))
                        )
                    )
                ) A
            WHERE A.STT >= MININDEX
              AND A.STT <= MAXINDEX
            ORDER BY A.STT;
    END THA_BIAN_GETANHSTRONGHT_PAGING;
   
    -- vnpt phat trien phan ban giao thi hanh an 08/2025
    PROCEDURE THA_BIAN_GETANNGOAIHT (
        TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , P_TRANGTHAI   IN NUMBER
      , TRANGTHAIGQ IN NUMBER
      , V_SOCMND    IN NVARCHAR2
      , V_TUNGAY    IN NVARCHAR2
      , V_DENNGAY   IN NVARCHAR2
      , PAGEINDEX   IN NUMBER
      , PAGESIZE    IN NUMBER
      , CURRETURN   OUT SYS_REFCURSOR
    ) AS
        VV_TUNGAY  DATE;
        VV_DENNGAY DATE;
        MININDEX   NUMBER;
        MAXINDEX   NUMBER;
    BEGIN
        MININDEX := PAGESIZE * ( PAGEINDEX - 1 ) + 1;
        MAXINDEX := PAGEINDEX * PAGESIZE;
        IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;

   ---------------------------------------------
        OPEN CURRETURN FOR SELECT A.*
                                ,(CASE
                                    --Đã uỷ thác THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON  BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.VUANID = UYTHAC.VUANID AND BIAN.ID = A.BIANID
                                                  ) THEN 'Đã có QĐ ủy thác thi hành án'
                                    WHEN EXISTS (   SELECT 'x' FROM THA_CVDON_KQGQ KQ
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                                    WHERE A.VUANID = KQ.VUANID
                                                    	AND BIAN.ID = A.BIANID
                                                    ) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
                                    --Đã ra QĐ THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_BIAN_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.VUANID = UYTHAC.VUANID
                                                    AND BIAN.ID = A.BIANID	
                                                    ) THEN 'Đã có QĐ thi hành án'
                                    --Không ra quyết định THA
                                    --VNPT- Lưu Quang Huy - hiển thị thêm TINHTRANGGQ - 18-09-2025 11:00
                                      WHEN EXISTS ( SELECT 'x' FROM THA_THULY THULY
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                                    WHERE A.VUANID = THULY.VUANID 
                                                     AND THULY.IS_KHONGTHA = 1
                                                     AND BIAN.ID = A.BIANID
                                                    ) THEN 'Không ra quyết định THA'
                                    --Đã thụ lý
                                      WHEN EXISTS ( SELECT 'x' FROM THA_THULY THULY
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                                    WHERE A.VUANID = THULY.VUANID 
                                                    	AND BIAN.ID = A.BIANID
                                                    ) THEN 'Đã thụ lý'
                                      ELSE 'Chưa giải quyết'  END 
                                      )      AS TINHTRANGGQ

                                              FROM ( SELECT ROW_NUMBER()
                                                            OVER(
                                                                ORDER BY A.ID DESC
                                                            )                   STT
                                                             , COUNT(*) OVER() AS COUNTALL
                                                          , A.ID                VUANID
                                                          , A.IDVUANHETHONG
                                                          , A.BA_MAVUAN         MAVUAN
                                                          , A.BA_TENVUAN        TENVUAN
                                                          , A.BA_NGAYVUAN       NGAYVUAN
                                                          , B.ID                BIANID
                                                          , B.MABICAN           MABIAN
                                                          , B.HOTEN             TENBIAN
                                                          , ahv.MAGIAIDOAN      MAGIAIDOAN
                                                          , ''                  GIAIDOANVUVIEC
                                                          , A.BA_ST_SO          SOBANAN
                                                          , A.BA_ST_NGAYBANAN   NGAYBANAN
                                                          , A.BA_ST_NGAYHIEULUC NGAYHIEULUC
                                                          --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
                                                          , ATD.HOTENBIAN_TOIDANH
												          , ST.NGAYBANAN_QD
												          , ST.SOBANAN_QD
												          , '' AS HINHPHAT_TONGHOP
												          , CASE WHEN TTL.SOTHULY IS NOT NULL THEN TO_CHAR(TTL.SOTHULY) || ' - ' || TO_CHAR(TTL.NGAYTHULY, 'DD/MM/YYYY')
												            	ELSE ''
												            END AS THA_SOTHULY_NGAYTHULY
												           , THABQ.QD_SO THA_QD_SO
												           , THA_BIANOLD.ID BIANIDOLD
												           , THA_BIANOLD.VUANID VUANIDOLD
												           --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
                                                            FROM ( SELECT ID
                                                                        , BA_MAVUAN
                                                                        , BA_TENVUAN
                                                                        , BA_ST_SO
                                                                        , BA_ST_NGAYBANAN
                                                                        , BA_ST_NGAYHIEULUC
                                                                        , BA_NGAYVUAN
                                                                        , IDVUANHETHONG
                                                                        
                                                                          FROM THA_VUAN
                                                                   WHERE ISHETHONG = 0
                                                                         AND TOAANID = TOA_AN_ID
                                                                         AND ( MA_VU_AN = '' OR MA_VU_AN IS NULL
                                                                               OR ( LOWER(BA_MAVUAN) LIKE ( '%' || LOWER(MA_VU_AN) ||'%' ) ) )
                                                                         AND ( TEN_VU_AN = ''OR TEN_VU_AN IS NULL
                                                                               OR ( LOWER(BA_TENVUAN) LIKE ( '%' || LOWER(TEN_VU_AN) || '%' ) ) )
                                                                 ) A
                                                            INNER JOIN ( SELECT ID
                                                                              , MABICAN
                                                                              , B.HOTEN
                                                                              , VUANID
                                                                              , SOCMND
                                                                              , UYTHAC_DETAIL_ID
                                                                                      FROM THA_BIAN B
                                                                         WHERE ( MA_BI_AN = ''
                                                                                 OR MA_BI_AN IS NULL
                                                                                 OR ( LOWER(B.MABICAN) LIKE ( '%' || LOWER(MA_BI_AN) || '%' ) ) )
                                                                               AND ( TEN_BI_AN = ''
                                                                                     OR TEN_BI_AN IS NULL
                                                                                     OR ( LOWER(B.HOTEN) LIKE ( '%' || LOWER(TEN_BI_AN) || '%' ) ) )
                                                        --SOCMND
                                                                               AND ( V_SOCMND = ''
                                                                                     OR V_SOCMND IS NULL
                                                                                     OR ( LOWER(B.SOCMND) LIKE ( '%' || LOWER(V_SOCMND) || '%' ) ) )
                                                                       ) B ON A.ID = B.VUANID
                                                                       --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
                                                            LEFT JOIN THA_THULY TTL ON TTL.VUANID = A.ID AND TTL.BIANID = B.ID
                                                            LEFT JOIN THA_BIAN_QUYETDINH THABQ ON THABQ.VUANID = A.ID AND THABQ.BIANID = B.ID
                                                            LEFT JOIN THA_UYTHAC_DETAIL tud ON tud.ID = B.UYTHAC_DETAIL_ID
                                                            LEFT JOIN THA_UYTHAC_QUYETDINH tuq ON tuq.ID = tud.QD_UYTHACTHA_ID AND tud.BIANID = tuq.BIANID
                                                            LEFT JOIN THA_BIAN THA_BIANOLD ON THA_BIANOLD.ID = tuq.BIANID AND tuq.VUANID = THA_BIANOLD.VUANID
                                                            LEFT JOIN (
										                        SELECT
										                            A.ID AS BANANID,
										                            A.VUANID,
										                            A.NGAYBANAN,
										                            COALESCE(PTBA.NGAYBANAN, PTQD.NGAYQD, A.NGAYBANAN, ASQV.NGAYQD) NGAYBANAN_QD,
										                            (A.NGAYBANAN + 14) AS NGAYHIEULUCST,
										                            A.SOBANAN,
										                            COALESCE(PTBA.SOBANAN, PTQD.SOQUYETDINH, A.SOBANAN, ASQV.SOQUYETDINH) SOBANAN_QD
										                        FROM AHS_SOTHAM_BANAN A
										                        LEFT JOIN (
										                        	SELECT ASQV.* FROM
										                        	AHS_SOTHAM_QUYETDINH_VUAN ASQV
										                        	INNER JOIN DM_QD_QUYETDINH DMQD1 ON DMQD1.ID = ASQV.QUYETDINHID AND DMQD1.KET_THUC = 1
										                        ) ASQV ON A.VUANID = ASQV.VUANID
										                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID = A.VUANID
										                        LEFT JOIN (
										                        	SELECT PTQD.* FROM
										                        	AHS_PHUCTHAM_QUYETDINH_VUAN PTQD 
										                        	INNER JOIN DM_QD_QUYETDINH DMQD2 ON DMQD2.ID = PTQD.QUYETDINHID AND DMQD2.KET_THUC = 1
										                        ) PTQD ON PTQD.VUANID = A.VUANID
--										                        WHERE (
--										                              A.NGAYBANAN <= CURRENT_DATE - 31
--										                              OR PTBA.ID IS NOT NULL
--										                              OR PTQD.QUYETDINHID IN (79, 80, 127, 128, 203, 205, 324)
--										                          )
										                    ) ST ON ST.VUANID = THA_BIANOLD.IDVUANHETHONG
										                    LEFT JOIN AHS_VUAN ahv ON ST.VUANID = ahv.ID
										                    --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
										                    LEFT JOIN (
										                    	SELECT 
																	a.ID,
																	a.VUANID,
																	CASE 
																		WHEN c.TENTOIDANH IS NULL THEN a.HOTEN
																		ELSE a.HOTEN || ' - ' || c.TENTOIDANH
																	END AS HOTENBIAN_TOIDANH
																FROM
																	THA_BIAN a
																LEFT JOIN THA_SOTHAM_CAOTRANG_DIEULUAT c ON
																	a.ID = c.BICANID AND a.VUANID = c.VUANID AND c.ISMAIN = 1
										                    ) ATD ON ATD.ID = THA_BIANOLD.ID AND ATD.VUANID = THA_BIANOLD.VUANID
										                    --VNPT- Lưu Quang Huy - trả thêm thông tin ds THA thong tin bi cao - 17-09-2025 13:30
                                                     WHERE  1 = 1
                                                     AND ( SO_BAN_AN = ''
                                                               OR SO_BAN_AN IS NULL
                                                               OR ( LOWER(ST.SOBANAN_QD) LIKE ( '%' || LOWER(SO_BAN_AN) || '%' ) ))
                                                           AND ( NGAY_BAN_AN IS NULL
                                                                 OR NGAY_BAN_AN = ''
                                                                 OR NGAY_BAN_AN >= ST.NGAYBANAN_QD )
                                                            AND (
                                                                 (
                                                                    TRANGTHAIGQ = 1 AND (
                                                                        EXISTS (
                                                                            SELECT 'x'
                                                                            FROM THA_BIAN_QUYETDINH QD
                                                                            INNER JOIN THA_BIAN BIAN ON BIAN.ID = QD.BIANID
                                                                            WHERE A.ID = QD.VUANID
                                                                              AND B.ID = BIAN.ID
                                                                              AND TOA_AN_ID  <>  QD.TOA_GIAIQUYET_ID
                                                                              AND (V_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                                                              AND (V_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                                                                        )
                                                                        OR EXISTS (
                                                                            SELECT 'x'
                                                                            FROM THA_CVDON_KQGQ KQ
                                                                            INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID                                                                          
                                                                            WHERE A.ID = KQ.VUANID
                                                                           	  AND B.ID = BIAN.ID
                                                                              AND TOA_AN_ID  <>  KQ.TOA_GIAIQUYET_ID
                                                                              AND (V_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                                                              AND (V_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                                                                        )
                                                                    )
                                                                )                    
                                                                OR ( TRANGTHAIGQ = 0 AND (
                                                                        NOT EXISTS (
                                                                            SELECT 'x'
                                                                            FROM THA_BIAN_QUYETDINH QD
                                                                            INNER JOIN THA_BIAN BIAN ON BIAN.ID = QD.BIANID
                                                                            WHERE A.ID = QD.VUANID
                                                                              AND B.ID = BIAN.ID
                                                                              AND TOA_AN_ID  <>  QD.TOA_GIAIQUYET_ID
                                                                              AND (V_TUNGAY IS NULL OR QD.QD_NGAY >= VV_TUNGAY)
                                                                              AND (V_DENNGAY IS NULL OR QD.QD_NGAY <= VV_DENNGAY)
                                                                        )
                                                                        AND NOT EXISTS (
                                                                            SELECT 'x'
                                                                            FROM THA_CVDON_KQGQ KQ
                                                                            INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                                                            WHERE A.ID = KQ.VUANID
                                                                              AND B.ID = BIAN.ID
                                                                              AND TOA_AN_ID  <>  KQ.TOA_GIAIQUYET_ID
                                                                              AND (V_TUNGAY IS NULL OR KQ.NGAYVANBAN >= VV_TUNGAY)
                                                                              AND (V_DENNGAY IS NULL OR KQ.NGAYVANBAN <= VV_DENNGAY)
                                                                        ))
                                                                )
                                                            ) 
                                                            AND (
                                                            ( (P_TRANGTHAI IS NULL
                                                                 OR P_TRANGTHAI = 0)
                                                                 AND ( V_TUNGAY IS NULL
                                                                       OR ST.NGAYBANAN_QD >= VV_TUNGAY )
                                                                 AND ( V_DENNGAY IS NULL
                                                                       OR ST.NGAYBANAN_QD <= VV_DENNGAY ) )
                                                           OR ( P_TRANGTHAI = 1
                                                                AND NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_THULY THULY
                                                                      WHERE A.ID = THULY.VUANID
                                                                            AND B.ID = THULY.BIANID
                                                                               )
                                                                AND ( V_TUNGAY IS NULL
                                                                      OR A.BA_ST_NGAYBANAN >= VV_TUNGAY )
                                                                AND ( V_DENNGAY IS NULL
                                                                      OR A.BA_ST_NGAYBANAN <= VV_DENNGAY ) )
            ------not exists (select 'x' from tha_thuly where  vuanid = a.vuanid)
                          ---đã giải quyết
                                ----đã thụ lý
                                                           OR ( P_TRANGTHAI = 2
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_THULY THULY
                                                                  WHERE A.ID = THULY.VUANID
                                                                        AND B.ID = THULY.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR THULY.NGAYTHULY >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                                           )
                                 --ko có qd THA
                                                                AND NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_UYTHAC_DETAIL UYTHAC
                                                                                       INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                      WHERE BIAN.ID = UYTHAC.BIANID
                                                                               )

                                --ko có GV CV/đơn yc THA
                                                                AND NOT EXISTS ( SELECT 'x'
                                                                                       FROM THA_CVDON_KQGQ KQ
                                                                      WHERE A.ID = KQ.VUANID
                                                                            AND B.ID = KQ.BIANID
                                                                               ) )
                                 ----đã có qd THA
                                                           OR ( P_TRANGTHAI = 3
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_BIAN_QUYETDINH QD
                                                                  WHERE A.ID = QD.VUANID
                                                                        AND B.ID = QD.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR QD.QD_NGAY >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR QD.QD_NGAY <= VV_DENNGAY )
                                                                           ) )
                                ----đã có QĐ ủy thác THA
                                                           OR ( P_TRANGTHAI = 4
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                                  WHERE A.ID = UYTHAC.VUANID
                                                                        AND B.ID = UYTHAC.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                                           ) )
                                ----đã GV CV/đơn yc THA
                                                           OR ( P_TRANGTHAI = 5
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_CVDON_KQGQ KQ
                                                                  WHERE A.ID = KQ.VUANID
                                                                        AND B.ID = KQ.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                           ) )
                                                           OR ( P_TRANGTHAI = 6
                                                                AND (
             --đã có QĐ ủy thác THA
                                                                 EXISTS ( SELECT 'x'
                                                                                   FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                                                   INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                    WHERE A.ID = UYTHAC.VUANID
                                                                          AND BIAN.ID = UYTHAC.BIANID
                                                                          AND ( V_TUNGAY IS NULL
                                                                                OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                                          AND ( V_DENNGAY IS NULL
                                                                                OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                                             )
                                 --THULY
                                                                      OR EXISTS ( SELECT 'x'
                                                                             FROM THA_THULY THULY
                                                                             INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                 WHERE A.ID = THULY.VUANID
                                                                       AND BIAN.ID = THULY.BIANID
                                                                       AND ( V_TUNGAY IS NULL
                                                                             OR THULY.NGAYTHULY >= VV_TUNGAY )
                                                                       AND ( V_DENNGAY IS NULL
                                                                             OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                                                )   
                            --đã GV CV/đơn yc THA
                                                                      OR EXISTS ( SELECT 'x'
                                                                             FROM THA_CVDON_KQGQ KQ
                                                                             INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                 WHERE A.ID = KQ.VUANID
                                                                       AND BIAN.ID = KQ.BIANID
                                                                       AND ( V_TUNGAY IS NULL
                                                                             OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                       AND ( V_DENNGAY IS NULL
                                                                             OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                                )
                            --  QĐ tha
                                                                      OR EXISTS ( SELECT 'x'
                                                                             FROM THA_BIAN_QUYETDINH QD
                                                                             INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
                                                                 WHERE A.ID = QD.VUANID
                                                                       AND BIAN.ID = QD.BIANID
                                                                       AND ( V_TUNGAY IS NULL
                                                                             OR QD.QD_NGAY >= VV_TUNGAY )
                                                                       AND ( V_DENNGAY IS NULL
                                                                             OR QD.QD_NGAY <= VV_DENNGAY )
                                                                                ) ) )
                                                      OR (
                                                      --VNPT- Lưu Quang Huy - thêm filter trường hợp không THA - 18-09-2025 10:00
									                        P_TRANGTHAI = 7
									                        AND (
									                            EXISTS (
									                                SELECT 'x'
									                                FROM THA_THULY TTL
									                                INNER JOIN THA_BIAN BIAN ON B.ID = BIAN.ID
									                                WHERE A.ID = TTL.VUANID
									                                  AND BIAN.ID = TTL.BIANID
									                                  AND TTL.IS_KHONGTHA = 1
									                                  AND (V_TUNGAY IS NULL OR TTL.NGAYTHONGKE >= VV_TUNGAY)
									                                  AND (V_DENNGAY IS NULL OR TTL.NGAYTHONGKE <= VV_DENNGAY)
									                            )
									                        )
									                    )
									                    )
                                                   ) A
                           WHERE A.STT >= MININDEX
                                 AND A.STT <= MAXINDEX;
    END THA_BIAN_GETANNGOAIHT;
   
    PROCEDURE THA_UYTHACDETAIL_GETINFO (
        V_VUANID  IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT ROW_NUMBER()
                                  OVER(
                                                  ORDER BY A.NGAYUYTHAC DESC
                                  )                 STT
                                , A.ID
                                , QD.MAQD
                                , QD.SOQD
                                , QD.TENQD
                                , QD.TOAANUYTHACID
                                , TOA_UYTHAC.MA_TEN TENTOAANUYTHAC
                                , A.LOAIUYTHAC
                                , CASE
                                                  WHEN A.LOAIUYTHAC = 0 THEN u'L\00fd do'
                                                  WHEN A.LOAIUYTHAC = 1 THEN u'Kh\00e1c'
                                    END               AS TRUONGHOPUYTHAC
                                , A.LYDOID
                                , NVL(B.TEN, '')    TENLYDO
                                , A.NGAYUYTHAC
                                , A.NGUOINHAP
                                , CB.HOTEN          TENNGUOINHAP
                                , A.TRANGTHAI
                                , VA.BA_MAVUAN
                                , VA.BA_TENVUAN
                                , BA.MABICAN
                                , BA.HOTEN          TENBICAN
                                , QD.VUANID
                                              FROM ( SELECT ID
                                                          , BIANID
                                                          , NGAYUYTHAC
                                                          , LOAIUYTHAC
                                                          , LYDOID
                                                          , QD_UYTHACTHA_ID
                                                          , NGUOINHAP
                                                          , NVL(TRANGTHAI, 0) TRANGTHAI
                                                     FROM THA_UYTHAC_DETAIL 
                --where ID=CurrDetailUyThacID
                                                   ) A
                                              INNER JOIN ( SELECT ID
                                                                , MAQD
                                                                , SOQD
                                                                , TENQD
                                                                , TOAANNHANUYTHACID
                                                                , TOAANUYTHACID
                                                                , BIANID
                                                                , VUANID
                                                           FROM THA_UYTHAC_QUYETDINH
                                                         ) QD ON QD.ID = A.QD_UYTHACTHA_ID
                                              LEFT JOIN ( SELECT ID
                                                               , MABICAN
                                                               , HOTEN
                                                               , VUANID
                                                               , IDVUANHETHONG
                                                               , IDBICANHETHONG
                                                          FROM THA_BIAN
                                                        ) BA ON QD.BIANID = BA.ID
                                              LEFT JOIN ( SELECT ID
                                                               , BA_MAVUAN
                                                               , BA_TENVUAN
                                                          FROM THA_VUAN
                                                        ) VA ON VA.ID = QD.VUANID
                                              LEFT JOIN ( SELECT ID
                                                               , MA_TEN
                                                          FROM DM_TOAAN
                                                        ) TOA_UYTHAC ON TOA_UYTHAC.ID = QD.TOAANUYTHACID
                                              LEFT JOIN ( SELECT ID
                                                               , HOTEN
                                                          FROM DM_CANBO
                                                        ) CB ON CB.ID = A.NGUOINHAP
                                              LEFT JOIN ( SELECT ID
                                                               , MA
                                                               , TEN
                                                          FROM DM_DATAITEM
                                                        ) B ON A.LYDOID = B.ID
                           WHERE QD.VUANID = V_VUANID;
    END THA_UYTHACDETAIL_GETINFO;
    
    PROCEDURE THA_UYTHAC_QD_GETALL (
        CURR_BIANID IN NUMBER
      , CURRETURN   OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT ROW_NUMBER()
                                  OVER(
                               ORDER BY A.NGAYQD DESC
                                  )                                   STT
                                , A.ID
                                , A.BIANID
                                , A.MAQD
                                , A.NGAYKY
                                , A.NGAYQD
                                , A.TENQD
                                , A.NGUOIKY
                                , CB.HOTEN                            TENNGUOIKY
                                , A.TOAANUYTHACID
                                , TOA_UYTHAC.MA_TEN                   TENTOAANUYTHAC
                                , A.TOAANNHANUYTHACID
                                , B.MA_TEN                            TENTOAANNHANUYTHAC
                                , A.HIEULUC_TUNGAY
                                , A.HIEULUC_DENNGAY
                                , A.VUANID
                                , COALESCE(UYTHACDETAIL.TRANGTHAI, 0) AS TRANGTHAI
                                ,A.TOA_GIAIQUYET_ID
                           FROM ( SELECT *
                                         FROM THA_UYTHAC_QUYETDINH
                                  WHERE BIANID = CURR_BIANID
                                )                 A
                           LEFT JOIN DM_CANBO          CB ON CB.ID = A.NGUOIKY
                           LEFT JOIN ( SELECT ID
                                            , MA_TEN
                                       FROM DM_TOAAN
                                     )                 TOA_UYTHAC ON TOA_UYTHAC.ID = A.TOAANUYTHACID
                           LEFT JOIN ( SELECT ID
                                            , MA_TEN
                                       FROM DM_TOAAN
                                     )                 B ON B.ID = A.TOAANNHANUYTHACID
                           LEFT JOIN THA_UYTHAC_DETAIL UYTHACDETAIL ON UYTHACDETAIL.QD_UYTHACTHA_ID = A.ID;
    END THA_UYTHAC_QD_GETALL;
   
    PROCEDURE DM_LYDOUYTHAC_SEARCH (
        SOLUONG   IN NUMBER
      , TEXTKEY   IN VARCHAR2
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT I.ID, I.MA, I.TEN
                                , ( ( 
                                        CASE SOCAP
                                          WHEN 2 THEN '...'
                                          WHEN 3 THEN '......'
                                          ELSE ''
                                      END
                                  ) || I.TEN ) MA_TEN
                                  FROM DM_DATAITEM I
                                  INNER JOIN DM_DATAGROUP G ON G.ID = I.GROUPID
                           WHERE G.MA = 'UYTHACTHA_LyDo'
                                 AND I.HIEULUC = 1
                                 AND I.ID != 970
                                 AND (TEXTKEY = '' OR LOWER(I.TEN) LIKE ( '%' || LOWER(TEXTKEY) || '%' ))
                                 AND (TEXTKEY = '' OR LOWER(I.MA) LIKE ( '%' || LOWER(TEXTKEY) || '%' )) 
                                 AND ROWNUM <= SOLUONG
                           ORDER BY I.ARRTHUTU;
    END DM_LYDOUYTHAC_SEARCH;
  
    PROCEDURE THA_GET_MATHULY_TUSINH (
        CURRETURN OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT THA_MATHULY_TUSINH_SEQ.NEXTVAL
                           FROM DUAL;
    END THA_GET_MATHULY_TUSINH;
  
    PROCEDURE THA_GET_MABIAN_TUSINH (
        CURRETURN OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT THA_MABIAN_TUSINH_SEQ.NEXTVAL
                           FROM DUAL;
    END THA_GET_MABIAN_TUSINH;
  
    PROCEDURE THA_UYTHAC_DETAIL_GETALL (
        CURRBIANID IN NUMBER
      , CURRETURN  OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT ROW_NUMBER() OVER(ORDER BY A.NGAYUYTHAC DESC)        STT
                                , A.ID
                                , QD.MAQD
                                , QD.TENQD
                                , A.LOAIUYTHAC
                                , CASE
                                                  WHEN A.LOAIUYTHAC = 0 THEN u'Ủy thác vì không thuộc thẩm quyền'
                                                  WHEN A.LOAIUYTHAC = 1 THEN CONCAT(u'', A.UYTHACKHAC)
                                    END      AS TRUONGHOPUYTHAC
                                , A.NGAYUYTHAC
                                , A.NGUOINHAP
                                , CB.HOTEN TENNGUOINHAP
                                , A.TRANGTHAI
                                ,A.TOA_GIAIQUYET_ID
                                ,A.QT_FILE_ID AS FILE_ID -- vnpt 180925
                                , CASE 
	                                WHEN A.TRANGTHAI = 3 THEN u'Bị án bị trả lại'
	                                ELSE u''
	                              END AS TRANGTHAIBIAN
                              FROM THA_UYTHAC_DETAIL A
                              INNER JOIN ( SELECT ID, MAQD, TENQD FROM THA_UYTHAC_QUYETDINH) QD ON QD.ID = A.QD_UYTHACTHA_ID
                              LEFT JOIN ( SELECT ID, HOTEN FROM DM_CANBO) CB ON CB.ID = A.NGUOINHAP
                              LEFT JOIN ( SELECT ID, MA, TEN FROM DM_DATAITEM) B ON A.LYDOID = B.ID
                           WHERE A.BIANID = CURRBIANID;
    END THA_UYTHAC_DETAIL_GETALL;
    
    
    PROCEDURE CHECK_EXIST_PHATTIEN (
    v_VUANID   IN  NUMBER,
    v_BIANID   IN  NUMBER,
    v_RESULT   OUT NUMBER   -- 1 = tồn tại, 0 = không tồn tại
) AS
    v_MAGIAIDOAN NUMBER;
BEGIN
    -- Lấy MAGIAIDOAN từ bảng AHS_VUAN
    SELECT MAGIAIDOAN 
      INTO v_MAGIAIDOAN
      FROM AHS_VUAN
     WHERE ID = v_VUANID;

    IF v_MAGIAIDOAN = 2 THEN
        SELECT CASE WHEN EXISTS (
                   SELECT 1
                   FROM AHS_SOTHAM_BANAN_DIEU_CHITIET ahdc
                   INNER JOIN AHS_SOTHAM_BANAN asb ON ahdc.BANANID = asb.ID
                   INNER JOIN DM_HINHPHAT dh ON ahdc.HINHPHATID = dh.ID
                   INNER JOIN AHS_BICANBICAO ab ON ab.ID = ahdc.BICANID
                   WHERE asb.VUANID = v_VUANID
                   	 AND ab.ID = v_BIANID
                     AND dh.MAHINHPHAT = 'PHATTIEN'
                     AND NOT EXISTS (
                         SELECT 1
                         FROM AHS_SOTHAM_BANAN_DIEU_CHITIET A1
                         INNER JOIN AHS_SOTHAM_BANAN C1 ON A1.BANANID = C1.ID
                         INNER JOIN DM_HINHPHAT DMH ON A1.HINHPHATID = DMH.ID
                         WHERE A1.VUANID = ahdc.VUANID
                           AND A1.BICANID = ahdc.BICANID
                           AND C1.VUANID = asb.VUANID
                           AND asb.ID = C1.ID
                           AND DMH.MAHINHPHAT <> 'PHATTIEN'
                     )
               )
               THEN 1 ELSE 0 END
          INTO v_RESULT
        FROM dual;

    ELSIF v_MAGIAIDOAN = 3 THEN
        SELECT CASE WHEN EXISTS (
                   SELECT 1
                   FROM AHS_PHUCTHAM_BANAN_DIEU_CT ahdc
                   INNER JOIN AHS_PHUCTHAM_BANAN asb ON ahdc.BANANID = asb.ID
                   INNER JOIN DM_HINHPHAT dh ON ahdc.HINHPHATID = dh.ID
                   INNER JOIN AHS_BICANBICAO ab ON ab.ID = ahdc.BICANID          
                   WHERE asb.VUANID = v_VUANID
                   	 AND ab.ID = v_BIANID
                     AND dh.MAHINHPHAT = 'PHATTIEN'
                     AND NOT EXISTS (
                         SELECT 1
                         FROM AHS_PHUCTHAM_BANAN_DIEU_CT A1
                         INNER JOIN AHS_PHUCTHAM_BANAN C1 ON A1.BANANID = C1.ID
                         INNER JOIN DM_HINHPHAT DMH ON A1.HINHPHATID = DMH.ID
                         WHERE C1.ID = asb.ID
                           AND A1.BICANID = ahdc.BICANID
                           AND C1.VUANID = asb.VUANID
                           AND DMH.MAHINHPHAT <> 'PHATTIEN'
                     )
               )
               THEN 1 ELSE 0 END
          INTO v_RESULT
        FROM dual;
    ELSE
        v_RESULT := 0; -- các mã giai đoạn khác thì coi như không tồn tại
    END IF;
END;

-- vnpt - Lưu Quang Huy - lấy ds án phạt của bị án khi THA - 22/09/2025 14:25
PROCEDURE GET_THA_BIAN_QUYETDINH_ANPHAT (
        p_bian_id IN NUMBER,
        p_vuan_id IN NUMBER,
        CURRETURN  OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT ROW_NUMBER() OVER (ORDER BY NVL(a.BiCanDauVu, 0) DESC, a.id) stt--NVL(a.BiCanDauVu, 0) desc,a.NgayThamGia desc
                    , a.ID, a.HoTen, a.NamSinh, a.NGAYTHAMGIA, a.TamTru   
                    , NVL(a.LOAIDOITUONG,0) LOAIDOITUONG,NVL(a.BICANDAUVU,0) BICANDAUVU
                    , nvl(b.BiCaoID, 0) BiCaoSoTham_ID
                    , case when nvl(b.BiCaoID, 0)>0 then 1  when nvl(b.BiCaoID, 0)=0 then 0 end IsShow                     
                    , NVL(b.IsThamGiaPhienToa, 0) IsThamGiaPhienToa, NVL(b.AnPhi, 0) AnPhi
                    , NVL(b.IsDinhCHi, 0) IsDinhChi
                    , b.NgayNhanBanAn
                    , st.TOA_GIAIQUYET_ID
                from THA_BIAN a 
                    inner join THA_VUAN va on va.ID = a.VuAnID
                    left join THA_BIAN_QUYETDINH st on st.VuAnId = va.ID AND st.BIANID = a.ID
                    left join (select BanAnID, BiCaoID, IsThamGiaPhienToa, AnPhi, IsDinhchi, NgayNhanBanAN, TOA_GIAIQUYET_ID
                                from THA_SOTHAM_BANAN_BICAO)  b on a.Id = b.BiCaoID
                where a.VuAnID = p_vuan_id AND a.id = p_bian_id;
END GET_THA_BIAN_QUYETDINH_ANPHAT;
PROCEDURE THA_PT_BANAN_BICAO_GETBYVUANID
(
     vu_an_id in NUMBER,
     bi_an_id IN NUMBER
	 , curReturn    OUT   sys_refcursor
)
AS
BEGIN	
    OPEN curReturn FOR 
          select  ROW_NUMBER() OVER (ORDER BY NVL(a.BiCanDauVu, 0) DESC, a.id) stt--a.NgayThamGia desc) stt
             , a.ID BiCanID, a.HoTen
             , case when nvl(pt.BiCaoID , 0)>0 then 1 
                    when nvl(pt.BiCaoID , 0)=0 then 0 end IsShow
             , nvl(pt.BiCaoID , 0) BiCaoPT_ID, NVL( pt.IsDinhChi, 0) IsDinhChi
             , NVL(pt.IsThamGiaPhienToa, 0) IsThamGiaPhienToa
             , NVL(pt.AnPhi, 0) AnPhi , NVL(pt.IsDinhCHi, 0) IsDinhChi , pt.NgayNhanBanAn                
             , td.getalltoidanh
             , TENYEUCAU as NoiDung_KCKN
             ,a.TOA_GIAIQUYET_ID
             --, Decode(NGTGTTHOTEN, '' , TENYEUCAU,  '(' || NGTGTTHOTEN || ')' || TENYEUCAU) as NoiDung_KCKN 
             
          from THA_BIAN a 
          	   INNER JOIN THA_VUAN b ON a.VUANID = b.ID 
               left join  (select b.VuAnID, b.BiCAoID
                              , NVL(b.IsThamGiaPhienToa,0) IsThamGiaPhienToa, b.NgayNhanBanAn
                              , NVL(b.AnPHi,0) AnPhi , NVL(b.ISDinhChi,0) IsDinhChi  
                            from THA_PhucTHAM_BANAN_BICAO b
                            where b.VUANID = vu_an_id AND b.BiCAoID = bi_an_id) pt on pt.BiCaoID = a.ID
               LEFT JOIN (SELECT BICANID,LISTAGG(DM_BL_TD.TENTOIDANH,', ') WITHIN GROUP (ORDER BY ISMAIN) GETALLTOIDANH
                                FROM THA_PHUCTHAM_BANAN_DIEU_CT AHS_CT
                                    INNER JOIN (SELECT ID,TENTOIDANH FROM DM_BOLUAT_TOIDANH
                                                WHERE KHOAN IS NULL AND DIEM IS NULL) DM_BL_TD ON DM_BL_TD.ID = AHS_CT.TOIDANHID
                                WHERE HINHPHATID = 0
                                GROUP BY BICANID) TD ON TD.BICANID = A.ID
               LEFT JOIN (SELECT D.NGUOIKCID, TENYEUCAU
                          FROM AHS_SOTHAM_KHANGCAO D
                               LEFT JOIN (SELECT KHANGCAOID, LISTAGG(DM.TEN, '; ') WITHIN GROUP (ORDER BY '') TENYEUCAU
                                           FROM AHS_SOTHAM_KHANGCAO_YEUCAU YC
                                                LEFT JOIN (SELECT ID,TEN FROM DM_DATAITEM) DM ON DM.ID = YC.YEUCAUID
                                           GROUP BY KHANGCAOID) YCKCKN ON YCKCKN.KHANGCAOID = D.ID) NOIDUNGYEUCAU ON NOIDUNGYEUCAU.NGUOIKCID = a.IDBICANHETHONG 
--               LEFT JOIN (SELECT VUANID,TT.HOTEN NGTGTTHOTEN FROM AHS_SOTHAM_KHANGCAO D
--                            LEFT JOIN (SELECT ID, HOTEN FROM AHS_NGUOITHAMGIATOTUNG) TT ON TT.ID = D.NGUOIKCID
--                            LEFT JOIN (SELECT KHANGCAOID, LISTAGG(DM.TEN, '; ') WITHIN GROUP (ORDER BY '') TENYEUCAU
--                                        FROM AHS_SOTHAM_KHANGCAO_YEUCAU YC
--                                                LEFT JOIN (SELECT ID,TEN FROM DM_DATAITEM) DM ON DM.ID = YC.YEUCAUID 
--                                                 GROUP BY KHANGCAOID) NDYC ON NDYC.NGUOIKCID = TT.ID 
--                                           ) TGTT ON TGTT.VUANID = A.VUANID
                            
          where a.VUANID = vu_an_id AND a.ID = bi_an_id;
END THA_PT_BANAN_BICAO_GETBYVUANID;
PROCEDURE THA_GETCHITIET_BANGIAO
(
     v_VUVIECID in NUMBER,
     v_TOAANNHANID IN NUMBER,
     v_VUVIECLOAI IN VARCHAR, 
     curReturn    OUT   sys_refcursor
)
AS
BEGIN 
	OPEN curReturn FOR
	SELECT * FROM VUAN_BANGIAO_MAPPING VBM WHERE VBM.VUVIECID = v_VUVIECID AND VBM.TOAANNHANID = v_TOAANNHANID AND VBM.VUVIECLOAI = v_VUVIECLOAI;
END THA_GETCHITIET_BANGIAO;



END PKG_THA_GS;