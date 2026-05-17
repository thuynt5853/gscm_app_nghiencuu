--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_BAOCAO_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_BAOCAO_APP" AS
FUNCTION GDTTT_QLTOTRINH_CHECKFIRSTTT
( 
  vVuAnID in number, 
  vTuNgay in date,
  vDenNgay in date
)
RETURN number AS 
  CountTT number:=0;
BEGIN
        SELECT COUNT(*) INTO CountTT FROM (
                select TT.*  from
                             (SELECT ROW_NUMBER() OVER (ORDER BY SS.NGAYTRINH) n_Row, SS.VUANID,
                                     SS.NGAYTRINH,TO_CHAR(SS.NGAYTRINH,'dd/MM/yyyy')NGAYTRINHS FROM GDTTT_TOTRINH SS 
                                      WHERE  SS.VUANID = vVuAnID  AND SS.TINHTRANGID>=6                              
                                     ) TT
                 where  n_Row=1
        )TS WHERE  ((TS.NGAYTRINH  >=vTuNgay AND vTuNgay IS NOT NULL) OR (vTuNgay IS NULL ))
        AND ((TS.NGAYTRINH <= vDenNgay AND vDenNgay IS NOT NULL) OR(vDenNgay  IS NULL))
        ; 
     RETURN CountTT;
END GDTTT_QLTOTRINH_CHECKFIRSTTT;

FUNCTION GDTTT_QLTOTRINH_CHECKTT
( 
  vVuAnID in number,
  vDenNgay in date
)
RETURN number AS 
 CountTT number:=0;
 vCou     number:=0;
BEGIN
     select count(id) into vCou from GDTTT_TOTRINH where VUANID = vVuAnID;
  
        if(vCou > 0) then
            SELECT COUNT(*) INTO CountTT FROM (
                    select TT.*  from
                                 (SELECT ROW_NUMBER() OVER (ORDER BY SS.NGAYTRINH) n_Row, SS.VUANID,
                                     SS.NGAYTRINH,TO_CHAR(SS.NGAYTRINH,'dd/MM/yyyy')NGAYTRINHS FROM GDTTT_TOTRINH SS 
                                      WHERE  SS.VUANID = vVuAnID  AND SS.TINHTRANGID>=6                              
                                     ) TT
                 where  n_Row=1
            )TS WHERE  ((TS.NGAYTRINH <= vDenNgay AND vDenNgay IS NOT NULL) OR(vDenNgay  IS NULL)) ; 
        end if;
        
     RETURN CountTT;
END GDTTT_QLTOTRINH_CHECKTT;
FUNCTION GDTTT_QLTOTRINH_SEAR_CHUATRINH
( 
  VVUANID IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE,
  VKETQUAYN IN NUMBER
)
RETURN NUMBER AS 
  COUNTTT NUMBER;
  LAST_NGAYTRINH DATE;
  LAST_NGAYTRA DATE;
BEGIN
     SELECT A.NGAYTRA INTO  LAST_NGAYTRA
                FROM ( SELECT  ROW_NUMBER() OVER (ORDER BY NGAYTRINH DESC) STT,NGAYTRA
                       FROM GDTTT_TOTRINH  WHERE VUANID=VVUANID
                     ) A WHERE STT<=1; 
       IF (VKETQUAYN = 0) THEN
        IF (LAST_NGAYTRA IS NULL) THEN
            COUNTTT:=1;
        ELSE
            COUNTTT:=0;
        END IF;
      END IF ;
     ----------------------------
     RETURN NVL(COUNTTT, 0);
END GDTTT_QLTOTRINH_SEAR_CHUATRINH;
FUNCTION GDTTT_DON_GETTHULYBYVUAN
( 
VVUANID IN NUMBER
)
RETURN VARCHAR2 AS 
  DSTHULY NVARCHAR2(2000);
BEGIN
 SELECT (SELECT LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                , '; ')
            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)            
            FROM GDTTT_DON CV  
            WHERE CV.VUVIECID=VVUANID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
    )  INTO DSTHULY FROM DUAL;
  RETURN NVL(DSTHULY, '');
END GDTTT_DON_GETTHULYBYVUAN;

FUNCTION GDTTT_SODEN_DON_GETTHULYBYVUAN
( 
VVUANID IN NUMBER
)
RETURN VARCHAR2 AS 
  SOTIEPNHAN VARCHAR2(2000);
