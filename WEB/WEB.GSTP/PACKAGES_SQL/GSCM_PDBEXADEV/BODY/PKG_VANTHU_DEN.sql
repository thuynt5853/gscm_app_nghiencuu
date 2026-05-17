--------------------------------------------------------
--  DDL for Package Body PKG_VANTHU_DEN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VANTHU_DEN" AS
PROCEDURE  VT_HUY_NHAN_IN_DELETE
( 
  V_VANBANDEN_ID IN VARCHAR2 
)
IS  
      V_TRANG_THAI_XLY NUMBER; V_GDTTT_DON_ID NUMBER;
BEGIN
       SELECT TRANG_THAI_XLY,GDTTT_DON_ID INTO V_TRANG_THAI_XLY,V_GDTTT_DON_ID FROM VT_CHUYEN_NHAN cn WHERE cn.VANBANDEN_ID=V_VANBANDEN_ID;
       --V_TRANG_THAI_XLY =3 HCTP chưa xử lý, V_TRANG_THAI_XLY =4 HCTP đã xử lý
      -- IF(V_TRANG_THAI_XLY =4) THEN 
         UPDATE VT_CHUYEN_NHAN
            SET  CANBO_NHAN_ID=NULL,NGAY_NHAN=NULL,TRANG_THAI_XLY=NULL,GDTTT_DON_ID=NULL,USERNAME_NHAN=NULL
            WHERE VANBANDEN_ID=V_VANBANDEN_ID;
          ------------   
          DELETE GDTTT_DON_DS_KN_CC WHERE DONID=V_GDTTT_DON_ID;         
          DELETE GDTTT_DON_DUONGSU_TOIDANH_CC WHERE DONID=V_GDTTT_DON_ID;
          DELETE GDTTT_DON_DUONGSU_CC WHERE DONID=V_GDTTT_DON_ID;
          DELETE GDTTT_DON WHERE ID=V_GDTTT_DON_ID; 
          ------------
   --    END IF;
END VT_HUY_NHAN_IN_DELETE;

PROCEDURE VT_DEN_INS_UP
    (
    V_ID	in	NUMBER,
    V_LOAI_VB	in	NUMBER,
    V_SODEN	in	NUMBER,
    V_NGAY_DEN	in	DATE,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    V_DIACHI_GUI_BT	in	VARCHAR2,
    V_NGAY_BT	in	DATE,
    V_NOI_NHAN	in	NUMBER,
    V_NGUOI_NHAN	in	NUMBER,
    V_GHICHU	in	VARCHAR2,
    V_SO_VB	in	VARCHAR2,
    V_NGAY_VB	in	DATE,
    V_NOIDUNG_VB	in	VARCHAR2,
    V_SOLUONG_DON	in	NUMBER,

    V_LOAI_GDTTTT	in	NUMBER, 
    V_BAQD_CHECK_DON	in	NUMBER,
    V_LOAI_AN_DON	in	NUMBER,
    V_CAP_XX_DON	in	NUMBER,
    V_SO_BAQD_DON	in	VARCHAR2,
    V_NGAY_BAQD_DON	in	DATE,
    V_TOAAN_BAQD_DON in	NUMBER,

    V_BIDON	in	VARCHAR2,
    V_NGUYENDON	in	VARCHAR2,
    V_QHPL_DS	in	VARCHAR2,
    V_QHPL_HS in	NUMBER,
    V_SOLUONG_GAM in	NUMBER,

    V_SO_CV	in	VARCHAR2,
    V_NGAY_CV	in	DATE,
    V_DONVICHUYEN_CV	in	VARCHAR2,
    V_NOIDUNG_CV	in	VARCHAR2,

    V_DVXULY_ID_DON	in	NUMBER,
    V_CANBONHAN_ID	in	NUMBER,
    V_NGAY_GIAO_DON	in	DATE,

    V_SO_HS	in	VARCHAR2,
    V_NGAY_HS	in	DATE,
    V_DONVICHUYEN_HS	in	NUMBER,
    V_GHICHU_HS	in	VARCHAR2,
    V_NGUOI_TAO	in	VARCHAR2,
    V_TOAANID	in	NUMBER,
    V_NGUON_DEN	in	NUMBER,
    V_MABD	in	VARCHAR2,
    V_NGUOIDUNGDON in	VARCHAR2,
    V_DIACHI_NDD in	VARCHAR2,
    V_DOMAT_ID in	VARCHAR2,
    V_DO_KHAN_ID in	VARCHAR2,
    V_DIACHI_GUI_BT_ID	in	NUMBER,
    V_DIACHI_NDD_ID	in	NUMBER,
    V_ID_VBDH IN NUMBER
    )
