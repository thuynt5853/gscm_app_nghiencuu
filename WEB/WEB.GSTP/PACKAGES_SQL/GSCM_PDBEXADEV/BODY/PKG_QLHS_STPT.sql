--------------------------------------------------------
--  DDL for Package Body PKG_QLHS_STPT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_QLHS_STPT" AS

PROCEDURE GETQUANLYHOSOAN_ADS
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT 
                ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll,A.ID,A.MAVUVIEC,A.TENVUVIEC, A.SOTHUTU,A.NGAYNHANDON,A.NGUOITAO,A.MAGIAIDOAN,
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                2 LOAIAN, 'Dân sự' TENLOAIAN,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '')THAMPHAN,
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '')THUKY,
                
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from ADS_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid) TENNGUYENDON,
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from ADS_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  group by  ds.donid) TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from ADS_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN

              FROM ADS_DON A

                    INNER JOIN (SELECT G.* 
                                FROM ADS_DON_GIAIDOAN G 
                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID 
                                
                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=2 and hs_stpt.CAPXX = a.magiaidoan  
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    --BẢN ÁN
                    LEFT JOIN (SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYTUYENAN 
                               FROM ADS_SOTHAM_BANAN BA
                               WHERE  BA.SOBANAN IS NOT NULL
                               GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYTUYENAN
                               )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
                            
                    LEFT JOIN (SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYTUYENAN  
                               FROM ADS_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                               GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYTUYENAN 
                               )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
                         
                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM, S.TEN
                               FROM ADS_SOTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.DONID = A.ID AND GD.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM, S.TEN
                               FROM ADS_PHUCTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.DONID = A.ID AND GD.MAGIAIDOAN=3         

                    --lấy thông tin thụ lý  
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME
                               from ADS_SOTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) sotham_thuly on sotham_thuly.donid = A.ID

                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME 
                               from ADS_PHUCTHAM_THULY thuly  
                               group by thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) phuctham_thuly on phuctham_thuly.donid = A.ID

                    -- lấy thông tin hội đồng xét xử 
                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from ADS_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by hdxx.donid ) sotham_tp on sotham_tp.donid = A.ID

                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from ADS_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                               group by hdxx.donid) sotham_tk on sotham_tk.donid = A.ID

                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from ADS_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid) phuctham_tp on phuctham_tp.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from ADS_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY'
                               group by  hdxx.donid)phuctham_tk on phuctham_tk.donid = A.ID
               
                    -- lấy thông tin quan hệ pháp luật
                    left join (select st_banan.donid,LISTAGG( DECODE(di.TEN,null, st_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from ADS_SOTHAM_BANAN st_banan 
                                   left join DM_DATAITEM di on st_banan.QUANHEPHAPLUATID = di.id
                               group by  st_banan.donid)sotham_qhpl on sotham_qhpl.donid = A.ID

                    left join (select phuctham_banan.donid,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from ADS_PHUCTHAM_BANAN phuctham_banan 
                                   left join DM_DATAITEM di on phuctham_banan.QUANHEPHAPLUATID = di.id   
                               group by  phuctham_banan.donid)phuctham_qhpl on phuctham_qhpl.donid = A.ID
                    
                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                                        
                    AND (VCAPXX IS NULL OR(GD.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    
--                    AND( (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID AND V_CAP_XET_XU_LOGIN='CAPTINH')) 
--                            OR (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID AND V_CAP_XET_XU_LOGIN='CAPCAO' AND T.LOAITOA!='CAPHUYEN'))
--                         )
                    
                    AND ( (GD.MAGIAIDOAN =2 AND  (EXISTS(SELECT 1 FROM ADS_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID   AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate ) 
                                                  OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV 
                                                                join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID
                                                            WHERE A.ID=QSV.DONID AND dmqd.KET_THUC=1
                                                            AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate
                                                            )
                                                  ) 
                          )
                          OR (GD.MAGIAIDOAN =3 AND  (EXISTS (SELECT 1 
                                                             FROM ADS_PHUCTHAM_BANAN QSV 
                                                             WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate 
                                                                                  AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISADS = 1) 
                                                             ) 
                                                     OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV 
                                                             join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID
                                                             WHERE A.ID=QSV.DONID AND dmqd.KET_THUC=1
                                                             /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/
                                                                )
                                                      )
                             )
                        )
                    AND (vLoaian =0  OR (vLoaian=2)) --where tạm
                    AND (vNgayThuLy is null OR  DECODE(GD.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )

                    AND (vSoBA IS NULL--Số BA/QĐ
                             OR  (     (EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  )AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3)
                                    OR (EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3 )
                                  )
                        )
                    AND (vNgayBA IS NULL--Ngày BA/QĐ
                     OR  (    (EXISTS(SELECT 'X' FROM ADS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                           OR (EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                         )
                     )
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
   
                    AND (vNguyenDon is null OR     
                            LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" 
                                    from ADS_DON_DUONGSU ds 
                                    where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )
                    AND (vBiDon is null OR     
                            LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" 
                            from ADS_DON_DUONGSU ds 
                            where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vBiDon)||'%'   )

                     AND (vMaVuViec is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    --AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR ( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 
            )tt --                  
        ;
END GETQUANLYHOSOAN_ADS; 
PROCEDURE GETQUANLYHOSOAN_AHN
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.NGUOITAO,

                A.MAGIAIDOAN, 

                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                3 LOAIAN,
                'Hôn nhân' TENLOAIAN,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '')THAMPHAN,
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '')THUKY,
                
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHN_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid) TENNGUYENDON,
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHN_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  group by  ds.donid) TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from AHN_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN
              FROM AHN_DON A
                    INNER JOIN (SELECT G.* 
                                FROM AHN_DON_GIAIDOAN G 
                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID 
                                
                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=3 and hs_stpt.CAPXX = a.magiaidoan  
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    --BẢN ÁN
                    LEFT JOIN (SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYTUYENAN 
                               FROM AHN_SOTHAM_BANAN BA
                               WHERE  BA.SOBANAN IS NOT NULL
                               GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYTUYENAN
                               )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
                            
                    LEFT JOIN (SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYTUYENAN  
                               FROM AHN_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                               GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYTUYENAN 
                               )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
                         
                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AHN_SOTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.DONID = A.ID AND GD.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AHN_PHUCTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.DONID = A.ID AND GD.MAGIAIDOAN=3         

                    --lấy thông tin thụ lý  
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME
                               from AHN_SOTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME)sotham_thuly on sotham_thuly.donid = A.ID

                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME 
                               from AHN_PHUCTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) phuctham_thuly on phuctham_thuly.donid = A.ID

                    -- lấy thông tin hội đồng xét xử 
                    left join (select  hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from AHN_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid ) sotham_tp on sotham_tp.donid = A.ID

                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from AHN_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                               group by hdxx.donid)sotham_tk on sotham_tk.donid = A.ID

                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from AHN_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid) phuctham_tp on phuctham_tp.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from AHN_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY'
                               group by  hdxx.donid)phuctham_tk on phuctham_tk.donid = A.ID
               
                    -- lấy thông tin quan hệ pháp luật
                    left join (select st_banan.donid,LISTAGG( DECODE(di.TEN,null, st_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from AHN_SOTHAM_BANAN st_banan 
                                   left join DM_DATAITEM di on st_banan.QUANHEPHAPLUATID = di.id
                               group by  st_banan.donid)sotham_qhpl on sotham_qhpl.donid = A.ID

                    left join (select phuctham_banan.donid,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from AHN_PHUCTHAM_BANAN phuctham_banan 
                                   left join DM_DATAITEM di on phuctham_banan.QUANHEPHAPLUATID = di.id   
                               group by  phuctham_banan.donid)phuctham_qhpl on phuctham_qhpl.donid = A.ID
                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (VCAPXX IS NULL OR(GD.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    
                    AND ( (GD.MAGIAIDOAN =2 AND  (EXISTS(SELECT 1 FROM AHN_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate) 
                                                  OR EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV 
                                                                join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                            WHERE A.ID=QSV.DONID AND dmqd.KET_THUC=1 
                                                                                 AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate) 
                                                  ) 
                           )
                    OR (GD.MAGIAIDOAN =3 AND  (EXISTS(SELECT 1 FROM AHN_PHUCTHAM_BANAN QSV 
                                                      WHERE A.ID=QSV.DONID  AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate
                                                                            AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISAHN = 1) 
                                                      ) 
                                               OR EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV 
                                                            join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                         WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1 /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/)
                                               )
                       )
                    )
                    AND (vLoaian =0  OR (vLoaian=3)) --where tạm
                    AND (vNgayThuLy is null OR  DECODE(GD.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )
                   -- AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                   --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                   AND (vSoBA IS NULL--Số BA/QĐ
                             OR  (     (EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  )AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3)
                                    OR (EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3 )
                                  )
                        )
                    AND (vNgayBA IS NULL--Ngày BA/QĐ
                     OR  (    (EXISTS(SELECT 'X' FROM AHN_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHN_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                           OR (EXISTS(SELECT 'X' FROM AHN_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                         )
                     )
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
                    AND (vNguyenDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHN_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )

                    AND (vBiDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHN_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vBiDon)||'%'   )

                     AND (vMaVuViec is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    --AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 
            )tt                   
        ;
END GETQUANLYHOSOAN_AHN; 
PROCEDURE GETQUANLYHOSOAN_AKT
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC, A.TENVUVIEC,A.SOTHUTU,A.NGAYNHANDON,A.NGUOITAO,A.MAGIAIDOAN, 
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                4 LOAIAN,
                'Kinh tế' TENLOAIAN,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '')THAMPHAN,
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '')THUKY,
                
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AKT_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid) TENNGUYENDON,
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AKT_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  group by  ds.donid) TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from AKT_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN
              FROM AKT_DON A
                    INNER JOIN (SELECT G.* 
                                FROM AKT_DON_GIAIDOAN G 
                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID 
                                
                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=4 and hs_stpt.CAPXX = a.magiaidoan  
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    --BẢN ÁN
                    LEFT JOIN (SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYTUYENAN 
                               FROM AKT_SOTHAM_BANAN BA
                               WHERE  BA.SOBANAN IS NOT NULL
                               GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYTUYENAN
                               )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
                            
                    LEFT JOIN (SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYTUYENAN  
                               FROM AKT_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                               GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYTUYENAN 
                               )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
                         
                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AKT_SOTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.DONID = A.ID AND GD.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AKT_PHUCTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.DONID = A.ID AND GD.MAGIAIDOAN=3         

                    --lấy thông tin thụ lý  
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME
                               from AKT_SOTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME)sotham_thuly on sotham_thuly.donid = A.ID

                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME 
                               from AKT_PHUCTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) phuctham_thuly on phuctham_thuly.donid = A.ID

                    -- lấy thông tin hội đồng xét xử 
                    left join (select  hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from AKT_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid ) sotham_tp on sotham_tp.donid = A.ID

                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from AKT_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                               group by hdxx.donid)sotham_tk on sotham_tk.donid = A.ID

                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from AKT_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid) phuctham_tp on phuctham_tp.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from AKT_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY'
                               group by  hdxx.donid)phuctham_tk on phuctham_tk.donid = A.ID
               
                    -- lấy thông tin quan hệ pháp luật
                    left join (select st_banan.donid,LISTAGG( DECODE(di.TEN,null, st_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from AKT_SOTHAM_BANAN st_banan 
                                   left join DM_DATAITEM di on st_banan.QUANHEPHAPLUATID = di.id
                               group by  st_banan.donid)sotham_qhpl on sotham_qhpl.donid = A.ID

                    left join (select phuctham_banan.donid,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from AKT_PHUCTHAM_BANAN phuctham_banan 
                                   left join DM_DATAITEM di on phuctham_banan.QUANHEPHAPLUATID = di.id   
                               group by  phuctham_banan.donid)phuctham_qhpl on phuctham_qhpl.donid = A.ID
                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (VCAPXX IS NULL OR(GD.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    AND ( (GD.MAGIAIDOAN =2 AND  (EXISTS(SELECT 1 FROM AKT_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate) 
                                                 OR EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV 
                                                 join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                 WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1
                                                 AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)
                                                    ) 
                                                )
                        OR (GD.MAGIAIDOAN =3 AND  (EXISTS(SELECT 1 FROM AKT_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISAKT = 1) ) 
                                                OR EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV 
                                                          join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID
                                                          WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1
                                                        /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/
                                                          )
                                                    )
                                                )
                        )
                    AND (vLoaian =0  OR (vLoaian=4)) --where tạm
                    AND (vNgayThuLy is null OR  DECODE(GD.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )
--                   AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
--                   AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                        AND (vSoBA IS NULL--Số BA/QĐ
                             OR  (     (EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  )AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3)
                                    OR (EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3 )
                                  )
                        )
                    AND (vNgayBA IS NULL--Ngày BA/QĐ
                     OR  (    (EXISTS(SELECT 'X' FROM AKT_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AKT_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                           OR (EXISTS(SELECT 'X' FROM AKT_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                         )
                     )
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
                    AND (vNguyenDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AKT_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )

                    AND (vBiDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AKT_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vBiDon)||'%'   )

                     AND (vMaVuViec is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    --AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 
            )tt                   
        ;
END GETQUANLYHOSOAN_AKT; 
PROCEDURE GETQUANLYHOSOAN_ALD
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.NGUOITAO,

                A.MAGIAIDOAN, 

                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                5 LOAIAN,
                'Lao động' TENLOAIAN,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '')THAMPHAN,
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '')THUKY,
                
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from ALD_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid) TENNGUYENDON,
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from ALD_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  group by  ds.donid) TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from ALD_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN
              FROM ALD_DON A
                    INNER JOIN (SELECT G.* 
                                FROM ALD_DON_GIAIDOAN G 
                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID 
                                
                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=5 and hs_stpt.CAPXX = a.magiaidoan  
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    --BẢN ÁN
                    LEFT JOIN (SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYTUYENAN 
                               FROM ALD_SOTHAM_BANAN BA
                               WHERE  BA.SOBANAN IS NOT NULL
                               GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYTUYENAN
                               )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
                            
                    LEFT JOIN (SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYTUYENAN  
                               FROM ALD_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                               GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYTUYENAN 
                               )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
                         
                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM ALD_SOTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.DONID = A.ID AND GD.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM ALD_PHUCTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.DONID = A.ID AND GD.MAGIAIDOAN=3         

                    --lấy thông tin thụ lý  
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME
                               from ALD_SOTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME)sotham_thuly on sotham_thuly.donid = A.ID

                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME 
                               from ALD_PHUCTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) phuctham_thuly on phuctham_thuly.donid = A.ID

                    -- lấy thông tin hội đồng xét xử 
                    left join (select  hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from ALD_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid ) sotham_tp on sotham_tp.donid = A.ID

                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from ALD_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                               group by hdxx.donid)sotham_tk on sotham_tk.donid = A.ID

                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from ALD_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid) phuctham_tp on phuctham_tp.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from ALD_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY'
                               group by  hdxx.donid)phuctham_tk on phuctham_tk.donid = A.ID
               
                    -- lấy thông tin quan hệ pháp luật
                    left join (select st_banan.donid,LISTAGG( DECODE(di.TEN,null, st_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from ALD_SOTHAM_BANAN st_banan 
                                   left join DM_DATAITEM di on st_banan.QUANHEPHAPLUATID = di.id
                               group by  st_banan.donid)sotham_qhpl on sotham_qhpl.donid = A.ID

                    left join (select phuctham_banan.donid,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from ALD_PHUCTHAM_BANAN phuctham_banan 
                                   left join DM_DATAITEM di on phuctham_banan.QUANHEPHAPLUATID = di.id   
                               group by  phuctham_banan.donid)phuctham_qhpl on phuctham_qhpl.donid = A.ID
                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (VCAPXX IS NULL OR(GD.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    AND ( (GD.MAGIAIDOAN =2 AND  (EXISTS(SELECT 1 FROM ALD_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID  AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate) 
                                                        OR EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV 
                                                        join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                        -- join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                        WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1 --dmlqd.ma in ('DC','CNTT','TTLYHON ') 
                                                        AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)  )
                                                        )
                    OR (GD.MAGIAIDOAN =3 AND  (EXISTS(SELECT 1 FROM ALD_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISALD = 1) ) 
                                                      OR EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV 
                                                              join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                              --join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                              WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1 
                                                              /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/)--dmlqd.ma in ('DC','CNTT','TTLYHON ')
                                                              ) 
                                                      )
                    )
                    AND (vLoaian =0  OR (vLoaian=5)) --where tạm
                    AND (vNgayThuLy is null OR  DECODE(GD.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )

--                    AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
--                    AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                          AND (vSoBA IS NULL--Số BA/QĐ
                             OR  (     (EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  )AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3)
                                    OR (EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3 )
                                  )
                        )
                    AND (vNgayBA IS NULL--Ngày BA/QĐ
                     OR  (    (EXISTS(SELECT 'X' FROM ALD_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM ALD_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                           OR (EXISTS(SELECT 'X' FROM ALD_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                         )
                     )
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
                    AND (vNguyenDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from ALD_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )

                    AND (vBiDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from ALD_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vBiDon)||'%'   )

                     AND (vMaVuViec is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    --AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai) 
      AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 
            )tt                   
        ;
END GETQUANLYHOSOAN_ALD; 
PROCEDURE GETQUANLYHOSOAN_AHC
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.NGUOITAO,

                A.MAGIAIDOAN, 

                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                6 LOAIAN,
                'Hành chính' TENLOAIAN,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '')THAMPHAN,
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '')THUKY,
                
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHC_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid) TENNGUYENDON,
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHC_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  group by  ds.donid) TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from AHC_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN
              FROM AHC_DON A
                    INNER JOIN (SELECT G.* 
                                FROM AHC_DON_GIAIDOAN G 
                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID 
                                
                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=6 and hs_stpt.CAPXX = a.magiaidoan
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    LEFT JOIN (
                            SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYTUYENAN FROM AHC_SOTHAM_BANAN BA
                            WHERE  BA.SOBANAN IS NOT NULL
                            GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYTUYENAN
                            )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
                            
                     LEFT JOIN ( 
                            SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYTUYENAN  FROM AHC_PHUCTHAM_BANAN PTBA 
                            WHERE  PTBA.SOBANAN IS NOT NULL
                            GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYTUYENAN 
                           )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
                           
                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AHC_SOTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.DONID = A.ID AND GD.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AHC_PHUCTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.DONID = A.ID AND GD.MAGIAIDOAN=3
  
                    --lấy thông tin thụ lý 
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME 
                               from AHC_SOTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) sotham_thuly on sotham_thuly.donid = A.ID
                               
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY",thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME
                               from AHC_PHUCTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME)phuctham_thuly on phuctham_thuly.donid = A.ID
           
                   -- lấy thông tin thẩm phán sơ thẩm
                    left join (select  hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from AHC_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid ) sotham_tp on sotham_tp.donid = A.ID
                    
                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from AHC_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                               group by  hdxx.donid)sotham_tk on sotham_tk.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                                from AHC_PHUCTHAM_HDXX hdxx 
                                    join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                                group by  hdxx.donid) phuctham_tp on phuctham_tp.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                                from AHC_PHUCTHAM_HDXX hdxx 
                                    join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                                group by  hdxx.donid)phuctham_tk on phuctham_tk.donid = A.ID

                    -- lấy thông tin quan hệ pháp luật sơ thẩm
                    left join (select st_banan.donid,LISTAGG( DECODE(di.TEN,null, st_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                                from AHC_SOTHAM_BANAN st_banan 
                                    left join DM_DATAITEM di on st_banan.QUANHEPHAPLUATID = di.id   
                                group by  st_banan.donid)sotham_qhpl on sotham_qhpl.donid = A.ID

                    -- lấy thông tin quan hệ pháp luật phúc thẩm
                    left join (select phuctham_banan.donid,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                                from AHC_PHUCTHAM_BANAN phuctham_banan 
                                    left join DM_DATAITEM di on phuctham_banan.QUANHEPHAPLUATID = di.id   
                                group by  phuctham_banan.donid)phuctham_qhpl on phuctham_qhpl.donid = A.ID

                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (VCAPXX IS NULL OR(GD.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    AND ( (GD.MAGIAIDOAN =2 AND ( EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate ) 
                                                        OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV 
                                                        join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                        --join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                        WHERE A.ID=QSV.DONID and dmqd.ket_thuc=1--dmlqd.ma in ('DC','CNTT','TTLYHON ') 
                                                        AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate) )
                                                        )
                    OR (GD.MAGIAIDOAN =3 AND  (EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate
                                                    AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISAHC = 1) ) 
                                                    OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV 
                                                    join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                    --join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                    WHERE A.ID=QSV.DONID and dmqd.ket_thuc=1
                                                    /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/)) --dmlqd.ma in ('DC','CNTT','TTLYHON ')) 
                                                    )

                    )
                    AND (vLoaian =0  OR (vLoaian=6)) --where tạm
                    AND (vNgayThuLy is null OR  DECODE(GD.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )

--                    AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
--                    AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                      AND (vSoBA IS NULL--Số BA/QĐ
                             OR  (     (EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  )AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3)
                                    OR (EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3 )
                                  )
                        )
                    AND (vNgayBA IS NULL--Ngày BA/QĐ
                     OR  (    (EXISTS(SELECT 'X' FROM AHC_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                           OR (EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                         )
                     )
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
                    AND (vNguyenDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHC_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )

                    AND (vBiDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHC_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vBiDon)||'%'   )

                     AND (vMaVuViec is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    --AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai) 
      AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 
            )tt                   
        ;
END GETQUANLYHOSOAN_AHC; 
PROCEDURE GETQUANLYHOSOAN_APS
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC,
                A.TENVUVIEC,
                A.SOTHUTU,
                A.NGAYNHANDON,
                A.NGUOITAO,

                A.MAGIAIDOAN, 

                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                7 LOAIAN,
                'Phá sản' TENLOAIAN,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(A.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(A.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(A.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(A.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(A.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(A.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                DECODE(A.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(A.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '') THAMPHAN,
                DECODE(A.MAGIAIDOAN,3, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '') THUKY,
                
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from APS_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid) TENNGUYENDON,
                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from APS_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  group by  ds.donid) TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from APS_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN
              FROM APS_DON A
--                    INNER JOIN (SELECT G.* 
--                                FROM APS_DON_GIAIDOAN G 
--                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.DONID 
                                
                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=7 and hs_stpt.CAPXX = a.magiaidoan  
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    --BẢN ÁN
                    LEFT JOIN (SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYTUYENAN 
                               FROM APS_SOTHAM_BANAN BA
                               WHERE  BA.SOBANAN IS NOT NULL
                               GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYTUYENAN
                               )BAST ON  BAST.DONID=a.id AND A.MAGIAIDOAN=2
                            
                    LEFT JOIN (SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYTUYENAN  
                               FROM APS_PHUCTHAM_BANAN PTBA 
                               WHERE  PTBA.SOBANAN IS NOT NULL
                               GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYTUYENAN 
                               )BAPT ON  BAPT.DONID=a.id AND A.MAGIAIDOAN=3
                         
                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM APS_SOTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.DONID = A.ID AND A.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM APS_PHUCTHAM_QUYETDINH QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.DONID,'QĐ số: '|| QSV.SOQD ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.DONID = A.ID AND A.MAGIAIDOAN=3         

                    --lấy thông tin thụ lý  
                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME
                               from APS_SOTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME)sotham_thuly on sotham_thuly.donid = A.ID

                    left join (select thuly.donid,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME 
                               from APS_PHUCTHAM_THULY thuly  
                               group by  thuly.donid,thuly.NGAYTHULY, thuly.QUANHEPHAPLUAT_NAME) phuctham_thuly on phuctham_thuly.donid = A.ID

                    -- lấy thông tin hội đồng xét xử 
                    left join (select  hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from APS_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid ) sotham_tp on sotham_tp.donid = A.ID

                    left join (select hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                               from APS_SOTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                               group by hdxx.donid)sotham_tk on sotham_tk.donid = A.ID

                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from APS_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                               group by  hdxx.donid) phuctham_tp on phuctham_tp.donid = A.ID
                    
                    left join (select distinct hdxx.donid,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                               from APS_PHUCTHAM_HDXX hdxx 
                                   join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY'
                               group by  hdxx.donid)phuctham_tk on phuctham_tk.donid = A.ID
               
                    -- lấy thông tin quan hệ pháp luật
                    left join (select st_banan.donid,LISTAGG( DECODE(di.TEN,null, st_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from APS_SOTHAM_BANAN st_banan 
                                   left join DM_DATAITEM di on st_banan.QUANHEPHAPLUATID = di.id
                               group by  st_banan.donid)sotham_qhpl on sotham_qhpl.donid = A.ID

                    left join (select phuctham_banan.donid,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                               from APS_PHUCTHAM_BANAN phuctham_banan 
                                   left join DM_DATAITEM di on phuctham_banan.QUANHEPHAPLUATID = di.id   
                               group by  phuctham_banan.donid)phuctham_qhpl on phuctham_qhpl.donid = A.ID
                               
                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
--                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)
--                    )
                    1=1
                    AND (VCAPXX IS NULL OR(A.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (A.TOAANID =vDonViID OR(A.TOAPHUCTHAMID=vDonViID))
                    AND ( (A.MAGIAIDOAN =2 AND  (EXISTS(SELECT 1 FROM APS_SOTHAM_BANAN QSV WHERE A.ID = QSV.DONID AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate) 
                                                OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV 
                                                join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                --join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1 --dmlqd.ma in ('DC','CNTT','TTLYHON ') 
                                                AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate) ) )
                     OR (A.MAGIAIDOAN =3 AND  (EXISTS(SELECT 1 FROM APS_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID  AND (QSV.NGAYTUYENAN + INTERVAL '30' DAY) <= sysdate AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISAPS = 1) ) 
                                                    OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV 
                                                    join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                    --join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                    WHERE A.ID=QSV.DONID and dmqd.KET_THUC=1
                                                    /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/ --dmlqd.ma in ('DC','CNTT','TTLYHON ')
                                                    )  )
                                                )
                    )
                    AND (vLoaian =0  OR (vLoaian=7)) --where tạm
                    AND (vNgayThuLy is null OR  DECODE(A.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )

--                    AND (vSoBA is null OR  LOWER(DECODE(A.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
--                    AND (vNgayBA is null OR  DECODE(A.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                     AND (vSoBA IS NULL--Số BA/QĐ
                             OR  (     (EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  )AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=2)
                                    OR (EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3)
                                    OR (EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE UPPER(QSV.SOQD) LIKE '%'||vSoBA||'%' AND A.ID=QSV.DONID  ) AND vCapxx=3 )
                                  )
                        )
                    AND (vNgayBA IS NULL--Ngày BA/QĐ
                     OR  (    (EXISTS(SELECT 'X' FROM APS_SOTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM APS_PHUCTHAM_BANAN QSV WHERE TO_CHAR(QSV.NGAYMOPHIENTOA,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                           OR (EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV WHERE TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy')=vNgayBA AND A.ID=QSV.DONID  )AND vCapxx=3)
                         )
                     )
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(A.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(A.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
                    AND (vNguyenDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from APS_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )

                    AND (vBiDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from APS_DON_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  group by  ds.donid)) LIKE  '%'||LOWER(vBiDon)||'%'   )

                     AND (vMaVuViec is null OR   LOWER(DECODE(A.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    --AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 
            )tt                   
        ;
END GETQUANLYHOSOAN_APS; 
PROCEDURE GETQUANLYHOSOAN_AHS
(   
    vCapxx IN NUMBER,
    vLoaian IN NUMBER, 
    vNgayThuLy IN VARCHAR2,
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vThamPhanChuToa IN VARCHAR2,
    vThuKy IN VARCHAR2,
    vNguyenDon IN VARCHAR2,
    vBiDon  IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NGAYTHULY DATE; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayThuLy IS NOT NULL) then  VV_NGAYTHULY:=to_date(trim(vNgayThuLy)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;   
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
        SELECT tt.* from (
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUAN MAVUVIEC,
                TOIDANH.hoten TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYBANCAOTRANG NGAYNHANDON,
                A.NGUOITAO,
                A.MAGIAIDOAN, 
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                01 LOAIAN,
                'Hình sự' TENLOAIAN,
                TOIDANH.TenToiDanh QUANHEPL,
                
                to_char(a.NgayTao,'dd/MM/yyyy')||'<br/>'||to_char(a.NgayTao,' HH24:MI:SS') NGAYTAO,
                
                DECODE(GD.MAGIAIDOAN,3,'</br><i>Tòa xét xử sơ thẩm: </i><b>'||T.Ten||'</b>',null) TENTOASOTHAM, 

                DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY, 3,phuctham_thuly.SOTHULY, '') SOTHULY,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') , 3, TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') NGAYTHULY,

                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN, NULL, DCST.GQDC_SOTHAM,BAST.SOBANAN), 3, DECODE(BAPT.SOBANAN, NULL, DCPT.GQDC_SOTHAM, BAPT.SOBANAN), '') SOBANAN,
                DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), 3, TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') NGAYBANAN,
                                
                DECODE(GD.MAGIAIDOAN,2, DECODE(BAST.SOBANAN,NULL,DCST.TEN,'Bản án'), 3, DECODE(BAPT.SOBANAN,NULL, DCPT.TEN,'Bản án'), '') TENQD,
                
                DECODE(A.MAGIAIDOAN,2, 'Sơ thẩm',3,'Phúc thẩm', 4,'Thụ lý Giám đốc thẩm','') GIAIDOANVUVIEC,
                
                --DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_qhpl.TEN,NULL,sotham_thuly.QUANHEPHAPLUAT_NAME,sotham_qhpl.TEN),3, DECODE(phuctham_qhpl.TEN,NULL,phuctham_thuly.QUANHEPHAPLUAT_NAME,phuctham_qhpl.TEN), '') QUANHEPL,
                
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tp.HOTEN, NULL, '', sotham_tp.HOTEN), 3, phuctham_tp.HOTEN, '')THAMPHAN,
                DECODE(GD.MAGIAIDOAN,2, DECODE(sotham_tk.HOTEN, NULL, '', sotham_tk.HOTEN), 3, phuctham_tk.HOTEN, '')THUKY,
                
--                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" 
--                 from AHS_VUAN_BICANBICAO ds 
--                 where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.DONID=a.ID  
--                 group by  ds.donid) 
                 '' TENNGUYENDON,
                 
--                (select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" 
--                from AHS_VUAN_BICANBICAO ds 
--                where ds.TUCACHTOTUNG_MA = 'BIDON' and ds.DONID=a.ID  
--                group by  ds.donid) 
                '' TENBIDON,
                
                NVL(hs_stpt.TRANGTHAIID,0) TRANGTHAIHOSO,
                --1:Hố sơ đã lưu; 2:Hố sơ cho muon; 3:Hồ sơ đã chuyên
                DECODE(hs_stpt.TRANGTHAIID,1, 'Hồ sơ đã lưu',2,'Hồ sơ cho mượn', 3,'Hồ sơ đã chuyển',4,'Kháng cáo/kháng nghị','Chưa lưu') TENTRANGTHAIHOSO,
                TO_CHAR(hs_stpt.NGAYGIAONHAN,'dd/MM/yyyy') NGAYGIAONHANHOSO,
                hs_stpt.TENDONVI TENDONVINHANHOSO,
                hs_stpt.TENNGUOICHUYEN TENNGUOICHUYENHOSO,
                hs_stpt.TENNGUOINHAN TENNGUOINHANHOSO,
                (select  id from AHS_CHUYEN_NHAN_AN ca WHERE ca.vuanid=a.id AND ROWNUM=1) ISCHUYENAN
                
              FROM AHS_VUAN A
                    INNER JOIN (SELECT G.* 
                                FROM AHS_VUAN_GIAIDOAN G 
                                WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = vDonViID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = vDonViID)) GD ON A.ID=GD.VUANID

                    LEFT JOIN  QLHS_STPT hs_stpt ON  hs_stpt.VUVIECID=a.id AND hs_stpt.LOAIAN=1 and hs_stpt.CAPXX = a.magiaidoan 
                    
                    LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                    
                    LEFT JOIN (
                            SELECT BA.VUANID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN FROM AHS_SOTHAM_BANAN BA
                            WHERE  BA.SOBANAN IS NOT NULL
                            GROUP BY BA.VUANID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA
                            )BAST ON  BAST.VUANID=a.id AND GD.MAGIAIDOAN=2      
                     LEFT JOIN ( 
                            SELECT PTBA.VUANID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN  FROM AHS_PHUCTHAM_BANAN PTBA 
                            WHERE  PTBA.SOBANAN IS NOT NULL
                            GROUP BY PTBA.VUANID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA 
                           )BAPT ON  BAPT.VUANID=a.id AND GD.MAGIAIDOAN=3  

                    --QUYẾT ĐỊNH GÂY KẾT THÚC  
                    LEFT JOIN (SELECT QSV.VUANID,'QĐ số: '|| QSV.SOQUYETDINH ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.VUANID,'QĐ số: '|| QSV.SOQUYETDINH ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCST ON DCST.VUANID = A.ID AND GD.MAGIAIDOAN=2
                      
                    LEFT JOIN (SELECT QSV.VUANID,'QĐ số: '|| QSV.SOQUYETDINH ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy') GQDC_SOTHAM,s.TEN
                               FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV 
                                   INNER JOIN DM_QD_QUYETDINH S ON S.ID = QSV.QUYETDINHID AND S.KET_THUC = 1
                               GROUP BY QSV.VUANID,'QĐ số: '|| QSV.SOQUYETDINH ||' '|| TO_CHAR(QSV.NGAYQD,'dd/MM/yyyy'), S.TEN
                               ) DCPT ON DCPT.VUANID = A.ID AND GD.MAGIAIDOAN=3

                    --lấy thông tin thụ lý  
                    left join (select thuly.VUANID,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY", thuly.NGAYTHULY 
                                from AHS_SOTHAM_THULY thuly  
                                group by  thuly.VUANID,thuly.NGAYTHULY)sotham_thuly on sotham_thuly.VUANID = A.ID
                                
                    left join (select thuly.VUANID,LISTAGG( thuly.SOTHULY, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  thuly.SOTHULY) "SOTHULY",thuly.NGAYTHULY 
                    from AHS_PHUCTHAM_THULY thuly  
                    group by  thuly.VUANID,thuly.NGAYTHULY)phuctham_thuly on phuctham_thuly.VUANID = A.ID

                    -- lấy thông tin hội đồng xét xử
                    left join (select  hdxx.VUANID,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                                from AHS_SOTHAM_HDXX hdxx 
                                    join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                                group by  hdxx.VUANID ) sotham_tp on sotham_tp.VUANID = A.ID
                    
                    left join (select hdxx.VUANID,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN"
                                from AHS_SOTHAM_HDXX hdxx 
                                    join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                                group by  hdxx.VUANID)sotham_tk on sotham_tk.VUANID = A.ID

                    left join (select distinct hdxx.VUANID,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                                from AHS_PHUCTHAM_HDXX hdxx 
                                    join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THAMPHAN' 
                                group by  hdxx.VUANID) phuctham_tp on phuctham_tp.VUANID = A.ID
                   
                    left join (select distinct hdxx.VUANID,LISTAGG( cb.HOTEN, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  cb.HOTEN) "HOTEN" 
                                from AHS_PHUCTHAM_HDXX hdxx 
                                    join DM_CANBO cb on hdxx.Canboid = cb.id and hdxx.MAVAITRO='THUKY' 
                                group by  hdxx.VUANID)phuctham_tk on phuctham_tk.VUANID = A.ID
                    
                    -- lấy thông tin quan hệ pháp luật sơ thẩm
                    left join (select   VUANID,LISTAGG( st_banan.TenToiDanh  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  st_banan.TenToiDanh) "TEN"
                                from AHS_SOTHAM_CAOTRANG_DIEULUAT st_banan     
                                group by  st_banan.VUANID)sotham_qhpl on sotham_qhpl.VUANID = A.ID

                    -- lấy thông tin quan hệ pháp luật phúc thẩm
                    --left join (select vu_an_id VUANID,LISTAGG( DECODE(di.TEN,null, phuctham_banan.QUANHEPHAPLUAT_NAME, di.TEN)  , ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  di.TEN) "TEN"
                    --from AHS_PHUCTHAM_CAOTRANG_DIEULUAT phuctham_banan   
                    --group by  phuctham_banan.vu_an_id)phuctham_qhpl on phuctham_qhpl.VUANID = A.ID
                     
                    LEFT JOIN(SELECT BC.ID,BC.VUANID,BC.HOTEN,BC.BICANDAUVU,BC.ROWNUMBER,c.TenToiDanh 
                                FROM (SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                                      FROM  AHS_BICANBICAO B )BC 
                                          LEFT JOIN (SELECT CD.BICANID, CD.ISMAIN, NVL(CD.TenToiDanh, c.TenToiDanh) as TenToiDanh
                                                     FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD 
                                                        inner join (select Id, TenBoLuat, Loai from DM_BoLuat where HieuLuc=1 and (Loai = '01' or Loai='1') ) b on CD.DieuLuatID = b.ID
                                                        inner join (select ID, LuatID, Chuong, Diem, Khoan, dieu, TenToiDanh, capChaID, Loai, ArrSapXep, LOAITOIPHAM from DM_BoLuat_ToiDanh where HieuLuc=1 ) c on c.LuatID = b.ID and CD.ToiDanhID = c.ID
                                                     WHERE CD.ISMAIN=1
                                                     ) C ON BC.ID = C.BICANID
                                    where BC.ROWNUMBER <=1
                            ) TOIDANH ON TOIDANH.VUANID=A.ID
                    
                WHERE (hs_stpt.TRANGTHAIID is null OR hs_stpt.TRANGTHAIID !=4) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (VCAPXX IS NULL OR(GD.MAGIAIDOAN=VCAPXX))--Cấp xét xử
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    AND ( (GD.MAGIAIDOAN =2 AND ( EXISTS(SELECT 1 FROM AHS_SOTHAM_BANAN QSV WHERE A.ID=QSV.VUANID AND (QSV.NGAYBANAN + INTERVAL '30' DAY) <= sysdate) 
                                                       OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV 
                                                       join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                       --join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid
                                                       WHERE A.ID=QSV.VUANID and dmqd.KET_THUC=1--dmlqd.ma in ('DC','CNTT','TTLYHON ')  
                                                       AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)  )
                                                       )
                    OR (GD.MAGIAIDOAN =3 AND ( EXISTS(SELECT 1 FROM AHS_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.VUANID AND (QSV.NGAYBANAN + INTERVAL '30' DAY) <= sysdate
                                                AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISAHS = 1) )
                                                    OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV 
                                                    join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID 
                                                    -- join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid 
                                                    WHERE A.ID=QSV.VUANID and dmqd.KET_THUC=1
                                                    /*AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate*/--dmlqd.ma in ('DC','CNTT','TTLYHON ')
                                                        ) )
                                                    )
                    )
                    AND (vLoaian =0  OR (vLoaian=1)) --where tạm 
                    AND (vNgayThuLy is null OR  DECODE(GD.MAGIAIDOAN,2,  TO_CHAR(sotham_thuly.NGAYTHULY,'dd/MM/yyyy') ,3,TO_CHAR(phuctham_thuly.NGAYTHULY,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NGAYTHULY,'dd/MM/yyyy') )

--                    AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
--                    AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                   AND (vSoBA IS NULL
                     OR  (    (EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.VUANID  ) AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE UPPER(QSV.SOBANAN) LIKE '%'||vSoBA||'%' AND A.ID=QSV.VUANID  )AND vCapxx=3 )
                           OR (EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||vSoBA||'%' AND A.ID=QSV.VUANID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||vSoBA||'%' AND A.ID=QSV.VUANID  )AND vCapxx=3 )
                           OR (EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||vSoBA||'%' AND A.ID=QSV.VUANID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE UPPER(QSV.SOQUYETDINH) LIKE '%'||vSoBA||'%' AND A.ID=QSV.VUANID  )AND vCapxx=3 )
                         )
                     )
                  AND (vNgayBA IS NULL
                     OR  (    (EXISTS(SELECT 'X' FROM AHS_SOTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(vNgayBA,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_BANAN QSV WHERE QSV.NGAYBANAN=TO_DATE(vNgayBA,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )AND vCapxx=3 )
                           OR (EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(vNgayBA,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV WHERE QSV.NGAYQD=TO_DATE(vNgayBA,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )AND vCapxx=3 )
                           OR (EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(vNgayBA,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )AND vCapxx=2)
                           OR (EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_BICAN QSV WHERE QSV.NGAYQD=TO_DATE(vNgayBA,'dd/MM/yyyy') AND A.ID=QSV.VUANID  )AND vCapxx=3 )
                         )
                     )    
                    AND (vThamPhanChuToa is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tp.HOTEN,3,phuctham_tp.HOTEN, '')) LIKE  '%'||LOWER(vThamPhanChuToa)||'%'   )
                    AND (vThuKy is null OR     LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_tk.HOTEN,3,phuctham_tk.HOTEN, '')) LIKE  '%'||LOWER(vThuKy)||'%'   )
                    --AND (vNguyenDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHS_VUAN_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.VUANID=a.ID  group by  ds.VUANID)) LIKE  '%'||LOWER(vNguyenDon)||'%'   )
                    --AND (vBiDon is null OR     LOWER((select LISTAGG(ds.TENDUONGSU, ', ' ON OVERFLOW TRUNCATE ) WITHIN GROUP (ORDER BY  ds.TENDUONGSU) "TENDUONGSU" from AHS_VUAN_DUONGSU ds where ds.TUCACHTOTUNG_MA = 'NGUYENDON' and ds.VUANID=a.ID  group by  ds.VUANID)) LIKE  '%'||LOWER(vBiDon)||'%'   )
                     AND (vNguyenDon IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE BC.BICANDAUVU = 1 AND FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(vNguyenDon))||'%' AND BC.VUANID=A.ID)
                    )  
                     AND (vBiDon IS NULL
                     OR  EXISTS(SELECT 'X' FROM AHS_BICANBICAO BC WHERE FN_CONVERT_TO_VN(UPPER(BC.HOTEN)) LIKE '%'||FN_CONVERT_TO_VN(UPPER(vBiDon))||'%' AND BC.VUANID=A.ID)
                    ) 
                     AND (vMaVuViec is null OR   LOWER(DECODE(GD.MAGIAIDOAN,2, sotham_thuly.SOTHULY,3,phuctham_thuly.SOTHULY, '')) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   

                    AND (vTenVuViec is null OR   LOWER(A.TENVUAN) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(hs_stpt.TRANGTHAIID,1, 1,2,2, 3,3,0) = vTrangThai OR( vTrangThai=2 and 1= (select TRANGTHAIID from (SELECT TRANGTHAIID from QLHS_STPT_LICHSU hsls WHERE  hsls.MAHS = hs_stpt.ID order by hsls.id desc) where ROWNUM=1 ) ) ) 

            )tt 
        ;
