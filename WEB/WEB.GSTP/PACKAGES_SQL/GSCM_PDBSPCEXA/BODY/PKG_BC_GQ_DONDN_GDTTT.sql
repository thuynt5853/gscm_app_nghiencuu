--------------------------------------------------------
--  DDL for Package Body PKG_BC_GQ_DONDN_GDTTT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_BC_GQ_DONDN_GDTTT" AS
FUNCTION BC_GQ_DONDN_GDTTT
(
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date
)
 RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;v_TenPhongban VARCHAR2(150);v_dem NUMBER:=0;V_MOITHULY_DON NUMBER;
    FIRST_NAME_PHONGBAN VARCHAR2(150);MID_NAME_PHONGBAN VARCHAR2(150);LAST_NAME_PHONGBAN VARCHAR2(150);
    V_EXPORT_TEXT CLOB;  v_table T_BC_GQ_DONDN_GDTTT;v_table_ld T_LANH_DAO;KN_TLD_XD_CUCONLAI NUMBER;
    V_DON_MOITHULY NUMBER;V_DON_DATHULY NUMBER;V_KHONGDON NUMBER;
    V_DON_MOITHULY_TEMP NUMBER;V_DON_DATHULY_TEMP NUMBER;
    -----------------
    TotalItem NUMBER; v_Month VARCHAR2(150);v_year VARCHAR2(150);V_AZ VARCHAR2(150);TONG_VU NUMBER;V_CUCONLAI_VU_DON NUMBER;
    LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;LOAI_THANG NUMBER;
    ------------------
    CU_CON_LAI_VU_XX_TONG NUMBER; MOI_THU_LY_VU_XX_TONG NUMBER;DA_XX_ITEM VARCHAR2(250);CON_LAI_XX_ITEM VARCHAR2(250);
    -----------------
     vvTuNgay date;vvDenNgay date;V_TONG_GQ NUMBER;V_TONG_GQ_ID CLOB;V_CHUA_CO_KQGQ NUMBER;V_CHUA_CO_KQGQ_ID CLOB;
  BEGIN	   
    vvTuNgay:=to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS' );
    vvDenNgay:=to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS' );
    ----------------------
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true); DBMS_LOB.CREATETEMPORARY(V_TONG_GQ_ID,true); DBMS_LOB.CREATETEMPORARY(V_CHUA_CO_KQGQ_ID,true);
    ----------------------
     v_table := T_BC_GQ_DONDN_GDTTT();v_table_ld := T_LANH_DAO();
      ---------------cắt tên phòng ban
      SELECT SUBSTR(PB.TENPHONGBAN,0,INSTR(PB.TENPHONGBAN,' ')- 1)
           ,SUBSTR(PB.TENPHONGBAN,INSTR(PB.TENPHONGBAN,' ') +1,  INSTR(PB.TENPHONGBAN,' ',-1,1) - INSTR(PB.TENPHONGBAN,' ') -1)
           ,SUBSTR(PB.TENPHONGBAN,INSTR(PB.TENPHONGBAN,' ',-1)+ 1)
          INTO FIRST_NAME_PHONGBAN,MID_NAME_PHONGBAN,LAST_NAME_PHONGBAN
      FROM  DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID AND PB.ID=vPhongBanID;
      --------------
      SELECT to_char(vvDenNgay, 'MM'),to_char(vvDenNgay, 'YYYY') into v_Month,v_year from dual;
       -------------//////////////////////////////////////////////
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng v_table_ld
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH(
                                  vToaAnID,vPhongBanID,NULL,--vToaAnID,vPhongBanID,vLoaiAn
                                  vvTuNgay,vvDenNgay,--tt_tungay,tt_denngay
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,LOAI_THANG;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_ld.extend;
                         v_table_ld(v_table_ld.count) := R_LANH_DAO(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,LOAI_THANG
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
--//////////////////////////////////////////////////////////////////////////////////////////////
      --------------Tạo dữ liệu chuyển vào bảng định nghĩa v_table
        FOR  item_loaian IN (
                --lấy loại án theo từng đơn vị PB.id=vPhongBanID
                 SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                        DECODE(TT.COL_LOAIAN,'ISHINHSU','Hình sự','ISDANSU','Dân sự','ISHNGD','Hôn nhân và gia đình','ISKDTM','Kinh doanh, thương mại','ISLAODONG','Lao động','ISHANHCHINH','Hành chính')LOAIAN_TEN
                FROM (
                SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD, PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_PHONGBAN PB WHERE PB.TOAANID=vToaAnID AND PB.id=vPhongBanID)
                UNPIVOT --chuyển từ cột thành dòng
                (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                )TT WHERE CHECK_LOAIAN=1  ORDER BY TO_NUMBER(LOAIAN_ID)
        )
        LOOP
             ----------------cũ còn lại vụ 
             --DD.CD_TRANGTHAI=2 hành chính tư pháp đã chuyển và và các vụ đã nhận
             --DD.ISTHULY=1 là trường hợp thụ lý mới
             --DD.CD_NGAYXULY là ngày hành chính tư pháp đã chuyển và và các vụ đã nhận
             -- VA.NGAYTAO được thay cho DD.CD_NGAYXULY 
             --VA.GQD_NGAYPHATHANHCV là ngày của kết quả giải quiyết đơn của các vụ
             --GDQ_NGAY Ngày của TATC - ngày trên văn bản
              SELECT  COUNT(*) INTO TotalItem FROM (
                SELECT VA.*, CASE WHEN (VA.GQD_NGAYPHATHANHCV IS NOT NULL AND VA.GDQ_NGAY IS NOT NULL)  THEN  VA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VA.GQD_NGAYPHATHANHCV IS  NULL AND VA.GDQ_NGAY IS NOT NULL)  THEN  VA.GDQ_NGAY 
                                  WHEN (VA.GQD_NGAYPHATHANHCV IS NOT NULL AND VA.GDQ_NGAY IS NULL) THEN  VA.GQD_NGAYPHATHANHCV 
                                 END GQD_NGACVS
                            FROM GDTTT_VUAN VA
                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN is null
                    AND VA.NGAYTAO<vvTuNgay
                )TL WHERE TL.GQD_LOAIKETQUA IS NULL OR (TL.GQD_LOAIKETQUA IS not NULL and TL.GQD_NGACVS >=vvTuNgay)   
                ;
                 v_table.extend;
                 v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                             TotalItem,0,0,0,
                             0,0,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                            );
             ----------------cũ còn lại đơn
                 V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                  FOR item IN (
                        SELECT TL.* FROM (
                        SELECT VA.*, CASE WHEN (VA.GQD_NGAYPHATHANHCV IS NOT NULL AND VA.GDQ_NGAY IS NOT NULL)  THEN  VA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VA.GQD_NGAYPHATHANHCV IS  NULL AND VA.GDQ_NGAY IS NOT NULL)  THEN  VA.GDQ_NGAY 
                                          WHEN (VA.GQD_NGAYPHATHANHCV IS NOT NULL AND VA.GDQ_NGAY IS NULL) THEN  VA.GQD_NGAYPHATHANHCV 
                                         END GQD_NGACVS
                                    FROM GDTTT_VUAN VA
                            WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN is null
                            AND VA.NGAYTAO<vvTuNgay
                        )TL WHERE (TL.GQD_LOAIKETQUA IS NULL OR (TL.GQD_LOAIKETQUA IS not NULL and TL.GQD_NGACVS >=vvTuNgay) )
                      )  
                 LOOP
                         SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                         SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                         ---------------
                         IF(V_DON_MOITHULY_TEMP>0) THEN 
                            V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                          ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                               IF(V_DON_DATHULY_TEMP>0)THEN
                                   V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                  V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                               END IF;
                          END IF;
                 END LOOP;
                 TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                 -------
                 v_table.extend;
                 v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                             0,TotalItem,0,0,
                             0,0,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                            );              
                  ------------------Mới thụ lý vụ
                 SELECT COUNT(*)INTO TOTALITEM FROM GDTTT_VUAN VA
                 WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID
                 AND VA.NGAYTAO>=vvTuNgay AND VA.NGAYTAO<=vvDenNgay
                 and VA.ISVIENTRUONGKN is null
                 ;
                  --------
                 v_table.extend;
                 v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                             0,0,TotalItem,0,
                             0,0,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                            );
                ------------------Mới thụ lý đơn
                 V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                  FOR item IN (
                         SELECT VA.* FROM GDTTT_VUAN VA
                         WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID
                         AND VA.NGAYTAO>=vvTuNgay AND VA.NGAYTAO<=vvDenNgay
                         AND VA.ISVIENTRUONGKN IS NULL
                        )
                  LOOP
                     SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                         SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                         ---------------
                         IF(V_DON_MOITHULY_TEMP>0) THEN 
                            V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                          ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                               IF(V_DON_DATHULY_TEMP>0)THEN
                                   V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                  V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                               END IF;
                          END IF;
                  END LOOP;
                 TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                  ----
                 v_table.extend;
                 v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                             0,0,0,TotalItem,
                             0,0,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                            );
                --///////////////////////////////////////
                 ------------------Kháng nghị
                 ---------------- lấy từ mới thụ lý của vụ
                    SELECT COUNT(*)INTO TOTALITEM FROM (
                    SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                  WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                  WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                 END GQD_NGACVS
                    FROM GDTTT_VUAN TA) VA
                   WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                    AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                    AND  VA.NGAYTAO<=vvDenNgay 
                    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=1;
                        ----------------
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     TotalItem,0,0,0,0,0,
                                     0,0,0,
                                     0,0,0,0,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );
                        -------------khang nghi lay từ Mới thụ lý đơn
                        V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                        FOR item IN (
                                SELECT va.* FROM (
                                 SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                              WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                              WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                              END GQD_NGACVS
                                    FROM GDTTT_VUAN TA) VA
                                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                                    AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                                    AND  VA.NGAYTAO<=vvDenNgay
                                    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=1 --Kháng nghị (CA)
                            )
                   LOOP
                        SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                         SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                         ---------------
                         IF(V_DON_MOITHULY_TEMP>0) THEN 
                            V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                          ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                               IF(V_DON_DATHULY_TEMP>0)THEN
                                   V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                  V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                               END IF;
                          END IF;
                    END LOOP;
                         TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                         ----
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                             0,0,0,0,
                             0,TotalItem,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                                    );

                    --///////////////////////////////////////
                       ------------------Trả lời đơn
                       ---------------- lấy từ mới thụ lý của vụ
                       SELECT COUNT(*)INTO TOTALITEM FROM (
                    SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                  WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                  WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                 END GQD_NGACVS        
                    FROM GDTTT_VUAN TA) VA
                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                     AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                    AND  VA.NGAYTAO<=vvDenNgay 
                    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=0;
                        ----------------
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,TotalItem,0,0,0,
                                     0,0,0,
                                     0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                                    );
                        ------------- lay từ Mới thụ lý đơn
                        V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                        FOR item IN (
                                    SELECT va.* FROM (
                                        SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                                      WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                                      WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                                     END GQD_NGACVS        
                                        FROM GDTTT_VUAN TA) VA
                                        WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                                         AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                                        AND  VA.NGAYTAO<=vvDenNgay
                                        AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=0 --Trả lời đơn;
                                    )
                   LOOP
                        SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                         SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                         WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                         ---------------
                         IF(V_DON_MOITHULY_TEMP>0) THEN 
                            V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                          ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                               IF(V_DON_DATHULY_TEMP>0)THEN
                                   V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                  V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                               END IF;
                          END IF;
                    END LOOP;
                         TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                         ----
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,TotalItem,0,0,
                                     0,0,0,
                                     0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                                    );
                    --///////////////////////////////////////
                    -------------------Xếp đơn
                    ---------------- lấy từ mới thụ lý của vụ
                      SELECT COUNT(*)INTO TOTALITEM FROM (
                      SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                  WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                  WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS
                    FROM GDTTT_VUAN TA) VA
                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                     AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                    AND  VA.NGAYTAO<=vvDenNgay 
                    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=2;
                        ----------------
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,TotalItem,0,
                                     0,0,0,
                                     0,0,0,0,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );
                        ------------- lay từ Mới thụ lý đơn 
                            V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                            FOR item IN (
                                    SELECT va.* FROM (
                                          SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                                      WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                                      WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                                      END GQD_NGACVS
                                        FROM GDTTT_VUAN TA) VA
                                        WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                                         AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                                        AND  VA.NGAYTAO<=vvDenNgay
                                        AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=2 --Xếp đơn
                                    )
                        LOOP
                            SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                             WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                             SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                             WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                             ---------------
                             IF(V_DON_MOITHULY_TEMP>0) THEN 
                                V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                              ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                                   IF(V_DON_DATHULY_TEMP>0)THEN
                                       V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                    ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                      V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                                   END IF;
                              END IF;
                         END LOOP;
                         TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                         ----
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,TotalItem,
                                     0,0,0,
                                     0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                                    );
                    --///////////////////////////////////////
                    -------------------Xử lý khác
                    ---------------- lấy từ mới thụ lý của vụ
                      SELECT COUNT(*)INTO TOTALITEM FROM (
                      SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                  WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                  WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS
                    FROM GDTTT_VUAN TA) VA
                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                    AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                    AND  VA.NGAYTAO<=vvDenNgay 
                    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=3;
                        ----------------
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,0,0,0,
                                     0,0,0,0,0,0,0
                                    ,TotalItem,0,0,0
                                    );   
                   ------------- lay từ Mới thụ lý đơn 
                            V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                            FOR item IN (
                                    SELECT va.* FROM (
                                          SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                                      WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                                      WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                                      END GQD_NGACVS
                                        FROM GDTTT_VUAN TA) VA
                                        WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                                         AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                                        AND  VA.NGAYTAO<=vvDenNgay
                                        AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=3 --Xử lý khác
                                    )
                        LOOP
                            SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                             WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                             SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                             WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                             ---------------
                             IF(V_DON_MOITHULY_TEMP>0) THEN 
                                V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                              ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                                   IF(V_DON_DATHULY_TEMP>0)THEN
                                       V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                    ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                      V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                                   END IF;
                              END IF;
                         END LOOP;
                         TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                         ----
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,TotalItem,0,0
                                    );   
                     --///////////////////////////////////////
                    -------------------Vien Kiem Sat dang nghien cuu
                    ---------------- lấy từ mới thụ lý của vụ
                      SELECT COUNT(*)INTO TOTALITEM FROM (
                      SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                  WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                  WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS
                    FROM GDTTT_VUAN TA) VA
                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                    AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                    AND  VA.NGAYTAO<=vvDenNgay 
                    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=4;
                        ----------------
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,0,0,0,
                                     0,0,0,0,0,0,0
                                    ,0,0,TotalItem,0
                                    );   
                   ------------- lay từ Mới thụ lý đơn 
                            V_DON_MOITHULY:=0;V_DON_DATHULY:=0;V_KHONGDON:=0; V_DON_MOITHULY_TEMP:=0;V_DON_DATHULY_TEMP:=0;
                            FOR item IN (
                                    SELECT va.* FROM (
                                          SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                                      WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                                      WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                                      END GQD_NGACVS
                                        FROM GDTTT_VUAN TA) VA
                                        WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=ITEM_LOAIAN.LOAIAN_ID and VA.ISVIENTRUONGKN  is null
                                         AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                                        AND  VA.NGAYTAO<=vvDenNgay
                                        AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA=4 --VKS Dang giai quyet
                                    )
                        LOOP
                            SELECT COUNT(*)INTO V_DON_MOITHULY_TEMP FROM GDTTT_DON DD 
                             WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 1 AND DD.VUVIECID=item.ID;
                             SELECT COUNT(*)INTO V_DON_DATHULY_TEMP FROM GDTTT_DON DD 
                             WHERE  DD.CD_TRANGTHAI=2  AND DD.ISTHULY = 2 AND DD.VUVIECID=item.ID;
                             ---------------
                             IF(V_DON_MOITHULY_TEMP>0) THEN 
                                V_DON_MOITHULY:=V_DON_MOITHULY+V_DON_MOITHULY_TEMP;--trường hợp thụ lý mới lấy tổng số những đơn là thụ lý mới
                              ELSIF(V_DON_MOITHULY_TEMP=0) THEN 
                                   IF(V_DON_DATHULY_TEMP>0)THEN
                                       V_DON_DATHULY:=V_DON_DATHULY+V_DON_DATHULY_TEMP;--trường hợp đã thụ lý lấy tổng số những đơn đã thụ lý của 1 vụ án
                                    ELSIF(V_DON_DATHULY_TEMP=0)THEN   
                                      V_KHONGDON:=V_KHONGDON+1;--trường hợp không đơn thì coi 1 vụ án là 1 đơn
                                   END IF;
                              END IF;
                         END LOOP;
                         TotalItem:=V_DON_MOITHULY+V_DON_DATHULY+V_KHONGDON;
                         ----
                         v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,TotalItem
                                    );                 
                    --/////////////////////////////
                      ------------- CHUA_CO_KQGQ - Các giá trị của bảng v_table vừa được insert ở trên và được lấy ra luôn để tính toán 
                      --và tạo ra trường CHUA_CO_KQGQ,CHUA_CO_KQGQ_DON
                    FOR item IN( 
                                SELECT SUM((PA.CU_CON_LAI_VU+PA.MOI_THU_LY_VU)-(PA.KHANGNGHI+PA.TRALOIDON+PA.XEPDON+PA.XULY_KHAC+PA.XEPDON_VKS))CHUA_CO_KQGQ,
                                SUM((PA.CU_CON_LAI_DON+PA.MOI_THU_LY_DON)-(PA.KHANGNGHI_DON+PA.TRALOIDON_DON+PA.XEPDON_DON+PA.XULY_KHAC_DON+PA.XEPDON_VKS_DON))CHUA_CO_KQGQ_DON
                                FROM TABLE(v_table) PA WHERE PA.LOAIAN_ID=item_loaian.LOAIAN_ID
                              )
                    LOOP   
                    v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     item.CHUA_CO_KQGQ,item.CHUA_CO_KQGQ_DON,0,
                                     0,0,0,0,
                             0,0,0,0,0,0,0
                             ,0,0,0,0
                                    );
                    END LOOP;
                    --////////////////////////////////////////////////
                    --DANG_NGHIEN_CUU---cũng được tạo ra từ trường CHUA_CO_KQGQ vừa được insert ở trên
                    FOR item IN( 
                                SELECT SUM(T.CHUA_CO_KQGQ-T.DANG_TRINH)DANG_NGHIEN_CUU FROM (
                                    SELECT SUM(PA.CHUA_CO_KQGQ)CHUA_CO_KQGQ,SUM(0)DANG_TRINH FROM TABLE(v_table) PA WHERE PA.LOAIAN_ID=item_loaian.LOAIAN_ID
                                    UNION ALL                                
                                    SELECT SUM(0)CHUA_CO_KQGQ,COUNT(*)DANG_TRINH FROM TABLE(v_table_ld) PA WHERE PA.LOAI_THANG=0 AND PA.LOAIAN_ID=item_loaian.LOAIAN_ID
                                    )T
                              )
                    LOOP          
                   v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,item.DANG_NGHIEN_CUU,
                                     0,0,0,0,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );
                     END LOOP;
                   --///////////////////////////////////////
                   --CU_CON_LAI_VU_XX
                    SELECT  COUNT(*)  INTO TotalItem  FROM GDTTT_VUAN VA 
                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=item_loaian.LOAIAN_ID
                    AND VA.NgayThuLyXXGDT <vvTuNgay
                        AND    ( EXISTS  ( SELECT XX.VUANID FROM GDTTT_VUAN_XETXUGDTTT XX WHERE XX.ISHOAN=0 AND XX.VUANID=VA.ID AND XX.NGAYMOPT>=vvTuNgay )
                                 OR(NOT EXISTS ( SELECT XX.VUANID FROM GDTTT_VUAN_XETXUGDTTT XX WHERE XX.ISHOAN=0 AND XX.VUANID=VA.ID))
                                );
                      v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     TotalItem,0,0,0,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );
                  --MOI_THU_LY_VU_XX
                    SELECT  COUNT(*) INTO TotalItem FROM GDTTT_VUAN VA 
                    WHERE  VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=item_loaian.LOAIAN_ID
                    AND VA.NgayThuLyXXGDT >=vvTuNgay AND  VA.NgayThuLyXXGDT <= vvDenNgay;
                      v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,TotalItem,0,0,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );  
                    --DA_XX
                    SELECT COUNT(*)INTO TotalItem FROM GDTTT_VUAN_XETXUGDTTT XX
                    INNER JOIN GDTTT_VUAN VA ON VA.ID=XX.VUANID
                    WHERE XX.ISHOAN=0 AND VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID AND VA.LOAIAN=item_loaian.LOAIAN_ID
                    AND XX.NGAYMOPT >= vvTuNgay AND XX.NGAYMOPT <= vvDenNgay;
                    ----
                      v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,0,TotalItem,0,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );                  
                     --CON_LAI_XX
                   SELECT SUM((CU_CON_LAI_VU_XX+MOI_THU_LY_VU_XX)-DA_XX) INTO TotalItem  FROM TABLE(v_table) PA WHERE PA.LOAIAN_ID=item_loaian.LOAIAN_ID;
                     ----
                      v_table.extend;
                         v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                     item_loaian.LOAIAN_ID,item_loaian.LOAIAN_TEN,
                                     0,0,0,0,
                                     0,0,0,0,0,0,
                                     0,0,0,
                                     0,0,0,TotalItem,
                                     0,0,0,0,0,0,0
                                     ,0,0,0,0
                                    );             

     END LOOP; 
