--------------------------------------------------------
--  DDL for Package Body PKG_PCTP_HANHCHINH
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_PCTP_HANHCHINH" AS
PROCEDURE PCTP_INS_UP
(
    V_TRANGTHAI IN VARCHAR2,
    V_THAMPHANGQ_ID IN VARCHAR2,
    V_DONID	IN VARCHAR2,
    V_NGAYPHANCONGTP	IN VARCHAR2,
    V_THAM_PHAN_ID	IN VARCHAR2,
    V_NGAYPHANCONGLD	IN VARCHAR2,
    V_PHANCONGLD_ID	IN VARCHAR2,
    V_CAPXX	IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_COUNTS OUT NUMBER,
    V_THONGBAO	OUT VARCHAR2
)
AS
   V_VAITRO  VARCHAR2(100); V_COUNT_CHECK NUMBER; V_TOAANID NUMBER;

BEGIN 
    V_COUNTS:=0;V_THONGBAO:='';
    SELECT DECODE(V_CAPXX,'2','VTTP_GIAIQUYETSOTHAM','3','VTTP_GIAIQUYETPHUCTHAM') INTO V_VAITRO FROM DUAL;
    SELECT A.TOAANID INTO V_TOAANID FROM AHC_DON A WHERE A.ID=V_DONID;
    ----------
    IF(V_TRANGTHAI=2) THEN
       IF(V_NGAYPHANCONGTP IS NOT NULL AND  V_THAM_PHAN_ID IS NOT NULL AND V_NGAYPHANCONGLD IS NOT NULL AND V_PHANCONGLD_ID IS NOT NULL) THEN
         SELECT COUNT(*) INTO V_COUNT_CHECK FROM AHC_DON_THAMPHAN X 
         WHERE X.DONID=V_DONID AND X.CANBOID=V_THAM_PHAN_ID AND X.MAVAITRO=V_VAITRO;
         ----V_COUNT_CHECK
          IF(V_COUNT_CHECK=0)THEN
             INSERT INTO AHC_DON_THAMPHAN
               (ID,DONID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID,
                NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA, TOA_GIAIQUYET_ID)
             VALUES (AHC_DON_THAMPHAN_SEQ.NEXTVAL,V_DONID,V_THAM_PHAN_ID,V_VAITRO,TO_DATE(V_NGAYPHANCONGLD,'dd/MM/yyyy'),TO_DATE(V_NGAYPHANCONGTP,'dd/MM/yyyy'),V_PHANCONGLD_ID,
                sysdate,V_NGUOITAO,sysdate,V_NGUOITAO, V_TOAANID);
              -----
             V_COUNTS:=1;
          ELSIF(V_COUNT_CHECK>0)THEN
             V_THONGBAO:='Thẩm phán đã được phân công, bạn phải chọn Thẩm phán khác';
          END IF;
        ------
      END IF;
    ELSIF(V_TRANGTHAI=3) THEN
        IF(V_NGAYPHANCONGTP IS NOT NULL AND  V_THAM_PHAN_ID IS NOT NULL AND V_NGAYPHANCONGLD IS NOT NULL AND V_PHANCONGLD_ID IS NOT NULL) THEN
          UPDATE AHC_DON_THAMPHAN
            SET  
                CANBOID=V_THAM_PHAN_ID,
                NGAYPHANCONG=TO_DATE(V_NGAYPHANCONGLD,'dd/MM/yyyy'),
                NGAYNHANPHANCONG=TO_DATE(V_NGAYPHANCONGTP,'dd/MM/yyyy'),
                NGUOIPHANCONGID=V_PHANCONGLD_ID,
                NGAYSUA=sysdate,
                NGUOISUA=V_NGUOITAO
            WHERE ID=V_THAMPHANGQ_ID; 
        V_COUNTS:=1;
        END IF;
    END IF;
END PCTP_INS_UP;

