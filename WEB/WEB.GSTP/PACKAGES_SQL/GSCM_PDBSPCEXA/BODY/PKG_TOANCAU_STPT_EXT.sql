--------------------------------------------------------
--  DDL for Package Body PKG_TOANCAU_STPT_EXT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_TOANCAU_STPT_EXT" AS
PROCEDURE   AHS_NTGTT_GETBYVUANID
(
    vu_an_id in number,
    GiaiDoan in varchar2,
	  PageIndex	in	int,
	  PageSize	in	int,
	  curReturn  OUT sys_refcursor
)

AS
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
    --CheckDelete number;

BEGIN	
    ----------------------------------------------
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

   select count (a.ID) into TotalItem 
   from AHS_NguoiThamGiaToTung a 
                  inner join AHS_NguoiThamGiaToTung_TuCach b on a.ID = b.NguoiID
                  inner join DM_DataItem c on b.TuCachID = c.ID
                where a.VuAnId =vu_an_id  and ((case when GiaiDoan='HOSO' and a.ISHOSO=1 then 1
                                                when GiaiDoan='SOTHAM' and a.ISSOTHAM=1 then 1
                                                when GiaiDoan='PHUCTHAM' and a.ISPHUCTHAM=1 then 1 end)=1);
		---------------------------------------------------
    OPEN curReturn FOR 
        select c.*,c.id arrID, TotalItem as CountAll 
        from (	select ROW_NUMBER() OVER (ORDER BY a.LoaiDT, c.Ten asc, a.HoTen asc) stt
                    ,a.ID, a.VuAnId, a.HoTen , a.NamSinh, a.NgayThamGia
                    , a.NgayKetThuc, a.DiaChiChiTiet Diachi
                    , b.TuCachID, c.Ten TenTuCachTGTT
                    , DECODE(a.LoaiDT, 0,u'C\00e1 nh\00e2n', 1,u'C\01a1 quan', 2,u'T\1ed5 ch\1ee9c') DoiTuong 
                    ,DD.BICAO_DATA
                from AHS_NguoiThamGiaToTung a 
                  inner join AHS_NguoiThamGiaToTung_TuCach b on a.ID = b.NguoiID
                  inner join DM_DataItem c on b.TuCachID = c.ID
                  LEFT JOIN (
                              SELECT NGUOI_TGTT_ID,LISTAGG(TEN_TCTG, ', ') WITHIN GROUP (ORDER BY TEN_TCTG) BICAO_DATA
                              FROM  (
                                     SELECT DD.NGUOI_TGTT_ID,DECODE(DD.ID_EXT,'BC-',DD.TEN_TCTG,TG.HOTEN||DECODE(DD.ID_EXT,'BH-',' - Bị Hại','QLNVLQ-','- QLNVLQ','BDDS-','- Bị đơn dân sự','NDDS-',' - Nguyên đơn dân sự'))TEN_TCTG FROM AHS_NGUOI_DAIDIEN DD
                                     LEFT JOIN AHS_NGUOITHAMGIATOTUNG TG ON TG.ID=DD.BICAO_ID
                                   )
                              GROUP BY NGUOI_TGTT_ID
                  )DD ON DD.NGUOI_TGTT_ID=A.ID
                where a.VuAnId = vu_an_id  and ((case when GiaiDoan='HOSO' and a.ISHOSO=1 then 1
                                                when GiaiDoan='SOTHAM' and a.ISSOTHAM=1 then 1
                                                when GiaiDoan='PHUCTHAM' and a.ISPHUCTHAM=1 then 1 end)=1)
              ) c where c.STT>=MinIndex and c.STT<=MaxIndex;
END AHS_NTGTT_GetByVuAnID;
 PROCEDURE     AHS_ST_BICAO_GETALL
(
  vu_an_id IN NUMBER,CurReturn OUT sys_refcursor
) AS 

BEGIN
      open CurReturn for
        SELECT 'BC'||'-'||BC.id BICANID,BC.HOTEN||' - bị cáo' TENBICAN
        FROM (SELECT ID, HOTEN,VUANID FROM AHS_BICANBICAO WHERE VUANID = VU_AN_ID) BC
                left JOIN (SELECT LISTAGG(HOTEN,', ') WITHIN GROUP (ORDER BY ID), BICANID FROM  AHS_BICAN_NHANTHAN GROUP BY BICANID) PTBC ON PTBC.BICANID = BC.ID--left JOIN AHS_BICAN_NHANTHAN PTBC ON PTBC.BICANID = BC.ID
        WHERE BC.VUANID = VU_AN_ID
        /*SELECT 'BC'||'-'||PTBC.BICANID BICANID,BC.HOTEN||' - bị cáo' TENBICAN
        FROM AHS_BICAN_NHANTHAN PTBC
        INNER JOIN (SELECT ID, HOTEN FROM AHS_BICANBICAO WHERE VUANID = VU_AN_ID) BC ON PTBC.BICANID = BC.ID
        WHERE PTBC.VUANID = VU_AN_ID*/
      UNION ALL 
       SELECT DECODE(N.ID,122,'BH'||'-'||NT.ID,124,'BDDS'||'-'||NT.ID,125,'NDDS'||'-'||NT.ID,126,'QLNVLQ'||'-'||NT.ID)ID,
       NT.HOTEN||' - '||N.TEN TENBIHAI FROM  AHS_NGUOITHAMGIATOTUNG NT
        LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON tc.nguoiid=NT.ID
        LEFT JOIN (  SELECT i.ID,i.TEN FROM DM_DATAITEM i
            inner join DM_DATAGROUP g on g.ID=i.GROUPID
            Where g.MA='TUCACHTGTTHS' and i.HIEULUC=1
            )N ON N.ID=tc.tucachid
        WHERE nt.vuanid=VU_AN_ID AND N.ID IN(122,124,125,126);--122,124,125,126;Bị hại,Bị đơn dân sự,Nguyên đơn dân sự,Người có quyền lợi nghĩa vụ liên quan
end AHS_ST_BiCao_GetAll;

PROCEDURE NGUOI_DD_INS
(
V_NGUOI_TGTT_ID	in	NUMBER,
P_BICAO_ID	in	VARCHAR2,
V_CHECK OUT VARCHAR2
)
AS    
       v_count NUMBER;v_count_check NUMBER; V_VALUES VARCHAR2(255):=NULL;V_ID VARCHAR2(255);V_HOTEN VARCHAR2(255);V_TEN_TCTG VARCHAR2(255);
       CURSOR v_cursor IS  
       select REGEXP_SUBSTR (P_BICAO_ID, '[^,]+', 1, level) as BC_ID from dual        
       connect by level <= length(regexp_replace(P_BICAO_ID,'[^,]*'))+1; 
