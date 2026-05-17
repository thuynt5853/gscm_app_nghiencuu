--------------------------------------------------------
--  DDL for Package Body PKG_STPT_XLHC_VNPTV2
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_XLHC_VNPTV2" AS

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
        --start check select here
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
            FROM XLHC_SOTHAM_THULY T2
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
              FROM XLHC_PHUCTHAM_THULY T2
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
          AND (vCapXetXu IS NULL
          --OR (GD.MAGIAIDOAN=vCapXetXu ))--Cấp xét xử
          --thaipd
              OR (
                (GD.MAGIAIDOAN = 2 AND GD.TOAANID = vToaXetXu)
                OR (GD.MAGIAIDOAN = 3 AND (GD.TOAANID = vToaXetXu OR GD.TOAPHUCTHAMID = vToaXetXu))
                )
          )
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
FUNCTION DON_SEARCH_ITEM
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
  Page_Size	in	int
)RETURN T_STPT_6LOAIAN
IS
  V_TABLE T_STPT_6LOAIAN;
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
	V_TABLE := T_STPT_6LOAIAN();
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
    MinIndex := 1;
    MaxIndex := 1000 ;

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
    FOR r IN (
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
            FROM XLHC_SOTHAM_THULY T2
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
              FROM XLHC_PHUCTHAM_THULY T2
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
    ),abac AS (Select * from BAQD_CONGBO)
        --Select * from XLHC_DON
        Select * from cte_Data
         --Select * from abac
	)
	LOOP
    V_TABLE.extend;
    V_TABLE(V_TABLE.count) := R_STPT_6LOAIAN(
                r.ID,r.MAVUVIEC,r.TENVUVIEC,to_char(r.NGAYTAO,'dd/MM/yyyy')||'<br/>'||to_char(r.NGAYTAO,' HH24:MI:SS'),r.NGAYTAO,r.NGUOITAO,r.MAGIAIDOAN,
                r.HOTENBICAN,r.TOASOTHAM,NULL,r.GIAIDOANVUVIEC,NULL,NULL,
                r.TINHTRANG_GQ,r.CHECK_THULY,'8'
                );
     END LOOP;
    RETURN V_TABLE;
END DON_SEARCH_ITEM;

PROCEDURE XLHC_DON_SEARCH_V2
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
        ,don.CQDN_TEN
        ,don.NGAYNHANDON
        ,don.NGUOITAO
        ,TO_CHAR(don.NGAYTAO, 'dd/mm/yyyy') AS NGAYTAO
        ,item.TEN as QUANHEPL
        ,don.MAGIAIDOAN
        ,toa.TEN TOASOTHAM
        ,don.HINHTHUCNHANDON
        ,(Case don.MAGIAIDOAN when 1 then 'Hồ sơ' when 2 then 'Sơ thẩm' when 3 then 'Phúc thẩm' when 4 then 'GĐT, TT' End) GiaiDoanVuViec
        ,DECODE(don.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    GN.TruongHopGiaoNhan) TRUONGHOPGIAONHAN,
        nvl('</br><i>Tòa xem xét sơ thẩm: </i><b>'||toa.Ten||'</b>', '') TenToaSoTham
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
                 '<br /><b>'||
                  listagg (BC.TENDUONGSU||' '|| '(người bị đề nghị)</b>')--decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC) BC
                  GROUP BY BC.DONID
                )BC2 ON BC2.DONID=don.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                  SELECT BC.DONID,'<br /><br/> <b>'||
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
            FROM XLHC_SOTHAM_THULY T2
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
            SELECT BA.donid,'</br>- Quyết định số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM XLHC_SOTHAM_BANAN BA
            WHERE  BA.SOBANAN IS NOT NULL
            GROUP BY BA.donid,'</br>- Quyết định số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
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
              FROM XLHC_PHUCTHAM_THULY T2
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
                            OR EXISTS (
                                    SELECT 'X' FROM XLHC_DON_XULY DXL
                                    WHERE DXL.TRADON_LYDOID IS NOT NULL
                                    AND (vTuNgayGQ IS NULL OR DXL.NGAYGQ_YC >=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR DXL.NGAYGQ_YC <=VV_DENNGAY_GQ)
                                    AND DXL.DONID=don.id
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
    select ROW_NUMBER() OVER (ORDER BY a.NGAYNHANDON desc) STT,a.ID,a.MAVUVIEC,a.TENVUVIEC,a.SOTHUTU,a.CQDN_TEN,a.NGAYNHANDON,a.NGUOITAO,a.NGAYTAO,a.QUANHEPL,a.MAGIAIDOAN,a.TOASOTHAM,
        a.HINHTHUCNHANDON,a.GiaiDoanVuViec,a.TenHinhThuc,a.TruongHopGiaoNhan,a.TenToaSoTham,a.BANAN_QD_ST,a.HoTenBiCan,a.KHANGNGHI_ST,a.CHECK_THULY,a.TINHTRANG_GQ,a.THULYXXLAI,(select Total from cte_Total) as CountAll
    from cte_Data a
  )
    select a.*
    from cte_Final a where a.STT between MinIndex and MaxIndex;

END XLHC_DON_SEARCH_V2;