END GETQUANLYHOSOAN_AHS; 


PROCEDURE GETQUANLYCBBA_AHS
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (
         SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUAN MAVUVIEC,
                A.TENVUAN TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYBANCAOTRANG NGAYNHANDON,
                A.NGUOITAO,
                GD.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')SOBANAN,
                --DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '')NGAYBANAN,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố' end as ISCONGBOBA,

                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(GD.MAGIAIDOAN,2,STQD.SOQUYETDINH,3,PTQD.SOQUYETDINH,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA,  
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                1 LOAIAN,
                'Hình sự' TENLOAIAN,

                (select  id from AHS_SOTHAM_BANAN ca WHERE ca.vuanid=a.id AND ROWNUM=1)

              --FROM AHS_VUAN B INNER JOIN AHS_SOTHAM_BANAN ca ON ca.vuanid=b.id

              FROM AHS_VUAN A
              LEFT JOIN AHS_VUAN_GIAIDOAN GD ON A.ID=GD.VUANID 
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                     LEFT JOIN (
                            SELECT BA.VUANID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM AHS_SOTHAM_BANAN BA
                            WHERE  BA.SOBANAN IS NOT NULL AND ba.ISCONGBOBA = 1 
                            GROUP BY BA.VUANID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                            )BAST ON  BAST.VUANID=a.id AND GD.MAGIAIDOAN=2      
                     LEFT JOIN ( 
                            SELECT PTBA.VUANID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN, PTBA.ISCONGBOBA  FROM AHS_PHUCTHAM_BANAN PTBA 
                            WHERE  PTBA.SOBANAN IS NOT NULL
                            GROUP BY PTBA.VUANID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA 
                           )BAPT ON  BAPT.VUANID=a.id AND GD.MAGIAIDOAN=3
                     LEFT JOIN(
                            SELECT QDVV.VUANID, QDVV.SOQUYETDINH , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM AHS_SOTHAM_QUYETDINH_VUAN QDVV
                            Where QDVV.ISCONGBOQD = 1
                            GROUP BY QDVV.VUANID , QDVV.SOQUYETDINH , QDVV.NGAYQD , QDVV.ISCONGBOQD
                            )STQD ON STQD.VUANID = a.id AND GD.MAGIAIDOAN = 2
                     LEFT JOIN(
                            SELECT QDVVPT.VUANID, QDVVPT.SOQUYETDINH , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD  FROM AHS_PHUCTHAM_QUYETDINH_VUAN QDVVPT
                            Where QDVVPT.SOQUYETDINH IS NOT NULL
                            GROUP BY QDVVPT.VUANID , QDVVPT.SOQUYETDINH , QDVVPT.NGAYQD, QDVVPT.ISCONGBOQD
                            )PTQD ON PTQD.VUANID = a.id AND GD.MAGIAIDOAN = 3

                WHERE((BAST.ISCONGBOBA  = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    -- AND ( (GD.MAGIAIDOAN =2 AND  EXISTS(SELECT 1 FROM AHS_SOTHAM_BANAN QSV WHERE A.ID=QSV.VUANID) OR EXISTS(SELECT 'X' FROM AHS_SOTHAM_QUYETDINH_VUAN QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.VUANID and dmlqd.ma in ('DC','CNTT','TTLYHON ')  AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)  )
                    --OR (GD.MAGIAIDOAN =3 AND  EXISTS(SELECT 1 FROM AHS_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.VUANID AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISAHS = 1) ) OR EXISTS(SELECT 'X' FROM AHS_PHUCTHAM_QUYETDINH_VUAN QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.VUANID and dmlqd.ma in ('DC','CNTT','TTLYHON '))  )
                    --)
                    AND (vLoaian =0  OR (vLoaian=1)) --where tạm 
                    --AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,STQD.SOQUYETDINH,3,PTQD.SOQUYETDINH,''),1 ,DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUAN) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUAN) LIKE  '%'||LOWER(vTenVuViec)||'%'   )          
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai) --where ROWNUM =1
              ))tt--
        ;
