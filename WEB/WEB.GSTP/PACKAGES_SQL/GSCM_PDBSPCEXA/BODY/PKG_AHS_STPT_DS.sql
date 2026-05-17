--------------------------------------------------------
--  DDL for Package Body PKG_AHS_STPT_DS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_AHS_STPT_DS" AS

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
    v_HINHTHUCXX in number,
    v_GDTaoHS in number,
	V_VAITRO_THAMPHAN IN VARCHAR2,
    Page_Index in	int,
    Page_Size	in	int, 
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_AHS_THAMPHANGIAIQUYET;
    VV_TUNGAY DATE;VV_DENNGAY DATE;  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;
    V_TABLE_TLST T_QUYETDINH;V_TABLE_TLPT T_QUYETDINH;
    V_TABLE_THAMPHAN T_THAMPHAN_EXT;--TOANCAU-03102023-ANHNT
--    V_TABLE_HDXX_ST T_QUYETDINH;V_TABLE_HDXX_PT T_QUYETDINH;  
--    V_TABLE_TP T_QUYETDINH;
    V_TABLE_ST T_QUYETDINH;V_TABLE_PT T_QUYETDINH;
    V_TABLE_BC T_AHS_BICANBICAO; V_TABLE_BC_KC T_AHS_BICANBICAO;
    V_TABLE_TGTT T_AHS_BICANBICAO; V_TABLE_TGTT_KC T_AHS_BICANBICAO;        
BEGIN	
    -- edit by anhvh 02/03/2020     
    -- Giai đoạn vụ án/vụ việc
    -- SOTHAM = 2;PHUCTHAM = 3;THULYGDT = 4;  --//(DINHCHI = 5;HOSO = 1;)đã xóa 2 gai đoạn này vì không phù hợp với nghiệp vụ tòa án
    --v_Capxx: SOTHAM = 2;PHUCTHAM = 3
     V_TABLE_TLST := T_QUYETDINH();  V_TABLE_TLPT := T_QUYETDINH();
     V_TABLE_THAMPHAN := T_THAMPHAN_EXT();--TOANCAU-03102023-ANHNT
