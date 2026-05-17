--------------------------------------------------------
--  DDL for Package Body PKG_AHN_STPT_DS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_AHN_STPT_DS" AS

PROCEDURE AHN_DON_SEARCH
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
	V_VAITRO_THAMPHAN IN VARCHAR2, --toancau-04112023
	 V_CHECK_HOAGIAI IN NUMBER,--toancau-04112023
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

--THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM AHN_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  AHN_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  AHN_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));    
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
                       WHERE EXISTS(SELECT 'X' FROM AHN_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID and kc.loaikhangcao !=2 AND KC.DONID=DS.DONID)
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
      ,i.TEN as QUANHEPL,DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 
        DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','')GIAIDOANVUVIEC,
--      GN.TRUONGHOPGIAONHAN,
        A.HINHTHUCNHANDON,
        DECODE(A.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    '<br/><i>TH giao nhận:</i> <b>'|| GN.TruongHopGiaoNhan||'</b>') TRUONGHOPGIAONHAN,
        STBA.BANAN_QD_ST,'' as QD_PT,STKN.KHANGNGHI_ST, PKG_STPT_AHN_GS.NOIDUNG_KHANGCAO_DANHSACH(a.ID) as KHANGCAO_ST,--toancau 18092023-anhnt thêm trường QD_PT mặc định trống
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
                    from AHN_DON D
                    left join AHN_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHN_DON D
                    left join AHN_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )

        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI,
        A.QHPLTKID,A.TOAANID
      FROM AHN_DON A
      INNER JOIN (SELECT G.* FROM AHN_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      -- lấy thông tin vụ án end     
      LEFT JOIN (SELECT PTBA.* FROM AHN_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AHN_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách
        LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.AHN_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

        LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.AHN_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
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
--                        FROM AHN_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM AHN_DON_THAMPHAN GG
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
                                         AHN_CHUYEN_NHAN_AN CA
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
                                         AHN_CHUYEN_NHAN_AN CN1
                                    JOIN AHN_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = v_toaan_id
                                    AND CN2.ID > CNA.ID
                            )

--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--toancau-anhnt-sửa check đã chuyển lại án sơ thẩm
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID

            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM FROM DM_DATAITEM i 
                     INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                     and not exists (select 'x' from AHN_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)
                     group by CA.VUANID,i.TEN, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHN_SOTHAM_KHANGNGHI KN
                      where KN.TINHTRANG_GIAIQUYET != 3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 

----LẤY THÔNG TIN KHÁNG CÁO --toancau 18092023-bỏ
--   LEFT JOIN ( SELECT KC.DONID,
--                     '<br /><i>Kháng cáo:</i> <br />'|| 
--                      listagg (' ngày '||TO_CHAR(KC.NGAYKHANGCAO,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO) KHANGCAO_ST
--                      FROM  AHN_SOTHAM_KHANGCAO KC
--                      GROUP BY KC.DONID
--              )STKC ON STKC.DONID=A.ID 
        ---------------------                
        WHERE   
        a.magiaidoan != 7 and --toancau 31-03-2023 bỏ án pt tđc
        (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM AHN_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM AHN_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHN_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    ) ) 
             AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
             AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
           -----   
           --toancau - quyet (
            AND ( (v_TINHTRANG_THULY IS NULL 
                    AND (
                            (GD.MAGIAIDOAN = 2
                            AND (V_NGAYTHULY_TU IS NULL OR  A.NGAYNHANDON >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR A.NGAYNHANDON <=VV_NGAYTHULY_DEN)
                        )
                        OR EXISTS ( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA
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
                                                SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND PC.NGAYPHANCONG >= VV_NGAYTHULY_TU
                                                AND A.ID = PC.DONID
                                                )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU

                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM ADS_DON D
                                                LEFT JOIN AHN_DON_THAMPHAN PC ON PC.DONID = D.ID
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
                                        SELECT 'X' FROM AHN_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                )
--                                AND ( V_NGAYTHULY_TU IS NULL 
--                                        OR EXISTS(
--                                            SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA
--                                            WHERE CNA.NGAYNHAN >= VV_NGAYTHULY_TU
--                                ))
                                AND (TLPT.NGAYTHULY>VV_NGAYTHULY_DEN
--                                        OR EXISTS (
--                                            SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA
--                                            WHERE  VV_NGAYTHULY_DEN>=CNA.NGAYNHAN
--                                                
--                                        )
                                    )
                                )
                            OR (
                                TLPT.DONID IS NULL
                                AND GD.MAGIAIDOAN=3
                                AND EXISTS(
                                        SELECT 'X' FROM AHN_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                )
                                AND ( V_NGAYTHULY_TU IS NULL 
                                    OR EXISTS( 
                                            SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA
                                            WHERE GD.MAGIAIDOAN = 3
                                            AND CNA.NGAYNHAN >=VV_NGAYTHULY_TU 
                                    )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU
                                    OR EXISTS(
                                                SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM AHN_DON D
                                                LEFT JOIN ADS_DON_THAMPHAN PC ON PC.DONID = D.ID
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
            --OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
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
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )   
          AND (v_thuky_id is null--Thư ký
                   OR( EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id ) 

                     )

                )

                AND(vchecktk=0 or (select count(*) from AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
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
                 OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
             --toancau - quyet (
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,18,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',03,04,06,12,13,14,15,21,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )--toancau - quyet )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
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
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                        LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                OR EXISTS ( SELECT 'X' FROM AHN_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        ))
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    ( ( (
                        EXISTS (
                                SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
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
                                SELECT 'X' FROM AHN_SOTHAM_THULY STTL
                                WHERE
                                STTL.DONID =  A.ID 
                                AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                                AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                                )-- =2)
                                --=3
                                OR EXISTS( 
                                    SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2--sơ thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                )--=3)
                                 --(=4 
                                OR EXISTS(
                                SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV --SO THAM
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                                WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                                    )--=4)
                                     --(=5
                                OR EXISTS ( -- hoãn sơ thẩm
                                SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                    WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                    WHERE
                                    PTTL.DONID = A.ID

                                    AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                                    AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                                        )--2
                                --=3 
                                OR EXISTS( 
                                    SELECT 'x' FROM AHN_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3--phuc thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                        )--=3)
                                        --(=4 
                                OR EXISTS(
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA -- PHUC THAM
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN AHN_PHUCTHAM_BANAN BA ON PTQDVA.DONID = BA.DONID
                                    WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=A.ID )--=4)
                                --(=5 
                                OR EXISTS ( --Đang hoãn phuc tham
                                    SELECT  'X' FROM   AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA='TDC' --Tạm đình chỉ
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )--=6)
                                )  
                            ) )
                )-- toan cau --quyet)
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND ( EXISTS ( 
                        SELECT 'X' FROM AHN_SOTHAM_THULY STTL
                        WHERE
                        STTL.DONID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                    OR EXISTS(
                        SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.DONID = A.ID

                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                    )
                   AND ( 
                                NOT EXISTS (
                                    SELECT 'x' FROM AHN_DON_THAMPHAN PC 
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
                            SELECT 'x' FROM AHN_DON_THAMPHAN PC 
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
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
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
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHNGD = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHNGD = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AHN_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
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
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
END AHN_DON_SEARCH;

PROCEDURE AHN_DON_CON_SEARCH
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
    Page_Index in	int,
    Page_Size	in	int, 
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
               || --hieu thêm thông tin giải quyết của vụ án cha
             CASE WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN is null) THEN 
             (SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHN_DON D
                    left join AHN_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AHN_DON D
                    left join AHN_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )
            TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
            DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI
      FROM AHN_DON A
      INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      ----- BA Or QD----------------------------------------------
      LEFT JOIN (SELECT PTBA.* FROM AHN_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
         --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AHN_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
        LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHN_SOTHAM_KHANGNGHI KN
                      where KN.TINHTRANG_GIAIQUYET != 3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 
        ---------------------                
        WHERE   (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM AHN_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM AHN_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AHN_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    ) ) 
             AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
             AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
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
            OR( EXISTS(SELECT 'x' FROM AHN_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AHN_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AHN_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AHN_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                        OR EXISTS(SELECT 'X' FROM AHN_DON_THAMPHAN TP WHERE  TP.THUKYID=v_thuky_id and TP.DONID=A.ID)

                     )
                )
                AND(vchecktk=0 or (select count(*) from AHN_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
                 --hieu check theo trạng thái vụ án hôn nhân        
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
                 OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',04,06,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHN_PHUCTHAM_BANAN PB 
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
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                        LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                    LEFT JOIN AHN_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_THULY TL 
                                    LEFT JOIN AHN_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AHN_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN BA
                              LEFT JOIN AHN_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                                SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                            SELECT 'x' FROM AHN_DON_THAMPHAN PC 
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
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHN_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AHN_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AHN_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHNGD = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHNGD = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AHN_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA 
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
                                SELECT 'X' FROM AHN_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
END AHN_DON_CON_SEARCH;

END PKG_AHN_STPT_DS;
