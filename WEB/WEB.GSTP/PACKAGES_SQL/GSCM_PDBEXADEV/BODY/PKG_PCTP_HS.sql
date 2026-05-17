--------------------------------------------------------
--  DDL for Package Body PKG_PCTP_HS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_PCTP_HS" AS

PROCEDURE PCTP_INS_UP
(
    V_TRANGTHAI IN VARCHAR2,
    V_THAMPHANGQ_ID IN VARCHAR2,
    V_VUANID	IN VARCHAR2,
    V_SOQD	IN VARCHAR2,
    V_NGAYQD	IN VARCHAR2,
    V_THULY	IN VARCHAR2,
    V_NGAYPHANCONGTP	IN VARCHAR2,
    V_THAM_PHAN_ID	IN VARCHAR2,
    V_NGAYPHANCONGLD	IN VARCHAR2,
    V_PHANCONGLD_ID	IN VARCHAR2,
    V_CAPXX	IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_TOA_GIAIQUYET_ID IN VARCHAR2,
    V_COUNTS OUT NUMBER,
    V_THONGBAO	OUT VARCHAR2
)
AS
   V_VAITRO  VARCHAR2(100); V_COUNT_CHECK NUMBER; V_COUNT_FILE NUMBER;V_FILE_ID VARCHAR2(100):=NULL;
   V_BIEUMAU_ID NUMBER:=0;V_TOAANID NUMBER;
BEGIN 
    V_COUNTS:=0;V_THONGBAO:='';
    SELECT DECODE(V_CAPXX,'2','VTTP_GIAIQUYETSOTHAM','3','VTTP_GIAIQUYETPHUCTHAM') INTO V_VAITRO FROM DUAL;
    SELECT A.TOAANID INTO V_TOAANID FROM AHS_VUAN A WHERE A.ID=V_VUANID;
    ----------
    IF(V_TRANGTHAI=2) THEN
       IF(V_SOQD IS NOT NULL AND V_NGAYQD IS NOT NULL AND V_NGAYPHANCONGTP IS NOT NULL AND  V_THAM_PHAN_ID IS NOT NULL AND V_NGAYPHANCONGLD IS NOT NULL AND V_PHANCONGLD_ID IS NOT NULL) THEN
         SELECT COUNT(*) INTO V_COUNT_CHECK FROM AHS_THAMPHANGIAIQUYET X 
         WHERE X.VUANID=V_VUANID AND X.CANBOID=V_THAM_PHAN_ID AND X.MAVAITRO=V_VAITRO;
         ----V_COUNT_CHECK
          IF(V_COUNT_CHECK=0)THEN
             SELECT BM.ID INTO V_BIEUMAU_ID FROM DM_BIEUMAU BM WHERE BM.MABM='01-HS' AND ROWNUM=1;
              --xử lý giá trị V_FILE_ID
              IF(V_BIEUMAU_ID>0)THEN
                SELECT COUNT(*) INTO V_COUNT_FILE FROM AHS_FILE FI WHERE FI.VUANID=V_VUANID AND FI.MAGIAIDOAN=V_CAPXX 
                AND FI.BIEUMAUID=V_BIEUMAU_ID AND ROWNUM=1;
                --
                    IF(V_COUNT_FILE>0)THEN
                         SELECT FI.ID INTO V_FILE_ID FROM AHS_FILE FI WHERE FI.VUANID=V_VUANID AND FI.MAGIAIDOAN=V_CAPXX 
                         AND FI.BIEUMAUID=V_BIEUMAU_ID AND ROWNUM=1;
                         -----------
                         UPDATE AHS_FILE
                         SET VUANID=V_VUANID,TOAANID=V_TOAANID,MAGIAIDOAN=V_CAPXX,LOAIFILE=0,BIEUMAUID=V_BIEUMAU_ID,
                         NAM=EXTRACT(YEAR FROM SYSDATE),NGAYTAO=SYSDATE,NGUOITAO=V_NGUOITAO
                         WHERE ID=V_FILE_ID;
                    ELSIF(V_COUNT_FILE=0)THEN
                        SELECT AHS_FILE_SEQ.NEXTVAL INTO V_FILE_ID FROM DUAL;
                          INSERT INTO AHS_FILE
                          (ID,VUANID,TOAANID,MAGIAIDOAN,LOAIFILE,BIEUMAUID,NAM,NGAYTAO,NGUOITAO)
                          VALUES (V_FILE_ID,V_VUANID,V_TOAANID,V_CAPXX,0,V_BIEUMAU_ID,EXTRACT(YEAR FROM SYSDATE),SYSDATE,V_NGUOITAO);
                    END IF;
                END IF;
           ----------
             INSERT INTO AHS_THAMPHANGIAIQUYET
               (ID,VUANID,CANBOID,MAVAITRO,NGAYPHANCONG,NGAYNHANPHANCONG,NGUOIPHANCONGID,
                NGAYTAO,NGUOITAO,NGAYSUA,NGUOISUA,THULYID,FILEID,SOQD,NGAYQD,
                TOA_GIAIQUYET_ID) -- UPDATE toa_gq_id
             VALUES (AHS_THAMPHANGIAIQUYET_SEQ.NEXTVAL,V_VUANID,V_THAM_PHAN_ID,V_VAITRO,TO_DATE(V_NGAYPHANCONGLD,'dd/MM/yyyy'),TO_DATE(V_NGAYPHANCONGTP,'dd/MM/yyyy'),V_PHANCONGLD_ID,
                sysdate,V_NGUOITAO,sysdate,V_NGUOITAO,V_THULY,V_FILE_ID,V_SOQD,TO_DATE(V_NGAYQD,'dd/MM/yyyy'),V_TOA_GIAIQUYET_ID);
              -----
             V_COUNTS:=1;
          ELSIF(V_COUNT_CHECK>0)THEN
             V_THONGBAO:='Thẩm phán đã được phân công, bạn phải chọn Thẩm phán khác';
          END IF;
        ------
      END IF;
    ELSIF(V_TRANGTHAI=3) THEN
        IF(V_SOQD IS NOT NULL AND V_NGAYQD IS NOT NULL AND V_NGAYPHANCONGTP IS NOT NULL AND  V_THAM_PHAN_ID IS NOT NULL AND V_NGAYPHANCONGLD IS NOT NULL AND V_PHANCONGLD_ID IS NOT NULL) THEN
          UPDATE AHS_THAMPHANGIAIQUYET
            SET  
                CANBOID=V_THAM_PHAN_ID,
                NGAYPHANCONG=TO_DATE(V_NGAYPHANCONGLD,'dd/MM/yyyy'),
                NGAYNHANPHANCONG=TO_DATE(V_NGAYPHANCONGTP,'dd/MM/yyyy'),
                NGUOIPHANCONGID=V_PHANCONGLD_ID,
                NGAYSUA=sysdate,
                NGUOISUA=V_NGUOITAO,
                THULYID=V_THULY,
                SOQD=V_SOQD,
                NGAYQD=TO_DATE(V_NGAYQD,'dd/MM/yyyy')
            WHERE ID=V_THAMPHANGQ_ID; 
        V_COUNTS:=1;
        END IF;
    END IF;