--CÔNG VĂN TRAO ĐỔI NGHIỆP VỤ
                -----------cũ còn lại chưa trình 
                SELECT COUNT(*) INTO TotalItem FROM GDTTT_VUAN_TRAODOICONGVAN TD  
                WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
                AND  (NVL(TD.ISKETQUAGQ,0)=0) 
                AND NOT EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID)
                AND TD.NGAYTHULY <=vvTuNgay;
                ----
                  v_table.extend;
                     v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                 0,NULL,
                                 0,0,0,0,
                                 0,0,0,0,0,0,
                                 0,0,0,
                                 0,0,0,0,
                                 TotalItem,0,0,0,0,0,0
                                 ,0,0,0,0
                                );        
                 -----------cũ còn lại đã trình chưa có kết quả
                SELECT COUNT(*) INTO TotalItem FROM GDTTT_VUAN_TRAODOICONGVAN TD 
                WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
                AND TD.NGAYTHULY <=vvTuNgay
                AND EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID )
                AND (NVL(TD.ISKETQUAGQ,0)=0) 
                ;
                ----
                  v_table.extend;
                     v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                0,NULL,
                                 0,0,0,0,
                                 0,0,0,0,0,0,
                                 0,0,0,
                                 0,0,0,0,
                                 0,TotalItem,0,0,0,0,0
                                 ,0,0,0,0
                                );   
                -----------cũ còn lại đã trình đã có kết quả
                SELECT COUNT(*) INTO TotalItem FROM GDTTT_VUAN_TRAODOICONGVAN TD 
                WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
                AND TD.NGAYTHULY <=vvTuNgay
                AND EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID )
                AND(TD.KQ_NGAYCONGVAN>=vvTuNgay  AND  (NVL(TD.ISKETQUAGQ,0)!=0) ) 
                ;
                ----
                  v_table.extend;
                     v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                 0,NULL,
                                 0,0,0,0,
                                 0,0,0,0,0,0,
                                 0,0,0,
                                 0,0,0,0,
                                 0,0,TotalItem,0,0,0,0
                                 ,0,0,0,0
                                );   
              ---------mới thụ lý chưa trình
            SELECT COUNT(*)INTO TotalItem FROM GDTTT_VUAN_TRAODOICONGVAN TD WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
            AND TD.NGAYTHULY >=vvTuNgay AND TD.NGAYTHULY <=vvDenNgay AND NOT EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID);   
            ----
                  v_table.extend;
                     v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                 0,NULL,
                                 0,0,0,0,
                                 0,0,0,0,0,0,
                                 0,0,0,
                                 0,0,0,0,
                                 0,0,0,TotalItem,0,0,0
                                 ,0,0,0,0
                                );  
        --------- mới thụ lý đã trình
        SELECT COUNT(*)INTO TotalItem FROM GDTTT_VUAN_TRAODOICONGVAN TD WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
        AND TD.NGAYTHULY >=vvTuNgay AND TD.NGAYTHULY <=vvDenNgay AND EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID); 
         ----
                  v_table.extend;
                     v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                                 0,NULL,
                                 0,0,0,0,
                                 0,0,0,0,0,0,
                                 0,0,0,
                                 0,0,0,0,
                                 0,0,0,0,TotalItem,0,0
                                 ,0,0,0,0
                                );  
        --------- đã có kết quả gải quyết
        SELECT COUNT(*)INTO TotalItem  FROM GDTTT_VUAN_TRAODOICONGVAN TD WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
        AND TD.NGAYTHULY >=vvTuNgay AND TD.NGAYTHULY <=vvDenNgay AND (NVL(TD.ISKETQUAGQ,0) =1);       
          ----
              v_table.extend;
                 v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             0,NULL,
                             0,0,0,0,
                             0,0,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,TotalItem,0
                             ,0,0,0,0
                            );  
        --------- còn lại
        --(cu con lai + moi thu ly) - ket qua  - cũ còn lại đã trình chưa có kết quả
         SELECT SUM((PA.TRAODOI_CUCONLAI+PA.TRAODOI_CUCONLAI_DATRINH+PA.TRAODOI_MOI+PA.TRAODOI_MOI_DATRINH)-PA.TRAODOI_KQ-PA.TRAODOI_CUCONLAI_DATRINH) INTO TotalItem 
         FROM TABLE(v_table) PA;
         ----
              v_table.extend;
                 v_table(v_table.count) := R_BC_GQ_DONDN_GDTTT(
                             0,NULL,
                             0,0,0,0,
                             0,0,0,0,0,0,
                             0,0,0,
                             0,0,0,0,
                             0,0,0,0,0,0,TotalItem
                             ,0,0,0,0
                            );  
