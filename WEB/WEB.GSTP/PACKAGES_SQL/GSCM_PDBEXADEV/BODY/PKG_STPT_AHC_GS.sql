--------------------------------------------------------
--  DDL for Package Body PKG_STPT_AHC_GS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_AHC_GS" AS
 PROCEDURE DON_SEARCH (
  V_CAP_XET_XU_LOGIN    IN VARCHAR2,
  V_TEN_VU_AN           IN VARCHAR2,
  V_QHPL                IN VARCHAR2,
  V_MA_VU_AN            IN VARCHAR2,
  V_TENDUONGSU          IN VARCHAR2,
  V_CAPXX               IN VARCHAR2,
  V_TOAAN_ID            IN VARCHAR2,
  V_TINHTRANG_THULY     IN VARCHAR2,
  V_NGAYTHULY_TU        IN VARCHAR2,
  V_NGAYTHULY_DEN       IN VARCHAR2,
  V_SOTHULY             IN VARCHAR2,
  V_THAMPHAN_ID         IN VARCHAR2,
  V_TINHTRANG_GIAIQUYET IN VARCHAR2,
  V_TUNGAY              IN VARCHAR2,
  V_DENNGAY             IN VARCHAR2,
  V_KETQUA              IN VARCHAR2,
  V_SO_QD               IN VARCHAR2,
  V_NGAY_QD             IN VARCHAR2,
  V_THUKY_ID            IN VARCHAR2,
  V_THOIHAN_GQ          IN VARCHAR2,
  V_LOAIDON             IN VARCHAR2,
  V_PT_RKINHNGHIEM      IN VARCHAR2,
  V_GQDON               IN VARCHAR2,
  V_UTTP                IN VARCHAR2,
  VCHECKTK              IN NUMBER,
  V_TRANGTHAIVUAN       IN NUMBER,
  V_VAITRO_THAMPHAN     IN VARCHAR2,
 V_CHECK_HOAGIAI        IN NUMBER,
    V_HOAGIAI_TRANGTHAI IN NUMBER DEFAULT NULL,
    V_HOAGIAI_TUNGAY IN VARCHAR2 DEFAULT NULL,
    V_HOAGIAI_DENNGAY IN VARCHAR2 DEFAULT NULL,
  V_AN_KET_THUC           IN NUMBER,
  PAGE_INDEX            IN INT,
  PAGE_SIZE             IN INT,
  CURRETURN             OUT SYS_REFCURSOR
 ) IS
  TOTALITEM        NUMBER;
  MININDEX         NUMBER;
  MAXINDEX         NUMBER;
  VV_TUNGAY        DATE;
  VV_DENNGAY       DATE;
  VV_NGAYTHULY_TU  DATE;
  VV_NGAYTHULY_DEN DATE;
  V_TABLE_TLPT     T_QUYETDINH_EXT;
  V_TABLE_HDXX_PT  T_QUYETDINH_EXT;
  V_TABLE_PT       T_QUYETDINH_EXT;
  V_TABLE_BC       T_BICANBICAO_EXT;
  V_TABLE_BC_KC    T_BICANBICAO_EXT;
  V_TABLE_THAMPHAN T_THAMPHAN_EXT;
    --TOANCAU-03102023-ANHNT
 BEGIN
  V_TABLE_TLPT := T_QUYETDINH_EXT();
  V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
  V_TABLE_PT := T_QUYETDINH_EXT();
  V_TABLE_BC := T_BICANBICAO_EXT();
  V_TABLE_BC_KC := T_BICANBICAO_EXT();
  V_TABLE_THAMPHAN := T_THAMPHAN_EXT();
    --TOANCAU-03102023-ANHNT
    ---------------------------------------
  MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
  MAXINDEX := PAGE_INDEX * PAGE_SIZE;
    ----------
  IF ( V_NGAYTHULY_TU IS NOT NULL ) THEN VV_NGAYTHULY_TU := TO_DATE ( TRIM(V_NGAYTHULY_TU) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;
  IF ( V_NGAYTHULY_DEN IS NOT NULL ) THEN VV_NGAYTHULY_DEN := TO_DATE ( TRIM(V_NGAYTHULY_DEN) || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;  
     --
  IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;
  IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;  
   ------------------------
   ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --THAMPHAN --TOANCAU-03102023-ANHNT
  SELECT R_THAMPHAN_EXT(TP.DONID, TP.ID, TP.CANBOID, TP.MAVAITRO, TP.MAGIAIDOAN,
                        TP.NGAYPHANCONG)
  BULK COLLECT
  INTO V_TABLE_THAMPHAN
  FROM ( SELECT MAVAITRO,
                DONID,
                ID,
                CANBOID,
                ROW_NUMBER()
                OVER(PARTITION BY DONID, MAVAITRO
                     ORDER BY NGAYPHANCONG DESC
                ) ROWNUMBER,
                NGAYPHANCONG,
                (
                               CASE
                                WHEN MAVAITRO IN ( 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETDON' ) THEN 2
                                WHEN MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' THEN 7
                               END
                              ) MAGIAIDOAN
                              FROM AHC_DON_THAMPHAN
                       WHERE MAVAITRO IN ( 'VTTP_GIAIQUYETDON', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' )
                UNION
                SELECT CAST(MAVAITRO AS NVARCHAR2(20)) MAVAITRO,
                       DONID,
                       ID,
                       CANBOID,
                       ROW_NUMBER()
                       OVER(PARTITION BY DONID, MAVAITRO
                            ORDER BY NGAYPHANCONG DESC
                       )                               ROWNUMBER,
                       NGAYPHANCONG,
                       7                               MAGIAIDOAN
                FROM AHC_KCKNQDK_PHUCTHAM_HDXX
         WHERE MAVAITRO IN ( 'THAMPHAN', 'THAMPHANHDXX', 'THAMPHANDUKHUYET' )
       ) TP
  WHERE ( ( TP.ROWNUMBER = 1 AND
            TP.MAVAITRO IN ( 'VTTP_GIAIQUYETDON', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM', 'THAMPHAN', 'THAMPHANHDXX' ) OR
            TP.MAVAITRO = 'THAMPHANDUKHUYET' ) );
		--THAMPHAN --TOANCAU-03102023-ANHNT
         --AHC_KCKNQDK_PHUCTHAM_QUYETDINH
  SELECT R_QUYETDINH_EXT(TTS.DONID, TTS.ID, TTS.MA)
  BULK COLLECT
  INTO V_TABLE_PT
  FROM ( SELECT TT.DONID,
                TT.ID,
                TT.MA
                FROM ( SELECT PQD.DONID,
                              FIRST_VALUE(PQD.ID)
                              OVER(PARTITION BY PQD.DONID, QDL.MA
                                   ORDER BY PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                              ) ID,
                              QDL.MA
                       FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PQD
                       LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PQD.QUYETDINHID
                       LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                     ) TT
         GROUP BY TT.DONID,
                  TT.ID,
                  TT.MA
       ) TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
  SELECT R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
  BULK COLLECT
  INTO V_TABLE_BC
  FROM ( SELECT BC.ID,
                BC.DONID,
                BC.TENDUONGSU,
                BC.TUCACHTOTUNG_MA,
                BC.ROWNUMBER
                FROM ( SELECT ID,
                              DONID,
                              TENDUONGSU,
                              TUCACHTOTUNG_MA,
                              ROW_NUMBER()
                              OVER(PARTITION BY DONID
                                   ORDER BY ISDAIDIEN DESC, TENDUONGSU
                              ) ROWNUMBER
                              FROM AHC_DON_DUONGSU
                       WHERE ISDAIDIEN = 0
                     ) BC
         WHERE BC.ROWNUMBER <= 3
       ) TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
  SELECT R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
  BULK COLLECT
  INTO V_TABLE_BC_KC
  FROM ( SELECT BC.ID,
                BC.DONID,
                BC.TENDUONGSU,
                BC.TUCACHTOTUNG_MA,
                BC.ROWNUMBER
                FROM ( SELECT DS.ID,
                              DS.DONID,
                              DS.TENDUONGSU,
                              DS.TUCACHTOTUNG_MA,
                              ROW_NUMBER()
                              OVER(PARTITION BY DS.DONID
                                   ORDER BY DS.ISDAIDIEN DESC, DS.TENDUONGSU
                              ) ROWNUMBER
                              FROM AHC_DON_DUONGSU DS
                       WHERE EXISTS ( SELECT 'X'
                                                     FROM AHC_SOTHAM_KHANGCAO KC
                                      WHERE KC.DUONGSUID = DS.ID AND
                                            KC.DONID = DS.DONID
                                    )
                     ) BC
         WHERE BC.ROWNUMBER <= 3
       ) TTS;             
   -----------------------
  OPEN CURRETURN FOR SELECT TT.*
                                        FROM ( SELECT ROW_NUMBER()
                                                      OVER(
                                                       ORDER BY A.NGAYTAO DESC
                                                      )                                                                                STT,
                                                      COUNT(*)
                                                      OVER()                                                                           AS COUNTALL,
                                                      A.ID,
                                                      A.MAVUVIEC,
                                                      A.TENVUVIEC,
                                                      A.SOTHUTU,
                                                      A.NGAYNHANDON,
                                                      A.NGUOITAO,
                                                      TO_CHAR(A.NGAYTAO, 'dd/MM/yyyy') || '<br/>' || TO_CHAR(A.NGAYTAO, ' HH24:MI:SS') NGAYTAO,
                                                      I.TEN                                                                            AS QUANHEPL,
                                                      '</br><i>Tòa xét xử sơ thẩm: </i><b>' || NVL(TST.TEN, T.TEN) || '</b>'           TENTOASOTHAM,
                                                      'Phúc thẩm'                                                                      GIAIDOANVUVIEC,
--      GN.TRUONGHOPGIAONHAN,
                                                      A.HINHTHUCNHANDON,
                                                      DECODE(A.HINHTHUCNHANDON, 1, '<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>', 270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                                             '<br/><i>TH giao nhận:</i> <b>' || GN.TRUONGHOPGIAONHAN || '</b>')        TRUONGHOPGIAONHAN,
                                                      STBA.BANAN_QD_ST,
                                                      STKN.KHANGNGHI_ST,
                                                      STKC.KHANGCAO_ST,
                                                      PTQD.QD_PT,
                                                      A.MAGIAIDOAN,
                                                      ( BC3.HOTEN )                                                                    HOTENBICAN,
                                                      DECODE(XLD.LOAIGIAIQUYET,
                                                             1,
                                                             '- Đã chuyển đơn',
                                                             CASE
                                                              WHEN(TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý'
                                                              ELSE(TLPT.TINHTRANG_GQ)
                                                             END
                                                             ||
                                                             CASE
                                                              WHEN(TPPCPT.TINHTRANG_GQ) IS NULL AND
                                                                  (TLPT.TINHTRANG_GQ) IS NOT NULL THEN '</br>- Chưa phân công Thẩm phán'
                                                              ELSE(TPPCPT.TINHTRANG_GQ)
                                                             END
                                                             || HPTPT.TINHTRANG_GQ || TDCPT.TINHTRANG_GQ || DCPT.TINHTRANG_GQ || CPT.TINHTRANG_GQ || GNST.TINHTRANG_GQ ||
     --hieu thêm thông tin giải quyết của vụ án cha
                                                             CASE
                                                              WHEN(A.VUANGOCID > 0 AND
                                                                   A.IS_TACHAN IS NULL) THEN(SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> ' || TO_CHAR(T.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T.NGAYTHULY, 'dd/MM/yyyy')
                                                                                                                   FROM AHC_DON          D
                                                                                                                   LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                         WHERE D.ID = A.VUANGOCID
                                                                                             )
                                                              WHEN(A.VUANGOCID > 0 AND
                                                                   A.IS_TACHAN = 1) THEN(SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ' || TO_CHAR(T.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T.NGAYTHULY, 'dd/MM/yyyy')
                                                                                                           FROM AHC_DON          D
                                                                                                           LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                     WHERE D.ID = A.VUANGOCID
                                                                                         )
                                                             END
                                                      )                                                                                TINHTRANG_GQ,
                                                      ( TLPT.TINHTRANG_GQ )                                                            CHECK_THULY,
                                                      0                                                                                THULYXXLAI
                                                      FROM AHC_DON            A
                                                      LEFT JOIN DM_DATAITEM        I ON A.QUANHEPHAPLUATID = I.ID
                                                      LEFT JOIN DM_TOAAN           T ON A.TOAANID = T.ID
                                                      LEFT JOIN AHC_CHUYEN_NHAN_AN NA ON NA.MAP_VUANID_NEW = A.ID
                                                      LEFT JOIN DM_TOAAN           TST ON NA.TOACHUYENID = TST.ID
      ----- BA Or QD----------------------------------------------
                                                      LEFT JOIN ( SELECT PTQDVA.*
                                                                              FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                              LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                              LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                  WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                                )                  QD ON QD.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQD.DONID,
                                                                         '<br /><i>QĐ GQ PT: </i><b>' || 'Số ' || PTQD.SOQD || ' ngày ' || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy') || '</b>' QD_PT
                                                                              FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQD
                                                                  WHERE QUYETDINHID = 213
                                                                )                  PTQD ON PTQD.DONID = A.ID  
         --- Lay ra trang thai giai quyet don
                                                      LEFT JOIN ( SELECT DONID,
                                                                         LOAIGIAIQUYET,
                                                                         NGAYGQ_YC
                                                                              FROM AHC_DON_XULY
                                                                  WHERE LOAIGIAIQUYET IN ( 1, 5 )
                                                                )                  XLD ON A.ID = XLD.DONID
                                                      LEFT JOIN ( SELECT T2.DONID,
                                                                         T2.NGAYTHULY,
                                                                         T2.SOTHULY,
                                                                         T2.TRUONGHOPTHULY,
                                                                         '</br>- Thụ lý số:<b> ' || TO_CHAR(T2.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy') || '</b>' TINHTRANG_GQ
                                                                              FROM GSCM.AHC_KCKNQDK_PHUCTHAM_THULY T2
                                                                  WHERE EXISTS ( SELECT 'X'
                                                                                                FROM ( SELECT TT.DONID,
                                                                                                              TT.ID
                                                                                                              FROM ( SELECT DONID,
                                                                                                                            FIRST_VALUE(ID)
                                                                                                                            OVER(PARTITION BY DONID
                                                                                                                                 ORDER BY NGAYTHULY DESC, NGAYTAO DESC
                                                                                                                            ) ID
                                                                                                                     FROM AHC_KCKNQDK_PHUCTHAM_THULY
                                                                                                                   ) TT
                                                                                                       GROUP BY TT.DONID,
                                                                                                                TT.ID
                                                                                                     ) QDL
                                                                                 WHERE QDL.ID = T2.ID
                                                                               )
    --> Lấy thụ lý mới nhất
                                                                )                  TLPT ON TLPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT TP.DONID,
                                                                         '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                                                                                          FROM AHC_DON_THAMPHAN TP
                                                                                          LEFT JOIN ( SELECT TT.DONID,
                                                                                                             TT.ID
                                                                                                                  FROM ( SELECT DONID,
                                                                                                                                FIRST_VALUE(CANBOID)
                                                                                                                                OVER(PARTITION BY DONID
                                                                                                                                     ORDER BY NGAYTAO DESC
                                                                                                                                ) ID
                                                                                                                                FROM AHC_KCKNQDK_PHUCTHAM_HDXX
                                                                                                                         WHERE MAVAITRO = 'THAMPHAN'
                                                                                                                       ) TT
                                                                                                      GROUP BY TT.DONID,
                                                                                                               TT.ID
                                                                                                    )                HD ON HD.DONID = TP.DONID
                                                                                          LEFT JOIN ( SELECT GG.*
                                                                                                                  FROM AHC_DON_THAMPHAN GG
                                                                                                      WHERE EXISTS ( SELECT 'X'
                                                                                                                                    FROM ( SELECT TT.DONID,
                                                                                                                                                  TT.ID
                                                                                                                                                  FROM ( SELECT DONID,
                                                                                                                                                                FIRST_VALUE(ID)
                                                                                                                                                                OVER(PARTITION BY DONID
                                                                                                                                                                     ORDER BY NGAYNHANPHANCONG DESC
                                                                                                                                                                ) ID
                                                                                                                                                         FROM AHC_DON_THAMPHAN
                                                                                                                                                       ) TT
                                                                                                                                           GROUP BY TT.DONID,
                                                                                                                                                    TT.ID
                                                                                                                                         ) TP
                                                                                                                     WHERE TP.ID = GG.ID
                                                                                                                   )
                                                                                                    )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID
    --lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                                                                          LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                                                                          LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                                                              WHERE TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                                  GROUP BY TP.DONID,
                                                                           '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>'
                                                                )                  TPPCPT ON TPPCPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ HPT số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',HPT,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ HPT số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  HPTPT ON HPTPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ TĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',TDC,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ TĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  TDCPT ON TDCPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ ĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ ĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  DCPT ON DCPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ CVA số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',CVA,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ CVA số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  CPT ON CPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT CA.VUANID,
                                             -- '</br>- '
                                              --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                                                         '</br>- Đã chuyển vụ án' TINHTRANG_GQ
                                                                              FROM AHC_CHUYEN_NHAN_AN CA
                                                                              INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                                                  WHERE CA.TOACHUYENID = V_TOAAN_ID
                                                                )                  GNST ON GNST.VUANID = A.ID
                                                      LEFT JOIN ( SELECT CA.MAP_VUANID_NEW,
                                                                         I.TEN TRUONGHOPGIAONHAN
                                                                                          FROM DM_DATAITEM I
                                                                                          INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                                                              WHERE CA.TOANHANID = V_TOAAN_ID
                                                                  GROUP BY CA.MAP_VUANID_NEW,
                                                                           I.TEN
                                                                )                  GN ON GN.MAP_VUANID_NEW = A.ID
             ------bị cáo kháng cáo lấy cho phúc thẩm    
                                                      LEFT JOIN ( SELECT BC.DONID,
                                                                         '<br /><i>Người kháng cáo:</i> <br />' ||
                                                                         LISTAGG(BC.TENDUONGSU || ' ' || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Người khởi kiện)', 'BIDON', '(Người bị kiện)',
                                                                                                                'QUYENNVLQ', '(Người có quyền và NVLQ)', ' (' || BC.TUCACHTOTUNG_MA || ')'),
                                                                                 '<br/>') WITHIN GROUP(
                                                                               ORDER BY BC.ROWNUMBER)
                                                                              HOTEN
                                                                              FROM TABLE ( V_TABLE_BC_KC ) BC
                                                                  GROUP BY BC.DONID
                                                                )                  BC3 ON BC3.DONID = A.ID


        ----- lấy thông tin BA/sơ thẩm                
                                                      LEFT JOIN ( SELECT BA.DONID,
                                                                         '<br />BA/QĐ sơ thẩm: <b>' || 'Số ' || BA.SOBANAN || ' ngày ' || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy') || '</b>' BANAN_QD_ST
                                                                  FROM AHC_SOTHAM_BANAN BA
                                                                )                  STBA ON STBA.DONID = NA.VUANID           

        ------- lấy thông tin số ngày kháng nghị
                                                      LEFT JOIN ( SELECT KN.DONID,
                                                                         '<br /><i>Kháng nghị:</i> <br />' ||
                                                                         LISTAGG('Số ' || KN.SOKN || ' ngày ' || TO_CHAR(KN.NGAYKN, 'dd/MM/yyyy'),
                                                                                 '<br/>') WITHIN GROUP(
                                                                                           ORDER BY KN.NGAYKN)
                                                                                          KHANGNGHI_ST
                                                                                          FROM AHC_SOTHAM_KHANGNGHI KN
                                                                              WHERE KN.TINHTRANG_GIAIQUYET != 3 AND
                                                                                    KN.LOAIKN = 2
                                                                  GROUP BY KN.DONID
                                                                )                  STKN ON STKN.DONID = NA.VUANID 

------ - lấy thông tin số ngày kháng cáo + đương sự toancau
                                                      LEFT JOIN ( SELECT DSKC.DONID,
                                                                         '<br /><i>Kháng cáo: </i> <br />' || ' Tên đương sự: ' || DSKC.TENDUONGSU || '<br/>' ||
                                                                         LISTAGG(' - Ngày kháng cáo: ' || TO_CHAR(DSKC.NGAYKHANGCAO, 'dd/MM/yyyy'),
                                                                                 '<br/>') WITHIN GROUP(
                                                                               ORDER BY DSKC.TENDUONGSU)
                                                                              KHANGCAO_ST
                                                                              FROM ( SELECT DS.DONID,
                                                                                            DS.TENDUONGSU || '-' || I.TEN TENDUONGSU,
                                                                                            KC.NGAYKHANGCAO,
                                                                                            KC.ID
                                                                                            FROM AHC_SOTHAM_KHANGCAO KC
                                                                                            INNER JOIN AHC_DON_DUONGSU DS ON KC.DUONGSUID = DS.ID
                                                                                            LEFT JOIN DM_DATAITEM     I ON I.MA = DS.TUCACHTOTUNG_MA
                                                                                     WHERE KC.TINHTRANG_GIAIQUYET != 2
                                                                                   ) DSKC
                                                                  GROUP BY DSKC.DONID,
                                                                           DSKC.TENDUONGSU
                                                                )                  STKC ON STKC.DONID = NA.VUANID 


        ---------------------                
                                               WHERE A.TOAPHUCTHAMID = V_TOAAN_ID AND
                                                     A.MAGIAIDOAN = 7 AND
                                                     ( V_TEN_VU_AN IS NULL OR
                                                       ( LOWER(A.TENVUVIEC) LIKE '%' || LOWER(V_TEN_VU_AN) || '%' ) )
    --Tên vụ án
                                                        AND
                                                     ( V_UTTP IS NULL OR
                                                       ( V_UTTP IS NOT NULL AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_THULY TLPT
                                                                    WHERE TLPT.UTTPDI = TO_NUMBER(V_UTTP) AND
                                                                          TLPT.DONID = A.ID
                                                                  ) ) ) ) AND
                                                     ( V_QHPL IS NULL OR
                                                       ( LOWER(A.TENVUVIEC) LIKE '%' || LOWER(V_QHPL) || '%' ) )
    --Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                                                        AND
                                                     ( V_MA_VU_AN IS NULL OR
                                                       ( LOWER(A.MAVUVIEC) LIKE LOWER(V_MA_VU_AN) ) )
       --Mã vụ án
                                                        AND
                                                     ( V_TENDUONGSU IS NULL
     --Đương sự
                                                      OR
                                                       ( EXISTS ( SELECT 'X'
                                                                             FROM AHC_DON_DUONGSU DS
                                                                  WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%' || FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU)) || '%' AND
                                                                        DS.DONID = A.ID
                                                                ) ) )
                        -----------------------------check hoa giải
--                                        AND (NVL(V_CHECK_HOAGIAI,0) = 0 OR 
--                                            D.HOAGIAI_TRANGTHAI > 0)
           -----   
           --26/06/2023 tuyennh them tim kiem theo ten tham phan--                               
                                                                 AND
                                                     ( V_THAMPHAN_ID IS NULL
                                                     --TOANCAU-03102023-ANHNT
                                                      OR
                                                       ( V_VAITRO_THAMPHAN IS NULL AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.CANBOID = V_THAMPHAN_ID AND
                                                                        TP.MAGIAIDOAN = A.MAGIAIDOAN
                                                                ) ) OR
                                                       ( V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC' AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.MAVAITRO IN ( 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' ) AND
                                                                        TP.CANBOID = V_THAMPHAN_ID
                                                                ) ) OR
                                                       ( V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA' AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.MAVAITRO IN ( 'THAMPHAN', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' ) AND
                                                                        TP.CANBOID = V_THAMPHAN_ID AND
                                                                        TP.MAGIAIDOAN = A.MAGIAIDOAN
                                                                ) ) OR
                                                       ( V_VAITRO_THAMPHAN IN ( 'VTTP_GIAIQUYETDON', 'THAMPHANHDXX', 'THAMPHANDUKHUYET' ) AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.MAVAITRO = V_VAITRO_THAMPHAN AND
                                                                        TP.CANBOID = V_THAMPHAN_ID AND
                                                                        TP.MAGIAIDOAN = A.MAGIAIDOAN
                                                                ) ) )
           --TOANCAU-03102023-ANHNT
                --26/06/2023 tuyennh them tim kiem theo ten tham phan-- 
                                                                 AND
                                                     ( ( V_TINHTRANG_THULY IS NULL AND
                                                         ( V_NGAYTHULY_TU IS NULL OR
                                                           A.NGAYTAO >= VV_NGAYTHULY_TU ) AND
                                                         ( V_NGAYTHULY_DEN IS NULL OR
                                                           A.NGAYTAO <= VV_NGAYTHULY_DEN ) )
    --Tình trạng thụ lý
                                                            OR
                                                       ( V_TINHTRANG_THULY = 1 AND
                                                         ( ( ( TLPT.DONID IS NOT NULL AND
                                                               ( V_NGAYTHULY_TU IS NULL OR
                                                                 TLPT.NGAYTHULY >= VV_NGAYTHULY_TU ) AND
                                                               ( V_NGAYTHULY_DEN IS NULL OR
                                                                 TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) ) ) ) OR
                                                         ( V_TINHTRANG_THULY = 2 AND
                                                           ( TLPT.DONID IS NULL ) AND
                                                           ( V_NGAYTHULY_TU IS NULL OR
                                                             A.NGAYTAO >= VV_NGAYTHULY_TU ) AND
                                                           ( V_NGAYTHULY_DEN IS NULL OR
                                                             A.NGAYTAO <= VV_NGAYTHULY_DEN ) ) )
         -----
                                                              AND
                                                       ( V_SOTHULY IS NULL OR
                                                         ( UPPER(TLPT.SOTHULY) = UPPER(V_SOTHULY) ) )
    --Số Thụ lý
         -----
                                        --    AND ( V_THAMPHAN_ID IS NULL
                                        --          OR ( EXISTS (
                                        --  SELECT
                                        --      'x'
                                        --  FROM
                                        --      AHC_DON_THAMPHAN PC
                                       --   WHERE
                                       --           PC.CANBOID = V_THAMPHAN_ID
                                       --       AND PC.DONID = A.ID
                                     -- ) )--Thẩm phán
                                     --  )
            --GQ đơn;V_GQDON -- -- 
                                                          AND
                                                       ( V_GQDON IS NULL OR
                                                         ( ( V_GQDON = 1 OR
                                                             V_GQDON = 3 OR
                                                             V_GQDON = 4 OR
                                                             V_GQDON = 5 ) AND
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_DON_XULY XL
                                                                    WHERE XL.LOAIGIAIQUYET = V_GQDON AND
                                                                          XL.DONID = A.ID
                                                                  ) ) OR
                                                         ( V_GQDON = 6 AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_XULY XL
                                                                        WHERE XL.DONID = A.ID
                                                                      ) ) OR
                                                         ( V_GQDON = 7 AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_XULY XL
                                                                        WHERE XL.DONID = A.ID
                                                                      ) AND
                                                           ( SYSDATE - A.NGAYNHANDON ) > 15 ) OR
                                                         ( V_GQDON = 8 AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_XULY XL
                                                                        WHERE XL.DONID = A.ID
                                                                      ) AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_THAMPHAN TP
                                                                        WHERE TP.DONID = A.ID
                                                                      ) ) ) AND
                                                       ( V_THUKY_ID IS NULL
    --Thư ký
                                                        OR
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_HDXX TP
                                                                    WHERE TP.CANBOID = V_THUKY_ID AND
                                                                          TP.DONID = A.ID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_DON_THAMPHAN TP
                                                                    WHERE TP.THUKYID = V_THUKY_ID AND
                                                                          TP.DONID = A.ID
                                                                  ) ) ) AND
                                                       ( VCHECKTK = 0 OR
                                                         ( SELECT COUNT(*)
                                                             FROM AHC_DON_THAMPHAN TP
                                                           WHERE TP.DONID = A.ID AND
                                                                 TP.THUKYID = VCHECKTK AND
                                                                 TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                         ) > 0 ) 
               --hieu check theo trạng thái vụ án hành chính        
                                                          AND
                                                       ( ( V_TRANGTHAIVUAN = 0 AND
                                                           ( A.VUANGOCID = 0 OR
                                                             A.VUANGOCID IS NULL ) ) OR
                                                         ( V_TRANGTHAIVUAN = 1 AND
                                                           A.VUANGOCID > 0 AND
                                                           A.IS_TACHAN IS NULL ) OR
                                                         ( V_TRANGTHAIVUAN = 2 AND
                                                           A.VUANGOCID > 0 AND
                                                           A.IS_TACHAN = 1 ) ) 
            ------Loại đơn 
                                                            AND
                                                       ( V_LOAIDON IS NULL OR
                                                         ( A.LOAIDON = V_LOAIDON ) )    
           --------------
                                                          AND
                                                       ( V_SO_QD IS NULL
    --Số BA/QĐ
                                                        OR
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_SOTHAM_BANAN QSV
                                                                    WHERE UPPER(QSV.SOBANAN) LIKE '%' || V_SO_QD || '%' AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_SOTHAM_QUYETDINH QSV
                                                                    WHERE UPPER(QSV.SOQD) LIKE '%' || V_SO_QD || '%' AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                    WHERE UPPER(QSV.SOQD) LIKE '%' || V_SO_QD || '%' AND
                                                                          A.ID = QSV.DONID
                                                                  ) ) ) AND
                                                       ( V_NGAY_QD IS NULL
    --Ngày BA/QĐ
                                                        OR
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_SOTHAM_BANAN QSV
                                                                    WHERE TO_CHAR(QSV.NGAYMOPHIENTOA, 'dd/MM/yyyy') = V_NGAY_QD AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_SOTHAM_QUYETDINH QSV
                                                                    WHERE TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                    WHERE TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD AND
                                                                          A.ID = QSV.DONID
                                                                  ) ) )
                                      --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
             --11/7/2023 TOAN CAU - quyet(
                                                                   AND
                                                       ( V_KETQUA IS NULL OR
                                                         ( V_KETQUA = 1 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 101
     --Giữ nguyên quyết định của Tòa án cấp sơ thẩm
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) OR
                                                         ( V_KETQUA = 2 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 103
     --Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) OR
                                                         ( V_KETQUA = 3 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 21
     --Sửa toàn bộ bản án, quyết định sơ thẩm
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) OR
                                                         ( V_KETQUA = 4 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 102
     -- Sửa quyết định của Tòa án cấp sơ thẩm
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) )


        --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        --/////////////đối với sơ thẩm          
                                                                     AND
                                                       ( V_THOIHAN_GQ IS NULL OR
                                                         ( V_THOIHAN_GQ = 1
     --Đã hết thời hạn
                                                          AND
                                                           (  
                            --dùng ngày QĐ phúc thẩm  
                                                            EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_THULY TL
                                                                                 LEFT JOIN AHC_SOTHAM_QUYETDINH       QSV ON TL.DONID = QSV.DONID
                                                                                 LEFT JOIN DM_QD_LOAI                 QDL ON QDL.ID = QSV.LOAIQDID
                                                                      WHERE ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') > 0 AND
                                                                                ( QSV.NGAYQD - TL.NGAYTHULY ) > 90 )
     --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                                                                 OR
                                                                              ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0 AND
                                                                                ( SYSDATE - TL.NGAYTHULY ) > 90 ) ) AND
                                                                            TL.DONID = NA.VUANID
                                                                    ) ) ) ) )
            --Tình trạng GQ;
                                                                     AND
                                                     ( ( V_TINHTRANG_GIAIQUYET IS NULL AND
                                                         ( V_TUNGAY IS NULL OR
                                                           A.NGAYTAO >= VV_TUNGAY ) AND
                                                         ( V_DENNGAY IS NULL OR
                                                           A.NGAYTAO <= VV_DENNGAY ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 1
     --Chưa giải quyết xong
--                                                      
                                --da thu ly
                                                        AND
                                                         ( TLPT.NGAYTHULY IS NOT NULL ) AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          PTQDVA.NGAYQD IS NOT NULL AND
                                                                          V_DENNGAY IS NOT NULL AND
                                                                          VV_DENNGAY < PTQDVA.NGAYQD
                                                                  ) OR
                                                           ( NOT EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                          WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                                                                PTQDVA.DONID = A.ID
                                                                        ) AND
                                                                 (

                                  --chua phan cong tham phan
                                                                  ( ( V_TUNGAY IS NULL OR
                                                                       TLPT.NGAYTHULY >= VV_TUNGAY ) AND
                                                                     ( V_DENNGAY IS NULL OR
                                                                       TLPT.NGAYTHULY <= VV_DENNGAY ) AND
                                                                     NOT EXISTS ( SELECT 'x'
                                                                                               FROM AHC_DON_THAMPHAN PC
                                                                                  WHERE PC.DONID = A.ID AND
                                                                                        ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' ) ) AND
                                                                                        ( V_TUNGAY IS NULL OR
                                                                                          PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                                        ( V_DENNGAY IS NULL OR
                                                                                          PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                                ) )
     --da phan cong tham phan
                                                                                 OR
                                                                   ( EXISTS ( SELECT 'x'
                                                                                         FROM AHC_DON_THAMPHAN PC
                                                                              WHERE PC.DONID = A.ID AND
                                                                                    ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' )
     --phuc thẩm
                                                                                     ) AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                            ) )
     --da len lich xx
                                                                             OR
                                                                   ( EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                              WHERE QDL.MA = 'DVARXX'
     --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                                                               AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                                    PTQDVA.DONID = A.ID
                                                                            ) )
     --dang hoan
                                                                             OR
                                                                   ( EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                                         LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                                         LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                              WHERE PTBA.DONID IS NULL AND
                                                                                    QDL.MA = 'HPT'
     --Vụ án chưa có bản án  --hoãn phiên tòa 
                                                                                     AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                                    PTQDVA.DONID = A.ID
                                                                            ) )
     --dang tdc
                                                                             OR
                                                                   ( EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                                         LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                                         LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                              WHERE PTBA.DONID IS NULL AND
                                                                                    QDL.MA = 'TDC'
     -- QDL.MA ='TDC' Tam dinh chi
                                                                                     AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                                    PTQDVA.DONID = A.ID
                                                                            ) ) ) ) ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 2
     --chưa phân công Thẩm phán
                                                        AND
                                                         ( TPPCPT.DONID IS NULL )
                                                       --( 10/7 toancau quyet
                                                          AND
                                                         ( TLPT.NGAYTHULY IS NOT NULL ) AND
                                                         ( V_TUNGAY IS NULL OR
                                                           TLPT.NGAYTHULY >= VV_TUNGAY ) AND
                                                         ( V_DENNGAY IS NULL OR
                                                           TLPT.NGAYTHULY <= VV_DENNGAY ) AND
                                                         ( NOT EXISTS ( SELECT 'x'
                                                                                       FROM AHC_DON_THAMPHAN PC
                                                                        WHERE PC.DONID = A.ID AND
                                                                              ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' AND
                                                                                  A.MAGIAIDOAN = 7 ) ) AND
                                                                              ( V_TUNGAY IS NULL OR
                                                                                PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                              ( V_DENNGAY IS NULL OR
                                                                                PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                      ) ) )
                                                       --10/7 toancau quyet)
                                                                       OR
                                                       ( V_TINHTRANG_GIAIQUYET = 3
     --đã phân công Thẩm phán
                                                        AND
                                                         EXISTS ( SELECT 'x'
                                                                           FROM AHC_DON_THAMPHAN PC
                                                                  WHERE PC.DONID = A.ID AND
                                                                        ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' )
    --phuc thẩm
                                                                         ) AND
                                                                        ( V_TUNGAY IS NULL OR
                                                                          PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                        ( V_DENNGAY IS NULL OR
                                                                          PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                ) ) 
                                      -- ( 10/7 TOANCAU QUYET
                                                                 OR
                                                       ( V_TINHTRANG_GIAIQUYET = 4
     --ĐÃ LÊN LỊCH XÉT XỬ
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE QDL.MA = 'DVARXX'
     --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                                                     AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 5
     --Đang hoãn  
                                                        AND
                                                         ( 
                      --Đang hoãn phuc tham                 
                                                          EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                               LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          QDL.MA = 'HPT'
     --Vụ án chưa có bản án  --hoãn phiên tòa 
                                                                           AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 6
     --Đang tạm đình chỉ  
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                               LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          QDL.MA = 'TDC'
     -- QDL.MA ='TDC' Tam dinh chi
                                                                           AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) )
                                      -- 10/7 TOANCAU QUYET )
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 7
     --Đã giải quyết xong
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                    WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  )
     -- ( 11/7 TOANCAU QUYET
                                                                   OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                             LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                             LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                             LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7 AND
                                                                          QD.KET_THUC = 1
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                             LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  )
                                      -- 11/7 TOANCAU QUYET)
                                                                   ) )
                                      -- ( 10/7 TOANCAU QUYET
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 8
     --ĐÃ XÉT XỬ 
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                               LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7 AND
                                                                          QD.KET_THUC = 1
                                                                  ) ) )
                                      -- 10/7 TOANCAU QUYET ) 
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 9
     --Đình chỉ
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  ) ) )
                                      -- ( 10/7 TOANCAU QUYET
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 10
     --Công nhận thỏa thuận của đương sự
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',CNTT,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) ) 
                                      -- 10/7 TOANCAU QUYET )
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 11
     --QĐ chuyển vụ án
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',CVA,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  ) ) ) )
                                               AND ((V_AN_KET_THUC = 1
                                                 AND  (    EXISTS(SELECT 'X' 
                                                                     FROM AHC_DON_GIAIDOAN AVGD 
                                                                     WHERE A.ID=AVGD.DONID 
                                                                                   AND (
                                                                        (AVGD.MAGIAIDOAN = 2 AND AVGD.TOAANID = V_TOAAN_ID) OR
                                                                        (AVGD.MAGIAIDOAN in (3,7) AND AVGD.TOAPHUCTHAMID = V_TOAAN_ID)
                                                                      )
                                                                       AND AN_DA_KET_THUC = 1
                                                                     )  
                                                      )
                                                 )
                                            OR (V_AN_KET_THUC = 0 
                                                 AND  (  NOT  EXISTS(SELECT 'X' 
                                                                     FROM AHC_DON_GIAIDOAN AVGD 
                                                                     WHERE A.ID=AVGD.DONID 
                                                                                   AND (
                                                                        (AVGD.MAGIAIDOAN = 2 AND AVGD.TOAANID = V_TOAAN_ID) OR
                                                                        (AVGD.MAGIAIDOAN in (3,7) AND AVGD.TOAPHUCTHAMID = V_TOAAN_ID)
                                                                      )
                                                                       AND AN_DA_KET_THUC = 1
                                                                     )
                                                      )
                                                 )    
                                            OR (V_AN_KET_THUC IS NULL))
                                             ) TT
                     WHERE TT.STT >= MININDEX AND
                           TT.STT <= MAXINDEX;
 END DON_SEARCH;
 PROCEDURE AHC_KCKNQDK_PHUCTHAM_THULY_GETLIST (
  VDONID    IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
 ) IS
  VGROUPTHGIAONHAN NUMBER;
 BEGIN
  SELECT ID
  INTO VGROUPTHGIAONHAN
  FROM DM_DATAGROUP
  WHERE MA = 'TRUONGHOP_GIAONHAN';
  OPEN CURRETURN FOR SELECT T.ID,
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
                            T.NGUOITAO,
                            T.TOA_GIAIQUYET_ID
                                        FROM AHC_KCKNQDK_PHUCTHAM_THULY T
                                        LEFT JOIN AHC_FILE                   F ON F.ID = T.FILEID
                                        LEFT JOIN ( SELECT A.ID,
                                                           A.TEN
                                                                FROM DM_DATAITEM A
                                                    WHERE A.GROUPID = VGROUPTHGIAONHAN AND
                                                          A.MA IN ( '02', '03', '04' )
                                                  )                          THTL ON THTL.ID = T.TRUONGHOPTHULY
                                        LEFT JOIN DM_QHPL_TK                 QHPLTK ON QHPLTK.ID = T.QHPLTKID
                     WHERE T.DONID = VDONID
                     ORDER BY T.NGAYTHULY DESC;
 END AHC_KCKNQDK_PHUCTHAM_THULY_GETLIST;