/*
    -- 20240513
    -- Fix tim vu an sau khi chuyen
*/
PROCEDURE XLHC_DON_SEARCH_VNPT_V2
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
        ,don.CQDN_TEN
        ,don.NGAYNHANDON
        ,don.NGUOITAO
        ,TO_CHAR(don.NGAYTAO, 'dd/mm/yyyy') AS NGAYTAO
        ,item.TEN as QUANHEPL
        ,GD.MAGIAIDOAN
        ,toa.TEN TOASOTHAM
        ,don.HINHTHUCNHANDON
        ,(Case GD.MAGIAIDOAN when 1 then 'Hồ sơ' when 2 then 'Sơ thẩm' when 3 then 'Phúc thẩm' when 4 then 'GĐT, TT' End) GiaiDoanVuViec
        ,DECODE(don.HINHTHUCNHANDON,1,'<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>',
                                    270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
                                    GN.TruongHopGiaoNhan) TRUONGHOPGIAONHAN,
        nvl('</br><i>Tòa xem xét sơ thẩm: </i><b>'||toa.Ten||'</b>', '') TenToaSoTham
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
      INNER JOIN (
        SELECT G.* FROM XLHC_DON_GIAIDOAN G
        WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vToaXetXu)
        --Thaipd: OR G.TOAANID = vToaXetXu
        OR (G.MAGIAIDOAN = 3 AND (G.TOAPHUCTHAMID = vToaXetXu OR G.TOAANID = vToaXetXu))
      ) GD ON don.id = GD.DONID
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
                 '<br /><b>'||
                  listagg (BC.TENDUONGSU||' '|| '(người bị đề nghị)</b>')--decode(BC.TUCACHTOTUNG_MA,'NGUYENDON','(Nguyên đơn)','BIDON','(Bị đơn)','QUYENNVLQ','(Người có quyền và NVLQ)',' ('||BC.TUCACHTOTUNG_MA || ')' ), '<br/>')
                  WITHIN GROUP (ORDER BY BC.ROWNUMBER) HOTEN
                  FROM  TABLE(V_TABLE_BC) BC
                  GROUP BY BC.DONID
                )BC2 ON BC2.DONID=don.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                  SELECT BC.DONID,'<br /><br/> <b>'||
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
            FROM XLHC_SOTHAM_THULY T2
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
            SELECT BA.donid,'</br>- Quyết định số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy') TINHTRANG_GQ FROM XLHC_SOTHAM_BANAN BA
            WHERE  BA.SOBANAN IS NOT NULL
            GROUP BY BA.donid,'</br>- Quyết định số: '||BA.SOBANAN||' ngày '||to_char(BA.NGAYTUYENAN,'dd/MM/yyyy')
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
              FROM XLHC_PHUCTHAM_THULY T2
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
--                    LEFT JOIN ( SELECT GG.* FROM XLHC_DON_THAMPHAN GG
--                                 WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                                )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                    LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                    LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
                   )TPPC ON TPPC.DONID=don.ID AND GD.MAGIAIDOAN=2
      LEFT JOIN (
                SELECT TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                FROM XLHC_DON_THAMPHAN TP
                LEFT JOIN (SELECT DONID,ID FROM TABLE(V_TABLE_HDXX_PT))HD ON HD.DONID=TP.DONID
--                LEFT JOIN (SELECT GG.* FROM XLHC_DON_THAMPHAN GG
--                            WHERE EXISTS (SELECT 'X' FROM TABLE(V_TABLE_TP)TP WHERE TP.ID=GG.ID)
--                           )PCTP_GQ ON PCTP_GQ.DONID=TP.DONID--lấy một thẩm phán có ngày nhận phân công mới nhất làm chủ tọa trong phân công thẩm phán giải quyết
                LEFT JOIN DM_CANBO CBB ON CBB.ID=HD.ID
                LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM'
                GROUP BY TP.DONID,'</br>- Thẩm phán: <b>'||TO_CHAR(DECODE(CBB.HOTEN,NULL,CB.HOTEN,CBB.HOTEN))||'</b><i> (chủ tọa)</i>'
    )TPPCPT ON TPPCPT.DONID=don.ID  AND GD.MAGIAIDOAN=3
      Where (don.TOAANID=vDonViID Or ((don.TOAPHUCTHAMID=vDonViID OR don.TOAANID = vDonViID) And don.MAGIAIDOAN=PHUCTHAM))
          and (1=(CASE WHEN (vMaViec|| ' ')=' ' THEN 1 WHEN LOWER(don.MAVUVIEC) LIKE  ('%' || LOWER(vMaViec) || '%') THEN 1 END))
          and (1=(CASE WHEN (vTenViec|| ' ')=' '  THEN 1 WHEN LOWER(don.TENVUVIEC) LIKE  ('%' || LOWER(vTenViec) || '%') THEN 1 Else 0 END))
          and (1=(CASE WHEN vQuanHePhapLuat is null THEN 1 WHEN don.QUANHEPHAPLUATID=vQuanHePhapLuat THEN 1 Else 0 END))
          and (vDoiTuongApDungBPXLHC IS NULL OR (LOWER(duongsu.HOTEN) like '%' || LOWER(vDoiTuongApDungBPXLHC) || '%') )
          AND (vCapXetXu IS NULL
            --OR (GD.MAGIAIDOAN=vCapXetXu )
            --thaipd
              OR (
                (GD.MAGIAIDOAN = 2 AND GD.TOAANID = vToaXetXu)
                OR (GD.MAGIAIDOAN = 3 AND (GD.TOAANID = vToaXetXu OR GD.TOAPHUCTHAMID = vToaXetXu))
                )
          )--Cấp xét xử
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
                        OR EXISTS (
                                    SELECT 'X' FROM XLHC_DON_XULY DXL
                                    WHERE 1=1
                                    --and DXL.TRADON_LYDOID IS NOT NULL
                                    and (
                                        DXL.LOAIGIAIQUYET = 5 --thụ lý
                                        OR DXL.LOAIGIAIQUYET = 4 --Bổ sung
                                    )
                                    AND (vTuNgayGQ IS NULL OR DXL.NGAYGQ_YC >=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR DXL.NGAYGQ_YC <=VV_DENNGAY_GQ)
                                    AND DXL.DONID=don.id
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
                            OR EXISTS (
                                    SELECT 'X' FROM XLHC_DON_XULY DXL
                                    WHERE 1=1
                                    --and DXL.TRADON_LYDOID IS NOT NULL
                                    and DXL.LOAIGIAIQUYET = 3 --trả đơn
                                    AND DXL.TRADON_LYDOID > 0
                                    AND (vTuNgayGQ IS NULL OR DXL.NGAYGQ_YC >=VV_TUNGAY_GQ)
                                    AND (vDenNgayGQ IS NULL OR DXL.NGAYGQ_YC <=VV_DENNGAY_GQ)
                                    AND DXL.DONID=don.id
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
    select ROW_NUMBER() OVER (ORDER BY a.NGAYNHANDON desc) STT,a.ID,a.MAVUVIEC,a.TENVUVIEC,a.SOTHUTU,a.CQDN_TEN,a.NGAYNHANDON,a.NGUOITAO,a.NGAYTAO,a.QUANHEPL,a.MAGIAIDOAN,a.TOASOTHAM,
        a.HINHTHUCNHANDON,a.GiaiDoanVuViec,a.TenHinhThuc,a.TruongHopGiaoNhan,a.TenToaSoTham,a.BANAN_QD_ST,a.HoTenBiCan,a.KHANGNGHI_ST,a.CHECK_THULY,a.TINHTRANG_GQ,a.THULYXXLAI,(select Total from cte_Total) as CountAll
    from cte_Data a
  )
    select a.*
    from cte_Final a where a.STT between MinIndex and MaxIndex;

END XLHC_DON_SEARCH_VNPT_V2;


PROCEDURE XLHC_DON_SEARCH_PTQDK (
        
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
        
    ) IS

--        TOTALITEM            NUMBER;
--        MININDEX             NUMBER;
--        MAXINDEX             NUMBER;
--        VV_TUNGAY            DATE;
--        VV_DENNGAY           DATE;
--        VV_NGAYTHULY_TU      DATE;
--        VV_NGAYTHULY_DEN     DATE;
--        V_TABLE_BC           T_BICANBICAO_EXT;
--        V_TABLE_BC_KC        T_BICANBICAO_EXT;
--        V_TABLE_TLPTQDK      T_QUYETDINH_EXT;  
--        V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-03102023-ANHNT
--        V_TABLE_PTQDK        T_QUYETDINH_EXT;
       
      TotalItem number;
	  MinIndex	number;
	  MaxIndex	number;
	  VV_NGAYTHULY_TU DATE;
	  VV_NGAYTHULY_DEN DATE;
	  VV_TUNGAY date;
	  VV_DENNGAY date;
	  V_TABLE_TLPTQDK T_QUYETDINH_EXT;
--	  V_TABLE_HDXX_PT T_QUYETDINH_EXT;
	  V_TABLE_THAMPHAN T_THAMPHAN_EXT;
	  V_TABLE_PTQDK T_QUYETDINH_EXT;
	  V_TABLE_BC T_BICANBICAO_EXT;
	  V_TABLE_BC_KC T_BICANBICAO_EXT;
    BEGIN
        V_TABLE_BC := T_BICANBICAO_EXT();
        V_TABLE_BC_KC := T_BICANBICAO_EXT();
        V_TABLE_TLPTQDK := T_QUYETDINH_EXT();
        V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-03102023-ANHNT
        V_TABLE_PTQDK := T_QUYETDINH_EXT();
    ---------------------------------------
        MININDEX := PAGE_SIZE * ( PAGE_INDEX - 1 ) + 1;
        MAXINDEX := PAGE_INDEX * PAGE_SIZE;
    ----------
        IF ( vTuNgayThuLy IS NOT NULL ) THEN
            VV_NGAYTHULY_TU := TO_DATE(TRIM(vTuNgayThuLy)
                                       || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( vDenNgayThuLy IS NOT NULL ) THEN
            VV_NGAYTHULY_DEN := TO_DATE(TRIM(vDenNgayThuLy)
                                        || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;  
     --

        IF ( vTuNgayGQ IS NOT NULL ) THEN
            VV_TUNGAY := TO_DATE(TRIM(vTuNgayGQ)
                                 || ' 00:00:00', 'dd/MM/yyyy HH24:MI:SS');
        END IF;

        IF ( vDenNgayGQ IS NOT NULL ) THEN
            VV_DENNGAY := TO_DATE(TRIM(vDenNgayGQ)
                                  || ' 23:59:59', 'dd/MM/yyyy HH24:MI:SS');
        END IF;  

   ------------------------

   ------------------dinh nghĩa bảng lay 1 ban ghi moi nhat với mục đích chỉ chạy 1 lần.

        --XLHC_KCKNQDK_PHUCTHAM_THULY

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, NULL)
        BULK COLLECT
        INTO V_TABLE_TLPTQDK
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID
                FROM
                    (
                        SELECT
                            DONID,
                            FIRST_VALUE(ID) OVER(
                                PARTITION BY DONID
                                ORDER BY
                                    NGAYTHULY DESC, NGAYTAO DESC
                            ) ID
                        FROM
                            XLHC_KCKNQDK_PHUCTHAM_THULY
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID
            ) TTS;  

        --THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.DONID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,DONID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM XLHC_DON_THAMPHAN WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,DONID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY DONID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,7 MAGIAIDOAN
            FROM  XLHC_KCKNQDK_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
		--THAMPHAN --TOANCAU-03102023-ANHNT      
         --XLHC_KCKNQDK_PHUCTHAM_QUYETDINH

        SELECT
            R_QUYETDINH_EXT(TTS.DONID, TTS.ID, TTS.MA)
        BULK COLLECT
        INTO V_TABLE_PTQDK
        FROM
            (
                SELECT
                    TT.DONID,
                    TT.ID,
                    TT.MA
                FROM
                    (
                        SELECT
                            PQD.DONID,
                            FIRST_VALUE(PQD.ID) OVER(
                                PARTITION BY PQD.DONID, QDL.MA
                                ORDER BY
                                    PQD.NGAYQD DESC, PQD.NGAYTAO DESC
                            ) ID,
                            QDL.MA
                        FROM
                            XLHC_KCKNQDK_PHUCTHAM_QUYETDINH   PQD
                            LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PQD.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                    ) TT
                GROUP BY
                    TT.DONID,
                    TT.ID,
                    TT.MA
            ) TTS;
          ---V_TABLE_BC; tạo bảng lấy  <=3 đương sự khác  

        SELECT
            R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.HOTEN, NULL, TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC
        FROM
            (
                SELECT
                    BC.ID,
                    BC.DONID,
                    BC.HOTEN,
--                    BC.TUCACHTOTUNG_MA,
                    BC.ROWNUMBER
                FROM
                    (
                        SELECT
                            D.ID,
                            D.DONID,
                            D.HOTEN,
--                            D.TUCACHTOTUNG_MA,
                            ROW_NUMBER() OVER(
                                PARTITION BY D.DONID
                                ORDER BY
                                    D.HOTEN
                            ) ROWNUMBER
                        FROM
                            XLHC_DUONGSU   D
                            -- LEFT JOIN ADS_ANPHI         P ON P.DUONGSU_ID = D.ID
--                        WHERE
--                            D.ISDAIDIEN = 0
--                            -- AND ( ( D.TUCACHTOTUNG_MA = 'NGUYENDON'
--                            --         AND ( P.SOBIENLAI IS NOT NULL
--                            --               OR P.TINHTRANG = 1 ) )
--                            OR D.TUCACHTOTUNG_MA <> 'NGUYENDON'
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;         
          ---V_TABLE_BC_KC; tạo bảng lấy  <=3 người kháng cáo  

        SELECT
            R_BICANBICAO_EXT(TTS.ID, TTS.DONID, TTS.HOTEN, NULL, TTS.ROWNUMBER)
        BULK COLLECT
        INTO V_TABLE_BC_KC
        FROM
            (
                SELECT
                    BC.ID,
                    BC.DONID,
                    BC.HOTEN,
--                    BC.TUCACHTOTUNG_MA,
                    BC.ROWNUMBER
                FROM
                    (
                        SELECT
                            DS.ID,
                            DS.DONID,
                            DS.HOTEN,
--                            DS.TUCACHTOTUNG_MA,
                            ROW_NUMBER() OVER(
                                PARTITION BY DS.DONID
                                ORDER BY
                                    DS.HOTEN
                            ) ROWNUMBER
                        FROM
                            XLHC_DUONGSU DS
                        WHERE
                            EXISTS (
                                SELECT
                                    'X'
                                FROM
                                    XLHC_SOTHAM_KHANGCAO KC
                                WHERE
                                    KC.DUONGSUID = DS.ID
                                    AND KC.DONID = DS.DONID
                            )
                    ) BC
                WHERE
                    BC.ROWNUMBER <= 3
            ) TTS;             
   -----------------------

        OPEN CURRETURN FOR SELECT
                              TT.*
                          FROM
                              (
                                  SELECT
								    ROW_NUMBER() OVER(ORDER BY A.NGAYTAO DESC) STT,
								    A.ID,
								    A.MAVUVIEC,
								    A.TENVUVIEC,
								    A.SOTHUTU,
								    A.CQDN_TEN,
								    A.NGAYNHANDON,
								    A.NGUOITAO,
								    TO_CHAR(A.NGAYTAO, 'dd/MM/yyyy') || '<br/>' || TO_CHAR(A.NGAYTAO, ' HH24:MI:SS') NGAYTAO,
								    I.TEN AS QUANHEPL,
								    T.TEN AS TOASOTHAM,
								    A.HINHTHUCNHANDON,
								    DECODE(GD.MAGIAIDOAN, 7, '</br><i>Tòa xét xử sơ thẩm: </i><b>' || NVL(TST.TEN, T.TEN) || '</b>', NULL) TENTOASOTHAM,
								    DECODE(GD.MAGIAIDOAN, 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm', 7, 'Phúc thẩm', '') GIAIDOANVUVIEC,
								    DECODE(A.HINHTHUCNHANDON, 1, '<br/><i>TH giao nhận:</i> <b>Thụ lý mới</b>', 
								           270, '<br/><i>TH giao nhận:</i> <b>Xét xử lại cấp sơ thẩm</b>',
								           '<br/><i>TH giao nhận:</i> <b>' || GN.TRUONGHOPGIAONHAN || '</b>') TRUONGHOPGIAONHAN,
								    (Case A.HINHTHUCNHANDON when 1 then 'Trực tiếp' when 2 then 'Qua bưu điện' when 3 then 'Trực tuyến' End) TenHinhThuc,
								    '' AS BANAN_QD_ST,
--								    PTQD.QD_PT,
								    STKC.KHANGCAO_ST AS KHANGNGHI_ST,
								    A.MAGIAIDOAN,
								    BC3.HOTEN AS HOTENBICAN,
								    DECODE(XLD.LOAIGIAIQUYET, 1, '- Đã chuyển đơn',
								           CASE WHEN TLPT.TINHTRANG_GQ IS NULL THEN '- Chưa thụ lý' ELSE TLPT.TINHTRANG_GQ END
								           || CASE WHEN TPPCPT.TINHTRANG_GQ IS NULL AND TLPT.TINHTRANG_GQ IS NOT NULL 
								                   THEN '</br>- Chưa phân công Thẩm phán' ELSE TPPCPT.TINHTRANG_GQ END
								           || HPTPT.TINHTRANG_GQ || TDCPT.TINHTRANG_GQ || DCPT.TINHTRANG_GQ 
								           || THSPT.TINHTRANG_GQ || CPT.TINHTRANG_GQ || GNST.TINHTRANG_GQ) TINHTRANG_GQ,
								    TLPT.TINHTRANG_GQ AS CHECK_THULY,
								    DECODE(QD.ID, NULL, NULL, 3) THULYXXLAI,
								    COUNT(*) OVER() AS COUNTALL
								FROM XLHC_DON A
								INNER JOIN (
								    SELECT G.*
								    FROM XLHC_DON_GIAIDOAN G
								    WHERE G.MAGIAIDOAN = 7
								      AND G.TOAPHUCTHAMID = vToaXetXu
								) GD ON A.ID = GD.DONID
								LEFT JOIN DM_DATAITEM I ON A.QUANHEPHAPLUATID = I.ID
								LEFT JOIN XLHC_CHUYEN_NHAN_AN NA ON NA.MAP_VUANID_NEW = A.ID
								LEFT JOIN DM_TOAAN T ON A.TOAANID = T.ID
								LEFT JOIN DM_TOAAN TST ON NA.TOACHUYENID = TST.ID
								-- lấy thông tin vụ án end     
								LEFT JOIN (
								    SELECT PTQDVA.*
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
								    LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
								    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
								    WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0
								) QD ON QD.DONID = A.ID AND GD.MAGIAIDOAN = 7 
								----- Lay ra trang thai giai quyet don
								LEFT JOIN (
								    SELECT DONID, LOAIGIAIQUYET, NGAYGQ_YC
								    FROM XLHC_DON_XULY
								    WHERE LOAIGIAIQUYET IN (1, 5)
								) XLD ON A.ID = XLD.DONID
								--------Trạng thái giải quyết trong danh sách - DÙNG TABLE COLLECTION
								LEFT JOIN (
								    SELECT T2.DONID,
								    	   T2.NGAYTHULY,
								           '</br>- Thụ lý số:<b> ' || TO_CHAR(T2.SOTHULY) || '</b> ngày<b> ' || TO_CHAR(T2.NGAYTHULY, 'dd/MM/yyyy') || '</b>' TINHTRANG_GQ
								    FROM XLHC_KCKNQDK_PHUCTHAM_THULY T2
								    WHERE EXISTS (
								        SELECT 'X'
								        FROM TABLE(V_TABLE_TLPTQDK) QDL
								        WHERE QDL.ID = T2.ID
								    )
								) TLPT ON TLPT.DONID = A.ID AND GD.MAGIAIDOAN = 7
								-- Thẩm phán phúc thẩm - DÙNG TABLE COLLECTION  
								LEFT JOIN (
								    SELECT TP.DONID,
								           '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || '</b><i> (chủ tọa)</i>' TINHTRANG_GQ
								    FROM TABLE(V_TABLE_THAMPHAN) TP
								    LEFT JOIN TABLE(V_TABLE_THAMPHAN) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 3
								    LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
								    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID = HDXX.CANBOID  
								    WHERE TP.MAGIAIDOAN = 3 AND TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
								    GROUP BY TP.DONID, '</br>- Thẩm phán: <b>' || TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN)) || '</b><i> (chủ tọa)</i>'
								) TPPCPT ON TPPCPT.DONID = A.ID AND GD.MAGIAIDOAN = 7
								-- QĐ HPT - DÙNG TABLE COLLECTION
								LEFT JOIN (
								    SELECT PTQDVA.DONID,
								           '</br>- QĐ HPT số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ,
								           PTQDVA.NGAYQD NGAYQD
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
								    WHERE EXISTS (
								        SELECT 'X'
								        FROM TABLE(V_TABLE_PTQDK) QDL
								        WHERE QDL.ID = PTQDVA.ID AND INSTR(',HPT,', ','|| QDL.MA || ',') > 0
								    )
								    GROUP BY PTQDVA.DONID, PTQDVA.NGAYQD, '</br>- QĐ HPT số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
								) HPTPT ON HPTPT.DONID = A.ID AND GD.MAGIAIDOAN = 7
								-- QĐ TĐC - DÙNG TABLE COLLECTION
								LEFT JOIN (
								    SELECT PTQDVA.DONID,
								           '</br>- QĐ TĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
								    WHERE EXISTS (
								        SELECT 'X'
								        FROM TABLE(V_TABLE_PTQDK) QDL
								        WHERE QDL.ID = PTQDVA.ID AND INSTR(',TDC,', ',' || QDL.MA || ',') > 0
								    )
								    GROUP BY PTQDVA.DONID, '</br>- QĐ TĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
								) TDCPT ON TDCPT.DONID = A.ID AND GD.MAGIAIDOAN = 7
								-- QĐ ĐC - DÙNG TABLE COLLECTION
								LEFT JOIN (
								    SELECT PTQDVA.DONID,
								           '</br>- QĐ ĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
								    WHERE EXISTS (
								        SELECT 'X'
								        FROM TABLE(V_TABLE_PTQDK) QDL
								        WHERE QDL.ID = PTQDVA.ID AND INSTR(',DC,', ',' || QDL.MA || ',') > 0
								    )
								    GROUP BY PTQDVA.DONID, '</br>- QĐ ĐC số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
								) DCPT ON DCPT.DONID = A.ID AND GD.MAGIAIDOAN = 7
								-- QĐ CVA - DÙNG TABLE COLLECTION
								LEFT JOIN (
								    SELECT PTQDVA.DONID,
								           '</br>- QĐ CVA số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
								    WHERE EXISTS (
								        SELECT 'X'
								        FROM TABLE(V_TABLE_PTQDK) QDL
								        WHERE QDL.ID = PTQDVA.ID AND INSTR(',CVA,', ',' || QDL.MA || ',') > 0
								    )
								    GROUP BY PTQDVA.DONID, '</br>- QĐ CVA số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
								) CPT ON CPT.DONID = A.ID AND GD.MAGIAIDOAN = 7
								-- QĐ THS - DÙNG TABLE COLLECTION
								LEFT JOIN (
								    SELECT PTQDVA.DONID,
								           '</br>- QĐ THS số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy') TINHTRANG_GQ
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
								    WHERE EXISTS (
								        SELECT 'X'
								        FROM TABLE(V_TABLE_PTQDK) QDL
								        WHERE QDL.ID = PTQDVA.ID AND INSTR(',TRAHS,', ',' || QDL.MA || ',') > 0
								    )
								    GROUP BY PTQDVA.DONID, '</br>- QĐ THS số: ' || PTQDVA.SOQD || ' ngày ' || TO_CHAR(PTQDVA.NGAYQD, 'dd/MM/yyyy')
								) THSPT ON THSPT.DONID = A.ID AND GD.MAGIAIDOAN = 7 
								-------trường hợp giao nhận add vào cột trạng thái   
								LEFT JOIN (
								    SELECT CA.ID, CA.VUANID,
								           '</br>- Đã chuyển vụ án' TINHTRANG_GQ
								    FROM XLHC_CHUYEN_NHAN_AN CA
								    INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
								    WHERE CA.TOACHUYENID = vToaXetXu
								) GNST ON GNST.VUANID = A.ID AND GD.MAGIAIDOAN = 7
								LEFT JOIN (
								    SELECT CA.VUANID, I.TEN TRUONGHOPGIAONHAN, CA.MAP_VUANID_NEW
								    FROM DM_DATAITEM I
								    INNER JOIN XLHC_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID = I.ID
								    WHERE CA.TOANHANID = vToaXetXu
								    GROUP BY CA.VUANID, I.TEN, CA.MAP_VUANID_NEW
								) GN ON GN.VUANID = A.ID OR GN.MAP_VUANID_NEW = A.ID
								--------bị cáo kháng cáo lấy cho phúc thẩm - DÙNG TABLE COLLECTION    
								LEFT JOIN (
								    SELECT BC.DONID,
								           '<br /><i>Người kháng cáo:</i> <br />' ||
								           LISTAGG(BC.TENDUONGSU, '<br/>') 
								           WITHIN GROUP(ORDER BY BC.ROWNUMBER) HOTEN
								    FROM TABLE(V_TABLE_BC_KC) BC
								    WHERE BC.ROWNUMBER <= 3
								    GROUP BY BC.DONID
								) BC3 ON BC3.DONID = A.ID AND GD.MAGIAIDOAN = 7  
								----- lấy thông tin BA/sơ thẩm                
								LEFT JOIN (
								    SELECT PTQD.DONID,
								           '<br /><i>QĐ GQ PT: </i><b>' || 'Số ' || PTQD.SOQD || ' ngày ' || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy') || '</b>' QD_PT
								    FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQD
								    WHERE QUYETDINHID = 213
								) PTQD ON PTQD.DONID = A.ID           
								------ - lấy thông tin số ngày kháng cáo + đương sự toancau
								LEFT JOIN (
								    SELECT DS.DONID, 
								           '<br /><i>Kháng cáo: </i> <br />' || 
								           LISTAGG(DS.HOTEN || ' - Ngày kháng cáo: ' || TO_CHAR(KC.NGAYKHANGCAO, 'dd/MM/yyyy'), '<br/>') 
								           WITHIN GROUP(ORDER BY KC.NGAYKHANGCAO) KHANGCAO_ST
								    FROM XLHC_SOTHAM_KHANGCAO KC
								    INNER JOIN XLHC_DUONGSU DS ON KC.DUONGSUID = DS.ID
								    GROUP BY DS.DONID
								) STKC ON STKC.DONID = NA.VUANID
       --------------------- 

                                   WHERE
                                      A.MAGIAIDOAN = 7
                                      AND GD.MAGIAIDOAN = 7
--                                        tìm tên vụ án
                                      AND ( vTenViec IS NULL
									      OR ( LOWER(A.TENVUVIEC) LIKE '%' || LOWER(vTenViec) || '%' ) )--Tên vụ án
									
									AND ( vMaViec IS NULL
									      OR ( LOWER(A.MAVUVIEC) LIKE LOWER(vMaViec) ) ) 
									
									AND ( vQuanHePhapLuat IS NULL
									      OR ( LOWER(A.TENVUVIEC) LIKE '%' || LOWER(vQuanHePhapLuat) || '%' ) )
									
									AND ( ( GD.TOAANID = vToaXetXu
									        OR ( GD.TOAPHUCTHAMID = vToaXetXu ) )
									      OR ( GD.TOAANID = vToaXetXu
									           OR ( GD.TOAPHUCTHAMID = vToaXetXu
									                AND T.LOAITOA != 'CAPHUYEN' ) ) )
									
									AND ( ( vTinhTrangThuLy IS NULL
									        AND ( vTuNgayThuLy IS NULL OR A.NGAYTAO >= VV_NGAYTHULY_TU )
									        AND ( vDenNgayThuLy IS NULL OR A.NGAYTAO <= VV_NGAYTHULY_DEN ) )
									      OR ( vTinhTrangThuLy = 1
									           AND ( ( TLPT.DONID IS NOT NULL
									                   AND ( vTuNgayThuLy IS NULL OR TLPT.NGAYTHULY >= VV_NGAYTHULY_TU )
									                   AND ( vDenNgayThuLy IS NULL OR TLPT.NGAYTHULY <= VV_NGAYTHULY_DEN ) ) ) )
									      OR ( vTinhTrangThuLy = 2
									           AND ( TLPT.DONID IS NULL )
									           AND ( vTuNgayThuLy IS NULL OR A.NGAYTAO >= VV_NGAYTHULY_TU )
									           AND ( vDenNgayThuLy IS NULL OR A.NGAYTAO <= VV_NGAYTHULY_DEN ) ) )
									
									AND ( vSoThuLy IS NULL
									      OR ( EXISTS (
									          SELECT 'X'
									          FROM XLHC_KCKNQDK_PHUCTHAM_THULY
									          WHERE DONID = A.ID
									            AND UPPER(SOTHULY) = UPPER(vSoThuLy)
									      ) ) )
									
									AND (vThamPhan IS NULL
									     OR(EXISTS(SELECT 'X' FROM TABLE(V_TABLE_THAMPHAN) TP WHERE TP.DONID = A.ID AND TP.CANBOID = vThamPhan AND TP.MAGIAIDOAN = GD.MAGIAIDOAN))
									    )
									
									AND ( vThuKy IS NULL
									      OR ( EXISTS (
									          SELECT 'X'
									          FROM XLHC_PHUCTHAM_HDXX TP
									          WHERE TP.CANBOID = vThuKy
									            AND TP.DONID = A.ID
									      )
									           OR EXISTS (
									          SELECT 'X'
									          FROM XLHC_DON_THAMPHAN TP
									          WHERE TP.DONID = A.ID
									            AND TP.THUKYID = vThuKy
									      ) ) )
									
									AND ( vThoiHanGQ IS NULL
									      OR ( vThoiHanGQ = 1 --Đã hết thời hạn
									           AND ( 
									              EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_THULY TL
									                  LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID = TL.DONID
									                  LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE ( ( BA.ID IS NOT NULL
									                            AND ( BA.NGAYMOPHIENTOA - TL.NGAYTHULY ) > 90 )
									                          OR ( BA.ID IS NULL
									                               AND INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
									                               AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
									                    AND TL.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              )
									              OR EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_THULY TL
									                  LEFT JOIN XLHC_SOTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QSV.LOAIQDID
									                  WHERE ( ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') > 0
									                            AND ( QSV.NGAYQD - TL.NGAYTHULY ) > 90 )
									                          OR ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
									                               AND ( SYSDATE - TL.NGAYTHULY ) > 90 ) )
									                    AND TL.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) 
									           ) )
									      OR ( vThoiHanGQ = 2 --Còn thời hạn dưới 10 ngày
									           AND (
									              EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_THULY TL
									                  LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID = TL.DONID
									                  LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE ( SYSDATE - TL.NGAYTHULY ) >= 80
									                    AND ( SYSDATE - TL.NGAYTHULY ) < 90
									                    AND BA.ID IS NULL
									                    AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
									                          OR INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') IS NULL )
									                    AND TL.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) ) )
									      OR ( vThoiHanGQ = 3
									           AND (
									              EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_THULY TL
									                  LEFT JOIN XLHC_PHUCTHAM_BANAN BA ON BA.DONID = TL.DONID
									                  LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_QUYETDINH QSV ON TL.DONID = QSV.DONID
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE ( SYSDATE - TL.NGAYTHULY ) >= 70
									                    AND ( SYSDATE - TL.NGAYTHULY ) < 90
									                    AND BA.ID IS NULL
									                    AND ( INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') = 0
									                          OR INSTR(',DC,CVA,HPT,GHTHXX,', ',' || QDL.MA || ',') IS NULL )
									                    AND TL.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) ) ) )
									
									AND ( vPTRutKinhNghiem IS NULL
									      OR ( vPTRutKinhNghiem = 1
									           AND ( EXISTS (
									              SELECT 'X'
									              FROM XLHC_PHUCTHAM_BANAN BA
									              LEFT JOIN XLHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
									              WHERE SXX.PT_ISRUTKN = 1
									                AND BA.DONID = A.ID
									                AND GD.MAGIAIDOAN = 7
									          ) ) )
									      OR ( vPTRutKinhNghiem = 2
									           AND ( NOT EXISTS (
									              SELECT 'X'
									              FROM XLHC_PHUCTHAM_BANAN BA
									              LEFT JOIN XLHC_SAUXETXU SXX ON BA.DONID = SXX.VUANID
									              WHERE SXX.PT_ISRUTKN = 1
									                AND BA.DONID = A.ID
									                AND GD.MAGIAIDOAN = 7
									          ) ) ) )
									
									AND ( ( vTinhTrangGQ IS NULL
									        AND ( vTuNgayGQ IS NULL OR A.NGAYTAO >= VV_TUNGAY )
									        AND ( vDenNgayGQ IS NULL OR A.NGAYTAO <= VV_DENNGAY ) )
									      OR ( vTinhTrangGQ = 1 --Chưa giải quyết xong
									           AND ( 
									              EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_THULY PTTL
									                  WHERE (NOT EXISTS(SELECT 'X' FROM XLHC_PHUCTHAM_BANAN PTBA WHERE PTBA.DONID=PTTL.DONID)
									                         AND NOT EXISTS (
									                              SELECT 'X'
									                              FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									                              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									                              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                              WHERE INSTR(',DC,CVA,CNTT,', ',' || QDL.MA || ',') > 0
									                                AND QD.MA NOT IN ('69-DS', '70-DS', '72-DS')
									                                AND PTTL.DONID = PTQDVA.DONID
									                          ) )
									                    AND ( vTuNgayGQ IS NULL
									                          OR PTTL.NGAYTHULY >= VV_TUNGAY
									                          AND (HPTPT.NGAYQD IS NULL OR HPTPT.NGAYQD >= VV_TUNGAY) )
									                    AND ( vDenNgayGQ IS NULL OR PTTL.NGAYTHULY <= VV_DENNGAY )
									                    AND PTTL.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) 
									           ) ) 
									      OR ( vTinhTrangGQ = 2 --chưa phân công Thẩm phán  
									           AND( TLPT.NGAYTHULY IS NOT NULL )
									           AND ( vTuNgayGQ IS NULL OR TLPT.NGAYTHULY >= VV_TUNGAY ) 
									           AND ( vDenNgayGQ IS NULL OR TLPT.NGAYTHULY <= VV_DENNGAY )
									           AND ( 
									              NOT EXISTS (
									                  SELECT 'x'
									                  FROM XLHC_DON_THAMPHAN PC
									                  WHERE PC.DONID = A.ID
									                    AND ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
									                            AND GD.MAGIAIDOAN = 7 ))
									                    AND ( vTuNgayGQ IS NULL OR PC.NGAYPHANCONG >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR PC.NGAYPHANCONG <= VV_DENNGAY )
									              )))
									      OR ( vTinhTrangGQ = 3 --đã phân công Thẩm phán
									           AND EXISTS (
									              SELECT 'x'
									              FROM XLHC_DON_THAMPHAN PC
									              WHERE PC.DONID = A.ID
									                AND ( ( PC.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'
									                        AND GD.MAGIAIDOAN = 7 ) )
									                AND ( vTuNgayGQ IS NULL OR PC.NGAYPHANCONG >= VV_TUNGAY )
									                AND ( vDenNgayGQ IS NULL OR PC.NGAYPHANCONG <= VV_DENNGAY )
									          ) )
									      OR( vTinhTrangGQ =4 --ĐÃ LÊN LỊCH XÉT XỬ
									          AND ( EXISTS (
									                  SELECT 'X' FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE QDL.MA = 'DVARXX'
									                    AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                    AND PTQDVA.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) ) )
									      OR ( vTinhTrangGQ = 5 --Đang hoãn  
									           AND ( 
									              EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									                  LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID
									                  LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE PTBA.DONID IS NULL
									                    AND QDL.MA = 'HPT'
									                    AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                    AND PTQDVA.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) ) )
									      OR ( vTinhTrangGQ = 6 --Đang tạm đình chỉ  
									           AND (            
									              EXISTS (
									                  SELECT 'X' FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									                  LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID
									                  LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE PTBA.DONID IS NULL
									                    AND QDL.MA = 'TDC'
									                    AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                    AND PTQDVA.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) ) )
									      OR ( vTinhTrangGQ = 7 --Đã giải quyết xong
									           AND ( EXISTS (
									              SELECT 'X'
									              FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									              WHERE QD.MA IN ('69-DS', '70-DS', '72-DS')
									                AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                AND PTQDVA.DONID = A.ID
									                AND GD.MAGIAIDOAN = 7
									                OR INSTR(',CNTT,',','||QDL.MA||',')>0
									           ) ) )
									      OR ( vTinhTrangGQ = 8 --ĐÃ XÉT XỬ 
									           AND (            
									              EXISTS (
									                  SELECT 'X' FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									                  LEFT JOIN XLHC_KCKNQDK_PHUCTHAM_THULY PTTL ON PTTL.DONID = PTQDVA.DONID
									                  LEFT JOIN XLHC_PHUCTHAM_BANAN PTBA ON PTBA.DONID = PTTL.DONID
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE PTBA.DONID IS NULL
									                    AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                    AND PTQDVA.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									                    AND QD.KET_THUC = 1
									              ) ) )
									      OR ( vTinhTrangGQ = 9 --Đình chỉ
									           AND ( EXISTS (
									              SELECT 'X'
									              FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									              WHERE INSTR(',DC,', ',' || QDL.MA || ',') > 0
									                AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                AND PTQDVA.DONID = A.ID
									                AND GD.MAGIAIDOAN = 7
									          ) ) )
									      OR( vTinhTrangGQ=10 --Công nhận thỏa thuận của đương sự
									          AND ( EXISTS (
									              SELECT 'X' FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA 
									              LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
									              LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
									              WHERE INSTR(',CNTT,',','||QDL.MA||',')>0
									                AND (vTuNgayGQ IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
									                AND (vDenNgayGQ IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
									                AND PTQDVA.DONID=A.ID AND GD.MAGIAIDOAN=7
									           ))) 
									      OR ( vTinhTrangGQ = 11 --QĐ chuyển vụ án
									           AND ( 
									              EXISTS (
									                  SELECT 'X'
									                  FROM XLHC_KCKNQDK_PHUCTHAM_QUYETDINH PTQDVA
									                  LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
									                  LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
									                  WHERE INSTR(',CVA,', ',' || QDL.MA || ',') > 0
									                    AND ( vTuNgayGQ IS NULL OR PTQDVA.NGAYQD >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR PTQDVA.NGAYQD <= VV_DENNGAY )
									                    AND PTQDVA.DONID = A.ID
									                    AND GD.MAGIAIDOAN = 7
									              ) 
									              OR EXISTS(
									                  SELECT 'x'
									                  FROM XLHC_CHUYEN_NHAN_AN  
									                  WHERE TOACHUYENID = vToaXetXu AND VUANID = A.ID AND GD.MAGIAIDOAN = 7
									                    AND ( vTuNgayGQ IS NULL OR NGAYGIAO >= VV_TUNGAY )
									                    AND ( vDenNgayGQ IS NULL OR NGAYGIAO <= VV_DENNGAY )  
									              )
									           ) ) )
             -- END vTinhTrangGQ
--
--             --là con của chưa giải quyết xong 
----                                      and ( ( INSTR('2,3,4,5,6', vTinhTrangGQ) = 0
----                                              OR vTinhTrangGQ IS NULL )
----                                            OR ( INSTR('2,3,4,5,6', vTinhTrangGQ) > 0
----                                                 AND ( EXISTS (
----                                          SELECT
----                                              'X'
----                                          FROM
----                                              XLHC_KCKNQDK_PHUCTHAM_THULY PTTL
----                                          WHERE
----                                              ( NOT EXISTS (
----                                                  SELECT
----                                                      'X'
----                                                  FROM
----                                                      XLHC_KCKNQDK_PHUCTHAM_QUYETDINH   PTQDVA --QUYẾT ĐỊNH 
----                                                      LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
----                                                      LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
----                                                  WHERE 
----                                                      INSTR(',DC,CVA,CNTT,', ','
----                                                                             || QDL.MA
----                                                                             || ',') > 0
----                                                      AND PTTL.DONID = PTQDVA.DONID
----                                              ) )
------                                              AND ( vTuNgayGQ IS NULL
------                                                    OR PTTL.NGAYTHULY >= VV_TUNGAY )
------                                              AND ( vDenNgayGQ IS NULL
------                                                    OR PTTL.NGAYTHULY <= VV_DENNGAY )
----                                              AND PTTL.DONID = A.ID
----                                              AND GD.MAGIAIDOAN = 7
----                                      ) ) ) ) --là con của chưa giải quyết xong end 
--
--            -----------
                              ) TT
                          WHERE
                              TT.STT >= MinIndex
                              AND TT.STT <= MaxIndex;

    END XLHC_DON_SEARCH_PTQDK;

