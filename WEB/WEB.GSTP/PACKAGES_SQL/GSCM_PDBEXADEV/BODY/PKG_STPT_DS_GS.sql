--------------------------------------------------------
--  DDL for Package Body PKG_STPT_DS_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_DS_GS" AS

    PROCEDURE DON_SEARCH_PTQDK (
        V_CAP_XET_XU_LOGIN      IN    VARCHAR2,
        V_TEN_VU_AN             IN    VARCHAR2,
        V_QHPL                  IN    VARCHAR2,
        V_MA_VU_AN              IN    VARCHAR2,
        V_TENDUONGSU            IN    VARCHAR2,
        V_CAPXX                 IN    VARCHAR2,
        V_TOAAN_ID              IN    VARCHAR2,
        V_TINHTRANG_THULY       IN    VARCHAR2,
        V_NGAYTHULY_TU          IN    VARCHAR2,
        V_NGAYTHULY_DEN         IN    VARCHAR2,
        V_SOTHULY               IN    VARCHAR2,
        V_THAMPHAN_ID           IN    VARCHAR2,
        V_TINHTRANG_GIAIQUYET   IN    VARCHAR2,
        V_TUNGAY                IN    VARCHAR2,
        V_DENNGAY               IN    VARCHAR2,
        V_KETQUA                IN    VARCHAR2,
        V_SO_QD                 IN    VARCHAR2,
        V_NGAY_QD               IN    VARCHAR2,
        V_THUKY_ID              IN    VARCHAR2,
        V_THOIHAN_GQ            IN    VARCHAR2,
        V_LOAIDON               IN    VARCHAR2,
        V_PT_RKINHNGHIEM        IN    VARCHAR2,
        V_GQDON                 IN    VARCHAR2,
        V_UTTP                  IN    VARCHAR2,
        VCHECKTK                IN    NUMBER,
        V_CHECK_PTQDK           IN    NUMBER,
        PAGE_INDEX              IN    INT,
        PAGE_SIZE               IN    INT,
        CURRETURN               OUT   SYS_REFCURSOR
    ) IS

        TOTALITEM            NUMBER;
        MININDEX             NUMBER;
        MAXINDEX             NUMBER;
        VV_TUNGAY            DATE;
        VV_DENNGAY           DATE;
        VV_NGAYTHULY_TU      DATE;
        VV_NGAYTHULY_DEN     DATE;
        V_TABLE_TP           T_QUYETDINH_EXT;
        V_TABLE_BC           T_BICANBICAO_EXT;
        V_TABLE_BC_KC        T_BICANBICAO_EXT;
        V_TABLE_TLPTQDK      T_QUYETDINH_EXT;
        V_TABLE_HDXX_PTQDK   T_QUYETDINH_EXT;
        V_TABLE_PTQDK        T_QUYETDINH_EXT;
    BEGIN
        V_TABLE_TP := T_QUYETDINH_EXT();
        V_TABLE_BC := T_BICANBICAO_EXT();
        V_TABLE_BC_KC := T_BICANBICAO_EXT();
        V_TABLE_TLPTQDK := T_QUYETDINH_EXT();
        V_TABLE_HDXX_PTQDK := T_QUYETDINH_EXT();
        V_TABLE_PTQDK := T_QUYETDINH_EXT();
    ---------------------------------------

        MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
        MAXINDEX := PAGE_INDEX * PAGE_SIZE;
    ----------

        IF ( V_NGAYTHULY_TU IS NOT NULL ) THEN
            VV_NGAYTHULY_TU := TO_DATE(TRIM(V_NGAYTHULY_TU)
                                       || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( V_NGAYTHULY_DEN IS NOT NULL ) THEN
            VV_NGAYTHULY_DEN := TO_DATE(TRIM(V_NGAYTHULY_DEN)
                                        || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;  
     --

        IF ( V_TUNGAY IS NOT NULL ) THEN
            VV_TUNGAY := TO_DATE(TRIM(V_TUNGAY)
                                 || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( V_DENNGAY IS NOT NULL ) THEN
            VV_DENNGAY := TO_DATE(TRIM(V_DENNGAY)
                                  || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;  
   ------------------------

   ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.

        --ADS_KCKNQDK_PHUCTHAM_THULY

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TLPTQDK
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID
                FROM
                    (
                        SELECT
                            DONID,
                            FIRST_VALUE(ID) OVER(
                                PARTITION BY DONID
                                ORDER BY
                                    NGAYTHULY DESC, NGAYTAO DESC
                            ) ID
                        FROM
                            ADS_KCKNQDK_PHUCTHAM_THULY
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID
            ) TTS;  

        --THAMPHAN tham phan chu toa PTQDK

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_HDXX_PTQDK
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID
                FROM
                    (
                        SELECT
                            DONID,
                            FIRST_VALUE(CANBOID) OVER(
                                PARTITION BY DONID
                                ORDER BY
                                    NGAYTAO DESC
                            ) ID
                        FROM
                            ADS_KCKNQDK_PHUCTHAM_HDXX
                        WHERE
                            MAVAITRO = 'THAMPHAN'
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID
            ) TTS;     
       ---THAMPHAN giai quyet

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
                            FIRST_VALUE(ID) OVER(
                                PARTITION BY DONID
                                ORDER BY
                                    NGAYNHANPHANCONG DESC
                            ) ID
                        FROM
                            ADS_DON_THAMPHAN
                        WHERE
                            MAVAITRO != 'VTTP_GIAIQUYETDON'
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID
            ) TTS;       
         --ADS_KCKNQDK_PHUCTHAM_QUYETDINH

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, TTS.MA)
        BULK COLLECT
        INTO V_TABLE_PTQDK
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
                            FIRST_VALUE(PQD.ID) OVER(
                                PARTITION BY PQD.DONID, QDL.MA
                                ORDER BY
                                    PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                            ) ID,
                            QDL.MA
                        FROM
                            ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PQD
                            LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PQD.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID,
                    TT.MA
            ) TTS;
          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  

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
                            ROW_NUMBER() OVER(
                                PARTITION BY D.DONID
                                ORDER BY
                                    D.ISDAIDIEN DESC, D.TENDUONGSU
                            ) ROWNUMBER
                        FROM
                            ADS_DON_DUONGSU   D
                            LEFT JOIN ADS_ANPHI         P ON P.DUONGSU_ID = D.ID
                        WHERE
                            D.ISDAIDIEN = 0
                            AND ( ( D.TUCACHTOTUNG_MA = 'NGUYENDON'
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
                            ROW_NUMBER() OVER(
                                PARTITION BY DS.DONID
                                ORDER BY
                                    DS.ISDAIDIEN DESC, DS.TENDUONGSU
                            ) ROWNUMBER
                        FROM
                            ADS_DON_DUONGSU DS
                        WHERE
                            EXISTS (
                                SELECT
                                    'X'
                                FROM
                                    ADS_SOTHAM_KHANGCAO KC
                                WHERE
                                    KC.DUONGSUID = DS.ID
                                    AND KC.DONID = DS.DONID
                            )
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;             
   -----------------------

        OPEN CURRETURN FOR SELECT
                              TT.*
                          FROM
                              (
                                  SELECT
                                      ROW_NUMBER() OVER(
                                          ORDER BY
                                              A.NGAYTAO DESC
                                      ) STT,
                                      COUNT(*) OVER() AS COUNTALL,
                                      A.ID,
                                      A.MAVUVIEC,
                                      A.TENVUVIEC,
                                      A.SOTHUTU,
                                      A.NGAYNHANDON,
                                      A.NGUOITAO,
                                      TO_CHAR(A.NGAYTAO, 'dd/MM/yyyy')
                                      || '<br/>'
                                      || TO_CHAR(A.NGAYTAO, ' HH24:MI:SS') NGAYTAO,
                                      I.TEN AS QUANHEPL,
                                      DECODE(GD.MAGIAIDOAN, 7, '</br><i>Tòa xét xử sơ thẩm: </i><b>'
                                                               || NVL(TST.TEN, T.TEN)
                                                               || '</b>', NULL) TENTOASOTHAM,
                                      DECODE(GD.MAGIAIDOAN, 2, 'Sơ thẩm', 3, 'Phúc thẩm',
                                             4, 'Thụ lý Giám đốc thẩm', 7, 'Phúc thẩm', '') GIAIDOANVUVIEC,
--      GN.TRUONGHOPGIAONHAN,

                                      A.HINHTHUCNHANDON,
                                      DECODE(A.HINHTHUCNHANDON, 1, '<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>', 270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'
                                      ,
                                             '<br/><i>TH giao nhận:</i> <b>'
                                             || GN.TRUONGHOPGIAONHAN
                                             || '</b>') TRUONGHOPGIAONHAN,
                                      '' AS BANAN_QD_ST,
                                      PTQD.QD_PT,
                                      STKN.KHANGNGHI_ST,
                                      A.MAGIAIDOAN,
                                      ( BC3.HOTEN ) HOTENBICAN,
                                      DECODE(XLD.LOAIGIAIQUYET, 1, '- Đã chuyển đơn',
                                             CASE
                                                 WHEN(TLPT.TINHTRANG_GQ) IS NULL THEN
                                                     '- Chưa thụ lý'
                                                 ELSE
                                                     (TLPT.TINHTRANG_GQ)
                                             END
                                             ||
                                             CASE
                                                 WHEN(TPPCPT.TINHTRANG_GQ) IS NULL
                                                     AND(TLPT.TINHTRANG_GQ) IS NOT NULL THEN
                                                     '</br>- Chưa phân công Thẩm phán'
                                                 ELSE
                                                     (TPPCPT.TINHTRANG_GQ)
                                             END
                                             || HPTPT.TINHTRANG_GQ
                                             || TDCPT.TINHTRANG_GQ
                                             || DCPT.TINHTRANG_GQ
                                             || THSPT.TINHTRANG_GQ
                                             || CPT.TINHTRANG_GQ
                                             || GQPT.TINHTRANG_GQ
                                             || GNST.TINHTRANG_GQ) TINHTRANG_GQ,
                                      ( TLPT.TINHTRANG_GQ ) CHECK_THULY,
                                      DECODE(QD.ID, NULL, NULL, 3) THULYXXLAI
                                  FROM
                                      ADS_DON              A
 --      INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID

                                      INNER JOIN (
                                          SELECT
                                              G.*
                                          FROM
                                              ADS_DON_GIAIDOAN G
                                          WHERE
                                              ( G.MAGIAIDOAN = 7
                                                AND G.TOAPHUCTHAMID = V_TOAAN_ID )
                                      ) GD ON A.ID = GD.DONID--Điều kiện để hiển thị 1 bản ghi duy nhất theo giai đoạn xét xử (tránh hiển thị 2 giai đoạn ở ST và PT ở tòa tỉnh) tuanvna

                                      LEFT JOIN DM_DATAITEM          I ON A.QUANHEPHAPLUATID = I.ID
                                      LEFT JOIN ADS_CHUYEN_NHAN_AN   NA ON NA.MAP_VUANID_NEW = A.ID
                                      LEFT JOIN DM_TOAAN             T ON A.TOAANID = T.ID
                                      LEFT JOIN DM_TOAAN             TST ON NA.TOACHUYENID = TST.ID

      -- lấy thông tin vụ án end     

                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.*
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              INSTR(',DC,', ','
                                                            || QDL.MA
                                                            || ',') > 0
                                      ) QD ON QD.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7 
        --- Lay ra trang thai giai quyet don

                                      LEFT JOIN (
                                          SELECT
                                              DONID,
                                              LOAIGIAIQUYET,
                                              NGAYGQ_YC
                                          FROM
                                              ADS_DON_XULY
                                          WHERE
                                              LOAIGIAIQUYET IN (
                                                  1,
                                                  5
                                              )
                                      ) XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách

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
                                              GSCM.ADS_KCKNQDK_PHUCTHAM_THULY T2
                                          WHERE
                                              EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      TABLE ( V_TABLE_TLPTQDK ) QDL
                                                  WHERE
                                                      QDL.ID = T2.ID
                                              )--> Lấy thụ lý mới nhất

                                      ) TLPT ON TLPT.DONID = A.ID
                                                AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.DONID,
                                              '</br>- Đã giải quyết xong</b>' TINHTRANG_GQ
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA NOT IN (
                                                  '69-DS',
                                                  '70-DS',
                                                  '72-DS'
                                              )
                                      ) GQPT ON GQPT.DONID = A.ID
                                                AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              TP.DONID,
                                              '</br>- Thẩm phán: <b>'
                                              || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                              || '</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                                          FROM
                                              ADS_DON_THAMPHAN   TP
                                              LEFT JOIN (
                                                  SELECT
                                                      DONID,
                                                      ID
                                                  FROM
                                                      TABLE ( V_TABLE_HDXX_PTQDK )
                                              ) HD ON HD.DONID = TP.DONID
                                              LEFT JOIN (
                                                  SELECT
                                                      GG.*
                                                  FROM
                                                      ADS_DON_THAMPHAN GG
                                                  WHERE
                                                      EXISTS (
                                                          SELECT
                                                              'X'
                                                          FROM
                                                              TABLE ( V_TABLE_TP ) TP
                                                          WHERE
                                                              TP.ID = GG.ID
                                                      )
                                              ) PCTP_GQ ON PCTP_GQ.DONID = TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết

                                              LEFT JOIN DM_CANBO           CBB ON CBB.ID = HD.ID
                                              LEFT JOIN DM_CANBO           CB ON CB.ID = PCTP_GQ.CANBOID
                                          WHERE
                                              TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                          GROUP BY
                                              TP.DONID,
                                              '</br>- Thẩm phán: <b>'
                                              || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN))
                                              || '</b><i> (chủ tọa)</i>'
                                      ) TPPCPT ON TPPCPT.DONID = A.ID
                                                  AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.DONID,
                                              '</br>- QĐ HPT số: '
                                              || PTQDVA.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 

                                          WHERE
                                              EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      TABLE ( V_TABLE_PTQDK ) QDL
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
                                      ) HPTPT ON HPTPT.DONID = A.ID
                                                 AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.DONID,
                                              '</br>- QĐ TĐC số: '
                                              || PTQDVA.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 

                                          WHERE
                                              EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      TABLE ( V_TABLE_PTQDK ) QDL
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
                                      ) TDCPT ON TDCPT.DONID = A.ID
                                                 AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.DONID,
                                              '</br>- QĐ ĐC số: '
                                              || PTQDVA.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          WHERE
                                              EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      TABLE ( V_TABLE_PTQDK ) QDL
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
                                      ) DCPT ON DCPT.DONID = A.ID
                                                AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.DONID,
                                              '</br>- QĐ CVA số: '
                                              || PTQDVA.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          WHERE
                                              EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      TABLE ( V_TABLE_PTQDK ) QDL
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
                                      ) CPT ON CPT.DONID = A.ID
                                               AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              PTQDVA.DONID,
                                              '</br>- QĐ THS số: '
                                              || PTQDVA.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                          WHERE
                                              EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      TABLE ( V_TABLE_PTQDK ) QDL
                                                  WHERE
                                                      QDL.ID = PTQDVA.ID
                                                      AND INSTR(',TRAHS,', ','
                                                                           || QDL.MA
                                                                           || ',') > 0
                                              )
                                          GROUP BY
                                              PTQDVA.DONID,
                                              '</br>- QĐ THS số: '
                                              || PTQDVA.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                      ) THSPT ON THSPT.DONID = A.ID
                                                 AND GD.MAGIAIDOAN = 7 
             -------trường hợp giao nhận add vào cột trạng thái   

             --bỏ

                                      LEFT JOIN (
                                      --toancau-anhnt-sửa check đã chuyển lại án sơ thẩm

                                          SELECT
                                              CA.ID,
                                              CA.VUANID,
                                              -- '</br>- '
                                              --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                               '</br>- Đã chuyển vụ án' TINHTRANG_GQ
                                          FROM
                                              ADS_CHUYEN_NHAN_AN   CA
                                              INNER JOIN DM_DATAITEM          I ON CA.TRUONGHOPGIAONHANID = I.ID
                                          WHERE
                                              CA.TOACHUYENID = V_TOAAN_ID
                                      ) GNST ON GNST.VUANID = A.ID
                                                AND GD.MAGIAIDOAN = 7
                                      LEFT JOIN (
                                          SELECT
                                              CA.VUANID,
                                              I.TEN TRUONGHOPGIAONHAN,
                                              CA.MAP_VUANID_NEW
                                          FROM
                                              DM_DATAITEM          I
                                              INNER JOIN ADS_CHUYEN_NHAN_AN   CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                          WHERE
                                              CA.TOANHANID = V_TOAAN_ID
                                          GROUP BY
                                              CA.VUANID,
                                              I.TEN,
                                              CA.MAP_VUANID_NEW
                                      ) GN ON GN.VUANID = A.ID
                                              OR GN.MAP_VUANID_NEW = A.ID

           ------bị cáo lấy cho sơ thẩm

           --bỏ