AS
BEGIN 
   
     IF v_ID=0 THEN
       INSERT INTO VT_VANBANDEN
         (ID,LOAI_VB,SODEN,NGAY_DEN,NGUOI_GUI_BT,DIACHI_GUI_BT,NGAY_BT,NOI_NHAN,NGUOI_NHAN,GHICHU,SO_VB,NGAY_VB,
            NOIDUNG_VB,SOLUONG_DON,LOAI_GDTTTT, BAQD_CHECK_DON,LOAI_AN_DON,CAP_XX_DON,SO_BAQD_DON,
            NGAY_BAQD_DON,TOAAN_BAQD_DON,BIDON_DON,NGUYENDON_DON,QHPL_DS_DON,QHPL_HS_DON,SOLUONG_GAM,
            SO_CV,NGAY_CV,DONVICHUYEN_CV,NOIDUNG_CV,DVXULY_ID_DON,CANBONHAN_ID,NGAY_GIAO_DON,SO_HS,
            NGAY_HS,DONVICHUYEN_HS,GHICHU_HS,NGUOI_TAO,NGAY_TAO,NGUOI_SUA,NGAY_SUA,TOAANID,NGUON_DEN,MABD,NGUOIDUNGDON,DIACHI_NDD,DOMAT_ID,DO_KHAN_ID
            ,DIACHI_GUI_BT_ID,DIACHI_NDD_ID,ID_VBDH)
        VALUES (VT_VANBANDEN_SEQ.NEXTVAL,
            V_LOAI_VB,V_SODEN,V_NGAY_DEN,V_NGUOI_GUI_BT,V_DIACHI_GUI_BT,V_NGAY_BT,V_NOI_NHAN,V_NGUOI_NHAN,V_GHICHU,V_SO_VB,V_NGAY_VB,
            V_NOIDUNG_VB,V_SOLUONG_DON,V_LOAI_GDTTTT,V_BAQD_CHECK_DON,V_LOAI_AN_DON,V_CAP_XX_DON,V_SO_BAQD_DON,
            V_NGAY_BAQD_DON,V_TOAAN_BAQD_DON,V_BIDON,V_NGUYENDON,V_QHPL_DS,V_QHPL_HS,V_SOLUONG_GAM,
            V_SO_CV,V_NGAY_CV,V_DONVICHUYEN_CV,V_NOIDUNG_CV,V_DVXULY_ID_DON,V_CANBONHAN_ID,V_NGAY_GIAO_DON,V_SO_HS,
            V_NGAY_HS,V_DONVICHUYEN_HS,V_GHICHU_HS,V_NGUOI_TAO,SYSDATE,V_NGUOI_TAO,SYSDATE,V_TOAANID,V_NGUON_DEN,V_MABD,V_NGUOIDUNGDON,V_DIACHI_NDD,V_DOMAT_ID,V_DO_KHAN_ID
            ,V_DIACHI_GUI_BT_ID,V_DIACHI_NDD_ID,V_ID_VBDH);
     ELSE 
          UPDATE VT_VANBANDEN
            SET    
                LOAI_VB=V_LOAI_VB,
                SODEN=V_SODEN,
                NGAY_DEN=V_NGAY_DEN,
                NGUOI_GUI_BT=V_NGUOI_GUI_BT,
                DIACHI_GUI_BT=V_DIACHI_GUI_BT,
                NGAY_BT=V_NGAY_BT,
                NOI_NHAN=V_NOI_NHAN,
                NGUOI_NHAN=V_NGUOI_NHAN,
                GHICHU=V_GHICHU,
                SO_VB=V_SO_VB,
                NGAY_VB=V_NGAY_VB,
                NOIDUNG_VB=V_NOIDUNG_VB,
                SOLUONG_DON=V_SOLUONG_DON,

                LOAI_GDTTTT =V_LOAI_GDTTTT,
                BAQD_CHECK_DON=V_BAQD_CHECK_DON,
                LOAI_AN_DON=V_LOAI_AN_DON,
                CAP_XX_DON=V_CAP_XX_DON,
                SO_BAQD_DON=V_SO_BAQD_DON,
                NGAY_BAQD_DON=V_NGAY_BAQD_DON,
                TOAAN_BAQD_DON=V_TOAAN_BAQD_DON,

                BIDON_DON   = V_BIDON,
                NGUYENDON_DON = V_NGUYENDON,
                QHPL_DS_DON =  V_QHPL_DS,
                QHPL_HS_DON = V_QHPL_HS,
                SOLUONG_GAM = V_SOLUONG_GAM,

                SO_CV=V_SO_CV,
                NGAY_CV=V_NGAY_CV,
                DONVICHUYEN_CV=V_DONVICHUYEN_CV,
                NOIDUNG_CV=V_NOIDUNG_CV,

                DVXULY_ID_DON=V_DVXULY_ID_DON,
                CANBONHAN_ID=V_CANBONHAN_ID,
                NGAY_GIAO_DON=V_NGAY_GIAO_DON,

                SO_HS=V_SO_HS,
                NGAY_HS=V_NGAY_HS,
                DONVICHUYEN_HS=V_DONVICHUYEN_HS,
                NGUOI_SUA=V_NGUOI_TAO,
                NGAY_SUA=SYSDATE,
                NGUON_DEN=V_NGUON_DEN,
                MABD=V_MABD,
                NGUOIDUNGDON=V_NGUOIDUNGDON,
                DIACHI_NDD=V_DIACHI_NDD,
                DOMAT_ID=V_DOMAT_ID,
                DO_KHAN_ID=V_DO_KHAN_ID,
                DIACHI_GUI_BT_ID=V_DIACHI_GUI_BT_ID,
                DIACHI_NDD_ID=V_DIACHI_NDD_ID,
                
                ID_VBDH=V_ID_VBDH
            WHERE ID=V_ID;
     END IF;   
END VT_DEN_INS_UP;


PROCEDURE  DM_PHONGBAN_LIST
(
  V_TOAANID IN VARCHAR2,
  V_PHONGBAN_ID IN VARCHAR2,
  V_LOAI_COMBO  IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) 
AS 
BEGIN
     IF(V_LOAI_COMBO='1') THEN
          OPEN CURRETURN FOR
          SELECT P.ID,P.TENPHONGBAN FROM DM_PHONGBAN P WHERE P.TOAANID=V_TOAANID
          AND UPPER(P.TENPHONGBAN)!='VĂN THƯ'
          AND ( (INSTR(','||V_PHONGBAN_ID||',',','||P.ID||',')>0 AND V_PHONGBAN_ID IS NOT NULL) OR (V_PHONGBAN_ID IS NULL));
      ELSIF(V_LOAI_COMBO='2') THEN
          OPEN CURRETURN FOR
          SELECT P.ID,DECODE(P.ID,13,'Phòng hành chính tư pháp',P.TENPHONGBAN)TENPHONGBAN FROM DM_PHONGBAN P WHERE P.TOAANID=V_TOAANID
          AND UPPER(P.TENPHONGBAN)!='VĂN THƯ';
      END IF;
END DM_PHONGBAN_LIST;
PROCEDURE  LANH_DAO_LIST
(
  V_TOAANID IN VARCHAR2,
  V_PHONGBANID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) 
AS 
BEGIN
      --13 chức vụ; 12 chức danh
      OPEN CURRETURN FOR
      SELECT CB.ID,CB.HOTEN||decode(cd.TEN,null,null,' - '||cd.TEN)||decode(cv.TEN,null,null,' - '||cv.TEN) HOTEN FROM DM_CANBO CB 
      LEFT JOIN (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c  where c.GROUPID=13)cv on cv.ID=CB.CHUCVUID
      LEFT JOIN (select c.ID,c.TEN,c.MA  from DM_DATAITEM c where c.GROUPID=12 
                    and c.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) cd on cd.ID=CB.CHUCDANHID
      WHERE CB.TOAANID=V_TOAANID AND CB.PHONGBANID=V_PHONGBANID 
      AND (cv.TEN IS NOT NULL OR cd.MA IS NOT NULL) AND CB.HIEULUC=1 
      ;
END LANH_DAO_LIST;


PROCEDURE  CANBO_LIST_BY_PHONGBAN
(
  V_TOAANID IN VARCHAR2,
  V_PHONGBANID IN VARCHAR2,
  CurReturn OUT sys_refcursor 
) 
AS 
BEGIN
      --13 chức vụ; 12 chức danh
      OPEN CURRETURN FOR
      SELECT CB.ID,CB.HOTEN||decode(cd.TEN,null,null,' - '||cd.TEN) HOTEN FROM DM_CANBO CB 
       left join DM_CANBO_QUATRINH qt on qt.CANBOID=CB.id --anhvh  lấy những thẩm phán đã điều chuyển
--     LEFT JOIN (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c  where c.GROUPID=12)cv on cv.ID=CB.CHUCVUID
      LEFT JOIN (select c.ID,c.TEN,c.MA  from DM_DATAITEM c where c.GROUPID=12 
                   -- and c.MA in ('TTV','TTVCC','TTVC','TK','C008','C0009','C010','TK1')
                    ) cd on cd.ID=CB.CHUCDANHID
      WHERE  (qt.TOAANID=V_TOAANID or CB.TOAANID=V_TOAANID) 
     -- AND (V_PHONGBANID is null Or (CB.PHONGBANID=V_PHONGBANID and  V_PHONGBANID is not null ))
      --AND  cd.MA IS NOT NULL
      AND CB.HIEULUC=1 
      group by CB.ID,CB.HOTEN||decode(cd.TEN,null,null,' - '||cd.TEN)
      ;
END CANBO_LIST_BY_PHONGBAN;

PROCEDURE SODEN_GET
(
  V_TOAANID IN VARCHAR2,
  V_PHONGBANID IN VARCHAR2,
  V_LOAI_VB IN VARCHAR2,
  V_SODEN OUT NUMBER
)
AS   
BEGIN       
    SELECT COUNT (*) INTO  V_SODEN FROM VT_VANBANDEN V
    WHERE  EXTRACT(YEAR FROM  TO_DATE(V.NGAY_TAO, 'DD-MON-RR'))= EXTRACT(YEAR FROM  TO_DATE(SYSDATE, 'DD-MON-RR'))
    AND V.LOAI_VB=V_LOAI_VB AND V.TOAANID=V_TOAANID;
    -------------------------
    V_SODEN := V_SODEN+1;    