PROCEDURE XLHC_PHUCTHAM_KCKN_TGTT_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               D.ID,
                               D.HOTEN,
                               I.TEN             AS TENTC
        --,h1.MA_TEN as Tamtru
                               ,
                               D.TAMTRUCHITIET   AS TAMTRU,
                               I.MA,
--                               CONCAT(CB.HOTEN, '-' || D.CHUCVU_CHUCDANH) AS CHUCVUCHUCDANH,
                               D.NGAYTHAMGIA,
                               D.NGAYKETTHUC,
                               D.NGUOITAO,
                               D.NGAYTAO,
                               D.HOTEN
--                               (
--                                   SELECT
--                                       LISTAGG(D.HOTEN, '<br/>') WITHIN GROUP(
--                                           ORDER BY
--                                               ID
--                                       ) AS DESCRIPTION
--                                   FROM
--                                       XLHC_DUONGSU A
----                                   WHERE
----                                       A.DUONGSUID LIKE '%,'
----                                                        || A.ID
----                                                        || ',%'
--                               ) HOTEN
                           FROM
                               XLHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG   D
                               LEFT JOIN DM_DATAITEM                          I ON I.MA = D.TUCACHTGTTID
                               LEFT JOIN DM_HANHCHINH                         H1 ON H1.ID = D.TAMTRUID