PROCEDURE DON_SEARCH
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
    Page_Index in	int,
    Page_Size	in	int, 
    curReturn OUT sys_refcursor
)
IS 
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
BEGIN
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;
    ----------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
   select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_TINHTRANG_GIAIQUYET,2,a.NGAYTAO,3,PCTP_GQ.NGAYTAO) desc) STT,COUNT(*) OVER () as CountAll, A.ID,A.MAVUVIEC,A.TENVUVIEC,A.SOTHUTU,A.NGAYNHANDON,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN,STBA.BANAN_QD_ST,STKN.KHANGNGHI_ST,
      GD.MAGIAIDOAN,(BC3.HoTen||BC2.HoTen)HOTENBICAN ,
         CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
            TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
             to_char(PCTP_GQ.NGAYNHANPHANCONG,'dd/MM/yyyy') NGAYPHANCONGTP, to_char(PCTP_GQ.NGAYPHANCONG,'dd/MM/yyyy') NGAYPHANCONGLD,
            PCTP_GQ.CANBOID THAMPHAN_ID,PCTP_GQ.NGUOIPHANCONGID LANHDAO_ID,PCTP_GQ.ID THAMPHANGQ_ID
      FROM AHC_DON A
      INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_SOTHAM_THULY TL 
                       GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3   
             ----lấy 1 bản ghi mới nhất 27/12/2023
            LEFT JOIN (
                     SELECT FIRST_VALUE(TP.ID) OVER (PARTITION BY TP.DONID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) ID,
                     CB.HOTEN,TP.DONID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG
                     FROM  AHC_DON_THAMPHAN TP
                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                     LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
                     WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
                     AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
           )PCTP_GQ ON PCTP_GQ.DONID = A.ID 
            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- Đang hoãn phiên tòa sơ thẩm'TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                        WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                        GROUP BY QSV.DONID,'</br>- Đang hoãn phiên tòa sơ thẩm'
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
                 LEFT JOIN (
                        SELECT QSV.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                        WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                        AND BA.DONID IS NULL  -- chưa có bản án
                        GROUP BY QSV.DONID,'</br>- Đang tạm đình chỉ'
                       )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ FROM AHC_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm'
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AHC_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN (
                       SELECT QSV.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('DC',QDL.MA)>0
                       GROUP BY QSV.DONID,'</br>- Đã có QĐ đình chỉ'
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- Đã có QĐ công nhận thỏa thuận' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('CNTT',QDL.MA)>0
                       GROUP BY QSV.DONID,'</br>- Đã có QĐ công nhận thỏa thuận'
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('CVA',QDL.MA)>0
                       GROUP BY QSV.DONID,'</br>- Đã có QĐ chuyển vụ án'
                       )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3   
            -------trường hợp giao nhận add vào cột trạng thái          
           LEFT JOIN (SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               
         -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
        LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
                  )GN ON  GN.VUANID=a.ID
         ------bị cáo lấy cho sơ thẩm
         LEFT JOIN ( SELECT TS.DONID,'<br /><i>Đương sự khác:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_NGUYENDON',' (Nguyên đơn)'),'_BIDON',' (Bị đơn)'),'_QUYENNVLQ',' (Người có quyền và NVLQ)'),',','<br/>')HOTEN FROM (
                            SELECT TT.DONID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,',',1,DECODE(TT.COUNT_DS,1,1,2,2,3,3,3) )),',')HOTEN 
                                FROM (
                                      select COUNT(*)COUNT_DS,DS.DONID,
                                        listagg (DS.TENDUONGSU||'_'||DS.TUCACHTOTUNG_MA, ',') WITHIN GROUP (ORDER BY DS.TENDUONGSU)||',' HOTEN
                                        FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=0
                                        GROUP BY DS.DONID
                                     )TT
                     )TS
                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
             ------bị cáo kháng cáo lấy cho phúc thẩm    
            LEFT JOIN ( SELECT TS.DONID,'<br /><i>Người kháng cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_NGUYENDON',' (Nguyên đơn)'),'_BIDON',' (Bị đơn)'),'_QUYENNVLQ',' (Người có quyền và NVLQ)'),',','<br/>')HOTEN FROM (
                            SELECT TT.DONID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,',',1,DECODE(TT.COUNT_DS,1,1,2,2,3,3,3) )),',')HOTEN 
                                FROM (
                                      select COUNT(*)COUNT_DS,DS.DONID,
                                        listagg (DS.TENDUONGSU||'_'||DS.TUCACHTOTUNG_MA, ',') WITHIN GROUP (ORDER BY DS.TENDUONGSU)||',' HOTEN
                                        FROM AHC_DON_DUONGSU DS
                                        INNER JOIN (SELECT DUONGSUID, LOAIKHANGCAO,DONID FROM AHC_SOTHAM_KHANGCAO ) KC ON KC.DUONGSUID = DS.ID AND KC.DONID=DS.DONID
                                        --WHERE DS.ISDAIDIEN=0
                                        GROUP BY DS.DONID
                                     )TT
                     )TS
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
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE  UPPER(DS.TENDUONGSU) LIKE '%'||UPPER(V_TENDUONGSU)||'%' AND DS.DONID=A.ID)
                    )
            ) 
            AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))--Cấp xét xử
            AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
--         -----   
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLS.DONID IS NOT NULL 
                              AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                           OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
          AND (V_THAMPHAN_ID IS NULL
            OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID AND ((v_Capxx=2 AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )  )  )--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR(EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
            )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
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
           --Tình trạng GQ;
         AND(v_TINHTRANG_GIAIQUYET IS NULL
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                   AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  PCTP_GQ.NGAYNHANPHANCONG>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PCTP_GQ.NGAYNHANPHANCONG<=VV_DENNGAY)   
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
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr('DC,CVA,CNTT',T2.MA)>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) --là con của chưa giải quyết xong end 
            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
;
END DON_SEARCH;
FUNCTION DON_SEARCH_PRINT_OLD
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
    Page_Index in	int,
    Page_Size	in	int
)RETURN SYS_REFCURSOR
IS 
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
   ----------------
      V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; CountAll_S number:=0;
      V_TUNGAY_BC VARCHAR2(500); V_DENNGAY_BC VARCHAR2(500);v_TINHTRANG_GQ_TEN VARCHAR2(500);V_TOAAN_TEN VARCHAR2(200);