END; 

PROCEDURE  VT_VANBANDEN_SEARCH
( 
    V_TOAANID in	VARCHAR2,
    V_NGUON_DEN in	VARCHAR2,
    V_NGUOIDUNGDON in	VARCHAR2,
    V_LOAI_AN_DON in	VARCHAR2,
    V_TOAAN_BAQD_DON in	VARCHAR2,
    V_SO_BAQD_DON  in	VARCHAR2,
    V_NGAY_BAQD_DON  in	VARCHAR2,
    V_NGUOI_TAO in	VARCHAR2,
    -----------
    V_PHONGBAN_ID in	VARCHAR2,
    -----------
    V_LOAI_VB	in	VARCHAR2,
    V_NOI_NHAN	in	VARCHAR2,
    V_NGUOI_NHAN in	VARCHAR2,
    V_SODEN_TU	in	VARCHAR2,
    V_SODEN_DEN	in	VARCHAR2,
    V_ID	in	VARCHAR2,
    V_LOAI_NGAY in VARCHAR2,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    V_DIACHI_GUI_BT	in	VARCHAR2,
    V_GHICHU	in	VARCHAR2,
    V_TRANGTHAICHUYEN in	VARCHAR2,
    -----------
    PageIndex	in	int,
    PageSize	in	int,  
    curReturn OUT sys_refcursor
)
IS  
            MinIndex	number;  MaxIndex	number;
