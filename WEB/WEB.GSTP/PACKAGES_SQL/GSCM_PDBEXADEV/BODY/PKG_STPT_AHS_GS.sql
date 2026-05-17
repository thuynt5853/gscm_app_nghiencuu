CREATE OR REPLACE PACKAGE BODY GSCM.PKG_STPT_AHS_GS AS
     PROCEDURE AHS_VUAN_GETALLPAGING (
        V_CAP_XET_XU_LOGIN    IN VARCHAR2
      , V_TEN_VU_AN           IN VARCHAR2
      , V_TOIDANH             IN VARCHAR2
      , V_MA_VU_AN            IN VARCHAR2
      , V_BI_CAN              IN VARCHAR2
      , V_CAPXX               IN VARCHAR2
      , V_TOAAN_ID            IN VARCHAR2
      , V_TINHTRANG_THULY     IN VARCHAR2
      , V_NGAYTHULY_TU        IN VARCHAR2
      , V_NGAYTHULY_DEN       IN VARCHAR2
      , V_SOTHULY             IN VARCHAR2
      , V_TINHTRANG_GIAIQUYET IN VARCHAR2
      , V_TUNGAY              IN VARCHAR2
      , V_DENNGAY             IN VARCHAR2
      , V_KETQUA              IN VARCHAR2
      , V_SO_QD               IN VARCHAR2
      , V_NGAY_QD             IN VARCHAR2
      , V_THAMPHAN_ID         IN VARCHAR2
      , V_THUKY_ID            IN VARCHAR2
      , V_THOIHAN_GQ          IN VARCHAR2
      , V_QD_TAMGIAM          IN VARCHAR2
      , V_UTTP                IN VARCHAR2
      , VCHECKTK              IN NUMBER
      , V_THANHNIEN           IN NUMBER
      , V_HINHTHUCXX          IN NUMBER
      , V_GDTAOHS             IN NUMBER
      ,V_VAITRO_THAMPHAN     IN VARCHAR2
      ,V_AN_KET_THUC           IN NUMBER
      , PAGE_INDEX            IN INT
      , PAGE_SIZE             IN INT
      , CURRETURN             OUT SYS_REFCURSOR
    ) AS
        TOTALITEM        NUMBER;
        MININDEX         NUMBER;
        MAXINDEX         NUMBER;
        V_TABLE          T_AHS_THAMPHANGIAIQUYET;
        VV_TUNGAY        DATE;
        VV_DENNGAY       DATE;
        VV_NGAYTHULY_TU  DATE;
        VV_NGAYTHULY_DEN DATE;
        V_TABLE_TLST     T_QUYETDINH;
        V_TABLE_TLPT     T_QUYETDINH;
        V_TABLE_HDXX_ST  T_QUYETDINH;
        V_TABLE_HDXX_PT  T_QUYETDINH;
        V_TABLE_TP       T_QUYETDINH;
        V_TABLE_ST       T_QUYETDINH;
        V_TABLE_PT       T_QUYETDINH;
        V_TABLE_BC       T_AHS_BICANBICAO;
        V_TABLE_BC_KC    T_AHS_BICANBICAO;
        V_TABLE_TGTT     T_AHS_BICANBICAO;
        V_TABLE_TGTT_KC  T_AHS_BICANBICAO;
        V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-12102023-TAMNC
    BEGIN	

	--v_Capxx: SOTHAM = 2;PHUCTHAM = 3
        V_TABLE_TLST := T_QUYETDINH();
        V_TABLE_TLPT := T_QUYETDINH();
        V_TABLE_HDXX_ST := T_QUYETDINH();
        V_TABLE_HDXX_PT := T_QUYETDINH();
        V_TABLE_TP := T_QUYETDINH();
        V_TABLE_ST := T_QUYETDINH();
        V_TABLE_PT := T_QUYETDINH();
        V_TABLE_BC := T_AHS_BICANBICAO();
        V_TABLE_BC_KC := T_AHS_BICANBICAO();
        V_TABLE_TGTT := T_AHS_BICANBICAO();
        V_TABLE_TGTT_KC := T_AHS_BICANBICAO();
        V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-12102023-TAMNC
	---------------------------------------
        MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
        MAXINDEX := PAGE_INDEX * PAGE_SIZE;
	------------
	-------------------
        IF ( V_NGAYTHULY_TU IS NOT NULL ) THEN VV_NGAYTHULY_TU := TO_DATE ( TRIM(V_NGAYTHULY_TU) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_NGAYTHULY_DEN IS NOT NULL ) THEN VV_NGAYTHULY_DEN := TO_DATE ( TRIM(V_NGAYTHULY_DEN) || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;  
	--

        IF ( V_TUNGAY IS NOT NULL ) THEN VV_TUNGAY := TO_DATE ( TRIM(V_TUNGAY) || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;
        IF ( V_DENNGAY IS NOT NULL ) THEN VV_DENNGAY := TO_DATE ( TRIM(V_DENNGAY) || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS' );
        END IF;  
	------------------tao bang tam lay 1 ban ghi moi nhat
	--THAMPHAN --TOANCAU-20102023-TAMNC
        SELECT R_THAMPHAN_EXT(TP.VUANID, TP.ID, TP.CANBOID, TP.MAVAITRO, TP.MAGIAIDOAN
                            , TP.NGAYPHANCONG)
        BULK COLLECT
        INTO V_TABLE_THAMPHAN
        FROM ( SELECT MAVAITRO
                    , VUANID
                    , ID
                    , CANBOID
                    , ROW_NUMBER()
                        OVER(PARTITION BY VUANID, MAVAITRO
                             ORDER BY NGAYPHANCONG DESC
                        ) ROWNUMBER
                    , NGAYPHANCONG
                    , (
                                        CASE
                                            WHEN MAVAITRO IN ( 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETDON' ) THEN 2
                                            WHEN MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' THEN 3
                                        END
                                    ) MAGIAIDOAN
                                    FROM AHS_THAMPHANGIAIQUYET
                             WHERE MAVAITRO IN ( 'VTTP_GIAIQUYETDON', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' )
                      UNION
                      SELECT CAST(MAVAITRO AS NVARCHAR2(20)) MAVAITRO
                           , VUANID
                           , ID
                           , CANBOID
                           , ROW_NUMBER()
                               OVER(PARTITION BY VUANID, MAVAITRO
                                    ORDER BY NGAYPHANCONG DESC
                               )                               ROWNUMBER
                           , NGAYPHANCONG
                           , 3                               MAGIAIDOAN
                      FROM AHS_PHUCTHAM_HDXX
               WHERE MAVAITRO IN ( 'THAMPHAN', 'THAMPHANHDXX', 'THAMPHANDUKHUYET' )
             ) TP
        WHERE ( ( TP.ROWNUMBER = 1
                  AND TP.MAVAITRO IN ( 'VTTP_GIAIQUYETDON', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM', 'THAMPHAN', 'THAMPHANHDXX' )
                  OR TP.MAVAITRO = 'THAMPHANDUKHUYET' ) );
	--AHS_SOTHAM_THULY

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TLST
        FROM ( SELECT TT.VUANID
                    , TT.ID
                      FROM ( SELECT VUANID
                                  , FIRST_VALUE(ID)
                                      OVER(PARTITION BY VUANID
                                           ORDER BY NGAYTHULY DESC, NGAYTAO DESC
                                      ) ID
                             FROM AHS_SOTHAM_THULY
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
             ) TTS;
	--AHS_KCKNQDK_PHUCTHAM_THULY

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TLPT
        FROM ( SELECT TT.VUANID
                    , TT.ID
                      FROM ( SELECT VUANID
                                  , FIRST_VALUE(ID)
                                      OVER(PARTITION BY VUANID
                                           ORDER BY NGAYTHULY DESC, NGAYTAO DESC
                                      ) ID
                             FROM AHS_KCKNQDK_PHUCTHAM_THULY
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
             ) TTS;   
	--THAMPHAN tham phan chu toa ST

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_HDXX_ST
        FROM ( SELECT TT.VUANID
                    , TT.ID
                      FROM ( SELECT VUANID
                                  , FIRST_VALUE(CANBOID)
                                      OVER(PARTITION BY VUANID
                                           ORDER BY NGAYTAO DESC
                                      ) ID
                                    FROM AHS_SOTHAM_HDXX
                             WHERE MAVAITRO = 'THAMPHAN'
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
             ) TTS;  
	--THAMPHAN tham phan chu toa PT

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_HDXX_PT
        FROM ( SELECT TT.VUANID
                    , TT.ID
                      FROM ( SELECT VUANID
                                  , FIRST_VALUE(CANBOID)
                                      OVER(PARTITION BY VUANID
                                           ORDER BY NGAYTAO DESC
                                      ) ID
                                    FROM AHS_KCKNQDK_PHUCTHAM_HDXX
                             WHERE MAVAITRO = 'THAMPHAN'
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
             ) TTS;  
	---THAMPHAN giai quyet

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TP
        FROM ( SELECT TT.VUANID
                    , TT.ID
                      FROM ( SELECT VUANID
                                  , FIRST_VALUE(ID)
                                      OVER(PARTITION BY VUANID
                                           ORDER BY NGAYNHANPHANCONG DESC
                                      ) ID
                             FROM AHS_THAMPHANGIAIQUYET
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
             ) TTS;    
	--AHS_SOTHAM_QUYETDINH_VUAN

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, TTS.MA)
        BULK COLLECT
        INTO V_TABLE_ST
        FROM ( SELECT TT.VUANID
                    , TT.ID
                    , TT.MA
                      FROM ( SELECT PQD.VUANID
                                  , FIRST_VALUE(PQD.ID)
                                      OVER(PARTITION BY PQD.VUANID, QDL.MA
                                           ORDER BY PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                                      ) ID
                                  , QDL.MA
                             FROM AHS_SOTHAM_QUYETDINH_VUAN PQD
                             LEFT JOIN DM_QD_QUYETDINH           QD ON QD.ID = PQD.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI                QDL ON QDL.ID = QD.LOAIID
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
                      , TT.MA
             ) TTS;
	--AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN

        SELECT R_QUYETDINH(TTS.VUANID, TTS.ID, TTS.MA)
        BULK COLLECT
        INTO V_TABLE_PT
        FROM ( SELECT TT.VUANID
                    , TT.ID
                    , TT.MA
                      FROM ( SELECT PQD.VUANID
                                  , FIRST_VALUE(PQD.ID)
                                      OVER(PARTITION BY PQD.VUANID, QDL.MA
                                           ORDER BY PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                                      ) ID
                                  , QDL.MA
                             FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PQD
                             LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PQD.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                           ) TT
               GROUP BY TT.VUANID
                      , TT.ID
                      , TT.MA
             ) TTS;
	---V_TABLE_BC; tạo bảng lấy <=3 bị cáo: 1 đầu vụ và 2 bị cáo tiếp theo     

        SELECT R_AHS_BICANBICAO(TTS.ID, TTS.VUANID, TTS.HOTEN, TTS.TENTOIDANH, TTS.BICANDAUVU
                              , TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC
        FROM ( SELECT BC.ID
                    , BC.VUANID
                    , BC.HOTEN
                    , C.TENTOIDANH
                    , BC.BICANDAUVU
                    , BC.ROWNUMBER
                      FROM ( SELECT ID
                                  , VUANID
                                  , HOTEN
                                  , BICANDAUVU
                                  , ROW_NUMBER()
                                      OVER(PARTITION BY VUANID
                                           ORDER BY BICANDAUVU DESC, NGAYTHAMGIA DESC
                                      ) ROWNUMBER
                             FROM AHS_BICANBICAO
                           ) BC
                      LEFT JOIN ( SELECT CD.BICANID
                                       , CD.TENTOIDANH
                                       , CD.ISMAIN
                                              FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD
                                  WHERE ISMAIN = 1
                                ) C ON BC.ID = C.BICANID
               WHERE BC.ROWNUMBER <= 3
             ) TTS;       
	---V_TABLE_BC; tạo bảng  lấy <=3 bị cáo khang cao

        SELECT R_AHS_BICANBICAO(TTS.ID, TTS.VUANID, TTS.HOTEN, TTS.TENTOIDANH, TTS.BICANDAUVU
                              , TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC_KC
        FROM ( SELECT BC.ID
                    , BC.VUANID
                    , BC.HOTEN
                    , C.TENTOIDANH
                    , BC.BICANDAUVU
                    , BC.ROWNUMBER
                      FROM ( SELECT B.ID
                                  , B.VUANID
                                  , B.HOTEN
                                  , B.BICANDAUVU
                                  , ROW_NUMBER()
                                      OVER(PARTITION BY B.VUANID
                                           ORDER BY B.BICANDAUVU DESC, B.NGAYTHAMGIA DESC
                                      ) ROWNUMBER
                                    FROM AHS_BICANBICAO B
                             WHERE EXISTS ( SELECT 'X'
                                                           FROM AHS_SOTHAM_KHANGCAO KC
                                            WHERE KC.NGUOIKCID = B.ID
                                                  AND KC.VUANID = B.VUANID
                                          )
                           ) BC
                      LEFT JOIN ( SELECT CD.BICANID
                                       , CD.TENTOIDANH
                                       , CD.ISMAIN
                                              FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD
                                  WHERE ISMAIN = 1
                                ) C ON BC.ID = C.BICANID
               WHERE BC.ROWNUMBER <= 3
             ) TTS;   
	---V_TABLE_TGTT; tạo bảng  lấy NguoiTGTT  khang cao  manhnd    

        SELECT R_AHS_BICANBICAO(TTS.ID, TTS.VUANID, TTS.HOTEN, TTS.TENTUCACHTGTT, NULL
                              , TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_TGTT_KC
        FROM ( SELECT TG.ID
                    , TG.VUANID
                    , TG.HOTEN
                    , TG.TENTUCACHTGTT
                    , TG.ROWNUMBER
                      FROM ( SELECT A.ID
                                  , A.VUANID
                                  , A.HOTEN
                                  , C.TEN TENTUCACHTGTT
                                  , ROW_NUMBER()
                                      OVER(PARTITION BY A.VUANID
                                           ORDER BY A.HOTEN ASC
                                      )     ROWNUMBER
                                    FROM AHS_NGUOITHAMGIATOTUNG A
                                    INNER JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH B ON A.ID = B.NGUOIID
                                    INNER JOIN DM_DATAITEM                   C ON B.TUCACHID = C.ID
                             WHERE EXISTS ( SELECT 'X'
                                                           FROM AHS_SOTHAM_KHANGCAO KC
                                            WHERE KC.NGUOIKCID = A.ID
                                                  AND KC.VUANID = A.VUANID
                                                  AND KC.NGUOIKCLOAI = 1
                                          )
                           ) TG
               WHERE TG.ROWNUMBER <= 3
             ) TTS;  
	-----------------

        OPEN CURRETURN FOR SELECT TT.*
                                  FROM ( SELECT ROW_NUMBER()
                                                OVER(
                                                    ORDER BY A.NGAYTAO DESC
                                                )    STT
                                              , COUNT(*)
                                                  OVER()  AS COUNTALL
                                              , A.ID
                                              , A.MAVUAN
                                              , A.TENVUAN
                                              , A.TT
                                              , A.NGAYBANCAOTRANG
                                              , TO_CHAR(A.NGAYTAO, 'dd/MM/yyyy') || '<br/>' || TO_CHAR(A.NGAYTAO, ' HH24:MI:SS')  NGAYTAO
                                              , A.NGUOITAO
                                              , A.MAGIAIDOAN
                                              , DECODE(GD.MAGIAIDOAN,7,BC3.HoTen || TG3.HoTen,BC2.HoTen)  HOTENBICAN
                                              , ( '</br><i>Tòa xét xử sơ thẩm: </i><b>' || TOAANST.TEN || '</b>' )  TENTOASOTHAM
                                              , GN.TRUONGHOPGIAONHAN TRUONGHOPGIAONHAN
                                              , NULL HINHTHUCNHANDON
                                              , 'Phúc thẩm'  GIAIDOANVUVIEC
                                              , DECODE(A.GDTAOHS, 1, 'Thi hành án - Từ ' || TOAANID_GDTAOHS.TEN, 2, 'Phúc thẩm - Từ ' || TOAANID_GDTAOHS.TEN
                                                       , 3, 'Giám đốc thẩm - Từ ' || TOAANID_GDTAOHS.TEN, 'Sơ thẩm') GIAIDOANTAOHOSO
                                              , STBA.BANAN_QD_ST
                                              , STKN.KHANGNGHI_ST
                                              , '' KHANGCAO_ST --STKC.KHANGCAO_ST
                                              , PTQD.QD_PT
                                              ,
        
                              
--------
                                               CASE
                                                    WHEN ( TLPT.TINHTRANG_GQ ) IS NULL THEN '- Chưa thụ lý'
                                                    ELSE ( TLPT.TINHTRANG_GQ )
                                                END
                                                ||
                                                CASE
                                                    WHEN ( TPPCPT.TINHTRANG_GQ ) IS NULL
                                                         AND ( TLPT.TINHTRANG_GQ ) IS NOT NULL THEN '</br>- Chưa phân công Thẩm phán'
                                                    ELSE ( TPPCPT.TINHTRANG_GQ )
                                                END
--                                                || HPT.TINHTRANG_GQ 
                                                || HPTPT.TINHTRANG_GQ || TDCPT.TINHTRANG_GQ 
--                                                || BAST.TINHTRANG_GQ || DCST.TINHTRANG_GQ 
                                                || DCPT.TINHTRANG_GQ || CST.TINHTRANG_GQ || CPT.TINHTRANG_GQ || GNST.TINHTRANG_GQ TINHTRANG_GQ
                                              , TLPT.TINHTRANG_GQ CHECK_THULY
                                              , 0 THULYXXLAI
                                              
                                                FROM AHS_VUAN A
                                                INNER JOIN ( SELECT G.*
                                                                          FROM AHS_VUAN_GIAIDOAN G
                                                             WHERE ( G.MAGIAIDOAN = 7
                                                                     AND G.TOAPHUCTHAMID = V_TOAAN_ID )
                                                           )                  GD ON A.ID = GD.VUANID
                                                LEFT JOIN DM_TOAAN           TOAANID_GDTAOHS ON A.TOAANID_GDTAOHS = TOAANID_GDTAOHS.ID
                                                INNER JOIN AHS_CHUYEN_NHAN_AN NHANAN ON NHANAN.MAP_VUANID_NEW = A.ID
                                                LEFT JOIN DM_TOAAN           TOAANST ON NHANAN.TOACHUYENID = TOAANST.ID
-- lấy thông tin vụ án end     
                                                LEFT JOIN ( SELECT PTQDVA.*
                                                                        FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                        LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                        LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                            WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                          )                  QD ON QD.VUANID = A.ID
------Trạng thái giải quyết trong danh sách
                                                LEFT JOIN ( SELECT TL.VUANID
                                                                 , '</br>- Thụ lý số:<b> ' || TO_CHAR(TL.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(TL.NGAYTHULY, 'dd/MM/yyyy') || '</b>' TINHTRANG_GQ
                                                                                    FROM AHS_SOTHAM_THULY TL
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_TLST ) QDL
                                                                                       WHERE QDL.ID = TL.ID
                                                                                     )
                                                            GROUP BY TL.VUANID
                                                                   , '</br>- Thụ lý số:<b> ' || TO_CHAR(TL.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(TL.NGAYTHULY, 'dd/MM/yyyy') || '</b>'
                                                          )                  TLS ON NHANAN.VUANID = TLS.VUANID
                                                LEFT JOIN ( SELECT TL.VUANID
                                                                 , '</br>- Thụ lý số:<b> ' || TO_CHAR(TL.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(TL.NGAYTHULY, 'dd/MM/yyyy') || '</b>' TINHTRANG_GQ
                                                                                    FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_TLPT ) QDL
                                                                                       WHERE QDL.ID = TL.ID
                                                                                     )
                                                            GROUP BY TL.VUANID
                                                                   , '</br>- Thụ lý số:<b> ' || TO_CHAR(TL.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(TL.NGAYTHULY, 'dd/MM/yyyy') || '</b>'
                                                          )                  TLPT ON A.ID = TLPT.VUANID
                                                LEFT JOIN ( SELECT TP.VUANID
                                                                 , '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                                                                                    FROM AHS_THAMPHANGIAIQUYET TP
                                                                                    LEFT JOIN ( SELECT VUANID
                                                                                                     , ID
                                                                                                FROM TABLE ( V_TABLE_HDXX_ST )
                                                                                              )                     HD ON HD.VUANID = TP.VUANID
      ----anhvh add 08/07/2021 hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                                                                                    LEFT JOIN ( SELECT GG.*
                                                                                                            FROM AHS_THAMPHANGIAIQUYET GG
                                                                                                WHERE EXISTS ( SELECT 'X'
                                                                                                                              FROM TABLE ( V_TABLE_TP ) TP
                                                                                                               WHERE TP.ID = GG.ID
                                                                                                             )
                                                                                              )                     PCTP_GQ ON PCTP_GQ.VUANID = TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                                                                    LEFT JOIN DM_CANBO              CBB ON CBB.ID = HD.ID
                                                                                    LEFT JOIN DM_CANBO              CB ON CB.ID = PCTP_GQ.CANBOID
                                                                        WHERE TP.MAVAITRO = 'VTTP_GIAIQUYETSOTHAM'
                                                            GROUP BY TP.VUANID
                                                                   , '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>'
                                                          )                  TPPC ON TPPC.VUANID = NHANAN.VUANID
                                                LEFT JOIN ( SELECT TP.VUANID
                                                                 , '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                                                                                    FROM AHS_THAMPHANGIAIQUYET TP
                                                                                    LEFT JOIN ( SELECT VUANID
                                                                                                     , ID
                                                                                                FROM TABLE ( V_TABLE_HDXX_PT )
                                                                                              )                     HD ON HD.VUANID = TP.VUANID
                                                                                    LEFT JOIN ( SELECT GG.*
                                                                                                            FROM AHS_THAMPHANGIAIQUYET GG
                                                                                                WHERE EXISTS ( SELECT 'X'
                                                                                                                              FROM TABLE ( V_TABLE_TP ) TP
                                                                                                               WHERE TP.ID = GG.ID
                                                                                                             )
                                                                                              )                     PCTP_GQ ON PCTP_GQ.VUANID = TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                                                                    LEFT JOIN DM_CANBO              CBB ON CBB.ID = HD.ID
                                                                                    LEFT JOIN DM_CANBO              CB ON CB.ID = PCTP_GQ.CANBOID
                                                                        WHERE TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                            GROUP BY TP.VUANID
                                                                   , '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBB.HOTEN, NULL, CB.HOTEN, CBB.HOTEN)) || '</b><i> (chủ tọa)</i>'
                                                          )                  TPPCPT ON TPPCPT.VUANID = A.ID
--                                                LEFT JOIN ( SELECT QSV.VUANID
--                                                                 , '</br>- QĐ HPT số: ' || QSV.SOQUYETDINH || ' ngày ' || TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
--                                                                                    FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
--                                                                        WHERE EXISTS ( SELECT 'X'
--                                                                                                      FROM TABLE ( V_TABLE_ST ) QDL
--                                                                                       WHERE QDL.ID = QSV.ID
--                                                                                             AND INSTR(',HPT,', ',' || QDL.MA || ',') > 0
--                                                                                     )
--                                                            GROUP BY QSV.VUANID
--                                                                   , '</br>- QĐ HPT số: ' || QSV.SOQUYETDINH || ' ngày ' || TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy')
--                                                          )                  HPT ON HPT.VUANID = NHANAN.VUANID
                                                LEFT JOIN ( SELECT PTQDVA.VUANID
                                                                 , '</br>- QĐ HPT số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_PT ) QDL
                                                                                       WHERE QDL.ID = PTQDVA.ID
                                                                                             AND INSTR(',HPT,', ',' || QDL.MA || ',') > 0
                                                                                     )
                                                            GROUP BY PTQDVA.VUANID
                                                                   , '</br>- QĐ HPT số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                          )                  HPTPT ON HPTPT.VUANID = A.ID
                                                LEFT JOIN ( SELECT PTQDVA.VUANID
                                                                 , '</br>- QĐ TĐC số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_PT ) QDL
                                                                                       WHERE QDL.ID = PTQDVA.ID
                                                                                             AND INSTR(',TDC,', ',' || QDL.MA || ',') > 0
                                                                                     )
                                                            GROUP BY PTQDVA.VUANID
                                                                   , '</br>- QĐ TĐC số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                          )                  TDCPT ON TDCPT.VUANID = A.ID
                                                LEFT JOIN ( SELECT BA.VUANID
                                                                 , '</br>- Bản án số: ' || BA.SOBANAN || ' ngày ' || TO_CHAR(BA.NGAYBANAN, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_SOTHAM_BANAN BA
                                                                        WHERE BA.SOBANAN IS NOT NULL
                                                            GROUP BY BA.VUANID
                                                                   , '</br>- Bản án số: ' || BA.SOBANAN || ' ngày ' || TO_CHAR(BA.NGAYBANAN, 'dd/MM/yyyy')
                                                          )                  BAST ON BAST.VUANID = NHANAN.VUANID
                                                LEFT JOIN ( SELECT QSV.VUANID
                                                                 , '</br>- QĐ ĐC số: ' || QSV.SOQUYETDINH || ' ngày ' || TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
   --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_ST ) QDL
                                                                                       WHERE QDL.ID = QSV.ID
                                                                                             AND INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                                                     )
                                                            GROUP BY QSV.VUANID
                                                                   , '</br>- QĐ ĐC số: ' || QSV.SOQUYETDINH || ' ngày ' || TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy')
                                                          )                  DCST ON DCST.VUANID = NHANAN.VUANID
                                                LEFT JOIN ( SELECT PTQDVA.VUANID
                                                                 , '</br>- QĐ ĐC số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_PT ) QDL
                                                                                       WHERE QDL.ID = PTQDVA.ID
                                                                                             AND INSTR(',DC,', ',' || QDL.MA || ',') > 0
                                                                                     )
                                                            GROUP BY PTQDVA.VUANID
                                                                   , '</br>- QĐ ĐC số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                          )                  DCPT ON DCPT.VUANID = A.ID
                                                LEFT JOIN ( SELECT QSV.VUANID
                                                                 , '</br>- QĐ CVA số: ' || QSV.SOQUYETDINH || ' ngày ' || TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_ST ) QDL
                                                                                       WHERE QDL.ID = QSV.ID
                                                                                             AND QDL.MA = 'CVA'
                                                                                     )
                                                            GROUP BY QSV.VUANID
                                                                   , '</br>- QĐ CVA số: ' || QSV.SOQUYETDINH || ' ngày ' || TO_CHAR(QSV.NGAYQD, 'dd/MM/yyyy')
                                                          )                  CST ON CST.VUANID = NHANAN.VUANID
                                                LEFT JOIN ( SELECT PTQDVA.VUANID
                                                                 , '</br>- QĐ CVA số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
                                                                                    FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                        WHERE EXISTS ( SELECT 'X'
                                                                                                      FROM TABLE ( V_TABLE_PT ) QDL
                                                                                       WHERE QDL.ID = PTQDVA.ID
                                                                                             AND QDL.MA = 'CVA'
                                                                                     )
                                                            GROUP BY PTQDVA.VUANID
                                                                   , '</br>- QĐ CVA số: ' || PTQDVA.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
                                                          )                  CPT ON CPT.VUANID = A.ID
                                                LEFT JOIN ( SELECT CA.ID
                                                                 , CA.VUANID
                                                                 ,
                          -- '</br>- '
                          --|| I.TEN --toancau không hiển thị 'xét xử lại cấp sơ thẩm '
                                                                  '</br>- Đã chuyển vụ án' TINHTRANG_GQ
                                                                        FROM AHS_CHUYEN_NHAN_AN CA
                                                                        INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                                            WHERE CA.TOACHUYENID = V_TOAAN_ID
                                                          )                  GNST ON GNST.VUANID = A.ID
                                                                    AND GD.MAGIAIDOAN = 7
                                                LEFT JOIN ( SELECT CA.VUANID
                                                                 , I.TEN TRUONGHOPGIAONHAN
                                                                 , CA.MAP_VUANID_NEW
                                                                                    FROM DM_DATAITEM I
                                                                                    INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                                                        WHERE CA.TOANHANID = V_TOAAN_ID
                                                            GROUP BY CA.VUANID
                                                                   , I.TEN
                                                                   , CA.MAP_VUANID_NEW
                                                          )                  GN ON GN.VUANID = A.ID
                                                                  OR GN.MAP_VUANID_NEW = A.ID
                          
-------trường hợp giao nhân dùng cho sơ thẩm với viện kiểm sát
                                                LEFT JOIN ( SELECT A1.ID
                                                                 , DECODE(A1.TRUONGHOPGIAONHAN, 1, 'VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm', 2, 'Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung'
                                                                          , 3, 'Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung', '') TRUONGHOPGIAONHAN
                                                            FROM AHS_VUAN A1
                                                          )                  AA ON AA.ID = A.ID

-------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
                                                LEFT JOIN ( SELECT CA.MAP_VUANID_NEW
                                                                 , CA.VUANID
                                                                 , I.TEN TRUONGHOPGIAONHAN
                                                                                    FROM DM_DATAITEM I
                                                                                    INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
                                                                        WHERE CA.TOANHANID = V_TOAAN_ID
                                                            GROUP BY CA.MAP_VUANID_NEW
                                                                   , CA.VUANID
                                                                   , I.TEN
                                                          )                  GN ON GN.MAP_VUANID_NEW = A.ID

------bị cáo lấy cho sơ thẩm
                                                LEFT JOIN ( SELECT BC.VUANID
                                                                 , '<br/><i>Bị cáo:</i> <br />' ||
                                                                     LISTAGG(DECODE(BC.BICANDAUVU
                                                                                  , 1
                                                                                  , '<b>' || BC.HOTEN || DECODE(BC.TENTOIDANH, NULL, NULL, ' - ' || BC.TENTOIDANH) || ' (đầu vụ)</b>'
                                                                                  , BC.HOTEN || DECODE(BC.TENTOIDANH, NULL, NULL, ' - ' || BC.TENTOIDANH))
                                                                                    , '<br/>') WITHIN GROUP(
                                                                            ORDER BY BC.ROWNUMBER)
                                                                        HOTEN
                                                                        FROM TABLE ( V_TABLE_BC ) BC
                                                            GROUP BY BC.VUANID
                                                          )                  BC2 ON BC2.VUANID = NHANAN.VUANID      
------lấy tội danh của bị cáo đầu vụ
                                                LEFT JOIN ( SELECT BC.VUANID
                                                                 , LISTAGG(BC.TENTOIDANH) WITHIN GROUP(
                                                                                    ORDER BY BC.ROWNUMBER) TENTOIDANH
                                                                                    FROM TABLE ( V_TABLE_BC ) BC
                                                                        WHERE BC.BICANDAUVU = 1
                                                            GROUP BY BC.VUANID
                                                          )                  BC4 ON BC4.VUANID = A.ID 
------bị cáo kháng cáo lấy cho phúc thẩm 
                                                LEFT JOIN ( SELECT BC.VUANID
                                                                 , '<br/><i>Bị cáo kháng cáo:</i> <br />' ||
                                                                     LISTAGG(DECODE(BC.BICANDAUVU
                                                                                  , 1
                                                                                  , '<b>' || BC.HOTEN || DECODE(BC.TENTOIDANH, NULL, NULL, ' - ' || BC.TENTOIDANH) || ' (đầu vụ)</b>'
                                                                                  , BC.HOTEN || DECODE(BC.TENTOIDANH, NULL, NULL, ' - ' || BC.TENTOIDANH))
                                                                                    , '<br/>') WITHIN GROUP(
                                                                            ORDER BY BC.ROWNUMBER)
                                                                        HOTEN
                                                                        FROM TABLE ( V_TABLE_BC_KC ) BC
                                                            GROUP BY BC.VUANID
                                                          )                  BC3 ON BC3.VUANID = NHANAN.VUANID
------NguoiTGTT cáo kháng cáo lấy cho phúc thẩm manhnd
                                                LEFT JOIN ( SELECT TG.VUANID
                                                                 , '<br/><i>Người TGTT kháng cáo: </i>' || XMLAGG(XMLELEMENT(TG, TG.HOTEN || DECODE(TG.TENTOIDANH, NULL, NULL, ' (' || TG.TENTOIDANH) || ')', '; ').EXTRACT('//text()')).GETCLOBVAL() AS
                                                                 HOTEN
                                                                        FROM TABLE ( V_TABLE_TGTT_KC ) TG
                                                            GROUP BY TG.VUANID
                                                          )                  TG3 ON TG3.VUANID = A.ID
           
------- lấy thông tin BA/sơ thẩm                
                                                LEFT JOIN ( SELECT BA.VUANID
                                                                 , '<br />BA/QĐ sơ thẩm: <b>' ||
                                                                     LISTAGG('Số ' || BA.SOBANAN || ' ngày ' || TO_CHAR(BA.NGAYBANAN, 'dd/MM/yyyy')
                                                                                    , '<br/>') WITHIN GROUP(
                                                                            ORDER BY BA.NGAYBANAN)
                                                                        BANAN_QD_ST
                                                                        FROM AHS_SOTHAM_BANAN BA
                                                            GROUP BY BA.VUANID
                                                          )                  STBA ON STBA.VUANID = NHANAN.VUANID     
                  
                  
                  ---------------------------- toancau them qđ tđc 
                                                LEFT JOIN ( SELECT PTQD.VUANID
                                                                 , '<br /><i>QĐ GQ PT: </i><b>' ||
                                                                     LISTAGG('Số ' || PTQD.SOQUYETDINH || ' ngày ' || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy')
                                                                                                , '<br/>') WITHIN GROUP(
                                                                                        ORDER BY PTQD.NGAYQD)
                                                                                    QD_PT
                                                                                    FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQD
                                                                        WHERE QUYETDINHID = 324
                                                            GROUP BY PTQD.VUANID
                                                          )                  PTQD ON PTQD.VUANID = A.ID          
------- lấy thông tin số ngày kháng nghị
                                                LEFT JOIN ( SELECT KN.VUANID
                                                                 , XLY.VUANPT_ID
                                                                 , '<br /><i>Kháng nghị:</i> <br />' ||
                                                                     LISTAGG('Số ' || KN.SOKN || ' ngày ' || TO_CHAR(KN.NGAYKN, 'dd/MM/yyyy')
                                                                                    , '<br/>') WITHIN GROUP(
                                                                            ORDER BY KN.NGAYKN)
                                                                        KHANGNGHI_ST
                                                                        FROM AHS_SOTHAM_KHANGNGHI KN
                                                                        INNER JOIN AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST XLY ON XLY.KCKN_SOTHAM_ID = KN.ID
                                                                                                                           AND NVL(XLY.IS_KC, 0) = 0
                                                                                                                           AND XLY.VUANST_ID = KN.VUANID
                                                            GROUP BY KN.VUANID
                                                                   , XLY.VUANPT_ID
                                                          )                  STKN ON STKN.VUANPT_ID = A.ID
                  
--                                      
                  
                  --tamnc  lấy thông tin số ngày kháng cáo
--                                                LEFT JOIN ( SELECT KC.VUANID
--                                                                 , XLY.VUANPT_ID
--                                                                 , '<br /><i>Kháng cáo:</i> <br />' ||
--                                                                     LISTAGG('Số ' || KC.SOQDBA || ' ngày ' || TO_CHAR(KC.NGAYKHANGCAO, 'dd/MM/yyyy')
--                                                                                    , '<br/>') WITHIN GROUP(
--                                                                            ORDER BY KC.NGAYKHANGCAO)
--                                                                        KHANGCAO_ST
--                                                                        FROM AHS_SOTHAM_KHANGCAO KC
--                                                                        INNER JOIN AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST XLY ON XLY.KCKN_SOTHAM_ID = KC.ID
--                                                                                                                           AND NVL(XLY.IS_KC, 0) = 1
--                                                                                                                           AND XLY.VUANST_ID = KC.VUANID
--                                                            GROUP BY KC.VUANID
--                                                                   , XLY.VUANPT_ID
--                                                          )                  STKC ON STKC.VUANPT_ID = A.ID
-------
                                         WHERE A.MAGIAIDOAN = 7
                                               AND ( V_TEN_VU_AN IS NULL
                                                     OR ( LOWER(A.TENVUAN) LIKE '%' || LOWER(V_TEN_VU_AN) || '%' ) )
                                               AND ( V_UTTP IS NULL
                                                     OR ( V_UTTP IS NOT NULL
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_SOTHAM_THULY TL
                                                        WHERE TL.UTTPDI = TO_NUMBER(V_UTTP)
                                                              AND TL.VUANID = NHANAN.VUANID
                                                                       )
                                                                OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_THULY TLPT
                                                     WHERE TLPT.UTTPDI = TO_NUMBER(V_UTTP)
                                                           AND TLPT.VUANID = A.ID
                                                                          ) ) ) )
                                               AND ( V_TOIDANH IS NULL
                                                     OR ( LOWER(BC4.TENTOIDANH) LIKE '%' || LOWER(V_TOIDANH) || '%' ) )--tìm tội danh đã được gắn vào tên vụ án A.TENVUAN
                                               AND ( V_MA_VU_AN IS NULL
                                                     OR ( LOWER(A.MAVUAN) LIKE LOWER(V_MA_VU_AN) ) )
                                               AND ( V_BI_CAN IS NULL
                                                     OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_BICANBICAO BC
                                                     WHERE FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%' || FN_CONVERT_TO_VN(UPPER(V_BI_CAN)) || '%'
                                                           AND BC.VUANID = A.ID
                                                               ) )                
-----
---tuyennh 31/07/2023 sửa tìm kiếm theo tình trạng thụ lý start
                                               AND ( ( V_TINHTRANG_THULY IS NULL
--                                              AND ( V_NGAYTHULY_TU IS NULL
--                                                    OR A.NGAYTAO >= VV_NGAYTHULY_TU )
--                                              AND ( V_NGAYTHULY_DEN IS NULL
--                                                    OR A.NGAYTAO <= VV_NGAYTHULY_DEN ) 
                                                       AND ( V_NGAYTHULY_TU IS NULL
                                                             OR NHANAN.NGAYNHAN >= VV_NGAYTHULY_TU )
                                                       AND ( V_NGAYTHULY_DEN IS NULL
                                                             OR NHANAN.NGAYNHAN <= VV_NGAYTHULY_DEN ) )
                                                     OR ( V_TINHTRANG_THULY = 1 --đã thụ lý
                                                          AND ( EXISTS ( SELECT 'x'
                                                                       FROM AHS_SOTHAM_THULY TL
                                                        WHERE TL.VUANID = NHANAN.VUANID
--                                              AND ( V_NGAYTHULY_TU IS NULL
--                                                    OR TL.NGAYTHULY >= VV_NGAYTHULY_TU )
--                                              AND ( V_NGAYTHULY_DEN IS NULL
--                                                    OR TL.NGAYTHULY <= VV_NGAYTHULY_DEN )
                                                                       )
                                                                AND EXISTS ( SELECT 'x'
                                                                   FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                      WHERE TL.VUANID = A.ID
                                                            AND ( V_NGAYTHULY_TU IS NULL
                                                                  OR TL.NGAYTHULY >= VV_NGAYTHULY_TU )
                                                            AND ( V_NGAYTHULY_DEN IS NULL
                                                                  OR TL.NGAYTHULY <= VV_NGAYTHULY_DEN )
                                                                           ) ) )
                                                     OR ( V_TINHTRANG_THULY = 2 --chưa thụ lý
                                                          AND ( 
--                                                 NOT EXISTS (
--                                          SELECT
--                                              'x'
--                                          FROM
--                                              AHS_SOTHAM_THULY TL
--                                          WHERE
--                                              TL.VUANID = NHANAN.VUANID
--                                      )
--                                                           AND
                                                           NOT EXISTS ( SELECT 'x'
                                                                               FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                            WHERE TL.VUANID = A.ID
                                                                           )
                                                                    OR EXISTS ( SELECT 'x'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                     WHERE TL.VUANID = A.ID
                                                           AND ( V_NGAYTHULY_DEN IS NOT NULL
                                                                 OR TL.NGAYTHULY > VV_NGAYTHULY_DEN )
                                                                              ) 
--                                      AND ( V_NGAYTHULY_TU IS NULL
--                                           OR NHANAN.NGAYNHAN >= VV_NGAYTHULY_TU )
--                                      AND ( V_NGAYTHULY_DEN IS NULL
--                                           OR NHANAN.NGAYNHAN <= VV_NGAYTHULY_DEN )
                                                                               ) ) )
-----
---tuyennh 31/07/2023 sửa tìm kiếm theo tình trạng thụ lý end
                                               AND ( V_SOTHULY IS NULL
                                                     OR ( EXISTS ( SELECT 'x'
                                                                     FROM AHS_SOTHAM_THULY TL
                                                       WHERE TL.VUANID = A.ID
                                                             AND UPPER(TL.SOTHULY) = UPPER(V_SOTHULY)
                                                                 )
                                                          OR EXISTS ( SELECT 'x'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                     WHERE TL.VUANID = A.ID
                                                           AND UPPER(TL.SOTHULY) = UPPER(V_SOTHULY)
                                                                    ) ) )
                                               AND ( V_SO_QD IS NULL
                                                     OR ( EXISTS ( SELECT 'X'
                                                                     FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN QSV
                                                       WHERE UPPER(QSV.SOQUYETDINH) LIKE '%' || V_SO_QD || '%'
                                                             AND A.ID = QSV.VUANID
                                                                 )
                                                          OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN QSV
                                                     WHERE UPPER(QSV.SOQUYETDINH) LIKE '%' || V_SO_QD || '%'
                                                           AND A.ID = QSV.VUANID
                                                                    ) ) )
                                               AND ( V_NGAY_QD IS NULL
                                                     OR ( EXISTS ( SELECT 'X'
                                                                     FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN QSV
                                                       WHERE QSV.NGAYQD = TO_DATE(V_NGAY_QD, 'dd/MM/yyyy')
                                                             AND A.ID = QSV.VUANID
                                                                 )
                                                          OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN QSV
                                                     WHERE QSV.NGAYQD = TO_DATE(V_NGAY_QD, 'dd/MM/yyyy')
                                                           AND A.ID = QSV.VUANID
                                                                    ) ) )    
--KẾT QUẢ GIẢI QUYẾT v_KETQUA
                                               AND ( V_KETQUA IS NULL
                                                     OR ( EXISTS ( SELECT 'X'
                                                                     FROM AHS_KCKNQDK_PHUCTHAM_THULY          PTTL
                                                                     LEFT JOIN AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID = PTTL.VUANID --QUYẾT ĐỊNH 
                                                                     LEFT JOIN DM_KETQUA_PHUCTHAM                  KQPT ON KQPT.ID = PTQDVA.KETQUAID
                                                       WHERE --HP.MAHINHPHAT!='TUHINH' AND
                                                        ( ( V_KETQUA = 1 --Giữ nguyên quyết định/bản án sơ thẩm để...
                        --toancau-tuyennh thêm mã quyết định
                                                                 AND KQPT.MA IN ( '01', '10', '19', '18' ) ) 
                --Tăng hình phạt
                --Giảm hình phạt
                                                               OR ( V_KETQUA = 4 --Hủy quyết định/bản án sơ thẩm để...
                                                                    AND KQPT.MA IN ( '03', '04', '06', '13', '14'
                                                                                   , '12', 
                            --toancau-tuyennh thêm mã quyết định
                                                                                    '21' ) )
                --Sửa phần dân sự
                                                                                    )
                                                             AND ( V_TUNGAY IS NULL
                                                                   OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                             AND ( V_DENNGAY IS NULL
                                                                   OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                             AND PTTL.VUANID = A.ID
                                                                 ) ) )
                                               AND ( V_THAMPHAN_ID IS NULL
                                                     OR ( EXISTS ( SELECT 'X'
                                                                     FROM AHS_THAMPHANGIAIQUYET TP
                                                       WHERE TP.CANBOID = V_THAMPHAN_ID
                                                             AND TP.VUANID = A.ID
                                                                 )
                                                          OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_SOTHAM_HDXX TP
                                                     WHERE TP.CANBOID = V_THAMPHAN_ID
                                                           AND TP.VUANID = A.ID
                                                                    )
                                                          OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_HDXX TP
                                                     WHERE TP.CANBOID = V_THAMPHAN_ID
                                                           AND TP.VUANID = A.ID
                                                                    ) ) )
---tuyennh 26/06/2023 sua tim kiem theo ten tham phan                      
                                               AND ( V_THAMPHAN_ID IS NULL
                                                     OR ( EXISTS ( SELECT TP.VUANID
                                                                                   FROM AHS_THAMPHANGIAIQUYET TP
                                                                                   LEFT JOIN ( SELECT VUANID
                                                                                                    , ID
                                                                                               FROM TABLE ( V_TABLE_HDXX_ST )
                                                                                             )                     HD ON HD.VUANID = TP.VUANID ----anhvh add 08/07/2021 hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                                                                                   LEFT JOIN ( SELECT GG.*
                                                                                                           FROM AHS_THAMPHANGIAIQUYET GG
                                                                                               WHERE EXISTS ( SELECT 'X'
                                                                                                                             FROM TABLE ( V_TABLE_TP ) TP
                                                                                                              WHERE TP.ID = GG.ID
                                                                                                            )
                                                                                             )                     PCTP_GQ ON PCTP_GQ.VUANID = TP.VUANID --lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                                                                   LEFT JOIN DM_CANBO              CBB ON CBB.ID = HD.ID
                                                                                   LEFT JOIN DM_CANBO              CB ON CB.ID = PCTP_GQ.CANBOID
                                                                     WHERE TP.MAVAITRO = 'VTTP_GIAIQUYETSOTHAM'
                                                                           AND TP.VUANID = NHANAN.VUANID
                                                                           AND CBB.ID = V_THAMPHAN_ID
                                                       GROUP BY TP.VUANID
                                                                 ) )
                                                     OR ( EXISTS ( SELECT TP.VUANID
                                                                                   FROM AHS_THAMPHANGIAIQUYET TP
                                                                                   LEFT JOIN ( SELECT VUANID
                                                                                                    , ID
                                                                                               FROM TABLE ( V_TABLE_HDXX_PT )
                                                                                             )                     HD ON HD.VUANID = TP.VUANID
                                                                                   LEFT JOIN ( SELECT GG.*
                                                                                                           FROM AHS_THAMPHANGIAIQUYET GG
                                                                                               WHERE EXISTS ( SELECT 'X'
                                                                                                                             FROM TABLE ( V_TABLE_TP ) TP
                                                                                                              WHERE TP.ID = GG.ID
                                                                                                            )
                                                                                             )                     PCTP_GQ ON PCTP_GQ.VUANID = TP.VUANID --lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                                                                                   LEFT JOIN DM_CANBO              CBB ON CBB.ID = HD.ID
                                                                                   LEFT JOIN DM_CANBO              CB ON CB.ID = PCTP_GQ.CANBOID
                                                                     WHERE TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
                                                                           AND TP.VUANID = A.ID
                                                                           AND CBB.ID = V_THAMPHAN_ID
                                                       GROUP BY TP.VUANID
                                                                 ) ) )                 
---tuyennh 26/06/2023 sua tim kiem theo ten tham phan                      
                                               AND ( V_THUKY_ID IS NULL
                                                     OR ( EXISTS ( SELECT 'X'
                                                                     FROM AHS_SOTHAM_HDXX TP
                                                       WHERE TP.CANBOID = V_THUKY_ID
                                                             AND TP.VUANID = A.ID
                                                                 )
                                                          OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_HDXX TP
                                                     WHERE TP.CANBOID = V_THUKY_ID
                                                           AND TP.VUANID = A.ID
                                                                    )
                                                          OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_THAMPHANGIAIQUYET TSP
                                                     WHERE TSP.THUKYID = V_THUKY_ID
                                                           AND TSP.VUANID = A.ID
                                                                    ) ) )
                                               AND ( VCHECKTK = 0
                                                     OR ( SELECT COUNT(*)
                                                   FROM AHS_THAMPHANGIAIQUYET TP
                                              WHERE TP.VUANID = A.ID
                                                    AND TP.THUKYID = VCHECKTK
                                                    AND TP.MAVAITRO = DECODE(A.MAGIAIDOAN, 2, 'VTTP_GIAIQUYETSOTHAM', 3, 'VTTP_GIAIQUYETPHUCTHAM'
                                                                           , '')
                                                        ) > 0 )
                                               AND ( V_THAMPHAN_ID IS NULL
--TOANCAU-03102023-ANHNT
                                                     OR ( V_VAITRO_THAMPHAN IS NULL
                                                          AND EXISTS ( SELECT 'X'
                                                                   FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                      WHERE TP.DONID = A.ID
                                                            AND TP.CANBOID = V_THAMPHAN_ID
                                                            AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                                                     ) )
                                                     OR ( V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC'
                                                          AND EXISTS ( SELECT 'X'
                                                                   FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                      WHERE TP.DONID = A.ID
                                                            AND TP.MAVAITRO IN ( 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' )
                                                            AND TP.CANBOID = V_THAMPHAN_ID
                                                                     ) )
                                                     OR ( V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA'
                                                          AND EXISTS ( SELECT 'X'
                                                                   FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                      WHERE TP.DONID = A.ID
                                                            AND TP.MAVAITRO IN ( 'THAMPHAN', 'VTTP_GIAIQUYETSOTHAM', 'VTTP_GIAIQUYETPHUCTHAM' )
                                                            AND TP.CANBOID = V_THAMPHAN_ID
                                                            AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                                                     ) )
                                                     OR ( V_VAITRO_THAMPHAN IN ( 'VTTP_GIAIQUYETDON', 'THAMPHANHDXX', 'THAMPHANDUKHUYET' )
                                                          AND EXISTS ( SELECT 'X'
                                                                   FROM TABLE ( V_TABLE_THAMPHAN ) TP
                                                      WHERE TP.DONID = A.ID
                                                            AND TP.MAVAITRO = V_VAITRO_THAMPHAN
                                                            AND TP.CANBOID = V_THAMPHAN_ID
                                                            AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                                                     ) ) )

--////đối với phúc thẩm chỉ cần so sánh ngày thụ lý với ngày hiện tại >90 ngày thì là đã hết hạn
                                               AND ( V_THOIHAN_GQ IS NULL
                                                     OR ( V_THOIHAN_GQ = 1 --Đã hết thời hạn
                                                          AND (
       --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                                                           EXISTS ( SELECT 'X'
                                                                       FROM AHS_VUAN VA
                                                                       INNER JOIN AHS_SOTHAM_THULY          TL ON VA.ID = TL.VUANID
                                                                       LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID = QSV.VUANID
                                                                       LEFT JOIN DM_QD_QUYETDINH           QD ON QD.ID = QSV.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                QDL ON QDL.ID = QD.LOAIID
                                                                       LEFT JOIN AHS_SOTHAM_BANAN          BA ON BA.VUANID = TL.VUANID
                                                        WHERE ( ( BA.ID IS NOT NULL
                                                                  AND ( ( ( BA.NGAYBANAN - TL.NGAYTHULY ) > 45
                                                                          AND VA.LOAITOIPHAMID = 89 )
                                                                        OR ( ( BA.NGAYBANAN - TL.NGAYTHULY ) > 60
                                                                             AND VA.LOAITOIPHAMID = 90 )
                                                                        OR ( ( BA.NGAYBANAN - TL.NGAYTHULY ) > 90
                                                                             AND VA.LOAITOIPHAMID = 91 )
                                                                        OR ( ( BA.NGAYBANAN - TL.NGAYTHULY ) > 120
                                                                             AND VA.LOAITOIPHAMID = 92 ) ) )
                                                                OR ( ( BA.ID IS NULL
                                                                       AND INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0 )
                                                                     AND ( ( ( SYSDATE - TL.NGAYTHULY ) > 45
                                                                             AND VA.LOAITOIPHAMID = 89 )
                                                                           OR ( ( SYSDATE - TL.NGAYTHULY ) > 60
                                                                                AND VA.LOAITOIPHAMID = 90 )
                                                                           OR ( ( SYSDATE - TL.NGAYTHULY ) > 90
                                                                                AND VA.LOAITOIPHAMID = 91 )
                                                                           OR ( ( SYSDATE - TL.NGAYTHULY ) > 120
                                                                                AND VA.LOAITOIPHAMID = 92 ) ) ) )
                --AND TL.ID IS NOT NULL 
                                                              AND VA.ID = NHANAN.VUANID
                                                                       )
         --dùng ngày quyết định đình chỉ vụ án     
                                                                OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_VUAN VA
                                                                 INNER JOIN AHS_SOTHAM_THULY             TL ON VA.ID = TL.VUANID
                                                                 LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID = CT.VUANID
                                                                 LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QSV ON VA.ID = QSV.VUANID
                                                                 LEFT JOIN DM_QD_QUYETDINH              QD ON QD.ID = QSV.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                   QDL ON QDL.ID = QD.LOAIID
                                                     WHERE ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') > 0--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                                               AND ( ( ( QSV.NGAYQD - TL.NGAYTHULY ) > 45
                                                                       AND VA.LOAITOIPHAMID = 89 )
                                                                     OR ( ( QSV.NGAYQD - TL.NGAYTHULY ) > 60
                                                                          AND VA.LOAITOIPHAMID = 90 )
                                                                     OR ( ( QSV.NGAYQD - TL.NGAYTHULY ) > 90
                                                                          AND VA.LOAITOIPHAMID = 91 )
                                                                     OR ( ( QSV.NGAYQD - TL.NGAYTHULY ) > 120
                                                                          AND VA.LOAITOIPHAMID = 92 ) ) )
                                                             OR ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
                                                                  AND ( ( ( SYSDATE - TL.NGAYTHULY ) > 45
                                                                          AND VA.LOAITOIPHAMID = 89 )
                                                                        OR ( ( SYSDATE - TL.NGAYTHULY ) > 60
                                                                             AND VA.LOAITOIPHAMID = 90 )
                                                                        OR ( ( SYSDATE - TL.NGAYTHULY ) > 90
                                                                             AND VA.LOAITOIPHAMID = 91 )
                                                                        OR ( ( SYSDATE - TL.NGAYTHULY ) > 120
                                                                             AND VA.LOAITOIPHAMID = 92 ) ) ) )
              --AND TL.ID IS NOT NULL 
                                                           AND VA.ID = NHANAN.VUANID
                                                                          )
        
         --dùng ngày QĐ phúc thẩm   
                                                                OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_VUAN VA
                                                                 INNER JOIN AHS_KCKNQDK_PHUCTHAM_THULY          TL ON TL.VUANID = VA.ID
                                                                 INNER JOIN AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID = TL.VUANID
                                                                 LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                     WHERE
                 --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                                      ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') > 0
                                                               AND ( PTQDVA.NGAYQD - TL.NGAYTHULY ) > 90 )
                                                             OR ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
                                                                  AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
--                                     AND TL.ID IS NOT NULL 
                                                           AND VA.ID = A.ID
                                                                          ) ) )
                                                     OR ( V_THOIHAN_GQ = 2 --Còn thời hạn dưới 10 ngày
                                                          AND (
       --Sơ thẩm
                                                           EXISTS ( SELECT 'X'
                                                                       FROM AHS_VUAN VA
                                                                       INNER JOIN AHS_SOTHAM_THULY             TL ON VA.ID = TL.VUANID
                                                                       LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.VUANID = VA.ID
                                                                       LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID = CT.VUANID
                                                                       LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QSV ON VA.ID = QSV.VUANID
                                                                       LEFT JOIN DM_QD_QUYETDINH              QD ON QD.ID = QSV.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                   QDL ON QDL.ID = QD.LOAIID
                                                        WHERE ( ( ( SYSDATE - TL.NGAYTHULY ) >= 35
                                                                  AND ( SYSDATE - TL.NGAYTHULY ) < 45
                                                                  AND VA.LOAITOIPHAMID = 89 )
                                                                OR ( ( SYSDATE - TL.NGAYTHULY ) >= 50
                                                                     AND ( SYSDATE - TL.NGAYTHULY ) < 60
                                                                     AND VA.LOAITOIPHAMID = 90 )
                                                                OR ( ( SYSDATE - TL.NGAYTHULY ) >= 80
                                                                     AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                                                     AND VA.LOAITOIPHAMID = 91 )
                                                                OR ( ( SYSDATE - TL.NGAYTHULY ) >= 110
                                                                     AND ( SYSDATE - TL.NGAYTHULY ) < 120
                                                                     AND VA.LOAITOIPHAMID = 92 ) )
                                                              AND BA.ID IS NULL
                                                              AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
                                                                    OR INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') IS NULL )
                                                              AND VA.ID = NHANAN.VUANID
                                                                       ) ) )
                                                     OR ( V_THOIHAN_GQ = 3
                                                          AND (--Còn thời hạn dưới 20 ngày

       --Sơ thẩm
                                                           EXISTS ( SELECT 'X'
                                                                       FROM AHS_VUAN VA
                                                                       INNER JOIN AHS_SOTHAM_THULY             TL ON VA.ID = TL.VUANID
                                                                       LEFT JOIN AHS_SOTHAM_BANAN             BA ON BA.VUANID = VA.ID
                                                                       LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID = CT.VUANID
                                                                       LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN    QSV ON VA.ID = QSV.VUANID
                                                                       LEFT JOIN DM_QD_QUYETDINH              QD ON QD.ID = QSV.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                   QDL ON QDL.ID = QD.LOAIID
                                                        WHERE ( ( ( SYSDATE - TL.NGAYTHULY ) >= 25
                                                                  AND ( SYSDATE - TL.NGAYTHULY ) < 45
                                                                  AND VA.LOAITOIPHAMID = 89 )
                                                                OR ( ( SYSDATE - TL.NGAYTHULY ) >= 40
                                                                     AND ( SYSDATE - TL.NGAYTHULY ) < 60
                                                                     AND VA.LOAITOIPHAMID = 90 )
                                                                OR ( ( SYSDATE - TL.NGAYTHULY ) >= 70
                                                                     AND ( SYSDATE - TL.NGAYTHULY ) < 90
                                                                     AND VA.LOAITOIPHAMID = 91 )
                                                                OR ( ( SYSDATE - TL.NGAYTHULY ) >= 100
                                                                     AND ( SYSDATE - TL.NGAYTHULY ) < 120
                                                                     AND VA.LOAITOIPHAMID = 92 ) )
                                                              AND BA.ID IS NULL
                                                              AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
                                                                    OR INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') IS NULL )
                                                              AND VA.ID = NHANAN.VUANID
                                                                       ) ) ) )  