END GETQUANLYCBBA_AHS; 

PROCEDURE GETQUANLYCBBA_ADS
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (

                SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC MAVUVIEC,
                A.TENVUVIEC TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYNHANDON NGAYNHANDON,
                A.NGUOITAO,
                GD.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(ca.ISCONGBOBA,NULL,DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''), 1, DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))SOBANAN,
                --DECODE(ca.ISCONGBOBA,NULL,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1,DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'), ''))NGAYBANAN,

                --Ban đầu
                --DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'')SOBANAN,
                --DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'),'')NGAYBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố' end as ISCONGBOBA,
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                2 LOAIAN,
                'Dân sự' TENLOAIAN,

                (select  id from ADS_SOTHAM_BANAN ca WHERE ca.donid=a.id AND ROWNUM=1)

              FROM ADS_DON A
              LEFT JOIN ADS_DON_GIAIDOAN GD ON A.ID=GD.donid 
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
              LEFT JOIN (
                    SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM ADS_SOTHAM_BANAN BA
                    WHERE  BA.SOBANAN IS NOT NULL  AND ba.ISCONGBOBA = 1 
                    GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                    )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
              LEFT JOIN ( 
                    SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN, PTBA.ISCONGBOBA  FROM ADS_PHUCTHAM_BANAN PTBA 
                    WHERE  PTBA.SOBANAN IS NOT NULL
                    GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA
                   )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN(
                    SELECT QDVV.DONID, QDVV.SOQD , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM ADS_SOTHAM_QUYETDINH QDVV
                    Where QDVV.ISCONGBOQD = 1
                    GROUP BY QDVV.DONID , QDVV.SOQD , QDVV.NGAYQD , QDVV.ISCONGBOQD
                    )STQD ON STQD.DONID = a.id AND GD.MAGIAIDOAN = 2
              LEFT JOIN(
                    SELECT QDVVPT.DONID, QDVVPT.SOQD , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD FROM ADS_PHUCTHAM_QUYETDINH QDVVPT
                    Where QDVVPT.SOQD IS NOT NULL 
                    GROUP BY QDVVPT.DONID , QDVVPT.SOQD , QDVVPT.NGAYQD , QDVVPT.ISCONGBOQD
                    )PTQD ON PTQD.DONID = a.id AND GD.MAGIAIDOAN = 3  

                WHERE(BAST.ISCONGBOBA = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null))
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    --AND ((GD.MAGIAIDOAN =2 AND  EXISTS(SELECT 1 FROM ADS_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID) OR EXISTS(SELECT 'X' FROM ADS_SOTHAM_QUYETDINH QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.DONID and dmlqd.ma in ('DC','CNTT','TTLYHON ') AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)  )
                    --OR (GD.MAGIAIDOAN =3 AND  EXISTS(SELECT 1 FROM ADS_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISADS = 1) ) OR EXISTS(SELECT 'X' FROM ADS_PHUCTHAM_QUYETDINH QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.DONID and dmlqd.ma in ('DC','CNTT','TTLYHON '))  )
                    --)
                    AND (vLoaian =0  OR (vLoaian=2)) --where tạm
                    --AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''),1 ,DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )        
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai ) --where ROWNUM =1
            )tt --
        ;