BEGIN
 SELECT (SELECT LISTAGG(CASE WHEN LENGTH(NVL(SD.SODEN, ''))>0 THEN ('' || SD.SODEN ) ELSE '' END
                      || CASE WHEN LENGTH(NVL(SD.NGAY_DEN, ''))>0 THEN ('-' || TO_CHAR(SD.NGAY_DEN,'dd/MM/yyyy') ) ELSE '' END                         
                , '; ')
            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)            
            FROM GDTTT_DON CV  
             INNER JOIN  (SELECT VD.SODEN,VD.NGAY_DEN,CN.GDTTT_DON_ID 
                                                    FROM VT_VANBANDEN VD INNER JOIN  VT_CHUYEN_NHAN CN ON VD.ID = CN.VANBANDEN_ID)
                                        SD ON CV.ID= SD.GDTTT_DON_ID 
            WHERE CV.VUVIECID=VVUANID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
    )  INTO SOTIEPNHAN FROM DUAL;
  RETURN NVL(SOTIEPNHAN, '');
END GDTTT_SODEN_DON_GETTHULYBYVUAN;


FUNCTION  GDTTT_TOTRINH_GETLASTBYDK
(  VVUANID IN NUMBER
  , VTRANGTHAI IN NUMBER
  , TYPE_NGAY VARCHAR2
)
RETURN VARCHAR2 AS 
  NGAY_RETVAL VARCHAR2(10);
BEGIN
   SELECT CASE WHEN (LENGTH(NVL(A.NGAYRETVAL,''))=0 OR (TO_CHAR(A.NGAYRETVAL,'dd/MM/yyyy') ='01/01/0001')) THEN ''
                         WHEN LENGTH(NVL(A.NGAYRETVAL,'')) >0 THEN TO_CHAR(A.NGAYRETVAL,'dd/MM/yyyy')
                    END  INTO NGAY_RETVAL
    FROM ( SELECT  ROW_NUMBER() OVER (ORDER BY NGAYTRINH DESC) STT
                ,ID, TINHTRANGID                
                , (CASE  WHEN TYPE_NGAY ='NGAYDK' THEN NGAYDK 
                         WHEN TYPE_NGAY ='NGAYNHANTT' AND TINHTRANGID =6 
                              THEN NGAYLDNHANTOTRINH 
                         WHEN TYPE_NGAY ='NGAYNHANDUTHAO' AND TINHTRANGID =11
                              THEN NGAYLDNHANTOTRINH
                          WHEN TYPE_NGAY ='NGAYTRADUTHAO' AND TINHTRANGID =11
                              THEN NGAYTRA
                    END) AS NGAYRETVAL
             FROM GDTTT_TOTRINH 
             WHERE VUANID=VVUANID AND TINHTRANGID=VTRANGTHAI
           ) A WHERE STT<=1;
  RETURN NVL(NGAY_RETVAL, '');
END GDTTT_TOTRINH_GETLASTBYDK;
FUNCTION  GDTTT_XXGDTTT_GETLASTXX
(  VVUANID IN NUMBER, VISHOAN IN NUMBER
)
RETURN NUMBER AS 
  CURR_ID NUMBER;
  LAST_ID NUMBER;
  LAST_TRANGTHAI NUMBER;
BEGIN
    ------------------------------
    ---Neu trang thai can kiem tra (vIsHoan) == trang thai cuoi--> trả về id cua lan xx
    ---neu khac nhau --> id =0
 /*Rewrite */
 SELECT LAST_ID
  INTO CURR_ID
  FROM (  SELECT NVL (ID, 0) LAST_ID
            FROM GSCM.GDTTT_VUAN_XETXUGDTTT
           WHERE VUANID = VVUANID AND ISHOAN = VISHOAN
        ORDER BY NGAYMOPT DESC)
 WHERE ROWNUM = 1;
    RETURN CURR_ID;
END GDTTT_XXGDTTT_GETLASTXX;

FUNCTION CHECK_TLM_TRUNG
( 
    vDonID in number
)
RETURN NUMBER AS  
  vNum_TLM NUMBER;
  vSoBA VARCHAR2(100); vNgayBA date; vToaXX number;
  vSoBAPT VARCHAR2(100); vNgayBAPT  date; vToaXXPT number;
  vSoBAST VARCHAR2(100); vNgayBAST date; vToaXXST number;
  vLoaian NUMBER;
  vtoaanid NUMBER;