--     V_TABLE_HDXX_ST := T_QUYETDINH(); V_TABLE_HDXX_PT := T_QUYETDINH();   
--     V_TABLE_TP := T_QUYETDINH();
     V_TABLE_ST := T_QUYETDINH();V_TABLE_PT := T_QUYETDINH();
     V_TABLE_BC := T_AHS_BICANBICAO();V_TABLE_BC_KC := T_AHS_BICANBICAO();
     V_TABLE_TGTT := T_AHS_BICANBICAO();V_TABLE_TGTT_KC := T_AHS_BICANBICAO();
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
      --THAMPHAN --TOANCAU-03102023-ANHNT
		SELECT R_THAMPHAN_EXT(TP.VUANID,TP.ID,TP.CANBOID,TP.MAVAITRO,TP.MAGIAIDOAN,TP.NGAYPHANCONG)
		BULK COLLECT INTO V_TABLE_THAMPHAN
		FROM (
			SELECT  MAVAITRO,VUANID,ID,CANBOID, ROW_NUMBER()  OVER (PARTITION BY VUANID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,
            (CASE WHEN MAVAITRO IN( 'VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETDON') THEN 2 WHEN MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' THEN 3 END) MAGIAIDOAN
            FROM AHS_THAMPHANGIAIQUYET WHERE MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,VUANID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY VUANID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,2 MAGIAIDOAN
            FROM  AHS_SOTHAM_HDXX WHERE MAVAITRO IN ('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')
            UNION
            SELECT cast(MAVAITRO as nvarchar2(20)) MAVAITRO,VUANID,ID,CANBOID,ROW_NUMBER()  OVER (PARTITION BY VUANID,MAVAITRO ORDER BY NGAYPHANCONG DESC) ROWNUMBER,NGAYPHANCONG,3 MAGIAIDOAN
            FROM  AHS_PHUCTHAM_HDXX WHERE MAVAITRO IN('THAMPHAN','THAMPHANHDXX','THAMPHANDUKHUYET')) TP
        WHERE ((TP.ROWNUMBER = 1 AND TP.MAVAITRO IN ('VTTP_GIAIQUYETDON','VTTP_GIAIQUYETSOTHAM','VTTP_GIAIQUYETPHUCTHAM','THAMPHAN','THAMPHANHDXX')
        OR TP.MAVAITRO = 'THAMPHANDUKHUYET'));
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
         ---V_TABLE_TGTT; tạo bảng  lấy NguoiTGTT  khang cao  manhnd    
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TenTuCachTGTT,null,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_TGTT_KC
            FROM(SELECT TG.ID,TG.VUANID,TG.HOTEN,TG.TenTuCachTGTT,TG.ROWNUMBER FROM 
                        (   SELECT a.ID, a.VuAnId, a.HoTen,c.Ten TenTuCachTGTT, ROW_NUMBER()  OVER (PARTITION BY a.VUANID ORDER BY a.HoTen asc) ROWNUMBER
                            FROM  AHS_NguoiThamGiaToTung a
                                inner join AHS_NguoiThamGiaToTung_TuCach b on a.ID = b.NguoiID
                                inner join DM_DataItem c on b.TuCachID = c.ID
                            WHERE EXISTS(SELECT 'X' FROM AHS_SOTHAM_KHANGCAO KC WHERE KC.NGUOIKCID=a.ID AND KC.VUANID=a.VUANID and KC.NGUOIKCLOAI = 1)
                        )TG 
                    where TG.ROWNUMBER <=3
                )TTS;  
    -----------------
    OPEN curReturn FOR
    select tt.* from (
      SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,COUNT(*) OVER () as CountAll,a.ID, a.MaVuAn, a.TenVuAn, a.TT, a.NgayBanCaoTrang,
            DECODE(GD.MAGIAIDOAN,2, A.NGUOITAO,3,GN.NGUOITAO_PHUCTHAM,'') NGUOITAO, 
            DECODE(GD.MAGIAIDOAN,2, to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS'),
                            3, to_char(GN.NGAYTAO_PHUCTHAM,'dd/MM/yyyy')||'<br/>'||to_char(GN.NGAYTAO_PHUCTHAM,' HH24:MI:SS'),
                            '') NGAYTAO, 
            a.MaGiaiDoan, 
            DECODE(GD.MAGIAIDOAN,3,BC3.HoTen || TG3.HoTen,BC2.HoTen) HoTenBiCan, decode(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||b.Ten||'</b>',null) TenToaSoTham, 
            DECODE(GD.MAGIAIDOAN,3,GN.TruongHopGiaoNhan,Decode(A.TRUONGHOPGIAONHAN,270,'Xét xử lại cấp sơ thẩm',AA.TruongHopGiaoNhan))TruongHopGiaoNhan,
            NULL HINHTHUCNHANDON,
            DECODE(GD.MAGIAIDOAN,2, 'Sơ thẩm'  , 3, 'Phúc thẩm' , 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec,
            DECODE(A.GDTAOHS,1, 'Thi hành án - Từ '||TOAANID_GDTAOHS.TEN  , 2, 'Phúc thẩm - Từ '||TOAANID_GDTAOHS.TEN , 3, 'Giám đốc thẩm - Từ '||TOAANID_GDTAOHS.TEN,'Sơ thẩm')  GiaiDoanTaoHoSo,
            STBA.BANAN_QD_ST, STKN.KHANGNGHI_ST, DECODE(GD.MAGIAIDOAN,2,BC3.hoten,'') KHANGCAO_ST--,STKC.KHANGCAO_ST
            ,PTQD.QD_PT, --toancau thêm qd tđc số..ngày,.,.
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
            INNER JOIN (SELECT G.* FROM AHS_VUAN_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD  ON A.ID=GD.VUANID--Điều kiện để hiển thị 1 bản ghi duy nhất theo giai đoạn xét xử (tránh hiển thị 2 giai đoạn ở ST và PT ở tòa tỉnh) tuanvna
            LEFT JOIN DM_TOAAN TOAANID_GDTAOHS ON A.TOAANID_GDTAOHS = TOAANID_GDTAOHS.ID
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

            LEFT JOIN ( 
                       SELECT TP.DONID VUANID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
                     FROM TABLE(V_TABLE_THAMPHAN) TP
                          LEFT JOIN TABLE(V_TABLE_THAMPHAN) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 2
                     LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                          LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
                     WHERE TP.MAGIAIDOAN = 2 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETSOTHAM'
                          GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>'
                          )TPPC ON TPPC.VUANID=A.ID AND GD.MAGIAIDOAN=2

            LEFT JOIN (  
                        SELECT TP.DONID VUANID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>' TINHTRANG_GQ
					FROM TABLE(V_TABLE_THAMPHAN) TP
                    LEFT JOIN TABLE(V_TABLE_THAMPHAN) HDXX ON HDXX.DONID = TP.DONID AND HDXX.MAVAITRO = 'THAMPHAN' AND HDXX.MAGIAIDOAN = 3
					LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
                    LEFT JOIN DM_CANBO CBHDXX ON CBHDXX.ID=HDXX.CANBOID  
					WHERE TP.MAGIAIDOAN = 3 AND TP.MAVAITRO  = 'VTTP_GIAIQUYETPHUCTHAM'
                    GROUP BY TP.DONID,'</br>- Thẩm phán: <b>' ||TO_CHAR(DECODE(CBHDXX.HOTEN,NULL,CB.HOTEN,CBHDXX.HOTEN))||'</b><i> (chủ tọa)</i>'
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
                            CNA.ID, CNA.VUANID, CNA.TOACHUYENID, CNA.TINHTRANG_GQ
                        FROM
                            (
                                SELECT CA.ID, CA.VUANID, CA.TOACHUYENID,CA.MAP_VUANID_NEW,CA.NGAYTAO,
                                    '</br>- ' || I.TEN || '</br>- Đã chuyển vụ án' TINHTRANG_GQ,
                                    ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.NGAYTAO DESC ) RN
                                FROM
                                         AHS_CHUYEN_NHAN_AN CA
                                    INNER JOIN DM_DATAITEM I ON CA.TRUONGHOPGIAONHANID = I.ID
                                WHERE CA.TOACHUYENID = v_toaan_id
                            ) CNA
                        WHERE CNA.RN = 1
                        AND NOT EXISTS (SELECT 'X' FROM AHS_CHUYEN_NHAN_AN CN2 WHERE CN2.VUANID = CNA.MAP_VUANID_NEW AND CN2.TOANHANID = v_toaan_id AND CN2.NGAYTAO > CNA.NGAYTAO)
                  )GNST ON  GNST.VUANID=a.ID AND GD.MAGIAIDOAN=2             

            -------trường hợp giao nhân dùng cho sơ thẩm với viện kiểm sát
            LEFT JOIN (SELECT A1.ID, DECODE(A1.TruongHopGiaoNhan,1, 'VKS bàn giao hồ sơ sang Tòa án để xét xử sơ thẩm',2,'Tòa án trả hồ sơ - VKS chấp nhận điều tra bổ sung',3, 'Tòa án trả hồ sơ - VKS không chấp nhận điều tra bổ sung',''
                       ) TruongHopGiaoNhan  FROM AHS_VUAN A1) AA ON AA.ID=A.ID

            -------trường hợp giao nhân dùng cho phúc thẩm với lý do chuyển nhận án, tên trường hợp được định nghĩa trong bảng DM_DATAITEM--ví dụ:Do có kháng cáo phúc thẩm
--            LEFT JOIN (SELECT CA.VUANID,i.TEN TruongHopGiaoNhan FROM DM_DATAITEM i 
--                     INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID WHERE CA.TOANHANID=v_toaan_id group by CA.VUANID,i.TEN  
--                      )GN ON  GN.VUANID=a.ID
            --toancau
            LEFT JOIN (SELECT
                            CNA.VUANID,CNA.TruongHopGiaoNhan, CNA.NGUOITAO_PHUCTHAM, CNA.NGAYTAO_PHUCTHAM
                        FROM
                            (
                                SELECT CA.VUANID,i.TEN TruongHopGiaoNhan, CA.NGUOITAO_PHUCTHAM, CA.NGAYTAO_PHUCTHAM, ROW_NUMBER() OVER(PARTITION BY CA.VUANID, CA.TOACHUYENID ORDER BY CA.ID DESC ) RN FROM DM_DATAITEM i 
                                INNER JOIN AHS_CHUYEN_NHAN_AN CA ON CA.TRUONGHOPGIAONHANID=i.ID 
                                WHERE CA.TOANHANID=v_toaan_id
                            ) CNA
                        WHERE CNA.RN = 1)GN ON GN.VUANID=a.ID
            --toancau

            ------bị cáo lấy cho sơ thẩm
            LEFT JOIN( SELECT BC.VUANID,'<br/><i>Bị cáo:</i> <br />'
                        ||LISTAGG(DECODE(BC.BICANDAUVU,1,'<b>'||BC.HOTEN ||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)||' (đầu vụ)</b>',BC.HOTEN||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)),'<br/>') 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)HOTEN FROM  TABLE(V_TABLE_BC) BC
                        GROUP BY BC.VUANID   
                 ) BC2 ON BC2.VUANID=A.ID      
            ------lấy tội danh của bị cáo đầu vụ
            LEFT JOIN( SELECT BC.VUANID,LISTAGG(BC.TENTOIDANH) 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)TENTOIDANH FROM  TABLE(V_TABLE_BC) BC where BC.BICANDAUVU=1
                        GROUP BY BC.VUANID   
                 ) BC4 ON BC4.VUANID=A.ID 
             ------bị cáo kháng cáo lấy cho phúc thẩm 
            LEFT JOIN(SELECT BC.VUANID,'<br/><i>Bị cáo kháng cáo:</i> <br />'
                        ||LISTAGG(DECODE(BC.BICANDAUVU,1,'<b>'||BC.HOTEN ||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)||' (đầu vụ)</b>',BC.HOTEN||DECODE(BC.TENTOIDANH,NULL,NULL,' - '||BC.TENTOIDANH)),'<br/>') 
                        WITHIN GROUP (ORDER BY BC.ROWNUMBER)HOTEN FROM  TABLE(V_TABLE_BC_KC) BC
                        GROUP BY BC.VUANID 
                 )BC3 ON BC3.VUANID=A.ID
            ------NguoiTGTT cáo kháng cáo lấy cho phúc thẩm manhnd
            LEFT JOIN(SELECT TG.VUANID,'<br/><i>Người TGTT kháng cáo: </i>'
                        ||XMLAGG(XMLELEMENT(TG,TG.HOTEN||DECODE(TG.TENTOIDANH,NULL,NULL,' ('||TG.TENTOIDANH)||')','; ').EXTRACT('//text()') ).GetClobVal() AS HOTEN
                        FROM  TABLE(V_TABLE_TGTT_KC) TG
                        GROUP BY TG.VUANID 
                 )TG3 ON TG3.VUANID=A.ID
            ------- lấy thông tin BA/sơ thẩm                
            LEFT JOIN(SELECT BA.VUANID,'<br />BA/QĐ sơ thẩm: <b>'||'Số '||BA.SOBANAN||' ngày '||TO_CHAR(BA.NGAYBANAN,'dd/MM/yyyy')||'</b>' BANAN_QD_ST FROM AHS_SOTHAM_BANAN BA)STBA ON STBA.VUANID=A.ID 
                   ---------------------------- toancau them qđ tđc 
                                          LEFT JOIN (
                                          SELECT
                                              PTQD.VUANID,
                                              '<br /><i>QĐ GQ PT: </i><b>'
                                              || 'Số '
                                              || PTQD.SOQUYETDINH
                                              || ' ngày '
                                              || TO_CHAR(PTQD.NGAYQD, 'dd/MM/yyyy')
                                              || '</b>' QD_PT
                                          FROM
                                              AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN PTQD
                                          WHERE
                                              QUYETDINHID = 324
                                      ) PTQD ON PTQD.VUANID = A.ID     
            ------- lấy thông tin số ngày kháng nghị
           LEFT JOIN ( SELECT KN.VUANID,
                     '<br /><i>Kháng nghị:</i> <br />'|| 
                      listagg ('Số '||KN.SOKN||' ngày '||TO_CHAR(KN.NGAYKN,'dd/MM/yyyy'), '<br/>') WITHIN GROUP (ORDER BY KN.NGAYKN) KHANGNGHI_ST
                      FROM  (SELECT DISTINCT KN.VUANID, DECODE(KN.LOAIKN,3,QD.SOQUYETDINH,QDVA.SOQUYETDINH) SOKN, KN.NGAYKN FROM AHS_SOTHAM_KHANGNGHI KN
                      LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QD ON QD.ID = KN.BANANID AND KN.LOAIKN = 3
                    LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QDVA ON QDVA.ID = KN.BANANID AND KN.LOAIKN IN (1,2)
                    WHERE KN.LOAIKN IN (1,2,3)) KN
                      GROUP BY KN.VUANID
              )STKN ON STKN.VUANID=A.ID 

               -- lấy thông tin số ngày kháng cáo
            LEFT JOIN (
              SELECT
                  KC.VUANID,

                  '<br /><i>Kháng cáo:</i> <br />'
                  || LISTAGG('Số ' || KC.SOQDBA || ' ngày ' || TO_CHAR(KC.NGAYKHANGCAO, 'dd/MM/yyyy'), '<br/>') WITHIN GROUP(
                          ORDER BY KC.NGAYKHANGCAO ) KHANGCAO_ST
              FROM
                  (SELECT DISTINCT KC.VUANID,DECODE( KC.LOAIKHANGCAO,3,QD.SOQUYETDINH,QDVA.SOQUYETDINH) SOQDBA, KC.NGAYKHANGCAO FROM AHS_SOTHAM_KHANGCAO KC
                  LEFT JOIN AHS_SOTHAM_QUYETDINH_BICAN QD ON QD.ID = KC.SOQDBA AND KC.LOAIKHANGCAO = 3
                  LEFT JOIN AHS_SOTHAM_QUYETDINH_VUAN QDVA ON QDVA.ID = KC.SOQDBA AND KC.LOAIKHANGCAO IN (1,2)
                  WHERE KC.LOAIKHANGCAO IN (1,2,3)) KC
              GROUP BY
                  KC.VUANID
          ) STKC ON STKC.VUANID = a.id
            -------
            WHERE (V_TEN_VU_AN IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TEN_VU_AN)||'%' ) )
                 AND (V_UTTP IS NULL
                         OR (V_UTTP IS NOT NULL 
                          AND ( EXISTS ( SELECT 'X' FROM AHS_SOTHAM_THULY TL
                                            WHERE TL.UTTPDI = to_number(V_UTTP) and TL.VUANID = A.ID AND GD.MAGIAIDOAN=2)
                                       OR  EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_THULY TLPT 
                                          WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.VUANID = A.ID AND GD.MAGIAIDOAN=3)
                            )  ) )
                AND (V_TOIDANH IS NULL  OR ( LOWER(BC4.TENTOIDANH) LIKE  '%'||LOWER(V_TOIDANH)||'%' ) )--tìm tội danh đã được gắn vào tên vụ án A.TENVUAN
                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
                AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  LOWER(V_MA_VU_AN) ) )
                AND (V_BI_CAN IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(V_BI_CAN))||'%' AND BC.VUANID=A.ID)
                    )                
            -----
             ----toancau tuyennh 31/07/2023 sửa tình trạng thụ lý start
                  AND ( (v_TINHTRANG_THULY IS NULL 

                       AND( 
                        (GD.MAGIAIDOAN = 2 AND (V_NGAYTHULY_TU IS NULL OR  A.NGAYBANCAOTRANG >=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR A.NGAYBANCAOTRANG <=VV_NGAYTHULY_DEN) )
                        OR EXISTS ( SELECT 'X' FROM AHS_CHUYEN_NHAN_AN CNA WHERE GD.MAGIAIDOAN = 3 AND (V_NGAYTHULY_TU IS NULL OR  CNA.NGAYNHAN >=VV_NGAYTHULY_TU) AND (V_NGAYTHULY_DEN IS NULL OR CNA.NGAYNHAN <=VV_NGAYTHULY_DEN) ) )                          
--                  AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYTAO>=VV_NGAYTHULY_TU) 
--                  AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYTAO<=VV_NGAYTHULY_DEN)

                  )
                    OR(v_TINHTRANG_THULY=1 --đã thaụ lý
                         AND ( EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                                               AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                               AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                                           ) 
                               OR EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                                    AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                                    AND (V_NGAYTHULY_DEN IS NULL OR TL.NGAYTHULY<=VV_NGAYTHULY_DEN) 
                          )   )  ) 
                    OR(v_TINHTRANG_THULY=2 --chưa thụ lý
                     AND (
                     (( NOT EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=2) 
                           AND NOT EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL where TL.VUANID=a.id and GD.MAGIAIDOAN=3) 
                        )
                     AND (V_NGAYTHULY_TU IS NULL OR  a.NGAYBANCAOTRANG>=VV_NGAYTHULY_TU) 
                     AND (V_NGAYTHULY_DEN IS NULL OR a.NGAYBANCAOTRANG<=VV_NGAYTHULY_DEN)      
                    )
                    OR
                    (  EXISTS(SELECT 'x' from AHS_SOTHAM_THULY TL 
                        where TL.VUANID=a.id and GD.MAGIAIDOAN=2
                        --AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                        AND (V_NGAYTHULY_DEN IS NOT NULL AND TL.NGAYTHULY>VV_NGAYTHULY_DEN)
                        ) 
                           OR 
                       EXISTS(SELECT 'x' from AHS_PHUCTHAM_THULY TL 
                       where TL.VUANID=a.id and GD.MAGIAIDOAN=3
                       --AND (V_NGAYTHULY_TU IS NULL OR  TL.NGAYTHULY>=VV_NGAYTHULY_TU) 
                       AND (V_NGAYTHULY_DEN IS NOT NULL AND TL.NGAYTHULY>VV_NGAYTHULY_DEN)
                       ) 
                        )
                    )
                    )
                )
                ----toancau tuyennh 31/07/2023 sửa tình trạng thụ lý end
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
                                WHERE 
                                ----toancau tuyennh add 31/07/2023 thêm mã quyết định giữ nguyên bản án sơ thẩm
                                --KQPT.MA='01'--HP.MAHINHPHAT!='TUHINH' AND
                                KQPT.MA IN ('01','10','19','18')
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
                                ----toancau tuyennh add 31/07/2023 thêm mã quyết định hủy bản án sơ thẩm
                                KQPT.MA IN ('03','04','06','13','14','12','15','21')
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
             AND (v_thamphan_id is null
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
            AND ( (v_TINHTRANG_GIAIQUYET IS NULL  
            AND (V_TUNGAY IS NULL OR  a.NGAYTAO>=VV_TUNGAY) 
            AND (V_DENNGAY IS NULL OR a.NGAYTAO<=VV_DENNGAY) 
            )
            ----toancau tuyennh 31/07/2023 sửa tình trạng giải quyết start
                OR(v_TINHTRANG_GIAIQUYET=1 --Chưa giải quyết xong
                   AND 
                    ( (EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_THULY TL
                                 WHERE
                                TL.VUANID=a.id  AND GD.MAGIAIDOAN=2                                                   
                               )
                         AND(

                         EXISTS(
                                        SELECT
                                              'X'
                                          FROM
                                              AHS_SOTHAM_QUYETDINH_VUAN   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA IN (
                                                  '30-HS',
                                                  '33-HS',
                                                  '34-HS',
                                                  '39-HS',
                                                  '40-HS'
                                              ) 
                                              AND PTQDVA.VUANID = A.ID
                                              AND A.MAGIAIDOAN = 2
                                              AND PTQDVA.NGAYQD IS NOT NULL AND V_DENNGAY IS NOT NULL AND VV_DENNGAY<PTQDVA.NGAYQD
                                          ) 
                                          OR
                                           EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                                WHERE 
                                --BA.ID IS NOT NULL
                                    --AND (V_TUNGAY IS NULL OR  BA.NGAYBANAN>=VV_TUNGAY)
                                    --AND 
                                    (V_DENNGAY IS NOT NULL OR BA.NGAYBANAN>VV_DENNGAY)
                                    AND BA.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                 )
                         OR(
                            NOT EXISTS(
                              SELECT
                                              'X'
                                          FROM
                                              AHS_SOTHAM_QUYETDINH_VUAN   PTQDVA
                                              LEFT JOIN DM_QD_QUYETDINH                  QD ON QD.ID = PTQDVA.QUYETDINHID
                                              LEFT JOIN DM_QD_LOAI                       QDL ON QDL.ID = QD.LOAIID
                                          WHERE
                                              QD.MA IN (
                                                  '30-HS',
                                                  '33-HS',
                                                  '34-HS',
                                                  '39-HS',
                                                  '40-HS'
                                              ) 
                                              AND PTQDVA.VUANID = A.ID
                                              AND A.MAGIAIDOAN = 2
                                          )
                                  AND
                                 NOT EXISTS (
                                SELECT 'X' FROM  AHS_SOTHAM_BANAN BA 
                                WHERE 
                                     BA.VUANID=A.ID AND GD.MAGIAIDOAN=2
                                 )
                              AND (
                              --điều kiện con số 2
                         EXISTS ( 
                        SELECT 'X' FROM AHS_SOTHAM_THULY STTL
                        WHERE
                        STTL.VUANID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                         --điều kiện con số 3
                        OR EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND (
                                     (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     --OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                                --AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) 
                                AND (V_DENNGAY IS NOT NULL and pc.NGAYPHANCONG>VV_DENNGAY)       
                               )
                         --điều kiện con số 4
                         OR EXISTS (
                            SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            --AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NOT NULL and QSV.NGAYQD>VV_DENNGAY)
                            AND QSV.VUANID=A.ID AND GD.MAGIAIDOAN=2
                        )
                         --điều kiện con số 5
                         OR EXISTS (
                                SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE ( QDL.MA ='HPT'
                                OR INSTR(',43-HS,44-HS,',','||QD.MA||',')>0) --hoãn phiên tòa
                                --AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NOT NULL AND QSV.NGAYQD>VV_DENNGAY)
                                AND QSV.VUANID=a.id  AND GD.MAGIAIDOAN=2
                             )
                         --điều kiện con số 6
                         OR EXISTS (
                            SELECT 'X' FROM  AHS_SOTHAM_QUYETDINH_VUAN QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            LEFT JOIN AHS_SOTHAM_BANAN BA ON QSV.VUANID =BA.VUANID
                            WHERE QDL.MA ='TDC'
                            AND BA.VUANID IS NOT NULL
                            --INSTR(',TDC,',','||QDL.MA||',')>0 -- 'TDC' Tam dinh chi
                            --AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NOT NULL AND QSV.NGAYQD>VV_DENNGAY)
                            AND QSV.VUANID =A.ID  AND GD.MAGIAIDOAN=2
                             )
                              )            
                         )



                         )      
                        )
                        --Phúc thẩm
                        OR ( EXISTS (
                                SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                                WHERE 
                                (NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_BANAN BA WHERE BA.VUANID= PTTL.VUANID)
                                  AND NOT EXISTS ( SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN T1 
                                                 LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=T1.QUYETDINHID     
                                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                                WHERE INSTR(',DC,CVA,TRAHS,',','||QDL.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                             AND(
                             --điều kiện con 2
                             EXISTS( 
                        SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.VUANID = A.ID
                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                            --điều kiện con 3
                           OR
                           EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND (
                                     --(PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     --OR
                                     (PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                                AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) 
                                AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)       
                               )
                            --điều kiện con 4
                            OR 
                            EXISTS(
                        SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            LEFT JOIN AHS_PHUCTHAM_BANAN BA ON PTQDVA.VUANID = BA.VUANID
                            WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            --AND PTQDVA.DONID IS NULL
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=A.ID 
                        )
                            --điều kiện con 5
                        OR EXISTS (
                            SELECT 'X' FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=PTQDVA.VUANID 
                            LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR(',43-HS,44-HS,',','||QD.MA||',')>0 --hoãn phiên tòa
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=a.id  AND GD.MAGIAIDOAN=3
                        )     
                            --điều kiện con 6
                             OR EXISTS (
                            SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTQDVA.VUANID --BẢN ÁN
                            WHERE 
                            --PTBA.VUANID IS NULL --Vụ án chưa có bản án
                             QDL.MA='TDC' --Tạm đình chỉ
                            --INSTR(',TDC,',','||QDL.MA||',')>0 --Tạm đình chỉ
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=A.ID  AND GD.MAGIAIDOAN=3
                        )
                             )

                            )
                       )
                   )
                  OR(v_TINHTRANG_GIAIQUYET=2 --chưa phân công Thẩm phán
                  AND ( EXISTS ( 
                        SELECT 'X' FROM AHS_SOTHAM_THULY STTL
                        WHERE
                        STTL.VUANID =  A.ID 
                        AND ( V_TUNGAY IS NULL OR  STTL.NGAYTHULY>=VV_TUNGAY )
                        AND ( V_DENNGAY IS NULL OR  STTL.NGAYTHULY<=VV_DENNGAY )
                            )
                    OR EXISTS(
                        SELECT 'X' FROM AHS_PHUCTHAM_THULY PTTL 
                        WHERE
                        PTTL.VUANID = A.ID

                        AND(V_TUNGAY IS NULL OR  PTTL.NGAYTHULY>=VV_TUNGAY)
                        AND(V_DENNGAY IS NULL OR  PTTL.NGAYTHULY<=VV_DENNGAY)
                             )
                    )

                    AND NOT EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND ((PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                               AND (V_TUNGAY IS NULL OR  PC.NGAYPHANCONG>=VV_TUNGAY) 
                               AND (V_DENNGAY IS NULL OR PC.NGAYPHANCONG<=VV_DENNGAY)      
                               )

                    )
                   OR(v_TINHTRANG_GIAIQUYET=3 --Đã phân công Thẩm phán
                    AND  EXISTS (
                                SELECT 'x' FROM AHS_THAMPHANGIAIQUYET PC 
                                WHERE PC.VUANID=A.ID
                                AND (
                                     (PC.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GD.MAGIAIDOAN=2)--sơ thẩm
                                     OR(PC.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GD.MAGIAIDOAN=3)--phuc thẩm
                                     )
                                AND (V_TUNGAY IS NULL OR  pc.NGAYPHANCONG>=VV_TUNGAY) 
                                AND (V_DENNGAY IS NULL OR pc.NGAYPHANCONG<=VV_DENNGAY)       
                               )
                    )  
                    OR(v_TINHTRANG_GIAIQUYET = 4 --đã lên lịch xét xử

                    AND (
                        EXISTS (
                            SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            --LEFT JOIN ADS_SOTHAM_BANAN BA ON QSV.DONID = BA.DONID
                            WHERE QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.VUANID=A.ID AND GD.MAGIAIDOAN=2
                        )
                        OR EXISTS(
                        SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID = QD.LOAIID
                            LEFT JOIN AHS_PHUCTHAM_BANAN BA ON PTQDVA.VUANID = BA.VUANID
                            WHERE GD.MAGIAIDOAN=3 AND QDL.MA = 'DVARXX'  --QDL.MA = 'DVARXX' == Đưa vụ án ra xét xử
                            --AND PTQDVA.DONID IS NULL
                            AND (V_TUNGAY IS NULL OR   PTQDVA.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                            AND PTQDVA.VUANID=A.ID 
                        )

                    )


               )
                OR(v_TINHTRANG_GIAIQUYET=5 --Đang hoãn  
                   AND (
                     EXISTS (
                                SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QSV.QUYETDINHID
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE ( QDL.MA ='HPT'
                                OR INSTR(',43-HS,44-HS,',','||QD.MA||',')>0) --hoãn phiên tòa
                                AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                AND QSV.VUANID=a.id  AND GD.MAGIAIDOAN=2
                             )
                      --Đang hoãn phuc tham                 
                        OR EXISTS (
                            SELECT 'X' FROM  AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN AHS_PHUCTHAM_THULY PTTL ON PTTL.VUANID=PTQDVA.VUANID 
                            LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTTL.VUANID --BẢN ÁN 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                            WHERE INSTR(',43-HS,44-HS,',','||QD.MA||',')>0 --hoãn phiên tòa
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
                            LEFT JOIN AHS_SOTHAM_BANAN BA ON QSV.VUANID =BA.VUANID
                            WHERE QDL.MA ='TDC'
                            AND BA.VUANID IS NULL
                            --INSTR(',TDC,',','||QDL.MA||',')>0 -- 'TDC' Tam dinh chi
                            AND (V_TUNGAY IS NULL OR   QSV.NGAYQD>=VV_TUNGAY)
                            AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                            AND QSV.VUANID =A.ID  AND GD.MAGIAIDOAN=2
                             )
                     --phuc tham Đang tạm đình chỉ                
                        OR EXISTS (
                            SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA --QUYẾT ĐỊNH 
                            LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=PTQDVA.QUYETDINHID
                            LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID  
                            LEFT JOIN AHS_PHUCTHAM_BANAN PTBA ON PTBA.VUANID=PTQDVA.VUANID --BẢN ÁN
                            WHERE 
                            --PTBA.VUANID IS NULL --Vụ án chưa có bản án
                             QDL.MA='TDC' --Tạm đình chỉ
                            --INSTR(',TDC,',','||QDL.MA||',')>0 --Tạm đình chỉ
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
--                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
--                                    WHERE    instr(',DC,CVA,TRAHS,',','||QDL.MA||',')>0
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
--                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
--                                    WHERE instr(',DC,CVA,TRAHS,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHINHSU = 1
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
                            OR EXISTS (
                                        select 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = QSV.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                        WHERE (V_TUNGAY IS NULL OR QSV.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR QSV.NGAYQD<=VV_DENNGAY)
                                    AND QSV.VUANID=a.id  AND GD.MAGIAIDOAN=2
                                    AND QD.KET_THUC =1
                                    )
                            OR EXISTS (
                                        select 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQDVA
                                        LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID = PTQDVA.QUYETDINHID
                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
                                        WHERE (V_TUNGAY IS NULL OR PTQDVA.NGAYQD>=VV_TUNGAY)
                                    AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                    AND PTQDVA.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                    AND QD.KET_THUC =1
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
                                WHERE QDL.MA='CVA'
                                AND (V_TUNGAY IS NULL OR  PTQDVA.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR PTQDVA.NGAYQD<=VV_DENNGAY)
                                AND PTQDVA.VUANID=A.ID AND GD.MAGIAIDOAN=3
                                )       
                        )
                  )
                  OR(v_TINHTRANG_GIAIQUYET=11 --QĐ TRẢ HỒ SƠ
                  AND (EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QD
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QD.QUYETDINHID 
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE QDL.MA='TRAHS'
                                AND (V_TUNGAY IS NULL OR  QD.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QD.NGAYQD<=VV_DENNGAY)
                                AND QD.VUANID=A.ID AND GD.MAGIAIDOAN =3)
                        OR EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                LEFT JOIN DM_QD_QUYETDINH QD ON QD.ID=QD.QUYETDINHID 
                                LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID 
                                WHERE QDL.MA='TRAHS'
                                AND (V_TUNGAY IS NULL OR  QD.NGAYQD>=VV_TUNGAY)
                                AND (V_DENNGAY IS NULL OR QD.NGAYQD<=VV_DENNGAY)
                                AND QD.VUANID=A.ID AND GD.MAGIAIDOAN =2) ))
              )
                --check theo loại vị thành niên           
                AND (v_thanhnien = 0
                         OR (v_thanhnien = 1 
                          AND ( EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                            WHERE BC.istrevithanhnien = 1 AND BC.VUANID = A.ID)
                                       OR  
                                        EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                          WHERE NTT.istrevithanhnien = 1 AND NTT.VUANID = A.ID)
                               )
                            ) 
                         OR (v_thanhnien = 2
                          AND ( NOT EXISTS ( SELECT 'X' FROM AHS_BICANBICAO BC
                                            WHERE BC.istrevithanhnien = 1 AND BC.VUANID = A.ID)
                                       AND  
                                        NOT EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG NTT 
                                          WHERE NTT.istrevithanhnien = 1 AND NTT.VUANID = A.ID))
                            )
                    ) 
                --check theo loại vị thành niên  end
                AND (v_GDTaoHS = 0
                         OR (v_GDTaoHS = 1 
                          AND ( A.GDTAOHS = 1)
                            ) 
                         OR (v_GDTaoHS = 2
                          AND ( A.GDTAOHS = 2)
                          )
                        OR (v_GDTaoHS = 3
                          AND ( A.GDTAOHS = 3)
                          )
                        OR (v_GDTaoHS = 4
                          AND ( A.GDTAOHS is null)
                          )
                    ) 
                ----toancau tuyennh 31/07/2023 sửa hình thức xét xử start
                --hieu check theo Hình thức xét xử
                And (v_HINHTHUCXX = 0
                        Or(v_HINHTHUCXX = 1
                         AND(EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 1 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=2)
                             OR
                             EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 1 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=3)          
                             )
                          )
                        Or(v_HINHTHUCXX = 2
                         AND(EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 2 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=2)
                             OR
                             EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 2 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=3)           
                             )
                          )
                        Or(v_HINHTHUCXX = 3
                         AND(EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 3 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=2)
                             OR
                             EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 3 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=3)           
                             )
                          )
                        Or(v_HINHTHUCXX = 4
                         AND(EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 4 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=2)
                             OR
                             EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 4 AND BC.VUANID = A.ID
                                        AND A.MAGIAIDOAN=3)           
                             )
                          )
                        Or(v_HINHTHUCXX = 5
                         AND(NOT EXISTS (SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 1 AND BC.VUANID = A.ID)
                                        AND
                              NOT EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 2 AND BC.VUANID = A.ID)
                                        AND
                              NOT EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 3 AND BC.VUANID = A.ID)
                                        AND
                              NOT EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 4 AND BC.VUANID = A.ID)
                                        AND
                              A.MAGIAIDOAN=2          
                             )
                          OR
                          (NOT EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 1 AND BC.VUANID = A.ID)
                                        AND
                              NOT EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 2 AND BC.VUANID = A.ID)
                                        AND
                              NOT EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 3 AND BC.VUANID = A.ID)
                                        AND
                              NOT EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN BC
                                        WHERE BC.HINHTHUCXETXU = 4 AND BC.VUANID = A.ID)
                                        AND
                              A.MAGIAIDOAN=3         
                             )
                          )
                    )
                    --End Check HTXX
                    ----toancau tuyennh 31/07/2023 sửa hình thức xét xử end
              ----------------------------    
       )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex                  
   ;
