create or replace PACKAGE BODY PKG_BAOCAO_VUGDKT AS

PROCEDURE SOLIEU_VUGDKT3
(   V_DATE_FROM VARCHAR2 DEFAULT NULL,
    V_DATE_TO VARCHAR2 DEFAULT NULL,
    V_TOAANID NUMBER DEFAULT NULL,
    V_PHONGBANID NUMBER  DEFAULT NULL,
    curReturn    OUT       sys_refcursor
)
AS 
    v_cursor SYS_REFCURSOR;  
    v7KETQUAGQ varchar2(100);
    vTongGiaiQuyetTuan number;
    vTongGiaiQuyetTuanTLD number;
    vTongGiaiQuyetTuanKN number;
    vTongGiaiQuyetTuanXD number;
    
    v7TONGSOVUTRINH varchar2(200);
    v7TONGSOVUDANGGIAIQUYET number;
    v7TRINHLDV number;    
    v7TRINHTP number;
    v7TRINHPCA number;
    v7TRINHCA number;
    v7TRINHBAOCAOTOTP number;
    v7TRINHBAOCAOUBTP number;
    v7TRINHDUTHAOTLD number;
    v7TRINHDUTHAOKN number;
    
    
    v7XETXU varchar2(200);
    v7TongXETXU number;
    v7XXVKS number;
    v7XXCA number;
    
    vTONGPHAIGQ varchar2(200);
    vTONGPHAIGQ_C number;
    vTONGKDTM number;
    vTONGHNGD number;
    vTONGLD number;
    vTONGDS number;
    vTONGPS number;
    
    vTONGGIAIQUYET  varchar2(200);
    vTONGGIAIQUYETc number;
    vTONGKN number;
    vTONGTLD number;
    vTONGTXD number;
    
    vTONGTT varchar2(200);
    v_TONGTT number;
    vTRINHLDV number;    
    vTRINHTP number;
    vTRINHPCA number;
    vTRINHCA number;
    vTRINHBAOCAOTOTP number;
    vTRINHBAOCAOUBTP number;
    vTRINHDUTHAOTLD number;
    vTRINHDUTHAOKN number;
    
    vTONGTLXX varchar2(300);
    v_TONGTLXX number;
    v_TONGTLXX_VKS number;    
    v_TONGTLXX_CA number;
    v_TONGTLXX_CACCHN number;
    v_TONGTLXX_CACCHCM number;
    v_TONGTLXX_CACCDN number;
    
    vNAMXETXU  varchar2(200);
    v_NAMXETXU number;
    
    
    vLICHXXGDT varchar2(50);
    v_LICHXXGDT number;
    
    vLICHXXGDT_CT varchar2(300);
    v_LICHXXGDT_CT  number;
    v_LICHXXGDT_CACA number;
    v_LICHXXGDT_CTVKS number;
    v_LICHXXGDT_CACCHN number;
    v_LICHXXGDT_CACCDN number;
    v_LICHXXGDT_CACCHCM number;
    
    vTONGTRAODOI  varchar2(200);
    v_TONGTRAODOI  number;
    vTRAODOI_VB    varchar2(200);
    v_TRAODOI_VB   number;
    vTRAODOI_TOTRINH  varchar2(200);
    v_TRAODOI_TOTRINH  number;
    
    
    
    
    v_from date;
    v_to date;
    v_daunamCongtac date;
    v_thang number;
    v_nam number;
 