BEGIN
    SELECT BAQD_SO,BAQD_NGAYBA,BAQD_TOAANID,
            BAQD_SO_PT,BAQD_NGAYBA_PT,BAQD_TOAANID_PT,
            BAQD_SO_ST,BAQD_NGAYBA_ST,BAQD_TOAANID_ST, 
            BAQD_LOAIAN,toaanid
        INTO vSoBA, vNgayBA,vToaXX,
            vSoBAPT,vNgayBAPT,vToaXXPT,
            vSoBAST,vNgayBAST,vToaXXST,
            vLoaian , vtoaanid    
                FROM GDTTT_DON WHERE ID = vDonID;
        IF vDonID >0 THEN
         SELECT /*GSCM.PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG */  COUNT(v.ID) INTO vNum_TLM 
                        FROM GDTTT_DON v
                        WHERE v.ISTHULY = 1 
                            AND v.toaanid =  vtoaanid
                            AND v.CD_LOAI = 0 -- Nơi chuyển nội bo
                            AND v.BAQD_LOAIAN = vLoaian
                            AND ((lower(DECODE(INSTR(v.BAQD_SO,'/'),0
                                                    ,decode(INSTR(v.BAQD_SO,'0'),1
                                                                ,regexp_replace(v.BAQD_SO,'0','',1,1)
                                                                ,v.BAQD_SO )
                                                    ,decode(INSTR(v.BAQD_SO,'0'),1
                                                                ,SUBSTR(regexp_replace(v.BAQD_SO,'0','',1,1),1,instr(regexp_replace(v.BAQD_SO,'0','',1,1),'/')-1)
                                                                ,SUBSTR(v.BAQD_SO,1,instr(v.BAQD_SO,'/')-1) )
                                                    ))
                                           = 
                                            lower(DECODE(INSTR(vSoBA,'/'),0
                                                    ,decode(INSTR(vSoBA,'0'),1
                                                                ,regexp_replace(vSoBA,'0','',1,1)
                                                                ,vSoBA)
                                                    ,decode(INSTR(vSoBA,'0'),1
                                                                ,SUBSTR(regexp_replace(vSoBA,'0','',1,1),1,instr(regexp_replace(vSoBA,'0','',1,1),'/')-1)
                                                                ,SUBSTR(vSoBA,1,instr(vSoBA,'/')-1) )
                                                    ))
                                            AND v.BAQD_NGAYBA = vNgayBA AND v.BAQD_TOAANID = vToaXX) 
                                    OR (lower(DECODE(INSTR(v.BAQD_SO_PT,'/'),0
                                                    ,decode(INSTR(v.BAQD_SO_PT,'0'),1
                                                                ,regexp_replace(v.BAQD_SO_PT,'0','',1,1)
                                                                ,v.BAQD_SO_PT )
                                                    ,decode(INSTR(v.BAQD_SO_PT,'0'),1
                                                                ,SUBSTR(regexp_replace(v.BAQD_SO_PT,'0','',1,1),1,instr(regexp_replace(v.BAQD_SO_PT,'0','',1,1),'/')-1)
                                                                ,SUBSTR(v.BAQD_SO_PT,1,instr(v.BAQD_SO_PT,'/')-1) )
                                                    ))
                                           = 
                                            lower(DECODE(INSTR(vSoBAPT,'/'),0
                                                    ,decode(INSTR(vSoBAPT,'0'),1
                                                                ,regexp_replace(vSoBAPT,'0','',1,1)
                                                                ,vSoBAPT)
                                                    ,decode(INSTR(vSoBAPT,'0'),1
                                                                ,SUBSTR(regexp_replace(vSoBAPT,'0','',1,1),1,instr(regexp_replace(vSoBAPT,'0','',1,1),'/')-1)
                                                                ,SUBSTR(vSoBAPT,1,instr(vSoBAPT,'/')-1) )
                                                    ))
                                            AND v.BAQD_NGAYBA_PT = vNgayBAPT AND v.BAQD_TOAANID_PT = vToaXXPT) 
                                    OR (lower(DECODE(INSTR(v.BAQD_SO_ST,'/'),0
                                                    ,decode(INSTR(v.BAQD_SO_ST,'0'),1
                                                                ,regexp_replace(v.BAQD_SO_ST,'0','',1,1)
                                                                ,v.BAQD_SO_ST )
                                                    ,decode(INSTR(v.BAQD_SO_ST,'0'),1
                                                                ,SUBSTR(regexp_replace(v.BAQD_SO_ST,'0','',1,1),1,instr(regexp_replace(v.BAQD_SO_ST,'0','',1,1),'/')-1)
                                                                ,SUBSTR(v.BAQD_SO_ST,1,instr(v.BAQD_SO_ST,'/')-1) )
                                                    ))
                                           = 
                                            lower(DECODE(INSTR(vSoBAST,'/'),0
                                                    ,decode(INSTR(vSoBAST,'0'),1
                                                                ,regexp_replace(vSoBAST,'0','',1,1)
                                                                ,vSoBAST)
                                                    ,decode(INSTR(vSoBAST,'0'),1
                                                                ,SUBSTR(regexp_replace(vSoBAST,'0','',1,1),1,instr(regexp_replace(vSoBAST,'0','',1,1),'/')-1)
                                                                ,SUBSTR(vSoBAST,1,instr(vSoBAST,'/')-1) )
                                                    ))
                                            AND v.BAQD_NGAYBA_ST = vNgayBAST AND v.BAQD_TOAANID_ST = vToaXXST)) ;
                                            
                                    
         END IF;
    ----------------
  RETURN vNum_TLM; --Số TLM trung
