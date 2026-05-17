--------------------------------------------------------
--  DDL for Package Body PKG_AHN_STPT_DS_TKQUAHAN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_AHN_STPT_DS_TKQUAHAN" AS 
PROCEDURE AHN_DON_QUAHAN
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2, 
    V_DS_DONID              IN VARCHAR2,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
)
IS 
    SQL_STRING_WITH         CLOB;
    SQL_STRING_SELECT       CLOB;
    SQL_STRING_JOIN         CLOB;
    SQL_STRING_WHERE        CLOB;

    TOTALITEM               NUMBER; 
    MININDEX                NUMBER; 
    MAXINDEX                NUMBER; 


BEGIN

     IF(PAGE_INDEX > 0 AND PAGE_SIZE > 0) THEN
         MININDEX := PAGE_SIZE*(PAGE_INDEX - 1) + 1;
         MAXINDEX := PAGE_INDEX*PAGE_SIZE ;
     END IF;

     SQL_STRING_WITH := 
     '   WITH 
              V_TABLE_TLST AS (SELECT DISTINCT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC, NGAYTAO DESC) AS ID
                      FROM  AHN_SOTHAM_THULY
                      ),

              V_TABLE_TLPT AS (SELECT DISTINCT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) AS ID
                      FROM  AHN_PHUCTHAM_THULY
                      ),  

              V_TABLE_THAMPHAN_GIAIQUYET AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM (SELECT TP.MAVAITRO,TP.DONID,TP.ID,TP.CANBOID, ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,(CASE WHEN TP.MAVAITRO IN( ''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETDON'') THEN 2 WHEN TP.MAVAITRO=''VTTP_GIAIQUYETPHUCTHAM'' THEN 3 END) MAGIAIDOAN
                                          FROM AHN_DON_THAMPHAN TP) TP
                                    WHERE TP.ROWNUMBER = 1
                                    ),

              V_TABLE_THAMPHAN_HDXX_ST AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,2 MAGIAIDOAN
                                          FROM  AHN_SOTHAM_HDXX TP
                                          WHERE MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

              V_TABLE_THAMPHAN_HDXX_PT AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,3 MAGIAIDOAN
                                          FROM  AHN_PHUCTHAM_HDXX TP
                                          WHERE MAVAITRO IN(''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

                V_TABLE_BC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                               FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                     FROM AHN_DON_DUONGSU WHERE ISDAIDIEN=0) BC 
                               WHERE BC.ROWNUMBER <= 3),

                V_TABLE_BC_KC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                        FROM AHN_DON_DUONGSU DS
                                        WHERE EXISTS(SELECT 1 FROM AHN_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID))BC 
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

      FROM AHN_DON A 
     ';

     SQL_STRING_JOIN := 
     '    INNER JOIN (SELECT G.* 
                      FROM AHN_DON_GIAIDOAN G 
                      WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = '|| V_TOAAN_ID ||') 
                             OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                      ) GD ON A.ID=GD.DONID 

          LEFT JOIN AHN_ANPHI AI ON A.ID=AI.DONID

          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC=2

          LEFT JOIN DM_DATAITEM I ON A.QUANHEPHAPLUATID=I.ID

          LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID 

          -- lấy thông tin vụ án end  
          LEFT JOIN (SELECT PTBA.* 
                     FROM AHN_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     ) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3

          LEFT JOIN (SELECT PTQDVA.* 
                     FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                         LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                         LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                     WHERE  INSTR('',DC,'','',''||QDL.MA||'','') > 0
                     ) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN = 3 

          -- Lay ra trang thai giai quyet don
          LEFT JOIN (SELECT DONID, LOAIGIAIQUYET, NGAYGQ_YC 
                     FROM AHN_DON_XULY 
                     WHERE LOAIGIAIQUYET IN (1,5)
                     ) XLD ON A.ID = XLD.DONID

          --Trạng thái giải quyết trong danh sách
          LEFT JOIN (SELECT T2.DONID, T2.TOAANID, T2.NGAYTHULY, T2.SOTHULY, T2.TRUONGHOPTHULY, T2.SOTHONGBAO,
                            T2.QHPLTKID, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM GSCM.AHN_SOTHAM_THULY T2
                     WHERE EXISTS(SELECT 1 
                                  FROM V_TABLE_TLST QDL 
                                  WHERE QDL.ID = T2.ID)
                     ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2 --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

          LEFT JOIN (SELECT T2.DONID, T2.NGAYTHULY, T2.SOTHULY, T2.SOTHONGBAO,
                            T2.TRUONGHOPTHULY, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) || ''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM GSCM.AHN_PHUCTHAM_THULY T2
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
                   FROM AHN_SOTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1) DMQD ON DMQD.ID = QSV.QUYETDINHID
                    GROUP BY QSV.DONID
                    ) QDST ON QDST.DONID = A.ID AND GD.MAGIAIDOAN=2

        LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI || '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
                   FROM AHN_PHUCTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID

                    GROUP BY QSV.DONID
                    ) QDPT ON QDPT.DONID = A.ID AND GD.MAGIAIDOAN=3    

          LEFT JOIN (SELECT BA.DONID,''</br>- Bản án số: ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHN_SOTHAM_BANAN BA
                     WHERE  BA.SOBANAN IS NOT NULL
                     )BAST ON  BAST.DONID=A.ID AND GD.MAGIAIDOAN=2      

          LEFT JOIN (SELECT PTBA.DONID,''</br>- Bản án số: ''||PTBA.SOBANAN||'' ngày ''||TO_CHAR(PTBA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHN_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     )BAPT ON  BAPT.DONID=A.ID AND GD.MAGIAIDOAN=3  


         --trường hợp giao nhận add vào cột trạng thái     
         --sửa check đã chuyển lại án sơ thẩm     
         LEFT JOIN (SELECT CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
                    FROM(SELECT CA.ID, CA.VUANID, CA.TOACHUYENID, ''</br>- '' || I.TEN || ''</br>- Đã chuyển vụ án'' TINHTRANG_GQ,
                                ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN
                            FROM AHN_CHUYEN_NHAN_AN CA
                                INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                            WHERE CA.TOACHUYENID = '|| V_TOAAN_ID ||') CNA
                    WHERE CNA.RN = 1 AND NOT EXISTS (SELECT 1 
                                                     FROM AHN_CHUYEN_NHAN_AN CN1
                                                         JOIN AHN_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                                     WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = '|| V_TOAAN_ID ||' AND CN2.ID > CNA.ID )
                    )GNST ON  GNST.VUANID=A.ID AND GD.MAGIAIDOAN=2               

           --trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,I.TEN TRUONGHOPGIAONHAN, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM 
                      FROM DM_DATAITEM I 
                          INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=I.ID 
                      WHERE CA.TOANHANID='|| V_TOAAN_ID ||' AND NOT EXISTS (SELECT 1 FROM AHN_DON WHERE ID =NVL(CA.MAP_VUANID_NEW ,0) AND MAGIAIDOAN = 7)                      )GN ON  GN.VUANID=A.ID

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
            LEFT JOIN(SELECT BA.DONID,''<br />BA/QĐ sơ thẩm: <b>''||''Số ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'')||''</b>'' BANAN_QD_ST FROM AHN_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
            ------- lấy thông tin số ngày kháng nghị
            LEFT JOIN (SELECT KN.DONID, ''<br /><i>Kháng nghị:</i> <br />''|| LISTAGG (''Số ''||KN.SOKN||'' ngày ''||TO_CHAR(KN.NGAYKN,''dd/MM/yyyy''), ''<br/>'') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                       FROM  AHN_SOTHAM_KHANGNGHI KN
                       WHERE KN.TINHTRANG_GIAIQUYET != 3
                       GROUP BY KN.DONID
                      )STKN ON STKN.DONID=A.ID

        ----TOANCAU-1-11-2024
        LEFT JOIN HOAGIAI_DON HGD ON HGD.VUVIECID = A.ID AND HGD.LOAIANID = 6                      
        LEFT JOIN (SELECT TP.THAMPHANID,TP.HOAGIAIID,TP.ID,TP.NGAYPHANCONG,''<br/><i>Thẩm phán hoà giải:</i> <b>''|| CB.HOTEN||''</b>'' THAMPHANHG
                    FROM (SELECT ID,THAMPHANID,HOAGIAIID,NGAYPHANCONG,ROW_NUMBER() OVER (PARTITION BY HOAGIAIID ORDER BY NGAYPHANCONG DESC) RN
                        FROM HOAGIAI_THAMPHAN WHERE THAMPHANID IS NOT NULL)TP
                        JOIN DM_CANBO CB ON CB.ID = TP.THAMPHANID
                        ) TPHG
        ON HGD.ID = TPHG.HOAGIAIID
     ';

     --Bỏ án pt tđc
     SQL_STRING_WHERE := ' WHERE A.MAGIAIDOAN != 7 '; 

     --Lọc theo ID chọn
     SQL_STRING_WHERE := SQL_STRING_WHERE || 
    ' AND ( ''' || V_DS_DONID || ''' IS NULL OR TRIM(''' || V_DS_DONID || ''') = '''' ' ||
    ' OR A.ID IN (' ||
    '     SELECT TO_NUMBER(REGEXP_SUBSTR(''' || V_DS_DONID || ''', ''[^,]+'', 1, LEVEL)) ' ||
    '     FROM DUAL ' ||
    '     CONNECT BY LEVEL <= REGEXP_COUNT(''' || V_DS_DONID || ''', '','') + 1 ' ||
    ' ) )';

     --Tòa án
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND ( (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPTINH'')) 
                 OR (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPCAO'' AND T.LOAITOA != ''CAPHUYEN''))
                  )'
        ;
    --Tình trạng là đã thụ lý
    SQL_STRING_WHERE := SQL_STRING_WHERE || ' AND (TLS.DONID IS NOT NULL OR TLPT.DONID IS NOT NULL) '; 

    --Chưa giải quyết xong
    SQL_STRING_WHERE := SQL_STRING_WHERE ||
            '   
                AND 
                (
                    NOT EXISTS (SELECT 1 FROM AHN_DON_XULY XL WHERE XL.DONID = A.ID AND XL.LOAIGIAIQUYET IN (1,3))
                )
                AND 
                 (   
                     (   GD.MAGIAIDOAN = 2 -- SƠ THẨM
                         AND
                         (
                             ( EXISTS (SELECT 1 FROM AHN_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
                                       WHERE A.ID = QDVA.DONID)
                                       OR
                               EXISTS (SELECT 1 FROM AHN_SOTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                             OR 
                             ( NOT EXISTS (SELECT 1 FROM AHN_SOTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
                               AND NOT EXISTS (SELECT 1 FROM AHN_SOTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                         )
                     )
                     OR
                     (   GD.MAGIAIDOAN = 3 -- PHÚC THẨM
                         AND
                         (
                             ( EXISTS (SELECT 1 FROM AHN_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 
                                       WHERE A.ID = QDVA.DONID)
                                       OR
                               EXISTS (SELECT 1 FROM AHN_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                             OR 
                             ( NOT EXISTS (SELECT 1 FROM AHN_PHUCTHAM_QUYETDINH QDVA INNER JOIN DM_QD_QUYETDINH QD ON QD.ID = QDVA.QUYETDINHID AND QD.KET_THUC = 1 WHERE A.ID = QDVA.DONID)
                               AND NOT EXISTS (SELECT 1 FROM AHN_PHUCTHAM_BANAN BA WHERE A.ID = BA.DONID)

                             )
                         )
                     )

                 )'
        ;
OPEN CURRETURN FOR

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
                DECODE(A_HINHTHUCNHANDON,1,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',270, ''<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'',''<br/><i>TH giao nhận:</i> <b>''|| GN_TRUONGHOPGIAONHAN||''</b>'') TRUONGHOPGIAONHAN,
                PKG_STPT_AHN_GS.NOIDUNG_KHANGCAO_DANHSACH(A_ID) AS KHANGCAO_ST,
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
                                                                                FROM AHN_DON D
                                                                                LEFT JOIN AHN_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                WHERE D.ID = A_VUANGOCID)
                                                                  WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN = 1) 
                                                                  THEN (SELECT ''</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
                                                                            FROM AHN_DON D
                                                                            LEFT JOIN AHN_SOTHAM_THULY T ON D.ID = T.DONID
                                                                            WHERE D.ID = A_VUANGOCID)
                                                              END) TINHTRANG_GQ,
                  DECODE(BA_ID,NULL,DECODE(QD_ID,NULL,'''',3),3) THULYXXLAI

        FROM (SELECT TT.*, ROW_NUMBER() OVER (ORDER BY A_NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL
              FROM (' || SQL_STRING_WITH || ' '
                      || SQL_STRING_SELECT || ' ' 
                      || SQL_STRING_JOIN || ' ' 
                      || SQL_STRING_WHERE || ' ' 
                      || ' ) TT
               ) TTT' || 
               CASE WHEN PAGE_INDEX = 0 AND PAGE_SIZE = 0 THEN ''
               ELSE ' WHERE TTT.STT >= '|| MININDEX ||' AND TTT.STT <= '|| MAXINDEX
               END;

END AHN_DON_QUAHAN;

PROCEDURE AHN_DON_QUAHAN_CHITIET
( 
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2, 
    V_TK_QUAHAN_ID              IN VARCHAR2,
    PAGE_INDEX              IN INT,
    PAGE_SIZE               IN INT, 
    CURRETURN               OUT SYS_REFCURSOR
)
IS 
    SQL_STRING_WITH         CLOB;
    SQL_STRING_SELECT       CLOB;
    SQL_STRING_JOIN         CLOB;
    SQL_STRING_WHERE        CLOB;

    TOTALITEM               NUMBER; 
    MININDEX                NUMBER; 
    MAXINDEX                NUMBER; 


BEGIN

     IF(PAGE_INDEX > 0 AND PAGE_SIZE > 0) THEN
         MININDEX := PAGE_SIZE*(PAGE_INDEX - 1) + 1;
         MAXINDEX := PAGE_INDEX*PAGE_SIZE ;
     END IF;

     SQL_STRING_WITH := 
     '   WITH 
              V_TABLE_TLST AS (SELECT DISTINCT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC, NGAYTAO DESC) AS ID
                      FROM  AHN_SOTHAM_THULY
                      ),

              V_TABLE_TLPT AS (SELECT DISTINCT DONID, FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) AS ID
                      FROM  AHN_PHUCTHAM_THULY
                      ),  

              V_TABLE_THAMPHAN_GIAIQUYET AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM (SELECT TP.MAVAITRO,TP.DONID,TP.ID,TP.CANBOID, ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,(CASE WHEN TP.MAVAITRO IN( ''VTTP_GIAIQUYETSOTHAM'',''VTTP_GIAIQUYETDON'') THEN 2 WHEN TP.MAVAITRO=''VTTP_GIAIQUYETPHUCTHAM'' THEN 3 END) MAGIAIDOAN
                                          FROM AHN_DON_THAMPHAN TP) TP
                                    WHERE TP.ROWNUMBER = 1
                                    ),

              V_TABLE_THAMPHAN_HDXX_ST AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,2 MAGIAIDOAN
                                          FROM  AHN_SOTHAM_HDXX TP
                                          WHERE MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

              V_TABLE_THAMPHAN_HDXX_PT AS (SELECT TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG 
                                   FROM ( SELECT CAST(TP.MAVAITRO AS NVARCHAR2(20)) MAVAITRO,TP.DONID,TP.ID,TP.CANBOID,ROW_NUMBER()  OVER (PARTITION BY TP.DONID,TP.MAVAITRO ORDER BY TP.NGAYPHANCONG DESC) ROWNUMBER,TP.NGAYPHANCONG,3 MAGIAIDOAN
                                          FROM  AHN_PHUCTHAM_HDXX TP
                                          WHERE MAVAITRO IN(''THAMPHAN'',''THAMPHANHDXX'',''THAMPHANDUKHUYET'')) TP
                                    WHERE TP.ROWNUMBER = 1 AND TP.MAVAITRO IN (''THAMPHAN'',''THAMPHANHDXX'')
                                          OR TP.MAVAITRO = ''THAMPHANDUKHUYET''
                                    ),

                V_TABLE_BC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                               FROM (SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                                     FROM AHN_DON_DUONGSU WHERE ISDAIDIEN=0) BC 
                               WHERE BC.ROWNUMBER <= 3),

                V_TABLE_BC_KC AS (SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER 
                                  FROM (SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER() OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                                        FROM AHN_DON_DUONGSU DS
                                        WHERE EXISTS(SELECT 1 FROM AHN_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.LOAIKHANGCAO !=2 AND KC.DONID=DS.DONID))BC 
                                  WHERE BC.ROWNUMBER <=3)
        ';

    SQL_STRING_SELECT := 
    '    SELECT DISTINCT QH_CT.ID,
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

                QH_CT.LYDO_QUAHAN,
                QH_CT.CHITIET_LYDO 

      FROM AHN_DON A 
     ';

     SQL_STRING_JOIN := 
     '    INNER JOIN (SELECT G.* 
                      FROM AHN_DON_GIAIDOAN G 
                      WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = '|| V_TOAAN_ID ||') 
                             OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = '|| V_TOAAN_ID ||')
                      ) GD ON A.ID=GD.DONID 

          INNER JOIN TK_QUAHAN_CHITIET QH_CT ON QH_CT.DONID = A.ID

          INNER JOIN TK_QUAHAN QH ON QH.ID = QH_CT.TKQUAHANID AND QH.TRANGTHAI != 99 AND QH.LOAIAN = 3

          LEFT JOIN AHN_ANPHI AI ON A.ID=AI.DONID

          LEFT JOIN DVCQG_THANH_TOAN TT ON TT.ANPHI_ID=AI.ID AND TT.MALOAIVUVIEC=2

          LEFT JOIN DM_DATAITEM I ON A.QUANHEPHAPLUATID=I.ID

          LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID 

          -- lấy thông tin vụ án end  
          LEFT JOIN (SELECT PTBA.* 
                     FROM AHN_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     ) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3

          LEFT JOIN (SELECT PTQDVA.* 
                     FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                         LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                         LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                     WHERE  INSTR('',DC,'','',''||QDL.MA||'','') > 0
                     ) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN = 3 

          -- Lay ra trang thai giai quyet don
          LEFT JOIN (SELECT DONID, LOAIGIAIQUYET, NGAYGQ_YC 
                     FROM AHN_DON_XULY 
                     WHERE LOAIGIAIQUYET IN (1,5)
                     ) XLD ON A.ID = XLD.DONID

          --Trạng thái giải quyết trong danh sách
          LEFT JOIN (SELECT T2.DONID, T2.TOAANID, T2.NGAYTHULY, T2.SOTHULY, T2.TRUONGHOPTHULY, T2.SOTHONGBAO,
                            T2.QHPLTKID, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM GSCM.AHN_SOTHAM_THULY T2
                     WHERE EXISTS(SELECT 1 
                                  FROM V_TABLE_TLST QDL 
                                  WHERE QDL.ID = T2.ID)
                     ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2 --Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

          LEFT JOIN (SELECT T2.DONID, T2.NGAYTHULY, T2.SOTHULY, T2.SOTHONGBAO,
                            T2.TRUONGHOPTHULY, ''</br>- Thụ lý số:<b> ''|| TO_CHAR(T2.SOTHULY) || ''</b> ngày<b> ''||TO_CHAR(T2.NGAYTHULY,''dd/MM/yyyy'') || ''</b>'' TINHTRANG_GQ
                     FROM GSCM.AHN_PHUCTHAM_THULY T2
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
                   FROM AHN_SOTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1) DMQD ON DMQD.ID = QSV.QUYETDINHID
                    GROUP BY QSV.DONID
                    ) QDST ON QDST.DONID = A.ID AND GD.MAGIAIDOAN=2

        LEFT JOIN (SELECT QSV.DONID, LISTAGG(''</br>- QĐ ''|| DMQD.MAHIENTHI || '': số '' || QSV.SOQD || '' ngày '' || TO_CHAR(QSV.NGAYQD,''dd/MM/yyyy'') , ''<br/>'') 
                                     WITHIN GROUP (ORDER BY QSV.NGAYQD) TINHTRANG_GQ
                   FROM AHN_PHUCTHAM_QUYETDINH QSV
                       INNER JOIN (SELECT ID, LOAIID, MAHIENTHI FROM DM_QD_QUYETDINH WHERE KET_THUC = 1 ) DMQD ON DMQD.ID = QSV.QUYETDINHID

                    GROUP BY QSV.DONID
                    ) QDPT ON QDPT.DONID = A.ID AND GD.MAGIAIDOAN=3    

          LEFT JOIN (SELECT BA.DONID,''</br>- Bản án số: ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHN_SOTHAM_BANAN BA
                     WHERE  BA.SOBANAN IS NOT NULL
                     )BAST ON  BAST.DONID=A.ID AND GD.MAGIAIDOAN=2      

          LEFT JOIN (SELECT PTBA.DONID,''</br>- Bản án số: ''||PTBA.SOBANAN||'' ngày ''||TO_CHAR(PTBA.NGAYTUYENAN,''dd/MM/yyyy'') TINHTRANG_GQ 
                     FROM AHN_PHUCTHAM_BANAN PTBA 
                     WHERE  PTBA.SOBANAN IS NOT NULL
                     )BAPT ON  BAPT.DONID=A.ID AND GD.MAGIAIDOAN=3  


         --trường hợp giao nhận add vào cột trạng thái     
         --sửa check đã chuyển lại án sơ thẩm     
         LEFT JOIN (SELECT CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
                    FROM(SELECT CA.ID, CA.VUANID, CA.TOACHUYENID, ''</br>- '' || I.TEN || ''</br>- Đã chuyển vụ án'' TINHTRANG_GQ,
                                ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN
                            FROM AHN_CHUYEN_NHAN_AN CA
                                INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                            WHERE CA.TOACHUYENID = '|| V_TOAAN_ID ||') CNA
                    WHERE CNA.RN = 1 AND NOT EXISTS (SELECT 1 
                                                     FROM AHN_CHUYEN_NHAN_AN CN1
                                                         JOIN AHN_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                                     WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = '|| V_TOAAN_ID ||' AND CN2.ID > CNA.ID )
                    )GNST ON  GNST.VUANID=A.ID AND GD.MAGIAIDOAN=2               

           --trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,I.TEN TRUONGHOPGIAONHAN, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM 
                      FROM DM_DATAITEM I 
                          INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=I.ID 
                      WHERE CA.TOANHANID='|| V_TOAAN_ID ||' AND NOT EXISTS (SELECT 1 FROM AHN_DON WHERE ID =NVL(CA.MAP_VUANID_NEW ,0) AND MAGIAIDOAN = 7)                      )GN ON  GN.VUANID=A.ID

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
            LEFT JOIN(SELECT BA.DONID,''<br />BA/QĐ sơ thẩm: <b>''||''Số ''||BA.SOBANAN||'' ngày ''||TO_CHAR(BA.NGAYTUYENAN,''dd/MM/yyyy'')||''</b>'' BANAN_QD_ST FROM AHN_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
            ------- lấy thông tin số ngày kháng nghị
            LEFT JOIN (SELECT KN.DONID, ''<br /><i>Kháng nghị:</i> <br />''|| LISTAGG (''Số ''||KN.SOKN||'' ngày ''||TO_CHAR(KN.NGAYKN,''dd/MM/yyyy''), ''<br/>'') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                       FROM  AHN_SOTHAM_KHANGNGHI KN
                       WHERE KN.TINHTRANG_GIAIQUYET != 3
                       GROUP BY KN.DONID
                      )STKN ON STKN.DONID=A.ID

        ----TOANCAU-1-11-2024
        LEFT JOIN HOAGIAI_DON HGD ON HGD.VUVIECID = A.ID AND HGD.LOAIANID = 6                      
        LEFT JOIN (SELECT TP.THAMPHANID,TP.HOAGIAIID,TP.ID,TP.NGAYPHANCONG,''<br/><i>Thẩm phán hoà giải:</i> <b>''|| CB.HOTEN||''</b>'' THAMPHANHG
                    FROM (SELECT ID,THAMPHANID,HOAGIAIID,NGAYPHANCONG,ROW_NUMBER() OVER (PARTITION BY HOAGIAIID ORDER BY NGAYPHANCONG DESC) RN
                        FROM HOAGIAI_THAMPHAN WHERE THAMPHANID IS NOT NULL)TP
                        JOIN DM_CANBO CB ON CB.ID = TP.THAMPHANID
                        ) TPHG
        ON HGD.ID = TPHG.HOAGIAIID
     ';

     --Bỏ án pt tđc
     SQL_STRING_WHERE := ' WHERE A.MAGIAIDOAN != 7 '; 

      SQL_STRING_WHERE := SQL_STRING_WHERE || ' AND QH.ID = ''' || V_TK_QUAHAN_ID || '''';

     --Tòa án
        SQL_STRING_WHERE := SQL_STRING_WHERE || 
            ' AND ( (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPTINH'')) 
                 OR (GD.TOAANID = '|| V_TOAAN_ID || ' OR (GD.TOAPHUCTHAMID = '|| V_TOAAN_ID ||' AND '''|| V_CAP_XET_XU_LOGIN ||''' = ''CAPCAO'' AND T.LOAITOA != ''CAPHUYEN''))
                  )'
        ;

OPEN CURRETURN FOR

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
                TTT.LYDO_QUAHAN,
                TTT.CHITIET_LYDO,
                TO_CHAR(DECODE(GD_MAGIAIDOAN,2, A_NGAYTAO, 3, GN_NGAYTAO_PHUCTHAM,''''),''DD/MM/YYYY'') NGAY_TAO,
                DECODE(GD_MAGIAIDOAN,2, A_NGUOITAO,3,GN_NGUOITAO_PHUCTHAM,'''') NGUOITAO,
                DECODE(GD_MAGIAIDOAN,2, TO_CHAR(A_NGAYTAO,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(A_NGAYTAO,'' HH24:MI:SS''), 3, TO_CHAR(GN_NGAYTAO_PHUCTHAM,''dd/MM/yyyy'')||''<br/>''||TO_CHAR(GN_NGAYTAO_PHUCTHAM,'' HH24:MI:SS''), '''') NGAYTAO,
                DECODE(GD_MAGIAIDOAN,3,''</br><i>Tòa xét xử sơ thẩm: </i><b>''||T_TEN||''</b>'',NULL) TENTOASOTHAM, 
                DECODE(GD_MAGIAIDOAN,2, ''Sơ thẩm'',3,''Phúc thẩm'', 4,''Thụ lý Giám đốc thẩm'','''')GIAIDOANVUVIEC,
                DECODE(A_HINHTHUCNHANDON,1,''<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>'',270, ''<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>'',''<br/><i>TH giao nhận:</i> <b>''|| GN_TRUONGHOPGIAONHAN||''</b>'') TRUONGHOPGIAONHAN,
                PKG_STPT_AHN_GS.NOIDUNG_KHANGCAO_DANHSACH(A_ID) AS KHANGCAO_ST,
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
                                                                                FROM AHN_DON D
                                                                                LEFT JOIN AHN_SOTHAM_THULY T ON D.ID = T.DONID
                                                                                WHERE D.ID = A_VUANGOCID)
                                                                  WHEN (A_VUANGOCID > 0 AND A_IS_TACHAN = 1) 
                                                                  THEN (SELECT ''</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> ''|| TO_CHAR(T.SOTHULY) ||''</b> ngày<b> ''||TO_CHAR(T.NGAYTHULY,''dd/MM/yyyy'')
                                                                            FROM AHN_DON D
                                                                            LEFT JOIN AHN_SOTHAM_THULY T ON D.ID = T.DONID
                                                                            WHERE D.ID = A_VUANGOCID)
                                                              END) TINHTRANG_GQ,
                  DECODE(BA_ID,NULL,DECODE(QD_ID,NULL,'''',3),3) THULYXXLAI

        FROM (SELECT TT.*, ROW_NUMBER() OVER (ORDER BY A_NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL
              FROM (' || SQL_STRING_WITH || ' '
                      || SQL_STRING_SELECT || ' ' 
                      || SQL_STRING_JOIN || ' ' 
                      || SQL_STRING_WHERE || ' ' 
                      || ' ) TT
               ) TTT' || 
               CASE WHEN PAGE_INDEX = 0 AND PAGE_SIZE = 0 THEN ''
               ELSE ' WHERE TTT.STT >= '|| MININDEX ||' AND TTT.STT <= '|| MAXINDEX
               END;

END AHN_DON_QUAHAN_CHITIET;
END PKG_AHN_STPT_DS_TKQUAHAN;

/
