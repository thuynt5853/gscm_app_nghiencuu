--------------------------------------------------------
--  DDL for Package Body PKG_STPT_XLHC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_XLHC" AS

PROCEDURE XLHC_DON_SEARCH
( 
  vDonViID in varchar2,
  vTenViec in varchar2,
  vQuanHePhapLuat in varchar2,
  vMaViec in varchar2,
  vDoiTuongApDungBPXLHC in varchar2,
  vCapXetXu in varchar2,
  vToaXetXu in varchar2,
  vTinhTrangThuLy in varchar2,
  vTuNgayThuLy in varchar2,
  vDenNgayThuLy in varchar2,
  vSoThuLy in varchar2,
  vTinhTrangGQ in varchar2,
  vTuNgayGQ in varchar2,
  vDenNgayGQ in varchar2,
  vThamPhan in varchar2,
  vThoiHanGQ in varchar2,
  vSoQD in varchar2,
  vNgayQD in varchar2,
  vThuKy in varchar2,
  vPTRutKinhNghiem in varchar2,
  Page_Index in	int,
  Page_Size	in	int,
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
  VV_TUNGAY_GQ date;
  VV_DENNGAY_GQ date;
  V_TABLE_TLST T_QUYETDINH_EXT;
  V_TABLE_TLPT T_QUYETDINH_EXT;
  V_TABLE_HDXX_PT T_QUYETDINH_EXT;
  V_TABLE_TP T_QUYETDINH_EXT;
  V_TABLE_HDXX_ST T_QUYETDINH_EXT;
  V_TABLE_ST T_QUYETDINH;
  V_TABLE_PT T_QUYETDINH;
  V_TABLE_BC T_BICANBICAO_EXT;
  V_TABLE_BC_KC T_BICANBICAO_EXT;
BEGIN
    /* Giai đoạn vụ án/vụ việc
    HOSO = 1;
    SOTHAM = 2;
    PHUCTHAM = 3;
    THULYGDT = 4;
    DINHCHI = 5;
    */
    -- PhanCongTP=0 Tất cả
    -- PhanCongTP=1 Chưa phân công
    -- PhanCongTP=2 Đã phân công
    MinIndex := Page_Size*(Page_Index - 1) + 1;
    MaxIndex := Page_Index*Page_Size ;

    V_TABLE_TLST := T_QUYETDINH_EXT();
    V_TABLE_TLPT := T_QUYETDINH_EXT();
    V_TABLE_HDXX_PT := T_QUYETDINH_EXT();
    V_TABLE_TP := T_QUYETDINH_EXT();
    V_TABLE_ST := T_QUYETDINH();
    V_TABLE_HDXX_ST := T_QUYETDINH_EXT();
    V_TABLE_PT := T_QUYETDINH();
    V_TABLE_BC := T_BICANBICAO_EXT();
    V_TABLE_BC_KC := T_BICANBICAO_EXT();

    if(vTuNgayThuLy IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(vTuNgayThuLy)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;
    if(vDenNgayThuLy IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(vDenNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;
    if(vTuNgayGQ IS NOT NULL) then  VV_TUNGAY_GQ:=to_date(trim(vTuNgayGQ)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
    if(vDenNgayGQ IS NOT NULL) then  VV_DENNGAY_GQ:=to_date(trim(vDenNgayGQ)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;

    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  XLHC_SOTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLPT
        FROM( SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  XLHC_PHUCTHAM_THULY 
                )TT GROUP BY TT.DONID,TT.ID
        )TTS;
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TP
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYNHANPHANCONG DESC) ID
                 FROM  XLHC_DON_THAMPHAN 
                 WHERE MAVAITRO != 'VTTP_GIAIQUYETDON'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_PT
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  XLHC_PHUCTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;  
    SELECT R_QUYETDINH_EXT(TTS.DONID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_HDXX_ST
        FROM(SELECT TT.DONID,TT.ID FROM (  
                 SELECT DONID,FIRST_VALUE(CANBOID) OVER (PARTITION BY DONID ORDER BY NGAYTAO DESC) ID
                 FROM  XLHC_SOTHAM_HDXX WHERE MAVAITRO='THAMPHAN'
                )TT GROUP BY TT.DONID,TT.ID
            )TTS;
    SELECT R_QUYETDINH(TTS.donid,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_ST
            FROM(
             SELECT TT.donid,TT.ID,TT.MA FROM (  
                  SELECT PQD.donid,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.donid,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  XLHC_SOTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.donid,TT.ID,TT.MA
                )TTS;
    SELECT R_QUYETDINH(TTS.DONID,TTS.ID,TTS.MA)
            BULK COLLECT INTO V_TABLE_PT
            FROM( SELECT TT.DONID,TT.ID,TT.MA FROM (  
                  SELECT PQD.DONID,FIRST_VALUE(PQD.ID) OVER (PARTITION BY PQD.DONID,QDL.MA ORDER BY PQD.NGAYQD DESC,PQD.NGAYTAO DESC) ID
                  ,QDL.MA
                  FROM  XLHC_PHUCTHAM_QUYETDINH PQD
                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PQD.QUYETDINHID 
                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                  )TT GROUP BY TT.DONID,TT.ID,TT.MA
                )TTS;
    SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.hoten,TTS.trinhdovanhoaid,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.DONID,BC.hoten,BC.trinhdovanhoaid,BC.ROWNUMBER FROM 
                    (  SELECT ID,DONID,hoten,trinhdovanhoaid,ROW_NUMBER()  OVER (PARTITION BY DONID order by id) ROWNUMBER
                       FROM XLHC_DUONGSU
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;
    SELECT R_BICANBICAO_EXT(TTS.ID,TTS.DONID,TTS.hoten,TTS.trinhdovanhoaid,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.DONID,BC.hoten,BC.trinhdovanhoaid,BC.ROWNUMBER FROM 
                    (  SELECT DS.ID,DS.DONID,DS.hoten,DS.trinhdovanhoaid,ROW_NUMBER()  OVER (PARTITION BY DS.DONID ORDER BY ds.id) ROWNUMBER
                       FROM XLHC_DUONGSU DS
                       WHERE EXISTS(SELECT 'X' FROM XLHC_SOTHAM_KHANGCAO KC WHERE KC.DUONGSUID=DS.ID AND KC.DONID=DS.DONID)
                    )BC 
                where BC.ROWNUMBER <=3
            )TTS;   
    OPEN curReturn FOR
    WITH cte_Data AS(
      Select distinct(don.ID)
        ,don.MAVUVIEC
        ,don.TENVUVIEC
        ,don.SOTHUTU
        ,don.NGAYNHANDON
        ,don.NGUOITAO
        ,don.NGAYTAO
        ,item.TEN as QUANHEPL
        ,don.MAGIAIDOAN
        ,toa.TEN TOASOTHAM
        ,don.HINHTHUCNHANDON
        ,(Case don.MAGIAIDOAN when 1 then 'Hồ sơ' when 2 then 'Sơ thẩm' when 3 then 'Phúc thẩm' when 4 then 'GĐT, TT' End) GiaiDoanVuViec
        ,DECODE(don.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    GN.TruongHopGiaoNhan) TRUONGHOPGIAONHAN,
        nvl('</br><i>Tòa xét xử sơ thẩm: </i><b>'||toa.Ten||'</b>', '') TenToaSoTham
        ,(Case don.HINHTHUCNHANDON when 1 then 'Trực tiếp' when 2 then 'Qua bưu điện' when 3 then 'Trực tuyến' End) TenHinhThuc
        ,STBA.BANAN_QD_ST
        ,(BC3.HoTen||BC2.HoTen) HoTenBiCan
        ,STKN.KHANGNGHI_ST
        ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY
        ,CASE  WHEN (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NULL THEN '- Chưa thụ lý' 
                     ELSE (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) 
             END  ||
             CASE WHEN (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) IS NULL AND (TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) IS NOT NULL  THEN '</br>- Chưa phân công Thẩm phán' 
                 ELSE  (TPPC.TINHTRANG_GQ || TPPCPT.TINHTRANG_GQ) 
             END
             ||HPT.TINHTRANG_GQ||HPTPT.TINHTRANG_GQ
             ||TDC.TINHTRANG_GQ||TDCPT.TINHTRANG_GQ
             ||BAST.TINHTRANG_GQ||BAPT.TINHTRANG_GQ
             ||DCST.TINHTRANG_GQ||DCPT.TINHTRANG_GQ
             ||THSST.TINHTRANG_GQ||THSPT.TINHTRANG_GQ
             ||CPT.TINHTRANG_GQ || GNST.TINHTRANG_GQ
             ||CST.TINHTRANG_GQ
            TINHTRANG_GQ
        ,DECODE(BA.ID,null,DECODE(QD.ID,NULL,NULL,3),3) THULYXXLAI
      From XLHC_DON don
      INNER JOIN (SELECT G.* FROM XLHC_DON G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vToaXetXu) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vToaXetXu)) GD ON don.ID=GD.ID
      LEFT join XLHC_DUONGSU duongsu on don.ID = duongsu.DONID
      left join DM_DATAITEM item on don.QUANHEPHAPLUATID=item.ID
      left join DM_TOAAN toa on don.TOAANID=toa.ID
      LEFT JOIN (SELECT PTBA.* FROM XLHC_PHUCTHAM_BANAN PTBA WHERE  PTBA.SOBANAN IS NOT NULL) BA ON BA.donid = don.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
                     INNER JOIN XLHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=vToaXetXu group by CA.VUANID,i.TEN  
                      )GN ON  GN.VUANID=don.ID
      LEFT JOIN (SELECT PTQDVA.* FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA 
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE  instr(',DC,',','||QDL.MA||',')>0) QD ON QD.donid = don.ID AND GD.MAGIAIDOAN=3 
      LEFT JOIN(SELECT BA.DONID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYTUYENAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM XLHC_SOTHAM_BANAN BA)STBA ON STBA.DONID=don.ID 
      LEFT JOIN (
                  SELECT BC.DONID,
                 '<br /><i>Cơ quan đề nghị:</i> <br /><b>'|| 
                  listagg (BC.TENDUONGSU||' '|| '(người bị đề nghị)</b>')--decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC) BC
                  GROUP BY BC.DONID
                )BC2 ON BC2.DONID=don.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN ( 
                  SELECT BC.DONID,'<br /><i>Cơ quan đề nghị:</i><br/> <b>'|| 
                  listagg (BC.TENDUONGSU||' '|| '(người bị đề nghị)</b>')--decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC_KC) BC
                  GROUP BY BC.DONID
                )BC3 ON BC3.DONID=don.ID AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                       SELECT QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                       FROM XLHC_SOTHAM_QUYETDINH QSV 
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                       GROUP BY QSV.DONID,'</br>- QĐ CVA số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                     )CST ON  CST.DONID=don.id AND GD.MAGIAIDOAN=2   
      LEFT JOIN (
                  SELECT PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                  FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA 
                  WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',CVA,',','||QDL.MA||',')>0  )
                  GROUP BY PTQDVA.DONID,'</br>- QĐ CVA số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
                 )CPT ON  CPT.DONID=don.id AND GD.MAGIAIDOAN=3  
      LEFT JOIN (
                  SELECT CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án' TINHTRANG_GQ FROM DM_DATAITEM i 
                  INNER JOIN XLHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOACHUYENID=vToaXetXu 
                  GROUP BY CA.VUANID,'</br>- '||i.TEN||'</br>- Đã chuyển vụ án'
                  )GNST ON  GNST.VUANID=don.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (SELECT QSV.donid,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM XLHC_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',HPT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.donid,'</br>- QĐ HPT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                      )HPT ON HPT.donid=don.ID AND GD.MAGIAIDOAN=2 
      LEFT JOIN ( SELECT KN.donid,
                     '<br /><i>Kháng nghị:</i> <br /><b>'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/></b>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  XLHC_SOTHAM_KHANGNGHI KN
                      GROUP BY KN.donid
              )STKN ON STKN.donid=don.ID 
      LEFT JOIN (
            SELECT T2.DONID,T2.TOAANID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,T2.QHPLTKID ,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
            FROM GSCM.XLHC_SOTHAM_THULY T2
            WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=T2.ID)
         ) TLS ON TLS.DONID=don.ID AND GD.MAGIAIDOAN=2--Lấy lần thụ lý mới nhất là trường hợp có 2 lần thụ lý trong 1 đơn
      LEFT JOIN (
              SELECT PTQDVA.donid,'</br>- QĐ THS số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
              FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA 
              WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',TRAHS,',','||QDL.MA||',')>0  )
              GROUP BY PTQDVA.donid,'</br>- QĐ THS số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
             )THSPT ON  THSPT.donid=don.id AND GD.MAGIAIDOAN=3  
      LEFT JOIN (SELECT QSV.donid,'</br>- QĐ THS số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
               TINHTRANG_GQ FROM XLHC_SOTHAM_QUYETDINH QSV 
               --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
               WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',TRAHS,',','||QDL.MA||',')>0  ) 
               GROUP BY QSV.DONID,'</br>- QĐ THS số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
               )THSST ON  THSST.DONID=don.id AND GD.MAGIAIDOAN=2
      LEFT JOIN (
          SELECT PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
          FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA 
          WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID  AND instr(',DC,',','||QDL.MA||',')>0  )
          GROUP BY PTQDVA.DONID,'</br>- QĐ ĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
         )DCPT ON  DCPT.DONID=don.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (SELECT QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       TINHTRANG_GQ FROM XLHC_SOTHAM_QUYETDINH QSV 
                       --chi lay 1 gia tri dau tien moi nhat dung,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTAO DESC)
                       WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',DC,',','||QDL.MA||',')>0  ) 
                       GROUP BY QSV.DONID,'</br>- QĐ ĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )DCST ON  DCST.DONID=don.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM XLHC_PHUCTHAM_BANAN PTBA 
            WHERE  PTBA.SOBANAN IS NOT NULL
            GROUP BY PTBA.DONID,'</br>- Bản án số: '||PTBA.SOBANAN||' ngày '||to_char(PTBA.NGAYTUYENAN,'dd/MM/yyyy')
           )BAPT ON  BAPT.DONID=don.id AND GD.MAGIAIDOAN=3
      LEFT JOIN ( SELECT PTQDVA.donid,'</br>- QĐ HPT số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')TINHTRANG_GQ 
            FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
            WHERE  EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND  instr(',HPT,',','||QDL.MA||',')>0)
            GROUP BY PTQDVA.donid,'</br>- QĐ HPT số: '|| PTQDVA.SOQd ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
            )HPTPT ON  HPTPT.donid=don.id  AND GD.MAGIAIDOAN=3
      LEFT JOIN (
            SELECT BA.donid,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM XLHC_SOTHAM_BANAN BA
            WHERE  BA.SOBANAN IS NOT NULL
            GROUP BY BA.donid,'</br>- Bản án số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
            )BAST ON  BAST.donid=don.id AND GD.MAGIAIDOAN=2
      LEFT JOIN ( SELECT PTQDVA.donid,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ 
                FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_PT)QDL WHERE QDL.ID=PTQDVA.ID AND instr(',TDC,',','||QDL.MA||',')>0  ) 
                GROUP BY PTQDVA.donid,'</br>- QĐ TĐC số: '|| PTQDVA.SOQD ||' ngày '||to_char(PTQDVA.NGAYQD,'dd/MM/yyyy')
               )TDCPT ON  TDCPT.donid=don.id AND GD.MAGIAIDOAN=3
      LEFT JOIN (
                SELECT QSV.donid,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                TINHTRANG_GQ FROM XLHC_SOTHAM_QUYETDINH QSV
                WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND  instr(',TDC,',','||QDL.MA||',')>0 ) 
                GROUP BY QSV.donid,'</br>- QĐ TĐC số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
               )TDC ON  TDC.donid=don.id AND GD.MAGIAIDOAN=2

      LEFT JOIN (
             SELECT T2.DONID,T2.NGAYTHULY,T2.SOTHULY,T2.TRUONGHOPTHULY,'</br>- Thụ lý số:<b> '|| to_char(T2.SOTHULY) ||'</b> ngày<b> '||TO_CHAR(T2.NGAYTHULY,'dd/MM/yyyy')||'</b>' TINHTRANG_GQ
              FROM GSCM.XLHC_PHUCTHAM_THULY T2
--                  manhnd tam bo de test thu ly GDT huy
              WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLPT) QDL WHERE QDL.ID=T2.ID)--> Lấy thụ lý mới nhất
              ) TLPT ON TLPT.DONID=don.ID  AND GD.MAGIAIDOAN=3 
      LEFT JOIN (
                        SELECT QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy') TINHTRANG_GQ
                        FROM XLHC_SOTHAM_QUYETDINH QSV
                        WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_ST)QDL WHERE QDL.ID=QSV.ID AND instr(',CNTT,',','||QDL.MA||',')>0 ) 
                        GROUP BY QSV.DONID,'</br>- QĐ CNTT số: '|| QSV.SOQD ||' ngày '||to_char(QSV.NGAYQD,'dd/MM/yyyy')
                       )CNTT ON  CNTT.DONID=don.id AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                    SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                    FROM XLHC_DON_THAMPHAN TP
                    LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_ST) )HD ON HD.DONID=TP.DONID
                    LEFT JOIN ( SELECT GG.* FROM XLHC_DON_THAMPHAN GG
                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID  
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=don.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                FROM XLHC_DON_THAMPHAN TP
                LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
                LEFT JOIN (SELECT GG.* FROM XLHC_DON_THAMPHAN GG
                            WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
                           )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                LEFT JOIN DM_CANBO CB ON CB.ID=PCTP_GQ.CANBOID   
                WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
    )TPPCPT ON TPPCPT.DONID=don.ID  AND GD.MAGIAIDOAN=3
      Where (don.TOAANID=vDonViID Or (don.TOAPHUCTHAMID=vDonViID And don.MAGIAIDOAN=PHUCTHAM))
          and (1=(CASE WHEN (vMaViec|| ' ')=' ' THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(vMaViec) || '%') THEN 1 END))
          and (1=(CASE WHEN (vTenViec|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(vTenViec) || '%') THEN 1 Else 0 END))
          and (1=(CASE WHEN vQuanHePhapLuat is null THEN 1 WHEN don.QUANHEPHAPLUATID=vQuanHePhapLuat THEN 1 Else 0 END))
          and (vDoiTuongApDungBPXLHC IS NULL OR (LOWER(duongsu.HOTEN) like '%' || LOWER(vDoiTuongApDungBPXLHC) || '%') )
          AND (vCapXetXu IS NULL OR (GD.MAGIAIDOAN=vCapXetXu ))--Cấp xét xử
          AND ( (vTinhTrangThuLy IS NULL AND (vtungaythuly IS NULL OR  don.NGAYTAO>=VV_NGAYTHULY_TU) AND (vDenNgayThuLy IS NULL OR don.NGAYTAO<=VV_NGAYTHULY_DEN))--Tình trạng thụ lý
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
                  OR(vTinhTrangThuLy=2 AND (TLS.DONID IS NULL AND TLPT.DONID IS NULL)
                     AND (vtungaythuly IS NULL OR  don.NGAYTAO>=VV_NGAYTHULY_TU) 
                     AND (vDenNgayThuLy IS NULL OR don.NGAYTAO<=VV_NGAYTHULY_DEN)   
                   ) )
          AND (vSoThuLy IS NULL OR(UPPER(TLS.SOTHULY)=UPPER(vSoThuLy) OR UPPER(TLPT.SOTHULY)=UPPER(vSoThuLy) ))--Số Thụ lý
          AND( (vTinhTrangGQ IS NULL AND (vTuNgayGQ IS NULL OR  don.NGAYTAO>=VV_TUNGAY_GQ) AND (vDenNgayGQ IS NULL OR don.NGAYTAO<=VV_DENNGAY_GQ) )
             OR(vTinhTrangGQ=1 --Chưa giải quyết xong
                   AND 
                    (EXISTS (
                                SELECT 'X' FROM XLHC_SOTHAM_THULY TL
                                  WHERE (NOT EXISTS(SELECT 'X' FROM XLHC_SOTHAM_BANAN BA WHERE TL.DONID =BA.DONID)
                                        AND (NOT EXISTS(SELECT T1.DONID,T2.MA FROM XLHC_SOTHAM_QUYETDINH T1 
                                                   LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID 
                                                   INNER JOIN DM_QD_LOAI T2 ON T2.ID=QD.LOAIID
                                                   WHERE instr(',DC,CVA,CNTT,',','||T2.MA||',')>0 AND TL.DONID=T1.DONID) )
                                        )
                                 AND (vTuNgayGQ IS NULL OR   TL.NGAYTHULY>=VV_TUNGAY_GQ)
                                 AND (vDenNgayGQ IS NULL OR TL.NGAYTHULY<=VV_DENNGAY_GQ)
                                 AND TL.DONID=don.id  AND GD.MAGIAIDOAN=2
                               )
                     OR EXISTS (
                                SELECT 'X' FROM XLHC_PHUCTHAM_THULY PTTL 
                                 WHERE (NOT EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
                                        AND NOT EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                                       LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                                       LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                       WHERE instr(',DC,CVA,CNTT,',','||QDL.MA||',')>0 AND  PTTL.DONID=PTQDVA.DONID 
                                                       )
                                 )
                                 AND (vTuNgayGQ IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY_GQ)
                                 AND (vDenNgayGQ IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY_GQ)
                                 AND PTTL.DONID=don.id  AND GD.MAGIAIDOAN=3
                               )
                      )
                   )
             OR(vTinhTrangGQ=2 --chưa phân công Thẩm phán
                AND(TPPC.DONID IS NULL AND TPPCPT.DONID IS NULL )
                   AND (vTuNgayGQ IS NULL OR  don.NGAYTAO>=VV_TUNGAY_GQ) AND (vDenNgayGQ IS NULL OR don.NGAYTAO<=VV_DENNGAY_GQ) 
                )
               OR(vTinhTrangGQ=3 --đã phân công Thẩm phán
                   AND EXISTS (
                            SELECT 'x' FROM XLHC_DON_THAMPHAN PC 
                            WHERE PC.DONID=don.ID
                            AND (
                                 (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                 OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                 )
                            AND (vTuNgayGQ IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY_GQ) AND (vDenNgayGQ IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY_GQ)  
                      )
               )
               or(vTinhTrangGQ=4 -- đã lên lịch họp

               )
               OR(vTinhTrangGQ=5 --Đang hoãn  
                   AND (
                     EXISTS (
                            SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV
                             LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                             LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN XLHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='HPT' AND BA.ID IS NULL   -- QDL.MA ='HPT' --hoãn phiên tòa
                            AND (vTuNgayGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=don.ID AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT  'X' FROM   XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN XLHC_PHUCTHAM_THULY PTTL ON PTTL.DONID=PTQDVA.DONID 
                            LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTTL.DONID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID   
                            WHERE PTBA.DONID IS NULL  AND QDL.MA='HPT' --Vụ án chưa có bản án  --hoãn phiên tòa 
                            AND (vTuNgayGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=don.ID AND GD.MAGIAIDOAN=3
                            )    
                       )
                )
                 OR(vTinhTrangGQ=6 --Đang tạm đình chỉ 
                  --so tham Đang tạm đình chỉ 
                   AND 
                   (  EXISTS (
                            SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN XLHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                            WHERE QDL.MA ='TDC'   -- QDL.MA ='TDC' Tam dinh chi
                            AND BA.DONID IS NULL  -- chưa có bản án
                            AND (vTuNgayGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                            AND QSV.DONID=don.id  AND GD.MAGIAIDOAN=2
                         )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                            LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                            WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                            AND QDL.MA='TDC' --Tạm đình chỉ
                            AND (vTuNgayGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                            AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                            AND PTQDVA.DONID=don.id  AND GD.MAGIAIDOAN=3
                            )
                    )
                  )
                   ------------------------------
                  OR(vTinhTrangGQ=7 --Đã giải quyết xong
                     AND (   
                     EXISTS (       
                                    SELECT 'X' FROM XLHC_SOTHAM_BANAN BA
                                    WHERE  BA.SOBANAN IS NOT NULL
                                    AND (vTuNgayGQ IS NULL OR BA.NGAYTUYENAN>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR BA.NGAYTUYENAN<=VV_DENNGAY_GQ)
                                    AND BA.DONID=don.id  AND GD.MAGIAIDOAN=2
                                 )
                            OR  EXISTS (
                                    SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    WHERE instr(',DC,CVA,CNTT,TRAHS,',','||QDL.MA||',')>0
                                    AND (vTuNgayGQ IS NULL OR QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=don.id  AND GD.MAGIAIDOAN=2
                                )
                            OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_BANAN PTBA 
                                    WHERE  PTBA.SOBANAN IS NOT NULL
                                    AND (vTuNgayGQ IS NULL OR PTBA.NGAYTUYENAN>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR PTBA.NGAYTUYENAN<=VV_DENNGAY_GQ)
                                    AND PTBA.DONID=don.id  AND GD.MAGIAIDOAN=3
                                    )
                             OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE  instr(',DC,',','||QDL.MA||',')>0
                                    AND (vTuNgayGQ IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=don.id  AND GD.MAGIAIDOAN=3
                                    )         
                        )
                     )
                     or(vTinhTrangGQ = 8 -- chuyển hồ sơ
                         AND 
                           (  EXISTS (
                                    SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                    WHERE QDL.MA = 'CVA'   -- QDL.MA ='CVA' chuyen vu an
                                    AND BA.DONID IS NULL  -- chưa có bản án
                                    AND (vTuNgayGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=don.id  AND GD.MAGIAIDOAN=2
                                 )
                             --phuc tham Đang tạm đình chỉ                
                                OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA = 'CVA' --chuyen vu an
                                    AND (vTuNgayGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=don.id  AND GD.MAGIAIDOAN=3
                                    )
                            )
                     )
                     or(vTinhTrangGQ = 9 -- Đình chỉ
                         AND 
                           (  EXISTS (
                                    SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                    WHERE QDL.MA = 'DC'   -- QDL.MA ='TDC' Tam dinh chi
                                    AND BA.DONID IS NULL  -- chưa có bản án
                                    AND (vTuNgayGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=don.id  AND GD.MAGIAIDOAN=2
                                 )
                             --phuc tham Đang tạm đình chỉ                
                                OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA = 'DC' --Tạm đình chỉ
                                    AND (vTuNgayGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=don.id  AND GD.MAGIAIDOAN=3
                                    )
                            )
                     )
                     or(vTinhTrangGQ = 10 -- QĐ không áp dụng BPXLHC
                         AND 
                           (  EXISTS (
                                    SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                    WHERE QD.MA like '%BPXLHC-Ko%'   
                                    AND BA.DONID IS NULL  -- chưa có bản án
                                    AND (vTuNgayGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=don.id  AND GD.MAGIAIDOAN=2
                                 )
                             --phuc tham Đang tạm đình chỉ                
                                OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA like '%BPXLHC-Ko%' 
                                    AND (vTuNgayGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=don.id  AND GD.MAGIAIDOAN=3
                                    )
                            )
                     )
                     or(vTinhTrangGQ = 11 -- QĐ áp dụng BPXLHC
                         AND 
                           (  EXISTS (
                                    SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON QSV.DONID =BA.DONID 
                                    WHERE QDL.MA = 'BPXLHC'   
                                    AND BA.DONID IS NULL  -- chưa có bản án
                                    AND (vTuNgayGQ IS NULL OR   QSV.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR QSV.NGAYQD<=VV_DENNGAY_GQ)
                                    AND QSV.DONID=don.id  AND GD.MAGIAIDOAN=2
                                 )
                             --phuc tham Đang tạm đình chỉ                
                                OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH PTQDVA --QUYẾT ĐỊNH 
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID=PTQDVA.DONID --BẢN ÁN 
                                    WHERE PTBA.DONID IS NULL --Vụ án chưa có bản án 
                                    AND QDL.MA = 'BPXLHC' 
                                    AND (vTuNgayGQ IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY_GQ)
                                    AND PTQDVA.DONID=don.id  AND GD.MAGIAIDOAN=3
                                    )
                            )
                     )
               )
          AND (vThamPhan IS NULL
            OR( EXISTS(SELECT 'x' FROM XLHC_DON_THAMPHAN PC WHERE   PC.CANBOID = vThamPhan  AND PC.DONID=don.ID ))--Thẩm phán
           )
          AND (vThoiHanGQ IS NULL
                 OR (vThoiHanGQ=1 --Đã hết thời hạn
                     AND (   --dùng ngày bản án hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án
                            EXISTS(SELECT 'X' FROM XLHC_SOTHAM_THULY TL
                                    LEFT JOIN XLHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    WHERE
                                      (   ( BA.ID IS NOT NULL AND (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>180 )
                                          OR( BA.ID IS NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND (SYSDATE-TL.NGAYTHULY)>180)
                                      )
                                   AND TL.DONID =don.id AND GD.MAGIAIDOAN=2
                                  )
                           --dùng ngày quyết định và đình chỉ vụ án   
                            OR  EXISTS (SELECT 'X' FROM XLHC_SOTHAM_THULY TL
                                        LEFT JOIN XLHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                        LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                        WHERE 
                                         (
                                            ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0 AND  (QSV.NGAYQD-TL.NGAYTHULY)>180  )--'CVA' QĐ chuyển vụ án,'HPT' Hoãn phiên tòa, 'GHTHXX' QĐ gia hạn thời hạn chuẩn bị xét xử
                                           OR
                                            (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  BA.ID IS NULL AND (SYSDATE-TL.NGAYTHULY)>180 )
                                         )
                                        AND TL.DONID =don.id AND GD.MAGIAIDOAN=2
                                     )
                              --dùng ngày bản án phúc thẩm hoặc dùng ngày hiện tại và chưa có quyết định gây kết thúc vụ án  
                            OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN XLHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE 
                                     (
                                        (BA.ID IS NOT NULL  AND  (BA.NGAYMOPHIENTOA-TL.NGAYTHULY)>90 )
                                     OR (BA.ID IS  NULL AND instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 AND  (SYSDATE-TL.NGAYTHULY)>90 )
                                     )
                                 AND TL.DONID =don.id AND GD.MAGIAIDOAN=3
                             )
                            --dùng ngày QĐ phúc thẩm  
                              OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN XLHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QSV.LOAIQDID 
                                    WHERE
                                    (
                                          ( instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')>0  AND(QSV.NGAYQD-TL.NGAYTHULY)>90 ) --QĐ Đình chỉ hoặc QĐ hoãn hoặc QĐ gia hạn thời hạn chuẩn bị xét xử, QĐ chuyển vụ án
                                      OR (  instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0  AND(SYSDATE-TL.NGAYTHULY)>90)
                                    )
                                     AND TL.DONID =don.id AND GD.MAGIAIDOAN=3
                                 ) 
                         )
                   )
                OR (vThoiHanGQ=2 --Còn thời hạn dưới 10 ngày
                    AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM XLHC_SOTHAM_THULY TL
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN XLHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=170 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =don.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN XLHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=80 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                     AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =don.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                      )
                      OR (vThoiHanGQ=3  AND (
                      --Sơ thẩm chưa có quyết định và chưa có bản án
                            EXISTS(SELECT 'X' FROM XLHC_SOTHAM_THULY TL
                                    LEFT JOIN XLHC_SOTHAM_BANAN BA ON BA.DONID =TL.DONID
                                    LEFT JOIN XLHC_SOTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=160 AND (SYSDATE-TL.NGAYTHULY)<180 
                                    AND BA.ID IS NULL
                                    AND (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',') IS NULL)
                                    AND TL.DONID =don.id AND GD.MAGIAIDOAN=2
                                  )
                          --phúc thẩm   
                            OR EXISTS (
                                    SELECT 'X' FROM XLHC_PHUCTHAM_THULY TL 
                                    LEFT JOIN XLHC_PHUCTHAM_BANAN  BA ON BA.DONID =TL.DONID
                                    LEFT JOIN XLHC_PHUCTHAM_QUYETDINH QSV ON TL.DONID=QSV.DONID
                                    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID 
                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                    WHERE (SYSDATE-TL.NGAYTHULY)>=70 AND (SYSDATE-TL.NGAYTHULY)<90 
                                    AND BA.ID IS NULL
                                    AND  (instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')=0 OR instr(',DC,CVA,HPT,GHTHXX,',','||QDL.MA||',')IS NULL)
                                    AND TL.DONID =don.id AND GD.MAGIAIDOAN=3
                                    ) 
                           )          
                   ) 
                )
          AND (vSoQD IS NULL--Số BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM XLHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoQD||'%' AND don.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoQD||'%' AND don.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoQD||'%' AND don.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoQD||'%' AND don.ID=QSV.DONID  )
                 )
            )
          AND (vNgayQD IS NULL--Ngày BA/QĐ
             OR  (    EXISTS(SELECT 'X' FROM XLHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayQD AND don.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM XLHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayQD AND don.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayQD AND don.ID=QSV.DONID  )
                   OR EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayQD AND don.ID=QSV.DONID  )
                 )
             )
          AND (vThuKy is null--Thư ký
               OR( EXISTS(select 'X' from XLHC_SoTham_HDXX tp where tp.CanBoID = vThuKy and tp.DONID=don.ID) 
                   OR EXISTS(select 'X' from XLHC_PhucTham_HDXX tp where tp.CanBoID = vThuKy and tp.DONID=don.ID)
                   OR EXISTS(SELECT 'X' FROM XLHC_DON_THAMPHAN TP WHERE TP.DONID=don.ID and TP.THUKYID = vThuKy ) 
                 )
            )
          AND (vPTRutKinhNghiem IS NULL
               OR(vPTRutKinhNghiem =1 
                   AND ( EXISTS(SELECT 'X' FROM XLHC_SOTHAM_BANAN BA
                          LEFT JOIN XLHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                          WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                          AND BA.DONID =don.id AND GD.MAGIAIDOAN=2
                          )
                     OR   EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_BANAN BA
                          LEFT JOIN XLHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                          WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                          AND BA.DONID =don.id AND GD.MAGIAIDOAN=3
                          )
                      )
                )
               OR(vPTRutKinhNghiem =2 
                   AND ( NOT EXISTS(SELECT 'X' FROM XLHC_SOTHAM_BANAN BA
                          LEFT JOIN XLHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                          WHERE SXX.ST_ISRUTKN=1 -----PT_ISRUTKN trường phân biệt sơ thẩm rút kinh nghiệm
                          AND BA.DONID =don.id AND GD.MAGIAIDOAN=2
                          )
                         AND NOT  EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_BANAN BA
                          LEFT JOIN XLHC_SAUXETXU SXX ON BA.DONID=SXX.VUANID
                          WHERE SXX.PT_ISRUTKN=1 ---PT_ISRUTKN trường phân biệt phúc thẩm rút kinh nghiệm
                          AND BA.DONID =don.id AND GD.MAGIAIDOAN=3
                          )
                      )
                ) 
             )
    ), cte_Total AS (
        SELECT COUNT(ID) AS Total FROM cte_Data
    ), cte_Final AS(
    select ROW_NUMBER() OVER (ORDER BY a.NGAYNHANDON desc) STT,a.ID,a.MAVUVIEC,a.TENVUVIEC,a.SOTHUTU,a.NGAYNHANDON,a.NGUOITAO,a.NGAYTAO,a.QUANHEPL,a.MAGIAIDOAN,a.TOASOTHAM,
        a.HINHTHUCNHANDON,a.GiaiDoanVuViec,a.TenHinhThuc,a.TruongHopGiaoNhan,a.TenToaSoTham,a.BANAN_QD_ST,a.HoTenBiCan,a.KHANGNGHI_ST,a.CHECK_THULY,a.TINHTRANG_GQ,a.THULYXXLAI,(select Total from cte_Total) as CountAll
    from cte_Data a
  )
    select a.*
    from cte_Final a where a.STT between MinIndex and MaxIndex;

END XLHC_DON_SEARCH;
END PKG_STPT_XLHC;