BEGIN 
     SELECT COUNT(*)INTO v_count FROM (
     select REGEXP_SUBSTR (P_BICAO_ID, '[^,]+', 1, level) as BC_ID from dual        
     connect by level <= length(regexp_replace(P_BICAO_ID,'[^,]*'))+1); 

     SELECT REGEXP_COUNT(P_BICAO_ID,'BC-')INTO v_count_check  FROM DUAL;    
     IF(v_count=v_count_check)THEN 
        V_VALUES:='BC-';
     ELSE  V_VALUES:=NULL;
     END IF;
     -----
     IF(V_VALUES IS NULL)THEN
         SELECT REGEXP_COUNT(P_BICAO_ID,'BH-')INTO v_count_check  FROM DUAL;    
         IF(v_count=v_count_check)THEN 
            V_VALUES:='BH-';
         ELSE V_VALUES:=NULL;
         END IF;
      END IF;   
      -----
       IF(V_VALUES IS NULL)THEN
         SELECT REGEXP_COUNT(P_BICAO_ID,'BDDS-')INTO v_count_check  FROM DUAL;    
         IF(v_count=v_count_check)THEN 
            V_VALUES:='BDDS-';
         ELSE V_VALUES:=NULL;
         END IF;
      END IF;   
      -----
       IF(V_VALUES IS NULL)THEN
         SELECT REGEXP_COUNT(P_BICAO_ID,'NDDS-')INTO v_count_check  FROM DUAL;    
         IF(v_count=v_count_check)THEN 
            V_VALUES:='NDDS-';
         ELSE V_VALUES:=NULL;
         END IF;
      END IF;   
      -----
       IF(V_VALUES IS NULL)THEN
         SELECT REGEXP_COUNT(P_BICAO_ID,'QLNVLQ-')INTO v_count_check  FROM DUAL;    
         IF(v_count=v_count_check)THEN 
           V_VALUES:='QLNVLQ-';
            ELSE  V_VALUES:=NULL;
         END IF;
      END IF;   
      -----
     IF(V_VALUES IS NOT NULL) THEN
        DELETE AHS_NGUOI_DAIDIEN WHERE nguoi_tgtt_id=V_NGUOI_TGTT_ID;COMMIT;
        FOR rec IN v_cursor
          LOOP 
               V_ID:=REPLACE(rec.BC_ID,V_VALUES,'');
               IF(V_VALUES='BC-')THEN
                    SELECT BC.HOTEN||' - bị cáo',BC.HOTEN INTO V_TEN_TCTG,V_HOTEN FROM AHS_BICANBICAO BC
                    WHERE BC.ID=V_ID; 
               END IF;
              IF(V_VALUES='BH-')THEN
                    SELECT BC.HOTEN||' - bị hại',BC.HOTEN INTO V_TEN_TCTG,V_HOTEN FROM AHS_NGUOITHAMGIATOTUNG BC
                    WHERE BC.ID=V_ID; 
               END IF;
                IF(V_VALUES='BDDS-')THEN
                    SELECT BC.HOTEN||' - Bị đơn dân sự',BC.HOTEN INTO V_TEN_TCTG,V_HOTEN FROM AHS_NGUOITHAMGIATOTUNG BC
                    WHERE BC.ID=V_ID; 
               END IF;
                IF(V_VALUES='NDDS-')THEN
                    SELECT BC.HOTEN||' - Nguyên đơn dân sự',BC.HOTEN INTO V_TEN_TCTG,V_HOTEN FROM AHS_NGUOITHAMGIATOTUNG BC
                    WHERE BC.ID=V_ID; 
               END IF;
                   IF(V_VALUES='QLNVLQ-')THEN
                    SELECT BC.HOTEN||' - QLNVLQ',BC.HOTEN INTO V_TEN_TCTG,V_HOTEN FROM AHS_NGUOITHAMGIATOTUNG BC
                    WHERE BC.ID=V_ID; 
               END IF;
             if(V_ID!='0')then
              INSERT INTO AHS_NGUOI_DAIDIEN
                 (id,NGUOI_TGTT_ID,BICAO_ID,ID_EXT,TEN_TCTG,HOTEN)
                VALUES (AHS_NGUOI_DAIDIEN_SEQ.NEXTVAL,V_NGUOI_TGTT_ID,V_ID,V_VALUES,V_TEN_TCTG,V_HOTEN); 
               end if;
            END LOOP;
     END IF;  
     V_CHECK:=V_VALUES;