BEGIN

   
   
    v_from:=TO_DATE(V_DATE_FROM ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
    v_to:=TO_DATE(V_DATE_TO||'23:59:59', 'dd/MM/yyyy  hh24:mi:ss');
    v_thang := EXTRACT(MONTH FROM v_from);
    v_nam := EXTRACT(YEAR FROM v_from);
    IF v_thang <10 then
        v_daunamCongtac:=TO_DATE('01/10/'|| TO_CHAR(v_nam-1) ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
    else
        v_daunamCongtac:=TO_DATE('01/10/'|| TO_CHAR(v_nam) ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
    end if;
    
    -----1.Tong so theo tuan------------------------------ 
        select count(v.id) into vTongGiaiQuyetTuan from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_from AND v_to
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;
       -- Tong tra loi don trong tuan                             
      select count(v.id) into vTongGiaiQuyetTuanTLD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_from AND v_to
                                                               AND kq.gqd_loaiketqua = 0
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ; 
--     Tong khang nghi trong tuan                                
     select count(v.id) into vTongGiaiQuyetTuanKN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_from AND v_to
                                                               AND kq.gqd_loaiketqua = 1
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;    
--    Tong xep don trong tuan                                 
    select count(v.id) into vTongGiaiQuyetTuanXD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    and NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.gdq_ngay BETWEEN v_from AND v_to
                                                               AND kq.gqd_loaiketqua in (2,3,4)
                                                               AND kq.trangthai = 1
                                                               ) 
                                     ;  
        IF vTongGiaiQuyetTuan > 0 THEN                             
          v7KETQUAGQ :=  
                        CASE 
                            WHEN vTongGiaiQuyetTuan > 0  and vTongGiaiQuyetTuan <= 9 THEN '0'|| TO_CHAR(vTongGiaiQuyetTuan)                            
                            WHEN vTongGiaiQuyetTuan > 9  THEN TO_CHAR(vTongGiaiQuyetTuan)                            
                            ELSE ''
                         END 
                        || ' vụ ('|| 
                        CASE 
                            WHEN vTongGiaiQuyetTuanTLD > 0  and vTongGiaiQuyetTuanTLD <= 9 THEN 'Trả lời đơn: 0'|| TO_CHAR(vTongGiaiQuyetTuanTLD) ||';'                            
                            WHEN vTongGiaiQuyetTuanTLD > 9  THEN 'Trả lời đơn: '|| TO_CHAR(vTongGiaiQuyetTuanTLD) ||';'                            
                            ELSE ''
                         END 
                         || 
                         CASE 
                            WHEN vTongGiaiQuyetTuanKN > 0  and vTongGiaiQuyetTuanKN <= 9 THEN 'Trả lời đơn: 0'|| TO_CHAR(vTongGiaiQuyetTuanKN) ||';'                            
                            WHEN vTongGiaiQuyetTuanKN > 9  THEN 'Kháng nghị: '|| TO_CHAR(vTongGiaiQuyetTuanKN) ||';'                            
                            ELSE ''
                         END
                           || 
                         CASE 
                            WHEN vTongGiaiQuyetTuanXD > 0  and vTongGiaiQuyetTuanXD <= 9 THEN 'Trả lời đơn: 0'|| TO_CHAR(vTongGiaiQuyetTuanXD) ||';'                            
                            WHEN vTongGiaiQuyetTuanXD > 9  THEN 'Xử lý khác: '|| TO_CHAR(vTongGiaiQuyetTuanXD) ||';'   
                            ELSE ''
                         END
                         || ')';            
           
         ELSE
            v7KETQUAGQ := '0 vụ';
         END IF;
    -----2.Dang nghien cu va co to trinh trong tuan------------------- 
     select count(v.id) into v7TONGSOVUDANGGIAIQUYET from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                ) 
                                     ;
--        dang trinh LDV                             
       select count(v.id) into v7TRINHLDV from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (4,5) --Trinh PVT hoac VT
                                                ) 
                                     ;
                                     
    --        dang trinh TPTC                             
       select count(v.id) into v7TRINHTP from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (6) --Trinh TPTC
                                                ) 
                                     ;
--        dang trinh PCA                             
       select count(v.id) into v7TRINHPCA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                ) 
                                     ;                                
--        dang trinh CA                             
       select count(v.id) into v7TRINHCA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (8) --Trinh CA
                                                ) 
                                     ;         
 
    
--        dang trinh BAO CAO TO THAM PHAN                            
       select count(v.id) into v7TRINHBAOCAOTOTP from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (9)
                                                ) 
                                     ;  

--        dang trinh Dự thao tld                           
       select count(v.id) into v7TRINHDUTHAOTLD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (11) 
                                                ) 
                                     ; 
--        dang trinh Dự thao khang nghi                           
       select count(v.id) into v7TRINHDUTHAOKN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_from AND v_to
                                                    AND TT.TINHTRANGID in (12) 
                                                ) 
                            ;

----------------Tong dang trinh-----------------------------------                            
     IF v7tongsovudanggiaiquyet > 0 THEN
        v7TONGSOVUTRINH := CASE 
                                    WHEN v7tongsovudanggiaiquyet > 0  and v7tongsovudanggiaiquyet <= 9 THEN '0'|| TO_CHAR(v7tongsovudanggiaiquyet) ||';'                            
                                    WHEN v7tongsovudanggiaiquyet > 9  THEN ''|| TO_CHAR(v7tongsovudanggiaiquyet) ||';'   
                                    ELSE ''
                             END  
                            || ' vụ, trong đó:'
                            ||  CASE 
                                    WHEN v7trinhldv > 0  and v7trinhldv <= 9 THEN 'trình Lãnh đạo vụ 0'|| TO_CHAR(v7trinhldv) ||';'                            
                                    WHEN v7trinhldv > 9  THEN 'trình Lãnh đạo vụ '|| TO_CHAR(v7trinhldv) ||';'   
                                    ELSE ''
                             END 
                            || CASE 
                                WHEN v7trinhtp > 0  and v7trinhtp <= 9 THEN 'trình Thẩm phán TANDTC 0'|| TO_CHAR(v7trinhtp) ||';'                            
                                WHEN v7trinhtp > 9  THEN 'trình Thẩm phán TANDTC '|| TO_CHAR(v7trinhtp) ||';'   
                                ELSE ''
                             END 
                            || CASE 
                                WHEN v7trinhpca > 0  and v7trinhpca <= 9 THEN 'trình Phó Chánh án 0'|| TO_CHAR(v7trinhpca) ||';'                            
                                WHEN v7trinhpca > 9  THEN 'trình Phó Chánh án '|| TO_CHAR(v7trinhpca) ||';'   
                                ELSE ''
                             END 
                            || CASE                              
                                WHEN v7trinhbaocaototp > 0  and v7trinhbaocaototp <= 9 THEN 'báo cáo Tổ Thẩm phán 0'|| TO_CHAR(v7trinhbaocaototp) ||';'                            
                                WHEN v7trinhbaocaototp > 9  THEN 'báo cáo Tổ Thẩm phán '|| TO_CHAR(v7trinhbaocaototp) ||';'   
                                ELSE ''
                             END
                            || CASE 
                                WHEN v7trinhca > 0  and v7trinhca <= 9 THEN 'trình Chánh án 0'|| TO_CHAR(v7trinhca) ||';'                            
                                WHEN v7trinhca > 9  THEN 'trình Chánh án '|| TO_CHAR(v7trinhca) ||';'
                                ELSE ''
                             END
                            || CASE 
                                WHEN v7trinhduthaotld > 0  and v7trinhduthaotld <= 9 THEN 'trình dự thảo Trả lời đơn 0'|| TO_CHAR(v7trinhduthaotld) ||';'                            
                                WHEN v7trinhduthaotld > 9  THEN 'trình dự thảo Trả lời đơn  '|| TO_CHAR(v7trinhduthaotld) ||';'
                                ELSE ''
                             END
                             || CASE 
                                WHEN v7trinhduthaokn > 0  and v7trinhduthaokn <= 9 THEN 'trình dự thảo Kháng nghị 0'|| TO_CHAR(v7trinhduthaokn) ||';'                            
                                WHEN v7trinhduthaokn > 9  THEN 'trình dự thảo Kháng nghị '|| TO_CHAR(v7trinhduthaokn) ||';'
                                ELSE ''
                             END 
                            
                ;
     ELSE
        v7TONGSOVUTRINH := '0 vụ';
     END IF;