--                                      LEFT JOIN (

--                                          SELECT

--                                              BC.DONID,

--                                              '<br /><i>Đương sự khác:</i> <br />'

--                                              ||

--                                              LISTAGG(BC.TENDUONGSU

--                                                      || ' '

--                                                      || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Nguyên đơn)', 'BIDON', '(Bị đơn)',

--                                                                'QUYENNVLQ', '(Người có quyền và NVLQ)', ' ('

--                                                                                                         || BC.TUCACHTOTUNG_MA

--                                                                                                         || ')'), '<br/>') WITHIN GROUP(

--                                                  ORDER BY

--                                                      BC.ROWNUMBER

--                                                  )

--                                              HOTEN

--                                          FROM

--                                              TABLE ( V_TABLE_BC ) BC

--                                          GROUP BY

--                                              BC.DONID

--                                      )           BC2 ON BC2.DONID = A.ID

--                                               AND GD.MAGIAIDOAN = 2


             ------bị cáo kháng cáo lấy cho phúc thẩm    

                                      LEFT JOIN (
                                          SELECT
                                              BC.DONID,
                                              '<br /><i>Người kháng cáo:</i> <br />'
                                              ||
                                                  LISTAGG(BC.TENDUONGSU
                                                          || ' '
                                                          || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Nguyên đơn)', 'BIDON', '(Bị đơn)',
                                                                    'QUYENNVLQ', '(Người có quyền và NVLQ)', ' ('
                                                                                                             || BC.TUCACHTOTUNG_MA
                                                                                                             || ')'), '<br/>') WITHIN GROUP(
                                                      ORDER BY
                                                          BC.ROWNUMBER
                                                  )
                                              HOTEN
                                          FROM
                                              TABLE ( V_TABLE_BC_KC ) BC
                                          GROUP BY
                                              BC.DONID
                                      ) BC3 ON BC3.DONID = A.ID
                                               AND GD.MAGIAIDOAN = 7  

        ----- lấy thông tin BA/sơ thẩm                

                                      LEFT JOIN (
                                          SELECT
                                              PTQD.DONID,
                                              '<br /><i>QĐ GQ PT: </i><b>'
                                              || 'Số '
                                              || PTQD.SOQD
                                              || ' ngày '
                                              || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy')
                                              || '</b>' QD_PT
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH PTQD
                                          WHERE
                                              QUYETDINHID = 213
                                      ) PTQD ON PTQD.DONID = A.ID           
         ------- lấy thông tin số ngày kháng nghị

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
                                              ADS_SOTHAM_KHANGNGHI KN
                                          GROUP BY
                                              KN.DONID
                                      ) STKN ON STKN.DONID = A.ID 

        ---------------------                

                                  WHERE
                                      A.MAGIAIDOAN = 7
                                      AND GD.MAGIAIDOAN = 7
                                        --tìm tên vụ án

                                      AND ( V_TEN_VU_AN IS NULL
                                            OR ( LOWER(A.TENVUVIEC) LIKE '%'
                                                                         || LOWER(V_TEN_VU_AN)
                                                                         || '%' ) )--Tên vụ án

                                        --tìm tên vụ án

                                        --Mã vụ án

                                      AND ( V_MA_VU_AN IS NULL
                                            OR ( LOWER(A.MAVUVIEC) LIKE LOWER(V_MA_VU_AN) ) ) 
                                        --Mã vụ án

                                        --tìm Ủy thác tư pháp

                                      AND ( V_UTTP IS NULL
                                            OR ( V_UTTP IS NOT NULL
                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY TLPT
                                          WHERE
                                              TLPT.UTTPDI = TO_NUMBER(V_UTTP)
                                              AND TLPT.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) ) )
                                        --tìm Ủy thác tư pháp

                                        --Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án

                                      AND ( V_QHPL IS NULL
                                            OR ( LOWER(A.TENVUVIEC) LIKE '%'
                                                                         || LOWER(V_QHPL)
                                                                         || '%' ) )
                                        --Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án

                                        --Đương sự

                                      AND ( V_TENDUONGSU IS NULL
                                            OR ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_DUONGSU DS
                                          WHERE
                                              FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'
                                                                                          || FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))
                                                                                          || '%'
                                              AND DS.DONID = A.ID
                                      ) ) )
                                      --Đương sự

                                      AND ( ( GD.TOAANID = V_TOAAN_ID
                                              OR ( GD.TOAPHUCTHAMID = V_TOAAN_ID
                                                   AND V_CAP_XET_XU_LOGIN = 'CAPTINH' ) )
                                            OR ( GD.TOAANID = V_TOAAN_ID
                                                 OR ( GD.TOAPHUCTHAMID = V_TOAAN_ID
                                                      AND V_CAP_XET_XU_LOGIN = 'CAPCAO'
                                                      AND T.LOAITOA != 'CAPHUYEN' ) ) )
           -----   

                                      AND ( ( V_TINHTRANG_THULY IS NULL
                                              AND ( V_NGAYTHULY_TU IS NULL
                                                    OR A.NGAYTAO >= VV_NGAYTHULY_TU )
                                              AND ( V_NGAYTHULY_DEN IS NULL
                                                    OR A.NGAYTAO <= VV_NGAYTHULY_DEN ) )--Tình trạng thụ lý

                                            OR ( V_TINHTRANG_THULY = 1
                                                 AND ( ( TLPT.DONID IS NOT NULL
                                                         AND ( V_NGAYTHULY_TU IS NULL
                                                               OR TLPT.NGAYTHULY >= VV_NGAYTHULY_TU )
                                                         AND ( V_NGAYTHULY_DEN IS NULL
                                                               OR TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) ) ) )
                                            OR ( V_TINHTRANG_THULY = 2
                                                 AND ( TLPT.DONID IS NULL )
                                                 AND ( V_NGAYTHULY_TU IS NULL
                                                       OR A.NGAYTAO >= VV_NGAYTHULY_TU )
                                                 AND ( V_NGAYTHULY_DEN IS NULL
                                                       OR A.NGAYTAO <= VV_NGAYTHULY_DEN ) ) )
         -----

                                      AND ( V_SOTHULY IS NULL
                                            OR ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY
                                          WHERE
                                              DONID = A.ID
                                              AND UPPER(SOTHULY) = UPPER(V_SOTHULY)
                                      ) ) )--Số Thụ lý

         -----

                                      AND ( V_THAMPHAN_ID IS NULL--Thẩm phán

                                            OR ( ( EXISTS (
                                          SELECT
                                              'x'
                                          FROM
                                              ADS_DON_THAMPHAN PC
                                          WHERE
                                              PC.CANBOID = V_THAMPHAN_ID
                                              AND MAVAITRO = 'VTTP_GIAIQUYETSOTHAM'
                                              AND PC.DONID = A.ID
                                      ) ) ) )
            --GQ đơn;V_GQDON -- -- 

                                      AND ( V_GQDON IS NULL
                                            OR ( ( V_GQDON = 1
                                                   OR V_GQDON = 3
                                                   OR V_GQDON = 4
                                                   OR V_GQDON = 5 )
                                                 AND EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_XULY XL
                                          WHERE
                                              XL.LOAIGIAIQUYET = V_GQDON
                                              AND XL.DONID = A.ID
                                      ) )
                                            OR ( V_GQDON = 6
                                                 AND NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_XULY XL
                                          WHERE
                                              XL.DONID = A.ID
                                      ) )
                                            OR ( V_GQDON = 7
                                                 AND NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_XULY XL
                                          WHERE
                                              XL.DONID = A.ID
                                      )
                                                 AND ( SYSDATE - A.NGAYNHANDON ) > 15 )
                                            OR ( V_GQDON = 8
                                                 AND NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_XULY XL
                                          WHERE
                                              XL.DONID = A.ID
                                      )
                                                 AND NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_THAMPHAN TP
                                          WHERE
                                              TP.DONID = A.ID
                                      ) ) )
                                      AND ( V_THUKY_ID IS NULL--Thư ký

                                            OR ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_PHUCTHAM_HDXX TP
                                          WHERE
                                              TP.CANBOID = V_THUKY_ID
                                              AND TP.DONID = A.ID
                                      )
                                                 OR EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_DON_THAMPHAN TP
                                          WHERE
                                              TP.DONID = A.ID
                                              AND TP.THUKYID = V_THUKY_ID
                                      ) ) )
                                      AND ( VCHECKTK = 0
                                            OR (
                                          SELECT
                                              COUNT(*)
                                          FROM
                                              ADS_DON_THAMPHAN TP
                                          WHERE
                                              TP.DONID = A.ID
                                              AND TP.THUKYID = VCHECKTK
                                              AND TP.MAVAITRO = DECODE(A.MAGIAIDOAN, 2, 'VTTP_GIAIQUYETSOTHAM', 3, 'VTTP_GIAIQUYETPHUCTHAM',
                                                                       '')
                                      ) > 0 )
            --check theo trạng thái vụ án  --anhvh  đóng lại vì trên code chưa có         

