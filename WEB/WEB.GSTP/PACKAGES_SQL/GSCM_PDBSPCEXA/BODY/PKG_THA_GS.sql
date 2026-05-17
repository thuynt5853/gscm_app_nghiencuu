--------------------------------------------------------
--  DDL for Package Body PKG_THA_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_THA_GS" AS
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
    PROCEDURE THA_BIAN_GETANHSTRONGHT_PAGING (
        TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , TRANGTHAI   IN NUMBER
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
        IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        MININDEX := PAGESIZE * ( PAGEINDEX - 1 ) + 1;
        MAXINDEX := PAGEINDEX * PAGESIZE;     
        --1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total    
   --------------------------------   
        OPEN CURRETURN FOR SELECT A.*
                                ,
                                 (CASE
                                    --Đã uỷ thác THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON  BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.BIANID = BIAN.IDBICANHETHONG
                                                  ) THEN 'Đã có QĐ ủy thác thi hành án'
                                    WHEN EXISTS (   SELECT 'x' FROM THA_CVDON_KQGQ KQ
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                                    WHERE A.BIANID = BIAN.IDBICANHETHONG) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
                                    --Đã ra QĐ THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_BIAN_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.BIANID = BIAN.IDBICANHETHONG) THEN 'Đã có QĐ thi hành án'
                                    --Đã thụ lý
                                      WHEN EXISTS ( SELECT 'x' FROM THA_THULY THULY
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                                    WHERE A.VUANID = THULY.VUANID AND A.BIANID = BIAN.IDBICANHETHONG ) THEN 'Đã thụ lý'
                                      ELSE 'Chưa giải quyết'  END )      AS TINHTRANGGQ
                      FROM ( SELECT ROW_NUMBER()
                                    OVER(
                                        ORDER BY A.NGAYHIEULUC DESC
                                    ) STT
                                  , COUNT(*) OVER () AS COUNTALL
                                  , A.*
                                    FROM ( (
    ------lay ds vu an , bi can theo an so tham
                                     SELECT DISTINCT
                A.ID IDVuAnHeThong,
                A.MAVUAN,
                A.TENVUAN,
                BC.ID                                                 BIANID,
                BC.MABICAN                                            MABIAN,
                BC.HOTEN                                              TENBIAN,
                A.MAGIAIDOAN,
                DECODE(A.MAGIAIDOAN, 1, 'Hồ sơ', 2, 'Sơ thẩm',
                       3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm', '') GIAIDOANVUVIEC
                       ,
                ST.SOBANAN,
                ST.NGAYBANAN,
                ST.NGAYHIEULUCST                                      NGAYHIEULUC
                ,
                THAVUAN.ID                                            VUANID
            FROM
                     (
                    SELECT
                        ID,
                        MAVUAN,
                        TENVUAN,
                        TOAPHUCTHAMID,
                        MAGIAIDOAN
                    FROM
                        AHS_VUAN
                    WHERE
                        ( MAGIAIDOAN = '2'
                          OR MAGIAIDOAN = '3' )
                        AND TOAANID = TOA_AN_ID
                        AND ( MA_VU_AN = '' OR (LOWER(MAVUAN) LIKE ('%'||LOWER(MA_VU_AN)||'%')))
                        AND ( TEN_VU_AN = '' OR (LOWER(TENVUAN) LIKE ('%'||LOWER(TEN_VU_AN)||'%')))
                ) A
                INNER JOIN (
                    SELECT
                        A.ID                 BANANID,
                        A.VUANID,
                        A.NGAYBANAN,
                        ( A.NGAYBANAN + 14 ) NGAYHIEULUCST,
                        A.SOBANAN
                    FROM
                        AHS_SOTHAM_BANAN            A
                        LEFT JOIN AHS_PHUCTHAM_BANAN          PTBA ON PTBA.VUANID = A.VUANID
                        LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD ON PTQD.VUANID = A.VUANID
                    WHERE
                            (SO_BAN_AN = '' OR ( LOWER(A.SOBANAN) LIKE ( '%'||LOWER(SO_BAN_AN )||'%')))
                        AND (ngay_ban_an is null or ngay_ban_an ='' or ngay_ban_an= a.NgayBanAn) 
                        AND ( A.NGAYBANAN <= CURRENT_DATE - 31
                              OR PTBA.ID IS NOT NULL
                              OR PTQD.QUYETDINHID IN (79,80,127,128,203,205,324))
                )                          ST ON ST.VUANID = A.ID
                LEFT JOIN THA_VUAN                   THAVUAN ON A.ID = THAVUAN.IDVUANHETHONG
                INNER JOIN (
                    SELECT
                        BANANID,
                        BICAOID
                    FROM
                        AHS_SOTHAM_BANAN_BICAO
                )                          STBC ON STBC.BANANID = ST.BANANID
                INNER JOIN (
                    SELECT
                        IDKCKN,
                        CONCAT(CONCAT(  LISTAGG(KC1ID, ',') WITHIN GROUP(ORDER BY KC1ID),
                                        LISTAGG(KC2ID, ',') WITHIN GROUP(ORDER BY KC2ID)),
                               LISTAGG(KNID, ',') WITHIN GROUP(ORDER BY KNID))                          AS KCKN,
                        ','||LISTAGG(BAPT, ',') WITHIN GROUP(ORDER BY BAPT)|| ','                       AS BAPT,
                        ','||LISTAGG(KETQUAPHUCTHAM, ',') WITHIN GROUP(ORDER BY BAPT)|| ','             AS KQPT,
                        ','||LISTAGG(RUTKC1TINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKC1TINHTRANG)|| ',' AS RUTKC1TINHTRANG,
                        ','||LISTAGG(RUTKC2TINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKC2TINHTRANG)|| ',' AS RUTKC2TINHTRANG,
                        ','||LISTAGG(RUTKNTINHTRANG, ',') WITHIN GROUP(ORDER BY RUTKNTINHTRANG)|| ','   AS RUTKNTINHTRANG,
                        ','||LISTAGG(NGAYKHANGCAO1, ',') WITHIN GROUP(ORDER BY NGAYKHANGCAO1)|| ','     AS NGAYKHANGCAO1,
                        ','||LISTAGG(NGAYKHANGCAO2, ',') WITHIN GROUP(ORDER BY NGAYKHANGCAO2)|| ','     AS NGAYKHANGCAO2,
                        ','||LISTAGG(NGAYKHANGNGHI, ',') WITHIN GROUP(ORDER BY NGAYKHANGNGHI)|| ','     AS NGAYKHANGNGHI,
                        ','||LISTAGG(ISQUAHAN1, ',') WITHIN GROUP(ORDER BY ISQUAHAN1)|| ','             AS ISQUAHAN1,
                        ','||LISTAGG(ISQUAHAN2, ',') WITHIN GROUP(ORDER BY ISQUAHAN2)|| ','             AS ISQUAHAN2,
                        ','||LISTAGG(GQ_ISCHAPNHAN1, ',') WITHIN GROUP(ORDER BY GQ_ISCHAPNHAN1)|| ','   AS GQ_ISCHAPNHAN1,
                        ','||LISTAGG(GQ_ISCHAPNHAN2, ',') WITHIN GROUP(ORDER BY GQ_ISCHAPNHAN2)|| ','   AS GQ_ISCHAPNHAN2,
                        ','||LISTAGG(QUYETDINHID, ',') WITHIN GROUP(ORDER BY QUYETDINHID)|| ','         AS QUYETDINHID
                    FROM
                        (
                            SELECT
                                BC.ID                 AS IDKCKN,
                                KC1.ID                AS KC1ID,
                                KC2.ID                AS KC2ID,
                                KQPT.KETQUAPHUCTHAMID AS KETQUAPHUCTHAM,
                                KN.ID                 AS KNID,
                                BAPT.ID               AS BAPT,
                                VUAN.TOAANID          AS TOAANID,
                                RKCST1.TINHTRANG      AS RUTKC1TINHTRANG,
                                RKCST2.TINHTRANG      AS RUTKC2TINHTRANG,
                                RKNST.TINHTRANG       AS RUTKNTINHTRANG,
                                KC1.NGAYKHANGCAO      AS NGAYKHANGCAO1,
                                KC2.NGAYKHANGCAO      AS NGAYKHANGCAO2,
                                KC1.ISQUAHAN          AS ISQUAHAN1,
                                KC2.ISQUAHAN          AS ISQUAHAN2,
                                KC1.GQ_ISCHAPNHAN     AS GQ_ISCHAPNHAN1,
                                KC2.GQ_ISCHAPNHAN     AS GQ_ISCHAPNHAN2,
                                KN.NGAYKN             AS NGAYKHANGNGHI,
                                PTQD.QUYETDINHID      AS QUYETDINHID
                            FROM
                                AHS_BICANBICAO              BC
                                LEFT JOIN AHS_SOTHAM_KHANGCAO KC1 ON KC1.NGUOIKCLOAI = 0 AND KC1.NGUOIKCID = BC.ID
                                LEFT JOIN AHS_SOTHAM_KHANGCAO KC2 ON KC1.NGUOIKCLOAI = 1 AND KC2.DSNGUOIBIKC LIKE '%'|| BC.ID|| ','|| '%'
                                LEFT JOIN AHS_SOTHAM_KHANGNGHI KN ON KN.DSNGUOIBIKN LIKE '%'||BC.ID||','||'%'
                                LEFT JOIN AHS_PHUCTHAM_BANAN_BICAO    BAPT ON BAPT.BICAOID = BC.ID
                                LEFT JOIN AHS_SOTHAM_RUTKHANGCAO      RKCST1 ON RKCST1.KHANGCAOID = KC1.ID
                                LEFT JOIN AHS_SOTHAM_RUTKHANGCAO      RKCST2 ON RKCST2.KHANGCAOID = KC2.ID
                                LEFT JOIN AHS_SOTHAM_RUTKHANGNGHI     RKNST ON RKNST.KHANGNGHIID = KN.ID
                                LEFT JOIN AHS_VUAN                    VUAN ON VUAN.ID = BC.VUANID
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQD ON PTQD.VUANID = BC.VUANID
                                LEFT JOIN (
                                    SELECT
                                        PTBC.BICAOID          AS BICAOID,
                                        PTBA.KETQUAPHUCTHAMID AS KETQUAPHUCTHAMID
                                    FROM
                                        AHS_PHUCTHAM_BANAN_BICAO PTBC
                                        LEFT JOIN AHS_PHUCTHAM_BANAN       PTBA ON PTBA.ID = PTBC.BANANID
                                ) KQPT ON KQPT.BICAOID = BC.ID
                            WHERE
                                VUAN.TOAANID = TOA_AN_ID
                        )
                    GROUP BY
                        IDKCKN
                )                          BCKCKN ON ( ( KCKN IS NULL )
                              OR ( BAPT IS NOT NULL
                                   AND BAPT NOT LIKE ( '%,,%' )
                                   AND KCKN IS NOT NULL
                                   AND NOT REGEXP_LIKE (KQPT,',3,|,4,|,22,|,46,|,47,|,48,|,49,'))
                              OR ( QUYETDINHID NOT LIKE ( '%,,%' )
                                   AND KCKN IS NOT NULL
                                   AND REGEXP_LIKE (QUYETDINHID ,',79,|,80,|,127,|,128,|,203,|,205,|,324,' ))
                              OR ( KCKN IS NOT NULL
                                   AND REGEXP_LIKE (RUTKC1TINHTRANG,',2,|,1,' ) ) 
                              OR ( KCKN IS NOT NULL
                                   AND REGEXP_LIKE( RUTKC2TINHTRANG,',2,|,1,' ) ) 
                              OR ( KCKN IS NOT NULL
                                   AND REGEXP_LIKE( RUTKNTINHTRANG,',2,|,1,' ) ) 
                              OR ( ( KCKN IS NOT NULL
                                     AND ISQUAHAN1 LIKE ( '%,1,%' )
                                     AND GQ_ISCHAPNHAN1 LIKE ( '%,1,%' ) )
                                   OR ( KCKN IS NOT NULL
                                        AND ISQUAHAN2 LIKE ( '%,1,%' )
                                        AND GQ_ISCHAPNHAN2 LIKE ( '%,1,%' ) ) ) )
                            AND BCKCKN.IDKCKN = STBC.BICAOID
                INNER JOIN (
                    SELECT
                        ID,
                        VUANID,
                        MABICAN,
                        HOTEN,SOCMND
                    FROM
                        AHS_BICANBICAO BC
                    WHERE
             (TEN_BI_AN ='' or  TEN_BI_AN is null or (LOWER(bc.HOTEN) LIKE  ('%' || LOWER(TEN_BI_AN) || '%')))  
             and ( MA_BI_AN='' OR MA_BI_AN is null OR (LOWER(bc.MABICAN) LIKE  ('%' || LOWER(MA_BI_AN) || '%')) )
             and ( V_SOCMND='' OR V_SOCMND is null OR (LOWER(bc.SOCMND) LIKE  ('%' || LOWER(V_SOCMND) || '%')) )             
                )                          BC ON BC.VUANID = A.ID
                        AND STBC.BICAOID = BC.ID
                LEFT JOIN (
                    SELECT
                        BANANID,
                        VUANID,
                        NGAYKN
                    FROM
                        AHS_SOTHAM_KHANGNGHI
                )                          KN ON ST.BANANID = KN.BANANID
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
                    FROM
                        AHS_SOTHAM_KHANGCAO
                )                          KC ON A.ID = KC.VUANID
                        AND KC.SOQDBA = ST.BANANID
                        AND KC.NGUOIKCID = BC.ID
            WHERE
                ( QDBC.LOAIQDID IS NULL
                  OR ( QDBC.LOAIQDID != 3
                       AND QDBC.LOAIQDID != 4 ) )
           )
            ) A
                             WHERE
                       --tình trạng giải quyết  
  ---tất cả
                              ( ( TRANGTHAI IS NULL
                                       OR TRANGTHAI = 0 )
                                     AND ( V_TUNGAY IS NULL
                                           OR A.NGAYBANAN >= VV_TUNGAY )
                                     AND ( V_DENNGAY IS NULL
                                           OR A.NGAYBANAN <= VV_DENNGAY ) )
  ---chưa giải quyết
                                   OR ( TRANGTHAI = 1
                                        AND NOT EXISTS ( SELECT 'x'
                                                               FROM THA_THULY THULY
                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                              WHERE A.VUANID = THULY.VUANID
                                                    AND BIAN.ID = THULY.BIANID
                                                       )
                                        AND ( V_TUNGAY IS NULL
                                              OR A.NGAYBANAN >= VV_TUNGAY )
                                        AND ( V_DENNGAY IS NULL
                                              OR A.NGAYBANAN <= VV_DENNGAY ) )
  ------not exists (select 'x' from tha_thuly where  vuanid = a.vuanid)
  ---đã giải quyết
        ----đã thụ lý
                                   OR ( TRANGTHAI = 2
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_THULY THULY
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = THULY.VUANID
                                                AND BIAN.ID = THULY.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR THULY.NGAYTHULY >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                   )
        
      --ko có qd THA detail
                                        AND NOT EXISTS ( SELECT 'x'
                                                               FROM THA_UYTHAC_DETAIL UYTHAC
                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                              WHERE BIAN.ID = UYTHAC.BIANID
                                                       )
        -- ko có gv cv/đơn yc THA
                                        AND NOT EXISTS ( SELECT 'x'
                                                               FROM THA_CVDON_KQGQ KQ
                                                               INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                              WHERE A.VUANID = KQ.VUANID
                                                    AND BIAN.ID = KQ.BIANID
                                                       ) )
        ----đã có qd THA
                                   OR ( TRANGTHAI = 3
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_BIAN_QUYETDINH QD
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = QD.VUANID
                                                AND BIAN.ID = QD.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR QD.QD_NGAY >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR QD.QD_NGAY <= VV_DENNGAY )
                                                   ) )
        ----đã có QĐ ủy thác THA
                                   OR ( TRANGTHAI = 4
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = UYTHAC.VUANID
                                                AND BIAN.ID = UYTHAC.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                   ) )
        ----đã GV CV/đơn yc THA
                                   OR ( TRANGTHAI = 5
                                        AND EXISTS ( SELECT 'x'
                                                       FROM THA_CVDON_KQGQ KQ
                                                       INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                          WHERE A.VUANID = KQ.VUANID
                                                AND BIAN.ID = KQ.BIANID
                                                AND ( V_TUNGAY IS NULL
                                                      OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                AND ( V_DENNGAY IS NULL
                                                      OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                   ) )
---Đã giải quyết bao gồm đã thụ lý or có qđ tha or có qd ủy thác THA
                                   OR ( TRANGTHAI = 6
                                        AND (
--đã có QĐ ủy thác THA
                                         EXISTS ( SELECT 'x'
                                                           FROM THA_UYTHAC_QUYETDINH UYTHAC
                                                           INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                            WHERE A.VUANID = UYTHAC.VUANID
                                                  AND BIAN.ID = UYTHAC.BIANID
                                                  AND ( V_TUNGAY IS NULL
                                                        OR UYTHAC.NGAYQD >= VV_TUNGAY )
                                                  AND ( V_DENNGAY IS NULL
                                                        OR UYTHAC.NGAYQD <= VV_DENNGAY )
                                                     )
         --THULY
                                              OR EXISTS ( SELECT 'x'
                                                     FROM THA_THULY THULY
                                                     INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                         WHERE A.VUANID = THULY.VUANID
                                               AND BIAN.ID = THULY.BIANID
                                               AND ( V_TUNGAY IS NULL
                                                     OR THULY.NGAYTHULY >= VV_TUNGAY )
                                               AND ( V_DENNGAY IS NULL
                                                     OR THULY.NGAYTHULY <= VV_DENNGAY )
                                                        )   
    --đã GV CV/đơn yc THA
                                              OR EXISTS ( SELECT 'x'
                                                     FROM THA_CVDON_KQGQ KQ
                                                     INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                         WHERE A.VUANID = KQ.VUANID
                                               AND BIAN.ID = KQ.BIANID
                                               AND ( V_TUNGAY IS NULL
                                                     OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                               AND ( V_DENNGAY IS NULL
                                                     OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                        )
    --  QĐ tha
                                              OR EXISTS ( SELECT 'x'
                                                     FROM THA_BIAN_QUYETDINH QD
                                                     INNER JOIN THA_BIAN BIAN ON A.BIANID = BIAN.IDBICANHETHONG
                                         WHERE A.VUANID = QD.VUANID
                                               AND BIAN.ID = QD.BIANID
                                               AND ( V_TUNGAY IS NULL
                                                     OR QD.QD_NGAY >= VV_TUNGAY )
                                               AND ( V_DENNGAY IS NULL
                                                     OR QD.QD_NGAY <= VV_DENNGAY )
                                                        ) ) )
                           ) A
                       WHERE A.STT >= MININDEX
                             AND A.STT <= MAXINDEX
                       ORDER BY A.STT;
    END THA_BIAN_GETANHSTRONGHT_PAGING;
    PROCEDURE THA_BIAN_GETANNGOAIHT (
        TOA_AN_ID   IN NUMBER
      , MA_BI_AN    IN NVARCHAR2
      , TEN_BI_AN   IN NVARCHAR2
      , MA_VU_AN    IN NVARCHAR2
      , TEN_VU_AN   IN NVARCHAR2
      , SO_BAN_AN   IN VARCHAR2
      , NGAY_BAN_AN IN DATE
      , TRANGTHAI   IN NUMBER
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
                                                    WHERE A.VUANID = UYTHAC.VUANID
                                                  ) THEN 'Đã có QĐ ủy thác thi hành án'
                                    WHEN EXISTS (   SELECT 'x' FROM THA_CVDON_KQGQ KQ
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = KQ.BIANID
                                                    WHERE A.VUANID = KQ.VUANID) THEN 'Đã có GQ đơn/CV yêu cầu thi hành án'
                                    --Đã ra QĐ THA
                                    WHEN EXISTS (   SELECT 'x' FROM THA_BIAN_QUYETDINH UYTHAC
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = UYTHAC.BIANID
                                                    WHERE A.VUANID = UYTHAC.VUANID) THEN 'Đã có QĐ thi hành án'
                                    --Đã thụ lý
                                      WHEN EXISTS ( SELECT 'x' FROM THA_THULY THULY
                                                    INNER JOIN THA_BIAN BIAN ON BIAN.ID = THULY.BIANID
                                                    WHERE A.VUANID = THULY.VUANID ) THEN 'Đã thụ lý'
                                      ELSE 'Chưa giải quyết'  END )      AS TINHTRANGGQ
                               
                                              FROM ( SELECT ROW_NUMBER()
                                                            OVER(
                                                                ORDER BY A.BA_ST_NGAYHIEULUC DESC
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
                                                          , '0'                 MAGIAIDOAN
                                                          , ''                  GIAIDOANVUVIEC
                                                          , A.BA_ST_SO          SOBANAN
                                                          , A.BA_ST_NGAYBANAN   NGAYBANAN
                                                          , A.BA_ST_NGAYHIEULUC NGAYHIEULUC
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
                                                     WHERE ( ( SO_BAN_AN = ''
                                                               OR SO_BAN_AN IS NULL
                                                               OR ( LOWER(A.BA_ST_SO) LIKE ( '%' || LOWER(SO_BAN_AN) || '%' ) ) )
                                                             OR ( NGAY_BAN_AN IS NULL
                                                                  OR A.BA_ST_NGAYBANAN >= NGAY_BAN_AN ) )
                                                           AND ( NGAY_BAN_AN IS NULL
                                                                 OR NGAY_BAN_AN = ''
                                                                 OR NGAY_BAN_AN = A.BA_ST_NGAYBANAN )
                                                           AND ( TRANGTHAI IS NULL
                                                                 OR TRANGTHAI = 0
                                                                 AND ( V_TUNGAY IS NULL
                                                                       OR A.BA_ST_NGAYBANAN >= VV_TUNGAY )
                                                                 AND ( V_DENNGAY IS NULL
                                                                       OR A.BA_ST_NGAYBANAN <= VV_DENNGAY ) )
                                                           OR ( TRANGTHAI = 1
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
                                                           OR ( TRANGTHAI = 2
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
                                                           OR ( TRANGTHAI = 3
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
                                                           OR ( TRANGTHAI = 4
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
                                                           OR ( TRANGTHAI = 5
                                                                AND EXISTS ( SELECT 'x'
                                                                               FROM THA_CVDON_KQGQ KQ
                                                                  WHERE A.ID = KQ.VUANID
                                                                        AND B.ID = KQ.BIANID
                                                                        AND ( V_TUNGAY IS NULL
                                                                              OR KQ.NGAYVANBAN >= VV_TUNGAY )
                                                                        AND ( V_DENNGAY IS NULL
                                                                              OR KQ.NGAYVANBAN <= VV_DENNGAY )
                                                                           ) )
                                                           OR ( TRANGTHAI = 6
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
                              FROM THA_UYTHAC_DETAIL A
                              INNER JOIN ( SELECT ID, MAQD, TENQD FROM THA_UYTHAC_QUYETDINH) QD ON QD.ID = A.QD_UYTHACTHA_ID
                              LEFT JOIN ( SELECT ID, HOTEN FROM DM_CANBO) CB ON CB.ID = A.NGUOINHAP
                              LEFT JOIN ( SELECT ID, MA, TEN FROM DM_DATAITEM) B ON A.LYDOID = B.ID
                           WHERE A.BIANID = CURRBIANID;
    END THA_UYTHAC_DETAIL_GETALL;
END PKG_THA_GS;