END NGUOI_DD_INS;
PROCEDURE GET_BCBC_NGUOITGTT
(
  V_NGUOITGTT_ID IN NUMBER,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
 OPEN CURRETURN FOR
      SELECT LISTAGG(ID_EXT||BICAO_ID, ',') WITHIN GROUP (ORDER BY ID_EXT||BICAO_ID) BICAO_DATA
      FROM AHS_NGUOI_DAIDIEN WHERE NGUOI_TGTT_ID=V_NGUOITGTT_ID
      GROUP BY NGUOI_TGTT_ID;
END GET_BCBC_NGUOITGTT;

PROCEDURE SO_DK
(  
V_DK OUT NUMBER,
  VTOAANID IN VARCHAR2,
  V_TUCACHID IN VARCHAR2

)
AS   
BEGIN       
    V_DK:=0;
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK FROM AHS_NGUOITHAMGIATOTUNG D
    LEFT JOIN AHS_VUAN GD ON GD.ID=D.VUANID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
    --AND EXISTS (SELECT 'X' FROM AHS_NGUOITHAMGIATOTUNG_TUCACH TCC WHERE TCC.NGUOIID=D.ID AND TCC.TUCACHID=V_TUCACHID)
    AND gd.toaanid=VTOAANID;
    V_DK := V_DK+1;   
END; 
-----------------------------
PROCEDURE SO_DK_HC
(
V_DK_HC OUT NUMBER,
  VTOAANID IN VARCHAR2, 
    V_CXX IN VARCHAR2
)
AS   
BEGIN       
    V_DK_HC:=0;
      IF(V_CXX = 'PT') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_HC FROM AHC_PHUCTHAM_THAMGIATOTUNG D
    LEFT JOIN AHC_DON_GIAIDOAN GD ON GD.DONID=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
     AND gd.toaphucthamid=VTOAANID;
       END IF;
             IF(V_CXX = 'ST') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_HC FROM AHC_DON_THAMGIATOTUNG D
    LEFT JOIN AHC_DON GD ON GD.id=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
       END IF;
        V_DK_HC := V_DK_HC+1;

END; 
------------------------------
PROCEDURE SO_DK_PS
(
V_DK_PS OUT NUMBER,
  VTOAANID IN VARCHAR2, 
    V_CXX IN VARCHAR2
)
AS   
BEGIN       
    V_DK_PS:=0;
      IF(V_CXX = 'PT') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_PS FROM APS_PHUCTHAM_THAMGIATOTUNG D
    LEFT JOIN APS_DON_XULY GD ON GD.DONID=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
       END IF;
             IF(V_CXX = 'ST') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_PS FROM APS_DON_THAMGIATOTUNG D
    LEFT JOIN APS_DON GD ON GD.id=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
       END IF;
        V_DK_PS := V_DK_PS+1;

END; 
------------------------------
------------------------------

PROCEDURE SO_DK_ALD
(
  V_DK_ALD OUT NUMBER,
  VTOAANID IN VARCHAR2,
  V_CXX IN VARCHAR2
)
AS   
BEGIN       
    V_DK_ALD:=0;
   IF(v_CXX = 'PT') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_ALD FROM ALD_PHUCTHAM_THAMGIATOTUNG D
    LEFT JOIN ALD_DON_GIAIDOAN GD ON GD.DONID=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
     AND gd.toaphucthamid=VTOAANID;
       END IF;
   IF(V_CXX = 'ST') THEN 
         SELECT NVL(Max(D.SO_DK),0) INTO V_DK_ALD FROM ALD_DON_THAMGIATOTUNG D
    LEFT JOIN ALD_DON GD ON GD.id=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
    END IF;
        V_DK_ALD := V_DK_ALD+1;
END; 


-----------------------------

PROCEDURE SO_DK_DS
(
    V_DK_DS OUT NUMBER,
  VTOAANID IN VARCHAR2,
  V_CXX IN VARCHAR2

)
AS   
BEGIN      
    V_DK_DS:=0;
    IF(V_CXX = 'PT') THEN 
     SELECT NVL(Max(D.SO_DK),0) INTO V_DK_DS FROM ADS_PHUCTHAM_THAMGIATOTUNG D
    LEFT JOIN ADS_DON_GIAIDOAN GD ON GD.DONID=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaphucthamid=VTOAANID;
    END IF;
    IF(V_CXX = 'ST') THEN 
         SELECT NVL(Max(D.SO_DK),0) INTO V_DK_DS FROM ADS_DON_THAMGIATOTUNG D
    LEFT JOIN ADS_DON GD ON GD.id=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
    END IF;
    V_DK_DS := V_DK_DS+1;   

END; 

---------------------------------
PROCEDURE SO_DK_HN
(
  V_DK_HN OUT NUMBER,
  VTOAANID IN VARCHAR2,
 V_CXX IN VARCHAR2
)
AS   

BEGIN       
    V_DK_HN:=0;
     IF(V_CXX = 'PT') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_HN FROM AHN_PHUCTHAM_THAMGIATOTUNG D
    LEFT JOIN AHN_DON_GIAIDOAN GD ON GD.DONID=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaphucthamid=VTOAANID;
        END IF;
             IF(V_CXX = 'ST') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_HN FROM AHN_DON_THAMGIATOTUNG D
    LEFT JOIN AHN_DON GD ON GD.id=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
    END IF;
        V_DK_HN := V_DK_HN+1;
END; 
-----------------------------

PROCEDURE SO_DK_AKT
(
 V_DK_AKT OUT NUMBER,
  VTOAANID IN VARCHAR2,
   V_CXX IN VARCHAR2
)
AS   

BEGIN       
    V_DK_AKT:=0;
        IF(V_CXX = 'PT') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_AKT FROM AKT_PHUCTHAM_THAMGIATOTUNG D
    LEFT JOIN AKT_DON_GIAIDOAN GD ON GD.DONID=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaphucthamid=VTOAANID;
        END IF;
    IF(V_CXX = 'ST') THEN 
    SELECT NVL(Max(D.SO_DK),0) INTO V_DK_AKT FROM AKT_DON_THAMGIATOTUNG D
    LEFT JOIN AKT_DON GD ON GD.id=D.DONID
    WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
     AND gd.toaanid=VTOAANID;
        END IF;
        V_DK_AKT := V_DK_AKT+1;

END; 

---------------------------------
FUNCTION  GXN_BICAO
(
 vArrSelectID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; VTOAAN_TEN VARCHAR2(512);VCAPXX_TEN VARCHAR2(512);VSODK VARCHAR2(100);VCOUNT_LS NUMBER;V_TT_LS NUMBER;
    VTOAAN_TEN_FULL VARCHAR2(512);VBICAO_DATA VARCHAR2(512);VKSND_NAME VARCHAR2(512);VTENDVHC VARCHAR2(512);
    vThamPhan VARCHAR2(521);vindex number;
BEGIN	
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT COUNT(*) INTO VCOUNT_LS FROM AHS_NGUOITHAMGIATOTUNG WHERE ID IN(select to_number(regexp_substr(vArrSelectID,'[^,]+', 1, level)) 
                 from dual connect by regexp_substr(vArrSelectID, '[^,]+', 1, level) is not null ); 
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                 select tg.*,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys from AHS_NGUOITHAMGIATOTUNG tg 
                 LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH tt on tt.NGUOIID=tg.id
                 LEFT JOIN (
                            SELECT i.ID,i.MA,i.TEN
                            FROM DM_DATAITEM i
                            inner join DM_DATAGROUP g on g.ID=i.GROUPID
                            Where g.MA='TUCACHTGTTHS' and i.HIEULUC=1 
                          )TC ON TC.ID=TT.TUCACHID
                 LEFT JOIN AHS_SOTHAM_THULY TL ON TL.VUANID=TG.VUANID  
                 where tg.ID IN(select to_number(regexp_substr(vArrSelectID,'[^,]+', 1, level)) 
                 from dual connect by regexp_substr(vArrSelectID, '[^,]+', 1, level) is not null )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_DATA
         FROM (SELECT DD.NGUOI_TGTT_ID,DECODE(DD.ID_EXT,'BC-',DD.HOTEN,TG.HOTEN)HOTEN FROM AHS_NGUOI_DAIDIEN DD
                LEFT JOIN AHS_NGUOITHAMGIATOTUNG TG ON TG.ID=DD.BICAO_ID
                ) 
         WHERE NGUOI_TGTT_ID=ITEM.ID
         GROUP BY NGUOI_TGTT_ID;
--            SELECT LISTAGG(BC.HOTEN, ', ') WITHIN GROUP (ORDER BY BC.HOTEN) INTO VBICAO_DATA
--            FROM AHS_PHUCTHAM_BICANBICAO PTBC
--            INNER JOIN (SELECT ID, HOTEN FROM AHS_BICANBICAO WHERE VUANID = ITEM.VUANID) BC ON PTBC.BICANID = BC.ID
--            WHERE PTBC.VUANID = ITEM.VUANID 
--            AND EXISTS(SELECT 'x' FROM AHS_NGUOI_DAIDIEN DD WHERE DD.BICAO_ID=PTBC.BICANID AND DD.NGUOI_TGTT_ID=ITEM.ID)
--            GROUP BY PTBC.VUANID;
        --duongph
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            THÔNG BÁO
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bào chữa tham gia tố tụng</span>
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>Kính gửi: '||item.ONGBA||' '||item.HOTEN||', '||item.TEN||' '||item.TEN_VPLS
            ||' thuộc Đoàn luật sư '|| item.DOAN_LS||
            '<br />
            <span style="color: #ffffff">......</span>Địa chỉ: '||item.DIACHICHITIET||'
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span> Ngày '||to_char(item.ngaythuly,'dd')||' Tháng '||to_char(item.ngaythuly,'MM')||' năm '||to_char(item.ngaythuly,'yyyy')||'
            , '||VTOAAN_TEN_FULL||' đã thụ lý vụ án hình sự sơ thẩm số '||item.sothuly||'/'|| to_char(sysdate,'yyyy') ||'/TLST-HS. 
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>Sau khi xem xét thủ tục đăng ký bào chữa, căn cứ điều 72 và điều 78 của Bộ luật 
             tố tung hình sự, '||VTOAAN_TEN_FULL||' thông báo:
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>1. '||item.ONGBA||' '||item.HOTEN||' là người bào chữa cho bị cáo '||VBICAO_DATA||' trong
            vụ án hình sự sơ thẩm thụ lý số '||item.sothuly||'/'|| to_char(sysdate,'yyyy') ||'/TLST-HS ngày '||item.ngaythulys||'.
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>2. '||item.ONGBA||' '||item.HOTEN||' thực hiện các quyền và nghĩa vụ của người
            bào chữa theo quy định của pháp luật.
        </p>
              ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Như kính gửi;<br />
                        - '||VKSND_NAME||';<br />
                        - TTG số 1 thuộc CA '||VTENDVHC||';
                        <br />
                        - Bị cáo '||VBICAO_DATA||';
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_BICAO;
FUNCTION  GXN_BIHAI
(
 vArrSelectID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; VTOAAN_TEN VARCHAR2(512);VCAPXX_TEN VARCHAR2(512);VSODK VARCHAR2(100);VCOUNT_LS NUMBER;V_TT_LS NUMBER;VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);VBICAO_DATA VARCHAR2(512);VKSND_NAME VARCHAR2(512);VTENDVHC VARCHAR2(512);V_TENTOIDANH VARCHAR2(512);BICAO_VALUE VARCHAR2(512);V_HOTEN VARCHAR2(255);
    vThamPhan VARCHAR2(521);vindex number;
BEGIN	
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT COUNT(*) INTO VCOUNT_LS FROM AHS_NGUOITHAMGIATOTUNG WHERE ID IN(select to_number(regexp_substr(vArrSelectID,'[^,]+', 1, level)) 
                 from dual connect by regexp_substr(vArrSelectID, '[^,]+', 1, level) is not null ); 
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                 select tg.*,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                 ,A.TENVUAN
                 from AHS_NGUOITHAMGIATOTUNG tg 
                 LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH tt on tt.NGUOIID=tg.id
                 LEFT JOIN (
                            SELECT i.ID,i.MA,i.TEN
                            FROM DM_DATAITEM i
                            inner join DM_DATAGROUP g on g.ID=i.GROUPID
                            Where g.MA='TUCACHTGTTHS' and i.HIEULUC=1 
                          )TC ON TC.ID=TT.TUCACHID
                 LEFT JOIN AHS_SOTHAM_THULY TL ON TL.VUANID=TG.VUANID  
                 LEFT JOIN AHS_VUAN A ON A.ID=TG.VUANID  
                 where tg.ID IN(select to_number(regexp_substr(vArrSelectID,'[^,]+', 1, level)) 
                 from dual connect by regexp_substr(vArrSelectID, '[^,]+', 1, level) is not null )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_DATA
         FROM (SELECT DD.NGUOI_TGTT_ID,DECODE(DD.ID_EXT,'BC-',DD.TEN_TCTG,decode(GIOITINH,0,' bà ',' ông ') ||TG.HOTEN)HOTEN FROM AHS_NGUOI_DAIDIEN DD
                LEFT JOIN AHS_NGUOITHAMGIATOTUNG TG ON TG.ID=DD.BICAO_ID
                ) 
         WHERE NGUOI_TGTT_ID=ITEM.ID
         GROUP BY NGUOI_TGTT_ID;
         --------------------------
          SELECT DD.ID_EXT INTO BICAO_VALUE  FROM AHS_NGUOI_DAIDIEN DD
         WHERE NGUOI_TGTT_ID=ITEM.ID;
         IF(BICAO_VALUE='BH-')THEN BICAO_VALUE := 'bị hại'; 
               END IF;
                IF(BICAO_VALUE='BDDS-')THEN BICAO_VALUE := 'bị đơn dân sự'; 

               END IF;
                IF(BICAO_VALUE='NDDS-')THEN BICAO_VALUE := 'nguyên đơn dân sự'; 

               END IF;
                   IF(BICAO_VALUE='QLNVLQ-')THEN BICAO_VALUE := 'QLNVLQ'; 
               END IF; 

        ----------------
         SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
         FROM (SELECT DD.NGUOI_TGTT_ID,DECODE(DD.ID_EXT,'BC-',DD.TEN_TCTG,decode(GIOITINH,0,' Bà ',' Ông ') ||TG.HOTEN)HOTEN FROM AHS_NGUOI_DAIDIEN DD
                LEFT JOIN AHS_NGUOITHAMGIATOTUNG TG ON TG.ID=DD.BICAO_ID
                ) 
         WHERE NGUOI_TGTT_ID=ITEM.ID
         GROUP BY NGUOI_TGTT_ID;
        ---------------
        SELECT TD.TENTOIDANH INTO V_TENTOIDANH FROM AHS_SOTHAM_CAOTRANG_DIEULUAT TD
        LEFT JOIN AHS_BICANBICAO A  ON A.ID = TD.BICANID 
        WHERE TD.VUANID =ITEM.VUANID AND TD.ISMAIN=1 AND A.BICANDAUVU=1;
        --duongph
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            THÔNG BÁO
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của <br/> đương sự tham gia tố tụng</span>
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>Kính gửi: '||item.ONGBA||' '||item.HOTEN||', '||item.TEN||' '||item.TEN_VPLS
            ||' thuộc Đoàn luật sư '|| item.DOAN_LS||
            '<br />
            <span style="color: #ffffff">......</span>Địa chỉ: '||item.DIACHICHITIET||'
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span> Ngày '||to_char(item.ngaythuly,'dd')||' Tháng '||to_char(item.ngaythuly,'MM')||' năm '||to_char(item.ngaythuly,'yyyy')||'
            , '||VTOAAN_TEN_FULL||' đã thụ lý vụ án hình sự phúc thẩm số '||item.sothuly||'. 
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>Sau khi xem xét thủ tục đăng ký người bảo vệ quyền và lợi ích hợp pháp của đương sự,
            căn cứ Điều 84 của Bộ luật tố tụng hình sự,
            '||VTOAAN_TEN_FULL||' thông báo:
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;margin-bottom:0pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>1. '||item.ONGBA||' '||item.HOTEN||' là người bảo vệ quyền và lợi ích hợp pháp cho '||VBICAO_DATA||' là '||BICAO_VALUE||'
            trong vụ án '||item.TENVUAN||' phạm tội "'||V_TENTOIDANH ||'"
        </p>
        <p style="font-size: 14pt;text-align: justify;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>2. '||item.ONGBA||' '||item.HOTEN||' thực hiện các quyền và nghĩa vụ của người
            bảo vệ quyền và lợi ích hợp pháp theo quy định của pháp luật.
        </p>
              ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Như kính gửi;<br />
                        - '||VKSND_NAME||';<br />
                        - '||VBICAO_FOOTER||';
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_BIHAI;


--------------------------------------------------------------------------------------------------------------------------------------------------
--duongph
FUNCTION  GXN_DS_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;
    VTOAAN_TEN VARCHAR2(512);
    VCAPXX_TEN VARCHAR2(512);
    VSODK VARCHAR2(100);
    VCOUNT_LS NUMBER;
    V_TT_LS NUMBER;
    VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);
    VDUONGSU_DATA VARCHAR2(512);
    VKSND_NAME VARCHAR2(512);
    VTENDVHC VARCHAR2(512);
    V_TENTOIDANH VARCHAR2(512);
    BICAO_VALUE VARCHAR2(512);
    V_HOTEN VARCHAR2(255);
    vindex number;
    vThamPhan VARCHAR2(255);
    vChucDanhTP varchar(255);
BEGIN

    if(vCXX = 'PT') then 
        SELECT NVL(Max(D.SO_DK),0) into vsodk FROM ADS_PHUCTHAM_THAMGIATOTUNG D
            LEFT JOIN ADS_DON_GIAIDOAN GD ON GD.DONID=D.DONID
            WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
             AND gd.toaphucthamid=VTOAANID;
    ELSIF(vCXX = 'ST') then
       SELECT NVL(Max(D.SO_DK),0) into vsodk FROM ADS_DON_THAMGIATOTUNG D
            LEFT JOIN ADS_DON GD ON GD.ID=D.DONID
            WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
             AND gd.toaanid=VTOAANID;
    end if;

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   if(vCXX = 'PT') then 
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                select pt.id, pt.donid, pt.hoten, pt.ngaytao from ads_phuctham_thamgiatotung pt WHERE pt.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null ));
    ELSIF(vCXX = 'ST') then
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                    select st.id, st.donid, st.hoten, st.ngaytao from ads_don_thamgiatotung st where st.id IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                 ); 
    end if;
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa, tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ads_phuctham_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN ADS_PHUCTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN ADS_DON d ON d.ID=TG.donid  
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'PT' then 1 else 0 end)
                         )
        union
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ads_don_thamgiatotung tg 
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN ADS_SOTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN ADS_DON d ON d.ID=TG.donid
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'ST' then 1 else 0 end)
                         )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN) INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn', 'BIDON', ' là bị đơn', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan', 'QUYENLOIICHDUOCBAOVE', ' là người có quyền và lợi ích được bảo vệ', 'UYQUYEN', ' là người ủy quyền'))HOTEN FROM ADS_DON_DUONGSU DD
                    LEFT JOIN ADS_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST') then
             SELECT LISTAGG(HOTEN || ', ') WITHIN GROUP (ORDER BY HOTEN) INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn', 'BIDON', ' là bị đơn', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan', 'QUYENLOIICHDUOCBAOVE', ' là người có quyền và lợi ích được bảo vệ', 'UYQUYEN', ' là người ủy quyền'))HOTEN FROM ADS_DON_DUONGSU DD
                    LEFT JOIN ADS_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
         --------------------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM ADS_DON_DUONGSU DD
                    LEFT JOIN ADS_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM ADS_DON_DUONGSU DD
                    LEFT JOIN ADS_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
        ---------------
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
            select di.ten  into vChucDanhTP from dm_canbo cb left join dm_dataitem di on cb.chucvuid = di.id where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            GIẤY XÁC NHẬN
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của đương sự</span>
        </p>
        <p style="font-size: 14pt; margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| VTOAAN_TEN_FULL ||' xác nhận:<br />
        </p>
        <p style="font-size: 14pt; margin-bottom:0pt;margin-top:3pt;line-height: 115%; text-align: justify;">
            <span style="color: #ffffff">......</span>'|| item.ongba ||' '||item.hoten||' là '|| item.tentucach ||' '|| item.ten_vpls ||'
            '|| (case when item.doan_LS is null then '' else 'thuộc Đoàn luật sư ' || item.doan_ls end) ||''
            || (case when item.diachivpls is null then (case when item.dienthoai is null then '' else ' (SĐT: ' || item.dienthoai ||')' end) 
            else ' (địa chỉ: ' || item.diachivpls || (case when item.dienthoai is null then ')' else ', SĐT: ' || item.dienthoai ||')' end) end) || ', đã làm thủ tục đăng ký người bảo vệ quyền và lợi ích hợp
            pháp cho'|| VDUONGSU_DATA ||' trong vụ án dân sự thụ lý số '|| item.sothuly ||'/'|| to_char(sysdate,'yyyy') ||'/TL'|| vCXX ||'-DS ngày '|| item.ngaythulys ||' tại '|| item.tentoa ||'.
        </p>
        <p style="font-size: 14pt; margin-bottom:0pt;margin-top:3pt;;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>Vào sổ đăng ký số '|| item.so_dk ||' ngày '||to_char(sysdate,'dd/mm/yyyy')||'
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>
        </p>
        ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Người BVQ và LIHP của đương sự;<br />
                        - <span style="text-transform:capitalize;">'||VBICAO_FOOTER||';</span>
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p  style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_DS_NBC; 