--------3.Xet xu trong tuan---------------          
           select count(v.id) into v7TongXETXU from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)
                                    and NVL(v.XXGDTTT_ISKETQUA,0)>0
                                    AND v.NGAYXUGIAMDOCTHAM BETWEEN v_from and v_to
                            ;
                            
--------Xet xu trong tuan do KNCA---------------                 
            select count(v.id) into v7XXCA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)
                                    AND V.ISVIENTRUONGKN = 0
                                    and NVL(v.XXGDTTT_ISKETQUA,0)>0
                                    AND v.NGAYXUGIAMDOCTHAM BETWEEN v_from and v_to
                            ;                    
--------Xet xu trong tuan do KN VKS---------------                 
            select count(v.id) into v7XXVKS from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)
                                    AND V.ISVIENTRUONGKN = 1
                                    and NVL(v.XXGDTTT_ISKETQUA,0)>0
                                    AND v.NGAYXUGIAMDOCTHAM BETWEEN v_from and v_to
                            ;                             
    
----------------Tong da xet xu trong tuan-----------------------------------                            
     IF v7TongXETXU > 0 THEN
        v7xetxu := 
                            CASE 
                                WHEN v7TongXETXU > 0  and v7TongXETXU <= 9 THEN  TO_CHAR(v7TongXETXU)                            
                                WHEN v7TongXETXU > 9  THEN TO_CHAR(v7TongXETXU)
                                ELSE ''
                             END 
                            || ' vụ (trong đó:'
                            ||  CASE 
                                    WHEN v7XXVKS > 0  and v7XXVKS <= 9 THEN  TO_CHAR(v7XXVKS) ||' vụ kháng nghị của Viện trưởng Viện kiểm sát nhân dân tối cao;'                           
                                    WHEN v7XXVKS > 9  THEN TO_CHAR(v7XXVKS) ||' vụ kháng nghị của Viện trưởng Viện kiểm sát nhân dân tối cao;'                             
                                    ELSE ''
                             END 
                            ||  CASE 
                                    WHEN v7XXCA > 0  and v7XXCA <= 9 THEN  TO_CHAR(v7XXCA) ||' vụ kháng nghị của Chánh án Tòa án nhân dân tối cao'                          
                                    WHEN v7XXCA > 9  THEN TO_CHAR(v7XXCA) ||' vụ kháng nghị của Chánh án Tòa án nhân dân tối cao'  
                                ELSE ''
                             END 
                            || ')'
                            
                ;

     ELSE
        v7xetxu := '0 vụ';
     END IF;     
 
 --------4.Tong phai giai quyet den ngay--------------- kiem tra lai xem tu dau nam duong lich hay dau nam cong tac          
           select count(v.id) into vTONGPHAIGQ_C from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID  
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay < v_daunamCongtac
                                                               ) 
                                                    )
                            ;    
 --------Tong phai giai quyet an KDTM ---------------          
           select count(v.id) into vTONGKDTM from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND v.loaian = 4
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID 
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay < v_daunamCongtac
                                                               ) 
                                                    )
                            ;  
 --------Tong phai giai quyet an HNGD ---------------          
           select count(v.id) into vTONGHNGD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND v.loaian = 3
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID 
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay < v_daunamCongtac
                                                               ) 
                                                    )
                            ;  
 --------Tong phai giai quyet an Lao dong ---------------          
           select count(v.id) into vTONGLD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND v.loaian = 5
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID 
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay < v_daunamCongtac
                                                               ) 
                                                    )
                            ;  
 --------Tong phai giai quyet an Dan su ---------------          
           select count(v.id) into vTONGDS from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND v.loaian = 2
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay < v_daunamCongtac
                                                               ) 
                                                    )
                            ;
 --------Tong phai giai quyet an Dan su ---------------          
           select count(v.id) into vTONGPS from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND v.loaian = 7
                                    AND (NOT EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID 
                                                               AND kq.trangthai = 1
                                                               ) 
                                            OR 
                                            
                                            EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay < v_daunamCongtac
                                                               ) 
                                                    )
                            ;
                            
             ----------------Tong phai giai quyet-----------------------------------                            
     IF vTONGPHAIGQ_C > 0 THEN
               vTONGPHAIGQ := CASE 
                                    WHEN vTONGPHAIGQ_C > 0  and vTONGPHAIGQ_C <= 9 THEN TO_CHAR(vTONGPHAIGQ_C)
                                    WHEN vTONGPHAIGQ_C > 9  THEN TO_CHAR(vTONGPHAIGQ_C)
                                ELSE ''
                             END 
                            || ' vụ (gồm:'
                            ||  CASE                                
                                    WHEN vtongkdtm > 0  and vtongkdtm <= 9 THEN  TO_CHAR(vtongkdtm) ||' vụ kinh doanh, thương mại;'
                                    WHEN vtongkdtm > 9  THEN TO_CHAR(vtongkdtm) ||' vụ kinh doanh, thương mại;'
                                ELSE ''
                             END 
                            ||  CASE 
                                    WHEN vtonghngd > 0  and vtonghngd <= 9 THEN  TO_CHAR(vtonghngd) ||' vụ hôn nhân và gia đình;'
                                    WHEN vtonghngd > 9  THEN TO_CHAR(vtonghngd) ||' vụ hôn nhân và gia đình;'
                                ELSE ''
                             END
                            ||  CASE 
                                    WHEN vtongld > 0  and vtongld <= 9 THEN  TO_CHAR(vtongld) ||' vụ lao động;'
                                    WHEN vtongld > 9  THEN TO_CHAR(vtongld) ||' vụ lao động;'
                                ELSE ''
                             END 
                            ||  CASE 
                                    WHEN vtongds > 0  and vtongds <= 9 THEN  TO_CHAR(vtongds) ||' vụ dân sự;'
                                    WHEN vtongds > 9  THEN TO_CHAR(vtongds) ||' vụ dân sự;'
                                ELSE ''
                             END
                            ||  CASE                               
                                    WHEN vtongps > 0  and vtongps <= 9 THEN  TO_CHAR(vtongps) ||' vụ phá sản;'
                                    WHEN vtongps > 9  THEN TO_CHAR(vtongps) ||' vụ phá sản;'
                                ELSE ''
                             END 
                            || ')'
                            
                ;

     ELSE
        vTONGPHAIGQ := '0 vụ';
     END IF;     
 
 --------5.Tong da giai quyet---------------      