--///////////////////////////////////////////////   
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
       <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
        <tr style="text-align: center;">
            <td style="text-align: center; vertical-align: middle; height: 25px; font-size: 12pt">TÒA ÁN NHÂN DÂN TỐI CAO  </td>
            <th style="text-align: center; vertical-align: middle; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
        </tr>
        <tr style="height: 1pt;">
            <td>
                <table cellpadding="0" cellspacing="0">
                    <tr style="height: 1pt; padding-bottom: 3px">
                        <th style="width: 30px; text-align: right;padding-right:2px;"><span>'||UPPER(FIRST_NAME_PHONGBAN)||'</span></th>
                        <th style="border-bottom: 1px solid #000000;">
                            <span>'||UPPER(MID_NAME_PHONGBAN)||'</span>
                        </th>
                        <th style="text-align: left;padding-left:2px">'||UPPER(LAST_NAME_PHONGBAN)||'</th>
                    </tr>
                </table>
            </td>
            <td style="">
                <table cellpadding="0" cellspacing="0">
                    <tr style="height: 1pt; padding-bottom: 3px;font-size: 13pt">
                        <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                        <th style="border-bottom: 1px solid #000000; text-align: left;">
                            <span>ộc lập - Tự do - Hạnh ph</span>
                        </th>
                        <th style="text-align: left;"><span>úc</span></th>
                    </tr>
                </table>
            </td>
        </tr>
        <tr style="padding-top: 3px; font-size: 12pt;">
           <td>Số:<span style="color:#ffffff;">........</span>/BC-GĐKT.'||UPPER(LAST_NAME_PHONGBAN)||'</td>
            <td></td>
        </tr>
       <tr style="font-style: italic; font-size: 12pt;">
            <td>V/v  Báo cáo công tác</td>
            <td style="font-size: 13pt"><span style="color: #ffffff;">...............</span>Hà Nội, ngày <span style="color: #ffffff;">......</span> tháng <span style="color: #ffffff;">......</span> năm <span style="color: #ffffff;">......</span></td>
        </tr>
        <tr style="font-style: italic; font-size: 12pt;">
            <td><span style="color: #ffffff;">...</span> tháng <span style="color: #ffffff;">......</span> năm <span style="color: #ffffff;">......</span></td>
            <td></td>
        </tr>
         <tr style="height: 0px;">
            <td style="width:191.15pt;"></td>
            <td style="width:276.35pt"></td>
        </tr>
         </table>
                <p style="text-align: center;font-family: times New Roman;font-size: 16pt; font-weight: bold; margin: 4pt 0pt 3pt 0pt;">BÁO CÁO</p>
                <p style="text-align: center;font-size: 12pt; font-weight: bold; margin: 0pt 0pt 3pt 0pt;">TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ; XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</p>
                <p  style="font-family: times New Roman; font-size: 14pt;text-align: center; font-weight: bold; margin: 0pt;"><span style="color: #ffffff;">..</span>Tháng '||v_Month||' năm '||v_year||'</p>
                <p style="font-family: times New Roman; font-size: 14pt; text-align: justify; line-height: 130%">Kính gửi: Văn phòng Tòa án nhân dân tối cao</p>
                <p style="font-family: times New Roman; font-size: 14pt;text-align: justify; line-height: 130%">
                    <span style="color: #ffffff;">...........</span>Thực hiện chỉ đạo của Lãnh đạo Tòa án nhân dân tối cao về việc thực hiện báo cáo công tác hàng tháng của cơ quan Tòa án nhân dân tối 
                    cao, Vụ Giám đốc, kiểm tra '||UPPER(LAST_NAME_PHONGBAN)||'  (Vụ '||UPPER(LAST_NAME_PHONGBAN)||') báo cáo kết quả về tình hình thực hiện công tác tháng 
                    '||v_Month||' năm '||v_year||' (số liệu từ ngày '||TO_CHAR(vvTuNgay,'dd/MM/yyyy')||' đến ngày '||TO_CHAR(vvDenNgay,'dd/MM/yyyy')||') như sau:</p>
                   <p style="font-family: times New Roman; font-size: 14pt;text-align: left; line-height: 150%; margin-left: 40pt;">');
                    FOR item IN( 
                                SELECT SUM(PA.CU_CON_LAI_VU)CU_CON_LAI_VU,SUM(PA.CU_CON_LAI_DON)CU_CON_LAI_DON,
                                SUM(PA.MOI_THU_LY_VU)MOI_THU_LY_VU,SUM(PA.MOI_THU_LY_DON)MOI_THU_LY_DON FROM TABLE(v_table) PA
                              )
                    LOOP            
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <strong>1.<span style="color: #ffffff;">....</span>Tình hình giải quyết đơn đề nghị giám đốc thẩm, tái thẩm.</strong><br />
                    <strong>1.1.<span style="color: #ffffff;">....</span>Thụ lý đơn đề nghị giám đốc thẩm, tái thẩm.</strong>
                    <br />
                    - Tổng số án phải giải quyết: '||(item.CU_CON_LAI_VU+item.MOI_THU_LY_VU)||' vụ: ('||(item.CU_CON_LAI_DON+item.MOI_THU_LY_DON)||' đơn)<br />
                    + Cũ còn lại: '||item.CU_CON_LAI_VU||' vụ ('||item.CU_CON_LAI_DON||' đơn);<br />
                    + Mới thụ lý: '||item.MOI_THU_LY_VU||' vụ ('||item.MOI_THU_LY_DON||' đơn);<br />
                     - Số liệu cụ thể các loại án như sau:<br />'
                    );
                    END LOOP;
                    FOR item IN( 
                                SELECT PA.LOAIAN_ID,PA.LOAIAN_TEN,SUM(PA.CU_CON_LAI_VU+PA.MOI_THU_LY_VU)TONG_LOAI_AN,  
                                SUM(PA.CU_CON_LAI_DON+PA.MOI_THU_LY_DON)TONG_DON
                                FROM TABLE(v_table) PA  WHERE PA.LOAIAN_ID !=0
                                GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN
                              )
                    LOOP                     
                       DBMS_LOB.APPEND(V_EXPORT_TEXT,'+ Án '||item.LOAIAN_TEN||': '||item.TONG_LOAI_AN||' vụ ('||item.TONG_DON||' đơn); <br /> ');
                    END LOOP;
                    FOR item IN( 
                                SELECT SUM(PA.KHANGNGHI+PA.TRALOIDON+PA.XEPDON+PA.XULY_KHAC+PA.XEPDON_VKS)TONG_GQ,SUM(PA.KHANGNGHI_DON+PA.TRALOIDON_DON+PA.XEPDON_DON+PA.XULY_KHAC_DON)TONG_GQ_DON FROM TABLE(v_table) PA
                              )
                    LOOP       
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <strong>1.2.<span style="color: #ffffff;">....</span>	Kết quả giải quyết.</strong><br />
                    <i>a)<span style="color: #ffffff;">....</span>Đã giải quyết xong: '||item.TONG_GQ||' vụ của '||item.TONG_GQ_DON||' đơn cụ thể:</i><br />
                    ');
                    END LOOP;
                    FOR item IN( 
                           SELECT TT.LOAIAN_ID,TT.LOAIAN_TEN,TT.TONG_GQ,TT.TONG_GQ_DON,
                           DECODE(TT.KHANGNGHI,0,'',' kháng nghị: '||TT.KHANGNGHI||' vụ')||DECODE(TT.KHANGNGHI_DON,0,'',' của '||TT.KHANGNGHI_DON||' đơn; ')||--DECODE(DECODE(TT.KHANGNGHI_DON,0,' ',' của '||TT.KHANGNGHI_DON||' đơn; '),' ','; ',DECODE(TT.KHANGNGHI_DON,0,' ',' của '||TT.KHANGNGHI_DON||' đơn; '))||
                           DECODE(TT.TRALOIDON,0,'',' trả lời đơn: '||TT.TRALOIDON||' vụ')||DECODE(TT.TRALOIDON_DON,0,'',' của '||TT.TRALOIDON_DON||' đơn; ')||
                           DECODE(TT.XEPDON_VKS,0,'',' Viện kiểm sát giải quyết: '||TT.XEPDON_VKS||' vụ')||DECODE(TT.XEPDON_VKS_DON,0,'',' của '||TT.XEPDON_VKS_DON||' đơn; ')||
                           DECODE(TT.XEPDON,0,'',' xếp đơn: '||TT.XEPDON||' vụ')||DECODE(TT.XEPDON_DON,0,'',' của '||TT.XEPDON_DON||' đơn; ')||
                           DECODE(TT.XULY_KHAC,0,'',' xử lý khác: '||TT.XULY_KHAC||' vụ')||DECODE(TT.XULY_KHAC_DON,0,'',' của '||TT.XULY_KHAC_DON||' đơn; ')
                           DETAIL_ALL
                           FROM (
                                SELECT PA.LOAIAN_ID,PA.LOAIAN_TEN,SUM(PA.KHANGNGHI+PA.TRALOIDON+PA.XEPDON+PA.XULY_KHAC+PA.XEPDON_VKS)TONG_GQ,
                                SUM(PA.KHANGNGHI_DON+PA.TRALOIDON_DON+PA.XEPDON_DON+PA.XULY_KHAC+PA.XEPDON_VKS)TONG_GQ_DON,
                                SUM(PA.KHANGNGHI_DON)KHANGNGHI_DON, SUM(NVL(PA.TRALOIDON_DON,0))TRALOIDON_DON, SUM(PA.XEPDON_DON)XEPDON_DON,
                                SUM(PA.KHANGNGHI)KHANGNGHI, SUM(NVL(PA.TRALOIDON,0))TRALOIDON, SUM(PA.XEPDON)XEPDON,
                                SUM(PA.XEPDON_VKS) XEPDON_VKS,SUM(PA.XEPDON_VKS_DON)XEPDON_VKS_DON,
                                SUM(PA.XULY_KHAC)XULY_KHAC,SUM(PA.XULY_KHAC_DON)XULY_KHAC_DON
                                FROM TABLE(v_table) PA
                                GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN
                                )TT
                              )
                    LOOP              
                        IF(item.TONG_GQ!=0)THEN
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'- '||item.LOAIAN_TEN||': '||item.TONG_GQ||' vụ của '||item.TONG_GQ_DON||' đơn ('||item.DETAIL_ALL||')<br />');

                        END IF;
                    END LOOP;
                    --------
                    FOR item IN( 
                                SELECT SUM(CHUA_CO_KQGQ)CHUA_CO_KQGQ,SUM(CHUA_CO_KQGQ_DON)CHUA_CO_KQGQ_DON FROM TABLE(v_table) PA
                              )
                    LOOP   
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'<i>b) Chưa có kết quả giải quyết: '||item.CHUA_CO_KQGQ||' vụ của '||item.CHUA_CO_KQGQ_DON||' đơn</i><br />
                    ');
                    END LOOP;
                    -------
                    FOR item IN( 
                            SELECT SUM(T.DANG_TRINH)DANG_TRINH,SUM(T.DANG_TRINH_THANG)DANG_TRINH_THANG FROM (
                              SELECT COUNT(*)DANG_TRINH,SUM(0)DANG_TRINH_THANG FROM  TABLE(v_table_ld) PA WHERE PA.LOAI_THANG=0
                              UNION ALL 
                              SELECT SUM(0)DANG_TRINH,COUNT(*)DANG_TRINH_THANG FROM  TABLE(v_table_ld) PA WHERE PA.LOAI_THANG=1 
--                              AND PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(PA.VUANID,vvTuNgay,vvDenNgay)>0
                              )T
                            )
                    LOOP         

                   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    - Đã nghiên cứu xong hồ sơ, đang trình: '||item.DANG_TRINH||' vụ (Trình thẩm phán lần 1 được '||item.DANG_TRINH_THANG||' vụ) gồm: <br />');

                   END LOOP;
                        --------
                     FOR item_child IN( 
                              SELECT DECODE(TT.TINHTRANGID_VU,0,NULL,' <span style="color: #ffffff;">......</span> - '||TT.TENTINHTRANG ||': '||TT.TINHTRANGID_VU|| ' vụ <br />')DETAIL_DANG_TRINH
                                FROM (
                                    SELECT TR.TENTINHTRANG,COUNT(*)TINHTRANGID_VU FROM TABLE(v_table_ld) PA
                                    INNER JOIN (SELECT TR1.ID,TR1.TENTINHTRANG,TR1.GIAIDOAN,DECODE(TR1.ID,6,50,17,1,8,2,9,3,7,4,TR1.THUTU)THUTU FROM GDTTT_DM_TINHTRANG TR1) TR ON TR.ID=PA.TINHTRANGID
                                    WHERE PA.TINHTRANGID NOT IN(4,5) AND PA.LOAI_THANG=0
                                    GROUP BY TR.TENTINHTRANG,TR.GIAIDOAN,TR.THUTU ORDER BY TR.GIAIDOAN,TR.THUTU
                               )TT
                        )
                          LOOP
                                IF(item_child.DETAIL_DANG_TRINH IS NOT NULL)THEN
                                  DBMS_LOB.APPEND(V_EXPORT_TEXT,item_child.DETAIL_DANG_TRINH);
                                END IF;
                           END LOOP;  
                    -------
                     FOR item_tham_phan IN (
                          SELECT CC2.HOTEN,PA1.TONG_VU FROM (
                          SELECT PA.LANHDAOID,COUNT(*)TONG_VU FROM TABLE(v_table_ld) PA WHERE PA.TINHTRANGID=6 AND PA.LOAI_THANG=0 GROUP BY PA.LANHDAOID )PA1 
                          INNER JOIN (SELECT CC.ID,CC.HOTEN,SUBSTR(CC.HOTEN,INSTR(CC.HOTEN,' ',-1)+ 1) AS LAST_NAME FROM DM_CANBO CC )CC2 ON PA1.LANHDAOID=CC2.ID         
                          ORDER BY CC2.LAST_NAME
                     )
                     LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <i> <span style="color: #ffffff;">......</span>● Thẩm phán '||item_tham_phan.HOTEN||': '||item_tham_phan.TONG_VU||' vụ</i><br />
                    ');
                    END LOOP;
                    --số lượng thẩm phán không xác định trong vụ án
                     FOR item_check IN(
                                     SELECT COUNT(*)LANHDAOID_COUNT FROM TABLE(v_table_ld) LD 
                                     WHERE LD.TINHTRANGID=6 AND LD.LANHDAOID=0 AND LD.LOAI_THANG=0
                               )
                        LOOP
                            IF(item_check.LANHDAOID_COUNT>0)THEN
                            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                           <i> <span style="color: #ffffff;">......</span>● Thẩm phán không xác định: '||item_check.LANHDAOID_COUNT||' vụ</i><br />
                            ');
                            FOR item_ IN (
                                    SELECT DECODE(trim(VA1.SOANSOTHAM),NULL,VA1.SOANPHUCTHAM,VA1.SOANSOTHAM)SO_BA FROM GDTTT_VuAn VA1 
                                        WHERE VA1.PhongBanId=vPhongBanID and va1.TOAANID=vToaAnID
                                        AND EXISTS (SELECT 'X' FROM TABLE(v_table_ld) LD WHERE LD.TINHTRANGID=6 AND LD.LANHDAOID=0 AND LD.LOAI_THANG=0 AND VA1.ID=LD.VUANID)

                                  )
                            LOOP
                                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                 <i> <span style="color: #ffffff;">.......</span>  + Số bản án/quyết định: '||item_.SO_BA||'</i><br />
                                ');
                            END LOOP;
                            END IF;
                       END LOOP;
                       -------tách TR.ID IN(4,5) vụ trưởng và phó vụ trưởng xuống dưới