--duongph
FUNCTION  GXN_HC_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;
    VTOAAN_TEN VARCHAR2(512);
    VCAPXX_TEN VARCHAR2(512);
    VSODK VARCHAR2(100);
    VCOUNT_LS NUMBER;
    V_TT_LS NUMBER;
    VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);
    VDUONGSU_DATA VARCHAR2(512);
    VKSND_NAME VARCHAR2(512);
    VTENDVHC VARCHAR2(512);
    V_TENTOIDANH VARCHAR2(512);
    BICAO_VALUE VARCHAR2(512);
    V_HOTEN VARCHAR2(255);
    vindex number;
    vThamPhan VARCHAR2(255);
    vChucDanhTP varchar(255);
BEGIN	

    IF(vCXX = 'PT') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO vsodk FROM AHC_PHUCTHAM_THAMGIATOTUNG D
        LEFT JOIN AHC_DON_GIAIDOAN GD ON GD.DONID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
         AND gd.toaphucthamid=VTOAANID;
    END IF;
    IF(vCXX = 'ST') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO vsodk FROM AHC_DON_THAMGIATOTUNG D
        LEFT JOIN AHC_DON GD ON GD.ID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
         AND gd.toaanid=VTOAANID;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   if(vCXX = 'PT') then 
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                select pt.id, pt.donid, pt.hoten, pt.ngaytao from ahc_phuctham_thamgiatotung pt WHERE pt.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null ));
    ELSIF(vCXX = 'ST') then
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                    select st.id, st.donid, st.hoten, st.ngaytao from ahc_don_thamgiatotung st where st.id IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                 ); 
    end if;
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ahc_phuctham_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN AHC_PHUCTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN AHC_DON d ON d.ID=TG.donid  
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'PT' then 1 else 0 end)
                         )
        union
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ahc_don_thamgiatotung tg 
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1  
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN AHC_SOTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN AHC_DON d ON d.ID=TG.donid
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'ST' then 1 else 0 end)
                         )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là Người khởi kiện ', 'BIDON', ' là Người bị kiện ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan '))HOTEN FROM AHC_DON_DUONGSU DD
                    LEFT JOIN AHC_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là Người khởi kiện ', 'BIDON', ' là Người bị kiện ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan '))HOTEN FROM AHC_DON_DUONGSU DD
                    LEFT JOIN AHC_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
         --------------------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM AHC_DON_DUONGSU DD
                    LEFT JOIN AHC_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM AHC_DON_DUONGSU DD
                    LEFT JOIN AHC_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
        ---------------
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
            select di.ten into vChucDanhTP from dm_canbo cb left join dm_dataitem di on cb.chucvuid = di.id where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            GIẤY XÁC NHẬN
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của đương sự</span>
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| VTOAAN_TEN_FULL ||' xác nhận:<br />
        </p>
        <p style="font-size: 14pt; margin-bottom:0pt;margin-top:3pt;line-height: 115%; text-align: justify;">
            <span style="color: #ffffff">......</span>'|| item.ongba ||' '||item.hoten||' là '|| item.tentucach ||' '|| item.ten_vpls ||'
             '|| (case when item.doan_LS is null then '' else 'thuộc Đoàn luật sư ' || item.doan_ls end) ||''
            || (case when item.diachivpls is null then (case when item.dienthoai is null then '' else ' (SĐT: ' || item.dienthoai ||')' end) 
            else ' (địa chỉ: ' || item.diachivpls || (case when item.dienthoai is null then ')' else ', SĐT: ' || item.dienthoai ||')' end) end) ||', đã làm thủ tục đăng ký người bảo vệ quyền và lợi ích hợp
            pháp cho'|| VDUONGSU_DATA ||'trong vụ án hành chính thụ lý số '|| item.sothuly ||'/'|| to_char(sysdate,'yyyy') ||'/TL'|| vCXX ||'-HC ngày '|| item.ngaythulys ||' tại '|| item.tentoa ||'.
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>Vào sổ đăng ký số '|| item.so_dk ||' ngày '||to_char(sysdate,'dd/mm/yyyy')||'
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>
        </p>
        ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Người BVQ và LIHP của đương sự;<br />
                        - <span style="text-transform:capitalize;">'||VBICAO_FOOTER||';</span>
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_HC_NBC; 