END PCTP_INS_UP;

PROCEDURE AHS_VUAN_GETALLPAGING
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_Capxx in varchar2,
    v_toaan_id in varchar2, 
    v_TINHTRANG_THULY in varchar2,
    V_NGAYTHULY_TU in varchar2,
    V_NGAYTHULY_DEN in varchar2,
    v_SOTHULY in varchar2,
    v_TINHTRANG_GIAIQUYET in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_KETQUA in varchar2,
    v_so_qd in varchar2,
    v_ngay_qd in varchar2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2, 
    v_THOIHAN_GQ in varchar2, 
    v_QD_TAMGIAM in varchar2, 
    Page_Index in	int,
    Page_Size	in	int, 
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number;
      VV_TUNGAY DATE;VV_DENNGAY DATE;  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
BEGIN	
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;
    -------------------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    ------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_TINHTRANG_GIAIQUYET,2,a.NGAYTAO,3,PCTP_GQ.NGAYTAO) DESC) STT,COUNT(*) OVER () as CountAll,a.ID, a.MaVuAn, a.TenVuAn, a.TT, a.NgayBanCaoTrang
            ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
            , a.NguoiTao,GD.MAGIAIDOAN, 
            DECODE(GD.MAGIAIDOAN,3,BC3.HoTen,BC2.HoTen) HoTenBiCan, decode(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||b.Ten||'</b>',null) TenToaSoTham, 
            DECODE(GD.MAGIAIDOAN,3,GN.TruongHopGiaoNhan,AA.TruongHopGiaoNhan)TruongHopGiaoNhan,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm'  , 3, 'Phúc thẩm' , 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec,
            STBA.BANAN_QD_ST, STKN.KHANGNGHI_ST,
            ---
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
             ||GNST.TINHTRANG_GQ
            TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
            to_char(PCTP_GQ.NGAYNHANPHANCONG,'dd/MM/yyyy') NGAYPHANCONGTP, to_char(PCTP_GQ.NGAYPHANCONG,'dd/MM/yyyy') NGAYPHANCONGLD,
            PCTP_GQ.CANBOID THAMPHAN_ID,PCTP_GQ.NGUOIPHANCONGID LANHDAO_ID,PCTP_GQ.THULYID,PCTP_GQ.SOQD,to_char(PCTP_GQ.NGAYQD,'dd/MM/yyyy')NGAYQD,PCTP_GQ.ID THAMPHANGQ_ID
            FROM AHS_VUAN A
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
            LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.VUANID,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHS_SOTHAM_THULY TL 
                       GROUP BY TL.VUANID,'</br>- Đã thụ lý')TLS ON A.ID=TLS.VUANID AND GD.MAGIAIDOAN=2
            LEFT JOIN (SELECT TL.VUANID,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHS_PHUCTHAM_THULY TL 
                      GROUP BY TL.VUANID,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.VUANID AND GD.MAGIAIDOAN=3
            LEFT JOIN (SELECT TP.VUANID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHS_THAMPHANGIAIQUYET TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
                       GROUP BY TP.VUANID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.VUANID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (SELECT TP.VUANID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHS_THAMPHANGIAIQUYET TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.VUANID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.VUANID=A.ID AND GD.MAGIAIDOAN=3 
             ----lấy 1 bản ghi mới nhất 27/12/2023
            LEFT JOIN (
                     SELECT FIRST_VALUE(TP.ID) OVER (PARTITION BY TP.VUANID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) ID,
                     CB.HOTEN,TP.VUANID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG,
                     TP.NGAYQD,TP.SOQD,TP.THULYID
                     FROM  AHS_THAMPHANGIAIQUYET TP
                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                     LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
                     WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
                     AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
           )PCTP_GQ ON PCTP_GQ.VUANID = A.ID 
            ----            
            LEFT JOIN (
                        SELECT QSV.VUANID,'</br>- Đang hoãn phiên tòa sơ thẩm'TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON QSV.VUANID =BA.VUANID 
                        WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                        GROUP BY QSV.VUANID,'</br>- Đang hoãn phiên tòa sơ thẩm'
            )HPT ON HPT.VUANID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (
                        SELECT PTQDVA.VUANID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=PTQDVA.VUANID 
                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.VUANID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.VUANID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.VUANID=A.id  AND GD.MAGIAIDOAN=3
            LEFT JOIN (
                        SELECT QSV.VUANID,'</br>- Đang tạm đình chỉ vụ án' TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON QSV.VUANID =BA.VUANID 
                        WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                        AND BA.VUANID IS NULL  -- chưa có bản án
                        GROUP BY QSV.VUANID,'</br>- Đang tạm đình chỉ vụ án'
                       )TDC ON  TDC.VUANID=A.id AND GD.MAGIAIDOAN=2
            LEFT JOIN (
                        SELECT PTQDVA.VUANID,'</br>- Đang tạm đình chỉ vụ án' TINHTRANG_GQ FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTQDVA.VUANID --BẢN ÁN 
                        WHERE PTBA.VUANID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.VUANID,'</br>- Đang tạm đình chỉ vụ án'
                       )TDCPT ON  TDCPT.VUANID=A.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                        SELECT BA.VUANID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ FROM AHS_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.VUANID,'</br>- Đã có bản án sơ thẩm'
                        )BAST ON  BAST.VUANID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN ( 
                        SELECT PTBA.VUANID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AHS_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.VUANID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.VUANID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                       SELECT QSV.VUANID,'</br>- Đã có QĐ đình chỉ vụ án' TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('DC,',QDL.MA)>0
                       GROUP BY QSV.VUANID,'</br>- Đã có QĐ đình chỉ vụ án'
                       )DCST ON  DCST.VUANID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN (
                      SELECT PTQDVA.VUANID,'</br>- Đã có QĐ đình chỉ vụ án' TINHTRANG_GQ FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.VUANID,'</br>- Đã có QĐ đình chỉ vụ án'
                     )DCPT ON  DCPT.VUANID=a.id AND GD.MAGIAIDOAN=3
                 -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2           
            -------trường hợp giao nhân dùng cho sơ thẩm với viện kiểm sát
            LEFT JOIN (SELECT A1.ID, DECODE(A1.TruongHopGiaoNhan,1, 'VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm',2,'Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung',3, 'Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung',''
                       ) TruongHopGiaoNhan  FROM AHS_VUAN A1) AA ON AA.ID=A.ID
            -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                      )GN ON  GN.VUANID=a.ID
           ------bị cáo lấy cho sơ thẩm
                LEFT JOIN(  SELECT TS.VUANID,'<br /><i>Bị cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_BOLD','<b>'),'_GHACH_NOI',' - '),'_DAUVU',' (đầu vụ)</b>'),';','<br/>')HOTEN FROM (
                                SELECT TT.VUANID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,';',1,DECODE(TT.COUNT_BC,1,1,2,2,3,3,3) )),';')HOTEN 
                                FROM (                     
                                            SELECT COUNT(*)COUNT_BC,BC.VUANID,
                                            listagg (DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||DECODE(c.TenToiDanh,NULL,NULL,'_GHACH_NOI')||c.TenToiDanh), ';' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC)||';' HOTEN
                                            FROM AHS_BICANBICAO BC  
                                            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                                            GROUP BY BC.VUANID
                                      )TT
                            )TS
                 ) BC2 ON BC2.VUANID=A.ID      
             ------bị cáo kháng cáo lấy cho phúc thẩm 
               LEFT JOIN(  SELECT TS.VUANID,'<br /><i>Bị cáo kháng cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_BOLD','<b>'),'_GHACH_NOI',' - '),'_DAUVU',' (đầu vụ)</b>'),';','<br/>')HOTEN FROM (
                                SELECT TT.VUANID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,';',1,DECODE(TT.COUNT_BC,1,1,2,2,3,3,3) )),';')HOTEN 
                                FROM (                     
                                            SELECT COUNT(*)COUNT_BC,BC.VUANID,
                                            listagg (DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh), ';' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC)||';' HOTEN
                                            FROM AHS_BICANBICAO BC  
                                            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                                            INNER JOIN (SELECT NGUOIKCID, LOAIKHANGCAO,VUANID FROM AHS_SOTHAM_KHANGCAO) KC ON KC.NGUOIKCID = BC.ID AND KC.VUANID=BC.VUANID
                                            GROUP BY BC.VUANID
                                      )TT
                            )TS
                 )BC3 ON BC3.VUANID=A.ID
            ------- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.VUANID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHS_SOTHAM_BANAN BA)STBA ON STBA.VUANID=A.ID 
            ------- lấy thông tin số ngày kháng nghị
          LEFT JOIN ( SELECT KN.VUANID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHS_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.VUANID
              )STKN ON STKN.VUANID=A.ID 
            -------
            WHERE (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )
                AND (V_TOIDANH IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TOIDANH)||'%' ) )--tìm tội danh đã được gắn vào tên vụ án
                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
                 AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  '%'||LOWER(V_MA_VU_AN)||'%' ) )
                AND (V_BI_CAN IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE UPPER(BC.HOTEN) LIKE '%'||UPPER(V_BI_CAN)||'%' AND BC.VUANID=A.ID)
                    )                
             AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))
                    OR(v_TINHTRANG_THULY=1 --đã thụ lý
                         AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                                           ) 
                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                               ) 
                             )
                    )
                    OR(v_TINHTRANG_THULY=2 --chưa thụ lý
                     AND ( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
                        )
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)      
                    )
                ) 
              AND (v_SOTHULY IS NULL
                OR(    EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
                    OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
                  )
               )
              AND (V_SO_QD IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                     )
                 )
              AND (v_ngay_qd IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                     )
                 )    
            -----------------v_TINHTRANG_GIAIQUYET
            AND ( (v_TINHTRANG_GIAIQUYET IS NULL  AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
                  OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                    AND NOT EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )
                       AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) 
                    )
                   OR(v_TINHTRANG_GIAIQUYET=3 --Đã phân công Thẩm phán
                    AND  EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
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
           AND (v_thamphan_id is null
                   OR(    EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID AND ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ))
                       OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID AND v_Capxx=2) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID AND v_Capxx=3)
                     )
                )
           AND (v_thuky_id is null
                   OR( EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID)
                     )
                )
          -- END v_TINHTRANG_GIAIQUYET
               --là con của chưa giải quyết xong  
               AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                    AND( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR('DC,CVA',T2.MA)>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR('DC,CVA',T2.MA)>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                    )   
                )--là con của chưa giải quyết xong end       
       )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
   ;