--                AND ((v_trangthaivuan = 0 AND A.VUANGOCID = 0)

--                         OR (v_trangthaivuan = 1 

--                          AND A.VUANGOCID <> 0

--                            ) 

--                        OR v_trangthaivuan = 2

--                    ) 

                --check theo trạng thái vụ án end

            ------Loại đơn

                                      AND ( V_LOAIDON IS NULL
                                            OR ( A.LOAIDON = V_LOAIDON ) )    
           --------------

                                      AND ( V_SO_QD IS NULL--Số BA/QĐ

                                            OR ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                          WHERE
                                              UPPER(QSV.SOQD) LIKE '%'
                                                                   || V_SO_QD
                                                                   || '%'
                                              AND A.ID = QSV.DONID
                                      ) ) )
                                      AND ( V_NGAY_QD IS NULL--Ngày BA/QĐ

                                            OR ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                          WHERE
                                              TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD
                                              AND A.ID = QSV.DONID
                                      ) ) )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA


        --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án

        --/////////////đối với sơ thẩm          

                                      AND ( V_THOIHAN_GQ IS NULL
                                            OR ( V_THOIHAN_GQ = 1 --Đã hết thời hạn

                                                 AND ( 
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  

                                                  EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY       TL
                                              LEFT JOIN ADS_PHUCTHAM_BANAN               BA ON BA.DONID = TL.DONID
                                              LEFT JOIN ADS_KCKNQDK_PHUCTHAM_QUYETDINH   QSV ON TL.DONID = QSV.DONID
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = QSV.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              ( ( BA.ID IS NOT NULL
                                                  AND ( BA.NGAYMOPHIENTOA - TL.NGAYTHULY ) > 90 )
                                                OR ( BA.ID IS NULL
                                                     AND INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                      || QDL.MA
                                                                                      || ',') = 0
                                                     AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
                                              AND TL.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      )
                            --dùng ngày QĐ phúc thẩm  

                                                       OR EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY   TL
                                              LEFT JOIN ADS_SOTHAM_QUYETDINH         QSV ON TL.DONID = QSV.DONID
                                              LEFT JOIN DM_QD_LOAI                   QDL ON QDL.ID = QSV.LOAIQDID
                                          WHERE
                                              ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                               || QDL.MA
                                                                               || ',') > 0
                                                  AND ( QSV.NGAYQD - TL.NGAYTHULY ) > 90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án

                                                OR ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                  || QDL.MA
                                                                                  || ',') = 0
                                                     AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
                                              AND TL.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                                            OR ( V_THOIHAN_GQ = 2 --Còn thời hạn dưới 10 ngày

                                                 AND (
                          --phúc thẩm   

                                                  EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY       TL
                                              LEFT JOIN ADS_PHUCTHAM_BANAN               BA ON BA.DONID = TL.DONID
                                              LEFT JOIN ADS_KCKNQDK_PHUCTHAM_QUYETDINH   QSV ON TL.DONID = QSV.DONID
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = QSV.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              ( SYSDATE - TL.NGAYTHULY ) >= 80
                                              AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                              AND BA.ID IS NULL
                                              AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                 || QDL.MA
                                                                                 || ',') = 0
                                                    OR INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                    || QDL.MA
                                                                                    || ',') IS NULL )
                                              AND TL.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                                            OR ( V_THOIHAN_GQ = 3
                                                 AND (

                          --phúc thẩm   

                                                  EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY       TL
                                              LEFT JOIN ADS_PHUCTHAM_BANAN               BA ON BA.DONID = TL.DONID
                                              LEFT JOIN ADS_KCKNQDK_PHUCTHAM_QUYETDINH   QSV ON TL.DONID = QSV.DONID
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = QSV.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              ( SYSDATE - TL.NGAYTHULY ) >= 70
                                              AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                              AND BA.ID IS NULL
                                              AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                 || QDL.MA
                                                                                 || ',') = 0
                                                    OR INSTR(',DC,CVA,HPT,GHTHXX,', ','
                                                                                    || QDL.MA
                                                                                    || ',') IS NULL )
                                              AND TL.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) ) )  
             --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM

                                      AND ( V_PT_RKINHNGHIEM IS NULL
                                            OR ( V_PT_RKINHNGHIEM = 1
                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_PHUCTHAM_BANAN   BA
                                              LEFT JOIN ADS_SAUXETXU         SXX ON BA.DONID = SXX.VUANID
                                          WHERE
                                              SXX.PT_ISRUTKN = 1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm

                                              AND BA.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                                            OR ( V_PT_RKINHNGHIEM = 2
                                                 AND ( NOT EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_PHUCTHAM_BANAN   BA
                                              LEFT JOIN ADS_SAUXETXU         SXX ON BA.DONID = SXX.VUANID
                                          WHERE
                                              SXX.PT_ISRUTKN = 1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm

                                              AND BA.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) ) )        
           --Tình trạng GQ;

                                      AND ( ( V_TINHTRANG_GIAIQUYET IS NULL
                                              AND ( V_TUNGAY IS NULL
                                                    OR A.NGAYTAO >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR A.NGAYTAO <= VV_DENNGAY ) )
                                            OR ( V_TINHTRANG_GIAIQUYET = 1 --Chưa giải quyết xong

                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY PTTL
                                          WHERE
                                              ( NOT EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 

                                                      LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                                  WHERE
                                                      QD.MA NOT IN (
                                                          '69-DS',
                                                          '70-DS',
                                                          '72-DS'
                                                      )
                                                      AND PTTL.DONID = PTQDVA.DONID
                                              ) )
                                              AND ( V_TUNGAY IS NULL
                                                    OR PTTL.NGAYTHULY >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PTTL.NGAYTHULY <= VV_DENNGAY )
                                              AND PTTL.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                                            OR ( V_TINHTRANG_GIAIQUYET = 7 --chưa phân công Thẩm phán

                                                 AND ( TPPCPT.DONID IS NULL )
                                                 AND ( V_TUNGAY IS NULL
                                                       OR A.NGAYTAO >= VV_TUNGAY )
                                                 AND ( V_DENNGAY IS NULL
                                                       OR A.NGAYTAO <= VV_DENNGAY ) )
                                            OR ( V_TINHTRANG_GIAIQUYET = 7 --đã phân công Thẩm phán

                                                 AND EXISTS (
                                          SELECT
                                              'x'
                                          FROM
                                              ADS_DON_THAMPHAN PC
                                          WHERE
                                              PC.DONID = A.ID
                                              AND ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                      AND GD.MAGIAIDOAN = 7 )--phuc thẩm

                                                       )
                                              AND ( V_TUNGAY IS NULL
                                                    OR PC.NGAYPHANCONG >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PC.NGAYPHANCONG <= VV_DENNGAY )
                                      ) )
                                            OR ( V_TINHTRANG_GIAIQUYET = 5 --Đang hoãn  

                                                 AND ( 
                      --Đang hoãn phuc tham                 

                                                  EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 

                                              LEFT JOIN ADS_KCKNQDK_PHUCTHAM_THULY       PTTL ON PTTL.DONID = PTQDVA.DONID
                                              LEFT JOIN ADS_PHUCTHAM_BANAN               PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 

                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              PTBA.DONID IS NULL
                                              AND QDL.MA = 'HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 

                                              AND ( V_TUNGAY IS NULL
                                                    OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                              AND PTQDVA.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                   ------------------------------

                                            OR ( V_TINHTRANG_GIAIQUYET = 7 --Đã giải quyết xong

                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                          WHERE
                                              QD.MA NOT IN (
                                                  '69-DS',
                                                  '70-DS',
                                                  '72-DS'
                                              )
                                              AND ( V_TUNGAY IS NULL
                                                    OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                              AND PTQDVA.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                                            OR ( V_TINHTRANG_GIAIQUYET = 9 --Đình chỉ

                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              INSTR(',DC,', ','
                                                            || QDL.MA
                                                            || ',') > 0
                                              AND ( V_TUNGAY IS NULL
                                                    OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                              AND PTQDVA.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) )
                                            OR ( V_TINHTRANG_GIAIQUYET = 11 --QĐ chuyển vụ án

                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              INSTR(',CVA,', ','
                                                             || QDL.MA
                                                             || ',') > 0
                                              AND ( V_TUNGAY IS NULL
                                                    OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                              AND PTQDVA.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) ) )
             -- END v_TINHTRANG_GIAIQUYET

             --là con của chưa giải quyết xong 

                                      AND ( ( INSTR('2,3,4,5,6', V_TINHTRANG_GIAIQUYET) = 0
                                              OR V_TINHTRANG_GIAIQUYET IS NULL )
                                            OR ( INSTR('2,3,4,5,6', V_TINHTRANG_GIAIQUYET) > 0
                                                 AND ( EXISTS (
                                          SELECT
                                              'X'
                                          FROM
                                              ADS_KCKNQDK_PHUCTHAM_THULY PTTL
                                          WHERE
                                              ( NOT EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      ADS_PHUCTHAM_BANAN PTBA
                                                  WHERE
                                                      PTBA.DONID = PTTL.DONID
                                              )
                                                    AND NOT EXISTS (
                                                  SELECT
                                                      'X'
                                                  FROM
                                                      ADS_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 

                                                      LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                                      LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                                  WHERE
                                                      INSTR(',DC,CVA,CNTT,', ','
                                                                             || QDL.MA
                                                                             || ',') > 0
                                                      AND PTTL.DONID = PTQDVA.DONID
                                              ) )
                                              AND ( V_TUNGAY IS NULL
                                                    OR PTTL.NGAYTHULY >= VV_TUNGAY )
                                              AND ( V_DENNGAY IS NULL
                                                    OR PTTL.NGAYTHULY <= VV_DENNGAY )
                                              AND PTTL.DONID = A.ID
                                              AND GD.MAGIAIDOAN = 7
                                      ) ) ) ) --là con của chưa giải quyết xong end 

            -----------

                              ) TT
                          WHERE
                              TT.STT >= MININDEX
                              AND TT.STT <= MAXINDEX;

    END DON_SEARCH_PTQDK;

    PROCEDURE ADS_KCKN_PHUCTHAM_THULY_GETMAXTT (
        VDONVIID    IN    NUMBER,
        VFROMDATE   IN    DATE,
        VTODATE     IN    DATE,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               NVL(MAX(D.TT), 0)
                           FROM
                               ADS_KCKNQDK_PHUCTHAM_THULY   T
                               INNER JOIN ADS_DON                      D ON D.ID = T.DONID
                           WHERE
                               D.TOAANID = VDONVIID
                               AND T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;

    END ADS_KCKN_PHUCTHAM_THULY_GETMAXTT;

    PROCEDURE ADS_KCKN_PHUCTHAM_THULY_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
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
                              THTL.TEN                AS TENTRUONGHOPTHULY
    --,qhpl.TEN as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK
,
                              T.QUANHEPHAPLUAT_NAME   AS QUANHEPL,
                              QHPLTK.CASE_NAME        AS QUANHEPLTK,
                              T.NGAYTHULY,
                              T.SOTHULY,
                              T.FILEID,
                              T.TENFILE,
                              T.THOIHANTUNGAY,
                              T.THOIHANDENNGAY,
                              T.NGAYTAO,
                              T.NGUOITAO
                          FROM
                              ADS_KCKNQDK_PHUCTHAM_THULY   T
                              LEFT JOIN ADS_FILE                     F ON F.ID = T.FILEID
                              LEFT JOIN (
                                  SELECT
                                      A.ID,
                                      A.TEN
                                  FROM
                                      DM_DATAITEM A
                                  WHERE
                                      A.GROUPID = VGROUPTHGIAONHAN
                                      AND A.MA IN (
                                          '02',
                                          '03',
                                          '04'
                                      )
                              ) THTL ON THTL.ID = T.TRUONGHOPTHULY
  --left join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID

                              LEFT JOIN DM_QHPL_TK                   QHPLTK ON QHPLTK.ID = T.QHPLTKID
                          WHERE
                              T.DONID = VDONID
                          ORDER BY
                              T.NGAYTHULY DESC;

    END ADS_KCKN_PHUCTHAM_THULY_GETLIST;
-------------------------------

    PROCEDURE ADS_DM_QUYETDINH_VUAN_PTQDK (
        CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               TEN,
                               ID,
                               MA
                           FROM
                               DM_QD_QUYETDINH
                           WHERE
                               ISPHUCTHAM = 1
                               AND ISDANSU = 1
                               AND ( MA IN (
                                   '69-DS',
                                   '70-DS',
                                   '72-DS'
                               ) )
                           ORDER BY
                               CASE
                                   WHEN MA = '72-DS' THEN
                                       '1'
                                   ELSE
                                       MA
                               END;

    END ADS_DM_QUYETDINH_VUAN_PTQDK;

    PROCEDURE ADS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        COUNTBANANST INT;
    BEGIN

    --select count(ID) into CountBanAnST from ADS_PHUCTHAM_BANAN where DonID = vDONID;    

    --------------------------

        OPEN CURRETURN FOR SELECT
                               Q.ID,
                               Q.SOQD,
                               Q.NGAYQD,
                               Q.CHUCVU,
                               Q.QUYETDINHID,
                               D.TEN     AS TENQD,
                               C.HOTEN   AS NGUOIKY,
                               Q.HIEULUCTU,
                               Q.HIEULUCDEN,
                               LD.TEN    AS LYDO,
                               Q.NGAYTAO,
                               Q.NGUOITAO,
                               T.TEN     TENTOAAN,
                               Q.TENFILE,
                               Q.FILEID,
                               0 ISBANANST
                           FROM
                               ADS_KCKNQDK_PHUCTHAM_QUYETDINH   Q
                               LEFT JOIN ADS_FILE                         F ON Q.FILEID = F.ID
                               LEFT JOIN DM_QD_QUYETDINH_LYDO             LD ON LD.ID = Q.LYDOID
                               INNER JOIN DM_QD_QUYETDINH                  D ON D.ID = Q.QUYETDINHID
                                                               AND ( D.MA IN (
                                   '69-DS',
                                   '70-DS',
                                   '72-DS'
                               ) )
                               LEFT JOIN DM_CANBO                         C ON C.ID = Q.NGUOIKYID
                               LEFT JOIN DM_TOAAN                         T ON T.ID = Q.TOAANID
                           WHERE
                               Q.DONID = VDONID
                               OR Q.DONID IN (
                                   SELECT
                                       ID
                                   FROM
                                       ADS_DON
                                   WHERE
                                       VUANGOCID = VDONID
                               )
                           ORDER BY
                               Q.NGAYQD;

    END ADS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST;

    PROCEDURE ADS_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        CHECKBANANPT NUMBER;
    BEGIN
        SELECT
            COUNT(ID)
        INTO CHECKBANANPT
        FROM
            ADS_PHUCTHAM_BANAN
        WHERE
            DONID = VDONID;

        OPEN CURRETURN FOR SELECT
                              NVL(CHECKBANANPT, 0) CHECKBANANPT,
                              D.ID,
                              (
                                  CASE MAVAITRO
                                      WHEN 'THAMPHAN'           THEN
                                          'Thẩm phán chủ tọa phiên tòa'
                                      WHEN 'THAMPHANHDXX'       THEN
                                          'Thẩm phán thành viên hội đồng xét xử'
                                      WHEN 'THAMPHANDUKHUYET'   THEN
                                          'Thẩm phán dự khuyết'
                                      WHEN 'HTND'               THEN
                                          'Hội thẩm nhân dân'
                                      WHEN 'THUKY'              THEN
                                          'Thư ký'
                                      WHEN 'KSV'                THEN
                                          'Kiểm sát viên'
                                  END
                              ) AS TENVAITRO,
                              CASE
                                  WHEN D.MAVAITRO = 'KSV' THEN
                                      V.HOTEN
                                  ELSE
                                      C.HOTEN
                              END AS TENNGUOITHTT,
                              D.NGAYTHAMGIA,
                              D.NGAYKETTHUC,
                              D.NGAYPHANCONG,
                              D.NGAYNHANPHANCONG,
                              D.NGUOITAO,
                              D.NGAYTAO,
                              E.HOTEN AS NGUOIPHANCONG
                          FROM
                              ADS_KCKNQDK_PHUCTHAM_HDXX   D
                              LEFT JOIN DM_CANBO                    C ON C.ID = D.CANBOID
                              LEFT JOIN DM_CANBO                    E ON E.ID = D.NGUOIPHANCONGID
                              LEFT JOIN DM_CANBOVKS                 V ON V.ID = D.CANBOID
                          WHERE
                              D.DONID = VDONID
                          ORDER BY
                              D.HOTEN;

    END ADS_KCKNQDK_PHUCTHAM_HDXX_GETLIST;

    PROCEDURE ADS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
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
                               C.HOTEN   AS NGUOIKY,
                               Q.HIEULUCTU,
                               Q.HIEULUCDEN,
                               LD.TEN    AS LYDO,
                               Q.NGAYTAO,
                               Q.NGUOITAO,
                               Q.FILEID,
                               Q.TENFILE
                           FROM
                               ADS_KCKNQDK_PHUCTHAM_QUYETDINH   Q
                               LEFT JOIN ADS_FILE                         F ON F.ID = Q.FILEID
                               LEFT JOIN DM_QD_QUYETDINH_LYDO             LD ON LD.ID = Q.LYDOID
                               INNER JOIN DM_QD_QUYETDINH                  D ON D.ID = Q.QUYETDINHID
                                                               AND ( D.ISDANSU = 1
                                                                     AND D.ISPHUCTHAM = 1
                                                                     AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
                                                                             AND D.MA not in('72-DS','69-DS','70-DS')) --thêm điều kiện not in 
                               LEFT JOIN DM_CANBO                         C ON C.ID = Q.NGUOIKYID
                           WHERE
                               Q.DONID = VDONID
                           ORDER BY
                               Q.NGAYQD;

    END ADS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST;

    PROCEDURE ADS_KCKN_DON_THAMPHAN_GETBY (
        VDONID      IN    NUMBER,
        VMAVAITRO   IN    NVARCHAR2,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        CHECKBANANPT NUMBER;
    BEGIN
        SELECT
            COUNT(ID)
        INTO CHECKBANANPT
        FROM
            ADS_PHUCTHAM_BANAN
        WHERE
            DONID = VDONID;

        OPEN CURRETURN FOR SELECT
                              NVL(CHECKBANANPT, 0) CHECKBANANPT,
                              D.ID,
                              D.NGAYPHANCONG,
                              D.NGAYNHANPHANCONG,
                              D.NGAYTHAMGIA,
                              D.NGAYKETTHUC,
                              D.NGUOITAO,
                              D.NGAYTAO,
                              C3.HOTEN   AS THUKY,
                              D.CANBOID,
                              D.NGUOIPHANCONGID,
                              C1.HOTEN   AS TENTHAMPHAN,
                              C2.HOTEN   AS THAMPHANPHANCONG
                          FROM
                              ADS_DON_THAMPHAN   D
                              LEFT JOIN DM_CANBO           C1 ON C1.ID = D.CANBOID
                              LEFT JOIN DM_CANBO           C2 ON C2.ID = D.NGUOIPHANCONGID
                              LEFT JOIN DM_CANBO           C3 ON C3.ID = D.THUKYID
                              LEFT JOIN (
                                  SELECT
                                      MA,
                                      TEN
                                  FROM
                                      DM_DATAITEM
                                  WHERE
                                      GROUPID = (
                                          SELECT
                                              ID
                                          FROM
                                              DM_DATAGROUP
                                          WHERE
                                              MA = 'VAITROTHAMPHAN'
                                      )
                              ) I ON I.MA = D.MAVAITRO
                          WHERE
                              D.DONID = VDONID
                              AND 1 = (
                                  CASE
                                      WHEN VMAVAITRO = ''         THEN
                                          1
                                      WHEN D.MAVAITRO = VMAVAITRO THEN
                                          1
                                      ELSE
                                          0
                                  END
                              );

    END ADS_KCKN_DON_THAMPHAN_GETBY;

    PROCEDURE ADS_PHUCTHAM_KCKN_TGTT_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               D.ID,
                               D.HOTEN,
                               I.TEN             AS TENTC
        --,h1.MA_TEN as Tamtru

                               ,
                               D.TAMTRUCHITIET   AS TAMTRU,
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
                                       ADS_DON_DUONGSU A
                                   WHERE
                                       D.DUONGSUID LIKE '%,'
                                                        || A.ID
                                                        || ',%'
                               ) TENDUONGSU
                           FROM
                               ADS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG   D
                               LEFT JOIN DM_DATAITEM                          I ON I.MA = D.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH                         H1 ON H1.ID = D.TAMTRUID
                               LEFT JOIN DM_CANBO                             CB ON D.NGUOIPHANCONGID = CB.ID
                           WHERE
                               D.DONID = VDONID
                           ORDER BY
                               D.HOTEN;

    END ADS_PHUCTHAM_KCKN_TGTT_GETLIST;

    PROCEDURE SO_DK_KCKN_DS (
        V_DK_DS    OUT   NUMBER,
        VTOAANID   IN    VARCHAR2,
        V_CXX      IN    VARCHAR2
    ) AS
    BEGIN
        V_DK_DS := 0;
        IF ( V_CXX = 'PT_KCKN' ) THEN
            SELECT
                NVL(MAX(D.SO_DK), 0)
            INTO V_DK_DS
            FROM
                ADS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG   D
                LEFT JOIN ADS_DON_GIAIDOAN                     GD ON GD.DONID = D.DONID
            WHERE
                EXTRACT(YEAR FROM TO_DATE(D.NGAY_DK, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM TO_DATE(SYSDATE, 'DD-MM-YYYY'))
                AND D.SO_DK != 0
                AND GD.TOAPHUCTHAMID = VTOAANID;

        END IF;

        V_DK_DS := V_DK_DS + 1;
    END;

    PROCEDURE UPDATE_NOIDUNG_CHUYENNHANAN (
        VNHANANID   IN   NUMBER,
        VNOIDUNG    IN   VARCHAR2,
        V_VUANID    IN   NUMBER
    ) AS
        V_EXPORT_TEXT CLOB;
    BEGIN
        FOR ITEMS IN (
            SELECT --GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).

                T2.DONID,
                T2.DUONGSUID,
                '<b> - '
                || DM.TEN
                || ': '
                || T3.TENDUONGSU
                || '</b><br/> '
                ||
                    LISTAGG('<b>* Ngày kháng cáo:</b> '
                            || TO_CHAR(T2.NGAYKHANGCAO, 'dd/MM/yyyy')
                            || '<br/>'
                            || DECODE(T2.LOAIKHANGCAO, 0, '+ Kháng cáo bản án số: '
                                                          || BA.SOBANAN
                                                          || ', Ngày: '
                                                          || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'), '+ Kháng cáo quyết định số: '
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
                ADS_SOTHAM_KHANGCAO    T2
                INNER JOIN ADS_DON_DUONGSU        T3 ON T2.DUONGSUID = T3.ID
                                                 AND ( T3.DONID = T2.DONID )
                LEFT JOIN DM_DATAITEM            DM ON DM.MA = T3.TUCACHTOTUNG_MA
                LEFT JOIN ADS_SOTHAM_QUYETDINH   QD ON QD.ID = T2.SOQDBA
                                                     AND T2.LOAIKHANGCAO IN (
                    1,
                    2
                ) --> Kháng cáo quyết định --toancau-anhnt kc tđc

                LEFT JOIN ADS_SOTHAM_BANAN       BA ON BA.ID = T2.SOQDBA
                                                 AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án

            WHERE
                T2.DONID = (
                    CASE
                        WHEN NOT EXISTS (
                            SELECT
                                'x'
                            FROM
                                ADS_DON
                            WHERE
                                ID = V_VUANID
                                AND ADS_DON.MAGIAIDOAN = 7
                        ) THEN
                            V_VUANID
                        ELSE
                            (
                                SELECT
                                    VUANID
                                FROM
                                    ADS_CHUYEN_NHAN_AN
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
            SELECT --GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).

                T2.DONID,
                T2.DUONGSUID,
                '<b> - '
                || DM.TEN
                || ': '
                || T3.HOTEN
                || '</b><br/> '
                ||
                    LISTAGG('<b>* Ngày kháng cáo:</b> '
                            || TO_CHAR(T2.NGAYKHANGCAO, 'dd/MM/yyyy')
                            || '<br/>'
                            || DECODE(T2.LOAIKHANGCAO, 0, '+ Kháng cáo bản án số: '
                                                          || BA.SOBANAN
                                                          || ', Ngày: '
                                                          || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'), '+ Kháng cáo quyết định số: '
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
                ADS_SOTHAM_KHANGCAO     T2
                INNER JOIN ADS_DON_THAMGIATOTUNG   T3 ON T2.DUONGSUID = T3.ID
                                                       AND ( T3.DONID = T2.DONID )
                LEFT JOIN DM_DATAITEM             DM ON DM.MA = T3.TUCACHTGTTID
                LEFT JOIN ADS_SOTHAM_QUYETDINH    QD ON QD.ID = T2.SOQDBA
                                                     AND T2.LOAIKHANGCAO IN (
                    1,
                    2
                ) --> Kháng cáo quyết định --toancau-anhnt kc tđc

                LEFT JOIN ADS_SOTHAM_BANAN        BA ON BA.ID = T2.SOQDBA
                                                 AND T2.LOAIKHANGCAO = 0 --> Kháng cáo bản án

            WHERE
                T2.DONID = (
                    CASE
                        WHEN NOT EXISTS (
                            SELECT
                                'x'
                            FROM
                                ADS_DON
                            WHERE
                                ID = V_VUANID
                                AND ADS_DON.MAGIAIDOAN = 7
                        ) THEN
                            V_VUANID
                        ELSE
                            (
                                SELECT
                                    VUANID
                                FROM
                                    ADS_CHUYEN_NHAN_AN
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
        ) LOOP V_EXPORT_TEXT := TO_CLOB(V_EXPORT_TEXT || ITEMS.NOIDUNG);
        END LOOP;
  -- Tổng hợp kháng nghị

        FOR ITEMS IN (
            SELECT --GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENAN.(kháng nghị)

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
                ADS_SOTHAM_KHANGNGHI   T2
                LEFT JOIN DM_VKS                 T4 ON T2.TOAAN_VKS_KN = T4.ID
                                       AND T2.DONVIKN = 1 --> Viện trưởng Viện kiểm sát

                LEFT JOIN DM_TOAAN               T5 ON T2.TOAAN_VKS_KN = T5.ID
                                         AND T2.DONVIKN = 0 --> Chánh án Tòa án

                LEFT JOIN ADS_SOTHAM_QUYETDINH   QD ON QD.ID = T2.BANANID
                                                     AND T2.LOAIKN IN (
                    1,
                    2
                ) --> Kháng cáo quyết định

                LEFT JOIN ADS_SOTHAM_BANAN       BA ON BA.ID = T2.BANANID
                                                 AND T2.LOAIKN = 0 --> Kháng cáo bản án

                LEFT JOIN ADS_SOTHAM_RUTKCKN     RUT ON T2.ID = RUT.IDKCKN
            WHERE
                T2.DONID = (
                    CASE
                        WHEN NOT EXISTS (
                            SELECT
                                'x'
                            FROM
                                ADS_DON
                            WHERE
                                ID = V_VUANID
                                AND ADS_DON.MAGIAIDOAN = 7
                        ) THEN
                            V_VUANID
                        ELSE
                            (
                                SELECT
                                    VUANID
                                FROM
                                    ADS_CHUYEN_NHAN_AN
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
        ) LOOP V_EXPORT_TEXT := TO_CLOB(V_EXPORT_TEXT
                                        || '<br/>'
                                        || ITEMS.NOIDUNG);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE(V_EXPORT_TEXT);
        UPDATE ADS_CHUYEN_NHAN_AN
        SET
            NOIDUNG = V_EXPORT_TEXT,
            LYDOCHUYEN = VNOIDUNG
        WHERE
            ID = VNHANANID;

    END;

    PROCEDURE COUNT_KCKN_TDC (
        VDONID   IN    NUMBER,
        VOUT     OUT   NUMBER
    ) AS
        LCOUNTKC   NUMBER;
        LCOUNTKN   NUMBER;
    BEGIN
        SELECT
            COUNT(KC.ID)
        INTO LCOUNTKC
        FROM
            ADS_SOTHAM_KHANGCAO    KC
            LEFT JOIN ADS_SOTHAM_QUYETDINH   QD ON QD.ID = KC.SOQDBA
            LEFT JOIN DM_QD_QUYETDINH        DM ON DM.ID = QD.QUYETDINHID
        WHERE
            KC.LOAIKHANGCAO = 2
            AND NVL(KC.TINHTRANG_GIAIQUYET, 0) = 0
            AND DM.MA IN (
                '41-DS',
                '42-DS'
            )
            AND KC.DONID = VDONID;

        SELECT
            COUNT(KN.ID)
        INTO LCOUNTKN
        FROM
            ADS_SOTHAM_KHANGNGHI   KN
            LEFT JOIN ADS_SOTHAM_QUYETDINH   QD ON QD.ID = KN.BANANID
            LEFT JOIN DM_QD_QUYETDINH        DM ON DM.ID = QD.QUYETDINHID
        WHERE
            KN.LOAIKN = 2
            AND NVL(KN.TINHTRANG_GIAIQUYET, 0) = 0
            AND DM.MA IN (
                '41-DS',
                '42-DS'
            )
            AND KN.DONID = VDONID;

        VOUT := NVL(LCOUNTKC, 0) + NVL(LCOUNTKN, 0);
    END;


END PKG_STPT_DS_GS;

/
