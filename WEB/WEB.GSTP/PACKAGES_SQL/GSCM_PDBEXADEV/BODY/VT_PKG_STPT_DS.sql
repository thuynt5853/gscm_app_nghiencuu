--------------------------------------------------------
--  DDL for Package Body VT_PKG_STPT_DS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."VT_PKG_STPT_DS" AS

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
		--THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM ADS_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  ADS_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  ADS_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
		--THAMPHAN --TOANCAU-03102023-ANHNT
    --THAMPHAN tham phan chu toa ST
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  ADS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;  
       --THAMPHAN tham phan chu toa PT
--        SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  ADS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
       ---THAMPHAN giai quyet
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  ADS_DON_THAMPHAN 
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;       
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
        STBA.BANAN_QD_ST,'' as QD_PT,STKN.KHANGNGHI_ST, PKG_STPT_ADS_GS.NOIDUNG_KHANGCAO_DANHSACH(a.ID) as KHANGCAO_ST, --toancau-anhnt thêm trường QD_PT,KHANGCAO_ST mặc định trống
        A.MAGIAIDOAN,(BC3.HoTen||BC2.HoTen)HOTENBICAN ,
        DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
             END  ||
             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
             END
               ||QDST.TINHTRANG_GQ
               ||QDPT.TINHTRANG_GQ
--               ||HPT.TINHTRANG_GQ
--               ||HPTPT.TINHTRANG_GQ
--               ||TDC.TINHTRANG_GQ
--               ||TDCPT.TINHTRANG_GQ
               ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
--               ||DCST.TINHTRANG_GQ
--               ||DCPT.TINHTRANG_GQ
--               ||CNTT.TINHTRANG_GQ
--               ||CST.TINHTRANG_GQ
--               ||CPT.TINHTRANG_GQ
               ||GNST.TINHTRANG_GQ
               || --lanh thêm thông tin giải quyết của vụ án cha
             CASE WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN is null) THEN 
             (SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from ADS_DON D
                    left join ADS_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from ADS_DON D
                    left join ADS_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )

        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI,
        A.QHPLTKID,A.TOAANID,TLS.SOTHULY, TLS.NGAYTHULY
      FROM ADS_DON A
      --INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
      
      INNER JOIN (SELECT G.* FROM ADS_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.DONID
      
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      -- lấy thông tin vụ án end     
      LEFT JOIN (SELECT PTBA.* FROM ADS_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM ADS_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách
        LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.ADS_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

        LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.ADS_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (--TOANCAU-03102023-ANHNT
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
					SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 2
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 2 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

        LEFT JOIN (--TOANCAU-03102023-ANHNT
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
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 3
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 3 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETPHUCTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>'
            )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

--        LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ADS_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )HPT ON HPT.DONID=A.ID AND GD.MAGIAIDOAN=2 




--         LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- '||FN_GS_GET_STR_LOAIQD(QDL.MA)||' số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ADS_SOTHAM_QUYETDINH QSV
--                        LEFT JOIN (SELECT * FROM TABLE(V_TABLE_ST))QDL ON QDL.ID=QSV.ID
--                        WHERE QDL.MA IN ('HPT','TDC','DC','CNTT','CVA')
--                        GROUP BY QSV.DONID,'</br>- '||FN_GS_GET_STR_LOAIQD(QDL.MA)||' số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--            )QDST ON QDST.DONID=A.ID AND GD.MAGIAIDOAN=2 
--         LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- '||FN_GS_GET_STR_LOAIQD(QDL.MA)||' số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        LEFT JOIN (SELECT * FROM TABLE(V_TABLE_PT))QDL ON QDL.ID=PTQDVA.ID
--                        WHERE QDL.MA IN ('HPT','TDC','DC','CNTT','CVA')
--                        GROUP BY PTQDVA.DONID,'</br>- '||FN_GS_GET_STR_LOAIQD(QDL.MA)||' số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )QDPT ON  QDPT.DONID=A.id  AND GD.MAGIAIDOAN=3

         LEFT JOIN (--TOANCAU-ANHNT-09112023
					SELECT PQD.DONID,
					'</br>'||LISTAGG( '- '||FN_GS_GET_STR_LOAIQD(QDL.MA)||' số: '|| PQD.SOQD ||' ngày '||to_char(PQD.NGAYQD,'dd/MM/yyyy'),'</br>')WITHIN GROUP (ORDER BY PQD.NGAYQD)TINHTRANG_GQ
					FROM  ADS_SOTHAM_QUYETDINH PQD
						LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
						LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
					WHERE QDL.MA IN ('HPT','TDC','DC','CNTT','CVA')
					GROUP BY PQD.DONID
            )QDST ON QDST.DONID=A.ID AND GD.MAGIAIDOAN=2 
         LEFT JOIN (--TOANCAU-ANHNT-09112023
					SELECT PQD.DONID,
					'</br>'||LISTAGG( '- '||FN_GS_GET_STR_LOAIQD(QDL.MA)||' số: '|| PQD.SOQD ||' ngày '||to_char(PQD.NGAYQD,'dd/MM/yyyy'),'</br>')WITHIN GROUP (ORDER BY PQD.NGAYQD)TINHTRANG_GQ
					FROM  ADS_PHUCTHAM_QUYETDINH PQD
						LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
						LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
					WHERE QDL.MA IN ('HPT','TDC','DC','CNTT','CVA')
					GROUP BY PQD.DONID
                        )QDPT ON  QDPT.DONID=A.id  AND GD.MAGIAIDOAN=3


--        LEFT JOIN (
--                        SELECT PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                        FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
--                        GROUP BY PTQDVA.DONID,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                        )HPTPT ON  HPTPT.DONID=A.id  AND GD.MAGIAIDOAN=3

--        LEFT JOIN (
--                    SELECT QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM ADS_SOTHAM_QUYETDINH QSV
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TDC,',','||QDL.MA||',')>0 ) 
--                    GROUP BY QSV.DONID,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                   )TDC ON  TDC.DONID=A.id AND GD.MAGIAIDOAN=2   

--        LEFT JOIN ( SELECT PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
--                    FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
--                    WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',TDC,',','||QDL.MA||',')>0)
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                   )TDCPT ON  TDCPT.DONID=A.id AND GD.MAGIAIDOAN=3  

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

--        LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       TINHTRANG_GQ FROM ADS_SOTHAM_QUYETDINH QSV 
--                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
--                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )DCST ON  DCST.DONID=a.id AND GD.MAGIAIDOAN=2

--        LEFT JOIN (
--                      SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                      FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
--                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
--                      GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                     )DCPT ON  DCPT.DONID=a.id AND GD.MAGIAIDOAN=3      

--        LEFT JOIN (
--                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                        FROM ADS_SOTHAM_QUYETDINH QSV
--                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
--                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                       )CNTT ON  CNTT.DONID=a.id AND GD.MAGIAIDOAN=2

--             LEFT JOIN (
--                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
--                       FROM ADS_SOTHAM_QUYETDINH QSV 
--                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
--                     )CST ON  CST.DONID=a.id AND GD.MAGIAIDOAN=2   