END AHS_VUAN_GETALLPAGING;
FUNCTION UPDATE_TENVUAN_ERROR
RETURN SYS_REFCURSOR
AS
V_CURSOR sys_refcursor;v_count NUMBER;
BEGIN
      FOR rec in (
                SELECT A.ID VUANID,BC.ID BC_ID,BC.HOTEN FROM AHS_VUAN A
                INNER JOIN DM_TOAAN TA ON TA.ID=A.TOAANID 
                INNER JOIN AHS_BICANBICAO BC ON BC.VUANID=A.ID
                WHERE A.MAVUAN=A.TENVUAN AND BC.BICANDAUVU=1
                 )
        LOOP
          SELECT COUNT(*) INTO v_count FROM (
                SELECT TT.TenToiDanh FROM (
                        SELECT NVL(a.TenToiDanh, c.TenToiDanh) TenToiDanh
                                from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                                    inner join (select ID, LuatID,Chuong, Diem, Khoan, Dieu, TenToiDanh ,LOAITOIPHAM
                                                  , CapChaID, Loai, ArrSapXep from DM_BoLuat_ToiDanh where HieuLuc=1
                                                ) c ON a.ToiDanhID = c.ID
                                where   a.BiCanID= rec.BC_ID and a.VuAnID = rec.VUANID AND  C.LOAI=2
                                ORDER BY A.NgayTao, C.ArrSapXep ASC
                          )TT WHERE ROWNUM=1
                      );
           IF(v_count>0) THEN
                 FOR item in (
                    SELECT TT.TenToiDanh FROM (
                    SELECT NVL(a.TenToiDanh, c.TenToiDanh) TenToiDanh
                            from  AHS_SOTHAM_CAOTRANG_DIEULUAT a 
                                inner join (select ID, LuatID,Chuong, Diem, Khoan, Dieu, TenToiDanh ,LOAITOIPHAM
                                              , CapChaID, Loai, ArrSapXep from DM_BoLuat_ToiDanh where HieuLuc=1
                                            ) c ON a.ToiDanhID = c.ID
                            where   a.BiCanID= rec.BC_ID and a.VuAnID = rec.VUANID AND  C.LOAI=2
                            ORDER BY A.NgayTao, C.ArrSapXep ASC
                      )TT WHERE ROWNUM=1
                 )
                LOOP
                       UPDATE AHS_VUAN
                       SET TENVUAN=rec.HOTEN||' - '|| item.TenToiDanh
                       WHERE ID=rec.VUANID;
                       COMMIT;
                END LOOP;
            ELSE
               UPDATE AHS_VUAN
               SET TENVUAN=rec.HOTEN
               WHERE ID=rec.VUANID;
               COMMIT;
            END IF;
         END LOOP;
       ----------------------------- 
        FOR rec in (
                SELECT A.ID VUANID,BC.ID BC_ID,BC.HOTEN FROM AHS_VUAN A
                INNER JOIN DM_TOAAN TA ON TA.ID=A.TOAANID 
                INNER JOIN AHS_BICANBICAO BC ON BC.VUANID=A.ID
                WHERE A.MAVUAN=A.TENVUAN
                 )
        LOOP
               FOR item in (
                    select tt.HOTEN from (
                         select BC.HOTEN from AHS_BICANBICAO BC where BC.VUANID=rec.VUANID
                     )tt where ROWNUM=1
                  )
                  loop
                    UPDATE AHS_VUAN
                    SET TENVUAN=item.HOTEN
                    WHERE ID=rec.VUANID;
                    COMMIT;
                  END LOOP;
        END LOOP;
        ---DELETE
        FOR rec in (
                SELECT A.ID FROM AHS_VUAN A
                INNER JOIN DM_TOAAN TA ON TA.ID=A.TOAANID 
                WHERE A.MAVUAN=A.TENVUAN
                 )
        LOOP
              DELETE AHS_NGUOITHAMGIATOTUNG
              WHERE VUANID=rec.id;
              commit;
              --------
              DELETE AHS_SOTHAM_THULY
              WHERE VUANID=rec.id;
              commit;
              -------
              DELETE AHS_VUAN
              WHERE ID=rec.id;
              -----
              commit;
        END LOOP;
        -------
         DELETE AHS_NGUOITHAMGIATOTUNG
              WHERE VUANID IN (select tt.VUANID from AHS_NGUOITHAMGIATOTUNG tt 
                               where not exists(select 'x' from AHS_VUAN a where a.id=TT.VUANID)
                                );
       commit;    
       ------
        DELETE AHS_SOTHAM_THULY
              WHERE VUANID IN (select tt.VUANID from AHS_SOTHAM_THULY tt 
                               where not exists(select 'x' from AHS_VUAN a where a.id=TT.VUANID)
                                );
       commit;   
       ----
      OPEN V_CURSOR FOR
        SELECT A.ID VUANID,A.MAVUAN,A.TENVUAN,A.MAGIAIDOAN,TA.TEN,TA.MA_TEN FROM AHS_VUAN A
        INNER JOIN DM_TOAAN TA ON TA.ID=A.TOAANID 
        WHERE A.MAVUAN=A.TENVUAN;
 RETURN V_CURSOR;   