END AHS_VUAN_GETALLPAGING;

FUNCTION AHS_VUAN_GETALLPAGING_PRINT
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_ten_vu_an in varchar2, 
    v_toidanh in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    v_Capxx in varchar2,
    v_toaan_id in varchar2, 
    v_TINHTRANG_THULY in varchar2,
    V_NGAYTHULY_TU in varchar2,
    V_NGAYTHULY_DEN in varchar2,
    v_SOTHULY in varchar2,
    v_TINHTRANG_GIAIQUYET in varchar2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_KETQUA in varchar2,
    v_so_qd in varchar2,
    v_ngay_qd in varchar2,
    v_thamphan_id in varchar2, 
    v_thuky_id in varchar2, 
    v_THOIHAN_GQ in varchar2, 
    v_QD_TAMGIAM in varchar2, 
    Page_Index in	int,
    Page_Size	in	int
)RETURN SYS_REFCURSOR
AS
      TotalItem number;  MinIndex number; MaxIndex number;
      VV_TUNGAY DATE;VV_DENNGAY DATE;VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
      ----------------
      V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; CountAll_S number:=0;
      V_TUNGAY_BC VARCHAR2(500); V_DENNGAY_BC VARCHAR2(500);v_TINHTRANG_GQ_TEN VARCHAR2(500);V_TOAAN_TEN VARCHAR2(200);
      V_CAPXX_TEN VARCHAR2(100); V_CAPTAND_TEN VARCHAR2(100); 
      V_SOBICAO NUMBER := 0;
      VV_NOIDUNG CLOB; V_TENTOIDANH CLOB DEFAULT '';
      VV_HOTENBICAN CLOB;
      VV_BCKC CLOB; VV_NOIDUNGKC CLOB; 
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
    ------------------
     FOR item in (
            
            
            SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_TINHTRANG_GIAIQUYET,2,a.NGAYTAO,3,PCTP_GQ.NGAYTAO) DESC) STT,COUNT(*) OVER () as CountAll, a.MaVuAn, a.TenVuAn, a.TT, a.NgayBanCaoTrang