select count(v.id) into vTONGGIAIQUYETc from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay BETWEEN  v_daunamCongtac and v_to 
                                                               ) 
                            ;
                            
 --------Tong da giai quyet Khang nghi, TLD, XEP DON---------------      
select count(v.id) into vTONGKN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay BETWEEN  v_daunamCongtac and v_to 
                                                               AND KQ.GQD_LOAIKETQUA = 1
                                                               ) 
                            ;
select count(v.id) into vTONGTLD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay BETWEEN  v_daunamCongtac and v_to 
                                                               AND KQ.GQD_LOAIKETQUA = 0
                                                               ) 
                            ;                            
select count(v.id) into vTONGTXD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND EXISTS( SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               AND kq.gdq_ngay BETWEEN  v_daunamCongtac and v_to 
                                                               AND KQ.GQD_LOAIKETQUA in (2,3,4)
                                                               ) 
                            ;   
  
                  ----------------Tong da giai quyet-----------------------------------                            
     IF vTONGGIAIQUYETc > 0 THEN
        vTONGGIAIQUYET := CASE                               
                                    WHEN vTONGGIAIQUYETc > 0  and vTONGGIAIQUYETc <= 9 THEN  '0'||TO_CHAR(vTONGGIAIQUYETc)
                                    WHEN vTONGGIAIQUYETc > 9  THEN TO_CHAR(vTONGGIAIQUYETc)
                                ELSE '0'
                             END 
                            || ' vụ ('
                            ||  CASE 
                                    WHEN vTONGKN > 0  and vTONGKN <= 9 THEN  'Kháng nghị: 0' ||TO_CHAR(vTONGKN) ||' vụ;'
                                    WHEN vTONGKN > 9  THEN 'Kháng nghị: ' ||TO_CHAR(vTONGKN) ||' vụ;'
                                ELSE ''
                             END 
                            ||  CASE 
                                    WHEN vTONGTLD > 0  and vTONGTLD <= 9 THEN  'Kháng nghị: 0' ||TO_CHAR(vTONGTLD) ||' vụ;'
                                    WHEN vTONGTLD > 9  THEN 'Trả lời đơn: ' ||TO_CHAR(vTONGTLD) ||' vụ;'
                                ELSE ''
                             END
                            ||  CASE 
                                    WHEN vTONGTXD > 0  and vTONGTXD <= 9 THEN  'Kháng nghị: 0' ||TO_CHAR(vTONGTXD) ||' vụ;'
                                    WHEN vTONGTXD > 9  THEN 'Xử lý khác:: ' ||TO_CHAR(vTONGTXD) ||' vụ;'
                                ELSE ''
                             END 
                            || ')'
                            
                ;

     ELSE
        vTONGGIAIQUYET := '0 vụ';
     END IF; 
     
  -----6.Dang nghien cu va co to trinh trong nam------------------- 
     select count(v.id) into v_TONGTT from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                ) 
                                     ;
