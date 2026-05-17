--------------------------------------------------------
--  DDL for Package Body PKG_STPT_APS_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_APS_GS" AS

    PROCEDURE APS_DON_SEARCH (
        V_CAPXETXULOGIN             IN VARCHAR2,
        VDONVIID                    IN VARCHAR2,
        VTENVIEC                    IN VARCHAR2,
        VLOAIHINHDOANHNGHIEP        IN VARCHAR2,
        VMAVIEC                     IN VARCHAR2,
        VDUONGSU_NGUOITHAMGIATOTUNG IN VARCHAR2,
        VCAPXETXU                   IN VARCHAR2,
        VTOAXETXU                   IN VARCHAR2,
        VTINHTRANGTHULY             IN VARCHAR2,
        VTUNGAYTHULY                IN VARCHAR2,
        VDENNGAYTHULY               IN VARCHAR2,
        VSOTHULY                    IN VARCHAR2,
        VTINHTRANGGQ                IN VARCHAR2,
        VTUNGAYTINHTRANGGQ          IN VARCHAR2,
        VDENNGAYTINHTRANGGQ         IN VARCHAR2,
        VTHAMPHAN                   IN VARCHAR2,
        VTHOIHANGQ                  IN VARCHAR2,
        VSOQD                       IN VARCHAR2,
        VNGAYQD                     IN VARCHAR2,
        VTHUKY                      IN VARCHAR2,
        VGQDON                      IN VARCHAR2,
        VUYTHACTUPHAP               IN VARCHAR2,
        VPTRUTKINHNGHIEM            IN VARCHAR2,
        VCHECKTK                    IN NUMBER,
        V_TRANGTHAIVUAN             IN NUMBER,
        V_VAITRO_THAMPHAN           IN VARCHAR2,
        V_CHECK_HOAGIAI             IN NUMBER, 
        PAGE_INDEX                  IN INT,
        PAGE_SIZE                   IN INT,
        CURRETURN                   OUT SYS_REFCURSOR
    ) IS

        TOTALITEM        NUMBER;
        MININDEX         NUMBER;
        MAXINDEX         NUMBER;
        HOSO             NUMBER DEFAULT 1;
        SOTHAM           NUMBER DEFAULT 2;
        PHUCTHAM         NUMBER DEFAULT 3;
        VV_NGAYTHULY_TU  DATE;
        VV_NGAYTHULY_DEN DATE;
        V_TABLE_TP       T_QUYETDINH_EXT;
        VV_TUNGAY_GQ     DATE;
        VV_DENNGAY_GQ    DATE;
        V_TABLE_PT       T_QUYETDINH;
        V_TABLE_BC       T_BICANBICAO_EXT;
        V_TABLE_BC_KC    T_BICANBICAO_EXT;
        V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-12102023-tamnc
    BEGIN
    -- Giai đoạn vụ án/vụ việc
    -- HOSO = 1;
    -- SOTHAM = 2;
    -- PHUCTHAM = 3;
    -- THULYGDT = 4;
    -- DINHCHI = 5;

    -- PhanCongTP=0 Tất cả
    -- PhanCongTP=1 Chưa phân công
    -- PhanCongTP=2 Đã phân công
        MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
        MAXINDEX := PAGE_INDEX * PAGE_SIZE;
        V_TABLE_TP := T_QUYETDINH_EXT();
        V_TABLE_PT := T_QUYETDINH();
        V_TABLE_BC := T_BICANBICAO_EXT();
        V_TABLE_BC_KC := T_BICANBICAO_EXT();
        V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-12102023-tamnc
        IF ( VTUNGAYTHULY IS NOT NULL ) THEN
            VV_NGAYTHULY_TU := TO_DATE(TRIM(VTUNGAYTHULY)
                                       || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( VDENNGAYTHULY IS NOT NULL ) THEN
            VV_NGAYTHULY_DEN := TO_DATE(TRIM(VDENNGAYTHULY)
                                        || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( VTUNGAYTINHTRANGGQ IS NOT NULL ) THEN
            VV_TUNGAY_GQ := TO_DATE(TRIM(VTUNGAYTINHTRANGGQ)
                                    || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( VDENNGAYTINHTRANGGQ IS NOT NULL ) THEN
            VV_DENNGAY_GQ := TO_DATE(TRIM(VDENNGAYTINHTRANGGQ)
                                     || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;


   --THAMPHAN --TOANCAU-12102023-tamnc
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM APS_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,7 MAGIAIDOAN
            FROM  APS_KCKNQDK_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TP
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID
                FROM
                    (
                        SELECT
                            DONID,
                            FIRST_VALUE(ID)
                            OVER(PARTITION BY DONID
                                 ORDER BY
                                     NGAYNHANPHANCONG DESC
                            ) ID
                        FROM
                            APS_DON_THAMPHAN
                        WHERE
                            MAVAITRO != 'VTTP_GIAIQUYETDON'
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID
            ) TTS;

        SELECT
            R_QUYETDINH(TTS.DONID, TTS.ID, TTS.MA)
        BULK COLLECT
        INTO V_TABLE_PT
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID,
                    TT.MA
                FROM
                    (
                        SELECT
                            PQD.DONID,
                            FIRST_VALUE(PQD.ID)
                            OVER(PARTITION BY PQD.DONID, QDL.MA
                                 ORDER BY
                                     PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                            ) ID,
                            QDL.MA
                        FROM
                            APS_KCKNQDK_PHUCTHAM_QUYETDINH PQD
                            LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PQD.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID,
                    TT.MA
            ) TTS;

        SELECT
            R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC
        FROM
            (
                SELECT
                    BC.ID,
                    BC.DONID,
                    BC.TENDUONGSU,
                    BC.TUCACHTOTUNG_MA,
                    BC.ROWNUMBER
                FROM
                    (
                        SELECT
                            D.ID,
                            D.DONID,
                            D.TENDUONGSU,
                            D.TUCACHTOTUNG_MA,
                            ROW_NUMBER()
                            OVER(PARTITION BY D.DONID
                                 ORDER BY
                                     D.ISDAIDIEN DESC, D.TENDUONGSU
                            ) ROWNUMBER
                        FROM
                            APS_DON_DUONGSU D
                            LEFT JOIN APS_ANPHI       P ON P.DUONGSU_ID = D.ID
                        WHERE
                            ( ( D.TUCACHTOTUNG_MA = 'NGUYENDON'
                                AND ( P.SOBIENLAI IS NOT NULL
                                      OR P.TINHTRANG = 1 ) )
                              OR D.TUCACHTOTUNG_MA <> 'NGUYENDON' )
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT
            R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC_KC
        FROM
            (
                SELECT
                    BC.ID,
                    BC.DONID,
                    BC.TENDUONGSU,
                    BC.TUCACHTOTUNG_MA,
                    BC.ROWNUMBER
                FROM
                    (
                        SELECT
                            DS.ID,
                            DS.DONID,
                            DS.TENDUONGSU,
                            DS.TUCACHTOTUNG_MA,
                            ROW_NUMBER()
                            OVER(PARTITION BY DS.DONID
                                 ORDER BY
                                     DS.ISDAIDIEN DESC, DS.TENDUONGSU
                            ) ROWNUMBER
                        FROM
                            APS_DON_DUONGSU DS
                        WHERE
                            EXISTS (
                                SELECT
                                    'X'
                                FROM
                                    APS_SOTHAM_KHANGCAO KC
                                WHERE
                                        KC.DUONGSUID = DS.ID
                                    AND KC.DONID = DS.DONID
                            )
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;

        OPEN CURRETURN FOR WITH CTE_DATA AS (
                              SELECT DISTINCT
                                  ( D.MAVUVIEC ),
                                  D.ID,
                                  D.TENVUVIEC,
                                  D.SOTHUTU,
                                  D.NGAYNHANDON,
                                  D.NGUOITAO,
                                  TO_CHAR(D.NGAYTAO, 'dd/MM/yyyy HH24:MI:SS')          AS NGAYTAO,
                                  I.TEN                                                AS QUANHEPL,
                                  D.MAGIAIDOAN,
                                  T.TEN                                                TOASOTHAM,
                                  D.HINHTHUCNHANDON,
                                  'Phúc thẩm'                                          GIAIDOANVUVIEC,
                                  (
                                      CASE D.HINHTHUCNHANDON
                                          WHEN 1 THEN
                                              'Trực tiếp'
                                          WHEN 2 THEN
                                              'Qua bưu điện'
                                          WHEN 3 THEN
                                              'Trực tuyến'
                                      END
                                  )                                                    TENHINHTHUC,
                                  DECODE(D.HINHTHUCNHANDON, 1, '<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>', 270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                         GN.TRUONGHOPGIAONHAN)                         TRUONGHOPGIAONHAN,
                                  NVL('</br><i>Tòa xét xử sơ thẩm: </i><b>'
                                      || T.TEN
                                      || '</b>', '')                                       TENTOASOTHAM,
                                  STBA.BANAN_QD_ST,
                                  STKN.KHANGNGHI_ST,

                                   BAPT.TINHTRANG_GQ as QD_PT,
                                  ( BC3.HOTEN
                                     )                                       HOTENBICAN,
                                  ( TLS.TINHTRANG_GQ
                                    || TLPT.TINHTRANG_GQ )                               CHECK_THULY,
                                  CASE
                                      WHEN TLPT.TINHTRANG_GQ IS NULL THEN
                                              '- Chưa thụ lý'
                                      ELSE
                                          TLPT.TINHTRANG_GQ
                                  END
                                  ||
                                  CASE
                                      WHEN TPPCPT.TINHTRANG_GQ IS NULL
                                           AND TLPT.TINHTRANG_GQ IS NOT NULL THEN
                                              '</br>- Chưa phân công Thẩm phán'
                                      ELSE
                                          TPPCPT.TINHTRANG_GQ
                                  END
                                  || HPTPT.TINHTRANG_GQ
                                  || TDCPT.TINHTRANG_GQ
                                  || DCPT.TINHTRANG_GQ
                                  || CPT.TINHTRANG_GQ
                                  || GNST.TINHTRANG_GQ
                                || BAPT.TINHTRANG_GQ
                                  || PTQD.TINHTRANG_GQ                                 TINHTRANG_GQ,

                                  0 THULYXXLAI
                              FROM
                            APS_DON         D
                 INNER JOIN (SELECT G.* 
                  FROM APS_DON G 
                  WHERE (G.MAGIAIDOAN = 7 AND G.TOAANID = vToaXetXu) 
                  OR(G.TOAANID = vToaXetXu AND G.TOAPHUCTHAMID != vToaXetXu)
                  ) GD ON D.ID=GD.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.*
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          INSTR(',DC,', ','
                                                        || QDL.MA
                                                        || ',') > 0
                                  )               QD ON QD.DONID = D.ID
                                  INNER JOIN APS_DON_DUONGSU DDS ON D.ID = DDS.DONID
                                  LEFT JOIN DM_DATAITEM     I ON D.QUANHEPHAPLUATID = I.ID
                                  LEFT JOIN DM_TOAAN        T ON D.TOAANID = T.ID
                               ----- BA Or QD----------------------------------------------     

                                   LEFT JOIN (
                                          SELECT
                                              PTQDVA.*
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              INSTR(',DC,', ','
                                                            || QDL.MA
                                                            || ',') > 0
                                      )                  QD ON QD.DONID = D.ID
                                      LEFT JOIN (
                                          SELECT
                                              PTQD.DONID,
                                              '<br /><i>- QĐ GQ PT: </i><b>'
                                              || 'Số '
                                              || PTQD.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy')
                                              || '</b><br />- Đã giải quyết xong' TINHTRANG_GQ
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQD
                                              LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQD.QUYETDINHID
                                          WHERE
                                              QD.MA in ('04-PS', '72-DS')
                                      )                  BAPT ON BAPT.DONID = D.ID      


                            ---------------------------------------------------------------------------------     
                                  LEFT JOIN (
                                      SELECT
                                          T2.DONID,
                                          T2.TOAANID,
                                          T2.NGAYTHULY,
                                          T2.SOTHULY,
                                          T2.TRUONGHOPTHULY,
                                          T2.QHPLTKID,
                                          '</br>- Thụ lý số:<b> '
                                          || TO_CHAR(T2.SOTHULY)
                                          || '</b> ngày<b> '
                                          || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy')
                                          || '</b>' TINHTRANG_GQ
                                      FROM
                                          GSCM.APS_SOTHAM_THULY T2
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(ID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTHULY DESC, NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_SOTHAM_THULY
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  ) QDL
                                              WHERE
                                                  QDL.ID = T2.ID
                                          )
                                  )               TLS ON TLS.DONID = D.ID --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
                                  LEFT JOIN (
                                      SELECT
                                          T2.DONID,
                                          T2.NGAYTHULY,
                                          T2.SOTHULY,
                                          T2.TRUONGHOPTHULY,
                                          '</br>- Thụ lý số:<b> '
                                          || TO_CHAR(T2.SOTHULY)
                                          || '</b> ngày<b> '
                                          || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy')
                                          || '</b>' TINHTRANG_GQ
                                      FROM
                                          GSCM.APS_KCKNQDK_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(ID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTHULY DESC, NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_KCKNQDK_PHUCTHAM_THULY
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  ) QDL
                                              WHERE
                                                  QDL.ID = T2.ID
                                          )--> Lấy thụ lý mới nhất
                                  )               TLPT ON TLPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID) AS IDTP,
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'          TINHTRANG_GQ
                                      FROM
                                          APS_DON_THAMPHAN TP
                                          LEFT JOIN (
                                              SELECT
                                                  DONID,
                                                  ID
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(CANBOID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_SOTHAM_HDXX
                                                              WHERE
                                                                  MAVAITRO = 'THAMPHAN'
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  )
                                          )                HD ON HD.DONID = TP.DONID
                                          LEFT JOIN (
                                              SELECT
                                                  GG.*
                                              FROM
                                                  APS_DON_THAMPHAN GG
                                              WHERE
                                                  EXISTS (
                                                      SELECT
                                                          'X'
                                                      FROM
                                                          TABLE ( V_TABLE_TP ) TP
                                                      WHERE
                                                          TP.ID = GG.ID
                                                  )
                                          )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                          LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                          LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                      WHERE
                                          TP.MAVAITRO = 'VTTP_GIAIQUYETSOTHAM'
                                      GROUP BY
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID),
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'
                                  )               TPPC ON TPPC.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID) AS IDTP,
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'          TINHTRANG_GQ
                                      FROM
                                          APS_DON_THAMPHAN TP
                                          LEFT JOIN (
                                              SELECT
                                                  DONID,
                                                  ID
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(CANBOID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_KCKNQDK_PHUCTHAM_HDXX
                                                              WHERE
                                                                  MAVAITRO = 'THAMPHAN'
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  )
                                          )                HD ON HD.DONID = TP.DONID
                                          LEFT JOIN (
                                              SELECT
                                                  GG.*
                                              FROM
                                                  APS_DON_THAMPHAN GG
                                              WHERE
                                                  EXISTS (
                                                      SELECT
                                                          'X'
                                                      FROM
                                                          TABLE ( V_TABLE_TP ) TP
                                                      WHERE
                                                          TP.ID = GG.ID
                                                  )
                                          )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                          LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                          LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                      WHERE
                                          TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                      GROUP BY
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID),
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'
                                  )               TPPCPT ON TPPCPT.DONID = D.ID