END CHECK_TLM_TRUNG;

FUNCTION CHECK_ANTHOIHIEU
( 
    vLoaiAn in number,
    vNgayXuPT in date,
    vNgayXuST in date,
    vIsThuLyLai in number,
    vNgaythuly in date
)
RETURN NUMBER AS  
  DAY_AVG NUMBER;VNGAYXETXU DATE;TEMP_DATE DATE;
BEGIN
  -- luu y: can bao truoc 3 thang nen tinh nhu sau:' (sysdate-vNgayXuPT-365-90)
  /** An hanh chinh :
    1) NGay xu truoc < 1/7/2016 
    --> an thoi hieu tinh tu ngay xet xu den 1/7/2019  là het thoi hieu 
    2) Xu sau ngay >= 1/7/2016
    --> an thoi hieu tinh 3 nam tu ngay xet xu
    * an lao dong + hngd :
    - Tinh từ ngày xét xử + 3 nam : het han thoi hieu ( thụ lý GDTTT lần 1)
    Trong 3 nam ma thu ly lần 2 tro di --> tinh an thoi hieu  = ngay xet xu + 5 năm
    hoặc thụ lý lần 1 sau 3 năm thì thời hiệu là 5 năm*/
    if (VNGAYXUPT is not null and to_char(VNGAYXUPT,'dd/MM/yyyy') !='01/01/0001' )then
        VNGAYXETXU := TRUNC(VNGAYXUPT);
    else
        VNGAYXETXU := TRUNC(vNgayXuST);
    end if;
    TEMP_DATE := TO_DATE('2016/07/01','YYYY-MM-DD') ;
    -------------------
       IF(VLOAIAN = 1) THEN
         DAY_AVG:=365-(TRUNC(SYSDATE)-VNGAYXETXU);
       ELSIF(VLOAIAN = 6) THEN
              IF (VNGAYXETXU <TEMP_DATE) THEN
                 DAY_AVG:=-1;--giá trị mặc định là hết hạn lấy 1 giá trị bất kỳ là -1 để cho ngày day_avg trả về <0
              ELSE
               IF NVL(VISTHULYLAI,0)>0 THEN
                 DAY_AVG:=5*365-(TRUNC(SYSDATE)-VNGAYXETXU);
               ELSE
                 DAY_AVG:=3*365-(TRUNC(SYSDATE)-VNGAYXETXU);
                END IF;
            END IF;
        ELSE
           -- TH1: Thoi hieu = 3 nam khi chua thu ly lai lan nao
           -- TH2: Thoi hieu = 5 nam khi da tung thu ly lai
           IF (vNgaythuly is not null and (((TRUNC(VNGAYXETXU) + 3*365)- TRUNC(vNgaythuly))< 0)) then
                DAY_AVG:=5*365-(TRUNC(SYSDATE)-VNGAYXETXU);
           ELSE
                DAY_AVG:=3*365-(TRUNC(SYSDATE)-VNGAYXETXU);
            END IF;
      END IF;
    ----------------
  RETURN day_avg; --hàm trả về số ngày
END CHECK_ANTHOIHIEU;

FUNCTION CHECK_ANTHOIHIEU_BY_YEAR
( 
  vLoaiAn in number,
  vNgayXu in date,
  vNgaythuly in date,
  vIsThuLyLai in number,
  vLoaithoihieu in number,
  vKeoOan in number
)
RETURN NUMBER AS  
  DAY_AVG NUMBER;VNGAYXETXU DATE;TEMP_DATE DATE;