--duongph
FUNCTION  GXN_HN_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;
    VTOAAN_TEN VARCHAR2(512);
    VCAPXX_TEN VARCHAR2(512);
    VSODK VARCHAR2(100);
    VCOUNT_LS NUMBER;
    V_TT_LS NUMBER;
    VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);
    VDUONGSU_DATA VARCHAR2(512);
    VKSND_NAME VARCHAR2(512);
    VTENDVHC VARCHAR2(512);
    V_TENTOIDANH VARCHAR2(512);
    BICAO_VALUE VARCHAR2(512);
    V_HOTEN VARCHAR2(255);
    vindex number;
    vThamPhan VARCHAR2(255);
    vChucDanhTP varchar(255);
BEGIN	

    IF(vCXX = 'PT') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO vsodk FROM AHN_PHUCTHAM_THAMGIATOTUNG D
        LEFT JOIN AHN_DON_GIAIDOAN GD ON GD.DONID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
         AND gd.toaphucthamid=VTOAANID;
    END IF;
    IF(vCXX = 'ST') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO vsodk FROM AHN_DON_THAMGIATOTUNG D
        LEFT JOIN AHN_DON GD ON GD.ID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
         AND gd.toaanid=VTOAANID;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   if(vCXX = 'PT') then 
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                select pt.id, pt.donid, pt.hoten, pt.ngaytao from ahn_phuctham_thamgiatotung pt WHERE pt.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null ));
    ELSIF(vCXX = 'ST') then
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                    select st.id, st.donid, st.hoten, st.ngaytao from ahn_don_thamgiatotung st where st.id IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                 ); 
    end if;
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa, tg.diachi as diachivpls, tg.dienthoai, tg.NGUOIPHANCONGID, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ahn_phuctham_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN AHN_PHUCTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN AHN_DON d ON d.ID=TG.donid  
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'PT' then 1 else 0 end)
                         )
        union
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.NGUOIPHANCONGID, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ahn_don_thamgiatotung tg 
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN AHN_SOTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN AHN_DON d ON d.ID=TG.donid
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'ST' then 1 else 0 end)
                         )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan '))HOTEN FROM AHN_DON_DUONGSU DD
                    LEFT JOIN AHN_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif (vCXX = 'ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan '))HOTEN FROM AHN_DON_DUONGSU DD
                    LEFT JOIN AHN_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );

         end if;
         --------------------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM AHN_DON_DUONGSU DD
                    LEFT JOIN AHN_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM AHN_DON_DUONGSU DD
                    LEFT JOIN AHN_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
        ---------------
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
            select di.ten into vChucDanhTP from dm_canbo cb left join dm_dataitem di on cb.chucvuid = di.id where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            GIẤY XÁC NHẬN
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của đương sự</span>
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| VTOAAN_TEN_FULL ||' xác nhận:<br />
        </p>
        <p style="font-size: 14pt; margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| item.ongba ||' '||item.hoten||' là '|| item.tentucach ||' '|| item.ten_vpls ||'
             '|| (case when item.doan_LS is null then '' else 'thuộc Đoàn luật sư ' || item.doan_ls end) ||''
            || (case when item.diachivpls is null then (case when item.dienthoai is null then '' else ' (SĐT: ' || item.dienthoai ||')' end) 
            else ' (địa chỉ: ' || item.diachivpls || (case when item.dienthoai is null then ')' else ', SĐT: ' || item.dienthoai ||')' end) end) || ', đã làm thủ tục đăng ký người bảo vệ quyền và lợi ích hợp
            pháp cho'|| VDUONGSU_DATA ||'trong vụ án hôn nhân và gia đình thụ lý số '|| item.sothuly ||'/'|| to_char(sysdate,'yyyy') ||'/TL'|| vCXX ||'-HN ngày '|| item.ngaythulys ||' tại '|| item.tentoa ||'.
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>Vào sổ đăng ký số '|| item.so_dk ||' ngày '||to_char(sysdate,'dd/mm/yyyy')||'
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>
        </p>
        ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Người BVQ và LAHP của đương sự;<br />
                        - <span style="text-transform:capitalize;">'||VBICAO_FOOTER||';</span>
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_HN_NBC; 