--        dang trinh LDV                             
       select count(v.id) into vTRINHLDV from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (4,5) --Trinh PVT hoac VT
                                                ) 
                                     ;
                                     
    --        dang trinh TPTC                             
       select count(v.id) into vTRINHTP from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (6) --Trinh TPTC
                                                ) 
                                     ;
--        dang trinh PCA                             
       select count(v.id) into vTRINHPCA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (7) --Trinh PCA
                                                ) 
                                     ;                                
--        dang trinh CA                             
       select count(v.id) into vTRINHCA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (8) --Trinh CA
                                                ) 
                                     ;         
 
    
--        dang trinh BAO CAO TO THAM PHAN                            
       select count(v.id) into vTRINHBAOCAOTOTP from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (9)
                                                ) 
                                     ;  

--        dang trinh Dự thao tld                           
       select count(v.id) into vTRINHDUTHAOTLD from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (11) 
                                                ) 
                                     ; 
--        dang trinh Dự thao khang nghi                           
       select count(v.id) into vTRINHDUTHAOKN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NOT EXISTS( SELECT 1 FROM GDTTT_VUAN_KETQUA KQ
                                                               WHERE KQ.VUANID = V.ID
                                                               AND kq.trangthai = 1
                                                               ) 
                                    AND  EXISTS (
                                                    SELECT 1
                                                    FROM GDTTT_TOTRINH TT
                                                    WHERE TT.ID = (
                                                        SELECT MAX(TT2.ID)
                                                        FROM GDTTT_TOTRINH TT2
                                                        WHERE TT2.VUANID = v.ID                                                        
                                                    )
                                                    AND TT.NGAYTRINH BETWEEN v_daunamCongtac AND v_to
                                                    AND TT.TINHTRANGID in (12) 
                                                ) 
                            ;