--                               LEFT JOIN DM_CANBO                             CB ON D.NGUOIPHANCONGID = CB.ID
                           WHERE
                               D.DONID = VDONID
                           ORDER BY
                               D.HOTEN;

    END XLHC_PHUCTHAM_KCKN_TGTT_GETLIST;
   
   PROCEDURE XLHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        CHECKBANANPT NUMBER;
    BEGIN
        SELECT
            COUNT(ID)
        INTO CHECKBANANPT
        FROM
            XLHC_PHUCTHAM_BANAN
        WHERE
            DONID = VDONID;

        OPEN CURRETURN FOR SELECT
                              NVL(CHECKBANANPT, 0) CHECKBANANPT,
                              D.ID,
                              (
                                  CASE MAVAITRO
                                      WHEN 'THAMPHAN'           THEN
                                          'Thẩm phán chủ tọa phiên tòa'
                                      WHEN 'THAMPHANHDXX'       THEN
                                          'Thẩm phán thành viên hội đồng xét xử'
                                      WHEN 'THAMPHANDUKHUYET'   THEN
                                          'Thẩm phán dự khuyết'
                                      WHEN 'HTND'               THEN
                                          'Hội thẩm nhân dân'
                                      WHEN 'THUKY'              THEN
                                          'Thư ký'
                                      WHEN 'KSV'                THEN
                                          'Kiểm sát viên'
                                      WHEN 'THUKYDUKHUYET'		THEN
                                      	  'Thư ký dự khuyết'
                                  END
                              ) AS TENVAITRO,
                              CASE
                                  WHEN D.MAVAITRO = 'KSV' THEN
                                      V.HOTEN
                                  ELSE
                                      C.HOTEN
                              END AS TENNGUOITHTT,
                              D.NGAYTHAMGIA,
                              D.NGAYKETTHUC,
                              D.NGAYPHANCONG,
                              D.NGAYNHANPHANCONG,
                              D.NGUOITAO,
                              D.NGAYTAO,
                              E.HOTEN AS NGUOIPHANCONG
                          FROM
                              XLHC_KCKNQDK_PHUCTHAM_HDXX   D
                              LEFT JOIN DM_CANBO                    C ON C.ID = D.CANBOID
                              LEFT JOIN DM_CANBO                    E ON E.ID = D.NGUOIPHANCONGID
                              LEFT JOIN DM_CANBOVKS                 V ON V.ID = D.CANBOID
                          WHERE
                              D.DONID = VDONID
                          ORDER BY
                              D.HOTEN;

    END XLHC_KCKNQDK_PHUCTHAM_HDXX_GETLIST;
   
   PROCEDURE XLHC_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN CURRETURN FOR SELECT
                               Q.ID,
                               Q.SOQD,
                               Q.NGAYQD,
                               Q.CHUCVU,
                               D.TEN
                               || DECODE(Q.HINHTHUCXETXU, 1, ' (Xử/Họp kín trực tuyến)', 2, ' (Xử/Họp kín trực tiếp)',
                                         3, ' (Xử/Họp công khai trực tuyến)', 4, ' (Xử/Họp công khai trực tiếp)', 5,
                                         ' (Không xác định hình thức xét xử)', '') AS TENQD,
                               C.HOTEN   AS NGUOIKY,
                               Q.HIEULUCTU,
                               Q.HIEULUCDEN,
                               LD.TEN    AS LYDO,
                               Q.NGAYTAO,
                               Q.NGUOITAO,
                               Q.TENFILE,
                               D.TEN AS TenQD
                           FROM
                               XLHC_KCKNQDK_PHUCTHAM_QUYETDINH   Q