BEGIN
  -- luu y: can bao truoc 3 thang nen tinh nhu sau:' (sysdate-vNgayXuPT-365-90)
  /** An hanh chinh :
    1) NGay xu truoc < 1/7/2016 
    --> an thoi hieu tinh tu ngay xet xu den 1/7/2019  là het thoi hieu 
    2) Xu sau ngay >= 1/7/2016
    --> an thoi hieu tinh 3 nam tu ngay xet xu
    * an lao dong + hngd :
    - Tinh từ ngày xét xử + 3 nam : het han thoi hieu ( thụ lý GDTTT lần 1)
    Trong 3 nam ma thu ly lần 2 tro di --> tinh an thoi hieu  = ngay xet xu + 5 năm
    hoặc thụ lý lần 1 sau 3 năm thì thời hiệu là 5 năm*/
    VNGAYXETXU := TRUNC(VNGAYXU);
    TEMP_DATE := TO_DATE('2016/07/01','YYYY-MM-DD') ;
    -------------------
       IF(VLOAIAN = 1) THEN
            -- An Hinh sư Keu oan và Xin an giam khong có thoi hiệu
            If(vKeoOan = 0) then
                DAY_AVG:=365-(TRUNC(SYSDATE)-VNGAYXETXU);
            ElSE
                DAY_AVG:=365;
            END IF;
       ELSIF(VLOAIAN = 6) THEN
              IF (VNGAYXETXU <TEMP_DATE) THEN
                 DAY_AVG:=-1;--giá trị mặc định là hết hạn lấy 1 giá trị bất kỳ là -1 để cho ngày day_avg trả về <0
              ELSE
               IF NVL(VISTHULYLAI,0)>0 THEN
                 DAY_AVG:=5*365-(TRUNC(SYSDATE)-VNGAYXETXU);
               ELSE
                 DAY_AVG:=3*365-(TRUNC(SYSDATE)-VNGAYXETXU);
                END IF;
            END IF;
        ELSE
            
           -- TH1: Thoi hieu = 3 nam khi thu ly trong 3 năm đầu
           -- TH2: Thoi hieu = 5 nam khi thu ly sau thời gian 3 năm kể từ ngày bản án có hiệu lực pháp luật
           -- VU 2
             if (vLoaithoihieu = 5) then
                if( vNgaythuly is not null and (((TRUNC(VNGAYXETXU) + 3*365)- TRUNC(vNgaythuly))<0)) then
                    DAY_AVG:=5*365-(TRUNC(SYSDATE)-VNGAYXETXU);
                end if;
             else 
                if(vNgaythuly is not null AND ((TRUNC(VNGAYXETXU) + 3*365)- TRUNC(vNgaythuly)>=0)) then
                    DAY_AVG:=3*365-(TRUNC(SYSDATE)-VNGAYXETXU);
                ELSIF (vNgaythuly is null AND ((TRUNC(VNGAYXETXU) + 3*365)- TRUNC(VNGAYXETXU)>=0)) then
                    DAY_AVG:=3*365-(TRUNC(SYSDATE)-VNGAYXETXU);   
                end if;
             end if;
           
        END IF;
    ----------------
  RETURN day_avg; --hàm trả về số ngày
END CHECK_ANTHOIHIEU_BY_YEAR;

PROCEDURE GDTTTT_QLTOTRINH_ALL
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date,
  curReturn OUT sys_refcursor
)
IS 
         v_table T_TINHTRANG;tt_denngay_ DATE;V_THUTU NUMBER;
BEGIN
         v_table := T_TINHTRANG();
         SELECT DECODE(tt_denngay,NULL,SYSDATE,tt_denngay) INTO tt_denngay_ FROM DUAL;
         ------------------------
 FOR item_vuan IN (
            SELECT ROW_NUMBER() OVER (ORDER BY v.ID DESC) Row_, COUNT(*) OVER () TotalRecord,MM.LOAIAN_TEN,V.* from GDTTT_VUAN v 
            INNER JOIN (
                        SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                        SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                        DECODE(TT.COL_LOAIAN,'ISHINHSU','Hình sự','ISDANSU','Dân sự','ISHNGD','Hôn nhân và gia đình','ISKDTM','Kinh doanh, thương mại','ISLAODONG','Lao động','ISHANHCHINH','Hành chính')LOAIAN_TEN
                        FROM (
                        SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD, PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID)
                        UNPIVOT --chuyển từ cột thành dòng
                        (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                        )TT WHERE CHECK_LOAIAN=1  ORDER BY TO_NUMBER(LOAIAN_ID)
                    )LA 
                    WHERE LA.LOAIAN_ID IS NOT NULL  GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN
                  )MM ON MM.LOAIAN_ID=V.LOAIAN
                    where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID AND vPhongBanID!=0) OR vPhongBanID =0)
                    AND (v.LOAIAN=vLoaiAn OR (vLoaiAn IS NULL OR vLoaiAn=0)) 
                    and (v.GQD_LOAIKETQUA is null OR (v.GQD_LOAIKETQUA IS NOT NULL AND v.GQD_NGAYPHATHANHCV>=tt_denngay_) )
                    AND v.NGAYTAO<=tt_denngay_
             )

          LOOP
               FOR item_tt IN (
                        SELECT TT1.* FROM (
                            SELECT TT.*,TR.THUTU FROM GDTTT_TOTRINH TT 
                             INNER JOIN GDTTT_DM_TINHTRANG TR ON TT.TINHTRANGID=TR.ID
                             WHERE TT.NGAYTRINH<=tt_denngay_  AND TT.VUANID=item_vuan.ID
                             ORDER BY  TT.NGAYTRINH DESC,TR.THUTU DESC
                         )TT1 WHERE ROWNUM=1
                 )
             LOOP
             IF(item_tt.CAPTRINHTIEP IS NOT NULL AND item_tt.CAPTRINHTIEP !=0 ) THEN --AND item_tt.TINHTRANGID >=6 
                    SELECT TR.ID INTO V_THUTU FROM GDTTT_DM_TINHTRANG TR WHERE TR.ID=item_tt.CAPTRINHTIEP;
                    v_table.extend;
                    v_table(v_table.count) := R_TINHTRANG(
                    item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                    item_tt.VUANID,item_tt.TRINHTIEP_LANHDAO_ID,item_tt.CAPTRINHTIEP,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,1,V_THUTU --1 ton tai cap trinh tiep sử dụng lại giá trị LOAI_THANG thành Trạng thái của cấp trình
                    );
              ELSE
                  IF(item_tt.LOAIYKIEN=10)THEN --Nghiên cứu lại, xác minh, bổ sung
                        v_table.extend;
                        v_table(v_table.count) := R_TINHTRANG(
                        item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                        item_tt.VUANID,item_tt.LANHDAOID,10,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,0,item_tt.THUTU
                    );
                   ELSE
                        v_table.extend;
                        v_table(v_table.count) := R_TINHTRANG(
                        item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                        item_tt.VUANID,item_tt.LANHDAOID,item_tt.TINHTRANGID,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,0,item_tt.THUTU
                        );
                 END IF;    
             END IF;
            END LOOP;
    END LOOP;
       OPEN curReturn FOR
         SELECT * FROM  table(V_TABLE) PA;
