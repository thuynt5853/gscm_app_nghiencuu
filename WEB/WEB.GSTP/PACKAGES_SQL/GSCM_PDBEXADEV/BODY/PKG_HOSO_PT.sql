--------------------------------------------------------
--  DDL for Package Body PKG_HOSO_PT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_HOSO_PT" AS
PROCEDURE DELETE_HOSO_PT_ID
(    
  V_LOAIAN  IN NUMBER,
  V_ID	IN	NUMBER  
)
AS   
BEGIN  
        DELETE HOSO_PT HS WHERE HS.ID=V_ID AND HS.LOAIAN=LOAIAN;      
END;
PROCEDURE  HOSO_PT_LIST_ID
( 
  V_LOAIAN  IN NUMBER,
  V_ID IN VARCHAR2,
  curReturn OUT sys_refcursor
)
IS  
BEGIN
OPEN curReturn FOR
   SELECT HS.* FROM HOSO_PT HS WHERE HS.ID=V_ID AND HS.LOAIAN=LOAIAN;
END HOSO_PT_LIST_ID;
PROCEDURE   HOSO_PT_LIST 
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    PageIndex	in	int, 
    PageSize	in	int,
    CurReturn OUT sys_refcursor
) 
AS  
  TotalItem number;MinIndex	number;MaxIndex	number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

    open CurReturn for
      SELECT   A.* FROM (SELECT  ROW_NUMBER() OVER (ORDER BY a.LOAI_CN ASC, A.NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL,                   
               A.ID,b.HOTEN|| '-' || e.TEN TENCANBO,
               decode(a.LOAI_CN,1,'Chuyển hồ sơ đến',2,'Nhận hồ sơ từ')LOAI_CN,
               decode(A.LOAI_DV,1,TA.TEN,2,VK.TEN) DV_GUI_NHAN,
               A.GHICHU,to_char(a.NGAY_NC,'dd/MM/yyyy HH24:MI:SS')NGAY_NC
             FROM HOSO_PT A   
                LEFT JOIN DM_TOAAN TA ON TA.ID=A.DV_GUI_NHAN AND A.LOAI_DV=1
                LEFT JOIN DM_VKS VK ON VK.ID=A.DV_GUI_NHAN AND A.LOAI_DV=2
                LEFT JOIN DM_CANBO B ON A.CANBOID = B.ID
                left join (select c.ID,c.TEN,c.MA from DM_DATAITEM c where c.GROUPID=12) e on e.ID=b.CHUCDANHID
                left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=b.CHUCVUID
             WHERE A.VUANID =V_VUANID AND A.LOAIAN=LOAIAN      
      ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END HOSO_PT_LIST;
PROCEDURE  HOSO_PT_INS_UP
( 
    V_ID IN NUMBER,
    V_LOAIAN IN NUMBER,
    V_VUANID IN NUMBER,
    V_LOAI_CN IN NUMBER,
    V_CANBOID IN NUMBER,
    V_NGAY_NC  in DATE,
    V_DV_GUI_NHAN IN NUMBER,
    V_NGUOI_NHAN_VKS IN VARCHAR2,
    V_GHICHU IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_LOAI_DV IN NUMBER,
    V_TOAANID IN NUMBER,
    V_TOA_GIAIQUYET_ID IN NUMBER
)
IS 
BEGIN
  if(V_VUANID != 0) THEN
     IF v_ID=0 THEN
       INSERT INTO HOSO_PT
         (ID,LOAIAN,VUANID,LOAI_CN,CANBOID,NGAY_NC,DV_GUI_NHAN,NGUOI_NHAN_VKS,GHICHU,NGUOITAO,LOAI_DV,TOAANID,NGAYTAO,NGUOISUA,NGAYSUA,TOA_GIAIQUYET_ID)
        VALUES (HOSO_PT_SEQ.NEXTVAL,V_LOAIAN,V_VUANID,V_LOAI_CN,V_CANBOID,V_NGAY_NC,V_DV_GUI_NHAN,V_NGUOI_NHAN_VKS,V_GHICHU,V_NGUOITAO,V_LOAI_DV,V_TOAANID,SYSDATE,V_NGUOITAO,SYSDATE,V_TOA_GIAIQUYET_ID);
     ELSE 
          UPDATE HOSO_PT
            SET    
                LOAI_CN=V_LOAI_CN,
                CANBOID=V_CANBOID,
                NGAY_NC=V_NGAY_NC, 
                DV_GUI_NHAN=V_DV_GUI_NHAN,
                NGUOI_NHAN_VKS=V_NGUOI_NHAN_VKS,
                GHICHU=V_GHICHU,
                NGUOISUA=V_NGUOITAO,
                LOAI_DV=V_LOAI_DV,
                NGAYSUA=SYSDATE
            WHERE ID=V_ID;
     END IF;   
  END IF;
END;

PROCEDURE  DM_CANBO_QLHS_PT
(
  vDonViID in VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
    open CurReturn for
       select a.ID,a.HOTEN,a.HOTEN || '-' || b.TEN as MA_TEN,d.TEN as ChucVu,B.MA CHUCDANH,
        a.HOTEN|| '-' || b.TEN|| DECODE(d.TEN,NULL,NULL,'-'||d.TEN) ||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS
        from DM_CANBO a
          inner join (select c.ID,c.TEN,c.MA from DM_DATAITEM c where c.GROUPID=12) b on b.ID=a.CHUCDANHID
          left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=a.CHUCVUID
        where a.TOAANID=vDonViID And a.HIEULUC=1 
        AND B.MA NOT IN('TP','TPSC','TPTC','TPCC','TPTATC','HTND') AND UPPER(B.MA) NOT LIKE ('C0%')
        Order by a.HOTEN;
END DM_CANBO_QLHS_PT;
PROCEDURE   HOSO_PT_LIST_EXORT
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    CurReturn OUT sys_refcursor
) 
AS   
BEGIN	
    open CurReturn for
       SELECT NULL TEXT_REPORT FROM DUAL;

END HOSO_PT_LIST_EXORT;
PROCEDURE GETBY_COUNT_VKS
( 
    V_DONVIID in VARCHAR2,
	curReturn    OUT       sys_refcursor
)
IS 
BEGIN 
  open CurReturn for
  SELECT COUNT(*)CountAll FROM HOSO_PT HS 
  WHERE HS.LOAI_DV=2 AND HS.LOAI_CN=1 AND HS.TOAANID=29
      AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID
      AND HP.LOAI_DV=2 AND HP.LOAI_CN=2);--LOAI_CN =2 nhận hồ sơ
END GETBY_COUNT_VKS; 
PROCEDURE GETBY_COUNT_VKSS
( 
    V_DONVIID in VARCHAR2,
    V_CAPXX in VARCHAR2,
	curReturn    OUT       sys_refcursor
)
IS 
 VV_CAPXX VARCHAR2(100);
BEGIN 
    --LOAI_CN =1 Chuyển hồ sơ,2 nhận hồ sơ
    --LOAI_DV=1 tòa án;2 viện kiểm sát
    IF(V_CAPXX='CAPCAO')THEN
        VV_CAPXX:=3;
     ELSIF(V_CAPXX='CAPHUYEN')THEN
       VV_CAPXX:=2;
      ELSE 
       VV_CAPXX:=null;
      end if;
  open CurReturn for
   SELECT COUNT(*)CountAll FROM
         TABLE(PKG_HOSO_PT.HOSO_PT_VKS_TABLE('25',TO_CHAR(SYSDATE,'dd/MM/yyyy'),null,null,null,null,null,V_DONVIID)) TP
         WHERE (TP.CAP_XX=VV_CAPXX OR  VV_CAPXX IS NULL)
         ;
--        SELECT COUNT(*)CountAll FROM HOSO_PT HS 
--        LEFT JOIN DM_TOAAN TA ON TA.ID= HS.TOAANID
--       -- INNER JOIN AHS_VUAN VA ON VA.ID=HS.VUANID
--        WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) --viện kiểm sát chuyển hồ sơ
--        AND HS.TOAANID=V_DONVIID 
--        AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
--        AND (SYSDATE-NGAY_NC)>25;
END GETBY_COUNT_VKSS; 
FUNCTION HOSO_PT_VKS_TABLE
( 
    V_SONGAY_QUAHAN in VARCHAR2,
    V_TINH_DEN_NGAY in VARCHAR2,
    V_LOAIAN in VARCHAR2,
    V_TUNGAY in VARCHAR2,
    V_DENNGAY in VARCHAR2,
    V_TENDUONGSU in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2
)RETURN T_HOSOLUU_VKS
IS 
    V_TABLE_TLST T_QUYETDINH; V_TABLE_BC T_AHS_BICANBICAO; 
    v_table T_HOSOLUU_VKS;V_TABLE_BC_KC T_AHS_BICANBICAO;V_TABLE_BC_KC_EXT T_BICANBICAO_EXT;  V_TABLE_BC_KN T_AHS_BICANBICAO;
    VV_TUNGAY date;VV_DENNGAY date;  