END GETQUANLYCBBA_ADS;  

PROCEDURE GETQUANLYCBBA_AHC
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (

                SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC MAVUVIEC,
                A.TENVUVIEC TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYNHANDON NGAYNHANDON,
                A.NGUOITAO,
                GD.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')SOBANAN,
                --DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '')NGAYBANAN,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố'  end as ISCONGBOBA,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA, 
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                6 LOAIAN,
                'Hành Chính' TENLOAIAN,

                (select  id from AHC_SOTHAM_BANAN ca WHERE ca.donid=a.id AND ROWNUM=1)

              --FROM AHS_VUAN B INNER JOIN AHS_SOTHAM_BANAN ca ON ca.vuanid=b.id

              FROM AHC_DON A
              LEFT JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.donid 
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
              LEFT JOIN (
                    SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM AHC_SOTHAM_BANAN BA
                    WHERE  BA.SOBANAN IS NOT NULL  AND ba.ISCONGBOBA = 1 
                    GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                    )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
              LEFT JOIN ( 
                    SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN, PTBA.ISCONGBOBA  FROM AHC_PHUCTHAM_BANAN PTBA 
                    WHERE  PTBA.SOBANAN IS NOT NULL
                    GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA
                   )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN(
                    SELECT QDVV.DONID, QDVV.SOQD , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM AHC_SOTHAM_QUYETDINH QDVV
                    Where QDVV.ISCONGBOQD = 1
                    GROUP BY QDVV.DONID , QDVV.SOQD , QDVV.NGAYQD , QDVV.ISCONGBOQD
                    )STQD ON STQD.DONID = a.id AND GD.MAGIAIDOAN = 2
              LEFT JOIN(
                    SELECT QDVVPT.DONID, QDVVPT.SOQD , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD FROM AHC_PHUCTHAM_QUYETDINH QDVVPT
                    Where QDVVPT.SOQD IS NOT NULL 
                    GROUP BY QDVVPT.DONID , QDVVPT.SOQD , QDVVPT.NGAYQD , QDVVPT.ISCONGBOQD
                    )PTQD ON PTQD.DONID = a.id AND GD.MAGIAIDOAN = 3  

                WHERE(BAST.ISCONGBOBA = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    --AND ( (GD.MAGIAIDOAN =2 AND  EXISTS(SELECT 1 FROM AHC_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID   ) OR EXISTS(SELECT 'X' FROM AHC_SOTHAM_QUYETDINH QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.DONID and dmlqd.ma in ('DC','CNTT','TTLYHON ') AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)  )
                    --OR (GD.MAGIAIDOAN =3 AND  EXISTS(SELECT 1 FROM AHC_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISADS = 1) ) OR EXISTS(SELECT 'X' FROM AHC_PHUCTHAM_QUYETDINH QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.DONID and dmlqd.ma in ('DC','CNTT','TTLYHON '))  )
                    --)
                    AND (vLoaian =0  OR (vLoaian=6)) --where tạm
                    --AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''),1 ,DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai ) --where ROWNUM =1

            )tt --
        ;