--             LEFT JOIN (
--                    SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
--                    FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
--                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
--                    GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
--                    )CPT ON  CPT.DONID=a.id AND GD.MAGIAIDOAN=3    

             -------trường hợp giao nhận add vào cột trạng thái          
             LEFT JOIN (
             --toancau-anhnt-sửa check đã chuyển lại án sơ thẩm
                        SELECT
                            CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
                        FROM
                            ( SELECT CA.ID, CA.VUANID, CA.TOACHUYENID, '</br>- ' || I.TEN || '</br>- Đã chuyển vụ án' TINHTRANG_GQ, ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN
                                FROM ADS_CHUYEN_NHAN_AN CA INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                WHERE CA.TOACHUYENID = v_toaan_id ) CNA
                        WHERE
                                CNA.RN = 1
                            AND NOT EXISTS ( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CN1
                                    JOIN ADS_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE CN1.VUANID = CNA.VUANID AND CN2.TOANHANID = v_toaan_id AND CN2.ID > CNA.ID )
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--toancau-anhnt-sửa check đã chuyển lại án sơ thẩm
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID

--            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
--                     INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
--                      )GN ON  GN.VUANID=a.ID
           LEFT JOIN (SELECT CA.VUANID,i.TEN TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  and not exists (select 'x' from ads_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)--toancau
                  GROUP BY CA.VUANID,i.TEN
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  ADS_SOTHAM_KHANGNGHI KN
                      where kn.tinhtrang_giaiquyet != 3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 
------ - TOANCAU 18092023 bỏ
--        LEFT JOIN ( SELECT
--                        DSKC.DONID, '<br /><i>Kháng cáo: </i> <br />' || LISTAGG( DSKC.TENDUONGSU ||DSKC.NGAYKHANGCAO, '<br/>') WITHIN GROUP( ORDER BY DSKC.TENDUONGSU ) KHANGCAO_ST
--                    FROM
--                        ( SELECT
--                                DS.DONID, DS.TENDUONGSU || '-' || I.TEN TENDUONGSU, LISTAGG(' - Ngày kháng cáo: ' || TO_CHAR(KC.NGAYKHANGCAO, 'dd/MM/yyyy'), '<br/>') WITHIN GROUP( ORDER BY DS.TENDUONGSU || '-' || I.TEN ) NGAYKHANGCAO
--                            FROM ADS_SOTHAM_KHANGCAO   KC
--                                INNER JOIN ADS_DON_DUONGSU       DS ON KC.DUONGSUID = DS.ID
--                                LEFT JOIN DM_DATAITEM           I ON I.MA = DS.TUCACHTOTUNG_MA
--                            group by DS.DONID, DS.TENDUONGSU || '-' || I.TEN ) DSKC
--                    GROUP BY
--                        DSKC.DONID
--                  ) STKC ON STKC.DONID = A.ID
        ---------------------                
        WHERE  
        a.magiaidoan != 7 and --toancau bỏ án pt tđc
        (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM ADS_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM ADS_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM ADS_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    ) ) 
             AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
             AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
             
            
           -----  
           --Tình trạng thụ lý
           --toancau - quyet (
            AND ( (v_TINHTRANG_THULY IS NULL 
                    AND(  (GD.MAGIAIDOAN = 2 AND (V_NGAYTHULY_TU IS NULL OR  A.NGAYNHANDON >=VV_NGAYTHULY_TU)  AND (V_NGAYTHULY_DEN IS NULL OR A.NGAYNHANDON <=VV_NGAYTHULY_DEN) )
                        OR EXISTS ( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA WHERE GD.MAGIAIDOAN = 3 AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN) ) ) )--Tình trạng thụ lý
                  OR(v_TINHTRANG_THULY=1 
                       AND ( (TLS.DONID IS NOT NULL  AND (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) )
                           OR (TLPT.DONID IS NOT NULL AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) ) ) 
                    )
                  OR(v_TINHTRANG_THULY=2 
                    AND ( ( TLS.DONID IS NOT NULL AND GD.MAGIAIDOAN=2 AND ( TLS.NGAYTHULY>VV_NGAYTHULY_DEN) )
                            OR (
                                TLS.DONID IS NULL AND GD.MAGIAIDOAN = 2
                                AND ( V_NGAYTHULY_TU IS NULL OR A.NGAYNHANDON >= VV_NGAYTHULY_TU
                                    OR EXISTS( SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON' AND PC.NGAYPHANCONG >= VV_NGAYTHULY_TU AND A.ID = PC.DONID )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU )
                                AND ( V_NGAYTHULY_DEN IS NULL OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS( SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON' AND XLD.NGAYGQ_YC IS NULL AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN AND A.ID = PC.DONID )
                                        OR (NOT EXISTS( SELECT 'x' FROM ADS_DON D LEFT JOIN ADS_DON_THAMPHAN PC ON PC.DONID = D.ID WHERE PC.NGAYPHANCONG IS NULL ) OR A.NGAYNHANDON <= VV_NGAYTHULY_DEN ) ) )
                                ---- CHƯA THỤ LÝ PHÚC THẨM
                            OR( TLPT.DONID IS NOT NULL AND GD.MAGIAIDOAN=3
                                AND EXISTS( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA WHERE CNA.TRANGTHAI = 1 ) ------- 1ĐÃ NHẬN ÁN
                                AND (VV_NGAYTHULY_DEN < TLPT.NGAYTHULY )
                                AND EXISTS ( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA WHERE CNA.VUANID = A.ID AND CNA.NGAYNHAN <= VV_NGAYTHULY_DEN ) )
                            OR ( TLPT.DONID IS NULL AND GD.MAGIAIDOAN=3
                                AND EXISTS( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA WHERE CNA.TRANGTHAI = 1 )-- 1/ĐÃ NHẬN ÁN 
                                AND ( V_NGAYTHULY_TU IS NULL 
                                    OR EXISTS( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA WHERE GD.MAGIAIDOAN = 3 AND CNA.NGAYNHAN >=VV_NGAYTHULY_TU AND CNA.VUANID = A.ID ) )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR EXISTS( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA WHERE CNA.NGAYNHAN <= VV_NGAYTHULY_DEN AND CNA.VUANID = A.ID ) )
                                ))))--toancau - quyet
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
         AND (V_THAMPHAN_ID IS NULL
           -- OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
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
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )   
          AND (v_thuky_id is null--Thư ký
                   OR( EXISTS(select 'X' from ADS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from ADS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id ) 

                     )

                )

                AND(vchecktk=0 or (select count(*) from ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
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
           AND (V_LOAIDON IS NULL  
           --OR( A.LOAIDON=V_LOAIDON) 
           --6/7 toancau quyet
           --Đơn mới
           OR(V_LOAIDON = 1
           AND (EXISTS(
                        SELECT 'X' FROM ADS_DON_XULY DXL
                        WHERE DXL.DONID = A.ID
                        AND DXL.LOAIGIAIQUYET = 5 -- Thụ lý vụ việc
           )))
           --Đơn từ tòa khác chuyển đến
           OR(V_LOAIDON = 2 AND A.LOAIDON=2)
--            OR(V_LOAIDON = 2
--           AND (EXISTS(
--                        SELECT 'X' FROM ADS_DON_XULY DXL
--                        WHERE DXL.DONID = A.ID A.LOAIDON=2
--                        AND DXL.LOAIGIAIQUYET = 1  --Chuyển đơn trong Hệ thống Tòa án
--           )))
           --Đơn trùng
           OR(V_LOAIDON = 3
           AND (EXISTS(
                        SELECT 'X' FROM ADS_DON_XULY DXL
                        WHERE DXL.DONID = A.ID
                        and DXL.LOAIGIAIQUYET = 6 --Đơn trùng
           )))
           --Đơn không thuộc thẩm quyền
           OR(V_LOAIDON = 4
           AND (EXISTS(
                        SELECT 'X' FROM ADS_DON_XULY DXL
                        WHERE DXL.DONID = A.ID
                        and DXL.LOAIGIAIQUYET = 3 --Trả lại đơn
           )))
           
           
           )   
           --6/7 toancau quyet
           --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
             --toancau - quyet (
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
					AND EXISTS( SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID WHERE KQPT.MA IN('01','18') AND PB.DONID=a.id AND GD.MAGIAIDOAN=3 ) )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
					   AND EXISTS( SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID WHERE KQPT.MA IN ('03','04','06','12','13','14','15','21') AND PB.DONID=a.id AND GD.MAGIAIDOAN=3 ) )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
						AND EXISTS( SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID WHERE KQPT.MA='02' AND PB.DONID=a.id AND GD.MAGIAIDOAN=3 ) )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS( SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID  WHERE KQPT.MA = '05' AND PB.DONID=a.id AND GD.MAGIAIDOAN=3 ) ) )   
            --toancau - quyet )
        --Thời hạn GQ;v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
        --/////////////đối với sơ thẩm          
       AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                        LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                AND( GD.MAGIAIDOAN = 2
                    AND (V_TUNGAY IS NULL OR A.NGAYNHANDON>=VV_TUNGAY) 
                    AND (V_DENNGAY IS NULL OR A.NGAYNHANDON<=VV_DENNGAY)
                    )
                OR EXISTS ( SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        )
                 
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    (     (
                        EXISTS (
                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 
                                                   AND TL.DONID=T1.DONID
                                                   ) )
                                        )
                                 AND TL.NGAYTHULY IS NOT NULL
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                            AND(
                                -- (=2
                                 EXISTS (
                                SELECT 'X' FROM ADS_SOTHAM_THULY STTL
                                WHERE
                                STTL.DONID =  A.ID 
                                AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                                AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                                )-- =2)
                                --=3
                                OR EXISTS( 
                                    SELECT 'x' FROM ADS_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2--sơ thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                )--=3)
                                 --(=4 
                                OR EXISTS(
                                SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV --SO THAM
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                                WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                                    )--=4)
                                     --(=5
                                OR EXISTS ( -- hoãn sơ thẩm
                                SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                    WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                    WHERE
                                    PTTL.DONID = A.ID
                        
                                    AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                                    AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                                        )--2
                                --=3 
                                OR EXISTS( 
                                    SELECT 'x' FROM ADS_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3--phuc thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                        )--=3)
                                        --(=4 
                                OR EXISTS(
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA -- PHUC THAM
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN ADS_PHUCTHAM_BANAN BA ON PTQDVA.DONID = BA.DONID
                                    WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=A.ID )--=4)
                                --(=5 
                                OR EXISTS ( --Đang hoãn phuc tham
                                    SELECT  'X' FROM   ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA='TDC' --Tạm đình chỉ
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )--=6)
                                )  
                            ) 
                    -- toan cau --quyet)
                
                ) --toancau - quyet (
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
----                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
----                   AND (V_TUNGAY IS NULL OR  TLPT.NGAYTHULY>=VV_TUNGAY) 
----                   AND (V_DENNGAY IS NULL OR TLPT.NGAYTHULY<=VV_DENNGAY)
----                  12/7 toancau quyet (
                AND ( EXISTS ( 
                        SELECT 'X' FROM ADS_SOTHAM_THULY STTL
                        WHERE
                        STTL.DONID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                    OR EXISTS(
                        SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.DONID = A.ID
                        
                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                    )
                   AND ( 
                                NOT EXISTS (
----                                SELECT'x' FROM ADS_DON_THAMPHAN PC
----                                WHERE PC.DONID = A.ID
----                                    AND ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
----                                    AND GD.MAGIAIDOAN = 7 ))
----                                    AND ( V_TUNGAY IS NULL OR PC.NGAYPHANCONG >= VV_TUNGAY )
----                                    AND ( V_DENNGAY IS NULL
----                                                    OR PC.NGAYPHANCONG <= VV_DENNGAY )
                                    SELECT 'x' FROM ADS_DON_THAMPHAN PC 
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
                            SELECT 'x' FROM ADS_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
                      
               )
               --                  12/7 toancau quyet )
--toancau - quyet (
               OR(v_TINHTRANG_GIAIQUYET = 4 --đã lên lịch xét xử
               
                    AND (
                        EXISTS (
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID 
                        )
                        
                    )
                
               
               )-- quyet  *\
               OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                     EXISTS ( -- hoãn sơ thẩm
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE ( QDL.MA ='HPT' 
                                    or instr(',16-VDS,17-VDS,24-VDS,',','||QD.MA||',')>0
                                  )
                            AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                            --and qd.id = qsv.quyetdinhid
                             )    
                        OR EXISTS ( --Đang hoãn phuc tham
                            SELECT  'X' FROM   ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE( QDL.MA= 'HPT'
                            or instr(',24-VDS,',','||QD.MA||',')>0
                                  )
                            AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.DONID=A.ID 
                            AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    --LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    WHERE QD.KET_THUC = 1 AND QD.ISDANSU = 1 AND QD.ISSOTHAM = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    --LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    --WHERE  instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISDANSU = 1 AND QD.ISPHUCTHAM = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    ) 
                            --toancau quyet - thêm điểu kiện lọc tìm kiếm 
                            OR EXISTS (
                                        select 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                        WHERE (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                    AND QD.KET_THUC =1
                                    )
                            OR EXISTS (
                                        select 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                        WHERE (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    AND QD.KET_THUC =1
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE instr(',CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                          OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE instr(',CNTT,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )      
                        )
                  )
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(
                                    SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CA 
                                     WHERE CA.VUANID=a.ID 
                                     AND CA.TOACHUYENID= v_toaan_id 
                                     AND (V_TUNGAY IS NULL OR CA.NGAYGIAO>=VV_TUNGAY)
                                     AND (V_DENNGAY IS NULL OR CA.NGAYGIAO<=VV_DENNGAY) 
                                     and GD.MAGIAIDOAN=2
                                    )      
                         OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )  
                  --toancau - quyet )
               
             -- END v_TINHTRANG_GIAIQUYET
             --là con của chưa giải quyết xong 
--            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
--               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
--                     AND (EXISTS (
--                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
--                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
--                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
--                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
--                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
--                                        )
--                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
--                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
--                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                     OR EXISTS (
--                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
--                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
--                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                ) --là con của chưa giải quyết xong end 
            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
END DON_SEARCH;
PROCEDURE DON_CON_SEARCH
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
               || --lanh thêm thông tin giải quyết của vụ án cha
             CASE WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN is null) THEN 
             (SELECT '</br>- Đã nhập vụ án (Vụ án nhập: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from ADS_DON D
                    left join ADS_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from ADS_DON D
                    left join ADS_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )

        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI
      FROM ADS_DON A
      INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      -- lấy thông tin vụ án end     
      LEFT JOIN (SELECT PTBA.* FROM ADS_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM ADS_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách
        LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.ADS_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

        LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.ADS_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
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
                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID

--            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
--                     INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
--                      )GN ON  GN.VUANID=a.ID
           LEFT JOIN (SELECT CA.VUANID,i.TEN TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
                  INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                  GROUP BY CA.VUANID,i.TEN
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  ADS_SOTHAM_KHANGNGHI KN
                      where KN.TINHTRANG_GIAIQUYET != 3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 

        ---------------------                
        WHERE   (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM ADS_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM ADS_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM ADS_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
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
            OR( EXISTS(SELECT 'x' FROM ADS_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM ADS_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )   
          AND (v_thuky_id is null--Thư ký
                   OR( EXISTS(select 'X' from ADS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from ADS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id ) 

                     )

                )

                AND(vchecktk=0 or (select count(*) from ADS_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
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
                 OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM ADS_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',04,06,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
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
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                        LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                    LEFT JOIN ADS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_THULY TL 
                                    LEFT JOIN ADS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ADS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN BA
                              LEFT JOIN ADS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                            SELECT 'x' FROM ADS_DON_THAMPHAN PC 
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
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ADS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ADS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    --LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    --WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISDANSU = 1 AND QD.ISSOTHAM = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    --LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    --WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISDANSU = 1 AND QD.ISPHUCTHAM = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA 
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
                                SELECT 'X' FROM ADS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ADS_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ADS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
END DON_CON_SEARCH;

----- Án Hôn Nhân
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
		--THAMPHAN --TOANCAU-03102023-ANHNT
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
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, A.ID,A.MAVUVIEC,A.TENVUVIEC,A.SOTHUTU,A.NGAYNHANDON,A.NGUOITAO
      ,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NGAYTAO
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

            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHN_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                     and not exists (select 'x' from AHN_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)
                     group by CA.VUANID,i.TEN  
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
                AND( GD.MAGIAIDOAN = 2
                    AND (V_TUNGAY IS NULL OR A.NGAYNHANDON>=VV_TUNGAY) 
                    AND (V_DENNGAY IS NULL OR A.NGAYNHANDON<=VV_DENNGAY)
                    )
                OR EXISTS ( SELECT 'X' FROM AHN_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        )
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    (  (
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
                            ) 
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
               --toancau - quyet )
             -- END v_TINHTRANG_GIAIQUYET
             --là con của chưa giải quyết xong 
--            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
--               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
--                     AND (EXISTS (
--                                SELECT 'X' FROM AHN_SOTHAM_THULY TL
--                                  WHERE (NOT EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
--                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AHN_SOTHAM_QUYETDINH T1 
--                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
--                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
--                                        )
--                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
--                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
--                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                     OR EXISTS (
--                                SELECT 'X' FROM AHN_PHUCTHAM_THULY PTTL 
--                                 WHERE (NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
--                                        AND NOT EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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

PROCEDURE AKT_DON_SEARCH
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
        --THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM AKT_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  AKT_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  AKT_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
		--THAMPHAN --TOANCAU-03102023-ANHNT
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
                       WHERE EXISTS(SELECT 'X' FROM AKT_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID and kc.loaikhangcao !=2 AND KC.DONID=DS.DONID)
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
        STBA.BANAN_QD_ST,'' as QD_PT,STKN.KHANGNGHI_ST, PKG_STPT_AKT_GS.NOIDUNG_KHANGCAO_DANHSACH(a.ID) as KHANGCAO_ST,--toancau 18092023-anhnt thêm trường QD_PT mặc định trống
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
                    from AKT_DON D
                    left join AKT_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AKT_DON D
                    left join AKT_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )

        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI,
        A.QHPLTKID,A.TOAANID
      FROM AKT_DON A
      INNER JOIN (SELECT G.* FROM AKT_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      -- lấy thông tin vụ án end     
      LEFT JOIN (SELECT PTBA.* FROM AKT_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AKT_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
        ------Trạng thái giải quyết trong danh sách
        LEFT JOIN (
                    SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                    FROM GSCM.AKT_SOTHAM_THULY T2
                    WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
                 ) TLS ON TLS.DONID=A.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn

        LEFT JOIN (
                 SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
                  FROM GSCM.AKT_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
                  WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
                  ) TLPT ON TLPT.DONID=A.ID  AND GD.MAGIAIDOAN=3 

        LEFT JOIN (
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
--                        FROM AKT_DON_THAMPHAN TP
--                        LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                        LEFT JOIN (SELECT GG.* FROM AKT_DON_THAMPHAN GG
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
                                         AKT_CHUYEN_NHAN_AN CA
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
                                         AKT_CHUYEN_NHAN_AN CN1
                                    JOIN AKT_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = v_toaan_id
                                    AND CN2.ID > CNA.ID
                            )
                        
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
--toancau-anhnt-sửa check đã chuyển lại án sơ thẩm
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID

            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                     and not exists (select 'x' from AKT_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)
                     group by CA.VUANID,i.TEN  
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AKT_SOTHAM_KHANGNGHI KN
                      where KN.TINHTRANG_GIAIQUYET != 3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 

----LẤY THÔNG TIN KHÁNG CÁO --toancau 18092023-bỏ
--   LEFT JOIN ( SELECT KC.DONID,
--                     '<br /><i>Kháng cáo:</i> <br />'|| 
--                      listagg (' ngày '||TO_CHAR(KC.NGAYKHANGCAO,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO) KHANGCAO_ST
--                      FROM  AKT_SOTHAM_KHANGCAO KC
--                      GROUP BY KC.DONID
--              )STKC ON STKC.DONID=A.ID 

        ---------------------                
        WHERE   
        a.magiaidoan != 7 and --toancau 31-03-2023 bỏ án pt tđc
        (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM AKT_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM AKT_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AKT_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
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
                                                SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND PC.NGAYPHANCONG >= VV_NGAYTHULY_TU
                                                AND A.ID = PC.DONID
                                                )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU
                                    
                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM ADS_DON D
                                                LEFT JOIN AKT_DON_THAMPHAN PC ON PC.DONID = D.ID
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
                                        SELECT 'X' FROM AKT_CHUYEN_NHAN_AN CNA
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
                                        SELECT 'X' FROM AKT_CHUYEN_NHAN_AN CNA
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
                                                SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM AKT_DON D
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
            --OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
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
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )   
          AND (v_thuky_id is null--Thư ký
                   OR( EXISTS(select 'X' from AKT_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AKT_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id ) 

                     )

                )

                AND(vchecktk=0 or (select count(*) from AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
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
                 OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
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
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                        LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                AND( GD.MAGIAIDOAN = 2
                    AND (V_TUNGAY IS NULL OR A.NGAYNHANDON>=VV_TUNGAY) 
                    AND (V_DENNGAY IS NULL OR A.NGAYNHANDON<=VV_DENNGAY)
                    )
                OR EXISTS ( SELECT 'X' FROM AKT_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        )
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    (  (
                        EXISTS (
                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
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
                                SELECT 'X' FROM AKT_SOTHAM_THULY STTL
                                WHERE
                                STTL.DONID =  A.ID 
                                AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                                AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                                )-- =2)
                                --=3
                                OR EXISTS( 
                                    SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2--sơ thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                )--=3)
                                 --(=4 
                                OR EXISTS(
                                SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV --SO THAM
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                                WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                                    )--=4)
                                     --(=5
                                OR EXISTS ( -- hoãn sơ thẩm
                                SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                    WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                    WHERE
                                    PTTL.DONID = A.ID
                        
                                    AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                                    AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                                        )--2
                                --=3 
                                OR EXISTS( 
                                    SELECT 'x' FROM AKT_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3--phuc thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                        )--=3)
                                        --(=4 
                                OR EXISTS(
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA -- PHUC THAM
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN AKT_PHUCTHAM_BANAN BA ON PTQDVA.DONID = BA.DONID
                                    WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=A.ID )--=4)
                                --(=5 
                                OR EXISTS ( --Đang hoãn phuc tham
                                    SELECT  'X' FROM   AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA='TDC' --Tạm đình chỉ
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )--=6)
                                )  
                            ) 
                )-- toan cau --quyet)
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                AND ( EXISTS ( 
                        SELECT 'X' FROM AKT_SOTHAM_THULY STTL
                        WHERE
                        STTL.DONID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                    OR EXISTS(
                        SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.DONID = A.ID
                        
                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                    )
                   AND ( 
                                NOT EXISTS (
                                    SELECT 'x' FROM AKT_DON_THAMPHAN PC 
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
                            SELECT 'x' FROM AKT_DON_THAMPHAN PC 
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
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA
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
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISKDTM = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISKDTM = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AKT_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
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
--                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
--                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
--                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
--                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
--                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
--                                        )
--                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
--                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
--                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                     OR EXISTS (
--                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
--                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
--                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
END AKT_DON_SEARCH;

PROCEDURE AKT_DON_CON_SEARCH
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
                    from AKT_DON D
                    left join AKT_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from AKT_DON D
                    left join AKT_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )
        TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI
      FROM AKT_DON A
      INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      ----- BA Or QD----------------------------------------------
      LEFT JOIN (SELECT PTBA.* FROM AKT_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3 
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AKT_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AKT_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AKT_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 
              
        ---------------------                
        WHERE   (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM AKT_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM AKT_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM AKT_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
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
            OR( EXISTS(SELECT 'x' FROM AKT_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM AKT_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from AKT_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from AKT_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id )

                     )

                )
                AND(vchecktk=0 or (select count(*) from AKT_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
                --hieu check theo trạng thái vụ án dân sự          
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
                 OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',04,06,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AKT_PHUCTHAM_BANAN PB 
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
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                        LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                    LEFT JOIN AKT_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_THULY TL 
                                    LEFT JOIN AKT_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN AKT_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN BA
                              LEFT JOIN AKT_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                            SELECT 'x' FROM AKT_DON_THAMPHAN PC 
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
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AKT_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AKT_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN AKT_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISKDTM = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISKDTM = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AKT_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA 
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
                                SELECT 'X' FROM AKT_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM AKT_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM AKT_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
;
END AKT_DON_CON_SEARCH;

PROCEDURE ALD_DON_SEARCH
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
        --THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM ALD_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  ALD_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  ALD_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
		--THAMPHAN --TOANCAU-03102023-ANHNT
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
      STBA.BANAN_QD_ST,STKN.KHANGNGHI_ST,'' QD_PT,PKG_STPT_ALD_GS.NOIDUNG_KHANGCAO_DANHSACH(a.ID) as KHANGCAO_ST, --toancau 18092023-tamnc thêm trường QD_PT,KHANGCAO_ST mặc định trống
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
                    from ALD_DON D
                    left join ALD_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from ALD_DON D
                    left join ALD_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )
		TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI

      FROM ALD_DON A
    INNER JOIN (SELECT G.* FROM ALD_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.DONID 
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      ----- BA Or QD----------------------------------------------
      LEFT JOIN (SELECT PTBA.* FROM ALD_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM ALD_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
                   		
					SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 2
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 2 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>')TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN (
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
           
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 3
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 3 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETPHUCTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' )TPPCPT ON TPPCPT.DONID=A.ID  AND GD.MAGIAIDOAN=3                  

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
                                         ALD_CHUYEN_NHAN_AN CA
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
                                         ALD_CHUYEN_NHAN_AN CN1
                                    JOIN ALD_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = v_toaan_id
                                    AND CN2.ID > CNA.ID
                            )
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id
                     and not exists (select 'x' from ald_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)
                      group by CA.VUANID,i.TEN  
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  ALD_SOTHAM_KHANGNGHI KN
                          where kn.tinhtrang_giaiquyet !=3
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 
        ---------------------  --toancau 18092023-bỏ lấy thêm thông tin kháng cáo  
--      LEFT JOIN ( SELECT KC.DONID,
--                     '<br /><i>Kháng cáo:</i> <br />'|| 
--                      LISTAGG( ' ngày '
--                    || TO_CHAR(KC.NGAYKHANGCAO, 'dd/MM/yyyy'), '<br/>') WITHIN GROUP(
--                    ORDER BY
--                    KC.NGAYKHANGCAO
--                    ) KHANGCAO_ST
--                      FROM  ALD_SOTHAM_KHANGCAO KC
--                      GROUP BY KC.DONID
--              )STKC ON STKC.DONID=A.ID 

        ---------------------------------
        WHERE  
        a.magiaidoan != 7 and --toancau bo an tdc
        (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM ALD_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM ALD_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM ALD_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
                    ) ) 
             AND (V_CAPXX IS NULL OR (GD.MAGIAIDOAN=V_CAPXX ))--Cấp xét xử  instr(GD.MAGIAIDOAN,V_CAPXX_TEMP)>0)
             AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
           -----   
           --toancau - quyet (
            AND ( (v_TINHTRANG_THULY IS NULL 
                    AND(  (GD.MAGIAIDOAN = 2 AND (V_NGAYTHULY_TU IS NULL OR  A.NGAYNHANDON >=VV_NGAYTHULY_TU)  AND (V_NGAYTHULY_DEN IS NULL OR A.NGAYNHANDON <=VV_NGAYTHULY_DEN) )
                        OR EXISTS ( SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CNA WHERE GD.MAGIAIDOAN = 3 
                        AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                        AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN) ) ) )--Tình trạng thụ lý
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
                                                SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND PC.NGAYPHANCONG >= VV_NGAYTHULY_TU
                                                AND A.ID = PC.DONID
                                                )
                                    OR XLD.NGAYGQ_YC >= VV_NGAYTHULY_TU
                                    
                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR  XLD.NGAYGQ_YC <= VV_NGAYTHULY_DEN 
                                        OR EXISTS(
                                                SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                                                WHERE PC.MAVAITRO = 'VTTP_GIAIQUYETDON'
                                                AND XLD.NGAYGQ_YC IS NULL
                                                AND PC.NGAYPHANCONG <= VV_NGAYTHULY_DEN
                                                AND A.ID = PC.DONID
                                                )
                                        OR (NOT EXISTS(
                                                SELECT 'x' FROM ALD_DON D
                                                LEFT JOIN ADS_DON_THAMPHAN PC ON PC.DONID = D.ID
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
                                        SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.TRANGTHAI = 1 ------- 1ĐÃ NHẬN ÁN
                                )
                                AND (VV_NGAYTHULY_DEN < TLPT.NGAYTHULY )
                                AND EXISTS (
                                        SELECT 'X' FROM ADS_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.VUANID = A.ID
                                            AND CNA.NGAYNHAN <= VV_NGAYTHULY_DEN
                                )
                                
                                )
                            OR (
                                TLPT.DONID IS NULL
                                AND GD.MAGIAIDOAN=3
                                AND EXISTS(
                                        SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CNA
                                        WHERE CNA.TRANGTHAI = 1 -- 1/ĐÃ NHẬN ÁN
                                )
                                AND ( V_NGAYTHULY_TU IS NULL 
                                    OR EXISTS( 
                                            SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CNA
                                            WHERE GD.MAGIAIDOAN = 3
                                            AND CNA.NGAYNHAN >=VV_NGAYTHULY_TU 
                                            AND CNA.VUANID = A.ID
                                    )
                                    
                                    )
                                AND ( V_NGAYTHULY_DEN IS NULL
                                        OR EXISTS(
                                                    SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CNA
                                                    WHERE CNA.NGAYNHAN <= VV_NGAYTHULY_DEN
                                                    AND CNA.VUANID = A.ID
                                                )
                                     )
                                )
                        )
                    )
                    --toancau - quyet)
                )
         -----
          AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))--Số Thụ lý
         -----
         AND (V_THAMPHAN_ID IS NULL
           -- OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
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
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from ALD_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from ALD_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id )
                       OR ((select count(*) from ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)=0 or (select count(*) from ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)=1)
                     )

                )
                AND(vchecktk=0 or (select count(*) from ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0 )
                       --hieu check theo trạng thái vụ án dân sự          
--                AND ((v_trangthaivuan = 0 AND (A.VUANGOCID = 0 OR A.VUANGOCID is null))
--                         OR (v_trangthaivuan = 1 
--                          AND A.VUANGOCID > 0 AND A.IS_TACHAN IS NULL
--                            ) 
--                        OR (v_trangthaivuan = 2
--                          AND A.VUANGOCID > 0 AND A.IS_TACHAN IS NOT NULL
--                            )
--                    ) 
            ------Loại đơn
           AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
           --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
             --toancau - quyet (
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,18,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',03,04,06,12,13,14,15,21,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                     --toancau - quyet )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
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
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                        LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )        
                 --toancau - quyet (
           --Tình trạng GQ;
         AND( (v_TINHTRANG_GIAIQUYET IS NULL 
                AND( GD.MAGIAIDOAN = 2
                    AND (V_TUNGAY IS NULL OR A.NGAYNHANDON>=VV_TUNGAY) 
                    AND (V_DENNGAY IS NULL OR A.NGAYNHANDON<=VV_DENNGAY)
                    )
                OR EXISTS ( SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        )
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    (  (
                        EXISTS (
                                SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
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
                                SELECT 'X' FROM ALD_SOTHAM_THULY STTL
                                WHERE
                                STTL.DONID =  A.ID 
                                AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                                AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                                )-- =2)
                                --=3
                                OR EXISTS( 
                                    SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2--sơ thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                )--=3)
                                 --(=4 
                                OR EXISTS(
                                SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV --SO THAM
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                                WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                                    )--=4)
                                     --(=5
                                OR EXISTS ( -- hoãn sơ thẩm
                                SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                    WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                    WHERE PTTL.DONID = A.ID
                                    AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                                    AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                                        )--2
                                --=3 
                                OR EXISTS( 
                                    SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                                    WHERE PC.DONID=A.ID
                                    AND PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3--phuc thẩm
                                    AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                                    AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)
                                        )--=3)
                                        --(=4 
                                OR EXISTS(
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA -- PHUC THAM
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                                    LEFT JOIN ALD_PHUCTHAM_BANAN BA ON PTQDVA.DONID = BA.DONID
                                    WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=A.ID )--=4)
                                --(=5 
                                OR EXISTS ( --Đang hoãn phuc tham
                                    SELECT  'X' FROM   ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA='TDC' --Tạm đình chỉ
                                    AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                        )--=6)
                                )  
                            ) 
                )-- toan cau --quyet)
             OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                -- ( 13/07 TOANCAU QUYET 
                AND ( EXISTS ( 
                        SELECT 'X' FROM ALD_SOTHAM_THULY STTL
                        WHERE
                        STTL.DONID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                    OR EXISTS(
                        SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.DONID = A.ID
                        
                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                    )
                   AND ( 
                                NOT EXISTS (
                                    SELECT 'x' FROM ALD_DON_THAMPHAN PC 
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
                            -- 13/07 TOANCAU QUYET )
                )
               OR(v_TINHTRANG_GIAIQUYET=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM ALD_DON_THAMPHAN PC 
                            WHERE PC.DONID=A.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)  
                      )
               )
                --toancau /*quyết -thêm điều kiện 
               OR(v_TINHTRANG_GIAIQUYET=4 --đã lên lịch xét xử
               
                    AND (
                        EXISTS (
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA
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
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISLAODONG = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISLAODONG = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
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
             --toancau - quyet (
--            AND (  (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)=0 OR v_TINHTRANG_GIAIQUYET IS NULL)
--               OR (instr('2,3,4,5,6',v_TINHTRANG_GIAIQUYET)>0 
--                     AND (EXISTS (
--                                SELECT 'X' FROM ALD_SOTHAM_THULY TL
--                                  WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
--                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
--                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
--                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
--                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
--                                        )
--                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
--                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
--                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
--                               )
--                     OR EXISTS (
--                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
--                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
--                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
--toancau - quyet )
            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
;
END ALD_DON_SEARCH;

PROCEDURE ALD_DON_CON_SEARCH
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
                    from ALD_DON D
                    left join ALD_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             WHEN (A.VUANGOCID > 0 AND A.IS_TACHAN = 1) THEN
             (SELECT '</br>- Đã tách vụ án (Vụ án tách: Thụ lý số:<b> '|| to_char(T.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T.NGAYTHULY,'dd/MM/yyyy')
                    from ALD_DON D
                    left join ALD_SOTHAM_THULY T ON D.ID = T.DONID
                    WHERE D.ID = A.VUANGOCID)
             END
               )
		TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
        DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI

      FROM ALD_DON A
      INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
      left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
      LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
      ----- BA Or QD----------------------------------------------
      LEFT JOIN (SELECT PTBA.* FROM ALD_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.DONID = A.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN=3
        --- Lay ra trang thai giai quyet don
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM ALD_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2               

            -------trường hợp giao nhận dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--           LEFT JOIN (SELECT CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>' TRUONGHOPGIAONHAN FROM DM_DATAITEM i 
--                  INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
--                  GROUP BY CA.VUANID,'<br/><i>TH giao nhận:</i> <b>'||i.TEN||'</b>'
--                  )GN ON  GN.VUANID=a.ID
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN ALD_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
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
          LEFT JOIN ( SELECT KN.DONID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  ALD_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.DONID
              )STKN ON STKN.DONID=A.ID 
        ---------------------                
        WHERE   (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )--Tên vụ án
            AND (V_UTTP IS NULL OR (V_UTTP IS NOT NULL 
                                        AND (EXISTS (SELECT 'X' FROM ALD_SOTHAM_THULY TL  WHERE TL.UTTPDI = to_number(V_UTTP) and TL.DONID = A.ID AND GD.MAGIAIDOAN=2)    
                                            OR  EXISTS ( SELECT 'X' FROM ALD_PHUCTHAM_THULY TLPT WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.DONID = A.ID AND GD.MAGIAIDOAN=3)   )  ) )                       
            AND (V_QHPL IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUVIEC)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_QHPL))||'%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
            AND (V_MA_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.MAVUVIEC)) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )   --Mã vụ án
            AND (V_TENDUONGSU IS NULL --Đương sự
                  OR( EXISTS (SELECT 'X' FROM ALD_DON_DUONGSU DS WHERE FN_CONVERT_TO_VN(UPPER(DS.TENDUONGSU)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_TENDUONGSU))||'%' AND DS.DONID=A.ID)
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
            OR( EXISTS(SELECT 'x' FROM ALD_DON_THAMPHAN PC WHERE   PC.CANBOID = V_THAMPHAN_ID  AND PC.DONID=A.ID ))--Thẩm phán
           )
            --GQ đơn;V_GQDON -- -- 
          AND (V_GQDON IS NULL 
              OR((V_GQDON=1 OR V_GQDON=3 OR V_GQDON=4 OR V_GQDON=5)  AND EXISTS ( SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.LOAIGIAIQUYET=V_GQDON AND XL.DONID=A.ID) ) 
              OR(V_GQDON =6 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) ) 
              OR(V_GQDON =7 AND NOT EXISTS (SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID) 
                            AND (SYSDATE-a.NGAYNHANDON)>15
                 )
                OR(V_GQDON =8 AND NOT EXISTS(SELECT 'X' FROM ALD_DON_XULY XL WHERE XL.DONID=A.ID)
                              AND NOT EXISTS(SELECT 'X' FROM ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)
                ) 
              )  
          AND (V_THUKY_ID is null--Thư ký
                   OR( EXISTS(select 'X' from ALD_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID) 
                       OR EXISTS(select 'X' from ALD_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.DONID=a.ID)
                       OR EXISTS(SELECT 'X' FROM ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID = v_thuky_id )
                       OR ((select count(*) from ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)=0 or (select count(*) from ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID)=1)
                     )

                )
                AND(vchecktk=0 or (select count(*) from ALD_DON_THAMPHAN TP WHERE TP.DONID=A.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0 )
                       --hieu check theo trạng thái vụ án dân sự          
                AND ((v_trangthaivuan = 0 AND (A.VUANGOCID = 0 OR A.VUANGOCID is null))
                         OR (v_trangthaivuan = 1 
                          AND A.VUANGOCID > 0 AND A.IS_TACHAN IS NULL
                            ) 
                        OR (v_trangthaivuan = 2
                          AND A.VUANGOCID > 0 AND A.IS_TACHAN IS NOT NULL
                            )
                    ) 
            ------Loại đơn
           AND (V_LOAIDON IS NULL  OR( A.LOAIDON=V_LOAIDON) )    
           --------------
            AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )
            AND (V_NGAY_QD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=V_NGAY_QD AND A.ID=QSV.DONID  )
                 )
             )
             --Kết quả xx PT;KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',01,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                   OR (v_KETQUA=2 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr(',04,06,',','||KQPT.MA||',')>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=3 --...Sửa 1 phần bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PB.KETQUAPHUCTHAMID 
                                WHERE instr('02',KQPT.MA)>0
                                AND PB.DONID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )
                  OR (v_KETQUA=4 --...Sửa toàn bộ bản án/QĐ sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM ALD_PHUCTHAM_BANAN PB 
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
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                        LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
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
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                            EXISTS(SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                    LEFT JOIN ALD_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =a.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_THULY TL 
                                    LEFT JOIN ALD_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN ALD_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
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
                       AND ( EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(V_PT_RKINHNGHIEM =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =a.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN BA
                              LEFT JOIN ALD_SAUXETXU SXX ON BA.DONID=SXX.VUANID
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
                                SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
                            SELECT 'x' FROM ALD_DON_THAMPHAN PC 
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
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=A.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN ALD_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
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
                            SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN ALD_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN ALD_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
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
                                    SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISLAODONG = 1
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
                                    -- WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISLAODONG = 1
                                    AND (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                    OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND BA.DONID=a.id  AND GD.MAGIAIDOAN=2
                                  )
                             OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY)
                                    AND PTBA.DONID=a.id  AND GD.MAGIAIDOAN=3
                                    )    
                          )
                     )  
                OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
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
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
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
                                    SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',CVA,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.DONID=a.id  AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM ALD_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id and GD.MAGIAIDOAN=2)      
                         OR EXISTS (
                                    SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA 
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
                                SELECT 'X' FROM ALD_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM ALD_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   LEFT JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.DONID=a.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM ALD_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
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
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
;
END ALD_DON_CON_SEARCH;

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
    V_UTTP IN VARCHAR2,
    vchecktk in number,
    V_THANHNIEN in number,
    Page_Index in	int,
    Page_Size	in	int, 
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_AHS_THAMPHANGIAIQUYET;
    VV_TUNGAY DATE;VV_DENNGAY DATE;  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_TLST T_QUYETDINH;V_TABLE_TLPT T_QUYETDINH;
    V_TABLE_HDXX_ST T_QUYETDINH;V_TABLE_HDXX_PT T_QUYETDINH;  
    V_TABLE_TP T_QUYETDINH;
    V_TABLE_ST T_QUYETDINH;V_TABLE_PT T_QUYETDINH;
    V_TABLE_BC T_AHS_BICANBICAO; V_TABLE_BC_KC T_AHS_BICANBICAO;        
BEGIN	
    -- edit by anhvh 02/03/2020     
    -- Giai đoạn vụ án/vụ việc
    -- SOTHAM = 2;PHUCTHAM = 3;THULYGDT = 4;  --//(DINHCHI = 5;HOSO = 1;)đã xóa 2 gai đoạn này vì không phù hợp với nghiệp vụ tòa án
    --v_Capxx: SOTHAM = 2;PHUCTHAM = 3
     V_TABLE_TLST := T_QUYETDINH();  V_TABLE_TLPT := T_QUYETDINH();
     V_TABLE_HDXX_ST := T_QUYETDINH(); V_TABLE_HDXX_PT := T_QUYETDINH();   
     V_TABLE_TP := T_QUYETDINH();
     V_TABLE_ST := T_QUYETDINH();V_TABLE_PT := T_QUYETDINH();
     V_TABLE_BC := T_AHS_BICANBICAO();V_TABLE_BC_KC := T_AHS_BICANBICAO();
    ---------------------------------------
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size;
    ------------
    --lấy chi tiết với tình trạng GQ là đã phân công thẩm phán.nếu chức năng người tham gia không có chủ tọa thì hệ thống sẽ lấy 
    --1 thẩm phán giải quyết và có ngày nhận phân công gần nhất làm thẩm phán chủ tọa
    -------------------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
      ------------------tao bang tam lay 1 ban ghi moi nhat
      --AHS_SOTHAM_THULY
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHS_SOTHAM_THULY 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;
         --AHS_PHUCTHAM_THULY
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHS_PHUCTHAM_THULY 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;   
        --THAMPHAN tham phan chu toa ST
       SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(CANBOID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC) ID
                 FROM  AHS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;  
       --THAMPHAN tham phan chu toa PT
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(CANBOID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC) ID
                 FROM  AHS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;  
        ---THAMPHAN giai quyet
       SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  AHS_THAMPHANGIAIQUYET 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;    
      --AHS_SOTHAM_QUYETDINH_VUAN
      SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.VUANID,TT.ID,TT.MA FROM (  
                  SELECT PQD.VUANID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.VUANID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHS_SOTHAM_QUYETDINH_VUAN PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.VUANID,TT.ID,TT.MA
                )TTS;
         --AHS_PHUCTHAM_QUYETDINH_VUAN
         SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.VUANID,TT.ID,TT.MA FROM (  
                  SELECT PQD.VUANID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.VUANID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.VUANID,TT.ID,TT.MA
                )TTS;
      ---V_TABLE_BC; tạo bảng lấy <=3 bị cáo: 1 đầu vụ và 2 bị cáo tiếp theo     
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT ID,VUANID,HOTEN,BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY VUANID ORDER BY BICANDAUVU DESC,NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO 
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=3
            )TTS;       
      ---V_TABLE_BC; tạo bảng  lấy <=3 bị cáo khang cao
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO B
                        WHERE EXISTS(SELECT 'X' FROM AHS_SOTHAM_KHANGCAO KC WHERE KC.NGUOIKCID=B.ID AND KC.VUANID=B.VUANID)
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=3
            )TTS;              
    -----------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll,a.ID, a.MaVuAn, a.TenVuAn, a.TT, a.NgayBanCaoTrang,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NgayTao, a.NguoiTao,a.MaGiaiDoan, 
            DECODE(GD.MAGIAIDOAN,3,BC3.HoTen,BC2.HoTen) HoTenBiCan, decode(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||b.Ten||'</b>',null) TenToaSoTham, 
            DECODE(GD.MAGIAIDOAN,3,GN.TruongHopGiaoNhan,Decode(A.TRUONGHOPGIAONHAN,270,'Xét xử lại cấp sơ thẩm',AA.TruongHopGiaoNhan))TruongHopGiaoNhan,
--            DECODE(GD.MAGIAIDOAN,3,GN.TruongHopGiaoNhan,AA.TruongHopGiaoNhan)TruongHopGiaoNhan,
            NULL HINHTHUCNHANDON,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm'  , 3, 'Phúc thẩm' , 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec,
            STBA.BANAN_QD_ST, STKN.KHANGNGHI_ST,
            --------
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
             ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
             ||GNST.TINHTRANG_GQ
            TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
            DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI
            FROM AHS_VUAN A
            INNER JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID
            LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
            -- lấy thông tin vụ án end     
            LEFT JOIN (SELECT PTBA.* FROM AHS_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.VUANID = A.ID AND GD.MAGIAIDOAN=3
            LEFT JOIN (SELECT PTQDVA.* FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.VUANID = A.ID AND GD.MAGIAIDOAN=3 
            ------Trạng thái giải quyết trong danh sách
            LEFT JOIN (
                       SELECT TL.VUANID,'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                           TINHTRANG_GQ FROM AHS_SOTHAM_THULY TL
                           WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=TL.ID)
                           GROUP BY TL.VUANID,'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                       )TLS ON A.ID=TLS.VUANID AND GD.MAGIAIDOAN=2

            LEFT JOIN ( SELECT TL.VUANID,'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                          TINHTRANG_GQ FROM AHS_PHUCTHAM_THULY TL 
                          WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=TL.ID)
                          GROUP BY TL.VUANID,'</br>- Thụ lý số:<b> '|| to_char(TL.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(TL.NGAYTHULY,'dd/MM/yyyy')||'</b>'
                      )TLPT ON A.ID=TLPT.VUANID AND GD.MAGIAIDOAN=3

            LEFT JOIN ( SELECT TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AHS_THAMPHANGIAIQUYET TP
                        LEFT JOIN (SELECT VUANID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.VUANID=TP.VUANID
                          ----anhvh add 08/07/2021 hàm lấy 1 bản ghi mới nhất trong bảng AHS_THAMPHANGIAIQUYET      
                         LEFT JOIN ( SELECT GG.* FROM AHS_THAMPHANGIAIQUYET GG
                                     WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                    )PCTP_GQ ON PCTP_GQ.VUANID=TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                        GROUP BY TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                       )TPPC ON TPPC.VUANID=A.ID AND GD.MAGIAIDOAN=2

            LEFT JOIN (  SELECT TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                        FROM AHS_THAMPHANGIAIQUYET TP
                        LEFT JOIN (SELECT VUANID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.VUANID=TP.VUANID
                        LEFT JOIN (SELECT GG.* FROM AHS_THAMPHANGIAIQUYET GG
                                    WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                   )PCTP_GQ ON PCTP_GQ.VUANID=TP.VUANID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                        LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                        LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                        WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                        GROUP BY TP.VUANID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                       )TPPCPT ON TPPCPT.VUANID=A.ID AND GD.MAGIAIDOAN=3

            LEFT JOIN (SELECT QSV.VUANID,'</br>- QĐ HPT số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.VUANID,'</br>- QĐ HPT số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                      )HPT ON HPT.VUANID=A.ID AND GD.MAGIAIDOAN=2 

            LEFT JOIN ( SELECT PTQDVA.VUANID,'</br>- QĐ HPT số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
                        FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
                        GROUP BY PTQDVA.VUANID,'</br>- QĐ HPT số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                        )HPTPT ON  HPTPT.VUANID=A.id  AND GD.MAGIAIDOAN=3
            LEFT JOIN (
                        SELECT QSV.VUANID,'</br>- QĐ TĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                        TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND  instr(',TDC,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.VUANID,'</br>- QĐ TĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )TDC ON  TDC.VUANID=A.id AND GD.MAGIAIDOAN=2

            LEFT JOIN ( SELECT PTQDVA.VUANID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                        FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND instr(',TDC,',','||QDL.MA||',')>0  ) 
                        GROUP BY PTQDVA.VUANID,'</br>- QĐ TĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                       )TDCPT ON  TDCPT.VUANID=A.id AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                        SELECT BA.VUANID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy') TINHTRANG_GQ FROM AHS_SOTHAM_BANAN BA
                        WHERE  BA.SOBANAN IS NOT NULL
                        GROUP BY BA.VUANID,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYBANAN,'dd/MM/yyyy')
                        )BAST ON  BAST.VUANID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN ( SELECT PTBA.VUANID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYBANAN,'dd/MM/yyyy') TINHTRANG_GQ FROM AHS_PHUCTHAM_BANAN PTBA 
                        WHERE  PTBA.SOBANAN IS NOT NULL
                        GROUP BY PTBA.VUANID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYBANAN,'dd/MM/yyyy')
                       )BAPT ON  BAPT.VUANID=a.id AND GD.MAGIAIDOAN=3

             LEFT JOIN (SELECT QSV.VUANID,'</br>- QĐ ĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.VUANID,'</br>- QĐ ĐC số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.VUANID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                      SELECT PTQDVA.VUANID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                      FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                      WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
                      GROUP BY PTQDVA.VUANID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                     )DCPT ON  DCPT.VUANID=a.id AND GD.MAGIAIDOAN=3

             LEFT JOIN (
                   SELECT QSV.VUANID,'</br>- QĐ CVA số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                   FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                   WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                   GROUP BY QSV.VUANID,'</br>- QĐ CVA số: '|| QSV.SOQUYETDINH ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                   )CST ON  CST.VUANID=a.id AND GD.MAGIAIDOAN=2

             LEFT JOIN (
                  SELECT PTQDVA.VUANID,'</br>- QĐ CVA số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                  FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                  WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                  GROUP BY PTQDVA.VUANID,'</br>- QĐ CVA số: '|| PTQDVA.SOQUYETDINH ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                 )CPT ON  CPT.VUANID=a.id AND GD.MAGIAIDOAN=3  

           -------Đã chuyển vụ án; trường hợp giao nhận add vào cột trạng thái          
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
                                         AHS_CHUYEN_NHAN_AN CA
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
                                         AHS_CHUYEN_NHAN_AN CN1
                                    JOIN AHS_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = v_toaan_id
                                    AND CN2.ID > CNA.ID
                            )
--           SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2             

            -------trường hợp giao nhân dùng cho sơ thẩm với viện kiểm sát
            LEFT JOIN (SELECT A1.ID, DECODE(A1.TruongHopGiaoNhan,1, 'VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm',2,'Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung',3, 'Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung',''
                       ) TruongHopGiaoNhan  FROM AHS_VUAN A1) AA ON AA.ID=A.ID

            -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
                      )GN ON  GN.VUANID=a.ID

            ------bị cáo lấy cho sơ thẩm
            LEFT JOIN( SELECT BC.VUANID,'<br/><i>Bị cáo:</i> <br />'
                        ||LISTAGG(DECODE(BC.BICANDAUVU,1,'<b>'||BC.HOTEN ||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)||' (đầu vụ)</b>',BC.HOTEN||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)),'<br/>') 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)HOTEN FROM  TABLE(V_TABLE_BC) BC
                        GROUP BY BC.VUANID   
                 ) BC2 ON BC2.VUANID=A.ID      

             ------bị cáo kháng cáo lấy cho phúc thẩm 
            LEFT JOIN(SELECT BC.VUANID,'<br/><i>Bị cáo kháng cáo:</i> <br />'
                        ||LISTAGG(DECODE(BC.BICANDAUVU,1,'<b>'||BC.HOTEN ||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)||' (đầu vụ)</b>',BC.HOTEN||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)),'<br/>') 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)HOTEN FROM  TABLE(V_TABLE_BC_KC) BC
                        GROUP BY BC.VUANID 
                 )BC3 ON BC3.VUANID=A.ID

            ------- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.VUANID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHS_SOTHAM_BANAN BA)STBA ON STBA.VUANID=A.ID 
            ------- lấy thông tin số ngày kháng nghị
           LEFT JOIN ( SELECT KN.VUANID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  AHS_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.VUANID
              )STKN ON STKN.VUANID=A.ID 
            -------
            WHERE (V_TEN_VU_AN IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUAN)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(V_TEN_VU_AN))||'%' ) )
                 AND (V_UTTP IS NULL
                         OR (V_UTTP IS NOT NULL 
                          AND ( EXISTS ( SELECT 'X' FROM AHS_SOTHAM_THULY TL
                                            WHERE TL.UTTPDI = to_number(V_UTTP) and TL.VUANID = A.ID AND GD.MAGIAIDOAN=2)
                                       OR  EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_THULY TLPT 
                                          WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.VUANID = A.ID AND GD.MAGIAIDOAN=3)
                            )  ) )
                AND (V_TOIDANH IS NULL  OR ( FN_CONVERT_TO_VN(LOWER(A.TENVUAN)) LIKE  '%'||FN_CONVERT_TO_VN(LOWER(A.TENVUAN))||'%' ) )--tìm tội danh đã được gắn vào tên vụ án
                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
                AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  FN_CONVERT_TO_VN(LOWER(V_MA_VU_AN)) ) )
                AND (V_BI_CAN IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_BI_CAN))||'%' AND BC.VUANID=A.ID)
                    )                
            -----
                  AND ( (v_TINHTRANG_THULY IS NULL AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN))
                    OR(v_TINHTRANG_THULY=1 --đã thụ lý
                         AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                                           ) 
                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                          )   )  ) 
                    OR(v_TINHTRANG_THULY=2 --chưa thụ lý
                     AND ( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
                        )
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)      
                    )
                )
              -----
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
              --KẾT QUẢ GIẢI QUYẾT v_KETQUA
           AND (v_KETQUA IS NULL
              OR (v_KETQUA=1 --Giữ nguyên quyết định/bản án sơ thẩm
                   AND EXISTS(
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=PTTL.VUANID --QUYẾT ĐỊNH 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT HP ON HP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PTBA.KETQUAPHUCTHAMID 
                                WHERE KQPT.MA='01'--HP.MAHINHPHAT!='TUHINH' AND
                                AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                           )
                  )
                OR (v_KETQUA=2 --Tăng hình phạt
                    AND ( EXISTS(
                                SELECT 'X' FROM  AHS_PHUCTHAM_THULY PTTL
                                LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                WHERE STHP.LOAIHINHPHAT=PTHP.LOAIHINHPHAT--PTHP.MAHINHPHAT!='TUHINH' AND -- tương đương với trường hợp bắt buộc phải nhập hình phạt
                                AND STHP.ID=PTHP.ID
                                AND( (STBACT.SH_VALUE <PTBACT.SH_VALUE OR STBACT.TG_NAM+STBACT.TG_THANG/12+STBACT.TG_NGAY/365<PTBACT.TG_NAM+PTBACT.TG_THANG/12+PTBACT.TG_NGAY/365) --SO SÁNH TỐNG ÁN PHẠT (tăng)
                                     OR(STHP.MUCDO <PTHP.MUCDO)
                                   )
                                   --Tăng hình phạt --Chuyển hình phạt khác nặng hơn
                                AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                          )
                    OR EXISTS (--Tăng lên hình phạt tử hình
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                LEFT JOIN  AHS_BICANBICAO BC ON PTTL.VUANID=BC.VUANID -- BỊ CAN 
                                LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                WHERE STHP.MAHINHPHAT!='TUHINH' AND PTHP.MAHINHPHAT='TUHINH'
                                AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                             )
                       ) 
                   )
                   OR (v_KETQUA=3 --Giảm hình phạt
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                    LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                    LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                    LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                    WHERE --PTHP.MAHINHPHAT!='TUHINH' AND
                                     STHP.LOAIHINHPHAT=PTHP.LOAIHINHPHAT
                                    AND STHP.ID=PTHP.ID
                                    AND (   (STBACT.SH_VALUE >PTBACT.SH_VALUE OR STBACT.TG_NAM+STBACT.TG_THANG/12+STBACT.TG_NGAY/365>PTBACT.TG_NAM+PTBACT.TG_THANG/12+PTBACT.TG_NGAY/365) --SO SÁNH TỐNG ÁN PHẠT (giảm)--SO SÁNH TỐNG ÁN PHẠT (giảm)
                                        OR (STHP.MUCDO >PTHP.MUCDO)
                                        )
                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                    AND PTTL.VUANID=A.ID AND GD.MAGIAIDOAN=3  
                                )
                             OR EXISTS (
                                        SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                        LEFT JOIN AHS_SOTHAM_BANAN STBA ON STBA.VUANID=PTTL.VUANID 
                                        LEFT JOIN AHS_SOTHAM_BANAN_DIEU_CHITIET STBACT ON STBACT.BANANID=STBA.ID 
                                        LEFT JOIN DM_HINHPHAT STHP ON STHP.ID=STBACT.HINHPHATID --HÌNH PHẠT 
                                        LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                        LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                        LEFT JOIN DM_HINHPHAT PTHP ON PTHP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                        WHERE STHP.MAHINHPHAT='TUHINH' AND PTHP.MAHINHPHAT!='TUHINH'
                                        AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                        AND PTTL.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                    )
                            )
                     )
                  OR (v_KETQUA=4 --Hủy quyết định/bản án sơ thẩm để...
                   AND EXISTS(
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=PTTL.VUANID --QUYẾT ĐỊNH 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT HP ON HP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                LEFT JOIN DM_KETQUA_PHUCTHAM KQPT ON KQPT.ID=PTBA.KETQUAPHUCTHAMID 
                                WHERE --HP.MAHINHPHAT!='TUHINH' AND
                                KQPT.MA IN ('03','04','06','13','14','12')
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTTL.VUANID=A.ID AND GD.MAGIAIDOAN=3
                           )
                     )
                   OR (v_KETQUA=5
                     --Sửa phần dân sự bao gồm (Sửa phần bồi thường thiệt hại và quyết định xử lý vật chứng;Sửa các phần khác)
                     --các tiêu chí này tại cột 51 và 52 của báo cáo thống kê mẫu 1 
                   AND EXISTS(
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL
                                LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=PTTL.VUANID --QUYẾT ĐỊNH 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                                LEFT JOIN AHS_PHUCTHAM_BANAN_DIEU_CT PTBACT ON PTBACT.BANANID=PTBA.ID 
                                LEFT JOIN DM_HINHPHAT HP ON HP.ID=PTBACT.HINHPHATID --HÌNH PHẠT 
                                WHERE --HP.MAHINHPHAT!='TUHINH' AND -- tương đương với trường hợp bắt buộc phải nhập hình phạt
                                 (PTBA.TK_BOITHUONGTH=1 OR PTBA.TK_SUAKHAC=1)
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTTL.VUANID=a.id AND GD.MAGIAIDOAN=3
                           )
                     )  
                )
            -- Tham phan giai quyet
           AND (v_thamphan_id is null
                   OR(    EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
                       OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
                     )
                )
           AND (v_thuky_id is null
                   OR( EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID)
                        OR EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tsp where tsp.THUKYID = v_thuky_id and tsp.VuAnID=a.ID)

                     )
                )
                AND(vchecktk=0 or (select count(*) from AHS_THamPhanGiaiQuyet TP WHERE TP.VuANID=A.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(a.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
          --v_THOIHAN_GQ=1 --Đã hết thời hạn, Tính từ ngày thụ lý vụ án
           --/////////////đối với sơ thẩm     
          --Mức độ nghiêm trọng:
          --ít nghiêm trọng >45 ngày là hết hạn; nghiêm trọng >60 ngày; rất nghiêm trọng >90 ngày; 
          --đặc biệt nghiêm trọng >120 ngày
          ---->mốc để tính quá hạn là ngày bản án, hoặc quyết định kết thúc vụ án, hoặc quyết định gia hạn
          --Quyết định gia hạn chưa cần cộng thêm vào mốc ngày bắt đầu vì nếu có gia hạn thì cũng vẫn trong khoảng giới hạn mặc đinh đã có ví dụ 45 là ngày hạn mặc đinh
          --////đối với phúc thẩm chỉ cần so sánh ngày thụ lý với ngày hiện tại >90 ngày thì là đã hết hạn
          AND (v_THOIHAN_GQ IS NULL
                 OR (v_THOIHAN_GQ=1 --Đã hết thời hạn
                      AND(
                           --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS( SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =TL.VUANID
                                    WHERE
                                    (
                                        ( BA.ID IS NOT NULL
                                           AND (   ( (BA.NGAYBANAN-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                    OR ( (BA.NGAYBANAN-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                                  )
                                        )
                                        OR( (BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0)
                                          AND (        ( (SYSDATE-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                    OR ( (SYSDATE-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                             )
                                         )
                                    )
                                    --AND TL.ID IS NOT NULL 
                                    AND VA.ID =a.id AND GD.MAGIAIDOAN=2
                                  )
                             --dùng ngày quyết định đình chỉ vụ án     
                            OR  EXISTS (
                                        SELECT 'X' FROM  AHS_VUAN VA
                                        INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                        LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                        LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                       (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                        AND  (   ( (QSV.NGAYQD-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89  )
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                                OR ( (QSV.NGAYQD-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                          )
                                       )
                                       OR
                                        (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0
                                      AND  (   ( (SYSDATE-TL.NGAYTHULY)>45 AND VA.LOAITOIPHAMID=89 )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>120 AND VA.LOAITOIPHAMID=92)
                                         )
                                       )
                                    )
                                  --AND TL.ID IS NOT NULL 
                                  AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                 )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (PTBA.ID IS NOT NULL  AND  (PTBA.NGAYBANAN-TL.NGAYTHULY)>90 )
                                     OR (PTBA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
--                                     AND TL.ID IS NOT NULL 
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=3
                                    ) 
                             --dùng ngày QĐ phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    INNER JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE
                                     --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(PTQDVA.NGAYQD-TL.NGAYTHULY)>90 )
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
--                                     AND TL.ID IS NOT NULL 
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    )               
                        )
                  )
                OR (v_THOIHAN_GQ=2 --Còn thời hạn dưới 10 ngày
                      AND(
                           --Sơ thẩm
                            EXISTS(SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =VA.ID
                                    LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (   ( (SYSDATE-TL.NGAYTHULY)>=35 AND (SYSDATE-TL.NGAYTHULY)<45  AND VA.LOAITOIPHAMID=89  )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=50 AND (SYSDATE-TL.NGAYTHULY)<60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=110 AND (SYSDATE-TL.NGAYTHULY)<120 AND VA.LOAITOIPHAMID=92)
                                          )
                                    AND BA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                  )
                              --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND PTBA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    ) 
                           )
                  )
                   OR (v_THOIHAN_GQ=3   AND(--Còn thời hạn dưới 20 ngày
                           --Sơ thẩm
                            EXISTS(SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                                    LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID =VA.ID
                                    LEFT JOIN AHS_SOTHAM_CAOTRANG_DIEULUAT CT ON VA.ID=CT.VUANID
                                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QSV ON VA.ID=QSV.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (   ( (SYSDATE-TL.NGAYTHULY)>=25 AND (SYSDATE-TL.NGAYTHULY)<45  AND VA.LOAITOIPHAMID=89  )
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=40 AND (SYSDATE-TL.NGAYTHULY)<60 AND VA.LOAITOIPHAMID=90)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 AND VA.LOAITOIPHAMID=91)
                                            OR ( (SYSDATE-TL.NGAYTHULY)>=100 AND (SYSDATE-TL.NGAYTHULY)<120 AND VA.LOAITOIPHAMID=92)
                                          )
                                    AND BA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id AND GD.MAGIAIDOAN=2
                                  )
                              --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM  AHS_VUAN VA
                                    INNER JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=VA.ID 
                                    LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=TL.VUANID 
                                    LEFT JOIN AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA ON PTQDVA.VUANID=TL.VUANID 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND PTBA.ID IS NULL
                                    AND( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND VA.ID=a.id  AND GD.MAGIAIDOAN=3
                                    ) 
                           )
              )
          )  
          --BTG bắt tạm giam
          AND (v_QD_TAMGIAM IS NULL
               OR ( v_QD_TAMGIAM=1
                   AND(  EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                            LEFT JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM ( SELECT QSV.* FROM AHS_SOTHAM_QUYETDINH_BICAN QSV
                                                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                            WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                            ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                              (QSV2.HIEULUCDEN-SYSDATE)<0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=2
                            )
                         OR EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_VUAN_GIAIDOAN VGD ON VA.ID=VGD.VUANID
                            INNER JOIN AHS_PHUCTHAM_THULY TL ON VA.ID=TL.VUANID 
                            INNER JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM 
                                                         ( SELECT QSV.* FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV
                                                           LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                                           LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                           WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                           ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                             (QSV2.HIEULUCDEN-SYSDATE)<0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=3
                            )   
                      )
                   )
                 --Còn thời hạn dưới 10 ngày  
                OR ( v_QD_TAMGIAM=2
                   AND(  EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_SOTHAM_THULY TL ON VA.ID=TL.VUANID 
                            LEFT JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM ( SELECT QSV.* FROM AHS_SOTHAM_QUYETDINH_BICAN QSV
                                                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                            WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                            ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                              (QSV2.HIEULUCDEN-SYSDATE)<10 AND (QSV2.HIEULUCDEN-SYSDATE)>0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=2
                            )
                         OR EXISTS(
                            SELECT 'X' FROM  AHS_VUAN VA
                            INNER JOIN AHS_PHUCTHAM_THULY TL ON VA.ID=TL.VUANID 
                            INNER JOIN (SELECT QSV1.VUANID,DECODE(QSV1.HIEULUCDEN,NULL,SYSDATE,QSV1.HIEULUCDEN)HIEULUCDEN FROM 
                                                         ( SELECT QSV.* FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV
                                                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                            WHERE  instr(',BTG,',','||QDL.MA||',')>0
                                                            ORDER BY NGAYQD DESC
                                                           )QSV1 WHERE ROWNUM=1
                                       )QSV2 ON VA.ID=QSV2.VUANID 
                            WHERE 
                             (QSV2.HIEULUCDEN-SYSDATE)<10  AND (QSV2.HIEULUCDEN-SYSDATE)>0 AND
                              VA.ID=a.id AND GD.MAGIAIDOAN=3
                            )   
                      )
                   )   
              )
            -----------------v_TINHTRANG_GIAIQUYET
            AND ( (v_TINHTRANG_GIAIQUYET IS NULL  AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) )
                OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    ( EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                 (NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_BANAN BA WHERE BA.VUANID= TL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN T1 
                                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,',','||QDL.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,',','||QDL.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                   )
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
                                AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)       
                               )
                    )  
                OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                     EXISTS (
                                SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE INSTR(',HPT,',','||QDL.MA||',')>0 --hoãn phiên tòa
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.VUANID=a.id  AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT 'X' FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR(',HPT,',','||QDL.MA||',')>0 --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=a.id  AND GD.MAGIAIDOAN=3
                        ) 
                    )
                )
                OR(v_TINHTRANG_GIAIQUYET=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR(',TDC,',','||QDL.MA||',')>0 -- 'TDC' Tam dinh chi
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.VUANID =A.ID  AND GD.MAGIAIDOAN=2
                             )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE INSTR(',TDC,',','||QDL.MA||',')>0 --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                        )
                    )
                  )
                   ------------------------------
                  OR(v_TINHTRANG_GIAIQUYET=7 --Đã giải quyết xong
                     AND (   
                           EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                                WHERE BA.ID IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  BA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR BA.NGAYBANAN<=VV_DENNGAY)
                                    AND BA.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                     SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    --     LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE    instr(',DC,CVA,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISSOTHAM = 1 AND QD.ISHINHSU = 1
                                          AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                          AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                          AND QSV.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_BANAN PTBA
                                    WHERE  PTBA.ID IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                    AND PTBA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
                                    -- WHERE instr(',DC,',','||QDL.MA||',')>0
                                    WHERE  QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHINHSU = 1
                                    AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                     OR(v_TINHTRANG_GIAIQUYET=8 --Đã xét xử
                      AND ( EXISTS (
                                    SELECT 'X' FROM AHS_SOTHAM_BANAN BA
                                    WHERE BA.SOBANAN IS NOT NULL
                                        AND (V_TUNGAY IS NULL OR  BA.NGAYBANAN>=VV_TUNGAY)
                                        AND (V_DENNGAY IS NULL OR BA.NGAYBANAN<=VV_DENNGAY)
                                        AND BA.VUANID=a.id AND GD.MAGIAIDOAN=2
                                 )
                             OR EXISTS (
                                    SELECT 'X' FROM  AHS_PHUCTHAM_BANAN PTBA 
                                    WHERE   PTBA.SOBANAN IS NOT NULL
                                    AND (V_TUNGAY IS NULL OR  PTBA.NGAYBANAN>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTBA.NGAYBANAN<=VV_DENNGAY)
                                    AND PTBA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                                    )    
                            )
                     )
                  OR(v_TINHTRANG_GIAIQUYET=9 --Đình chỉ
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE   instr(',DC,',','||QDL.MA||',')>0
                                    AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.VUANID =A.ID AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                WHERE  instr(',DC,',','||QDL.MA||',')>0
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTQDVA.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )
                      OR(v_TINHTRANG_GIAIQUYET=10 --QĐ chuyển vụ án
                    AND ( EXISTS (
                                    SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE  QDL.MA='CVA'
                                    AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.VUANID =A.ID AND GD.MAGIAIDOAN=2
                                )
                         OR EXISTS(SELECT 'X' FROM AHS_CHUYEN_NHAN_AN CA WHERE CA.VUANID=a.ID AND CA.TOACHUYENID=v_toaan_id  AND GD.MAGIAIDOAN=2)
                         OR EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE  instr(',CVA,',','||QDL.MA||',')>0
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTQDVA.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                )       
                        )
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
                                                WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND TL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR TL.NGAYTHULY<=VV_DENNGAY)
                                 AND TL.VUANID=a.id  AND GD.MAGIAIDOAN=2
                               )
                        OR  EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                INNER JOIN DM_QD_LOAI T2 ON T1.LOAIQDID=T2.ID
                                                WHERE INSTR(',DC,CVA,',','||T2.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                    )   
                )--là con của chưa giải quyết xong end 
                AND (v_thanhnien = 0
                         OR (v_thanhnien = 1 
                          AND ( EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                            WHERE BC.istrevithanhnien = 1 and BC.VUANID = A.ID)
                                       OR  
                                        EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                          WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = A.ID))
                            ) 
                         OR (v_thanhnien = 2
                          AND ( NOT EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                            WHERE BC.istrevithanhnien = 1 and BC.VUANID = A.ID)
                                       AND  
                                        NOT EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                          WHERE NTT.istrevithanhnien = 1 and NTT.VUANID = A.ID))
                            )) 
              ----------------------------    
       )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
   ;
END AHS_VUAN_GETALLPAGING;

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
        STBA.BANAN_QD_ST,'' as QD_PT,STKN.KHANGNGHI_ST, PKG_STPT_AHC_GS.NOIDUNG_KHANGCAO_DANHSACH(a.ID) as KHANGCAO_ST,--toancau 18092023-anhnt thêm trường QD_PT mặc định trống
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

            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN AHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id 
                     and not exists (select 'x' from ahc_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7)
                     group by CA.VUANID,i.TEN  
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

----LẤY THÔNG TIN KHÁNG CÁO --toancau 18092023-bỏ
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
                AND( GD.MAGIAIDOAN = 2
                    AND (V_TUNGAY IS NULL OR A.NGAYNHANDON>=VV_TUNGAY) 
                    AND (V_DENNGAY IS NULL OR A.NGAYNHANDON<=VV_DENNGAY)
                    )
                OR EXISTS ( SELECT 'X' FROM AHC_CHUYEN_NHAN_AN CNA
                        WHERE
                        GD.MAGIAIDOAN = 3
                            AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) 
                            AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN)
                        )
            )
             OR (v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
             -- (toan cau --quyet
                   AND --SƠ THẨM
                    (  (
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
                            ) 
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
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
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
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
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
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
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
                                    -- LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID --TOANCAU-22092023
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

PROCEDURE APS_DON_SEARCH 
( v_CapXetXuLogin in varchar2, 
  vdonviID in varchar2, 
  vTenViec in varchar2, 
  vLoaiHinhDoanhNghiep in varchar2, 
  vMaViec in varchar2, 
  vDuongSu_NguoiThamGiaToTung in varchar2, 
  vCapXetXu in varchar2, 
  vToaXetXu in varchar2, 
  vTinhTrangThuLy in varchar2, 
  vTuNgayThuLy in varchar2, 
  vDenNgayThuLy in varchar2, 
  vSoThuLy in varchar2, 
  vTinhTrangGQ in varchar2, 
  vTuNgayTinhTrangGQ in varchar2, 
  vDenNgayTinhTrangGQ in varchar2, 
  vThamPhan IN varchar2, 
  vThoiHanGQ in varchar2, 
  vSoQD in varchar2, 
  vNgayQD in varchar2, 
  vThuKy in varchar2,
  vGQDon in varchar2, 
  vUyThacTuPhap in varchar2, 
  vPTRutKinhNghiem in varchar2,
  vchecktk in number,
  V_TRANGTHAIVUAN in number,
	V_VAITRO_THAMPHAN IN VARCHAR2, --toancau-04112023
  Page_Index in int,
  Page_Size in int,
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;
  MinIndex  number;
  MaxIndex  number;
  HOSO number DEFAULT 1;
  SOTHAM number DEFAULT 2;
  PHUCTHAM number DEFAULT 3;
  VV_NGAYTHULY_TU DATE;
  VV_NGAYTHULY_DEN DATE;
  V_TABLE_TLST T_QUYETDINH_EXT;
  V_TABLE_TLPT T_QUYETDINH_EXT;
	V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-03102023-ANHNT
--  V_TABLE_TP T_QUYETDINH_EXT;
--  V_TABLE_HDXX_PT T_QUYETDINH_EXT;
--  V_TABLE_HDXX_ST T_QUYETDINH_EXT;
  VV_TUNGAY_GQ date;
  VV_DENNGAY_GQ date;
  V_TABLE_PT T_QUYETDINH;
  V_TABLE_ST T_QUYETDINH;
  V_TABLE_BC T_BICANBICAO_EXT;
  V_TABLE_BC_KC T_BICANBICAO_EXT;
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
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;
    V_TABLE_TLST := T_QUYETDINH_EXT();
    V_TABLE_TLPT := T_QUYETDINH_EXT();
	 V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-03102023-ANHNT
--    V_TABLE_TP := T_QUYETDINH_EXT();
--    V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
--    V_TABLE_HDXX_ST := T_QUYETDINH_EXT();
    V_TABLE_PT := T_QUYETDINH();
    V_TABLE_ST := T_QUYETDINH();
    V_TABLE_BC := T_BICANBICAO_EXT();
    V_TABLE_BC_KC := T_BICANBICAO_EXT();

    if(vTuNgayThuLy IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(vTuNgayThuLy)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;
    if(vDenNgayThuLy IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(vDenNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;

    if(vTuNgayTinhTrangGQ IS NOT NULL) then  VV_TUNGAY_GQ:=to_date(trim(vTuNgayTinhTrangGQ)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgayTinhTrangGQ IS NOT NULL) then  VV_DENNGAY_GQ:=to_date(trim(vDenNgayTinhTrangGQ)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;

    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  APS_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  APS_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;
        --THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM APS_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  APS_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  APS_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
		--THAMPHAN --TOANCAU-03102023-ANHNT
--    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_TP
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
--                 FROM  APS_DON_THAMPHAN 
--                 WHERE MAVAITRO != 'VTTP_GIAIQUYETDON'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;      
--       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_ST
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  APS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;
--    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
--        BULK COLLECT INTO V_TABLE_HDXX_PT
--        FROM(SELECT TT.DONID,TT.ID FROM (  
--                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
--                 FROM  APS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
--                )TT GROUP BY TT.DONID,TT.ID
--            )TTS;     
    SELECT R_QUYETDINH(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  APS_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS; 
    SELECT R_QUYETDINH(TTS.donid,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.donid,TT.ID,TT.MA FROM (  
                  SELECT PQD.donid,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.donid,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  APS_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.donid,TT.ID,TT.MA
                )TTS;        
    SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT d.ID,d.DONID,d.TENDUONGSU,d.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY d.DONID ORDER BY d.ISDAIDIEN DESC,d.TENDUONGSU) ROWNUMBER
                       FROM APS_DON_DUONGSU d left join APS_ANPHI p ON p.duongsu_id = d.ID
                       WHERE ((d.TUCACHTOTUNG_MA='NGUYENDON' AND (p.SOBIENLAI IS NOT NULL OR p.tinhtrang=1)) OR d.TUCACHTOTUNG_MA<>'NGUYENDON')
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
    SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                   FROM APS_DON_DUONGSU DS
                   WHERE EXISTS(SELECT 'X' FROM APS_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                )BC 

            where BC.ROWNUMBER <=3
        )TTS;  

    OPEN curReturn FOR
    WITH cte_Data AS(
      Select 
        distinct(d.MAVUVIEC),
        d.ID,
        d.TENVUVIEC,
        d.SOTHUTU,
        d.NGAYNHANDON,
        d.NGUOITAO,
        TO_CHAR(d.NGAYTAO,'dd/MM/yyyy HH24:MI:SS') as NGAYTAO,
        i.TEN as QUANHEPL,
        d.MAGIAIDOAN,
        t.TEN TOASOTHAM,
        d.HINHTHUCNHANDON,
        (Case d.MAGIAIDOAN when 1 then 'Hồ sơ' when 2 then 'Sơ thẩm' when 3 then 'Phúc thẩm' when 4 then 'GĐT, TT' End) GiaiDoanVuViec,
        (Case d.HINHTHUCNHANDON when 1 then 'Trực tiếp' when 2 then 'Qua bưu điện' when 3 then 'Trực tuyến' End) TenHinhThuc,
        DECODE(d.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    GN.TruongHopGiaoNhan) TRUONGHOPGIAONHAN,
        nvl('</br><i>Tòa xét xử sơ thẩm: </i><b>'||t.Ten||'</b>', '') TenToaSoTham,
        STBA.BANAN_QD_ST,
        STKN.KHANGNGHI_ST,
        (BC3.HoTen||BC2.HoTen) HoTenBiCan,
        (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
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
               ||GNST.TINHTRANG_GQ || stqd.TINHTRANG_GQ || ptqd.TINHTRANG_GQ
            TINHTRANG_GQ,
            DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI,
            d.QHPLTKID,d.TOAANID,TLS.SOTHULY, TLS.NGAYTHULY
      From APS_DON d
      INNER JOIN (SELECT G.* FROM APS_DON G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vToaXetXu) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vToaXetXu)) GD ON d.ID=GD.ID
      LEFT JOIN (SELECT PTBA.* FROM APS_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.donid = d.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.donid = d.ID AND GD.MAGIAIDOAN=3 
      inner join APS_DON_DUONGSU dds on d.ID = dds.DONID
      left join DM_DATAITEM i on d.QUANHEPHAPLUATID=i.ID
      left join DM_TOAAN t on d.TOAANID=t.ID
      LEFT JOIN (
            SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
            FROM GSCM.APS_SOTHAM_THULY T2
            WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
         ) TLS ON TLS.DONID=d.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
    LEFT JOIN (
             SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
              FROM GSCM.APS_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
              WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
              ) TLPT ON TLPT.DONID=d.ID  AND GD.MAGIAIDOAN=3 
    LEFT JOIN (
--                    SELECT TP.DONID, DECODE(CBB.id,NULL,CB.id,CBB.id) as idtp,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                    FROM APS_DON_THAMPHAN TP
--                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
--                    LEFT JOIN ( SELECT GG.* FROM APS_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
--                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
--                    GROUP BY TP.DONID,DECODE(CBB.id,NULL,CB.id,CBB.id),'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   		
					SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 2
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 2 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>')TPPC ON TPPC.DONID=d.ID AND GD.MAGIAIDOAN=2
    LEFT JOIN (
--                SELECT TP.DONID, DECODE(CBB.id,NULL,CB.id,CBB.id) as idtp,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
--                FROM APS_DON_THAMPHAN TP
--                LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                LEFT JOIN (SELECT GG.* FROM APS_DON_THAMPHAN GG
--                            WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                           )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
--                LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
--                LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
--                WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
--                GROUP BY TP.DONID,DECODE(CBB.id,NULL,CB.id,CBB.id),'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
    
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) TP
                    LEFT JOIN (SELECT * FROM TABLE(V_TABLE_THAMPHAN)) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 3
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 3 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETPHUCTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>')TPPCPT ON TPPCPT.DONID=d.ID  AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                  SELECT BC.DONID,
                 '<br /><i>Người kháng cáo:</i> <br />'|| 
                  listagg (BC.TENDUONGSU||' ' || decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '</b><br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC) BC
                  GROUP BY BC.DONID
                )BC2 ON BC2.DONID=d.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN ( 
                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <b>'|| 
                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '</b><br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC_KC) BC
                  GROUP BY BC.DONID
                )BC3 ON BC3.DONID=d.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaXetXu group by CA.VUANID,i.TEN  
                      )GN ON  GN.VUANID=d.ID
      LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM APS_SOTHAM_BANAN BA)STBA ON STBA.DONID=d.ID
      LEFT JOIN ( SELECT KN.donid,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  APS_SOTHAM_KHANGNGHI KN
                      where KN.TINHTRANG_GIAIQUYET != 3
                      GROUP BY KN.donid
              )STKN ON STKN.donid=d.ID 
      LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaXetXu 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=d.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                  SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                  FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
                  WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                  GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                 )CPT ON  CPT.DONID=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM APS_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=d.id AND GD.MAGIAIDOAN=2   
      LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM APS_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN (
          SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
          FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
          WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
          GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
         )DCPT ON  DCPT.DONID=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM APS_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM APS_PHUCTHAM_BANAN PTBA 
            WHERE  PTBA.SOBANAN IS NOT NULL
            GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
           )BAPT ON  BAPT.DONID=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
            SELECT BA.donid,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM APS_SOTHAM_BANAN BA
            WHERE  BA.SOBANAN IS NOT NULL
            GROUP BY BA.donid,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
            )BAST ON  BAST.donid=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTQDVA.donid,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND instr(',TDC,',','||QDL.MA||',')>0  ) 
                GROUP BY PTQDVA.donid,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
               )TDCPT ON  TDCPT.donid=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                SELECT QSV.donid,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                TINHTRANG_GQ FROM APS_SOTHAM_QUYETDINH QSV
                WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND  instr(',TDC,',','||QDL.MA||',')>0 ) 
                GROUP BY QSV.donid,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
               )TDC ON  TDC.donid=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTQDVA.donid,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
            FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
            WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
            GROUP BY PTQDVA.donid,'</br>- QĐ HPT số: '|| PTQDVA.SOQd ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
            )HPTPT ON  HPTPT.donid=d.id  AND GD.MAGIAIDOAN=3         
      LEFT JOIN (SELECT QSV.donid,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM APS_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.donid,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                      )HPT ON HPT.donid=d.ID AND GD.MAGIAIDOAN=2
      left join (
            SELECT QSV.donid, '</br>- QĐ '||decode(qdl.ma, 'KMTTPS', 'không mở thủ tục phá sản số: ', 'MTTPS', 'mở thủ tục phá sản số: ', 'DC', 'đình chỉ tiến hành thủ tục phá sản số: ') || QSV.soqd || ' ngày ' || TO_CHAR(QSV.ngayqd, 'DD/MM/YYYY') TINHTRANG_GQ
                FROM APS_SOTHAM_QUYETDINH QSV
                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                WHERE qdl.MA in ('MTTPS', 'KMTTPS', 'DC')
                --and ba.sobanan is not null
      ) stqd on stqd.donid = d.id and GD.MAGIAIDOAN = 2
      left join (
            SELECT PTQDVA.donid, '</br>- QĐ '||decode(qdl.ma, 'KMTTPS', 'không mở thủ tục phá sản số: ', 'MTTPS', 'mở thủ tục phá sản số: ', 'DC', 'đình chỉ tiến hành thủ tục phá sản số: ') || PTQDVA.soqd || ' ngày ' || TO_CHAR(PTQDVA.ngayqd, 'DD/MM/YYYY') TINHTRANG_GQ
                from APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                WHERE qdl.MA in ('MTTPS', 'KMTTPS', 'DC')
                --and ptba.sobanan is not null
      ) ptqd on ptqd.donid = d.id and GD.MAGIAIDOAN = 3
      Where (d.TOAANID=vdonviID Or (d.TOAPHUCTHAMID=vdonviID And d.MAGIAIDOAN=PHUCTHAM))
          and (vLoaiHinhDoanhNghiep is null or dds.LOAIDUONGSU = vLoaiHinhDoanhNghiep)
          AND (vuythactuphap IS NULL OR (vuythactuphap IS NOT NULL 
                                        AND (
                                             EXISTS (
                                                    SELECT 'X' FROM APS_SOTHAM_THULY TL
                                                      WHERE TL.UTTPDI = to_number(vuythactuphap) and TL.DONID = d.ID AND d.MAGIAIDOAN=2)
                                            OR  EXISTS (
                                                SELECT 'X' FROM APS_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(vuythactuphap) and TLPT.DONID = d.ID AND d.MAGIAIDOAN=3)
                                            )
                                    )
                 )
          and (vMaViec IS NULL  OR ( LOWER(d.MAVUVIEC) LIKE  '%'||LOWER(vMaViec)||'%' ))
          and (vTenViec IS NULL  OR ( LOWER(d.TENVUVIEC) LIKE  '%'||LOWER(vTenViec)||'%' ) )--Tên vụ án
          AND (vCapXetXu IS NULL OR (GD.MAGIAIDOAN=vCapXetXu ))--Cấp xét xử
          AND( (GD.TOAANID = vToaXetXu OR (GD.TOAPHUCTHAMID=vToaXetXu AND v_CapXetXuLogin='CAPTINH')) 
                OR (GD.TOAANID =vToaXetXu OR(GD.TOAPHUCTHAMID=vToaXetXu AND v_CapXetXuLogin='CAPCAO' AND T.LOAITOA!='CAPHUYEN')))
          AND (
                (vTinhTrangThuLy IS NULL
                    /*AND(
                    (((vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN))
                    or ((vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN))))*/
                )
                OR(vTinhTrangThuLy=1 
                       AND (
                          (TLS.DONID IS NOT NULL 
                              /*AND (vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) */
                             )
                           OR (TLPT.DONID IS NOT NULL
                              /*AND (vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) */
                             )    ) 
                    )
                OR(vTinhTrangThuLy=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
                     /*AND (vtungaythuly IS NULL OR  d.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (vDenNgayThuLy IS NULL OR d.NGAYTAO<=VV_NGAYTHULY_DEN)   */
                   ) )
          and ((vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                or (vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN))
          -----
           AND (vSoThuLy IS NULL 
                OR( Exists(Select 'X' from APS_SOTHAM_THULY where donid = d.id and UPPER(SOTHULY)=UPPER(vSoThuLy)) 
                    OR Exists(Select 'X' from APS_SOTHAM_THULY where donid = d.id and UPPER(SOTHULY)=UPPER(vSoThuLy)) 
                    ))--Số Thụ lý
          and (1=(CASE WHEN (vDuongSu_NguoiThamGiaToTung|| ' ')=' '  THEN 1 WHEN (Select COunt(ID) from APS_DON_DUONGSU s where s.DONID=d.ID And LOWER(s.TENDUONGSU) LIKE  ('%' || LOWER(vDuongSu_NguoiThamGiaToTung) || '%'))>0 THEN 1 Else 0 END))
          AND (vThamPhan IS NULL
            --TOANCAU-03102023-ANHNT
           OR(V_VAITRO_THAMPHAN IS NULL 
                AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = d.ID AND TP.CANBOID = vThamPhan AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
            OR (V_VAITRO_THAMPHAN = 'VTTP_GIAIQUYETVUVIEC'
                    AND EXISTS (SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = d.ID AND TP.MAVAITRO IN ('VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = vThamPhan))
            OR(V_VAITRO_THAMPHAN = 'CHUTOAPHIENTOA'
                AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = d.ID AND TP.MAVAITRO IN ('THAMPHAN','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM') AND TP.CANBOID = vThamPhan AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
            OR(V_VAITRO_THAMPHAN IN ('VTTP_GIAIQUYETDON','THAMPHANHDXX','THAMPHANDUKHUYET')
                AND EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = d.ID AND TP.MAVAITRO =V_VAITRO_THAMPHAN AND TP.CANBOID = vThamPhan AND TP.MAGIAIDOAN = GD.MAGIAIDOAN )))
           --TOANCAU-03102023-ANHNT
            AND (VGQDON IS NULL --or EXISTS ( SELECT 'X' FROM APS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=vGQDon AND XL.DONID=d.ID)
              OR((vGQDon=1 OR vGQDon=3 OR vGQDon=4 OR vGQDon=5)  AND EXISTS ( SELECT 'X' FROM APS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=vGQDon AND XL.DONID=d.ID) ) 
              OR(vGQDon =6 AND NOT EXISTS (SELECT 'X' FROM APS_DON_XULY XL WHERE XL.DONID=d.ID) ) 
              OR(vGQDon =7 AND NOT EXISTS (SELECT 'X' FROM APS_DON_XULY XL WHERE XL.DONID=d.ID) 
                            AND (SYSDATE-d.NGAYNHANDON)>15
                 )
                OR(vGQDon =8 AND NOT EXISTS(SELECT 'X' FROM APS_DON_XULY XL WHERE XL.DONID=d.ID)
                              AND NOT EXISTS(SELECT 'X' FROM APS_DON_THAMPHAN TP WHERE TP.DONID=d.ID)
                ) 
              )   
          AND (vThuKy is null--Thư ký
                   OR( EXISTS(select 'X' from APS_SoTham_HDXX tp where tp.CanBoID = vThuKy and tp.DONID=d.ID) 
                       OR EXISTS(select 'X' from APS_PhucTham_HDXX tp where tp.CanBoID = vThuKy and tp.DONID=d.ID)
                       OR EXISTS(SELECT 'X' FROM APS_DON_THAMPHAN TP WHERE TP.DONID=d.ID and TP.THUKYID = vThuKy ) 

                     )
                )
        AND (vPTRutKinhNghiem IS NULL
                   OR(vPTRutKinhNghiem =1 
                       AND ( EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(vPTRutKinhNghiem =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )    
        -- vTinhTrangGQ
        AND( (vTinhTrangGQ IS NULL 
                AND (vTuNgayTinhTrangGQ IS NULL OR  d.NGAYTAO>=VV_TUNGAY_GQ) 
                AND (vDenNgayTinhTrangGQ IS NULL OR d.NGAYTAO<=VV_DENNGAY_GQ) 
            )
             OR(vTinhTrangGQ=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM APS_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (vTuNgayTinhTrangGQ IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY_GQ)
                                 AND (vDenNgayTinhTrangGQ IS NULL OR TL.NGAYTHULY<=VV_DENNGAY_GQ)
                                 AND TL.DONID=d.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM APS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (vTuNgayTinhTrangGQ IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY_GQ)
                                 AND (vDenNgayTinhTrangGQ IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY_GQ)
                                 AND PTTL.DONID=d.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(vTinhTrangGQ=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (vTuNgayTinhTrangGQ IS NULL OR  d.NGAYTAO>=VV_TUNGAY_GQ) AND (vDenNgayTinhTrangGQ IS NULL OR d.NGAYTAO<=VV_DENNGAY_GQ) 
                )
               OR(vTinhTrangGQ=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM APS_DON_THAMPHAN PC 
                            WHERE PC.DONID=d.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (vTuNgayTinhTrangGQ IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY_GQ) AND (vDenNgayTinhTrangGQ IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY_GQ)  
                      )
               )
               or(vTinhTrangGQ=4 -- đã lên lịch họp
                  --toancau /*quyết -thêm điều kiện 
                    AND (
                        EXISTS (
                            SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX' AND PTQDVA.DONID IS NULL--QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                        )
                    )
               -- quyet  *\
               )
               OR(vTinhTrangGQ=5 --Đang hoãn  
                   AND (
                     EXISTS (
                            SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(vTinhTrangGQ=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=d.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(vTinhTrangGQ=7 --Đã giải quyết xong
                     AND (   
                     EXISTS (       
                                    SELECT 'X' FROM APS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (vTuNgayTinhTrangGQ IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY_GQ)
                                    AND BA.DONID=d.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,TRAHS,',','||QDL.MA||',')>0
                                    AND (vTuNgayTinhTrangGQ IS NULL OR QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=d.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (vTuNgayTinhTrangGQ IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY_GQ)
                                    AND PTBA.DONID=d.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    AND (vTuNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=d.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                     or(vTinhTrangGQ = 8
                         AND (
                         EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                and QDL.MA = 'KMTTPS'
                                --and ba.sobanan is not null
                                AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                                 )                
                            OR EXISTS (
                                SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'KMTTPS'
                                --and PTBA.sobanan is not null
                                AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                                )    
                           )
                     )
                     or(vTinhTrangGQ = 9
                         AND (
                         EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'MTTPS'
                                and ba.sobanan is not null
                                AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                                 )                
                            OR EXISTS (
                                SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'MTTPS'
                                and PTBA.sobanan is not null
                                AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                                )    
                           )
                     )
                     or(vTinhTrangGQ = 10
                         AND (
                         EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'DC'
                                AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                                 )                
                            OR EXISTS (
                                SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'DC'
                                AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                                )    
                           )
                     )
               )
             -- END vTinhTrangGQ
             AND (vThoiHanGQ IS NULL
                 OR (vThoiHanGQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM APS_SOTHAM_THULY TL
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM APS_SOTHAM_THULY TL
                                        LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (vThoiHanGQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM APS_SOTHAM_THULY TL
                                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (vThoiHanGQ=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM APS_SOTHAM_THULY TL
                                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                ) 
        AND(vchecktk=0 or (select count(*) from APS_Don_ThamPhan TP WHERE TP.DONID=d.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(d.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
        AND (vSoQD IS NULL--Số BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                 )
            )
        AND (vNgayQD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                 )
             )
    ), cte_Total AS (
        SELECT COUNT(ID) AS Total FROM cte_Data
    ), cte_Final AS(
    select ROW_NUMBER() OVER (ORDER BY a.NGAYNHANDON desc) STT,a.ID,a.MAVUVIEC,a.TENVUVIEC,a.SOTHUTU,a.NGAYNHANDON,a.NGUOITAO,a.NGAYTAO,a.QUANHEPL,a.MAGIAIDOAN,a.TOASOTHAM,
        a.HINHTHUCNHANDON,a.GiaiDoanVuViec,a.TenHinhThuc,a.TruongHopGiaoNhan,a.CHECK_THULY,a.THULYXXLAI,a.TINHTRANG_GQ,a.TenToaSoTham,a.BANAN_QD_ST,a.KHANGNGHI_ST,a.HoTenBiCan,(select Total from cte_Total) as CountAll
    from cte_Data a
  )
    select a.*
    from cte_Final a where a.STT between MinIndex and MaxIndex;

END APS_DON_SEARCH;

PROCEDURE APS_DON_CON_SEARCH
( 
    V_DONID_GOC NUMBER,
    v_CapXetXuLogin in varchar2,
    vdonviID in varchar2, 
  vTenViec in varchar2, 
  vLoaiHinhDoanhNghiep in varchar2, 
  vMaViec in varchar2, 
  vDuongSu_NguoiThamGiaToTung in varchar2, 
  vCapXetXu in varchar2, 
  vToaXetXu in varchar2, 
  vTinhTrangThuLy in varchar2, 
  vTuNgayThuLy in varchar2, 
  vDenNgayThuLy in varchar2, 
  vSoThuLy in varchar2, 
  vTinhTrangGQ in varchar2, 
  vTuNgayTinhTrangGQ in varchar2, 
  vDenNgayTinhTrangGQ in varchar2, 
  vThamPhan IN varchar2, 
  vThoiHanGQ in varchar2, 
  vSoQD in varchar2, 
  vNgayQD in varchar2, 
  vThuKy in varchar2,
  vGQDon in varchar2, 
  vUyThacTuPhap in varchar2, 
  vPTRutKinhNghiem in varchar2,
  vchecktk in number,
  Page_Index in	int,
  Page_Size	in int,
  curReturn OUT sys_refcursor
)
IS 
  TotalItem number;
  MinIndex	number;
  MaxIndex	number;
  HOSO number DEFAULT 1;
  SOTHAM number DEFAULT 2;
  PHUCTHAM number DEFAULT 3;
  VV_NGAYTHULY_TU DATE;
  VV_NGAYTHULY_DEN DATE;
  V_TABLE_TLST T_QUYETDINH_EXT;
  V_TABLE_TLPT T_QUYETDINH_EXT;
  V_TABLE_TP T_QUYETDINH_EXT;
  V_TABLE_HDXX_PT T_QUYETDINH_EXT;
  V_TABLE_HDXX_ST T_QUYETDINH_EXT;
  VV_TUNGAY_GQ date;
  VV_DENNGAY_GQ date;
  V_TABLE_PT T_QUYETDINH;
  V_TABLE_ST T_QUYETDINH;
  V_TABLE_BC T_BICANBICAO_EXT;
  V_TABLE_BC_KC T_BICANBICAO_EXT;
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
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;
    V_TABLE_TLST := T_QUYETDINH_EXT();
    V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT();
    V_TABLE_PT := T_QUYETDINH();
    V_TABLE_ST := T_QUYETDINH();
    V_TABLE_BC := T_BICANBICAO_EXT();
    V_TABLE_BC_KC := T_BICANBICAO_EXT();

    if(vTuNgayThuLy IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(vTuNgayThuLy)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;
    if(vDenNgayThuLy IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(vDenNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;

    if(vTuNgayTinhTrangGQ IS NOT NULL) then  VV_TUNGAY_GQ:=to_date(trim(vTuNgayTinhTrangGQ)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgayTinhTrangGQ IS NOT NULL) then  VV_DENNGAY_GQ:=to_date(trim(vDenNgayTinhTrangGQ)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;

    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  APS_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  APS_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  APS_DON_THAMPHAN 
                 WHERE MAVAITRO != 'VTTP_GIAIQUYETDON'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;      
       SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  APS_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  APS_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;     
    SELECT R_QUYETDINH(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  APS_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS; 
    SELECT R_QUYETDINH(TTS.donid,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.donid,TT.ID,TT.MA FROM (  
                  SELECT PQD.donid,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.donid,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  APS_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.donid,TT.ID,TT.MA
                )TTS;        
    SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT d.ID,d.DONID,d.TENDUONGSU,d.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY d.DONID ORDER BY d.ISDAIDIEN DESC,d.TENDUONGSU) ROWNUMBER
                       FROM APS_DON_DUONGSU d left join APS_ANPHI p ON p.duongsu_id = d.ID
                       WHERE ((d.TUCACHTOTUNG_MA='NGUYENDON' AND (p.SOBIENLAI IS NOT NULL OR p.tinhtrang=1)) OR d.TUCACHTOTUNG_MA<>'NGUYENDON')
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  
    SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.TENDUONGSU,TTS.TUCACHTOTUNG_MA,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.TENDUONGSU,BC.TUCACHTOTUNG_MA,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.TENDUONGSU,DS.TUCACHTOTUNG_MA,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY DS.ISDAIDIEN DESC,DS.TENDUONGSU) ROWNUMBER
                   FROM APS_DON_DUONGSU DS
                   WHERE EXISTS(SELECT 'X' FROM APS_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                )BC 

            where BC.ROWNUMBER <=3
        )TTS;  

    OPEN curReturn FOR
    WITH cte_Data AS(
      Select 
        distinct(d.MAVUVIEC),
        d.ID,
        d.TENVUVIEC,
        d.SOTHUTU,
        d.NGAYNHANDON,
        d.NGUOITAO,
        TO_CHAR(d.NGAYTAO,'dd/MM/yyyy HH24:MI:SS') as NGAYTAO,
        i.TEN as QUANHEPL,
        d.MAGIAIDOAN,
        t.TEN TOASOTHAM,
        d.HINHTHUCNHANDON,
        (Case d.MAGIAIDOAN when 1 then 'Hồ sơ' when 2 then 'Sơ thẩm' when 3 then 'Phúc thẩm' when 4 then 'GĐT, TT' End) GiaiDoanVuViec,
        (Case d.HINHTHUCNHANDON when 1 then 'Trực tiếp' when 2 then 'Qua bưu điện' when 3 then 'Trực tuyến' End) TenHinhThuc,
        DECODE(d.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    GN.TruongHopGiaoNhan) TRUONGHOPGIAONHAN,
        nvl('</br><i>Tòa xét xử sơ thẩm: </i><b>'||t.Ten||'</b>', '') TenToaSoTham,
        STBA.BANAN_QD_ST,
        STKN.KHANGNGHI_ST,'' BAPT,
        (BC3.HoTen ) HoTenBiCan,
        (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY,
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
               ||GQDS.TINHTRANG_GQ
               ||CNTT.TINHTRANG_GQ
               ||CST.TINHTRANG_GQ||CPT.TINHTRANG_GQ
               ||GNST.TINHTRANG_GQ || stqd.TINHTRANG_GQ || ptqd.TINHTRANG_GQ
            TINHTRANG_GQ,
      DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI
      From APS_DON d
      INNER JOIN (SELECT G.* 
                  FROM APS_DON G 
                  WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vToaXetXu) 
                  OR(G.TOAANID = vToaXetXu AND G.TOAPHUCTHAMID != vToaXetXu)
                  OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vToaXetXu)
                  ) GD ON d.ID=GD.ID--toancau- Điều kiện để hiển thị 1 bản ghi duy nhất theo giai đoạn xét xử (tránh hiển thị 2 giai đoạn ở ST và PT ở tòa tỉnh) tuanvna
      LEFT JOIN (SELECT PTBA.* FROM APS_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.donid = d.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT PTQDVA.* FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.donid = d.ID AND GD.MAGIAIDOAN=3 

      left join DM_DATAITEM i on d.QUANHEPHAPLUATID=i.ID
      left join DM_TOAAN t on d.TOAANID=t.ID
      LEFT JOIN (
            SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
            FROM GSCM.APS_SOTHAM_THULY T2
            WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
         ) TLS ON TLS.DONID=d.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
    LEFT JOIN (
             SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
              FROM GSCM.APS_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
              WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
              ) TLPT ON TLPT.DONID=d.ID  AND GD.MAGIAIDOAN=3 
    LEFT JOIN (
                    SELECT TP.DONID, DECODE(CBB.id,NULL,CB.id,CBB.id) as idtp,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM APS_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM APS_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,DECODE(CBB.id,NULL,CB.id,CBB.id),'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=d.ID AND GD.MAGIAIDOAN=2
    LEFT JOIN (
                SELECT TP.DONID, DECODE(CBB.id,NULL,CB.id,CBB.id) as idtp,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                FROM APS_DON_THAMPHAN TP
                LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                LEFT JOIN (SELECT GG.* FROM APS_DON_THAMPHAN GG
                            WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                           )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                GROUP BY TP.DONID,DECODE(CBB.id,NULL,CB.id,CBB.id),'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
    )TPPCPT ON TPPCPT.DONID=d.ID  AND GD.MAGIAIDOAN=3
--      LEFT JOIN (
--                  SELECT BC.DONID,
--                 '<br /><i>Người kháng cáo:</i> <br />'|| 
--                  listagg (BC.TENDUONGSU||' ' || decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '</b><br/>')
--                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
--                  FROM  TABLE(V_TABLE_BC) BC
--                  GROUP BY BC.DONID
--                )BC2 ON BC2.DONID=d.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN ( 
                  SELECT BC.DONID,'<br /><i>Người kháng cáo:</i> <b>'|| 
                  listagg (BC.TENDUONGSU||' '|| decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '</b><br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC_KC) BC
                  GROUP BY BC.DONID
                )BC3 ON BC3.DONID=d.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaXetXu
                     and not exists (select 'x' from aPS_don where id =nvl(CA.map_vuanid_new ,0) and magiaidoan = 7) group by CA.VUANID,i.TEN  
                      )GN ON  GN.VUANID=d.ID
      LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM APS_SOTHAM_BANAN BA)STBA ON STBA.DONID=d.ID
      LEFT JOIN ( SELECT KN.donid,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  APS_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.donid
              )STKN ON STKN.donid=d.ID 
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
                                         APS_CHUYEN_NHAN_AN CA
                                    INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                WHERE
                                    CA.TOACHUYENID = vToaXetXu
                            ) CNA
                        WHERE
                                CNA.RN = 1
                            AND NOT EXISTS (
                                SELECT
                                    'X'
                                FROM
                                         APS_CHUYEN_NHAN_AN CN1
                                    JOIN APS_CHUYEN_NHAN_AN CN2 ON CN2.VUANID = CN1.MAP_VUANID_NEW
                                WHERE
                                        CN1.VUANID = CNA.VUANID
                                    AND CN2.TOANHANID = vToaXetXu
                                    AND CN2.ID > CNA.ID
                            )
--                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
--                  INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaXetXu 
--                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=d.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                  SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                  FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
                  WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                  GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                 )CPT ON  CPT.DONID=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM APS_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=d.id AND GD.MAGIAIDOAN=2   
      LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM APS_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=d.id AND GD.MAGIAIDOAN=2
      --Manhnd Loại vụ việc khi ra các quyết định gây kết thúc vụ án thì ko thấy hiển thị ở cột trạng thái trong danh sách
------------------------------------------------------------------------------------------------------------------------------------------------
            LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ GQDS số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM APS_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM DM_QD_QUYETDINH QDL 
                                                        WHERE QDL.ID=QSV.quyetdinhid 
                                                            AND instr(',93-DS,22-VDS,',','||QDL.MA||',')>0
                                                            ) 
                       GROUP BY QSV.DONID,'</br>- QĐ GQDS số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )GQDS ON  GQDS.DONID=d.id AND GD.MAGIAIDOAN=2    
------------------------------------------------------------------------------------------------------------------------------------------------
                  
      LEFT JOIN (
          SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
          FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
          WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
          GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
         )DCPT ON  DCPT.DONID=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM APS_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM APS_PHUCTHAM_BANAN PTBA 
            WHERE  PTBA.SOBANAN IS NOT NULL
            GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
           )BAPT ON  BAPT.DONID=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
            SELECT BA.donid,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM APS_SOTHAM_BANAN BA
            WHERE  BA.SOBANAN IS NOT NULL
            GROUP BY BA.donid,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
            )BAST ON  BAST.donid=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTQDVA.donid,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND instr(',TDC,',','||QDL.MA||',')>0  ) 
                GROUP BY PTQDVA.donid,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
               )TDCPT ON  TDCPT.donid=d.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                SELECT QSV.donid,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                TINHTRANG_GQ FROM APS_SOTHAM_QUYETDINH QSV
                WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND  instr(',TDC,',','||QDL.MA||',')>0 ) 
                GROUP BY QSV.donid,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
               )TDC ON  TDC.donid=d.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTQDVA.donid,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
            FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
            WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
            GROUP BY PTQDVA.donid,'</br>- QĐ HPT số: '|| PTQDVA.SOQd ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
            )HPTPT ON  HPTPT.donid=d.id  AND GD.MAGIAIDOAN=3         
      LEFT JOIN (SELECT QSV.donid,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM APS_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.donid,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                      )HPT ON HPT.donid=d.ID AND GD.MAGIAIDOAN=2
      left join (
            SELECT QSV.donid, '</br>- QĐ '||decode(qdl.ma, 'KMTTPS', 'không mở thủ tục phá sản số: ', 'MTTPS', 'mở thủ tục phá sản số: ', 'DC', 'đình chỉ tiến hành thủ tục phá sản số: ') || QSV.soqd || ' ngày ' || TO_CHAR(QSV.ngayqd, 'DD/MM/YYYY') TINHTRANG_GQ
                FROM APS_SOTHAM_QUYETDINH QSV
                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                WHERE qdl.MA in ('MTTPS', 'KMTTPS', 'DC')
                --and ba.sobanan is not null
      ) stqd on stqd.donid = d.id and GD.MAGIAIDOAN = 2
      left join (
            SELECT PTQDVA.donid, '</br>- QĐ '||decode(qdl.ma, 'KMTTPS', 'không mở thủ tục phá sản số: ', 'MTTPS', 'mở thủ tục phá sản số: ', 'DC', 'đình chỉ tiến hành thủ tục phá sản số: ') || PTQDVA.soqd || ' ngày ' || TO_CHAR(PTQDVA.ngayqd, 'DD/MM/YYYY') TINHTRANG_GQ
                from APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                WHERE qdl.MA in ('MTTPS', 'KMTTPS', 'DC')
                --and ptba.sobanan is not null
      ) ptqd on ptqd.donid = d.id and GD.MAGIAIDOAN = 3
      Where d.magiaidoan != 7
       AND 1 = ( CASE WHEN gd.toaphucthamid = vToaXetXu AND v_CapXetXuLogin = 'CAPTINH' AND gd.magiaidoan = 3 AND EXISTS 
                 ( SELECT 'x' FROM 
                 ( SELECT ca.id, ca.vuanid, ca.toachuyenid, ROW_NUMBER() OVER(PARTITION BY ca.vuanid, ca.toachuyenid ORDER BY  ca.id DESC ) rn 
                 FROM ahc_chuyen_nhan_an ca WHERE ca.toanhanid = vToaXetXu ) cna WHERE cna.rn = 1 
                 AND NOT EXISTS ( SELECT 'X' FROM ahc_chuyen_nhan_an cn1 JOIN ahc_chuyen_nhan_an cn2 ON cn2.vuanid = cn1.map_vuanid_new WHERE  cn1.vuanid = cna.vuanid AND cn2.toanhanid = vToaXetXu AND cn2.id > cna.id ) 
                 ) THEN 0 ELSE 1 END ) and--toancau
                 (d.TOAANID=vdonviID Or (d.TOAPHUCTHAMID=vdonviID And d.MAGIAIDOAN=PHUCTHAM))
          and (vLoaiHinhDoanhNghiep is null or exists(select 'x' from APS_DON_DUONGSU 
          where LOAIDUONGSU = vLoaiHinhDoanhNghiep and DONID=d.id))
          AND (vuythactuphap IS NULL OR (vuythactuphap IS NOT NULL 
                                        AND (
                                             EXISTS (
                                                    SELECT 'X' FROM APS_SOTHAM_THULY TL
                                                      WHERE TL.UTTPDI = to_number(vuythactuphap) and TL.DONID = d.ID AND d.MAGIAIDOAN=2)
                                            OR  EXISTS (
                                                SELECT 'X' FROM APS_PHUCTHAM_THULY TLPT
                                              WHERE TLPT.UTTPDI = to_number(vuythactuphap) and TLPT.DONID = d.ID AND d.MAGIAIDOAN=3)
                                            )
                                    )
                 )
          and (vMaViec IS NULL  OR ( LOWER(d.MAVUVIEC) LIKE  '%'||LOWER(vMaViec)||'%' ))
          and (vTenViec IS NULL  OR ( LOWER(d.TENVUVIEC) LIKE  '%'||LOWER(vTenViec)||'%' ) )--Tên vụ án
          AND (vCapXetXu IS NULL OR (GD.MAGIAIDOAN=vCapXetXu ))--Cấp xét xử
          AND( (GD.TOAANID = vToaXetXu OR (GD.TOAPHUCTHAMID=vToaXetXu AND v_CapXetXuLogin='CAPTINH')) 
                OR (GD.TOAANID =vToaXetXu OR(GD.TOAPHUCTHAMID=vToaXetXu AND v_CapXetXuLogin='CAPCAO' AND T.LOAITOA!='CAPHUYEN')))
          AND (
                (vTinhTrangThuLy IS NULL
                    /*AND(
                    (((vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN))
                    or ((vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN))))*/
                )
                OR(vTinhTrangThuLy=1 
                       AND (
                          (TLS.DONID IS NOT NULL 
                              AND (vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )
                           OR (TLPT.DONID IS NOT NULL
                              AND (vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    ) 
                    )
                OR(vTinhTrangThuLy=2 
                AND (
                --TLS.DONID IS NULL AND TLPT.DONID IS NULL
                (
                  TLS.DONID IS NOT NULL
                  AND GD.MAGIAIDOAN=2
                  AND ( TLS.NGAYTHULY>VV_NGAYTHULY_DEN)
                )
                
                )
                     /*AND (vtungaythuly IS NULL OR  d.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (vDenNgayThuLy IS NULL OR d.NGAYTAO<=VV_NGAYTHULY_DEN)   */
                   ) )
          and ((vtungaythuly IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                or (vtungaythuly IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN))
          -----
           AND (vSoThuLy IS NULL 
                OR( Exists(Select 'X' from APS_SOTHAM_THULY where donid = d.id and UPPER(SOTHULY)=UPPER(vSoThuLy)) 
                   -- OR Exists(Select 'X' from APS_SOTHAM_THULY where donid = d.id and UPPER(SOTHULY)=UPPER(vSoThuLy)) 
                    ))--Số Thụ lý
          and (1=(CASE WHEN (vDuongSu_NguoiThamGiaToTung|| ' ')=' '  THEN 1 WHEN (Select COunt(ID) from APS_DON_DUONGSU s where s.DONID=d.ID And LOWER(s.TENDUONGSU) LIKE  ('%' || LOWER(vDuongSu_NguoiThamGiaToTung) || '%'))>0 THEN 1 Else 0 END))
          AND (vThamPhan IS NULL
            or UPPER(TPPC.idtp) like '%'||UPPER(vthamphan)||'%' or UPPER(TPPCPT.idtp) like '%'||UPPER(vthamphan)||'%'
           )
            AND (VGQDON IS NULL --or EXISTS ( SELECT 'X' FROM APS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=vGQDon AND XL.DONID=d.ID)
              OR((vGQDon=1 OR vGQDon=3 OR vGQDon=4 OR vGQDon=5)  AND EXISTS ( SELECT 'X' FROM APS_DON_XULY XL WHERE XL.LOAIGIAIQUYET=vGQDon AND XL.DONID=d.ID) ) 
              OR(vGQDon =6 AND NOT EXISTS (SELECT 'X' FROM APS_DON_XULY XL WHERE XL.DONID=d.ID) ) 
              OR(vGQDon =7 AND NOT EXISTS (SELECT 'X' FROM APS_DON_XULY XL WHERE XL.DONID=d.ID) 
                            AND (SYSDATE-d.NGAYNHANDON)>15
                 )
                OR(vGQDon =8 AND NOT EXISTS(SELECT 'X' FROM APS_DON_XULY XL WHERE XL.DONID=d.ID)
                              AND NOT EXISTS(SELECT 'X' FROM APS_DON_THAMPHAN TP WHERE TP.DONID=d.ID)
                ) 
              )   
          AND (vThuKy is null--Thư ký
                   OR( EXISTS(select 'X' from APS_SoTham_HDXX tp where tp.CanBoID = vThuKy and tp.DONID=d.ID) 
                       OR EXISTS(select 'X' from APS_PhucTham_HDXX tp where tp.CanBoID = vThuKy and tp.DONID=d.ID)
                       OR EXISTS(SELECT 'X' FROM APS_DON_THAMPHAN TP WHERE TP.DONID=d.ID and TP.THUKYID = vThuKy ) 

                     )
                )
        AND (vPTRutKinhNghiem IS NULL
                   OR(vPTRutKinhNghiem =1 
                       AND ( EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=2
                              )
                         OR   EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    )
                   OR(vPTRutKinhNghiem =2 
                       AND ( NOT EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=2
                              )
                             AND NOT  EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN BA
                              LEFT JOIN APS_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                              WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                              AND BA.DONID =d.id AND GD.MAGIAIDOAN=3
                              )
                          )
                    ) 
                 )    
        -- vTinhTrangGQ
        AND( (vTinhTrangGQ IS NULL AND (vTuNgayTinhTrangGQ IS NULL OR  d.NGAYTAO>=VV_TUNGAY_GQ) AND (vDenNgayTinhTrangGQ IS NULL OR d.NGAYTAO<=VV_DENNGAY_GQ) )
             OR(vTinhTrangGQ=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM APS_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE (instr(',DC,CVA,CNTT,TRAHS,',','||T2.MA||',')>0 
                                                   --  Manh them các loại QD gây kết thúc khác
                                                    OR QD.loaiid in (15,10,3) OR QD.id in (422,423,23,70,425))
                                                   AND TL.DONID=T1.DONID) )
                                        )
                                 AND (vTuNgayTinhTrangGQ IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY_GQ)
                                 AND (vDenNgayTinhTrangGQ IS NULL OR TL.NGAYTHULY<=VV_DENNGAY_GQ)
                                 AND TL.DONID=d.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM APS_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (vTuNgayTinhTrangGQ IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY_GQ)
                                 AND (vDenNgayTinhTrangGQ IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY_GQ)
                                 AND PTTL.DONID=d.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(vTinhTrangGQ=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (vTuNgayTinhTrangGQ IS NULL OR  d.NGAYTAO>=VV_TUNGAY_GQ) AND (vDenNgayTinhTrangGQ IS NULL OR d.NGAYTAO<=VV_DENNGAY_GQ) 
                )
               OR(vTinhTrangGQ=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM APS_DON_THAMPHAN PC 
                            WHERE PC.DONID=d.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (vTuNgayTinhTrangGQ IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY_GQ) AND (vDenNgayTinhTrangGQ IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY_GQ)  
                      )
               )
               or(vTinhTrangGQ=4 -- đã lên lịch họp
               AND ( EXISTS ( 
                            SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='DVARXX' --đưa vụ án ra xét xưaer
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=7
               ))
               )
               OR(vTinhTrangGQ=5 --Đang hoãn  
                   AND (
                     EXISTS (
                            SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(vTinhTrangGQ=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=d.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=d.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(vTinhTrangGQ=7 --Đã giải quyết xong
                     AND (   
                     EXISTS (       
                                    SELECT 'X' FROM APS_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (vTuNgayTinhTrangGQ IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY_GQ)
                                    AND BA.DONID=d.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE (instr(',DC,CVA,CNTT,TRAHS,',','||QDL.MA||',')>0
                                    --  Manh them các loại QD gây kết thúc khác
                                                    OR QD.loaiid in (15,10,3) OR QD.id in (422,423,23,70,425))
                                    AND (vTuNgayTinhTrangGQ IS NULL OR QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=d.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (vTuNgayTinhTrangGQ IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY_GQ)
                                    AND PTBA.DONID=d.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    AND (vTuNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=d.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                     or(vTinhTrangGQ = 8
                         AND (
                         EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                and QDL.MA = 'KMTTPS'
                                --and ba.sobanan is not null
                                AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                                 )                
                            OR EXISTS (
                                SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'KMTTPS'
                                --and PTBA.sobanan is not null
                                AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                                )    
                           )
                     )
                     or(vTinhTrangGQ = 9
                         AND (
                         EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'MTTPS'
                                and ba.sobanan is not null
                                AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                                 )                
                            OR EXISTS (
                                SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'MTTPS'
                                and PTBA.sobanan is not null
                                AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                                )    
                           )
                     )
                     or(vTinhTrangGQ = 10
                         AND (
                         EXISTS (
                                SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV
                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                 LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                LEFT JOIN APS_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'DC'
                                AND QSV.DONID=d.ID AND GD.MAGIAIDOAN=2
                                 )                
                            OR EXISTS (
                                SELECT  'X' FROM   APS_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                LEFT JOIN APS_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                                LEFT JOIN APS_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                                WHERE (vTuNgayTinhTrangGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                AND (vDenNgayTinhTrangGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                and qdl.MA = 'DC'
                                AND PTQDVA.DONID=d.ID AND GD.MAGIAIDOAN=3
                                )    
                           )
                     )
               )
             -- END vTinhTrangGQ
             AND (vThoiHanGQ IS NULL
                 OR (vThoiHanGQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM APS_SOTHAM_THULY TL
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM APS_SOTHAM_THULY TL
                                        LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (vThoiHanGQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM APS_SOTHAM_THULY TL
                                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (vThoiHanGQ=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM APS_SOTHAM_THULY TL
                                    LEFT JOIN APS_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM APS_PHUCTHAM_THULY TL 
                                    LEFT JOIN APS_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN APS_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =d.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                ) 
        AND(vchecktk=0 or (select count(*) from APS_Don_ThamPhan TP WHERE TP.DONID=d.ID and TP.THUKYID=vchecktk  and TP.MAVAITRO=DECODE(d.MAGIAIDOAN,2,'VTTP_GIAIQUYETSOTHAM',3,'VTTP_GIAIQUYETPHUCTHAM',''))>0)
        AND (vSoQD IS NULL--Số BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoQD||'%' AND d.ID=QSV.DONID  )
                 )
            )
        AND (vNgayQD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayQD AND d.ID=QSV.DONID  )
                 )
             )
        AND d.ID <> V_DONID_GOC --lấy all trừ vụ việc gốc
    ), cte_Total AS (
        SELECT COUNT(ID) AS Total FROM cte_Data
    ), cte_Final AS(
    select ROW_NUMBER() OVER (ORDER BY a.NGAYNHANDON desc) STT,a.ID,a.MAVUVIEC,a.TENVUVIEC,a.SOTHUTU,a.NGAYNHANDON,a.NGUOITAO,a.NGAYTAO,a.QUANHEPL,a.MAGIAIDOAN,a.TOASOTHAM,
        a.HINHTHUCNHANDON,a.GiaiDoanVuViec,a.TenHinhThuc,a.TruongHopGiaoNhan,a.CHECK_THULY,a.THULYXXLAI,a.TINHTRANG_GQ,a.TenToaSoTham,a.BANAN_QD_ST,a.KHANGNGHI_ST,a.HoTenBiCan,A.BAPT,(select Total from cte_Total) as CountAll
    from cte_Data a
  )
    select a.*
    from cte_Final a where a.STT between MinIndex and MaxIndex;
END APS_DON_CON_SEARCH;

END VT_PKG_STPT_DS;

/