BEGIN
     ----------------------------------------------
     v_table := T_HOSOLUU_VKS();V_TABLE_BC_KC := T_AHS_BICANBICAO();V_TABLE_BC_KC_EXT := T_BICANBICAO_EXT();
     V_TABLE_BC_KN := T_AHS_BICANBICAO(); V_TABLE_TLST := T_QUYETDINH();
     V_TABLE_BC := T_AHS_BICANBICAO();
      ---------------------------------------------
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
      ----------------------------------------------
     v_table := T_HOSOLUU_VKS();V_TABLE_BC_KC := T_AHS_BICANBICAO();V_TABLE_BC_KC_EXT := T_BICANBICAO_EXT();
     V_TABLE_BC_KN := T_AHS_BICANBICAO(); V_TABLE_TLST := T_QUYETDINH();
     V_TABLE_BC := T_AHS_BICANBICAO();
      ---------------------------------------------
     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 
        ---V_TABLE_BC_KC; tạo bảng  lấy <=1 bị cáo khang cao
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KC
        FROM(SELECT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO B
                        WHERE EXISTS(SELECT 'X' FROM (SELECT DECODE(M.DSNGUOIBIKC,NULL,TO_CHAR(M.NGUOIKCID)||',',M.DSNGUOIBIKC)NGUOIKC_ID,M.* FROM AHS_SOTHAM_KHANGCAO M) KC
                                     WHERE INSTR(','||KC.NGUOIKC_ID,','||B.ID||',')>0 AND KC.VUANID=B.VUANID)
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=1
            )TTS;   
             ---V_TABLE_BC_KC; tạo bảng  lấy <=1 bị cáo bi khang nghi
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC_KN
        FROM(SELECT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT B.ID,B.VUANID,B.HOTEN,B.BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY B.VUANID ORDER BY B.BICANDAUVU DESC,B.NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO B
                        WHERE EXISTS(SELECT 'X' FROM (SELECT M.* FROM AHS_SOTHAM_KHANGNGHI M) KC
                                     WHERE INSTR(','||KC.DSNGUOIBIKN,','||B.ID||',')>0 AND KC.VUANID=B.VUANID)
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=1
            )TTS;  
         --AHS_SOTHAM_THULY
        SELECT R_QUYETDINH(TTS.VUANID,TTS.ID,NULL)
        BULK COLLECT INTO V_TABLE_TLST
        FROM( SELECT TT.VUANID,TT.ID FROM (  
                 SELECT VUANID,FIRST_VALUE(ID) OVER (PARTITION BY VUANID ORDER BY NGAYTHULY DESC,NGAYTAO DESC) ID
                 FROM  AHS_SOTHAM_THULY 
                )TT GROUP BY TT.VUANID,TT.ID
            )TTS;     
        SELECT R_AHS_BICANBICAO(TTS.ID,TTS.VUANID,TTS.HOTEN,TTS.TENTOIDANH,TTS.BICANDAUVU,TTS.ROWNUMBER)
        BULK COLLECT INTO V_TABLE_BC
        FROM(SELECT BC.ID,BC.VUANID,BC.HOTEN,C.TENTOIDANH,BC.BICANDAUVU,BC.ROWNUMBER FROM 
                    (   SELECT ID,VUANID,HOTEN,BICANDAUVU, ROW_NUMBER()  OVER (PARTITION BY VUANID ORDER BY BICANDAUVU DESC,NGAYTHAMGIA DESC) ROWNUMBER
                        FROM  AHS_BICANBICAO 
                    )BC 
                LEFT JOIN (SELECT CD.BICANID,CD.TENTOIDANH,CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN=1) C ON BC.ID = C.BICANID
                where BC.ROWNUMBER <=1
            )TTS;            
       -------------------------------------------------------------------------------------------------------------
       ---hình sự so tham
           FOR item IN(
            --LOAI_CN =1 Chuyển hồ sơ,2 nhận hồ sơ; --LOAI_DV=1 tòa án;2 viện kiểm sát           
            SELECT HS.NGAY_NC,TLS.SOTHULY SOTHULY,TLS.NGAYTHULY,VA.TOAANID--||'</br>'||va.ID||'</br>'||va.MAVUAN
            ,BA.SOBANAN||QD.SOQUYETDINH  SOQDBA
            ,BA.NGAYBANAN||QD.NGAYQD NGAYQDBA
            ,BC2.HOTEN NGUYENDON,BC2.TENTOIDANH BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AHS_VUAN VA ON VA.ID=HS.VUANID
             LEFT JOIN (
                         SELECT TL.VUANID,TL.SOTHULY,TL.NGAYTHULY FROM AHS_SOTHAM_THULY TL
                           WHERE EXISTS(SELECT 'X' FROM TABLE(V_TABLE_TLST) QDL WHERE QDL.ID=TL.ID)
                           GROUP BY TL.VUANID,TL.SOTHULY,TL.NGAYTHULY
                       )TLS ON TLS.VUANID=HS.VUANID
            LEFT JOIN AHS_SOTHAM_BANAN BA ON BA.VUANID=HS.VUANID
            LEFT JOIN  (SELECT QDS.* FROM AHS_SOTHAM_QUYETDINH_VUAN QDS 
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=QDS.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.VUANID=HS.VUANID
             LEFT JOIN(SELECT BC.VUANID,BC.HOTEN,BC.TENTOIDANH  FROM  TABLE(V_TABLE_BC) BC
                      ) BC2 ON BC2.VUANID=HS.VUANID            
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) --chuyển hồ sơ cho vks
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=1--hình sự so tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('2',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,NULL,item.BIDON,NULL,item.NGAY_NC
        );  
         END LOOP;
           ---hình sự phuc tham
           FOR item IN(
            --LOAI_CN =1 Chuyển hồ sơ,2 nhận hồ sơ; --LOAI_DV=1 tòa án;2 viện kiểm sát           
            SELECT HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,decode(DECODE(KC.LOAIKHANGCAO,0,BA_KC.SOBANAN,QD_KC.SOQUYETDINH),null,DECODE(KN.LOAIKN,0,BA_KN.SOBANAN,QD_KN.SOQUYETDINH),DECODE(KC.LOAIKHANGCAO,0,BA_KC.SOBANAN,QD_KC.SOQUYETDINH) ) SOQDBA
            ,decode(DECODE(KC.LOAIKHANGCAO,0,BA_KC.NGAYBANAN,QD_KC.NGAYQD),null,DECODE(KN.LOAIKN,0,BA_KN.NGAYBANAN,QD_KN.NGAYQD),DECODE(KC.LOAIKHANGCAO,0,BA_KC.NGAYBANAN,QD_KC.NGAYQD))NGAYQDBA
            ,BC3.HOTEN||BC4.HOTEN AS NGUYENDON,BC3.BIDON
           ,HS.LOAIAN          
            FROM HOSO_PT HS 
            INNER JOIN AHS_VUAN VA ON VA.ID=HS.VUANID
            LEFT JOIN(SELECT VUANID,HOTEN,TENTOIDANH BIDON FROM TABLE(V_TABLE_BC_KC) )BC3 ON BC3.VUANID=HS.VUANID
            LEFT JOIN(SELECT VUANID,HOTEN,TENTOIDANH BIDON FROM TABLE(V_TABLE_BC_KN) )BC4 ON BC4.VUANID=HS.VUANID
            LEFT JOIN (SELECT VUANID,SOQDBA,LOAIKHANGCAO,DSNGUOIBIKC from AHS_SOTHAM_KHANGCAO group by VUANID,SOQDBA,LOAIKHANGCAO,DSNGUOIBIKC)KC ON KC.VUANID=HS.VUANID
            LEFT JOIN (select ID,SOBANAN SOBANAN,to_char(NGAYBANAN,'dd/MM/yyyy')NGAYBANAN from AHS_SOTHAM_BANAN ) BA_KC ON BA_KC.ID=KC.SOQDBA
            LEFT JOIN (select ID,SOQUYETDINH SOQUYETDINH,to_char(NGAYQD,'dd/MM/yyyy')NGAYQD from AHS_SOTHAM_QUYETDINH_VUAN ) QD_KC ON QD_KC.ID=KC.SOQDBA
            LEFT JOIN(SELECT VUANID,BANANID,LOAIKN from AHS_SOTHAM_KHANGNGHI group by VUANID,BANANID,LOAIKN)KN ON KN.VUANID=HS.VUANID
            LEFT JOIN (select ID,SOBANAN SOBANAN,to_char(NGAYBANAN,'dd/MM/yyyy')NGAYBANAN from AHS_SOTHAM_BANAN) BA_KN ON BA_KN.ID=KN.BANANID
            LEFT JOIN (select ID,SOQUYETDINH SOQUYETDINH,to_char(NGAYQD,'dd/MM/yyyy')NGAYQD from AHS_SOTHAM_QUYETDINH_VUAN ) QD_KN ON QD_KN.ID=KN.BANANID
            LEFT JOIN AHS_PHUCTHAM_THULY TL ON TL.VUANID=HS.VUANID
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) --chuyển hồ sơ cho vks
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=1--hình sự phuc tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
            AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('3',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,NULL,item.BIDON,NULL,item.NGAY_NC
        );  
         END LOOP;
         ---Dan su sơ thẩm
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID--||'</br>'||va.ID||'</br>'||va.MAVUVIEC
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN ADS_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN ADS_SOTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from ADS_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from ADS_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ADS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ADS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=2--Dan su sơ thẩm
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('2',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
         END LOOP;
          ---Dan su phuc tham
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN ADS_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN ADS_PHUCTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from ADS_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from ADS_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ADS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ADS_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=2--Dan su phuc tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('3',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
         END LOOP;
           ---Hôn nhân sơ thẩm
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AHN_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN AHN_SOTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from AHN_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from AHN_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHN_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHN_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=3 --Hôn nhân sơ thẩm
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('2',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
        END LOOP;
        ---Hon nhan phuc tham
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AHN_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN AHN_PHUCTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from AHN_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from AHN_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHN_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHN_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=3--Hon nhan phuc tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('3',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
         END LOOP;
                  ---kinh ke sơ thẩm
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AKT_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN AKT_SOTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from AKT_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from AKT_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AKT_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AKT_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=4 --kinh ke sơ thẩm
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('2',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
        END LOOP;
        ---kinh te phuc tham
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AKT_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN AKT_PHUCTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from AKT_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from AKT_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AKT_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AKT_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=4--kinh te phuc tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('3',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
         END LOOP;   
                   ---Lao đong sơ thẩm
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN ALD_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN ALD_SOTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from ALD_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from ALD_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ALD_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ALD_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=5 ----Lao đong sơ thẩm
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('2',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
        END LOOP;
        ---Lao dong phuc tham
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN ALD_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN ALD_PHUCTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from ALD_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from ALD_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ALD_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM ALD_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=5--Lao dong phuc tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('3',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
         END LOOP;  
                  ---Hanh chinh sơ thẩm
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AHC_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN AHC_SOTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from AHC_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from AHC_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHC_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHC_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=6 ----Hanh chinh thẩm
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('2',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
        END LOOP;
        ---Hanh chinh phuc tham
           FOR item IN(
            SELECT  HS.NGAY_NC,TL.SOTHULY SOTHULY,TL.NGAYTHULY,VA.TOAANID
            ,BA.SOBANAN||QD.SOQUYETDINH SOQDBA ,BA.NGAYTUYENAN|| QD.NGAYQD NGAYQDBA           
            ,ND.TENDUONGSU NGUYENDON,BD.TENDUONGSU BIDON,HS.LOAIAN
            FROM HOSO_PT HS 
            INNER JOIN AHC_DON VA ON VA.ID=HS.VUANID
            LEFT JOIN AHC_PHUCTHAM_THULY TL ON TL.DONID=HS.VUANID
            LEFT JOIN (select DONID,SOBANAN,NGAYTUYENAN from AHC_SOTHAM_BANAN )BA ON BA.DONID=HS.VUANID
            LEFT JOIN (select qs.DONID,' QĐ - '||qs.SOQD SOQUYETDINH,qs.NGAYQD from AHC_SOTHAM_QUYETDINH qs
                        INNER JOIN DM_QD_QUYETDINH dmqd ON dmqd.ID=qs.QUYETDINHID and
                        dmqd.ISSOTHAM = 1 AND dmqd.KET_THUC = 1) QD ON QD.DONID=HS.VUANID
            LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHC_DON_DUONGSU WHERE TUCACHTOTUNG_MA='NGUYENDON'  GROUP BY DONID
                       )ND ON ND.DONID=HS.VUANID
             LEFT JOIN (SELECT DONID,LISTAGG(TENDUONGSU, ', ') WITHIN GROUP (ORDER BY ISDAIDIEN DESC)TENDUONGSU 
                        FROM AHC_DON_DUONGSU WHERE TUCACHTOTUNG_MA='BIDON' GROUP BY DONID
                       )BD ON BD.DONID=HS.VUANID           
            WHERE (HS.LOAI_DV=2 AND HS.LOAI_CN=1) 
            AND HS.TOAANID=V_DONVIID AND HS.LOAIAN=6--Hanh chinh phuc tham
            AND NOT EXISTS(SELECT 'X' FROM HOSO_PT HP WHERE HP.VUANID=HS.VUANID  AND HP.LOAI_CN=2 AND HP.LOAI_DV=2)--chưa nhận hồ sơ từ viện kiểm sát
           AND (TO_DATE(V_TINH_DEN_NGAY,'dd/MM/yyyy')-HS.NGAY_NC)>V_SONGAY_QUAHAN
            AND(V_TUNGAY IS NULL OR  HS.NGAY_NC>=VV_TUNGAY) AND (V_DENNGAY IS NULL OR HS.NGAY_NC<=VV_DENNGAY)
            )
         LOOP
            v_table.extend;
            v_table(v_table.count) := R_HOSOLUU_VKS('3',
            item.SOTHULY,item.NGAYTHULY,item.LOAIAN,item.TOAANID,item.SOQDBA,item.NGAYQDBA,item.NGUYENDON,item.BIDON,NULL,NULL,item.NGAY_NC
        );  
         END LOOP;   
     RETURN v_table;      
END HOSO_PT_VKS_TABLE;     

 PROCEDURE HOSO_PT_LIST_VKS
( 
    V_SONGAY_QUAHAN in VARCHAR2,
    V_TINH_DEN_NGAY in VARCHAR2,
    V_LOAIAN in VARCHAR2,
    V_TUNGAY in VARCHAR2,
    V_DENNGAY in VARCHAR2,
    V_TENDUONGSU in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn    OUT       sys_refcursor
)
IS 
    TotalItem number; MinIndex	number;MaxIndex	number;
BEGIN
    ---hiện tại đang làm luồng phúc thẩm
    -- sơ thẩm làm sau nếu là sơ thẩm thì thay đổi như sau:
    --cột thụ lý lấy của st,cột bị cáo, cột nguyên đơn, bị đơn vẫn lấy như vậy nhưng không check kháng cáo 
     MinIndex := PageSize*(PageIndex - 1) + 1;
     MaxIndex := PageIndex*PageSize;
       ----------------------------
     OPEN curReturn FOR 
      select tt.* from (
             SELECT ROW_NUMBER() OVER (ORDER BY TP.LOAIAN_ID,TP.NGAY_NC) STT,COUNT(*) OVER () AS COUNTALL,
             TP.SOTHULY||'<br />'||to_char(TP.NGAYTHULY,'dd/MM/yyyy')THULY ,TP.SOBA_QD_ST||'<br />'||to_char(to_date(TP.NGAYBA_QD_ST,'dd/MM/yyyy'),'dd/MM/yyyy') SONGAY_BAQD_ST
             ,LA.LOAI_AN_TEN,to_char(TP.NGAY_NC,'dd/MM/yyyy')NGAY_NC,TA.MA_TEN TOAAN_TEN,TP.NGUYEND_DON,DECODE(TP.LOAIAN_ID,1,TP.TOIDANH,TP.BI_DON)BI_DON
             FROM  TABLE(PKG_HOSO_PT.HOSO_PT_VKS_TABLE(V_SONGAY_QUAHAN,V_TINH_DEN_NGAY,V_LOAIAN,V_TUNGAY,V_DENNGAY,V_TENDUONGSU,V_CAPXX,V_DONVIID)) TP
             LEFT JOIN DM_LOAIAN LA ON LA.ID=TP.LOAIAN_ID
             LEFT JOIN DM_TOAAN TA ON TA.ID=TP.TOAANID
             WHERE TP.CAP_XX=V_CAPXX AND (V_LOAIAN IS NULL OR TP.LOAIAN_ID=V_LOAIAN) 
             AND (V_TENDUONGSU IS NULL 
               OR (UPPER(TP.NGUYEND_DON) LIKE '%'||upper(V_TENDUONGSU)||'%')
               OR (UPPER(TP.BI_DON) LIKE '%'||upper(V_TENDUONGSU)||'%')
             )
     )tt where tt.stt>=MinIndex and tt.stt<=MaxIndex
     ; 
 END HOSO_PT_LIST_VKS; 
 PROCEDURE HOSO_PT_LIST_VKS_EXPORT
( 
    V_SONGAY_QUAHAN in VARCHAR2,
    V_TINH_DEN_NGAY in VARCHAR2,
    V_LOAIAN in VARCHAR2,
    V_TUNGAY in VARCHAR2,
    V_DENNGAY in VARCHAR2,
    V_TENDUONGSU in VARCHAR2,
    V_CAPXX in VARCHAR2,
    V_DONVIID in VARCHAR2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn    OUT       sys_refcursor
)
IS 
    V_EXPORT_TEXT CLOB; V_DONVI_TEN VARCHAR(255);
BEGIN
     SELECT UPPER(MA_TEN) INTO V_DONVI_TEN FROM DM_TOAAN WHERE ID=V_DONVIID;
       ----------------------------
       DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 10pt; text-align: center;">
            <tr>
                <td colspan="4" style="text-align: center; vertical-align: middle;font-weight: bold; font-size: 10pt">'||V_DONVI_TEN||'</td>
                <th colspan="1"></th>
                <th colspan="4" style="text-align: center; vertical-align: middle;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center; vertical-align: middle;font-weight: bold; font-size: 10pt"></td>
                <th colspan="1"></th>
                <th colspan="4" style="text-align: center; vertical-align: middle;">Độc lập - Tự do - Hạnh phúc</th>
            </tr>
            <tr>
                <th colspan="9" style="text-align: center; vertical-align: middle; height: 48px; font-weight: bold; font-size: 10pt">HỒ SƠ QUÁ '||V_SONGAY_QUAHAN||' NGÀY CHƯA NHẬN VỀ TÍNH ĐẾN NGÀY '||V_TINH_DEN_NGAY||'</th>
            </tr>
            <tr>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">STT</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số, ngày thụ lý</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Loại án</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa phương</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số, ngày BAD/QĐ ST</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Nguyên đơn/NKK/Bị cáo</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Bị đơn/NBK/tội danh</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tổng số bút lục</th>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày chuyển</th>
            </tr>

            <tr align="center" style="font-style: italic;display:none">
                <td style="border: 0.1pt solid Black; vertical-align: middle;">1</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">2</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">3</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">4</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">5</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">6</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">7</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">8</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">9</td>
            </tr>
            ');

            for item in (
                 SELECT ROW_NUMBER() OVER (ORDER BY TP.LOAIAN_ID,TP.NGAY_NC) STT,COUNT(*) OVER () AS COUNTALL,
                  TP.SOTHULY||'<br />'||to_char(TP.NGAYTHULY,'dd/MM/yyyy')THULY ,TP.SOBA_QD_ST||'<br />'||to_char(to_date(TP.NGAYBA_QD_ST,'dd/MM/yyyy'),'dd/MM/yyyy') SONGAY_BAQD_ST
                 ,LA.LOAI_AN_TEN,to_char(TP.NGAY_NC,'dd/MM/yyyy')NGAY_NC,TA.MA_TEN TOAAN_TEN,TP.NGUYEND_DON,DECODE(TP.LOAIAN_ID,1,TP.TOIDANH,TP.BI_DON)BI_DON
                 FROM  TABLE(PKG_HOSO_PT.HOSO_PT_VKS_TABLE(V_SONGAY_QUAHAN,V_TINH_DEN_NGAY,V_LOAIAN,V_TUNGAY,V_DENNGAY,V_TENDUONGSU,V_CAPXX,V_DONVIID)) TP
                 LEFT JOIN DM_LOAIAN LA ON LA.ID=TP.LOAIAN_ID
                 LEFT JOIN DM_TOAAN TA ON TA.ID=TP.TOAANID
                 WHERE TP.CAP_XX=V_CAPXX AND (V_LOAIAN IS NULL OR TP.LOAIAN_ID=V_LOAIAN) 
                 AND (V_TENDUONGSU IS NULL 
                       OR (UPPER(TP.NGUYEND_DON) LIKE '%'||upper(V_TENDUONGSU)||'%')
                       OR (UPPER(TP.BI_DON) LIKE '%'||upper(V_TENDUONGSU)||'%')
                     )                     
              )                         
              LOOP
                       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                     <tr>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.STT||'</td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.THULY||'</td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.LOAI_AN_TEN||'</td>
                         <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.TOAAN_TEN||'</td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.SONGAY_BAQD_ST||'</td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.NGUYEND_DON||'</td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.BI_DON||'</td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;"></td>
                        <td style="border: 0.1pt solid Black; text-align: center; vertical-align: middle;">'||item.NGAY_NC||'</td>
                     </tr>
                    ');
              end loop;

             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <tr align="center">
                    <td style="width: 30px;"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                </tr>
            </table>
        ');
       ----------------------------
       OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
       dbms_lob.freetemporary(V_EXPORT_TEXT);
 END HOSO_PT_LIST_VKS_EXPORT; 

PROCEDURE SP_CANBO_THULY_PT
(
  vDonViID in VARCHAR2,
  CurReturn OUT sys_refcursor 
) AS 
BEGIN
    open CurReturn for
       SELECT a.ID, a.HOTEN, a.HOTEN || '-' || b.TEN as MA_TEN, d.TEN as ChucVu, B.MA CHUCDANH,
        a.HOTEN || ' - ' || b.TEN || DECODE(d.TEN,NULL,NULL,' - ' || d.TEN)  HOTEN_DROPDOWN
        FROM DM_CANBO a
          INNER JOIN (SELECT c.ID,c.TEN,c.MA from DM_DATAITEM c where c.GROUPID = 12) b on b.ID = a.CHUCDANHID
          LEFT JOIN (SELECT c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID = a.CHUCVUID
        WHERE a.TOAANID = vDonViID And a.HIEULUC = 1 
        AND B.MA IN('TP','TPSC','TPTC','TPCC','TPTATC')
        ORDER BY a.HOTEN;
END SP_CANBO_THULY_PT;
PROCEDURE HOSO_PT_LIST_V2
(
    V_LOAIAN  IN NUMBER,
    V_VUANID IN NUMBER,
    PageIndex	in	int, 
    PageSize	in	int,
    CurReturn OUT sys_refcursor
) 
AS  
  TotalItem number;MinIndex	number;MaxIndex	number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;

    open CurReturn for
      SELECT   A.* FROM (SELECT  ROW_NUMBER() OVER (ORDER BY a.LOAI_CN ASC, A.NGAYTAO DESC) STT, COUNT(*) OVER () AS COUNTALL,                   
               A.ID,b.HOTEN|| '-' || e.TEN TENCANBO,
               decode(a.LOAI_CN,1,'Chuyển hồ sơ đến',2,'Nhận hồ sơ từ')LOAI_CN,
               decode(A.LOAI_DV,1,TA.TEN,2,VK.TEN) DV_GUI_NHAN,
               A.GHICHU,to_char(a.NGAY_NC,'dd/MM/yyyy')NGAY_NC,
               A.TOA_GIAIQUYET_ID
             FROM HOSO_PT A   
                LEFT JOIN DM_TOAAN TA ON TA.ID=A.DV_GUI_NHAN AND A.LOAI_DV=1
                LEFT JOIN DM_VKS VK ON VK.ID=A.DV_GUI_NHAN AND A.LOAI_DV=2
                LEFT JOIN DM_CANBO B ON A.CANBOID = B.ID
                left join (select c.ID,c.TEN,c.MA from DM_DATAITEM c where c.GROUPID=12) e on e.ID=b.CHUCDANHID
                left join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=13) d on d.ID=b.CHUCVUID
             WHERE A.VUANID =V_VUANID AND A.LOAIAN=LOAIAN      
      ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
END HOSO_PT_LIST_V2;
END PKG_HOSO_PT;

/