--                               LEFT JOIN ADS_FILE                         F ON F.ID = Q.FILEID
                               LEFT JOIN DM_QD_QUYETDINH_LYDO             LD ON LD.ID = Q.LYDOID
                               INNER JOIN DM_QD_QUYETDINH                  D ON D.ID = Q.QUYETDINHID
                                                               AND ( D.ISDANSU = 1
                                                                     AND D.ISPHUCTHAM = 1
                                                                     AND D.TEN NOT LIKE '%Quyết định phúc thẩm giải quyết việc dân sự%'
                                                                     AND D.MA NOT IN (
                                   '72-DS',
                                   '69-DS',
                                   '70-DS'
                               ) ) --thêm điều kiện not in 
                               LEFT JOIN DM_CANBO                         C ON C.ID = Q.NGUOIKYID
                           WHERE
                               Q.DONID = VDONID
                           ORDER BY
                               Q.NGAYQD;

    END XLHC_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST;
   
   PROCEDURE XLHC_KCKN_PHUCTHAM_THULY_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        VGROUPTHGIAONHAN NUMBER;
    BEGIN
        SELECT
            ID
        INTO VGROUPTHGIAONHAN
        FROM
            DM_DATAGROUP
        WHERE
            MA = 'TRUONGHOP_GIAONHAN';

        OPEN CURRETURN FOR SELECT
                              T.ID,
                              T.MATHULY,
                              THTL.TEN                AS TENTRUONGHOPTHULY
    --,qhpl.TEN as QuanHePL,qhpltk.CASE_NAME as QuanHePLTK
                              ,
                              T.QUANHEPHAPLUAT_NAME   AS QUANHEPL,
                              QHPLTK.CASE_NAME        AS QUANHEPLTK,
                              T.NGAYTHULY,
                              T.SOTHULY,