--BTG bắt tạm giam
                                               AND ( V_QD_TAMGIAM IS NULL
                                                     OR ( V_QD_TAMGIAM = 1
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_VUAN VA
                                                                       INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID = TL.VUANID
                                                                       LEFT JOIN ( SELECT QSV1.VUANID
                                                                                        , DECODE(QSV1.HIEULUCDEN, NULL, SYSDATE, QSV1.HIEULUCDEN) HIEULUCDEN
                                                                                               FROM ( SELECT QSV.*
                                                                                                             FROM AHS_SOTHAM_QUYETDINH_BICAN QSV
                                                                                                             LEFT JOIN DM_QD_QUYETDINH            QD ON QD.ID = QSV.QUYETDINHID
                                                                                                             LEFT JOIN DM_QD_LOAI                 QDL ON QDL.ID = QD.LOAIID
                                                                                                      WHERE INSTR(',BTG,', ',' || QDL.MA || ',') > 0
                                                                                                      ORDER BY NGAYQD DESC
                                                                                                    ) QSV1
                                                                                   WHERE ROWNUM = 1
                                                                                 )                QSV2 ON VA.ID = QSV2.VUANID
                                                        WHERE ( QSV2.HIEULUCDEN - SYSDATE ) < 0
                                                              AND VA.ID = NHANAN.VUANID
                                                                       )
                                                                OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_VUAN VA
                                                                 INNER JOIN AHS_VUAN_GIAIDOAN          VGD ON VA.ID = VGD.VUANID
                                                                 INNER JOIN AHS_KCKNQDK_PHUCTHAM_THULY TL ON VA.ID = TL.VUANID
                                                                 INNER JOIN ( SELECT QSV1.VUANID
                                                                                   , DECODE(QSV1.HIEULUCDEN, NULL, SYSDATE, QSV1.HIEULUCDEN) HIEULUCDEN
                                                                                           FROM ( SELECT QSV.*
                                                                                                         FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN QSV
                                                                                                         LEFT JOIN DM_QD_QUYETDINH                      QD ON QD.ID = QSV.QUYETDINHID
                                                                                                         LEFT JOIN DM_QD_LOAI                           QDL ON QDL.ID = QD.LOAIID
                                                                                                  WHERE INSTR(',BTG,', ',' || QDL.MA || ',') > 0
                                                                                                  ORDER BY NGAYQD DESC
                                                                                                ) QSV1
                                                                              WHERE ROWNUM = 1
                                                                            )                          QSV2 ON VA.ID = QSV2.VUANID
                                                     WHERE ( QSV2.HIEULUCDEN - SYSDATE ) < 0
                                                           AND VA.ID = A.ID
                                                                          ) ) )