--    PROCEDURE HC_CHUYENDON (
--        VTOAANID       NUMBER,
--        VTOAANNHAN_TEN IN VARCHAR2,
--        VMAVUVIEC      IN NVARCHAR2,
--        VTENVUVIEC     IN NVARCHAR2,
--        VSOQD          IN NVARCHAR2,
--        VSOBA          IN NVARCHAR2,
--        VTUNGAY        IN DATE,
--        VDENNGAY       IN DATE,
--        VDUONGSU       IN NVARCHAR2,
--        VTRANGTHAI     IN NUMBER,
--        isDon          IN NUMBER, /*0 là đơn, 1 là án*/
--        CURRETURN      OUT SYS_REFCURSOR
--    ) AS
--        V_ARRAY T_CHUYENAN_STPT_GS;
--    BEGIN
--        IF VTRANGTHAI = 1 THEN
--            SELECT
--                R_CHUYENAN_STPT_GS(V_STT => ROW_NUMBER()
--                                         OVER(
--                    ORDER BY
--                        DXL.NGAYGQ_YC DESC, D.TENVUVIEC
--                                         ), V_VUANID => D.ID, V_TOAANID => VTOAANID, V_TENVUAN => D.TENVUVIEC, V_MAVUAN => D.MAVUVIEC,
--                               V_NGAYCHUYEN => NULL, V_NGAYNHAN => NULL, V_NGAYTHULY => NULL, V_NOIDUNG => NULL, V_TOANHAN => NULL,
--                               V_LYDOID => NULL,
--        V_CHUYENNHANID=>NULL
--                               )
--            BULK COLLECT
--            INTO V_ARRAY
--            FROM
--                     AHC_DON D
--                JOIN AHC_DON_XULY DXL ON DXL.DONID = D.ID
--            WHERE
--                ( 1 = (
--                    CASE
--                        WHEN ( VMAVUVIEC
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN LOWER(D.MAVUVIEC) LIKE ( '%'
--                                                      || LOWER(VMAVUVIEC)
--                                                      || '%' ) THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( 1 = (
--                    CASE
--                        WHEN ( VTENVUVIEC
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN LOWER(D.TENVUVIEC) LIKE ( '%'
--                                                       || LOWER(VTENVUVIEC)
--                                                       || '%' ) THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( 1 = (
--                    CASE
--                        WHEN ( VDUONGSU
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(DS.ID)
--                            FROM
--                                AHC_DON_DUONGSU DS
--                            WHERE
--                                    DS.DONID = D.ID
--                                AND LOWER(DS.TENDUONGSU) LIKE ( '%'
--                                                                || LOWER(VDUONGSU)
--                                                                || '%' )
--                        ) > 0          THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND DXL.LOAIGIAIQUYET = 1
--                AND ( ( D.TOAANID = VTOAANID
--                        AND ( D.MAGIAIDOAN = 2
--                              OR D.MAGIAIDOAN = 1
--                              OR D.MAGIAIDOAN = 7 ) )
--                      OR ( D.TOAPHUCTHAMID = VTOAANID
--                           AND ( D.MAGIAIDOAN = 3
--                                 OR D.MAGIAIDOAN = 7 ) )
--                
------------------------              
--                      OR ( D.TOAPHUCTHAMID = VTOAANID
--                           AND ( D.MAGIAIDOAN = 3
--                                 OR D.MAGIAIDOAN = 7 ) )
------------------------
--                                  )
--                AND (
--                    SELECT
--                        COUNT(ID)
--                    FROM
--                        AHC_CHUYEN_NHAN_AN CN
--                    WHERE
--                            CN.VUANID = D.ID
--                        AND CN.TOACHUYENID = VTOAANID
--                ) = 0
--            ORDER BY
--                DXL.NGAYGQ_YC DESC,
--                D.TENVUVIEC;
--
--        ELSE
--            SELECT
--                R_CHUYENAN_STPT_GS(V_STT => ROW_NUMBER()
--                                         OVER(
--                    ORDER BY
--                        CNA.NGAYGIAO DESC, D.TENVUVIEC
--                                         ), V_VUANID => D.ID, V_TOAANID => VTOAANID, V_TENVUAN => D.TENVUVIEC, V_MAVUAN => D.MAVUVIEC,
--                               V_NGAYCHUYEN => CNA.NGAYGIAO, V_NGAYNHAN => CNA.NGAYNHAN, V_NGAYTHULY => NULL, V_NOIDUNG => NULL, V_TOANHAN =>
--                               TA.TEN,
--                               V_LYDOID => CNA.TRUONGHOPGIAONHANID,
--        V_CHUYENNHANID=>CNA.ID)
--            BULK COLLECT
--            INTO V_ARRAY
--            FROM
--                     AHC_DON D
--                INNER JOIN AHC_CHUYEN_NHAN_AN CNA ON CNA.VUANID = D.ID
--                INNER JOIN DM_TOAAN           TA ON CNA.TOANHANID = TA.ID
--                JOIN AHC_DON_XULY       DXL ON DXL.DONID = D.ID
--            WHERE
--                ( ( ( ( D.TOAANID = VTOAANID
--                        AND CNA.TOACHUYENID = VTOAANID )
--                      OR ( D.TOAPHUCTHAMID = VTOAANID
--                           AND CNA.TOACHUYENID = VTOAANID ) )
--                    AND ( 1 = (
--                    CASE
--                        WHEN ( VSOQD
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(SQ.ID)
--                            FROM
--                                     AHC_SOTHAM_QUYETDINH SQ
--                                INNER JOIN DM_QD_LOAI QL ON QL.ID = SQ.LOAIQDID
--                            WHERE
--                                    SQ.DONID = D.ID
--                                AND QL.MA = 'CVA'
--                                AND SQ.SOQD = VSOQD
--                        ) > 0          THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                    AND ( 1 = (
--                    CASE
--                        WHEN ( VSOBA
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(BA.ID)
--                            FROM
--                                AHC_SOTHAM_BANAN BA
--                            WHERE
--                                    BA.DONID = D.ID
--                                AND BA.SOBANAN = VSOBA
--                        ) > 0          THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) ) )
--                  OR -- TRƯỜNG HỢP CÓ ÁN PHÚC THẨM CHUYỂN VỀ
--                   ( ( ( D.TOAANID = VTOAANID
--                           AND CNA.TOACHUYENID = VTOAANID )
--                         OR ( D.TOAPHUCTHAMID = VTOAANID
--                              AND CNA.TOACHUYENID = VTOAANID ) )
--                       AND ( 1 = (
--                    CASE
--                        WHEN ( VSOQD
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(QD1.ID)
--                            FROM
--                                     AHC_PHUCTHAM_QUYETDINH QD1
--                                INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
--                            WHERE
--                                    QD1.DONID = D.ID
--                                AND DMQD.KET_THUC = 1
--                                AND INSTR('04,06,103', QD1.KETQUAID) > 0
--                        ) > 0          THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) ) ) )
--                AND DXL.LOAIGIAIQUYET = 1
--                AND ( 1 = (
--                    CASE
--                        WHEN ( VMAVUVIEC
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN LOWER(D.MAVUVIEC) LIKE ( '%'
--                                                      || LOWER(VMAVUVIEC)
--                                                      || '%' ) THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( 1 = (
--                    CASE
--                        WHEN ( VTENVUVIEC
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN LOWER(D.TENVUVIEC) LIKE ( '%'
--                                                       || LOWER(VTENVUVIEC)
--                                                       || '%' ) THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( 1 = (
--                    CASE
--                        WHEN ( VDUONGSU
--                               || ' ' ) = ' ' THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(DS.ID)
--                            FROM
--                                AHC_DON_DUONGSU DS
--                            WHERE
--                                    DS.DONID = D.ID
--                                AND LOWER(DS.TENDUONGSU) LIKE ( '%'
--                                                                || LOWER(VDUONGSU)
--                                                                || '%' )
--                        ) > 0          THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( 1 = (
--                    CASE
--                        WHEN VTUNGAY IS NULL THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(TL.ID)
--                            FROM
--                                AHC_PHUCTHAM_THULY TL
--                            WHERE
--                                    TL.NGAYTHULY >= VTUNGAY
--                                AND TL.DONID = D.ID
--                        ) > 0 THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( 1 = (
--                    CASE
--                        WHEN VDENNGAY IS NULL THEN
--                            1
--                        WHEN (
--                            SELECT
--                                COUNT(TL.ID)
--                            FROM
--                                AHC_PHUCTHAM_THULY TL
--                            WHERE
--                                    TL.NGAYTHULY <= VDENNGAY
--                                AND TL.DONID = D.ID
--                        ) > 0 THEN
--                            1
--                        ELSE
--                            0
--                    END
--                ) )
--                AND ( VTOAANNHAN_TEN IS NULL
--                      OR ( UPPER(TA.TEN) LIKE '%'
--                                              || UPPER(VTOAANNHAN_TEN)
--                                              || '%' ) )
--            ORDER BY
--                CNA.NGAYGIAO DESC,
--                D.TENVUVIEC;
--
--        END IF;
--
--        PKG_STPT_DS_BC.FILL_HC_CHUYENAN(V_ARRAY);
--        OPEN CURRETURN FOR SELECT
--                               PA.V_STT,
--                               PA.V_VUANID,
--                               PA.V_TOAANID,
--                               PA.V_TENVUAN,
--                               PA.V_MAVUAN,
--                               PA.V_NGAYCHUYEN,
--                               PA.V_NGAYNHAN,
--                               PA.V_NGAYTHULY,
--                               PA.V_NOIDUNG V_NOIDUNG,
--                               PA.V_TOANHAN,
--                               PA.V_LYDOID
--                           FROM
--                               TABLE ( V_ARRAY ) PA;
--
--    END HC_CHUYENDON;

--toancau-linhnd
 PROCEDURE HC_CHUYENDON (
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
    /*0: chưa chuyển; 1: đã chuyển*/
  CURRETURN      OUT SYS_REFCURSOR
 ) AS
  V_ARRAY T_CHUYENAN_STPT_GS;
     -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
 BEGIN
  IF ( VTRANGTHAI = 0 ) THEN
  -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
   SELECT R_CHUYENAN_STPT_GS(V_STT => ROW_NUMBER()
                                                                OVER(
                                                         ORDER BY DXL.NGAYGQ_YC DESC, D.TENVUVIEC
                                                                ), V_VUANID => D.ID, V_TOAANID => VTOAANID, V_TENVUAN => D.TENVUVIEC, V_MAVUAN => D.MAVUVIEC,
                                                      V_NGAYCHUYEN => NULL, V_NGAYNHAN => NULL, V_NGAYTHULY => NULL, V_NOIDUNG => NULL, V_TOANHAN => NULL,
                                                      V_LYDOID => NULL, V_CHUYENNHANID => NULL)
    -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
                                                        BULK COLLECT
                                                        INTO V_ARRAY
                                                        FROM AHC_DON D
                                                        JOIN AHC_DON_XULY DXL ON DXL.DONID = D.ID
                             WHERE ( 1 = (
                              CASE
                               WHEN ( VMAVUVIEC || ' ' ) = ' ' THEN 1
                               WHEN LOWER(D.MAVUVIEC) LIKE ( '%' || LOWER(VMAVUVIEC) || '%' ) THEN 1
                               ELSE 0
                              END
                             ) ) AND
                                   ( 1 = (
                                    CASE
                                     WHEN ( VTENVUVIEC || ' ' ) = ' ' THEN 1
                                     WHEN LOWER(D.TENVUVIEC) LIKE ( '%' || LOWER(VTENVUVIEC) || '%' ) THEN 1
                                     ELSE 0
                                    END
                                   ) ) AND
                                   ( 1 = (
                                    CASE
                                     WHEN ( VDUONGSU || ' ' ) = ' ' THEN 1
                                     WHEN ( SELECT COUNT(DS.ID)
                                                   FROM AHC_DON_DUONGSU DS
                                            WHERE DS.DONID = D.ID AND
                                                  LOWER(DS.TENDUONGSU) LIKE ( '%' || LOWER(VDUONGSU) || '%' )
                                          ) > 0                     THEN 1
                                     ELSE 0
                                    END
                                   ) ) AND
                                   DXL.LOAIGIAIQUYET = 1 AND
                                   ( ( D.TOAANID = VTOAANID AND
                                       ( D.MAGIAIDOAN = 2 OR
                                         D.MAGIAIDOAN = 1 OR
                                         D.MAGIAIDOAN = 7 ) ) OR
                                     ( D.TOAPHUCTHAMID = VTOAANID AND
                                       ( D.MAGIAIDOAN = 3 OR
                                         D.MAGIAIDOAN = 7 ) ) ) AND
                                   ( SELECT COUNT(ID)
                                       FROM AHC_CHUYEN_NHAN_AN CN
                                     WHERE CN.VUANID = D.ID AND
                                           CN.TOACHUYENID = VTOAANID
                                   ) = 0
                             ORDER BY DXL.NGAYGQ_YC DESC,
                                      D.TENVUVIEC;
  ELSE SELECT R_CHUYENAN_STPT_GS(V_STT => ROW_NUMBER()
                                          OVER(
             ORDER BY CNA.NGAYGIAO DESC, D.TENVUVIEC
                                          ), V_VUANID => D.ID, V_TOAANID => VTOAANID, V_TENVUAN => D.TENVUVIEC, V_MAVUAN => D.MAVUVIEC,
                                V_NGAYCHUYEN => CNA.NGAYGIAO, V_NGAYNHAN => CNA.NGAYNHAN, V_NGAYTHULY => NULL, V_NOIDUNG => CNA.LYDOCHUYEN || CNA.NOIDUNG, V_TOANHAN => TA.TEN,
                                V_LYDOID => CNA.TRUONGHOPGIAONHANID, V_CHUYENNHANID => CNA.ID)
    -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
            BULK COLLECT
            INTO V_ARRAY
            FROM AHC_DON D
            INNER JOIN AHC_CHUYEN_NHAN_AN CNA ON CNA.VUANID = D.ID
            INNER JOIN DM_TOAAN           TA ON CNA.TOANHANID = TA.ID
            JOIN AHC_DON_XULY       DXL ON DXL.DONID = D.ID
       WHERE ( ( ( ( D.TOAANID = VTOAANID AND
                     CNA.TOACHUYENID = VTOAANID ) OR
                   ( D.TOAPHUCTHAMID = VTOAANID AND
                     CNA.TOACHUYENID = VTOAANID ) ) AND
                 ( 1 = (
                  CASE
                   WHEN ( VSOQD || ' ' ) = ' ' THEN 1
                   WHEN ( SELECT COUNT(SQ.ID)
                                 FROM AHC_SOTHAM_QUYETDINH SQ
                                 INNER JOIN DM_QD_LOAI QL ON QL.ID = SQ.LOAIQDID
                          WHERE SQ.DONID = D.ID AND
                                QL.MA = 'CVA' AND
                                SQ.SOQD = VSOQD
                        ) > 0                  THEN 1
                   ELSE 0
                  END
                 ) ) AND
                 ( 1 = (
                  CASE
                   WHEN ( VSOBA || ' ' ) = ' ' THEN 1
                   WHEN ( SELECT COUNT(BA.ID)
                                 FROM AHC_SOTHAM_BANAN BA
                          WHERE BA.DONID = D.ID AND
                                BA.SOBANAN = VSOBA
                        ) > 0                  THEN 1
                   ELSE 0
                  END
                 ) ) ) OR
     -- TRƯỜNG HỢP CÓ ÁN PHÚC THẨM CHUYỂN VỀ
               ( ( ( D.TOAANID = VTOAANID AND
                     CNA.TOACHUYENID = VTOAANID ) OR
                   ( D.TOAPHUCTHAMID = VTOAANID AND
                     CNA.TOACHUYENID = VTOAANID ) ) AND
                 ( 1 = (
                  CASE
                   WHEN ( VSOQD || ' ' ) = ' ' THEN 1
                   WHEN ( SELECT COUNT(QD1.ID)
                                 FROM AHC_PHUCTHAM_QUYETDINH QD1
                                 INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD1.QUYETDINHID
                          WHERE QD1.DONID = D.ID AND
                                DMQD.KET_THUC = 1 AND
                                INSTR('04,06,103', QD1.KETQUAID) > 0
                        ) > 0                  THEN 1
                   ELSE 0
                  END
                 ) ) ) ) AND
             DXL.LOAIGIAIQUYET = 1 AND
             ( 1 = (
              CASE
               WHEN ( VMAVUVIEC || ' ' ) = ' ' THEN 1
               WHEN LOWER(D.MAVUVIEC) LIKE ( '%' || LOWER(VMAVUVIEC) || '%' ) THEN 1
               ELSE 0
              END
             ) ) AND
             ( 1 = (
              CASE
               WHEN ( VTENVUVIEC || ' ' ) = ' ' THEN 1
               WHEN LOWER(D.TENVUVIEC) LIKE ( '%' || LOWER(VTENVUVIEC) || '%' ) THEN 1
               ELSE 0
              END
             ) ) AND
             ( 1 = (
              CASE
               WHEN ( VDUONGSU || ' ' ) = ' ' THEN 1
               WHEN ( SELECT COUNT(DS.ID)
                             FROM AHC_DON_DUONGSU DS
                      WHERE DS.DONID = D.ID AND
                            LOWER(DS.TENDUONGSU) LIKE ( '%' || LOWER(VDUONGSU) || '%' )
                    ) > 0                     THEN 1
               ELSE 0
              END
             ) ) AND
             ( 1 = (
              CASE
               WHEN VTUNGAY IS NULL THEN 1
               WHEN ( SELECT COUNT(TL.ID)
                             FROM AHC_PHUCTHAM_THULY TL
                      WHERE TL.NGAYTHULY >= VTUNGAY AND
                            TL.DONID = D.ID
                    ) > 0 THEN 1
               ELSE 0
              END
             ) ) AND
             ( 1 = (
              CASE
               WHEN VDENNGAY IS NULL THEN 1
               WHEN ( SELECT COUNT(TL.ID)
                             FROM AHC_PHUCTHAM_THULY TL
                      WHERE TL.NGAYTHULY <= VDENNGAY AND
                            TL.DONID = D.ID
                    ) > 0 THEN 1
               ELSE 0
              END
             ) ) AND
             ( VTOAANNHAN_TEN IS NULL OR
               ( UPPER(TA.TEN) LIKE '%' || UPPER(VTOAANNHAN_TEN) || '%' ) )
       ORDER BY CNA.NGAYGIAO DESC,
                D.TENVUVIEC;
  END IF;
  OPEN CURRETURN FOR SELECT PA.V_STT,
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
    -- TOANCAU 01-04-2023 LẤY THÊM TRƯỜNG
                     FROM TABLE ( V_ARRAY ) PA;
 END HC_CHUYENDON;  
--toancau-linhnd

 PROCEDURE HC_NHANDON (
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
  SELECT R_NHANAN_STPT(V_STT => ROW_NUMBER()
                                OVER(
   ORDER BY A.NGAYGIAO DESC
                                ), V_TOAANID => VTOAANID, V_VUANID => C.ID, V_CHUYEN_NHAN_ANID => A.ID, V_TENVUAN => C.TENVUVIEC,
                      V_MAVUAN => C.MAVUVIEC, V_NGAYGIAO => A.NGAYGIAO, V_NGAYNHAN => A.NGAYNHAN, V_NOIDUNG => '<b>- Trường hợp giao nhận: </b>' || I.TEN, V_TOACHUYEN => B.TEN,
                      V_LOAIVUVIEC => 'Hành chính', V_LOAIVV => 1, V_TRUONGHOPGIAONHAN => I.TEN)
  BULK COLLECT
  INTO V_ARRAY
  FROM AHC_CHUYEN_NHAN_AN A
  INNER JOIN DM_TOAAN     B ON A.TOACHUYENID = B.ID
  INNER JOIN AHC_DON      C ON A.VUANID = C.ID
  INNER JOIN DM_DATAITEM  I ON I.ID = A.TRUONGHOPGIAONHANID
  JOIN AHC_DON_XULY DXL ON DXL.DONID = A.VUANID
  WHERE A.TOANHANID = VTOAANID AND
        A.TRANGTHAI = VTRANGTHAI AND
        1 = (
         CASE
          WHEN VTRUONGHOPGIAONHAN = 0    THEN 1
          WHEN I.ID = VTRUONGHOPGIAONHAN THEN 1
          ELSE 0
         END
        ) AND
        ( 1 = (
         CASE
          WHEN ( VMAVUVIEC || ' ' ) = ' ' THEN 1
          WHEN LOWER(TRIM(C.MAVUVIEC)) LIKE ( '%' || LOWER(TRIM(VMAVUVIEC)) || '%' ) THEN 1
          ELSE 0
         END
        ) ) AND
        ( 1 = (
         CASE
          WHEN ( VTENVUVIEC || ' ' ) = ' ' THEN 1
          WHEN LOWER(TRIM(C.TENVUVIEC)) LIKE ( '%' || LOWER(TRIM(VTENVUVIEC)) || '%' ) THEN 1
          ELSE 0
         END
        ) ) AND
        ( 1 = (
         CASE
          WHEN ( VTOACHUYEN || ' ' ) = ' ' THEN 1
          WHEN LOWER(TRIM(B.TEN)) LIKE ( '%' || LOWER(TRIM(VTOACHUYEN)) || '%' ) THEN 1
          ELSE 0
         END
        ) ) AND
        ( 1 = (
         CASE
          WHEN VTUNGAY IS NULL THEN 1
          WHEN A.NGAYGIAO >= VTUNGAY THEN 1
          ELSE 0
         END
        ) ) AND
        ( 1 = (
         CASE
          WHEN VDENNGAY IS NULL THEN 1
          WHEN A.NGAYGIAO <= VDENNGAY THEN 1
          ELSE 0
         END
        ) ) AND
        DXL.LOAIGIAIQUYET = 1
  ORDER BY A.NGAYGIAO DESC;
  PKG_STPT_DS_BC.FILL_HC_NHANAN(V_ARRAY);
  OPEN CURRETURN FOR SELECT *
                                        FROM TABLE ( V_ARRAY ) A
                     WHERE
       ---anhvh add tim kiem theo so BA/QD 14/11/2022 cho 6 loai an
                      ( V_SO_QD IS NULL
    --Số BA/QĐ
                      OR
                             ( EXISTS ( SELECT 'X'
                                                   FROM AHC_SOTHAM_BANAN QSV
                                        WHERE UPPER(QSV.SOBANAN) LIKE '%' || V_SO_QD || '%' AND
                                              A.V_VUANID = QSV.DONID
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_SOTHAM_QUYETDINH QSV
                                        WHERE UPPER(QSV.SOQD) LIKE '%' || V_SO_QD || '%' AND
                                              A.V_VUANID = QSV.DONID
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_PHUCTHAM_BANAN QSV
                                        WHERE UPPER(QSV.SOBANAN) LIKE '%' || V_SO_QD || '%' AND
                                              A.V_VUANID = QSV.DONID
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_PHUCTHAM_QUYETDINH QSV
                                        WHERE UPPER(QSV.SOQD) LIKE '%' || V_SO_QD || '%' AND
                                              A.V_VUANID = QSV.DONID
                                      ) ) ) AND
                           ( V_NGAY_QD IS NULL
    --Ngày BA/QĐ
                            OR
                             ( EXISTS ( SELECT 'X'
                                                   FROM AHC_SOTHAM_BANAN QSV
                                        WHERE TO_CHAR(QSV.NGAYTUYENAN, 'dd/MM/yyyy') = V_NGAY_QD AND
                                              A.V_VUANID = QSV.DONID
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_SOTHAM_QUYETDINH QSV
                                        WHERE TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD AND
                                              A.V_VUANID = QSV.DONID
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_PHUCTHAM_BANAN QSV
                                        WHERE TO_CHAR(QSV.NGAYTUYENAN, 'dd/MM/yyyy') = V_NGAY_QD AND
                                              A.V_VUANID = QSV.DONID
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_PHUCTHAM_QUYETDINH QSV
                                        WHERE TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD AND
                                              A.V_VUANID = QSV.DONID
                                      ) ) ) AND
                           ( V_NG_KC IS NULL
    --tìm người kháng cáo
                            OR
                             ( EXISTS ( SELECT 'X'
                                                   FROM AHC_SOTHAM_KHANGCAO T2
                                                   INNER JOIN AHC_DON_DUONGSU T3 ON T2.DUONGSUID = T3.ID
                                        WHERE T2.DONID = A.V_VUANID AND
                                              UPPER(T3.TENDUONGSU) LIKE '%' || UPPER(V_NG_KC) || '%'
                                      ) OR
                               EXISTS ( SELECT 'X'
                                                 FROM AHC_DON_DUONGSU T3
                                        WHERE T3.DONID = A.V_VUANID AND
                                              UPPER(T3.TENDUONGSU) LIKE '%' || UPPER(V_NG_KC) || '%'
                                      ) ) );
 END HC_NHANDON;
 PROCEDURE AHC_PHUCTHAMQDK_THULY_GETMAXTT (
  VDONVIID  IN NUMBER,
  VFROMDATE IN DATE,
  VTODATE   IN DATE,
  CURRETURN OUT SYS_REFCURSOR
 ) IS
 BEGIN
  OPEN CURRETURN FOR SELECT NVL(MAX(D.TT),
                                0)
                                        FROM AHC_KCKNQDK_PHUCTHAM_THULY T
                                        INNER JOIN AHC_DON D ON D.ID = T.DONID
                     WHERE D.TOAANID = VDONVIID AND
                           T.NGAYTHULY BETWEEN VFROMDATE AND VTODATE;
 END AHC_PHUCTHAMQDK_THULY_GETMAXTT;


    --Lấy ra list HDXX tamnc 29-3
  PROCEDURE AHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
  VDONID    IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
 ) IS
  CHECKBANANPT NUMBER;
 BEGIN
  SELECT COUNT(ID)
  INTO CHECKBANANPT
  FROM AHC_PHUCTHAM_BANAN
  WHERE DONID = VDONID;
  OPEN CURRETURN FOR SELECT NVL(CHECKBANANPT, 0) CHECKBANANPT,
                            D.ID,
                            (
                                         CASE MAVAITRO
                                          WHEN 'THAMPHAN'         THEN 'Thẩm phán chủ tọa phiên tòa'
                                          WHEN 'THAMPHANHDXX'     THEN 'Thẩm phán thành viên hội đồng xét xử'
                                          WHEN 'THAMPHANDUKHUYET' THEN 'Thẩm phán dự khuyết'
                                          WHEN 'HTND'             THEN 'Hội thẩm nhân dân'
                                          WHEN 'THUKY'            THEN 'Thư ký'
                                          WHEN 'KSV'              THEN 'Kiểm sát viên'
                                         END
                                        )                    AS TENVAITRO,
                            CASE
                             WHEN D.MAVAITRO = 'KSV' THEN V.HOTEN
                             ELSE C.HOTEN
                            END                  AS TENNGUOITHTT,
                            D.NGAYTHAMGIA,
                            D.NGAYKETTHUC,
                            D.NGAYPHANCONG,
                            D.NGAYNHANPHANCONG,
                            D.NGUOITAO,
                            D.NGAYTAO,
                            E.HOTEN              AS NGUOIPHANCONG,
                            D.TOA_GIAIQUYET_ID
                                        FROM AHC_KCKNQDK_PHUCTHAM_HDXX D
                                        LEFT JOIN DM_CANBO                  C ON C.ID = D.CANBOID
                                        LEFT JOIN DM_CANBO                  E ON E.ID = D.NGUOIPHANCONGID
                                        LEFT JOIN DM_CANBOVKS               V ON V.ID = D.CANBOID
                     WHERE D.DONID = VDONID
                     ORDER BY D.HOTEN;
 END AHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST;

--Lấy ra list TGTT tamnc 29-3
 PROCEDURE AHC_PHUCTHAM_KCKN_TGTT_GETLIST (
  VDONID    IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
 ) IS
 BEGIN
  OPEN CURRETURN FOR SELECT D.ID,
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
                            ( SELECT LISTAGG(TENDUONGSU, '<br/>') WITHIN GROUP(
                                            ORDER BY ID) AS DESCRIPTION
                                            FROM AHC_DON_DUONGSU A
                                          WHERE D.DUONGSUID LIKE '%,' || A.ID || ',%'
                            )                                          TENDUONGSU,
                            D.TOA_GIAIQUYET_ID
                                        FROM AHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG D
                                        LEFT JOIN DM_DATAITEM                        I ON I.MA = D.TUCACHTGTTID
                                        LEFT JOIN DM_HANHCHINH                       H1 ON H1.ID = D.TAMTRUID
                                        LEFT JOIN DM_CANBO                           CB ON D.NGUOIPHANCONGID = CB.ID
                     WHERE D.DONID = VDONID
                     ORDER BY D.HOTEN;
 END AHC_PHUCTHAM_KCKN_TGTT_GETLIST;

    --Lấy ra list Quyết định tamnc 29-3
 PROCEDURE AHC_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
  VDONID    IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
 ) IS
 BEGIN
  OPEN CURRETURN FOR SELECT Q.ID,
                            Q.SOQD,
                            Q.NGAYQD,
                            Q.CHUCVU,
                            D.TEN || DECODE(Q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)',
                                            3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)', 5,
                                            ' (Không xác định hình thức xét xử)', '') AS TENQD,
                            C.HOTEN                                        AS NGUOIKY,
                            Q.HIEULUCTU,
                            Q.HIEULUCDEN,
                            LD.TEN                                         AS LYDO,
                            Q.NGAYTAO,
                            Q.NGUOITAO,
                            Q.FILEID,
                            Q.TENFILE,
                            Q.TOA_GIAIQUYET_ID
                                        FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH Q
                                        LEFT JOIN AHC_FILE                       F ON F.ID = Q.FILEID
                                        LEFT JOIN DM_QD_QUYETDINH_LYDO           LD ON LD.ID = Q.LYDOID
                                        INNER JOIN DM_QD_QUYETDINH                D ON D.ID = Q.QUYETDINHID AND
                                                                        ( D.ISHANHCHINH = 1 AND
                                                                          D.ISPHUCTHAM = 1 AND
                                                                          D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%' AND
                                                                          D.MA NOT IN ( '43-HC', '14-HC', '15-HC', '40-HC', '41-HC' ) )
     --thêm điều kiện not in 
                                        LEFT JOIN DM_CANBO                       C ON C.ID = Q.NGUOIKYID
                     WHERE Q.DONID = VDONID
                     ORDER BY Q.NGAYQD;
 END AHC_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST;


--Lấy ra list bản án tamnc 29-3
 PROCEDURE AHC_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
  VDONID    IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR
 ) IS
  COUNTBANANST INT;
 BEGIN
    --select count(ID) into CountBanAnST from AHC_PHUCTHAM_BANAN where DonID = vDONID;    
    --------------------------
  OPEN CURRETURN FOR SELECT Q.ID,
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
                            0       ISBANANST,
                            Q.TOA_GIAIQUYET_ID
                                        FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH Q
                                        LEFT JOIN AHC_FILE                       F ON Q.FILEID = F.ID
                                        LEFT JOIN DM_QD_QUYETDINH_LYDO           LD ON LD.ID = Q.LYDOID
                                        INNER JOIN DM_QD_QUYETDINH                D ON D.ID = Q.QUYETDINHID AND
                                                                        ( D.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) )
                                        LEFT JOIN DM_CANBO                       C ON C.ID = Q.NGUOIKYID
                                        LEFT JOIN DM_TOAAN                       T ON T.ID = Q.TOAANID
                     WHERE Q.DONID = VDONID OR
                           Q.DONID IN ( SELECT ID
                                                     FROM AHC_DON
                                        WHERE VUANGOCID = VDONID
                                      )
                     ORDER BY Q.NGAYQD;
 END AHC_PHUCTHAMQDK_BANANQUYETDINH_GETLIST;


 PROCEDURE SO_DK_KCKN_HC (
  V_DK_HC  OUT NUMBER,
  VTOAANID IN VARCHAR2,
  V_CXX    IN VARCHAR2
 ) AS
 BEGIN
  V_DK_HC := 0;
  IF ( V_CXX = 'PT_KCKN' ) THEN SELECT NVL(MAX(D.SO_DK),
                                           0)
                                                              INTO V_DK_HC
                                                              FROM AHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG D
                                                              LEFT JOIN AHC_DON_GIAIDOAN                   GD ON GD.DONID = D.DONID
                                WHERE EXTRACT(YEAR FROM TO_DATE(D.NGAY_DK, 'DD-MM-YYYY')) = EXTRACT(YEAR FROM TO_DATE(SYSDATE, 'DD-MM-YYYY')) AND
                                      D.SO_DK != 0 AND
                                      GD.TOAPHUCTHAMID = VTOAANID;
  END IF;
  V_DK_HC := V_DK_HC + 1;
 END;

    ---------------------------------- Lấy ra quyết định số 43 tamnc 31-3
 PROCEDURE AHC_DM_QUYETDINH_VUAN_PTQDK (
  CURRETURN OUT SYS_REFCURSOR
 ) AS
 BEGIN
  OPEN CURRETURN FOR SELECT TEN,
                            ID,
                            MA
                                        FROM DM_QD_QUYETDINH
                     WHERE ISPHUCTHAM = 1 AND
                           ISHANHCHINH = 1 AND
                           ( MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) )
                     ORDER BY
                      CASE
                       WHEN MA = '43-HC' THEN '1'
                       ELSE MA
                      END;
 END AHC_DM_QUYETDINH_VUAN_PTQDK;
 PROCEDURE UPDATE_NOIDUNG_CHUYENNHANAN (
  VNHANANID IN NUMBER,
  VNOIDUNG  IN VARCHAR2,
  V_VUANID  IN NUMBER
 ) AS
  V_EXPORT_TEXT CLOB;
 BEGIN
  FOR ITEMS IN ( SELECT
     /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/ T2.DONID,
                        T2.DUONGSUID,
                        '<b> - ' || DM.TEN || ': ' || T3.TENDUONGSU || '</b><br/> ' ||
                        LISTAGG('<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO, 'dd/MM/yyyy') || '<br/>' || DECODE(T2.LOAIKHANGCAO,
                                                                                                                           0,
                                                                                                                           '+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'),
                                                                                                                           '+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy'))
     --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                                                                                                                            || '<br/><div style="text-align:justify" >+ Nội dung: ' || T2.NOIDUNGKHANGCAO || '</div>',
                                ',') WITHIN GROUP(
                                                                                             ORDER BY T2.DONID,
                                                                                                      T2.DUONGSUID)
                                                                                            NOIDUNG
                                                                                            FROM AHC_SOTHAM_KHANGCAO T2
                                                                                            INNER JOIN AHC_DON_DUONGSU      T3 ON T2.DUONGSUID = T3.ID AND
                                                                                                                             ( T3.DONID = T2.DONID )
                                                                                            LEFT JOIN DM_DATAITEM          DM ON DM.MA = T3.TUCACHTOTUNG_MA
                                                                                            LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID = T2.SOQDBA AND
                                                                                                                                 T2.LOAIKHANGCAO IN ( 1, 2 )
     --> Kháng cáo quyết định --toancau-anhnt kc tđc
                                                                                            LEFT JOIN AHC_SOTHAM_BANAN     BA ON BA.ID = T2.SOQDBA AND
                                                                                                                             T2.LOAIKHANGCAO = 0
     --> Kháng cáo bản án
                                                                             WHERE T2.DONID = (
                                                                               CASE
                                                                                WHEN NOT EXISTS ( SELECT 'x'
                                                                                                                    FROM AHC_DON
                                                                                                  WHERE ID = V_VUANID AND
                                                                                                        AHC_DON.MAGIAIDOAN = 7
                                                                                                ) THEN V_VUANID
                                                                                ELSE ( SELECT VUANID
                                                                                               FROM AHC_CHUYEN_NHAN_AN
                                                                                        WHERE MAP_VUANID_NEW = V_VUANID AND
                                                                                              ROWNUM = 1
                                                                                      )
                                                                               END
                                                                              ) AND
                                                                                   ( T2.TINHTRANG_GIAIQUYET IS NULL OR
                                                                                     T2.TINHTRANG_GIAIQUYET = 0 )
                                                              GROUP BY T2.DONID,
                                                                       T2.DUONGSUID,
                                                                       T3.TENDUONGSU,
                                                                       DM.TEN
                                               UNION ALL
                                               SELECT
     /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENA ( kháng cáo).*/ T2.DONID,
                                                      T2.DUONGSUID,
                                                      '<b> - ' || DM.TEN || ': ' || T3.HOTEN || '</b><br/> ' ||
                                                      LISTAGG('<b>* Ngày kháng cáo:</b> ' || TO_CHAR(T2.NGAYKHANGCAO, 'dd/MM/yyyy') || '<br/>' || DECODE(T2.LOAIKHANGCAO,
                                                                                                                                                         0,
                                                                                                                                                         '+ Kháng cáo bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'),
                                                                                                                                                         '+ Kháng cáo quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy'))
      --toancau-anhnt thêm nvl(QD.SOQD,QD2.SOQD) kc tđc
                                                                                                                                                          || '<br/><div style="text-align:justify" >+ Nội dung: ' || T2.NOIDUNGKHANGCAO || '</div>',
                                                              ',') WITHIN GROUP(
                                                       ORDER BY T2.DONID,
                                                                T2.DUONGSUID)
                                                      NOIDUNG
                                               FROM AHC_SOTHAM_KHANGCAO T2
                                               INNER JOIN AHC_DON_THAMGIATOTUNG T3 ON T2.DUONGSUID = T3.ID AND
                                                                                      ( T3.DONID = T2.DONID )
                                               LEFT JOIN DM_DATAITEM           DM ON DM.MA = T3.TUCACHTGTTID
                                               LEFT JOIN AHC_SOTHAM_QUYETDINH  QD ON QD.ID = T2.SOQDBA AND
                                                                                    T2.LOAIKHANGCAO IN ( 1, 2 )
     --> Kháng cáo quyết định --toancau-anhnt kc tđc
                                               LEFT JOIN AHC_SOTHAM_BANAN      BA ON BA.ID = T2.SOQDBA AND
                                                                                T2.LOAIKHANGCAO = 0
     --> Kháng cáo bản án
                                WHERE T2.DONID = (
                                  CASE
                                   WHEN NOT EXISTS ( SELECT 'x'
                                                                       FROM AHC_DON
                                                     WHERE ID = V_VUANID AND
                                                           AHC_DON.MAGIAIDOAN = 7
                                                   ) THEN V_VUANID
                                   ELSE ( SELECT VUANID
                                                  FROM AHC_CHUYEN_NHAN_AN
                                           WHERE MAP_VUANID_NEW = V_VUANID AND
                                                 ROWNUM = 1
                                         )
                                  END
                                 ) AND
                                      ( T2.TINHTRANG_GIAIQUYET IS NULL OR
                                        T2.TINHTRANG_GIAIQUYET = 0 )
                 GROUP BY T2.DONID,
                          T2.DUONGSUID,
                          T3.HOTEN,
                          DM.TEN
               ) LOOP
   V_EXPORT_TEXT := TO_CLOB(V_EXPORT_TEXT || ITEMS.NOIDUNG);
  END LOOP;
  -- Tổng hợp kháng nghị
  FOR ITEMS IN ( SELECT
     /*GSCM.PKG_STPT_DS_BC.FILL_DS_CHUYENAN.(kháng nghị)*/ T2.DONID,
                        T2.TOAAN_VKS_KN,
                        T2.DONVIKN,
                        '<b> - ' || DECODE(T2.DONVIKN, 1, T4.TEN, T5.TEN) || '</b><br/>' ||
                        LISTAGG('<b>* Ngày kháng nghị: </b>' || TO_CHAR(T2.NGAYKN, 'dd/MM/yyyy') || '<br />' || DECODE(T2.LOAIKN,
                                                                                                                       0,
                                                                                                                       '+ Kháng nghị bản án số: ' || BA.SOBANAN || ', Ngày: ' || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy'),
                                                                                                                       '+ Kháng nghị quyết định số: ' || QD.SOQD || ', Ngày: ' || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy')) || '<br/>' || '+ Nội dung: ' || T2.NOIDUNGKN,
                                ',') WITHIN GROUP(
                                                ORDER BY T2.DONID,
                                                         T2.TOAAN_VKS_KN,
                                                         T2.DONVIKN)
                                               NOIDUNG
                                               FROM AHC_SOTHAM_KHANGNGHI T2
                                               LEFT JOIN DM_VKS               T4 ON T2.TOAAN_VKS_KN = T4.ID AND
                                                                      T2.DONVIKN = 1
     --> Viện trưởng Viện kiểm sát
                                               LEFT JOIN DM_TOAAN             T5 ON T2.TOAAN_VKS_KN = T5.ID AND
                                                                        T2.DONVIKN = 0
     --> Chánh án Tòa án
                                               LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID = T2.BANANID AND
                                                                                    T2.LOAIKN IN ( 1, 2 )
     --> Kháng cáo quyết định
                                               LEFT JOIN AHC_SOTHAM_BANAN     BA ON BA.ID = T2.BANANID AND
                                                                                T2.LOAIKN = 0
     --> Kháng cáo bản án
                                               LEFT JOIN AHC_SOTHAM_RUTKCKN   RUT ON T2.ID = RUT.IDKCKN
                                WHERE T2.DONID = (
                                  CASE
                                   WHEN NOT EXISTS ( SELECT 'x'
                                                                       FROM AHC_DON
                                                     WHERE ID = V_VUANID AND
                                                           AHC_DON.MAGIAIDOAN = 7
                                                   ) THEN V_VUANID
                                   ELSE ( SELECT VUANID
                                                  FROM AHC_CHUYEN_NHAN_AN
                                           WHERE MAP_VUANID_NEW = V_VUANID AND
                                                 ROWNUM = 1
                                         )
                                  END
                                 ) AND
                                      ( T2.TINHTRANG_GIAIQUYET IS NULL OR
                                        T2.TINHTRANG_GIAIQUYET = 0 )
                 GROUP BY T2.DONID,
                          T2.TOAAN_VKS_KN,
                          T2.DONVIKN,
                          T4.TEN,
                          T5.TEN
               ) LOOP
   V_EXPORT_TEXT := TO_CLOB(V_EXPORT_TEXT || '<br/>' || ITEMS.NOIDUNG);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(V_EXPORT_TEXT);
  UPDATE AHC_CHUYEN_NHAN_AN
  SET NOIDUNG = V_EXPORT_TEXT,
      LYDOCHUYEN = VNOIDUNG
  WHERE ID = VNHANANID;
 END;
 PROCEDURE COUNT_KCKN_TDC (
  VDONID IN NUMBER,
  VOUT   OUT NUMBER
 ) AS
  LCOUNTKC NUMBER;
  LCOUNTKN NUMBER;
 BEGIN
  SELECT COUNT(KC.ID)
  INTO LCOUNTKC
  FROM AHC_SOTHAM_KHANGCAO  KC
  LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID = KC.SOQDBA
  LEFT JOIN DM_QD_QUYETDINH      DM ON DM.ID = QD.QUYETDINHID
  WHERE KC.LOAIKHANGCAO = 2 AND
        NVL(KC.TINHTRANG_GIAIQUYET, 0) = 0 AND
        DM.MA IN ( '10-HC', '11-HC' ) AND
        KC.DONID = VDONID;
  SELECT COUNT(KN.ID)
  INTO LCOUNTKN
  FROM AHC_SOTHAM_KHANGNGHI KN
  LEFT JOIN AHC_SOTHAM_QUYETDINH QD ON QD.ID = KN.BANANID
  LEFT JOIN DM_QD_QUYETDINH      DM ON DM.ID = QD.QUYETDINHID
  WHERE KN.LOAIKN = 2 AND
        NVL(KN.TINHTRANG_GIAIQUYET, 0) = 0 AND
        DM.MA IN ( '10-HC', '11-HC' ) AND
        KN.DONID = VDONID;
  VOUT := NVL(LCOUNTKC, 0) + NVL(LCOUNTKN, 0);
 END;
    --toancau-linhnd


   --toancau-tamnc 
 FUNCTION NOIDUNG_KHANGCAO_DANHSACH (
  V_DONID NUMBER
 ) RETURN CLOB AS
  L_NOIDUNG_KC   CLOB;
  L_NGAYKHANGCAO CLOB;
 BEGIN
  BEGIN
   L_NOIDUNG_KC := '';
   FOR R_DS IN ( SELECT DS.ID,
                        DS.DONID,
                        DS.TENDUONGSU || '-' || I.TEN TENDUONGSU
                               FROM AHC_DON_DUONGSU DS
                               LEFT JOIN DM_DATAITEM     I ON I.MA = DS.TUCACHTOTUNG_MA
                 WHERE DS.DONID = V_DONID AND
                       EXISTS ( SELECT 'X'
                                         FROM AHC_SOTHAM_KHANGCAO
                                WHERE DUONGSUID = DS.ID
                              )
               ) LOOP
    L_NGAYKHANGCAO := '';
    FOR R_KC IN ( SELECT KC.*
                                FROM AHC_SOTHAM_KHANGCAO KC
                  WHERE KC.DUONGSUID = R_DS.ID AND
                        KC.DONID = V_DONID
                ) LOOP
     L_NGAYKHANGCAO := L_NGAYKHANGCAO || '<br/> - Ngày kháng cáo: ' || TO_CHAR(R_KC.NGAYKHANGCAO, 'dd/MM/yyyy');
    END LOOP;
    L_NOIDUNG_KC := L_NOIDUNG_KC || '<br/>' || R_DS.TENDUONGSU || L_NGAYKHANGCAO;
   END LOOP;
   RETURN '<br /><i>Kháng cáo: </i>' || L_NOIDUNG_KC;
  EXCEPTION
   WHEN NO_DATA_FOUND THEN RETURN '';
  END;
 END NOIDUNG_KHANGCAO_DANHSACH;
 
 PROCEDURE DON_SEARCH_V2 (
  V_CAP_XET_XU_LOGIN    IN VARCHAR2,
  V_TEN_VU_AN           IN VARCHAR2,
  V_QHPL                IN VARCHAR2,
  V_MA_VU_AN            IN VARCHAR2,
  V_TENDUONGSU          IN VARCHAR2,
  V_CAPXX               IN VARCHAR2,
  V_TOAAN_ID            IN VARCHAR2,
  V_TINHTRANG_THULY     IN VARCHAR2,
  V_NGAYTHULY_TU        IN VARCHAR2,
  V_NGAYTHULY_DEN       IN VARCHAR2,
  V_SOTHULY             IN VARCHAR2,
  V_THAMPHAN_ID         IN VARCHAR2,
  V_TINHTRANG_GIAIQUYET IN VARCHAR2,
  V_TUNGAY              IN VARCHAR2,
  V_DENNGAY             IN VARCHAR2,
  V_KETQUA              IN VARCHAR2,
  V_SO_QD               IN VARCHAR2,
  V_NGAY_QD             IN VARCHAR2,
  V_THUKY_ID            IN VARCHAR2,
  V_THOIHAN_GQ          IN VARCHAR2,
  V_LOAIDON             IN VARCHAR2,
  V_PT_RKINHNGHIEM      IN VARCHAR2,
  V_GQDON               IN VARCHAR2,
  V_UTTP                IN VARCHAR2,
  VCHECKTK              IN NUMBER,
  V_TRANGTHAIVUAN       IN NUMBER,
  V_VAITRO_THAMPHAN     IN VARCHAR2,
 V_CHECK_HOAGIAI        IN NUMBER,
    V_HOAGIAI_TRANGTHAI IN NUMBER DEFAULT NULL,
    V_HOAGIAI_TUNGAY IN VARCHAR2 DEFAULT NULL,
    V_HOAGIAI_DENNGAY IN VARCHAR2 DEFAULT NULL,
  PAGE_INDEX            IN INT,
  PAGE_SIZE             IN INT,
  CURRETURN             OUT SYS_REFCURSOR
 ) IS
  TOTALITEM        NUMBER;
  MININDEX         NUMBER;
  MAXINDEX         NUMBER;
  VV_TUNGAY        DATE;
  VV_DENNGAY       DATE;
  VV_NGAYTHULY_TU  DATE;
  VV_NGAYTHULY_DEN DATE;
  V_TABLE_TLPT     T_QUYETDINH_EXT;
  V_TABLE_HDXX_PT  T_QUYETDINH_EXT;
  V_TABLE_PT       T_QUYETDINH_EXT;
  V_TABLE_BC       T_BICANBICAO_EXT;
  V_TABLE_BC_KC    T_BICANBICAO_EXT;
  V_TABLE_THAMPHAN T_THAMPHAN_EXT;
    --TOANCAU-03102023-ANHNT
 BEGIN
  V_TABLE_TLPT := T_QUYETDINH_EXT();
  V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
  V_TABLE_PT := T_QUYETDINH_EXT();
  V_TABLE_BC := T_BICANBICAO_EXT();
  V_TABLE_BC_KC := T_BICANBICAO_EXT();
  V_TABLE_THAMPHAN := T_THAMPHAN_EXT();
    --TOANCAU-03102023-ANHNT
    ---------------------------------------
  MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
  MAXINDEX := PAGE_INDEX * PAGE_SIZE;
    ----------
  IF ( V_NGAYTHULY_TU IS NOT NULL ) THEN VV_NGAYTHULY_TU := TO_DATE ( TRIM(V_NGAYTHULY_TU) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;
  IF ( V_NGAYTHULY_DEN IS NOT NULL ) THEN VV_NGAYTHULY_DEN := TO_DATE ( TRIM(V_NGAYTHULY_DEN) || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;  
     --
  IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;
  IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS' );
  END IF;  
   ------------------------
   ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --THAMPHAN --TOANCAU-03102023-ANHNT
  SELECT R_THAMPHAN_EXT(TP.DONID, TP.ID, TP.CANBOID, TP.MAVAITRO, TP.MAGIAIDOAN,
                        TP.NGAYPHANCONG)
  BULK COLLECT
  INTO V_TABLE_THAMPHAN
  FROM ( SELECT MAVAITRO,
                DONID,
                ID,
                CANBOID,
                ROW_NUMBER()
                OVER(PARTITION BY DONID, MAVAITRO
                     ORDER BY NGAYPHANCONG DESC
                ) ROWNUMBER,
                NGAYPHANCONG,
                (
                               CASE
                                WHEN MAVAITRO IN ( 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETDON' ) THEN 2
                                WHEN MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' THEN 7
                               END
                              ) MAGIAIDOAN
                              FROM AHC_DON_THAMPHAN
                       WHERE MAVAITRO IN ( 'VTTP_GIAIQUYETDON', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' )
                UNION
                SELECT CAST(MAVAITRO AS NVARCHAR2(20)) MAVAITRO,
                       DONID,
                       ID,
                       CANBOID,
                       ROW_NUMBER()
                       OVER(PARTITION BY DONID, MAVAITRO
                            ORDER BY NGAYPHANCONG DESC
                       )                               ROWNUMBER,
                       NGAYPHANCONG,
                       7                               MAGIAIDOAN
                FROM AHC_KCKNQDK_PHUCTHAM_HDXX
         WHERE MAVAITRO IN ( 'THAMPHAN', 'THAMPHANHDXX', 'THAMPHANDUKHUYET' )
       ) TP
  WHERE ( ( TP.ROWNUMBER = 1 AND
            TP.MAVAITRO IN ( 'VTTP_GIAIQUYETDON', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM', 'THAMPHAN', 'THAMPHANHDXX' ) OR
            TP.MAVAITRO = 'THAMPHANDUKHUYET' ) );
		--THAMPHAN --TOANCAU-03102023-ANHNT
         --AHC_KCKNQDK_PHUCTHAM_QUYETDINH
  SELECT R_QUYETDINH_EXT(TTS.DONID, TTS.ID, TTS.MA)
  BULK COLLECT
  INTO V_TABLE_PT
  FROM ( SELECT TT.DONID,
                TT.ID,
                TT.MA
                FROM ( SELECT PQD.DONID,
                              FIRST_VALUE(PQD.ID)
                              OVER(PARTITION BY PQD.DONID, QDL.MA
                                   ORDER BY PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                              ) ID,
                              QDL.MA
                       FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PQD
                       LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PQD.QUYETDINHID
                       LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                     ) TT
         GROUP BY TT.DONID,
                  TT.ID,
                  TT.MA
       ) TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
  SELECT R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
  BULK COLLECT
  INTO V_TABLE_BC
  FROM ( SELECT BC.ID,
                BC.DONID,
                BC.TENDUONGSU,
                BC.TUCACHTOTUNG_MA,
                BC.ROWNUMBER
                FROM ( SELECT ID,
                              DONID,
                              TENDUONGSU,
                              TUCACHTOTUNG_MA,
                              ROW_NUMBER()
                              OVER(PARTITION BY DONID
                                   ORDER BY ISDAIDIEN DESC, TENDUONGSU
                              ) ROWNUMBER
                              FROM AHC_DON_DUONGSU
                       WHERE ISDAIDIEN = 0
                     ) BC
         WHERE BC.ROWNUMBER <= 3
       ) TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
  SELECT R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.TENDUONGSU, TTS.TUCACHTOTUNG_MA, TTS.ROWNUMBER)
  BULK COLLECT
  INTO V_TABLE_BC_KC
  FROM ( SELECT BC.ID,
                BC.DONID,
                BC.TENDUONGSU,
                BC.TUCACHTOTUNG_MA,
                BC.ROWNUMBER
                FROM ( SELECT DS.ID,
                              DS.DONID,
                              DS.TENDUONGSU,
                              DS.TUCACHTOTUNG_MA,
                              ROW_NUMBER()
                              OVER(PARTITION BY DS.DONID
                                   ORDER BY DS.ISDAIDIEN DESC, DS.TENDUONGSU
                              ) ROWNUMBER
                              FROM AHC_DON_DUONGSU DS
                       WHERE EXISTS ( SELECT 'X'
                                                     FROM AHC_SOTHAM_KHANGCAO KC
                                      WHERE KC.DUONGSUID = DS.ID AND
                                            KC.DONID = DS.DONID
                                    )
                     ) BC
         WHERE BC.ROWNUMBER <= 3
       ) TTS;             
   -----------------------
  OPEN CURRETURN FOR SELECT TT.*
                                        FROM ( SELECT ROW_NUMBER()
                                                      OVER(
                                                       ORDER BY A.NGAYTAO DESC
                                                      )                                                                                STT,
                                                      COUNT(*)
                                                      OVER()                                                                           AS COUNTALL,
                                                      A.ID,
                                                      A.MAVUVIEC,
                                                      A.TENVUVIEC,
                                                      A.SOTHUTU,
                                                      A.NGAYNHANDON,
                                                      A.NGUOITAO,
                                                      TO_CHAR(A.NGAYTAO, 'dd/MM/yyyy') || '<br/>' || TO_CHAR(A.NGAYTAO, ' HH24:MI:SS') NGAYTAO,
                                                      I.TEN                                                                            AS QUANHEPL,
                                                      '</br><i>Tòa xét xử sơ thẩm: </i><b>' || NVL(TST.TEN, T.TEN) || '</b>'           TENTOASOTHAM,
                                                      'Phúc thẩm'                                                                      GIAIDOANVUVIEC,
--      GN.TRUONGHOPGIAONHAN,
                                                      A.HINHTHUCNHANDON,
                                                      DECODE(A.HINHTHUCNHANDON, 1, '<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>', 270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                                             '<br/><i>TH giao nhận:</i> <b>' || GN.TRUONGHOPGIAONHAN || '</b>')        TRUONGHOPGIAONHAN,
                                                      STBA.BANAN_QD_ST,
                                                      STKN.KHANGNGHI_ST,
                                                      STKC.KHANGCAO_ST,
                                                      PTQD.QD_PT,
                                                      A.MAGIAIDOAN,
                                                      ( BC3.HOTEN )                                                                    HOTENBICAN,
                                                      DECODE(XLD.LOAIGIAIQUYET,
                                                             1,
                                                             '- Đã chuyển đơn',
                                                             CASE
                                                              WHEN(TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý'
                                                              ELSE(TLPT.TINHTRANG_GQ)
                                                             END
                                                             ||
                                                             CASE
                                                              WHEN(TPPCPT.TINHTRANG_GQ) IS NULL AND
                                                                  (TLPT.TINHTRANG_GQ) IS NOT NULL THEN '</br>- Chưa phân công Thẩm phán'
                                                              ELSE(TPPCPT.TINHTRANG_GQ)
                                                             END
                                                             || HPTPT.TINHTRANG_GQ || TDCPT.TINHTRANG_GQ || DCPT.TINHTRANG_GQ || CPT.TINHTRANG_GQ || GNST.TINHTRANG_GQ ||
     --hieu thêm thông tin giải quyết của vụ án cha
                                                             CASE
                                                              WHEN(A.VUANGOCID > 0 AND
                                                                   A.IS_TACHAN IS NULL) THEN(SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> ' || TO_CHAR(T.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T.NGAYTHULY, 'dd/MM/yyyy')
                                                                                                                   FROM AHC_DON          D
                                                                                                                   LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                         WHERE D.ID = A.VUANGOCID
                                                                                             )
                                                              WHEN(A.VUANGOCID > 0 AND
                                                                   A.IS_TACHAN = 1) THEN(SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ' || TO_CHAR(T.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T.NGAYTHULY, 'dd/MM/yyyy')
                                                                                                           FROM AHC_DON          D
                                                                                                           LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                     WHERE D.ID = A.VUANGOCID
                                                                                         )
                                                             END
                                                      )                                                                                TINHTRANG_GQ,
                                                      ( TLPT.TINHTRANG_GQ )                                                            CHECK_THULY,
                                                      0                                                                                THULYXXLAI
                                                      FROM AHC_DON            A
                                                      LEFT JOIN DM_DATAITEM        I ON A.QUANHEPHAPLUATID = I.ID
                                                      LEFT JOIN DM_TOAAN           T ON A.TOAANID = T.ID
                                                      LEFT JOIN AHC_CHUYEN_NHAN_AN NA ON NA.MAP_VUANID_NEW = A.ID
                                                      LEFT JOIN DM_TOAAN           TST ON NA.TOACHUYENID = TST.ID
      ----- BA Or QD----------------------------------------------
                                                      LEFT JOIN ( SELECT PTQDVA.*
                                                                              FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                              LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                              LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                  WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                                )                  QD ON QD.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQD.DONID,
                                                                         '<br /><i>QĐ GQ PT: </i><b>' || 'Số ' || PTQD.SOQD || ' ngày ' || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy') || '</b>' QD_PT
                                                                              FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQD
                                                                  WHERE QUYETDINHID = 213
                                                                )                  PTQD ON PTQD.DONID = A.ID  
         --- Lay ra trang thai giai quyet don
                                                      LEFT JOIN ( SELECT DONID,
                                                                         LOAIGIAIQUYET,
                                                                         NGAYGQ_YC
                                                                              FROM AHC_DON_XULY
                                                                  WHERE LOAIGIAIQUYET IN ( 1, 5 )
                                                                )                  XLD ON A.ID = XLD.DONID
                                                      LEFT JOIN ( SELECT T2.DONID,
                                                                         T2.NGAYTHULY,
                                                                         T2.SOTHULY,
                                                                         T2.TRUONGHOPTHULY,
                                                                         '</br>- Thụ lý số:<b> ' || TO_CHAR(T2.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy') || '</b>' TINHTRANG_GQ
                                                                              FROM AHC_KCKNQDK_PHUCTHAM_THULY T2
                                                                  WHERE EXISTS ( SELECT 'X'
                                                                                                FROM ( SELECT TT.DONID,
                                                                                                              TT.ID
                                                                                                              FROM ( SELECT DONID,
                                                                                                                            FIRST_VALUE(ID)
                                                                                                                            OVER(PARTITION BY DONID
                                                                                                                                 ORDER BY NGAYTHULY DESC, NGAYTAO DESC
                                                                                                                            ) ID
                                                                                                                     FROM AHC_KCKNQDK_PHUCTHAM_THULY
                                                                                                                   ) TT
                                                                                                       GROUP BY TT.DONID,
                                                                                                                TT.ID
                                                                                                     ) QDL
                                                                                 WHERE QDL.ID = T2.ID
                                                                               )
    --> Lấy thụ lý mới nhất
                                                                )                  TLPT ON TLPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT TP.DONID,
                                                                         '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                                                                                          FROM AHC_DON_THAMPHAN TP
                                                                                          LEFT JOIN ( SELECT TT.DONID,
                                                                                                             TT.ID
                                                                                                                  FROM ( SELECT DONID,
                                                                                                                                FIRST_VALUE(CANBOID)
                                                                                                                                OVER(PARTITION BY DONID
                                                                                                                                     ORDER BY NGAYTAO DESC
                                                                                                                                ) ID
                                                                                                                                FROM AHC_KCKNQDK_PHUCTHAM_HDXX
                                                                                                                         WHERE MAVAITRO = 'THAMPHAN'
                                                                                                                       ) TT
                                                                                                      GROUP BY TT.DONID,
                                                                                                               TT.ID
                                                                                                    )                HD ON HD.DONID = TP.DONID
                                                                                          LEFT JOIN ( SELECT GG.*
                                                                                                                  FROM AHC_DON_THAMPHAN GG
                                                                                                      WHERE EXISTS ( SELECT 'X'
                                                                                                                                    FROM ( SELECT TT.DONID,
                                                                                                                                                  TT.ID
                                                                                                                                                  FROM ( SELECT DONID,
                                                                                                                                                                FIRST_VALUE(ID)
                                                                                                                                                                OVER(PARTITION BY DONID
                                                                                                                                                                     ORDER BY NGAYNHANPHANCONG DESC
                                                                                                                                                                ) ID
                                                                                                                                                         FROM AHC_DON_THAMPHAN
                                                                                                                                                       ) TT
                                                                                                                                           GROUP BY TT.DONID,
                                                                                                                                                    TT.ID
                                                                                                                                         ) TP
                                                                                                                     WHERE TP.ID = GG.ID
                                                                                                                   )
                                                                                                    )                PCTP_GQ ON PCTP_GQ.DONID = TP.DONID
    --lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                                                                          LEFT JOIN DM_CANBO         CBB ON CBB.ID = HD.ID
                                                                                          LEFT JOIN DM_CANBO         CB ON CB.ID = PCTP_GQ.CANBOID
                                                                              WHERE TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                                  GROUP BY TP.DONID,
                                                                           '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>'
                                                                )                  TPPCPT ON TPPCPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ HPT số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',HPT,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ HPT số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  HPTPT ON HPTPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ TĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',TDC,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ TĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  TDCPT ON TDCPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ ĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ ĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  DCPT ON DCPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT PTQDVA.DONID,
                                                                         '</br>- QĐ CVA số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                          FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                              WHERE EXISTS ( SELECT 'X'
                                                                                                            FROM TABLE ( V_TABLE_PT ) QDL
                                                                                             WHERE QDL.ID = PTQDVA.ID AND
                                                                                                   INSTR(',CVA,', ',' || QDL.MA || ',') > 0
                                                                                           )
                                                                  GROUP BY PTQDVA.DONID,
                                                                           '</br>- QĐ CVA số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                                )                  CPT ON CPT.DONID = A.ID
                                                      LEFT JOIN ( SELECT CA.VUANID,
                                             -- '</br>- '
                                              --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                                                         '</br>- Đã chuyển vụ án' TINHTRANG_GQ
                                                                              FROM AHC_CHUYEN_NHAN_AN CA
                                                                              INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                                                  WHERE CA.TOACHUYENID = V_TOAAN_ID
                                                                )                  GNST ON GNST.VUANID = A.ID
                                                      LEFT JOIN ( SELECT CA.MAP_VUANID_NEW,
                                                                         I.TEN TRUONGHOPGIAONHAN
                                                                                          FROM DM_DATAITEM I
                                                                                          INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                                                              WHERE CA.TOANHANID = V_TOAAN_ID
                                                                  GROUP BY CA.MAP_VUANID_NEW,
                                                                           I.TEN
                                                                )                  GN ON GN.MAP_VUANID_NEW = A.ID
             ------bị cáo kháng cáo lấy cho phúc thẩm    
                                                      LEFT JOIN ( SELECT BC.DONID,
                                                                         '<br /><i>Người kháng cáo:</i> <br />' ||
                                                                         LISTAGG(BC.TENDUONGSU || ' ' || DECODE(BC.TUCACHTOTUNG_MA, 'NGUYENDON', '(Người khởi kiện)', 'BIDON', '(Người bị kiện)',
                                                                                                                'QUYENNVLQ', '(Người có quyền và NVLQ)', ' (' || BC.TUCACHTOTUNG_MA || ')'),
                                                                                 '<br/>') WITHIN GROUP(
                                                                               ORDER BY BC.ROWNUMBER)
                                                                              HOTEN
                                                                              FROM TABLE ( V_TABLE_BC_KC ) BC
                                                                  GROUP BY BC.DONID
                                                                )                  BC3 ON BC3.DONID = A.ID


        ----- lấy thông tin BA/sơ thẩm                
                                                      LEFT JOIN ( SELECT BA.DONID,
                                                                         '<br />BA/QĐ sơ thẩm: <b>' || 'Số ' || BA.SOBANAN || ' ngày ' || TO_CHAR(BA.NGAYTUYENAN, 'dd/MM/yyyy') || '</b>' BANAN_QD_ST
                                                                  FROM AHC_SOTHAM_BANAN BA
                                                                )                  STBA ON STBA.DONID = NA.VUANID           

        ------- lấy thông tin số ngày kháng nghị
                                                      LEFT JOIN ( SELECT KN.DONID,
                                                                         '<br /><i>Kháng nghị:</i> <br />' ||
                                                                         LISTAGG('Số ' || KN.SOKN || ' ngày ' || TO_CHAR(KN.NGAYKN, 'dd/MM/yyyy'),
                                                                                 '<br/>') WITHIN GROUP(
                                                                                           ORDER BY KN.NGAYKN)
                                                                                          KHANGNGHI_ST
                                                                                          FROM AHC_SOTHAM_KHANGNGHI KN
                                                                              WHERE KN.TINHTRANG_GIAIQUYET != 3 AND
                                                                                    KN.LOAIKN = 2
                                                                  GROUP BY KN.DONID
                                                                )                  STKN ON STKN.DONID = NA.VUANID 

------ - lấy thông tin số ngày kháng cáo + đương sự toancau
                                                      LEFT JOIN ( SELECT DSKC.DONID,
                                                                         '<br /><i>Kháng cáo: </i> <br />' || ' Tên đương sự: ' || DSKC.TENDUONGSU || '<br/>' ||
                                                                         LISTAGG(' - Ngày kháng cáo: ' || TO_CHAR(DSKC.NGAYKHANGCAO, 'dd/MM/yyyy'),
                                                                                 '<br/>') WITHIN GROUP(
                                                                               ORDER BY DSKC.TENDUONGSU)
                                                                              KHANGCAO_ST
                                                                              FROM ( SELECT DS.DONID,
                                                                                            DS.TENDUONGSU || '-' || I.TEN TENDUONGSU,
                                                                                            KC.NGAYKHANGCAO,
                                                                                            KC.ID
                                                                                            FROM AHC_SOTHAM_KHANGCAO KC
                                                                                            INNER JOIN AHC_DON_DUONGSU DS ON KC.DUONGSUID = DS.ID
                                                                                            LEFT JOIN DM_DATAITEM     I ON I.MA = DS.TUCACHTOTUNG_MA
                                                                                     WHERE KC.TINHTRANG_GIAIQUYET != 2
                                                                                   ) DSKC
                                                                  GROUP BY DSKC.DONID,
                                                                           DSKC.TENDUONGSU
                                                                )                  STKC ON STKC.DONID = NA.VUANID 


        ---------------------                
                                               WHERE A.TOAPHUCTHAMID = V_TOAAN_ID AND
                                                     A.MAGIAIDOAN = 7 AND
                                                     ( V_TEN_VU_AN IS NULL OR
                                                       ( LOWER(A.TENVUVIEC) LIKE '%' || LOWER(V_TEN_VU_AN) || '%' ) )
    --Tên vụ án
                                                        AND
                                                     ( V_UTTP IS NULL OR
                                                       ( V_UTTP IS NOT NULL AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_THULY TLPT
                                                                    WHERE TLPT.UTTPDI = TO_NUMBER(V_UTTP) AND
                                                                          TLPT.DONID = A.ID
                                                                  ) ) ) ) AND
                                                     ( V_QHPL IS NULL OR
                                                       ( LOWER(A.TENVUVIEC) LIKE '%' || LOWER(V_QHPL) || '%' ) )
    --Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                                                        AND
                                                     ( V_MA_VU_AN IS NULL OR
                                                       ( LOWER(A.MAVUVIEC) LIKE LOWER(V_MA_VU_AN) ) )
       --Mã vụ án
                                                        AND
                                                     ( V_TENDUONGSU IS NULL
     --Đương sự
                                                      OR
                                                       ( EXISTS ( SELECT 'X'
                                                                             FROM AHC_DON_DUONGSU DS
                                                                  WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%' || FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU)) || '%' AND
                                                                        DS.DONID = A.ID
                                                                ) ) )
                        -----------------------------check hoa giải
--                                        AND (NVL(V_CHECK_HOAGIAI,0) = 0 OR 
--                                            D.HOAGIAI_TRANGTHAI > 0)
           -----   
           --26/06/2023 tuyennh them tim kiem theo ten tham phan--                               
                                                                 AND
                                                     ( V_THAMPHAN_ID IS NULL
                                                     --TOANCAU-03102023-ANHNT
                                                      OR
                                                       ( V_VAITRO_THAMPHAN IS NULL AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.CANBOID = V_THAMPHAN_ID AND
                                                                        TP.MAGIAIDOAN = A.MAGIAIDOAN
                                                                ) ) OR
                                                       ( V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC' AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.MAVAITRO IN ( 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' ) AND
                                                                        TP.CANBOID = V_THAMPHAN_ID
                                                                ) ) OR
                                                       ( V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA' AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.MAVAITRO IN ( 'THAMPHAN', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' ) AND
                                                                        TP.CANBOID = V_THAMPHAN_ID AND
                                                                        TP.MAGIAIDOAN = A.MAGIAIDOAN
                                                                ) ) OR
                                                       ( V_VAITRO_THAMPHAN IN ( 'VTTP_GIAIQUYETDON', 'THAMPHANHDXX', 'THAMPHANDUKHUYET' ) AND
                                                         EXISTS ( SELECT 'X'
                                                                           FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                                  WHERE TP.DONID = A.ID AND
                                                                        TP.MAVAITRO = V_VAITRO_THAMPHAN AND
                                                                        TP.CANBOID = V_THAMPHAN_ID AND
                                                                        TP.MAGIAIDOAN = A.MAGIAIDOAN
                                                                ) ) )
           --TOANCAU-03102023-ANHNT
                --26/06/2023 tuyennh them tim kiem theo ten tham phan-- 
                                                                 AND
                                                     ( ( V_TINHTRANG_THULY IS NULL AND
                                                         ( V_NGAYTHULY_TU IS NULL OR
                                                           A.NGAYTAO >= VV_NGAYTHULY_TU ) AND
                                                         ( V_NGAYTHULY_DEN IS NULL OR
                                                           A.NGAYTAO <= VV_NGAYTHULY_DEN ) )
    --Tình trạng thụ lý
                                                            OR
                                                       ( V_TINHTRANG_THULY = 1 AND
                                                         ( ( ( TLPT.DONID IS NOT NULL AND
                                                               ( V_NGAYTHULY_TU IS NULL OR
                                                                 TLPT.NGAYTHULY >= VV_NGAYTHULY_TU ) AND
                                                               ( V_NGAYTHULY_DEN IS NULL OR
                                                                 TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) ) ) ) OR
                                                         ( V_TINHTRANG_THULY = 2 AND
                                                           ( TLPT.DONID IS NULL ) AND
                                                           ( V_NGAYTHULY_TU IS NULL OR
                                                             A.NGAYTAO >= VV_NGAYTHULY_TU ) AND
                                                           ( V_NGAYTHULY_DEN IS NULL OR
                                                             A.NGAYTAO <= VV_NGAYTHULY_DEN ) ) )
         -----
                                                              AND
                                                       ( V_SOTHULY IS NULL OR
                                                         ( UPPER(TLPT.SOTHULY) = UPPER(V_SOTHULY) ) )
    --Số Thụ lý
         -----
                                        --    AND ( V_THAMPHAN_ID IS NULL
                                        --          OR ( EXISTS (
                                        --  SELECT
                                        --      'x'
                                        --  FROM
                                        --      AHC_DON_THAMPHAN PC
                                       --   WHERE
                                       --           PC.CANBOID = V_THAMPHAN_ID
                                       --       AND PC.DONID = A.ID
                                     -- ) )--Thẩm phán
                                     --  )
            --GQ đơn;V_GQDON -- -- 
                                                          AND
                                                       ( V_GQDON IS NULL OR
                                                         ( ( V_GQDON = 1 OR
                                                             V_GQDON = 3 OR
                                                             V_GQDON = 4 OR
                                                             V_GQDON = 5 ) AND
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_DON_XULY XL
                                                                    WHERE XL.LOAIGIAIQUYET = V_GQDON AND
                                                                          XL.DONID = A.ID
                                                                  ) ) OR
                                                         ( V_GQDON = 6 AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_XULY XL
                                                                        WHERE XL.DONID = A.ID
                                                                      ) ) OR
                                                         ( V_GQDON = 7 AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_XULY XL
                                                                        WHERE XL.DONID = A.ID
                                                                      ) AND
                                                           ( SYSDATE - A.NGAYNHANDON ) > 15 ) OR
                                                         ( V_GQDON = 8 AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_XULY XL
                                                                        WHERE XL.DONID = A.ID
                                                                      ) AND
                                                           NOT EXISTS ( SELECT 'X'
                                                                                     FROM AHC_DON_THAMPHAN TP
                                                                        WHERE TP.DONID = A.ID
                                                                      ) ) ) AND
                                                       ( V_THUKY_ID IS NULL
    --Thư ký
                                                        OR
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_HDXX TP
                                                                    WHERE TP.CANBOID = V_THUKY_ID AND
                                                                          TP.DONID = A.ID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_DON_THAMPHAN TP
                                                                    WHERE TP.THUKYID = V_THUKY_ID AND
                                                                          TP.DONID = A.ID
                                                                  ) ) ) AND
                                                       ( VCHECKTK = 0 OR
                                                         ( SELECT COUNT(*)
                                                             FROM AHC_DON_THAMPHAN TP
                                                           WHERE TP.DONID = A.ID AND
                                                                 TP.THUKYID = VCHECKTK AND
                                                                 TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                         ) > 0 ) 
               --hieu check theo trạng thái vụ án hành chính        
                                                          AND
                                                       ( ( V_TRANGTHAIVUAN = 0 AND
                                                           ( A.VUANGOCID = 0 OR
                                                             A.VUANGOCID IS NULL ) ) OR
                                                         ( V_TRANGTHAIVUAN = 1 AND
                                                           A.VUANGOCID > 0 AND
                                                           A.IS_TACHAN IS NULL ) OR
                                                         ( V_TRANGTHAIVUAN = 2 AND
                                                           A.VUANGOCID > 0 AND
                                                           A.IS_TACHAN = 1 ) ) 
            ------Loại đơn 
                                                            AND
                                                       ( V_LOAIDON IS NULL OR
                                                         ( A.LOAIDON = V_LOAIDON ) )    
           --------------
                                                          AND
                                                       ( V_SO_QD IS NULL
    --Số BA/QĐ
                                                        OR
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_SOTHAM_BANAN QSV
                                                                    WHERE UPPER(QSV.SOBANAN) LIKE '%' || V_SO_QD || '%' AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_SOTHAM_QUYETDINH QSV
                                                                    WHERE UPPER(QSV.SOQD) LIKE '%' || V_SO_QD || '%' AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                    WHERE UPPER(QSV.SOQD) LIKE '%' || V_SO_QD || '%' AND
                                                                          A.ID = QSV.DONID
                                                                  ) ) ) AND
                                                       ( V_NGAY_QD IS NULL
    --Ngày BA/QĐ
                                                        OR
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_SOTHAM_BANAN QSV
                                                                    WHERE TO_CHAR(QSV.NGAYMOPHIENTOA, 'dd/MM/yyyy') = V_NGAY_QD AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_SOTHAM_QUYETDINH QSV
                                                                    WHERE TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD AND
                                                                          NA.VUANID = QSV.DONID
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                    WHERE TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') = V_NGAY_QD AND
                                                                          A.ID = QSV.DONID
                                                                  ) ) )
                                      --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
             --11/7/2023 TOAN CAU - quyet(
                                                                   AND
                                                       ( V_KETQUA IS NULL OR
                                                         ( V_KETQUA = 1 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 101
     --Giữ nguyên quyết định của Tòa án cấp sơ thẩm
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) OR
                                                         ( V_KETQUA = 2 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 103
     --Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) OR
                                                         ( V_KETQUA = 3 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 21
     --Sửa toàn bộ bản án, quyết định sơ thẩm
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) OR
                                                         ( V_KETQUA = 4 AND
                                                           ( EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV
                                                                                 LEFT JOIN DM_KETQUA_PHUCTHAM             KQPT ON KQPT.ID = QSV.KETQUAID
                                                                                 LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = QSV.QUYETDINHID
                                                                                 LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                      WHERE QSV.DONID = A.ID AND
                                                                            KQPT.ID = 102
     -- Sửa quyết định của Tòa án cấp sơ thẩm
                                                                             AND
                                                                            A.MAGIAIDOAN = 7
                                                                    ) ) ) )


        --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        --/////////////đối với sơ thẩm          
                                                                     AND
                                                       ( V_THOIHAN_GQ IS NULL OR
                                                         ( V_THOIHAN_GQ = 1
     --Đã hết thời hạn
                                                          AND
                                                           (  
                            --dùng ngày QĐ phúc thẩm  
                                                            EXISTS ( SELECT 'X'
                                                                                 FROM AHC_KCKNQDK_PHUCTHAM_THULY TL
                                                                                 LEFT JOIN AHC_SOTHAM_QUYETDINH       QSV ON TL.DONID = QSV.DONID
                                                                                 LEFT JOIN DM_QD_LOAI                 QDL ON QDL.ID = QSV.LOAIQDID
                                                                      WHERE ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') > 0 AND
                                                                                ( QSV.NGAYQD - TL.NGAYTHULY ) > 90 )
     --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                                                                 OR
                                                                              ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0 AND
                                                                                ( SYSDATE - TL.NGAYTHULY ) > 90 ) ) AND
                                                                            TL.DONID = NA.VUANID
                                                                    ) ) ) ) )
            --Tình trạng GQ;
                                                                     AND
                                                     ( ( V_TINHTRANG_GIAIQUYET IS NULL AND
                                                         ( V_TUNGAY IS NULL OR
                                                           A.NGAYTAO >= VV_TUNGAY ) AND
                                                         ( V_DENNGAY IS NULL OR
                                                           A.NGAYTAO <= VV_DENNGAY ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 1
     --Chưa giải quyết xong
--                                                      
                                --da thu ly
                                                        AND
                                                         ( TLPT.NGAYTHULY IS NOT NULL ) AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          PTQDVA.NGAYQD IS NOT NULL AND
                                                                          V_DENNGAY IS NOT NULL AND
                                                                          VV_DENNGAY < PTQDVA.NGAYQD
                                                                  ) OR
                                                           ( NOT EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                          WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                                                                PTQDVA.DONID = A.ID
                                                                        ) AND
                                                                 (

                                  --chua phan cong tham phan
                                                                  ( ( V_TUNGAY IS NULL OR
                                                                       TLPT.NGAYTHULY >= VV_TUNGAY ) AND
                                                                     ( V_DENNGAY IS NULL OR
                                                                       TLPT.NGAYTHULY <= VV_DENNGAY ) AND
                                                                     NOT EXISTS ( SELECT 'x'
                                                                                               FROM AHC_DON_THAMPHAN PC
                                                                                  WHERE PC.DONID = A.ID AND
                                                                                        ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' ) ) AND
                                                                                        ( V_TUNGAY IS NULL OR
                                                                                          PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                                        ( V_DENNGAY IS NULL OR
                                                                                          PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                                ) )
     --da phan cong tham phan
                                                                                 OR
                                                                   ( EXISTS ( SELECT 'x'
                                                                                         FROM AHC_DON_THAMPHAN PC
                                                                              WHERE PC.DONID = A.ID AND
                                                                                    ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' )
     --phuc thẩm
                                                                                     ) AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                            ) )
     --da len lich xx
                                                                             OR
                                                                   ( EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                              WHERE QDL.MA = 'DVARXX'
     --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                                                               AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                                    PTQDVA.DONID = A.ID
                                                                            ) )
     --dang hoan
                                                                             OR
                                                                   ( EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                                         LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                                         LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                              WHERE PTBA.DONID IS NULL AND
                                                                                    QDL.MA = 'HPT'
     --Vụ án chưa có bản án  --hoãn phiên tòa 
                                                                                     AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                                    PTQDVA.DONID = A.ID
                                                                            ) )
     --dang tdc
                                                                             OR
                                                                   ( EXISTS ( SELECT 'X'
                                                                                         FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                                         LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                                         LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                                         LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                                         LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                              WHERE PTBA.DONID IS NULL AND
                                                                                    QDL.MA = 'TDC'
     -- QDL.MA ='TDC' Tam dinh chi
                                                                                     AND
                                                                                    ( V_TUNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                                    ( V_DENNGAY IS NULL OR
                                                                                      PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                                    PTQDVA.DONID = A.ID
                                                                            ) ) ) ) ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 2
     --chưa phân công Thẩm phán
                                                        AND
                                                         ( TPPCPT.DONID IS NULL )
                                                       --( 10/7 toancau quyet
                                                          AND
                                                         ( TLPT.NGAYTHULY IS NOT NULL ) AND
                                                         ( V_TUNGAY IS NULL OR
                                                           TLPT.NGAYTHULY >= VV_TUNGAY ) AND
                                                         ( V_DENNGAY IS NULL OR
                                                           TLPT.NGAYTHULY <= VV_DENNGAY ) AND
                                                         ( NOT EXISTS ( SELECT 'x'
                                                                                       FROM AHC_DON_THAMPHAN PC
                                                                        WHERE PC.DONID = A.ID AND
                                                                              ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' AND
                                                                                  A.MAGIAIDOAN = 7 ) ) AND
                                                                              ( V_TUNGAY IS NULL OR
                                                                                PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                              ( V_DENNGAY IS NULL OR
                                                                                PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                      ) ) )
                                                       --10/7 toancau quyet)
                                                                       OR
                                                       ( V_TINHTRANG_GIAIQUYET = 3
     --đã phân công Thẩm phán
                                                        AND
                                                         EXISTS ( SELECT 'x'
                                                                           FROM AHC_DON_THAMPHAN PC
                                                                  WHERE PC.DONID = A.ID AND
                                                                        ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' )
    --phuc thẩm
                                                                         ) AND
                                                                        ( V_TUNGAY IS NULL OR
                                                                          PC.NGAYPHANCONG >= VV_TUNGAY ) AND
                                                                        ( V_DENNGAY IS NULL OR
                                                                          PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                ) ) 
                                      -- ( 10/7 TOANCAU QUYET
                                                                 OR
                                                       ( V_TINHTRANG_GIAIQUYET = 4
     --ĐÃ LÊN LỊCH XÉT XỬ
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE QDL.MA = 'DVARXX'
     --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                                                     AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 5
     --Đang hoãn  
                                                        AND
                                                         ( 
                      --Đang hoãn phuc tham                 
                                                          EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                               LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          QDL.MA = 'HPT'
     --Vụ án chưa có bản án  --hoãn phiên tòa 
                                                                           AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) ) OR
                                                       ( V_TINHTRANG_GIAIQUYET = 6
     --Đang tạm đình chỉ  
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                               LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          QDL.MA = 'TDC'
     -- QDL.MA ='TDC' Tam dinh chi
                                                                           AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) )
                                      -- 10/7 TOANCAU QUYET )
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 7
     --Đã giải quyết xong
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                    WHERE QD.MA IN ( '14-HC', '15-HC', '40-HC', '41-HC', '43-HC' ) AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  )
     -- ( 11/7 TOANCAU QUYET
                                                                   OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                             LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                             LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                             LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7 AND
                                                                          QD.KET_THUC = 1
                                                                  ) OR
                                                           EXISTS ( SELECT 'X'
                                                                             FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                             LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  )
                                                            OR EXISTS ( SELECT 1 
																		FROM AHC_DON_XULY ADX 
																		WHERE ADX.LOAIGIAIQUYET IN (1, 3)
																			AND (ADX.NGAYGQ_YC >= VV_TUNGAY)
																			AND (ADX.NGAYGQ_YC <= VV_DENNGAY)
																			AND ADX.DONID = A.ID )
                                      -- 11/7 TOANCAU QUYET)
                                                                   ) )
                                      -- ( 10/7 TOANCAU QUYET
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 8
     --ĐÃ XÉT XỬ 
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
     --QUYẾT ĐỊNH 
                                                                               LEFT JOIN AHC_KCKNQDK_PHUCTHAM_THULY     PTTL ON PTTL.DONID = PTQDVA.DONID
                                                                               LEFT JOIN AHC_PHUCTHAM_BANAN             PTBA ON PTBA.DONID = PTTL.DONID
     --BẢN ÁN 
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE PTBA.DONID IS NULL AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7 AND
                                                                          QD.KET_THUC = 1
                                                                  ) ) )
                                      -- 10/7 TOANCAU QUYET ) 
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 9
     --Đình chỉ
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  ) ) )
                                      -- ( 10/7 TOANCAU QUYET
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 10
     --Công nhận thỏa thuận của đương sự
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',CNTT,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID AND
                                                                          A.MAGIAIDOAN = 7
                                                                  ) ) ) 
                                      -- 10/7 TOANCAU QUYET )
                                                                   OR
                                                       ( V_TINHTRANG_GIAIQUYET = 11
     --QĐ chuyển vụ án
                                                        AND
                                                         ( EXISTS ( SELECT 'X'
                                                                               FROM AHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
                                                                               LEFT JOIN DM_QD_QUYETDINH                QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                               LEFT JOIN DM_QD_LOAI                     QDL ON QDL.ID = QD.LOAIID
                                                                    WHERE INSTR(',CVA,', ',' || QDL.MA || ',') > 0 AND
                                                                          ( V_TUNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD >= VV_TUNGAY ) AND
                                                                          ( V_DENNGAY IS NULL OR
                                                                            PTQDVA.NGAYQD <= VV_DENNGAY ) AND
                                                                          PTQDVA.DONID = A.ID
                                                                  ) ) ) )
                                             ) TT
                     WHERE TT.STT >= MININDEX AND
                           TT.STT <= MAXINDEX;
 END DON_SEARCH_V2;
 
END PKG_STPT_AHC_GS;

/