--                                  LEFT JOIN (
--                                      SELECT
--                                          BC.DONID,
--                                          '<br /><i>Người kháng cáo:</i> <br />'
--                                          ||
--                                          LISTAGG(BC.TENDUONGSU
--                                                  || ' '
--                                                  || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Nguyên đơn)', 'BIDON', '(Bị đơn)',
--                                                            'QUYENNVLQ', '(Người có quyền và NVLQ)', ' ('
--                                                                                                     || BC.TUCACHTOTUNG_MA
--                                                                                                     || ')'), '</b><br/>') WITHIN GROUP(
--                                              ORDER BY
--                                                  BC.ROWNUMBER
--                                              )
--                                          HOTEN
--                                      FROM
--                                          TABLE ( V_TABLE_BC ) BC
--                                      GROUP BY
--                                          BC.DONID
--                                  )               BC2 ON BC2.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          BC.DONID,
                                          '<br /><i>Người kháng cáo:</i> <b>'
                                          ||
                                          LISTAGG(BC.TENDUONGSU
                                                  || ' '
                                                  || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Nguyên đơn)', 'BIDON', '(Bị đơn)',
                                                            'QUYENNVLQ', '(Người có quyền và NVLQ)', ' ('
                                                                                                     || BC.TUCACHTOTUNG_MA
                                                                                                     || ')'), '</b><br/>') WITHIN GROUP(
                                              ORDER BY
                                                  BC.ROWNUMBER
                                              )
                                          HOTEN
                                      FROM
                                          TABLE ( V_TABLE_BC_KC ) BC
                                      GROUP BY
                                          BC.DONID
                                  )               BC3 ON BC3.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          CA.VUANID,
                                          I.TEN TRUONGHOPGIAONHAN
                                      FROM
                                               DM_DATAITEM I
                                          INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                      WHERE
                                          CA.TOANHANID = VTOAXETXU
                                      GROUP BY
                                          CA.VUANID,
                                          I.TEN
                                  )               GN ON GN.VUANID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          BA.DONID,
                                          '<br />BA/QĐ sơ thẩm: <b>'
                                          || 'Số '
                                          || BA.SOBANAN
                                          || ' ngày '
                                          || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy')
                                          || '</b>' BANAN_QD_ST
                                      FROM
                                          APS_SOTHAM_BANAN BA
                                  )               STBA ON STBA.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          KN.DONID,
                                          '<br /><i>Kháng nghị:</i> <br />'
                                          ||
                                          LISTAGG('Số '
                                                  || KN.SOKN
                                                  || ' ngày '
                                                  || TO_CHAR(KN.NGAYKN, 'dd/MM/yyyy'), '<br/>') WITHIN GROUP(
                                              ORDER BY
                                                  KN.NGAYKN
                                              )
                                          KHANGNGHI_ST
                                      FROM
                                          APS_SOTHAM_KHANGNGHI KN
                                          where KN.TINHTRANG_GIAIQUYET != 3
                                      GROUP BY
                                          KN.DONID
                                  )               STKN ON STKN.DONID = D.ID



        ----------------------------                          

                                  LEFT JOIN (
                                      SELECT
                                          CA.VUANID,
                                             -- '</br>- '
                                            --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                           '</br>- Đã chuyển vụ án' TINHTRANG_GQ
                                      FROM
                                               DM_DATAITEM I
                                          INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                      WHERE
                                          CA.TOACHUYENID = VTOAXETXU
                                      GROUP BY
                                          CA.VUANID,
                                                  -- '</br>- '
                                              --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                           '</br>- Đã chuyển vụ án'
                                  )               GNST ON GNST.VUANID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ CVA số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',CVA,', ','
                                                                     || QDL.MA
                                                                     || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ CVA số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               CPT ON CPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ ĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',DC,', ','
                                                                    || QDL.MA
                                                                    || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ ĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               DCPT ON DCPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ TĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',TDC,', ','
                                                                     || QDL.MA
                                                                     || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ TĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               TDCPT ON TDCPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ HPT số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',HPT,', ','
                                                                     || QDL.MA
                                                                     || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ HPT số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               HPTPT ON HPTPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ '
                                          || DECODE(QDL.MA, 'KMTTPS', 'không mở thủ tục phá sản số: ', 'MTTPS', 'mở thủ tục phá sản số: ',
                                                    'DC', 'đình chỉ tiến hành thủ tục phá sản số: ')
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'DD/MM/YYYY') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          QDL.MA IN ( 'MTTPS', 'KMTTPS', 'DC' )
                --and ptba.sobanan is not null
                                  )               PTQD ON PTQD.DONID = D.ID
                              WHERE
                                      D.MAGIAIDOAN = 7
                                  AND  D.TOAPHUCTHAMID = VDONVIID
                                  AND ( VLOAIHINHDOANHNGHIEP IS NULL
                                        OR DDS.LOAIDUONGSU = VLOAIHINHDOANHNGHIEP )
                                  AND ( VUYTHACTUPHAP IS NULL
                                        OR ( VUYTHACTUPHAP IS NOT NULL
                                             AND (  EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY TLPT
                                      WHERE
                                              TLPT.UTTPDI = TO_NUMBER(VUYTHACTUPHAP)
                                          AND TLPT.DONID = D.ID
                                  ) ) ) )
                                  AND ( VMAVIEC IS NULL
                                        OR ( LOWER(D.MAVUVIEC) LIKE '%'
                                                                    || LOWER(VMAVIEC)
                                                                    || '%' ) )
                                  AND ( VTENVIEC IS NULL
                                        OR ( LOWER(D.TENVUVIEC) LIKE '%'
                                                                     || LOWER(VTENVIEC)
                                                                     || '%' ) )--Tên vụ án
                                  AND  D.TOAPHUCTHAMID = VTOAXETXU
                                               AND V_CAPXETXULOGIN = 'CAPTINH'
                                 --26/06/2023 tuyennh sua tim kiem theo tinh trang thu ly start--               
                                  AND ( ( VTINHTRANGTHULY IS NULL

                                  AND (vtungaythuly IS NULL OR  d.NGAYTAO>=VV_NGAYTHULY_TU) 
                                  AND (vDenNgayThuLy IS NULL OR d.NGAYTAO<=VV_NGAYTHULY_DEN)   
                    /*AND(
                    (((vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN))
                    or ((vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN))))*/ 
                                        )
                                        OR ( VTINHTRANGTHULY = 1
                                             AND ( ( TLPT.DONID IS NOT NULL
                                                     AND ( VTUNGAYTHULY IS NULL
                                                           OR TLPT.NGAYTHULY >= VV_NGAYTHULY_TU )
                                                     AND ( VDENNGAYTHULY IS NULL
                                                           OR TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) 
                                                    ) 
                                                 ) 
                                            )
                                        OR ( VTINHTRANGTHULY = 2
                                             AND ( TLS.DONID IS NULL
                                                   AND TLPT.DONID IS NULL )
                     /*AND (vtungaythuly IS NULL OR  d.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (vDenNgayThuLy IS NULL OR d.NGAYTAO<=VV_NGAYTHULY_DEN)   */
                                        AND ( ( VTUNGAYTHULY IS NULL
                                          OR TLPT.NGAYTHULY >= VV_NGAYTHULY_TU )
                                        AND ( VDENNGAYTHULY IS NULL
                                              OR TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) )
                                            ) 
                                     )
                         --26/06/2023 tuyennh sua tim kiem theo tinh trang thu ly end--          
          -----
                                  AND ( VSOTHULY IS NULL
                                        OR ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_SOTHAM_THULY
                                      WHERE
                                              DONID = D.ID
                                          AND UPPER(SOTHULY) = UPPER(VSOTHULY)
                                  )
                                             OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_SOTHAM_THULY
                                      WHERE
                                              DONID = D.ID
                                          AND UPPER(SOTHULY) = UPPER(VSOTHULY)
                                  ) ) )--Số Thụ lý
                                  AND ( 1 = (
                                      CASE
                                          WHEN ( VDUONGSU_NGUOITHAMGIATOTUNG
                                                 || ' ' ) = ' ' THEN
                                              1
                                          WHEN (
                                              SELECT
                                                  COUNT(ID)
                                              FROM
                                                  APS_DON_DUONGSU S
                                              WHERE
                                                      S.DONID = D.ID
                                                  AND LOWER(S.TENDUONGSU) LIKE ( '%'
                                                                                 || LOWER(VDUONGSU_NGUOITHAMGIATOTUNG)
                                                                                 || '%' )
                                          ) > 0          THEN
                                              1
                                          ELSE
                                              0
                                      END
                                  ) )


                                  --AND ( VTHAMPHAN IS NULL
                                  --      OR UPPER(TPPC.IDTP) LIKE '%'
                                  ----                               || UPPER(VTHAMPHAN)
                                  --                               || '%'
                                  --      OR UPPER(TPPCPT.IDTP) LIKE '%'
                                  --                                || UPPER(VTHAMPHAN)
                                  --                                 || '%' )
                                  --26/06/2023 toancau-tuyennh them tim kiem theo ten tham phan--                               
                                and (VTHAMPHAN IS NULL or
                                exists( 
                                          SELECT
                                              TP.DONID
                                          FROM
                                              APS_DON_THAMPHAN TP
                                              LEFT JOIN (
                                                  SELECT
                                                      TT.DONID,
                                                      TT.ID
                                                  FROM
                                                      (
                                                          SELECT
                                                              DONID,
                                                              FIRST_VALUE(CANBOID)
                                                              OVER(PARTITION BY DONID
                                                                   ORDER BY
                                                                       NGAYTAO DESC
                                                              ) ID
                                                          FROM
                                                              APS_KCKNQDK_PHUCTHAM_HDXX
                                                          WHERE
                                                              MAVAITRO = 'THAMPHAN'
                                                      ) TT
                                                  GROUP BY
                                                      TT.DONID,
                                                      TT.ID
                                              )                HD ON HD.DONID = TP.DONID
                                              LEFT JOIN (
                                                  SELECT
                                                      GG.*
                                                  FROM
                                                      APS_DON_THAMPHAN GG
                                                  WHERE
                                                      EXISTS (
                                                          SELECT
                                                              'X'
                                                          FROM
                                                              (
                                                                  SELECT
                                                                      TT.DONID,
                                                                      TT.ID
                                                                  FROM
                                                                      (
                                                                          SELECT
                                                                              DONID,
                                                                              FIRST_VALUE(ID)
                                                                              OVER(PARTITION BY DONID
                                                                                   ORDER BY
                                                                                       NGAYNHANPHANCONG DESC
                                                                              ) ID
                                                                          FROM
                                                                              APS_DON_THAMPHAN
                                                                      ) TT
                                                                  GROUP BY
                                                                      TT.DONID,
                                                                      TT.ID
                                                              ) TP
                                                          WHERE
                                                              TP.ID = GG.ID
                                                      )
                                              )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                              LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                              LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                          WHERE
                                              TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' and TP.DONID = D.ID and cbb.id=VTHAMPHAN 
                                          GROUP BY
                                              TP.DONID
                                      ))  


                             and (VTHAMPHAN IS NULL
                                -- TOANCAU-13102023-tamnc\
                                   OR(V_VAITRO_THAMPHAN IS NULL 
                                       AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.CANBOID = VTHAMPHAN AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
                                    OR (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC'
                                            AND EXISTS (SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.MAVAITRO IN ('VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = VTHAMPHAN))
                                   OR(V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA'
                                       AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.MAVAITRO IN ('THAMPHAN','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = VTHAMPHAN AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
                                    OR(V_VAITRO_THAMPHAN IN ('VTTP_GIAIQUYETDON','THAMPHANHDXX','THAMPHANDUKHUYET')
                                      AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.MAVAITRO =V_VAITRO_THAMPHAN AND TP.CANBOID = VTHAMPHAN AND TP.MAGIAIDOAN = GD.MAGIAIDOAN )))
                --26/06/2023 toancau-tuyennh them tim kiem theo ten tham phan end-- 
                                  AND ( VGQDON IS NULL --or EXISTS ( SELECT 'X' FROM APS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=vGQDon AND XL.DONID=d.ID)
                                        OR ( ( VGQDON = 1
                                               OR VGQDON = 3
                                               OR VGQDON = 4
                                               OR VGQDON = 5 )
                                             AND EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                              XL.LOAIGIAIQUYET = VGQDON
                                          AND XL.DONID = D.ID
                                  ) )
                                        OR ( VGQDON = 6
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                          XL.DONID = D.ID
                                  ) )
                                        OR ( VGQDON = 7
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                          XL.DONID = D.ID
                                  )
                                             AND ( SYSDATE - D.NGAYNHANDON ) > 15 )
                                        OR ( VGQDON = 8
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                          XL.DONID = D.ID
                                  )
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_THAMPHAN TP
                                      WHERE
                                          TP.DONID = D.ID
                                  ) ) )
                                  AND ( VTHUKY IS NULL--Thư ký
                                        OR ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_SOTHAM_HDXX TP
                                      WHERE
                                              TP.CANBOID = VTHUKY
                                          AND TP.DONID = D.ID
                                  )
                                             OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_HDXX TP
                                      WHERE
                                              TP.CANBOID = VTHUKY
                                          AND TP.DONID = D.ID
                                  )
                                             OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_THAMPHAN TP
                                      WHERE
                                              TP.DONID = D.ID
                                          AND TP.THUKYID = VTHUKY
                                  ) ) )   
        -- vTinhTrangGQ
        --26/06/2023 toancau-tuyennh sua tim kiem theo tinh trang giai quyet start--
                                  AND ( ( VTINHTRANGGQ IS NULL
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR D.NGAYTAO >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR D.NGAYTAO <= VV_DENNGAY_GQ ) )
                                        OR ( VTINHTRANGGQ = 1 --Chưa giải quyết xong
--                                             AND ( EXISTS (
--                                      SELECT
--                                          'X'
--                                      FROM
--                                          APS_KCKNQDK_PHUCTHAM_THULY PTTL
--                                      WHERE
--                                          ( NOT EXISTS (
--                                              SELECT
--                                                  'X'
--                                              FROM
--                                                  APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                                                  LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
--                                                  LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
--                                              WHERE
--                                                      INSTR(',DC,CVA,CNTT,', ','
--                                                                             || QDL.MA
--                                                                             || ',') > 0
--                                                  AND PTTL.DONID = PTQDVA.DONID
--                                          ) )
--                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
--                                                OR PTTL.NGAYTHULY >= VV_TUNGAY_GQ )
--                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
--                                                OR PTTL.NGAYTHULY <= VV_DENNGAY_GQ )
--                                          AND PTTL.DONID = D.ID
--                                  ) ) 
                                --da thu ly
                                AND (TLPT.NGAYTHULY IS NOT NULL) 
                              AND ( EXISTS(
                              SELECT
                                              'X'
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA IN (
                                                  '04-PS',
                                                  '72-DS'
                                              ) 
                                              AND PTQDVA.DONID = D.ID
                                              AND PTQDVA.NGAYQD IS NOT NULL AND vDenNgayTinhTrangGQ IS NOT NULL AND VV_DENNGAY_GQ<PTQDVA.NGAYQD
                              ) OR (NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA IN (
                                                  '04-PS',
                                                  '72-DS'
                                              ) 
                                              AND PTQDVA.DONID = D.ID
                                      ) 
                                AND(

                                  --chua phan cong tham phan
                                  (

                                    (
                                      vTuNgayTinhTrangGQ IS NULL 
                                      OR TLPT.NGAYTHULY >= VV_TUNGAY_GQ
                                    ) 
                                    AND (
                                      vDenNgayTinhTrangGQ IS NULL 
                                      OR TLPT.NGAYTHULY <= VV_DENNGAY_GQ
                                    ) 
                                    AND NOT EXISTS(
                                      SELECT 
                                        'x' 
                                      FROM 
                                        APS_DON_THAMPHAN PC 
                                          WHERE 
                                            PC.DONID = D.ID 
                                        AND (
                                          (
                                            PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                          )
                                        ) 
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ
                                        )
                                    )
                                      ) --da phan cong tham phan
                                  or (
                                    EXISTS(
                                      SELECT 
                                        'x' 
                                      FROM 
                                        APS_DON_THAMPHAN PC 
                                      WHERE 
                                        PC.DONID = D.ID 
                                        AND (
                                          (
                                            PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' 
                                          ) --phuc thẩm
                                          ) 
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ
                                        )
                                    )
                                  ) --da len lich xx
                                  or(
                                    EXISTS(
                                      SELECT  'X' FROM   APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='DVARXX' --đưa vụ án ra xét xử
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID
                                    )
                                  ) --dang hoan
                                  or(
                                    EXISTS(
                                      SELECT 
                                        'X' 
                                      FROM 
                                        APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                        LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
                                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                      WHERE 
                                        PTBA.DONID IS NULL 
                                        AND QDL.MA = 'HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ
                                        ) 
                                        AND PTQDVA.DONID = D.ID 
                                    )
                                  ) --dang tdc
                                  or(
                                    EXISTS(
                                      SELECT 
                                        'X' 
                                      FROM 
                                        APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                        LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
                                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                      WHERE 
                                        PTBA.DONID IS NULL 
                                        AND QDL.MA = 'TDC' -- QDL.MA ='TDC' Tam dinh chi
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ
                                        ) 
                                        AND PTQDVA.DONID = D.ID 
                                    )
                                  )
                                ) ) )                                  
                                  )
                                        OR ( VTINHTRANGGQ = 2 --chưa phân công Thẩm phán
--                                             AND ( TPPC.DONID IS NULL
--                                                   AND TPPCPT.DONID IS NULL )
--                                             AND ( VTUNGAYTINHTRANGGQ IS NULL
--                                                   OR D.NGAYTAO >= VV_TUNGAY_GQ )
--                                             AND ( VDENNGAYTINHTRANGGQ IS NULL
--                                                   OR D.NGAYTAO <= VV_DENNGAY_GQ ) 

                                             AND( TLPT.NGAYTHULY IS NOT NULL )
                                            AND (  vTuNgayTinhTrangGQ IS NULL  OR TLPT.NGAYTHULY >= VV_TUNGAY_GQ  ) 
                                           AND ( VDENNGAYTINHTRANGGQ IS NULL  OR TLPT.NGAYTHULY <= VV_DENNGAY_GQ )
                                         AND ( 
                                            NOT EXISTS (
                                          SELECT
                                              'x'
                                          FROM
                                              APS_DON_THAMPHAN PC
                                          WHERE
                                              PC.DONID = D.ID
                                              AND ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                       ))
                                            AND ( vTuNgayTinhTrangGQ IS NULL
                                                    OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ )
                                              AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                    OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ )

                                                  ))

                                                   )
                                        OR ( VTINHTRANGGQ = 3 --đã phân công Thẩm phán
                                             AND EXISTS (
                                      SELECT
                                          'x'
                                      FROM
                                          APS_DON_THAMPHAN PC
                                      WHERE
                                              PC.DONID = D.ID
                                          AND PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' --phuc thẩm

                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ )
                                  ) )
                                  --tuyennh 29/06/2023 thêm điều kiện tìm kiếm start
                                        OR ( VTINHTRANGGQ = 4 -- đã lên lịch họp
                                        AND ( EXISTS ( 
                            SELECT  'X' FROM   APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='DVARXX' --đưa vụ án ra xét xử
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID 
                                        ))
                                          )
                                          --tuyennh 29/06/2023 thêm điều kiện tìm kiếm end
                                        OR ( VTINHTRANGGQ = 5 --Đang hoãn  
                                             AND (
                      --Đang hoãn phuc tham                 
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              QDL.MA = 'HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                                             AND ( 
                     --phuc tham Đang tạm đình chỉ                
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              QDL.MA = 'TDC' --Tạm đình chỉ
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                   ------------------------------
                                        OR ( VTINHTRANGGQ = 7 --Đã giải quyết xong
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                      WHERE
                                          QD.MA IN ( '04-PS', '72-DS' )
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 8
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          ( VTUNGAYTINHTRANGGQ IS NULL
                                            OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND QDL.MA = 'KMTTPS'
                                --and PTBA.sobanan is not null
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 9
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          ( VTUNGAYTINHTRANGGQ IS NULL
                                            OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND QDL.MA = 'MTTPS'
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 10
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          ( VTUNGAYTINHTRANGGQ IS NULL
                                            OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND QDL.MA = 'DC'
                                          AND PTQDVA.DONID = D.ID
                                  ) ) ) )
             -- END vTinhTrangGQ
             --26/06/2023 toancau-tuyennh sua tim kiem theo tinh trang giai quyet end--
                                  AND ( VTHOIHANGQ IS NULL
                                        OR ( VTHOIHANGQ = 1 --Đã hết thời hạn
                                             AND (  
                            --dùng ngày QĐ phúc thẩm  
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY TL
                                          LEFT JOIN APS_SOTHAM_QUYETDINH       QSV ON TL.DONID = QSV.DONID
                                          LEFT JOIN DM_QD_LOAI                 QDL ON QDL.ID = QSV.LOAIQDID
                                      WHERE
                                          ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                               || QDL.MA
                                                                               || ',') > 0
                                              AND ( QSV.NGAYQD - TL.NGAYTHULY ) > 90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                            OR ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                  || QDL.MA
                                                                                  || ',') = 0
                                                 AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
                                          AND TL.DONID = D.ID
                                  ) ) )
                                        OR ( VTHOIHANGQ = 2 --Còn thời hạn dưới 10 ngày
                                             AND (
                          --phúc thẩm   
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY     TL
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              ( SYSDATE - TL.NGAYTHULY ) >= 80
                                          AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                          AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                             || QDL.MA
                                                                             || ',') = 0
                                                OR INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                || QDL.MA
                                                                                || ',') IS NULL )
                                          AND TL.DONID = D.ID
                                  ) ) )
                                        OR ( VTHOIHANGQ = 3
                                             AND (
                          --phúc thẩm   
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY     TL
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              ( SYSDATE - TL.NGAYTHULY ) >= 70
                                          AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                          AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                             || QDL.MA
                                                                             || ',') = 0
                                                OR INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                || QDL.MA
                                                                                || ',') IS NULL )
                                          AND TL.DONID = D.ID
                                  ) ) ) )
                                  AND ( VCHECKTK = 0
                                        OR (
                                      SELECT
                                          COUNT(*)
                                      FROM
                                          APS_DON_THAMPHAN TP
                                      WHERE
                                              TP.DONID = D.ID
                                          AND TP.THUKYID = VCHECKTK
                                          AND TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                  ) > 0 )
                                  AND ( VSOQD IS NULL--Số BA/QĐ
                                        OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                      WHERE
                                          UPPER(QSV.SOQD) LIKE '%'
                                                               || VSOQD
                                                               || '%'
                                          AND D.ID = QSV.DONID
                                  ) )
                                  AND ( VNGAYQD IS NULL--Ngày BA/QĐ
                                        OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                      WHERE
                                              TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = VNGAYQD
                                          AND D.ID = QSV.DONID
                                  ) )
                          ), CTE_TOTAL AS (
                              SELECT
                                  COUNT(ID) AS TOTAL
                              FROM
                                  CTE_DATA
                          ), CTE_FINAL AS (
                              SELECT
                                  ROW_NUMBER()
                                  OVER(
                                      ORDER BY
                                          A.NGAYNHANDON DESC
                                  ) STT,
                                  A.ID,
                                  A.MAVUVIEC,
                                  A.TENVUVIEC,
                                  A.SOTHUTU,
                                  A.NGAYNHANDON,
                                  A.NGUOITAO,
                                  A.NGAYTAO,
                                  A.QUANHEPL,
                                  A.MAGIAIDOAN,
                                  A.TOASOTHAM,
                                  A.HINHTHUCNHANDON,
                                  A.GIAIDOANVUVIEC,
                                  A.TENHINHTHUC,
                                  A.TRUONGHOPGIAONHAN,
                                  A.CHECK_THULY,
                                  A.THULYXXLAI,
                                  A.TINHTRANG_GQ,
                                  A.TENTOASOTHAM,
                                  A.BANAN_QD_ST,
                                  A.KHANGNGHI_ST,
                                  A.HOTENBICAN,
                                  A.QD_PT,
                                  (
                                      SELECT
                                          TOTAL
                                      FROM
                                          CTE_TOTAL
                                  ) AS COUNTALL
                              FROM
                                  CTE_DATA A
                          )
                          SELECT
                              A.*
                          FROM
                              CTE_FINAL A
                          WHERE
                              A.STT BETWEEN MININDEX AND MAXINDEX;

    END APS_DON_SEARCH;
    -----------------------------------