--Còn thời hạn dưới 10 ngày  
                                                     OR ( V_QD_TAMGIAM = 2
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_VUAN VA
                                                                       INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID = TL.VUANID
                                                                       LEFT JOIN ( SELECT QSV1.VUANID
                                                                                        , DECODE(QSV1.HIEULUCDEN, NULL, SYSDATE, QSV1.HIEULUCDEN) HIEULUCDEN
                                                                                               FROM ( SELECT QSV.*
                                                                                                             FROM AHS_SOTHAM_QUYETDINH_BICAN QSV
                                                                                                             LEFT JOIN DM_QD_QUYETDINH            QD ON QD.ID = QSV.QUYETDINHID
                                                                                                             LEFT JOIN DM_QD_LOAI                 QDL ON QDL.ID = QD.LOAIID
                                                                                                      WHERE INSTR(',BTG,', ',' || QDL.MA || ',') > 0
                                                                                                      ORDER BY NGAYQD DESC
                                                                                                    ) QSV1
                                                                                   WHERE ROWNUM = 1
                                                                                 )                QSV2 ON VA.ID = QSV2.VUANID
                                                        WHERE ( QSV2.HIEULUCDEN - SYSDATE ) < 10
                                                              AND ( QSV2.HIEULUCDEN - SYSDATE ) > 0
                                                              AND VA.ID = NHANAN.VUANID
                                                                       )
                                                                OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_VUAN VA
                                                                 INNER JOIN AHS_KCKNQDK_PHUCTHAM_THULY TL ON VA.ID = TL.VUANID
                                                                 INNER JOIN ( SELECT QSV1.VUANID
                                                                                   , DECODE(QSV1.HIEULUCDEN, NULL, SYSDATE, QSV1.HIEULUCDEN) HIEULUCDEN
                                                                                           FROM ( SELECT QSV.*
                                                                                                         FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN QSV
                                                                                                         LEFT JOIN DM_QD_QUYETDINH                      QD ON QD.ID = QSV.QUYETDINHID
                                                                                                         LEFT JOIN DM_QD_LOAI                           QDL ON QDL.ID = QD.LOAIID
                                                                                                  WHERE INSTR(',BTG,', ',' || QDL.MA || ',') > 0
                                                                                                  ORDER BY NGAYQD DESC
                                                                                                ) QSV1
                                                                              WHERE ROWNUM = 1
                                                                            )                          QSV2 ON VA.ID = QSV2.VUANID
                                                     WHERE ( QSV2.HIEULUCDEN - SYSDATE ) < 10
                                                           AND ( QSV2.HIEULUCDEN - SYSDATE ) > 0
                                                           AND VA.ID = A.ID
                                                                          ) ) ) )