BEGIN
 ---------------
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
OPEN curReturn FOR
 SELECT a.* FROM ( 
       SELECT  COUNT(*) OVER () as CountAll, ROW_NUMBER() OVER (ORDER BY VT.NGAY_TAO DESC)STT,'<i>ĐV: </i>'||DECODE(P.ID,'13','Phòng hành chính tư pháp',P.TENPHONGBAN)||'<br/><i>NN: </i><b>'||CB.HOTEN||'</b>' DV_NHAN_NGUOI_NHAN
        ,DECODE(VT.LOAI_VB,1,'Đơn đề nghị GĐT,TT',2,'Công văn',3,'Đơn đề nghị GĐT,TT kèm theo CV chuyển đơn',4,'Hồ sơ Kháng nghị VKS',5,'Văn bản hành chính',6,'CV kiến nghị GĐT,TT',7,'Thông báo phát hiện vi phạm pháp luật',8,'Đơn khiếu nại tư pháp',9,'CV kiến nghị GĐT,TT kèm theo Hồ sơ')LOAI_VB_TEN
        ,'<b>'||CB.HOTEN||'</b>'|| DECODE(CD.TEN,NULL,NULL,' - '||CD.TEN) ||DECODE(CV.TEN,NULL,NULL,' - '||CV.TEN)NGUOI_NHAN_TEN
        --,DECODE(vtcn.VANBANDEN_ID,null,'Đang lưu',DECODE(vtcn.CANBO_NHAN_ID,NULL,DECODE(V_PHONGBAN_ID,62,'Đã chuyển, <br/>',NULL)||'Chưa nhận',DECODE(V_PHONGBAN_ID,62,'Đã chuyển, <br/>',NULL)||'Đã nhận')||decode(vtcn.NGAY_CHUYEN,null,null,'<br/>- Ngày chuyển '||to_char(vtcn.NGAY_CHUYEN,'dd/MM/yyyy'))||decode(vtcn.NGAY_NHAN,null,null,'<br/>- Ngày nhận '||to_char(vtcn.NGAY_NHAN,'dd/MM/yyyy')) )TRANGTHAICHUYEN_TEN
        ,VT.NGUOIDUNGDON
        ,DECODE(vtcn.VANBANDEN_ID,null,'Đang lưu',decode(vtcn.NGAY_CHUYEN,null,null,'- Ngày chuyển '||to_char(vtcn.NGAY_CHUYEN,'dd/MM/yyyy  HH24:MI:SS'))||decode(vtcn.NGAY_NHAN,null,null,'<br/>- Ngày nhận '||to_char(vtcn.NGAY_NHAN,'dd/MM/yyyy HH24:MI:SS')) )TRANGTHAICHUYEN_TEN
        ,vtcn.CANBO_NHAN_ID,vtcn.VANBANDEN_ID
        ,VT.id,VT.LOAI_VB,VT.SODEN,to_char(VT.NGAY_DEN,'dd/MM/yyyy')NGAY_DEN
        ,DECODE(VT.LOAI_VB,4, CASE VT.DONVICHUYEN_HS
                                        WHEN 818 THEN 'CA TANDTC'
                                        WHEN 819 THEN 'CA TANDCC tại Hà Nội'
                                         WHEN 820 THEN 'CA TANDCC tại Đà Nẵng'
                                        WHEN 821 THEN 'CA TANDCC tại Hồ Chí Minh'
                                        ELSE VT.NGUOI_GUI_BT END  
                                                    || ' (Số KN '|| VT.SO_HS||' ngày '||to_char(VT.NGAY_HS,'dd/MM/yyyy')||')'
                            , VT.NGUOI_GUI_BT) NGUOI_GUI_BT
        
        ,VT.DIACHI_GUI_BT
        ,decode(to_char(VT.NGAY_BT,'dd/MM/yyyy'),'01/01/0001',null,to_char(VT.NGAY_BT,'dd/MM/yyyy'))NGAY_BT
        ,VT.NOI_NHAN,VT.NGUOI_NHAN,VT.GHICHU
        ,VT.SO_VB,to_char(VT.NGAY_VB,'dd/MM/yyyy') NGAY_VB,VT.NOIDUNG_VB,VT.SOLUONG_DON
        ,VT.DVXULY_ID_DON,VT.BAQD_CHECK_DON,VT.LOAI_AN_DON,VT.CAP_XX_DON
        ,VT.SO_BAQD_DON,to_char(VT.NGAY_BAQD_DON,'dd/MM/yyyy') NGAY_BAQD_DON,VT.TOAAN_BAQD_DON
        ,DECODE(VT.SO_BAQD_DON,NULL,NULL, '<i>SoBA: </i>'||VT.SO_BAQD_DON)
         ||DECODE(to_char(VT.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001',null,'<br/><i>NBA: </i>'||to_char(VT.NGAY_BAQD_DON,'dd/MM/yyyy'))
         ||DECODE(TA.MA_TEN,NULL,NULL,'<br/> <i>TXX: </i>'||TA.MA_TEN) SOBA_NGAYBA_TOA_XX
         ,DECODE(VT.NGUON_DEN,0,NULL,1,'Bưu điện',2,'Tiếp công dân',3,'Trực tiếp')NGUON_DEN
        ,VT.SO_CV,VT.NGAY_CV,VT.DONVICHUYEN_CV,VT.NOIDUNG_CV,VT.CANBONHAN_ID
        ,VT.SO_HS,to_char(VT.NGAY_HS,'dd/MM/yyyy') NGAY_HS,VT.DONVICHUYEN_HS,VT.GHICHU_HS
        ,VT.NGUOI_TAO,to_char(VT.NGAY_TAO,'dd/MM/yyyy HH24:MI:SS') NGAY_TAO,VT.NGUOI_SUA,VT.NGAY_SUA
        ,VT.DIACHI_GUI_BT_ID,VT.DIACHI_NDD_ID
       FROM VT_VANBANDEN VT
       LEFT JOIN DM_TOAAN TA ON TA.ID=VT.TOAAN_BAQD_DON
       LEFT JOIN DM_PHONGBAN P ON VT.DVXULY_ID_DON=P.ID 
       LEFT JOIN DM_CANBO CB ON CB.ID=VT.NGUOI_NHAN
      -- LEFT JOIN DM_CANBO CBN ON CBN.ID=VT.CANBONHAN_ID
       LEFT JOIN (select i.ID, i.TEN from DM_DATAITEM i where  i.GROUPID=12)CD ON CD.ID=CB.CHUCDANHID
       LEFT JOIN (select i.ID, i.TEN from DM_DATAITEM i where  i.GROUPID=13)CV ON CV.ID=CB.CHUCVUID
       LEFT JOIN VT_CHUYEN_NHAN vtcn on vtcn.VANBANDEN_ID=vt.id  
       WHERE (VT.LOAI_VB=V_LOAI_VB OR V_LOAI_VB IS NULL) 
       AND VT.TOAANID=V_TOAANID
       ------------------
       AND (V_NGUON_DEN IS NULL OR (VT.NGUON_DEN=V_NGUON_DEN) )
       AND (V_NGUOIDUNGDON IS NULL OR (upper(VT.NGUOIDUNGDON)LIKE '%'||upper(V_NGUOIDUNGDON)||'%'))
       --V_LOAI_AN_DON=55 là một loại án định nghĩa ra để list dữ liệu
       AND (V_LOAI_AN_DON IS NULL 
            OR( V_LOAI_AN_DON!=55 and (VT.LOAI_AN_DON=V_LOAI_AN_DON  OR EXISTS(SELECT 'X' FROM GDTTT_DON d where d.id = vtcn.GDTTT_DON_ID and  d.BAQD_LOAIAN = V_LOAI_AN_DON) ))
            OR(V_LOAI_AN_DON=55 AND VT.LOAI_AN_DON=0)
          )
       AND (V_TOAAN_BAQD_DON IS NULL OR (VT.TOAAN_BAQD_DON=V_TOAAN_BAQD_DON))
       AND (V_SO_BAQD_DON IS NULL OR (upper(VT.SO_BAQD_DON)=upper(V_SO_BAQD_DON)))
       AND (V_NGAY_BAQD_DON IS NULL OR (to_char(VT.NGAY_BAQD_DON,'dd/MM/yyyy')=V_NGAY_BAQD_DON))
       AND (V_NGUOI_TAO IS NULL OR (upper(VT.NGUOI_TAO)=upper(V_NGUOI_TAO)))
       -----------------
       AND (VT.NOI_NHAN=V_NOI_NHAN OR V_NOI_NHAN IS NULL)
       AND (VT.NGUOI_NHAN=V_NGUOI_NHAN OR V_NGUOI_NHAN IS NULL) 
       AND (VT.SODEN>=TO_NUMBER(V_SODEN_TU) OR V_SODEN_TU IS NULL)
       AND (VT.SODEN<=TO_NUMBER(V_SODEN_DEN) OR V_SODEN_DEN IS NULL)
       AND ( VT.ID=V_ID  OR V_ID IS NULL)
       AND ( (V_LOAI_NGAY IS NULL)--trên form không có nhưng thêm giá trị null để test PROCEDURE trên SQL DEVELOPER
             OR(V_LOAI_NGAY='0' AND  (VT.NGAY_TAO>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_FROM IS NULL)
                                 AND   (VT.NGAY_TAO<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_TO IS NULL)
              )
              OR
              (V_LOAI_NGAY='1' AND (VT.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_FROM IS NULL)
                                AND  (VT.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_TO IS NULL)
              )
              OR
              (V_LOAI_NGAY='2' AND (VT.NGAY_BT>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_FROM IS NULL)
                               AND  (VT.NGAY_BT<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_TO IS NULL)
              )
              OR(V_LOAI_NGAY='3' AND EXISTS(SELECT 'X' FROM  VT_CHUYEN_NHAN cn WHERE cn.VANBANDEN_ID=vt.id
                                            AND (cn.NGAY_CHUYEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_FROM IS NULL)
                                            AND  (cn.NGAY_CHUYEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_TO IS NULL)
                                            )

              )
            OR(V_LOAI_NGAY='4' AND EXISTS(SELECT 'X' FROM  VT_CHUYEN_NHAN cn WHERE cn.VANBANDEN_ID=vt.id
                                            AND (cn.NGAY_NHAN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_FROM IS NULL)
                                            AND  (cn.NGAY_NHAN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') OR V_NGAY_TO IS NULL)
                                            )
               )                             
            )
        AND ( (UPPER(VT.NGUOI_GUI_BT) LIKE '%'||UPPER(V_NGUOI_GUI_BT)||'%') OR (V_NGUOI_GUI_BT IS NULL) )
        AND ( (UPPER(VT.DIACHI_GUI_BT) LIKE '%'||UPPER(V_DIACHI_GUI_BT)||'%') OR (V_DIACHI_GUI_BT IS NULL) )
        AND ( (UPPER(VT.GHICHU) LIKE '%'||UPPER(V_GHICHU)||'%') OR (V_GHICHU IS NULL) )
         -- V_PHONGBAN_ID=62 đơn vị văn thư trên App đang đóng,trên procedure để lại với mục đích test để không phải truyền tham số
         -- V_PHONGBAN_ID=1 Văn phòng đại diện cho phòng hành chính tư pháp
        AND (   
--          (V_TRANGTHAICHUYEN IS NULL   AND( (VT.PHONGBANID=V_PHONGBAN_ID AND (V_PHONGBAN_ID NOT IN(13,9,5)) )
--                                               OR( (V_PHONGBAN_ID=13 OR V_PHONGBAN_ID=9 OR V_PHONGBAN_ID=5)  AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID) )-- AND CN.DONVI_CHUYEN_ID=V_PHONGBAN_ID
--                                             )
--           )
        --or V_PHONGBAN_ID=361 vu 4
          (V_TRANGTHAICHUYEN IS NULL     AND(  V_PHONGBAN_ID IS NULL
                                               OR( (V_PHONGBAN_ID=13 OR V_PHONGBAN_ID=9 OR V_PHONGBAN_ID=5 OR V_PHONGBAN_ID=1)  AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID) )-- AND CN.DONVI_CHUYEN_ID=V_PHONGBAN_ID
                                             )
           )
           --06/11/2024
             OR
             (V_TRANGTHAICHUYEN=0 AND  VTCN.VANBANDEN_ID IS NULL)--NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID)) --đang lưu
             OR (V_TRANGTHAICHUYEN=1 AND  VTCN.VANBANDEN_ID IS NOT NULL)--EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID))--đã chuyển
             OR (V_TRANGTHAICHUYEN=2 AND  VTCN.VANBANDEN_ID IS NOT NULL AND VTCN.CANBO_NHAN_ID IS NULL)--EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID AND CN.CANBO_NHAN_ID IS NULL))--chua nhận
             OR (V_TRANGTHAICHUYEN=3 AND VTCN.VANBANDEN_ID IS NOT NULL AND VTCN.CANBO_NHAN_ID IS NOT NULL)--EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID AND CN.CANBO_NHAN_ID IS NOT NULL))--đã nhận
        )
    )a where a.stt>=MinIndex and a.stt<=MaxIndex     
    ;
END VT_VANBANDEN_SEARCH;