--       SELECT PA.VUANID FROM  table(V_TABLE) PA ORDER BY PA.VUANID;
--       SELECT * FROM  table(V_TABLE) PA where PA.VUANID=3825;-- pa.TINHTRANGID=8 and 
END GDTTTT_QLTOTRINH_ALL;
PROCEDURE GDTTTT_QLTOTRINH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date,
  curReturn OUT sys_refcursor
)
IS 
         v_table T_LANH_DAO;
BEGIN
         v_table := T_LANH_DAO(); 
         ------------------------
 FOR i IN 0..1 --0 là tất cả 1 là trong tháng cuối cùng          
  LOOP
     IF(i=0) THEN
         FOR item_vuan IN (
            SELECT ROW_NUMBER() OVER (ORDER BY v.ID DESC) Row_, COUNT(*) OVER () TotalRecord,MM.LOAIAN_TEN,V.* from GDTTT_VUAN v 
            INNER JOIN (
                        SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                        SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                        DECODE(TT.COL_LOAIAN,'ISHINHSU','Hình sự','ISDANSU','Dân sự','ISHNGD','Hôn nhân và gia đình','ISKDTM','Kinh doanh, thương mại','ISLAODONG','Lao động','ISHANHCHINH','Hành chính')LOAIAN_TEN
                        FROM (
                        SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD, PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID AND PB.ID=vPhongBanID)
                        UNPIVOT --chuyển từ cột thành dòng
                        (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                        )TT WHERE CHECK_LOAIAN=1  ORDER BY TO_NUMBER(LOAIAN_ID)
                    )LA 
                    WHERE LA.LOAIAN_ID IS NOT NULL  GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN
                  )MM ON MM.LOAIAN_ID=V.LOAIAN
                  --anhvh add 22/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới  
                   LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID

                    where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
                    AND ((v.LOAIAN=vLoaiAn AND vLoaiAn !=NULL) OR vLoaiAn IS NULL )
                    ------
                    AND V.ISVIENTRUONGKN is null
                    AND (v.GQD_LOAIKETQUA is null OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=tt_denngay) )
                    AND v.NGAYTAO<=tt_denngay 
             )
         LOOP
               FOR item_tt IN (
                        SELECT TT1.* FROM (
                            SELECT TT.* FROM GDTTT_TOTRINH TT 
                             INNER JOIN GDTTT_DM_TINHTRANG TR ON TT.TINHTRANGID=TR.ID
                             WHERE TT.NGAYTRINH<=tt_denngay  AND TT.VUANID=item_vuan.ID
                             --AND TT.TINHTRANGID NOT IN(4,5)--bỏ 2 trường hợp trình vụ trưởng và phó vụ trưởng
                             ORDER BY TT.NGAYTRINH DESC,TR.THUTU DESC
                         )TT1 WHERE ROWNUM=1 
                 )
             LOOP
             IF(item_tt.CAPTRINHTIEP IS NOT NULL AND item_tt.CAPTRINHTIEP !=0 AND item_tt.TINHTRANGID >=6 ) THEN
                    v_table.extend;
                    v_table(v_table.count) := R_LANH_DAO(
                    item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                    item_tt.VUANID,item_tt.TRINHTIEP_LANHDAO_ID,item_tt.CAPTRINHTIEP,0
                    );
              ELSE
                       IF(item_tt.LOAIYKIEN=10)THEN --Nghiên cứu lại, xác minh, bổ sung
                            v_table.extend;
                            v_table(v_table.count) := R_LANH_DAO(
                            item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                            item_tt.VUANID,item_tt.LANHDAOID,10,0
                            );
                       ELSE
                            v_table.extend;
                            v_table(v_table.count) := R_LANH_DAO(
                            item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                            item_tt.VUANID,item_tt.LANHDAOID,item_tt.TINHTRANGID,0
                            );
                      END IF;
             END IF;
            END LOOP;
    END LOOP;
       -- Trình thẩm phán lần 1
     ELSIF(i=1) THEN
         FOR item_vuan IN (
            SELECT ROW_NUMBER() OVER (ORDER BY v.ID DESC) Row_, COUNT(*) OVER () TotalRecord,MM.LOAIAN_TEN,V.* from GDTTT_VUAN v 
            INNER JOIN (
                        SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                        SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                        DECODE(TT.COL_LOAIAN,'ISHINHSU','Hình sự','ISDANSU','Dân sự','ISHNGD','Hôn nhân và gia đình','ISKDTM','Kinh doanh, thương mại','ISLAODONG','Lao động','ISHANHCHINH','Hành chính')LOAIAN_TEN
                        FROM (
                        SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD, PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID AND PB.ID=vPhongBanID)
                        UNPIVOT --chuyển từ cột thành dòng
                        (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                        )TT WHERE CHECK_LOAIAN=1  ORDER BY TO_NUMBER(LOAIAN_ID)
                    )LA 
                    WHERE LA.LOAIAN_ID IS NOT NULL  GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN
                  )MM ON MM.LOAIAN_ID=V.LOAIAN
                   --anhvh add 22/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới  