END GETQUANLYCBBA_AHC;  

PROCEDURE GETQUANLYCBBA_AHN
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (

                SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC MAVUVIEC,
                A.TENVUVIEC TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYNHANDON NGAYNHANDON,
                A.NGUOITAO,
                GD.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')SOBANAN,
                --DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '')NGAYBANAN,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố' end as ISCONGBOBA,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA,  
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                3 LOAIAN,
                'Hôn Nhân' TENLOAIAN,

                (select  id from AHN_SOTHAM_BANAN ca WHERE ca.donid=a.id AND ROWNUM=1)

              --FROM AHS_VUAN B INNER JOIN AHS_SOTHAM_BANAN ca ON ca.vuanid=b.id

              FROM AHN_DON A
              LEFT JOIN AHN_DON_GIAIDOAN GD ON A.ID=GD.donid 
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
              LEFT JOIN (
                    SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM AHN_SOTHAM_BANAN BA
                    WHERE  BA.SOBANAN IS NOT NULL  AND ba.ISCONGBOBA = 1 
                    GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                    )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
              LEFT JOIN ( 
                    SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN, PTBA.ISCONGBOBA  FROM AHN_PHUCTHAM_BANAN PTBA 
                    WHERE  PTBA.SOBANAN IS NOT NULL
                    GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA
                   )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN(
                    SELECT QDVV.DONID, QDVV.SOQD , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM AHN_SOTHAM_QUYETDINH QDVV
                    Where QDVV.ISCONGBOQD = 1
                    GROUP BY QDVV.DONID , QDVV.SOQD , QDVV.NGAYQD , QDVV.ISCONGBOQD
                    )STQD ON STQD.DONID = a.id AND GD.MAGIAIDOAN = 2
              LEFT JOIN(
                    SELECT QDVVPT.DONID, QDVVPT.SOQD , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD FROM AHN_PHUCTHAM_QUYETDINH QDVVPT
                    Where QDVVPT.SOQD IS NOT NULL 
                    GROUP BY QDVVPT.DONID , QDVVPT.SOQD , QDVVPT.NGAYQD , QDVVPT.ISCONGBOQD
                    )PTQD ON PTQD.DONID = a.id AND GD.MAGIAIDOAN = 3  
                WHERE(BAST.ISCONGBOBA = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (vLoaian =0  OR (vLoaian=3)) --where tạm
                    --AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''),1 ,DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )        
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai ) --where ROWNUM =1

            )tt --
        ;