BEGIN
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
     --
     SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN','TAND') INTO V_TOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=v_toaan_id;
     SELECT DECODE(V_TUNGAY,NULL,'..........',V_TUNGAY) INTO V_TUNGAY_BC FROM DUAL;
     SELECT DECODE(V_DENNGAY,NULL,'..........',V_DENNGAY) INTO V_DENNGAY_BC FROM DUAL;
     SELECT DECODE(v_TINHTRANG_GIAIQUYET,2,'CHƯA PHÂN CÔNG',3,'ĐÃ PHÂN CÔNG') INTO v_TINHTRANG_GQ_TEN FROM DUAL;
    -------------------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
   ---------------------------
   FOR item in  (
      SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_TINHTRANG_GIAIQUYET,2,a.NGAYTAO,3,PCTP_GQ.NGAYTAO) desc) STT,COUNT(*) OVER () as CountAll, A.ID,A.MAVUVIEC,A.TENVUVIEC,A.SOTHUTU,A.NGAYNHANDON,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
      DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
      GN.TRUONGHOPGIAONHAN,STBA.BANAN_QD_ST,STKN.KHANGNGHI_ST,
      GD.MAGIAIDOAN,(BC3.HoTen||BC2.HoTen)HOTENBICAN ,
         CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
                TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
                'Ngày NPC: '||to_char(PCTP_GQ.NGAYNHANPHANCONG,'dd/MM/yyyy') NGAYPHANCONGTP,
                'Ngày PC: '||to_char(PCTP_GQ.NGAYPHANCONG,'dd/MM/yyyy') NGAYPHANCONGLD,
                 PCTP_GQ.CANBOID THAMPHAN_ID,'TP: '||PCTP_GQ.HOTEN THAMPHAN_TEN
                ,PCTP_GQ.NGUOIPHANCONGID LANHDAO_ID,'LĐ: '||PCTP_GQ.HOTEN_LD LANHDAO_TEN
                ,PCTP_GQ.ID THAMPHANGQ_ID
       FROM AHC_DON A
      INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_SOTHAM_THULY TL 
                       GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3   
            ----anhvh add 05/05/2020 hàm lấy 1 bản ghi mới nhất
            LEFT JOIN ( SELECT NNPC.HOTEN,NPC.HOTEN HOTEN_LD,GG.* FROM AHC_DON_THAMPHAN GG
                                INNER JOIN (
                                            SELECT TT.DONID,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',')ID --lấy 1 ID đầu tiên mới nhất
                                                FROM (
                                                SELECT TP.DONID ,
                                                LISTAGG (TP.ID, ',') WITHIN GROUP (ORDER BY TP.NGAYPHANCONG DESC,TP.NGAYTAO DESC)||','ID
                                                FROM AHC_DON_THAMPHAN TP 
                                                WHERE ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )
                                                AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
                                                GROUP BY TP.DONID  )TT
                                         )TS ON TS.ID=GG.ID
                         LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID   
                         LEFT JOIN DM_CANBO NPC ON NPC.ID=GG.NGUOIPHANCONGID   
                      )PCTP_GQ ON PCTP_GQ.DONID=A.ID
            ----
            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- Đang hoãn phiên tòa sơ thẩm'TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                        WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                        GROUP BY QSV.DONID,'</br>- Đang hoãn phiên tòa sơ thẩm'
            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 
             LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.DONID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3
                 LEFT JOIN (
                        SELECT QSV.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                        WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                        AND BA.DONID IS NULL  -- chưa có bản án
                        GROUP BY QSV.DONID,'</br>- Đang tạm đình chỉ'
                       )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   
                 LEFT JOIN (
                        SELECT PTQDVA.DONID,'</br>- Đang tạm đình chỉ' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                        WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.DONID,'</br>- Đang tạm đình chỉ'
                       )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  
                LEFT JOIN (
                        SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ FROM AHC_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm'
                        )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2      
                 LEFT JOIN ( 
                        SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AHC_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN (
                       SELECT QSV.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('DC',QDL.MA)>0
                       GROUP BY QSV.DONID,'</br>- Đã có QĐ đình chỉ'
                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ đình chỉ'
                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      
             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- Đã có QĐ công nhận thỏa thuận' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('CNTT',QDL.MA)>0
                       GROUP BY QSV.DONID,'</br>- Đã có QĐ công nhận thỏa thuận'
                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN (
                       SELECT QSV.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AHC_SOTHAM_QUYETDINH QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('CVA',QDL.MA)>0
                       GROUP BY QSV.DONID,'</br>- Đã có QĐ chuyển vụ án'
                       )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   
             LEFT JOIN (
                      SELECT PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án' TINHTRANG_GQ FROM AHC_PHUCTHAM_QUYETDINH PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('CVA',QDL.MA)>0
                      GROUP BY PTQDVA.DONID,'</br>- Đã có QĐ chuyển vụ án'
                     )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3     
            -------trường hợp giao nhận add vào cột trạng thái          
           LEFT JOIN (SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2                 
         -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
         LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b><br/>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b><br/>'
                  )GN ON  GN.VUANID=a.ID
         ------bị cáo lấy cho sơ thẩm
         LEFT JOIN ( SELECT TS.DONID,'<br /><i>Đương sự khác:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_NGUYENDON',' (Nguyên đơn)'),'_BIDON',' (Bị đơn)'),'_QUYENNVLQ',' (Người có quyền và NVLQ)'),',','<br/>')HOTEN FROM (
                            SELECT TT.DONID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,',',1,DECODE(TT.COUNT_DS,1,1,2,2,3,3,3) )),',')HOTEN 
                                FROM (
                                      select COUNT(*)COUNT_DS,DS.DONID,
                                        listagg (DS.TENDUONGSU||'_'||DS.TUCACHTOTUNG_MA, ',') WITHIN GROUP (ORDER BY DS.TENDUONGSU)||',' HOTEN
                                        FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=0
                                        GROUP BY DS.DONID
                                     )TT
                     )TS
                )BC2 ON BC2.DONID=A.ID AND GD.MAGIAIDOAN=2
             ------bị cáo kháng cáo lấy cho phúc thẩm    
            LEFT JOIN ( SELECT TS.DONID,'<br /><i>Người kháng cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_NGUYENDON',' (Nguyên đơn)'),'_BIDON',' (Bị đơn)'),'_QUYENNVLQ',' (Người có quyền và NVLQ)'),',','<br/>')HOTEN FROM (
                            SELECT TT.DONID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,',',1,DECODE(TT.COUNT_DS,1,1,2,2,3,3,3) )),',')HOTEN 
                                FROM (
                                      select COUNT(*)COUNT_DS,DS.DONID,
                                        listagg (DS.TENDUONGSU||'_'||DS.TUCACHTOTUNG_MA, ',') WITHIN GROUP (ORDER BY DS.TENDUONGSU)||',' HOTEN
                                        FROM AHC_DON_DUONGSU DS
                                        INNER JOIN (SELECT DUONGSUID, LOAIKHANGCAO,DONID FROM AHC_SOTHAM_KHANGCAO ) KC ON KC.DUONGSUID = DS.ID AND KC.DONID=DS.DONID
                                        --WHERE DS.ISDAIDIEN=0
                                        GROUP BY DS.DONID
                                     )TT
                     )TS
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
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE  UPPER(DS.TENDUONGSU) LIKE '%'||UPPER(V_TENDUONGSU)||'%' AND DS.DONID=A.ID)
                    )
            ) 
            AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))--Cấp xét xử
            AND (GD.TOAANID =V_TOAAN_ID  OR GD.TOAPHUCTHAMID=V_TOAAN_ID)--Tòa xx sơ thẩm