--duongph
FUNCTION  GXN_KT_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;
    VTOAAN_TEN VARCHAR2(512);
    VCAPXX_TEN VARCHAR2(512);
    VSODK VARCHAR2(100);
    VCOUNT_LS NUMBER;
    V_TT_LS NUMBER;
    VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);
    VDUONGSU_DATA VARCHAR2(512);
    VKSND_NAME VARCHAR2(512);
    VTENDVHC VARCHAR2(512);
    V_TENTOIDANH VARCHAR2(512);
    BICAO_VALUE VARCHAR2(512);
    V_HOTEN VARCHAR2(255);
    vindex number;
    vThamPhan VARCHAR2(255);
    vChucDanhTP varchar(255);
BEGIN	

    IF(vCXX = 'PT') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO vsodk FROM AKT_PHUCTHAM_THAMGIATOTUNG D
        LEFT JOIN AKT_DON_GIAIDOAN GD ON GD.DONID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
         AND gd.toaphucthamid=VTOAANID;
    END IF;
    IF(vCXX = 'ST') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO vsodk FROM AKT_DON_THAMGIATOTUNG D
        LEFT JOIN AKT_DON GD ON GD.ID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
         AND gd.toaanid=VTOAANID;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   if(vCXX = 'PT') then 
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                select pt.id, pt.donid, pt.hoten, pt.ngaytao from akt_phuctham_thamgiatotung pt WHERE pt.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null ));
    ELSIF(vCXX = 'ST') then
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                    select st.id, st.donid, st.hoten, st.ngaytao from akt_don_thamgiatotung st where st.id IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                 ); 
    end if;
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from akt_phuctham_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN AKT_PHUCTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN AKT_DON d ON d.ID=TG.donid  
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'PT' then 1 else 0 end)
                         )
        union
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from akt_don_thamgiatotung tg 
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN AKT_SOTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN AKT_DON d ON d.ID=TG.donid
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'ST' then 1 else 0 end)
                         )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan '))HOTEN FROM AKT_DON_DUONGSU DD
                    LEFT JOIN AKT_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX='ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan '))HOTEN FROM AKT_DON_DUONGSU DD
                    LEFT JOIN AKT_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
         --------------------------
         if(vCXX='PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM AKT_DON_DUONGSU DD
                    LEFT JOIN AKT_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX='ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM AKT_DON_DUONGSU DD
                    LEFT JOIN AKT_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
        ---------------
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
            select di.ten into vChucDanhTP from dm_canbo cb left join dm_dataitem di on cb.chucvuid = di.id where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            GIẤY XÁC NHẬN
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của đương sự</span>
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| VTOAAN_TEN_FULL ||' xác nhận:<br />
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| item.ongba ||' '||item.hoten||' là '|| item.tentucach ||' '|| item.ten_vpls ||'
             '|| (case when item.doan_LS is null then '' else 'thuộc Đoàn luật sư ' || item.doan_ls end) ||''
            || (case when item.diachivpls is null then (case when item.dienthoai is null then '' else ' (SĐT: ' || item.dienthoai ||')' end) 
            else ' (địa chỉ: ' || item.diachivpls || (case when item.dienthoai is null then ')' else ', SĐT: ' || item.dienthoai ||')' end) end) || ', đã làm thủ tục đăng ký người bảo vệ quyền và lợi ích hợp
            pháp cho'|| VDUONGSU_DATA ||'trong vụ án kinh doanh thương mại thụ lý số '|| item.sothuly ||'/'|| to_char(sysdate,'yyyy') ||'/TL'|| vCXX ||'-KDTM ngày '|| item.ngaythulys ||' tại '|| item.tentoa ||'.
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>Vào sổ đăng ký số '|| item.so_dk ||' ngày '||to_char(sysdate,'dd/mm/yyyy')||'
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>
        </p>
        ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Người BVQ và LIHP của đương sự;<br />
                        - <span style="text-transform:capitalize;">'||VBICAO_FOOTER||';</span>
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <pstyle="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_KT_NBC;

--duongph
FUNCTION  GXN_LD_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;
    VTOAAN_TEN VARCHAR2(512);
    VCAPXX_TEN VARCHAR2(512);
    VSODK VARCHAR2(100);
    VCOUNT_LS NUMBER;
    V_TT_LS NUMBER;
    VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);
    VDUONGSU_DATA VARCHAR2(512);
    VKSND_NAME VARCHAR2(512);
    VTENDVHC VARCHAR2(512);
    V_TENTOIDANH VARCHAR2(512);
    BICAO_VALUE VARCHAR2(512);
    V_HOTEN VARCHAR2(255);
    vindex number;
    vThamPhan VARCHAR2(255);
    vChucDanhTP varchar(255);