--                     FOR item_child IN( 
--                              SELECT DECODE(TT.TINHTRANGID_VU,0,NULL,'<span style="color: #ffffff;">......</span> - '||TT.TENTINHTRANG ||': '||TT.TINHTRANGID_VU|| ' vụ <br />')DETAIL_DANG_TRINH
--                                FROM (
--                                    SELECT TR.TENTINHTRANG,COUNT(*)TINHTRANGID_VU FROM TABLE(v_table_ld) PA
--                                    INNER JOIN (SELECT TR1.ID,TR1.TENTINHTRANG,TR1.GIAIDOAN,DECODE(TR1.ID,6,50,5,30,4,31,TR1.THUTU)THUTU FROM GDTTT_DM_TINHTRANG TR1) TR ON TR.ID=PA.TINHTRANGID
--                                    WHERE PA.TINHTRANGID IN(4,5) AND PA.LOAI_THANG=0
--                                    GROUP BY TR.TENTINHTRANG,TR.GIAIDOAN,TR.THUTU ORDER BY TR.GIAIDOAN,TR.THUTU
--                               )TT
--                        )
--                          LOOP
--                                IF(item_child.DETAIL_DANG_TRINH IS NOT NULL)THEN
--                                  DBMS_LOB.APPEND(V_EXPORT_TEXT,item_child.DETAIL_DANG_TRINH);
--                                END IF;
--                           END LOOP;  
                     FOR item IN( 
                                SELECT SUM(CHUA_CO_KQGQ-DANG_TRINH)DANG_NGHIEN_CUU FROM (
                                    SELECT SUM((PA.CU_CON_LAI_VU+PA.MOI_THU_LY_VU)-(PA.KHANGNGHI+PA.TRALOIDON+PA.XEPDON+PA.XEPDON_VKS+PA.XULY_KHAC))CHUA_CO_KQGQ,SUM(0)DANG_TRINH FROM TABLE(v_table) PA
                                    UNION ALL                                
                                    SELECT SUM(0)CHUA_CO_KQGQ,COUNT(*)DANG_TRINH FROM TABLE(v_table_ld) PA WHERE PA.LOAI_THANG=0
                                    )T
                              )
                    LOOP          
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'                  
                    - Đang nghiên cứu: '||item.DANG_NGHIEN_CUU||' vụ<br />
                    <strong>1.3.<span style="color: #ffffff;">....</span>	Tình hình giải quyết các loại án cụ thể:</strong><br />
                    ');
                     END LOOP;
                     FOR item IN( 
                            SELECT CC1.LOAIAN_ID,CC1.LOAIAN_TEN,(CC1.DANG_TRINH+CC2.DANG_NGHIEN_CUU) TONG_LOAI_AN,(CC1.DANG_TRINH)DANG_TRINH,CC2.DANG_NGHIEN_CUU
                            FROM (SELECT PA.LOAIAN_ID,PA.LOAIAN_TEN,COUNT(*) DANG_TRINH FROM TABLE(v_table_ld) PA WHERE PA.LOAI_THANG=0 GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN)CC1
                            INNER JOIN (SELECT PA1.LOAIAN_ID, SUM(PA1.DANG_NGHIEN_CUU)DANG_NGHIEN_CUU FROM TABLE(v_table) PA1 GROUP BY PA1.LOAIAN_ID)CC2  ON CC1.LOAIAN_ID=CC2.LOAIAN_ID
                            ORDER BY LOAIAN_ID
                            )
                    LOOP   
                         v_dem:=v_dem+1;
                         ---tạo chỉ mục a-z
                         SELECT TT.AZ INTO V_AZ FROM (
                             select chr( ascii('a')+level-1 )AZ from dual connect by level <= v_dem ORDER BY AZ DESC
                             )TT WHERE ROWNUM=1;
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                          <i>'||V_AZ||', Án '||item.LOAIAN_TEN||':</i><br />
                        - Tổng số án phải giải quyết: '||item.TONG_LOAI_AN||' vụ.<br />
                        - Đang trình: '||item.DANG_TRINH||'  vụ; trong đó:<br />
                        ');
                              FOR item_child IN( 
                                       SELECT DECODE(TT.TINHTRANGID_VU,0,NULL,' <span style="color: #ffffff;">......</span> - '||TT.TENTINHTRANG ||': '||TT.TINHTRANGID_VU|| ' vụ <br />')DETAIL_DANG_TRINH
                                      FROM (
                                          SELECT TR.TENTINHTRANG,COUNT(*)TINHTRANGID_VU FROM TABLE(v_table_ld) PA
                                          INNER JOIN (SELECT TR1.ID,TR1.TENTINHTRANG,TR1.GIAIDOAN,DECODE(TR1.ID,6,50,5,51,4,52,TR1.THUTU)THUTU FROM GDTTT_DM_TINHTRANG TR1) TR ON TR.ID=PA.TINHTRANGID
                                          WHERE PA.LOAIAN_ID=item.LOAIAN_ID AND PA.LOAI_THANG=0
                                          GROUP BY TR.TENTINHTRANG,TR.GIAIDOAN,TR.THUTU ORDER BY TR.GIAIDOAN,TR.THUTU
                                      )TT
                            )
                            LOOP
                               IF(item_child.DETAIL_DANG_TRINH IS NOT NULL)THEN
                                      DBMS_LOB.APPEND(V_EXPORT_TEXT,item_child.DETAIL_DANG_TRINH);
                                    END IF;
                             END LOOP;  
                              DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         - Đang nghiên cứu: '||item.DANG_NGHIEN_CUU||' vụ<br />
                        ');
                       END LOOP;  
                     FOR item IN(
                           SELECT SUM(PA.CU_CON_LAI_VU_XX+PA.MOI_THU_LY_VU_XX)TONG_XETXU,SUM(PA.DA_XX)DA_XX FROM TABLE(v_table) PA
                        )
                       LOOP
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <strong>2.<span style="color: #ffffff;">....</span>Tình hình xét xử giám đốc thẩm, tái thẩm.</strong><br />
                        - Tổng số vụ án phải xét xử: '||item.TONG_XETXU||' vụ 
                      ');
                      ----------------------------
                         SELECT SUM(PA.CU_CON_LAI_VU_XX)INTO CU_CON_LAI_VU_XX_TONG FROM TABLE(v_table) PA 
                         WHERE PA.CU_CON_LAI_VU_XX!=0;
                      ----------------------------
                         SELECT SUM(PA.MOI_THU_LY_VU_XX) INTO MOI_THU_LY_VU_XX_TONG FROM TABLE(v_table) PA 
                           WHERE PA.MOI_THU_LY_VU_XX!=0;
                      -----------------------------     
                          FOR item_detai IN (
                                SELECT '('||LISTAGG(TT.CHITIET ,'; ') WITHIN GROUP (ORDER BY TT.CHITIET)||')'CHITIET  FROM (
                                    SELECT DECODE(CU_CON_LAI_VU_XX_TONG,NULL,NULL,'Cũ còn lại '||CU_CON_LAI_VU_XX_TONG||' vụ án: ')||LISTAGG(T.LOAIAN_TEN||' '||T.CU_CON_LAI_VU_XX||' vụ', ', ') WITHIN GROUP (ORDER BY LOAIAN_TEN)CHITIET 
                                     FROM (     
                                     SELECT PA.LOAIAN_TEN,SUM(PA.CU_CON_LAI_VU_XX)CU_CON_LAI_VU_XX FROM TABLE(v_table) PA 
                                     WHERE PA.CU_CON_LAI_VU_XX!=0
                                     GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN
                                     )T
                                    UNION ALL
                                    SELECT DECODE(MOI_THU_LY_VU_XX_TONG,NULL,NULL,'Mới thụ lý '||MOI_THU_LY_VU_XX_TONG||' vụ án: ')||LISTAGG(T.LOAIAN_TEN||' '||T.MOI_THU_LY_VU_XX||' vụ', ', ') WITHIN GROUP (ORDER BY LOAIAN_TEN)CHITIET 
                                     FROM (     
                                     SELECT PA.LOAIAN_TEN,SUM(PA.MOI_THU_LY_VU_XX)MOI_THU_LY_VU_XX FROM TABLE(v_table) PA 
                                     WHERE PA.MOI_THU_LY_VU_XX!=0
                                     GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN
                                  )T
                                )TT
                              )
                           LOOP
                           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                             '||item_detai.CHITIET||'<br/>
                           ');
                      END LOOP;
                      -------------
                       SELECT  '- Đã xét xử '||item.DA_XX||' vụ: ('||LISTAGG(T.LOAIAN_TEN||' '||T.DA_XX||' vụ', ', ') WITHIN GROUP (ORDER BY LOAIAN_TEN)||')' INTO DA_XX_ITEM 
                                     FROM (     
                                     SELECT PA.LOAIAN_TEN,SUM(PA.DA_XX)DA_XX FROM TABLE(v_table) PA 
                                     WHERE PA.DA_XX!=0
                                     GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN
                                      )T;
                      -------------
                       SELECT  '- Còn lại '||(item.TONG_XETXU-item.DA_XX)||' vụ: ('||LISTAGG(T.LOAIAN_TEN||' '||T.CON_LAI_XX||' vụ', ', ') WITHIN GROUP (ORDER BY LOAIAN_TEN)||')' INTO CON_LAI_XX_ITEM 
                                     FROM (     
                                     SELECT PA.LOAIAN_TEN,SUM(PA.CON_LAI_XX)CON_LAI_XX FROM TABLE(v_table) PA 
                                     WHERE PA.CON_LAI_XX!=0
                                     GROUP BY PA.LOAIAN_ID,PA.LOAIAN_TEN
                                      )T;
                      -------------
                       DBMS_LOB.APPEND(V_EXPORT_TEXT,DA_XX_ITEM||'<br />'
                        ||CON_LAI_XX_ITEM||' trong đó:<br />
                        ');
                       END LOOP;
                      DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    +…….vụ Vụ '||UPPER(LAST_NAME_PHONGBAN)||' đã lập danh sách trình Hội đồng thẩm phán trong tháng ..... (trình Hội đồng Toàn thể …… vụ; trình Hội đồng 05 thành viên ....... vụ).<br />
                    + …. vụ hoãn phiên tòa để xác minh, nghiên cứu lại quy định của pháp luật;<br />
                    + ……. vụ nghiên cứu lại trình Tổ thẩm phán;<br />
                    + …….. vụ trình Thẩm phán kết quả xác minh.<br />
                    <strong>3.<span style="color: #ffffff;">....</span>Giải quyết Công văn trao đổi nghiệp vụ:</strong><br />
                    ');
                    FOR item IN (
                          SELECT DECODE(T.TONG_CV,0,'',T.TONG_CV||' Công văn (')||
                          DECODE(T.MƠITHULY,0,'','mới thụ lý '||T.MƠITHULY||', ')|| 
                          'cũ còn lại '|| T.CUCONLAI||     
                          DECODE(T.TONG_CV,0,'','),')||
                          DECODE(T.KETQUA,0,' ',case when T.KETQUA<10 then ' 0'||T.KETQUA else ', '||T.KETQUA end||' Công văn đã có kết quả,'  )||
                          DECODE(T.DATRINH,0,' ',case when T.DATRINH<10 then ' 0'||T.DATRINH else ', '||T.DATRINH end||' đang trình')||
                          DECODE(T.CONLAI,0,' ',case when T.CONLAI<10 then ' 0'||T.CONLAI else ', '||T.CONLAI end||' Công văn Thẩm tra viên đang nghiên cứu.')
                          CHITIET,
                          T.DATRINH--select case when &n<10 then '0'||to_char(&n) else ''||to_char(&n) end from dual;
                          FROM (
                              SELECT SUM(TRAODOI_KQ+TRAODOI_CONLAI+PA.TRAODOI_CUCONLAI_DA_COKQ+TRAODOI_CUCONLAI_DATRINH)TONG_CV,SUM(PA.TRAODOI_CUCONLAI+PA.TRAODOI_CUCONLAI_DATRINH+PA.TRAODOI_CUCONLAI_DA_COKQ)CUCONLAI,
                              SUM(PA.TRAODOI_MOI+PA.TRAODOI_MOI_DATRINH)MƠITHULY,SUM(PA.TRAODOI_KQ)KETQUA,
                              SUM(PA.TRAODOI_CUCONLAI_DATRINH+PA.TRAODOI_MOI_DATRINH)DATRINH,
                              SUM(PA.TRAODOI_CONLAI)CONLAI
                              FROM  TABLE(v_table) PA
                              )T
                        )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        Số công văn trao đổi nghiệp vụ thuộc thẩm quyền giải quyết là: '||item.CHITIET||' <br />
                        ');
--                       -----------chi tiet cũ còn lại đã trình + chi tiet mới thụ lý đã trình
--                     IF(item.DATRINH>0)THEN
--                           FOR item_chitiet IN (
--                            SELECT '<span style="color: #ffffff;">....</span>- Công văn trao đổi đã trình gồm: <br/><span style="color: #ffffff;">....</span>● '||LISTAGG(TT.TENTINHTRANG ,'<br /><span style="color: #ffffff;">....</span>● ') WITHIN GROUP (ORDER BY TT.TENTINHTRANG)CHITIET_TRINH  FROM (
--                                    SELECT COUNT(*)||' Công văn '||TG.TENTINHTRANG ||' '||CB.HOTEN TENTINHTRANG FROM (
--                                            SELECT TD.* FROM GDTTT_VUAN_TRAODOICONGVAN TD
--                                            WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
--                                            AND  (NVL(TD.ISKETQUAGQ,0)=0) AND EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID) 
--                                            AND TD.NGAYTHULY <=vvTuNgay-1
--                                             UNION ALL
--                                            SELECT TD.* FROM GDTTT_VUAN_TRAODOICONGVAN TD
--                                            WHERE TD.DONVIID=vToaAnID AND TD.PHONGBANID=VPHONGBANID 
--                                            AND TD.NGAYTHULY >=vvTuNgay AND TD.NGAYTHULY <=vvDenNgay
--                                            AND (NVL(TD.ISKETQUAGQ,0)=0) AND EXISTS (SELECT R.* FROM GDTTT_TRAODOICV_TOTRINH R WHERE R.CONGVANID=TD.ID) 
--                                        )T 
--                                    INNER JOIN GDTTT_TRAODOICV_TOTRINH TR ON TR.CONGVANID=T.ID
--                                    LEFT JOIN GDTTT_DM_TINHTRANG TG ON TG.ID=TR.TINHTRANGID
--                                    LEFT JOIN DM_CANBO CB ON CB.ID=TR.LANHDAOID
--                                    GROUP BY TG.TENTINHTRANG,CB.HOTEN
--                              )TT
--                         )
--                         LOOP
--                           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--                            '||item_chitiet.CHITIET_TRINH||'<br />
--                            ');
--                          END LOOP;
--                    END IF;
                    END LOOP;
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <strong>4.<span style="color: #ffffff;">....</span>Kiến nghị, đề xuất:</strong><br />
                </p>
          <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
       <tr>
            <td><br />
                <p style="font-size: 12pt; text-align: left;margin-left: 40pt;line-height: 105%;">
                    <i><strong>Nơi nhận:</strong></i> <br />                   
                    - Như kính gửi;<br />
                    - Đ/c .................. PCA TANDTC (để b/c);<br />
                    - Vụ trưởng Vụ GĐKT '||UPPER(LAST_NAME_PHONGBAN)||';<br />
                    - Lưu: Vu '||UPPER(LAST_NAME_PHONGBAN)||'<br />
                     <i style="font-size: 9pt;">('||to_char(sysdate,'dd/MM/yyyy HH:mm:ss')||')</i><br />
                    <br />
                </p>
            </td>
            <td>
               <p><strong>VỤ TRƯỞNG</strong></p><br /><br /><br /><br /><br /><br />
            </td>
        </tr>
        <tr>
            <td></td>
            <td> 
            ');
            FOR item_vt IN (
               select a.HOTEN from DM_CANBO a
                inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=(select aa.ID from DM_DATAGROUP aa where aa.MA='CHUCDANH') ) b on b.ID=a.CHUCDANHID
                inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c  where c.GROUPID=(select cc.ID from DM_DATAGROUP cc where cc.MA='CHUCVU') and c.MA='VT') d on d.ID=a.CHUCVUID
                where ROWNUM =1 AND a.TOAANID=vToaAnID and a.PHONGBANID=vPhongBanID  And a.HIEULUC=1
                )
               LOOP
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <p><strong>'||item_vt.HOTEN||'</strong></p>
                ');
                END LOOP;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            </td>
        </tr>
           ');
     -----------
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
       <tr style="height: 0px;">
            <td style="width: 276.35pt"></td>
             <td style="width: 191.15pt;"></td>
        </tr>
   </table>
    ');
    --------Insert vao bang báo cáo----------
    --  vvTuNgay date;vvDenNgay date;V_TONG_GQ NUMBER;V_TONG_GQ_ID CLOB;V_CHUA_CO_KQGQ NUMBER;V_CHUA_CO_KQGQ_ID CLOB;
    SELECT SUM(PA.KHANGNGHI+PA.TRALOIDON+PA.XEPDON+PA.XULY_KHAC+PA.XEPDON_VKS),SUM(PA.CHUA_CO_KQGQ) INTO V_TONG_GQ,V_CHUA_CO_KQGQ FROM TABLE(v_table) PA;
    --đã có kết quả giải quyết
     SELECT --LISTAGG(VA.ID,',') WITHIN GROUP(ORDER BY VA.ID)
     RTRIM (XMLAGG (XMLELEMENT (e, VA.ID,',') ORDER BY VA.ID).EXTRACT ( '//text()').getCLOBVal(),',')
     INTO V_TONG_GQ_ID FROM (
     SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                  WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                  WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                  END GQD_NGACVS
    FROM GDTTT_VUAN TA) VA
    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID and VA.ISVIENTRUONGKN  is null
    AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
    AND  VA.NGAYTAO<=vvDenNgay 
    AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA in (0,1,2,3,4);
   ---------chưa có kết quả giải quyết
          SELECT  RTRIM (XMLAGG (XMLELEMENT (e, MM.ID,',') ORDER BY MM.ID).EXTRACT ( '//text()').getCLOBVal(),',')INTO V_CHUA_CO_KQGQ_ID
                                FROM  (
                                 --cũ còn lại vụ 
                                SELECT  TL.* FROM (
                                SELECT VA.*, CASE WHEN (VA.GQD_NGAYPHATHANHCV IS NOT NULL AND VA.GDQ_NGAY IS NOT NULL)  THEN  VA.GQD_NGAYPHATHANHCV 
                                                  WHEN ( VA.GQD_NGAYPHATHANHCV IS  NULL AND VA.GDQ_NGAY IS NOT NULL)  THEN  VA.GDQ_NGAY 
                                                  WHEN (VA.GQD_NGAYPHATHANHCV IS NOT NULL AND VA.GDQ_NGAY IS NULL) THEN  VA.GQD_NGAYPHATHANHCV 
                                                 END GQD_NGACVS
                                            FROM GDTTT_VUAN VA
                                    WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID  and VA.ISVIENTRUONGKN is null
                                    AND VA.NGAYTAO<vvTuNgay
                                )TL WHERE TL.GQD_LOAIKETQUA IS NULL OR (TL.GQD_LOAIKETQUA IS not NULL and TL.GQD_NGACVS >=vvTuNgay)  
                                UNION ALL    
                                --Mới thụ lý vụ
                                SELECT VA.*,NULL GQD_NGACVS FROM GDTTT_VUAN VA
                                 WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID 
                                 AND VA.NGAYTAO>=vvTuNgay AND VA.NGAYTAO<=vvDenNgay
                                 and VA.ISVIENTRUONGKN is null
                        )MM
                         WHERE NOT EXISTS
                            (
                                 SELECT 'X' FROM (
                                 SELECT TA.*,CASE WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GQD_NGAYPHATHANHCV 
                                              WHEN ( TA.GQD_NGAYPHATHANHCV IS  NULL AND TA.GDQ_NGAY IS NOT NULL)  THEN  TA.GDQ_NGAY 
                                              WHEN (TA.GQD_NGAYPHATHANHCV IS NOT NULL AND TA.GDQ_NGAY IS NULL) THEN  TA.GQD_NGAYPHATHANHCV 
                                              END GQD_NGACVS
                                FROM GDTTT_VUAN TA) VA
                                WHERE VA.TOAANID=vToaAnID AND VA.PHONGBANID=VPHONGBANID and VA.ISVIENTRUONGKN  is null
                                AND (VA.GQD_NGACVS >=vvTuNgay) AND (vA.GQD_NGACVS <=vvDenNgay)
                                AND  VA.NGAYTAO<=vvDenNgay 
                                AND VA.GQD_LOAIKETQUA is not null AND VA.GQD_LOAIKETQUA in (0,1,2,3,4)
                                AND MM.ID=VA.ID
                            )
                    ;     
          INSERT INTO BC_GQ_DONDN_GDTTT
          (PHONGBANID,BC_TUNGAY,BC_DENNGAY,NGAYTAO,TONG_GQ,TONG_GQ_ID,CHUA_CO_KQGQ,CHUA_CO_KQGQ_ID)
          VALUES(vPhongBanID,vvTuNgay,vvDenNgay,SYSDATE,V_TONG_GQ,V_TONG_GQ_ID,V_CHUA_CO_KQGQ,V_CHUA_CO_KQGQ_ID);
          COMMIT;
          ---------------
        OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;