--         -----   
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLS.DONID IS NOT NULL 
                              AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                           OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
         AND (V_THAMPHAN_ID IS NULL
            OR( EXISTS(SELECT 'x' FROM AHC_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR(EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
            )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
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
           --Tình trạng GQ;
         AND(v_TINHTRANG_GIAIQUYET IS NULL
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                   AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  PCTP_GQ.NGAYNHANPHANCONG>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PCTP_GQ.NGAYNHANPHANCONG<=VV_DENNGAY)   
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
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr('DC,CVA,CNTT',T2.MA)>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) 
            -----------
     )
      LOOP             
            CountAll_S:=item.CountAll;
           DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <tr style="font-size: 12pt;padding:3pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">
                                        <i style="margin-right: 3px;">Tên vụ án:</i>  <b>'||item.TENVUVIEC||'</b><br />
                                        <i style="margin-right: 3px;">Mã vụ án:</i>  <b>'||item.MAVUVIEC||'</b><br />
                                        <i style="margin-right: 3px;">Cấp xét xử:</i>  <b>'||item.GiaiDoanVuViec||'</b>'
                                         ||item.TruongHopGiaoNhan
                                         ||item.TenToaSoTham||item.BANAN_QD_ST||item.HoTenBiCan||item.KHANGNGHI_ST||'
                 </td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGAYPHANCONGTP||'<br/>'||item.THAMPHAN_TEN||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGAYPHANCONGLD||'<br/>'||item.LANHDAO_TEN||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
                ');
       END LOOP;
       --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="5" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="5" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH '||v_TINHTRANG_GQ_TEN||' THẨM PHÁN <br/>'||V_TOAAN_TEN||'</b>
                    <br /><i style="font-size: 12pt;">(Số liệu tính từ ngày '||V_TUNGAY_BC||' đến ngày '||V_DENNGAY_BC||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="5" style="height: 15pt; text-align: left;"><b>Tổng số: '||CountAll_S||' bản ghi</b></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thông tin vụ án </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận phân công<br />/ Thẩm phán </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày phân công<br />/ Người phân công </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú </td>
            </tr>
                 '); 
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1pt;">
                <td style="width: 30pt"></td>
                <td style="width: 350pt"></td>
                <td style="width: 130pt"></td>
                <td style="width: 130pt"></td>
                <td style="width: 130pt"></td>
            </tr>
        </table>
      ');
       OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;       
END DON_SEARCH_PRINT_OLD;
FUNCTION DON_SEARCH_PRINT
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
    Page_Index in	int,
    Page_Size	in	int
)RETURN SYS_REFCURSOR
IS 
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
   ----------------
      V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; CountAll_S number:=0;
      V_TUNGAY_BC VARCHAR2(500); V_DENNGAY_BC VARCHAR2(500);v_TINHTRANG_GQ_TEN VARCHAR2(500);V_TOAAN_TEN VARCHAR2(200);
      V_CAPXX_TEN VARCHAR2(100); V_CAPTAND_TEN VARCHAR2(100); 
BEGIN
     SELECT DECODE(v_Capxx,2,'SƠ THẨM',3,'PHÚC THẨM') INTO V_CAPXX_TEN FROM DUAL;
     SELECT DECODE(V_CAP_XET_XU_LOGIN,'CAPTINH','TANDT','CAPCAO','TANDCC') INTO V_CAPTAND_TEN FROM DUAL;
     ------------------
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
     --
     SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN','TAND') INTO V_TOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=v_toaan_id;
     SELECT DECODE(V_TUNGAY,NULL,'..........',V_TUNGAY) INTO V_TUNGAY_BC FROM DUAL;
     SELECT DECODE(V_DENNGAY,NULL,'..........',V_DENNGAY) INTO V_DENNGAY_BC FROM DUAL;
      SELECT DECODE(v_TINHTRANG_GIAIQUYET,2,'CHƯA PHÂN CÔNG',3,'ĐƯỢC') INTO v_TINHTRANG_GQ_TEN FROM DUAL;
    -------------------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
   ---------------------------
   FOR item in  (
      SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_TINHTRANG_GIAIQUYET,2,a.NGAYTAO,3,PCTP_GQ.NGAYTAO) desc) STT
      ,COUNT(*) OVER () as CountAll 
        ------BC mới------------------
        ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY
        ,T.Ten TENTOASOTHAM 
        ,TO_CHAR(DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY),'dd/MM/yyyy')NGAYTHULY
        ,DECODE(v_Capxx,2,NDST.TENDUONGSU,3,NDPT.TENDUONGSU)NGUYENDON
        ,DECODE(v_Capxx,2,BDST.TENDUONGSU,3,BDPT.TENDUONGSU)BIDON
        ,NDBDS.NDBD_NOIDUNG||'<br style="mso-data-placement:same-cell;" />'||NDKNS.NOIDUNGKN NDBD_NOIDUNG
        ,DECODE(A.QUANHEPHAPLUAT_NAME,NULL,i.TEN,QUANHEPHAPLUAT_NAME) QHPL_TEN,PCTP_GQ.HOTEN THAMPHAN_TEN
      FROM AHC_DON A
      INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_SOTHAM_THULY TL 
                       GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_PHUCTHAM_THULY TL 
                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3   
             ----lấy 1 bản ghi mới nhất 27/12/2023
            LEFT JOIN (
                     SELECT FIRST_VALUE(TP.ID) OVER (PARTITION BY TP.DONID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) ID,
                     CB.HOTEN,TP.DONID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG
                     FROM  AHC_DON_THAMPHAN TP
                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                     LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
                     WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
                     AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
           )PCTP_GQ ON PCTP_GQ.DONID = A.ID 
          LEFT JOIN (
                 SELECT DS.TENDUONGSU,DS.DONID  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='NGUYENDON'          
          )NDST ON NDST.DONID=A.ID AND GD.MAGIAIDOAN=2
         LEFT JOIN (
                SELECT DS.TENDUONGSU,DS.DONID  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='NGUYENDON'          
          )NDPT ON NDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
         LEFT JOIN (
                 SELECT DS.TENDUONGSU,DS.DONID  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
          )BDST ON BDST.DONID=A.ID AND GD.MAGIAIDOAN=2
         LEFT JOIN (
                SELECT DS.TENDUONGSU,DS.DONID  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
          )BDPT ON BDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
          LEFT JOIN (     
                        SELECT NDBD.DONID,
                        -- LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NDBD_NOIDUNG
                        RTRIM(XMLAGG(XMLELEMENT(E,NDBD.NOIDUNGKHANGCAO,'//BR').EXTRACT('//text()') ORDER BY NDBD.NOIDUNGKHANGCAO DESC).GetClobVal(),'//BR') NDBD_NOIDUNG
                        -- REPLACE(ITEM.NDBD_NOIDUNG,'//BR','<br style="mso-data-placement:same-cell;" />') vì định dạng text
                            FROM (
                                    SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                       SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                    FROM (   
                                          SELECT F.DON_ND FROM (
                                               select KC.DONID||';'
                                               ||decode(DS.TUCACHTOTUNG_MA,'BIDON','NBK','NGUYENDON','NKK','QUYENNVLQ','NLQ') ||' kc: '
                                               ||KC.NOIDUNGKHANGCAO DON_ND  
                                               from AHC_SOTHAM_KHANGCAO kc 
                                                LEFT JOIN AHC_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                where KC.NOIDUNGKHANGCAO is not null -- and kc.DONID=17177 
                                               )F
                                          GROUP BY F.DON_ND
                                      )FF

                                UNION ALL
                                    SELECT KC.DONID,'kc:'NOIDUNGKHANGCAO FROM AHC_SOTHAM_KHANGCAO  KC
                                    LEFT JOIN AHC_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                    WHERE KC.NOIDUNGKHANGCAO is null
                                    GROUP BY KC.DONID,'kc:'
                             )NDBD  GROUP BY NDBD.DONID
             )NDBDS ON NDBDS.DONID=A.ID
        ---------------------           
        LEFT JOIN (
                SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                            FROM (
                                    SELECT KC.DONID,' kn: ' ||KC.NOIDUNGKN NOIDUNGKN FROM AHC_SOTHAM_KHANGNGHI KC
                                    WHERE KC.NOIDUNGKN is not null
                                UNION ALL
                                    SELECT KC.DONID,'kn:'NOIDUNGKN FROM AHC_SOTHAM_KHANGNGHI KC
                                    WHERE KC.NOIDUNGKN is null
                                    GROUP BY KC.DONID,'kn:'
                             )NDKN  GROUP BY NDKN.DONID
               )NDKNS ON NDKNS.DONID=A.ID
        ---------------------
        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE  UPPER(DS.TENDUONGSU) LIKE '%'||UPPER(V_TENDUONGSU)||'%' AND DS.DONID=A.ID)
                    )
            ) 
            AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))--Cấp xét xử
              AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