-----------------v_TINHTRANG_GIAIQUYET
---tuyennh 31/07/2023 sửa tìm kiếm theo tình trạng giải quyết start
                                               AND ( ( V_TINHTRANG_GIAIQUYET IS NULL
                                                       AND ( V_TUNGAY IS NULL
                                                             OR A.NGAYTAO >= VV_TUNGAY )
                                                       AND ( V_DENNGAY IS NULL
                                                             OR A.NGAYTAO <= VV_DENNGAY ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 1 --Chưa giải quyết xong
                                                          AND EXISTS ( SELECT 'x'
                                                                   FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                      WHERE TL.VUANID = A.ID
                                                                     )
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                       LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                        WHERE QD.MA IN ( '46-HS', '51-HS', '52-HS' )
                                                              AND PTQDVA.VUANID = A.ID
                                                              AND A.MAGIAIDOAN = 7
                                                              AND PTQDVA.NGAYQD IS NOT NULL
                                                              AND V_DENNGAY IS NOT NULL
                                                              AND VV_DENNGAY < PTQDVA.NGAYQD
                                                                       )
                                                                OR ( NOT EXISTS ( SELECT 'X'
                                                                             FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                             LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                           WHERE QD.MA IN ( '46-HS', '51-HS', '52-HS' )
                                                                 AND PTQDVA.VUANID = A.ID
                                                                 AND A.MAGIAIDOAN = 7
                                                                                )
                                                                         AND (
                     --chưa phân công thẩm phán
                    --trường hợp có thụ lý nhưng chưa có phân công thẩm phán
                                                                          ( EXISTS ( SELECT 'x'
                                                                           FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                          WHERE TL.VUANID = A.ID
                                                                AND ( V_TUNGAY IS NULL
                                                                      OR TL.NGAYTHULY >= VV_TUNGAY )
                                                                AND ( V_DENNGAY IS NULL
                                                                      OR TL.NGAYTHULY <= VV_DENNGAY )
                                                                                        )
                                                                                 AND NOT EXISTS ( SELECT 'x'
                                                                           FROM AHS_THAMPHANGIAIQUYET PC
                                                          WHERE PC.VUANID = A.ID
                                                                AND PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'--phuc thẩm                                                                                       
                                                                                                ) )
                                                                               OR
                   --trường hợp có thụ lý và đã có phân công thẩm phán  
                                                                                ( EXISTS ( SELECT 'x'
                                                                     FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                       WHERE TL.VUANID = A.ID
                                                                                           )
                                                                                    AND EXISTS ( SELECT 'x'
                                                                   FROM AHS_THAMPHANGIAIQUYET PC
                                                      WHERE PC.VUANID = A.ID
                                                            AND A.MAGIAIDOAN = 7
                                                            AND ( V_DENNGAY IS NOT NULL
                                                                  OR PC.NGAYPHANCONG > VV_DENNGAY )
                                                                                               ) )
                  --đã phân công thẩm phán
                                                                               OR EXISTS ( SELECT 'x'
                                                                 FROM AHS_THAMPHANGIAIQUYET PC
                                                     WHERE PC.VUANID = A.ID
                                                           AND PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'--phuc thẩm
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR PC.NGAYPHANCONG >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                                         )
                  --đã lên lịch xx
                                                                               OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                                                 LEFT JOIN DM_QD_QUYETDINH           QD ON QD.ID = QSV.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                QDL ON QDL.ID = QD.LOAIID
                                                     WHERE INSTR(',DVARXX,', ',' || QDL.MA || ',') > 0 --hoãn phiên tòa
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR QSV.NGAYQD >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR QSV.NGAYQD <= VV_DENNGAY )
                                                           AND QSV.VUANID = NHANAN.VUANID
                                                                                         )
                --Đang hoãn phuc tham                 
                                                                               OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                 LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                     WHERE INSTR(',DVARXX,', ',' || QDL.MA || ',') > 0 --hoãn phiên tòa
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                           AND PTQDVA.VUANID = A.ID
                                                           AND A.MAGIAIDOAN = 7
                                                                                         )
                  --đang hoãn
                                                                               OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                                                 LEFT JOIN DM_QD_QUYETDINH           QD ON QD.ID = QSV.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                QDL ON QDL.ID = QD.LOAIID
                                                     WHERE INSTR(',HPT,', ',' || QDL.MA || ',') > 0 --hoãn phiên tòa
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR QSV.NGAYQD >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR QSV.NGAYQD <= VV_DENNGAY )
                                                           AND QSV.VUANID = NHANAN.VUANID
                                                                                         )
  --Đang hoãn phuc tham                 
                                                                               OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                 LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                     WHERE INSTR(',HPT,', ',' || QDL.MA || ',') > 0 --hoãn phiên tòa
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                           AND PTQDVA.VUANID = A.ID
                                                           AND A.MAGIAIDOAN = 7
                                                                                         )
                  --đang tđc
                                                                               OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                                                 LEFT JOIN DM_QD_QUYETDINH           QD ON QD.ID = QSV.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                QDL ON QDL.ID = QD.LOAIID
                                                     WHERE INSTR(',TDC,', ',' || QDL.MA || ',') > 0 -- 'TDC' Tam dinh chi
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR QSV.NGAYQD >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR QSV.NGAYQD <= VV_DENNGAY )
                                                           AND QSV.VUANID = NHANAN.VUANID
                                                                                         )
 --phuc tham Đang tạm đình chỉ                
                                                                               OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                 LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                 LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                     WHERE INSTR(',TDC,', ',' || QDL.MA || ',') > 0 --Tạm đình chỉ
                                                           AND ( V_TUNGAY IS NULL
                                                                 OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                           AND ( V_DENNGAY IS NULL
                                                                 OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                           AND PTQDVA.VUANID = A.ID
                                                           AND A.MAGIAIDOAN = 7
                                                                                         ) ) ) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 2 --chưa phân công Thẩm phán

                                                          AND (
                     --trường hợp có thụ lý nhưng chưa có phân công thẩm phán

                                                           ( EXISTS ( SELECT 'x'
                                                                           FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                          WHERE TL.VUANID = A.ID
                                                                AND ( V_TUNGAY IS NULL
                                                                      OR TL.NGAYTHULY >= VV_TUNGAY )
                                                                AND ( V_DENNGAY IS NULL
                                                                      OR TL.NGAYTHULY <= VV_DENNGAY )
                                                                         )
                                                                  AND NOT EXISTS ( SELECT 'x'
                                                                           FROM AHS_THAMPHANGIAIQUYET PC
                                                          WHERE PC.VUANID = A.ID
                                                                AND PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'--phuc thẩm                                                                                       
                                                                                 ) )
                                                                OR
                   --trường hợp có thụ lý và đã có phân công thẩm phán  
                                                                 ( EXISTS ( SELECT 'x'
                                                                     FROM AHS_KCKNQDK_PHUCTHAM_THULY TL
                                                       WHERE TL.VUANID = A.ID
                                                                            )
                                                                     AND EXISTS ( SELECT 'x'
                                                                   FROM AHS_THAMPHANGIAIQUYET PC
                                                      WHERE PC.VUANID = A.ID
                                                            AND A.MAGIAIDOAN = 7
                                                            AND ( V_DENNGAY IS NOT NULL
                                                                  OR PC.NGAYPHANCONG > VV_DENNGAY )
                                                                                ) ) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 3 --Đã phân công Thẩm phán
                                                          AND EXISTS ( SELECT 'x'
                                                                   FROM AHS_THAMPHANGIAIQUYET PC
                                                      WHERE PC.VUANID = A.ID
                                                            AND PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'--phuc thẩm
                                                            AND ( V_TUNGAY IS NULL
                                                                  OR PC.NGAYPHANCONG >= VV_TUNGAY )
                                                            AND ( V_DENNGAY IS NULL
                                                                  OR PC.NGAYPHANCONG <= VV_DENNGAY )
                                                                     ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 4 --ĐÃ LÊN LỊCH XÉT XỬ
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                       LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                        WHERE INSTR(',DVARXX,', ',' || QDL.MA || ',') > 0 --hoãn phiên tòa
                                                              AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                              AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                              AND PTQDVA.VUANID = A.ID
                                                              AND A.MAGIAIDOAN = 7) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 5 --Đang hoãn  
                                                          AND ( EXISTS ( SELECT 'X'
                                                                           FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                           LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                           LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                            WHERE INSTR(',HPT,', ',' || QDL.MA || ',') > 0 --hoãn phiên tòa
                                                                                  AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                                  AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                                  AND PTQDVA.VUANID = A.ID
                                                                                  AND A.MAGIAIDOAN = 7 ) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 6 --Đang tạm đình chỉ 
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                       LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                        WHERE INSTR(',TDC,', ',' || QDL.MA || ',') > 0 --Tạm đình chỉ
                                                                              AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                              AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                              AND PTQDVA.VUANID = A.ID
                                                                              AND A.MAGIAIDOAN = 7
                                                                                       ) ) )