--                  LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
--                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
--                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
--                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID

                    where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
                    AND ((v.LOAIAN=vLoaiAn AND vLoaiAn !=NULL) OR vLoaiAn IS NULL )
                    ------
                    AND V.ISVIENTRUONGKN is null
--                    AND (v.GQD_LOAIKETQUA is null OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=tt_denngay) )
                    AND v.NGAYTAO<=tt_denngay 
                    ------------------------------
--                    where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
--                    AND (v.LOAIAN=vLoaiAn OR vLoaiAn IS NULL) 
--                    AND v.GQD_LOAIKETQUA is null
--                    AND v.NGAYTAO<=tt_denngay
             )
           LOOP
                   FOR item_tt IN (
                             SELECT TS.* FROM (
                                    select TT.*  from
                                                 (SELECT SS.* FROM GDTTT_TOTRINH SS 
                                                  WHERE  SS.VUANID = item_vuan.ID AND SS.TINHTRANGID>=6
                                                  --(SS.TINHTRANGID=6  or SS.CAPTRINHTIEP=6)
                                                  ORDER BY SS.NGAYTRINH ASC
                                                 ) TT
                                     where  ROWNUM=1
                              )TS WHERE 
                                      --  TS.NGAYTRINH  >=TO_DATE('01/'||to_char(tt_denngay, 'MM/yyyy'),'dd/MM/yyyy') AND
                                       TS.NGAYTRINH>=tt_tungay and
                                       TS.NGAYTRINH <= tt_denngay
                            )
                     LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_LANH_DAO(
                        item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                        item_tt.VUANID,item_tt.LANHDAOID,item_tt.TINHTRANGID,1
                        );
                    END LOOP;
         END LOOP;
     END IF;
 END LOOP;
       OPEN curReturn FOR
         SELECT * FROM  table(V_TABLE) PA WHERE PA.TINHTRANGID NOT IN (4,5);-- AND PA.TINHTRANGID =9
END GDTTTT_QLToTrinh;
PROCEDURE GDTTTT_QLTOTRINH_TP
( 
  vThamphanID in number,
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number,
  tt_tungay in date,
  tt_denngay in date,
  curReturn OUT sys_refcursor
)
IS 
         v_table T_TINHTRANG;V_THUTU NUMBER;ma_chucvu varchar2(10); curr_thamphan_id number;
