--------------------------------------------------------
--  DDL for Package Body PKG_DONCHOXL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DONCHOXL" AS

  PROCEDURE GET_DON_CHOXULY
(
    v_toa_an_id IN VARCHAR2,
    vNguonDen IN number,
    vNguoiGuiDon IN VARCHAR2,
    vLoaian in number,
    vSoLuongDon in number,
    vLoaiDon IN number,
    vNoiDungDon IN VARCHAR2,
    vSoDenTu in number,
    vDen in number,
    vLoaiNgay IN number,
    vTuNgay IN VARCHAR2,
    vDenNgay in VARCHAR2,
    vTrangThai in number,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
) IS TotalItem number; MinIndex number; MaxIndex number; V_TUNGAY date;V_DENNGAY date;
  BEGIN
    MinIndex := vPageSize*(vPageIndex - 1) + 1; 
    MaxIndex := vPageIndex*vPageSize ;
    ----------
    if(vTuNgay IS NOT NULL) then  V_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(vDenNgay IS NOT NULL) then  V_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
    -- TODO: Implementation required for PROCEDURE PKG_DONCHOXL.GET_DON_CHOXULY
    -----------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT ROW_NUMBER() OVER (ORDER BY A.NGAYCHUYEN desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.NGUONDEN,
        CASE WHEN A.LOAIVANBAN=1 THEN 'Đơn khởi kiện'  WHEN A.LOAIVANBAN=2 THEN 'Đơn kháng cáo' Else 'Đơn khác' END AS LOAIDON, 
        CASE WHEN A.LOAIAN=1 THEN 'Hình sự'  
             WHEN A.LOAIAN=2 THEN 'Dân sự'
             WHEN A.LOAIAN=3 THEN 'HN & GĐ'  
             WHEN A.LOAIAN=4 THEN 'KD, TM'
             WHEN A.LOAIAN=5 THEN 'Lao động'  
             WHEN A.LOAIAN=6 THEN 'Hành chính'
             WHEN A.LOAIAN=7 THEN 'Phá sản'
             Else '' END AS LOAIAN, 
        A.SODEN, A.NGAYDEN,    
        DECODE(A.LOAIVANBAN, 1, 'Người gửi: <b>' || A.NGUOIGUI || '</b><br>Địa chỉ: <b>' || A.DCGUI_CHITIET || ', ' || dm.MA_TEN
        || '</b><br>Người khởi kiện: <b>' || NKK.HOTEN || '</b><br>Năm sinh: <b>' || NKK.NAMSINH || '</b><br>CMNN/CCCD: <b>' || NKK.SOCMND
        || '</b><br>Người bị kiện: <b>' || BKK.HOTEN || '</b><br>Năm sinh: <b>' || BKK.NAMSINH || '</b><br>CMNN/CCCD: <b>' || BKK.SOCMND || '</b>',
        2, 'Người gửi: <b>' || A.NGUOIGUI || '</b><br>Địa chỉ: <b>' || A.DCGUI_CHITIET || ', ' || dm.MA_TEN
        || '</b><br>Người kháng cáo: <b>' || NKC.HOTEN || '</b><br>Năm sinh: <b>' || NKC.NAMSINH || '</b><br>CMNN/CCCD: <b>' || NKC.SOCMND
        || '</b><br>BA/QĐ bị KC: Số <b>' || A.SO_BAQD || '</b> ngày <b>' || TO_CHAR(A.NGAY_BAQD, 'dd/MM/yyyy' )|| '</b>',
        'Người đứng đơn: <b>' || NK.HOTEN || '</b><br>Năm sinh: <b>' || NK.NAMSINH || '</b><br>CMNN/CCCD: <b>' || NK.SOCMND || '</b>') AS NGUOIGUI,                
        DECODE(A.LOAIVANBAN, 1, A.NOIDUNGKHOIKIEN, A.NOIDUNGKHANGCAO) AS NOIDUNGDON, A.SLDON,
        CASE WHEN A.TRANGTHAI=0 THEN 'Đã trả lại' WHEN A.TRANGTHAI=1 THEN 'Chưa xử lý' WHEN A.TRANGTHAI=5 THEN 'Đã thu hồi' ELSE 'Đã tiếp nhận' END AS TRANGTHAI, A.TRANGTHAI AS TRANGTHAI_MA, A.ID_VBDH
        FROM DON_GUINHAN A     
        LEFT JOIN DM_HANHCHINH dm ON dm.ID = A.DCGUI
        LEFT JOIN DON_GUINHAN_DUONGSU NKK on A.ID=NKK.ID_DON AND NKK.TUCACHTOTUNG='NGUYENDON' AND A.LOAIVANBAN=1
        LEFT JOIN DON_GUINHAN_DUONGSU BKK on A.ID=BKK.ID_DON AND BKK.TUCACHTOTUNG='BIDON' AND A.LOAIVANBAN=1
        LEFT JOIN DON_GUINHAN_DUONGSU NKC on A.ID=NKC.ID_DON AND NKC.NGUOIKHANGCAO=1 AND A.LOAIVANBAN=2
        LEFT JOIN DON_GUINHAN_DUONGSU NK on A.ID=NK.ID_DON AND NK.NGUOIKHANGCAO=2 AND A.LOAIVANBAN=3
        WHERE   (vNoiDungDon IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungDon)||'%' )
                                      OR ( LOWER(A.NOIDUNGKHANGCAO) LIKE  '%'||LOWER(vNoiDungDon)||'%' ))--Nội dung 
            AND (vNguonDen IS NULL  OR( A.NGUONDEN=vNguonDen) )
            AND (vNguoiGuiDon IS NULL  OR ( LOWER(A.NGUOIGUI) LIKE  '%'||LOWER(vNguoiGuiDon)||'%' ) 
            OR EXISTS(SELECT 'X' FROM DON_GUINHAN_DUONGSU d WHERE d.ID_DON = A.ID AND ( LOWER(D.HOTEN) LIKE  '%'||LOWER(vNguoiGuiDon)||'%' )))
            AND (vLoaian IS NULL  OR( A.LOAIAN=vLoaian) )
            AND (vSoLuongDon IS NULL  OR( A.SLDON=vSoLuongDon) )
            AND (vLoaiNgay IS NULL  
                OR(vLoaiNgay = 1 AND (vDenNgay IS NULL OR A.NGAYTAO <=V_DENNGAY) AND (vTuNgay IS NULL OR A.NGAYTAO>=V_TUNGAY ) )
                OR(vLoaiNgay = 2 AND (vDenNgay IS NULL OR A.NGAYDEN <=V_DENNGAY) AND (vTuNgay IS NULL  OR A.NGAYDEN>=V_TUNGAY ) ) 
                OR(vLoaiNgay = 3 AND (vDenNgay IS NULL OR A.NGAYDAUBUUDIEN <=V_DENNGAY) AND (vTuNgay IS NULL  OR A.NGAYDAUBUUDIEN>=V_TUNGAY ) ) 
                OR(vLoaiNgay = 4 AND (vDenNgay IS NULL OR A.ngaychuyen <=V_DENNGAY) AND (vTuNgay IS NULL  OR A.ngaychuyen>=V_TUNGAY ) ) 
                OR(vLoaiNgay = 5 AND (vDenNgay IS NULL OR A.NGAYNHAN <=V_DENNGAY) AND (vTuNgay IS NULL  OR A.NGAYNHAN>=V_TUNGAY ) )
            )
            AND ((vTrangThai IS NULL AND A.TRANGTHAI NOT IN (0,5)) 
                OR (vTrangThai = 0 AND A.TRANGTHAI=0)
                OR (vTrangThai = 5 AND A.TRANGTHAI=5)
                OR (vTrangThai = 1 AND A.TRANGTHAI=1)
                OR (vTrangThai = 2 AND A.TRANGTHAI IN (2,3,4))
                )
            AND v_toa_an_id = A.TOAAN_ID
            ORDER BY A.NGAYCHUYEN DESC
            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY;
  PROCEDURE GET_DON_CHOXULY_LICHSU
 (
    vDonID in number,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
 ) IS TotalItem number; MinIndex number; MaxIndex number;
  BEGIN
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    -----------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID,
        CASE WHEN A.THAOTAC=1 THEN 'Ghép đơn'  WHEN A.THAOTAC=2 THEN 'Trả lại' WHEN A.THAOTAC=3 THEN 'Tiếp nhận' END AS THAOTAC, 
        A.NGUOITAO, A.NGAYTAO, A.LYDOTRA
        FROM DON_GUINHAN_LICHSU A             
        WHERE  A.ID_VBDH = vDonID
            -----------
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_LICHSU;
  
  PROCEDURE GET_DON_CHOXULY_GHEPDON_ADS
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
)IS TotalItem number; MinIndex number; MaxIndex number; VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;VV_NGAYBA_TU DATE;VV_NGAYBA_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
  BEGIN
    V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
    -----------------------
    if(V_NGAYBA_TU IS NOT NULL) then  VV_NGAYBA_TU:=to_date(trim(V_NGAYBA_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_NGAYBA_DEN IS NOT NULL) then  VV_NGAYBA_DEN:=to_date(trim(V_NGAYBA_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
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
     ---------------------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.MAVUVIEC
        , 'Vụ việc : ' || A.TENVUVIEC || '<br>Cấp xét xử: ' || DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') AS TENVUVIEC
        , DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               )  AS TINHTRANGGIAIQUYET,
        nd.TENDUONGSU || '<br>' || nd.SOCMND || '<br>' || nd.NAMSINH AS NGUYENDON, bd.TENDUONGSU AS BIDON
        FROM ADS_DON A
        INNER JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.DONID
        LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM ADS_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
         LEFT JOIN (
              SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
              INNER JOIN ADS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
              GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
              )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2      
        LEFT JOIN ADS_DON_DUONGSU nd ON nd.DONID = A.ID AND nd.tucachtotung_ma='NGUYENDON' AND nd.isdaidien = 1
        LEFT JOIN ADS_DON_DUONGSU bd ON bd.DONID = A.ID AND bd.tucachtotung_ma='BIDON' AND bd.isdaidien = 1
        WHERE  (vTenVuViec IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%' ) )
        AND (vMaVuViec IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%' ) )
        AND (vNoiDungKK IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungKK)||'%' ) )
        AND (vNguoiKhoiKien IS NULL  OR ( LOWER(nd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiKhoiKien)||'%' ) )
        AND (vNamSinh IS NULL  OR nd.NAMSINH = vNamSinh )
        AND (vSoCMND IS NULL  OR ( LOWER(nd.socmnd) LIKE  '%'||LOWER(vSoCMND)||'%' ) )
        AND (vNguoiBiKien IS NULL  OR ( LOWER(bd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiBiKien)||'%' ) )
        AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
        AND (TLS.DONID IS NOT NULL  OR TLPT.DONID IS NOT NULL)
        AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))
        AND (
           (TLS.DONID IS NOT NULL 
                              AND  (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                             )
            OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    
        ) 
        
        AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )  
        AND (   EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
             ) 
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_ADS;
  
  PROCEDURE GET_DON_CHOXULY_GHEPDON_AHN
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
)IS TotalItem number; MinIndex number; MaxIndex number;VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;VV_NGAYBA_TU DATE;VV_NGAYBA_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
  BEGIN
    V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    -----------------------
    if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
    -----------------------
    if(V_NGAYBA_TU IS NOT NULL) then  VV_NGAYBA_TU:=to_date(trim(V_NGAYBA_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(V_NGAYBA_DEN IS NOT NULL) then  VV_NGAYBA_DEN:=to_date(trim(V_NGAYBA_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
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
     ---------------------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.MAVUVIEC
        , 'Vụ việc : ' || A.TENVUVIEC || '<br>Cấp xét xử: ' || DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') AS TENVUVIEC
        , DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               )  AS TINHTRANGGIAIQUYET,
        nd.TENDUONGSU || '<br>' || nd.SOCMND || '<br>' || nd.NAMSINH AS NGUYENDON, bd.TENDUONGSU AS BIDON
        FROM AHN_DON A
        INNER JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.DONID
        LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AHN_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
        LEFT JOIN AHN_DON_DUONGSU nd ON nd.DONID = A.ID AND nd.tucachtotung_ma='NGUYENDON' AND nd.isdaidien = 1
        LEFT JOIN AHN_DON_DUONGSU bd ON bd.DONID = A.ID AND bd.tucachtotung_ma='BIDON' AND bd.isdaidien = 1
        WHERE  (vTenVuViec IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%' ) )
        AND (vMaVuViec IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%' ) )
        AND (vNoiDungKK IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungKK)||'%' ) )
        AND (vNguoiKhoiKien IS NULL  OR ( LOWER(nd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiKhoiKien)||'%' ) )
        AND (vNamSinh IS NULL  OR nd.NAMSINH = vNamSinh )
        AND (vSoCMND IS NULL  OR ( LOWER(nd.socmnd) LIKE  '%'||LOWER(vSoCMND)||'%' ) )
        AND (vNguoiBiKien IS NULL  OR ( LOWER(bd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiBiKien)||'%' ) )
        AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
        AND (TLS.DONID IS NOT NULL  OR TLPT.DONID IS NOT NULL)
        AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))
        AND (
           (TLS.DONID IS NOT NULL 
                              AND  (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                             )
            OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    
        ) 
        AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )        
        AND (   EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
             ) 
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_AHN;
  PROCEDURE GET_DON_CHOXULY_GHEPDON_AHC
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
)IS TotalItem number; MinIndex number; MaxIndex number;VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;VV_NGAYBA_TU DATE;VV_NGAYBA_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
  BEGIN
    V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    -----------------------
    if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
    -----------------------
    if(V_NGAYBA_TU IS NOT NULL) then  VV_NGAYBA_TU:=to_date(trim(V_NGAYBA_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(V_NGAYBA_DEN IS NOT NULL) then  VV_NGAYBA_DEN:=to_date(trim(V_NGAYBA_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
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
     ---------------------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.MAVUVIEC
        , 'Vụ việc : ' || A.TENVUVIEC || '<br>Cấp xét xử: ' || DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') AS TENVUVIEC
        , DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               )  AS TINHTRANGGIAIQUYET,
        nd.TENDUONGSU || '<br>' || nd.SOCMND || '<br>' || nd.NAMSINH AS NGUYENDON, bd.TENDUONGSU AS BIDON
        FROM AHC_DON A
        INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
        LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AHC_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
        LEFT JOIN AHC_DON_DUONGSU nd ON nd.DONID = A.ID AND nd.tucachtotung_ma='NGUYENDON' AND nd.isdaidien = 1
        LEFT JOIN AHC_DON_DUONGSU bd ON bd.DONID = A.ID AND bd.tucachtotung_ma='BIDON' AND bd.isdaidien = 1
        WHERE  (vTenVuViec IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%' ) )
        AND (vMaVuViec IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%' ) )
        AND (vNoiDungKK IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungKK)||'%' ) )
        AND (vNguoiKhoiKien IS NULL  OR ( LOWER(nd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiKhoiKien)||'%' ) )
        AND (vNamSinh IS NULL  OR nd.NAMSINH = vNamSinh )
        AND (vSoCMND IS NULL  OR ( LOWER(nd.socmnd) LIKE  '%'||LOWER(vSoCMND)||'%' ) )
        AND (vNguoiBiKien IS NULL  OR ( LOWER(bd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiBiKien)||'%' ) )
        AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
        AND (TLS.DONID IS NOT NULL  OR TLPT.DONID IS NOT NULL)
        AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))
        AND (
           (TLS.DONID IS NOT NULL 
                              AND  (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                             )
            OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    
        ) 
        AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )  
        AND (   EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
             ) 
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_AHC;
  PROCEDURE GET_DON_CHOXULY_GHEPDON_AKT
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
)IS TotalItem number; MinIndex number; MaxIndex number;VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;VV_NGAYBA_TU DATE;VV_NGAYBA_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
  BEGIN
    V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    -----------------------
    if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
    -----------------------
    if(V_NGAYBA_TU IS NOT NULL) then  VV_NGAYBA_TU:=to_date(trim(V_NGAYBA_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(V_NGAYBA_DEN IS NOT NULL) then  VV_NGAYBA_DEN:=to_date(trim(V_NGAYBA_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
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
     ---------------------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.MAVUVIEC
        , 'Vụ việc : ' || A.TENVUVIEC || '<br>Cấp xét xử: ' || DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') AS TENVUVIEC
        , DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               )  AS TINHTRANGGIAIQUYET,
        nd.TENDUONGSU || '<br>' || nd.SOCMND || '<br>' || nd.NAMSINH AS NGUYENDON, bd.TENDUONGSU AS BIDON
        FROM AKT_DON A
        INNER JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.DONID
        LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM AKT_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
        LEFT JOIN AKT_DON_DUONGSU nd ON nd.DONID = A.ID AND nd.tucachtotung_ma='NGUYENDON' AND nd.isdaidien = 1
        LEFT JOIN AKT_DON_DUONGSU bd ON bd.DONID = A.ID AND bd.tucachtotung_ma='BIDON' AND bd.isdaidien = 1
        WHERE  (vTenVuViec IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%' ) )
        AND (vMaVuViec IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%' ) )
        AND (vNoiDungKK IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungKK)||'%' ) )
        AND (vNguoiKhoiKien IS NULL  OR ( LOWER(nd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiKhoiKien)||'%' ) )
        AND (vNamSinh IS NULL  OR nd.NAMSINH = vNamSinh )
        AND (vSoCMND IS NULL  OR ( LOWER(nd.socmnd) LIKE  '%'||LOWER(vSoCMND)||'%' ) )
        AND (vNguoiBiKien IS NULL  OR ( LOWER(bd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiBiKien)||'%' ) )
        AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
        AND (TLS.DONID IS NOT NULL  OR TLPT.DONID IS NOT NULL)
        AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))
        AND (
           (TLS.DONID IS NOT NULL 
                              AND  (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                             )
            OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    
        ) 
        AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )        
        AND (   EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
             ) 
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_AKT;
  PROCEDURE GET_DON_CHOXULY_GHEPDON_ALD
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
)IS TotalItem number; MinIndex number; MaxIndex number;VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;VV_NGAYBA_TU DATE;VV_NGAYBA_DEN DATE;
    V_TABLE_TLST T_QUYETDINH_EXT;V_TABLE_TLPT T_QUYETDINH_EXT;
    V_TABLE_HDXX_ST T_QUYETDINH_EXT;V_TABLE_HDXX_PT T_QUYETDINH_EXT;  
    V_TABLE_TP T_QUYETDINH_EXT;
    V_TABLE_ST T_QUYETDINH_EXT;V_TABLE_PT T_QUYETDINH_EXT;
  BEGIN
    V_TABLE_TLST := T_QUYETDINH_EXT();  V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT(); V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_ST := T_QUYETDINH_EXT();V_TABLE_PT := T_QUYETDINH_EXT();
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    -----------------------
    if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
    -----------------------
    if(V_NGAYBA_TU IS NOT NULL) then  VV_NGAYBA_TU:=to_date(trim(V_NGAYBA_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(V_NGAYBA_DEN IS NOT NULL) then  VV_NGAYBA_DEN:=to_date(trim(V_NGAYBA_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
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
     ---------------------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.MAVUVIEC
        , 'Vụ việc : ' || A.TENVUVIEC || '<br>Cấp xét xử: ' || DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') AS TENVUVIEC
        , DECODE(XLD.LOAIGIAIQUYET,1,'- Đã chuyển đơn',CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
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
               )  AS TINHTRANGGIAIQUYET,
        nd.TENDUONGSU || '<br>' || nd.SOCMND || '<br>' || nd.NAMSINH AS NGUYENDON, bd.TENDUONGSU AS BIDON
        FROM ALD_DON A
        INNER JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.DONID
        LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
        LEFT JOIN (
                    SELECT DONID,LOAIGIAIQUYET,NGAYGQ_YC FROM ALD_DON_XULY 
                                        WHERE LOAIGIAIQUYET IN (1,5)
                )XLD ON A.ID = XLD.DONID
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
        LEFT JOIN ALD_DON_DUONGSU nd ON nd.DONID = A.ID AND nd.tucachtotung_ma='NGUYENDON' AND nd.isdaidien = 1
        LEFT JOIN ALD_DON_DUONGSU bd ON bd.DONID = A.ID AND bd.tucachtotung_ma='BIDON' AND bd.isdaidien = 1
        WHERE  (vTenVuViec IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%' ) )
        AND (vMaVuViec IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%' ) )
        AND (vNoiDungKK IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungKK)||'%' ) )
        AND (vNguoiKhoiKien IS NULL  OR ( LOWER(nd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiKhoiKien)||'%' ) )
        AND (vNamSinh IS NULL  OR nd.NAMSINH = vNamSinh )
        AND (vSoCMND IS NULL  OR ( LOWER(nd.socmnd) LIKE  '%'||LOWER(vSoCMND)||'%' ) )
        AND (vNguoiBiKien IS NULL  OR ( LOWER(bd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiBiKien)||'%' ) )
        AND( (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
             )
        AND (TLS.DONID IS NOT NULL  OR TLPT.DONID IS NOT NULL)
        AND (V_SOTHULY IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(V_SOTHULY) OR UPPER(TLPT.SOTHULY)=UPPER(V_SOTHULY) ))
        AND (
           (TLS.DONID IS NOT NULL 
                              AND  (V_NGAYTHULY_TU IS NULL OR  TLS.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLS.NGAYTHULY<=VV_NGAYTHULY_DEN)
                             )
            OR (TLPT.DONID IS NOT NULL
                              AND (V_NGAYTHULY_TU IS NULL OR  TLPT.NGAYTHULY>=VV_NGAYTHULY_TU) 
                              AND (V_NGAYTHULY_DEN IS NULL OR TLPT.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                             )    
        ) 
        AND (V_SO_QD IS NULL--Số BA/QĐ
                 OR  (    EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                       OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||V_SO_QD||'%' AND A.ID=QSV.DONID  )
                     )
                )        
        AND (   EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYMOPHIENTOA>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYMOPHIENTOA<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.DONID  )
             ) 
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_ALD;
  PROCEDURE GET_DON_CHOXULY_GHEPDON_APS
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id IN VARCHAR2,
    vMaVuViec IN VARCHAR2,
    vTenVuViec IN VARCHAR2,
    vNguoiKhoiKien in VARCHAR2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    vNguoiBiKien IN VARCHAR2,
    vNoiDungKK in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
)IS TotalItem number; MinIndex number; MaxIndex number;
    PHUCTHAM number DEFAULT 3;
  BEGIN
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
     ---------------------------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY A.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll, 
        A.ID, A.MAVUVIEC
        , 'Vụ việc : ' || A.TENVUVIEC || '<br>Thụ lý sơ thẩm: ' || t.TEN AS TENVUVIEC
        , 'QHPL: ' || i.TEN  || '<br>Hình thức nhận đơn: ' || A.HINHTHUCNHANDON 
        || '<br>Giai đoạn: ' || (Case A.MAGIAIDOAN when 1 then 'Hồ sơ' when 2 then 'Sơ thẩm' when 3 then 'Phúc thẩm' when 4 then 'GĐT, TT' End)
        AS TINHTRANGGIAIQUYET,
        nd.TENDUONGSU || '<br>' || nd.SOCMND || '<br>' || nd.NAMSINH AS NGUYENDON, bd.TENDUONGSU AS BIDON
        FROM APS_DON A
        left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
        left join DM_TOAAN t on A.TOAANID=t.ID                     
        LEFT JOIN APS_DON_DUONGSU nd ON nd.DONID = A.ID AND nd.tucachtotung_ma='NGUYENDON' AND nd.isdaidien = 1
        LEFT JOIN APS_DON_DUONGSU bd ON bd.DONID = A.ID AND bd.tucachtotung_ma='BIDON' AND bd.isdaidien = 1
        WHERE  (vTenVuViec IS NULL  OR ( LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%' ) )
        AND (vMaVuViec IS NULL  OR ( LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%' ) )
        AND (vNoiDungKK IS NULL  OR ( LOWER(A.NOIDUNGKHOIKIEN) LIKE  '%'||LOWER(vNoiDungKK)||'%' ) )
        AND (vNguoiKhoiKien IS NULL  OR ( LOWER(nd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiKhoiKien)||'%' ) )
        AND (vNamSinh IS NULL  OR nd.NAMSINH = vNamSinh )
        AND (vSoCMND IS NULL  OR ( LOWER(nd.socmnd) LIKE  '%'||LOWER(vSoCMND)||'%' ) )
        AND (vNguoiBiKien IS NULL  OR ( LOWER(bd.TENDUONGSU) LIKE  '%'||LOWER(vNguoiBiKien)||'%' ) )
        AND (A.TOAANID=v_toaan_id Or (A.TOAPHUCTHAMID=v_toaan_id And A.MAGIAIDOAN=PHUCTHAM))
    )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_APS;
  
  PROCEDURE GET_DON_CHOXULY_GHEPDON_AHS
(
    V_CAP_XET_XU_LOGIN  IN VARCHAR2,
    v_toaan_id in varchar2, 
    v_ten_vu_an in varchar2, 
    v_ma_vu_an in varchar2, 
    v_bi_can in varchar2,
    vSoCMND in VARCHAR2,
    vNamSinh IN number,
    v_SOTHULY IN VARCHAR2,
    V_NGAYTHULY_TU IN VARCHAR2,
    V_NGAYTHULY_DEN in VARCHAR2,
    v_so_qd in VARCHAR2,
    V_NGAYBA_TU IN VARCHAR2,
    V_NGAYBA_DEN in VARCHAR2,
    vPageIndex	in	int,
    vPageSize	in	int,
    CurReturn OUT sys_refcursor 
) AS 
TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_AHS_THAMPHANGIAIQUYET;
    VV_NGAYBA_TU DATE;VV_NGAYBA_DEN DATE;  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_TLST T_QUYETDINH;V_TABLE_TLPT T_QUYETDINH;
    V_TABLE_HDXX_ST T_QUYETDINH;V_TABLE_HDXX_PT T_QUYETDINH;  
    V_TABLE_TP T_QUYETDINH;
    V_TABLE_ST T_QUYETDINH;V_TABLE_PT T_QUYETDINH;
    V_TABLE_BC T_AHS_BICANBICAO; V_TABLE_BC_KC T_AHS_BICANBICAO;        
BEGIN	
     V_TABLE_TLST := T_QUYETDINH();  V_TABLE_TLPT := T_QUYETDINH();
     V_TABLE_HDXX_ST := T_QUYETDINH(); V_TABLE_HDXX_PT := T_QUYETDINH();   
     V_TABLE_TP := T_QUYETDINH();
     V_TABLE_ST := T_QUYETDINH();V_TABLE_PT := T_QUYETDINH();
     V_TABLE_BC := T_AHS_BICANBICAO();V_TABLE_BC_KC := T_AHS_BICANBICAO();
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize;
    -------------------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_NGAYBA_TU IS NOT NULL) then  VV_NGAYBA_TU:=to_date(trim(V_NGAYBA_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_NGAYBA_DEN IS NOT NULL) then  VV_NGAYBA_DEN:=to_date(trim(V_NGAYBA_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
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
           LEFT JOIN (SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=v_toaan_id 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
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
            WHERE (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )
                AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  LOWER(V_MA_VU_AN) ) )
                AND (V_BI_CAN IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_BI_CAN))||'%' AND BC.VUANID=A.ID)
                    )                
            -----
                AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3))
                AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                                           ) 
                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                          )   )                
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
                 
              AND (   EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYBANAN>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYBANAN<=VV_NGAYBA_DEN) AND A.ID=QSV.VUANID  )
                   OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYBANAN>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYBANAN<=VV_NGAYBA_DEN) AND A.ID=QSV.VUANID  )
                   OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.VUANID  )
                   OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.VUANID  )
                   OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.VUANID  )
                   OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE (V_NGAYBA_TU IS NULL OR QSV.NGAYQD>=VV_NGAYBA_TU) 
                              AND (V_NGAYBA_DEN IS NULL OR QSV.NGAYQD<=VV_NGAYBA_DEN) AND A.ID=QSV.VUANID  )
             ) 
              ----------------------------    
       )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex;
  END GET_DON_CHOXULY_GHEPDON_AHS;
  
END PKG_DONCHOXL;

/
