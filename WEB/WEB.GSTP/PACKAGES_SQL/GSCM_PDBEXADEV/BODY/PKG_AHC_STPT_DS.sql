CREATE OR REPLACE PACKAGE BODY GSCM.PKG_AHC_STPT_DS AS

--PROCEDURE AHC_DON_SEARCH_TURNING
--( 
--    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
--    V_TEN_VU_AN             IN VARCHAR2,
--    V_QHPL                  IN VARCHAR2, 
--    V_MA_VU_AN              IN VARCHAR2, 
--    V_TENDUONGSU            IN VARCHAR2,
--    V_CAPXX                 IN VARCHAR2,
--    V_TOAAN_ID              IN VARCHAR2, 
--    V_TINHTRANG_THULY       IN VARCHAR2,
--    V_NGAYTHULY_TU          IN VARCHAR2, 
--    V_NGAYTHULY_DEN         IN VARCHAR2,
--    V_SOTHULY               IN VARCHAR2,
--    V_THAMPHAN_ID           IN VARCHAR2, 
--    V_TINHTRANG_GIAIQUYET   IN VARCHAR2,
--    V_TUNGAY                IN VARCHAR2,
--    V_DENNGAY               IN VARCHAR2,
--    V_KETQUA                IN VARCHAR2,
--    V_SO_QD                 IN VARCHAR2,
--    V_NGAY_QD               IN VARCHAR2,
--    V_THUKY_ID              IN VARCHAR2, 
--    V_THOIHAN_GQ            IN VARCHAR2, 
--    V_LOAIDON               IN VARCHAR2, 
--    V_PT_RKINHNGHIEM        IN VARCHAR2, 
--    V_GQDON                 IN VARCHAR2, 
--    V_UTTP                  IN VARCHAR2,
--    VCHECKTK                IN NUMBER,
--    V_TRANGTHAIVUAN         IN NUMBER, -- CHƯA DÙNG ĐẾN
--	V_VAITRO_THAMPHAN       IN VARCHAR2,
--
--    V_LOAI_TBTL             IN NUMBER,
--    V_MA_THONG_BAO          IN NUMBER, -- 1 Tim theo ma vu an, 2 tim theo ma thong bao an phi
--    
--	V_CHECK_HOAGIAI         IN NUMBER,--TOANCAU-1-11-2024
--    V_HOAGIAI_TRANGTHAI IN NUMBER DEFAULT NULL,
--    V_HOAGIAI_TUNGAY IN VARCHAR2 DEFAULT NULL,
--    V_HOAGIAI_DENNGAY IN VARCHAR2 DEFAULT NULL,
--    V_AN_KET_THUC           IN NUMBER,
--    PAGE_INDEX              IN INT,
--    PAGE_SIZE               IN INT, 
--    CURRETURN               OUT SYS_REFCURSOR
--)
--IS 
--    SQL_STRING_WITH         CLOB;
--    SQL_STRING_SELECT       CLOB;
--    SQL_STRING_JOIN         CLOB;
--    SQL_STRING_WHERE        CLOB;
--
--    TOTALITEM               NUMBER; 
--    MININDEX                NUMBER; 
--    MAXINDEX                NUMBER; 
--    VV_TUNGAY               VARCHAR(250);
--    VV_DENNGAY              VARCHAR(250); 
--    VV_NGAYTHULY_TU         VARCHAR(250);
--    VV_NGAYTHULY_DEN        VARCHAR(250);
--    VV_HOAGIAI_TUNGAY       VARCHAR(250);--TOANCAU-1-11-2024
--    VV_HOAGIAI_DENNGAY      VARCHAR(250);
--
--    VV_TEN_VU_AN            VARCHAR(250);
--    VV_QHPL                 VARCHAR(250);
--    VV_TENDUONGSU           VARCHAR(250);
--    VV_MA_VU_AN             VARCHAR(250);
--
--BEGIN
--
--     IF(PAGE_INDEX > 0 AND PAGE_SIZE > 0) THEN
--         MININDEX := PAGE_SIZE*(PAGE_INDEX - 1) + 1;
--         MAXINDEX := PAGE_INDEX*PAGE_SIZE ;
--     END IF;
--
--     IF(NVL(LENGTH(V_NGAYTHULY_TU),0) >0) THEN 
--             VV_NGAYTHULY_TU := 'TO_DATE(TRIM('''|| V_NGAYTHULY_TU ||''') ||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';
--         ELSE
--            VV_NGAYTHULY_TU := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
--     END IF;  
--
--     IF(NVL(LENGTH(V_NGAYTHULY_DEN),0) >0) THEN  
--             VV_NGAYTHULY_DEN := 'TO_DATE(TRIM('''|| V_NGAYTHULY_DEN ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
--          ELSE
--             VV_NGAYTHULY_DEN := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
--     END IF;  
--
--     IF(NVL(LENGTH(V_TUNGAY),0) >0) THEN  
--            VV_TUNGAY := 'TO_DATE(TRIM('''|| V_TUNGAY ||''')||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';  
--          ELSE
--             VV_TUNGAY := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
--     END IF;  
--
--     IF(NVL(LENGTH(V_DENNGAY),0) >0) THEN  
--            VV_DENNGAY := 'TO_DATE(TRIM('''|| V_DENNGAY ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
--          ELSE
--             VV_DENNGAY := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
--     END IF; 
--
--     IF(NVL(LENGTH(V_HOAGIAI_TUNGAY),0) >0) THEN  --TOANCAU-1-11-2024
--            VV_HOAGIAI_TUNGAY := 'TO_DATE(TRIM('''|| V_HOAGIAI_TUNGAY ||''')||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';  
--          ELSE
--             VV_HOAGIAI_TUNGAY := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
--     END IF;  
--
--     IF(NVL(LENGTH(V_HOAGIAI_DENNGAY),0) >0) THEN  --TOANCAU-1-11-2024
--            VV_HOAGIAI_DENNGAY := 'TO_DATE(TRIM('''|| V_HOAGIAI_DENNGAY ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
--          ELSE
--             VV_HOAGIAI_DENNGAY := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
--     END IF; 
--
--
--     SQL_STRING_WITH := 
--     '   WITH 
--              V_TABLE_TLST AS (SELECT DISTINCT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC, NGAYTAO DESC) AS ID
--                      FROM  AHC_SOTHAM_THULY
--                      ),
--
--              V_TABLE_TLPT AS (SELECT DISTINCT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) AS ID
--                      FROM  AHC_PHUCTHAM_THULY
--                      ),  
--
--              V_TABLE_THAMPHAN_GIAIQUYET AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
--                                   FROM (SELECT TP.MAVAITRO,TP.DONID,TP.ID,TP.CANBOID, ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,(CASE WHEN TP.MAVAITRO IN( ''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETDON'') THEN 2 WHEN TP.MAVAITRO=''VTTP_GIAIQUYETPHUCTHAM'' THEN 3 END) MAGIAIDOAN
--                                          FROM AHC_DON_THAMPHAN TP) TP
--                                    WHERE TP.ROWNUMBER = 1
--                                    ),
--
--              V_TABLE_THAMPHAN_HDXX_ST AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
--                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,2 MAGIAIDOAN
--                                          FROM  AHC_SOTHAM_HDXX TP
--                                          WHERE MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
--                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
--                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
--                                    ),
--
--              V_TABLE_THAMPHAN_HDXX_PT AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
--                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,3 MAGIAIDOAN
--                                          FROM  AHC_PHUCTHAM_HDXX TP
--                                          WHERE MAVAITRO IN(''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
--                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
--                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
--                                    ),
--
--                V_TABLE_BC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
--                               FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
--                                     FROM AHC_DON_DUONGSU WHERE ISDAIDIEN=0) BC 
--                               WHERE BC.ROWNUMBER <= 3),
--
--                V_TABLE_BC_KC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
--                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
--                                        FROM AHC_DON_DUONGSU DS
--                                        WHERE EXISTS(SELECT 1 FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID))BC 
--                                  WHERE BC.ROWNUMBER <=3)
--        ';  
--
--    SQL_STRING_SELECT := 
--    '    SELECT DISTINCT A.ID,
--                A.MAVUVIEC,
--                A.TENVUVIEC,
--                A.SOTHUTU,
--                A.NGAYNHANDON,
--                A.HINHTHUCNHANDON,
--                A.MAGIAIDOAN,
--                A.QHPLTKID,
--                A.TOAANID,
--                I.TEN AS QUANHEPL,
--                STBA.BANAN_QD_ST,
--                '''' AS QD_PT,-- thêm trường QD_PT mặc định trống
--                STKN.KHANGNGHI_ST,
--                (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
--                (BC3.HOTEN||BC2.HOTEN) HOTENBICAN,
--
--                A.NGUOITAO A_NGUOITAO,
--                GD.MAGIAIDOAN GD_MAGIAIDOAN,
--                GN.NGUOITAO_PHUCTHAM GN_NGUOITAO_PHUCTHAM,
--
--                A.NGAYTAO AS A_NGAYTAO,
--                GN.NGAYTAO_PHUCTHAM GN_NGAYTAO_PHUCTHAM,
--                T.TEN T_TEN,
--
--                A.HINHTHUCNHANDON A_HINHTHUCNHANDON,
--                GN.TRUONGHOPGIAONHAN GN_TRUONGHOPGIAONHAN,
--
--                A.ID A_ID,
--
--                XLD.LOAIGIAIQUYET XLD_LOAIGIAIQUYET,
--                TLS.TINHTRANG_GQ TLS_TINHTRANG_GQ,
--                TLPT.TINHTRANG_GQ TLPT_TINHTRANG_GQ,
--                TPPC.TINHTRANG_GQ TPPC_TINHTRANG_GQ,
--                TPPCPT.TINHTRANG_GQ TPPCPT_TINHTRANG_GQ,
--                QDST.TINHTRANG_GQ QDST_TINHTRANG_GQ,
--                QDPT.TINHTRANG_GQ QDPT_TINHTRANG_GQ,
--                BAST.TINHTRANG_GQ BAST_TINHTRANG_GQ,
--                BAPT.TINHTRANG_GQ BAPT_TINHTRANG_GQ,
--                GNST.TINHTRANG_GQ GNST_TINHTRANG_GQ,
--                A.VUANGOCID A_VUANGOCID,
--                A.IS_TACHAN A_IS_TACHAN,
--
--                BA.ID BA_ID,
--                QD.ID QD_ID
--
--      FROM AHC_DON A 
--     ';
--
--     SQL_STRING_JOIN := 
--     '    INNER JOIN (SELECT G.* 
--                      FROM AHC_DON_GIAIDOAN G 
--                      WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = '|| V_TOAAN_ID ||') 
--                             OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
--                      ) GD ON A.ID=GD.DONID 
--
--          LEFT JOIN AHC_ANPHI AI ON A.ID=AI.DONID
--
--          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC=6
--
--          LEFT JOIN DM_DATAITEM I ON A.QUANHEPHAPLUATID=I.ID
--
--          LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--
--          -- lấy thông tin vụ án end  
--          LEFT JOIN (SELECT PTBA.* 
--                     FROM AHC_PHUCTHAM_BANAN PTBA 
--                     WHERE  PTBA.SOBANAN IS NOT NULL
--                     ) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
--
--          LEFT JOIN (SELECT PTQDVA.* 
--                     FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
--                         LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
--                         LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                     WHERE  INSTR('',DC,'','',''||QDL.MA||'','') > 0
--                     ) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN = 3 
--
--          -- Lay ra trang thai giai quyet don
--          LEFT JOIN (SELECT DONID, LOAIGIAIQUYET, NGAYGQ_YC 
--                     FROM AHC_DON_XULY 
--                     WHERE LOAIGIAIQUYET IN (1,5)
--                     ) XLD ON A.ID = XLD.DONID
--
--          --Trạng thái giải quyết trong danh sách
--          LEFT JOIN (SELECT T2.DONID, T2.TOAANID, T2.NGAYTHULY, T2.SOTHULY, T2.TRUONGHOPTHULY,  T2.SOTHONGBAO,
--                            T2.QHPLTKID, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
--                     FROM AHC_SOTHAM_THULY T2
--                     WHERE EXISTS(SELECT 1 
--                                  FROM V_TABLE_TLST QDL 
--                                  WHERE QDL.ID = T2.ID)
--                     ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2 --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
--
--          LEFT JOIN (SELECT T2.DONID, T2.NGAYTHULY, T2.SOTHULY,   T2.SOTHONGBAO,
--                            T2.TRUONGHOPTHULY, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) || ''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
--                     FROM AHC_PHUCTHAM_THULY T2
--                     WHERE EXISTS(SELECT 1 
--                                  FROM V_TABLE_TLPT QDL 
--                                  WHERE QDL.ID = T2.ID) --> Lấy thụ lý mới nhất
--                     ) TLPT ON TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 3 
--
--          LEFT JOIN (SELECT TP.DONID, ''</br>- Thẩm phán: <b>'' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || ''</b><i> (chủ tọa)</i>'' TINHTRANG_GQ
--                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP
--                         LEFT JOIN (SELECT HDXX.CANBOID, HDXX.DONID 
--                                    FROM V_TABLE_THAMPHAN_HDXX_ST HDXX
--                                    WHERE HDXX.MAVAITRO = ''THAMPHAN''
--                                    ) HDXX ON HDXX.DONID = TP.DONID 
--                         LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID  
--					     LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
--                     WHERE TP.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM''
--                     )TPPC ON TPPC.DONID = A.ID AND GD.MAGIAIDOAN = 2 
--
--          LEFT JOIN (SELECT TP.DONID,''</br>- Thẩm phán: <b>'' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || ''</b><i> (chủ tọa)</i>'' TINHTRANG_GQ
--                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP
--                        LEFT JOIN (SELECT HDXX.CANBOID, HDXX.DONID
--                                   FROM V_TABLE_THAMPHAN_HDXX_PT HDXX
--                                   WHERE HDXX.MAVAITRO = ''THAMPHAN''
--                                   ) HDXX ON HDXX.DONID = TP.DONID
--                        LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID 
--                        LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID 
--                     WHERE TP.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM''
--                     )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3                 
--
--        LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI || '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
--                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
--                   FROM AHC_SOTHAM_QUYETDINH QSV
--                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID
----                       INNER JOIN (SELECT ID, 
----                                          DECODE(MA,''TDC'', ''TĐC'',
----                                                    ''DC'', ''ĐC'',
----                                                    ''HPT'', ''HPT'',
----                                                    ''CNTT'', ''CNTT'',
----                                                    ''CVA'', ''CVA'',
----                                                    '''') MA
----                                                    FROM DM_QD_LOAI) DMQDLOAI ON DMQDLOAI.ID = DMQD.LOAIID
--                    GROUP BY QSV.DONID
--                    ) QDST ON QDST.DONID = A.ID AND GD.MAGIAIDOAN=2
--
--        LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI|| '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
--                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
--                   FROM AHC_PHUCTHAM_QUYETDINH QSV
--                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID
----                       INNER JOIN (SELECT ID, 
----                                          DECODE(MA,''TDC'', ''TĐC'',
----                                                    ''DC'', ''ĐC'',
----                                                    ''HPT'', ''HPT'',
----                                                    ''CVA'', ''CVA'',
----                                                    '''') MA
----                                                    FROM DM_QD_LOAI) DMQDLOAI ON DMQDLOAI.ID = DMQD.LOAIID
--                    GROUP BY QSV.DONID
--                    ) QDPT ON QDPT.DONID = A.ID AND GD.MAGIAIDOAN=3    
--
--          LEFT JOIN (SELECT BA.DONID,''</br>- Bản án số: ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
--                     FROM AHC_SOTHAM_BANAN BA
--                     WHERE  BA.SOBANAN IS NOT NULL
--                     )BAST ON  BAST.DONID=A.ID AND GD.MAGIAIDOAN=2      
--
--          LEFT JOIN (SELECT PTBA.DONID,''</br>- Bản án số: ''||PTBA.SOBANAN||'' ngày ''||TO_CHAR(PTBA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
--                     FROM AHC_PHUCTHAM_BANAN PTBA 
--                     WHERE  PTBA.SOBANAN IS NOT NULL
--                     )BAPT ON  BAPT.DONID=A.ID AND GD.MAGIAIDOAN=3  
--
--
--         --trường hợp giao nhận add vào cột trạng thái     
--         --sửa check đã chuyển lại án sơ thẩm     
--         LEFT JOIN (SELECT CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
--                    FROM(SELECT CA.ID, CA.VUANID, CA.TOACHUYENID, ''</br>- '' || I.TEN || ''</br>- Đã chuyển vụ án'' TINHTRANG_GQ,
--                                ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN
--                            FROM AHC_CHUYEN_NHAN_AN CA
--                                INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
--                            WHERE CA.TOACHUYENID = '|| V_TOAAN_ID ||') CNA
--                    WHERE CNA.RN = 1 AND NOT EXISTS (SELECT 1 
--                                                     FROM AHC_CHUYEN_NHAN_AN CN1
--                                                         JOIN AHC_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
--                                                     WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = '|| V_TOAAN_ID ||' AND CN2.ID > CNA.ID )
--                    )GNST ON  GNST.VUANID=A.ID AND GD.MAGIAIDOAN=2               
--
--           --trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,I.TEN TRUONGHOPGIAONHAN, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM 
--                      FROM DM_DATAITEM I 
--                          INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=I.ID 
--                      WHERE CA.TOANHANID='|| V_TOAAN_ID ||' AND NOT EXISTS (SELECT 1 FROM AHC_DON WHERE ID =NVL(CA.MAP_VUANID_NEW ,0) AND MAGIAIDOAN = 7)                      )GN ON  GN.VUANID=A.ID
--
--            --bị cáo lấy cho sơ thẩm
--            LEFT JOIN (SELECT BC.DONID, ''<br /><i>Đương sự khác:</i> <br />''|| LISTAGG (BC.TENDUONGSU||'' ''|| DECODE(BC.TUCACHTOTUNG_MA,''NGUYENDON'',''(Nguyên đơn)'',''BIDON'',''(Bị đơn)'',''QUYENNVLQ'',''(Người có quyền và NVLQ)'','' (''||BC.TUCACHTOTUNG_MA || '')'' ), ''<br/>'') WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                       FROM V_TABLE_BC BC
--                       GROUP BY BC.DONID
--                       )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
--
--            ------bị cáo kháng cáo lấy cho phúc thẩm    
--            LEFT JOIN (SELECT BC.DONID,''<br /><i>Người kháng cáo:</i> <br />''|| LISTAGG (BC.TENDUONGSU||'' ''|| DECODE(BC.TUCACHTOTUNG_MA,''NGUYENDON'',''(Nguyên đơn)'',''BIDON'',''(Bị đơn)'',''QUYENNVLQ'',''(Người có quyền và NVLQ)'','' (''||BC.TUCACHTOTUNG_MA || '')'' ), ''<br/>'') WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                       FROM V_TABLE_BC_KC BC
--                       GROUP BY BC.DONID
--                      )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3
--
--            ----- lấy thông tin BA/sơ thẩm                
--            LEFT JOIN(SELECT BA.DONID,''<br />BA/QĐ sơ thẩm: <b>''||''Số ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'')||''</b>'' BANAN_QD_ST FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
--            ------- lấy thông tin số ngày kháng nghị
--            LEFT JOIN (SELECT KN.DONID, ''<br /><i>Kháng nghị:</i> <br />''|| LISTAGG (''Số ''||KN.SOKN||'' ngày ''||TO_CHAR(KN.NGAYKN,''dd/MM/yyyy''), ''<br/>'') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
--                       FROM  AHC_SOTHAM_KHANGNGHI KN
--                       WHERE KN.TINHTRANG_GIAIQUYET != 3
--                       GROUP BY KN.DONID
--                      )STKN ON STKN.DONID=A.ID
--
--
--        ----TOANCAU-1-11-2024
--        LEFT JOIN HOAGIAI_DON HGD ON HGD.VUVIECID = A.ID AND HGD.LOAIANID = 6                      
--        LEFT JOIN (SELECT TP.THAMPHANID,TP.HOAGIAIID,TP.ID,TP.NGAYPHANCONG,''<br/><i>Thẩm phán hoà giải:</i> <b>''|| CB.HOTEN||''</b>'' THAMPHANHG
--                    FROM (SELECT ID,THAMPHANID,HOAGIAIID,NGAYPHANCONG,ROW_NUMBER() OVER (PARTITION BY HOAGIAIID ORDER BY NGAYPHANCONG DESC) RN
--                        FROM HOAGIAI_THAMPHAN WHERE THAMPHANID IS NOT NULL)TP
--                        JOIN DM_CANBO CB ON CB.ID = TP.THAMPHANID
--                    WHERE ( '||NVL(V_THAMPHAN_ID,'''''')||' IS NOT NULL AND '||NVL(V_THAMPHAN_ID,'''''')||' = TP.THAMPHANID )
--                                          OR( '||NVL(V_THAMPHAN_ID,'''''')||' IS NULL and RN=1)) TPHG ON HGD.ID = TPHG.HOAGIAIID   
--     ';
--
--     --Bỏ án pt tđc
--     SQL_STRING_WHERE := ' WHERE A.MAGIAIDOAN != 7 ';  
--
--     --Tên vụ án
----     IF(NVL(LENGTH(V_TEN_VU_AN),0) > 0) THEN
----        VV_TEN_VU_AN := FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN));
----        SQL_STRING_WHERE := SQL_STRING_WHERE || 
----            ' AND ( CONTAINS(A.TENVUVIEC, '''|| VV_TEN_VU_AN ||''') > 0
----            )'    
----        ;
----     END IF;
--     IF(NVL(LENGTH(V_TEN_VU_AN),0) > 0) THEN
--        VV_TEN_VU_AN := FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN));
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE ''%'|| VV_TEN_VU_AN ||'%''  
--            )'        
--            ;
--     END IF;
--
--     --Ủy thác tư pháp
--     IF(NVL(LENGTH(V_UTTP),0) > 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND (EXISTS (SELECT 1 
--                           FROM AHC_SOTHAM_THULY TL  
--                           WHERE TL.UTTPDI = ' || TO_NUMBER(V_UTTP) || ' AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2)    
--                   OR  EXISTS (SELECT 1 
--                               FROM AHC_PHUCTHAM_THULY TLPT 
--                               WHERE TLPT.UTTPDI = ' || TO_NUMBER(V_UTTP) || ' AND TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 3)   
--
--                   )'
--        ;
--     END IF;
--
--     --Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
----     IF(NVL(LENGTH(V_QHPL),0) > 0) THEN
----        VV_QHPL := FN_CONVERT_TO_VN(LOWER(V_QHPL));
----        SQL_STRING_WHERE := SQL_STRING_WHERE || 
----            ' AND (CONTAINS(A.TENVUVIEC, '''|| VV_QHPL ||''') > 0
----                  )'
----        ;
----     END IF;  
--     IF(NVL(LENGTH(V_QHPL),0) > 0) THEN
--        VV_QHPL := FN_CONVERT_TO_VN(LOWER(V_QHPL));
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND ( A.FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE ''%'|| VV_QHPL ||'%''  
--                  )'
--        ;
--     END IF;
--
--     --Mã vụ việc
--     IF(V_MA_THONG_BAO = 1) THEN
--        VV_MA_VU_AN := FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN));
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND (LOWER(A.MAVUVIEC) LIKE '''|| VV_MA_VU_AN ||'%''  
--                  )'
--        ;
--     END IF;    
--
--     IF(V_MA_THONG_BAO = 2) THEN
--     VV_MA_VU_AN := FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN));
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND ( LOWER(TT.MA_THONGBAO) LIKE ''%'|| VV_MA_VU_AN ||'%''  
--            )'        
--            ;
--     END IF;
--
--     --Tên đương sự
----     IF(NVL(LENGTH(V_TENDUONGSU),0) > 0) THEN
----        VV_TENDUONGSU   := FN_CONVERT_TO_VN(LOWER(V_TENDUONGSU));
----        SQL_STRING_WHERE := SQL_STRING_WHERE || 
----            ' AND (EXISTS (SELECT 1 
----                           FROM AHC_DON_DUONGSU DS 
----                           WHERE CONTAINS(DS.TENDUONGSU, '''|| VV_TENDUONGSU ||''') > 0 AND DS.DONID = A.ID)
----                  )'
----        ;
----     END IF; 
--     IF(NVL(LENGTH(V_TENDUONGSU),0) > 0) THEN
--        VV_TENDUONGSU   := FN_CONVERT_TO_VN(LOWER(V_TENDUONGSU));
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND (EXISTS (SELECT 1 
--                           FROM AHC_DON_DUONGSU DS 
--                           WHERE FN_CONVERT_TO_VN(LOWER(DS.TENDUONGSU)) LIKE ''%'|| VV_TENDUONGSU ||'%'' AND DS.DONID = A.ID)
--                  )'
--        ;
--     END IF;
--
--     --Cấp xét xử
--     IF(NVL(LENGTH(V_CAPXX),0) > 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND (GD.MAGIAIDOAN= '|| V_CAPXX ||'
--                  )'
--        ;
--     END IF;
--
--     --Tòa án
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND ( (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPTINH'')) 
--                 OR (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPCAO'' AND T.LOAITOA != ''CAPHUYEN''))
--                  )'
--        ;
--     IF(V_CHECK_HOAGIAI > 0) THEN
--     --Thêm tìm kiếm đơn theo trạng thái hòa giải        
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--             ' AND ( (NVL('|| V_CHECK_HOAGIAI ||',0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) 
--                      OR ('|| V_CHECK_HOAGIAI ||' > 0 AND A.HOAGIAI_TRANGTHAI > 0)
--                   )'
--        ;
--     END IF;
--
--     --Thẩm phán và vai trò thẩm phán
--     IF(NVL(TO_NUMBER(V_THAMPHAN_ID),0) > 0) THEN
--            IF(NVL(LENGTH(V_VAITRO_THAMPHAN),0) = 0) THEN
--                    SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                        ' AND EXISTS(SELECT 1 
--                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
--                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
--                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     UNION
--                                     SELECT 1 
--                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
--                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
--                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     UNION
--                                     SELECT 1 
--                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
--                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
--                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     )'
--                    ;
--                ELSIF (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC') THEN
--                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
--                        ' AND EXISTS (SELECT 1 
--                                      FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
--                                      WHERE TP.DONID = A.ID AND TP.MAVAITRO IN (''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETPHUCTHAM'') 
--                                      AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
--                                      )'
--                    ;
--                ELSIF (V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA') THEN
--                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
--                        ' AND EXISTS(SELECT 1
--                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
--                                     WHERE TP.DONID = A.ID 
--                                           AND TP.MAVAITRO IN (''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETPHUCTHAM'')
--                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     UNION
--                                     SELECT 1
--                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
--                                     WHERE TP.DONID = A.ID 
--                                           AND TP.MAVAITRO IN (''THAMPHAN'')
--                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     UNION
--                                     SELECT 1
--                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
--                                     WHERE TP.DONID = A.ID 
--                                           AND TP.MAVAITRO IN (''THAMPHAN'')
--                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     )'
--                    ;
--                ELSIF (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETDON') THEN
--                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
--                         'AND EXISTS(SELECT 1 
--                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
--                                     WHERE TP.DONID = A.ID AND TP.MAVAITRO = '''|| V_VAITRO_THAMPHAN ||''' 
--                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
--                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     )'
--                    ;
--                ELSIF (V_VAITRO_THAMPHAN IN ('THAMPHANHDXX','THAMPHANDUKHUYET')) THEN
--                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
--                         'AND EXISTS(SELECT 1 
--                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
--                                     WHERE TP.DONID = A.ID AND TP.MAVAITRO = '''|| V_VAITRO_THAMPHAN ||''' 
--                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
--                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     UNION
--                                     SELECT 1
--                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
--                                     WHERE TP.DONID = A.ID 
--                                           AND TP.MAVAITRO IN (''THAMPHAN'')
--                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
--                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
--                                     )'
--                    ;
--            END IF;
--     END IF;
--
--     --Thư ký
--     IF(NVL(LENGTH(V_THUKY_ID),0) > 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            'AND (EXISTS(SELECT 1 
--                         FROM AHC_SOTHAM_HDXX TP 
--                         WHERE TP.CANBOID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID) 
--                  OR EXISTS(SELECT 1 
--                            FROM AHC_PHUCTHAM_HDXX TP 
--                            WHERE TP.CANBOID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID)
--                  OR EXISTS(SELECT 1 
--                            FROM AHC_DON_THAMPHAN TP 
--                            WHERE TP.THUKYID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID) 
--                  )'
--        ;
--     END IF;     
--
--     --Loại đơn
--     IF(NVL(LENGTH(V_LOAIDON),0) > 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND (A.LOAIDON = '|| V_LOAIDON || '
--                  )'
--        ;
--     END IF;
--
--     --Giải quyết đơn;
--     IF(NVL(LENGTH(V_GQDON),0) > 0) THEN
--        IF(V_GQDON IN (1,3,4,5)) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                    ' AND EXISTS (SELECT 1 
--                                  FROM AHC_DON_XULY XL 
--                                  WHERE XL.LOAIGIAIQUYET = '|| V_GQDON ||' AND XL.DONID = A.ID) '
--                ;
--            ELSIF(V_GQDON = 6) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                    ' AND NOT EXISTS (SELECT 1 
--                                      FROM AHC_DON_XULY XL 
--                                      WHERE XL.DONID = A.ID) '
--                ;
--            ELSIF(V_GQDON = 7) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                    ' AND NOT EXISTS (SELECT 1 
--                                      FROM AHC_DON_XULY XL 
--                                      WHERE XL.DONID=A.ID) 
--                      AND (SYSDATE-A.NGAYNHANDON) > 15 '
--                ;
--            ELSIF(V_GQDON = 8) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                    ' AND NOT EXISTS(SELECT 1 
--                                     FROM AHC_DON_XULY XL 
--                                     WHERE XL.DONID = A.ID)
--                      AND NOT EXISTS(SELECT 1 
--                                     FROM AHC_DON_THAMPHAN TP 
--                                     WHERE TP.DONID = A.ID) '
--                ;
--        END IF;
--     END IF;
--
--     IF(VCHECKTK != 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND EXISTS(
--                    (SELECT 1 
--                    FROM AHC_DON_THAMPHAN TP 
--                    WHERE TP.DONID = A.ID AND TP.THUKYID = '|| VCHECKTK ||'
--                                          AND TP.MAVAITRO = DECODE(A.MAGIAIDOAN,2,''VTTP_GIAIQUYETSOTHAM'',3,''VTTP_GIAIQUYETPHUCTHAM'','''') 
--                    )
--                   )'
--        ;
--     END IF;    
--
--     --Số BA/QĐ             
--     IF(NVL(LENGTH(V_SO_QD),0) > 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ((EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE ''%'|| V_SO_QD ||'%'' AND A.ID=QSV.DONID  )
--                    OR EXISTS(SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
--                    OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
--                    OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
--                   )
--                  )'
--        ;
--     END IF;    
--
--     --Ngày BA/QĐ
--     IF(NVL(LENGTH(V_NGAY_QD),0) > 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ((EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
--                   OR EXISTS(SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
--                   OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
--                   OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
--                   )
--                  )'
--        ;
--     END IF; 
--
--     --Số thụ lý
--     IF(V_LOAI_TBTL = 1) THEN
--             IF(NVL(LENGTH(V_SOTHULY),0) > 0) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                    ' AND (UPPER(TLS.SOTHULY) LIKE '''|| UPPER(V_SOTHULY) ||''' 
--                           OR UPPER(TLPT.SOTHULY) LIKE '''|| UPPER(V_SOTHULY) ||''' 
--                          )'
--                ;
--             END IF;
--        ELSIF (V_LOAI_TBTL = 2) THEN
--             IF(NVL(LENGTH(V_SOTHULY),0) > 0) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                    ' AND (UPPER(TLS.SOTHONGBAO) LIKE '''|| UPPER(V_SOTHULY) ||''' 
--                           OR UPPER(TLPT.SOTHONGBAO) LIKE '''|| UPPER(V_SOTHULY) ||''' 
--                          )'
--                ;
--             END IF;
--     END IF;
--
--     --Tình trạng thụ lý và ngày thụ lý
--     IF(NVL(LENGTH(V_TINHTRANG_THULY),0) = 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ((GD.MAGIAIDOAN = 2 AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON >= '|| VV_NGAYTHULY_TU ||') 
--                                      AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'))
--                    OR EXISTS (SELECT 1 
--                               FROM AHC_CHUYEN_NHAN_AN CNA 
--                               WHERE GD.MAGIAIDOAN = 3 AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN >= '|| VV_NGAYTHULY_TU ||') 
--                                                       AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN <= '|| VV_NGAYTHULY_DEN ||'))
--                  )'
--        ;
--     END IF;
--     IF(V_TINHTRANG_THULY LIKE '1') THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ((TLS.DONID IS NOT NULL 
--                     AND (TLS.NGAYTHULY >= '|| VV_NGAYTHULY_TU ||') 
--                     AND (TLS.NGAYTHULY <= '|| VV_NGAYTHULY_DEN ||') 
--                    )
--                    OR (TLPT.DONID IS NOT NULL
--                        AND (TLPT.NGAYTHULY >= '|| VV_NGAYTHULY_TU ||') 
--                        AND (TLPT.NGAYTHULY <= '|| VV_NGAYTHULY_DEN ||') 
--                        )     
--                   )'
--        ;
--     END IF;
--     IF(V_TINHTRANG_THULY LIKE '2') THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ( (TLS.DONID IS NOT NULL AND GD.MAGIAIDOAN = 2 AND ( TLS.NGAYTHULY > '|| VV_NGAYTHULY_DEN ||'))
--                     OR (TLS.DONID IS NULL AND GD.MAGIAIDOAN = 2 AND ( A.NGAYNHANDON >= '|| VV_NGAYTHULY_TU ||' 
--                                                                       OR EXISTS( SELECT 1 
--                                                                                  FROM AHC_DON_THAMPHAN PC 
--                                                                                  WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
--                                                                                        AND PC.NGAYPHANCONG >= '|| VV_NGAYTHULY_TU ||'
--                                                                                        AND A.ID = PC.DONID
--                                                                                )
--                                                                       OR XLD.NGAYGQ_YC >= '|| VV_NGAYTHULY_TU ||'
--                                                                       )
--                                                                 AND ( XLD.NGAYGQ_YC <= '|| VV_NGAYTHULY_DEN ||' 
--                                                                       OR EXISTS( SELECT 1 
--                                                                                  FROM AHC_DON_THAMPHAN PC 
--                                                                                  WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
--                                                                                        AND XLD.NGAYGQ_YC IS NULL
--                                                                                        AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
--                                                                                        AND A.ID = PC.DONID
--                                                                                )
--                                                                        OR (NOT EXISTS( SELECT 1 
--                                                                                        FROM AHC_DON D
--                                                                                            LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
--                                                                                        WHERE PC.NGAYPHANCONG IS NULL
--                                                                                       ) 
--                                                                             OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'
--                                                                            )
--                                                                      )
--                            )
--                         -- CHƯA THỤ LÝ PHÚC THẨM
--                         OR (TLPT.DONID IS NOT NULL AND GD.MAGIAIDOAN=3 AND EXISTS( SELECT 1 
--                                                                                    FROM AHC_CHUYEN_NHAN_AN CNA
--                                                                                    WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
--                                                                                   )
--                                                                        AND (TLPT.NGAYTHULY> '|| VV_NGAYTHULY_DEN ||')
--                            )
--                         OR (TLPT.DONID IS NULL AND GD.MAGIAIDOAN=3 AND EXISTS( SELECT 1 
--                                                                                FROM AHC_CHUYEN_NHAN_AN CNA
--                                                                                WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
--                                                                              )
--                                                AND ( EXISTS( SELECT 1 FROM AHC_CHUYEN_NHAN_AN CNA
--                                                              WHERE GD.MAGIAIDOAN = 3
--                                                                    AND CNA.NGAYNHAN >='|| VV_NGAYTHULY_TU ||' 
--                                                             )
--                                                      OR XLD.NGAYGQ_YC >= '|| VV_NGAYTHULY_TU ||'
--                                                      OR EXISTS( SELECT 1 
--                                                                 FROM AHC_DON_THAMPHAN PC 
--                                                                 WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
--                                                                    AND XLD.NGAYGQ_YC IS NULL
--                                                                    AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
--                                                                    AND A.ID = PC.DONID
--                                                                )
--                                                     )
--                                                AND ( XLD.NGAYGQ_YC <= '|| VV_NGAYTHULY_DEN ||' 
--                                                                              OR EXISTS( SELECT 1 FROM AHC_DON_THAMPHAN PC 
--                                                                                         WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
--                                                                                             AND XLD.NGAYGQ_YC IS NULL
--                                                                                             AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
--                                                                                             AND A.ID = PC.DONID
--                                                                                        )
--                                                                               OR (NOT EXISTS( SELECT 1 
--                                                                                               FROM AHC_DON D
--                                                                                                   LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
--                                                                                               WHERE PC.NGAYPHANCONG IS NULL
--                                                                                              ) 
--                                                                                   OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'
--                                                                                   )
--                                                     )
--                              )
--                  )'
--        ;
--     END IF;              
--
--
--     -- Turning được
--     -- Phiên tòa rút kinh nghiệm;
--     IF(V_PT_RKINHNGHIEM LIKE '1') THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--         ' AND (EXISTS(SELECT 1 
--                       FROM AHC_SOTHAM_BANAN BA
--                           LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
--                       WHERE SXX.ST_ISRUTKN = 1 -- trường phân biệt sơ thẩm rút kinh nghiệm
--                             AND BA.DONID = A.ID AND GD.MAGIAIDOAN=2
--                       )
--                OR EXISTS(SELECT 1 
--                          FROM AHC_PHUCTHAM_BANAN BA
--                             LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
--                          WHERE SXX.PT_ISRUTKN = 1 -- trường phân biệt phúc thẩm rút kinh nghiệm
--                                AND BA.DONID = A.ID AND GD.MAGIAIDOAN=3
--                          )
--                )'
--        ;
--     END IF;
--     IF(V_PT_RKINHNGHIEM LIKE '2') THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--         ' AND ( NOT EXISTS(SELECT 1
--                            FROM AHC_SOTHAM_BANAN BA
--                                LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
--                            WHERE SXX.ST_ISRUTKN = 1 --PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
--                                  AND BA.DONID =A.ID AND GD.MAGIAIDOAN=2
--                            )
--                 AND NOT  EXISTS(SELECT 1 
--                                 FROM AHC_PHUCTHAM_BANAN BA
--                                    LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
--                                 WHERE SXX.PT_ISRUTKN=1 --PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
--                                       AND BA.DONID =A.ID AND GD.MAGIAIDOAN=3
--                                 )
--                )'
--        ;
--     END IF;
--
--    --Kết quả xét xử phúc thẩm;
--    IF(V_KETQUA LIKE '1') THEN --Giữ nguyên quyết định/bản án sơ thẩm
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--          ' AND EXISTS( SELECT 1 
--                        FROM AHC_PHUCTHAM_BANAN PB 
--                            LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
--                        WHERE INSTR('',01,18,'','',''||KQPT.MA||'','') > 0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN=3
--                       )'
--        ;
--    END IF;
--    IF(V_KETQUA LIKE '2') THEN --Hủy quyết định/bản án sơ thẩm để...
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND EXISTS( SELECT 1 
--                          FROM AHC_PHUCTHAM_BANAN PB 
--                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
--                          WHERE INSTR('',03,04,06,12,13,14,15,21,'','',''||KQPT.MA||'','') > 0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN=3
--                         )'
--        ;
--    END IF;
--    IF(V_KETQUA LIKE '3') THEN --...Sửa 1 phần bản án/QĐ sơ thẩm
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND EXISTS( SELECT 1 
--                          FROM AHC_PHUCTHAM_BANAN PB 
--                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
--                          WHERE INSTR(''02'',KQPT.MA)>0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                         )'
--        ;
--    END IF;
--    IF(V_KETQUA LIKE '4') THEN --...Sửa toàn bộ bản án/QĐ sơ thẩm
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND EXISTS( SELECT 1 
--                          FROM AHC_PHUCTHAM_BANAN PB 
--                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
--                          WHERE INSTR(''05'',KQPT.MA)>0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                         )'
--        ;
--    END IF;
--
--    ----Thời hạn Giải quyết;
--    IF(V_THOIHAN_GQ LIKE '1') THEN --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ( --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
--                    EXISTS(SELECT 1 
--                           FROM AHC_SOTHAM_THULY TL
--                               LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                               LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                               LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                               LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
--                           WHERE( ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA - TL.NGAYTHULY) > 180 )
--                                    OR ( BA.ID IS NULL AND INSTR('',DC,CVA,HPT,GHTHXX,'','',''|| QDL.MA ||'','') = 0 AND (SYSDATE - TL.NGAYTHULY) > 180)
--                                   )
--                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                            )
--                    --dùng ngày quyết định và đình chỉ vụ án   
--                    OR  EXISTS (SELECT 1 
--                                FROM AHC_SOTHAM_THULY TL
--                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
--                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                                 WHERE ( ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') > 0 AND  (QSV.NGAYQD - TL.NGAYTHULY) > 180  ) --CVA QĐ chuyển vụ án, HPT Hoãn phiên tòa, GHTHXX QĐ gia hạn thời hạn chuẩn bị xét xử
--                                           OR ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 AND  BA.ID IS NULL AND (SYSDATE - TL.NGAYTHULY) > 180 )
--                                          )
--                                       AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                                 )
--                     --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
--                     OR EXISTS (SELECT 1 
--                                FROM AHC_PHUCTHAM_THULY TL 
--                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
--                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
--                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                                 WHERE ( (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA - TL.NGAYTHULY) > 90 )
--                                         OR (BA.ID IS NULL AND INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 AND  (SYSDATE - TL.NGAYTHULY) > 90 )
--                                       )
--                                       AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                                )
--                       --dùng ngày QĐ phúc thẩm  
--                       OR EXISTS (SELECT 1 
--                                  FROM AHC_PHUCTHAM_THULY TL 
--                                      LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID 
--                                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QSV.LOAIQDID 
--                                  WHERE ( ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') > 0  AND(QSV.NGAYQD - TL.NGAYTHULY) > 90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
--                                      OR (  INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0  AND(SYSDATE - TL.NGAYTHULY) > 90)
--                                    )
--                                     AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                                 ) 
--                   )'
--        ;
--    END IF;         
--    IF(V_THOIHAN_GQ LIKE '2') THEN --Còn thời hạn dưới 10 ngày
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND (--Sơ thẩm chưa có quyết định và chưa có bản án
--                  EXISTS(SELECT 1 
--                         FROM AHC_SOTHAM_THULY TL
--                             LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
--                             LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                         WHERE (SYSDATE - TL.NGAYTHULY) >= 170 AND (SYSDATE - TL.NGAYTHULY) < 180 
--                                AND BA.ID IS NULL 
--                                AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
--                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                         )
--                 --phúc thẩm   
--                 OR EXISTS (SELECT 1 
--                            FROM AHC_PHUCTHAM_THULY TL 
--                                LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
--                                LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                            WHERE (SYSDATE - TL.NGAYTHULY) >= 80 AND (SYSDATE - TL.NGAYTHULY) < 90 
--                                   AND BA.ID IS NULL
--                                   AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
--                                   AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                           ) 
--                  )'
--        ;
--    END IF;
--    IF(V_THOIHAN_GQ LIKE '3') THEN --chưa có quyết định và chưa có bản án
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND (--Sơ thẩm 
--                  EXISTS(SELECT 1 
--                         FROM AHC_SOTHAM_THULY TL
--                             LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
--                             LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
--                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                         WHERE (SYSDATE - TL.NGAYTHULY) >= 160 AND (SYSDATE - TL.NGAYTHULY) < 180 
--                                AND BA.ID IS NULL
--                                AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
--                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                         )
--                   --phúc thẩm   
--                   OR EXISTS (SELECT 1 
--                              FROM AHC_PHUCTHAM_THULY TL 
--                                  LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
--                                  LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
--                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
--                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                              WHERE (SYSDATE - TL.NGAYTHULY) >= 70 AND (SYSDATE - TL.NGAYTHULY) < 90 
--                                    AND BA.ID IS NULL
--                                    AND  (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
--                                    AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                              ) 
--                   )'  
--        ;
--    END IF;          
--
--    --Tình trạng GQ;
--    IF(NVL(LENGTH(V_TINHTRANG_GIAIQUYET),0) = 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--             'AND (
--                    ( GD.MAGIAIDOAN = 2
--                        AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON>= '|| VV_TUNGAY ||') 
--                        AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON<= '|| VV_DENNGAY ||')
--                    )
--                    OR EXISTS ( SELECT 1 
--                                FROM AHC_CHUYEN_NHAN_AN CNA
--                                WHERE GD.MAGIAIDOAN = 3
--                                    AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN >= '|| VV_NGAYTHULY_TU ||') 
--                                    AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN <= '|| VV_NGAYTHULY_DEN ||')
--                                )
--                  )'
--        ;
--    END IF;
--    IF(V_TINHTRANG_GIAIQUYET LIKE '1') THEN --Chưa giải quyết xong
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--           ' 
--                AND 
--                (
--                    NOT EXISTS (SELECT 1 FROM AHC_DON_XULY XL WHERE XL.DONID = A.ID AND XL.LOAIGIAIQUYET IN (1,3))
--                )
--                AND 
--                 (   
--                     (   GD.MAGIAIDOAN = 2 -- SƠ THẨM
--                         AND
--                         (
--                             ( EXISTS (SELECT 1 FROM AHC_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
--                                       WHERE A.ID = QDVA.DONID AND QDVA.NGAYQD >= '|| VV_DENNGAY ||')
--                                       OR
--                               EXISTS (SELECT 1 FROM AHC_SOTHAM_BANAN BA WHERE A.ID = BA.DONID AND BA.NGAYTUYENAN >= '|| VV_DENNGAY ||')
--
--                             )
--                             OR 
--                             ( NOT EXISTS (SELECT 1 FROM AHC_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
--                               AND NOT EXISTS (SELECT 1 FROM AHC_SOTHAM_BANAN BA WHERE A.ID = BA.DONID)
--
--                             )
--                         )
--                     )
--                     OR
--                     (   GD.MAGIAIDOAN = 3 -- PHÚC THẨM
--                         AND
--                         (
--                             ( EXISTS (SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
--                                       WHERE A.ID = QDVA.DONID AND QDVA.NGAYQD >= '|| VV_DENNGAY ||' )
--                                       OR
--                               EXISTS (SELECT 1 FROM AHC_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID AND BA.NGAYTUYENAN >= '|| VV_DENNGAY ||')
--
--                             )
--                             OR 
--                             ( NOT EXISTS (SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
--                               AND NOT EXISTS (SELECT 1 FROM AHC_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID)
--
--                             )
--                         )
--                     )
--                 )'
--        ;
--    END IF;  
--    IF(V_TINHTRANG_GIAIQUYET LIKE '2') THEN --chưa phân công Thẩm phán
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--             'AND (EXISTS(SELECT 1 
--                          FROM AHC_SOTHAM_THULY STTL
--                          WHERE STTL.DONID =  A.ID 
--                              AND ( STTL.NGAYTHULY >= '|| VV_TUNGAY ||')
--                              AND ( STTL.NGAYTHULY <= '|| VV_DENNGAY ||')
--                          )
--                  OR EXISTS(SELECT 1 
--                            FROM AHC_PHUCTHAM_THULY PTTL 
--                            WHERE PTTL.DONID = A.ID
--                                AND( PTTL.NGAYTHULY >= '|| VV_TUNGAY ||')
--                                AND( PTTL.NGAYTHULY <= '|| VV_DENNGAY ||')
--                            )
--                  )
--              AND (NOT EXISTS (SELECT 1 
--                               FROM AHC_DON_THAMPHAN PC 
--                               WHERE PC.DONID=A.ID
--                                    AND ((PC.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM'' AND GD.MAGIAIDOAN = 2)--sơ thẩm
--                                        OR (PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 3)--phuc thẩm
--                                        OR ( PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 7 )
--                                        )
--                                    AND ( PC.NGAYPHANCONG >= '|| VV_TUNGAY ||') 
--                                    AND ( PC.NGAYPHANCONG <= '|| VV_DENNGAY ||')  
--                                )
--                   )'
--        ;
--    END IF;
--    IF(V_TINHTRANG_GIAIQUYET = 3) THEN --đã phân công Thẩm phán
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND EXISTS (SELECT 1 
--                          FROM AHC_DON_THAMPHAN PC 
--                          WHERE PC.DONID=A.ID
--                              AND ((PC.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM'' AND GD.MAGIAIDOAN = 2)--sơ thẩm
--                                  OR(PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 3)--phuc thẩm
--                                  )
--                              AND ( PC.NGAYPHANCONG >= '|| VV_TUNGAY ||') AND (PC.NGAYPHANCONG <= '|| VV_DENNGAY ||')  
--                       )'
--        ;
--    END IF;                 
--    IF(V_TINHTRANG_GIAIQUYET LIKE '4') THEN --đã lên lịch xét xử
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND (EXISTS ( SELECT 1 
--                            FROM AHC_SOTHAM_QUYETDINH QSV
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
--                            WHERE QDL.MA = ''DVARXX''  --DVARXX - Đưa vụ án ra xét xử
--                                AND ( QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                AND ( QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                           )
--                        OR EXISTS( SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH PTQDVA
--                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
--                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
--                                   WHERE QDL.MA = ''DVARXX'' AND PTQDVA.DONID IS NULL
--                                       AND ( PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
--                                       AND ( PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
--                                       AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                                  )
--                    )'
--        ;
--    END IF;       
--    IF(V_TINHTRANG_GIAIQUYET LIKE '5') THEN --Đang hoãn
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ( EXISTS (SELECT 1 
--                            FROM AHC_SOTHAM_QUYETDINH QSV
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
--                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID 
--                            WHERE QDL.MA = ''HPT'' AND BA.ID IS NULL
--                                AND (  QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                             )
--                    --Đang hoãn phuc tham                 
--                    OR EXISTS (SELECT 1 
--                               FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                                  LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
--                                  LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
--                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
--                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID   
--                               WHERE PTBA.DONID IS NULL  AND QDL.MA = ''HPT'' --Vụ án chưa có bản án  --hoãn phiên tòa 
--                                  AND (  PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
--                                  AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
--                                  AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                            )    
--                       )'
--        ;
--    END IF;
--    IF(V_TINHTRANG_GIAIQUYET LIKE '6') THEN --Đang tạm đình chỉ
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            '--so tham Đang tạm đình chỉ 
--              AND (EXISTS ( SELECT 1 
--                            FROM AHC_SOTHAM_QUYETDINH QSV
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID 
--                            WHERE QDL.MA = ''TDC''  
--                                AND BA.DONID IS NULL  -- chưa có bản án
--                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
--                          )
--              --phuc tham Đang tạm đình chỉ                
--                    OR EXISTS ( SELECT 1 
--                                FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
--                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
--                                    LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTQDVA.DONID --BẢN ÁN 
--                                WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
--                                    AND QDL.MA = ''TDC'' --Tạm đình chỉ
--                                    AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
--                                    AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
--                                    AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
--                               )
--                  )'
--        ;
--    END IF;           
--    IF(V_TINHTRANG_GIAIQUYET LIKE '7') THEN --Đã giải quyết xong
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            ' AND ( EXISTS (SELECT 1 
--                            FROM AHC_SOTHAM_BANAN BA
--                            WHERE BA.SOBANAN IS NOT NULL
--                                AND (BA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
--                                AND (BA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
--                                AND BA.DONID = A.ID  AND GD.MAGIAIDOAN = 2
--                         )
--                    OR EXISTS ( SELECT 1 
--                                FROM AHC_SOTHAM_QUYETDINH QSV 
--                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
--                                WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1
--                                    AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                    AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                    AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
--                              )
--                    OR EXISTS ( SELECT 1 
--                                FROM AHC_PHUCTHAM_BANAN PTBA 
--                                WHERE PTBA.SOBANAN IS NOT NULL
--                                    AND (PTBA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
--                                    AND (PTBA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
--                                    AND PTBA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
--                               )
--                    OR EXISTS ( SELECT 1 
--                                FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
--                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
--                                WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHANHCHINH = 1
--                                    AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
--                                    AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
--                                    AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
--                               )   
--					  OR EXISTS ( SELECT 1 
--								FROM AHC_DON_XULY ADX 
--								WHERE ADX.LOAIGIAIQUYET IN (1, 3)
--									AND (ADX.NGAYGQ_YC >= '|| VV_TUNGAY ||')
--									AND (ADX.NGAYGQ_YC <= '|| VV_DENNGAY ||')
--									AND ADX.DONID = A.ID  AND GD.MAGIAIDOAN = 2  )    
--                )'
--        ;
--    END IF;                
--    IF(V_TINHTRANG_GIAIQUYET LIKE '8') THEN --Đã xét xử
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            'AND ( EXISTS ( SELECT 1 
--                            FROM AHC_SOTHAM_BANAN BA
--                            WHERE  BA.SOBANAN IS NOT NULL
--                                AND (BA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
--                                AND (BA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
--                                AND BA.DONID = A.ID  AND GD.MAGIAIDOAN = 2
--                           )
--                   OR EXISTS ( SELECT 1 
--                               FROM AHC_PHUCTHAM_BANAN PTBA 
--                               WHERE  PTBA.SOBANAN IS NOT NULL
--                                   AND (PTBA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
--                                   AND (PTBA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
--                                   AND PTBA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
--                               )    
--                  )'
--        ;
--    END IF;            
--    IF(V_TINHTRANG_GIAIQUYET LIKE '9') THEN --Đình chỉ
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            'AND ( EXISTS ( SELECT 1 
--                            FROM AHC_SOTHAM_QUYETDINH QSV 
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
--                            WHERE INSTR('',DC,'','',''||QDL.MA||'','')>0
--                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
--                            )
--                   OR EXISTS ( SELECT 1 
--                               FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
--                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
--                                   LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                               WHERE  INSTR('',DC,'','',''||QDL.MA||'','')>0
--                                   AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
--                                   AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
--                                   AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
--                              )       
--                 )'
--        ;
--    END IF; 
--    IF(V_TINHTRANG_GIAIQUYET LIKE '10') THEN --Công nhận thỏa thuận của đương sự
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            'AND ( EXISTS ( SELECT 1 
--                            FROM AHC_SOTHAM_QUYETDINH QSV 
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                            WHERE INSTR('',CNTT,'','',''||QDL.MA||'','')>0
--                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                AND QSV.DONID=A.ID  AND GD.MAGIAIDOAN = 2
--                           )
--                   )'
--        ;
--    END IF;                 
--    IF(V_TINHTRANG_GIAIQUYET LIKE '11') THEN --QĐ chuyển vụ án
--        SQL_STRING_WHERE := SQL_STRING_WHERE ||
--            'AND ( EXISTS ( SELECT 1 
--                            FROM AHC_SOTHAM_QUYETDINH QSV 
--                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
--                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
--                            WHERE INSTR('',CVA,'','',''||QDL.MA||'','') > 0
--                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
--                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
--                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
--                            )
--                   OR EXISTS( SELECT 1 
--                              FROM AHC_CHUYEN_NHAN_AN CA 
--                              WHERE CA.VUANID=A.ID AND CA.TOACHUYENID = '|| V_TOAAN_ID ||' AND GD.MAGIAIDOAN = 2)      
--                   OR EXISTS( SELECT 1 
--                              FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
--                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
--                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
--                              WHERE INSTR('',CVA,'','',''||QDL.MA||'','') > 0
--                                  AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
--                                  AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
--                                  AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
--                             )       
--                   )'
--        ;
--    END IF;  
--
--    --TOANCAU-1-11-2024    
--    IF(NVL(V_CHECK_HOAGIAI,0) = 0) THEN
--            SQL_STRING_WHERE := SQL_STRING_WHERE || ' AND (NVL('||V_CHECK_HOAGIAI||',0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) ';
--        ELSE 
--            SQL_STRING_WHERE := SQL_STRING_WHERE ||
--                  'AND (
--                                    '||V_CHECK_HOAGIAI||' > 0 )';
--
--            IF(V_HOAGIAI_TRANGTHAI != 0) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE ||  
--                          ' AND ( ('||V_HOAGIAI_TRANGTHAI||' = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) >= 1)
--                                  OR ('||V_HOAGIAI_TRANGTHAI||' = 1 AND NVL(A.HOAGIAI_TRANGTHAI,0) >= 1
--                                                                    AND NOT EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ 
--                                                                                    WHERE KQ.HOAGIAIID = HGD.ID))
--                                  OR ('||V_HOAGIAI_TRANGTHAI||' = A.HOAGIAI_TRANGTHAI)) ';
--            END IF;
--
--            IF(V_HOAGIAI_TUNGAY NOT LIKE '') THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                              '  AND ( EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ
--                                                    WHERE KQ.NGAYHOAGIAI >= '||VV_HOAGIAI_TUNGAY||' AND KQ.HOAGIAIID = HGD.ID)
--                                    )';
--            END IF;  
--
--            IF(VV_HOAGIAI_DENNGAY NOT LIKE '') THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                              ' AND ( EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ
--                                                        WHERE KQ.NGAYHOAGIAI <= '||VV_HOAGIAI_DENNGAY||' AND KQ.HOAGIAIID = HGD.ID)
--                                        ) ';
--            END IF;                            
--
--            IF(V_THAMPHAN_ID IS NOT NULL) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                              ' AND ( EXISTS (SELECT 1 FROM HOAGIAI_THAMPHAN HGTP
--                                                        WHERE HGTP.THAMPHANID = '||V_THAMPHAN_ID||' AND HGTP.HOAGIAIID = HGD.ID)
--                                        ) ';
--            END IF;  
--
--            IF(V_VAITRO_THAMPHAN IS NOT NULL) THEN
--                SQL_STRING_WHERE := SQL_STRING_WHERE || 
--                             '  AND ( EXISTS (SELECT 1 FROM HOAGIAI_THAMPHAN TPHG
--                                                          WHERE TPHG.MAVAITRO= ''VTTP_HOAGIAI'' AND TPHG.HOAGIAIID=HGD.ID)
--                                        ) ';
--            END IF; 
--    END IF;
--    IF (V_AN_KET_THUC = 1) THEN
--            SQL_STRING_WHERE := SQL_STRING_WHERE || '
--                AND(EXISTS (SELECT 1 FROM AHC_DON_GIAIDOAN BC
--                                        WHERE  BC.DONID = A.ID
--                                          AND (
--                                            (BC.MAGIAIDOAN = 2 AND BC.TOAANID = '|| V_TOAAN_ID ||') OR
--                                            (BC.MAGIAIDOAN in (3,7) AND BC.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
--                                          )
--                                          AND BC.AN_DA_KET_THUC = 1)                                      
--                             )';
--     ELSIF(V_AN_KET_THUC = 0) THEN
--        SQL_STRING_WHERE := SQL_STRING_WHERE || '
--            AND(NOT EXISTS (SELECT 1 FROM AHC_DON_GIAIDOAN BC
--                                    WHERE BC.DONID = A.ID
--                                      AND (
--                                        (BC.MAGIAIDOAN = 2 AND BC.TOAANID = '|| V_TOAAN_ID ||') OR
--                                        (BC.MAGIAIDOAN in (3,7) AND BC.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
--                                      )
--                                      AND BC.AN_DA_KET_THUC = 1)                                      
--                         )';
--    END IF;
--    --DBMS_OUTPUT.PUT_LINE(SQL_STRING_WITH || ' ' || SQL_STRING_SELECT );                       
--    --DBMS_OUTPUT.PUT_LINE(SQL_STRING_JOIN );
--    --DBMS_OUTPUT.PUT_LINE(SQL_STRING_WHERE );
--
--    OPEN CURRETURN FOR
--
--       'SELECT  TTT.ID,
--                TTT.MAVUVIEC,
--                TTT.TENVUVIEC,
--                TTT.SOTHUTU,
--                TTT.NGAYNHANDON,
--                TTT.HINHTHUCNHANDON,
--                TTT.MAGIAIDOAN,
--                TTT.QHPLTKID,
--                TTT.TOAANID,
--                TTT.QUANHEPL,
--                TTT.BANAN_QD_ST,
--                TTT.QD_PT,
--                TTT.KHANGNGHI_ST,
--                TTT.CHECK_THULY,
--                TTT.HOTENBICAN,
--                TTT.COUNTALL,
--                TTT.STT,
--                TO_CHAR(DECODE(GD_MAGIAIDOAN,2, A_NGAYTAO, 3, GN_NGAYTAO_PHUCTHAM,''''),''DD/MM/YYYY'') NGAY_TAO,
--                DECODE(GD_MAGIAIDOAN,2, A_NGUOITAO,3,GN_NGUOITAO_PHUCTHAM,'''') NGUOITAO,
--                DECODE(GD_MAGIAIDOAN,2, TO_CHAR(A_NGAYTAO,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(A_NGAYTAO,'' HH24:MI:SS''), 3, TO_CHAR(GN_NGAYTAO_PHUCTHAM,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(GN_NGAYTAO_PHUCTHAM,'' HH24:MI:SS''), '''') NGAYTAO,
--                DECODE(GD_MAGIAIDOAN,3,''</br><i>Tòa xét xử sơ thẩm: </i><b>''||T_TEN||''</b>'',NULL) TENTOASOTHAM, 
--                DECODE(GD_MAGIAIDOAN,2, ''Sơ thẩm'',3,''Phúc thẩm'', 4,''Thụ lý Giám đốc thẩm'','''')GIAIDOANVUVIEC,
--                DECODE(A_HINHTHUCNHANDON,1,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',270, ''<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'',''<br/><i>TH giao nhận:</i> <b>''|| GN_TRUONGHOPGIAONHAN||''</b>'') TRUONGHOPGIAONHAN,
--                PKG_STPT_AHC_GS.NOIDUNG_KHANGCAO_DANHSACH(A_ID) AS KHANGCAO_ST,
--                DECODE(XLD_LOAIGIAIQUYET,1,''- Đã chuyển đơn'',
--                                                             CASE WHEN (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) IS NULL 
--                                                                  THEN ''- Chưa thụ lý''
--                                                                  ELSE (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) 
--                                                             END  
--                                                           ||CASE WHEN (TPPC_TINHTRANG_GQ || TPPCPT_TINHTRANG_GQ) IS NULL AND (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) IS NOT NULL  
--                                                                  THEN ''</br>- Chưa phân công Thẩm phán'' 
--                                                                  ELSE  (TPPC_TINHTRANG_GQ || TPPCPT_TINHTRANG_GQ) 
--                                                             END
--
--                                                           || QDST_TINHTRANG_GQ || QDPT_TINHTRANG_GQ
--                                                           ||BAST_TINHTRANG_GQ||BAPT_TINHTRANG_GQ
--                                                           ||GNST_TINHTRANG_GQ
--
--                                                           --lanh thêm thông tin giải quyết của vụ án cha
--                                                           ||CASE WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN IS NULL) 
--                                                                  THEN (SELECT ''</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
--                                                                                FROM AHC_DON D
--                                                                                LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
--                                                                                WHERE D.ID = A_VUANGOCID)
--                                                                  WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN = 1) 
--                                                                  THEN (SELECT ''</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
--                                                                            FROM AHC_DON D
--                                                                            LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
--                                                                            WHERE D.ID = A_VUANGOCID)
--                                                              END) TINHTRANG_GQ,
--                  DECODE(BA_ID,NULL,DECODE(QD_ID,NULL,NULL,3),3) THULYXXLAI, '''' THAMPHANHG
--
--        FROM (SELECT TT.*, ROW_NUMBER() OVER (ORDER BY A_NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL
--              FROM (' || SQL_STRING_WITH || ' '
--                      || SQL_STRING_SELECT || ' ' 
--                      || SQL_STRING_JOIN || ' ' 
--                      || SQL_STRING_WHERE || ' ' 
--                      || ' ) TT
--               ) TTT' || 
--               CASE WHEN PAGE_INDEX = 0 AND PAGE_SIZE = 0 THEN ''
--               ELSE ' WHERE TTT.STT >= '|| MININDEX ||' AND TTT.STT <= '|| MAXINDEX
--               END;
--
--END AHC_DON_SEARCH_TURNING;

PROCEDURE AHC_DON_SEARCH
( 
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2,
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    vchecktk in number,
    V_TRANGTHAIVUAN in number,
	V_VAITRO_THAMPHAN IN VARCHAR2,
	 V_CHECK_HOAGIAI IN NUMBER,
    Page_Index in   int,
    Page_Size   in  int, 
    curReturn OUT sys_refcursor
)
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
	V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-03102023-ANHNT
--    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
--    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
    V_TABLE_BC T_BICANBICAO_EXT;V_TABLE_BC_KC T_BICANBICAO_EXT;   
 BEGIN
     V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
	 V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-03102023-ANHNT
--     V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
--     V_TABLE_TP := T_QUYETDINH_EXT();
     V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
     V_TABLE_BC := T_BICANBICAO_EXT(); V_TABLE_BC_KC := T_BICANBICAO_EXT();
    --SELECT LOAITOA INTO V_TOAAN_ID_CAPXX FROM DM_TOAAN WHERE ID=V_TOAAN_ID;--LOAITOA: (CAPCAO,CAPHUYEN,QSKHUVUC,CAPTINH,QSTRUNGUONG,TOICAO,QSQUANKHU)
    -- edit by anhvh 10/03/2020-- Giai đoạn vụ án/vụ việc
    -- SOTHAM = 2;PHUCTHAM = 3;THULYGDT = 4;  --//(DINHCHI = 5;HOSO = 1;)đã xóa 2 gai đoạn này vì không phù hợp với nghiệp vụ tòa án
    --v_Capxx: SOTHAM = 2;PHUCTHAM = 3
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;
    ----------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
   ------------------------
   ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --AHC_SOTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHC_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
         --AHC_PHUCTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHC_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;   
        --THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM AHC_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  AHC_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  AHC_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
		--THAMPHAN --TOANCAU-03102023-ANHNT
--    --THAMPHAN tham phan chu toa ST
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  AHC_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;  
--       --THAMPHAN tham phan chu toa PT
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  AHC_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
--       ---THAMPHAN giai quyet
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  AHC_DON_THAMPHAN 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;       
       --AHC_SOTHAM_QUYETDINH
      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHC_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
         --AHC_PHUCTHAM_QUYETDINH
         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHC_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                       FROM AHC_DON_DUONGSU WHERE ISDAIDIEN=0
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                       FROM AHC_DON_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID and kc.loaikhangcao !=2 AND KC.DONID=DS.DONID)
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;             
   -----------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, A.ID,A.MAVUVIEC,A.TENVUVIEC,A.SOTHUTU,A.NGAYNHANDON,
      DECODE(GD.MAGIAIDOAN,2, A.NGUOITAO,3,GN.NGUOITAO_PHUCTHAM,'') NGUOITAO
            ,DECODE(GD.MAGIAIDOAN,2, to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS'),
                            3, to_char(GN.NGAYTAO_PHUCTHAM,'dd/MM/yyyy')||'<br/>'||to_char(GN.NGAYTAO_PHUCTHAM,' HH24:MI:SS'),
                            '') NGAYTAO
      --,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
        DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
--      GN.TRUONGHOPGIAONHAN,
        A.HINHTHUCNHANDON,
        DECODE(A.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    '<br/><i>TH giao nhận:</i> <b>'|| GN.TruongHopGiaoNhan||'</b>') TRUONGHOPGIAONHAN,
        STBA.BANAN_QD_ST,'' as QD_PT,STKN.KHANGNGHI_ST, PKG_STPT_AHC_GS.NOIDUNG_KHANGCAO_DANHSACH(a.ID) as KHANGCAO_ST,--toancau-anhnt thêm trường QD_PT mặc định trống
        A.MAGIAIDOAN,(BC3.HoTen||BC2.HoTen)HOTENBICAN ,
        DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
             END  ||
             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
             END
               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
               ||CNTT.TINHTRANG_GQ
               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
               ||GNST.TINHTRANG_GQ
               || --lanh thêm thông tin giải quyết của vụ án cha
             CASE WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN is null) THEN 
             (SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHC_DON D
                    left join AHC_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHC_DON D
                    left join AHC_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )

        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI,
        A.QHPLTKID,A.TOAANID
      FROM AHC_DON A
      INNER JOIN (SELECT G.* FROM AHC_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      -- lấy thông tin vụ án end     
      LEFT JOIN (SELECT PTBA.* FROM AHC_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AHC_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách
        LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.AHC_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

        LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.AHC_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
--                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                    FROM AHC_DON_THAMPHAN TP
--                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
--                    LEFT JOIN ( SELECT GG.* FROM AHC_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
--                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
--                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 2
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 2 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

        LEFT JOIN (
--                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                        FROM AHC_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM AHC_DON_THAMPHAN GG
--                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
--                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
--                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 3
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 3 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETPHUCTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

        LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHC_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 

        LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

        LEFT JOIN (
                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AHC_SOTHAM_QUYETDINH QSV
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

        LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                    FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

        LEFT JOIN (
                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHC_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      

        LEFT JOIN (
                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHC_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3

        LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

        LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

        LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHC_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM AHC_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN (
                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
             --toancau-anhnt-sửa check đã chuyển lại án sơ thẩm
                        SELECT
                            CNA.ID,
                            CNA.VUANID,
                            CNA.TOACHUYENID,
                            CNA.TINHTRANG_GQ
                        FROM
                            (
                                SELECT
                                    CA.ID,
                                    CA.VUANID,
                                    CA.TOACHUYENID,
                                    '</br>- '
                                    || I.TEN
                                    || '</br>- Đã chuyển vụ án' TINHTRANG_GQ,
                                    ROW_NUMBER()
                                    OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID
                                         ORDER BY
                                             CA.ID DESC
                                    )                           RN
                                FROM
                                         AHC_CHUYEN_NHAN_AN CA
                                    INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                WHERE
                                    CA.TOACHUYENID = v_toaan_id
                            ) CNA
                        WHERE
                                CNA.RN = 1
                            AND NOT EXISTS (
                                SELECT
                                    'X'
                                FROM
                                         AHC_CHUYEN_NHAN_AN CN1
                                    JOIN AHC_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = v_toaan_id
                                    AND CN2.ID > CNA.ID
                            )

--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--toancau-anhnt-sửa check đã chuyển lại án sơ thẩm
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID

            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM FROM DM_DATAITEM i 
                     INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                     and not exists (select 'x' from ahc_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)
                     group by CA.VUANID,i.TEN  , CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM
                      )GN ON  GN.VUANID=a.ID
           ------bị cáo lấy cho sơ thẩm
        LEFT JOIN (
                  SELECT BC.DONID,
                 '<br /><i>Đương sự khác:</i> <br />'|| 
                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC) BC
                  GROUP BY BC.DONID
                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2

             ------bị cáo kháng cáo lấy cho phúc thẩm    
                LEFT JOIN ( 
                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC_KC) BC
                  GROUP BY BC.DONID
                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  

        ----- lấy thông tin BA/sơ thẩm                
        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
         ------- lấy thông tin số ngày kháng nghị
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHC_SOTHAM_KHANGNGHI KN
                      where KN.TINHTRANG_GIAIQUYET != 3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 

----LẤY THÔNG TIN KHÁNG CÁO
--   LEFT JOIN ( SELECT KC.DONID,
--                     '<br /><i>Kháng cáo:</i> <br />'|| 
--                      listagg (' ngày '||TO_CHAR(KC.NGAYKHANGCAO,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO) KHANGCAO_ST
--                      FROM  AHC_SOTHAM_KHANGCAO KC
--                      GROUP BY KC.DONID
--              )STKC ON STKC.DONID=A.ID 

        WHERE   
        a.magiaidoan != 7 and --toancau 31-03-2023 bỏ án pt tđc
        (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM AHC_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM AHC_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    ) ) 
             AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
             AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
             AND ((NVL(V_CHECK_HOAGIAI,0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) OR -- Thêm tìm kiếm đơn theo trạng thái hòa giải
             (V_CHECK_HOAGIAI > 0 AND A.HOAGIAI_TRANGTHAI > 0))
           -----   
           --toancau - quyet (
            AND ( (v_TINHTRANG_THULY IS NULL 
                    AND (
                            (GD.MAGIAIDOAN = 2
                            AND (V_NGAYTHULY_TU IS NULL OR  A.NGAYNHANDON >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR A.NGAYNHANDON <=VV_NGAYTHULY_DEN)
                        )
                        OR EXISTS ( SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        ))
                    )--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND (
                            (TLS.DONID IS NOT NULL 
                              AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                           OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                              )     
                            ) 
                    )
                  OR(v_TINHTRANG_THULY=2 
                        AND (
                            (
                                TLS.DONID IS NOT NULL
                                AND GD.MAGIAIDOAN=2
                                AND ( TLS.NGAYTHULY>VV_NGAYTHULY_DEN)
                            )
                            OR (
                                TLS.DONID IS NULL
                                AND GD.MAGIAIDOAN = 2
                                AND ( V_NGAYTHULY_TU IS NULL 
                                    OR A.NGAYNHANDON >= VV_NGAYTHULY_TU
                                    OR EXISTS(
                                                SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND PC.NGAYPHANCONG >= VV_NGAYTHULY_TU
                                                AND A.ID = PC.DONID
                                                )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU

                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM AHC_DON D
                                                LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
                                                WHERE PC.NGAYPHANCONG IS NULL
                                                ) 
                                                OR A.NGAYNHANDON <= VV_NGAYTHULY_DEN
                                            )
                                     )
                                )

                                ---- CHƯA THỤ LÝ PHÚC THẨM
                            OR(
                                TLPT.DONID IS NOT NULL
                                AND GD.MAGIAIDOAN=3
                                AND EXISTS(
                                        SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                )
--                                AND ( V_NGAYTHULY_TU IS NULL 
--                                        OR EXISTS(
--                                            SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
--                                            WHERE CNA.NGAYNHAN >= VV_NGAYTHULY_TU
--                                ))
                                AND (TLPT.NGAYTHULY>VV_NGAYTHULY_DEN
--                                        OR EXISTS (
--                                            SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
--                                            WHERE  VV_NGAYTHULY_DEN>=CNA.NGAYNHAN
--                                                
--                                        )
                                    )
                                )
                            OR (
                                TLPT.DONID IS NULL
                                AND GD.MAGIAIDOAN=3
                                AND EXISTS(
                                        SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                )
                                AND ( V_NGAYTHULY_TU IS NULL 
                                    OR EXISTS( 
                                            SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
                                            WHERE GD.MAGIAIDOAN = 3
                                            AND CNA.NGAYNHAN >=VV_NGAYTHULY_TU 
                                    )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU
                                    OR EXISTS(
                                                SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM AHC_DON D
                                                LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
                                                WHERE PC.NGAYPHANCONG IS NULL
                                                ) 
                                                OR A.NGAYNHANDON <= VV_NGAYTHULY_DEN
                                            )
                                     )
                                )
                        )   
                   ) 
                )
                --toancau - quyet )
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
         AND (V_THAMPHAN_ID IS NULL
            --OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
             --TOANCAU-03102023-ANHNT
           OR(V_VAITRO_THAMPHAN IS NULL 
                AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = A.ID AND TP.CANBOID = V_THAMPHAN_ID AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
            OR (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC'
                    AND EXISTS (SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = A.ID AND TP.MAVAITRO IN ('VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = V_THAMPHAN_ID))
            OR(V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA'
                AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = A.ID AND TP.MAVAITRO IN ('THAMPHAN','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = V_THAMPHAN_ID AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
            OR(V_VAITRO_THAMPHAN IN ('VTTP_GIAIQUYETDON','THAMPHANHDXX','THAMPHANDUKHUYET')
                AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = A.ID AND TP.MAVAITRO =V_VAITRO_THAMPHAN AND TP.CANBOID = V_THAMPHAN_ID AND TP.MAGIAIDOAN = GD.MAGIAIDOAN )))
           --TOANCAU-03102023-ANHNT

            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )   
          AND (v_thuky_id is null--Thư ký
                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id ) 

                     )

                )

                AND(vchecktk=0 or (select count(*) from AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
            --lanh check theo trạng thái vụ án dân sự          
               /* AND ((v_trangthaivuan = 0 AND (A.VUANGOCID = 0 OR A.VUANGOCID is null))
                         OR (v_trangthaivuan = 1 
                          AND A.VUANGOCID > 0 AND A.IS_TACHAN IS NULL
                            ) 
                        OR (v_trangthaivuan = 2
                          AND A.VUANGOCID > 0 AND A.IS_TACHAN = 1
                            )
                    ) */
            --check theo trạng thái vụ án end
            ------Loại đơn
           AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
           --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
             --toancau - quyet (
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,18,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',03,04,06,12,13,14,15,21,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )--toancau - quyet )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )     
            )   
        --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        --/////////////đối với sơ thẩm          
       AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                        LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
             --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
             AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND ( EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )     
                 --toancau - quyet (
           --Tình trạng GQ;
         AND( 
            (v_TINHTRANG_GIAIQUYET IS NULL 
                AND(( GD.MAGIAIDOAN = 2
                    AND (V_TUNGAY IS NULL OR A.NGAYNHANDON>=VV_TUNGAY) 
                    AND (V_DENNGAY IS NULL OR A.NGAYNHANDON<=VV_DENNGAY)
                    )
                OR EXISTS ( SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        ))
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    (  ((
                        EXISTS (
                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 
                                                   AND TL.DONID=T1.DONID
                                                   ) )
                                        )
                                 AND TL.NGAYTHULY IS NOT NULL
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                            AND(
                                -- (=2
                                 EXISTS (
                                SELECT 'X' FROM AHC_SOTHAM_THULY STTL
                                WHERE
                                STTL.DONID =  A.ID 
                                AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                                AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                                )-- =2)
                                --=3
                                OR EXISTS( 
                                    SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2--sơ thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                )--=3)
                                 --(=4 
                                OR EXISTS(
                                SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV --SO THAM
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                                WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                                    )--=4)
                                     --(=5
                                OR EXISTS ( -- hoãn sơ thẩm
                                SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE ( QDL.MA ='HPT' 
                                    or instr(',16-VDS,17-VDS,24-VDS,',','||QD.MA||',')>0
                                    )
                                AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                                --and qd.id = qsv.quyetdinhid
                             ) 
                                --=5)
                                --(=6
                                OR EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                    WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                                    AND BA.DONID IS NULL  -- chưa có bản án
                                    AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                        )--=6) 

                            ))

                        )

                          OR ( -- PHÚC THẨM
                                EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                    WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                            )
                                        AND  PTTL.NGAYTHULY IS NOT NULL
                                        AND PTTL.DONID=a.id  
                                        AND GD.MAGIAIDOAN=3
                                    )
                                AND (
                                --2
                                 EXISTS(
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                    WHERE
                                    PTTL.DONID = A.ID

                                    AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                                    AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                                        )--2
                                --=3 
                                OR EXISTS( 
                                    SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3--phuc thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                        )--=3)
                                        --(=4 
                                OR EXISTS(
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA -- PHUC THAM
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN AHC_PHUCTHAM_BANAN BA ON PTQDVA.DONID = BA.DONID
                                    WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=A.ID )--=4)
                                --(=5 
                                OR EXISTS ( --Đang hoãn phuc tham
                                    SELECT  'X' FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                    WHERE PTBA.DONID IS NULL  
                                    AND ( QDL.MA= 'HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                        or instr(',24-VDS,',','||QD.MA||',')>0
                                        )
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                                    )
                                    --=5)
                                    --(=6
                                OR EXISTS (--phuc tham Đang tạm đình chỉ
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA='TDC' --Tạm đình chỉ
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )--=6)
                                )  
                            )) 
                )-- toan cau --quyet)
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND ( EXISTS ( 
                        SELECT 'X' FROM AHC_SOTHAM_THULY STTL
                        WHERE
                        STTL.DONID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                    OR EXISTS(
                        SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.DONID = A.ID

                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                    )
                   AND ( 
                                NOT EXISTS (
                                    SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND (
                                         (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                        OR
                                        (PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                        OR
                                        ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN = 7 )
                                        )
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)  

                                                  ))
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
                --toancau /*quyết -thêm điều kiện 
               OR(v_TINHTRANG_GIAIQUYET = 4 --đã lên lịch xét xử

                    AND (
                        EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX' AND PTQDVA.DONID IS NULL--QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                        )

                    )


               )-- quyet  *\
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                     EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (   
                     EXISTS (       
                                    SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                 OR(v_TINHTRANG_GIAIQUYET=10 --Công nhận thỏa thuận của đương sự
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE instr(',CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                  )
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
               --toancau - quyet )
             -- END v_TINHTRANG_GIAIQUYET
             --là con của chưa giải quyết xong 
--            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
--               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
--                     AND (EXISTS (
--                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
--                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
--                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
--                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
--                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
--                                        )
--                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
--                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
--                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                     OR EXISTS (
--                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
--                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
--                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
--                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
--                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
--                                                       )
--                                 )
--                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
--                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
--                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
--                               )
--                      )
--                    )   
--                ) --là con của chưa giải quyết xong end 
            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
END AHC_DON_SEARCH;

PROCEDURE AHC_DON_CON_SEARCH
(
    V_DONID_GOC NUMBER,
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    V_TEN_VU_AN IN VARCHAR2, 
    V_QHPL IN VARCHAR2, 
    V_MA_VU_AN IN VARCHAR2, 
    V_TENDUONGSU IN VARCHAR2,
    V_CAPXX IN VARCHAR2,
    V_TOAAN_ID IN VARCHAR2, 
    V_TINHTRANG_THULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN IN VARCHAR2,
    V_SOTHULY IN VARCHAR2,
    V_THAMPHAN_ID IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    V_KETQUA IN VARCHAR2,
    V_SO_QD IN VARCHAR2,
    V_NGAY_QD IN VARCHAR2,
    V_THUKY_ID IN VARCHAR2, 
    V_THOIHAN_GQ IN VARCHAR2, 
    V_LOAIDON IN VARCHAR2, 
    V_PT_RKINHNGHIEM IN VARCHAR2, 
    V_GQDON IN VARCHAR2, 
    V_UTTP IN VARCHAR2,
    vchecktk in number,
    V_TRANGTHAIVUAN in number,
    Page_Index in   int,
    Page_Size   in  int, 
    curReturn OUT sys_refcursor 
)
IS 
    TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
    V_TABLE_BC T_BICANBICAO_EXT;V_TABLE_BC_KC T_BICANBICAO_EXT;   
 BEGIN
     V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
     V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
     V_TABLE_TP := T_QUYETDINH_EXT();
     V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
     V_TABLE_BC := T_BICANBICAO_EXT(); V_TABLE_BC_KC := T_BICANBICAO_EXT();
    --SELECT LOAITOA INTO V_TOAAN_ID_CAPXX FROM DM_TOAAN WHERE ID=V_TOAAN_ID;--LOAITOA: (CAPCAO,CAPHUYEN,QSKHUVUC,CAPTINH,QSTRUNGUONG,TOICAO,QSQUANKHU)
    -- edit by anhvh 10/03/2020-- Giai đoạn vụ án/vụ việc
    -- SOTHAM = 2;PHUCTHAM = 3;THULYGDT = 4;  --//(DINHCHI = 5;HOSO = 1;)đã xóa 2 gai đoạn này vì không phù hợp với nghiệp vụ tòa án
    --v_Capxx: SOTHAM = 2;PHUCTHAM = 3
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;
    ----------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
   ------------------------
   ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --AHC_SOTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHC_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
         --AHC_PHUCTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHC_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;   
    --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  AHC_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  AHC_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;     
       ---THAMPHAN giai quyet
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  AHC_DON_THAMPHAN 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;       
       --AHC_SOTHAM_QUYETDINH
      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHC_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
         --AHC_PHUCTHAM_QUYETDINH
         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHC_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                       FROM AHC_DON_DUONGSU WHERE ISDAIDIEN=0
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                       FROM AHC_DON_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                    )BC 

                where BC.ROWNUMBER <=3
            )TTS;             
   -----------------------
    OPEN curReturn FOR
   select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, A.ID,A.MAVUVIEC,A.TENVUVIEC,A.SOTHUTU,A.NGAYNHANDON,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
--      GN.TRUONGHOPGIAONHAN,
     A.HINHTHUCNHANDON,
    DECODE(A.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    '<br/><i>TH giao nhận:</i> <b>'|| GN.TruongHopGiaoNhan||'</b>') TRUONGHOPGIAONHAN,
      STBA.BANAN_QD_ST,STKN.KHANGNGHI_ST,
      A.MAGIAIDOAN,(BC3.HoTen||BC2.HoTen)HOTENBICAN ,
      DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn', CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
             END  ||
             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
             END
               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
               ||CNTT.TINHTRANG_GQ
               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
               ||GNST.TINHTRANG_GQ
               || --hieu thêm thông tin giải quyết của vụ án cha
             CASE WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN is null) THEN 
             (SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHC_DON D
                    left join AHC_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHC_DON D
                    left join AHC_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )
        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI

      FROM AHC_DON A
      INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      ----- BA Or QD----------------------------------------------
      LEFT JOIN (SELECT PTBA.* FROM AHC_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
         --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AHC_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách
          LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.AHC_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

           LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.AHC_PHUCTHAM_THULY T2
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM AHC_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM AHC_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN (
                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AHC_DON_THAMPHAN TP
                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                        LEFT JOIN (SELECT GG.* FROM AHC_DON_THAMPHAN GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHC_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 

             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AHC_SOTHAM_QUYETDINH QSV
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                    FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHC_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      

            LEFT JOIN (
                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHC_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3

              LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

             LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHC_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM AHC_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN (
                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
        LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
                      )GN ON  GN.VUANID=a.ID

           ------bị cáo lấy cho sơ thẩm
        LEFT JOIN (
                  SELECT BC.DONID,
                 '<br /><i>Đương sự khác:</i> <br />'|| 
                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Người khởi kiện)','BIDON','(Người bị kiện)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC) BC
                  GROUP BY BC.DONID
                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2

             ------bị cáo kháng cáo lấy cho phúc thẩm    
                LEFT JOIN ( 
                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Người khởi kiện)','BIDON','(Người bị kiện)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC_KC) BC
                  GROUP BY BC.DONID
                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  

        ----- lấy thông tin BA/sơ thẩm                
        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           

        ------- lấy thông tin số ngày kháng nghị
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHC_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 

        ---------------------                
        WHERE   (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM AHC_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM AHC_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    ) ) 
             AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
             AND (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID))
           -----   
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND (
                          (TLS.DONID IS NOT NULL 
                              AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                           OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   ) )
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
         AND (V_THAMPHAN_ID IS NULL
            OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM AHC_DON_THAMPHAN TP WHERE TP.THUKYID=v_thuky_id and TP.DONID=A.ID)

                     )
                )
               AND(vchecktk=0 or (select count(*) from AHC_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0) 
               --hieu check theo trạng thái vụ án hành chính        
                AND ((v_trangthaivuan = 0 AND (A.VUANGOCID = 0 OR A.VUANGOCID is null))
                         OR (v_trangthaivuan = 1 
                          AND A.VUANGOCID > 0 AND A.IS_TACHAN IS NULL
                            ) 
                        OR (v_trangthaivuan = 2
                          AND A.VUANGOCID > 0 AND A.IS_TACHAN = 1
                            )
                    ) 
            ------Loại đơn 
           AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
           --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',04,06,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHC_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('05',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )      
            )   
        --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        --/////////////đối với sơ thẩm          
       AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                        LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (v_THOIHAN_GQ=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )  
             --------PT rút kinh nghiệm;V_PT_RKINHNGHIEM
             AND (V_PT_RKINHNGHIEM IS NULL
                   OR(V_PT_RKINHNGHIEM =1 
                       AND ( EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN BA
                              LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
           --Tình trạng GQ;
         AND( (v_TINHTRANG_GIAIQUYET IS NULL AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
             OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                     EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (   
                     EXISTS (       
                                    SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  ) 
                 OR(v_TINHTRANG_GIAIQUYET=10 --Công nhận thỏa thuận của đương sự
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE instr(',CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                        )
                  )
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
               )
             -- END v_TINHTRANG_GIAIQUYET
             --là con của chưa giải quyết xong 
            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                     AND (EXISTS (
                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end
                AND A.ID <> V_DONID_GOC --lấy all trừ vụ việc gốc

            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
END AHC_DON_CON_SEARCH;

PROCEDURE AHC_DON_SEARCH_TURNING
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TEN_VU_AN             IN VARCHAR2,
    V_QHPL                  IN VARCHAR2, 
    V_MA_VU_AN              IN VARCHAR2, 
    V_TENDUONGSU            IN VARCHAR2,
    V_CAPXX                 IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2, 
    V_TINHTRANG_THULY       IN VARCHAR2,
    V_NGAYTHULY_TU          IN VARCHAR2, 
    V_NGAYTHULY_DEN         IN VARCHAR2,
    V_SOTHULY               IN VARCHAR2,
    V_THAMPHAN_ID           IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET   IN VARCHAR2,
    V_TUNGAY                IN VARCHAR2,
    V_DENNGAY               IN VARCHAR2,
    V_KETQUA                IN VARCHAR2,
    V_SO_QD                 IN VARCHAR2,
    V_NGAY_QD               IN VARCHAR2,
    V_THUKY_ID              IN VARCHAR2, 
    V_THOIHAN_GQ            IN VARCHAR2, 
    V_LOAIDON               IN VARCHAR2, 
    V_PT_RKINHNGHIEM        IN VARCHAR2, 
    V_GQDON                 IN VARCHAR2, 
    V_UTTP                  IN VARCHAR2,
    VCHECKTK                IN NUMBER,
    V_TRANGTHAIVUAN         IN NUMBER, -- CHƯA DÙNG ĐẾN
	V_VAITRO_THAMPHAN       IN VARCHAR2,
    V_LOAI_TBTL             IN NUMBER,
    V_MA_THONG_BAO          IN NUMBER, -- 1 Tim theo ma vu an, 2 tim theo ma thong bao an phi
	V_CHECK_HOAGIAI         IN NUMBER,--TOANCAU-1-11-2024
    V_HOAGIAI_TRANGTHAI     IN NUMBER DEFAULT NULL,
    V_HOAGIAI_TUNGAY        IN VARCHAR2 DEFAULT NULL,
    V_HOAGIAI_DENNGAY       IN VARCHAR2 DEFAULT NULL,
    V_AN_KET_THUC           IN NUMBER,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
)
IS 
    SQL_STRING_WITH         CLOB;
    SQL_STRING_SELECT       CLOB;
    SQL_STRING_JOIN         CLOB;
    SQL_STRING_WHERE        CLOB;
    SQL_STRING_VUAN         CLOB;

    TOTALITEM               NUMBER; 
    MININDEX                NUMBER; 
    MAXINDEX                NUMBER; 
    VV_TUNGAY               VARCHAR(250);
    VV_DENNGAY              VARCHAR(250); 
    VV_NGAYTHULY_TU         VARCHAR(250);
    VV_NGAYTHULY_DEN        VARCHAR(250);
    VV_HOAGIAI_TUNGAY       VARCHAR(250);--TOANCAU-1-11-2024
    VV_HOAGIAI_DENNGAY      VARCHAR(250);

    VV_TEN_VU_AN            VARCHAR(250);
    VV_QHPL                 VARCHAR(250);
    VV_TENDUONGSU           VARCHAR(250);
    VV_MA_VU_AN             VARCHAR(250);

BEGIN

     IF(PAGE_INDEX > 0 AND PAGE_SIZE > 0) THEN
         MININDEX := PAGE_SIZE*(PAGE_INDEX - 1) + 1;
         MAXINDEX := PAGE_INDEX*PAGE_SIZE ;
     END IF;

     IF(NVL(LENGTH(V_NGAYTHULY_TU),0) >0) THEN 
             VV_NGAYTHULY_TU := 'TO_DATE(TRIM('''|| V_NGAYTHULY_TU ||''') ||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';
         ELSE
            VV_NGAYTHULY_TU := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_NGAYTHULY_DEN),0) >0) THEN  
             VV_NGAYTHULY_DEN := 'TO_DATE(TRIM('''|| V_NGAYTHULY_DEN ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
          ELSE
             VV_NGAYTHULY_DEN := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_TUNGAY),0) >0) THEN  
            VV_TUNGAY := 'TO_DATE(TRIM('''|| V_TUNGAY ||''')||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';  
          ELSE
             VV_TUNGAY := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_DENNGAY),0) >0) THEN  
            VV_DENNGAY := 'TO_DATE(TRIM('''|| V_DENNGAY ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
          ELSE
             VV_DENNGAY := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
     END IF; 

     IF(NVL(LENGTH(V_HOAGIAI_TUNGAY),0) >0) THEN  --TOANCAU-1-11-2024
            VV_HOAGIAI_TUNGAY := 'TO_DATE(TRIM('''|| V_HOAGIAI_TUNGAY ||''')||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';  
          ELSE
             VV_HOAGIAI_TUNGAY := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_HOAGIAI_DENNGAY),0) >0) THEN  --TOANCAU-1-11-2024
            VV_HOAGIAI_DENNGAY := 'TO_DATE(TRIM('''|| V_HOAGIAI_DENNGAY ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
          ELSE
             VV_HOAGIAI_DENNGAY := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
     END IF; 

     -- gioi han data cua bang vu an/ Bỏ án pt tđc
     SQL_STRING_VUAN := 'SELECT * FROM AHC_DON A WHERE (A.TOAANID = ' || V_TOAAN_ID || ' OR A.TOAPHUCTHAMID = '|| V_TOAAN_ID || ') AND A.MAGIAIDOAN != 7 ';
     
     --Mã vụ việc/ma thong bao
     IF(NVL(LENGTH(V_MA_VU_AN),0) > 0) THEN
        IF(V_MA_THONG_BAO = 1) THEN
        VV_MA_VU_AN := FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN));
        SQL_STRING_VUAN := SQL_STRING_VUAN || 
            ' AND ( LOWER(A.MAVUVIEC) LIKE '''|| VV_MA_VU_AN ||'%''  
                  )'
        ;
        END IF;     
     END IF;

     --Tên vụ án
     IF(NVL(LENGTH(V_TEN_VU_AN),0) > 0) THEN
        VV_TEN_VU_AN := FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN));
        SQL_STRING_VUAN := SQL_STRING_VUAN || 
            ' AND ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE ''%'|| VV_TEN_VU_AN ||'%''
            )'        
            ;
     END IF;

     IF(V_CHECK_HOAGIAI > 0) THEN
     --Thêm tìm kiếm đơn theo trạng thái hòa giải        
        SQL_STRING_VUAN := SQL_STRING_VUAN || 
             ' AND ( (NVL('|| V_CHECK_HOAGIAI ||',0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) 
                      OR ('|| V_CHECK_HOAGIAI ||' > 0 AND A.HOAGIAI_TRANGTHAI > 0)
                   )'
        ;
     END IF;

     SQL_STRING_WITH := 
     '   WITH 
                V_TABLE_VUAN AS (
                ' || SQL_STRING_VUAN || '
                ),
                
                V_TABLE_TLST AS (SELECT /*+ MATERIALIZE */ DONID, ID
							FROM (
							SELECT tl.DONID, tl.ID, ROW_NUMBER() OVER (PARTITION BY tl.DONID ORDER BY NGAYTHULY DESC, tl.NGAYTAO DESC) AS rn
                                FROM AHC_SOTHAM_THULY tl 
                                JOIN V_TABLE_VUAN b ON tl.DONID = b.ID 
							)
							WHERE rn = 1
                      ),
                      
                V_TABLE_TLPT AS (SELECT DISTINCT tl.DONID, FIRST_VALUE(tl.ID) OVER (PARTITION BY tl.DONID ORDER BY NGAYTHULY DESC, tl.NGAYTAO DESC) AS ID
                      FROM  AHC_PHUCTHAM_THULY tl 
                      JOIN V_TABLE_VUAN b ON tl.DONID = b.ID
                      ),

                V_TABLE_THAMPHAN_GIAIQUYET AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM (SELECT TP.MAVAITRO,TP.DONID,TP.ID,TP.CANBOID, ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,(CASE WHEN TP.MAVAITRO IN( ''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETDON'') THEN 2 WHEN TP.MAVAITRO=''VTTP_GIAIQUYETPHUCTHAM'' THEN 3 END) MAGIAIDOAN
                                          FROM AHC_DON_THAMPHAN TP
                                          JOIN V_TABLE_VUAN b ON TP.DONID = b.ID) TP
                                    WHERE TP.ROWNUMBER = 1
                                    ),

                V_TABLE_THAMPHAN_HDXX_ST AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,2 MAGIAIDOAN
                                          FROM  AHC_SOTHAM_HDXX TP
                                          JOIN V_TABLE_VUAN b ON TP.DONID = b.ID
                                          WHERE MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

                V_TABLE_THAMPHAN_HDXX_PT AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,3 MAGIAIDOAN
                                          FROM  AHC_PHUCTHAM_HDXX TP
                                          JOIN V_TABLE_VUAN b ON TP.DONID = b.ID
                                          WHERE MAVAITRO IN(''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

                V_TABLE_BC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                                FROM (SELECT BC.ID, BC.DONID, BC.TENDUONGSU, BC.TUCACHTOTUNG_MA, ROW_NUMBER()  OVER (PARTITION BY BC.DONID ORDER BY BC.ISDAIDIEN DESC, BC.TENDUONGSU) ROWNUMBER
                                     FROM AHC_DON_DUONGSU BC
                                     JOIN V_TABLE_VUAN b ON BC.DONID = b.ID 
                                    WHERE ISDAIDIEN=0) BC 
                               WHERE BC.ROWNUMBER <= 3),

                V_TABLE_BC_KC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                        FROM AHC_DON_DUONGSU DS
                                        JOIN V_TABLE_VUAN b ON DS.DONID = b.ID
                                        WHERE EXISTS(SELECT 1 FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID))BC 
                                  WHERE BC.ROWNUMBER <=3)

        ';  

    SQL_STRING_SELECT := 
    '    SELECT DISTINCT A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                I.TEN AS QUANHEPL,
                STBA.BANAN_QD_ST,
                '''' AS QD_PT,-- thêm trường QD_PT mặc định trống
                STKN.KHANGNGHI_ST,
                (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
                (BC3.HOTEN||BC2.HOTEN) HOTENBICAN,

                A.NGUOITAO A_NGUOITAO,
                GD.MAGIAIDOAN GD_MAGIAIDOAN,
                GN.NGUOITAO_PHUCTHAM GN_NGUOITAO_PHUCTHAM,

                A.NGAYTAO AS A_NGAYTAO,
                GN.NGAYTAO_PHUCTHAM GN_NGAYTAO_PHUCTHAM,
                T.TEN T_TEN,

                A.HINHTHUCNHANDON A_HINHTHUCNHANDON,
                GN.TRUONGHOPGIAONHAN GN_TRUONGHOPGIAONHAN,

                A.ID A_ID,

                XLD.LOAIGIAIQUYET XLD_LOAIGIAIQUYET,
                TLS.TINHTRANG_GQ TLS_TINHTRANG_GQ,
                TLPT.TINHTRANG_GQ TLPT_TINHTRANG_GQ,
                TPPC.TINHTRANG_GQ TPPC_TINHTRANG_GQ,
                TPPCPT.TINHTRANG_GQ TPPCPT_TINHTRANG_GQ,
                QDST.TINHTRANG_GQ QDST_TINHTRANG_GQ,
                QDPT.TINHTRANG_GQ QDPT_TINHTRANG_GQ,
                BAST.TINHTRANG_GQ BAST_TINHTRANG_GQ,
                BAPT.TINHTRANG_GQ BAPT_TINHTRANG_GQ,
                GNST.TINHTRANG_GQ GNST_TINHTRANG_GQ,
                A.VUANGOCID A_VUANGOCID,
                A.IS_TACHAN A_IS_TACHAN,

                BA.ID BA_ID,
                QD.ID QD_ID,

				STBAKT.ID STBAKT_ID, -- VNPT HOANGNDH 03/12/2025 update thụ lý lại ST
				STQDKT.ID STQDKT_ID

        FROM V_TABLE_VUAN A 
     ';

     SQL_STRING_JOIN := 
     '      INNER JOIN (SELECT G.* 
                      FROM AHC_DON_GIAIDOAN G 
                      WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = '|| V_TOAAN_ID ||') 
                             OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                      ) GD ON A.ID=GD.DONID 

            LEFT JOIN AHC_ANPHI AI ON A.ID=AI.DONID

            LEFT JOIN DVCQG_THANH_TOAN TT ON TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC=6

			-- VNPT HOANGNDH 03/12/2025 lấy thông tin vụ án kết thúc ở ST
			LEFT JOIN ( SELECT STBA.ID, STBA.DONID FROM AHC_SOTHAM_BANAN STBA WHERE STBA.SOBANAN IS NOT NULL) STBAKT ON STBAKT.DONID = A.ID AND GD.MAGIAIDOAN=2
			LEFT JOIN ( SELECT STQD.ID, STQD.DONID FROM AHC_SOTHAM_QUYETDINH STQD LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = STQD.QUYETDINHID WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1) STQDKT ON STQDKT.DONID = A.ID AND GD.MAGIAIDOAN=2

            LEFT JOIN DM_DATAITEM I ON A.QUANHEPHAPLUATID=I.ID

            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID

            -- lấy thông tin vụ án end  
            LEFT JOIN (SELECT PTBA.* 
                     FROM AHC_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     ) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3

            LEFT JOIN (SELECT PTQDVA.* 
                     FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                         LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                         LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                     WHERE  INSTR('',DC,'','',''||QDL.MA||'','') > 0
                     ) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN = 3 

            -- Lay ra trang thai giai quyet don
            LEFT JOIN (SELECT DONID, LOAIGIAIQUYET, NGAYGQ_YC 
                     FROM AHC_DON_XULY 
                     WHERE LOAIGIAIQUYET IN (1,5)
                     ) XLD ON A.ID = XLD.DONID

            --Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT T2.DONID, T2.TOAANID, T2.NGAYTHULY, T2.SOTHULY, T2.TRUONGHOPTHULY,  T2.SOTHONGBAO,
                            T2.QHPLTKID, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM AHC_SOTHAM_THULY T2
                     WHERE EXISTS(SELECT 1 
                                  FROM V_TABLE_TLST QDL 
                                  WHERE QDL.ID = T2.ID)
                     ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2 --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

            LEFT JOIN (SELECT T2.DONID, T2.NGAYTHULY, T2.SOTHULY,   T2.SOTHONGBAO,
                            T2.TRUONGHOPTHULY, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) || ''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM AHC_PHUCTHAM_THULY T2
                     WHERE EXISTS(SELECT 1 
                                  FROM V_TABLE_TLPT QDL 
                                  WHERE QDL.ID = T2.ID) --> Lấy thụ lý mới nhất
                     ) TLPT ON TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 3 

            LEFT JOIN (SELECT TP.DONID, ''</br>- Thẩm phán: <b>'' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || ''</b><i> (chủ tọa)</i>'' TINHTRANG_GQ
                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP
                         LEFT JOIN (SELECT HDXX.CANBOID, HDXX.DONID 
                                    FROM V_TABLE_THAMPHAN_HDXX_ST HDXX
                                    WHERE HDXX.MAVAITRO = ''THAMPHAN''
                                    ) HDXX ON HDXX.DONID = TP.DONID 
                         LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID  
					     LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                     WHERE TP.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM''
                     )TPPC ON TPPC.DONID = A.ID AND GD.MAGIAIDOAN = 2 

            LEFT JOIN (SELECT TP.DONID,''</br>- Thẩm phán: <b>'' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || ''</b><i> (chủ tọa)</i>'' TINHTRANG_GQ
                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP
                        LEFT JOIN (SELECT HDXX.CANBOID, HDXX.DONID
                                   FROM V_TABLE_THAMPHAN_HDXX_PT HDXX
                                   WHERE HDXX.MAVAITRO = ''THAMPHAN''
                                   ) HDXX ON HDXX.DONID = TP.DONID
                        LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID 
                        LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID 
                     WHERE TP.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM''
                     )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3                 

            LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI || '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
                   FROM AHC_SOTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID
                    GROUP BY QSV.DONID
                    ) QDST ON QDST.DONID = A.ID AND GD.MAGIAIDOAN=2

            LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI|| '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
                   FROM AHC_PHUCTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID
                    GROUP BY QSV.DONID
                    ) QDPT ON QDPT.DONID = A.ID AND GD.MAGIAIDOAN=3    

            LEFT JOIN (SELECT BA.DONID,''</br>- Bản án số: ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHC_SOTHAM_BANAN BA
                     WHERE  BA.SOBANAN IS NOT NULL
                     )BAST ON  BAST.DONID=A.ID AND GD.MAGIAIDOAN=2      

            LEFT JOIN (SELECT PTBA.DONID,''</br>- Bản án số: ''||PTBA.SOBANAN||'' ngày ''||TO_CHAR(PTBA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHC_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     )BAPT ON  BAPT.DONID=A.ID AND GD.MAGIAIDOAN=3  


            --trường hợp giao nhận add vào cột trạng thái     
            --sửa check đã chuyển lại án sơ thẩm     
            LEFT JOIN (SELECT CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
                    FROM(SELECT CA.ID, CA.VUANID, CA.TOACHUYENID, ''</br>- '' || I.TEN || ''</br>- Đã chuyển vụ án'' TINHTRANG_GQ,
                                ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN
                            FROM AHC_CHUYEN_NHAN_AN CA
                                INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                            WHERE CA.TOACHUYENID = '|| V_TOAAN_ID ||') CNA
                    WHERE CNA.RN = 1 AND NOT EXISTS (SELECT 1 
                                                     FROM AHC_CHUYEN_NHAN_AN CN1
                                                         JOIN AHC_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                                     WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = '|| V_TOAAN_ID ||' AND CN2.ID > CNA.ID )
                    )GNST ON  GNST.VUANID=A.ID AND GD.MAGIAIDOAN=2               

            --trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
            LEFT JOIN (SELECT CA.VUANID,I.TEN TRUONGHOPGIAONHAN, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM 
                      FROM DM_DATAITEM I 
                          INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=I.ID 
                      WHERE CA.TOANHANID='|| V_TOAAN_ID ||' AND NOT EXISTS (SELECT 1 FROM AHC_DON WHERE ID =NVL(CA.MAP_VUANID_NEW ,0) AND MAGIAIDOAN = 7)                      )GN ON  GN.VUANID=A.ID

            --bị cáo lấy cho sơ thẩm
            LEFT JOIN (SELECT BC.DONID, ''<br /><i>Đương sự khác:</i> <br />''|| LISTAGG (BC.TENDUONGSU||'' ''|| DECODE(BC.TUCACHTOTUNG_MA,''NGUYENDON'',''(Nguyên đơn)'',''BIDON'',''(Bị đơn)'',''QUYENNVLQ'',''(Người có quyền và NVLQ)'','' (''||BC.TUCACHTOTUNG_MA || '')'' ), ''<br/>'') WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                       FROM V_TABLE_BC BC
                       GROUP BY BC.DONID
                       )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2

            ------bị cáo kháng cáo lấy cho phúc thẩm    
            LEFT JOIN (SELECT BC.DONID,''<br /><i>Người kháng cáo:</i> <br />''|| LISTAGG (BC.TENDUONGSU||'' ''|| DECODE(BC.TUCACHTOTUNG_MA,''NGUYENDON'',''(Nguyên đơn)'',''BIDON'',''(Bị đơn)'',''QUYENNVLQ'',''(Người có quyền và NVLQ)'','' (''||BC.TUCACHTOTUNG_MA || '')'' ), ''<br/>'') WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                       FROM V_TABLE_BC_KC BC
                       GROUP BY BC.DONID
                      )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3

            ----- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.DONID,''<br />BA/QĐ sơ thẩm: <b>''||''Số ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'')||''</b>'' BANAN_QD_ST FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
            ------- lấy thông tin số ngày kháng nghị
            LEFT JOIN (SELECT KN.DONID, ''<br /><i>Kháng nghị:</i> <br />''|| LISTAGG (''Số ''||KN.SOKN||'' ngày ''||TO_CHAR(KN.NGAYKN,''dd/MM/yyyy''), ''<br/>'') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                       FROM  AHC_SOTHAM_KHANGNGHI KN
                       WHERE KN.TINHTRANG_GIAIQUYET != 3
                       GROUP BY KN.DONID
                      )STKN ON STKN.DONID=A.ID


            ----TOANCAU-1-11-2024
            LEFT JOIN HOAGIAI_DON HGD ON HGD.VUVIECID = A.ID AND HGD.LOAIANID = 6                      
            LEFT JOIN (SELECT TP.THAMPHANID,TP.HOAGIAIID,TP.ID,TP.NGAYPHANCONG,''<br/><i>Thẩm phán hoà giải:</i> <b>''|| CB.HOTEN||''</b>'' THAMPHANHG
                    FROM (SELECT ID,THAMPHANID,HOAGIAIID,NGAYPHANCONG,ROW_NUMBER() OVER (PARTITION BY HOAGIAIID ORDER BY NGAYPHANCONG DESC) RN
                        FROM HOAGIAI_THAMPHAN WHERE THAMPHANID IS NOT NULL)TP
                        JOIN DM_CANBO CB ON CB.ID = TP.THAMPHANID
                    WHERE ( '||NVL(V_THAMPHAN_ID,'''''')||' IS NOT NULL AND '||NVL(V_THAMPHAN_ID,'''''')||' = TP.THAMPHANID )
                                          OR( '||NVL(V_THAMPHAN_ID,'''''')||' IS NULL and RN=1)) TPHG ON HGD.ID = TPHG.HOAGIAIID   
     ';

     --Bỏ án pt tđc
     SQL_STRING_WHERE := ' WHERE 1 = 1 ';  

     --Ủy thác tư pháp
     IF(NVL(LENGTH(V_UTTP),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND (EXISTS (SELECT 1 
                           FROM AHC_SOTHAM_THULY TL  
                           WHERE TL.UTTPDI = ' || TO_NUMBER(V_UTTP) || ' AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2)    
                   OR  EXISTS (SELECT 1 
                               FROM AHC_PHUCTHAM_THULY TLPT 
                               WHERE TLPT.UTTPDI = ' || TO_NUMBER(V_UTTP) || ' AND TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 3)   

                   )'
        ;
     END IF;

     IF(NVL(LENGTH(V_QHPL),0) > 0) THEN
        VV_QHPL := FN_CONVERT_TO_VN(LOWER(V_QHPL));
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND ( A.FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE ''%'|| VV_QHPL ||'%''  
                  )'
        ;
     END IF;

     IF(V_MA_THONG_BAO = 2) THEN
     VV_MA_VU_AN := FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN));
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND ( LOWER(TT.MA_THONGBAO) LIKE ''%'|| VV_MA_VU_AN ||'%''  
            )'        
            ;
     END IF;

     IF(NVL(LENGTH(V_TENDUONGSU),0) > 0) THEN
        VV_TENDUONGSU   := FN_CONVERT_TO_VN(LOWER(V_TENDUONGSU));
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND (EXISTS (SELECT 1 
                           FROM AHC_DON_DUONGSU DS 
                           WHERE FN_CONVERT_TO_VN(LOWER(DS.TENDUONGSU)) LIKE ''%'|| VV_TENDUONGSU ||'%'' AND DS.DONID = A.ID)
                  )'
        ;
     END IF;

     --Cấp xét xử
     IF(NVL(LENGTH(V_CAPXX),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND (GD.MAGIAIDOAN= '|| V_CAPXX ||'
                  )'
        ;
     END IF;

--     --Tòa án
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND ( (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPTINH'')) 
--                 OR (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPCAO'' AND T.LOAITOA != ''CAPHUYEN''))
--                  )'
--        ;

     --Thẩm phán và vai trò thẩm phán
     IF(NVL(TO_NUMBER(V_THAMPHAN_ID),0) > 0) THEN
            IF(NVL(LENGTH(V_VAITRO_THAMPHAN),0) = 0) THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE || 
                        ' AND EXISTS(SELECT 1 
                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1 
                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1 
                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC') THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                        ' AND EXISTS (SELECT 1 
                                      FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                      WHERE TP.DONID = A.ID AND TP.MAVAITRO IN (''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETPHUCTHAM'') 
                                      AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
                                      )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA') THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                        ' AND EXISTS(SELECT 1
                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETPHUCTHAM'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1
                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''THAMPHAN'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1
                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''THAMPHAN'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETDON') THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                         'AND EXISTS(SELECT 1 
                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                     WHERE TP.DONID = A.ID AND TP.MAVAITRO = '''|| V_VAITRO_THAMPHAN ||''' 
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN IN ('THAMPHANHDXX','THAMPHANDUKHUYET')) THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                         'AND EXISTS(SELECT 1 
                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
                                     WHERE TP.DONID = A.ID AND TP.MAVAITRO = '''|| V_VAITRO_THAMPHAN ||''' 
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1
                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''THAMPHAN'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
            END IF;
     END IF;

     --Thư ký
     IF(NVL(LENGTH(V_THUKY_ID),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND (EXISTS(SELECT 1 
                         FROM AHC_SOTHAM_HDXX TP 
                         WHERE TP.CANBOID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID) 
                  OR EXISTS(SELECT 1 
                            FROM AHC_PHUCTHAM_HDXX TP 
                            WHERE TP.CANBOID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID)
                  OR EXISTS(SELECT 1 
                            FROM AHC_DON_THAMPHAN TP 
                            WHERE TP.THUKYID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID) 
                  )'
        ;
     END IF;     

     --Loại đơn
     IF(NVL(LENGTH(V_LOAIDON),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (A.LOAIDON = '|| V_LOAIDON || '
                  )'
        ;
     END IF;

     --Giải quyết đơn;
     IF(NVL(LENGTH(V_GQDON),0) > 0) THEN
        IF(V_GQDON IN (1,3,4,5)) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND EXISTS (SELECT 1 
                                  FROM AHC_DON_XULY XL 
                                  WHERE XL.LOAIGIAIQUYET = '|| V_GQDON ||' AND XL.DONID = A.ID) '
                ;
            ELSIF(V_GQDON = 6) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND NOT EXISTS (SELECT 1 
                                      FROM AHC_DON_XULY XL 
                                      WHERE XL.DONID = A.ID) '
                ;
            ELSIF(V_GQDON = 7) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND NOT EXISTS (SELECT 1 
                                      FROM AHC_DON_XULY XL 
                                      WHERE XL.DONID=A.ID) 
                      AND (SYSDATE-A.NGAYNHANDON) > 15 '
                ;
            ELSIF(V_GQDON = 8) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND NOT EXISTS(SELECT 1 
                                     FROM AHC_DON_XULY XL 
                                     WHERE XL.DONID = A.ID)
                      AND NOT EXISTS(SELECT 1 
                                     FROM AHC_DON_THAMPHAN TP 
                                     WHERE TP.DONID = A.ID) '
                ;
        END IF;
     END IF;

     IF(VCHECKTK != 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS(
                    (SELECT 1 
                    FROM AHC_DON_THAMPHAN TP 
                    WHERE TP.DONID = A.ID AND TP.THUKYID = '|| VCHECKTK ||'
                                          AND TP.MAVAITRO = DECODE(A.MAGIAIDOAN,2,''VTTP_GIAIQUYETSOTHAM'',3,''VTTP_GIAIQUYETPHUCTHAM'','''') 
                    )
                   )'
        ;
     END IF;    

     --Số BA/QĐ             
     IF(NVL(LENGTH(V_SO_QD),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE ''%'|| V_SO_QD ||'%'' AND A.ID=QSV.DONID  )
                    OR EXISTS(SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
                    OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
                    OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
                   )
                  )'
        ;
     END IF;    

     --Ngày BA/QĐ
     IF(NVL(LENGTH(V_NGAY_QD),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   OR EXISTS(SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   )
                  )'
        ;
     END IF; 

     --Số thụ lý
     IF(V_LOAI_TBTL = 1) THEN
             IF(NVL(LENGTH(V_SOTHULY),0) > 0) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND (UPPER(TLS.SOTHULY) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                           OR UPPER(TLPT.SOTHULY) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                          )'
                ;
             END IF;
        ELSIF (V_LOAI_TBTL = 2) THEN
             IF(NVL(LENGTH(V_SOTHULY),0) > 0) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND (UPPER(TLS.SOTHONGBAO) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                           OR UPPER(TLPT.SOTHONGBAO) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                          )'
                ;
             END IF;
     END IF;

     --Tình trạng thụ lý và ngày thụ lý
     IF(NVL(LENGTH(V_TINHTRANG_THULY),0) = 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((GD.MAGIAIDOAN = 2 AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON >= '|| VV_NGAYTHULY_TU ||') 
                                      AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'))
                    OR EXISTS (SELECT 1 
                               FROM AHC_CHUYEN_NHAN_AN CNA 
                               WHERE GD.MAGIAIDOAN = 3 AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN >= '|| VV_NGAYTHULY_TU ||') 
                                                       AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN <= '|| VV_NGAYTHULY_DEN ||'))
                  )'
        ;
     END IF;
     IF(V_TINHTRANG_THULY LIKE '1') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((TLS.DONID IS NOT NULL 
                     AND (TLS.NGAYTHULY >= '|| VV_NGAYTHULY_TU ||') 
                     AND (TLS.NGAYTHULY <= '|| VV_NGAYTHULY_DEN ||') 
                    )
                    OR (TLPT.DONID IS NOT NULL
                        AND (TLPT.NGAYTHULY >= '|| VV_NGAYTHULY_TU ||') 
                        AND (TLPT.NGAYTHULY <= '|| VV_NGAYTHULY_DEN ||') 
                        )     
                   )'
        ;
     END IF;
     IF(V_TINHTRANG_THULY LIKE '2') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( (TLS.DONID IS NOT NULL AND GD.MAGIAIDOAN = 2 AND ( TLS.NGAYTHULY > '|| VV_NGAYTHULY_DEN ||'))
                     OR (TLS.DONID IS NULL AND GD.MAGIAIDOAN = 2 AND ( A.NGAYNHANDON >= '|| VV_NGAYTHULY_TU ||' 
                                                                       OR EXISTS( SELECT 1 
                                                                                  FROM AHC_DON_THAMPHAN PC 
                                                                                  WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                                        AND PC.NGAYPHANCONG >= '|| VV_NGAYTHULY_TU ||'
                                                                                        AND A.ID = PC.DONID
                                                                                )
                                                                       OR XLD.NGAYGQ_YC >= '|| VV_NGAYTHULY_TU ||'
                                                                       )
                                                                 AND ( XLD.NGAYGQ_YC <= '|| VV_NGAYTHULY_DEN ||' 
                                                                       OR EXISTS( SELECT 1 
                                                                                  FROM AHC_DON_THAMPHAN PC 
                                                                                  WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                                        AND XLD.NGAYGQ_YC IS NULL
                                                                                        AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
                                                                                        AND A.ID = PC.DONID
                                                                                )
                                                                        OR (NOT EXISTS( SELECT 1 
                                                                                        FROM V_TABLE_VUAN D
                                                                                            LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
                                                                                        WHERE PC.NGAYPHANCONG IS NULL
                                                                                       ) 
                                                                             OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'
                                                                            )
                                                                      )
                            )
                         -- CHƯA THỤ LÝ PHÚC THẨM
                         OR (TLPT.DONID IS NOT NULL AND GD.MAGIAIDOAN=3 AND EXISTS( SELECT 1 
                                                                                    FROM AHC_CHUYEN_NHAN_AN CNA
                                                                                    WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                                                                   )
                                                                        AND (TLPT.NGAYTHULY> '|| VV_NGAYTHULY_DEN ||')
                            )
                         OR (TLPT.DONID IS NULL AND GD.MAGIAIDOAN=3 AND EXISTS( SELECT 1 
                                                                                FROM AHC_CHUYEN_NHAN_AN CNA
                                                                                WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                                                              )
                                                AND ( EXISTS( SELECT 1 FROM AHC_CHUYEN_NHAN_AN CNA
                                                              WHERE GD.MAGIAIDOAN = 3
                                                                    AND CNA.NGAYNHAN >='|| VV_NGAYTHULY_TU ||' 
                                                             )
                                                      OR XLD.NGAYGQ_YC >= '|| VV_NGAYTHULY_TU ||'
                                                      OR EXISTS( SELECT 1 
                                                                 FROM AHC_DON_THAMPHAN PC 
                                                                 WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                    AND XLD.NGAYGQ_YC IS NULL
                                                                    AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
                                                                    AND A.ID = PC.DONID
                                                                )
                                                     )
                                                AND ( XLD.NGAYGQ_YC <= '|| VV_NGAYTHULY_DEN ||' 
                                                                              OR EXISTS( SELECT 1 FROM AHC_DON_THAMPHAN PC 
                                                                                         WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                                             AND XLD.NGAYGQ_YC IS NULL
                                                                                             AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
                                                                                             AND A.ID = PC.DONID
                                                                                        )
                                                                               OR (NOT EXISTS( SELECT 1 
                                                                                               FROM V_TABLE_VUAN D
                                                                                                   LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
                                                                                               WHERE PC.NGAYPHANCONG IS NULL
                                                                                              ) 
                                                                                   OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'
                                                                                   )
                                                     )
                              )
                  )'
        ;
     END IF;              


     -- Turning được
     -- Phiên tòa rút kinh nghiệm;
     IF(V_PT_RKINHNGHIEM LIKE '1') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
         ' AND (EXISTS(SELECT 1 
                       FROM AHC_SOTHAM_BANAN BA
                           LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
                       WHERE SXX.ST_ISRUTKN = 1 -- trường phân biệt sơ thẩm rút kinh nghiệm
                             AND BA.DONID = A.ID AND GD.MAGIAIDOAN=2
                       )
                OR EXISTS(SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN BA
                             LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
                          WHERE SXX.PT_ISRUTKN = 1 -- trường phân biệt phúc thẩm rút kinh nghiệm
                                AND BA.DONID = A.ID AND GD.MAGIAIDOAN=3
                          )
                )'
        ;
     END IF;
     IF(V_PT_RKINHNGHIEM LIKE '2') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
         ' AND ( NOT EXISTS(SELECT 1
                            FROM AHC_SOTHAM_BANAN BA
                                LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                            WHERE SXX.ST_ISRUTKN = 1 --PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                                  AND BA.DONID =A.ID AND GD.MAGIAIDOAN=2
                            )
                 AND NOT  EXISTS(SELECT 1 
                                 FROM AHC_PHUCTHAM_BANAN BA
                                    LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                                 WHERE SXX.PT_ISRUTKN=1 --PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                                       AND BA.DONID =A.ID AND GD.MAGIAIDOAN=3
                                 )
                )'
        ;
     END IF;

    --Kết quả xét xử phúc thẩm;
    IF(V_KETQUA LIKE '1') THEN --Giữ nguyên quyết định/bản án sơ thẩm
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
          ' AND EXISTS( SELECT 1 
                        FROM AHC_PHUCTHAM_BANAN PB 
                            LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                        WHERE INSTR('',01,18,'','',''||KQPT.MA||'','') > 0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN=3
                       )'
        ;
    END IF;
    IF(V_KETQUA LIKE '2') THEN --Hủy quyết định/bản án sơ thẩm để...
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS( SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN PB 
                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                          WHERE INSTR('',03,04,06,12,13,14,15,21,'','',''||KQPT.MA||'','') > 0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN=3
                         )'
        ;
    END IF;
    IF(V_KETQUA LIKE '3') THEN --...Sửa 1 phần bản án/QĐ sơ thẩm
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS( SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN PB 
                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                          WHERE INSTR(''02'',KQPT.MA)>0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN = 3
                         )'
        ;
    END IF;
    IF(V_KETQUA LIKE '4') THEN --...Sửa toàn bộ bản án/QĐ sơ thẩm
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS( SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN PB 
                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                          WHERE INSTR(''05'',KQPT.MA)>0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN = 3
                         )'
        ;
    END IF;

    ----Thời hạn Giải quyết;
    IF(V_THOIHAN_GQ LIKE '1') THEN --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                    EXISTS(SELECT 1 
                           FROM AHC_SOTHAM_THULY TL
                               LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                               LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                               LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                               LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                           WHERE( ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA - TL.NGAYTHULY) > 180 )
                                    OR ( BA.ID IS NULL AND INSTR('',DC,CVA,HPT,GHTHXX,'','',''|| QDL.MA ||'','') = 0 AND (SYSDATE - TL.NGAYTHULY) > 180)
                                   )
                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                            )
                    --dùng ngày quyết định và đình chỉ vụ án   
                    OR  EXISTS (SELECT 1 
                                FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                 WHERE ( ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') > 0 AND  (QSV.NGAYQD - TL.NGAYTHULY) > 180  ) --CVA QĐ chuyển vụ án, HPT Hoãn phiên tòa, GHTHXX QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 AND  BA.ID IS NULL AND (SYSDATE - TL.NGAYTHULY) > 180 )
                                          )
                                       AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                                 )
                     --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                     OR EXISTS (SELECT 1 
                                FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                 WHERE ( (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA - TL.NGAYTHULY) > 90 )
                                         OR (BA.ID IS NULL AND INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 AND  (SYSDATE - TL.NGAYTHULY) > 90 )
                                       )
                                       AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                                )
                       --dùng ngày QĐ phúc thẩm  
                       OR EXISTS (SELECT 1 
                                  FROM AHC_PHUCTHAM_THULY TL 
                                      LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID 
                                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QSV.LOAIQDID 
                                  WHERE ( ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') > 0  AND(QSV.NGAYQD - TL.NGAYTHULY) > 90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0  AND(SYSDATE - TL.NGAYTHULY) > 90)
                                    )
                                     AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                                 ) 
                   )'
        ;
    END IF;         
    IF(V_THOIHAN_GQ LIKE '2') THEN --Còn thời hạn dưới 10 ngày
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (--Sơ thẩm chưa có quyết định và chưa có bản án
                  EXISTS(SELECT 1 
                         FROM AHC_SOTHAM_THULY TL
                             LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                             LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                         WHERE (SYSDATE - TL.NGAYTHULY) >= 170 AND (SYSDATE - TL.NGAYTHULY) < 180 
                                AND BA.ID IS NULL 
                                AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                         )
                 --phúc thẩm   
                 OR EXISTS (SELECT 1 
                            FROM AHC_PHUCTHAM_THULY TL 
                                LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
                                LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                            WHERE (SYSDATE - TL.NGAYTHULY) >= 80 AND (SYSDATE - TL.NGAYTHULY) < 90 
                                   AND BA.ID IS NULL
                                   AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                   AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                           ) 
                  )'
        ;
    END IF;
    IF(V_THOIHAN_GQ LIKE '3') THEN --chưa có quyết định và chưa có bản án
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (--Sơ thẩm 
                  EXISTS(SELECT 1 
                         FROM AHC_SOTHAM_THULY TL
                             LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                             LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                         WHERE (SYSDATE - TL.NGAYTHULY) >= 160 AND (SYSDATE - TL.NGAYTHULY) < 180 
                                AND BA.ID IS NULL
                                AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                         )
                   --phúc thẩm   
                   OR EXISTS (SELECT 1 
                              FROM AHC_PHUCTHAM_THULY TL 
                                  LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
                                  LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                              WHERE (SYSDATE - TL.NGAYTHULY) >= 70 AND (SYSDATE - TL.NGAYTHULY) < 90 
                                    AND BA.ID IS NULL
                                    AND  (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                    AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                              ) 
                   )'  
        ;
    END IF;          

    --Tình trạng GQ;
    IF(NVL(LENGTH(V_TINHTRANG_GIAIQUYET),0) = 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
             'AND (
                    ( GD.MAGIAIDOAN = 2
                        AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON>= '|| VV_TUNGAY ||') 
                        AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON<= '|| VV_DENNGAY ||')
                    )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_CHUYEN_NHAN_AN CNA
                                WHERE GD.MAGIAIDOAN = 3
                                    AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN >= '|| VV_NGAYTHULY_TU ||') 
                                    AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN <= '|| VV_NGAYTHULY_DEN ||')
                                )
                  )'
        ;
    END IF;
    IF(V_TINHTRANG_GIAIQUYET LIKE '1') THEN --Chưa giải quyết xong
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
           ' 
                AND 
                (
                    NOT EXISTS (SELECT 1 FROM AHC_DON_XULY XL WHERE XL.DONID = A.ID AND XL.LOAIGIAIQUYET IN (1,3))
                )
                AND 
                 (   
                     (   GD.MAGIAIDOAN = 2 -- SƠ THẨM
                         AND
                         (
                             ( EXISTS (SELECT 1 FROM AHC_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
                                       WHERE A.ID = QDVA.DONID AND QDVA.NGAYQD >= '|| VV_DENNGAY ||')
                                       OR
                               EXISTS (SELECT 1 FROM AHC_SOTHAM_BANAN BA WHERE A.ID = BA.DONID AND BA.NGAYTUYENAN >= '|| VV_DENNGAY ||')

                             )
                             OR 
                             ( NOT EXISTS (SELECT 1 FROM AHC_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
                               AND NOT EXISTS (SELECT 1 FROM AHC_SOTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                         )
                     )
                     OR
                     (   GD.MAGIAIDOAN = 3 -- PHÚC THẨM
                         AND
                         (
                             ( EXISTS (SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
                                       WHERE A.ID = QDVA.DONID AND QDVA.NGAYQD >= '|| VV_DENNGAY ||' )
                                       OR
                               EXISTS (SELECT 1 FROM AHC_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID AND BA.NGAYTUYENAN >= '|| VV_DENNGAY ||')

                             )
                             OR 
                             ( NOT EXISTS (SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
                               AND NOT EXISTS (SELECT 1 FROM AHC_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                         )
                     )
                 )'
        ;
    END IF;  
    IF(V_TINHTRANG_GIAIQUYET LIKE '2') THEN --chưa phân công Thẩm phán
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
             'AND (EXISTS(SELECT 1 
                          FROM AHC_SOTHAM_THULY STTL
                          WHERE STTL.DONID =  A.ID 
                              AND ( STTL.NGAYTHULY >= '|| VV_TUNGAY ||')
                              AND ( STTL.NGAYTHULY <= '|| VV_DENNGAY ||')
                          )
                  OR EXISTS(SELECT 1 
                            FROM AHC_PHUCTHAM_THULY PTTL 
                            WHERE PTTL.DONID = A.ID
                                AND( PTTL.NGAYTHULY >= '|| VV_TUNGAY ||')
                                AND( PTTL.NGAYTHULY <= '|| VV_DENNGAY ||')
                            )
                  )
              AND (NOT EXISTS (SELECT 1 
                               FROM AHC_DON_THAMPHAN PC 
                               WHERE PC.DONID=A.ID
                                    AND ((PC.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM'' AND GD.MAGIAIDOAN = 2)--sơ thẩm
                                        OR (PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 3)--phuc thẩm
                                        OR ( PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 7 )
                                        )
                                    AND ( PC.NGAYPHANCONG >= '|| VV_TUNGAY ||') 
                                    AND ( PC.NGAYPHANCONG <= '|| VV_DENNGAY ||')  
                                )
                   )'
        ;
    END IF;
    IF(V_TINHTRANG_GIAIQUYET = 3) THEN --đã phân công Thẩm phán
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS (SELECT 1 
                          FROM AHC_DON_THAMPHAN PC 
                          WHERE PC.DONID=A.ID
                              AND ((PC.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM'' AND GD.MAGIAIDOAN = 2)--sơ thẩm
                                  OR(PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 3)--phuc thẩm
                                  )
                              AND ( PC.NGAYPHANCONG >= '|| VV_TUNGAY ||') AND (PC.NGAYPHANCONG <= '|| VV_DENNGAY ||')  
                       )'
        ;
    END IF;                 
    IF(V_TINHTRANG_GIAIQUYET LIKE '4') THEN --đã lên lịch xét xử
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE QDL.MA = ''DVARXX''  --DVARXX - Đưa vụ án ra xét xử
                                AND ( QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND ( QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
                           )
                        OR EXISTS( SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH PTQDVA
                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                   WHERE QDL.MA = ''DVARXX'' AND PTQDVA.DONID IS NULL
                                       AND ( PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                       AND ( PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                       AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
                                  )
                    )'
        ;
    END IF;       
    IF(V_TINHTRANG_GIAIQUYET LIKE '5') THEN --Đang hoãn
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( EXISTS (SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID 
                            WHERE QDL.MA = ''HPT'' AND BA.ID IS NULL
                                AND (  QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
                             )
                    --Đang hoãn phuc tham                 
                    OR EXISTS (SELECT 1 
                               FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                  LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
                                  LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID   
                               WHERE PTBA.DONID IS NULL  AND QDL.MA = ''HPT'' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                  AND (  PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                  AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                  AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
                            )    
                       )'
        ;
    END IF;
    IF(V_TINHTRANG_GIAIQUYET LIKE '6') THEN --Đang tạm đình chỉ
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            '--so tham Đang tạm đình chỉ 
              AND (EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID 
                            WHERE QDL.MA = ''TDC''  
                                AND BA.DONID IS NULL  -- chưa có bản án
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                          )
              --phuc tham Đang tạm đình chỉ                
                    OR EXISTS ( SELECT 1 
                                FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTQDVA.DONID --BẢN ÁN 
                                WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA = ''TDC'' --Tạm đình chỉ
                                    AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                    AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                    AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )
                  )'
        ;
    END IF;           
    IF(V_TINHTRANG_GIAIQUYET LIKE '7') THEN --Đã giải quyết xong
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( EXISTS (SELECT 1 
                            FROM AHC_SOTHAM_BANAN BA
                            WHERE BA.SOBANAN IS NOT NULL
                                AND (BA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                AND (BA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                AND BA.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                         )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                    AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                    AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                              )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_PHUCTHAM_BANAN PTBA 
                                WHERE PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                    AND (PTBA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                    AND PTBA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                    AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                    AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )   
					  OR EXISTS ( SELECT 1 
								FROM AHC_DON_XULY ADX 
								WHERE ADX.LOAIGIAIQUYET IN (1, 3)
									AND (ADX.NGAYGQ_YC >= '|| VV_TUNGAY ||')
									AND (ADX.NGAYGQ_YC <= '|| VV_DENNGAY ||')
									AND ADX.DONID = A.ID  AND GD.MAGIAIDOAN = 2  )    
                )'
        ;
    END IF;                
    IF(V_TINHTRANG_GIAIQUYET LIKE '8') THEN --Đã xét xử
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_BANAN BA
                            WHERE  BA.SOBANAN IS NOT NULL
                                AND (BA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                AND (BA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                AND BA.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                           )
                   OR EXISTS ( SELECT 1 
                               FROM AHC_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                                   AND (PTBA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                   AND (PTBA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                   AND PTBA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )    
                  )'
        ;
    END IF;            
    IF(V_TINHTRANG_GIAIQUYET LIKE '9') THEN --Đình chỉ
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE INSTR('',DC,'','',''||QDL.MA||'','')>0
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                            )
                   OR EXISTS ( SELECT 1 
                               FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                   LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                               WHERE  INSTR('',DC,'','',''||QDL.MA||'','')>0
                                   AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                   AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                   AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                              )       
                 )'
        ;
    END IF; 
    IF(V_TINHTRANG_GIAIQUYET LIKE '10') THEN --Công nhận thỏa thuận của đương sự
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR('',CNTT,'','',''||QDL.MA||'','')>0
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID=A.ID  AND GD.MAGIAIDOAN = 2
                           )
                   )'
        ;
    END IF;                 
    IF(V_TINHTRANG_GIAIQUYET LIKE '11') THEN --QĐ chuyển vụ án
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE INSTR('',CVA,'','',''||QDL.MA||'','') > 0
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
                            )
                   OR EXISTS( SELECT 1 
                              FROM AHC_CHUYEN_NHAN_AN CA 
                              WHERE CA.VUANID=A.ID AND CA.TOACHUYENID = '|| V_TOAAN_ID ||' AND GD.MAGIAIDOAN = 2)      
                   OR EXISTS( SELECT 1 
                              FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                              WHERE INSTR('',CVA,'','',''||QDL.MA||'','') > 0
                                  AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                  AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                  AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
                             )       
                   )'
        ;
    END IF;  

    --TOANCAU-1-11-2024    
    IF(NVL(V_CHECK_HOAGIAI,0) = 0) THEN
            SQL_STRING_WHERE := SQL_STRING_WHERE || ' AND (NVL('||V_CHECK_HOAGIAI||',0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) ';
        ELSE 
            SQL_STRING_WHERE := SQL_STRING_WHERE ||
                  'AND (
                                    '||V_CHECK_HOAGIAI||' > 0 )';

            IF(V_HOAGIAI_TRANGTHAI != 0) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE ||  
                          ' AND ( ('||V_HOAGIAI_TRANGTHAI||' = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) >= 1)
                                  OR ('||V_HOAGIAI_TRANGTHAI||' = 1 AND NVL(A.HOAGIAI_TRANGTHAI,0) >= 1
                                                                    AND NOT EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ 
                                                                                    WHERE KQ.HOAGIAIID = HGD.ID))
                                  OR ('||V_HOAGIAI_TRANGTHAI||' = A.HOAGIAI_TRANGTHAI)) ';
            END IF;

            IF(V_HOAGIAI_TUNGAY NOT LIKE '') THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                              '  AND ( EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ
                                                    WHERE KQ.NGAYHOAGIAI >= '||VV_HOAGIAI_TUNGAY||' AND KQ.HOAGIAIID = HGD.ID)
                                    )';
            END IF;  

            IF(VV_HOAGIAI_DENNGAY NOT LIKE '') THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                              ' AND ( EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ
                                                        WHERE KQ.NGAYHOAGIAI <= '||VV_HOAGIAI_DENNGAY||' AND KQ.HOAGIAIID = HGD.ID)
                                        ) ';
            END IF;                            

            IF(V_THAMPHAN_ID IS NOT NULL) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                              ' AND ( EXISTS (SELECT 1 FROM HOAGIAI_THAMPHAN HGTP
                                                        WHERE HGTP.THAMPHANID = '||V_THAMPHAN_ID||' AND HGTP.HOAGIAIID = HGD.ID)
                                        ) ';
            END IF;  

            IF(V_VAITRO_THAMPHAN IS NOT NULL) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                             '  AND ( EXISTS (SELECT 1 FROM HOAGIAI_THAMPHAN TPHG
                                                          WHERE TPHG.MAVAITRO= ''VTTP_HOAGIAI'' AND TPHG.HOAGIAIID=HGD.ID)
                                        ) ';
            END IF; 
    END IF;
    IF (V_AN_KET_THUC = 1) THEN
            SQL_STRING_WHERE := SQL_STRING_WHERE || '
                AND(EXISTS (SELECT 1 FROM AHC_DON_GIAIDOAN BC
                                        WHERE  BC.DONID = A.ID
                                          AND (
                                            (BC.MAGIAIDOAN = 2 AND BC.TOAANID = '|| V_TOAAN_ID ||') OR
                                            (BC.MAGIAIDOAN in (3,7) AND BC.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                                          )
                                          AND BC.AN_DA_KET_THUC = 1)                                      
                             )';
     ELSIF(V_AN_KET_THUC = 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE || '
            AND(NOT EXISTS (SELECT 1 FROM AHC_DON_GIAIDOAN BC
                                    WHERE BC.DONID = A.ID
                                      AND (
                                        (BC.MAGIAIDOAN = 2 AND BC.TOAANID = '|| V_TOAAN_ID ||') OR
                                        (BC.MAGIAIDOAN in (3,7) AND BC.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                                      )
                                      AND BC.AN_DA_KET_THUC = 1)                                      
                         )';
    END IF;

    OPEN CURRETURN FOR
        SQL_STRING_WITH ||
        'SELECT  TTT.ID,
                TTT.MAVUVIEC,
                TTT.TENVUVIEC,
                TTT.SOTHUTU,
                TTT.NGAYNHANDON,
                TTT.HINHTHUCNHANDON,
                TTT.MAGIAIDOAN,
                TTT.QHPLTKID,
                TTT.TOAANID,
                TTT.QUANHEPL,
                TTT.BANAN_QD_ST,
                TTT.QD_PT,
                TTT.KHANGNGHI_ST,
                TTT.CHECK_THULY,
                TTT.HOTENBICAN,
                TTT.COUNTALL,
                TTT.STT,
                TO_CHAR(DECODE(GD_MAGIAIDOAN,2, A_NGAYTAO, 3, GN_NGAYTAO_PHUCTHAM,''''),''DD/MM/YYYY'') NGAY_TAO,
                DECODE(GD_MAGIAIDOAN,2, A_NGUOITAO,3,GN_NGUOITAO_PHUCTHAM,'''') NGUOITAO,
                DECODE(GD_MAGIAIDOAN,2, TO_CHAR(A_NGAYTAO,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(A_NGAYTAO,'' HH24:MI:SS''), 3, TO_CHAR(GN_NGAYTAO_PHUCTHAM,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(GN_NGAYTAO_PHUCTHAM,'' HH24:MI:SS''), '''') NGAYTAO,
                DECODE(GD_MAGIAIDOAN,3,''</br><i>Tòa xét xử sơ thẩm: </i><b>''||T_TEN||''</b>'',NULL) TENTOASOTHAM, 
                DECODE(GD_MAGIAIDOAN,2, ''Sơ thẩm'',3,''Phúc thẩm'', 4,''Thụ lý Giám đốc thẩm'','''')GIAIDOANVUVIEC,
				CASE WHEN GD_MAGIAIDOAN = 2 THEN 
                	DECODE(A_HINHTHUCNHANDON,1,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',270, ''<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'',2597,''<br/><i>TH giao nhận:</i> <b>Giám đốc thẩm hủy để xét xử lại sơ thẩm</b>'',''<br/><i>TH giao nhận:</i> <b>''|| GN_TRUONGHOPGIAONHAN||''</b>'')
				WHEN GD_MAGIAIDOAN = 3 THEN 
					DECODE(A_HINHTHUCNHANDON,1,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',270, ''<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'',2597,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',''<br/><i>TH giao nhận:</i> <b>''|| GN_TRUONGHOPGIAONHAN||''</b>'')
				END TRUONGHOPGIAONHAN,
                PKG_STPT_AHC_GS.NOIDUNG_KHANGCAO_DANHSACH(A_ID) AS KHANGCAO_ST,
                DECODE(XLD_LOAIGIAIQUYET,1,''- Đã chuyển đơn'',
                                                             CASE WHEN (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) IS NULL 
                                                                  THEN ''- Chưa thụ lý''
                                                                  ELSE (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) 
                                                             END  
                                                           ||CASE WHEN (TPPC_TINHTRANG_GQ || TPPCPT_TINHTRANG_GQ) IS NULL AND (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) IS NOT NULL  
                                                                  THEN ''</br>- Chưa phân công Thẩm phán'' 
                                                                  ELSE  (TPPC_TINHTRANG_GQ || TPPCPT_TINHTRANG_GQ) 
                                                             END

                                                           || QDST_TINHTRANG_GQ || QDPT_TINHTRANG_GQ
                                                           ||BAST_TINHTRANG_GQ||BAPT_TINHTRANG_GQ
                                                           ||GNST_TINHTRANG_GQ

                                                           --lanh thêm thông tin giải quyết của vụ án cha
                                                           ||CASE WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN IS NULL) 
                                                                  THEN (SELECT ''</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
                                                                                FROM AHC_DON D
                                                                                LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                WHERE D.ID = A_VUANGOCID)
                                                                  WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN = 1) 
                                                                  THEN (SELECT ''</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
                                                                            FROM V_TABLE_VUAN D
                                                                            LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                            WHERE D.ID = A_VUANGOCID)
                                                              END) TINHTRANG_GQ, '''' THAMPHANHG,
									DECODE(BA_ID,NULL,DECODE(QD_ID,NULL,DECODE(STBAKT_ID,NULL,DECODE(STQDKT_ID,NULL,NULL,4),4),3),3) THULYXXLAI -- VNPT HOANGNDH 03/12/2025

        FROM (SELECT TT.*, ROW_NUMBER() OVER (ORDER BY A_NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL
              FROM (' 
                      || SQL_STRING_SELECT || ' ' 
                      || SQL_STRING_JOIN || ' ' 
                      || SQL_STRING_WHERE || ' ' 
                      || ' ) TT
               ) TTT' || 
               CASE WHEN PAGE_INDEX = 0 AND PAGE_SIZE = 0 THEN ''
               ELSE ' WHERE TTT.STT >= '|| MININDEX ||' AND TTT.STT <= '|| MAXINDEX
               END;

END AHC_DON_SEARCH_TURNING;

PROCEDURE AHC_DON_SEARCH_TURNING_V2
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TEN_VU_AN             IN VARCHAR2,
    V_QHPL                  IN VARCHAR2, 
    V_MA_VU_AN              IN VARCHAR2, 
    V_TENDUONGSU            IN VARCHAR2,
    V_CAPXX                 IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2, 
    V_TINHTRANG_THULY       IN VARCHAR2,
    V_NGAYTHULY_TU          IN VARCHAR2, 
    V_NGAYTHULY_DEN         IN VARCHAR2,
    V_SOTHULY               IN VARCHAR2,
    V_THAMPHAN_ID           IN VARCHAR2, 
    V_TINHTRANG_GIAIQUYET   IN VARCHAR2,
    V_TUNGAY                IN VARCHAR2,
    V_DENNGAY               IN VARCHAR2,
    V_KETQUA                IN VARCHAR2,
    V_SO_QD                 IN VARCHAR2,
    V_NGAY_QD               IN VARCHAR2,
    V_THUKY_ID              IN VARCHAR2, 
    V_THOIHAN_GQ            IN VARCHAR2, 
    V_LOAIDON               IN VARCHAR2, 
    V_PT_RKINHNGHIEM        IN VARCHAR2, 
    V_GQDON                 IN VARCHAR2, 
    V_UTTP                  IN VARCHAR2,
    VCHECKTK                IN NUMBER,
    V_TRANGTHAIVUAN         IN NUMBER, -- CHƯA DÙNG ĐẾN
	V_VAITRO_THAMPHAN       IN VARCHAR2,
    V_LOAI_TBTL             IN NUMBER,
    V_MA_THONG_BAO          IN NUMBER, -- 1 Tim theo ma vu an, 2 tim theo ma thong bao an phi
	V_CHECK_HOAGIAI         IN NUMBER,--TOANCAU-1-11-2024
    V_HOAGIAI_TRANGTHAI     IN NUMBER DEFAULT NULL,
    V_HOAGIAI_TUNGAY        IN VARCHAR2 DEFAULT NULL,
    V_HOAGIAI_DENNGAY       IN VARCHAR2 DEFAULT NULL,
    V_AN_KET_THUC           IN NUMBER,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
)
IS 
    SQL_STRING_WITH         CLOB;
    SQL_STRING_SELECT       CLOB;
    SQL_STRING_JOIN         CLOB;
    SQL_STRING_WHERE        CLOB;
    SQL_STRING_VUAN         CLOB;

    TOTALITEM               NUMBER; 
    MININDEX                NUMBER; 
    MAXINDEX                NUMBER; 
    VV_TUNGAY               VARCHAR(250);
    VV_DENNGAY              VARCHAR(250); 
    VV_NGAYTHULY_TU         VARCHAR(250);
    VV_NGAYTHULY_DEN        VARCHAR(250);
    VV_HOAGIAI_TUNGAY       VARCHAR(250);--TOANCAU-1-11-2024
    VV_HOAGIAI_DENNGAY      VARCHAR(250);

    VV_TEN_VU_AN            VARCHAR(250);
    VV_QHPL                 VARCHAR(250);
    VV_TENDUONGSU           VARCHAR(250);
    VV_MA_VU_AN             VARCHAR(250);

BEGIN

     IF(PAGE_INDEX > 0 AND PAGE_SIZE > 0) THEN
         MININDEX := PAGE_SIZE*(PAGE_INDEX - 1) + 1;
         MAXINDEX := PAGE_INDEX*PAGE_SIZE ;
     END IF;

     IF(NVL(LENGTH(V_NGAYTHULY_TU),0) >0) THEN 
             VV_NGAYTHULY_TU := 'TO_DATE(TRIM('''|| V_NGAYTHULY_TU ||''') ||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';
         ELSE
            VV_NGAYTHULY_TU := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_NGAYTHULY_DEN),0) >0) THEN  
             VV_NGAYTHULY_DEN := 'TO_DATE(TRIM('''|| V_NGAYTHULY_DEN ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
          ELSE
             VV_NGAYTHULY_DEN := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_TUNGAY),0) >0) THEN  
            VV_TUNGAY := 'TO_DATE(TRIM('''|| V_TUNGAY ||''')||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';  
          ELSE
             VV_TUNGAY := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_DENNGAY),0) >0) THEN  
            VV_DENNGAY := 'TO_DATE(TRIM('''|| V_DENNGAY ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
          ELSE
             VV_DENNGAY := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
     END IF; 

     IF(NVL(LENGTH(V_HOAGIAI_TUNGAY),0) >0) THEN  --TOANCAU-1-11-2024
            VV_HOAGIAI_TUNGAY := 'TO_DATE(TRIM('''|| V_HOAGIAI_TUNGAY ||''')||'' 00:00:00'',''dd/MM/yyyy HH24:MI:SS'')';  
          ELSE
             VV_HOAGIAI_TUNGAY := 'TO_DATE(''01/01/0001'',''DD/MM/YYYY'')';
     END IF;  

     IF(NVL(LENGTH(V_HOAGIAI_DENNGAY),0) >0) THEN  --TOANCAU-1-11-2024
            VV_HOAGIAI_DENNGAY := 'TO_DATE(TRIM('''|| V_HOAGIAI_DENNGAY ||''')||'' 23:59:59'',''dd/MM/yyyy HH24:MI:SS'')'; 
          ELSE
             VV_HOAGIAI_DENNGAY := 'TO_DATE(''01/01/9999'',''DD/MM/YYYY'')';
     END IF; 

     -- gioi han data cua bang vu an/ Bỏ án pt tđc
     SQL_STRING_VUAN := 'SELECT * FROM AHC_DON A WHERE (A.TOAANID = ' || V_TOAAN_ID || ' OR A.TOAPHUCTHAMID = '|| V_TOAAN_ID || ') AND A.MAGIAIDOAN != 7 ';
     
     --Mã vụ việc/ma thong bao
     IF(NVL(LENGTH(V_MA_VU_AN),0) > 0) THEN
        IF(V_MA_THONG_BAO = 1) THEN
        VV_MA_VU_AN := FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN));
        SQL_STRING_VUAN := SQL_STRING_VUAN || 
            ' AND ( LOWER(A.MAVUVIEC) LIKE '''|| VV_MA_VU_AN ||'%''  
                  )'
        ;
        END IF;     
     END IF;

     --Tên vụ án
     IF(NVL(LENGTH(V_TEN_VU_AN),0) > 0) THEN
        VV_TEN_VU_AN := FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN));
        SQL_STRING_VUAN := SQL_STRING_VUAN || 
            ' AND ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE ''%'|| VV_TEN_VU_AN ||'%''
            )'        
            ;
     END IF;

     IF(V_CHECK_HOAGIAI > 0) THEN
     --Thêm tìm kiếm đơn theo trạng thái hòa giải        
        SQL_STRING_VUAN := SQL_STRING_VUAN || 
             ' AND ( (NVL('|| V_CHECK_HOAGIAI ||',0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) 
                      OR ('|| V_CHECK_HOAGIAI ||' > 0 AND A.HOAGIAI_TRANGTHAI > 0)
                   )'
        ;
     END IF;

     SQL_STRING_WITH := 
     '   WITH 
                V_TABLE_VUAN AS (
                ' || SQL_STRING_VUAN || '
                ),
                
                V_TABLE_TLST AS (SELECT /*+ MATERIALIZE */ DONID, ID
							FROM (
							SELECT tl.DONID, tl.ID, ROW_NUMBER() OVER (PARTITION BY tl.DONID ORDER BY NGAYTHULY DESC, tl.NGAYTAO DESC) AS rn
                                FROM AHC_SOTHAM_THULY tl 
                                JOIN V_TABLE_VUAN b ON tl.DONID = b.ID 
							)
							WHERE rn = 1
                      ),
                      
                V_TABLE_TLPT AS (SELECT DISTINCT tl.DONID, FIRST_VALUE(tl.ID) OVER (PARTITION BY tl.DONID ORDER BY NGAYTHULY DESC, tl.NGAYTAO DESC) AS ID
                      FROM  AHC_PHUCTHAM_THULY tl 
                      JOIN V_TABLE_VUAN b ON tl.DONID = b.ID
                      ),

                V_TABLE_THAMPHAN_GIAIQUYET AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM (SELECT TP.MAVAITRO,TP.DONID,TP.ID,TP.CANBOID, ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,(CASE WHEN TP.MAVAITRO IN( ''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETDON'') THEN 2 WHEN TP.MAVAITRO=''VTTP_GIAIQUYETPHUCTHAM'' THEN 3 END) MAGIAIDOAN
                                          FROM AHC_DON_THAMPHAN TP
                                          JOIN V_TABLE_VUAN b ON TP.DONID = b.ID) TP
                                    WHERE TP.ROWNUMBER = 1
                                    ),

                V_TABLE_THAMPHAN_HDXX_ST AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,2 MAGIAIDOAN
                                          FROM  AHC_SOTHAM_HDXX TP
                                          JOIN V_TABLE_VUAN b ON TP.DONID = b.ID
                                          WHERE MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

                V_TABLE_THAMPHAN_HDXX_PT AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,3 MAGIAIDOAN
                                          FROM  AHC_PHUCTHAM_HDXX TP
                                          JOIN V_TABLE_VUAN b ON TP.DONID = b.ID
                                          WHERE MAVAITRO IN(''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

                V_TABLE_BC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                                FROM (SELECT BC.ID, BC.DONID, BC.TENDUONGSU, BC.TUCACHTOTUNG_MA, ROW_NUMBER()  OVER (PARTITION BY BC.DONID ORDER BY BC.ISDAIDIEN DESC, BC.TENDUONGSU) ROWNUMBER
                                     FROM AHC_DON_DUONGSU BC
                                     JOIN V_TABLE_VUAN b ON BC.DONID = b.ID 
                                    WHERE ISDAIDIEN=0) BC 
                               WHERE BC.ROWNUMBER <= 3),

                V_TABLE_BC_KC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                        FROM AHC_DON_DUONGSU DS
                                        JOIN V_TABLE_VUAN b ON DS.DONID = b.ID
                                        WHERE EXISTS(SELECT 1 FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID))BC 
                                  WHERE BC.ROWNUMBER <=3)

        ';  

    SQL_STRING_SELECT := 
    '    SELECT DISTINCT A.ID,
                A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.HINHTHUCNHANDON,
                A.MAGIAIDOAN,
                A.QHPLTKID,
                A.TOAANID,
                I.TEN AS QUANHEPL,
                STBA.BANAN_QD_ST,
                '''' AS QD_PT,-- thêm trường QD_PT mặc định trống
                STKN.KHANGNGHI_ST,
                (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
                (BC3.HOTEN||BC2.HOTEN) HOTENBICAN,

                A.NGUOITAO A_NGUOITAO,
                GD.MAGIAIDOAN GD_MAGIAIDOAN,
                GN.NGUOITAO_PHUCTHAM GN_NGUOITAO_PHUCTHAM,

                A.NGAYTAO AS A_NGAYTAO,
                GN.NGAYTAO_PHUCTHAM GN_NGAYTAO_PHUCTHAM,
                T.TEN T_TEN,

                A.HINHTHUCNHANDON A_HINHTHUCNHANDON,
                GN.TRUONGHOPGIAONHAN GN_TRUONGHOPGIAONHAN,

                A.ID A_ID,

                XLD.LOAIGIAIQUYET XLD_LOAIGIAIQUYET,
                TLS.TINHTRANG_GQ TLS_TINHTRANG_GQ,
                TLPT.TINHTRANG_GQ TLPT_TINHTRANG_GQ,
                TPPC.TINHTRANG_GQ TPPC_TINHTRANG_GQ,
                TPPCPT.TINHTRANG_GQ TPPCPT_TINHTRANG_GQ,
                QDST.TINHTRANG_GQ QDST_TINHTRANG_GQ,
                QDPT.TINHTRANG_GQ QDPT_TINHTRANG_GQ,
                BAST.TINHTRANG_GQ BAST_TINHTRANG_GQ,
                BAPT.TINHTRANG_GQ BAPT_TINHTRANG_GQ,
                GNST.TINHTRANG_GQ GNST_TINHTRANG_GQ,
                A.VUANGOCID A_VUANGOCID,
                A.IS_TACHAN A_IS_TACHAN,

                BA.ID BA_ID,
                QD.ID QD_ID

        FROM V_TABLE_VUAN A 
     ';

     SQL_STRING_JOIN := 
     '      INNER JOIN (SELECT G.* 
                      FROM AHC_DON_GIAIDOAN G 
                      WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = '|| V_TOAAN_ID ||') 
                             OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                      ) GD ON A.ID=GD.DONID 

            LEFT JOIN AHC_ANPHI AI ON A.ID=AI.DONID

            LEFT JOIN DVCQG_THANH_TOAN TT ON TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC=6

            LEFT JOIN DM_DATAITEM I ON A.QUANHEPHAPLUATID=I.ID

            LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID

            -- lấy thông tin vụ án end  
            LEFT JOIN (SELECT PTBA.* 
                     FROM AHC_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     ) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3

            LEFT JOIN (SELECT PTQDVA.* 
                     FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                         LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                         LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                     WHERE  INSTR('',DC,'','',''||QDL.MA||'','') > 0
                     ) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN = 3 

            -- Lay ra trang thai giai quyet don
            LEFT JOIN (SELECT DONID, LOAIGIAIQUYET, NGAYGQ_YC 
                     FROM AHC_DON_XULY 
                     WHERE LOAIGIAIQUYET IN (1,5)
                     ) XLD ON A.ID = XLD.DONID

            --Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT T2.DONID, T2.TOAANID, T2.NGAYTHULY, T2.SOTHULY, T2.TRUONGHOPTHULY,  T2.SOTHONGBAO,
                            T2.QHPLTKID, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM AHC_SOTHAM_THULY T2
                     WHERE EXISTS(SELECT 1 
                                  FROM V_TABLE_TLST QDL 
                                  WHERE QDL.ID = T2.ID)
                     ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2 --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

            LEFT JOIN (SELECT T2.DONID, T2.NGAYTHULY, T2.SOTHULY,   T2.SOTHONGBAO,
                            T2.TRUONGHOPTHULY, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) || ''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM AHC_PHUCTHAM_THULY T2
                     WHERE EXISTS(SELECT 1 
                                  FROM V_TABLE_TLPT QDL 
                                  WHERE QDL.ID = T2.ID) --> Lấy thụ lý mới nhất
                     ) TLPT ON TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 3 

            LEFT JOIN (SELECT TP.DONID, ''</br>- Thẩm phán: <b>'' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || ''</b><i> (chủ tọa)</i>'' TINHTRANG_GQ
                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP
                         LEFT JOIN (SELECT HDXX.CANBOID, HDXX.DONID 
                                    FROM V_TABLE_THAMPHAN_HDXX_ST HDXX
                                    WHERE HDXX.MAVAITRO = ''THAMPHAN''
                                    ) HDXX ON HDXX.DONID = TP.DONID 
                         LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID  
					     LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
                     WHERE TP.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM''
                     )TPPC ON TPPC.DONID = A.ID AND GD.MAGIAIDOAN = 2 

            LEFT JOIN (SELECT TP.DONID,''</br>- Thẩm phán: <b>'' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || ''</b><i> (chủ tọa)</i>'' TINHTRANG_GQ
                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP
                        LEFT JOIN (SELECT HDXX.CANBOID, HDXX.DONID
                                   FROM V_TABLE_THAMPHAN_HDXX_PT HDXX
                                   WHERE HDXX.MAVAITRO = ''THAMPHAN''
                                   ) HDXX ON HDXX.DONID = TP.DONID
                        LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID 
                        LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID 
                     WHERE TP.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM''
                     )TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3                 

            LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI || '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
                   FROM AHC_SOTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID
                    GROUP BY QSV.DONID
                    ) QDST ON QDST.DONID = A.ID AND GD.MAGIAIDOAN=2

            LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI|| '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
                   FROM AHC_PHUCTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID
                    GROUP BY QSV.DONID
                    ) QDPT ON QDPT.DONID = A.ID AND GD.MAGIAIDOAN=3    

            LEFT JOIN (SELECT BA.DONID,''</br>- Bản án số: ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHC_SOTHAM_BANAN BA
                     WHERE  BA.SOBANAN IS NOT NULL
                     )BAST ON  BAST.DONID=A.ID AND GD.MAGIAIDOAN=2      

            LEFT JOIN (SELECT PTBA.DONID,''</br>- Bản án số: ''||PTBA.SOBANAN||'' ngày ''||TO_CHAR(PTBA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHC_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     )BAPT ON  BAPT.DONID=A.ID AND GD.MAGIAIDOAN=3  


            --trường hợp giao nhận add vào cột trạng thái     
            --sửa check đã chuyển lại án sơ thẩm     
            LEFT JOIN (SELECT CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
                    FROM(SELECT CA.ID, CA.VUANID, CA.TOACHUYENID, ''</br>- '' || I.TEN || ''</br>- Đã chuyển vụ án'' TINHTRANG_GQ,
                                ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN
                            FROM AHC_CHUYEN_NHAN_AN CA
                                INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                            WHERE CA.TOACHUYENID = '|| V_TOAAN_ID ||') CNA
                    WHERE CNA.RN = 1 AND NOT EXISTS (SELECT 1 
                                                     FROM AHC_CHUYEN_NHAN_AN CN1
                                                         JOIN AHC_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                                     WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = '|| V_TOAAN_ID ||' AND CN2.ID > CNA.ID )
                    )GNST ON  GNST.VUANID=A.ID AND GD.MAGIAIDOAN=2               

            --trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
            LEFT JOIN (SELECT CA.VUANID,I.TEN TRUONGHOPGIAONHAN, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM 
                      FROM DM_DATAITEM I 
                          INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=I.ID 
                      WHERE CA.TOANHANID='|| V_TOAAN_ID ||' AND NOT EXISTS (SELECT 1 FROM AHC_DON WHERE ID =NVL(CA.MAP_VUANID_NEW ,0) AND MAGIAIDOAN = 7)                      )GN ON  GN.VUANID=A.ID

            --bị cáo lấy cho sơ thẩm
            LEFT JOIN (SELECT BC.DONID, ''<br /><i>Đương sự khác:</i> <br />''|| LISTAGG (BC.TENDUONGSU||'' ''|| DECODE(BC.TUCACHTOTUNG_MA,''NGUYENDON'',''(Nguyên đơn)'',''BIDON'',''(Bị đơn)'',''QUYENNVLQ'',''(Người có quyền và NVLQ)'','' (''||BC.TUCACHTOTUNG_MA || '')'' ), ''<br/>'') WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                       FROM V_TABLE_BC BC
                       GROUP BY BC.DONID
                       )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2

            ------bị cáo kháng cáo lấy cho phúc thẩm    
            LEFT JOIN (SELECT BC.DONID,''<br /><i>Người kháng cáo:</i> <br />''|| LISTAGG (BC.TENDUONGSU||'' ''|| DECODE(BC.TUCACHTOTUNG_MA,''NGUYENDON'',''(Nguyên đơn)'',''BIDON'',''(Bị đơn)'',''QUYENNVLQ'',''(Người có quyền và NVLQ)'','' (''||BC.TUCACHTOTUNG_MA || '')'' ), ''<br/>'') WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                       FROM V_TABLE_BC_KC BC
                       GROUP BY BC.DONID
                      )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3

            ----- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.DONID,''<br />BA/QĐ sơ thẩm: <b>''||''Số ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'')||''</b>'' BANAN_QD_ST FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
            ------- lấy thông tin số ngày kháng nghị
            LEFT JOIN (SELECT KN.DONID, ''<br /><i>Kháng nghị:</i> <br />''|| LISTAGG (''Số ''||KN.SOKN||'' ngày ''||TO_CHAR(KN.NGAYKN,''dd/MM/yyyy''), ''<br/>'') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                       FROM  AHC_SOTHAM_KHANGNGHI KN
                       WHERE KN.TINHTRANG_GIAIQUYET != 3
                       GROUP BY KN.DONID
                      )STKN ON STKN.DONID=A.ID


            ----TOANCAU-1-11-2024
            LEFT JOIN HOAGIAI_DON HGD ON HGD.VUVIECID = A.ID AND HGD.LOAIANID = 6                      
            LEFT JOIN (SELECT TP.THAMPHANID,TP.HOAGIAIID,TP.ID,TP.NGAYPHANCONG,''<br/><i>Thẩm phán hoà giải:</i> <b>''|| CB.HOTEN||''</b>'' THAMPHANHG
                    FROM (SELECT ID,THAMPHANID,HOAGIAIID,NGAYPHANCONG,ROW_NUMBER() OVER (PARTITION BY HOAGIAIID ORDER BY NGAYPHANCONG DESC) RN
                        FROM HOAGIAI_THAMPHAN WHERE THAMPHANID IS NOT NULL)TP
                        JOIN DM_CANBO CB ON CB.ID = TP.THAMPHANID
                    WHERE ( '||NVL(V_THAMPHAN_ID,'''''')||' IS NOT NULL AND '||NVL(V_THAMPHAN_ID,'''''')||' = TP.THAMPHANID )
                                          OR( '||NVL(V_THAMPHAN_ID,'''''')||' IS NULL and RN=1)) TPHG ON HGD.ID = TPHG.HOAGIAIID   
     ';

     --Bỏ án pt tđc
     SQL_STRING_WHERE := ' WHERE 1 = 1 ';  

     --Ủy thác tư pháp
     IF(NVL(LENGTH(V_UTTP),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND (EXISTS (SELECT 1 
                           FROM AHC_SOTHAM_THULY TL  
                           WHERE TL.UTTPDI = ' || TO_NUMBER(V_UTTP) || ' AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2)    
                   OR  EXISTS (SELECT 1 
                               FROM AHC_PHUCTHAM_THULY TLPT 
                               WHERE TLPT.UTTPDI = ' || TO_NUMBER(V_UTTP) || ' AND TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 3)   

                   )'
        ;
     END IF;

     IF(NVL(LENGTH(V_QHPL),0) > 0) THEN
        VV_QHPL := FN_CONVERT_TO_VN(LOWER(V_QHPL));
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND ( A.FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE ''%'|| VV_QHPL ||'%''  
                  )'
        ;
     END IF;

     IF(V_MA_THONG_BAO = 2) THEN
     VV_MA_VU_AN := FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN));
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND ( LOWER(TT.MA_THONGBAO) LIKE ''%'|| VV_MA_VU_AN ||'%''  
            )'        
            ;
     END IF;

     IF(NVL(LENGTH(V_TENDUONGSU),0) > 0) THEN
        VV_TENDUONGSU   := FN_CONVERT_TO_VN(LOWER(V_TENDUONGSU));
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND (EXISTS (SELECT 1 
                           FROM AHC_DON_DUONGSU DS 
                           WHERE FN_CONVERT_TO_VN(LOWER(DS.TENDUONGSU)) LIKE ''%'|| VV_TENDUONGSU ||'%'' AND DS.DONID = A.ID)
                  )'
        ;
     END IF;

     --Cấp xét xử
     IF(NVL(LENGTH(V_CAPXX),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND (GD.MAGIAIDOAN= '|| V_CAPXX ||'
                  )'
        ;
     END IF;

--     --Tòa án
--        SQL_STRING_WHERE := SQL_STRING_WHERE || 
--            ' AND ( (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPTINH'')) 
--                 OR (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPCAO'' AND T.LOAITOA != ''CAPHUYEN''))
--                  )'
--        ;

     --Thẩm phán và vai trò thẩm phán
     IF(NVL(TO_NUMBER(V_THAMPHAN_ID),0) > 0) THEN
            IF(NVL(LENGTH(V_VAITRO_THAMPHAN),0) = 0) THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE || 
                        ' AND EXISTS(SELECT 1 
                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1 
                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1 
                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
                                     WHERE TP.DONID = A.ID AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC') THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                        ' AND EXISTS (SELECT 1 
                                      FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                      WHERE TP.DONID = A.ID AND TP.MAVAITRO IN (''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETPHUCTHAM'') 
                                      AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
                                      )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA') THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                        ' AND EXISTS(SELECT 1
                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETPHUCTHAM'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1
                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''THAMPHAN'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1
                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''THAMPHAN'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETDON') THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                         'AND EXISTS(SELECT 1 
                                     FROM V_TABLE_THAMPHAN_GIAIQUYET TP 
                                     WHERE TP.DONID = A.ID AND TP.MAVAITRO = '''|| V_VAITRO_THAMPHAN ||''' 
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
                ELSIF (V_VAITRO_THAMPHAN IN ('THAMPHANHDXX','THAMPHANDUKHUYET')) THEN
                    SQL_STRING_WHERE := SQL_STRING_WHERE ||
                         'AND EXISTS(SELECT 1 
                                     FROM V_TABLE_THAMPHAN_HDXX_ST TP 
                                     WHERE TP.DONID = A.ID AND TP.MAVAITRO = '''|| V_VAITRO_THAMPHAN ||''' 
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||'
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     UNION
                                     SELECT 1
                                     FROM V_TABLE_THAMPHAN_HDXX_PT TP 
                                     WHERE TP.DONID = A.ID 
                                           AND TP.MAVAITRO IN (''THAMPHAN'')
                                           AND TP.CANBOID = '|| V_THAMPHAN_ID ||' 
                                           AND TP.MAGIAIDOAN = GD.MAGIAIDOAN
                                     )'
                    ;
            END IF;
     END IF;

     --Thư ký
     IF(NVL(LENGTH(V_THUKY_ID),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND (EXISTS(SELECT 1 
                         FROM AHC_SOTHAM_HDXX TP 
                         WHERE TP.CANBOID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID) 
                  OR EXISTS(SELECT 1 
                            FROM AHC_PHUCTHAM_HDXX TP 
                            WHERE TP.CANBOID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID)
                  OR EXISTS(SELECT 1 
                            FROM AHC_DON_THAMPHAN TP 
                            WHERE TP.THUKYID = '|| V_THUKY_ID ||' AND TP.DONID=A.ID) 
                  )'
        ;
     END IF;     

     --Loại đơn
     IF(NVL(LENGTH(V_LOAIDON),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (A.LOAIDON = '|| V_LOAIDON || '
                  )'
        ;
     END IF;

     --Giải quyết đơn;
     IF(NVL(LENGTH(V_GQDON),0) > 0) THEN
        IF(V_GQDON IN (1,3,4,5)) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND EXISTS (SELECT 1 
                                  FROM AHC_DON_XULY XL 
                                  WHERE XL.LOAIGIAIQUYET = '|| V_GQDON ||' AND XL.DONID = A.ID) '
                ;
            ELSIF(V_GQDON = 6) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND NOT EXISTS (SELECT 1 
                                      FROM AHC_DON_XULY XL 
                                      WHERE XL.DONID = A.ID) '
                ;
            ELSIF(V_GQDON = 7) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND NOT EXISTS (SELECT 1 
                                      FROM AHC_DON_XULY XL 
                                      WHERE XL.DONID=A.ID) 
                      AND (SYSDATE-A.NGAYNHANDON) > 15 '
                ;
            ELSIF(V_GQDON = 8) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND NOT EXISTS(SELECT 1 
                                     FROM AHC_DON_XULY XL 
                                     WHERE XL.DONID = A.ID)
                      AND NOT EXISTS(SELECT 1 
                                     FROM AHC_DON_THAMPHAN TP 
                                     WHERE TP.DONID = A.ID) '
                ;
        END IF;
     END IF;

     IF(VCHECKTK != 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS(
                    (SELECT 1 
                    FROM AHC_DON_THAMPHAN TP 
                    WHERE TP.DONID = A.ID AND TP.THUKYID = '|| VCHECKTK ||'
                                          AND TP.MAVAITRO = DECODE(A.MAGIAIDOAN,2,''VTTP_GIAIQUYETSOTHAM'',3,''VTTP_GIAIQUYETPHUCTHAM'','''') 
                    )
                   )'
        ;
     END IF;    

     --Số BA/QĐ             
     IF(NVL(LENGTH(V_SO_QD),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE ''%'|| V_SO_QD ||'%'' AND A.ID=QSV.DONID  )
                    OR EXISTS(SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
                    OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
                    OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE ''%'||V_SO_QD||'%'' AND A.ID=QSV.DONID  )
                   )
                  )'
        ;
     END IF;    

     --Ngày BA/QĐ
     IF(NVL(LENGTH(V_NGAY_QD),0) > 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   OR EXISTS(SELECT 1 FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   OR EXISTS(SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') = '|| V_NGAY_QD ||' AND A.ID = QSV.DONID  )
                   )
                  )'
        ;
     END IF; 

     --Số thụ lý
     IF(V_LOAI_TBTL = 1) THEN
             IF(NVL(LENGTH(V_SOTHULY),0) > 0) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND (UPPER(TLS.SOTHULY) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                           OR UPPER(TLPT.SOTHULY) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                          )'
                ;
             END IF;
        ELSIF (V_LOAI_TBTL = 2) THEN
             IF(NVL(LENGTH(V_SOTHULY),0) > 0) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                    ' AND (UPPER(TLS.SOTHONGBAO) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                           OR UPPER(TLPT.SOTHONGBAO) LIKE '''|| UPPER(V_SOTHULY) ||''' 
                          )'
                ;
             END IF;
     END IF;

     --Tình trạng thụ lý và ngày thụ lý
     IF(NVL(LENGTH(V_TINHTRANG_THULY),0) = 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((GD.MAGIAIDOAN = 2 AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON >= '|| VV_NGAYTHULY_TU ||') 
                                      AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'))
                    OR EXISTS (SELECT 1 
                               FROM AHC_CHUYEN_NHAN_AN CNA 
                               WHERE GD.MAGIAIDOAN = 3 AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN >= '|| VV_NGAYTHULY_TU ||') 
                                                       AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN <= '|| VV_NGAYTHULY_DEN ||'))
                  )'
        ;
     END IF;
     IF(V_TINHTRANG_THULY LIKE '1') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ((TLS.DONID IS NOT NULL 
                     AND (TLS.NGAYTHULY >= '|| VV_NGAYTHULY_TU ||') 
                     AND (TLS.NGAYTHULY <= '|| VV_NGAYTHULY_DEN ||') 
                    )
                    OR (TLPT.DONID IS NOT NULL
                        AND (TLPT.NGAYTHULY >= '|| VV_NGAYTHULY_TU ||') 
                        AND (TLPT.NGAYTHULY <= '|| VV_NGAYTHULY_DEN ||') 
                        )     
                   )'
        ;
     END IF;
     IF(V_TINHTRANG_THULY LIKE '2') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( (TLS.DONID IS NOT NULL AND GD.MAGIAIDOAN = 2 AND ( TLS.NGAYTHULY > '|| VV_NGAYTHULY_DEN ||'))
                     OR (TLS.DONID IS NULL AND GD.MAGIAIDOAN = 2 AND ( A.NGAYNHANDON >= '|| VV_NGAYTHULY_TU ||' 
                                                                       OR EXISTS( SELECT 1 
                                                                                  FROM AHC_DON_THAMPHAN PC 
                                                                                  WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                                        AND PC.NGAYPHANCONG >= '|| VV_NGAYTHULY_TU ||'
                                                                                        AND A.ID = PC.DONID
                                                                                )
                                                                       OR XLD.NGAYGQ_YC >= '|| VV_NGAYTHULY_TU ||'
                                                                       )
                                                                 AND ( XLD.NGAYGQ_YC <= '|| VV_NGAYTHULY_DEN ||' 
                                                                       OR EXISTS( SELECT 1 
                                                                                  FROM AHC_DON_THAMPHAN PC 
                                                                                  WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                                        AND XLD.NGAYGQ_YC IS NULL
                                                                                        AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
                                                                                        AND A.ID = PC.DONID
                                                                                )
                                                                        OR (NOT EXISTS( SELECT 1 
                                                                                        FROM V_TABLE_VUAN D
                                                                                            LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
                                                                                        WHERE PC.NGAYPHANCONG IS NULL
                                                                                       ) 
                                                                             OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'
                                                                            )
                                                                      )
                            )
                         -- CHƯA THỤ LÝ PHÚC THẨM
                         OR (TLPT.DONID IS NOT NULL AND GD.MAGIAIDOAN=3 AND EXISTS( SELECT 1 
                                                                                    FROM AHC_CHUYEN_NHAN_AN CNA
                                                                                    WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                                                                   )
                                                                        AND (TLPT.NGAYTHULY> '|| VV_NGAYTHULY_DEN ||')
                            )
                         OR (TLPT.DONID IS NULL AND GD.MAGIAIDOAN=3 AND EXISTS( SELECT 1 
                                                                                FROM AHC_CHUYEN_NHAN_AN CNA
                                                                                WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                                                              )
                                                AND ( EXISTS( SELECT 1 FROM AHC_CHUYEN_NHAN_AN CNA
                                                              WHERE GD.MAGIAIDOAN = 3
                                                                    AND CNA.NGAYNHAN >='|| VV_NGAYTHULY_TU ||' 
                                                             )
                                                      OR XLD.NGAYGQ_YC >= '|| VV_NGAYTHULY_TU ||'
                                                      OR EXISTS( SELECT 1 
                                                                 FROM AHC_DON_THAMPHAN PC 
                                                                 WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                    AND XLD.NGAYGQ_YC IS NULL
                                                                    AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
                                                                    AND A.ID = PC.DONID
                                                                )
                                                     )
                                                AND ( XLD.NGAYGQ_YC <= '|| VV_NGAYTHULY_DEN ||' 
                                                                              OR EXISTS( SELECT 1 FROM AHC_DON_THAMPHAN PC 
                                                                                         WHERE PC.MAVAITRO = ''VTTP_GIAIQUYETDON''
                                                                                             AND XLD.NGAYGQ_YC IS NULL
                                                                                             AND PC.NGAYPHANCONG <= '|| VV_NGAYTHULY_DEN ||'
                                                                                             AND A.ID = PC.DONID
                                                                                        )
                                                                               OR (NOT EXISTS( SELECT 1 
                                                                                               FROM V_TABLE_VUAN D
                                                                                                   LEFT JOIN AHC_DON_THAMPHAN PC ON PC.DONID = D.ID
                                                                                               WHERE PC.NGAYPHANCONG IS NULL
                                                                                              ) 
                                                                                   OR A.NGAYNHANDON <= '|| VV_NGAYTHULY_DEN ||'
                                                                                   )
                                                     )
                              )
                  )'
        ;
     END IF;              


     -- Turning được
     -- Phiên tòa rút kinh nghiệm;
     IF(V_PT_RKINHNGHIEM LIKE '1') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
         ' AND (EXISTS(SELECT 1 
                       FROM AHC_SOTHAM_BANAN BA
                           LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
                       WHERE SXX.ST_ISRUTKN = 1 -- trường phân biệt sơ thẩm rút kinh nghiệm
                             AND BA.DONID = A.ID AND GD.MAGIAIDOAN=2
                       )
                OR EXISTS(SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN BA
                             LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
                          WHERE SXX.PT_ISRUTKN = 1 -- trường phân biệt phúc thẩm rút kinh nghiệm
                                AND BA.DONID = A.ID AND GD.MAGIAIDOAN=3
                          )
                )'
        ;
     END IF;
     IF(V_PT_RKINHNGHIEM LIKE '2') THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
         ' AND ( NOT EXISTS(SELECT 1
                            FROM AHC_SOTHAM_BANAN BA
                                LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                            WHERE SXX.ST_ISRUTKN = 1 --PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                                  AND BA.DONID =A.ID AND GD.MAGIAIDOAN=2
                            )
                 AND NOT  EXISTS(SELECT 1 
                                 FROM AHC_PHUCTHAM_BANAN BA
                                    LEFT JOIN AHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                                 WHERE SXX.PT_ISRUTKN=1 --PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                                       AND BA.DONID =A.ID AND GD.MAGIAIDOAN=3
                                 )
                )'
        ;
     END IF;

    --Kết quả xét xử phúc thẩm;
    IF(V_KETQUA LIKE '1') THEN --Giữ nguyên quyết định/bản án sơ thẩm
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
          ' AND EXISTS( SELECT 1 
                        FROM AHC_PHUCTHAM_BANAN PB 
                            LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                        WHERE INSTR('',01,18,'','',''||KQPT.MA||'','') > 0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN=3
                       )'
        ;
    END IF;
    IF(V_KETQUA LIKE '2') THEN --Hủy quyết định/bản án sơ thẩm để...
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS( SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN PB 
                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                          WHERE INSTR('',03,04,06,12,13,14,15,21,'','',''||KQPT.MA||'','') > 0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN=3
                         )'
        ;
    END IF;
    IF(V_KETQUA LIKE '3') THEN --...Sửa 1 phần bản án/QĐ sơ thẩm
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS( SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN PB 
                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                          WHERE INSTR(''02'',KQPT.MA)>0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN = 3
                         )'
        ;
    END IF;
    IF(V_KETQUA LIKE '4') THEN --...Sửa toàn bộ bản án/QĐ sơ thẩm
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS( SELECT 1 
                          FROM AHC_PHUCTHAM_BANAN PB 
                              LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID = PB.KETQUAPHUCTHAMID 
                          WHERE INSTR(''05'',KQPT.MA)>0 AND PB.DONID = A.ID AND GD.MAGIAIDOAN = 3
                         )'
        ;
    END IF;

    ----Thời hạn Giải quyết;
    IF(V_THOIHAN_GQ LIKE '1') THEN --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                    EXISTS(SELECT 1 
                           FROM AHC_SOTHAM_THULY TL
                               LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                               LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                               LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                               LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                           WHERE( ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA - TL.NGAYTHULY) > 180 )
                                    OR ( BA.ID IS NULL AND INSTR('',DC,CVA,HPT,GHTHXX,'','',''|| QDL.MA ||'','') = 0 AND (SYSDATE - TL.NGAYTHULY) > 180)
                                   )
                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                            )
                    --dùng ngày quyết định và đình chỉ vụ án   
                    OR  EXISTS (SELECT 1 
                                FROM AHC_SOTHAM_THULY TL
                                    LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                    LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                 WHERE ( ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') > 0 AND  (QSV.NGAYQD - TL.NGAYTHULY) > 180  ) --CVA QĐ chuyển vụ án, HPT Hoãn phiên tòa, GHTHXX QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 AND  BA.ID IS NULL AND (SYSDATE - TL.NGAYTHULY) > 180 )
                                          )
                                       AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                                 )
                     --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                     OR EXISTS (SELECT 1 
                                FROM AHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
                                    LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                 WHERE ( (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA - TL.NGAYTHULY) > 90 )
                                         OR (BA.ID IS NULL AND INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 AND  (SYSDATE - TL.NGAYTHULY) > 90 )
                                       )
                                       AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                                )
                       --dùng ngày QĐ phúc thẩm  
                       OR EXISTS (SELECT 1 
                                  FROM AHC_PHUCTHAM_THULY TL 
                                      LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID 
                                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QSV.LOAIQDID 
                                  WHERE ( ( INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') > 0  AND(QSV.NGAYQD - TL.NGAYTHULY) > 90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0  AND(SYSDATE - TL.NGAYTHULY) > 90)
                                    )
                                     AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                                 ) 
                   )'
        ;
    END IF;         
    IF(V_THOIHAN_GQ LIKE '2') THEN --Còn thời hạn dưới 10 ngày
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (--Sơ thẩm chưa có quyết định và chưa có bản án
                  EXISTS(SELECT 1 
                         FROM AHC_SOTHAM_THULY TL
                             LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                             LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                         WHERE (SYSDATE - TL.NGAYTHULY) >= 170 AND (SYSDATE - TL.NGAYTHULY) < 180 
                                AND BA.ID IS NULL 
                                AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                         )
                 --phúc thẩm   
                 OR EXISTS (SELECT 1 
                            FROM AHC_PHUCTHAM_THULY TL 
                                LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
                                LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                            WHERE (SYSDATE - TL.NGAYTHULY) >= 80 AND (SYSDATE - TL.NGAYTHULY) < 90 
                                   AND BA.ID IS NULL
                                   AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                   AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                           ) 
                  )'
        ;
    END IF;
    IF(V_THOIHAN_GQ LIKE '3') THEN --chưa có quyết định và chưa có bản án
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (--Sơ thẩm 
                  EXISTS(SELECT 1 
                         FROM AHC_SOTHAM_THULY TL
                             LEFT JOIN AHC_SOTHAM_BANAN BA ON BA.DONID = TL.DONID
                             LEFT JOIN AHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                         WHERE (SYSDATE - TL.NGAYTHULY) >= 160 AND (SYSDATE - TL.NGAYTHULY) < 180 
                                AND BA.ID IS NULL
                                AND (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 2
                         )
                   --phúc thẩm   
                   OR EXISTS (SELECT 1 
                              FROM AHC_PHUCTHAM_THULY TL 
                                  LEFT JOIN AHC_PHUCTHAM_BANAN  BA ON BA.DONID = TL.DONID
                                  LEFT JOIN AHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                              WHERE (SYSDATE - TL.NGAYTHULY) >= 70 AND (SYSDATE - TL.NGAYTHULY) < 90 
                                    AND BA.ID IS NULL
                                    AND  (INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') = 0 OR INSTR('',DC,CVA,HPT,GHTHXX,'','',''||QDL.MA||'','') IS NULL)
                                    AND TL.DONID = A.ID AND GD.MAGIAIDOAN = 3
                              ) 
                   )'  
        ;
    END IF;          

    --Tình trạng GQ;
    IF(NVL(LENGTH(V_TINHTRANG_GIAIQUYET),0) = 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
             'AND (
                    ( GD.MAGIAIDOAN = 2
                        AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON>= '|| VV_TUNGAY ||') 
                        AND (A.NGAYNHANDON IS NULL OR A.NGAYNHANDON<= '|| VV_DENNGAY ||')
                    )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_CHUYEN_NHAN_AN CNA
                                WHERE GD.MAGIAIDOAN = 3
                                    AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN >= '|| VV_NGAYTHULY_TU ||') 
                                    AND (CNA.NGAYNHAN IS NULL OR CNA.NGAYNHAN <= '|| VV_NGAYTHULY_DEN ||')
                                )
                  )'
        ;
    END IF;
    IF(V_TINHTRANG_GIAIQUYET LIKE '1') THEN --Chưa giải quyết xong
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
           ' 
                AND 
                (
                    NOT EXISTS (SELECT 1 FROM AHC_DON_XULY XL WHERE XL.DONID = A.ID AND XL.LOAIGIAIQUYET IN (1,3))
                )
                AND 
                 (   
                     (   GD.MAGIAIDOAN = 2 -- SƠ THẨM
                         AND
                         (
                             ( EXISTS (SELECT 1 FROM AHC_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
                                       WHERE A.ID = QDVA.DONID AND QDVA.NGAYQD >= '|| VV_DENNGAY ||')
                                       OR
                               EXISTS (SELECT 1 FROM AHC_SOTHAM_BANAN BA WHERE A.ID = BA.DONID AND BA.NGAYTUYENAN >= '|| VV_DENNGAY ||')

                             )
                             OR 
                             ( NOT EXISTS (SELECT 1 FROM AHC_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
                               AND NOT EXISTS (SELECT 1 FROM AHC_SOTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                         )
                     )
                     OR
                     (   GD.MAGIAIDOAN = 3 -- PHÚC THẨM
                         AND
                         (
                             ( EXISTS (SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
                                       WHERE A.ID = QDVA.DONID AND QDVA.NGAYQD >= '|| VV_DENNGAY ||' )
                                       OR
                               EXISTS (SELECT 1 FROM AHC_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID AND BA.NGAYTUYENAN >= '|| VV_DENNGAY ||')

                             )
                             OR 
                             ( NOT EXISTS (SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
                               AND NOT EXISTS (SELECT 1 FROM AHC_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                         )
                     )
                 )'
        ;
    END IF;  
    IF(V_TINHTRANG_GIAIQUYET LIKE '2') THEN --chưa phân công Thẩm phán
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
             'AND (EXISTS(SELECT 1 
                          FROM AHC_SOTHAM_THULY STTL
                          WHERE STTL.DONID =  A.ID 
                              AND ( STTL.NGAYTHULY >= '|| VV_TUNGAY ||')
                              AND ( STTL.NGAYTHULY <= '|| VV_DENNGAY ||')
                          )
                  OR EXISTS(SELECT 1 
                            FROM AHC_PHUCTHAM_THULY PTTL 
                            WHERE PTTL.DONID = A.ID
                                AND( PTTL.NGAYTHULY >= '|| VV_TUNGAY ||')
                                AND( PTTL.NGAYTHULY <= '|| VV_DENNGAY ||')
                            )
                  )
              AND (NOT EXISTS (SELECT 1 
                               FROM AHC_DON_THAMPHAN PC 
                               WHERE PC.DONID=A.ID
                                    AND ((PC.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM'' AND GD.MAGIAIDOAN = 2)--sơ thẩm
                                        OR (PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 3)--phuc thẩm
                                        OR ( PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 7 )
                                        )
                                    AND ( PC.NGAYPHANCONG >= '|| VV_TUNGAY ||') 
                                    AND ( PC.NGAYPHANCONG <= '|| VV_DENNGAY ||')  
                                )
                   )'
        ;
    END IF;
    IF(V_TINHTRANG_GIAIQUYET = 3) THEN --đã phân công Thẩm phán
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND EXISTS (SELECT 1 
                          FROM AHC_DON_THAMPHAN PC 
                          WHERE PC.DONID=A.ID
                              AND ((PC.MAVAITRO = ''VTTP_GIAIQUYETSOTHAM'' AND GD.MAGIAIDOAN = 2)--sơ thẩm
                                  OR(PC.MAVAITRO = ''VTTP_GIAIQUYETPHUCTHAM'' AND GD.MAGIAIDOAN = 3)--phuc thẩm
                                  )
                              AND ( PC.NGAYPHANCONG >= '|| VV_TUNGAY ||') AND (PC.NGAYPHANCONG <= '|| VV_DENNGAY ||')  
                       )'
        ;
    END IF;                 
    IF(V_TINHTRANG_GIAIQUYET LIKE '4') THEN --đã lên lịch xét xử
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND (EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE QDL.MA = ''DVARXX''  --DVARXX - Đưa vụ án ra xét xử
                                AND ( QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND ( QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
                           )
                        OR EXISTS( SELECT 1 FROM AHC_PHUCTHAM_QUYETDINH PTQDVA
                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                   WHERE QDL.MA = ''DVARXX'' AND PTQDVA.DONID IS NULL
                                       AND ( PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                       AND ( PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                       AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
                                  )
                    )'
        ;
    END IF;       
    IF(V_TINHTRANG_GIAIQUYET LIKE '5') THEN --Đang hoãn
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( EXISTS (SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID 
                            WHERE QDL.MA = ''HPT'' AND BA.ID IS NULL
                                AND (  QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
                             )
                    --Đang hoãn phuc tham                 
                    OR EXISTS (SELECT 1 
                               FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                  LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID 
                                  LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID --BẢN ÁN 
                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID   
                               WHERE PTBA.DONID IS NULL  AND QDL.MA = ''HPT'' --Vụ án chưa có bản án  --hoãn phiên tòa 
                                  AND (  PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                  AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                  AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
                            )    
                       )'
        ;
    END IF;
    IF(V_TINHTRANG_GIAIQUYET LIKE '6') THEN --Đang tạm đình chỉ
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            '--so tham Đang tạm đình chỉ 
              AND (EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                                LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID 
                            WHERE QDL.MA = ''TDC''  
                                AND BA.DONID IS NULL  -- chưa có bản án
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                          )
              --phuc tham Đang tạm đình chỉ                
                    OR EXISTS ( SELECT 1 
                                FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTQDVA.DONID --BẢN ÁN 
                                WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA = ''TDC'' --Tạm đình chỉ
                                    AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                    AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                    AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )
                  )'
        ;
    END IF;           
    IF(V_TINHTRANG_GIAIQUYET LIKE '7') THEN --Đã giải quyết xong
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            ' AND ( EXISTS (SELECT 1 
                            FROM AHC_SOTHAM_BANAN BA
                            WHERE BA.SOBANAN IS NOT NULL
                                AND (BA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                AND (BA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                AND BA.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                         )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID 
                                WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                    AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                    AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                              )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_PHUCTHAM_BANAN PTBA 
                                WHERE PTBA.SOBANAN IS NOT NULL
                                    AND (PTBA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                    AND (PTBA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                    AND PTBA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )
                    OR EXISTS ( SELECT 1 
                                FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID 
                                WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHANHCHINH = 1
                                    AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                    AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                    AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )   
					  OR EXISTS ( SELECT 1 
								FROM AHC_DON_XULY ADX 
								WHERE ADX.LOAIGIAIQUYET IN (1, 3)
									AND (ADX.NGAYGQ_YC >= '|| VV_TUNGAY ||')
									AND (ADX.NGAYGQ_YC <= '|| VV_DENNGAY ||')
									AND ADX.DONID = A.ID  AND GD.MAGIAIDOAN = 2  )    
                )'
        ;
    END IF;                
    IF(V_TINHTRANG_GIAIQUYET LIKE '8') THEN --Đã xét xử
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_BANAN BA
                            WHERE  BA.SOBANAN IS NOT NULL
                                AND (BA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                AND (BA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                AND BA.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                           )
                   OR EXISTS ( SELECT 1 
                               FROM AHC_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                                   AND (PTBA.NGAYTUYENAN >= '|| VV_TUNGAY ||')
                                   AND (PTBA.NGAYTUYENAN <= '|| VV_DENNGAY ||')
                                   AND PTBA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                               )    
                  )'
        ;
    END IF;            
    IF(V_TINHTRANG_GIAIQUYET LIKE '9') THEN --Đình chỉ
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE INSTR('',DC,'','',''||QDL.MA||'','')>0
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID  AND GD.MAGIAIDOAN = 2
                            )
                   OR EXISTS ( SELECT 1 
                               FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                   LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                               WHERE  INSTR('',DC,'','',''||QDL.MA||'','')>0
                                   AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                   AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                   AND PTQDVA.DONID = A.ID  AND GD.MAGIAIDOAN = 3
                              )       
                 )'
        ;
    END IF; 
    IF(V_TINHTRANG_GIAIQUYET LIKE '10') THEN --Công nhận thỏa thuận của đương sự
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR('',CNTT,'','',''||QDL.MA||'','')>0
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID=A.ID  AND GD.MAGIAIDOAN = 2
                           )
                   )'
        ;
    END IF;                 
    IF(V_TINHTRANG_GIAIQUYET LIKE '11') THEN --QĐ chuyển vụ án
        SQL_STRING_WHERE := SQL_STRING_WHERE ||
            'AND ( EXISTS ( SELECT 1 
                            FROM AHC_SOTHAM_QUYETDINH QSV 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE INSTR('',CVA,'','',''||QDL.MA||'','') > 0
                                AND (QSV.NGAYQD >= '|| VV_TUNGAY ||')
                                AND (QSV.NGAYQD <= '|| VV_DENNGAY ||')
                                AND QSV.DONID = A.ID AND GD.MAGIAIDOAN = 2
                            )
                   OR EXISTS( SELECT 1 
                              FROM AHC_CHUYEN_NHAN_AN CA 
                              WHERE CA.VUANID=A.ID AND CA.TOACHUYENID = '|| V_TOAAN_ID ||' AND GD.MAGIAIDOAN = 2)      
                   OR EXISTS( SELECT 1 
                              FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID 
                              WHERE INSTR('',CVA,'','',''||QDL.MA||'','') > 0
                                  AND (PTQDVA.NGAYQD >= '|| VV_TUNGAY ||')
                                  AND (PTQDVA.NGAYQD <= '|| VV_DENNGAY ||')
                                  AND PTQDVA.DONID = A.ID AND GD.MAGIAIDOAN = 3
                             )       
                   )'
        ;
    END IF;  

    --TOANCAU-1-11-2024    
    IF(NVL(V_CHECK_HOAGIAI,0) = 0) THEN
            SQL_STRING_WHERE := SQL_STRING_WHERE || ' AND (NVL('||V_CHECK_HOAGIAI||',0) = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) NOT IN (1,2)) ';
        ELSE 
            SQL_STRING_WHERE := SQL_STRING_WHERE ||
                  'AND (
                                    '||V_CHECK_HOAGIAI||' > 0 )';

            IF(V_HOAGIAI_TRANGTHAI != 0) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE ||  
                          ' AND ( ('||V_HOAGIAI_TRANGTHAI||' = 0 AND NVL(A.HOAGIAI_TRANGTHAI,0) >= 1)
                                  OR ('||V_HOAGIAI_TRANGTHAI||' = 1 AND NVL(A.HOAGIAI_TRANGTHAI,0) >= 1
                                                                    AND NOT EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ 
                                                                                    WHERE KQ.HOAGIAIID = HGD.ID))
                                  OR ('||V_HOAGIAI_TRANGTHAI||' = A.HOAGIAI_TRANGTHAI)) ';
            END IF;

            IF(V_HOAGIAI_TUNGAY NOT LIKE '') THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                              '  AND ( EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ
                                                    WHERE KQ.NGAYHOAGIAI >= '||VV_HOAGIAI_TUNGAY||' AND KQ.HOAGIAIID = HGD.ID)
                                    )';
            END IF;  

            IF(VV_HOAGIAI_DENNGAY NOT LIKE '') THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                              ' AND ( EXISTS (SELECT 1 FROM HOAGIAI_GHINHANKETQUA KQ
                                                        WHERE KQ.NGAYHOAGIAI <= '||VV_HOAGIAI_DENNGAY||' AND KQ.HOAGIAIID = HGD.ID)
                                        ) ';
            END IF;                            

            IF(V_THAMPHAN_ID IS NOT NULL) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                              ' AND ( EXISTS (SELECT 1 FROM HOAGIAI_THAMPHAN HGTP
                                                        WHERE HGTP.THAMPHANID = '||V_THAMPHAN_ID||' AND HGTP.HOAGIAIID = HGD.ID)
                                        ) ';
            END IF;  

            IF(V_VAITRO_THAMPHAN IS NOT NULL) THEN
                SQL_STRING_WHERE := SQL_STRING_WHERE || 
                             '  AND ( EXISTS (SELECT 1 FROM HOAGIAI_THAMPHAN TPHG
                                                          WHERE TPHG.MAVAITRO= ''VTTP_HOAGIAI'' AND TPHG.HOAGIAIID=HGD.ID)
                                        ) ';
            END IF; 
    END IF;
    IF (V_AN_KET_THUC = 1) THEN
            SQL_STRING_WHERE := SQL_STRING_WHERE || '
                AND(EXISTS (SELECT 1 FROM AHC_DON_GIAIDOAN BC
                                        WHERE  BC.DONID = A.ID
                                          AND (
                                            (BC.MAGIAIDOAN = 2 AND BC.TOAANID = '|| V_TOAAN_ID ||') OR
                                            (BC.MAGIAIDOAN in (3,7) AND BC.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                                          )
                                          AND BC.AN_DA_KET_THUC = 1)                                      
                             )';
     ELSIF(V_AN_KET_THUC = 0) THEN
        SQL_STRING_WHERE := SQL_STRING_WHERE || '
            AND(NOT EXISTS (SELECT 1 FROM AHC_DON_GIAIDOAN BC
                                    WHERE BC.DONID = A.ID
                                      AND (
                                        (BC.MAGIAIDOAN = 2 AND BC.TOAANID = '|| V_TOAAN_ID ||') OR
                                        (BC.MAGIAIDOAN in (3,7) AND BC.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                                      )
                                      AND BC.AN_DA_KET_THUC = 1)                                      
                         )';
    END IF;

    OPEN CURRETURN FOR
        SQL_STRING_WITH ||
        'SELECT  TTT.ID,
                TTT.MAVUVIEC,
                TTT.TENVUVIEC,
                TTT.SOTHUTU,
                TTT.NGAYNHANDON,
                TTT.HINHTHUCNHANDON,
                TTT.MAGIAIDOAN,
                TTT.QHPLTKID,
                TTT.TOAANID,
                TTT.QUANHEPL,
                TTT.BANAN_QD_ST,
                TTT.QD_PT,
                TTT.KHANGNGHI_ST,
                TTT.CHECK_THULY,
                TTT.HOTENBICAN,
                TTT.COUNTALL,
                TTT.STT,
                TO_CHAR(DECODE(GD_MAGIAIDOAN,2, A_NGAYTAO, 3, GN_NGAYTAO_PHUCTHAM,''''),''DD/MM/YYYY'') NGAY_TAO,
                DECODE(GD_MAGIAIDOAN,2, A_NGUOITAO,3,GN_NGUOITAO_PHUCTHAM,'''') NGUOITAO,
                DECODE(GD_MAGIAIDOAN,2, TO_CHAR(A_NGAYTAO,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(A_NGAYTAO,'' HH24:MI:SS''), 3, TO_CHAR(GN_NGAYTAO_PHUCTHAM,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(GN_NGAYTAO_PHUCTHAM,'' HH24:MI:SS''), '''') NGAYTAO,
                DECODE(GD_MAGIAIDOAN,3,''</br><i>Tòa xét xử sơ thẩm: </i><b>''||T_TEN||''</b>'',NULL) TENTOASOTHAM, 
                DECODE(GD_MAGIAIDOAN,2, ''Sơ thẩm'',3,''Phúc thẩm'', 4,''Thụ lý Giám đốc thẩm'','''')GIAIDOANVUVIEC,
                DECODE(A_HINHTHUCNHANDON,1,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',270, ''<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'',2597,''<br/><i>TH giao nhận:</i> <b>Giám đốc thẩm hủy để xét xử lại sơ thẩm</b>'',''<br/><i>TH giao nhận:</i> <b>''|| GN_TRUONGHOPGIAONHAN||''</b>'') TRUONGHOPGIAONHAN,
                PKG_STPT_AHC_GS.NOIDUNG_KHANGCAO_DANHSACH(A_ID) AS KHANGCAO_ST,
                DECODE(XLD_LOAIGIAIQUYET,1,''- Đã chuyển đơn'',
                                                             CASE WHEN (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) IS NULL 
                                                                  THEN ''- Chưa thụ lý''
                                                                  ELSE (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) 
                                                             END  
                                                           ||CASE WHEN (TPPC_TINHTRANG_GQ || TPPCPT_TINHTRANG_GQ) IS NULL AND (TLS_TINHTRANG_GQ || TLPT_TINHTRANG_GQ) IS NOT NULL  
                                                                  THEN ''</br>- Chưa phân công Thẩm phán'' 
                                                                  ELSE  (TPPC_TINHTRANG_GQ || TPPCPT_TINHTRANG_GQ) 
                                                             END

                                                           || QDST_TINHTRANG_GQ || QDPT_TINHTRANG_GQ
                                                           ||BAST_TINHTRANG_GQ||BAPT_TINHTRANG_GQ
                                                           ||GNST_TINHTRANG_GQ

                                                           --lanh thêm thông tin giải quyết của vụ án cha
                                                           ||CASE WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN IS NULL) 
                                                                  THEN (SELECT ''</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
                                                                                FROM AHC_DON D
                                                                                LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                WHERE D.ID = A_VUANGOCID)
                                                                  WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN = 1) 
                                                                  THEN (SELECT ''</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
                                                                            FROM V_TABLE_VUAN D
                                                                            LEFT JOIN AHC_SOTHAM_THULY T ON D.ID = T.DONID
                                                                            WHERE D.ID = A_VUANGOCID)
                                                              END) TINHTRANG_GQ,
                  DECODE(BA_ID,NULL,DECODE(QD_ID,NULL,NULL,3),3) THULYXXLAI, '''' THAMPHANHG

        FROM (SELECT TT.*, ROW_NUMBER() OVER (ORDER BY A_NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL
              FROM (' 
                      || SQL_STRING_SELECT || ' ' 
                      || SQL_STRING_JOIN || ' ' 
                      || SQL_STRING_WHERE || ' ' 
                      || ' ) TT
               ) TTT' || 
               CASE WHEN PAGE_INDEX = 0 AND PAGE_SIZE = 0 THEN ''
               ELSE ' WHERE TTT.STT >= '|| MININDEX ||' AND TTT.STT <= '|| MAXINDEX
               END;

END AHC_DON_SEARCH_TURNING_V2;

END PKG_AHC_STPT_DS;