BEGIN
         v_table := T_TINHTRANG(); 
         ------------------------
    select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphanID;
    curr_thamphan_id:=0; 
       if  (ma_chucvu is null)then 
            curr_thamphan_id:= vThamphanID;
        elsif(ma_chucvu='PCA' OR ma_chucvu='CA')then  
         curr_thamphan_id:=0; 
        ELSE
            curr_thamphan_id:= vThamphanID;
        end if;
          --------------------------------
 FOR item_vuan IN (
            SELECT ROW_NUMBER() OVER (ORDER BY v.ID DESC) Row_, COUNT(*) OVER () TotalRecord,MM.LOAIAN_TEN,V.* from GDTTT_VUAN v 
            INNER JOIN (
                        SELECT TT.LOAIAN_ID,TT.LOAIAN_TEN FROM (
                                        SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                        SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                        DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                        FROM (
                                                SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                                PB WHERE PB.Id = vThamphanID
                                             )
                                        UNPIVOT --chuyển từ cột thành dòng
                                        (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                        )TT WHERE CHECK_LOAIAN=1 
                                    )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                                   GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                             UNION ALL
                                        select  LAS.LOAIAN_ID,LAS.LOAIAN_TEN FROM(
                                        select V.LOAIAN LOAIAN_ID,DECODE(V.LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH')LOAIAN_TEN From GDTTT_VUAN v 
                                        where v.THAMPHANID=vThamphanID AND V.LOAIAN IS NOT NULL
                                        group by V.LOAIAN
                                       )LAS 
                           )TT  GROUP BY TT.LOAIAN_ID,TT.LOAIAN_TEN  ORDER BY TT.LOAIAN_ID
                  )MM ON MM.LOAIAN_ID=V.LOAIAN
                  LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                      WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                      WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                      END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID AND vPhongBanID!=0) OR vPhongBanID =0)
                    AND EXISTS (SELECT 'x' FROM GDTTT_TOTRINH DT WHERE DT.VUANID=V.ID AND ((DT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0))
                    AND (v.LOAIAN=vLoaiAn OR (vLoaiAn IS NULL OR vLoaiAn=0) ) 
                    and (v.GQD_LOAIKETQUA is null OR (v.GQD_LOAIKETQUA IS NOT NULL AND VA.GQD_NGACVS>=tt_denngay) )
                    AND v.NGAYTAO<=tt_denngay
             )
       LOOP
               FOR item_tt IN (
                        SELECT TT1.* FROM (
                            SELECT TT.*,TR.THUTU FROM GDTTT_TOTRINH TT 
                             INNER JOIN GDTTT_DM_TINHTRANG TR ON TT.TINHTRANGID=TR.ID
                              WHERE TT.VUANID=item_vuan.ID
                             ORDER BY TT.NGAYTRINH DESC,TR.THUTU  DESC
                         )TT1 WHERE ROWNUM=1
                   )
             LOOP
             --if(item_tt.TINHTRANGID =7 or item_tt.TINHTRANGID =8 or item_tt.TINHTRANGID =9 or item_tt.TINHTRANGID =17  ) then
                 IF(item_tt.CAPTRINHTIEP IS NOT NULL AND item_tt.CAPTRINHTIEP !=0) THEN--AND item_tt.TINHTRANGID >=6 
                         SELECT TR.ID INTO V_THUTU FROM GDTTT_DM_TINHTRANG TR WHERE TR.ID=item_tt.CAPTRINHTIEP;
                        v_table.extend;
                        v_table(v_table.count) := R_TINHTRANG(
                        item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                        item_tt.VUANID,item_tt.TRINHTIEP_LANHDAO_ID,item_tt.CAPTRINHTIEP,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,1,V_THUTU --1 ton tai cap trinh tiep sử dụng lại giá trị LOAI_THANG thành Trạng thái của cấp trình
                        );
                  ELSE
                        IF(item_tt.LOAIYKIEN=10)THEN --Nghiên cứu lại, xác minh, bổ sung
                            v_table.extend;
                            v_table(v_table.count) := R_TINHTRANG(
                            item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                            item_tt.VUANID,item_tt.LANHDAOID,10,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,0,item_tt.THUTU
                            );
                         ELSE
                            v_table.extend;
                            v_table(v_table.count) := R_TINHTRANG(
                            item_vuan.LOAIAN,item_vuan.LOAIAN_TEN,
                            item_tt.VUANID,item_tt.LANHDAOID,item_tt.TINHTRANGID,item_tt.NGAYTRA,item_tt.ID,item_tt.NGAYTRINH,0,item_tt.THUTU
                            );
                         END IF;
                 END IF;
            -- end if;
            END LOOP;
 END LOOP;
       OPEN curReturn FOR
      SELECT PA.* FROM  table(V_TABLE) PA ;
--     SELECT count(*) FROM  table(V_TABLE) PA  WHERE PA.TINHTRANGID IN(7,8,9,17);
-- SELECT pa.* FROM TABLE(V_TABLE) PA 
--                INNER JOIN GDTTT_VUAN V ON V.ID=PA.VUANID
--                WHERE instr(',7,8,9,17,',','||PA.TINHTRANGID||',')>0 
--                and v.NGAYTAO<sysdate
--                AND NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16);
END GDTTTT_QLTOTRINH_TP;
END PKG_GDTTT_BAOCAO_APP;

/
