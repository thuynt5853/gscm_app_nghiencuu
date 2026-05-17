--------------------------------------------------------
--  DDL for Package Body PKG_APS_STPT_DS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_APS_STPT_DS" AS

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
	V_VAITRO_THAMPHAN IN VARCHAR2,
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
        DECODE(GD.MAGIAIDOAN,2, d.NGUOITAO,3,GN.NGUOITAO_PHUCTHAM,'') NGUOITAO,      
        DECODE(GD.MAGIAIDOAN,2, to_char(d.NGAYTAO,'dd/MM/yyyy')||'<br/>'||to_char(d.NGAYTAO,' HH24:MI:SS'),
                            3, to_char(GN.NGAYTAO_PHUCTHAM,'dd/MM/yyyy')||'<br/>'||to_char(GN.NGAYTAO_PHUCTHAM,' HH24:MI:SS'),
                            '') NGAYTAO,
        --TO_CHAR(d.NGAYTAO,'dd/MM/yyyy HH24:MI:SS') as NGAYTAO,
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
      LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM FROM DM_DATAITEM i 
                     INNER JOIN APS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaXetXu group by CA.VUANID,i.TEN  , CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM
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


      Where  

     (d.TOAANID=vdonviID Or (d.TOAPHUCTHAMID=vdonviID And d.MAGIAIDOAN=PHUCTHAM))

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
        d.ID,
        d.MAVUVIEC,
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

END PKG_APS_STPT_DS;