--       SELECT SUM(PA.CU_CON_LAI_VU)CU_CON_LAI_VU,SUM(PA.CU_CON_LAI_DON)CU_CON_LAI_DON,
--       SUM(PA.MOI_THU_LY_VU)MOI_THU_LY_VU,SUM(PA.MOI_THU_LY_DON)MOI_THU_LY_DON FROM TABLE(v_table) PA;
--       SELECT V_TONG_GQ TONG_GQ,V_TONG_GQ_ID TONG_GQ_ID,V_CHUA_CO_KQGQ CHUA_CO_KQGQ,V_CHUA_CO_KQGQ_ID CHUA_CO_KQGQ_ID FROM dual;
        RETURN V_CURSOR;  
END BC_GQ_DONDN_GDTTT;
FUNCTION BC_GET
(
    vPhongBanID  in number,
    vTuNgay in VARCHAR2
)
 RETURN SYS_REFCURSOR
 IS
  V_CURSOR sys_refcursor;
BEGIN
      OPEN V_CURSOR FOR
            SELECT TO_CHAR(BC.NGAYTAO,'dd/MM/yyyy hh24:mi:ss') NGAYTAOS ,BC.* 
            FROM BC_GQ_DONDN_GDTTT BC 
            WHERE TO_CHAR(BC.BC_TUNGAY,'dd/MM/yyyy')=vTuNgay  and BC.PHONGBANID=vPhongBanID
            ORDER BY BC.NGAYTAO
            FETCH FIRST 1 ROWS ONLY;
       RETURN V_CURSOR;   
END;
END PKG_BC_GQ_DONDN_GDTTT;