------------------------------
                                                     OR ( V_TINHTRANG_GIAIQUYET = 7 --Đã giải quyết xong
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                       LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                        WHERE QD.MA IN ( '46-HS', '51-HS', '52-HS' )
                                                                          AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                          AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                          AND PTQDVA.VUANID = A.ID
                                                                          OR INSTR(',CNTT,', ',' || QDL.MA || ',') > 0 )
                                                                OR EXISTS ( SELECT 'X'
                                                                             FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                             LEFT JOIN AHS_KCKNQDK_PHUCTHAM_THULY          PTTL ON PTTL.VUANID = PTQDVA.VUANID
                                                                             LEFT JOIN AHS_PHUCTHAM_BANAN                  PTBA ON PTBA.VUANID = PTTL.VUANID --BẢN ÁN 
                                                                             LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                             WHERE PTBA.VUANID IS NULL
                                                                                   AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                                   AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                                   AND PTQDVA.VUANID = A.ID
                                                                                   AND QD.KET_THUC = 1 )
                                                                OR EXISTS ( SELECT 'X'
                                                                             FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                             LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                             WHERE QDL.MA in ('DC','CVA','TRAHS')
                                                                                   AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                                   AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                                   AND PTQDVA.VUANID = A.ID ) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 8 --Đã xét xử
                                                          AND ( EXISTS ( SELECT 'X'
                                                                           FROM AHS_SOTHAM_BANAN BA
                                                                            WHERE BA.SOBANAN IS NOT NULL
                                                                              AND ( V_TUNGAY IS NULL OR BA.NGAYBANAN >= VV_TUNGAY )
                                                                              AND ( V_DENNGAY IS NULL OR BA.NGAYBANAN <= VV_DENNGAY )
                                                                              AND BA.VUANID = NHANAN.VUANID )
                                                                OR EXISTS ( SELECT 'X'
                                                                             FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                                                                             LEFT JOIN AHS_KCKNQDK_PHUCTHAM_THULY          PTTL ON PTTL.VUANID = PTQDVA.VUANID
                                                                             LEFT JOIN AHS_PHUCTHAM_BANAN                  PTBA ON PTBA.VUANID = PTTL.VUANID --BẢN ÁN 
                                                                             LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                             WHERE PTBA.VUANID IS NULL
                                                                                   AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                                   AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                                   AND PTQDVA.VUANID = A.ID
                                                                                   AND A.MAGIAIDOAN = 7
                                                                                   AND QD.KET_THUC = 1 ) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 9 --Đình chỉ
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                                                       LEFT JOIN DM_QD_QUYETDINH           QD ON QD.ID = QSV.QUYETDINHID
                                                                       LEFT JOIN DM_QD_LOAI                QDL ON QDL.ID = QD.LOAIID
                                                                        WHERE QDL.MA = 'DC'
                                                                          AND ( V_TUNGAY IS NULL OR QSV.NGAYQD >= VV_TUNGAY )
                                                                          AND ( V_DENNGAY IS NULL OR QSV.NGAYQD <= VV_DENNGAY )
                                                                          AND QSV.VUANID = NHANAN.VUANID )
                                                                OR EXISTS ( SELECT 'X'
                                                                             FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                                                             LEFT JOIN DM_QD_QUYETDINH                     QD ON QD.ID = PTQDVA.QUYETDINHID
                                                                             LEFT JOIN DM_QD_LOAI                          QDL ON QDL.ID = QD.LOAIID
                                                                             WHERE QDL.MA = 'DC'
                                                                                   AND ( V_TUNGAY IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
                                                                                   AND ( V_DENNGAY IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
                                                                                   AND PTQDVA.VUANID = A.ID
                                                                                   AND A.MAGIAIDOAN = 7 ) ) )
                                                     OR ( V_TINHTRANG_GIAIQUYET = 10 --QĐ chuyển vụ án
                                                          AND EXISTS ( SELECT 'x' FROM AHS_CHUYEN_NHAN_AN
                                                                            WHERE TOACHUYENID = V_TOAAN_ID
                                                                              AND VUANID = A.ID
                                                                              AND A.MAGIAIDOAN = 7
                                                                              AND ( V_TUNGAY IS NULL OR NGAYGIAO >= VV_TUNGAY )
                                                                              AND ( V_DENNGAY IS NULL OR NGAYGIAO <= VV_DENNGAY )))
                                                         OR(v_TINHTRANG_GIAIQUYET=11 --QĐ TRẢ HỒ SƠ
                                                          AND EXISTS (  SELECT 'X' FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN QD
                                                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QD.QUYETDINHID 
                                                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                                                        WHERE QDL.MA='TRAHS'
                                                                        AND (V_TUNGAY IS NULL OR  QD.NGAYQD>=VV_TUNGAY)
                                                                        AND (V_DENNGAY IS NULL OR QD.NGAYQD<=VV_DENNGAY)
                                                                        AND QD.VUANID=A.ID AND GD.MAGIAIDOAN =7)))

--check theo loại vị thành niên           
                                               AND ( V_THANHNIEN = 0
                                                     OR ( V_THANHNIEN = 1
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_BICANBICAO BC
                                                        WHERE BC.ISTREVITHANHNIEN = 1
                                                              AND BC.VUANID = A.ID
                                                                       )
                                                                OR EXISTS ( SELECT 'X'
                                                                 FROM AHS_NGUOITHAMGIATOTUNG NTT
                                                     WHERE NTT.ISTREVITHANHNIEN = 1
                                                           AND NTT.VUANID = A.ID
                                                                          ) ) )
                                                     OR ( V_THANHNIEN = 2
                                                          AND ( NOT EXISTS ( SELECT 'X'
                                                                               FROM AHS_BICANBICAO BC
                                                            WHERE BC.ISTREVITHANHNIEN = 1
                                                                  AND BC.VUANID = A.ID
                                                                           )
                                                                    AND NOT EXISTS ( SELECT 'X'
                                                                           FROM AHS_NGUOITHAMGIATOTUNG NTT
                                                          WHERE NTT.ISTREVITHANHNIEN = 1
                                                                AND NTT.VUANID = A.ID
                                                                                   ) ) ) ) 