END UPDATE_TENVUAN_ERROR;
FUNCTION AHS_VUAN_GETALLPAGING_ITEM
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
    Page_Index in	int,
    Page_Size	in	int
)RETURN T_STPT_6LOAIAN
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_STPT_6LOAIAN;
    VV_TUNGAY DATE;VV_DENNGAY DATE;  VV_NGAYTHULY_TU DATE;VV_NGAYTHULY_DEN DATE;   
     V_TABLE_TLST T_QUYETDINH;V_TABLE_TLPT T_QUYETDINH;
    V_TABLE_HDXX_ST T_QUYETDINH;V_TABLE_HDXX_PT T_QUYETDINH;  
    V_TABLE_TP T_QUYETDINH;
    V_TABLE_ST T_QUYETDINH;V_TABLE_PT T_QUYETDINH;
    V_TABLE_BC T_AHS_BICANBICAO; V_TABLE_BC_KC T_AHS_BICANBICAO;   

BEGIN	
     v_table := T_STPT_6LOAIAN();
     V_TABLE_TLST := T_QUYETDINH();  V_TABLE_TLPT := T_QUYETDINH();
     V_TABLE_HDXX_ST := T_QUYETDINH(); V_TABLE_HDXX_PT := T_QUYETDINH();   
     V_TABLE_TP := T_QUYETDINH();
     V_TABLE_ST := T_QUYETDINH();V_TABLE_PT := T_QUYETDINH();
     V_TABLE_BC := T_AHS_BICANBICAO();V_TABLE_BC_KC := T_AHS_BICANBICAO();
    -- edit by anhvh 02/03/2020     
    -- Giai đoạn vụ án/vụ việc
    -- SOTHAM = 2;PHUCTHAM = 3;THULYGDT = 4;  --//(DINHCHI = 5;HOSO = 1;)đã xóa 2 gai đoạn này vì không phù hợp với nghiệp vụ tòa án
    --v_Capxx: SOTHAM = 2;PHUCTHAM = 3
    ---------------------------------------
     if(V_NGAYTHULY_TU IS NOT NULL) then  VV_NGAYTHULY_TU:=to_date(trim(V_NGAYTHULY_TU)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(v_NGAYTHULY_DEN IS NOT NULL) then  VV_NGAYTHULY_DEN:=to_date(trim(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     --
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    ------------------
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
        FROM(SELECT DISTINCT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO B
                        WHERE EXISTS(SELECT 'X' FROM AHS_SOTHAM_KHANGCAO KC WHERE KC.NGUOIKCID=B.ID AND KC.VUANID=B.VUANID)
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=3
            )TTS;              
    -----------------
     FOR item_hs IN (
      SELECT a.ID, a.MaVuAn,'<i style="margin-right: 3px">Vụ án:</i><b>'||a.TenVuAn||'</b>'TenVuAn,to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS')NgayTao,a.NgayTao NGAY_TAO,a.NguoiTao,a.MaGiaiDoan, 
            DECODE(GD.MAGIAIDOAN,3,BC3.HoTen,BC2.HoTen) HoTenBiCan, decode(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||b.Ten||'</b>',null) TenToaSoTham, 
            '<br/><i style="margin-right: 3px;">TH giao nhận:</i> <b>'||DECODE(GD.MAGIAIDOAN,3,GN.TruongHopGiaoNhan,AA.TruongHopGiaoNhan)||'</b>' TruongHopGiaoNhan,
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
            TINHTRANG_GQ,(TLS.TINHTRANG_GQ || TLPT.TINHTRANG_GQ) CHECK_THULY
            FROM AHS_VUAN A
            INNER JOIN (SELECT G.* FROM AHS_VUAN_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = v_toaan_id) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = v_toaan_id)) GD ON A.ID=GD.VUANID
            LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID
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
                 AND (V_UTTP IS NULL
                         OR (V_UTTP IS NOT NULL 
                          AND ( EXISTS ( SELECT 'X' FROM AHS_SOTHAM_THULY TL
                                            WHERE TL.UTTPDI = to_number(V_UTTP) and TL.VUANID = A.ID AND GD.MAGIAIDOAN=2)
                                       OR  EXISTS (SELECT 'X' FROM AHS_PHUCTHAM_THULY TLPT 
                                          WHERE TLPT.UTTPDI = to_number(V_UTTP) and TLPT.VUANID = A.ID AND GD.MAGIAIDOAN=3)
                            )  ) )
                AND (V_TOIDANH IS NULL  OR ( LOWER(A.TENVUAN) LIKE  '%'||LOWER(V_TOIDANH)||'%' ) )--tìm tội danh đã được gắn vào tên vụ án
                AND (V_CAPXX IS NULL OR(GD.MAGIAIDOAN=V_CAPXX))
                 AND(    (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
                     OR (GD.TOAANID =V_TOAAN_ID OR(GD.TOAPHUCTHAMID=V_TOAAN_ID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND B.LOAITOA!='CAPHUYEN'))
                    )
                AND (V_MA_VU_AN IS NULL  OR ( LOWER(A.MAVUAN) LIKE  LOWER(V_MA_VU_AN) ) )
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
           AND (v_thamphan_id is null
                   OR(    EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
                      -- OR EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID) 
                       OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thamphan_id and tp.VuAnID=a.ID)
                     )
                )
           AND (v_thuky_id is null
                   OR( EXISTS(select 'X' from AHS_SoTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID) 
                      -- OR EXISTS(select 'X' from AHS_PhucTham_HDXX tp where tp.CanBoID = v_thuky_id and tp.VuAnID=a.ID)
                        OR EXISTS(select 'X' from AHS_THamPhanGiaiQuyet tsp where tsp.THUKYID = v_thuky_id and tsp.VuAnID=a.ID)
                     )
                )
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
                                                WHERE INSTR(',DC,CVA,TRAHS,',','||QDL.MA||',')>0 AND TL.VUANID =T1.VUANID )
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
                                                WHERE INSTR(',DC,CVA,TRAHS,',','||QDL.MA||',')>0 AND PTTL.VUANID =T1.VUANID )
                                  )
                                 AND (V_TUNGAY IS NULL OR   PTTL.NGAYTHULY>=VV_TUNGAY)
                                 AND (V_DENNGAY IS NULL OR PTTL.NGAYTHULY<=VV_DENNGAY)
                                 AND PTTL.VUANID=a.id  AND GD.MAGIAIDOAN=3
                                )
                       )
                   )
                 OR(v_TINHTRANG_GIAIQUYET=11 --chưa chuyển Ho so qua VKS và chưa ket thuc
                    AND NOT EXISTS (
                                SELECT 'x' FROM HOSO_PT hs
                                WHERE hs.VUANID=A.ID 
                                AND hs.LOAIAN = 1 -- an Hinh su
                                AND hs.LOAI_CN = 1 -- chuyển VKS
                                AND (V_TUNGAY IS NULL OR  hs.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR hs.NGAY_NC<=VV_DENNGAY)
                            )

                    ) 

                 OR(v_TINHTRANG_GIAIQUYET=12 --Đã chuyển Ho so qua VKS và chưa ket thuc
                    AND EXISTS (
                                SELECT 'x' FROM HOSO_PT hs
                                WHERE hs.VUANID=A.ID 
                                AND hs.LOAIAN = 1 -- an Hinh su
                                AND hs.LOAI_CN = 1 -- chuyển VKS
                                AND (V_TUNGAY IS NULL OR  hs.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR hs.NGAY_NC<=VV_DENNGAY)
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
--                                        LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID--TOANCAU-22092023
--                                    WHERE    instr(',DC,CVA,TRAHS,',','||QDL.MA||',')>0
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
--                                    LEFT JOIN DM_QD_LOAI QDL ON QDL.ID=QD.LOAIID
--                                    WHERE instr(',DC,TRAHS,',','||QDL.MA||',')>0
                                    WHERE QD.KET_THUC = 1 AND QD.ISPHUCTHAM = 1 AND QD.ISHINHSU = 1
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
        )
     LOOP 
                v_table.extend;
                v_table(v_table.count) := R_STPT_6LOAIAN(
                item_hs.ID,item_hs.MAVUAN,item_hs.TENVUAN,item_hs.NGAYTAO,item_hs.NGAY_TAO,item_hs.NGUOITAO,item_hs.MAGIAIDOAN,
                item_hs.HOTENBICAN,item_hs.TENTOASOTHAM,item_hs.TRUONGHOPGIAONHAN,item_hs.GIAIDOANVUVIEC,item_hs.BANAN_QD_ST,item_hs.KHANGNGHI_ST,
                item_hs.TINHTRANG_GQ,item_hs.CHECK_THULY,'1'
                );   
     END LOOP;
   RETURN v_table;   
END AHS_VUAN_GETALLPAGING_ITEM;

PROCEDURE   AHS_PT_KCKN_TINHTRANG_GETLIST
( 
    vVUANID in int,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
OPEN curReturn FOR  
  Select r.ID,d.ID as KCKNID,'1' as IsKhangCao,'Kháng cáo' as KCKNName
        ,s.HOTEN || l.HOTEN as NguoiKCCapKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        ,(CASE d.LOAIKHANGCAO WHEN 0 THEN b.SOBANAN Else q.SOQUYETDINH END) as SO_QDBA
        ,to_char(r.NGAYRUT,'dd/MM/yyyy') NGAYRUT
        ,r.TINHTRANG
        ,r.NOIDUNG
        --,(case r.TINHTRANG when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From AHS_SOTHAM_KHANGCAO d
  left join (select g.ID,g.KHANGCAOID,g.NGAYRUT,g.TINHTRANG,g.NOIDUNG,g.CAPRUTKN from AHS_SOTHAM_RUTKHANGCAO g) r on r.KHANGCAOID=d.ID
  left join (select a.ID,a.HOTEN from AHS_BICANBICAO a where a.VUANID=vVUANID) s on s.ID=d.NGUOIKCID
  left join (select l.ID,l.HOTEN from AHS_NGUOITHAMGIATOTUNG l where l.VUANID=vVUANID) l on l.ID=d.NGUOIKCID
  left join (select e.VUANID,e.SOBANAN from AHS_SOTHAM_BANAN e where e.VUANID=vVUANID) b on b.VUANID=d.VUANID
  left join (select f.VUANID,f.SOQUYETDINH from AHS_SOTHAM_QUYETDINH_VUAN f where f.VUANID=vVUANID) q on q.VUANID=d.SOQDBA
  Where d.VUANID=vVUANID  and not exists (select 'X' from AHS_SOTHAM_RUTKHANGCAO kc where kc.KHANGCAOID = d.id and (kc.CAPRUTKN = 2 or kc.CAPRUTKN is null) )
  union all
  Select r.ID,d.ID as KCKNID, '2' as IsKhangCao,'Kháng nghị' as KCKNName
        ,(CASE d.CAPKN WHEN 1 THEN u'C\00f9ng c\1ea5p' ELSE u'C\1ea5p tr\00ean' END) as NguoiKCCapKN
        ,(CASE d.LOAIKN WHEN 0 THEN 'Bản án/ QĐ giải quyết' ELSE 'Quyết định' END) as LoaiKCKN
        --,d.NGAYKN as NgayKCKN
        ,(CASE d.LOAIKN WHEN 0 THEN b.SOBANAN Else q.SOQUYETDINH END) as SO_QDBA
        --,d.NGAYBANAN as NGAYQDBA
        ,to_char(r.NGAYRUT,'dd/MM/yyyy') NGAYRUT
        ,r.TINHTRANG
        ,r.NOIDUNG
        --,(case r.TINHTRANG when 1 then 'Rút một phần' when 2 then 'Rút toàn bộ'  else 'Chưa rút' end) as TinhTrangName
  From AHS_SOTHAM_KHANGNGHI d 
  left join (select g.ID,g.KHANGNGHIID,g.NGAYRUT,g.TINHTRANG,g.NOIDUNG,g.CAPRUTKN from AHS_SOTHAM_RUTKHANGNGHI g) r on r.KHANGNGHIID=d.ID
  left join (select a.VUANID,a.SOBANAN from AHS_SOTHAM_BANAN a where a.VUANID=vVuAnID) b on b.VUANID=d.VUANID
  left join (select c.VUANID,c.SOQUYETDINH from AHS_SOTHAM_QUYETDINH_VUAN c where c.VUANID=vVuAnID) q on q.VUANID=d.VUANID
  Where d.VUANID=vVuAnID  and not exists (select 'X' from AHS_SOTHAM_RUTKHANGNGHI kn where kn.KHANGNGHIID = d.id and (kn.CAPRUTKN = 2 or kn.CAPRUTKN is null) );

END AHS_PT_KCKN_TINHTRANG_GETLIST;


END PKG_AHS_STPT_DS;