--                              T.FILEID,
--                              T.TENFILE,
                              T.THOIHANTUNGAY,
                              T.SOTHONGBAO,
                              T.NGAYTHONGBAO,
                              T.NGUOIKY,
                              T.THOIHANDENNGAY,
                              T.NGAYTAO,
                              T.NGUOITAO
                          FROM
                              XLHC_KCKNQDK_PHUCTHAM_THULY   T
--                              LEFT JOIN ADS_FILE                     F ON F.ID = T.FILEID
                              LEFT JOIN (
                                  SELECT
                                      A.ID,
                                      A.TEN
                                  FROM
                                      DM_DATAITEM A
                                  WHERE
                                      A.GROUPID = VGROUPTHGIAONHAN
                                      AND A.MA IN (
                                          '02',
                                          '03',
                                          '04'
                                      )
                              ) THTL ON THTL.ID = T.TRUONGHOPTHULY
  --left join DM_DATAITEM qhpl on qhpl.ID=t.QUANHEPHAPLUATID
                              LEFT JOIN DM_QHPL_TK                   QHPLTK ON QHPLTK.ID = T.QHPLTKID
                          WHERE
                              T.DONID = VDONID
                          ORDER BY
                              T.NGAYTHULY DESC;

    END XLHC_KCKN_PHUCTHAM_THULY_GETLIST;
   
   PROCEDURE XLHC_KCKN_DON_THAMPHAN_GETBY (
        VDONID      IN    NUMBER,
        VMAVAITRO   IN    NVARCHAR2,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        CHECKBANANPT NUMBER;
    BEGIN
        SELECT
            COUNT(ID)
        INTO CHECKBANANPT
        FROM
            XLHC_PHUCTHAM_BANAN
        WHERE
            DONID = VDONID;

        OPEN CURRETURN FOR SELECT
                              NVL(CHECKBANANPT, 0) CHECKBANANPT,
                              D.ID,
                              D.NGAYPHANCONG,
                              D.NGAYNHANPHANCONG,
                              D.NGAYTHAMGIA,
                              D.NGAYKETTHUC,
                              D.NGUOITAO,
                              D.NGAYTAO,
                              C3.HOTEN   AS THUKY,
                              D.CANBOID,
                              D.NGUOIPHANCONGID,
                              C1.HOTEN   AS TENTHAMPHAN,
                              C2.HOTEN   AS THAMPHANPHANCONG
                          FROM
                              XLHC_DON_THAMPHAN   D
                              LEFT JOIN DM_CANBO           C1 ON C1.ID = D.CANBOID
                              LEFT JOIN DM_CANBO           C2 ON C2.ID = D.NGUOIPHANCONGID
                              LEFT JOIN DM_CANBO           C3 ON C3.ID = D.THUKYID
                              LEFT JOIN (
                                  SELECT
                                      MA,
                                      TEN
                                  FROM
                                      DM_DATAITEM
                                  WHERE
                                      GROUPID = (
                                          SELECT
                                              ID
                                          FROM
                                              DM_DATAGROUP
                                          WHERE
                                              MA = 'VAITROTHAMPHAN'
                                      )
                              ) I ON I.MA = D.MAVAITRO
                          WHERE
                              D.DONID = VDONID
                              AND 1 = (
                                  CASE
                                      WHEN VMAVAITRO = ''         THEN
                                          1
                                      WHEN D.MAVAITRO = VMAVAITRO THEN
                                          1
                                      ELSE
                                          0
                                  END
                              );

    END XLHC_KCKN_DON_THAMPHAN_GETBY;

   PROCEDURE XLHC_PHUCTHAMQDK_BANANQUYETDINH_GETLIST (
        VDONID      IN    NUMBER,
        CURRETURN   OUT   SYS_REFCURSOR
    ) IS
        COUNTBANANST INT;
    BEGIN

    --select count(ID) into CountBanAnST from ADS_PHUCTHAM_BANAN where DonID = vDONID;    

    --------------------------
        OPEN CURRETURN FOR SELECT
                               Q.ID,
                               Q.SOBANAN,
                               Q.NGAYTUYENAN ,
                               Q.KETQUAPHUCTHAMID ,
                               D.TEN     AS TENQD,
                               LD.TEN    AS LYDO,
                               Q.NGAYTAO,
                               Q.NGUOITAO,
                               T.TEN     TENTOAAN,
                               F.TENFILE,
                               0 ISBANANST
                           FROM
                               XLHC_PHUCTHAM_BANAN   Q
                               LEFT JOIN XLHC_PHUCTHAM_BANAN_FILE 	 	  F ON F.BANANID = Q.DONID
                               LEFT JOIN DM_KETQUA_PHUCTHAM_LYDO          LD ON LD.ID = Q.LYDOBANANID 
                               INNER JOIN DM_KETQUA_PHUCTHAM              D ON D.ID = Q.KETQUAPHUCTHAMID
                               LEFT JOIN DM_TOAAN                         T ON T.ID = Q.TOAANID
                           WHERE
                               Q.DONID = VDONID
                           ORDER BY
                               Q.NGAYTUYENAN;

    END XLHC_PHUCTHAMQDK_BANANQUYETDINH_GETLIST;

END PKG_STPT_XLHC_VNPTV2;

/