--            ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
--            , a.NguoiTao, 
--            DECODE(GD.MAGIAIDOAN,3,BC3.HoTen,BC2.HoTen) HoTenBiCan, 
--            DECODE(GD.MAGIAIDOAN,3,GN.TruongHopGiaoNhan,AA.TruongHopGiaoNhan)TruongHopGiaoNhan,
--            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm'  , 3, 'Phúc thẩm' , 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec,
--            STBA.BANAN_QD_ST, STKN.KHANGNGHI_ST,
--            ---
--             CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
--                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
--             END  ||
--             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
--                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
--             END
--             ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
--             ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
--             ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--             ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
--             ||GNST.TINHTRANG_GQ
--            TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
--            to_char(PCTP_GQ.NGAYNHANPHANCONG,'dd/MM/yyyy') NGAYPHANCONGTP, to_char(PCTP_GQ.NGAYPHANCONG,'dd/MM/yyyy') NGAYPHANCONGLD,
--            PCTP_GQ.CANBOID THAMPHAN_ID,PCTP_GQ.NGUOIPHANCONGID LANHDAO_ID,PCTP_GQ.THULYID,PCTP_GQ.SOQD,to_char(PCTP_GQ.NGAYQD,'dd/MM/yyyy')NGAYQD,PCTP_GQ.ID THAMPHANGQ_ID
            
            ,GD.MAGIAIDOAN MAGIAIDOAN
            ,decode(GD.MAGIAIDOAN,3,b.Ten,null) TenToaSoTham
            ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY, DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY)NGAYTHULY
            ,PCTP_GQ.HOTEN THAMPHAN_TEN ,a.ID VUAN_ID
            FROM AHS_VUAN A
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
            LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (SELECT TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')NGAYTHULY,TL.VUANID,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHS_SOTHAM_THULY TL 
                       GROUP BY TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy'),TL.VUANID,'</br>- Đã thụ lý')TLS ON A.ID=TLS.VUANID AND GD.MAGIAIDOAN=2
            LEFT JOIN (SELECT TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')NGAYTHULY,TL.VUANID,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHS_PHUCTHAM_THULY TL 
                      GROUP BY TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy'),TL.VUANID,'</br>- Đã thụ lý')TLPT ON A.ID=TLPT.VUANID AND GD.MAGIAIDOAN=3
            LEFT JOIN (SELECT TP.VUANID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHS_THAMPHANGIAIQUYET TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
                       GROUP BY TP.VUANID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.VUANID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (SELECT TP.VUANID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHS_THAMPHANGIAIQUYET TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
                       GROUP BY TP.VUANID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.VUANID=A.ID AND GD.MAGIAIDOAN=3 
             ----lấy 1 bản ghi mới nhất 27/12/2023
            LEFT JOIN (
                     SELECT FIRST_VALUE(TP.ID) OVER (PARTITION BY TP.VUANID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) ID,
                     CB.HOTEN,TP.VUANID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG,
                     TP.NGAYQD,TP.SOQD,TP.THULYID
                     FROM  AHS_THAMPHANGIAIQUYET TP
                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                     LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
                     WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
                     AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
           )PCTP_GQ ON PCTP_GQ.VUANID = A.ID 
            ----            
            LEFT JOIN (
                        SELECT QSV.VUANID,'</br>- Đang hoãn phiên tòa sơ thẩm'TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON QSV.VUANID =BA.VUANID 
                        WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                        GROUP BY QSV.VUANID,'</br>- Đang hoãn phiên tòa sơ thẩm'
            )HPT ON HPT.VUANID=A.ID AND GD.MAGIAIDOAN=2 
            LEFT JOIN (
                        SELECT PTQDVA.VUANID,'</br>- Đang hoãn phiên tòa phúc thẩm'TINHTRANG_GQ FROM   AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        LEFT JOIN AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=PTQDVA.VUANID 
                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        WHERE PTBA.VUANID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                        GROUP BY PTQDVA.VUANID,'</br>- Đang hoãn phiên tòa phúc thẩm'
                        )HPTPT ON  HPTPT.VUANID=A.id  AND GD.MAGIAIDOAN=3
            LEFT JOIN (
                        SELECT QSV.VUANID,'</br>- Đang tạm đình chỉ vụ án' TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID 
                        LEFT JOIN AHS_SOTHAM_BANAN BA ON QSV.VUANID =BA.VUANID 
                        WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                        AND BA.VUANID IS NULL  -- chưa có bản án
                        GROUP BY QSV.VUANID,'</br>- Đang tạm đình chỉ vụ án'
                       )TDC ON  TDC.VUANID=A.id AND GD.MAGIAIDOAN=2
            LEFT JOIN (
                        SELECT PTQDVA.VUANID,'</br>- Đang tạm đình chỉ vụ án' TINHTRANG_GQ FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        INNER JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTQDVA.VUANID --BẢN ÁN 
                        WHERE PTBA.VUANID IS NULL --Vụ án chưa có bản án 
                        AND QDL.MA='TDC' --Tạm đình chỉ
                        GROUP BY PTQDVA.VUANID,'</br>- Đang tạm đình chỉ vụ án'
                       )TDCPT ON  TDCPT.VUANID=A.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                        SELECT BA.VUANID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ FROM AHS_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.VUANID,'</br>- Đã có bản án sơ thẩm'
                        )BAST ON  BAST.VUANID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN ( 
                        SELECT PTBA.VUANID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ FROM AHS_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.VUANID,'</br>- Đã có bản án phúc thẩm'
                       )BAPT ON  BAPT.VUANID=a.id AND GD.MAGIAIDOAN=3
             LEFT JOIN (
                       SELECT QSV.VUANID,'</br>- Đã có QĐ đình chỉ vụ án' TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                       INNER JOIN DM_QD_LOAI QDL ON QSV.LOAIQDID=QDL.ID
                       WHERE instr('DC,',QDL.MA)>0
                       GROUP BY QSV.VUANID,'</br>- Đã có QĐ đình chỉ vụ án'
                       )DCST ON  DCST.VUANID=a.id AND GD.MAGIAIDOAN=2
             LEFT JOIN (
                      SELECT PTQDVA.VUANID,'</br>- Đã có QĐ đình chỉ vụ án' TINHTRANG_GQ FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                      LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=PTQDVA.LOAIQDID 
                      WHERE  instr('DC',QDL.MA)>0
                      GROUP BY PTQDVA.VUANID,'</br>- Đã có QĐ đình chỉ vụ án'
                     )DCPT ON  DCPT.VUANID=a.id AND GD.MAGIAIDOAN=3
                 -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2           
            -------trường hợp giao nhân dùng cho sơ thẩm với viện kiểm sát
            LEFT JOIN (SELECT A1.ID, DECODE(A1.TruongHopGiaoNhan,1, 'VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm',2,'Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung',3, 'Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung',''
                       ) TruongHopGiaoNhan  FROM AHS_VUAN A1) AA ON AA.ID=A.ID
            -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                      )GN ON  GN.VUANID=a.ID
           ------bị cáo lấy cho sơ thẩm
                LEFT JOIN(  SELECT TS.VUANID,'<br /><i>Bị cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_BOLD','<b>'),'_GHACH_NOI',' - '),'_DAUVU',' (đầu vụ)</b>'),';','<br/>')HOTEN FROM (
                                SELECT TT.VUANID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,';',1,DECODE(TT.COUNT_BC,1,1,2,2,3,3,3) )),';')HOTEN 
                                FROM (                     
                                            SELECT COUNT(*)COUNT_BC,BC.VUANID,
                                            listagg (DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||DECODE(c.TenToiDanh,NULL,NULL,'_GHACH_NOI')||c.TenToiDanh), ';' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC)||';' HOTEN
                                            FROM AHS_BICANBICAO BC  
                                            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                                            GROUP BY BC.VUANID
                                      )TT
                            )TS
                 ) BC2 ON BC2.VUANID=A.ID      
             ------bị cáo kháng cáo lấy cho phúc thẩm 
               LEFT JOIN(  SELECT TS.VUANID,'<br /><i>Bị cáo kháng cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_BOLD','<b>'),'_GHACH_NOI',' - '),'_DAUVU',' (đầu vụ)</b>'),';','<br/>')HOTEN FROM (
                                SELECT TT.VUANID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,';',1,DECODE(TT.COUNT_BC,1,1,2,2,3,3,3) )),';')HOTEN 
                                FROM (                     
                                            SELECT COUNT(*)COUNT_BC,BC.VUANID,
                                            listagg (DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh), ';' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC)||';' HOTEN
                                            FROM AHS_BICANBICAO BC  
                                            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                                            INNER JOIN (SELECT NGUOIKCID, LOAIKHANGCAO,VUANID FROM AHS_SOTHAM_KHANGCAO) KC ON KC.NGUOIKCID = BC.ID AND KC.VUANID=BC.VUANID
                                            GROUP BY BC.VUANID
                                      )TT
                            )TS
                 )BC3 ON BC3.VUANID=A.ID
            ------- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.VUANID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHS_SOTHAM_BANAN BA)STBA ON STBA.VUANID=A.ID 
            ------- lấy thông tin số ngày kháng nghị
          LEFT JOIN ( SELECT KN.VUANID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>' ON OVERFLOW TRUNCATE) WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHS_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.VUANID
              )STKN ON STKN.VUANID=A.ID 
            -------
            WHERE (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )
                AND (V_TOIDANH IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TOIDANH)||'%' ) )--tìm tội danh đã được gắn vào tên vụ án
                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
                 AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  '%'||LOWER(V_MA_VU_AN)||'%' ) )
                AND (V_BI_CAN IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE UPPER(BC.HOTEN) LIKE '%'||UPPER(V_BI_CAN)||'%' AND BC.VUANID=A.ID)
                    )                
             AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))
                    OR(v_TINHTRANG_THULY=1 --đã thụ lý
                         AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                                           ) 
                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                               ) 
                             )
                    )
                    OR(v_TINHTRANG_THULY=2 --chưa thụ lý
                     AND ( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
                        )
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)      
                    )
                ) 
              AND (v_SOTHULY IS NULL
                OR(    EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
                    OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
                  )
               )
              AND (V_SO_QD IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
                     )
                 )
              AND (v_ngay_qd IS NULL
                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
                     )
                 )    
            -----------------v_TINHTRANG_GIAIQUYET
            AND ( (v_TINHTRANG_GIAIQUYET IS NULL  AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
                  OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                    AND NOT EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               )
                       AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) 
                    )
                   OR(v_TINHTRANG_GIAIQUYET=3 --Đã phân công Thẩm phán
                    AND  EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
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
           AND (v_thamphan_id is null
                   OR(    EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID AND ((v_Capxx=2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM')OR(v_Capxx=3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ))
                       OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID AND v_Capxx=2) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID AND v_Capxx=3)
                     )
                )
           AND (v_thuky_id is null
                   OR( EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID)
                     )
                )
          -- END v_TINHTRANG_GIAIQUYET
               --là con của chưa giải quyết xong  
               AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
                    AND( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR('DC,CVA',T2.MA)>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR('DC,CVA',T2.MA)>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                    )   
                )--là con của chưa giải quyết xong end     
            )
       LOOP 
            VV_BCKC := '';
            FOR ITEM_S IN (SELECT FF.VUANID, SUBSTR(FF.VUAN_ND,INSTR(FF.VUAN_ND,';')+1, LENGTH(FF.VUAN_ND)) AS NOIDUNGKHANGCAO
                           FROM (SELECT F.VUAN_ND, F.VUANID
                                 FROM (SELECT KC.VUANID,KC.VUANID || ';' || DECODE(KC.NGUOIKCLOAI,0,'Bc k/c: ',1,I.TEN|| ': ') ||T6.TEN ||' '||KC.NOIDUNGKHANGCAO VUAN_ND 
                                       FROM AHS_SOTHAM_KHANGCAO KC
                                           --LEFT JOIN AHS_BICANBICAO BC ON KC.VUANID=BC.VUANID
                                           LEFT JOIN AHS_SOTHAM_KHANGCAO_YEUCAU T5 ON T5.KHANGCAOID=KC.ID
                                           LEFT JOIN DM_DATAITEM T6 ON T6.ID=T5.YEUCAUID
                                           LEFT JOIN AHS_NGUOITHAMGIATOTUNG TT ON KC.NGUOIKCID=TT.ID
                                           LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID=TT.ID
                                           LEFT JOIN DM_DataItem I ON I.ID=TC.TUCACHID) F
                            )FF
                             WHERE FF.VUANID = ITEM.VUAN_ID)
            LOOP
                VV_BCKC := CONCAT(VV_BCKC, ITEM_S.NOIDUNGKHANGCAO || '<br style="mso-data-placement:same-cell;" />');
            END LOOP;
                               
            SELECT DECODE(item.MAGIAIDOAN,3,BC3.HoTen,BC2.HoTen) INTO VV_HOTENBICAN            
            FROM AHS_VUAN A 
                LEFT JOIN(  SELECT TS.VUANID
                ,'<br style="mso-data-placement:same-cell;" /><i>Bị cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_BOLD','<b>'),'_GHACH_NOI',' - '),'_DAUVU',' (đầu vụ)</b>'),';','<br/>') HOTEN 
                                FROM (
                                    SELECT TT.VUANID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,';',1,DECODE(TT.COUNT_BC,1,1,2,2,3,3,3) )),';')HOTEN 
                                    FROM (                     
                                                SELECT COUNT(*)COUNT_BC,BC.VUANID,
                                                --listagg (DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||DECODE(c.TenToiDanh,NULL,NULL,'_GHACH_NOI')||c.TenToiDanh), ';') WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC)||';' HOTEN
                                                RTRIM(XMLAGG(XMLELEMENT(E,DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||DECODE(c.TenToiDanh,NULL,NULL,'_GHACH_NOI')||c.TenToiDanh),';').EXTRACT('//text()') ORDER BY BC.BICANDAUVU DESC).GetClobVal(),';') ||';' HOTEN
                                                FROM AHS_BICANBICAO BC  
                                                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                                                GROUP BY BC.VUANID
                                          )TT
                                )TS
                     ) BC2 ON BC2.VUANID=A.ID
                LEFT JOIN( SELECT  TS.VUANID,LISTAGG (TS.HOTEN, ', ') WITHIN GROUP (ORDER BY TS.HOTEN) HOTEN  FROM AHS_BICANBICAO TS 
                            WHERE TS.BICANDAUVU=1 GROUP BY  TS.VUANID
                     )BC3 ON BC3.VUANID=A.ID
            WHERE A.ID = ITEM.VUAN_ID;
        
            SELECT count('x') INTO V_SOBICAO FROM AHS_BICANBICAO TS WHERE VUANID = ITEM.VUAN_ID;
            
            V_TENTOIDANH := ' ';
            SELECT to_char(count('x')) into V_TENTOIDANH
            FROM AHS_BICANBICAO TS 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON TS.ID = C.BICANID
            WHERE TS.BICANDAUVU=1 AND ROWNUM = 1 AND TS.VUANID = ITEM.VUAN_ID
            ORDER BY TS.ID;

            IF(V_TENTOIDANH NOT LIKE '0') THEN 
                    SELECT TO_CHAR(C.TENTOIDANH) INTO V_TENTOIDANH 
                    FROM AHS_BICANBICAO TS 
                        LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON TS.ID = C.BICANID
                    WHERE TS.BICANDAUVU=1 AND ROWNUM = 1 AND TS.VUANID = ITEM.VUAN_ID
                    ORDER BY TS.ID;
                    
                    --V_TENTOIDANH := TO_CHAR(ITEM.VUAN_ID);
            ELSE V_TENTOIDANH := ' ';
                END IF;
        
            VV_NOIDUNG := VV_BCKC || '<br style="mso-data-placement:same-cell;" />' || VV_HOTENBICAN;
            CountAll_S:=item.CountAll;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                   <tr style="font-size: 12pt;padding:3pt;">
                   <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">Hình sự</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenToaSoTham||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||VV_HOTENBICAN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_SOBICAO||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||VV_NOIDUNG||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||V_TENTOIDANH||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;"></td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
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
                <td colspan="15" style="line-height: 100%; font-size: 14pt;text-align: center;"><b>DANH SÁCH THẨM PHÁN '||v_TINHTRANG_GQ_TEN||' PHÂN CÔNG XÉT XỬ
                    <br />
                    '||V_CAPXX_TEN||' VỤ ÁN HÌNH SỰ
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đầu vụ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số BC</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KC/KN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tội danh</td>
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
                <td style="width: 48px"></td>
                <td style="width: 70px"></td>
                <td style="width: 60px"></td>
                <td style="width: 60px"></td>
                <td style="width: 142px"></td>
                <td style="width: 142px"></td>
                <td style="width: 90px"></td>
                <td style="width: 45px"></td>
                <td style="width: 45px"></td>
                <td style="width: 45px"></td>
                <td style="width: 45px"></td>
                <td style="width: 45px"></td>
                <td style="width: 45px"></td>
            </tr>
        </table>
      ');
       OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;       