BEGIN	

    IF(vCXX = 'PT') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO VSODK FROM ALD_PHUCTHAM_THAMGIATOTUNG D
        LEFT JOIN ALD_DON_GIAIDOAN GD ON GD.DONID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
         AND gd.toaphucthamid=VTOAANID;
    END IF;
    IF(vCXX = 'ST') THEN 
         SELECT NVL(Max(D.SO_DK),0) INTO VSODK FROM ALD_DON_THAMGIATOTUNG D
        LEFT JOIN ALD_DON GD ON GD.ID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR')) AND D.SO_DK !=0
         AND gd.toaanid=VTOAANID;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   if(vCXX = 'PT') then 
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                select pt.id, pt.donid, pt.hoten, pt.ngaytao from ald_phuctham_thamgiatotung pt WHERE pt.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null ));
    ELSIF(vCXX = 'ST') then
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                    select st.id, st.donid, st.hoten, st.ngaytao from ald_don_thamgiatotung st where st.id IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                 ); 
    end if;
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ald_phuctham_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN ALD_PHUCTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN ALD_DON d ON d.ID=TG.donid  
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'PT' then 1 else 0 end)
                         )
        union
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from ald_don_thamgiatotung tg 
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN ALD_SOTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN ALD_DON d ON d.ID=TG.donid
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'ST' then 1 else 0 end)
                         )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         if(vCXX='PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan ', 'UYQUYEN', ' là người ủy quyền '))HOTEN FROM ALD_DON_DUONGSU DD
                    LEFT JOIN ALD_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX='ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan ', 'UYQUYEN', ' là người ủy quyền '))HOTEN FROM ALD_DON_DUONGSU DD
                    LEFT JOIN ALD_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
         --------------------------
         if(vCXX='PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM ALD_DON_DUONGSU DD
                    LEFT JOIN ALD_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX='ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM ALD_DON_DUONGSU DD
                    LEFT JOIN ALD_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
        ---------------
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
            select di.ten into vChucDanhTP from dm_canbo cb left join dm_dataitem di on cb.chucvuid = di.id where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            GIẤY XÁC NHẬN
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của đương sự</span>
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| VTOAAN_TEN_FULL ||' xác nhận:<br />
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| item.ongba ||' '||item.hoten||' là '|| item.tentucach ||' '|| item.ten_vpls ||'
             '|| (case when item.doan_LS is null then '' else 'thuộc Đoàn luật sư ' || item.doan_ls end) ||''
            || (case when item.diachivpls is null then (case when item.dienthoai is null then '' else ' (SĐT: ' || item.dienthoai ||')' end) 
            else ' (địa chỉ: ' || item.diachivpls || (case when item.dienthoai is null then ')' else ', SĐT: ' || item.dienthoai ||')' end) end) || ', đã làm thủ tục đăng ký người bảo vệ quyền và lợi ích hợp
            pháp cho'|| VDUONGSU_DATA ||'trong vụ án lao động thụ lý số '|| item.sothuly ||'/'|| to_char(sysdate,'yyyy') ||'/TL'|| vCXX ||'-LD ngày '|| item.ngaythulys ||' tại '|| item.tentoa ||'.
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>Vào sổ đăng ký số '|| item.so_dk ||' ngày '||to_char(sysdate,'dd/mm/yyyy')||'
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>
        </p>
        ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Người BVQ và LIHP của đương sự;<br />
                        - <span style="text-transform:capitalize;">'||VBICAO_FOOTER||';</span>
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p  style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_LD_NBC;

--duongph
FUNCTION  GXN_PS_NBC
(
 vCXX in varchar2,
 vArrLuatSuID in varchar2,
 VTOAANID in varchar2,
 VCAPXX in varchar2
)
RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;
    VTOAAN_TEN VARCHAR2(512);
    VCAPXX_TEN VARCHAR2(512);
    VSODK VARCHAR2(100);
    VCOUNT_LS NUMBER;
    V_TT_LS NUMBER;
    VBICAO_FOOTER VARCHAR2(512);
    VTOAAN_TEN_FULL VARCHAR2(512);
    VDUONGSU_DATA VARCHAR2(512);
    VKSND_NAME VARCHAR2(512);
    VTENDVHC VARCHAR2(512);
    V_TENTOIDANH VARCHAR2(512);
    BICAO_VALUE VARCHAR2(512);
    V_HOTEN VARCHAR2(255);
    vindex number;
    vThamPhan VARCHAR2(255);
    vChucDanhTP varchar(255);
BEGIN	

    IF(VCXX = 'PT') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO VSODK FROM APS_PHUCTHAM_THAMGIATOTUNG D
        LEFT JOIN APS_DON_XULY GD ON GD.DONID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
         AND gd.toaanid=VTOAANID;
        END IF;
    IF(VCXX = 'ST') THEN 
        SELECT NVL(Max(D.SO_DK),0) INTO VSODK FROM APS_DON_THAMGIATOTUNG D
        LEFT JOIN APS_DON GD ON GD.ID=D.DONID
        WHERE  EXTRACT(YEAR FROM  TO_DATE(D.NGAY_DK, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))AND D.SO_DK !=0
        AND gd.toaanid=VTOAANID;
       END IF;

    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
   SELECT DECODE(TA.LOAITOA,'CAPCAO',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN CẤP CAO',''),'CAPTINH',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN TỈNH'),'CAPHUYEN',REPLACE(UPPER(TA.TEN),'TÒA ÁN NHÂN DÂN HUYỆN',''),'') INTO VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT DECODE(TA.LOAITOA,'CAPCAO','TÒA ÁN NHÂN DÂN CẤP CAO','CAPTINH','TÒA ÁN NHÂN DÂN TỈNH','CAPHUYEN','TÒA ÁN NHÂN DÂN HUYỆN')INTO VCAPXX_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   --SELECT UPPER(TA.TEN) into VTOAAN_TEN FROM DM_TOAAN TA WHERE TA.ID=VTOAANID;
   SELECT INSTR(VTOAAN_TEN,'TÒA ÁN NHÂN DÂN THÀNH PHỐ') into vindex from dual;
   if(vindex > 0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN THÀNH PHỐ','');
      VCAPXX_TEN := 'TÒA ÁN NHÂN DÂN THÀNH PHỐ';
   end if;
   /*if(INSTR(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN')>0) then
      VTOAAN_TEN := REPLACE(UPPER(VTOAAN_TEN),'TÒA ÁN NHÂN DÂN','TAND');
      --VCAPXX_TEN := 'TAND';
   end if;*/
   if(vCXX = 'PT') then 
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                select pt.id, pt.donid, pt.hoten, pt.ngaytao from aps_phuctham_thamgiatotung pt WHERE pt.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null ));
    ELSIF(vCXX = 'ST') then
        SELECT COUNT(*) INTO VCOUNT_LS FROM ( 
                    select st.id, st.donid, st.hoten, st.ngaytao from aps_don_thamgiatotung st where st.id IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                        from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                 ); 
    end if;
   SELECT TEN INTO VTOAAN_TEN_FULL FROM DM_TOAAN WHERE ID=VTOAANID;
   SELECT REPLACE(TEN,'Viện kiểm sát nhân dân','VKSND')INTO VKSND_NAME FROM DM_VKS WHERE ID=VTOAANID;
   SELECT REPLACE(REPLACE(REPLACE(REPLACE(TEN,'Tòa án nhân dân cấp cao tại Hà Nội','tp Hà Nội'),'Tòa án nhân dân cấp cao tại Đà Nẵng','tp Đà Nẵng'),'Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh','tp Hồ Chí Minh'),'Tòa án nhân dân','')
   INTO VTENDVHC FROM DM_TOAAN WHERE ID=VTOAANID;
   --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
            style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
            </w:sdt>
            <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
      </div>');
      V_TT_LS:=0;
     FOR item in (
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from aps_phuctham_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1 
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN APS_PHUCTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN APS_DON d ON d.ID=TG.donid  
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'PT' then 1 else 0 end)
                         )
        union
                (select tg.id, tg.donid, tg.hoten, tg.tucachtgttid, tg.ngaytao, tg.nguoitao, tg.duongsuid,DECODE(TG.GIOITINH,0,'Bà','Ông') ONGBA,TC.TEN,tl.sothuly,tl.ngaythuly,to_char(tl.ngaythuly,'dd/MM/yyyy')  ngaythulys
                         ,d.tenvuviec, tg.ten_vpls, tg.doan_LS, ta.ten as tentoa,tg.diachi as diachivpls, tg.dienthoai, tg.nguoiphancongid, tg.chucvu_chucdanh, tc.ten as tentucach, tg.so_dk
                         from aps_don_thamgiatotung tg
                         LEFT JOIN (
                                    SELECT i.ID,i.MA,i.TEN
                                    FROM DM_DATAITEM i
                                    inner join DM_DATAGROUP g on g.ID=i.GROUPID
                                    Where i.HIEULUC=1 
                                    --Where g.MA='TUCACHTGTTKT' and i.HIEULUC=1  
                                  )TC ON TC.ma=tg.tucachtgttid
                         LEFT JOIN APS_SOTHAM_THULY TL ON TL.donid=tg.donID  
                         LEFT JOIN APS_DON d ON d.ID=TG.donid
                         left join DM_TOAAN ta on ta.id = tl.toaanid
                         where tg.ID IN(select to_number(regexp_substr(vArrLuatSuID,'[^,]+', 1, level)) 
                         from dual connect by regexp_substr(vArrLuatSuID, '[^,]+', 1, level) is not null )
                         and 1 = (case when vCXX = 'ST' then 1 else 0 end)
                         )
        )
     LOOP
        V_TT_LS:=V_TT_LS+1;
         ---------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan ', 'UYQUYEN', ' là người ủy quyền ', 'KHAC', ''))HOTEN FROM APS_DON_DUONGSU DD
                    LEFT JOIN APS_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST')then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VDUONGSU_DATA
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' bà ',' ông ') ||dd.tenduongsu||decode(dd.tucachtotung_ma, 'NGUYENDON', ' là nguyên đơn ', 'BIDON', ' là bị đơn ', 'QUYENNVLQ', ' là người có quyền nghĩa vụ liên quan ', 'UYQUYEN', ' là người ủy quyền ', 'KHAC', ''))HOTEN FROM APS_DON_DUONGSU DD
                    LEFT JOIN APS_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
         --------------------------
         if(vCXX = 'PT') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM APS_DON_DUONGSU DD
                    LEFT JOIN APS_PHUCTHAM_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         elsif(vCXX = 'ST') then
             SELECT LISTAGG(HOTEN, ', ') WITHIN GROUP (ORDER BY HOTEN)INTO VBICAO_FOOTER
             FROM (SELECT dd.id,DECODE(DD.donid,'BC-',DD.tenduongsu,decode(dd.GIOITINH,0,' Bà ',' Ông ') ||dd.tenduongsu)HOTEN FROM APS_DON_DUONGSU DD
                    LEFT JOIN APS_DON_THAMGIATOTUNG TG ON TG.donid=DD.donid where tg.id = item.id
                    ) 
             WHERE id IN(select to_number(regexp_substr(item.duongsuid,'[^,]+', 1, level)) 
                            from dual connect by regexp_substr(item.duongsuid, '[^,]+', 1, level) is not null );
         end if;
        ---------------
        if (item.nguoiphancongid is not null) then
            select cb.hoten into vThamPhan from dm_canbo cb where cb.id = item.nguoiphancongid;
            select di.ten into vChucDanhTP from dm_canbo cb left join dm_dataitem di on cb.chucvuid = di.id where cb.id = item.nguoiphancongid;
        end if;
        ----------------
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 13pt; text-align: center; border-collapse: collapse;">
            <tr style="text-align: center;">
                <th style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    '||VCAPXX_TEN||'
                </th>
                <th style="text-align: center; width=750px; font-size: 13pt; letter-spacing: -1px;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td style="text-align: center; font-size: 13pt; letter-spacing: -1px;">
                    <table>
                        <tr>
                            <th style="border-bottom: 1px solid #000000; font-size: 13pt; letter-spacing: -1px;"><span>' || VTOAAN_TEN || '</span></th>
                        </tr>
                    </table>
                </td>
                <td>
                    <table cellpadding="0" cellspacing="0">
                        <tr style="height: 1pt; padding-bottom: 3px; font-size: 12pt">
                            <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                            <th style="border-bottom: 1px solid #000000; text-align: left;">
                                <span>ộc lập - Tự do - Hạnh ph</span>
                            </th>
                            <th style="text-align: left;"><span>úc</span></th>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="text-align: center; font-size: 12pt">
                <td></td>
                <td></td>
            </tr>
            <tr style=" font-size: 12pt;">
                <td style="font-size: 11pt">Số: '||item.SO_DK||'/'||to_char(sysdate,'yyyy')||'/GXNNBV</td>
                <td style="font-size: 12pt;font-style: italic;"><span style="color: #ffffff;">......</span>Hà Nội, ngày <span>'||to_char(sysdate,'dd')||'</span> tháng <span>'||to_char(sysdate,'MM')||'</span> năm <span>'||to_char(sysdate,'yyyy')||'</span></td>
            </tr>
            <tr style="font-style: italic; font-size: 12pt;">
                <td></td>
                <td></td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 450pt;"></td>
                <td style="width: 750pt"></td>
            </tr>
        </table>
            ');
            ----------------  
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <p style="font-weight: bold; text-align: center; font-size: 16pt; line-height: 125%;">
            GIẤY XÁC NHẬN
            <br />
            <span style="font-weight: bold; text-align: center; font-size: 14pt;">Người bảo vệ quyền và lợi ích hợp pháp của đương sự</span>
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| VTOAAN_TEN_FULL ||' xác nhận:<br />
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>'|| item.ongba ||' '||item.hoten||' là '|| item.tentucach ||' '|| item.ten_vpls ||'
             '|| (case when item.doan_LS is null then '' else 'thuộc Đoàn luật sư ' || item.doan_ls end) ||''
            || (case when item.diachivpls is null then (case when item.dienthoai is null then '' else ' (SĐT: ' || item.dienthoai ||')' end) 
            else ' (địa chỉ: ' || item.diachivpls || (case when item.dienthoai is null then ')' else ', SĐT: ' || item.dienthoai ||')' end) end) || ', đã làm thủ tục đăng ký người bảo vệ quyền và lợi ích hợp
            pháp cho'|| VDUONGSU_DATA ||'trong vụ án phá sản thụ lý số '|| item.sothuly ||'/'|| to_char(sysdate,'yyyy') ||'/TL'|| vCXX ||'-PS ngày '|| item.ngaythulys ||' tại '|| item.tentoa ||'.
        </p>
        <p style="font-size: 14pt;margin-bottom:0pt;margin-top:3pt;line-height: 115%;text-align: justify;">
            <span style="color: #ffffff">......</span>Vào sổ đăng ký số '|| item.so_dk ||' ngày '||to_char(sysdate,'dd/mm/yyyy')||'
        </p>
        <p style="font-size: 14pt; line-height: 135%;margin-bottom:0pt;margin-top:3pt;line-height: 115%;">
            <span style="color: #ffffff">......</span>
        </p>
        ');
            ----------------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td style="vertical-align: top;">
                    <p style="font-size: 11pt; text-align: left; line-height: 105%;">
                        <i style="font-weight: bold;">Nơi nhận:</i>
                        <br />
                        - Người BVQ và LIHP của đương sự;<br />
                        - <span style="text-transform:capitalize;">'||VBICAO_FOOTER||';</span>
                        <br />
                        - Lưu hồ sơ vụ án;
                        <br />
                    </p>
                </td>
                <td>
                    <p style="font-size: 13pt;">
                        <strong>'|| (case when item.chucvu_chucdanh is null then '' else UPPER(REPLACE(REPLACE(item.chucvu_chucdanh, 'trung cấp', ''),'sơ cấp', '')) end) ||'</strong>
                    </p>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <p style="font-size: 12pt;"><strong>'|| (case when vThamPhan is null then '' else vThamPhan end) ||'</strong></p>
                </td>
            </tr>
            <tr style="height: 0px;">
                <td style="width: 600pt;"></td>
                <td style="width: 550pt"></td>
            </tr>
        </table>
            ');
            -------------
          IF(V_TT_LS<VCOUNT_LS)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>
            ');
            END IF;
       END LOOP;     
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GXN_PS_NBC;

END PKG_TOANCAU_STPT_EXT;