PROCEDURE  VT_VANBANDEN_BY_ID
(
    V_ID  in NUMBER,
    curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR
     SELECT a.* FROM VT_VANBANDEN a WHERE a.ID = V_ID;
END;

PROCEDURE  VT_CHUYEN_NHAN_BY_DONID
(
    V_DonID  in NUMBER,
    curReturn OUT sys_refcursor
)IS
BEGIN
    OPEN curReturn FOR
     SELECT a.* FROM VT_CHUYEN_NHAN a WHERE a.GDTTT_DON_ID = V_DonID;
END;


PROCEDURE  VBD_LOAD_ID
( 
  V_TOAANID IN VARCHAR2,
  V_ID IN VARCHAR2,
  curReturn OUT sys_refcursor
)
IS  
   V_LOAI_AN_DON VARCHAR2(100);V_CD_TA_DONVIID  VARCHAR2(100);
BEGIN
        SELECT LOAI_AN_DON  INTO V_LOAI_AN_DON  FROM VT_VANBANDEN VT WHERE VT.ID=V_ID;
         --xác định tham số đơn vị(Vụ 1,2,3) bằng loại án
        IF(V_LOAI_AN_DON IS NOT NULL AND V_LOAI_AN_DON !=0)THEN
           SELECT TT.ID INTO V_CD_TA_DONVIID FROM (
                SELECT decode(ISHINHSU,1,','||1)||decode(ISDANSU,1,','||2) ||decode(ISHNGD,1,','||3)||decode(ISKDTM,1,','||4)
                ||decode(ISLAODONG,1,','||5)||decode(ISHANHCHINH,1,','||6)||decode(ISPHASAN,1,','||7)||',' LOAIAN,pb.ID
                FROM DM_PHONGBAN pb WHERE    (  (V_TOAANID =6 AND ID in (14,15,16)) --Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
                                             OR (V_TOAANID =5 AND ID in (10,11)) --Tòa án nhân dân cấp cao tại Đà Nẵng
                                             OR (V_TOAANID =4 AND ID in (6,7,8)) --Tòa án nhân dân cấp cao tại Hà Nội
                                             OR (V_TOAANID =1 AND ID in (2,3,4)) --Tòa án nhân dân tối cao
                                              )                 
            )TT WHERE INSTR(TT.LOAIAN,','||V_LOAI_AN_DON||',')>0
            FETCH FIRST 1 ROWS ONLY;
        END IF;

        ----------------
OPEN curReturn FOR
   SELECT VT.*,V_CD_TA_DONVIID CD_TA_DONVIID FROM VT_VANBANDEN VT WHERE VT.ID=V_ID;
END VBD_LOAD_ID;
PROCEDURE  DM_LOAIAN_LIST
( 
  curReturn OUT sys_refcursor
)
IS  
BEGIN
OPEN curReturn FOR
   SELECT LA.* FROM DM_LOAIAN LA;
END DM_LOAIAN_LIST;
PROCEDURE  VT_DEN_DELETE
( 
  V_ID IN VARCHAR2
)
IS  
BEGIN
        DELETE VT_VANBANDEN VT WHERE VT.ID=V_ID;
END VT_DEN_DELETE;
PROCEDURE VT_CHUYEN_INS
    (
        V_VANBANDEN_ID  in  NUMBER,
        V_DONVI_CHUYEN_ID in  NUMBER,
        V_CANBO_CHUYEN_ID in  NUMBER
    )
AS 
            V_NOI_NHAN NUMBER;V_COUNT_CHEK NUMBER;
            V_NGUOI_NHAN NUMBER;--là lãnh đạo nhận trong bảng VT_VANBANDEN
BEGIN 
       SELECT NOI_NHAN INTO V_NOI_NHAN FROM VT_VANBANDEN VT WHERE VT.ID=V_VANBANDEN_ID;
       SELECT NGUOI_NHAN INTO V_NGUOI_NHAN FROM VT_VANBANDEN VT WHERE VT.ID=V_VANBANDEN_ID;
       SELECT COUNT(*) INTO V_COUNT_CHEK FROM VT_CHUYEN_NHAN WHERE VANBANDEN_ID=V_VANBANDEN_ID;
      ------------
       IF(V_COUNT_CHEK=0)THEN --bảng VT_CHUYEN_NHAN và VT_VANBANDEN quan hệ 1-1
            INSERT INTO VT_CHUYEN_NHAN
             (ID,VANBANDEN_ID,DONVI_CHUYEN_ID,CANBO_CHUYEN_ID,NGAY_CHUYEN,NOI_NHAN,NGUOI_NHAN)
            VALUES (VT_CHUYEN_NHAN_SEQ.NEXTVAL,V_VANBANDEN_ID,V_DONVI_CHUYEN_ID,V_CANBO_CHUYEN_ID,SYSDATE,V_NOI_NHAN,V_NGUOI_NHAN);
        END IF;
END VT_CHUYEN_INS;
PROCEDURE  VT_HUY_CHUYEN
( 
  V_VANBANDEN_ID IN VARCHAR2,
  V_CANBO_NHAN_ID OUT VARCHAR2
)
IS  
BEGIN
       SELECT CANBO_NHAN_ID INTO V_CANBO_NHAN_ID FROM VT_CHUYEN_NHAN cn WHERE cn.VANBANDEN_ID=V_VANBANDEN_ID;
       IF(V_CANBO_NHAN_ID IS NULL)THEN     
         DELETE VT_CHUYEN_NHAN cn WHERE cn.VANBANDEN_ID=V_VANBANDEN_ID;
        END IF;
END VT_HUY_CHUYEN;
PROCEDURE VT_NHAN_INS_UP
    (
        V_TOAANID in NUMBER,
        V_VANBANDEN_ID  in  NUMBER,
        V_CANBO_NHAN_ID in  NUMBER,
        V_USERNAME_NHAN IN VARCHAR2
    )
AS 
     CHECK_NHAN NUMBER DEFAULT 0;
     V_GDTTT_DON_ID NUMBER;V_LOAI_VB NUMBER;V_NGUOI_GUI_BT VARCHAR2(1000);V_DIACHI_GUI_BT VARCHAR2(1000);
     V_SODEN VARCHAR2(500);  
     V_LOAI_GDTTTT number; V_SO_BAQD_DON VARCHAR2(500);V_NGAY_BAQD_DON DATE;V_TOAAN_BAQD_DON VARCHAR2(500);
     V_NGUYENDON   VARCHAR2(500); V_BIDON   VARCHAR2(500); V_QHPL_DSDON   VARCHAR2(500); V_QHPL_HSDON NUMBER;
     V_BIDON_ID NUMBER; V_NGUYENDON_ID NUMBER ;V_TOIDANH_ID NUMBER;V_TENTOIDANH VARCHAR2(500); 
     V_CAP_XX_DON VARCHAR2(100);V_LOAI_AN_DON VARCHAR2(100);V_CD_TA_DONVIID  VARCHAR2(100);V_SO_CV VARCHAR2(100);V_NGAY_CV DATE;
     V_NOIDUNG_CV  VARCHAR2(1000);V_GHICHU VARCHAR2(1000);V_DONVICHUYEN_CV VARCHAR2(1000);V_NGAY_BT DATE;V_MADON  VARCHAR2(100);
     V_TT NUMBER;V_SO_HS  VARCHAR2(255);V_NGAY_HS DATE;V_DONVICHUYEN_HS NUMBER;V_NGAY_DEN DATE;V_NOIDUNG_VB  VARCHAR2(1000);V_SO_VB VARCHAR2(500);V_NGAY_VB DATE;
     V_NGUOIDUNGDON VARCHAR2(512); V_DIACHI_NDD VARCHAR2(512); V_DIACHI_GUI_BT_ID NUMBER;V_DIACHI_NDD_ID NUMBER;
BEGIN 

        SELECT COUNT('X') INTO CHECK_NHAN
        FROM VT_CHUYEN_NHAN CN
        WHERE CN.VANBANDEN_ID = V_VANBANDEN_ID AND CN.GDTTT_DON_ID IS NULL;
        
        IF(CHECK_NHAN > 0) THEN
            --SELECT INTO
            SELECT VT.LOAI_VB,VT.NGUOI_GUI_BT,VT.DIACHI_GUI_BT,SODEN,LOAI_GDTTTT,SO_BAQD_DON,NGAY_BAQD_DON,TOAAN_BAQD_DON,CAP_XX_DON,LOAI_AN_DON,SO_CV,NGAY_CV,NOIDUNG_CV,GHICHU,DONVICHUYEN_CV,NGAY_BT,
                BIDON_DON, NGUYENDON_DON,QHPL_DS_DON,QHPL_HS_DON,SO_HS,NGAY_HS,DONVICHUYEN_HS,NGAY_DEN,NGUOIDUNGDON,DIACHI_NDD,DIACHI_GUI_BT_ID,DIACHI_NDD_ID,NOIDUNG_VB,SO_VB,NGAY_VB
            INTO V_LOAI_VB,V_NGUOI_GUI_BT,V_DIACHI_GUI_BT,V_SODEN,V_LOAI_GDTTTT,V_SO_BAQD_DON,V_NGAY_BAQD_DON,V_TOAAN_BAQD_DON,V_CAP_XX_DON,V_LOAI_AN_DON,V_SO_CV,V_NGAY_CV,V_NOIDUNG_CV,V_GHICHU,V_DONVICHUYEN_CV,V_NGAY_BT,
                V_BIDON,V_NGUYENDON,V_QHPL_DSDON,V_QHPL_HSDON,V_SO_HS,V_NGAY_HS,V_DONVICHUYEN_HS,V_NGAY_DEN,V_NGUOIDUNGDON,V_DIACHI_NDD,V_DIACHI_GUI_BT_ID,V_DIACHI_NDD_ID,V_NOIDUNG_VB,V_SO_VB,V_NGAY_VB
            FROM VT_VANBANDEN VT WHERE VT.ID=V_VANBANDEN_ID;
            --
            SELECT GDTTT_DON_SEQ.NEXTVAL INTO V_GDTTT_DON_ID FROM DUAL;
             --tạo mã đơn--09-- ENUM_LOAIVUVIEC.AN_GDTTT--01 Session[ENUM_SESSION.SESSION_MADONVI] thường có mã 01 vì là mã của id=1 của Tòa án nhân dân tối cao
             Select '0901'||NVL(MAX(d.TT)+1,0),NVL(MAX(d.TT)+1,0) INTO V_MADON,V_TT  From GDTTT_DON d Where d.TOAANID=6;
             --tạo mã đơn end
            --xác định tham số đơn vị(Vụ 1,2,3) bằng loại án
           if(V_LOAI_VB in (1,3,4,5,6,9) )THEN --đơn
               IF(V_LOAI_AN_DON IS NOT NULL  and V_LOAI_AN_DON > 0)THEN
                   SELECT TT.ID INTO V_CD_TA_DONVIID FROM (
                        SELECT decode(ISHINHSU,1,','||1)||decode(ISDANSU,1,','||2) ||decode(ISHNGD,1,','||3)||decode(ISKDTM,1,','||4)
                        ||decode(ISLAODONG,1,','||5)||decode(ISHANHCHINH,1,','||6)||decode(ISPHASAN,1,','||7)||',' LOAIAN,pb.ID
                        FROM DM_PHONGBAN pb WHERE (  (V_TOAANID =6 AND ID in (14,15,16)) --Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
                                                 OR (V_TOAANID =5 AND ID in (10,11)) --Tòa án nhân dân cấp cao tại Đà Nẵng
                                                 OR (V_TOAANID =4 AND ID in (6,7,8)) --Tòa án nhân dân cấp cao tại Hà Nội
                                                 OR (V_TOAANID =1 AND ID in (2,3,4)) --Tòa án nhân dân tối cao
                                                )   
                    )TT WHERE INSTR(TT.LOAIAN,','||V_LOAI_AN_DON||',')>0
                    FETCH FIRST 1 ROWS ONLY;
                END IF;
    
                ---INSERT----------
                INSERT INTO GDTTT_DON
                    (ID,TOAANID,LOAIDON,NGAYTAO,SOHIEUDON,BAQD_CAPXETXU,NGAYNHANDON)
                VALUES 
                     (V_GDTTT_DON_ID,V_TOAANID,V_LOAI_VB,SYSDATE,V_SODEN,V_CAP_XX_DON,V_NGAY_DEN);
                 ---UPDATE-----------
                 --CD_LOAI=0 Nơi chuyển đến nội bộ (giá trị set tạm)
                 --ISTHULY=1 Thụ lý mới đơn (giá trị set tạm)
                 --,CD_LOAI=0,ISTHULY=1(giá trị set tạm)
                 -- LOAICONGVAN = 544 Là công văn kiến nghị
                 IF (V_LOAI_VB IN (6,9)) THEN
                    UPDATE  GDTTT_DON
                     SET BAQD_LOAIAN=V_LOAI_AN_DON
                     ,CD_TA_DONVIID=V_CD_TA_DONVIID,CD_LOAI=0
                     ,LOAICONGVAN = 544,CV_SO=V_SO_CV,CV_NGAY=V_NGAY_CV
                     ,NOIDUNGDON=V_NOIDUNG_CV,GHICHU=V_GHICHU,NGUOIGUI_HUYENID=V_DIACHI_GUI_BT_ID,NGUOIGUI_HOTEN=V_NGUOI_GUI_BT,DONGKHIEUNAI=V_NGUOI_GUI_BT,CV_TENDONVI=V_DONVICHUYEN_CV
                     ,NGUOIGUI_DIACHI=V_DIACHI_GUI_BT,TT=V_TT,MADON=V_MADON,NGAYGHITRENDON=null--NGAYGHITRENDON=V_NGAY_BT
                     WHERE ID=V_GDTTT_DON_ID;
                  ELSIF (V_LOAI_VB IN (1,3)) THEN--V_NGUOIDUNGDON
                     UPDATE  GDTTT_DON
                     SET BAQD_LOAIAN=V_LOAI_AN_DON
                     ,CD_TA_DONVIID=V_CD_TA_DONVIID,CD_LOAI=0
                     ,CV_SO=V_SO_CV,CV_NGAY=V_NGAY_CV
                     ,NOIDUNGDON=V_NOIDUNG_CV,GHICHU=V_GHICHU,NGUOIGUI_HUYENID=V_DIACHI_NDD_ID,NGUOIGUI_HOTEN=V_NGUOIDUNGDON,DONGKHIEUNAI=V_NGUOIDUNGDON,CV_TENDONVI=V_DONVICHUYEN_CV
                     ,NGUOIGUI_DIACHI=V_DIACHI_NDD,TT=V_TT,MADON=V_MADON,NGAYGHITRENDON=null--NGAYGHITRENDON=decode(V_LOAI_VB,3,null,V_NGAY_BT)
                     ,SO_HSKN=V_SO_HS,NGAY_HSKN=V_NGAY_HS,DONVICHUYEN_HSKN=V_DONVICHUYEN_HS
                    -- ,SO_HSKN
                     WHERE ID=V_GDTTT_DON_ID;
                 ELSIF (V_LOAI_VB=5) THEN
                  UPDATE  GDTTT_DON
                     SET BAQD_LOAIAN=V_LOAI_AN_DON
                     ,CD_TA_DONVIID=V_CD_TA_DONVIID,CD_LOAI=0
                     ,CV_SO=V_SO_VB,CV_NGAY=V_NGAY_VB
                     ,NOIDUNGDON=V_NOIDUNG_VB,GHICHU=V_GHICHU,NGUOIGUI_HUYENID=V_DIACHI_GUI_BT_ID,NGUOIGUI_HOTEN=V_NGUOI_GUI_BT,DONGKHIEUNAI=V_NGUOI_GUI_BT,CV_TENDONVI=V_DONVICHUYEN_CV
                     ,NGUOIGUI_DIACHI=V_DIACHI_GUI_BT,TT=V_TT,MADON=V_MADON,NGAYGHITRENDON=null--NGAYGHITRENDON=decode(V_LOAI_VB,3,null,V_NGAY_VB)
                     ,SO_HSKN=V_SO_HS,NGAY_HSKN=V_NGAY_HS,DONVICHUYEN_HSKN=V_DONVICHUYEN_HS
                    -- ,SO_HSKN
                     WHERE ID=V_GDTTT_DON_ID;
                 ELSE
                  UPDATE  GDTTT_DON
                     SET BAQD_LOAIAN=V_LOAI_AN_DON
                     ,CD_TA_DONVIID=V_CD_TA_DONVIID,CD_LOAI=0
                     ,CV_SO=V_SO_CV,CV_NGAY=V_NGAY_CV
                     ,NOIDUNGDON=V_NOIDUNG_CV,GHICHU=V_GHICHU,NGUOIGUI_HUYENID=V_DIACHI_GUI_BT_ID,NGUOIGUI_HOTEN=V_NGUOI_GUI_BT,DONGKHIEUNAI=V_NGUOI_GUI_BT,CV_TENDONVI=V_DONVICHUYEN_CV
                     ,NGUOIGUI_DIACHI=V_DIACHI_GUI_BT,TT=V_TT,MADON=V_MADON,NGAYGHITRENDON=null--NGAYGHITRENDON=decode(V_LOAI_VB,3,null,V_NGAY_BT)
                     ,SO_HSKN=V_SO_HS,NGAY_HSKN=V_NGAY_HS,DONVICHUYEN_HSKN=V_DONVICHUYEN_HS
                    -- ,SO_HSKN
                     WHERE ID=V_GDTTT_DON_ID;
                  END IF;
                ---UPDATE CHECK-----
                IF(V_CAP_XX_DON=4)THEN --GDT,TT
                     UPDATE   GDTTT_DON
                     SET LOAI_GDTTTT = V_LOAI_GDTTTT,BAQD_SO=V_SO_BAQD_DON,BAQD_NGAYBA=V_NGAY_BAQD_DON,BAQD_TOAANID=V_TOAAN_BAQD_DON
                     WHERE ID=V_GDTTT_DON_ID;
                  ELSIF(V_CAP_XX_DON=3)THEN --PT
                   UPDATE   GDTTT_DON
                     SET  LOAI_GDTTTT = V_LOAI_GDTTTT, BAQD_SO_PT=V_SO_BAQD_DON,BAQD_NGAYBA_PT=V_NGAY_BAQD_DON,BAQD_TOAANID_PT=V_TOAAN_BAQD_DON
                     WHERE ID=V_GDTTT_DON_ID;
                   ELSIF(V_CAP_XX_DON=2)THEN --ST  
                   UPDATE   GDTTT_DON
                     SET  LOAI_GDTTTT = V_LOAI_GDTTTT,BAQD_SO_ST=V_SO_BAQD_DON,BAQD_NGAYBA_ST=V_NGAY_BAQD_DON,BAQD_TOAANID_ST=V_TOAAN_BAQD_DON
                     WHERE ID=V_GDTTT_DON_ID;   
                   ELSE
                     UPDATE   GDTTT_DON
                     SET LOAI_GDTTTT = V_LOAI_GDTTTT,BAQD_SO=V_SO_BAQD_DON,BAQD_NGAYBA=V_NGAY_BAQD_DON,BAQD_TOAANID=V_TOAAN_BAQD_DON
                     WHERE ID=V_GDTTT_DON_ID;
                 END IF;
                ---UPDATE DƯƠNG SỰ----------------- 
                IF(V_LOAI_AN_DON IS NOT NULL)THEN
                 IF (V_LOAI_AN_DON = 1) THEN
                    IF (TRIM (V_QHPL_DSDON)  is not null) THEN
                        UPDATE  GDTTT_DON
                             SET QHPL_TEXT=V_QHPL_HSDON,
                                LOAI_GDTTTT = V_LOAI_GDTTTT
                             WHERE ID=V_GDTTT_DON_ID;
                     END IF;    
                  --UPDATE BỊ CAO
                    IF (TRIM(V_BIDON) is not null) THEN
                        SELECT GDTTT_DON_DUONGSU_CC_SEQ.NEXTVAL INTO V_BIDON_ID  FROM DUAL;  
                         INSERT INTO GDTTT_DON_DUONGSU_CC
                            (ID,DONID,LOAI,
                            BICAOID,HS_TUCACHTOTUNG,HS_ISKHIEUNAI,HS_BICANDAUVU,HS_ISBICAO,TUCACHTOTUNG,
                            TENDUONGSU,GIOITINH,ISINPUTADDRESS,NGAYTAO,NGUOITAO)
                          VALUES 
                             (V_BIDON_ID,V_GDTTT_DON_ID,2,
                             0,'',0,1,1,'',
                             V_BIDON,2,0,SYSDATE,V_USERNAME_NHAN);
                        -- INSERT TOI DANH
                        SELECT GDTTT_DON_DUONGSU_TOIDANH_CC_SEQ.NEXTVAL INTO V_TOIDANH_ID  FROM DUAL; 
                        IF(V_QHPL_HSDON > 0 AND V_QHPL_HSDON IS NOT NULL) THEN
                             SELECT TD.DIEU ||'.'|| TD.TENTOIDANH 
                                ||' ('|| DECODE(BL.ID,7,'BLHS 2017',53,'LHS 1985',54,'LHS 2015',51,'LHS 2009',52,'LHS 1999')||')'
                                INTO V_TENTOIDANH 
                                from DM_BOLUAT_TOIDANH TD
                                INNER JOIN DM_BOLUAT BL ON BL.ID=TD.LUATID
                                    WHERE  TD.LUATID IN (7,51,52,53,54) AND TD.LOAI = 2
                                         AND TD.ID = V_QHPL_HSDON;
                            --update ten toi danh vao duong su
                             UPDATE  GDTTT_DON_DUONGSU_CC
                                SET HS_TENTOIDANH=V_TENTOIDANH
                                WHERE ID=V_BIDON_ID; 
                        END IF;
                        --UPDATE TOI DANH
                        INSERT INTO GDTTT_DON_DUONGSU_TOIDANH_CC 
                            (ID,DUONGSUID,DONID,TOIDANHID,TENTOIDANH)
                            VALUES
                             (V_TOIDANH_ID,V_BIDON_ID,V_GDTTT_DON_ID,V_QHPL_HSDON,V_TENTOIDANH);
                    END IF;
                 ELSE
                    --UPDATE QUAN HE PHAP LUAT
                    IF (TRIM (V_QHPL_DSDON)  is not null) THEN
                        UPDATE  GDTTT_DON
                             SET QHPL_TEXT=V_QHPL_DSDON,
                                LOAI_GDTTTT = V_LOAI_GDTTTT
                             WHERE ID=V_GDTTT_DON_ID;
                     END IF;
                    --UPDATE BI DON
                    IF (TRIM(V_BIDON) is not null) THEN
                        SELECT GDTTT_DON_DUONGSU_CC_SEQ.NEXTVAL INTO V_BIDON_ID  FROM DUAL; 
    
                         INSERT INTO GDTTT_DON_DUONGSU_CC
                            (ID,DONID,LOAI,TUCACHTOTUNG,TENDUONGSU,GIOITINH,ISINPUTADDRESS,NGAYTAO,NGUOITAO)
                          VALUES 
                             (V_BIDON_ID,V_GDTTT_DON_ID,2,'BIDON',V_BIDON,2,0,SYSDATE,V_USERNAME_NHAN);
                    END IF;
                    --UPDATE NGUYEN DON
                    IF (TRIM(V_NGUYENDON) is not null) THEN
                        SELECT GDTTT_DON_DUONGSU_CC_SEQ.NEXTVAL INTO V_NGUYENDON_ID  FROM DUAL;  
                         INSERT INTO GDTTT_DON_DUONGSU_CC
                            (ID,DONID,LOAI,TUCACHTOTUNG,TENDUONGSU,GIOITINH,ISINPUTADDRESS,NGAYTAO,NGUOITAO)
                          VALUES 
                             (V_NGUYENDON_ID,V_GDTTT_DON_ID,2,'NGUYENDON',V_NGUYENDON,2,0,SYSDATE,V_USERNAME_NHAN);
                    END IF;
                 END IF;
                END IF;
            ELSIF(V_LOAI_VB in (7,8))THEN
                 ---INSERT----------
                INSERT INTO GDTTT_DON
                    (ID,TOAANID,LOAIDON,NGAYTAO,SOHIEUDON,BAQD_CAPXETXU,NGAYNHANDON)
                VALUES 
                     (V_GDTTT_DON_ID,V_TOAANID,V_LOAI_VB,SYSDATE,V_SODEN,V_CAP_XX_DON,V_NGAY_DEN);
                      ---UPDATE-----------
                 --CD_LOAI=0 Nơi chuyển đến nội bộ (giá trị set tạm)
                 --ISTHULY=1 Thụ lý mới đơn (giá trị set tạm)
                 --,CD_LOAI=0,ISTHULY=1(giá trị set tạm)
                  UPDATE  GDTTT_DON
                     SET CD_TA_DONVIID=V_CD_TA_DONVIID,CD_LOAI=0
                     ,GHICHU=V_GHICHU,NGUOIGUI_HUYENID=V_DIACHI_GUI_BT_ID,NGUOIGUI_HOTEN=V_NGUOI_GUI_BT,DONGKHIEUNAI=V_NGUOI_GUI_BT,CV_TENDONVI=V_DONVICHUYEN_CV
                     ,NGUOIGUI_DIACHI=V_DIACHI_GUI_BT,TT=V_TT,MADON=V_MADON,NGAYGHITRENDON=null--NGAYGHITRENDON=V_NGAY_BT
                     WHERE ID=V_GDTTT_DON_ID;
            END IF;
            -- UPDATE NGUYEN DON
            --------------------
            UPDATE VT_CHUYEN_NHAN
            SET CANBO_NHAN_ID=V_CANBO_NHAN_ID,NGAY_NHAN=SYSDATE,TRANG_THAI_XLY=3,GDTTT_DON_ID=V_GDTTT_DON_ID --TRANG_THAI_XLY=3 đã nhận chưa xử lý =4 đã nhận đã xử lý
            ,USERNAME_NHAN=V_USERNAME_NHAN
            WHERE VANBANDEN_ID=V_VANBANDEN_ID;
        
        END IF;
        ------------
END VT_NHAN_INS_UP;
PROCEDURE  VT_HUY_NHAN
( 
  V_VANBANDEN_ID IN VARCHAR2,
  V_TRANG_THAI_XLY OUT VARCHAR2
)
IS  
             V_GDTTT_DON_ID NUMBER;
BEGIN
       SELECT TRANG_THAI_XLY,GDTTT_DON_ID INTO V_TRANG_THAI_XLY,V_GDTTT_DON_ID FROM VT_CHUYEN_NHAN cn WHERE cn.VANBANDEN_ID=V_VANBANDEN_ID;
       --V_TRANG_THAI_XLY =3 HCTP chưa xử lý, V_TRANG_THAI_XLY =4 HCTP đã xử lý
       IF(V_TRANG_THAI_XLY =3) THEN
         UPDATE VT_CHUYEN_NHAN
            SET  CANBO_NHAN_ID=NULL,NGAY_NHAN=NULL,TRANG_THAI_XLY=NULL,GDTTT_DON_ID=NULL,USERNAME_NHAN=NULL
            WHERE VANBANDEN_ID=V_VANBANDEN_ID;
          ------------   
          DELETE GDTTT_DON_DS_KN_CC WHERE DONID=V_GDTTT_DON_ID;         
          DELETE GDTTT_DON_DUONGSU_TOIDANH_CC WHERE DONID=V_GDTTT_DON_ID;
          DELETE GDTTT_DON_DUONGSU_CC WHERE DONID=V_GDTTT_DON_ID;
          DELETE GDTTT_DON WHERE ID=V_GDTTT_DON_ID; 
          ------------
        END IF;
END VT_HUY_NHAN;
PROCEDURE VT_DAXULY_UP
    (
        V_GDTTT_DON_ID IN VARCHAR2
    )
AS 
        V_COUNT_DON NUMBER;
BEGIN 
       SELECT COUNT(*) INTO V_COUNT_DON FROM VT_CHUYEN_NHAN VT WHERE VT.GDTTT_DON_ID=V_GDTTT_DON_ID;
       IF(V_COUNT_DON>0)THEN
            UPDATE VT_CHUYEN_NHAN
            SET TRANG_THAI_XLY=4
            WHERE GDTTT_DON_ID=V_GDTTT_DON_ID;
        END IF;
END VT_DAXULY_UP;
PROCEDURE VT_VANBANDEN_BY_ID_VBDH
    (
        V_ID_VBDH IN NUMBER,
        CurReturn OUT sys_refcursor 
    )
IS
BEGIN
    OPEN curReturn FOR
     SELECT a.* FROM VT_VANBANDEN a WHERE a.ID_VBDH = V_ID_VBDH;
END;
PROCEDURE VT_CHUYENNHAN_BY_VANBANDEN_ID
    (
        V_VANBANDEN_ID IN NUMBER,
        CurReturn OUT sys_refcursor
    )
IS
BEGIN
    OPEN curReturn FOR
     SELECT a.* FROM VT_CHUYEN_NHAN a WHERE a.VANBANDEN_ID = V_VANBANDEN_ID;
END;
PROCEDURE TRANG_THAI_XLY_UP
    (
        V_ID IN NUMBER,
        V_TRANG_THAI_XLY IN NUMBER
    )
IS
BEGIN
	UPDATE VT_CHUYEN_NHAN SET TRANG_THAI_XLY = V_TRANG_THAI_XLY WHERE ID = V_ID;
END;
END PKG_VANTHU_DEN;

/