END AHS_VUAN_GETALLPAGING_PRINT;

--FUNCTION AHS_VUAN_GETALLPAGING_PRINT_ITEM
--(
--    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
--    v_ten_vu_an in varchar2, 
--    v_toidanh in varchar2, 
--    v_ma_vu_an in varchar2, 
--    v_bi_can in varchar2,
--    v_Capxx in varchar2,
--    v_toaan_id in varchar2, 
--    v_TINHTRANG_THULY in varchar2,
--    V_NGAYTHULY_TU in varchar2,
--    V_NGAYTHULY_DEN in varchar2,
--    v_SOTHULY in varchar2,
--    v_TINHTRANG_GIAIQUYET in varchar2,
--    V_TUNGAY IN VARCHAR2,
--    V_DENNGAY IN VARCHAR2,
--    v_KETQUA in varchar2,
--    v_so_qd in varchar2,
--    v_ngay_qd in varchar2,
--    v_thamphan_id in varchar2, 
--    v_thuky_id in varchar2, 
--    v_THOIHAN_GQ in varchar2, 
--    v_QD_TAMGIAM in varchar2, 
--    Page_Index in	int,
--    Page_Size	in	int
--)RETURN SYS_REFCURSOR
--AS
--      TotalItem number;  MinIndex number; MaxIndex number;
--      VV_TUNGAY DATE;VV_DENNGAY DATE;VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
--      ----------------
--      V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; CountAll_S number:=0;
--      V_TUNGAY_BC VARCHAR2(500); V_DENNGAY_BC VARCHAR2(500);v_TINHTRANG_GQ_TEN VARCHAR2(500);V_TOAAN_TEN VARCHAR2(200);
--      V_CAPXX_TEN VARCHAR2(100); V_CAPTAND_TEN VARCHAR2(100); 
--     V_TABLE_TLST T_QUYETDINH;
--     V_TABLE_TP T_QUYETDINH;
--BEGIN	
--
--     V_TABLE_TLST := T_QUYETDINH();	
--      V_TABLE_TP := T_QUYETDINH();
--     SELECT DECODE(v_Capxx,2,'SƠ THẨM',3,'PHÚC THẨM') INTO V_CAPXX_TEN FROM DUAL;
--     SELECT DECODE(V_CAP_XET_XU_LOGIN,'CAPTINH','TANDT','CAPCAO','TANDCC') INTO V_CAPTAND_TEN FROM DUAL;
--     ------------------
--     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
--     --
--     SELECT REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN','TAND') INTO V_TOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=v_toaan_id;
--     SELECT DECODE(V_TUNGAY,NULL,'..........',V_TUNGAY) INTO V_TUNGAY_BC FROM DUAL;
--     SELECT DECODE(V_DENNGAY,NULL,'..........',V_DENNGAY) INTO V_DENNGAY_BC FROM DUAL;
--      SELECT DECODE(v_TINHTRANG_GIAIQUYET,2,'CHƯA PHÂN CÔNG',3,'ĐƯỢC') INTO v_TINHTRANG_GQ_TEN FROM DUAL;
--    -------------------
--     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
--     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
--     --
--     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
--     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
--    
--    --AHS_SOTHAM_THULY
--        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TLST
--        FROM( SELECT TT.VUANID,TT.ID FROM (  
--                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
--                 FROM  AHS_SOTHAM_THULY 
--                )TT GROUP BY TT.VUANID,TT.ID
--            )TTS;        
--    ------------------
--     FOR item in (
--           SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,THTL.SOTHULY,3,to_number(regexp_replace(THTLPT.SOTHULY, '[^[:digit:]]', '')) ) ) STT,COUNT(*) OVER () as CountAll,
--            --BÁO CÁO MỚI-----------------------------------------------
--             DECODE(GD.MAGIAIDOAN,3,BC3.HoTen,BC2.HoTen) HoTenBiCan, decode(GD.MAGIAIDOAN,3,b.Ten,null) TenToaSoTham
--            ,DECODE(v_Capxx,2,THTL.SOTHULY,3,THTLPT.SOTHULY)SOTHULY,DECODE(v_Capxx,2,THTL.NGAYTHULY,3,THTLPT.NGAYTHULY)NGAYTHULY
--            ,TONG_BC.TONG,BC_KC.BCKC||'<br style="mso-data-placement:same-cell;" />'||STKN.NOIDUNGKN BCKC
--            ,TD.TENTOIDANH
--            ,PCTP_GQ.HOTEN THAMPHAN_TEN
--            ,A.ID
--            FROM AHS_VUAN A
--             INNER JOIN (SELECT G.* FROM AHS_VUAN_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.VUANID
----            INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
--            LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
--            LEFT JOIN (         SELECT TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')NGAYTHULY,TL.VUANID,TL.ID
--                                 FROM AHS_SOTHAM_THULY TL
--                                 WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=TL.ID)
--                      )THTL ON THTL.VUANID=A.ID 
--            LEFT JOIN (           SELECT  TL.SOTHULY,TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')NGAYTHULY,TL.VUANID,TL.ID
--                                  FROM AHS_PHUCTHAM_THULY TL
--                     )THTLPT ON THTLPT.VUANID=A.ID 
--             ----lấy 1 bản ghi mới nhất 27/12/2023
--              LEFT JOIN (
--                     SELECT ROW_NUMBER() OVER (PARTITION BY TP.VUANID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) AS ROWNUMBER,
--                     TP.ID,CB.HOTEN,TP.VUANID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG,
--                     TP.NGAYQD,TP.SOQD,TP.THULYID
--                     FROM  AHS_THAMPHANGIAIQUYET TP
--                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
--                     LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
--                     WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
--                     
--                     AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
--           )PCTP_GQ ON PCTP_GQ.VUANID = A.ID AND  ROWNUMBER = 1
--           
--           ------bị cáo lấy cho sơ thẩm
--            LEFT JOIN(  SELECT TS.VUANID,'<br style="mso-data-placement:same-cell;" /><i>Bị cáo:</i> <br />'||REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN,'_BOLD','<b>'),'_GHACH_NOI',' - '),'_DAUVU',' (đầu vụ)</b>'),';','<br/>')HOTEN FROM (
--                                SELECT TT.VUANID,RTRIM(SUBSTR(TT.HOTEN,0,INSTR(TT.HOTEN,';',1,DECODE(TT.COUNT_BC,1,1,2,2,3,3,3) )),';')HOTEN 
--                                FROM (                     
--                                            SELECT COUNT(*)COUNT_BC,BC.VUANID,
--                                            --listagg (DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||DECODE(c.TenToiDanh,NULL,NULL,'_GHACH_NOI')||c.TenToiDanh), ';') WITHIN GROUP (ORDER BY BC.BICANDAUVU DESC)||';' HOTEN
--                                            RTRIM(XMLAGG(XMLELEMENT(E,DECODE(BC.BICANDAUVU,1,'_BOLD'||BC.HOTEN||'_GHACH_NOI'||c.TenToiDanh||'_DAUVU',0,BC.HOTEN||DECODE(c.TenToiDanh,NULL,NULL,'_GHACH_NOI')||c.TenToiDanh),';').EXTRACT('//text()') ORDER BY BC.BICANDAUVU DESC).GetClobVal(),';') ||';' HOTEN
--                                            FROM AHS_BICANBICAO BC  
--                                            LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
--                                            GROUP BY BC.VUANID
--                                      )TT
--                            )TS
--                 ) BC2 ON BC2.VUANID=A.ID   
--               ------edit 09/07/2021 bị cáo kháng cáo
--               LEFT JOIN(  
--                            SELECT NDBD.VUANID,LISTAGG(NDBD.NOIDUNGKHANGCAO, ', ')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) BCKC
--                               FROM (
--                                        SELECT  TO_NUMBER(SUBSTR(FF.VUAN_ND,0,INSTR(FF.VUAN_ND,';')-1))VUANID,
--                                                SUBSTR(FF.VUAN_ND,INSTR(FF.VUAN_ND,';')+1, LENGTH(FF.VUAN_ND))NOIDUNGKHANGCAO
--                                        FROM (   
--                                                        SELECT F.VUAN_ND FROM (
--                                                             SELECT KC.VUANID||';'||count(*)||' '
--                                                                    ||DECODE(KC.NGUOIKCLOAI,0,'BC',1,I.TEN)||' k/c'
--                                                                     VUAN_ND 
--                                                            FROM AHS_SOTHAM_KHANGCAO KC
--                                                            LEFT JOIN AHS_NGUOITHAMGIATOTUNG TT ON KC.NGUOIKCID=TT.ID
--                                                            LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID=TT.ID
--                                                            LEFT JOIN DM_DataItem I ON I.ID=TC.TUCACHID
--                                                            GROUP BY KC.VUANID,KC.NGUOIKCLOAI,I.TEN
--                                                        )F
--                                                        GROUP BY F.VUAN_ND
--                                        )FF
--                         )NDBD  GROUP BY NDBD.VUANID
--                 )BC_KC ON BC_KC.VUANID=A.ID
--              --edit 09/07/2021 lấy bị 1 bị cáo cáo kháng cáo đầu tiên,nếu bị cáo kháng cáo là null thì lấy bị cáo đầu vụ   
--             LEFT JOIN( 
--                       SELECT MM.VUANID,SUBSTR(MM.HOTEN,0,INSTR(MM.HOTEN,';')-1)HOTEN FROM (
--                             SELECT KK.VUANID,LISTAGG (KK.HOTEN,';') WITHIN GROUP (ORDER BY KK.STT)||';' HOTEN FROM (
--                                  select cc.VUANID,to_char(replace(TS1.hoten,';',''))HOTEN,1 STT from  (                              
--                                       SELECT FF.VUANID,SUBSTR(FF.NGUOIKCID,0,INSTR(FF.NGUOIKCID,';')-1)NGUOIKC_ID ,FF.NGUOIKCID 
--                                        FROM (           
--                                            SELECT KC.VUANID,LISTAGG(KC.NGUOIKCID,';')  WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO)||';'NGUOIKCID
--                                            FROM AHS_SOTHAM_KHANGCAO KC
--                                            WHERE KC.NGUOIKCLOAI=0-- là bị cáo
--                                            AND NOT EXISTS(SELECT 'X' FROM AHS_SOTHAM_RUTKHANGCAO RK WHERE RK.KHANGCAOID=KC.ID
--                                                       AND RK.TINHTRANG=2 AND (RK.CAPRUTKN IS NULL OR RK.CAPRUTKN=2) )--rút kháng cáo
--                                            GROUP BY KC.VUANID
--                                            )FF
--                                    )cc
--                                  LEFT JOIN AHS_BICANBICAO TS1 ON TS1.ID=cc.NGUOIKC_ID AND TS1.VUANID=cc.VUANID  
--                                  union all        
--                                  select dd.VUANID,to_char(dd.HOTEN)HOTEN,2 STT from (
--                                    SELECT TS.VUANID,LISTAGG (replace(TS.HOTEN,';',''), ',') WITHIN GROUP (ORDER BY TS.HOTEN) HOTEN  
--                                    FROM AHS_BICANBICAO TS 
--                                    WHERE TS.BICANDAUVU=1 
--                                    GROUP BY  TS.VUANID
--                                  )dd
--                            )KK GROUP BY KK.VUANID
--                      )MM
--                   )BC3 ON BC3.VUANID=A.ID
--              --------edit 09/07/2021 Tên tội danh----
--               LEFT JOIN( SELECT MM.VUANID,SUBSTR(MM.TENTOIDANH,0,INSTR(MM.TENTOIDANH,';')-1)TENTOIDANH FROM (
--                             SELECT KK.VUANID,LISTAGG (KK.TENTOIDANH,';') WITHIN GROUP (ORDER BY KK.STT DESC)||';' TENTOIDANH FROM (
--                                  select cc.VUANID,to_char(C.TENTOIDANH)TENTOIDANH,1 STT from  (                              
--                                       SELECT FF.VUANID,SUBSTR(FF.NGUOIKCID,0,INSTR(FF.NGUOIKCID,';')-1)NGUOIKC_ID ,FF.NGUOIKCID 
--                                        FROM (           
--                                            SELECT KC.VUANID,LISTAGG(KC.NGUOIKCID,';')  WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO)||';'NGUOIKCID
--                                            FROM AHS_SOTHAM_KHANGCAO KC
--                                            WHERE  KC.NGUOIKCLOAI=0-- là bị cáo
--                                            GROUP BY KC.VUANID
--                                            )FF
--                                    )cc
--                                  LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON cc.NGUOIKC_ID = C.BICANID
--                                  union all        
--                                  select dd.VUANID,SUBSTR(dd.TENTOIDANH,0,INSTR(dd.TENTOIDANH,';')-1)TENTOIDANH,2 STT from (
--                                    SELECT TS.VUANID,LISTAGG (C.TENTOIDANH, ';') WITHIN GROUP (ORDER BY C.TENTOIDANH)||';' TENTOIDANH  
--                                    FROM AHS_BICANBICAO TS 
--                                    LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON TS.ID = C.BICANID
--                                    WHERE TS.BICANDAUVU=1 
--                                    GROUP BY  TS.VUANID
--                                  )dd
--                            )KK GROUP BY KK.VUANID
--                      )MM
--                 )TD ON TD.VUANID=A.ID
--              ----------
--           LEFT JOIN(  
--              SELECT count(*) TONG,TS.VUANID  FROM AHS_BICANBICAO TS 
--              GROUP BY TS.VUANID
--                 )TONG_BC  ON TONG_BC.VUANID=A.ID    
--            ------- lấy thông tin kháng nghị
--             LEFT JOIN (
--           SELECT NDKN.VUANID,LISTAGG(NDKN.NOIDUNGKN, ', ')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
--                            FROM (
--                                    SELECT KC.VUANID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n'
--                                     NOIDUNGKN
--                                    FROM AHS_SOTHAM_KHANGNGHI KC
--                                    LEFT JOIN AHS_SOTHAM_KHANGCAO_YEUCAU T5 ON T5.KHANGCAOID=KC.ID
--                                    where  NOT EXISTS(SELECT 'X' FROM AHS_SOTHAM_RUTKHANGNGHI RK WHERE RK.KHANGNGHIID=KC.ID
--                                                       AND RK.TINHTRANG=2 AND (RK.CAPRUTKN IS NULL OR RK.CAPRUTKN=2) )--rút kháng nghị
--                             )NDKN  GROUP BY NDKN.VUANID
--               )STKN ON STKN.VUANID=A.ID
--            -------
--            WHERE (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )
--                AND (V_TOIDANH IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TOIDANH)||'%' ) )--tìm tội danh đã được gắn vào tên vụ án
--                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
--                AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
--                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
--                    )
--                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  '%'||LOWER(V_MA_VU_AN)||'%' ) )
--                AND (V_BI_CAN IS NULL
--                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE UPPER(BC.HOTEN) LIKE '%'||UPPER(V_BI_CAN)||'%' AND BC.VUANID=A.ID)
--                    )                
--              -----
--                AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))
--                    OR(v_TINHTRANG_THULY=1 --đã thụ lý
--                         AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
--                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
--                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
--                                           ) 
--                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
--                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
--                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
--                               ) 
--                             )
--                    )
--                    OR(v_TINHTRANG_THULY=2 --chưa thụ lý
--                     AND ( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
--                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
--                        )
--                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
--                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)      
--                    )
--                ) 
--              -----
--              AND (v_SOTHULY IS NULL
--                OR(    EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
--                    OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id AND upper(TL.SOTHULY)=upper(v_SOTHULY))
--                  )
--               )
--              AND (V_SO_QD IS NULL
--                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.VUANID  )
--                     )
--                 )
--              AND (v_ngay_qd IS NULL
--                 OR  (    EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
--                       OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(v_ngay_qd,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )
--                     )
--                 )    
--            -----------------v_TINHTRANG_GIAIQUYET
--            AND ( (v_TINHTRANG_GIAIQUYET IS NULL  AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
--                  OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
--                    AND NOT EXISTS (
--                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
--                                WHERE PC.VUANID=A.ID
--                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
--                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
--                                     )
--                               )
--                       AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) 
--                    )
--                   OR(v_TINHTRANG_GIAIQUYET=3 --Đã phân công Thẩm phán
--                    AND  EXISTS (
--                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
--                                WHERE PC.VUANID=A.ID
--                                AND (
--                                     (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
--                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
--                                     )
--                                AND (V_TUNGAY IS NULL OR  PCTP_GQ.NGAYNHANPHANCONG>=VV_TUNGAY)
--                                AND (V_DENNGAY IS NULL OR PCTP_GQ.NGAYNHANPHANCONG<=VV_DENNGAY)  
--                               )
--                    )  
--              )    
--              -- END v_TINHTRANG_GIAIQUYET
--           AND (v_thamphan_id is null
--                   OR(    EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
--                       OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID) 
--                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
--                     )
--                )
--           AND (v_thuky_id is null
--                   OR( EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID) 
--                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID)
--                     )
--                )
--          -- END v_TINHTRANG_GIAIQUYET
--               --là con của chưa giải quyết xong  
--               AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
--               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
--                    AND( EXISTS (
--                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
--                                 WHERE
--                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
--                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
--                                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                                                WHERE INSTR(',DC,CVA,',','||QDL.MA||',')>0 AND TL.VUANID =T1.VUANID )
--                                  )
--                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                        OR  EXISTS (
--                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
--                                WHERE 
--                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
--                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
--                                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
--                                                WHERE INSTR(',DC,CVA,',','||QDL.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
--                                  )
--                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
--                                )
--                       )
--                    )   
--                )--là con của chưa giải quyết xong end     
--            )
--       LOOP 
--        CountAll_S:=item.CountAll;
--           DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
--               <tr style="font-size: 12pt;padding:3pt;">
--               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenToaSoTham||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.HoTenBiCan||'</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TONG||'</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BCKC||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOIDANH||'</td>
--                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
--            </tr>
--                ');
--       END LOOP;
--      DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--          <table cellpadding="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
--            <tr>
--                <td colspan="9" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH ÁN HÌNH SỰ THỤ LÝ MỚI</b>
--                </td>
--            </tr>
--            <tr>
--                <td colspan="9" style="height: 15pt; text-align: left;"><b>Tổng số: '||CountAll_S||' bản ghi</b></td>
--            </tr>
--            <tr style="font-weight: bold;">
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">Stt</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số TL</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày TL</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tỉnh / TP</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đầu vụ</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số BC</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KC/KN</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tội danh</td>
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
--            </tr>
--                 '); 
--       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
--       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
--       --------------------------------
--       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--          <tr style="height: 1px;">
--               <td style="width: 43px"></td>
--                <td style="width: 72px"></td>
--                <td style="width: 83px"></td>
--                <td style="width: 135px"></td>
--                <td style="width: 100px"></td>
--                <td style="width: 60px"></td>
--                <td style="width: 142px"></td>
--                <td style="width: 176px"></td>
--                <td style="width: 90px"></td>
--            </tr>
--        </table>
--      ');
--       OPEN V_CURSOR FOR
--        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
--        dbms_lob.freetemporary(V_EXPORT_TEXT);
--        RETURN V_CURSOR;       
--END AHS_VUAN_GETALLPAGING_PRINT_ITEM;



END PKG_PCTP_HS;

/