END GETQUANLYCBBA_AHN; 

PROCEDURE GETQUANLYCBBA_AKT
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (

                SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC MAVUVIEC,
                A.TENVUVIEC TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYNHANDON NGAYNHANDON,
                A.NGUOITAO,
                GD.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')SOBANAN,
                --DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '')NGAYBANAN,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố' end as ISCONGBOBA,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA,
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                4 LOAIAN,
                'Kinh Doanh Thương Mại' TENLOAIAN,

                (select  id from AKT_SOTHAM_BANAN ca WHERE ca.donid=a.id AND ROWNUM=1)

              --FROM AHS_VUAN B INNER JOIN AHS_SOTHAM_BANAN ca ON ca.vuanid=b.id

              FROM AKT_DON A
              LEFT JOIN AKT_DON_GIAIDOAN GD ON A.ID=GD.donid 
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
              LEFT JOIN (
                    SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM AKT_SOTHAM_BANAN BA
                    WHERE  BA.SOBANAN IS NOT NULL  AND ba.ISCONGBOBA = 1 
                    GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                    )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
              LEFT JOIN ( 
                    SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN, PTBA.ISCONGBOBA  FROM AKT_PHUCTHAM_BANAN PTBA 
                    WHERE  PTBA.SOBANAN IS NOT NULL
                    GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA 
                   )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN(
                    SELECT QDVV.DONID, QDVV.SOQD , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM AKT_SOTHAM_QUYETDINH QDVV
                    Where QDVV.ISCONGBOQD = 1
                    GROUP BY QDVV.DONID , QDVV.SOQD , QDVV.NGAYQD , QDVV.ISCONGBOQD
                    )STQD ON STQD.DONID = a.id AND GD.MAGIAIDOAN = 2
              LEFT JOIN(
                    SELECT QDVVPT.DONID, QDVVPT.SOQD , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD FROM AKT_PHUCTHAM_QUYETDINH QDVVPT
                    Where QDVVPT.SOQD IS NOT NULL 
                    GROUP BY QDVVPT.DONID , QDVVPT.SOQD , QDVVPT.NGAYQD , QDVVPT.ISCONGBOQD
                    )PTQD ON PTQD.DONID = a.id AND GD.MAGIAIDOAN = 3 

                WHERE (BAST.ISCONGBOBA = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1) AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (GD.TOAANID =vDonViID OR(GD.TOAPHUCTHAMID=vDonViID))
                    AND (vLoaian =0  OR (vLoaian=4)) --where tạm
                    --AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''),1 ,DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )    
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai ) --where ROWNUM =1

            )tt --
        ;