----------------Tong dang trinh-----------------------------------                            
     IF v_TONGTT > 0 THEN
        vTONGTT := CASE 
                        WHEN v_TONGTT > 0  and v_TONGTT <= 9 THEN '0'|| TO_CHAR(v_TONGTT)                           
                        WHEN v_TONGTT > 9  THEN ''|| TO_CHAR(v_TONGTT)   
                        ELSE '0'
                     END  
                            || ' vụ, trong đó:'
                            ||  CASE 
                                    WHEN vtrinhldv > 0  and vtrinhldv <= 9 THEN ' trình Lãnh đạo vụ 0'|| TO_CHAR(vtrinhldv) ||' vụ;'                            
                                    WHEN vtrinhldv > 9  THEN ' trình Lãnh đạo vụ '|| TO_CHAR(vtrinhldv) ||' vụ;'   
                                    ELSE ''
                             END 
                            || CASE 
                                WHEN vtrinhtp > 0  and vtrinhtp <= 9 THEN ' trình Thẩm phán TANDTC 0'|| TO_CHAR(vtrinhtp) ||' vụ;'                            
                                WHEN vtrinhtp > 9  THEN ' trình Thẩm phán TANDTC '|| TO_CHAR(vtrinhtp) ||' vụ;'   
                                ELSE ''
                             END 
                            || CASE 
                                WHEN vtrinhpca > 0  and vtrinhpca <= 9 THEN ' trình Phó Chánh án 0'|| TO_CHAR(vtrinhpca) ||' vụ;'                            
                                WHEN vtrinhpca > 9  THEN ' trình Phó Chánh án '|| TO_CHAR(vtrinhpca) ||' vụ;'   
                                ELSE ''
                             END 
                            || CASE                              
                                WHEN vtrinhbaocaototp > 0  and vtrinhbaocaototp <= 9 THEN ' báo cáo Tổ Thẩm phán 0'|| TO_CHAR(vtrinhbaocaototp) ||' vụ;'                            
                                WHEN vtrinhbaocaototp > 9  THEN ' báo cáo Tổ Thẩm phán '|| TO_CHAR(vtrinhbaocaototp) ||' vụ;'   
                                ELSE ''
                             END
                            || CASE 
                                WHEN vtrinhca > 0  and vtrinhca <= 9 THEN ' trình Chánh án 0'|| TO_CHAR(vtrinhca) ||' vụ;'                            
                                WHEN vtrinhca > 9  THEN ' trình Chánh án '|| TO_CHAR(vtrinhca) ||' vụ;'
                                ELSE ''
                             END
                            || CASE 
                                WHEN vtrinhduthaotld > 0  and vtrinhduthaotld <= 9 THEN 'trình dự thảo Trả lời đơn 0'|| TO_CHAR(vtrinhduthaotld) ||' vụ;'                            
                                WHEN vtrinhduthaotld > 9  THEN 'trình dự thảo Trả lời đơn  '|| TO_CHAR(vtrinhduthaotld) ||'vụ;'
                                ELSE ''
                             END
                             || CASE 
                                WHEN vtrinhduthaokn > 0  and vtrinhduthaokn <= 9 THEN ' trình dự thảo Kháng nghị 0'|| TO_CHAR(vtrinhduthaokn) ||' vụ;'                            
                                WHEN vtrinhduthaokn > 9  THEN ' trình dự thảo Kháng nghị '|| TO_CHAR(vtrinhduthaokn) ||' vụ;'
                                ELSE ''
                             END 
                            
                ;
     ELSE
        vTONGTT := '0 vụ';
     END IF;    
     
  -----7.Xet xu giam doc tham------------------- 
     select count(v.id) into v_TONGTLXX from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))   
                                     ;   
    ---Kháng nghị của Chánh An TANDTC
         select count(v.id) into v_TONGTLXX_CA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 0
                                     ;   
     ---Kháng nghị của Chánh An CCHN
         select count(v.id) into v_TONGTLXX_CACCHN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 819
                                     ; 
       ---Kháng nghị của Chánh An CCHCM
         select count(v.id) into v_TONGTLXX_CACCHCM from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 821
                                     ;   
           ---Kháng nghị của Chánh An CCDN
         select count(v.id) into v_TONGTLXX_CACCDN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 820
                                     ; 
        ---Kháng nghị của VIEN TRUONG VKS
         select count(v.id) into v_TONGTLXX_VKS from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) in (1)                                   
                                     AND ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.IsRutKN,0) = 0)
                                             or (v.XXGDTTT_KETQUAID>0 
                                                  and (v.XXGDTTT_NGAYQD > v_daunamCongtac))
                                             or (NVL(v.IsRutKN,0) = 1 and v.ngayrutkn > v_daunamCongtac)
                                            )
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 1
                                     ;                               
         IF v_TONGTLXX > 0 THEN
             vTONGTLXX := CASE 
                                WHEN v_TONGTLXX > 0  and v_TONGTLXX <= 9 THEN '0'|| TO_CHAR(v_TONGTLXX)                            
                                WHEN v_TONGTLXX > 9  THEN ''|| TO_CHAR(v_TONGTLXX)  
                                ELSE ''
                            END  
                            || ' vụ (trong đó:'
                            ||  CASE 
                                    WHEN v_TONGTLXX_CA > 0  and v_TONGTLXX_CA <= 9 THEN ' 0'|| TO_CHAR(v_TONGTLXX_CA) ||' vụ kháng nghị của Chánh án TANDTC;'                            
                                    WHEN v_TONGTLXX_CA > 9  THEN  TO_CHAR(v_TONGTLXX_CA) ||' vụ kháng nghị của Chánh án TANDTC;'   
                                    ELSE ''
                             END 
                            ||  CASE 
                                    WHEN v_TONGTLXX_VKS > 0  and v_TONGTLXX_VKS <= 9 THEN ' 0'|| TO_CHAR(v_TONGTLXX_VKS) ||' vụ kháng nghị của Viện trưởng Viện kiểm sát nhân dân tối cao;'                            
                                    WHEN v_TONGTLXX_VKS > 9  THEN  TO_CHAR(v_TONGTLXX_VKS) ||' vụ kháng nghị của Viện trưởng Viện kiểm sát nhân dân tối cao;'   
                                    ELSE ''
                             END 
                            || CASE 
                                     WHEN v_TONGTLXX_CACCHN > 0  and v_TONGTLXX_CACCHN <= 9 THEN ' 0'|| TO_CHAR(v_TONGTLXX_CACCHN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hà Nội;'                            
                                     WHEN v_TONGTLXX_CACCHN > 9  THEN  TO_CHAR(v_TONGTLXX_CACCHN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hà Nội;'   
                                ELSE ''
                             END 
                            || CASE 
                                     WHEN v_TONGTLXX_CACCHCM > 0  and v_TONGTLXX_CACCHCM <= 9 THEN ' 0'|| TO_CHAR(v_TONGTLXX_CACCHCM) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hồ Chí Minh;'                            
                                     WHEN v_TONGTLXX_CACCHCM > 9  THEN  TO_CHAR(v_TONGTLXX_CACCHCM) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hồ Chí Minh;'      
                                ELSE ''
                             END 
                            || CASE                              
                                    WHEN v_TONGTLXX_CACCDN > 0  and v_TONGTLXX_CACCDN <= 9 THEN ' 0'|| TO_CHAR(v_TONGTLXX_CACCDN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Đà Nẵng;'                            
                                    WHEN v_TONGTLXX_CACCDN > 9  THEN  TO_CHAR(v_TONGTLXX_CACCDN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Đà Nẵng;'      
                                ELSE ''
                             END
                            || ');'
                ;
     ELSE
        vTONGTLXX := '0 vụ';
     END IF;    
     
--  dA XET XU TRONG NAM
     select count(v.id) into v_NAMXETXU from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)>0
                                    AND V.XXGDTTT_NGAYQD BETWEEN v_daunamCongtac and v_to
                                     ;
        IF v_NAMXETXU > 0 THEN
             vNAMXETXU := CASE 
                                WHEN v_NAMXETXU > 0  and v_NAMXETXU <= 9 THEN '0'|| TO_CHAR(v_NAMXETXU)                            
                                WHEN v_NAMXETXU > 9  THEN  TO_CHAR(v_NAMXETXU)   
                                ELSE ''
                            END      
                ;
         ELSE
            vNAMXETXU := '0';
         END IF;                                   
                                     
--------8.Đã thụ lý nhưng chưa xet xử-------------------
      
       select count(v.id) into v_LICHXXGDT from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)
                                    AND NVL(v.IsRutKN,0) = 0
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
                                    and NVL(v.XXGDTTT_KETQUAID,0)=0 
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                     ;
       
        IF v_LICHXXGDT > 0 THEN
             vLICHXXGDT := CASE 
                                WHEN v_LICHXXGDT > 0  and v_LICHXXGDT <= 9 THEN '0'|| TO_CHAR(v_LICHXXGDT)                            
                                WHEN v_LICHXXGDT > 9  THEN  TO_CHAR(v_LICHXXGDT)   
                                ELSE ''
                            END      
                ;
         ELSE
            vLICHXXGDT := '0';
         END IF;                                  

--------.Chi tiet Đã thụ lý nhưng chưa xet xử-------------------
      ---Kháng nghị của Chánh An TANDTC
       select count(v.id) into v_LICHXXGDT_CACA from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10,1)
                                    AND NVL(v.IsRutKN,0) = 0
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
                                    and NVL(v.XXGDTTT_KETQUAID,0)=0 
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 0
                                     ;       
                                      
     ---Kháng nghị của Chánh An CCHN
         select count(v.id) into v_LICHXXGDT_CACCHN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND NVL(v.IsRutKN,0) = 0
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
                                    and NVL(v.XXGDTTT_KETQUAID,0)=0 
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 819
                                     ; 
       ---Kháng nghị của Chánh An CCHCM
         select count(v.id) into v_LICHXXGDT_CACCHCM from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND NVL(v.IsRutKN,0) = 0
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
                                    and NVL(v.XXGDTTT_KETQUAID,0)=0
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 821
                                     ;   
           ---Kháng nghị của Chánh An CCDN
         select count(v.id) into v_LICHXXGDT_CACCDN from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0) not in (8,10)                                   
                                    AND NVL(v.IsRutKN,0) = 0
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
                                    and NVL(v.XXGDTTT_KETQUAID,0)=0
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 820
                                     ; 
        ---Kháng nghị của VIEN TRUONG VKS
         select count(v.id) into v_LICHXXGDT_CTVKS from GSCM.gdttt_vuan v
                                    where v.toaanid = V_TOAANID
                                    AND v.phongbanid = V_PHONGBANID
                                    AND NVL(v.truonghopthuly,0)  in (1)                                   
                                    AND NVL(v.IsRutKN,0) = 0
                                    AND NVL(v.XXGDTTT_ISKETQUA,0)=0 
                                    and NVL(v.XXGDTTT_KETQUAID,0)=0
                                    AND (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')) 
                                    AND NVL(v.IsVienTruongKN,0) = 1
                                    AND v.VIENTRUONGKN_NGUOIKY = 1
                                     ;                            

        
         IF v_LICHXXGDT > 0 THEN
             vLICHXXGDT_CT := ' (trong đó:'
                            ||  CASE 
                                    WHEN v_LICHXXGDT_CACA > 0  and v_LICHXXGDT_CACA <= 9 THEN ' 0'|| TO_CHAR(v_LICHXXGDT_CACA) ||' vụ kháng nghị của Chánh án TANDTC;'                            
                                    WHEN v_LICHXXGDT_CACA > 9  THEN  TO_CHAR(v_LICHXXGDT_CACA) ||' vụ kháng nghị của Chánh án TANDTC;'   
                                    ELSE ''
                             END 
                            ||  CASE 
                                    WHEN v_LICHXXGDT_CTVKS > 0  and v_LICHXXGDT_CTVKS <= 9 THEN ' 0'|| TO_CHAR(v_LICHXXGDT_CTVKS) ||' vụ kháng nghị của Viện trưởng VKSNDTC;'                            
                                    WHEN v_LICHXXGDT_CTVKS > 9  THEN  TO_CHAR(v_LICHXXGDT_CTVKS) ||' vụ kháng nghị của Viện trưởng VKSNDTC;'   
                                    ELSE ''
                             END 
                            || CASE 
                                     WHEN v_LICHXXGDT_CACCHN > 0  and v_LICHXXGDT_CACCHN <= 9 THEN ' 0'|| TO_CHAR(v_LICHXXGDT_CACCHN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hà Nội trước đây;'                            
                                     WHEN v_LICHXXGDT_CACCHN > 9  THEN  TO_CHAR(v_LICHXXGDT_CACCHN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hà Nội trước đây;'   
                                ELSE ''
                             END 
                            || CASE 
                                     WHEN v_LICHXXGDT_CACCHCM > 0  and v_LICHXXGDT_CACCHCM <= 9 THEN ' 0'|| TO_CHAR(v_LICHXXGDT_CACCHCM) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hồ Chí Minh trước đây;'                            
                                     WHEN v_LICHXXGDT_CACCHCM > 9  THEN  TO_CHAR(v_LICHXXGDT_CACCHCM) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Hồ Chí Minh trước đây;'      
                                ELSE ''
                             END 
                            || CASE                              
                                    WHEN v_LICHXXGDT_CACCDN > 0  and v_LICHXXGDT_CACCDN <= 9 THEN ' 0'|| TO_CHAR(v_LICHXXGDT_CACCDN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Đà Nẵng trước đây;'                            
                                    WHEN v_LICHXXGDT_CACCDN > 9  THEN  TO_CHAR(v_LICHXXGDT_CACCDN) ||' vụ kháng nghị của Chánh án TAND cấp cáo tại Thành phố Đà Nẵng trước đây;'      
                                ELSE ''
                             END
                            || ')'
                ;
         ELSE
            vLICHXXGDT_CT := '';
         END IF; 
      
  --------9. Cong van trao doi-------------------------    
  
     select count(v.id) into v_TONGTRAODOI  from GDTTT_VUAN_TRAODOICONGVAN v 
                         where v.DonViId = V_TOAANID
                            AND v.phongbanid = V_PHONGBANID
                            AND v.NgayCV < v_to
                            AND (to_char(v.KQ_NgayCongVan,'dd/MM/yyyy') ='01/01/0001'
                                OR v.KQ_NgayCongVan is null
                                OR v.KQ_NgayCongVan > v_daunamCongtac
                                )
                            
                            ;
                            
         IF v_TONGTRAODOI > 0 THEN
             vTONGTRAODOI := CASE 
                                WHEN v_TONGTRAODOI > 0  and v_TONGTRAODOI <= 9 THEN '0'|| TO_CHAR(v_TONGTRAODOI)                            
                                WHEN v_TONGTRAODOI > 9  THEN  TO_CHAR(v_TONGTRAODOI)   
                                ELSE ''
                            END      
                ;
         ELSE
            vTONGTRAODOI := '0';
         END IF; 
         
    ---- Tong so dã phat hanh
     select count(v.id) into v_TRAODOI_VB  from GDTTT_VUAN_TRAODOICONGVAN v 
                         where v.DonViId = V_TOAANID
                            AND v.phongbanid = V_PHONGBANID
                            AND v.NgayCV BETWEEN v_daunamCongtac and v_to
                            AND v.KQ_NgayCongVan  BETWEEN v_daunamCongtac and v_to
                            ;
                            
         IF v_TRAODOI_VB > 0 THEN
             vTRAODOI_VB := CASE 
                                WHEN v_TRAODOI_VB > 0  and v_TRAODOI_VB <= 9 THEN '0'|| TO_CHAR(v_TRAODOI_VB)                            
                                WHEN v_TRAODOI_VB > 9  THEN  TO_CHAR(v_TRAODOI_VB)   
                                ELSE '0'
                            END      
                ;
         ELSE
            vTRAODOI_VB := '0';
         END IF; 
   
    ---- Tong so đang trình
     select count(v.id) into v_TRAODOI_TOTRINH  from GDTTT_VUAN_TRAODOICONGVAN v 
                         where v.DonViId = V_TOAANID
                            AND v.phongbanid = V_PHONGBANID
                            AND v.NgayCV BETWEEN v_daunamCongtac and v_to
                            AND v.KQ_NgayCongVan  BETWEEN v_daunamCongtac and v_to
                            ;
                            
         IF v_TRAODOI_TOTRINH > 0 THEN
             vTRAODOI_TOTRINH := CASE 
                                WHEN v_TRAODOI_TOTRINH > 0  and v_TRAODOI_TOTRINH <= 9 THEN '0'|| TO_CHAR(v_TRAODOI_TOTRINH)                            
                                WHEN v_TRAODOI_TOTRINH > 9  THEN  TO_CHAR(v_TRAODOI_TOTRINH)   
                                ELSE '0'
                            END      
                ;
         ELSE
            vTRAODOI_TOTRINH := '0';
         END IF; 

                            
     OPEN curReturn FOR
        SELECT 
            v7KETQUAGQ     AS "v7KETQUAGQ",
            v7TONGSOVUTRINH AS "v7TONGSOVUTRINH",
            v7xetxu        AS "v7xetxu",
            vTONGPHAIGQ    AS "vTONGPHAIGQ",
            vTONGGIAIQUYET AS "vTONGGIAIQUYET",
            vTONGTT        AS "vTONGTT",
            vTONGTLXX      AS "vTONGTLXX",
            vNAMXETXU      AS "vNAMXETXU",
            vLICHXXGDT     AS "vLICHXXGDT",
            vLICHXXGDT_CT  AS "vLICHXXGDT_CT",
            vTONGTRAODOI   AS "vTONGTRAODOI",
            vTRAODOI_VB    AS "vTRAODOI_VB",
            vTRAODOI_TOTRINH AS "vTRAODOI_TOTRINH"
        FROM dual;
      -----------------
  
END SOLIEU_VUGDKT3;


END PKG_BAOCAO_VUGDKT;