PROCEDURE APS_PHUCTHAMQDK_THULY_GETMAXTT (
        VDONVIID  IN NUMBER,
        VFROMDATE IN DATE,
        VTODATE   IN DATE,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               NVL(MAX(D.TT), 0)
                           FROM
                                    APS_KCKNQDK_PHUCTHAM_THULY T
                               INNER JOIN APS_DON D ON D.ID = T.DONID
                           WHERE
                                   D.TOAANID = VDONVIID
                               AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

    END APS_PHUCTHAMQDK_THULY_GETMAXTT;


-----------------------------------   ---- 
 --Lấy ra list TGTT tamnc 1-4
    PROCEDURE APS_PHUCTHAM_KCKN_TGTT_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               D.ID,
                               D.HOTEN,
                               I.TEN                                      AS TENTC
        --,h1.MA_TEN as Tamtru
                               ,
                               D.TAMTRUCHITIET                            AS TAMTRU,
                               I.MA,
                               CONCAT(CB.HOTEN, '-' || D.CHUCVU_CHUCDANH) AS CHUCVUCHUCDANH,
                               D.NGAYTHAMGIA,
                               D.NGAYKETTHUC,
                               D.NGUOITAO,
                               D.NGAYTAO,
                               (
                                   SELECT
                                       LISTAGG(TENDUONGSU, '<br/>') WITHIN GROUP(
                                       ORDER BY
                                           ID
                                       ) AS DESCRIPTION
                                   FROM
                                       APS_DON_DUONGSU A
                                   WHERE
                                       D.DUONGSUID LIKE '%,'
                                                        || A.ID
                                                        || ',%'
                               )                                          TENDUONGSU
                           FROM
                               APS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG D
                               LEFT JOIN DM_DATAITEM                        I ON I.MA = D.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH                       H1 ON H1.ID = D.TAMTRUID
                               LEFT JOIN DM_CANBO                           CB ON D.NGUOIPHANCONGID = CB.ID
                           WHERE
                               D.DONID = VDONID
                           ORDER BY
                               D.HOTEN;

    END APS_PHUCTHAM_KCKN_TGTT_GETLIST;
 ---------------------------------------------------  
 --Lấy ra list HDXX tamnc 1-4
    PROCEDURE APS_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
        CHECKBANANPT NUMBER;
    BEGIN
        SELECT
            COUNT(ID)
        INTO CHECKBANANPT
        FROM
            APS_PHUCTHAM_BANAN
        WHERE
            DONID = VDONID;

        OPEN CURRETURN FOR SELECT
                              NVL(CHECKBANANPT, 0) CHECKBANANPT,
                              D.ID,
                              (
                                  CASE MAVAITRO
                                      WHEN 'THAMPHAN'         THEN
                                          'Thẩm phán chủ tọa phiên tòa'
                                      WHEN 'THAMPHANHDXX'     THEN
                                          'Thẩm phán thành viên hội đồng xét xử'
                                      WHEN 'THAMPHANDUKHUYET' THEN
                                          'Thẩm phán dự khuyết'
                                      WHEN 'HTND'             THEN
                                          'Hội thẩm nhân dân'
                                      WHEN 'THUKY'            THEN
                                          'Thư ký'
                                      WHEN 'KSV'              THEN
                                          'Kiểm sát viên'
                                  END
                              )                    AS TENVAITRO,
                              CASE
                                  WHEN D.MAVAITRO = 'KSV' THEN
                                      V.HOTEN
                                  ELSE
                                      C.HOTEN
                              END                  AS TENNGUOITHTT,
                              D.NGAYTHAMGIA,
                              D.NGAYKETTHUC,
                              D.NGAYPHANCONG,
                              D.NGAYNHANPHANCONG,
                              D.NGUOITAO,
                              D.NGAYTAO,
                              E.HOTEN              AS NGUOIPHANCONG
                          FROM
                              APS_KCKNQDK_PHUCTHAM_HDXX D
                              LEFT JOIN DM_CANBO                  C ON C.ID = D.CANBOID
                              LEFT JOIN DM_CANBO                  E ON E.ID = D.NGUOIPHANCONGID
                              LEFT JOIN DM_CANBOVKS               V ON V.ID = D.CANBOID
                          WHERE
                              D.DONID = VDONID
                          ORDER BY
                              D.HOTEN;

    END APS_KCKNQDK_PHUCTHAM_HDXX_GETLIST;
    -------------------------------------------------
    --Lấy ra list bản án tamnc 29-3
    PROCEDURE APS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
        COUNTBANANST INT;
    BEGIN
    --select count(ID) into CountBanAnST from APS_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
        OPEN CURRETURN FOR SELECT
                               Q.ID,
                               Q.SOQD,
                               Q.NGAYQD,
                               Q.CHUCVU,
                               Q.QUYETDINHID,
                               D.TEN   AS TENQD,
                               C.HOTEN AS NGUOIKY,
                               Q.HIEULUCTU,
                               Q.HIEULUCDEN,
                               LD.TEN  AS LYDO,
                               Q.NGAYTAO,
                               Q.NGUOITAO,
                               T.TEN   TENTOAAN,
                               Q.TENFILE,
                               Q.FILEID,
                               0       ISBANANST
                           FROM
                               APS_KCKNQDK_PHUCTHAM_QUYETDINH Q
                               LEFT JOIN APS_FILE                       F ON Q.FILEID = F.ID
                               LEFT JOIN DM_QD_QUYETDINH_LYDO           LD ON LD.ID = Q.LYDOID
                               INNER JOIN DM_QD_QUYETDINH                D ON D.ID = Q.QUYETDINHID
                                                            AND ( D.MA IN ('04-PS', '72-DS') )
                               LEFT JOIN DM_CANBO                       C ON C.ID = Q.NGUOIKYID
                               LEFT JOIN DM_TOAAN                       T ON T.ID = Q.TOAANID
                           WHERE
                               Q.DONID = VDONID
                               OR Q.DONID IN (
                                   SELECT
                                       ID
                                   FROM
                                       APS_DON
                                   WHERE
                                       VUANGOCID = VDONID
                               )
                           ORDER BY
                               Q.NGAYQD;

    END APS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST;


    -------------------------------------------------------
          --Lấy ra list Quyết định tamnc 1-4
    PROCEDURE APS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               Q.ID,
                               Q.SOQD,
                               Q.NGAYQD,
                               Q.CHUCVU,
                               D.TEN
                               || DECODE(Q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)',
                                         3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)', 5,
                                         ' (Không xác định hình thức xét xử)', '') AS TENQD,
                               C.HOTEN                                   AS NGUOIKY,
                               Q.HIEULUCTU,
                               Q.HIEULUCDEN,
                               LD.TEN                                    AS LYDO,
                               Q.NGAYTAO,
                               Q.NGUOITAO,
                               Q.FILEID,
                               Q.TENFILE
                           FROM
                               APS_KCKNQDK_PHUCTHAM_QUYETDINH Q
                               LEFT JOIN APS_FILE                       F ON F.ID = Q.FILEID
                               LEFT JOIN DM_QD_QUYETDINH_LYDO           LD ON LD.ID = Q.LYDOID
                               INNER JOIN DM_QD_QUYETDINH                D ON D.ID = Q.QUYETDINHID
                                                               AND ( D.ISPHASAN = 1
                                                                     AND D.ISPHUCTHAM = 1
                                                                     AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%' 
                                                                           AND D.MA not in('72-DS','69-DS','70-DS'))--thêm điều kiện not in 
                               LEFT JOIN DM_CANBO                       C ON C.ID = Q.NGUOIKYID
                           WHERE
                               Q.DONID = VDONID
                           ORDER BY
                               Q.NGAYQD;

    END APS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST;



          ---------------------------------- Lấy ra quyết định số "" tamnc 1-4
    PROCEDURE APS_DM_QUYETDINH_VUAN_PTQDK (
        CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
       OPEN CURRETURN FOR SELECT
                               TEN,
                               ID,MA
                           FROM
                               DM_QD_QUYETDINH
                           WHERE
                                   ISPHUCTHAM = 1

                               AND ( MA IN ('04-PS', '72-DS') )
                           ORDER BY
                               CASE WHEN MA = '72-DS' THEN '0' ELSE MA END;
    END APS_DM_QUYETDINH_VUAN_PTQDK;

----------------------------------------------------------------------------
  PROCEDURE APS_KCKNQDK_PHUCTHAM_THULY_GETLIST (
        VDONID    IN NUMBER,
        CURRETURN OUT SYS_REFCURSOR
    ) IS
        VGROUPTHGIAONHAN NUMBER;
    BEGIN
        SELECT
            ID
        INTO VGROUPTHGIAONHAN
        FROM
            DM_DATAGROUP
        WHERE
            MA = 'TRUONGHOP_GIAONHAN';

        OPEN CURRETURN FOR SELECT
                              T.ID,
                              T.MATHULY,
                              THTL.TEN              AS TENTRUONGHOPTHULY,
                              T.QUANHEPHAPLUAT_NAME AS QUANHEPL,
                              QHPLTK.CASE_NAME      AS QUANHEPLTK,
                              T.NGAYTHULY,
                              T.SOTHULY,
                              T.FILEID,
                              T.TENFILE,
                              T.THOIHANTUNGAY,
                              T.THOIHANDENNGAY,
                              T.NGAYTAO,
                              T.NGUOITAO
                          FROM
                              APS_KCKNQDK_PHUCTHAM_THULY T
                              LEFT JOIN APS_FILE                   F ON F.ID = T.FILEID
                              LEFT JOIN (
                                  SELECT
                                      A.ID,
                                      A.TEN
                                  FROM
                                      DM_DATAITEM A
                                  WHERE
                                          A.GROUPID = VGROUPTHGIAONHAN
                                      AND A.MA IN ( '02', '03', '04' )
                              )                          THTL ON THTL.ID = T.TRUONGHOPTHULY
                              LEFT JOIN DM_QHPL_TK                 QHPLTK ON QHPLTK.ID = T.QHPLTKID
                          WHERE
                              T.DONID = VDONID
                          ORDER BY
                              T.NGAYTHULY DESC;

    END APS_KCKNQDK_PHUCTHAM_THULY_GETLIST;
--------------------------------------------------------------------------------------------------------------

 PROCEDURE SO_DK_KCKN_PS (
        V_DK_PS  OUT NUMBER,
        VTOAANID IN VARCHAR2,
        V_CXX    IN VARCHAR2
    ) AS
    BEGIN
        V_DK_PS := 0;
        IF ( V_CXX = 'PT_KCKN' ) THEN
            SELECT
                NVL(MAX(D.SO_DK), 0)
            INTO V_DK_PS
            FROM
                APS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG D
                LEFT JOIN APS_DON                GD ON GD.ID = D.DONID
            WHERE
                    EXTRACT(YEAR FROM TO_DATE(D.NGAY_DK, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM TO_DATE(SYSDATE, 'DD-MM-YYYY'))
                AND D.SO_DK != 0
                AND GD.TOAPHUCTHAMID = VTOAANID;

        END IF;

        V_DK_PS := V_DK_PS + 1;
    END;

  ---------------------------------------------------------------------------------------------------------------------------------  

     PROCEDURE UPDATE_NOIDUNG_CHUYENNHANAN (
        VNHANANID IN NUMBER,
        VNOIDUNG  IN VARCHAR2,
        V_VUANID  IN NUMBER
    ) AS
        V_EXPORT_TEXT CLOB;
    BEGIN
        FOR ITEMS IN (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/
                T2.DONID,
                T2.DUONGSUID,
                '<b> - '
                || DM.TEN
                || ': '
                || T3.TENDUONGSU
                || '</b><br/> '
                ||
                LISTAGG('<b>* Ngày đề nghị:</b> '
                        || TO_CHAR(T2.NGAYKHANGCAO, 'dd/MM/yyyy')
                        || '<br/>'
                        || DECODE(T2.LOAIKHANGCAO, 0, '+ Đề nghị bản án số: '
                                                      || BA.SOBANAN
                                                      || ', Ngày: '
                                                      || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'), '+ Đề nghị quyết định số: '
                                                                                                || QD.SOQD
                                                                                                || ', Ngày: '
                                                                                                || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy')) --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                        || '<br/><div style="text-align:justify" >+ Nội dung: '
                        || T2.NOIDUNGKHANGCAO
                        || '</div>', ',') WITHIN GROUP(
                    ORDER BY
                        T2.DONID, T2.DUONGSUID
                    )
                NOIDUNG
            FROM
                     APS_SOTHAM_KHANGCAO T2
                INNER JOIN APS_DON_DUONGSU      T3 ON T2.DUONGSUID = T3.ID
                                                 AND ( T3.DONID = T2.DONID )
                LEFT JOIN DM_DATAITEM          DM ON DM.MA = T3.TUCACHTOTUNG_MA
                LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID = T2.SOQDBA
                                                     AND T2.LOAIKHANGCAO IN ( 1, 2 ) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                LEFT JOIN APS_SOTHAM_BANAN     BA ON BA.ID = T2.SOQDBA
                                                 AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
            WHERE
                    T2.DONID = (
                        CASE
                            WHEN NOT EXISTS (
                                SELECT
                                    'x'
                                FROM
                                    APS_DON
                                WHERE
                                        ID = V_VUANID
                                    AND APS_DON.MAGIAIDOAN = 7
                            ) THEN
                                V_VUANID
                            ELSE
                                (
                                    SELECT
                                        VUANID
                                    FROM
                                        APS_CHUYEN_NHAN_AN
                                    WHERE
                                            MAP_VUANID_NEW = V_VUANID
                                        AND ROWNUM = 1
                                )
                        END
                    )
                AND ( T2.TINHTRANG_GIAIQUYET IS NULL
                      OR T2.TINHTRANG_GIAIQUYET = 0 )
            GROUP BY
                T2.DONID,
                T2.DUONGSUID,
                T3.TENDUONGSU,
                DM.TEN
            UNION ALL
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/
                T2.DONID,
                T2.DUONGSUID,
                '<b> - '
                || DM.TEN
                || ': '
                || T3.HOTEN
                || '</b><br/> '
                ||
                LISTAGG('<b>* Ngày đề nghị:</b> '
                        || TO_CHAR(T2.NGAYKHANGCAO, 'dd/MM/yyyy')
                        || '<br/>'
                        || DECODE(T2.LOAIKHANGCAO, 0, '+ Đề nghị bản án số: '
                                                      || BA.SOBANAN
                                                      || ', Ngày: '
                                                      || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'), '+ Đề nghị quyết định số: '
                                                                                                || QD.SOQD
                                                                                                || ', Ngày: '
                                                                                                || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy'))  --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                        || '<br/><div style="text-align:justify" >+ Nội dung: '
                        || T2.NOIDUNGKHANGCAO
                        || '</div>', ',') WITHIN GROUP(
                    ORDER BY
                        T2.DONID, T2.DUONGSUID
                    )
                NOIDUNG
            FROM
                     APS_SOTHAM_KHANGCAO T2
                INNER JOIN APS_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID = T3.ID
                                                       AND ( T3.DONID = T2.DONID )
                LEFT JOIN DM_DATAITEM           DM ON DM.MA = T3.TUCACHTGTTID
                LEFT JOIN APS_SOTHAM_QUYETDINH  QD ON QD.ID = T2.SOQDBA
                                                     AND T2.LOAIKHANGCAO IN ( 1, 2 ) --> Kháng cáo quyết định --toancau-anhnt kc tđc
                LEFT JOIN APS_SOTHAM_BANAN      BA ON BA.ID = T2.SOQDBA
                                                 AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án
            WHERE
                    T2.DONID = (
                        CASE
                            WHEN NOT EXISTS (
                                SELECT
                                    'x'
                                FROM
                                    APS_DON
                                WHERE
                                        ID = V_VUANID
                                    AND APS_DON.MAGIAIDOAN = 7
                            ) THEN
                                V_VUANID
                            ELSE
                                (
                                    SELECT
                                        VUANID
                                    FROM
                                        APS_CHUYEN_NHAN_AN
                                    WHERE
                                            MAP_VUANID_NEW = V_VUANID
                                        AND ROWNUM = 1
                                )
                        END
                    )
                AND ( T2.TINHTRANG_GIAIQUYET IS NULL
                      OR T2.TINHTRANG_GIAIQUYET = 0 )
            GROUP BY
                T2.DONID,
                T2.DUONGSUID,
                T3.HOTEN,
                DM.TEN
        ) LOOP
            V_EXPORT_TEXT := TO_CLOB(V_EXPORT_TEXT || ITEMS.NOIDUNG);
        END LOOP;
  -- Tổng hợp kháng nghị
        FOR ITEMS IN (
            SELECT /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENAN.(kháng nghị)*/
                T2.DONID,
                T2.TOAAN_VKS_KN,
                T2.DONVIKN,
                '<b> - '
                || DECODE(T2.DONVIKN, 1, T4.TEN, T5.TEN)
                || '</b><br/>'
                ||
                LISTAGG('<b>* Ngày kháng nghị: </b>'
                        || TO_CHAR(T2.NGAYKN, 'dd/MM/yyyy')
                        || '<br />'
                        || DECODE(T2.LOAIKN, 0, '+ Kháng nghị bản án số: '
                                                || BA.SOBANAN
                                                || ', Ngày: '
                                                || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'), '+ Kháng nghị quyết định số: '
                                                                                          || QD.SOQD
                                                                                          || ', Ngày: '
                                                                                          || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy'))
                        || '<br/>'
                        || '+ Nội dung: '
                        || T2.NOIDUNGKN, ',') WITHIN GROUP(
                    ORDER BY
                        T2.DONID, T2.TOAAN_VKS_KN, T2.DONVIKN
                    )
                NOIDUNG
            FROM
                APS_SOTHAM_KHANGNGHI T2
                LEFT JOIN DM_VKS               T4 ON T2.TOAAN_VKS_KN = T4.ID
                                       AND T2.DONVIKN = 1 --> Viện trưởng Viện kiểm sát
                LEFT JOIN DM_TOAAN             T5 ON T2.TOAAN_VKS_KN = T5.ID
                                         AND T2.DONVIKN = 0 --> Chánh án Tòa án
                LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID = T2.BANANID
                                                     AND T2.LOAIKN IN ( 1, 2 ) --> Kháng cáo quyết định
                LEFT JOIN APS_SOTHAM_BANAN     BA ON BA.ID = T2.BANANID
                                                 AND T2.LOAIKN = 0 --> Kháng cáo bản án
                LEFT JOIN APS_SOTHAM_RUTKCKN   RUT ON T2.ID = RUT.IDKCKN
            WHERE
                    T2.DONID = (
                        CASE
                            WHEN NOT EXISTS (
                                SELECT
                                    'x'
                                FROM
                                    APS_DON
                                WHERE
                                        ID = V_VUANID
                                    AND APS_DON.MAGIAIDOAN = 7
                            ) THEN
                                V_VUANID
                            ELSE
                                (
                                    SELECT
                                        VUANID
                                    FROM
                                        APS_CHUYEN_NHAN_AN
                                    WHERE
                                            MAP_VUANID_NEW = V_VUANID
                                        AND ROWNUM = 1
                                )
                        END
                    )
                AND ( T2.TINHTRANG_GIAIQUYET IS NULL
                      OR T2.TINHTRANG_GIAIQUYET = 0 )
            GROUP BY
                T2.DONID,
                T2.TOAAN_VKS_KN,
                T2.DONVIKN,
                T4.TEN,
                T5.TEN
        ) LOOP
            V_EXPORT_TEXT := TO_CLOB(V_EXPORT_TEXT
                                     || '<br/>'
                                     || ITEMS.NOIDUNG);
        END LOOP;

        UPDATE APS_CHUYEN_NHAN_AN
        SET
            NOIDUNG = V_EXPORT_TEXT,
            LYDOCHUYEN = VNOIDUNG
        WHERE
            ID = VNHANANID;

    END;
---------------------------------------------------------------------

   PROCEDURE COUNT_KCKN_TDC (
        VDONID IN NUMBER,
        VOUT   OUT NUMBER
    ) AS
        LCOUNTKC NUMBER;
        LCOUNTKN NUMBER;
    BEGIN
        SELECT
            COUNT(KC.ID)
        INTO LCOUNTKC
        FROM
            APS_SOTHAM_KHANGCAO  KC
            LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID = KC.SOQDBA
            LEFT JOIN DM_QD_QUYETDINH      DM ON DM.ID = QD.QUYETDINHID
        WHERE
                KC.LOAIKHANGCAO = 2
            AND NVL(KC.TINHTRANG_GIAIQUYET, 0) = 0
            AND DM.MA IN ( '41-DS', '42-DS' )
            AND KC.DONID = VDONID;

        SELECT
            COUNT(KN.ID)
        INTO LCOUNTKN
        FROM
            APS_SOTHAM_KHANGNGHI KN
            LEFT JOIN APS_SOTHAM_QUYETDINH QD ON QD.ID = KN.BANANID
            LEFT JOIN DM_QD_QUYETDINH      DM ON DM.ID = QD.QUYETDINHID
        WHERE
                KN.LOAIKN = 2
            AND NVL(KN.TINHTRANG_GIAIQUYET, 0) = 0
            AND DM.MA IN ( '41-DS', '42-DS' )
            AND KN.DONID = VDONID;

        VOUT := NVL(LCOUNTKC, 0) + NVL(LCOUNTKN, 0);
    END;

-------------------------------------------------------
/*
 PROCEDURE SO_DK_KCKN_PS (
        V_DK_PS  OUT NUMBER,
        VTOAANID IN VARCHAR2,
        V_CXX    IN VARCHAR2
    ) AS
    BEGIN
        V_DK_PS := 0;
        IF ( V_CXX = 'PT_KCKN' ) THEN
            SELECT
                NVL(MAX(D.SO_DK), 0)
            INTO V_DK_PS
            FROM
                APS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG D
                LEFT JOIN APS_DON_GIAIDOAN                   GD ON GD.DONID = D.DONID
            WHERE
                    EXTRACT(YEAR FROM TO_DATE(D.NGAY_DK, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM TO_DATE(SYSDATE, 'DD-MM-YYYY'))
                AND D.SO_DK != 0
                AND GD.TOAPHUCTHAMID = VTOAANID;

        END IF;

        V_DK_PS := V_DK_PS + 1;
    END;
    */
-------------------------------------------------------------
 PROCEDURE PS_CHUYENDON (

        VTOAANID       NUMBER,
        VTOAANNHAN_TEN IN VARCHAR2,
        VMAVUVIEC      IN NVARCHAR2,
        VTENVUVIEC     IN NVARCHAR2,
        VSOQD          IN NVARCHAR2,
        VSOBA          IN NVARCHAR2,
        VTUNGAY        IN DATE,
        VDENNGAY       IN DATE,
        VDUONGSU       IN NVARCHAR2,
        VTRANGTHAI     IN NUMBER,
        CURRETURN      OUT SYS_REFCURSOR
    ) AS
        V_ARRAY T_CHUYENAN_STPT_GS;
    BEGIN
        IF VTRANGTHAI = 0 THEN
            SELECT
                R_CHUYENAN_STPT_GS(V_STT => ROW_NUMBER()
                                            OVER(
                    ORDER BY
                        DXL.NGAYGQ_YC DESC, D.TENVUVIEC
                                            ), V_VUANID => D.ID, V_TOAANID => VTOAANID, V_TENVUAN => D.TENVUVIEC, V_MAVUAN => D.MAVUVIEC,
                                  V_NGAYCHUYEN => NULL, V_NGAYNHAN => NULL, V_NGAYTHULY => NULL, V_NOIDUNG => NULL, V_TOANHAN => NULL,
                                  V_LYDOID => NULL, V_CHUYENNHANID => NULL)
            BULK COLLECT
            INTO V_ARRAY
            FROM
                     APS_DON D
                JOIN APS_DON_XULY DXL ON DXL.DONID = D.ID
            WHERE
                ( 1 = (
                    CASE
                        WHEN ( VMAVUVIEC
                               || ' ' ) = ' ' THEN
                            1
                        WHEN LOWER(D.MAVUVIEC) LIKE ( '%'
                                                      || LOWER(VMAVUVIEC)
                                                      || '%' ) THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( 1 = (
                    CASE
                        WHEN ( VTENVUVIEC
                               || ' ' ) = ' ' THEN
                            1
                        WHEN LOWER(D.TENVUVIEC) LIKE ( '%'
                                                       || LOWER(VTENVUVIEC)
                                                       || '%' ) THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( 1 = (
                    CASE
                        WHEN ( VDUONGSU
                               || ' ' ) = ' ' THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(DS.ID)
                            FROM
                                APS_DON_DUONGSU DS
                            WHERE
                                    DS.DONID = D.ID
                                AND LOWER(DS.TENDUONGSU) LIKE ( '%'
                                                                || LOWER(VDUONGSU)
                                                                || '%' )
                        ) > 0          THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND DXL.LOAIGIAIQUYET = 1
                AND ( ( D.TOAANID = VTOAANID
                        AND ( D.MAGIAIDOAN = 2
                              OR D.MAGIAIDOAN = 1
                              OR D.MAGIAIDOAN = 7 ) )
                      OR ( D.TOAPHUCTHAMID = VTOAANID
                           AND ( D.MAGIAIDOAN = 3
                                 OR D.MAGIAIDOAN = 7 ) )

----------------------              
                      OR ( D.TOAPHUCTHAMID = VTOAANID
                           AND ( D.MAGIAIDOAN = 3
                                 OR D.MAGIAIDOAN = 7 ) )
----------------------
                                  )
                AND (
                    SELECT
                        COUNT(ID)
                    FROM
                        APS_CHUYEN_NHAN_AN CN
                    WHERE
                            CN.VUANID = D.ID
                        AND CN.TOACHUYENID = VTOAANID
                ) = 0
            ORDER BY
                DXL.NGAYGQ_YC DESC,
                D.TENVUVIEC;

        ELSE
            SELECT
                R_CHUYENAN_STPT_GS(V_STT => ROW_NUMBER()
                                            OVER(
                    ORDER BY
                        CNA.NGAYGIAO DESC, D.TENVUVIEC
                                            ), V_VUANID => D.ID, V_TOAANID => VTOAANID, V_TENVUAN => D.TENVUVIEC, V_MAVUAN => D.MAVUVIEC,
                                  V_NGAYCHUYEN => CNA.NGAYGIAO, V_NGAYNHAN => CNA.NGAYNHAN, V_NGAYTHULY => NULL, V_NOIDUNG => NULL, V_TOANHAN =>
                                  TA.TEN,
                                  V_LYDOID => CNA.TRUONGHOPGIAONHANID, V_CHUYENNHANID => CNA.ID)
            BULK COLLECT
            INTO V_ARRAY
            FROM
                     APS_DON D
                INNER JOIN APS_CHUYEN_NHAN_AN CNA ON CNA.VUANID = D.ID
                INNER JOIN DM_TOAAN           TA ON CNA.TOANHANID = TA.ID
                JOIN APS_DON_XULY       DXL ON DXL.DONID = D.ID
            WHERE
                ( ( ( ( D.TOAANID = VTOAANID
                        AND CNA.TOACHUYENID = VTOAANID )
                      OR ( D.TOAPHUCTHAMID = VTOAANID
                           AND CNA.TOACHUYENID = VTOAANID ) )
                    AND ( 1 = (
                    CASE
                        WHEN ( VSOQD
                               || ' ' ) = ' ' THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(SQ.ID)
                            FROM
                                     APS_SOTHAM_QUYETDINH SQ
                                INNER JOIN DM_QD_LOAI QL ON QL.ID = SQ.LOAIQDID
                            WHERE
                                    SQ.DONID = D.ID
                                AND QL.MA = 'CVA'
                                AND SQ.SOQD = VSOQD
                        ) > 0          THEN
                            1
                        ELSE
                            0
                    END
                ) )
                    AND ( 1 = (
                    CASE
                        WHEN ( VSOBA
                               || ' ' ) = ' ' THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(BA.ID)
                            FROM
                                APS_SOTHAM_BANAN BA
                            WHERE
                                    BA.DONID = D.ID
                                AND BA.SOBANAN = VSOBA
                        ) > 0          THEN
                            1
                        ELSE
                            0
                    END
                ) ) )
                  OR -- TRƯỜNG HỢP CÓ ÁN PHÚC THẨM CHUYỂN VỀ
                   ( ( ( D.TOAANID = VTOAANID
                           AND CNA.TOACHUYENID = VTOAANID )
                         OR ( D.TOAPHUCTHAMID = VTOAANID
                              AND CNA.TOACHUYENID = VTOAANID ) )
                       AND ( 1 = (
                    CASE
                        WHEN ( VSOQD
                               || ' ' ) = ' ' THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(QD1.ID)
                            FROM
                                     APS_PHUCTHAM_QUYETDINH QD1
                                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                            WHERE
                                    QD1.DONID = D.ID
                                AND DMQD.KET_THUC = 1
                                AND INSTR('04,06,103', QD1.KETQUAID) > 0
                        ) > 0          THEN
                            1
                        ELSE
                            0
                    END
                ) ) ) )
                AND DXL.LOAIGIAIQUYET = 1
                AND ( 1 = (
                    CASE
                        WHEN ( VMAVUVIEC
                               || ' ' ) = ' ' THEN
                            1
                        WHEN LOWER(D.MAVUVIEC) LIKE ( '%'
                                                      || LOWER(VMAVUVIEC)
                                                      || '%' ) THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( 1 = (
                    CASE
                        WHEN ( VTENVUVIEC
                               || ' ' ) = ' ' THEN
                            1
                        WHEN LOWER(D.TENVUVIEC) LIKE ( '%'
                                                       || LOWER(VTENVUVIEC)
                                                       || '%' ) THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( 1 = (
                    CASE
                        WHEN ( VDUONGSU
                               || ' ' ) = ' ' THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(DS.ID)
                            FROM
                                APS_DON_DUONGSU DS
                            WHERE
                                    DS.DONID = D.ID
                                AND LOWER(DS.TENDUONGSU) LIKE ( '%'
                                                                || LOWER(VDUONGSU)
                                                                || '%' )
                        ) > 0          THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( 1 = (
                    CASE
                        WHEN VTUNGAY IS NULL THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(TL.ID)
                            FROM
                                APS_KCKNQDK_PHUCTHAM_THULY TL
                            WHERE
                                    TL.NGAYTHULY >= VTUNGAY
                                AND TL.DONID = D.ID
                        ) > 0 THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( 1 = (
                    CASE
                        WHEN VDENNGAY IS NULL THEN
                            1
                        WHEN (
                            SELECT
                                COUNT(TL.ID)
                            FROM
                                APS_KCKNQDK_PHUCTHAM_THULY TL
                            WHERE
                                    TL.NGAYTHULY <= VDENNGAY
                                AND TL.DONID = D.ID
                        ) > 0 THEN
                            1
                        ELSE
                            0
                    END
                ) )
                AND ( VTOAANNHAN_TEN IS NULL
                      OR ( UPPER(TA.TEN) LIKE '%'
                                              || UPPER(VTOAANNHAN_TEN)
                                              || '%' ) )
            ORDER BY
                CNA.NGAYGIAO DESC,
                D.TENVUVIEC;

        END IF;

        PKG_STPT_DS_BC.FILL_PS_CHUYENAN(V_ARRAY);
        OPEN CURRETURN FOR SELECT
                               PA.V_STT,
                               PA.V_VUANID,
                               PA.V_TOAANID,
                               PA.V_TENVUAN,
                               PA.V_MAVUAN,
                               PA.V_NGAYCHUYEN,
                               PA.V_NGAYNHAN,
                               PA.V_NGAYTHULY,
                               PA.V_NOIDUNG V_NOIDUNG,
                               PA.V_TOANHAN,
                               PA.V_LYDOID,
                               PA.V_CHUYENNHANID
                           FROM
                               TABLE ( V_ARRAY ) PA;

    END PS_CHUYENDON;

-------------------------------------------------------------
PROCEDURE PS_NHANDON (
        V_NG_KC            IN VARCHAR2,
        VTOAANID           NUMBER,
        VMAVUVIEC          IN NVARCHAR2,
        VTENVUVIEC         IN NVARCHAR2,
        VTOACHUYEN         IN NVARCHAR2,
        VTRUONGHOPGIAONHAN IN NUMBER,
        VTUNGAY            IN DATE,
        VDENNGAY           IN DATE,
        VTRANGTHAI         IN NUMBER,
        V_SO_QD            IN VARCHAR2,
        V_NGAY_QD          IN VARCHAR2,
        CURRETURN          OUT SYS_REFCURSOR
    ) AS
        V_ARRAY T_NHANAN_STPT;
    BEGIN
        SELECT
            R_NHANAN_STPT(V_STT => ROW_NUMBER()
                                   OVER(
                ORDER BY
                    A.NGAYGIAO DESC
                                   ), V_TOAANID => VTOAANID, V_VUANID => C.ID, V_CHUYEN_NHAN_ANID => A.ID, V_TENVUAN => C.TENVUVIEC,
                         V_MAVUAN => C.MAVUVIEC, V_NGAYGIAO => A.NGAYGIAO, V_NGAYNHAN => A.NGAYNHAN, V_NOIDUNG => '<b>- Trường hợp giao nhận: </b>' ||
                         I.TEN, V_TOACHUYEN => B.TEN,
                         V_LOAIVUVIEC => 'Hành chính', V_LOAIVV => 1, V_TRUONGHOPGIAONHAN => I.TEN)
        BULK COLLECT
        INTO V_ARRAY
        FROM
                 APS_CHUYEN_NHAN_AN A
            INNER JOIN DM_TOAAN     B ON A.TOACHUYENID = B.ID
            INNER JOIN APS_DON      C ON A.VUANID = C.ID
            INNER JOIN DM_DATAITEM  I ON I.ID = A.TRUONGHOPGIAONHANID
            JOIN APS_DON_XULY DXL ON DXL.DONID = A.VUANID
        WHERE
                A.TOANHANID = VTOAANID
            AND A.TRANGTHAI = VTRANGTHAI
            AND 1 = (
                CASE
                    WHEN VTRUONGHOPGIAONHAN = 0    THEN
                        1
                    WHEN I.ID = VTRUONGHOPGIAONHAN THEN
                        1
                    ELSE
                        0
                END
            )
            AND ( 1 = (
                CASE
                    WHEN ( VMAVUVIEC
                           || ' ' ) = ' ' THEN
                        1
                    WHEN LOWER(TRIM(C.MAVUVIEC)) LIKE ( '%'
                                                        || LOWER(TRIM(VMAVUVIEC))
                                                        || '%' ) THEN
                        1
                    ELSE
                        0
                END
            ) )
            AND ( 1 = (
                CASE
                    WHEN ( VTENVUVIEC
                           || ' ' ) = ' ' THEN
                        1
                    WHEN LOWER(TRIM(C.TENVUVIEC)) LIKE ( '%'
                                                         || LOWER(TRIM(VTENVUVIEC))
                                                         || '%' ) THEN
                        1
                    ELSE
                        0
                END
            ) )
            AND ( 1 = (
                CASE
                    WHEN ( VTOACHUYEN
                           || ' ' ) = ' ' THEN
                        1
                    WHEN LOWER(TRIM(B.TEN)) LIKE ( '%'
                                                   || LOWER(TRIM(VTOACHUYEN))
                                                   || '%' ) THEN
                        1
                    ELSE
                        0
                END
            ) )
            AND ( 1 = (
                CASE
                    WHEN VTUNGAY IS NULL THEN
                        1
                    WHEN A.NGAYGIAO >= VTUNGAY THEN
                        1
                    ELSE
                        0
                END
            ) )
            AND ( 1 = (
                CASE
                    WHEN VDENNGAY IS NULL THEN
                        1
                    WHEN A.NGAYGIAO <= VDENNGAY THEN
                        1
                    ELSE
                        0
                END
            ) )
            AND DXL.LOAIGIAIQUYET = 1
        ORDER BY
            A.NGAYGIAO DESC;

        PKG_STPT_DS_BC.FILL_PS_NHANAN(V_ARRAY);
        OPEN CURRETURN FOR SELECT
                               *
                           FROM
                               TABLE ( V_ARRAY ) A
                           WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                               ( V_SO_QD IS NULL--Số BA/QĐ
                                 OR ( EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_SOTHAM_BANAN QSV
                                   WHERE
                                       UPPER(QSV.SOBANAN) LIKE '%'
                                                               || V_SO_QD
                                                               || '%'
                                       AND A.V_VUANID = QSV.DONID
                               )
                                      OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_SOTHAM_QUYETDINH QSV
                                   WHERE
                                       UPPER(QSV.SOQD) LIKE '%'
                                                            || V_SO_QD
                                                            || '%'
                                       AND A.V_VUANID = QSV.DONID
                               )
                                      OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_PHUCTHAM_BANAN QSV
                                   WHERE
                                       UPPER(QSV.SOBANAN) LIKE '%'
                                                               || V_SO_QD
                                                               || '%'
                                       AND A.V_VUANID = QSV.DONID
                               )
                                      OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_PHUCTHAM_QUYETDINH QSV
                                   WHERE
                                       UPPER(QSV.SOQD) LIKE '%'
                                                            || V_SO_QD
                                                            || '%'
                                       AND A.V_VUANID = QSV.DONID
                               ) ) )
                               AND ( V_NGAY_QD IS NULL--Ngày BA/QĐ
                                     OR ( EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_SOTHAM_BANAN QSV
                                   WHERE
                                           TO_CHAR(QSV.NGAYTUYENAN, 'dd/MM/yyyy') = V_NGAY_QD
                                       AND A.V_VUANID = QSV.DONID
                               )
                                          OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_SOTHAM_QUYETDINH QSV
                                   WHERE
                                           TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD
                                       AND A.V_VUANID = QSV.DONID
                               )
                                          OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_PHUCTHAM_BANAN QSV
                                   WHERE
                                           TO_CHAR(QSV.NGAYTUYENAN, 'dd/MM/yyyy') = V_NGAY_QD
                                       AND A.V_VUANID = QSV.DONID
                               )
                                          OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_PHUCTHAM_QUYETDINH QSV
                                   WHERE
                                           TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD
                                       AND A.V_VUANID = QSV.DONID
                               ) ) )
                               AND ( V_NG_KC IS NULL--tìm người kháng cáo
                                     OR ( EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                            APS_SOTHAM_KHANGCAO T2
                                       INNER JOIN APS_DON_DUONGSU T3 ON T2.DUONGSUID = T3.ID
                                   WHERE
                                           T2.DONID = A.V_VUANID
                                       AND UPPER(T3.TENDUONGSU) LIKE '%'
                                                                     || UPPER(V_NG_KC)
                                                                     || '%'
                               )
                                          OR EXISTS (
                                   SELECT
                                       'X'
                                   FROM
                                       APS_DON_DUONGSU T3
                                   WHERE
                                           T3.DONID = A.V_VUANID
                                       AND UPPER(T3.TENDUONGSU) LIKE '%'
                                                                     || UPPER(V_NG_KC)
                                                                     || '%'
                               ) ) );

    END PS_NHANDON;


 PROCEDURE APS_DON_SEARCH_V2 (
        V_CAPXETXULOGIN             IN VARCHAR2,
        VDONVIID                    IN VARCHAR2,
        VTENVIEC                    IN VARCHAR2,
        VLOAIHINHDOANHNGHIEP        IN VARCHAR2,
        VMAVIEC                     IN VARCHAR2,
        VDUONGSU_NGUOITHAMGIATOTUNG IN VARCHAR2,
        VCAPXETXU                   IN VARCHAR2,
        VTOAXETXU                   IN VARCHAR2,
        VTINHTRANGTHULY             IN VARCHAR2,
        VTUNGAYTHULY                IN VARCHAR2,
        VDENNGAYTHULY               IN VARCHAR2,
        VSOTHULY                    IN VARCHAR2,
        VTINHTRANGGQ                IN VARCHAR2,
        VTUNGAYTINHTRANGGQ          IN VARCHAR2,
        VDENNGAYTINHTRANGGQ         IN VARCHAR2,
        VTHAMPHAN                   IN VARCHAR2,
        VTHOIHANGQ                  IN VARCHAR2,
        VSOQD                       IN VARCHAR2,
        VNGAYQD                     IN VARCHAR2,
        VTHUKY                      IN VARCHAR2,
        VGQDON                      IN VARCHAR2,
        VUYTHACTUPHAP               IN VARCHAR2,
        VPTRUTKINHNGHIEM            IN VARCHAR2,
        VCHECKTK                    IN NUMBER,
        V_TRANGTHAIVUAN             IN NUMBER,
        V_VAITRO_THAMPHAN           IN VARCHAR2,
        V_CHECK_HOAGIAI             IN NUMBER, 
        PAGE_INDEX                  IN INT,
        PAGE_SIZE                   IN INT,
        CURRETURN                   OUT SYS_REFCURSOR
    ) IS

        TOTALITEM        NUMBER;
        MININDEX         NUMBER;
        MAXINDEX         NUMBER;
        HOSO             NUMBER DEFAULT 1;
        SOTHAM           NUMBER DEFAULT 2;
        PHUCTHAM         NUMBER DEFAULT 3;
        VV_NGAYTHULY_TU  DATE;
        VV_NGAYTHULY_DEN DATE;
        V_TABLE_TP       T_QUYETDINH_EXT;
        VV_TUNGAY_GQ     DATE;
        VV_DENNGAY_GQ    DATE;
        V_TABLE_PT       T_QUYETDINH;
        V_TABLE_BC       T_BICANBICAO_EXT;
        V_TABLE_BC_KC    T_BICANBICAO_EXT;
        V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-12102023-tamnc
    BEGIN
    -- Giai đoạn vụ án/vụ việc
    -- HOSO = 1;
    -- SOTHAM = 2;
    -- PHUCTHAM = 3;
    -- THULYGDT = 4;
    -- DINHCHI = 5;

    -- PhanCongTP=0 Tất cả
    -- PhanCongTP=1 Chưa phân công
    -- PhanCongTP=2 Đã phân công
        MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
        MAXINDEX := PAGE_INDEX * PAGE_SIZE;
        V_TABLE_TP := T_QUYETDINH_EXT();
        V_TABLE_PT := T_QUYETDINH();
        V_TABLE_BC := T_BICANBICAO_EXT();
        V_TABLE_BC_KC := T_BICANBICAO_EXT();
        V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-12102023-tamnc
        IF ( VTUNGAYTHULY IS NOT NULL ) THEN
            VV_NGAYTHULY_TU := TO_DATE(TRIM(VTUNGAYTHULY)
                                       || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( VDENNGAYTHULY IS NOT NULL ) THEN
            VV_NGAYTHULY_DEN := TO_DATE(TRIM(VDENNGAYTHULY)
                                        || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( VTUNGAYTINHTRANGGQ IS NOT NULL ) THEN
            VV_TUNGAY_GQ := TO_DATE(TRIM(VTUNGAYTINHTRANGGQ)
                                    || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( VDENNGAYTINHTRANGGQ IS NOT NULL ) THEN
            VV_DENNGAY_GQ := TO_DATE(TRIM(VDENNGAYTINHTRANGGQ)
                                     || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;


   --THAMPHAN --TOANCAU-12102023-tamnc
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM APS_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,7 MAGIAIDOAN
            FROM  APS_KCKNQDK_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TP
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID
                FROM
                    (
                        SELECT
                            DONID,
                            FIRST_VALUE(ID)
                            OVER(PARTITION BY DONID
                                 ORDER BY
                                     NGAYNHANPHANCONG DESC
                            ) ID
                        FROM
                            APS_DON_THAMPHAN
                        WHERE
                            MAVAITRO != 'VTTP_GIAIQUYETDON'
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID
            ) TTS;

        SELECT
            R_QUYETDINH(TTS.DONID, TTS.ID, TTS.MA)
        BULK COLLECT
        INTO V_TABLE_PT
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID,
                    TT.MA
                FROM
                    (
                        SELECT
                            PQD.DONID,
                            FIRST_VALUE(PQD.ID)
                            OVER(PARTITION BY PQD.DONID, QDL.MA
                                 ORDER BY
                                     PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                            ) ID,
                            QDL.MA
                        FROM
                            APS_KCKNQDK_PHUCTHAM_QUYETDINH PQD
                            LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PQD.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID,
                    TT.MA
            ) TTS;

        SELECT
            R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC
        FROM
            (
                SELECT
                    BC.ID,
                    BC.DONID,
                    BC.TENDUONGSU,
                    BC.TUCACHTOTUNG_MA,
                    BC.ROWNUMBER
                FROM
                    (
                        SELECT
                            D.ID,
                            D.DONID,
                            D.TENDUONGSU,
                            D.TUCACHTOTUNG_MA,
                            ROW_NUMBER()
                            OVER(PARTITION BY D.DONID
                                 ORDER BY
                                     D.ISDAIDIEN DESC, D.TENDUONGSU
                            ) ROWNUMBER
                        FROM
                            APS_DON_DUONGSU D
                            LEFT JOIN APS_ANPHI       P ON P.DUONGSU_ID = D.ID
                        WHERE
                            ( ( D.TUCACHTOTUNG_MA = 'NGUYENDON'
                                AND ( P.SOBIENLAI IS NOT NULL
                                      OR P.TINHTRANG = 1 ) )
                              OR D.TUCACHTOTUNG_MA <> 'NGUYENDON' )
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT
            R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC_KC
        FROM
            (
                SELECT
                    BC.ID,
                    BC.DONID,
                    BC.TENDUONGSU,
                    BC.TUCACHTOTUNG_MA,
                    BC.ROWNUMBER
                FROM
                    (
                        SELECT
                            DS.ID,
                            DS.DONID,
                            DS.TENDUONGSU,
                            DS.TUCACHTOTUNG_MA,
                            ROW_NUMBER()
                            OVER(PARTITION BY DS.DONID
                                 ORDER BY
                                     DS.ISDAIDIEN DESC, DS.TENDUONGSU
                            ) ROWNUMBER
                        FROM
                            APS_DON_DUONGSU DS
                        WHERE
                            EXISTS (
                                SELECT
                                    'X'
                                FROM
                                    APS_SOTHAM_KHANGCAO KC
                                WHERE
                                        KC.DUONGSUID = DS.ID
                                    AND KC.DONID = DS.DONID
                            )
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;

        OPEN CURRETURN FOR WITH CTE_DATA AS (
                              SELECT DISTINCT
                                  ( D.MAVUVIEC ),
                                  D.ID,
                                  D.TENVUVIEC,
                                  D.SOTHUTU,
                                  D.NGAYNHANDON,
                                  D.NGUOITAO,
                                  TO_CHAR(D.NGAYTAO, 'dd/MM/yyyy HH24:MI:SS')          AS NGAYTAO,
                                  I.TEN                                                AS QUANHEPL,
                                  D.MAGIAIDOAN,
                                  T.TEN                                                TOASOTHAM,
                                  D.HINHTHUCNHANDON,
                                  'Phúc thẩm'                                          GIAIDOANVUVIEC,
                                  (
                                      CASE D.HINHTHUCNHANDON
                                          WHEN 1 THEN
                                              'Trực tiếp'
                                          WHEN 2 THEN
                                              'Qua bưu điện'
                                          WHEN 3 THEN
                                              'Trực tuyến'
                                      END
                                  )                                                    TENHINHTHUC,
                                  DECODE(D.HINHTHUCNHANDON, 1, '<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>', 270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                         GN.TRUONGHOPGIAONHAN)                         TRUONGHOPGIAONHAN,
                                  NVL('</br><i>Tòa xét xử sơ thẩm: </i><b>'
                                      || T.TEN
                                      || '</b>', '')                                       TENTOASOTHAM,
                                  STBA.BANAN_QD_ST,
                                  STKN.KHANGNGHI_ST,

                                   BAPT.TINHTRANG_GQ as QD_PT,
                                  ( BC3.HOTEN
                                     )                                       HOTENBICAN,
                                  ( TLS.TINHTRANG_GQ
                                    || TLPT.TINHTRANG_GQ )                               CHECK_THULY,
                                  CASE
                                      WHEN TLPT.TINHTRANG_GQ IS NULL THEN
                                              '- Chưa thụ lý'
                                      ELSE
                                          TLPT.TINHTRANG_GQ
                                  END
                                  ||
                                  CASE
                                      WHEN TPPCPT.TINHTRANG_GQ IS NULL
                                           AND TLPT.TINHTRANG_GQ IS NOT NULL THEN
                                              '</br>- Chưa phân công Thẩm phán'
                                      ELSE
                                          TPPCPT.TINHTRANG_GQ
                                  END
                                  || HPTPT.TINHTRANG_GQ
                                  || TDCPT.TINHTRANG_GQ
                                  || DCPT.TINHTRANG_GQ
                                  || CPT.TINHTRANG_GQ
                                  || GNST.TINHTRANG_GQ
                                || BAPT.TINHTRANG_GQ
                                  || PTQD.TINHTRANG_GQ                                 TINHTRANG_GQ,

                                  0 THULYXXLAI
                              FROM
                            APS_DON         D
                 INNER JOIN (SELECT G.* 
                  FROM APS_DON G 
                  WHERE (G.MAGIAIDOAN = 7 AND G.TOAANID = vToaXetXu) 
                  OR(G.TOAANID = vToaXetXu AND G.TOAPHUCTHAMID != vToaXetXu)
                  ) GD ON D.ID=GD.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.*
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          INSTR(',DC,', ','
                                                        || QDL.MA
                                                        || ',') > 0
                                  )               QD ON QD.DONID = D.ID
                                  INNER JOIN APS_DON_DUONGSU DDS ON D.ID = DDS.DONID
                                  LEFT JOIN DM_DATAITEM     I ON D.QUANHEPHAPLUATID = I.ID
                                  LEFT JOIN DM_TOAAN        T ON D.TOAANID = T.ID
                               ----- BA Or QD----------------------------------------------     

                                   LEFT JOIN (
                                          SELECT
                                              PTQDVA.*
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              INSTR(',DC,', ','
                                                            || QDL.MA
                                                            || ',') > 0
                                      )                  QD ON QD.DONID = D.ID
                                      LEFT JOIN (
                                          SELECT
                                              PTQD.DONID,
                                              '<br /><i>- QĐ GQ PT: </i><b>'
                                              || 'Số '
                                              || PTQD.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy')
                                              || '</b><br />- Đã giải quyết xong' TINHTRANG_GQ
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQD
                                              LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQD.QUYETDINHID
                                          WHERE
                                              QD.MA in ('04-PS', '72-DS')
                                      )                  BAPT ON BAPT.DONID = D.ID      


                            ---------------------------------------------------------------------------------     
                                  LEFT JOIN (
                                      SELECT
                                          T2.DONID,
                                          T2.TOAANID,
                                          T2.NGAYTHULY,
                                          T2.SOTHULY,
                                          T2.TRUONGHOPTHULY,
                                          T2.QHPLTKID,
                                          '</br>- Thụ lý số:<b> '
                                          || TO_CHAR(T2.SOTHULY)
                                          || '</b> ngày<b> '
                                          || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy')
                                          || '</b>' TINHTRANG_GQ
                                      FROM
                                          APS_SOTHAM_THULY T2
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(ID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTHULY DESC, NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_SOTHAM_THULY
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  ) QDL
                                              WHERE
                                                  QDL.ID = T2.ID
                                          )
                                  )               TLS ON TLS.DONID = D.ID --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
                                  LEFT JOIN (
                                      SELECT
                                          T2.DONID,
                                          T2.NGAYTHULY,
                                          T2.SOTHULY,
                                          T2.TRUONGHOPTHULY,
                                          '</br>- Thụ lý số:<b> '
                                          || TO_CHAR(T2.SOTHULY)
                                          || '</b> ngày<b> '
                                          || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy')
                                          || '</b>' TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(ID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTHULY DESC, NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_KCKNQDK_PHUCTHAM_THULY
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  ) QDL
                                              WHERE
                                                  QDL.ID = T2.ID
                                          )--> Lấy thụ lý mới nhất
                                  )               TLPT ON TLPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID) AS IDTP,
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'          TINHTRANG_GQ
                                      FROM
                                          APS_DON_THAMPHAN TP
                                          LEFT JOIN (
                                              SELECT
                                                  DONID,
                                                  ID
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(CANBOID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_SOTHAM_HDXX
                                                              WHERE
                                                                  MAVAITRO = 'THAMPHAN'
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  )
                                          )                HD ON HD.DONID = TP.DONID
                                          LEFT JOIN (
                                              SELECT
                                                  GG.*
                                              FROM
                                                  APS_DON_THAMPHAN GG
                                              WHERE
                                                  EXISTS (
                                                      SELECT
                                                          'X'
                                                      FROM
                                                          TABLE ( V_TABLE_TP ) TP
                                                      WHERE
                                                          TP.ID = GG.ID
                                                  )
                                          )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                          LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                          LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                      WHERE
                                          TP.MAVAITRO = 'VTTP_GIAIQUYETSOTHAM'
                                      GROUP BY
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID),
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'
                                  )               TPPC ON TPPC.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID) AS IDTP,
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'          TINHTRANG_GQ
                                      FROM
                                          APS_DON_THAMPHAN TP
                                          LEFT JOIN (
                                              SELECT
                                                  DONID,
                                                  ID
                                              FROM
                                                   (
                                                      SELECT
                                                          TT.DONID,
                                                          TT.ID
                                                      FROM
                                                          (
                                                              SELECT
                                                                  DONID,
                                                                  FIRST_VALUE(CANBOID)
                                                                  OVER(PARTITION BY DONID
                                                                       ORDER BY
                                                                           NGAYTAO DESC
                                                                  ) ID
                                                              FROM
                                                                  APS_KCKNQDK_PHUCTHAM_HDXX
                                                              WHERE
                                                                  MAVAITRO = 'THAMPHAN'
                                                          ) TT
                                                      GROUP BY
                                                          TT.DONID,
                                                          TT.ID
                                                  )
                                          )                HD ON HD.DONID = TP.DONID
                                          LEFT JOIN (
                                              SELECT
                                                  GG.*
                                              FROM
                                                  APS_DON_THAMPHAN GG
                                              WHERE
                                                  EXISTS (
                                                      SELECT
                                                          'X'
                                                      FROM
                                                          TABLE ( V_TABLE_TP ) TP
                                                      WHERE
                                                          TP.ID = GG.ID
                                                  )
                                          )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                          LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                          LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                      WHERE
                                          TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                      GROUP BY
                                          TP.DONID,
                                          DECODE(CBB.ID, NULL, CB.ID, CBB.ID),
                                          '</br>- Thẩm phán: <b>'
                                          || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                          || '</b><i> (chủ tọa)</i>'
                                  )               TPPCPT ON TPPCPT.DONID = D.ID
--                                  LEFT JOIN (
--                                      SELECT
--                                          BC.DONID,
--                                          '<br /><i>Người kháng cáo:</i> <br />'
--                                          ||
--                                          LISTAGG(BC.TENDUONGSU
--                                                  || ' '
--                                                  || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Nguyên đơn)', 'BIDON', '(Bị đơn)',
--                                                            'QUYENNVLQ', '(Người có quyền và NVLQ)', ' ('
--                                                                                                     || BC.TUCACHTOTUNG_MA
--                                                                                                     || ')'), '</b><br/>') WITHIN GROUP(
--                                              ORDER BY
--                                                  BC.ROWNUMBER
--                                              )
--                                          HOTEN
--                                      FROM
--                                          TABLE ( V_TABLE_BC ) BC
--                                      GROUP BY
--                                          BC.DONID
--                                  )               BC2 ON BC2.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          BC.DONID,
                                          '<br /><i>Người kháng cáo:</i> <b>'
                                          ||
                                          LISTAGG(BC.TENDUONGSU
                                                  || ' '
                                                  || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Nguyên đơn)', 'BIDON', '(Bị đơn)',
                                                            'QUYENNVLQ', '(Người có quyền và NVLQ)', ' ('
                                                                                                     || BC.TUCACHTOTUNG_MA
                                                                                                     || ')'), '</b><br/>') WITHIN GROUP(
                                              ORDER BY
                                                  BC.ROWNUMBER
                                              )
                                          HOTEN
                                      FROM
                                          TABLE ( V_TABLE_BC_KC ) BC
                                      GROUP BY
                                          BC.DONID
                                  )               BC3 ON BC3.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          CA.VUANID,
                                          I.TEN TRUONGHOPGIAONHAN
                                      FROM
                                               DM_DATAITEM I
                                          INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                      WHERE
                                          CA.TOANHANID = VTOAXETXU
                                      GROUP BY
                                          CA.VUANID,
                                          I.TEN
                                  )               GN ON GN.VUANID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          BA.DONID,
                                          '<br />BA/QĐ sơ thẩm: <b>'
                                          || 'Số '
                                          || BA.SOBANAN
                                          || ' ngày '
                                          || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy')
                                          || '</b>' BANAN_QD_ST
                                      FROM
                                          APS_SOTHAM_BANAN BA
                                  )               STBA ON STBA.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          KN.DONID,
                                          '<br /><i>Kháng nghị:</i> <br />'
                                          ||
                                          LISTAGG('Số '
                                                  || KN.SOKN
                                                  || ' ngày '
                                                  || TO_CHAR(KN.NGAYKN, 'dd/MM/yyyy'), '<br/>') WITHIN GROUP(
                                              ORDER BY
                                                  KN.NGAYKN
                                              )
                                          KHANGNGHI_ST
                                      FROM
                                          APS_SOTHAM_KHANGNGHI KN
                                          where KN.TINHTRANG_GIAIQUYET != 3
                                      GROUP BY
                                          KN.DONID
                                  )               STKN ON STKN.DONID = D.ID



        ----------------------------                          

                                  LEFT JOIN (
                                      SELECT
                                          CA.VUANID,
                                             -- '</br>- '
                                            --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                           '</br>- Đã chuyển vụ án' TINHTRANG_GQ
                                      FROM
                                               DM_DATAITEM I
                                          INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                      WHERE
                                          CA.TOACHUYENID = VTOAXETXU
                                      GROUP BY
                                          CA.VUANID,
                                                  -- '</br>- '
                                              --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                           '</br>- Đã chuyển vụ án'
                                  )               GNST ON GNST.VUANID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ CVA số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',CVA,', ','
                                                                     || QDL.MA
                                                                     || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ CVA số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               CPT ON CPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ ĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',DC,', ','
                                                                    || QDL.MA
                                                                    || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ ĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               DCPT ON DCPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ TĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',TDC,', ','
                                                                     || QDL.MA
                                                                     || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ TĐC số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               TDCPT ON TDCPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ HPT số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                      WHERE
                                          EXISTS (
                                              SELECT
                                                  'X'
                                              FROM
                                                  TABLE ( V_TABLE_PT ) QDL
                                              WHERE
                                                      QDL.ID = PTQDVA.ID
                                                  AND INSTR(',HPT,', ','
                                                                     || QDL.MA
                                                                     || ',') > 0
                                          )
                                      GROUP BY
                                          PTQDVA.DONID,
                                          '</br>- QĐ HPT số: '
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                  )               HPTPT ON HPTPT.DONID = D.ID
                                  LEFT JOIN (
                                      SELECT
                                          PTQDVA.DONID,
                                          '</br>- QĐ '
                                          || DECODE(QDL.MA, 'KMTTPS', 'không mở thủ tục phá sản số: ', 'MTTPS', 'mở thủ tục phá sản số: ',
                                                    'DC', 'đình chỉ tiến hành thủ tục phá sản số: ')
                                          || PTQDVA.SOQD
                                          || ' ngày '
                                          || TO_CHAR(PTQDVA.NGAYQD, 'DD/MM/YYYY') TINHTRANG_GQ
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          QDL.MA IN ( 'MTTPS', 'KMTTPS', 'DC' )
                --and ptba.sobanan is not null
                                  )               PTQD ON PTQD.DONID = D.ID
                              WHERE
                                      D.MAGIAIDOAN = 7
                                  AND  D.TOAPHUCTHAMID = VDONVIID
                                  AND ( VLOAIHINHDOANHNGHIEP IS NULL
                                        OR DDS.LOAIDUONGSU = VLOAIHINHDOANHNGHIEP )
                                  AND ( VUYTHACTUPHAP IS NULL
                                        OR ( VUYTHACTUPHAP IS NOT NULL
                                             AND (  EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY TLPT
                                      WHERE
                                              TLPT.UTTPDI = TO_NUMBER(VUYTHACTUPHAP)
                                          AND TLPT.DONID = D.ID
                                  ) ) ) )
                                  AND ( VMAVIEC IS NULL
                                        OR ( LOWER(D.MAVUVIEC) LIKE '%'
                                                                    || LOWER(VMAVIEC)
                                                                    || '%' ) )
                                  AND ( VTENVIEC IS NULL
                                        OR ( LOWER(D.TENVUVIEC) LIKE '%'
                                                                     || LOWER(VTENVIEC)
                                                                     || '%' ) )--Tên vụ án
                                  AND  D.TOAPHUCTHAMID = VTOAXETXU
                                               AND V_CAPXETXULOGIN = 'CAPTINH'
                                 --26/06/2023 tuyennh sua tim kiem theo tinh trang thu ly start--               
                                  AND ( ( VTINHTRANGTHULY IS NULL

                                  AND (vtungaythuly IS NULL OR  d.NGAYTAO>=VV_NGAYTHULY_TU) 
                                  AND (vDenNgayThuLy IS NULL OR d.NGAYTAO<=VV_NGAYTHULY_DEN)   
                    /*AND(
                    (((vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN))
                    or ((vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN))))*/ 
                                        )
                                        OR ( VTINHTRANGTHULY = 1
                                             AND ( ( TLPT.DONID IS NOT NULL
                                                     AND ( VTUNGAYTHULY IS NULL
                                                           OR TLPT.NGAYTHULY >= VV_NGAYTHULY_TU )
                                                     AND ( VDENNGAYTHULY IS NULL
                                                           OR TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) 
                                                    ) 
                                                 ) 
                                            )
                                        OR ( VTINHTRANGTHULY = 2
                                             AND ( TLS.DONID IS NULL
                                                   AND TLPT.DONID IS NULL )
                     /*AND (vtungaythuly IS NULL OR  d.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (vDenNgayThuLy IS NULL OR d.NGAYTAO<=VV_NGAYTHULY_DEN)   */
                                        AND ( ( VTUNGAYTHULY IS NULL
                                          OR TLPT.NGAYTHULY >= VV_NGAYTHULY_TU )
                                        AND ( VDENNGAYTHULY IS NULL
                                              OR TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) )
                                            ) 
                                     )
                         --26/06/2023 tuyennh sua tim kiem theo tinh trang thu ly end--          
          -----
                                  AND ( VSOTHULY IS NULL
                                        OR ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_SOTHAM_THULY
                                      WHERE
                                              DONID = D.ID
                                          AND UPPER(SOTHULY) = UPPER(VSOTHULY)
                                  )
                                             OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_SOTHAM_THULY
                                      WHERE
                                              DONID = D.ID
                                          AND UPPER(SOTHULY) = UPPER(VSOTHULY)
                                  ) ) )--Số Thụ lý
                                  AND ( 1 = (
                                      CASE
                                          WHEN ( VDUONGSU_NGUOITHAMGIATOTUNG
                                                 || ' ' ) = ' ' THEN
                                              1
                                          WHEN (
                                              SELECT
                                                  COUNT(ID)
                                              FROM
                                                  APS_DON_DUONGSU S
                                              WHERE
                                                      S.DONID = D.ID
                                                  AND LOWER(S.TENDUONGSU) LIKE ( '%'
                                                                                 || LOWER(VDUONGSU_NGUOITHAMGIATOTUNG)
                                                                                 || '%' )
                                          ) > 0          THEN
                                              1
                                          ELSE
                                              0
                                      END
                                  ) )


                                  --AND ( VTHAMPHAN IS NULL
                                  --      OR UPPER(TPPC.IDTP) LIKE '%'
                                  ----                               || UPPER(VTHAMPHAN)
                                  --                               || '%'
                                  --      OR UPPER(TPPCPT.IDTP) LIKE '%'
                                  --                                || UPPER(VTHAMPHAN)
                                  --                                 || '%' )
                                  --26/06/2023 toancau-tuyennh them tim kiem theo ten tham phan--                               
                                and (VTHAMPHAN IS NULL or
                                exists( 
                                          SELECT
                                              TP.DONID
                                          FROM
                                              APS_DON_THAMPHAN TP
                                              LEFT JOIN (
                                                  SELECT
                                                      TT.DONID,
                                                      TT.ID
                                                  FROM
                                                      (
                                                          SELECT
                                                              DONID,
                                                              FIRST_VALUE(CANBOID)
                                                              OVER(PARTITION BY DONID
                                                                   ORDER BY
                                                                       NGAYTAO DESC
                                                              ) ID
                                                          FROM
                                                              APS_KCKNQDK_PHUCTHAM_HDXX
                                                          WHERE
                                                              MAVAITRO = 'THAMPHAN'
                                                      ) TT
                                                  GROUP BY
                                                      TT.DONID,
                                                      TT.ID
                                              )                HD ON HD.DONID = TP.DONID
                                              LEFT JOIN (
                                                  SELECT
                                                      GG.*
                                                  FROM
                                                      APS_DON_THAMPHAN GG
                                                  WHERE
                                                      EXISTS (
                                                          SELECT
                                                              'X'
                                                          FROM
                                                              (
                                                                  SELECT
                                                                      TT.DONID,
                                                                      TT.ID
                                                                  FROM
                                                                      (
                                                                          SELECT
                                                                              DONID,
                                                                              FIRST_VALUE(ID)
                                                                              OVER(PARTITION BY DONID
                                                                                   ORDER BY
                                                                                       NGAYNHANPHANCONG DESC
                                                                              ) ID
                                                                          FROM
                                                                              APS_DON_THAMPHAN
                                                                      ) TT
                                                                  GROUP BY
                                                                      TT.DONID,
                                                                      TT.ID
                                                              ) TP
                                                          WHERE
                                                              TP.ID = GG.ID
                                                      )
                                              )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                              LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                              LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                          WHERE
                                              TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' and TP.DONID = D.ID and cbb.id=VTHAMPHAN 
                                          GROUP BY
                                              TP.DONID
                                      ))  


                             and (VTHAMPHAN IS NULL
                                -- TOANCAU-13102023-tamnc\
                                   OR(V_VAITRO_THAMPHAN IS NULL 
                                       AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.CANBOID = VTHAMPHAN AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
                                    OR (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC'
                                            AND EXISTS (SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.MAVAITRO IN ('VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = VTHAMPHAN))
                                   OR(V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA'
                                       AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.MAVAITRO IN ('THAMPHAN','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = VTHAMPHAN AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
                                    OR(V_VAITRO_THAMPHAN IN ('VTTP_GIAIQUYETDON','THAMPHANHDXX','THAMPHANDUKHUYET')
                                      AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = D.ID AND TP.MAVAITRO =V_VAITRO_THAMPHAN AND TP.CANBOID = VTHAMPHAN AND TP.MAGIAIDOAN = GD.MAGIAIDOAN )))
                --26/06/2023 toancau-tuyennh them tim kiem theo ten tham phan end-- 
                                  AND ( VGQDON IS NULL --or EXISTS ( SELECT 'X' FROM APS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=vGQDon AND XL.DONID=d.ID)
                                        OR ( ( VGQDON = 1
                                               OR VGQDON = 3
                                               OR VGQDON = 4
                                               OR VGQDON = 5 )
                                             AND EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                              XL.LOAIGIAIQUYET = VGQDON
                                          AND XL.DONID = D.ID
                                  ) )
                                        OR ( VGQDON = 6
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                          XL.DONID = D.ID
                                  ) )
                                        OR ( VGQDON = 7
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                          XL.DONID = D.ID
                                  )
                                             AND ( SYSDATE - D.NGAYNHANDON ) > 15 )
                                        OR ( VGQDON = 8
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_XULY XL
                                      WHERE
                                          XL.DONID = D.ID
                                  )
                                             AND NOT EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_THAMPHAN TP
                                      WHERE
                                          TP.DONID = D.ID
                                  ) ) )
                                  AND ( VTHUKY IS NULL--Thư ký
                                        OR ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_SOTHAM_HDXX TP
                                      WHERE
                                              TP.CANBOID = VTHUKY
                                          AND TP.DONID = D.ID
                                  )
                                             OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_HDXX TP
                                      WHERE
                                              TP.CANBOID = VTHUKY
                                          AND TP.DONID = D.ID
                                  )
                                             OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_DON_THAMPHAN TP
                                      WHERE
                                              TP.DONID = D.ID
                                          AND TP.THUKYID = VTHUKY
                                  ) ) )   
        -- vTinhTrangGQ
        --26/06/2023 toancau-tuyennh sua tim kiem theo tinh trang giai quyet start--
                                  AND ( ( VTINHTRANGGQ IS NULL
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR D.NGAYTAO >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR D.NGAYTAO <= VV_DENNGAY_GQ ) )
                                        OR ( VTINHTRANGGQ = 1 --Chưa giải quyết xong
--                                             AND ( EXISTS (
--                                      SELECT
--                                          'X'
--                                      FROM
--                                          APS_KCKNQDK_PHUCTHAM_THULY PTTL
--                                      WHERE
--                                          ( NOT EXISTS (
--                                              SELECT
--                                                  'X'
--                                              FROM
--                                                  APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                                                  LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
--                                                  LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
--                                              WHERE
--                                                      INSTR(',DC,CVA,CNTT,', ','
--                                                                             || QDL.MA
--                                                                             || ',') > 0
--                                                  AND PTTL.DONID = PTQDVA.DONID
--                                          ) )
--                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
--                                                OR PTTL.NGAYTHULY >= VV_TUNGAY_GQ )
--                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
--                                                OR PTTL.NGAYTHULY <= VV_DENNGAY_GQ )
--                                          AND PTTL.DONID = D.ID
--                                  ) ) 
                                --da thu ly
                                AND (TLPT.NGAYTHULY IS NOT NULL) 
                              AND ( EXISTS(
                              SELECT
                                              'X'
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA IN (
                                                  '04-PS',
                                                  '72-DS'
                                              ) 
                                              AND PTQDVA.DONID = D.ID
                                              AND PTQDVA.NGAYQD IS NOT NULL AND vDenNgayTinhTrangGQ IS NOT NULL AND VV_DENNGAY_GQ<PTQDVA.NGAYQD
                              ) OR (NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              APS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA IN (
                                                  '04-PS',
                                                  '72-DS'
                                              ) 
                                              AND PTQDVA.DONID = D.ID
                                      ) 
                                AND(

                                  --chua phan cong tham phan
                                  (

                                    (
                                      vTuNgayTinhTrangGQ IS NULL 
                                      OR TLPT.NGAYTHULY >= VV_TUNGAY_GQ
                                    ) 
                                    AND (
                                      vDenNgayTinhTrangGQ IS NULL 
                                      OR TLPT.NGAYTHULY <= VV_DENNGAY_GQ
                                    ) 
                                    AND NOT EXISTS(
                                      SELECT 
                                        'x' 
                                      FROM 
                                        APS_DON_THAMPHAN PC 
                                          WHERE 
                                            PC.DONID = D.ID 
                                        AND (
                                          (
                                            PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                          )
                                        ) 
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ
                                        )
                                    )
                                      ) --da phan cong tham phan
                                  or (
                                    EXISTS(
                                      SELECT 
                                        'x' 
                                      FROM 
                                        APS_DON_THAMPHAN PC 
                                      WHERE 
                                        PC.DONID = D.ID 
                                        AND (
                                          (
                                            PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' 
                                          ) --phuc thẩm
                                          ) 
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ
                                        )
                                    )
                                  ) --da len lich xx
                                  or(
                                    EXISTS(
                                      SELECT  'X' FROM   APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='DVARXX' --đưa vụ án ra xét xử
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID
                                    )
                                  ) --dang hoan
                                  or(
                                    EXISTS(
                                      SELECT 
                                        'X' 
                                      FROM 
                                        APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                        LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
                                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                      WHERE 
                                        PTBA.DONID IS NULL 
                                        AND QDL.MA = 'HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ
                                        ) 
                                        AND PTQDVA.DONID = D.ID 
                                    )
                                  ) --dang tdc
                                  or(
                                    EXISTS(
                                      SELECT 
                                        'X' 
                                      FROM 
                                        APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                        LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
                                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                      WHERE 
                                        PTBA.DONID IS NULL 
                                        AND QDL.MA = 'TDC' -- QDL.MA ='TDC' Tam dinh chi
                                        AND (
                                          vTuNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ
                                        ) 
                                        AND (
                                          vDenNgayTinhTrangGQ IS NULL 
                                          OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ
                                        ) 
                                        AND PTQDVA.DONID = D.ID 
                                    )
                                  )
                                ) ) )                                  
                                  )
                                        OR ( VTINHTRANGGQ = 2 --chưa phân công Thẩm phán
--                                             AND ( TPPC.DONID IS NULL
--                                                   AND TPPCPT.DONID IS NULL )
--                                             AND ( VTUNGAYTINHTRANGGQ IS NULL
--                                                   OR D.NGAYTAO >= VV_TUNGAY_GQ )
--                                             AND ( VDENNGAYTINHTRANGGQ IS NULL
--                                                   OR D.NGAYTAO <= VV_DENNGAY_GQ ) 

                                             AND( TLPT.NGAYTHULY IS NOT NULL )
                                            AND (  vTuNgayTinhTrangGQ IS NULL  OR TLPT.NGAYTHULY >= VV_TUNGAY_GQ  ) 
                                           AND ( VDENNGAYTINHTRANGGQ IS NULL  OR TLPT.NGAYTHULY <= VV_DENNGAY_GQ )
                                         AND ( 
                                            NOT EXISTS (
                                          SELECT
                                              'x'
                                          FROM
                                              APS_DON_THAMPHAN PC
                                          WHERE
                                              PC.DONID = D.ID
                                              AND ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                       ))
                                            AND ( vTuNgayTinhTrangGQ IS NULL
                                                    OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ )
                                              AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                    OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ )

                                                  ))

                                                   )
                                        OR ( VTINHTRANGGQ = 3 --đã phân công Thẩm phán
                                             AND EXISTS (
                                      SELECT
                                          'x'
                                      FROM
                                          APS_DON_THAMPHAN PC
                                      WHERE
                                              PC.DONID = D.ID
                                          AND PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' --phuc thẩm

                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PC.NGAYPHANCONG >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PC.NGAYPHANCONG <= VV_DENNGAY_GQ )
                                  ) )
                                  --tuyennh 29/06/2023 thêm điều kiện tìm kiếm start
                                        OR ( VTINHTRANGGQ = 4 -- đã lên lịch họp
                                        AND ( EXISTS ( 
                            SELECT  'X' FROM   APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='DVARXX' --đưa vụ án ra xét xử
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID 
                                        ))
                                          )
                                          --tuyennh 29/06/2023 thêm điều kiện tìm kiếm end
                                        OR ( VTINHTRANGGQ = 5 --Đang hoãn  
                                             AND (
                      --Đang hoãn phuc tham                 
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              QDL.MA = 'HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                                             AND ( 
                     --phuc tham Đang tạm đình chỉ                
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              QDL.MA = 'TDC' --Tạm đình chỉ
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                   ------------------------------
                                        OR ( VTINHTRANGGQ = 7 --Đã giải quyết xong
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                      WHERE
                                          QD.MA IN ( '04-PS', '72-DS' )
                                          AND ( VTUNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 8
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          ( VTUNGAYTINHTRANGGQ IS NULL
                                            OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND QDL.MA = 'KMTTPS'
                                --and PTBA.sobanan is not null
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 9
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          ( VTUNGAYTINHTRANGGQ IS NULL
                                            OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND QDL.MA = 'MTTPS'
                                          AND PTQDVA.DONID = D.ID
                                  ) ) )
                                        OR ( VTINHTRANGGQ = 10
                                             AND ( EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                          ( VTUNGAYTINHTRANGGQ IS NULL
                                            OR PTQDVA.NGAYQD >= VV_TUNGAY_GQ )
                                          AND ( VDENNGAYTINHTRANGGQ IS NULL
                                                OR PTQDVA.NGAYQD <= VV_DENNGAY_GQ )
                                          AND QDL.MA = 'DC'
                                          AND PTQDVA.DONID = D.ID
                                  ) ) ) )
             -- END vTinhTrangGQ
             --26/06/2023 toancau-tuyennh sua tim kiem theo tinh trang giai quyet end--
                                  AND ( VTHOIHANGQ IS NULL
                                        OR ( VTHOIHANGQ = 1 --Đã hết thời hạn
                                             AND (  
                            --dùng ngày QĐ phúc thẩm  
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY TL
                                          LEFT JOIN APS_SOTHAM_QUYETDINH       QSV ON TL.DONID = QSV.DONID
                                          LEFT JOIN DM_QD_LOAI                 QDL ON QDL.ID = QSV.LOAIQDID
                                      WHERE
                                          ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                               || QDL.MA
                                                                               || ',') > 0
                                              AND ( QSV.NGAYQD - TL.NGAYTHULY ) > 90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                            OR ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                  || QDL.MA
                                                                                  || ',') = 0
                                                 AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
                                          AND TL.DONID = D.ID
                                  ) ) )
                                        OR ( VTHOIHANGQ = 2 --Còn thời hạn dưới 10 ngày
                                             AND (
                          --phúc thẩm   
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY     TL
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              ( SYSDATE - TL.NGAYTHULY ) >= 80
                                          AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                          AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                             || QDL.MA
                                                                             || ',') = 0
                                                OR INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                || QDL.MA
                                                                                || ',') IS NULL )
                                          AND TL.DONID = D.ID
                                  ) ) )
                                        OR ( VTHOIHANGQ = 3
                                             AND (
                          --phúc thẩm   
                                              EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_THULY     TL
                                          LEFT JOIN APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                          LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                          LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                      WHERE
                                              ( SYSDATE - TL.NGAYTHULY ) >= 70
                                          AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                          AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                             || QDL.MA
                                                                             || ',') = 0
                                                OR INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                || QDL.MA
                                                                                || ',') IS NULL )
                                          AND TL.DONID = D.ID
                                  ) ) ) )
                                  AND ( VCHECKTK = 0
                                        OR (
                                      SELECT
                                          COUNT(*)
                                      FROM
                                          APS_DON_THAMPHAN TP
                                      WHERE
                                              TP.DONID = D.ID
                                          AND TP.THUKYID = VCHECKTK
                                          AND TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                  ) > 0 )
                                  AND ( VSOQD IS NULL--Số BA/QĐ
                                        OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                      WHERE
                                          UPPER(QSV.SOQD) LIKE '%'
                                                               || VSOQD
                                                               || '%'
                                          AND D.ID = QSV.DONID
                                  ) )
                                  AND ( VNGAYQD IS NULL--Ngày BA/QĐ
                                        OR EXISTS (
                                      SELECT
                                          'X'
                                      FROM
                                          APS_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                      WHERE
                                              TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = VNGAYQD
                                          AND D.ID = QSV.DONID
                                  ) )
                          ), CTE_TOTAL AS (
                              SELECT
                                  COUNT(ID) AS TOTAL
                              FROM
                                  CTE_DATA
                          ), CTE_FINAL AS (
                              SELECT
                                  ROW_NUMBER()
                                  OVER(
                                      ORDER BY
                                          A.NGAYNHANDON DESC
                                  ) STT,
                                  A.ID,
                                  A.MAVUVIEC,
                                  A.TENVUVIEC,
                                  A.SOTHUTU,
                                  A.NGAYNHANDON,
                                  A.NGUOITAO,
                                  A.NGAYTAO,
                                  A.QUANHEPL,
                                  A.MAGIAIDOAN,
                                  A.TOASOTHAM,
                                  A.HINHTHUCNHANDON,
                                  A.GIAIDOANVUVIEC,
                                  A.TENHINHTHUC,
                                  A.TRUONGHOPGIAONHAN,
                                  A.CHECK_THULY,
                                  A.THULYXXLAI,
                                  A.TINHTRANG_GQ,
                                  A.TENTOASOTHAM,
                                  A.BANAN_QD_ST,
                                  A.KHANGNGHI_ST,
                                  A.HOTENBICAN,
                                  A.QD_PT,
                                  (
                                      SELECT
                                          TOTAL
                                      FROM
                                          CTE_TOTAL
                                  ) AS COUNTALL
                              FROM
                                  CTE_DATA A
                          )
                          SELECT
                              A.*
                          FROM
                              CTE_FINAL A
                          WHERE
                              A.STT BETWEEN MININDEX AND MAXINDEX;

    END APS_DON_SEARCH_V2;


END PKG_STPT_APS_GS;

/