--check theo loại vị thành niên  end
                                               AND ( V_GDTAOHS = 0
                                                     OR ( V_GDTAOHS = 1
                                                          AND ( A.GDTAOHS = 1 ) )
                                                     OR ( V_GDTAOHS = 2
                                                          AND ( A.GDTAOHS = 2 ) )
                                                     OR ( V_GDTAOHS = 3
                                                          AND ( A.GDTAOHS = 3 ) )
                                                     OR ( V_GDTAOHS = 4
                                                          AND ( A.GDTAOHS IS NULL ) ) ) 
--hieu check theo Hình thức xét xử
---tuyennh 31/07/2023 sửa tìm kiếm theo hình thức xét sử start
                                               AND ( V_HINHTHUCXX = 0
                                                     OR ( V_HINHTHUCXX = 1
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                        WHERE BC.HINHTHUCXETXU = 1
                                                              AND BC.VUANID = A.ID
                                                                       ) ) )
                                                     OR ( V_HINHTHUCXX = 2
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                        WHERE BC.HINHTHUCXETXU = 2
                                                              AND BC.VUANID = A.ID
                                                                       ) ) )
                                                     OR ( V_HINHTHUCXX = 3
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                        WHERE BC.HINHTHUCXETXU = 3
                                                              AND BC.VUANID = A.ID
                                                                       ) ) )
                                                     OR ( V_HINHTHUCXX = 4
                                                          AND ( EXISTS ( SELECT 'X'
                                                                       FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                        WHERE BC.HINHTHUCXETXU = 4
                                                              AND BC.VUANID = A.ID
                                                                       ) ) )
                                                     OR ( V_HINHTHUCXX = 5
                                                          AND ( NOT EXISTS ( SELECT 'X'
                                                                               FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                            WHERE BC.HINHTHUCXETXU = 1
                                                                  AND BC.VUANID = A.ID
                                                                           )
                                                                    AND NOT EXISTS ( SELECT 'X'
                                                                           FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                          WHERE BC.HINHTHUCXETXU = 2
                                                                AND BC.VUANID = A.ID
                                                                                   )
                                                                    AND NOT EXISTS ( SELECT 'X'
                                                                           FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                          WHERE BC.HINHTHUCXETXU = 3
                                                                AND BC.VUANID = A.ID
                                                                                   )
                                                                    AND NOT EXISTS ( SELECT 'X'
                                                                           FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN BC
                                                          WHERE BC.HINHTHUCXETXU = 4
                                                                AND BC.VUANID = A.ID
                                                                                   ) ) ) )
                                            AND ((V_AN_KET_THUC = 1
                                                 AND  (    EXISTS(SELECT 'X' 
                                                                     FROM AHS_VUAN_GIAIDOAN AVGD 
                                                                     WHERE A.ID=AVGD.VUANID 
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
                                                                     FROM AHS_VUAN_GIAIDOAN AVGD 
                                                                     WHERE A.ID=AVGD.VUANID 
                                                                                   AND (
                                                                        (AVGD.MAGIAIDOAN = 2 AND AVGD.TOAANID = V_TOAAN_ID) OR
                                                                        (AVGD.MAGIAIDOAN in (3,7) AND AVGD.TOAPHUCTHAMID = V_TOAAN_ID)
                                                                      )
                                                                       AND AN_DA_KET_THUC = 1
                                                                     )
                                                      )
                                                 )    
                                             OR (V_AN_KET_THUC IS NULL))
