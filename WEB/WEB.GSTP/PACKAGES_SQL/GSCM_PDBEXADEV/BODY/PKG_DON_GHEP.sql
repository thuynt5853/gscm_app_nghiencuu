--------------------------------------------------------
--  DDL for Package Body PKG_DON_GHEP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DON_GHEP" AS


 PROCEDURE Don_GETLIST
( 
  vToaanId in number, 
  vMavuviec in varchar2,
  vTenvuviec  in varchar2,
  vNguoikhoikien in varchar2,
  vCmnd in varchar2,
  vNamsinh in varchar2, 
  vNguoibikien in varchar2,
  vNoidungkhoikien in varchar2,
  vmaloaian in varchar2,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
AS
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
    if vmaloaian='AN_DANSU' then
       ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --ADS_SOTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  ADS_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
         --ADS_PHUCTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  ADS_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;   
    --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  ADS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  ADS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;     
       ---THAMPHAN giai quyet
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  ADS_DON_THAMPHAN 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;       
       --ADS_SOTHAM_QUYETDINH
      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  ADS_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
         --ADS_PHUCTHAM_QUYETDINH
         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  ADS_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                       FROM ADS_DON_DUONGSU WHERE ISDAIDIEN=0
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                       FROM ADS_DON_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM ADS_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                    )BC 

                where BC.ROWNUMBER <=3
            )TTS;             
   -----------------------

     OPEN curReturn FOR 
        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,a.NGAYTAO,
        DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               ||GNST.TINHTRANG_GQ)

            TINHTRANG_GQ ,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST 
            from ADS_DON a 
                left join ADS_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON' and b.ISDAIDIEN = 1
                left join ADS_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' and c.ISDAIDIEN = 1
                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
                ------Trạng thái giải quyết trong danh sách
          LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.ADS_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

           LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.ADS_PHUCTHAM_THULY T2
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM ADS_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM ADS_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN (
                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM ADS_DON_THAMPHAN TP
                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                        LEFT JOIN (SELECT GG.* FROM ADS_DON_THAMPHAN GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM ADS_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 

             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM ADS_SOTHAM_QUYETDINH QSV
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                    FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM ADS_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      

            LEFT JOIN (
                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM ADS_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3

              LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM ADS_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

             LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM ADS_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM ADS_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN (
                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2

                  -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
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
        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM ADS_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           

        ------- lấy thông tin số ngày kháng nghị
        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM ADS_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
                where 
                (vToaanId=0 or a.TOAANID=vToaanId)
                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;

    elsif vmaloaian='AN_HNGD' then
    ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --AHN_SOTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHN_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
         --AHN_PHUCTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHN_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;   
    --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  AHN_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  AHN_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;     
       ---THAMPHAN giai quyet
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  AHN_DON_THAMPHAN 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;       
       --AHN_SOTHAM_QUYETDINH
      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHN_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
         --AHN_PHUCTHAM_QUYETDINH
         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHN_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                       FROM AHN_DON_DUONGSU WHERE ISDAIDIEN=0
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                       FROM AHN_DON_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM AHN_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                    )BC 

                where BC.ROWNUMBER <=3
            )TTS;             
   -----------------------
        OPEN curReturn FOR 
            select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'3' LOAIVUVIEC,a.NGAYTAO 
            ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               ||GNST.TINHTRANG_GQ)

            TINHTRANG_GQ ,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
            from AHN_DON a 
            INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
                left join AHN_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON' and b.ISDAIDIEN = 1
                left join AHN_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' and c.ISDAIDIEN = 1
                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        ------Trạng thái giải quyết trong danh sách
          LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.AHN_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

           LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.AHN_PHUCTHAM_THULY T2
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM AHN_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM AHN_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN (
                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AHN_DON_THAMPHAN TP
                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                        LEFT JOIN (SELECT GG.* FROM AHN_DON_THAMPHAN GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHN_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 

             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AHN_SOTHAM_QUYETDINH QSV
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                    FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHN_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      

            LEFT JOIN (
                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHN_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3

              LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM AHN_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

             LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHN_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM AHN_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN (
                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
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
        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHN_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           

        ------- lấy thông tin số ngày kháng nghị
        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM AHN_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
                where 
                (vToaanId=0 or a.TOAANID=vToaanId)
                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;

    elsif vmaloaian='AN_KDTM' then
     ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --AKT_SOTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AKT_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
         --AKT_PHUCTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AKT_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;   
    --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  AKT_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  AKT_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;     
       ---THAMPHAN giai quyet
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  AKT_DON_THAMPHAN 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;       
       --AKT_SOTHAM_QUYETDINH
      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AKT_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
         --AKT_PHUCTHAM_QUYETDINH
         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AKT_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                       FROM AKT_DON_DUONGSU WHERE ISDAIDIEN=0
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                       FROM AKT_DON_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM AKT_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                    )BC 

                where BC.ROWNUMBER <=3
            )TTS;             
   -----------------------
        OPEN curReturn FOR 
        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'4' LOAIVUVIEC ,a.NGAYTAO 
        ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               ||GNST.TINHTRANG_GQ)

            TINHTRANG_GQ ,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
        from AKT_DON a 
        INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
                left join AKT_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON' and b.ISDAIDIEN = 1
                left join AKT_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' and c.ISDAIDIEN = 1
                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        ------Trạng thái giải quyết trong danh sách
          LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.AKT_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

           LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.AKT_PHUCTHAM_THULY T2
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM AKT_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM AKT_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN (
                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AKT_DON_THAMPHAN TP
                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                        LEFT JOIN (SELECT GG.* FROM AKT_DON_THAMPHAN GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AKT_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 

             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AKT_SOTHAM_QUYETDINH QSV
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                    FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AKT_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      

            LEFT JOIN (
                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AKT_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3

              LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM AKT_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

             LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AKT_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM AKT_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN (
                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
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
        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AKT_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           

        ------- lấy thông tin số ngày kháng nghị
        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM AKT_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
                where 
                (vToaanId=0 or a.TOAANID=vToaanId)
                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;

       elsif vmaloaian='AN_LAODONG' then
       ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
   --ALD_SOTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  ALD_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
         --ALD_PHUCTHAM_THULY
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  ALD_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;   
    --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  ALD_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  ALD_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;     
       ---THAMPHAN giai quyet
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  ALD_DON_THAMPHAN 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;       
       --ALD_SOTHAM_QUYETDINH
      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  ALD_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
         --ALD_PHUCTHAM_QUYETDINH
         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  ALD_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;

          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
                       FROM ALD_DON_DUONGSU WHERE ISDAIDIEN=0
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                       FROM ALD_DON_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM ALD_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                    )BC 

                where BC.ROWNUMBER <=3
            )TTS;             
   -----------------------
        OPEN curReturn FOR 
        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'5' LOAIVUVIEC,a.NGAYTAO  
        ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               ||GNST.TINHTRANG_GQ)

            TINHTRANG_GQ ,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
        from ALD_DON a 
        INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
                left join ALD_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON' and b.ISDAIDIEN = 1
                left join ALD_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' and c.ISDAIDIEN = 1
                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        ------Trạng thái giải quyết trong danh sách
          LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.ALD_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

           LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.ALD_PHUCTHAM_THULY T2
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM ALD_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM ALD_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN (
                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM ALD_DON_THAMPHAN TP
                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                        LEFT JOIN (SELECT GG.* FROM ALD_DON_THAMPHAN GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM ALD_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 

             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM ALD_SOTHAM_QUYETDINH QSV
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                    FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM ALD_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      

            LEFT JOIN (
                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM ALD_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3

              LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM ALD_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

             LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM ALD_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM ALD_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

             LEFT JOIN (
                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                    FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
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
        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM ALD_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           

        ------- lấy thông tin số ngày kháng nghị
        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM ALD_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
                where 
                (vToaanId=0 or a.TOAANID=vToaanId)
                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;         
          elsif vmaloaian='AN_HANHCHINH' then
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
        OPEN curReturn FOR 

   -----------------------
        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'6' LOAIVUVIEC ,a.NGAYTAO 
        ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               ||GNST.TINHTRANG_GQ)

            TINHTRANG_GQ ,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
        from AHC_DON a 
        INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
                left join AHC_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON' and b.ISDAIDIEN = 1
                left join AHC_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' and c.ISDAIDIEN = 1
                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
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
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vtoaanid 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vtoaanid 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
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
        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM AHC_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 

                where 
                (vToaanId=0 or a.TOAANID=vToaanId)
                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;    





    elsif vmaloaian='AN_PHASAN' then
        OPEN curReturn FOR 
        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'7' LOAIVUVIEC,a.NGAYTAO 
        ,'' TINHTRANG_GQ ,
            '' GIAIDOANVUVIEC,'' TRUONGHOPGIAONHAN
            ,t.TEN TENTOASOTHAM,
            '' HOTENBICAN,'' KHANGNGHI_ST
        from APS_DON a 
                left join APS_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON' and b.ISDAIDIEN = 1
                left join APS_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' and c.ISDAIDIEN = 1
                left join DM_TOAAN t on a.TOAANID=t.ID
                where 
                (vToaanId=0 or a.TOAANID=vToaanId)
                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;      
    end if;
END Don_GETLIST;


PROCEDURE GetDonGhep
( 
  vToaanId in number,
  IdDon in number,
  LoaiAn in number,
  curReturn OUT sys_refcursor
)
AS 
BEGIN  

    if LoaiAn=2 then
    --dân sự
        OPEN curReturn FOR  
        select d.ID,a.ID ADS_DONID, a.MAVUVIEC,a.TENVUVIEC,'2' LOAIVUVIEC,d.DONKKID, d.DONGUINHANID , d.loaidon as idloaidon , d.IS_NHAPAN,
        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP ,
        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN 
        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
                              when d.Loaidon =3 then 'Đơn trùng'
                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
                         end as LOAIDON,
        case when d.Loaidon =1 then 'Nguyên đơn'
                              when d.Loaidon =2 then 'Nguyên đơn'
                              when d.Loaidon =3 then 'Nguyên đơn'
                              when d.Loaidon =4 then 'Nguyên đơn'
                              when d.Loaidon =5 then 'Bị đơn' 
                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
                         end as TCTT,d.TOA_GIAIQUYET_ID

        from DON_CHITIET d
        inner join ADS_DON a on d.DONID=a.ID
        left join (SELECT 
            DonChitietID,
            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
                FROM (
                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                    from DON_DUONGSU_CHITIET a
                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                    left join ADS_DON_DUONGSU b on a.DuongSUid = b.id
                    where a.donid = IdDon and c.LOAIANID = 2 and c.LOAIDON IN (5,6)
                )
            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id

        left join (
            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
            FROM DON_CHITIET d
            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
            LEFT JOIN ADS_DON_DUONGSU ds on ds.ID = c.DUONGSUID
            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = 2 AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
        ) DSND on DSND.id = d.id    
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=2 and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
        ;
    --hôn nhân gia đình
    ELSIF LoaiAn=3 then
        OPEN curReturn FOR  
        select d.ID,a.ID AHN_DONID, a.MAVUVIEC,a.TENVUVIEC,'3' LOAIVUVIEC,d.DONKKID, d.DONGUINHANID , d.loaidon as idloaidon , d.IS_NHAPAN,
        DECODE(d.Loaidon, 8, '', 9, '', DSND.SOCMND) as SOCMND , 
        DECODE(d.Loaidon, 8, '', 9, '', DSND.NAMSINH)as NAMSINH ,
        DECODE(d.Loaidon, 8 ,ds.TENNGUOINOP,9,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP ,
        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
                              when d.Loaidon =3 then 'Đơn từ Cơ quan quản lý nhà nước về gia đình'
                              when d.Loaidon =4 then 'Đơn từ Cơ quan quản lý nhà nước về trẻ em'
                              when d.Loaidon =5 then 'Đơn từ Hội liên hiệp phụ nữ'
                              when d.Loaidon =6 then 'Đơn trùng'
                              when d.Loaidon =7 then 'Đơn không thuộc thẩm quyền'
                              when d.Loaidon =8 then 'Đơn có yêu cầu phản tố' 
                              when d.Loaidon =9 then 'Đơn có yêu cầu độc lập'
                         end as LOAIDON,
        case when d.Loaidon =1 then 'Nguyên đơn'
                              when d.Loaidon =2 then 'Nguyên đơn'
                              when d.Loaidon =3 then 'Nguyên đơn'
                              when d.Loaidon =4 then 'Nguyên đơn'
                              when d.Loaidon =5 then 'Nguyên đơn'
                              when d.Loaidon =6 then 'Nguyên đơn'
                              when d.Loaidon =7 then 'Nguyên đơn'
                              when d.Loaidon =8 then 'Bị đơn' 
                              when d.Loaidon =9 then 'Người có quyền và NVLQ'
                         end as TCTT,d.TOA_GIAIQUYET_ID
        from DON_CHITIET d
        inner join AHN_DON a on d.DONID=a.ID
        left join (SELECT 
            DonChitietID,
            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
                FROM (
                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                    from DON_DUONGSU_CHITIET a
                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                    left join AHN_DON_DUONGSU b on a.DuongSUid = b.id
                    where a.donid = IdDon and c.LOAIANID = LoaiAn and c.LOAIDON IN (8,9)
                )
            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id

        left join (
            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
            FROM DON_CHITIET d
            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
            LEFT JOIN AHN_DON_DUONGSU ds on ds.ID = c.DUONGSUID
            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4,5,6,7) AND d.LOAIANID =LoaiAn AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
        ) DSND on DSND.id = d.id    
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 8 or d.Loaidon = 9 ) 
        ;
    --kinh doanh thuong mại
    ELSIF LoaiAn=4 then
        OPEN curReturn FOR  
        select d.ID,a.ID AKT_DONID, a.MAVUVIEC,a.TENVUVIEC,'4' LOAIVUVIEC,d.DONKKID, d.DONGUINHANID , d.loaidon as idloaidon , d.IS_NHAPAN,
        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
                              when d.Loaidon =3 then 'Đơn trùng'
                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
                         end as LOAIDON,
        case when d.Loaidon =1 then 'Nguyên đơn'
                              when d.Loaidon =2 then 'Nguyên đơn'
                              when d.Loaidon =3 then 'Nguyên đơn'
                              when d.Loaidon =4 then 'Nguyên đơn'
                              when d.Loaidon =5 then 'Bị đơn' 
                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
                         end as TCTT,d.TOA_GIAIQUYET_ID
        from DON_CHITIET d
       inner join AKT_DON a on d.DONID=a.ID
        left join (SELECT 
            DonChitietID,
            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
                FROM (
                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                    from DON_DUONGSU_CHITIET a
                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                    left join AKT_DON_DUONGSU b on a.DuongSUid = b.id
                    where a.donid = IdDon and c.LOAIANID = 4 and c.LOAIDON IN (5,6)
                )
            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id

        left join (
            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
            FROM DON_CHITIET d
            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
            LEFT JOIN AKT_DON_DUONGSU ds on ds.ID = c.DUONGSUID
            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = 4 AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
        ) DSND on DSND.id = d.id    
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
        ;
    --lao động
    ELSIF LoaiAn=5 then
         OPEN curReturn FOR  
        select d.ID,a.ID ALD_DONID, a.MAVUVIEC,a.TENVUVIEC,'2' LOAIVUVIEC,d.DONKKID, d.DONGUINHANID , d.loaidon as idloaidon , d.IS_NHAPAN,
        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
                              when d.Loaidon =3 then 'Đơn trùng'
                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
                         end as LOAIDON,
        case when d.Loaidon =1 then 'Nguyên đơn'
                              when d.Loaidon =2 then 'Nguyên đơn'
                              when d.Loaidon =3 then 'Nguyên đơn'
                              when d.Loaidon =4 then 'Nguyên đơn'
                              when d.Loaidon =5 then 'Bị đơn' 
                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
                         end as TCTT,d.TOA_GIAIQUYET_ID
        from DON_CHITIET d
        inner join ALD_DON a on d.DONID=a.ID
        left join (SELECT 
            DonChitietID,
            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
                FROM (
                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                    from DON_DUONGSU_CHITIET a
                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                    left join ALD_DON_DUONGSU b on a.DuongSUid = b.id
                    where a.donid = IdDon and c.LOAIANID = 5 and c.LOAIDON IN (5,6)
                )
            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id

        left join (
            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
            FROM DON_CHITIET d
            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
            LEFT JOIN ALD_DON_DUONGSU ds on ds.ID = c.DUONGSUID
            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = 5 AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
        ) DSND on DSND.id = d.id    
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
        ;
    --hành chính
    ELSIF LoaiAn=6 then
        OPEN curReturn FOR  
        select d.ID,a.ID AHC_DONID, a.MAVUVIEC,a.TENVUVIEC,'6' LOAIVUVIEC,d.DONKKID, d.DONGUINHANID , d.loaidon as idloaidon , d.IS_NHAPAN,
        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
                              when d.Loaidon =3 then 'Đơn trùng'
                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
                         end as LOAIDON,
        case when d.Loaidon =1 then 'Người khởi kiện'
                              when d.Loaidon =2 then 'Nguyên đơn'
                              when d.Loaidon =3 then 'Nguyên đơn'
                              when d.Loaidon =4 then 'Nguyên đơn'
                              when d.Loaidon =5 then 'Bị đơn' 
                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
                         end as TCTT, d.TOA_GIAIQUYET_ID
        from DON_CHITIET d
       inner join AHC_DON a on d.DONID=a.ID
        left join (SELECT 
            DonChitietID,
            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
                FROM (
                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                    from DON_DUONGSU_CHITIET a
                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                    left join AHC_DON_DUONGSU b on a.DuongSUid = b.id
                    where a.donid = IdDon and c.LOAIANID = LoaiAn and c.LOAIDON IN (5,6)
                )
            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id

        left join (
            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
            FROM DON_CHITIET d
            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
            LEFT JOIN AHC_DON_DUONGSU ds on ds.ID = c.DUONGSUID
            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = LoaiAn AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
        ) DSND on DSND.id = d.id    
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
        ;

    --phá sản
    ELSIF LoaiAn=7 then
        OPEN curReturn FOR  
        select d.ID,a.ID APS_DONID, a.MAVUVIEC,a.TENVUVIEC,'7' LOAIVUVIEC,d.DONKKID, d.DONGUINHANID , d.loaidon as idloaidon , d.IS_NHAPAN,
        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn trùng'
--                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
                         end as LOAIDON,
        case when d.Loaidon =1 then 'Người yêu cầu'
--                              when d.Loaidon =2 then 'Người yêu cầu'
--                              when d.Loaidon =3 then 'Người yêu cầu'
--                              when d.Loaidon =4 then 'Người yêu cầu'
                              when d.Loaidon =5 then 'DN,HTX bị tuyên bố PS' 
                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
                         end as TCTT
        from DON_CHITIET d
        inner join APS_DON a on d.DONID=a.ID
        left join (SELECT 
            DonChitietID,
            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
                FROM (
                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
                    from DON_DUONGSU_CHITIET a
                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
                    left join APS_DON_DUONGSU b on a.DuongSUid = b.id
                    where a.donid = IdDon and c.LOAIANID = 7 and c.LOAIDON IN (5,6)
                )
            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id

        left join (
            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
            FROM DON_CHITIET d
            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
            LEFT JOIN APS_DON_DUONGSU ds on ds.ID = c.DUONGSUID
            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = LoaiAn AND ds.TUCACHTOTUNG_MA = 'NGUOIYEUCAUPS'
        ) DSND on DSND.id = d.id    
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
        ;
    end if;  

END GetDonGhep;

PROCEDURE GetDonGhepDonKC
( 
  vToaanId in number,
  IdDon in number,
  LoaiAn in number,
  curReturn OUT sys_refcursor
)
AS 
BEGIN  
    if LoaiAn=1 then
    --Hinh su
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as AHS_DONID  , aDK.MAVUAN as MAVUVIEC , aDK.TENVUAN as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , '' ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 7 , DECODE(dk.LOAIKCKN ,1, DECODE(dk.ISDUONGSU, 1, to_char(dsDK.HOTEN) , to_char(TGTTDK.HOTEN)),2,'Chánh án') 
        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.HOTEN) , to_char(TGTTDK.HOTEN)) )as TENNGUOINOP,
        DECODE(dk.ngaynhandon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngaynhandon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, 'Bị can' , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD,dk.TOA_GIAIQUYET_ID
        from DON_KHAC dk
        inner join AHS_VUAN aDK on dk.DONID=aDK.ID
        left join AHS_BICANBICAO dsDK on dk.duongsuid=dsDK.ID
        left join AHS_NGUOITHAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join AHS_NGUOITHAMGIATOTUNG_TUCACH TGTTDK_TUCACH on TGTTDK_TUCACH.nguoiid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.ID = tgttdk_tucach.tucachid 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;
    ELSIF LoaiAn=2 then
    --dân sự
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as ADS_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 7 ,
        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD,dk.TOA_GIAIQUYET_ID
        from DON_KHAC dk
        inner join ADS_DON aDK on dk.DONID=aDK.ID
        left join ADS_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
        left join ADS_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;
    --hôn nhân gia đình
    ELSIF LoaiAn=3 then
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as AHN_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 10 ,
        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
        , 11 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =10 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
        when dk.Loaidon =10 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =11 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD,dk.TOA_GIAIQUYET_ID
        from DON_KHAC dk
        inner join AHN_DON aDK on dk.DONID=aDK.ID
        left join AHN_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
        left join AHN_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;
    --kinh doanh thuong mại
    ELSIF LoaiAn=4 then
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as AKT_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 7 ,
        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
        , dk.TOA_GIAIQUYET_ID as TOA_GIAIQUYET_ID 
        from DON_KHAC dk
        inner join AKT_DON aDK on dk.DONID=aDK.ID
        left join AKT_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
        left join AKT_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;
    --lao động
    ELSIF LoaiAn=5 then
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as ALD_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 7 ,
        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD,dk.TOA_GIAIQUYET_ID
        from DON_KHAC dk
        inner join ALD_DON aDK on dk.DONID=aDK.ID
        left join ALD_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
        left join ALD_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;
    --hành chính
    ELSIF LoaiAn=6 then
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as AHC_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 7 ,
        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD, dk.TOA_GIAIQUYET_ID
        from DON_KHAC dk
        inner join AHC_DON aDK on dk.DONID=aDK.ID
        left join AHC_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
        left join AHC_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;

    --phá sản
    ELSIF LoaiAn=7 then
        OPEN curReturn FOR  
        Select dk.id as ID, dk.donid as APS_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID, dk.DONGUINHANID , 
        dk.loaidon as idloaidon, 
        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
        DECODE(dk.Loaidon , 7 ,
        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn đề nghị' 
        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
        ,DECODE(Trim(dk.NOIDUNGTTGQ), '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
        from DON_KHAC dk
        inner join APS_DON aDK on dk.DONID=aDK.ID
        left join APS_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
        left join APS_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
        ;
    end if;  

END GetDonGhepDonKC;


PROCEDURE GetDonGhepDonKC_DUONGSUID
( 
    vToaanId in	int,
    IdDon in int,
    IdDuongSu in int,
    LoaiAnId in	int,
    PageIndex in int,
    PageSize in int, 
    curReturn OUT sys_refcursor
)IS MinIndex number; MaxIndex number;
  BEGIN
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
    -----------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT ROW_NUMBER() OVER (ORDER BY A.NGAYVIETDONKC desc) STT, COUNT(*) OVER () as CountAll, A.ID,
      CASE A.LOAIKHANGCAO WHEN 0 THEN 'Bản án'
                         WHEN 1 THEN 'Quyết định'
                         WHEN 2 THEN 'Quyết định khác'
      End as LOAIKHANGCAO, A.NOIDUNGDON ,
      DECODE(A.NGAYKHANGCAO, '01-JAN-01','', '01-01-0001','',to_char(A.NGAYKHANGCAO,'dd/MM/yyyy'))as NGAYKHANGCAO ,
      DECODE( A.NGAYVIETDONKC , '01-JAN-01','', '01-01-0001','', to_char(A.NGAYVIETDONKC,'dd/MM/yyyy')) as NGAYVIETDONKC
        From DON_KHAC A
     WHERE A.TOAANID = vToaanId and A.LOAIANID = LoaiAnId and A.DUONGSUID = IdDuongSu and A.LOAIKCKN = 1 and A.DONID = IdDon   
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
END GetDonGhepDonKC_DUONGSUID;


PROCEDURE GetDonGhepDonKC_BIANID
( 
    vToaanId in	int,
    IdDon in int,
    IdBiAn in int,
    LoaiAnId in	int,
    PageIndex in int,
    PageSize in int, 
    curReturn OUT sys_refcursor
)IS MinIndex number; MaxIndex number;
  BEGIN
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
    -----------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT ROW_NUMBER() OVER (ORDER BY Q.NGAYVIETDONKC desc) STT, COUNT(*) OVER () as CountAll, Q.ID,
      CASE Q.LOAIKHANGCAO WHEN 0 THEN 'Bản án'
                         WHEN 1 THEN 'Quyết định'
                         WHEN 2 THEN 'Quyết định khác'
     End as LOAIKHANGCAO
      , Q.NGAYKHANGCAO , Q.NGAYVIETDONKC , Q.TEN  from(
      SELECT DISTINCT A.ID, A.LOAIKHANGCAO , A.NGAYKHANGCAO , A.NGAYVIETDONKC , BANGB.TEN
        FROM DON_KHAC A    
        LEFT JOIN DON_KHAC_YEUCAU DKYC on DKYC.DONKHACID = A.ID
        LEFT JOIN DM_DATAITEM YC on YC.ID = DKYC.Yeucauid
        LEFT JOIN (Select BANGB.ID , listagg(BANGB.TEN, ',') within group (order by BANGB.ID ) as TEN
            from(
                SELECT TAMA.ID, TAMYC.TEN
                FROM DON_KHAC TAMA  
                JOIN DON_KHAC_YEUCAU TAMDKYC on TAMDKYC.DONKHACID = TAMA.ID
                JOIN DM_DATAITEM TAMYC on TAMYC.ID = TAMDKYC.Yeucauid ORDER BY TAMA.ID
                ) BANGB GROUP BY BANGB.ID
            ) BANGB on BANGB.ID = A.ID
        WHERE A.TOAANID = vToaanId and A.LOAIANID = LoaiAnId and A.DUONGSUID = IdBiAn and A.LOAIKCKN = 1 and A.DONID = IdDon
        ) Q

    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
END GetDonGhepDonKC_BIANID;
/*
PROCEDURE GetDonGhepXuLy
( 
  vToaanId in number,
  IdDon in number,
  LoaiAn in number,
  curReturn OUT sys_refcursor
)
AS 
BEGIN  

    if LoaiAn=2 then
    --dân sự
        OPEN curReturn FOR  
        select d.ID,a.ID ADS_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
        inner join ADS_DON a on d.DONID=a.ID
        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
        left join ADS_DON_XULY e on d.ID=e.DON_CHITIETID
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
    --hôn nhân gia đình
    ELSIF LoaiAn=3 then
        OPEN curReturn FOR  
        select d.ID,a.ID AHN_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
        inner join AHN_DON a on d.DONID=a.ID
        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
        left join AHN_DON_XULY e on d.ID=e.DON_CHITIETID
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
    --kinh doanh thuong mại
    ELSIF LoaiAn=4 then
        OPEN curReturn FOR  
        select d.ID,a.ID AKT_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
        inner join AKT_DON a on d.DONID=a.ID
        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
        left join AKT_DON_XULY e on d.ID=e.DON_CHITIETID
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
    --lao động
    ELSIF LoaiAn=5 then
        OPEN curReturn FOR  
        select d.ID,a.ID ALD_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
        inner join ALD_DON a on d.DONID=a.ID
        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
        left join ALD_DON_XULY e on d.ID=e.DON_CHITIETID
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
    --hành chính
    ELSIF LoaiAn=6 then 
        OPEN curReturn FOR  
        select d.ID,a.ID AHC_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
        inner join AHC_DON a on d.DONID=a.ID
        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
        left join AHC_DON_XULY e on d.ID=e.DON_CHITIETID
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;

    --phá sản
    ELSIF LoaiAn=7 then
        OPEN curReturn FOR  
        select d.ID,a.ID APS_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
        inner join APS_DON a on d.DONID=a.ID
        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
        left join APS_DON_XULY e on d.ID=e.DON_CHITIETID
        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
    end if;  

END GetDonGhepXuLy;
*/
end PKG_DON_GHEP;




--create or replace NONEDITIONABLE PACKAGE BODY PKG_DON_GHEP AS
--
--  PROCEDURE Don_GETLIST
--( 
--  vToaanId in number, 
--  vMavuviec in varchar2,
--  vTenvuviec  in varchar2,
--  vNguoikhoikien in varchar2,
--  vCmnd in varchar2,
--  vNamsinh in varchar2, 
--  vNguoibikien in varchar2,
--  vNoidungkhoikien in varchar2,
--  vmaloaian in varchar2,
--  PageIndex	in	int,
--  PageSize	in	int,  
--  curReturn OUT sys_refcursor
--)
--AS
--V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
--    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
--    V_TABLE_TP T_QUYETDINH_EXT;
--    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
--    V_TABLE_BC T_BICANBICAO_EXT;V_TABLE_BC_KC T_BICANBICAO_EXT; 
--BEGIN 
-- V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
--     V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
--     V_TABLE_TP := T_QUYETDINH_EXT();
--     V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
--     V_TABLE_BC := T_BICANBICAO_EXT(); V_TABLE_BC_KC := T_BICANBICAO_EXT();
--    if vmaloaian='AN_DANSU' then
--       ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
--   --ADS_SOTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLST
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  ADS_SOTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;
--         --ADS_PHUCTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLPT
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  ADS_PHUCTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--        )TTS;   
--    --THAMPHAN tham phan chu toa ST
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  ADS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;  
--       --THAMPHAN tham phan chu toa PT
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  ADS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
--       ---THAMPHAN giai quyet
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  ADS_DON_THAMPHAN 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;       
--       --ADS_SOTHAM_QUYETDINH
--      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_ST
--            FROM(
--             SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  ADS_SOTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--         --ADS_PHUCTHAM_QUYETDINH
--         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_PT
--            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  ADS_PHUCTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--
--          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
--                       FROM ADS_DON_DUONGSU WHERE ISDAIDIEN=0
--                    )BC 
--                where BC.ROWNUMBER <=3
--            )TTS;         
--          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC_KC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
--                       FROM ADS_DON_DUONGSU DS
--                       WHERE EXISTS(SELECT 'X' FROM ADS_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
--                    )BC 
--                    
--                where BC.ROWNUMBER <=3
--            )TTS;             
--   -----------------------
--    
--     OPEN curReturn FOR 
--        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,a.NGAYTAO,
--        DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
--                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
--             END  ||
--             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
--                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
--             END
--               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
--               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
--               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
--               ||CNTT.TINHTRANG_GQ
--               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
--               ||GNST.TINHTRANG_GQ)
--         
--            TINHTRANG_GQ ,
--            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
--            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
--            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST 
--            from ADS_DON a 
--                left join ADS_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--                left join ADS_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON'
--                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--                INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
--                ------Trạng thái giải quyết trong danh sách
--          LEFT JOIN (
--                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                    FROM GSCM.ADS_SOTHAM_THULY T2
--                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
--                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
--
--           LEFT JOIN (
--                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                  FROM GSCM.ADS_PHUCTHAM_THULY T2
--                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
--                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 
--
--        LEFT JOIN (
--                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                    FROM ADS_DON_THAMPHAN TP
--                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
--                    LEFT JOIN ( SELECT GG.* FROM ADS_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
--                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
--                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--            LEFT JOIN (
--                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                        FROM ADS_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM ADS_DON_THAMPHAN GG
--                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
--                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
--                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  
--
--            LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ADS_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--             LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
--                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
--
--             LEFT JOIN (
--                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM ADS_SOTHAM_QUYETDINH QSV
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
--                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                    FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
--
--                LEFT JOIN (
--                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM ADS_SOTHAM_BANAN BA
--                        WHERE  BA.SOBANAN IS NOT NULL
--                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
--
--            LEFT JOIN (
--                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM ADS_PHUCTHAM_BANAN PTBA 
--                        WHERE  PTBA.SOBANAN IS NOT NULL
--                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
--
--              LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       TINHTRANG_GQ FROM ADS_SOTHAM_QUYETDINH QSV 
--                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
--                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                      FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
--                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
--                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
--
--             LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ADS_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                       FROM ADS_SOTHAM_QUYETDINH QSV 
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN (
--                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    
--
--             -------trường hợp giao nhận add vào cột trạng thái          
--             LEFT JOIN (
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2
--                  
--                  -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
--
--           ------bị cáo lấy cho sơ thẩm
--        LEFT JOIN (
--                  SELECT BC.DONID,
--                 '<br /><i>Đương sự khác:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC) BC
--                  GROUP BY BC.DONID
--                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
--
--             ------bị cáo kháng cáo lấy cho phúc thẩm    
--                LEFT JOIN ( 
--                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC_KC) BC
--                  GROUP BY BC.DONID
--                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  
--
--        ----- lấy thông tin BA/sơ thẩm                
--        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM ADS_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
--
--        ------- lấy thông tin số ngày kháng nghị
--        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM ADS_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
--                where 
--                (vToaanId=0 or a.TOAANID=vToaanId)
--                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
--                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
--                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
--                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
--                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
--                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
--                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;
--    
--    elsif vmaloaian='AN_HNGD' then
--    ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
--   --AHN_SOTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLST
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AHN_SOTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;
--         --AHN_PHUCTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLPT
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AHN_PHUCTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--        )TTS;   
--    --THAMPHAN tham phan chu toa ST
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  AHN_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;  
--       --THAMPHAN tham phan chu toa PT
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  AHN_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
--       ---THAMPHAN giai quyet
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  AHN_DON_THAMPHAN 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;       
--       --AHN_SOTHAM_QUYETDINH
--      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_ST
--            FROM(
--             SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  AHN_SOTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--         --AHN_PHUCTHAM_QUYETDINH
--         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_PT
--            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  AHN_PHUCTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--
--          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
--                       FROM AHN_DON_DUONGSU WHERE ISDAIDIEN=0
--                    )BC 
--                where BC.ROWNUMBER <=3
--            )TTS;         
--          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC_KC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
--                       FROM AHN_DON_DUONGSU DS
--                       WHERE EXISTS(SELECT 'X' FROM AHN_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
--                    )BC 
--                    
--                where BC.ROWNUMBER <=3
--            )TTS;             
--   -----------------------
--        OPEN curReturn FOR 
--            select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'3' LOAIVUVIEC,a.NGAYTAO 
--            ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
--                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
--             END  ||
--             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
--                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
--             END
--               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
--               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
--               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
--               ||CNTT.TINHTRANG_GQ
--               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
--               ||GNST.TINHTRANG_GQ)
--         
--            TINHTRANG_GQ ,
--            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
--            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
--            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
--            from AHN_DON a 
--            INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
--                left join AHN_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--                left join AHN_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON'
--                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--        ------Trạng thái giải quyết trong danh sách
--          LEFT JOIN (
--                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                    FROM GSCM.AHN_SOTHAM_THULY T2
--                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
--                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
--
--           LEFT JOIN (
--                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                  FROM GSCM.AHN_PHUCTHAM_THULY T2
--                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
--                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 
--
--        LEFT JOIN (
--                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                    FROM AHN_DON_THAMPHAN TP
--                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
--                    LEFT JOIN ( SELECT GG.* FROM AHN_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
--                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
--                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--            LEFT JOIN (
--                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                        FROM AHN_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM AHN_DON_THAMPHAN GG
--                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
--                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
--                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  
--
--            LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM AHN_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--             LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
--                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
--
--             LEFT JOIN (
--                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM AHN_SOTHAM_QUYETDINH QSV
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
--                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                    FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
--
--                LEFT JOIN (
--                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM AHN_SOTHAM_BANAN BA
--                        WHERE  BA.SOBANAN IS NOT NULL
--                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
--
--            LEFT JOIN (
--                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM AHN_PHUCTHAM_BANAN PTBA 
--                        WHERE  PTBA.SOBANAN IS NOT NULL
--                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
--
--              LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       TINHTRANG_GQ FROM AHN_SOTHAM_QUYETDINH QSV 
--                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
--                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                      FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
--                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
--                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
--
--             LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM AHN_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                       FROM AHN_SOTHAM_QUYETDINH QSV 
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN (
--                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    
--
--             -------trường hợp giao nhận add vào cột trạng thái          
--             LEFT JOIN (
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               
--
--            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
--
--           ------bị cáo lấy cho sơ thẩm
--        LEFT JOIN (
--                  SELECT BC.DONID,
--                 '<br /><i>Đương sự khác:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC) BC
--                  GROUP BY BC.DONID
--                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
--
--             ------bị cáo kháng cáo lấy cho phúc thẩm    
--                LEFT JOIN ( 
--                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC_KC) BC
--                  GROUP BY BC.DONID
--                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  
--
--        ----- lấy thông tin BA/sơ thẩm                
--        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHN_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
--
--        ------- lấy thông tin số ngày kháng nghị
--        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM AHN_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
--                where 
--                (vToaanId=0 or a.TOAANID=vToaanId)
--                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
--                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
--                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
--                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
--                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
--                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
--                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;
--                
--    elsif vmaloaian='AN_KDTM' then
--     ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
--   --AKT_SOTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLST
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AKT_SOTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;
--         --AKT_PHUCTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLPT
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AKT_PHUCTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--        )TTS;   
--    --THAMPHAN tham phan chu toa ST
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  AKT_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;  
--       --THAMPHAN tham phan chu toa PT
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  AKT_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
--       ---THAMPHAN giai quyet
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  AKT_DON_THAMPHAN 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;       
--       --AKT_SOTHAM_QUYETDINH
--      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_ST
--            FROM(
--             SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  AKT_SOTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--         --AKT_PHUCTHAM_QUYETDINH
--         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_PT
--            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  AKT_PHUCTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--
--          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
--                       FROM AKT_DON_DUONGSU WHERE ISDAIDIEN=0
--                    )BC 
--                where BC.ROWNUMBER <=3
--            )TTS;         
--          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC_KC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
--                       FROM AKT_DON_DUONGSU DS
--                       WHERE EXISTS(SELECT 'X' FROM AKT_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
--                    )BC 
--                    
--                where BC.ROWNUMBER <=3
--            )TTS;             
--   -----------------------
--        OPEN curReturn FOR 
--        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'4' LOAIVUVIEC ,a.NGAYTAO 
--        ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
--                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
--             END  ||
--             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
--                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
--             END
--               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
--               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
--               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
--               ||CNTT.TINHTRANG_GQ
--               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
--               ||GNST.TINHTRANG_GQ)
--         
--            TINHTRANG_GQ ,
--            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
--            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
--            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
--        from AKT_DON a 
--        INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
--                left join AKT_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--                left join AKT_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON'
--                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--        ------Trạng thái giải quyết trong danh sách
--          LEFT JOIN (
--                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                    FROM GSCM.AKT_SOTHAM_THULY T2
--                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
--                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
--
--           LEFT JOIN (
--                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                  FROM GSCM.AKT_PHUCTHAM_THULY T2
--                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
--                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 
--
--        LEFT JOIN (
--                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                    FROM AKT_DON_THAMPHAN TP
--                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
--                    LEFT JOIN ( SELECT GG.* FROM AKT_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
--                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
--                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--            LEFT JOIN (
--                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                        FROM AKT_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM AKT_DON_THAMPHAN GG
--                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
--                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
--                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  
--
--            LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM AKT_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--             LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
--                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
--
--             LEFT JOIN (
--                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM AKT_SOTHAM_QUYETDINH QSV
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
--                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                    FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
--
--                LEFT JOIN (
--                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM AKT_SOTHAM_BANAN BA
--                        WHERE  BA.SOBANAN IS NOT NULL
--                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
--
--            LEFT JOIN (
--                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM AKT_PHUCTHAM_BANAN PTBA 
--                        WHERE  PTBA.SOBANAN IS NOT NULL
--                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
--
--              LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       TINHTRANG_GQ FROM AKT_SOTHAM_QUYETDINH QSV 
--                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
--                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                      FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
--                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
--                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
--
--             LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM AKT_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                       FROM AKT_SOTHAM_QUYETDINH QSV 
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN (
--                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    
--
--             -------trường hợp giao nhận add vào cột trạng thái          
--             LEFT JOIN (
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               
--
--            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
--
--           ------bị cáo lấy cho sơ thẩm
--        LEFT JOIN (
--                  SELECT BC.DONID,
--                 '<br /><i>Đương sự khác:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC) BC
--                  GROUP BY BC.DONID
--                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
--
--             ------bị cáo kháng cáo lấy cho phúc thẩm    
--                LEFT JOIN ( 
--                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC_KC) BC
--                  GROUP BY BC.DONID
--                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  
--
--        ----- lấy thông tin BA/sơ thẩm                
--        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AKT_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
--
--        ------- lấy thông tin số ngày kháng nghị
--        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM AKT_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
--                where 
--                (vToaanId=0 or a.TOAANID=vToaanId)
--                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
--                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
--                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
--                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
--                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
--                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
--                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;
--                
--       elsif vmaloaian='AN_LAODONG' then
--       ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
--   --ALD_SOTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLST
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  ALD_SOTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;
--         --ALD_PHUCTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLPT
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  ALD_PHUCTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--        )TTS;   
--    --THAMPHAN tham phan chu toa ST
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  ALD_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;  
--       --THAMPHAN tham phan chu toa PT
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  ALD_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
--       ---THAMPHAN giai quyet
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  ALD_DON_THAMPHAN 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;       
--       --ALD_SOTHAM_QUYETDINH
--      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_ST
--            FROM(
--             SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  ALD_SOTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--         --ALD_PHUCTHAM_QUYETDINH
--         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_PT
--            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  ALD_PHUCTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--
--          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
--                       FROM ALD_DON_DUONGSU WHERE ISDAIDIEN=0
--                    )BC 
--                where BC.ROWNUMBER <=3
--            )TTS;         
--          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC_KC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
--                       FROM ALD_DON_DUONGSU DS
--                       WHERE EXISTS(SELECT 'X' FROM ALD_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
--                    )BC 
--                    
--                where BC.ROWNUMBER <=3
--            )TTS;             
--   -----------------------
--        OPEN curReturn FOR 
--        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'5' LOAIVUVIEC,a.NGAYTAO  
--        ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
--                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
--             END  ||
--             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
--                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
--             END
--               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
--               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
--               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
--               ||CNTT.TINHTRANG_GQ
--               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
--               ||GNST.TINHTRANG_GQ)
--         
--            TINHTRANG_GQ ,
--            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
--            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
--            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
--        from ALD_DON a 
--        INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
--                left join ALD_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--                left join ALD_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON'
--                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--        ------Trạng thái giải quyết trong danh sách
--          LEFT JOIN (
--                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                    FROM GSCM.ALD_SOTHAM_THULY T2
--                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
--                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
--
--           LEFT JOIN (
--                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                  FROM GSCM.ALD_PHUCTHAM_THULY T2
--                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
--                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 
--
--        LEFT JOIN (
--                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                    FROM ALD_DON_THAMPHAN TP
--                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
--                    LEFT JOIN ( SELECT GG.* FROM ALD_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
--                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
--                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--            LEFT JOIN (
--                        SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                        FROM ALD_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM ALD_DON_THAMPHAN GG
--                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                   )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
--                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
--                        GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
--            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  
--
--            LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ALD_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--             LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
--                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
--
--             LEFT JOIN (
--                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM ALD_SOTHAM_QUYETDINH QSV
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
--                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                    FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
--
--                LEFT JOIN (
--                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM ALD_SOTHAM_BANAN BA
--                        WHERE  BA.SOBANAN IS NOT NULL
--                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
--
--            LEFT JOIN (
--                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM ALD_PHUCTHAM_BANAN PTBA 
--                        WHERE  PTBA.SOBANAN IS NOT NULL
--                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
--
--              LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       TINHTRANG_GQ FROM ALD_SOTHAM_QUYETDINH QSV 
--                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
--                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                      FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
--                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
--                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
--
--             LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ALD_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                       FROM ALD_SOTHAM_QUYETDINH QSV 
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN (
--                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    
--
--             -------trường hợp giao nhận add vào cột trạng thái          
--             LEFT JOIN (
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaanId
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               
--
--            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaanId 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
--
--           ------bị cáo lấy cho sơ thẩm
--        LEFT JOIN (
--                  SELECT BC.DONID,
--                 '<br /><i>Đương sự khác:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC) BC
--                  GROUP BY BC.DONID
--                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
--
--             ------bị cáo kháng cáo lấy cho phúc thẩm    
--                LEFT JOIN ( 
--                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC_KC) BC
--                  GROUP BY BC.DONID
--                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  
--
--        ----- lấy thông tin BA/sơ thẩm                
--        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM ALD_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
--
--        ------- lấy thông tin số ngày kháng nghị
--        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM ALD_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
--                where 
--                (vToaanId=0 or a.TOAANID=vToaanId)
--                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
--                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
--                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
--                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
--                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
--                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
--                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;         
--          elsif vmaloaian='AN_HANHCHINH' then
--                  ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.
--   --AHC_SOTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLST
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AHC_SOTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;
--         --AHC_PHUCTHAM_THULY
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLPT
--        FROM( SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AHC_PHUCTHAM_THULY 
--                )TT GROUP BY TT.DONID,TT.ID
--        )TTS;   
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
--       --AHC_SOTHAM_QUYETDINH
--      SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_ST
--            FROM(
--             SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  AHC_SOTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--         --AHC_PHUCTHAM_QUYETDINH
--         SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,TTS.MA)
--            BULK COLLECT INTO V_TABLE_PT
--            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
--                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
--                  ,QDL.MA
--                  FROM  AHC_PHUCTHAM_QUYETDINH PQD
--                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
--                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
--                )TTS;
--
--          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT ID,DONID,TENDUONGSU,TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DONID ORDER BY ISDAIDIEN DESC,TENDUONGSU) ROWNUMBER
--                       FROM AHC_DON_DUONGSU WHERE ISDAIDIEN=0
--                    )BC 
--                where BC.ROWNUMBER <=3
--            )TTS;         
--          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
--        SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
--        BULK COLLECT INTO V_TABLE_BC_KC
--        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
--                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
--                       FROM AHC_DON_DUONGSU DS
--                       WHERE EXISTS(SELECT 'X' FROM AHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
--                    )BC 
--                    
--                where BC.ROWNUMBER <=3
--            )TTS;  
--        OPEN curReturn FOR 
--           
--   -----------------------
--        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'6' LOAIVUVIEC ,a.NGAYTAO 
--        ,DECODE(A.LOAIDON,2,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
--                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
--             END  ||
--             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
--                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
--             END
--               ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
--               ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
--               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--               ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
--               ||CNTT.TINHTRANG_GQ
--               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
--               ||GNST.TINHTRANG_GQ)
--         
--            TINHTRANG_GQ ,
--            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,GN.TRUONGHOPGIAONHAN
--            ,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM,
--            STBA.BANAN_QD_ST,(BC3.HoTen||BC2.HoTen)HOTENBICAN,STKN.KHANGNGHI_ST
--        from AHC_DON a 
--        INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
--                left join AHC_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--                left join AHC_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON'
--                LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--        ------Trạng thái giải quyết trong danh sách
--          LEFT JOIN (
--                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                    FROM GSCM.AHC_SOTHAM_THULY T2
--                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
--                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
--
--           LEFT JOIN (
--                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
--                  FROM GSCM.AHC_PHUCTHAM_THULY T2
--                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
--                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 
--
--        LEFT JOIN (
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
--                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--            LEFT JOIN (
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
--            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  
--
--            LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM AHC_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
--
--             LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
--                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
--
--             LEFT JOIN (
--                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM AHC_SOTHAM_QUYETDINH QSV
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
--                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                    FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
--
--                LEFT JOIN (
--                        SELECT BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM AHC_SOTHAM_BANAN BA
--                        WHERE  BA.SOBANAN IS NOT NULL
--                        GROUP BY BA.DONID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
--                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
--
--            LEFT JOIN (
--                        SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                        TINHTRANG_GQ FROM AHC_PHUCTHAM_BANAN PTBA 
--                        WHERE  PTBA.SOBANAN IS NOT NULL
--                        GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
--                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
--
--              LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
--                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
--                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                      FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
--                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
--                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
--
--             LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM AHC_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
--
--             LEFT JOIN (
--                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                       FROM AHC_SOTHAM_QUYETDINH QSV 
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
--
--             LEFT JOIN (
--                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    
--
--             -------trường hợp giao nhận add vào cột trạng thái          
--             LEFT JOIN (
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vtoaanid 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               
--
--            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vtoaanid 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
--
--           ------bị cáo lấy cho sơ thẩm
--        LEFT JOIN (
--                  SELECT BC.DONID,
--                 '<br /><i>Đương sự khác:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC) BC
--                  GROUP BY BC.DONID
--                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
--
--             ------bị cáo kháng cáo lấy cho phúc thẩm    
--                LEFT JOIN ( 
--                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC_KC) BC
--                  GROUP BY BC.DONID
--                )BC3 ON BC3.DONID=A.ID AND GD.MAGIAIDOAN=3  
--
--        ----- lấy thông tin BA/sơ thẩm                
--        LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=A.ID           
--
--        ------- lấy thông tin số ngày kháng nghị
--        LEFT JOIN (SELECT KN.DONID,'<br />Kháng nghị: <b>'||'Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy')||'</b>' KHANGNGHI_ST FROM AHC_SOTHAM_KHANGNGHI KN) STKN ON STKN.DONID=A.ID 
--
--                where 
--                (vToaanId=0 or a.TOAANID=vToaanId)
--                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
--                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
--                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
--                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
--                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
--                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
--                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;    
--                
--          
--    
--     
--    
--    elsif vmaloaian='AN_PHASAN' then
--        OPEN curReturn FOR 
--        select distinct a.ID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'7' LOAIVUVIEC,a.NGAYTAO 
--        ,'' TINHTRANG_GQ ,
--            '' GIAIDOANVUVIEC,'' TRUONGHOPGIAONHAN
--            ,t.TEN TENTOASOTHAM,
--            '' HOTENBICAN,'' KHANGNGHI_ST
--        from APS_DON a 
--                left join APS_DON_DUONGSU b on b.DONID=a.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--                left join APS_DON_DUONGSU c on c.DONID=a.ID and c.TUCACHTOTUNG_MA='BIDON' 
--                left join DM_TOAAN t on a.TOAANID=t.ID
--                where 
--                (vToaanId=0 or a.TOAANID=vToaanId)
--                and (vMavuviec is null or LOWER(a.MAVUVIEC) like ('%' || lower(vMavuviec)|| '%'))
--                and (vTenvuviec is null or LOWER(a.TENVUVIEC) like ('%' || lower(vTenvuviec)|| '%'))
--                and (vNguoikhoikien is null or LOWER(b.TENDUONGSU) like ('%' || lower(vNguoikhoikien)|| '%'))
--                and (vCmnd is null or LOWER(b.SOCMND) like ('%' || lower(vCmnd)|| '%'))
--                and (vNamsinh is null or LOWER(b.NAMSINH) like ('%' || lower(vNamsinh)|| '%'))
--                and (vNguoibikien is null or LOWER(c.TENDUONGSU) like ('%' || lower(vNguoibikien)|| '%'))
--                and (vNoidungkhoikien is null or LOWER(a.NOIDUNGKHOIKIEN) like ('%' || lower(vNoidungkhoikien)|| '%')) order by a.NGAYTAO desc;      
--    end if;
--END Don_GETLIST;
--
--
--PROCEDURE GetDonGhep
--( 
--  vToaanId in number,
--  IdDon in number,
--  LoaiAn in number,
--  curReturn OUT sys_refcursor
--)
--AS 
--BEGIN  
--
--    if LoaiAn=2 then
--    --dân sự
--        OPEN curReturn FOR  
--        select d.ID,a.ID ADS_DONID, a.MAVUVIEC,a.TENVUVIEC,'2' LOAIVUVIEC,d.DONKKID , d.loaidon as idloaidon ,
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
--        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP ,
--        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN 
--        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn trùng'
--                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
--                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
--                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
--                         end as LOAIDON,
--        case when d.Loaidon =1 then 'Nguyên đơn'
--                              when d.Loaidon =2 then 'Nguyên đơn'
--                              when d.Loaidon =3 then 'Nguyên đơn'
--                              when d.Loaidon =4 then 'Nguyên đơn'
--                              when d.Loaidon =5 then 'Bị đơn' 
--                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
--                         end as TCTT
--        
--        from DON_CHITIET d
--        inner join ADS_DON a on d.DONID=a.ID
--        left join (SELECT 
--            DonChitietID,
--            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
--            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
--            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
--                FROM (
--                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
--                    from DON_DUONGSU_CHITIET a
--                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
--                    left join ADS_DON_DUONGSU b on a.DuongSUid = b.id
--                    where a.donid = IdDon and c.LOAIANID = 2 and c.LOAIDON IN (5,6)
--                )
--            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id
--            
--        left join (
--            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
--            FROM DON_CHITIET d
--            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
--            LEFT JOIN ADS_DON_DUONGSU ds on ds.ID = c.DUONGSUID
--            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = 2 AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
--        ) DSND on DSND.id = d.id    
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=2 and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
--        ;
--    --hôn nhân gia đình
--    ELSIF LoaiAn=3 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID AHN_DONID, a.MAVUVIEC,a.TENVUVIEC,'3' LOAIVUVIEC,d.DONKKID , d.loaidon as idloaidon ,
--        DECODE(d.Loaidon, 8, '', 9, '', DSND.SOCMND) as SOCMND , 
--        DECODE(d.Loaidon, 8, '', 9, '', DSND.NAMSINH)as NAMSINH ,
--        DECODE(d.Loaidon, 8 ,ds.TENNGUOINOP,9,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP ,
--        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
--        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn từ Cơ quan quản lý nhà nước về gia đình'
--                              when d.Loaidon =4 then 'Đơn từ Cơ quan quản lý nhà nước về trẻ em'
--                              when d.Loaidon =5 then 'Đơn từ Hội liên hiệp phụ nữ'
--                              when d.Loaidon =6 then 'Đơn trùng'
--                              when d.Loaidon =7 then 'Đơn không thuộc thẩm quyền'
--                              when d.Loaidon =8 then 'Đơn có yêu cầu phản tố' 
--                              when d.Loaidon =9 then 'Đơn có yêu cầu độc lập'
--                         end as LOAIDON,
--        case when d.Loaidon =1 then 'Nguyên đơn'
--                              when d.Loaidon =2 then 'Nguyên đơn'
--                              when d.Loaidon =3 then 'Nguyên đơn'
--                              when d.Loaidon =4 then 'Nguyên đơn'
--                              when d.Loaidon =5 then 'Nguyên đơn'
--                              when d.Loaidon =6 then 'Nguyên đơn'
--                              when d.Loaidon =7 then 'Nguyên đơn'
--                              when d.Loaidon =8 then 'Bị đơn' 
--                              when d.Loaidon =9 then 'Người có quyền và NVLQ'
--                         end as TCTT
--        from DON_CHITIET d
--        inner join AHN_DON a on d.DONID=a.ID
--        left join (SELECT 
--            DonChitietID,
--            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
--            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
--            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
--                FROM (
--                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
--                    from DON_DUONGSU_CHITIET a
--                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
--                    left join AHN_DON_DUONGSU b on a.DuongSUid = b.id
--                    where a.donid = IdDon and c.LOAIANID = LoaiAn and c.LOAIDON IN (8,9)
--                )
--            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id
--            
--        left join (
--            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
--            FROM DON_CHITIET d
--            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
--            LEFT JOIN AHN_DON_DUONGSU ds on ds.ID = c.DUONGSUID
--            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4,5,6,7) AND d.LOAIANID =LoaiAn AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
--        ) DSND on DSND.id = d.id    
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 8 or d.Loaidon = 9 ) 
--        ;
--    --kinh doanh thuong mại
--    ELSIF LoaiAn=4 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID AKT_DONID, a.MAVUVIEC,a.TENVUVIEC,'4' LOAIVUVIEC,d.DONKKID , d.loaidon as idloaidon ,
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
--        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
--        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
--        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn trùng'
--                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
--                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
--                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
--                         end as LOAIDON,
--        case when d.Loaidon =1 then 'Nguyên đơn'
--                              when d.Loaidon =2 then 'Nguyên đơn'
--                              when d.Loaidon =3 then 'Nguyên đơn'
--                              when d.Loaidon =4 then 'Nguyên đơn'
--                              when d.Loaidon =5 then 'Bị đơn' 
--                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
--                         end as TCTT
--        from DON_CHITIET d
--       inner join AKT_DON a on d.DONID=a.ID
--        left join (SELECT 
--            DonChitietID,
--            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
--            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
--            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
--                FROM (
--                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
--                    from DON_DUONGSU_CHITIET a
--                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
--                    left join AKT_DON_DUONGSU b on a.DuongSUid = b.id
--                    where a.donid = IdDon and c.LOAIANID = 4 and c.LOAIDON IN (5,6)
--                )
--            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id
--            
--        left join (
--            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
--            FROM DON_CHITIET d
--            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
--            LEFT JOIN AKT_DON_DUONGSU ds on ds.ID = c.DUONGSUID
--            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = 4 AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
--        ) DSND on DSND.id = d.id    
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
--        ;
--    --lao động
--    ELSIF LoaiAn=5 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID ALD_DONID, a.MAVUVIEC,a.TENVUVIEC,'2' LOAIVUVIEC,d.DONKKID , d.loaidon as idloaidon ,
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
--        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
--        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
--        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn trùng'
--                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
--                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
--                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
--                         end as LOAIDON,
--        case when d.Loaidon =1 then 'Nguyên đơn'
--                              when d.Loaidon =2 then 'Nguyên đơn'
--                              when d.Loaidon =3 then 'Nguyên đơn'
--                              when d.Loaidon =4 then 'Nguyên đơn'
--                              when d.Loaidon =5 then 'Bị đơn' 
--                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
--                         end as TCTT          
--        from DON_CHITIET d
--        inner join ALD_DON a on d.DONID=a.ID
--        left join (SELECT 
--            DonChitietID,
--            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
--            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
--            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
--                FROM (
--                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
--                    from DON_DUONGSU_CHITIET a
--                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
--                    left join ALD_DON_DUONGSU b on a.DuongSUid = b.id
--                    where a.donid = IdDon and c.LOAIANID = 5 and c.LOAIDON IN (5,6)
--                )
--            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id
--            
--        left join (
--            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
--            FROM DON_CHITIET d
--            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
--            LEFT JOIN ALD_DON_DUONGSU ds on ds.ID = c.DUONGSUID
--            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = 5 AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
--        ) DSND on DSND.id = d.id    
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
--        ;
--    --hành chính
--    ELSIF LoaiAn=6 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID AHC_DONID, a.MAVUVIEC,a.TENVUVIEC,'6' LOAIVUVIEC,d.DONKKID , d.loaidon as idloaidon ,
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
--        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
--        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
--        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn trùng'
--                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
--                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
--                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
--                         end as LOAIDON,
--        case when d.Loaidon =1 then 'Người khởi kiện'
--                              when d.Loaidon =2 then 'Nguyên đơn'
--                              when d.Loaidon =3 then 'Nguyên đơn'
--                              when d.Loaidon =4 then 'Nguyên đơn'
--                              when d.Loaidon =5 then 'Bị đơn' 
--                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
--                         end as TCTT
--        from DON_CHITIET d
--       inner join AHC_DON a on d.DONID=a.ID
--        left join (SELECT 
--            DonChitietID,
--            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
--            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
--            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
--                FROM (
--                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
--                    from DON_DUONGSU_CHITIET a
--                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
--                    left join AHC_DON_DUONGSU b on a.DuongSUid = b.id
--                    where a.donid = IdDon and c.LOAIANID = LoaiAn and c.LOAIDON IN (5,6)
--                )
--            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id
--            
--        left join (
--            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
--            FROM DON_CHITIET d
--            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
--            LEFT JOIN AHC_DON_DUONGSU ds on ds.ID = c.DUONGSUID
--            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = LoaiAn AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
--        ) DSND on DSND.id = d.id    
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
--        ;
--    
--    --phá sản
--    ELSIF LoaiAn=7 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID APS_DONID, a.MAVUVIEC,a.TENVUVIEC,'7' LOAIVUVIEC,d.DONKKID , d.loaidon as idloaidon ,
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.SOCMND) as SOCMND , 
--        DECODE(d.Loaidon, 5, '', 6, '', DSND.NAMSINH)as NAMSINH ,
--        DECODE(d.Loaidon, 5 ,ds.TENNGUOINOP,6,ds.TENNGUOINOP,DSND.TENDUONGSU)as TENNGUOINOP,
--        DECODE(d.NGAYVIETDON, '01-JAN-01','', '01-01-0001','',to_char(d.NGAYVIETDON,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,d.NOIDUNGKHOIKIEN as NOIDUNGKHOIKIEN
--        ,DECODE(d.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when d.Loaidon =1 then 'Đơn khởi kiện'
--                              when d.Loaidon =2 then 'Đơn từ Tòa án khác chuyển đến'
--                              when d.Loaidon =3 then 'Đơn trùng'
--                              when d.Loaidon =4 then 'Đơn không thuộc thẩm quyền'
--                              when d.Loaidon =5 then 'Đơn có yêu cầu phản tố' 
--                              when d.Loaidon =6 then 'Đơn có yêu cầu độc lập'
--                         end as LOAIDON,
--        case when d.Loaidon =1 then 'Nguyên đơn'
--                              when d.Loaidon =2 then 'Nguyên đơn'
--                              when d.Loaidon =3 then 'Nguyên đơn'
--                              when d.Loaidon =4 then 'Nguyên đơn'
--                              when d.Loaidon =5 then 'Bị đơn' 
--                              when d.Loaidon =6 then 'Người có quyền và NVLQ'
--                         end as TCTT
--        from DON_CHITIET d
--        inner join APS_DON a on d.DONID=a.ID
--        left join (SELECT 
--            DonChitietID,
--            LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY TENDUONGSU) "TENNGUOINOP",
--            LISTAGG(namsinh, ', ') WITHIN GROUP (ORDER BY namsinh) "NAMSINH",
--            LISTAGG(SOCMND, ', ') WITHIN GROUP (ORDER BY SOCMND) "SOCMND"
--                FROM (
--                    Select DonChitietID , TENDUONGSU,namsinh , SOCMND
--                    from DON_DUONGSU_CHITIET a
--                    left join DON_CHITIET c ON c.ID = a.DONCHITIETID
--                    left join APS_DON_DUONGSU b on a.DuongSUid = b.id
--                    where a.donid = IdDon and c.LOAIANID = 7 and c.LOAIDON IN (5,6)
--                )
--            GROUP BY donchitietid  ) DS on ds.donchitietid = d.id
--            
--        left join (
--            SELECT d.id, ds.TENDUONGSU, ds.namsinh, ds.socmnd, ds.ISDAIDIEN_DONCHITIET , ds.ISDONCHITIET
--            FROM DON_CHITIET d
--            LEFT JOIN DON_DUONGSU_CHITIET c on c.DONCHITIETID = d.ID
--            LEFT JOIN APS_DON_DUONGSU ds on ds.ID = c.DUONGSUID
--            where d.DONID = IdDon and d.LOAIDON IN (1,2,3,4) AND d.LOAIANID = LoaiAn AND ds.TUCACHTOTUNG_MA = 'NGUYENDON'
--        ) DSND on DSND.id = d.id    
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn and ( DSND.ISDAIDIEN_DONCHITIET = 1 or d.Loaidon = 6 or d.Loaidon = 5 ) 
--        ;
--    end if;  
--                
--END GetDonGhep;
--
--
--
--PROCEDURE GetDonGhepDonKC
--( 
--  vToaanId in number,
--  IdDon in number,
--  LoaiAn in number,
--  curReturn OUT sys_refcursor
--)
--AS 
--BEGIN  
--    if LoaiAn=1 then
--    --Hinh su
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as AHS_DONID  , aDK.MAVUAN as MAVUVIEC , aDK.TENVUAN as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , '' ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 7 , DECODE(dk.LOAIKCKN ,1, DECODE(dk.ISDUONGSU, 1, to_char(dsDK.HOTEN) , to_char(TGTTDK.HOTEN)),2,'Chánh án') 
--        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.HOTEN) , to_char(TGTTDK.HOTEN)) )as TENNGUOINOP,
--        DECODE(dk.ngaynhandon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngaynhandon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, 'Bị can' , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join AHS_VUAN aDK on dk.DONID=aDK.ID
--        left join AHS_BICANBICAO dsDK on dk.duongsuid=dsDK.ID
--        left join AHS_NGUOITHAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join AHS_NGUOITHAMGIATOTUNG_TUCACH TGTTDK_TUCACH on TGTTDK_TUCACH.nguoiid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.ID = tgttdk_tucach.tucachid 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    ELSIF LoaiAn=2 then
--    --dân sự
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as ADS_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 7 ,
--        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
--        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
--        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
--        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join ADS_DON aDK on dk.DONID=aDK.ID
--        left join ADS_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
--        left join ADS_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
--        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    --hôn nhân gia đình
--    ELSIF LoaiAn=3 then
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as AHN_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 10 ,
--        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
--        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
--        , 11 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
--        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =10 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =10 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =11 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join AHN_DON aDK on dk.DONID=aDK.ID
--        left join AHN_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
--        left join AHN_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
--        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    --kinh doanh thuong mại
--    ELSIF LoaiAn=4 then
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as AKT_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 7 ,
--        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
--        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
--        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
--        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join AKT_DON aDK on dk.DONID=aDK.ID
--        left join AKT_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
--        left join AKT_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
--        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    --lao động
--    ELSIF LoaiAn=5 then
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as ALD_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 7 ,
--        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
--        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
--        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
--        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join ALD_DON aDK on dk.DONID=aDK.ID
--        left join ALD_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
--        left join ALD_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
--        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    --hành chính
--    ELSIF LoaiAn=6 then
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as AHC_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 7 ,
--        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
--        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
--        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
--        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join AHC_DON aDK on dk.DONID=aDK.ID
--        left join AHC_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
--        left join AHC_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
--        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    
--    --phá sản
--    ELSIF LoaiAn=7 then
--        OPEN curReturn FOR  
--        Select dk.id as ID, dk.donid as APS_DONID  , aDK.MAVUVIEC as MAVUVIEC , aDK.TENVUVIEC as TENVUVUEC , '2' as LOAIVUVIEC , null as DONKKID , 
--        dk.loaidon as idloaidon, 
--        DECODE(dk.ISDUONGSU, 1, dsDK.SOCMND , TGTTDK.SOCMND ) as SOCMND , 
--        DECODE(dk.ISDUONGSU, 1, to_char(dsDK.namsinh) , to_char(TGTTDK.namsinh)) as NAMSINH, 
--        DECODE(dk.Loaidon , 7 ,
--        DECODE(dk.LOAIKCKN, 1 ,DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU) , to_char(TGTTDK.HOTEN)) , 
--        2 , DECODE(dk.NGUOIKCKN , 0 , 'Chánh án', 1 , 'Viện trưởng'))
--        , 8 , DECODE(dk.ISDUONGSU, 1, to_char(dsDK.TENDUONGSU), to_char(TGTTDK.HOTEN)) )as TENNGUOINOP ,
--        DECODE(dk.ngayvietdon, '01-JAN-01','', '01-01-0001','',to_char(dk.ngayvietdon,'dd/MM/yyyy'))as NGAYGHITRENDON
--        ,dk.NOIDUNGDON as NOIDUNGKHOIKIEN
--        ,DECODE(dk.TTGQ , 1 , 'Thụ lý' , 2 , 'Bổ sung' , 3 , 'Trả lại' , '') as TTGQ
--        ,case when dk.Loaidon =7 and dk.LOAIKCKN = 1 then 'Đơn kháng cáo' 
--        when dk.Loaidon =7 and dk.LOAIKCKN = 2 then 'Đơn kháng nghị'
--        when dk.Loaidon =8 then 'Đơn khác' end as LOAIDON,
--        DECODE(dk.ISDUONGSU, 1, to_char(DMDS.TEN) , to_char(DMTGTT.TEN)) as TCTT
--        ,DECODE(dk.NOIDUNGTTGQ, '', 'Xử lý đơn' , null , 'Xử lý đơn' , 'Kết quả XLĐ') as XLD
--        from DON_KHAC dk
--        inner join APS_DON aDK on dk.DONID=aDK.ID
--        left join APS_DON_DUONGSU dsDK on dk.duongsuid=dsDK.ID
--        left join APS_DON_THAMGIATOTUNG TGTTDK on dk.duongsuid=TGTTDK.ID
--        left join DM_DATAITEM DMTGTT on DMTGTT.MA = tgttdk.tucachtgttid 
--        left join DM_DATAITEM DMDS on DMDS.MA = dsDK.TUCACHTOTUNG_MA 
--        where dk.DONID = IdDon and dk.TOAANID=vToaanId and dk.LOAIANID=LoaiAn
--        ;
--    end if;  
--                
--END GetDonGhepDonKC;
--
--
--PROCEDURE GetDonGhepDonKC_DUONGSUID
--( 
--    vToaanId in	int,
--    IdDon in int,
--    IdDuongSu in int,
--    LoaiAnId in	int,
--    PageIndex in int,
--    PageSize in int, 
--    curReturn OUT sys_refcursor
--)IS MinIndex number; MaxIndex number;
--  BEGIN
--    MinIndex := PageSize*(PageIndex - 1) + 1;
--    MaxIndex := PageIndex*PageSize ;
--    -----------------------
--    OPEN curReturn FOR
--    select tt.* from (
--      SELECT ROW_NUMBER() OVER (ORDER BY A.NGAYVIETDONKC desc) STT, COUNT(*) OVER () as CountAll, A.ID,
--      CASE A.LOAIKHANGCAO WHEN 0 THEN 'Bản án'
--                         WHEN 1 THEN 'Quyết định'
--                         WHEN 2 THEN 'Quyết định khác'
--      End as LOAIKHANGCAO, A.NOIDUNGDON ,
--      DECODE(A.NGAYKHANGCAO, '01-JAN-01','', '01-01-0001','',to_char(A.NGAYKHANGCAO,'dd/MM/yyyy'))as NGAYKHANGCAO ,
--      DECODE( A.NGAYVIETDONKC , '01-JAN-01','', '01-01-0001','', to_char(A.NGAYVIETDONKC,'dd/MM/yyyy')) as NGAYVIETDONKC
--        From DON_KHAC A
--     WHERE A.TOAANID = vToaanId and A.LOAIANID = LoaiAnId and A.DUONGSUID = IdDuongSu and A.LOAIKCKN = 1 and A.DONID = IdDon   
--    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
--END GetDonGhepDonKC_DUONGSUID;
--
--
--PROCEDURE GetDonGhepDonKC_BIANID
--( 
--    vToaanId in	int,
--    IdDon in int,
--    IdBiAn in int,
--    LoaiAnId in	int,
--    PageIndex in int,
--    PageSize in int, 
--    curReturn OUT sys_refcursor
--)IS MinIndex number; MaxIndex number;
--  BEGIN
--    MinIndex := PageSize*(PageIndex - 1) + 1;
--    MaxIndex := PageIndex*PageSize ;
--    -----------------------
--    OPEN curReturn FOR
--    select tt.* from (
--      SELECT ROW_NUMBER() OVER (ORDER BY Q.NGAYVIETDONKC desc) STT, COUNT(*) OVER () as CountAll, Q.ID,
--      CASE Q.LOAIKHANGCAO WHEN 0 THEN 'Bản án'
--                         WHEN 1 THEN 'Quyết định'
--                         WHEN 2 THEN 'Quyết định khác'
--     End as LOAIKHANGCAO
--      , Q.NGAYKHANGCAO , Q.NGAYVIETDONKC , Q.TEN  from(
--      SELECT DISTINCT A.ID, A.LOAIKHANGCAO , A.NGAYKHANGCAO , A.NGAYVIETDONKC , BANGB.TEN
--        FROM DON_KHAC A    
--        LEFT JOIN DON_KHAC_YEUCAU DKYC on DKYC.DONKHACID = A.ID
--        LEFT JOIN DM_DATAITEM YC on YC.ID = DKYC.Yeucauid
--        LEFT JOIN (Select BANGB.ID , listagg(BANGB.TEN, ',') within group (order by BANGB.ID ) as TEN
--            from(
--                SELECT TAMA.ID, TAMYC.TEN
--                FROM DON_KHAC TAMA  
--                JOIN DON_KHAC_YEUCAU TAMDKYC on TAMDKYC.DONKHACID = TAMA.ID
--                JOIN DM_DATAITEM TAMYC on TAMYC.ID = TAMDKYC.Yeucauid ORDER BY TAMA.ID
--                ) BANGB GROUP BY BANGB.ID
--            ) BANGB on BANGB.ID = A.ID
--        WHERE A.TOAANID = vToaanId and A.LOAIANID = LoaiAnId and A.DUONGSUID = IdBiAn and A.LOAIKCKN = 1 and A.DONID = IdDon
--        ) Q
--        
--    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
--END GetDonGhepDonKC_BIANID;
--/*
--PROCEDURE GetDonGhepXuLy
--( 
--  vToaanId in number,
--  IdDon in number,
--  LoaiAn in number,
--  curReturn OUT sys_refcursor
--)
--AS 
--BEGIN  
--
--    if LoaiAn=2 then
--    --dân sự
--        OPEN curReturn FOR  
--        select d.ID,a.ID ADS_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
--        inner join ADS_DON a on d.DONID=a.ID
--        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
--        left join ADS_DON_XULY e on d.ID=e.DON_CHITIETID
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
--    --hôn nhân gia đình
--    ELSIF LoaiAn=3 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID AHN_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
--        inner join AHN_DON a on d.DONID=a.ID
--        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
--        left join AHN_DON_XULY e on d.ID=e.DON_CHITIETID
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
--    --kinh doanh thuong mại
--    ELSIF LoaiAn=4 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID AKT_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
--        inner join AKT_DON a on d.DONID=a.ID
--        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
--        left join AKT_DON_XULY e on d.ID=e.DON_CHITIETID
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
--    --lao động
--    ELSIF LoaiAn=5 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID ALD_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
--        inner join ALD_DON a on d.DONID=a.ID
--        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
--        left join ALD_DON_XULY e on d.ID=e.DON_CHITIETID
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
--    --hành chính
--    ELSIF LoaiAn=6 then 
--        OPEN curReturn FOR  
--        select d.ID,a.ID AHC_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
--        inner join AHC_DON a on d.DONID=a.ID
--        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
--        left join AHC_DON_XULY e on d.ID=e.DON_CHITIETID
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
--    
--    --phá sản
--    ELSIF LoaiAn=7 then
--        OPEN curReturn FOR  
--        select d.ID,a.ID APS_DONID, a.MAVUVIEC,a.TENVUVIEC,b.TENDUONGSU NGUYENDON,c.TENDUONGSU BIDON,b.SOCMND,b.NAMSINH,'2' LOAIVUVIEC,e.DON_XULYID from DON_CHITIET d
--        inner join APS_DON a on d.DONID=a.ID
--        left join DON_CHITIET_DUONGSU b on b.DONID=d.ID and b.TUCACHTOTUNG_MA='NGUYENDON'
--        left join DON_CHITIET_DUONGSU c on c.DONID=d.ID and c.TUCACHTOTUNG_MA='BIDON'
--        left join APS_DON_XULY e on d.ID=e.DON_CHITIETID
--        where d.DONID=IdDon and d.TOAANID=vToaanId and d.LOAIANID=LoaiAn;
--    end if;  
--                
--END GetDonGhepXuLy;
--*/
--end PKG_DON_GHEP;

/