--         -----   
            AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLS.DONID IS NOT NULL 
                              AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                           OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                       ) 
                    )
                  OR(v_TINHTRANG_THULY=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   )
               )
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
          AND (V_THAMPHAN_ID IS NULL
            OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID AND ((v_Capxx=2 AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )  )  )--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR(EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
            )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
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
           --Tình trạng GQ;
         AND(v_TINHTRANG_GIAIQUYET IS NULL
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                   AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  PCTP_GQ.NGAYNHANPHANCONG>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PCTP_GQ.NGAYNHANPHANCONG<=VV_DENNGAY)   
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
                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                   WHERE instr('DC,CVA,CNTT',T2.MA)>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                    )   
                ) 
            -----------
     )
      LOOP             
           CountAll_S:=item.CountAll;
           DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Hành chính</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||REPLACE(item.NDBD_NOIDUNG,'//BR','<br style="mso-data-placement:same-cell;" />')||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.THAMPHAN_TEN||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
                ');
       END LOOP;
      DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="15" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="15" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH THẨM PHÁN  '||v_TINHTRANG_GQ_TEN||' PHÂN CÔNG XÉT XỬ
                    <br />
                    '||V_CAPXX_TEN||' ÁN HÀNH CHÍNH
                </b>
                    <br />
                    (Kèm theo quyết định số:.../....../QĐ-TA, ngày .../.../..... của Chánh án '||V_CAPTAND_TEN||')
                </td>
            </tr>
            <tr>
                <td colspan="15" style="height: 15pt; text-align: left;"><b>Tổng số: '||CountAll_S||' bản ghi</b></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Loại án</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số TL</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày TL</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tỉnh / TP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">NĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">BĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KC/KN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Vụ việc</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Chủ tọa</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">T.viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">T.viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thư ký</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
           </tr>
                 '); 
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
                 <td style="width: 43px"></td>
                <td style="width: 60px"></td>
                <td style="width: 45px"></td>
                <td style="width: 45px"></td>
                <td style="width: 70px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 148px"></td>
                <td style="width: 110px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 60px"></td>
            </tr>
        </table>
      ');
       OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;       