--End Check HTXX
---tuyennh 31/07/2023 sửa tìm kiếm theo hình thức xét sử end

                                       ) TT
               WHERE TT.STT >= MININDEX
                     AND TT.STT <= MAXINDEX;
    END AHS_VUAN_GETALLPAGING;
  -- Load quyết định khác để kháng cáo (quyết định không gây kết thúc)

    PROCEDURE DANHSACH_KHANGCAO_QUYETDINHTDC_BICAN (
        VLOAIAN   VARCHAR2
      , VDONID    NUMBER
      , VBICANID  VARCHAR2
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT QD.ID
                                , 'Số: ' || SOQUYETDINH || ' - Ngày ' || TO_CHAR(NGAYQD, 'dd/MM/yyyy') AS TEN
                                              FROM AHS_SOTHAM_QUYETDINH_BICAN QD
                                              INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                                                                                 AND DMQD.KET_THUC = 0
                           WHERE VUANID = VDONID
                                 AND QD.BICANID IN ( SELECT TO_NUMBER(REGEXP_SUBSTR(VBICANID, '[^,]+', 1, LEVEL))
                                                                   FROM DUAL
                                               CONNECT BY
                                                   REGEXP_SUBSTR(VBICANID, '[^,]+', 1, LEVEL) IS NOT NULL
                                                   )
--                               AND ( VBICANID IS NULL 
--                               OR VBICANID = 0
--                                     OR VBICANID = QD.BICANID )
                           ORDER BY TEN;
    END DANHSACH_KHANGCAO_QUYETDINHTDC_BICAN;
    PROCEDURE COUNT_KCKN_TDC (
        VDONID IN NUMBER
      , VOUT   OUT NUMBER
    ) AS
        LCOUNTKC NUMBER;
        LCOUNTKN NUMBER;
    BEGIN
        SELECT COUNT(KC.ID)
        INTO LCOUNTKC
        FROM AHS_SOTHAM_KHANGCAO        KC
        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QD ON QD.ID = KC.SOQDBA
                                                   AND KC.LOAIKHANGCAO = 3
        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN  QDVA ON QDVA.ID = KC.SOQDBA
                                                    AND KC.LOAIKHANGCAO = 2
        LEFT JOIN DM_QD_QUYETDINH            DM ON DM.ID = QD.QUYETDINHID
        LEFT JOIN DM_QD_QUYETDINH            DMVA ON DMVA.ID = QDVA.QUYETDINHID
        WHERE KC.LOAIKHANGCAO IN ( 2, 3 )
              AND NVL(KC.TINHTRANG_GIAIQUYET, 0) = 0
              AND ( DM.MA IN ( '36-HS', '37-HS', '38-HS' )
                    OR DMVA.MA IN ( '36-HS', '37-HS', '38-HS' ) )
              AND KC.VUANID = VDONID;
        SELECT COUNT(KN.ID)
        INTO LCOUNTKN
        FROM AHS_SOTHAM_KHANGNGHI       KN
        LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QD ON QD.ID = KN.BANANID
                                                   AND KN.LOAIKN = 3
        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN  QDVA ON QDVA.ID = KN.BANANID
                                                    AND KN.LOAIKN = 2
        LEFT JOIN DM_QD_QUYETDINH            DM ON DM.ID = QD.QUYETDINHID
        LEFT JOIN DM_QD_QUYETDINH            DMVA ON DMVA.ID = QDVA.QUYETDINHID
        WHERE KN.LOAIKN IN ( 2, 3 )
              AND NVL(KN.TINHTRANG_GIAIQUYET, 0) = 0
              AND ( DM.MA IN ( '36-HS', '37-HS', '38-HS' )
                    OR DMVA.MA IN ( '36-HS', '37-HS', '38-HS' ) )
              AND KN.VUANID = VDONID;
        VOUT := NVL(LCOUNTKC, 0) + NVL(LCOUNTKN, 0);
    END;
   PROCEDURE AHS_PHUCTHAM_THULY_GETBYVUAN (
        VU_AN_ID  IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT A.ID
                                , A.MATHULY
                                , A.SOTHULY
                                , C.TEN TRUONGHOPTHULY
                                , A.NGAYTHULY
                                , A.THOIHANTUNGAY
                                , A.THOIHANDENNGAY
                                , A.ISANDIEM
                                , A.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
                                              FROM AHS_KCKNQDK_PHUCTHAM_THULY A
                                              INNER JOIN ( SELECT ID
                                                                , TEN
                                                           FROM DM_DATAITEM
                                                         ) C ON C.ID = A.TRUONGHOPTHULY
                           WHERE A.VUANID = VU_AN_ID
                           ORDER BY A.NGAYTHULY DESC;
    END AHS_PHUCTHAM_THULY_GETBYVUAN;
    PROCEDURE AHS_PHUCTHAM_THULY_GETMAXTT (
        TOA_AN_ID IN NUMBER
      , TU_NGAY   DATE
      , DEN_NGAY  DATE
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
        VCOUNT NUMBER;
    BEGIN
        SELECT MAX(NVL(T.TT, 0))
        INTO VCOUNT
        FROM AHS_PHUCTHAM_THULY T
        INNER JOIN ( SELECT ID
                                  FROM AHS_VUAN
                     WHERE TOAANID = TOA_AN_ID
                   ) A ON T.VUANID = A.ID
        WHERE ( T.NGAYTHULY BETWEEN TU_NGAY AND DEN_NGAY );
        VCOUNT := NVL(VCOUNT, 0);
        OPEN CURRETURN FOR SELECT VCOUNT COUNTALL
                           FROM DUAL;
    END AHS_PHUCTHAM_THULY_GETMAXTT;
     PROCEDURE AHS_PHUCTHAM_HDXX_GETLIST (
        VVUANID   IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT D.ID
                                , (
                                                  CASE MAVAITRO
                                                      WHEN 'THAMPHAN'         THEN 'Thẩm phán chủ tọa phiên tòa'
                                                      WHEN 'THAMPHANHDXX'     THEN 'Thẩm phán thành viên hội đồng xét xử'
                                                      WHEN 'THAMPHANDUKHUYET' THEN 'Thẩm phán dự khuyết'
                                                      WHEN 'HTND'             THEN 'Hội thẩm nhân dân'
                                                      WHEN 'THAMTRAVIEN'      THEN 'Thẩm tra viên'
                                                      WHEN 'THUKY'            THEN 'Thư ký'
                                                      WHEN 'THUKYDUKHUYET'    THEN 'Thư ký dự khuyết'
                                                      WHEN 'KSV'              THEN 'Kiểm sát viên'
                                                  END
                                              )       AS TENVAITRO
                                , (
                                                  CASE MAVAITRO
                                                      WHEN 'KSV' THEN V.HOTEN
                                                      ELSE C.HOTEN
                                                  END
                                              )       AS TENNGUOITHTT
                                , D.NGAYTHAMGIA
                                , D.NGAYKETTHUC
                                , D.NGAYPHANCONG
                                , D.NGAYNHANPHANCONG
                                , D.NGUOITAO
                                , D.NGAYTAO
                                , D.SOQD
                                , D.NGAYQD
                                , E.HOTEN AS NGUOIPHANCONG
                                , D.TOA_GIAIQUYET_ID -- UPDATE  toa_gq_id
                                , CV.TEN  CHUCVU_NGUOIPC
                                              FROM AHS_KCKNQDK_PHUCTHAM_HDXX D
                                              LEFT JOIN DM_CANBO                  C ON C.ID = D.CANBOID
                                              LEFT JOIN DM_CANBO                  E ON E.ID = D.NGUOIPHANCONGID
                                              LEFT JOIN ( SELECT ID
                                                               , TEN
                                                          FROM DM_DATAITEM
                                                        )                         CV ON CV.ID = E.CHUCVUID
                                              LEFT JOIN DM_CANBOVKS               V ON V.ID = D.CANBOID
                           WHERE D.VUANID = VVUANID
                                 AND ( ( D.MAVAITRO = 'THAMPHAN'
                                         AND NVL(ISTHAYDOI, 0) <> 1 )
                                       OR ( D.MAVAITRO <> 'THAMPHAN'
                                            AND NVL(ISTHAYDOI, 0) <> 1 ) )
                           ORDER BY D.HOTEN;
    END AHS_PHUCTHAM_HDXX_GETLIST;
    PROCEDURE AHS_PT_BICAO_GETALL (
        VU_AN_ID  IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
        VU_AN_ID_ST NUMBER;
    BEGIN
        SELECT VUANID
        INTO VU_AN_ID_ST
        FROM AHS_CHUYEN_NHAN_AN
        WHERE MAP_VUANID_NEW = VU_AN_ID;
        OPEN CURRETURN FOR SELECT ROW_NUMBER()
                                  OVER(
                                                  ORDER BY BC.HOTEN DESC
                                  )
                                , PTBC.BICANID
                                , PTBC.VUANID
                                , BC.HOTEN TENBICAN
                                              FROM AHS_KCKNQDK_PHUCTHAM_BICANBICAO PTBC
                                              INNER JOIN ( SELECT ID
                                                                , HOTEN
                                                                        FROM AHS_BICANBICAO
                                                           WHERE VUANID = VU_AN_ID_ST
                                                         ) BC ON PTBC.BICANID = BC.ID
                           WHERE PTBC.VUANID = VU_AN_ID;
    END AHS_PT_BICAO_GETALL;
    PROCEDURE AHS_BICAN_GETALLBYVUAN (
        VU_AN_ID  IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
        VU_AN_ID_ST NUMBER;
    BEGIN
        SELECT VUANID
        INTO VU_AN_ID_ST
        FROM AHS_CHUYEN_NHAN_AN
        WHERE MAP_VUANID_NEW = VU_AN_ID;
        OPEN CURRETURN FOR SELECT ROW_NUMBER()
                                  OVER(
                               ORDER BY BC.BICANDAUVU DESC, BC.ID--,bc.NgayThamGia desc
                                  )                    STT
                                , BC.ID                BICAOID
                                , BC.HOTEN             TENBICAO
                                , BC.BICANDAUVU
                                , BC.NAMSINH
                                , BC.NGAYTHAMGIA
                                , NVL(PTBC.BICANID, 0) BICANPHUCTHAM_ID
                                , CASE
                               WHEN NVL(KC.NGUOIKCID, 0) > 0 THEN 1
                               WHEN NVL(KC.NGUOIKCID, 0) = 0 THEN 0
                                    END                  ISKHANGCAO
                                , CASE
                               WHEN NVL(PTBC.BICANID, 0) > 0 THEN 1
                               WHEN NVL(PTBC.BICANID, 0) = 0 THEN 0
                                    END                  ISPHUCTHAM
                                , TINH.MA_TEN          TINH
                                , CASE
                               WHEN ( ( BC.TAMTRUCHITIET IS NULL )
                                      OR ( LENGTH(NVL(BC.TAMTRUCHITIET, '')) = 0 ) ) THEN HC.MA_TEN
                               WHEN ( ( BC.TAMTRUCHITIET IS NOT NULL )
                                      AND ( LENGTH(NVL(BC.TAMTRUCHITIET, '')) > 0 ) ) THEN ( BC.TAMTRUCHITIET || ',' || HC.MA_TEN )
                                    END                  DCTAMTRU
                                , BC.TENTOIDANH || DECODE(KC.TINHTRANG, 1, ' (Rút 1 phần Khang cáo)', 2, ' (Rút Kháng cáo)'
                                                          , '')                TENTOIDANH
                           FROM ( SELECT A.ID
                                       , A.MABICAN
                                       , A.HOTEN
                                       , NVL(A.BICANDAUVU, 0) BICANDAUVU
                                       , A.NAMSINH
                                       , A.NGAYTHAMGIA
                                       , A.TAMTRU
                                       , A.TAMTRU_HUYEN
                                       , A.TAMTRUCHITIET
                                       , C.TENTOIDANH
                                         FROM AHS_BICANBICAO A
                                         LEFT JOIN ( SELECT BICANID
                                                          , TENTOIDANH
                                                          , ISMAIN
                                                                 FROM AHS_SOTHAM_CAOTRANG_DIEULUAT
                                                     WHERE VUANID = VU_AN_ID_ST
                                                           AND ISMAIN = 1
                                                   )              C ON A.ID = C.BICANID
                                  WHERE VUANID = VU_AN_ID_ST
                                ) BC
                           LEFT JOIN ( SELECT A.ID
                                            , A.MABICAN
                                            , A.HOTEN
                                            , NVL(A.BICANDAUVU, 0) BICANDAUVU
                                            , A.NAMSINH
                                            , A.NGAYTHAMGIA
                                            , A.TAMTRU
                                            , A.TAMTRU_HUYEN
                                            , A.TAMTRUCHITIET
                                            , C.TENTOIDANH
                                                   FROM AHS_BICANBICAO A
                                                   LEFT JOIN ( SELECT BICANID
                                                                    , TENTOIDANH
                                                                    , ISMAIN
                                                                           FROM AHS_SOTHAM_CAOTRANG_DIEULUAT
                                                               WHERE VUANID = VU_AN_ID_ST
                                                                     AND ISMAIN = 1
                                                             )              C ON A.ID = C.BICANID
                                       WHERE VUANID = VU_AN_ID_ST
                                     ) BCST ON BCST.ID = BC.ID
                           LEFT JOIN ( SELECT D.ID
                                            , D.NGUOIKCID
                                            , D.LOAIKHANGCAO
                                            , R.TINHTRANG
                                                   FROM AHS_SOTHAM_KHANGCAO D
                                                   LEFT JOIN ( SELECT G.KHANGCAOID
                                                                    , G.TINHTRANG
                                                               FROM AHS_SOTHAM_RUTKHANGCAO G
                                                             )                   R ON R.KHANGCAOID = D.ID
                                       WHERE LOAIKHANGCAO IN ( 2, 3 )
                                             AND VUANID = VU_AN_ID_ST
                                     ) KC ON KC.NGUOIKCID = BCST.ID
                           INNER JOIN ( SELECT ID
                                             , TEN
                                             , MA_TEN
                                        FROM DM_HANHCHINH
                                      ) TINH ON TINH.ID = BC.TAMTRU
                           LEFT JOIN ( SELECT ID
                                            , TEN
                                            , MA_TEN
                                       FROM DM_HANHCHINH
                                     ) HC ON HC.ID = BC.TAMTRU_HUYEN
                           LEFT JOIN ( SELECT VUANID
                                            , BICANID
                                                   FROM AHS_KCKNQDK_PHUCTHAM_BICANBICAO
                                       WHERE VUANID = VU_AN_ID
                                     ) PTBC ON PTBC.BICANID = BC.ID;
    END AHS_BICAN_GETALLBYVUAN;
    PROCEDURE GET_CT_TAMGIAM (
        VVUAN_ID       IN VARCHAR2
      , VHIEULUCTUNGAY IN VARCHAR2
      , CURRETURN      OUT SYS_REFCURSOR
    ) AS
        KETQUA      VARCHAR2(100);
        V_NGAYTHULY DATE;
    BEGIN
        SELECT NGAYTHULY
        INTO V_NGAYTHULY
        FROM AHS_KCKNQDK_PHUCTHAM_THULY
        WHERE VUANID = VVUAN_ID;
        KETQUA := 90 - ( TO_DATE ( VHIEULUCTUNGAY, 'dd/MM/yyyy' ) - V_NGAYTHULY );
        OPEN CURRETURN FOR SELECT KETQUA KETQUAS
                           FROM DUAL;
    END GET_CT_TAMGIAM;
    PROCEDURE AHS_GETKCSOTHAM_XULY (
        VVUANID   IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
        LOAINGUOIKN NUMBER DEFAULT 0;
        V_COUNT_KC  NUMBER;
    BEGIN
        OPEN CURRETURN FOR SELECT A.ID
                                , A.TRANG_THAI_ID
                                , A.NGAY_TAO
                                ,
--                               BCKC.HOTEN
--                               || ' - '
--                               || DECODE(BCKC.BICANDAUVU, 0, '(Bị cáo)', 1, '(Bị cáo đầu vụ)',
--                                         '') AS NGUOIKCCAPKN,
                                 DECODE(BCKC.HOTEN, NULL, NGUOITHAMGIA.HOTEN, BCKC.HOTEN) || ' ' || DECODE(BCKC.BICANDAUVU, 0, '(Bị cáo)', 1, '(Bị cáo đầu vụ)'
                                                                                                            , '(' || NGUOITHAMGIA.TEN || ')') || ' - ' || DECODE(BCKC.NAMSINH
                                                                                                                                                                 , NULL
                                                                                                                                                                 , DECODE(NGUOITHAMGIA.NAMSINH, 0, '', NGUOITHAMGIA.NAMSINH)
                                                                                                                                                                 , BCKC.NAMSINH)                                                                                                                                                                                                                                                          AS
                                                                                                                                                                 NGUOIKCCAPKN
                                , '<b>* Ngày kháng cáo: </b>' || TO_CHAR(KC.NGAYKHANGCAO, 'dd/MM/yyyy') || '<br />' || DECODE(KC.LOAIKHANGCAO
                                                                                                                              , 0
                                                                                                                              , '+ Kháng cáo bản án số: ' || BAKC.SOBANAN || ', Ngày: ' || TO_CHAR(BAKC.NGAYBANAN, 'dd/MM/yyyy')
                                                                                                                              , '+ Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy')) || '<br/>' || '+ Yêu cầu: ' || YCKC.YEUCAU
                                                                                                                              || '<br />' || '+ Nội dung: ' || KC.NOIDUNGKHANGCAO || '<br/>' || '+ Biện pháp ngăn chặn: <b>' || DMKC.TEN || '</b> <br/>' || '+ Ngày bắt đầu: '
                                                                                                                              || TO_CHAR(BPKC.NGAYBATDAU, 'dd/MM/yyyy') || '- Ngày kết thúc: ' || TO_CHAR(BPKC.NGAYKETTHUC, 'dd/MM/yyyy') || '<br />' AS NOIDUNG
                                              FROM AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST A
                                              INNER JOIN AHS_SOTHAM_KHANGCAO         KC ON KC.ID = A.KCKN_SOTHAM_ID
                                                                                   AND A.IS_KC = 1
                                              LEFT JOIN AHS_BICANBICAO              BCKC ON KC.NGUOIKCID = BCKC.ID
                                                                               AND BCKC.VUANID = KC.VUANID
                                              LEFT JOIN ( SELECT A.ID
                                                               , A.HOTEN
                                                               , A.NAMSINH
                                                               , DM_DTITEM.TEN
                                                               , A.VUANID
                                                          FROM AHS_NGUOITHAMGIATOTUNG A
                                                          LEFT JOIN ( SELECT A.NGUOIID
                                                                           , A.TUCACHID
                                                                      FROM AHS_NGUOITHAMGIATOTUNG_TUCACH A
                                                                    )                      TC ON TC.NGUOIID = A.ID
                                                          LEFT JOIN ( SELECT A.ID
                                                                           , A.TEN
                                                                      FROM DM_DATAITEM A
                                                                    )                      DM_DTITEM ON DM_DTITEM.ID = TC.TUCACHID
                                                        )                           NGUOITHAMGIA ON NGUOITHAMGIA.ID = KC.NGUOIKCID
                                                                          AND NGUOITHAMGIA.VUANID = KC.VUANID
                                              INNER JOIN ( SELECT T5.KHANGCAOID
                                                                , LISTAGG(T6.TEN || '; ') WITHIN GROUP(
                                                                        ORDER BY T5.KHANGCAOID) YEUCAU
                                                                        FROM AHS_SOTHAM_KHANGCAO_YEUCAU T5
                                                                        INNER JOIN DM_DATAITEM T6 ON T6.ID = T5.YEUCAUID
                                                           GROUP BY T5.KHANGCAOID
                                                         )                           YCKC ON YCKC.KHANGCAOID = KC.ID
                                              LEFT JOIN ( SELECT QD.ID
                                                               , QD.SOQUYETDINH
                                                               , QD.NGAYQD
                                                               , QD.VUANID
                                                               , 0 ISBICAN
                                                                      FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                                          UNION
                                                          SELECT QD.ID
                                                               , QD.SOQUYETDINH
                                                               , QD.NGAYQD
                                                               , QD.VUANID
                                                               , 1 ISBICAN
                                                          FROM AHS_SOTHAM_QUYETDINH_BICAN QD
                                                        )                           QD ON QD.ID = KC.SOQDBA
                                                                AND QD.VUANID = KC.VUANID
                                                                AND KC.LOAIKHANGCAO IN ( 1, 2, 3 ) --> Kháng cáo quyết định
                                              LEFT JOIN AHS_SOTHAM_BANAN            BAKC ON BAKC.ID = KC.SOQDBA
                                                                                 AND KC.LOAIKHANGCAO = 0 --> Kháng cáo bản án
                                              LEFT JOIN AHS_SOTHAM_BIENPHAPNGANCHAN BPKC ON BPKC.VUANID = KC.VUANID
                                                                                            AND BPKC.BICANID = KC.NGUOIKCID  --> Lấy thông tin biện pháp ngăn chặn bị cáo
                                                                                            AND BPKC.NGAYTAO = ( SELECT AHS_SOTHAM_BIENPHAPNGANCHAN.NGAYTAO
                                                                                        FROM AHS_SOTHAM_BIENPHAPNGANCHAN
                                                                   WHERE AHS_SOTHAM_BIENPHAPNGANCHAN.VUANID = KC.VUANID
                                                                         AND AHS_SOTHAM_BIENPHAPNGANCHAN.BICANID = KC.NGUOIKCID
                                                                         AND ROWNUM = 1
                                                                                                               )
                                              LEFT JOIN DM_DATAITEM                 DMKC ON DMKC.ID = BPKC.BIENPHAPNGANCHANID
                           WHERE A.VUANPT_ID = VVUANID
                           ORDER BY NVL(A.TRANG_THAI_ID, 0) ASC
                                  , A.NGAY_TAO DESC;
    END AHS_GETKCSOTHAM_XULY;
    PROCEDURE AHS_GETKNSOTHAM_XULY (
        VVUANID   IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
        LOAINGUOIKN NUMBER DEFAULT 0;
        V_COUNT_KC  NUMBER;
    BEGIN
        OPEN CURRETURN FOR SELECT A.ID
                                , A.TRANG_THAI_ID
                                , A.NGAY_TAO
                                , DECODE(KN.CAPKN, 0, 'Cùng cấp', 'Cấp trên')                                                             AS NGUOIKCCAPKN
                                , CAST('&nbsp;&nbsp;<b>* Ngày kháng nghị: </b>' || TO_CHAR(KN.NGAYKN, 'dd/MM/yyyy') || '<br />' || DECODE(KN.LOAIKN
                                                                                                                                          , 0
                                                                                                                                          , '&nbsp;&nbsp;+ Kháng cáo bản án số: ' || BAKN.SOBANAN || ', Ngày: ' || TO_CHAR(BAKN.NGAYBANAN, 'dd/MM/yyyy')
                                                                                                                                          , '&nbsp;&nbsp;+ Kháng cáo quyết định số: ' || QD.SOQUYETDINH || ', Ngày: ' || TO_CHAR(QD.NGAYQD, 'dd/MM/yyyy')) || '<br/>'
                                                                                                                                          || '&nbsp;&nbsp;+ Yêu cầu: ' || SUBSTR(YCKN.YEUCAU
                                                                                                                                                                                                                                                              , 1
                                                                                                                                                                                                                                                              , LENGTH
                                                                                                                                                                                                                                                              (YCKN.YEUCAU
                                                                                                                                                                                                                                                              ) - 2)
                                                                                                                                                                                                                                                              || '<br />'
                                                                                                                                                                                                                                                              || '&nbsp;&nbsp;+ Nội dung: '
                                                                                                                                                                                                                                                              || KN.NOIDUNGKN
                                                                                                                                                                                                                                                              AS VARCHAR2
                                                                                                                                                                                                                                                              (4000)
                                                                                                                                                                                                                                                              ) AS NOIDUNG
                                              FROM AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST A
                                              INNER JOIN AHS_SOTHAM_KHANGNGHI KN ON KN.ID = A.KCKN_SOTHAM_ID
                                                                                    AND A.IS_KC = 0
                                              INNER JOIN ( SELECT T5.KHANGNGHIID
                                                                , LISTAGG(CAST(T6.TEN || '; ' AS VARCHAR2(4000))) WITHIN GROUP(
                                                                        ORDER BY T5.KHANGNGHIID) YEUCAU
                                                                        FROM AHS_SOTHAM_KHANGNGHI_YEUCAU T5
                                                                        INNER JOIN DM_DATAITEM T6 ON T6.ID = T5.YEUCAUID
                                                           GROUP BY T5.KHANGNGHIID
                                                         )                    YCKN ON YCKN.KHANGNGHIID = KN.ID
                                              LEFT JOIN ( SELECT QD.ID
                                                               , QD.SOQUYETDINH
                                                               , QD.NGAYQD
                                                               , QD.VUANID
                                                               , 0 ISBICAN
                                                                      FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                                          UNION
                                                          SELECT QD.ID
                                                               , QD.SOQUYETDINH
                                                               , QD.NGAYQD
                                                               , QD.VUANID
                                                               , 1 ISBICAN
                                                          FROM AHS_SOTHAM_QUYETDINH_BICAN QD
                                                        )                    QD ON QD.ID = KN.BANANID
                                                                AND QD.VUANID = KN.VUANID
                                                                AND ( ( KN.LOAIKN IN ( 1, 2 )
                                                                        AND QD.ISBICAN = 0 )
                                                                      OR ( KN.LOAIKN = 3
                                                                           AND QD.ISBICAN = 1 ) ) --> Kháng cáo quyết định
                                              LEFT JOIN AHS_SOTHAM_BANAN     BAKN ON BAKN.ID = KN.BANANID
                                                                                 AND KN.LOAIKN = 0 --> Kháng cáo bản án
                           WHERE A.VUANPT_ID = VVUANID
                           ORDER BY NVL(A.TRANG_THAI_ID, 0) ASC
                                  , A.NGAY_TAO DESC;
    END AHS_GETKNSOTHAM_XULY;
-------------LOAD QUYẾT ĐỊNH DGLIST PHÚC THẨM (Quyết định bị can/bị cáo)------------ procedure AHS_PT_QD_BICAN_GETLIST

   PROCEDURE DGLIST_QUYETDINH_BICAN_PTDC (
        VLOAIAN   VARCHAR2
      , VDONID    NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT Q.ID
                                , Q.SOQUYETDINH
                                , Q.NGAYQD
                                , Q.CHUCVU
                                , D.TEN   AS TENQD
                                , C.HOTEN AS NGUOIKY
                                , Q.NGAYTAO
                                , Q.NGUOITAO
                                , BC.HOTEN
                                , Q.TENFILE
                                , Q.HINHPHAT_VUAN_KHAC
                                , Q.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
                                              FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN Q
                                              INNER JOIN AHS_BICANBICAO  BC ON BC.ID = Q.BICANID
                                              LEFT JOIN DM_QD_QUYETDINH D ON D.ID = Q.QUYETDINHID
                                              LEFT JOIN DM_CANBO        C ON C.ID = Q.NGUOIKYID
                           WHERE Q.VUANID = VDONID
                           ORDER BY Q.NGAYQD;
    END DGLIST_QUYETDINH_BICAN_PTDC;
-----------------------------------------------

    PROCEDURE AHS_DM_QUYETDINH_VUAN_PTTDC (
        CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT TEN
                                , ID
                                , MA
                                              FROM DM_QD_QUYETDINH
                           WHERE ISHINHSU = 1
                                 AND ISPHUCTHAM = 1
                                 AND KET_THUC != 1
                                 AND TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
                                 AND LOAIID NOT IN ( 121, 4 ) -- Không load quyết định bắt tạm giam
                           ORDER BY
                               CASE
                                   WHEN MA = '21-HS' THEN '0'
                                   ELSE MA
                               END;
    END AHS_DM_QUYETDINH_VUAN_PTTDC;
-------------LOAD QUYẾT ĐỊNH DGLIST PHÚC THẨM (Quyết định vụ án/vụ việc)------------ procedure %_PT_QD_VUAN_GETLIST, %_PHUCTHAM_QUYETDINH_GETLIST

    PROCEDURE DGLIST_QUYETDINH_PTTDC (
        VLOAIAN   VARCHAR2
      , VDONID    NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT Q.ID
                                , Q.SOQUYETDINH
                                , Q.NGAYQD
                                , Q.CHUCVU
                                , CASE
                                        WHEN INSTR(D.TEN, '03-HS') > 0 THEN DECODE(Q.THAYDOITCTT, 2, D.TEN || ' (' || HTND_PC.HOTEN || ' - ' || HTND_BTHAY.HOTEN || ')', D.TEN || ' (' || TPTK_PC.HOTEN || ' - ' || TPTK_BTHAY.HOTEN || ')')
                                        ELSE D.TEN
                                    END     AS TENQD
                                , C.HOTEN AS NGUOIKY
                                , Q.NGAYTAO
                                , Q.NGUOITAO
                                , Q.HIEULUCTU
                                , Q.HIEULUCDEN
                                , LD.TEN  AS LYDO
                                , Q.TENFILE
                                , Q.TOA_GIAIQUYET_ID -- UPDATE toa_gq_id
                                              FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN Q
                                              LEFT JOIN DM_QD_QUYETDINH_LYDO                LD ON Q.LYDOID = LD.ID
                                              INNER JOIN DM_QD_QUYETDINH                     D ON D.ID = Q.QUYETDINHID
                                                                              AND D.KET_THUC = 0
                                              LEFT JOIN DM_CANBO                            C ON C.ID = Q.NGUOIKYID
                                              LEFT JOIN DM_CANBO                            TPTK_PC ON Q.NGUOIDUOCPHANCONG = TPTK_PC.ID
                                              LEFT JOIN DM_CANBOVKS                         HTND_PC ON Q.NGUOIDUOCPHANCONG = HTND_PC.ID
                                              LEFT JOIN DM_CANBO                            TPTK_BTHAY ON Q.NGUOIBITHAY = TPTK_BTHAY.ID
                                              LEFT JOIN DM_CANBOVKS                         HTND_BTHAY ON Q.NGUOIBITHAY = HTND_BTHAY.ID
                           WHERE Q.VUANID = VDONID
                           ORDER BY Q.NGAYQD;
    END DGLIST_QUYETDINH_PTTDC;
-----------------------------------------------

    PROCEDURE AHS_DM_QUYETDINHKETQUA_VUAN_PTTDC (
        CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT TEN
                                , ID
                                , MA
                                              FROM DM_QD_QUYETDINH
                           WHERE ISHINHSU = 1
                                 AND ISPHUCTHAM = 1
                                 AND KET_THUC = 1
                                 AND MA IN ( '46-HS', '51-HS', '52-HS' )
                           ORDER BY
                               CASE
                                   WHEN MA = '46-HS' THEN '0'
                                   ELSE MA
                               END;
    END AHS_DM_QUYETDINHKETQUA_VUAN_PTTDC;
  PROCEDURE DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC (
        VLOAIAN   VARCHAR2
      , VDONID    NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN    
            --------------------------
        OPEN CURRETURN FOR SELECT Q.ID
                                , Q.SOQUYETDINH
                                , Q.NGAYQD
                                , Q.CHUCVU
                                , Q.TENFILE
                                , Q.FILEID
                                , Q.QUYETDINHID
                                , CASE
                                        WHEN INSTR(D.TEN, '03-HS') > 0 THEN DECODE(Q.THAYDOITCTT, 2, D.TEN || ' (' || HTND_PC.HOTEN || ' - ' || HTND_BTHAY.HOTEN || ')', D.TEN || ' (' || TPTK_PC.HOTEN || ' - ' || TPTK_BTHAY.HOTEN || ')')
                                        ELSE D.TEN
                                    END     AS TENQD
                                , C.HOTEN AS NGUOIKY
                                , Q.NGAYTAO
                                , Q.NGUOITAO
                                , C.ID    AS NGUOIKYID
                                , Q.HIEULUCTU
                                , Q.HIEULUCDEN
                                , LD.TEN  AS LYDO
                                , T.TEN   TENTOAAN
                                , 0       ISBANANST
                                , Q.TOA_GIAIQUYET_ID
                                              FROM AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN Q
                                              LEFT JOIN DM_QD_QUYETDINH_LYDO                LD ON Q.LYDOID = LD.ID
                                              INNER JOIN DM_QD_QUYETDINH                     D ON D.ID = Q.QUYETDINHID
                                                                              AND D.MA IN ( '46-HS', '51-HS', '52-HS' )
                                              LEFT JOIN AHS_FILE                            F ON Q.FILEID = F.ID
                                              LEFT JOIN DM_CANBO                            C ON C.ID = Q.NGUOIKYID
                                              LEFT JOIN DM_TOAAN                            T ON T.ID = Q.DONVIID
                                              LEFT JOIN DM_CANBO                            TPTK_PC ON Q.NGUOIDUOCPHANCONG = TPTK_PC.ID
                                              LEFT JOIN DM_CANBOVKS                         HTND_PC ON Q.NGUOIDUOCPHANCONG = HTND_PC.ID
                                              LEFT JOIN DM_CANBO                            TPTK_BTHAY ON Q.NGUOIBITHAY = TPTK_BTHAY.ID
                                              LEFT JOIN DM_CANBOVKS                         HTND_BTHAY ON Q.NGUOIBITHAY = HTND_BTHAY.ID
                           WHERE Q.VUANID = VDONID
                           ORDER BY Q.NGAYQD;
    END DGLIST_BAQD_QUYETDINH_KETTHUC_PTTDC;

---

    PROCEDURE AHS_SOTHAM_KCAOKNGHI_GETLIST (
        VVUANID   IN NUMBER
      , CURRETURN OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN CURRETURN FOR SELECT D.ID
                                , '1'                                                                                                                                                 AS ISKHANGCAO
                                , 'Kháng cáo'                                                                                                                                         AS KCKNNAME
        --,s.HOTEN as NguoiKCCapKN
                                , DECODE(S.HOTEN, NULL, L.HOTEN, S.HOTEN) || ' ' || DECODE(S.BICANDAUVU, 0, '(Bị cáo)', 1, '(Bị cáo đầu vụ)'
                                                                                           , '(' || L.TEN || ')') || ' - ' || DECODE(S.NAMSINH
                                                                                                                                     , NULL
                                                                                                                                     , DECODE(L.NAMSINH, 0, '', L.NAMSINH)
                                                                                                                                     , S.NAMSINH)                                                                                                                                        AS
                                                                                                                                     NGUOIKCCAPKN
                                , ( SELECT LISTAGG(C.HOTEN, ', ') WITHIN GROUP(
                                                                                            ORDER BY C.ID) AS NGUOIBIKN
                                                                                            FROM AHS_BICANBICAO C
                                                                                        WHERE C.ID IN ( SELECT REGEXP_SUBSTR(D.DSNGUOIBIKC, '[^,]+', 1, LEVEL) IDS
                                                                                                                        FROM DUAL
                                                                                                        CONNECT BY
                                                                                                            REGEXP_SUBSTR(D.DSNGUOIBIKC, '[^,]+', 1, LEVEL) IS NOT NULL
                                                                                                      )
                                    )                                                                                                                                                   AS NGUOIBIKC
                                , (
                                                                                        CASE D.LOAIKHANGCAO
                                                                                            WHEN 0 THEN 'Bản án'
                                                                                            WHEN 1 THEN 'Quyết định'
                                                                                            ELSE 'Quyết định tạm đình chỉ khác'
                                                                                        END
                                                                                    )                                                                                                                                                   AS LOAIKCKN
                                , D.NGAYKHANGCAO                                                                                                                                      AS NGAYKCKN
                                , (
                                                                                        CASE D.LOAIKHANGCAO
                                                                                            WHEN 0 THEN B.SOBANAN
                                                                                            ELSE Q.SOQUYETDINH
                                                                                        END
                                                                                    )                                                                                                                                                   AS SO_QDBA
                                , D.NGAYQDBA                                                                                                                                          AS NGAYQDBA
                                , D.NGUOITAO
                                , D.NGAYTAO
                                , CASE
                                        WHEN D.ISQUAHAN = 1 THEN 'Có'
                                        ELSE 'Không'
                                    END                                                                                                                                                 AS QUAHAN
                                , D.NGUOITAO || ' ' || TO_CHAR(D.NGAYTAO, 'dd/mm/rrrr')                                                                                               AS NGUOITAONGAYTAO
                                , (
                                                                                        CASE D.LOAIKHANGCAO
                                                                                            WHEN 0 THEN B.SOBANAN
                                                                                            ELSE Q.SOQUYETDINH
                                                                                        END
                                                                                    ) || '<br>' || TO_CHAR(D.NGAYQDBA, 'dd/mm/rrrr')                                                                                                    AS SONGAY_BAQD
                                , YCKCKN.TENYEUCAU
                                , D.TENFILE
                                , DECODE(S.ID, NULL, 'Người kháng cáo ' || L.HOTEN || ' kháng cáo ' || D.NOIDUNGKHANGCAO, 'Bị cáo ' || S.HOTEN || ' kháng cáo ' || D.NOIDUNGKHANGCAO) NOIDUNG
                                                                                    FROM AHS_SOTHAM_KHANGCAO D
                                                                                    LEFT JOIN ( SELECT A.ID
                                                                                                     , A.HOTEN
                                                                                                     , A.NAMSINH
                                                                                                     , A.BICANDAUVU
                                                                                                            FROM AHS_BICANBICAO A
                                                                                                WHERE A.VUANID = VVUANID
                                                                                              )                   S ON S.ID = D.NGUOIKCID
                                                                                    LEFT JOIN ( SELECT A.ID
                                                                                                     , A.HOTEN
                                                                                                     , A.NAMSINH
                                                                                                     , DM_DTITEM.TEN
                                                                                                            FROM AHS_NGUOITHAMGIATOTUNG A
                                                                                                            LEFT JOIN ( SELECT A.NGUOIID
                                                                                                                             , A.TUCACHID
                                                                                                                        FROM AHS_NGUOITHAMGIATOTUNG_TUCACH A
                                                                                                                      )                      TC ON TC.NGUOIID = A.ID
                                                                                                            LEFT JOIN ( SELECT A.ID
                                                                                                                             , A.TEN
                                                                                                                        FROM DM_DATAITEM A
                                                                                                                      )                      DM_DTITEM ON DM_DTITEM.ID = TC.TUCACHID
                                                                                                WHERE A.VUANID = VVUANID
                                                                                              )                   L ON L.ID = D.NGUOIKCID
                                                                                    LEFT JOIN ( SELECT E.VUANID
                                                                                                     , E.SOBANAN
                                                                                                     , E.ID
                                                                                                            FROM AHS_SOTHAM_BANAN E
                                                                                                WHERE E.VUANID = VVUANID
                                                                                              )                   B ON B.ID = D.SOQDBA
                                                                                                     AND D.LOAIKHANGCAO = 0
                                                                                    LEFT JOIN ( SELECT F.VUANID
                                                                                                     , F.SOQUYETDINH
                                                                                                     , F.ID
                                                                                                            FROM AHS_SOTHAM_QUYETDINH_VUAN F
                                                                                                WHERE F.VUANID = VVUANID
                                                                                              )                   Q ON Q.ID = D.SOQDBA
                                                                                                     AND D.LOAIKHANGCAO IN ( 1, 2, 3 )
                                                                                    LEFT JOIN ( SELECT KHANGCAOID
                                                                                                     , LISTAGG(DM.TEN, '; ') WITHIN GROUP(
                                                                                                            ORDER BY '') TENYEUCAU
                                                                                                            FROM AHS_SOTHAM_KHANGCAO_YEUCAU YC
                                                                                                            LEFT JOIN ( SELECT ID
                                                                                                                             , TEN
                                                                                                                        FROM DM_DATAITEM
                                                                                                                      )                          DM ON DM.ID = YC.YEUCAUID
                                                                                                GROUP BY KHANGCAOID
                                                                                              )                   YCKCKN ON YCKCKN.KHANGCAOID = D.ID
                                                                 WHERE D.VUANID = VVUANID
                                              UNION
                                              SELECT D.ID
                                                   , '2'                                                   AS ISKHANGCAO
                                                   , 'Kháng nghị'                                          AS KCKNNAME
                                                   , (
                                                  CASE D.CAPKN
                                                      WHEN 0 THEN u'C\00f9ng c\1ea5p'
                                                      ELSE u'C\1ea5p tr\00ean'
                                                  END
                                              )                                                     AS NGUOIKCCAPKN
                                                   , ( SELECT LISTAGG(C.HOTEN, ', ') WITHIN GROUP(
                                                      ORDER BY C.ID) AS NGUOIBIKC
                                                      FROM AHS_BICANBICAO C
                                                  WHERE C.ID IN ( SELECT REGEXP_SUBSTR(D.DSNGUOIBIKN, '[^,]+', 1, LEVEL) IDS
                                                                                  FROM DUAL
                                                                  CONNECT BY
                                                                      REGEXP_SUBSTR(D.DSNGUOIBIKN, '[^,]+', 1, LEVEL) IS NOT NULL
                                                                )
                                                       )                                                     AS NGUOIBIKC
        --,bc.HOTEN  as NguoiBiKC
                                                   , (
                                                  CASE D.LOAIKN
                                                      WHEN 0 THEN 'Bản án'
                                                      WHEN 1 THEN 'Quyết định'
                                                      ELSE 'Quyết định tạm đình chỉ khác'
                                                  END
                                              )                                                     AS LOAIKCKN
                                                   , D.NGAYKN                                              AS NGAYKCKN
                                                   , (
                                                  CASE D.LOAIKN
                                                      WHEN 0 THEN B.SOBANAN
                                                      ELSE Q.SOQUYETDINH
                                                  END
                                              )                                                     AS SO_QDBA
                                                   , D.NGAYBANAN                                           AS NGAYQDBA
                                                   , D.NGUOITAO
                                                   , D.NGAYTAO
                                                   , ''                                                    AS QUAHAN
                                                   , D.NGUOITAO || ' ' || TO_CHAR(D.NGAYTAO, 'dd/mm/rrrr') AS NGUOITAONGAYTAO
                                                   , (
                                                  CASE D.LOAIKN
                                                      WHEN 0 THEN B.SOBANAN
                                                      ELSE Q.SOQUYETDINH
                                                  END
                                              ) || '<br>' || TO_CHAR(D.NGAYBANAN, 'dd/mm/rrrr')     AS SONGAY_BAQD
                                                   , YCKCKN.TENYEUCAU
                                                   , D.TENFILE
                                                   , ( (
                                                  CASE D.CAPKN
                                                      WHEN 0 THEN u'C\00f9ng c\1ea5p'
                                                      ELSE u'C\1ea5p tr\00ean'
                                                  END
                                              ) || ' kháng nghị ' || D.NOIDUNGKN )                  NOIDUNG
                                              FROM AHS_SOTHAM_KHANGNGHI D
                                              LEFT JOIN ( SELECT A.VUANID
                                                               , A.SOBANAN
                                                                      FROM AHS_SOTHAM_BANAN A
                                                          WHERE A.VUANID = VVUANID
                                                        )                    B ON B.VUANID = D.VUANID
                                              LEFT JOIN ( SELECT C.VUANID
                                                               , C.SOQUYETDINH
                                                                      FROM AHS_SOTHAM_QUYETDINH_VUAN C
                                                          WHERE C.VUANID = VVUANID
                                                        )                    Q ON Q.VUANID = D.VUANID
                                              LEFT JOIN ( SELECT KHANGNGHIID
                                                               , LISTAGG(DM.TEN, '; ') WITHIN GROUP(
                                                                      ORDER BY '') TENYEUCAU
                                                                      FROM AHS_SOTHAM_KHANGNGHI_YEUCAU YC
                                                                      LEFT JOIN ( SELECT ID
                                                                                       , TEN
                                                                                  FROM DM_DATAITEM
                                                                                )                           DM ON DM.ID = YC.YEUCAUID
                                                          GROUP BY KHANGNGHIID
                                                        )                    YCKCKN ON YCKCKN.KHANGNGHIID = D.ID
                           WHERE D.VUANID = VVUANID;
    END AHS_SOTHAM_KCAOKNGHI_GETLIST;
END PKG_STPT_AHS_GS;