END GETQUANLYCBBA_AKT; 

PROCEDURE GETQUANLYCBBA_ALD
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (

            SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC MAVUVIEC,
                A.TENVUVIEC TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYNHANDON NGAYNHANDON,
                A.NGUOITAO,
                GD.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')SOBANAN,
                --DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '')NGAYBANAN,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố' end as ISCONGBOBA,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA, 
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                5 LOAIAN,
                'Lao Động' TENLOAIAN,

                (select  id from ALD_SOTHAM_BANAN ca WHERE ca.donid=a.id AND ROWNUM=1)

              --FROM AHS_VUAN B INNER JOIN AHS_SOTHAM_BANAN ca ON ca.vuanid=b.id

              FROM ALD_DON A
              LEFT JOIN ALD_DON_GIAIDOAN GD ON A.ID=GD.donid 
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
              LEFT JOIN (
                    SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM ALD_SOTHAM_BANAN BA
                    WHERE  BA.SOBANAN IS NOT NULL  AND ba.ISCONGBOBA = 1 
                    GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                    )BAST ON  BAST.DONID=a.id AND GD.MAGIAIDOAN=2
              LEFT JOIN ( 
                    SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN , PTBA.ISCONGBOBA FROM ALD_PHUCTHAM_BANAN PTBA 
                    WHERE  PTBA.SOBANAN IS NOT NULL
                    GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA 
                   )BAPT ON  BAPT.DONID=a.id AND GD.MAGIAIDOAN=3
              LEFT JOIN(
                    SELECT QDVV.DONID, QDVV.SOQD , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM ALD_SOTHAM_QUYETDINH QDVV
                    Where QDVV.ISCONGBOQD = 1
                    GROUP BY QDVV.DONID , QDVV.SOQD , QDVV.NGAYQD , QDVV.ISCONGBOQD
                    )STQD ON STQD.DONID = a.id AND GD.MAGIAIDOAN = 2
              LEFT JOIN(
                    SELECT QDVVPT.DONID, QDVVPT.SOQD , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD FROM ALD_PHUCTHAM_QUYETDINH QDVVPT
                    Where QDVVPT.SOQD IS NOT NULL 
                    GROUP BY QDVVPT.DONID , QDVVPT.SOQD , QDVVPT.NGAYQD , QDVVPT.ISCONGBOQD
                    )PTQD ON PTQD.DONID = a.id AND GD.MAGIAIDOAN = 3  

                WHERE(BAST.ISCONGBOBA = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1)  AND
                    ((A.MAGIAIDOAN = 2 AND GD.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND GD.TOAPHUCTHAMID is not null)  )
                    AND (vLoaian =0  OR vLoaian=5) --where tạm
                    --AND (vSoBA is null OR  LOWER(DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''),1 ,DECODE(GD.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(GD.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(GD.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )        
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai ) --where ROWNUM =1
            )tt --
        ;
END GETQUANLYCBBA_ALD; 

PROCEDURE GETQUANLYCBBA_APS
(   
    vMaVuViec	IN VARCHAR2,
    vTenVuViec	IN VARCHAR2,
    vLoaian IN NUMBER, 
    vSoBA IN VARCHAR2,
    vNgayBA IN VARCHAR2,
    vDonViID	IN NUMBER, 
    vTuNgay	IN VARCHAR2,
    vDenNgay	IN VARCHAR2,
    vTrangThai	IN NUMBER,
    vPageIndex in	NUMBER,
    vPageSize	in	NUMBER, 
    curReturn OUT sys_refcursor 
)
AS
  TotalItem number; MinIndex number; MaxIndex number; VV_TUNGAY date;VV_DENNGAY date; VV_NgayBA DATE;
BEGIN
    ---------------------------------------
    MinIndex := vPageSize*(vPageIndex - 1) + 1;
    MaxIndex := vPageIndex*vPageSize ;
    ----------
     if(vTuNgay IS NOT NULL) then  VV_TUNGAY:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(vDenNgay IS NOT NULL) then  VV_DENNGAY:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
     if(vNgayBA IS NOT NULL) then  VV_NgayBA:=to_date(trim(vNgayBA)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if;  
    OPEN curReturn FOR
         SELECT tt.* from (

            SELECT ROW_NUMBER() OVER (ORDER BY a.NGAYTAO desc) STT,
                COUNT(1) OVER () as CountAll, 
                A.ID,A.MAVUVIEC MAVUVIEC,
                A.TENVUVIEC TENVUVIEC,
                A.TT SOTHUTU,
                A.NGAYNHANDON NGAYNHANDON,
                A.NGUOITAO,
                A.MAGIAIDOAN,
                --ca.SOBANAN,
                --ca.NGAYBANAN NGAYTUYENAN,
                --ca.ISCONGBOBA,
                --DECODE(A.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')SOBANAN,
                --DECODE(A.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '')NGAYBANAN,
                --case ca.ISCONGBOBA when 1 then 'Chưa công bố' end as ISCONGBOBA,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(A.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,'') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then DECODE(A.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,'') end as SOBANAN,
                Case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then DECODE(A.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then  DECODE(A.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),'') end as NGAYBANAN,
                case when BAST.ISCONGBOBA = 1 OR BAPT.ISCONGBOBA = 1 then 'Chưa công bố' when STQD.ISCONGBOQD = 1 OR PTQD.ISCONGBOQD = 1 then 'Chưa công bố' end as ISCONGBOBA, 
                --1:HS; 2:DS; 3:HN; 4:KD;5:LĐ; 6:HC; 7:PS
                7 LOAIAN,
                'Phá Sản' TENLOAIAN,

                (select  id from APS_SOTHAM_BANAN ca WHERE ca.donid=a.id AND ROWNUM=1)

              --FROM AHS_VUAN B INNER JOIN AHS_SOTHAM_BANAN ca ON ca.vuanid=b.id

              FROM APS_DON A
              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
              LEFT JOIN (
                    SELECT BA.DONID,'</br>- Đã có bản án sơ thẩm' TINHTRANG_GQ, BA.SOBANAN, ba.NGAYMOPHIENTOA NGAYTUYENAN, BA.ISCONGBOBA FROM APS_SOTHAM_BANAN BA
                    WHERE  BA.SOBANAN IS NOT NULL  AND ba.ISCONGBOBA = 1 
                    GROUP BY BA.DONID,'</br>- Đã có bản án sơ thẩm',BA.SOBANAN ,ba.NGAYMOPHIENTOA, BA.ISCONGBOBA
                    )BAST ON  BAST.DONID=a.id AND A.MAGIAIDOAN=2
              LEFT JOIN ( 
                    SELECT PTBA.DONID,'</br>- Đã có bản án phúc thẩm' TINHTRANG_GQ,PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA NGAYTUYENAN, PTBA.ISCONGBOBA  FROM APS_PHUCTHAM_BANAN PTBA 
                    WHERE  PTBA.SOBANAN IS NOT NULL
                    GROUP BY PTBA.DONID,'</br>- Đã có bản án phúc thẩm',PTBA.SOBANAN, PTBA.NGAYMOPHIENTOA, PTBA.ISCONGBOBA 
                   )BAPT ON  BAPT.DONID=a.id AND A.MAGIAIDOAN=3
              LEFT JOIN(
                    SELECT QDVV.DONID, QDVV.SOQD , QDVV.NGAYQD   NGAYTUYENAN, QDVV.ISCONGBOQD FROM APS_SOTHAM_QUYETDINH QDVV
                    Where QDVV.ISCONGBOQD = 1
                    GROUP BY QDVV.DONID , QDVV.SOQD , QDVV.NGAYQD , QDVV.ISCONGBOQD
                    )STQD ON STQD.DONID = a.id AND A.MAGIAIDOAN = 2
              LEFT JOIN(
                    SELECT QDVVPT.DONID, QDVVPT.SOQD , QDVVPT.NGAYQD  NGAYTUYENAN, QDVVPT.ISCONGBOQD FROM APS_PHUCTHAM_QUYETDINH QDVVPT
                    Where QDVVPT.SOQD IS NOT NULL 
                    GROUP BY QDVVPT.DONID , QDVVPT.SOQD , QDVVPT.NGAYQD , QDVVPT.ISCONGBOQD
                    )PTQD ON PTQD.DONID = a.id AND A.MAGIAIDOAN = 3  

                WHERE (BAST.ISCONGBOBA = 1 or STQD.ISCONGBOQD = 1 or BAPT.ISCONGBOBA = 1 or PTQD.ISCONGBOQD = 1) AND
                    ((A.MAGIAIDOAN = 2 AND A.TOAPHUCTHAMID is null ) OR (A.MAGIAIDOAN = 3 AND A.TOAPHUCTHAMID is not null)  )
                    AND (A.TOAANID =vDonViID OR(A.TOAPHUCTHAMID=vDonViID))
                    --AND ( (A.MAGIAIDOAN =2 AND  EXISTS(SELECT 1 FROM APS_SOTHAM_BANAN QSV WHERE A.ID=QSV.DONID   ) OR EXISTS(SELECT 'X' FROM APS_SOTHAM_QUYETDINH QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.DONID and dmlqd.ma in ('DC','CNTT','TTLYHON ') AND (QSV.NGAYQD + INTERVAL '30' DAY)  <= sysdate)  )
                    --OR (A.MAGIAIDOAN =3 AND  EXISTS(SELECT 1 FROM APS_PHUCTHAM_BANAN QSV WHERE A.ID=QSV.DONID AND QSV.KETQUAPHUCTHAMID not in (select ID from DM_KETQUA_PHUCTHAM where ma in ('04','06','14','15') and ISADS = 1) ) OR EXISTS(SELECT 'X' FROM APS_PHUCTHAM_QUYETDINH QSV join DM_QD_QUYETDINH dmqd on dmqd.id = qsv.QUYETDINHID join DM_QD_LOAI dmlqd on dmlqd.id=dmqd.loaiid WHERE A.ID=QSV.DONID and dmlqd.ma in ('DC','CNTT','TTLYHON '))  )
                    --)
                    AND (vLoaian =0  OR (vLoaian=7)) --where tạm
                    --AND (vSoBA is null OR  LOWER(DECODE(A.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN, '')) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    --AND (vNgayBA is null OR  DECODE(A.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), '') =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vSoBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(A.MAGIAIDOAN,2,STQD.SOQD,3,PTQD.SOQD,''),1 ,DECODE(A.MAGIAIDOAN,2, BAST.SOBANAN,3,BAPT.SOBANAN,''))) LIKE  '%'||LOWER(vSoBA)||'%'   )
                    AND (vNgayBA is null OR  (DECODE(BAST.ISCONGBOBA,null,DECODE(A.MAGIAIDOAN,2,TO_CHAR(STQD.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(PTQD.NGAYTUYENAN,'dd/MM/yyyy'),''),1, DECODE(A.MAGIAIDOAN,2, TO_CHAR(BAST.NGAYTUYENAN,'dd/MM/yyyy'),3,TO_CHAR(BAPT.NGAYTUYENAN,'dd/MM/yyyy'), ''))) =   TO_CHAR(VV_NgayBA,'dd/MM/yyyy') )
                    AND (vMaVuViec is null OR   LOWER(A.MAVUVIEC) LIKE  '%'||LOWER(vMaVuViec)||'%'   )   
                    AND (vTenVuViec is null OR   LOWER(A.TENVUVIEC) LIKE  '%'||LOWER(vTenVuViec)||'%'   )         
                    AND (vTuNgay IS NULL OR  A.NGAYTAO>=VV_TUNGAY) 
                    AND (vDenNgay IS NULL OR A.NGAYTAO<=VV_DENNGAY) 
                    AND (vTrangThai IS NULL OR vTrangThai = -1 OR  DECODE(BAST.ISCONGBOBA,1, 1,0) = vTrangThai ) --where ROWNUM =1

            )tt --
        ;
END GETQUANLYCBBA_APS; 

END PKG_QLHS_STPT;

/