END DON_SEARCH_PRINT;
--FUNCTION DON_SEARCH_PRINT_ITEM
--( 
--    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
--    V_TEN_VU_AN IN VARCHAR2, 
--    V_QHPL IN VARCHAR2, 
--    V_MA_VU_AN IN VARCHAR2, 
--    V_TENDUONGSU IN VARCHAR2,
--    V_CAPXX IN VARCHAR2,
--    V_TOAAN_ID IN VARCHAR2, 
--    V_TINHTRANG_THULY IN VARCHAR2,
--    V_NGAYTHULY_TU IN VARCHAR2,
--    V_NGAYTHULY_DEN IN VARCHAR2,
--    V_SOTHULY IN VARCHAR2,
--    V_THAMPHAN_ID IN VARCHAR2, 
--    V_TINHTRANG_GIAIQUYET IN VARCHAR2,
--    V_TUNGAY IN VARCHAR2,
--    V_DENNGAY IN VARCHAR2,
--    V_KETQUA IN VARCHAR2,
--    V_SO_QD IN VARCHAR2,
--    V_NGAY_QD IN VARCHAR2,
--    V_THUKY_ID IN VARCHAR2, 
--    V_THOIHAN_GQ IN VARCHAR2, 
--    V_LOAIDON IN VARCHAR2, 
--    V_PT_RKINHNGHIEM IN VARCHAR2, 
--    V_GQDON IN VARCHAR2, 
--    Page_Index in	int,
--    Page_Size	in	int
--)RETURN SYS_REFCURSOR
--IS 
--  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; 
--  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
--   ----------------
--      V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; CountAll_S number:=0;
--      V_TUNGAY_BC VARCHAR2(500); V_DENNGAY_BC VARCHAR2(500);v_TINHTRANG_GQ_TEN VARCHAR2(100);V_TOAAN_TEN VARCHAR2(200);
--      V_CAPXX_TEN VARCHAR2(100); V_CAPTAND_TEN VARCHAR2(100); 
--BEGIN
--     SELECT DECODE(v_Capxx,2,'SƠ THẨM',3,'PHÚC THẨM') INTO V_CAPXX_TEN FROM DUAL;
--     SELECT DECODE(V_CAP_XET_XU_LOGIN,'CAPTINH','TANDT','CAPCAO','TANDCC') INTO V_CAPTAND_TEN FROM DUAL;
--     ------------------
--     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
--     --
--     SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN','TAND') INTO V_TOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=v_toaan_id;
--     SELECT DECODE(V_TUNGAY,NULL,'..........',V_TUNGAY) INTO V_TUNGAY_BC FROM DUAL;
--     SELECT DECODE(V_DENNGAY,NULL,'..........',V_DENNGAY) INTO V_DENNGAY_BC FROM DUAL;
--     SELECT DECODE(v_TINHTRANG_GIAIQUYET,2,'CHƯA PHÂN CÔNG',3,'ĐƯỢC') INTO v_TINHTRANG_GQ_TEN FROM DUAL;
--    -------------------
--     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
--     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
--     --
--     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
--     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
--   ---------------------------
--   FOR item in  (
--      SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,TLS.SOTHULY,3,to_number(regexp_replace(TLPT.SOTHULY, '[^[:digit:]]', '')) )ASC ) STT
--      ,COUNT(*) OVER () as CountAll
--        ------BC mới------------------
--        ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY
--        ,T.Ten TENTOASOTHAM 
--        ,to_char(DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY),'dd/MM/yyyy')NGAYTHULY
--        ,DECODE(v_Capxx,2,NDST.TENDUONGSU,3,NDPT.TENDUONGSU)NGUYENDON
--        ,DECODE(v_Capxx,2,BDST.TENDUONGSU,3,BDPT.TENDUONGSU)BIDON
--        ,NDBDS.NOIDUNGKHANGCAO||'<br style="mso-data-placement:same-cell;" />'||NDKNS.NOIDUNGKN NOIDUNGKHANGCAO
--        ,DECODE(A.QUANHEPHAPLUAT_NAME,NULL,i.TEN,QUANHEPHAPLUAT_NAME) QHPL_TEN,PCTP_GQ.HOTEN THAMPHAN_TEN
--      FROM AHC_DON A
--      INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
--      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
--      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
--        ------Trạng thái giải quyết trong danh sách
--            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_SOTHAM_THULY TL 
--                       GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
--            LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_PHUCTHAM_THULY TL 
--                      GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3
--            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
--                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--            LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
--                       GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3   
--              ----lấy 1 bản ghi mới nhất 27/12/2023
--            LEFT JOIN (
--                     SELECT FIRST_VALUE(TP.ID) OVER (PARTITION BY TP.DONID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) ID,
--                     CB.HOTEN,TP.DONID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG
--                     FROM  AHC_DON_THAMPHAN TP
--                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
--                     LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
--                     WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
--                     AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
--           )PCTP_GQ ON PCTP_GQ.DONID = A.ID 
--          LEFT JOIN (
--                 SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHC_DON_DUONGSU DS WHERE  DS.TUCACHTOTUNG_MA='NGUYENDON'          
--                 GROUP BY DS.DONID
--          )NDST ON NDST.DONID=A.ID AND GD.MAGIAIDOAN=2
--         LEFT JOIN (
--                SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU FROM AHC_DON_DUONGSU DS WHERE DS.TUCACHTOTUNG_MA='NGUYENDON'     
--                GROUP BY DS.DONID
--          )NDPT ON NDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
--         LEFT JOIN (
--                 SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
--                 GROUP BY DS.DONID
--          )BDST ON BDST.DONID=A.ID AND GD.MAGIAIDOAN=2
--         LEFT JOIN (
--                SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
--                GROUP BY DS.DONID
--          )BDPT ON BDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
--          -- SO LƯƠNG + TUCACHTOTUNG_MA
--          LEFT JOIN (     
--                    SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
--                        FROM (
--                                SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
--                                   SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
--                                FROM (   
--                                      SELECT F.DON_ND FROM (
--                                            select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
--                                            from AHC_SOTHAM_KHANGCAO kc 
--                                            LEFT JOIN AHC_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
--                                            GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
--                                           )F
--                                      GROUP BY F.DON_ND
--                                  )FF
--                         )NDBD  GROUP BY NDBD.DONID
--             )NDBDS ON NDBDS.DONID=A.ID
--        ---KHANG NGHI - TOAAN - VIEN KIEM SOAT       
--        LEFT JOIN (
--                SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
--                            FROM (
--                                    SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AHC_SOTHAM_KHANGNGHI KC
--                             )NDKN  GROUP BY NDKN.DONID
--               )NDKNS ON NDKNS.DONID=A.ID
--        ---------------------
--        WHERE   (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )--Tên vụ án
--            AND (V_QHPL IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(V_QHPL)||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
--            AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  LOWER(V_MA_VU_AN) ) )   --Mã vụ án
--            AND (V_TENDUONGSU IS NULL --Đương sự
--                  OR( EXISTS (SELECT 'X' FROM AHC_DON_DUONGSU DS WHERE  UPPER(DS.TENDUONGSU) LIKE '%'||UPPER(V_TENDUONGSU)||'%' AND DS.DONID=A.ID)
--                    )
--            ) 
--            AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))--Cấp xét xử
--            AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
--                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO'))-- AND T.LOAITOA!='CAPHUYEN'))
--             )
--         -----   
--              AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
--                  OR(v_TINHTRANG_THULY=1 
--                       AND (
--                            (TLS.DONID IS NOT NULL 
--                              AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
--                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
--                             )
--                           OR 
--                           (TLPT.DONID IS NOT NULL
--                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
--                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
--                             )
--                       ) 
--                    )
--                  OR(v_TINHTRANG_THULY=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
--                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
--                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)   
--                   )
--               )
--         -----
--          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
--         -----
--        AND (V_THAMPHAN_ID IS NULL
--            OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID AND ((v_Capxx=2 AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  )  )  )--Thẩm phán
--           )
--            --GQ đơn;V_GQDON -- -- 
--          AND (V_GQDON IS NULL 
--              OR(EXISTS ( SELECT 'X' FROM AHC_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
--            )  
--          AND (V_THUKY_ID is null--Thư ký
--                   OR( EXISTS(select 'X' from AHC_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
--                       OR EXISTS(select 'X' from AHC_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
--                     )
--                )
--            ------Loại đơn
--           AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
--           --------------
--            AND (V_SO_QD IS NULL--Số BA/QĐ
--                 OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
--                       OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
--                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
--                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
--                     )
--                )
--            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
--             OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
--                   OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
--                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
--                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
--                 )
--             )
--           --Tình trạng GQ;
--         AND(v_TINHTRANG_GIAIQUYET IS NULL
--             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
--                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
--                   AND (V_TUNGAY IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
--                   AND (V_DENNGAY IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
--                )
--               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
--                   AND EXISTS (
--                            SELECT 'x' FROM AHC_DON_THAMPHAN PC 
--                            WHERE PC.DONID=A.ID
--                            AND (
--                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
--                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
--                                 )
--                            AND (V_TUNGAY IS NULL OR  PCTP_GQ.NGAYNHANPHANCONG>=VV_TUNGAY)
--                            AND (V_DENNGAY IS NULL OR PCTP_GQ.NGAYNHANPHANCONG<=VV_DENNGAY)   
--                      )
--               )
--             )
--             -- END v_TINHTRANG_GIAIQUYET
--             --là con của chưa giải quyết xong 
--            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
--               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
--                     AND (EXISTS (
--                                SELECT 'X' FROM AHC_SOTHAM_THULY TL
--                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
--                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHC_SOTHAM_QUYETDINH T1 
--                                                   INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
--                                                   WHERE instr('DC,CVA,CNTT',T2.MA)>0 AND TL.DONID=T1.DONID) )
--                                        )
--                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                     OR EXISTS (
--                                SELECT 'X' FROM AHC_PHUCTHAM_THULY PTTL 
--                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
--                                        AND NOT EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                                                       INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
--                                                       WHERE instr('DC,CVA,CNTT',QDL.MA)>0 AND  PTTL.DONID=PTQDVA.DONID 
--                                                       )
--                                 )
--                                 AND PTTL.DONID=a.id  AND GD.MAGIAIDOAN=3
--                               )
--                      )
--                    )   
--                ) 
--            -----------
--     )
--      LOOP             
--           CountAll_S:=item.CountAll;
--           DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Hành chính</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NOIDUNGKHANGCAO||'</td>
--            </tr>
--                ');
--       END LOOP;
--      DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--           <table cellpadding="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
--            <tr>
--                <td colspan="9" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH ÁN HÀNH CHÍNH THỤ LÝ MỚI</b>
--                </td>
--            </tr>
--            <tr>
--                <td colspan="9" style="height: 15pt; text-align: left;"><b>Tổng số: '||CountAll_S||' bản ghi</b></td>
--            </tr>
--            <tr style="font-weight: bold;">
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Loại án</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số TL</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày TL</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tỉnh / TP</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Vụ việc</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KC/KN</td>
--            </tr>
--                 '); 
--       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
--       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
--       --------------------------------
--       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--          <tr style="height: 1px;">
--                <td style="width: 43px"></td>
--                <td style="width: 72px"></td>
--                <td style="width: 61px"></td>
--                <td style="width: 90px"></td>
--                <td style="width: 115px"></td>
--                <td style="width: 115px"></td>
--                <td style="width: 166px"></td>
--                <td style="width: 185px"></td>
--                <td style="width: 90px"></td>
--            </tr>
--        </table>
--      ');
--       OPEN V_CURSOR FOR
--        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
--        dbms_lob.freetemporary(V_EXPORT_TEXT);
--        RETURN V_CURSOR;       
--END DON_SEARCH_PRINT_ITEM;
END PKG_PCTP_HANHCHINH;

/
