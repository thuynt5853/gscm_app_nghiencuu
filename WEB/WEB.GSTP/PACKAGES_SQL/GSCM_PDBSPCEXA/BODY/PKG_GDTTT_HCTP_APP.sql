create or replace NONEDITIONABLE PACKAGE BODY "PKG_GDTTT_HCTP_APP" AS

FUNCTION TLXXGDT_GETMAXTT
(   vToaanid in number,
    vYear in number,
    vLoaian in number
)RETURN NUMBER AS 
    vY number;
    v_maxTLxxgdt number;
BEGIN
 
    vY:=vYear;
 
    select Max(to_number(tt.sotlxx)) into v_maxTLxxgdt
        from (
            select              
                lower(DECODE(INSTR(d.TL_SO,'/')
                            ,0,decode(INSTR(d.TL_SO,'0'),1,regexp_replace(d.TL_SO,'0','',1,1),d.TL_SO),decode(INSTR(d.TL_SO,'0')
                            ,1,SUBSTR(regexp_replace(d.TL_SO,'0','',1,1),1,instr(regexp_replace(d.TL_SO,'0','',1,1),'/')-1),SUBSTR(d.TL_SO,1,instr(d.TL_SO,'/')-1) )
                             )
                        ) as sotlxx 
                from gdttt_don d
              Where d.TOAANID=vToaanid  
                And d.LOAIDON = 4
                and d.TL_NGAY between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
                and d.BAQD_LOAIAN = vLoaian
             UNION ALL 
             select 
                 lower(DECODE(INSTR(v.SOTHULYXXGDT,'/')
                            ,0,decode(INSTR(v.SOTHULYXXGDT,'0'),1,regexp_replace(v.SOTHULYXXGDT,'0','',1,1),v.SOTHULYXXGDT),decode(INSTR(v.SOTHULYXXGDT,'0')
                            ,1,SUBSTR(regexp_replace(v.SOTHULYXXGDT,'0','',1,1),1,instr(regexp_replace(v.SOTHULYXXGDT,'0','',1,1),'/')-1),SUBSTR(v.SOTHULYXXGDT,1,instr(v.SOTHULYXXGDT,'/')-1) )
                             )
                        ) as sotlxx 
                from gdttt_vuan v 
                    where  
                     v.toaanid = vToaanid
                        and v.LOAIAN = vLoaian
                        and NVL(v.IsVienTruongKN,0) = 0
                        and v.GQD_LOAIKETQUA = 1 -- Kháng nghị
                        and NVL(v.truonghopthuly,0) not in (8,10,1) -- Đơn khiếu nại tư pháp và ho so kn
                        and v.NGAYTHULYXXGDT between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
                    
    )tt;
    
    return NVL(v_maxTLxxgdt,0);
END TLXXGDT_GETMAXTT;


FUNCTION CHECK_SOVANBAN
(  
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
    
    SELECT COUNT(a.ID) INTO V_COUNT FROM QUANLY_SOPHATHANH a 
                                WHERE a.ToaAnID = vToaAnID 
                                    AND a.PhongbanID = vPhongbanID 
                                    AND a.MASO = vLoaiSO
                                    AND a.SOVB = vSoVB
                                    AND to_char(a.NGAYVB,'dd/MM/yyyy') = vNgayVB;
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;  
    
END CHECK_SOVANBAN;

PROCEDURE QUANLYSOVB_HCTP
( 
    vToaAnID in number,
    vPhongbanID in number,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2,
    vNgayVB_den in varchar2,
    PageIndex	in	int,
    PageSize	in	int,
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
    MinIndex	number;
    MaxIndex	number;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;

  OPEN curReturn FOR
      select /*PKG_GDTTT_HCTP_APP.QUANLYSOVB_HCTP (Quan ly sổ văn ban hctp cc)*/  a.*
                from (Select  ROW_NUMBER() OVER (ORDER BY svb.NGAYTAO desc) STT, COUNT(*) OVER () as CountAll, 
                               svb.id, svb.MASO,lvb.TEN AS TENSO,svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB,svb.NGUOIKY,
                               sd.soluongdon, Decode(NVL(tt.trangthai,0),0,'Chưa chuyển','Đã chuyển') trangthai,
                               svb.NGAYTAO,svb.NGUOITAO,svb.NGUOISUA,svb.NGAYSUA
                            from QUANLY_SOPHATHANH svb
                                left join (select SOPHATHANH_ID,count(*) soluongdon from SOPHATHANH_DON group by SOPHATHANH_ID) sd on svb.id = sd.SOPHATHANH_ID                               
                                left join DM_DATAITEM lvb on lvb.ma = svb.MASO
                                left join (Select dvb.SOPHATHANH_ID,count(d.ID) trangthai 
                                                        From SOPHATHANH_DON dvb 
                                                           left join GDTTT_DON d on dvb.DONID = d.id
                                                          Where  d.CD_TRANGTHAI in (1,2)
                                                                group by dvb.SOPHATHANH_ID) tt on svb.id = tt.SOPHATHANH_ID
                             where 
                                 svb.TOAANID=vToaAnID
                                and svb.PHONGBANID = vPhongbanID
                                and (vLoaiSO = '0' Or svb.MASO  = vLoaiSO)
                                and (vSoVB is null or lower(svb.SOVB)=lower(vSoVB))
                                and ( (vNgayVB is null or ( vNgayVB_den is null and to_char(svb.NGAYVB,'dd/MM/yyyy')=vNgayVB))
                                        OR (vNgayVB_den is null or ( vNgayVB is null and to_char(svb.NGAYVB,'dd/MM/yyyy')=vNgayVB_den))
                                        OR (vNgayVB is not null and vNgayVB_den is not null and svb.NGAYVB between to_Date(vNgayVB,'dd/MM/yyyy') and  to_Date(vNgayVB_den,'dd/MM/yyyy') ) 
                                    )
         ) a where a.stt>=MinIndex and a.stt<=MaxIndex;

END QUANLYSOVB_HCTP;

PROCEDURE DON_CVCHUYEN_CHECK
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
)
IS 
vY number;
BEGIN

OPEN curReturn FOR  
  Select count(d.ID) vcheck
  From SOPHATHANH_DON dvb
  left join GDTTT_DON d on dvb.DONID = d.id
  Where dvb.SOPHATHANH_ID=vSOPHATHANH_ID
        and  d.CD_TRANGTHAI in (1,2); -- don đã chuyen hoac đã nhận

END DON_CVCHUYEN_CHECK;

FUNCTION SOVANBAN_INSERT
(  
    v_ToaAnID in number,
    v_PhongbanID in number,
    v_MASO   IN VARCHAR2,
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER AS
    vPHATHANHID NUMBER;
BEGIN
SAVEPOINT P1;     
        vPHATHANHID:= QUANLY_SOPHATHANH_SEQ.NEXTVAL;
        --1.INNSERT SOPHATHANH
        INSERT INTO QUANLY_SOPHATHANH (ID,TOAANID,PHONGBANID,MASO,SOVB,NGAYVB,NGUOIKY,NGUOITAO,NGAYTAO)
                            VALUES (vPHATHANHID,v_ToaAnID,v_PhongbanID,v_MASO,v_SOVB,to_date(v_NGAYVB,'dd/MM/yyyy'),v_NGUOIKY,V_NGUOITAO,SYSDATE);
       RETURN vPHATHANHID;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_INSERT;

FUNCTION SOPHATHANH_DON_INSERT
(  
    v_PHATHANHID IN NUMBER,
    v_DONID     IN NUMBER,
    V_NGUOITAO IN VARCHAR2
)RETURN NUMBER AS
BEGIN
SAVEPOINT P1;     
            --2.INSERT SOPHATHANH_DON
           Insert Into SOPHATHANH_DON (ID,SOPHATHANH_ID,DONID,NGUOITAO,NGAYTAO)
                                    VALUES (SOPHATHANH_DON_SEQ.nextval,v_PHATHANHID,v_DONID,V_NGUOITAO,SYSDATE);
           
           RETURN 1;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOPHATHANH_DON_INSERT;

FUNCTION SOVANBAN_UPDATE
(  
    v_SOPHATHANH_ID in number, 
    v_SOVB     IN VARCHAR2,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    V_NGUOISUA IN VARCHAR2
)RETURN NUMBER AS
    vPHATHANHID NUMBER;
BEGIN
    SAVEPOINT P1;
    --Update--------
    UPDATE QUANLY_SOPHATHANH 
                SET SOVB = v_SOVB 
                ,NGAYVB = to_date(v_NGAYVB,'dd/MM/yyyy')
                ,NGUOIKY  = v_NGUOIKY
                ,NGUOISUA = V_NGUOISUA
                ,NGAYSUA  = SYSDATE
                WHERE ID = v_SOPHATHANH_ID;
        RETURN 1;
        
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_UPDATE;

FUNCTION SOVANBAN_DEL_ALL
(  
    v_SOPHATHANH_ID in number
)RETURN NUMBER AS
BEGIN
    --Xoa don khoi Sổ Văn Đơn
    SAVEPOINT P1;
    DELETE SOPHATHANH_DON WHERE SOPHATHANH_ID = v_SOPHATHANH_ID;
    DELETE QUANLY_SOPHATHANH WHERE ID = v_SOPHATHANH_ID;
    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_DEL_ALL;

FUNCTION SOVANBAN_DEL_ONE
(  
    v_SOVB_DONID in number
)RETURN NUMBER AS
BEGIN
    --Xoa don khoi Sổ Văn Đơn
    SAVEPOINT P1;
    DELETE SOPHATHANH_DON WHERE ID = v_SOVB_DONID;
    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBAN_DEL_ONE;

PROCEDURE SUAVANBAN_SEARCH
( 
    vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
    MinIndex	number;
    MaxIndex	number;
BEGIN

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
			from (
  Select /*PKG_GDTTT_HCTP_APP.SUACONGVAN_SEARCH (Sua Cong Van)*/ ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB ,svb.NGUOIKY NGUOIKY,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then  d.KN_SOQD Else d.BAQD_SO END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(d.ToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN)) Infor_PT
        ,NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU 
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển' when 1 then  'Đã chuyển' when 2 then  'Đã nhận' when 3 then  'Bị trả lại' else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET  
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

         ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          ) arrCongvan

        ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

            , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=3 then '<b> Xử lý khác ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||to_char(va.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            when NVL(va.GQD_LOAIKETQUA,5)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 5, 'Đang giải quyết'
                                          , 2, u'X\1ebfp \0111\01a1n'  
                                          , 1,decode(d.loaidon,8,'Không chấp nhận khiếu nại',10,'Không chấp nhận khiếu nại',u'Kh\00e1ng ngh\1ecb')
                                          , 0,decode(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',u'Tr\1ea3 l\1eddi \0111\01a1n') 
                                          ,4,'Thông báo VKS đang giải quyết'
                                          )
                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end   
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG,
              lvb.ten TenSOVB
    from SOPHATHANH_DON dvb
        left join QUANLY_SOPHATHANH svb on svb.id = dvb.SOPHATHANH_ID
        left join DM_DATAITEM lvb on lvb.ma = svb.MASO
        left join GDTTT_DON d on dvb.DONID = d.id
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
        left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NgayPhatHanhCV from GDTTT_VuAn) va on va.ID = d.VuViecID
     where dvb.SOPHATHANH_ID=vSOPHATHANH_ID
        and dvb.TRANGTHAI in (1)
        order by d.NGAYTAO desc
     ) a;


END SUAVANBAN_SEARCH;




PROCEDURE  DM_CANBO_GETBYDONVI_2CHUCVU 
(
  vDonViID in number,
  vChucVu1 in varchar2,
  vChucVu2 in varchar2,
  CurReturn OUT sys_refcursor 
) AS 
  vGroupChucDanhID number;
  vGroupChucVuID number;
BEGIN
  select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
  select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';
  open CurReturn for
  select a.ID,a.HOTEN,a.HOTEN || '-' || d.TEN as MA_TEN,d.TEN as ChucVu,a.HOTEN || '-' || d.TEN||DECODE(a.HIEULUC,0,' (Nghỉ công tác)',NULL) HOTEN_STATUS  from DM_CANBO a
    inner join (select c.ID,c.TEN from DM_DATAITEM c where c.GROUPID=vGroupChucDanhID ) b on b.ID=a.CHUCDANHID
    inner join (select c.ID,c.TEN, c.ThuTu from DM_DATAITEM c 
                where c.GROUPID=vGroupChucVuID and (c.MA=vChucVu1 Or c.MA=vChucVu2)) d on d.ID=a.CHUCVUID
  where a.TOAANID=vDonViID 
  And a.HIEULUC=1
  order by d.ThuTu;
END DM_CANBO_GETBYDONVI_2CHUCVU;
PROCEDURE CHECK_DONTRUNGID
( 
    V_ID in number,
    V_IS_DONTRUNG OUT number
)
IS 
     V_DONTRUNGID NUMBER;V_COUNT_DONTRUNG NUMBER;
BEGIN
   V_IS_DONTRUNG:=1;--ton tai trong group đơn gốc
   SELECT DONTRUNGID INTO V_DONTRUNGID  FROM GDTTT_DON D WHERE D.ID =V_ID;
   IF(V_DONTRUNGID IS NULL OR V_DONTRUNGID =0) THEN
       SELECT COUNT(*) INTO V_COUNT_DONTRUNG  FROM GDTTT_DON D WHERE D.DONTRUNGID =V_ID;
        IF(V_COUNT_DONTRUNG=0)THEN
        V_IS_DONTRUNG:=0;--không tồn tại trong group đơn gốc
        END IF;
   END IF;
END;
PROCEDURE CANBO_GETBYDONVI
( 
   v_CANBO_ID in varchar2,
   donviID in number,
   vChucDanh in varchar2,
   curReturn    OUT       sys_refcursor
)
IS 
    vGroupChucDanhID number;TOTAL_CHECK number;
    vChucvuid number;
BEGIN
    SELECT COUNT(*)INTO TOTAL_CHECK FROM DM_CANBO c 
    INNER JOIN (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=12 and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC'))d1 on d1.ID=c.CHUCDANHID
    WHERE C.ID=v_CANBO_ID;
    ------
 select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
    if(vChucDanh='TP') then
          Select c.chucvuid into vChucvuid from DM_CANBO c where c.id = v_CANBO_ID;
--    Nếu là PCA hoac CA thi phai lay them các Tham phan ma minh phu trach de cho tim kiem
        if (vChucvuid in (74,46)) THEN
                OPEN curReturn FOR 
                            Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
                              ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
                              ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
                                || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
                                || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
                                || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
                            From DM_CANBO c
                             inner join DM_TOAAN t on c.TOAANID=t.ID
                             inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
                             left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
                            WHere c.TOAANID=donviID AND (TOTAL_CHECK=0 OR (C.ID=v_CANBO_ID AND TOTAL_CHECK!=0))
                               -- manh them cả nguoi da nghi huu    
                              And (c.HIEULUC=1 or c.HIEULUC=0) 
                              --OR C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
                              AND (c.MADONGBO IS NOT NULL) --anhvh add 07/09/2020 chỉ lấy những cán bộ mà đồng bộ với pm cán bộ
                              and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                                                  c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                        union 
                            Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
                              ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
                              ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
                                || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
                                || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
                                || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
                                From DM_CANBO c
                                 inner join DM_TOAAN t on c.TOAANID=t.ID
                                 inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
                                 left join (Select * from DM_CANBO where id = v_CANBO_ID) PCA on PCA.CHUCDANHID = c.CHUCDANHID
                                 left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
                                WHere c.TOAANID=donviID 
                                   -- manh them cả nguoi da nghi huu    
                                        and c.HIEULUC=1 and c.CHUCDANHID = 486 and c.chucvuid is null
                                        and (
                                                (c.ISHINHSU= PCA.ISHINHSU and c.ISHINHSU=1)
                                                Or (c.ISDANSU= PCA.ISDANSU and c.ISDANSU=1 )
                                                Or (c.ISHNGD=PCA.ISHNGD  and c.ISHNGD=1 )
                                                Or (c.ISKDTM=PCA.ISKDTM  and c.ISKDTM=1 )
                                                Or (c.ISLAODONG=PCA.ISLAODONG   and c.ISLAODONG=1 )
                                                Or (c.ISHANHCHINH=PCA.ISHANHCHINH  and c.ISHANHCHINH=1 ) 
                                                Or (c.ISPHASAN=PCA.ISPHASAN and c.ISPHASAN=1 ) 
                                                )
                                        and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                    ;

        ELSE
             OPEN curReturn FOR 
                Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
                  ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
                  ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
                    || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
                    || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
                    || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
                From DM_CANBO c
                 inner join DM_TOAAN t on c.TOAANID=t.ID
                 inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')) d1 on d1.ID=c.CHUCDANHID
                 left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
                WHere c.TOAANID=donviID AND (TOTAL_CHECK=0 OR (C.ID=v_CANBO_ID AND TOTAL_CHECK!=0))
                   -- manh them cả nguoi da nghi huu    
                  And (c.HIEULUC=1 or c.HIEULUC=0) 
                  --OR C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
                  AND (c.MADONGBO IS NOT NULL) --anhvh add 07/09/2020 chỉ lấy những cán bộ mà đồng bộ với pm cán bộ
                  and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                                      c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
                Order by c.Hoten;
        END IF;
    elsif(vChucDanh='TTV') then
         OPEN curReturn FOR 
            Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
              ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU     
            From DM_CANBO c
             inner join DM_TOAAN t on c.TOAANID=t.ID
             inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TTV','TTVCC','TTVC')) d1 on d1.ID=c.CHUCDANHID
             left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
            WHere c.TOAANID=donviID
            Order by c.Hoten;    
    Else
         OPEN curReturn FOR 
            Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
              ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
              ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
                || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
                || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
                || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
            From DM_CANBO c
             inner join DM_TOAAN t on c.TOAANID=t.ID
             inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA=vChucDanh) d1 on d1.ID=c.CHUCDANHID
             left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
            WHere c.TOAANID=donviID
              And c.HIEULUC=1
            Order by c.Hoten;
    End if;    
END CANBO_GETBYDONVI;
--------------------------------------------------------------------
PROCEDURE SUACONGVAN_SEARCH
( 
    vToaAnID in number,
    vSoCongVan in varchar2,
    vNgayCongVan in varchar2,
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
    MinIndex	number;
    MaxIndex	number;
BEGIN

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
			from (
  Select /*PKG_GDTTT_HCTP_APP.SUACONGVAN_SEARCH (Sua Cong Van)*/ ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,to_char(d.CD_NGAYCV,'dd/MM/yyyy') CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then  d.KN_SOQD Else d.BAQD_SO END) BAQD_SO
--      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else ('BA: ' || d.BAQD_SO) END) BAQD
--      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else d.BAQD_NGAYBA END) BAQD_NGAYBA
--      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN)) Infor_PT
        ,NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU 
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển' when 1 then  'Đã chuyển' when 2 then  'Đã nhận' when 3 then  'Bị trả lại' else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET  
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

         ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          ) arrCongvan

        ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

            , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=3 then '<b> Xử lý khác ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||to_char(va.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            when NVL(va.GQD_LOAIKETQUA,5)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 5, 'Đang giải quyết'
                                          , 2, u'X\1ebfp \0111\01a1n'  
                                          , 1,decode(d.loaidon,8,'Không chấp nhận khiếu nại',10,'Không chấp nhận khiếu nại',u'Kh\00e1ng ngh\1ecb')
                                          , 0,decode(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',u'Tr\1ea3 l\1eddi \0111\01a1n') 
                                          ,4,'Thông báo VKS đang giải quyết'
                                          )
                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end   
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
    from GDTTT_DON d
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID

        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
        left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NgayPhatHanhCV from GDTTT_VuAn) va on va.ID = d.VuViecID
     where (vSoCongVan is not null and lower(d.CD_SOCV)=lower(vSoCongVan))
        and d.TOAANID=vToaAnID
        and ((vNgayCongVan is null) or (vNgayCongVan is not null and  to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan))
        and d.CD_TRANGTHAI in (0,3)
        order by d.NGAYTAO desc
     ) a;


END SUACONGVAN_SEARCH;
PROCEDURE CANBO_GETBYDONVI_XX
( donviID in number,
  vChucDanh in varchar2,
	curReturn    OUT       sys_refcursor
)
IS 
vGroupChucDanhID number;
BEGIN
 select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
 if(vChucDanh='TP') then
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TPTATC')) d1 on d1.ID=c.CHUCDANHID--'TP','TPSC','TPTC','TPCC', chỉ lấy tp tối cao
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
      And c.HIEULUC=1 and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                          c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
      AND C.TRANGTHAI_XETXU=1 --anhvh add 19/09/2020 chỉ lấy những thẩm phán đang xét xử                   
    Order by c.Hoten;
elsif(vChucDanh='TTV') then
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU     
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TTV','TTVCC','TTVC')) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
    Order by c.Hoten;    
Else
 OPEN curReturn FOR 
    Select c.ID,c.MACANBO,c.Hoten,c.CHUCDANHID,c.CHUCVUID
      ,(c.Hoten || ' - ' || d1.TEN || ' - ' || d2.TEN) as MA_TEN,t.TEN as TenDonVi,d1.TEN as TENCHUCDANH, d2.TEN as TENCHUCVU
      ,((Case c.ISHINHSU when 1 then 'HS, ' Else '' End)  || (Case c.ISDANSU when 1 then 'DS, ' Else '' End) 
        || (Case c.ISHNGD when 1 then 'HN, ' Else '' End) || (Case c.ISKDTM when 1 then 'KD, ' Else '' End)
        || (Case c.ISLAODONG when 1 then 'LĐ, ' Else '' End) || (Case c.ISHANHCHINH when 1 then 'HC, ' Else '' End)
        || (Case c.ISPHASAN when 1 then 'PS, ' Else '' End) || (Case c.ISBPXLHC when 1 then 'XLHC' Else '' End)) LINHVUC
    From DM_CANBO c
     inner join DM_TOAAN t on c.TOAANID=t.ID
     inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA=vChucDanh) d1 on d1.ID=c.CHUCDANHID
     left join DM_DATAITEM d2  on d2.ID=c.CHUCVUID
    WHere c.TOAANID=donviID
      And c.HIEULUC=1
    Order by c.Hoten;
End if;    
END CANBO_GETBYDONVI_XX;
PROCEDURE  GDTTT_VUAN_GETALLCBTHEOPB
(  vPhongBanID in number
, vToaAnID in number, vChucDanh in varchar2
,	curReturn    OUT       sys_refcursor
)
as
   vGroupChucDanhID number;
   vGroupChucVuID number;
BEGIN
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';  
   select a.ID into vGroupChucVuID from DM_DATAGROUP a where a.MA='CHUCVU';

   ------------------------------------------------ 
 if(vChucDanh='TTV') then
    OPEN curReturn FOR 
     select a.ID, a.HoTen, a.HieuLuc
     from 
      ( (  Select c.ID, c.Hoten, 1 HieuLuc
            From DM_CANBO c
             inner join (select i.ID,i.TEN from DM_DATAITEM i 
                          where i.GROUPID=vGroupChucDanhID and i.MA in ('TTV','TTVCC','TTVC','TK1','TK','TKVC','C027','C010','C008','C009')
                        ) d1 on d1.ID=c.CHUCDANHID           
            WHere c.TOAANID=vToaAnID  and c.Phongbanid=vPhongBanID and c.HieuLuc=1   
         ) union 
         (
          select distinct a.ThamTraVienID ID, (b.HoTen||' (N)') HoTen, 0 HieuLuc
            from GDTTT_VuAn a
              inner join (select Id, HoTen, PhongBanID from DM_CanBo
                          where NVL(HieuLuc,0)=0 or NVL(PhongBanID,0)<> vPhongBanID) b on a.ThamTraVienId = b.ID
            where NVL(a.ThamTraVienId, 0)>0
                and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
         )
      ) a order by a.HieuLuc desc,a.HoTen;
  elsif(vChucDanh='TP') then
    OPEN curReturn FOR 
       select a.ID, a.HoTen, a.HieuLuc
       from 
        ( ( Select c.ID,c.HoTen,1 HieuLuc From DM_CANBO c
             inner join (select i.ID, i.TEN from DM_DATAITEM i 
                         where i.GROUPID=vGroupChucDanhID 
                              and i.MA in ('TP','TPSC','TPTC','TPCC','TPTATC')
                        ) d1 on d1.ID=c.CHUCDANHID    
             left join (select c.ID, c.TEN from DM_DATAITEM c 
                          where c.GROUPID=vGroupChucVuID  and c.Ma in ('CA', 'PCA')
                        ) d on d.ID=c.CHUCVUID    
              WHere c.TOAANID=vToaAnID  and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0 OR C.ID=40599)-- C.ID=40599 anhvh 16/09/2020 add ngoai lệ TP Dương văn Thăng vẫn được phân án                                   
              And c.HIEULUC=1 and (c.ISHINHSU=1 Or c.ISDANSU=1 Or c.ISHNGD=1 Or c.ISKDTM=1 Or
                                  c.ISLAODONG=1 Or c.ISHANHCHINH=1 Or c.ISPHASAN=1)
              AND C.TRANGTHAI_XETXU=1 --anhvh add 19/09/2020 trang thai dang xet xử                    
           ) union 
           (
            select distinct a.ThamPhanID ID, (b.HoTen||' (N)') HoTen, 0 HieuLuc 
            from GDTTT_VuAn a
                inner join (select Id, HoTen, PhongBanID from DM_CanBo
                            where NVL(HieuLuc,0)=0 or NVL(TOAANID,0)<> vToaAnID
                            ) b on a.ThamPhanID = b.ID
              where NVL(a.ThamPhanID, 0)>0
                  and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
           )
        ) a order by a.HieuLuc desc, a.HoTen;
    elsif(vChucDanh='LDV') then
    OPEN curReturn FOR 
       select a.ID, a.HoTen, a.HieuLuc
       from (
            ( Select c.ID,c.Hoten, 1 HieuLuc From DM_CANBO c
                  inner join (select i.ID,i.TEN from DM_DATAITEM i 
                              where i.GROUPID=vGroupChucVuID and (i.MA='PVT' or i.Ma='VT')
                             ) d1 on d1.ID=c.CHUCVUID    
              WHere c.TOAANID=vToaAnID and c.Phongbanid=vPhongBanID and c.HieuLuc=1
               and (c.MaDongBo is not null or Length(NVL(c.Madongbo,''))>0)
            )
            union 
           (
            select distinct a.LanhDaoVuId ID, (b.HoTen||' (N)') HoTen, 0 HieuLuc
            from GDTTT_VuAn a
                inner join (select Id, HoTen, PhongBanID from DM_CanBo
                            where NVL(HieuLuc,0)=0 or NVL(PhongBanID,0)<> vPhongBanID) b on a.LanhDaoVuId = b.ID
              where NVL(a.LanhDaoVuId, 0)>0
                  and a.ToaAnID =vToaAnID and a.PhongBanId =vPhongBanID
           )
       ) a order by a.HieuLuc desc, a.HoTen;
    end if;
end GDTTT_VuAn_GetAllCBTheoPB;
PROCEDURE DON_SEARCH
( 
    V_NDBD_VALUE VARCHAR2,
    V_NDBD_TEXT VARCHAR2,
    --van thu don den----
    V_DONVI_CHUYEN_ID in  VARCHAR2,
    V_TRANGTHAICHUYEN in	VARCHAR2,
    V_LOAI_VB	in	VARCHAR2,
    V_SODEN_TU	in	VARCHAR2,
    V_SODEN_DEN	in	VARCHAR2,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    --van thu don den end----
    v_ID_USER VARCHAR2,
    vToaAnID in number,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vSoCMND in varchar2,
    vTuNgay in date,
    vDenNgay in date,
    vHinhThucDon in number,
    vSoHieuDon in varchar2,
    vDiaChiTinh in number,
    vDiaChiHuyen in number,
    vDiaChiCT in varchar2,
    vSoCongVan in varchar2,
    vNgayCongVan in varchar2,
    vTraLoi in number,
    vNguoiNhap in varchar2,
    vNoiChuyen in number,
    vTrangthai in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    vNgaychuyenTu in date,
    vNgaychuyenDen in date,
    vArrSelectID in varchar2,
    vIsThuLy in number,
    vPhanloaixuly in number,
    vNgayThulyTu in date,
    vNgayThulyDen in date,
    vSoThuly in varchar2,
    vChidao in number,
    vTraigiam in number,
    vTBQuahan in number,
    vNgayQuahan in date,
    vThamphanID in number,
    vThamtravienID in number,
    vLoaiCVID in number,
    vNgayNhapTu in date,
    vNgayNhapDen in date,
    vIsDonGoc in number,
    vIsTuHinh in number,
    vLoaiAn in number,
    vCVPC_So in varchar2,
    vCVPC_Ngay in varchar2,
    vCVPC_TenCQ in varchar2,
    vGuitoiCA_TA in number,
    vLOAI_GDTTT in number,

    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
)
IS 
        TotalItem number;MinIndex	number;MaxIndex	number;
        ma_chucvu varchar2(10);curr_thamphan_id number:=0;vvloaian VARCHAR2(150);
        V_CANBOID number;v_phongban number;V_CURSOR sys_refcursor;

        ------------------
        -- v_table T_GDTTT_DON_HCTP; 
BEGIN
  --v_table := T_GDTTT_DON_HCTP();  
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
  --------------
 ---anhvh add 09/09/2020 check dữ liệu theo PCA
 SELECT NSD.CANBOID,NSD.PHONGBANID INTO V_CANBOID,v_phongban FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;
  select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = V_CANBOID;
   if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
            --          manh neu can bo dang nhap la PCA hoac CA thi cho phep tim kiem theo Tham phan theo linh vuc minh quan ly 
            if V_CANBOID =  vThamphanID then
                curr_thamphan_id:=0;
            else
                curr_thamphan_id:= vThamphanID;
            end if;
    ELSE
        curr_thamphan_id:= vThamphanID;
    end if;
      ------------Truong hop nay thuong dung cho toi cao TW-------------
      IF(vIsDonGoc=1) THEN --Lọc theo tìm kiếm đơn gốc --ddlPhanloaiDdon.SelectedValue == "1" là Đơn gốc
    --Lấy danh sách đơn
     OPEN curReturn FOR
     with 
     g as       (select /*GSCM.PKG_GDTTT_HCTP_APP.DON_SEARCH (Danh sach Don HCTP) */ tt.*,  COUNT(*) OVER () as CountAll from  (Select Count(ID) SODONTRUNG,MAX(ID) ID from 
                    (select dtk.ID,(Case NVL(dtk.DONTRUNGID,0) when 0 then ID else dtk.DONTRUNGID END) DTID
                    from GDTTT_DON dtk 
                    where dtk.TOAANID= vToaAnID
                         And 1=(Case when vIsThuLy=-1 then 1 
                                    when vIsThuLy=1  and dtk.ISTHULY=1  then 1 -- TLM 
                                    when vIsThuLy=3  and dtk.ISTHULY=1 
                                                     and (vNgayNhapTu is not null and  vNgayNhapDen is not null)  
                                                     and PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(dtk.id)>1 then 1 -- TLM trùng
                                    when vIsThuLy=4  and dtk.ISTHULY=1 and  NVL(dtk.THAMPHANID,0) > 0  then 1 -- TLM đã phan cong
                                    when vIsThuLy=5  and dtk.ISTHULY=1 and  NVL(dtk.THAMPHANID,0) = 0   then 1 -- TLM chua phan cong
                                    when vIsThuLy=2  and dtk.ISTHULY=2 then 1 
                                    Else 0 End)  
                        and 
                        1=case when vToaRaBAQD=0 then 1 when dtk.BAQD_TOAANID=vToaRaBAQD 
                                                         Or dtk.BAQD_TOAANID_PT=vToaRaBAQD 
                                                         Or dtk.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end  
                       -- and 1=case when vLoaiAn=0 then 1 when dtk.BAQD_LOAIAN=vLoaiAn then 1 else 0 end  
                       --anhvh 12/02/2020
                       AND (vLoaiAn=0
                            OR(dtk.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                            OR(vLoaiAn=55 AND dtk.BAQD_LOAIAN IS NULL)
                          )

--                                                   and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(dtk.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(dtk.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--                                                    and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end   
--                                                    and (vSoBAQD || ' '=' '  Or lower(dtk.BAQD_SO) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%' 
--                                                                             Or lower(dtk.BAQD_SO_PT) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                                                                             Or lower(dtk.BAQD_SO_ST) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                                                                             Or lower(dtk.KN_SOQD) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%') 
--                                                    and  (vNgayBAQD || ' '=' ' Or  to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
--                                                                                Or to_char(dtk.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
--                                                                                Or to_char(dtk.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
--                                                                                Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
--                                                    

                        and (  ((vSoBAQD || ' '=' '  Or lower(dtk.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                                  And (vNgayBAQD || ' '=' ' Or  to_char(dtk.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                                )
                                Or((vSoBAQD || ' '=' ' Or lower(dtk.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                    And (vNgayBAQD || ' '=' ' Or to_char(dtk.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                                )
                                Or ((vSoBAQD || ' '=' ' Or lower(dtk.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                    And (vNgayBAQD || ' '=' ' Or to_char(dtk.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                                )
                                Or ((vSoBAQD || ' '=' ' Or lower(dtk.KN_SOQD) like  lower(vSoBAQD) || '%')
                                    And (vNgayBAQD || ' '=' ' Or to_char(dtk.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                                )
                             )
--                                                    
--                                                    
                        and
                        1=case when vNguoiGui || ' '=' ' then 1 when lower(DECODE(dtk.LOAIDON,6,dtk.CV_TENDONVI,decode(vToaAnID,6,dtk.NGUOIGUI_HOTEN,dtk.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                        and
                        1=case when vSoCMND || ' '=' ' then 1 when dtk.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                        and
                        1=case when vTuNgay is null then 1 when vTuNgay <= dtk.NGAYNHANDON then 1 else 0 end
                        and
                        1=case when vDenNgay is null then 1 when dtk.NGAYNHANDON <= vDenNgay then 1 else 0 end
                        and
                        1=case when vHinhThucDon=0 then 1 when dtk.LOAIDON=vHinhThucDon then 1 else 0 end
                        and
                        1=case when vSoHieuDon || ' '=' ' then 1 when (dtk.MADON =vSoHieuDon Or dtk.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                        and
                        1=case when vDiaChiTinh=0 then 1 when dtk.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                        and
                        1=case when vDiaChiHuyen=0 then 1 when dtk.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
                        and
                        1=case when vDiaChiCT || ' '=' ' then 1 when lower(dtk.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
                        and
                        1=case when vSoCongVan || ' '=' ' then 1 when ((lower(dtk.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(dtk.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(dtk.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )  and dtk.isthuly = 1) then 1 else 0 end
                        and
                        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(dtk.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(dtk.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(dtk.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
                       and
                        1=case when vCVPC_So || ' '=' ' then 1 when lower(dtk.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                        and
                        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(dtk.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                         and
                        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(dtk.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                        and
                        1=case when vTraLoi=0 then 1 when dtk.TRALOIDON=vTraLoi then 1 else 0 end
                        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(dtk.nguoitao)|| ',%') then 1 else 0 end
                        -- and 1=case when vNoiChuyen=-1 then 1 when dtk.CD_LOAI=vNoiChuyen then 1 else 0 end
                         --anhvh 13/02/2020
                        AND (vNoiChuyen=-1
                             OR(dtk.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                             OR(dtk.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                             )
                        and  1=case when vTrangthai=-1 then 1 
                              when vTrangthai=1 and   dtk.CD_TRANGTHAI in (1,2) then 1 
                              when dtk.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                        and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dtk.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                            OR (vCD_TA_TRANGTHAI=3 and NVL(dtk.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=dtk.ID)) --lanhnt thêm trạng thái đơn
                            OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=dtk.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = dtk.ID))))) then 1
                             when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dtk.CD_TK_DONVIID=vCD_DONVIID) Or
                                                    (vCD_DONVIID=-1 And dtk.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                            when (vNoiChuyen=2 and lower(dtk.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                           when (vNoiChuyen>2 and dtk.CD_LOAI=vNoiChuyen) then 1
                            else 0 end)   
                        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dtk.CD_NGAYXULY then 1 else 0 end
                        and 1=case when vNgaychuyenDen is null then 1 when dtk.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
                        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= dtk.TL_NGAY then 1 else 0 end
                        and 1=case when vNgayThulyDen is null then 1 when dtk.TL_NGAY <= vNgayThulyDen then 1 else 0 end
                        and 1=case when vSoThuly || ' '=' ' then 1 when lower(dtk.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
                        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(dtk.ID as varchar2(10)) || ',%' then 1 else 0 end
                        and 1=case when vChidao=-1 then 1 
                                    when  vChidao=0 and NVL(dtk.CHIDAO_COKHONG,0)>0 then 1 -- Có ý kiến chỉ đạo
                                    when  vChidao=1 and NVL(dtk.CHIDAO_COKHONG,0)=0 then 1 -- Không có ý kiến chỉ đạo
                                    when vChidao>1 and dtk.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
                        and 1=case when vTraigiam=-1 then 1 when NVL(dtk.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
                        and 1=case when vTBQuahan=0 then 1 when dtk.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
                         and 1=case when curr_thamphan_id=0 then 1 when dtk.THAMPHANID=curr_thamphan_id then 1 else 0 end
                         and 1=case when vThamtravienID=0 then 1 when dtk.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                             and 1=case when vLoaiCVID=0 then 1 
                             when vLoaiCVID=-1 and dtk.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                             when (dtk.LOAICONGVAN=vLoaiCVID Or dtk.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                             and  ( ( (vNgayNhapTu is null or dtk.NGAYTAO>=vNgayNhapTu) AND (vNgayNhapDen is null or dtk.NGAYTAO<=vNgayNhapDen) )
                                    Or  (visthuly=1 and(vNgayNhapTu is null or dtk.TL_NGAY>=vNgayNhapTu) and (vNgayNhapDen is null or dtk.TL_NGAY <= vNgayNhapDen) )
                                  )
--                                                     and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dtk.NGAYTAO then 1 else 0 end
--                                                    and 1=case when vNgayNhapDen is null then 1 when dtk.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
--                                                    Or (
--                                                         1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dtk.TL_NGAY then 1 else 0 end
--                                                         and 1=case when vNgayNhapDen is null then 1 when dtk.TL_NGAY <= vNgayNhapDen then 1 else 0 end
--                                                        )
--                                                    )
                        and 1=case when vPhanloaixuly=0 then 1 when dtk.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
                        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(dtk.ISANTUHINH,0)=0 then 1 
                         when vIsTuHinh=2 and NVL(dtk.ISANTUHINH,0)=1 then 1
                         when vIsTuHinh=3 and NVL(dtk.ISANTUHINH,0)=1 and NVL(dtk.ISTH_ANGIAM,0)=1 then 1
                         when vIsTuHinh=4 and NVL(dtk.ISANTUHINH,0)=1 and NVL(dtk.ISTH_KEUOAN,0)=1 then 1  else 0 end
                         And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and dtk.CD_TK_NOIGUI=0 then 1
                              when vGuitoiCA_TA=1 and dtk.CD_TK_NOIGUI=1 then 1 else 0 end
                        -------anhvh add 22/10/2020 vanthu den
                          AND (V_DONVI_CHUYEN_ID IS NULL 
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=dtk.ID AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                              ) 
                          AND ( V_TRANGTHAICHUYEN IS NULL
                                  OR(
                                     (V_TRANGTHAICHUYEN=3 AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=dtk.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
                                  )
                                  OR(V_TRANGTHAICHUYEN=4  
                                   AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=dtk.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID)
                                  )
                              )
                          AND ( V_LOAI_VB IS NULL
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                        WHERE cn.GDTTT_DON_ID=dtk.ID AND vbd.LOAI_VB=V_LOAI_VB AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                              )  
                           AND ( V_SODEN_TU IS NULL
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                        WHERE cn.GDTTT_DON_ID=dtk.ID AND vbd.SODEN>=V_SODEN_TU AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                              )    
                          AND ( V_SODEN_DEN IS NULL
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                        WHERE cn.GDTTT_DON_ID=dtk.ID AND vbd.SODEN<=V_SODEN_DEN AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                              ) 
                           AND ( V_NGAY_FROM IS NULL
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                        WHERE cn.GDTTT_DON_ID=dtk.ID AND vbd.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
                              )  
                            AND ( V_NGAY_TO IS NULL
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                        WHERE cn.GDTTT_DON_ID=dtk.ID AND vbd.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
                              )  
                           AND ( V_NGUOI_GUI_BT IS NULL
                              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                    WHERE cn.GDTTT_DON_ID=dtk.ID AND vbd.NGUOI_GUI_BT LIKE '%'||V_NGUOI_GUI_BT||'%' AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                               )    
                          -----------------

                                            order by dtk.NGAYTAO desc
                 ) GROUP BY DTID
                 )tt
--                                                     order by isthuly asc,dtk.NGAYTAO desc 
--                            ) DD  GROUP BY DD.DTID
--                    ) TT 
         ),

        MM as (
               SELECT /*GSCM.PKG_GDTTT_HCTP_APP.DON_SEARCH (Danh sach Don HCTP) */ DO.DONTRUNGID,
               --RTRIM(SUBSTR(LISTAGG(DO.CV_TRALOI_NOIDUNG, '|') WITHIN GROUP (ORDER BY DO.NGAYTAO DESC)||'|',0,INSTR(LISTAGG(DO.CV_TRALOI_NOIDUNG, '|') WITHIN GROUP (ORDER BY DO.NGAYTAO DESC)||'|','|',1,1) ),'|')
               RTRIM(
                        Xmlagg(
                                Xmlelement(E, DO.CV_TRALOI_NOIDUNG || ',')
                                ORDER BY DO.NGAYTAO DESC
                                ).extract ( '//text()' ).GetClobVal(),
                            ','
                     ) AS 
               
               CV_TRALOI_NOIDUNG,
               RTRIM(SUBSTR(LISTAGG(DO.VUVIECID, '|') WITHIN GROUP (ORDER BY DO.NGAYTAO DESC)||'|',0,INSTR(LISTAGG(DO.VUVIECID, '|') WITHIN GROUP (ORDER BY DO.NGAYTAO DESC)||'|','|',1,1) ),'|')
                VUVIECID
               FROM (
                    SELECT DD.ID,DD.DONTRUNGID DONTRUNGIDS,DD.NGAYTAO,DECODE(DD.DONTRUNGID,NULL,DD.ID,0,DD.ID,DD.DONTRUNGID)DONTRUNGID
                    ,SUBSTR(DD.CV_TRALOI_NOIDUNG,0,150)CV_TRALOI_NOIDUNG,DD.VUVIECID
                    FROM GDTTT_DON DD 

                     where dd.TOAANID= vToaAnID and DD.CV_TRALOI_NOIDUNG is not null
                     And 1=(Case when vIsThuLy=-1 then 1 
                                when vIsThuLy=1  and dd.ISTHULY=1  then 1 -- TLM 
                                when vIsThuLy=3  and dd.ISTHULY=1
                                                 and (vNgayNhapTu is not null and  vNgayNhapDen is not null)  
                                                 and PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(dd.id)>1 then 1 -- TLM trùng
                                when vIsThuLy=4  and dd.ISTHULY=1 and  NVL(dd.THAMPHANID,0) > 0  then 1 -- TLM đã phan cong
                                when vIsThuLy=5  and dd.ISTHULY=1 and  NVL(dd.THAMPHANID,0) = 0   then 1 -- TLM chua phan cong
                                when vIsThuLy=2  and dd.ISTHULY=2 then 1 
                                Else 0 End)         
                    and 
                    1=case when vToaRaBAQD=0 then 1 when dd.BAQD_TOAANID=vToaRaBAQD 
                                                     Or dd.BAQD_TOAANID_PT=vToaRaBAQD 
                                                     Or dd.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end  
                   -- and 1=case when vLoaiAn=0 then 1 when dd.BAQD_LOAIAN=vLoaiAn then 1 else 0 end  
                   --anhvh 12/02/2020
                   AND (vLoaiAn=0
                        OR(dd.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                        OR(vLoaiAn=55 AND dd.BAQD_LOAIAN IS NULL)
                      )

--                                                   and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(dd.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(dd.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--                                                    and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(dd.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(dd.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end   
--                                                    and (vSoBAQD || ' '=' '  Or lower(dd.BAQD_SO) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%' 
--                                                                             Or lower(dd.BAQD_SO_PT) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                                                                             Or lower(dd.BAQD_SO_ST) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                                                                             Or lower(dd.KN_SOQD) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%') 
--                                                    and  (vNgayBAQD || ' '=' ' Or  to_char(dd.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
--                                                                                Or to_char(dd.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
--                                                                                Or to_char(dd.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
--                                                                                Or to_char(dd.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
--                                                   

                    and (  ((vSoBAQD || ' '=' '  Or lower(dd.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                              And (vNgayBAQD || ' '=' ' Or  to_char(dd.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                            )
                            Or((vSoBAQD || ' '=' ' Or lower(dd.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(dd.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(dd.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(dd.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                            Or ((vSoBAQD || ' '=' ' Or lower(dd.KN_SOQD) like  lower(vSoBAQD) || '%')
                                And (vNgayBAQD || ' '=' ' Or to_char(dd.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                            )
                         )
--                                                    

                    and
                    1=case when vNguoiGui || ' '=' ' then 1 when lower(DECODE(dd.LOAIDON,6,dd.CV_TENDONVI,decode(vToaAnID,6,dd.NGUOIGUI_HOTEN,dd.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                    and
                    1=case when vSoCMND || ' '=' ' then 1 when dd.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                    and
                    1=case when vTuNgay is null then 1 when vTuNgay <= dd.NGAYNHANDON then 1 else 0 end
                    and
                    1=case when vDenNgay is null then 1 when dd.NGAYNHANDON <= vDenNgay then 1 else 0 end
                    and
                    1=case when vHinhThucDon=0 then 1 when dd.LOAIDON=vHinhThucDon then 1 else 0 end
                    and
                    1=case when vSoHieuDon || ' '=' ' then 1 when (dd.MADON =vSoHieuDon Or dd.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                    and
                    1=case when vDiaChiTinh=0 then 1 when dd.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                    and
                    1=case when vDiaChiHuyen=0 then 1 when dd.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
                    and
                    1=case when vDiaChiCT || ' '=' ' then 1 when lower(dd.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
                    and
                    1=case when vSoCongVan || ' '=' ' then 1 when ((lower(dd.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(dd.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(dd.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )  and dd.isthuly = 1) then 1 else 0 end
                    and
                    1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(dd.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(dd.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(dd.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
                   and
                    1=case when vCVPC_So || ' '=' ' then 1 when lower(dd.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                    and
                    1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(dd.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                     and
                    1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(dd.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                    and
                    1=case when vTraLoi=0 then 1 when dd.TRALOIDON=vTraLoi then 1 else 0 end
                    and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(dd.nguoitao)|| ',%') then 1 else 0 end
                    -- and 1=case when vNoiChuyen=-1 then 1 when dd.CD_LOAI=vNoiChuyen then 1 else 0 end
                     --anhvh 13/02/2020
                    AND (vNoiChuyen=-1
                         OR(dd.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                         OR(dd.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                         )
                    and  1=case when vTrangthai=-1 then 1 
                          when vTrangthai=1 and   dd.CD_TRANGTHAI in (1,2) then 1 
                          when dd.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                    and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                        when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dd.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI)
                        OR (vCD_TA_TRANGTHAI=3 and NVL(dd.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=dd.ID)) --lanhnt thêm trạng thái đơn
                        OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=dd.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = dd.ID))))) then 1
                         when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And dd.CD_TK_DONVIID=vCD_DONVIID) Or
                                                (vCD_DONVIID=-1 And dd.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                        when (vNoiChuyen=2 and lower(dd.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
                       when (vNoiChuyen>2 and dd.CD_LOAI=vNoiChuyen) then 1
                        else 0 end)   
                    and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dd.CD_NGAYXULY then 1 else 0 end
                    and 1=case when vNgaychuyenDen is null then 1 when dd.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
                    and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= dd.TL_NGAY then 1 else 0 end
                    and 1=case when vNgayThulyDen is null then 1 when dd.TL_NGAY <= vNgayThulyDen then 1 else 0 end
                    and 1=case when vSoThuly || ' '=' ' then 1 when lower(dd.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
                    and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(dd.ID as varchar2(10)) || ',%' then 1 else 0 end

                    and 1=case when vChidao=-1 then 1 
                                when  vChidao=0 and NVL(dd.CHIDAO_COKHONG,0)>0 then 1 -- Có ý kiến chỉ đạo
                                when  vChidao=1 and NVL(dd.CHIDAO_COKHONG,0)=0 then 1 -- Không có ý kiến chỉ đạo
                                when vChidao>1 and dd.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
                    and 1=case when vTraigiam=-1 then 1 when NVL(dd.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
                    and 1=case when vTBQuahan=0 then 1 when dd.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
                     and 1=case when curr_thamphan_id=0 then 1 when dd.THAMPHANID=curr_thamphan_id then 1 else 0 end
                     and 1=case when vThamtravienID=0 then 1 when dd.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                         and 1=case when vLoaiCVID=0 then 1 
                         when vLoaiCVID=-1 and dd.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                         when (dd.LOAICONGVAN=vLoaiCVID Or dd.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                         and  ( ( (vNgayNhapTu is null or dd.NGAYTAO>=vNgayNhapTu) AND (vNgayNhapDen is null or dd.NGAYTAO<=vNgayNhapDen) )
                                Or  (visthuly=1 and(vNgayNhapTu is null or dd.TL_NGAY>=vNgayNhapTu) and (vNgayNhapDen is null or dd.TL_NGAY <= vNgayNhapDen) )
                              )
--                                                     and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dd.NGAYTAO then 1 else 0 end
--                                                    and 1=case when vNgayNhapDen is null then 1 when dd.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
--                                                    Or (
--                                                         1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= dd.TL_NGAY then 1 else 0 end
--                                                         and 1=case when vNgayNhapDen is null then 1 when dd.TL_NGAY <= vNgayNhapDen then 1 else 0 end
--                                                        )
--                                                    )
                    and 1=case when vPhanloaixuly=0 then 1 when dd.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
                    and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(dd.ISANTUHINH,0)=0 then 1 
                     when vIsTuHinh=2 and NVL(dd.ISANTUHINH,0)=1 then 1
                     when vIsTuHinh=3 and NVL(dd.ISANTUHINH,0)=1 and NVL(dd.ISTH_ANGIAM,0)=1 then 1
                     when vIsTuHinh=4 and NVL(dd.ISANTUHINH,0)=1 and NVL(dd.ISTH_KEUOAN,0)=1 then 1  else 0 end
                     And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and dd.CD_TK_NOIGUI=0 then 1
                          when vGuitoiCA_TA=1 and dd.CD_TK_NOIGUI=1 then 1 else 0 end
                    -------anhvh add 22/10/2020 vanthu den
                      AND (V_DONVI_CHUYEN_ID IS NULL 
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=dd.ID AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                          ) 
                      AND ( V_TRANGTHAICHUYEN IS NULL
                              OR(
                                 (V_TRANGTHAICHUYEN=3 AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=dd.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
                              )
                              OR(V_TRANGTHAICHUYEN=4  
                               AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=dd.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID)
                              )
                          )
                      AND ( V_LOAI_VB IS NULL
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                    WHERE cn.GDTTT_DON_ID=dd.ID AND vbd.LOAI_VB=V_LOAI_VB AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                          )  
                       AND ( V_SODEN_TU IS NULL
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                    WHERE cn.GDTTT_DON_ID=dd.ID AND vbd.SODEN>=V_SODEN_TU AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                          )    
                      AND ( V_SODEN_DEN IS NULL
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                    WHERE cn.GDTTT_DON_ID=dd.ID AND vbd.SODEN<=V_SODEN_DEN AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                          ) 
                       AND ( V_NGAY_FROM IS NULL
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                    WHERE cn.GDTTT_DON_ID=dd.ID AND vbd.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
                          )  
                        AND ( V_NGAY_TO IS NULL
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                    WHERE cn.GDTTT_DON_ID=dd.ID AND vbd.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
                          )  
                       AND ( V_NGUOI_GUI_BT IS NULL
                          OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                                INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                                WHERE cn.GDTTT_DON_ID=dd.ID AND vbd.NGUOI_GUI_BT LIKE '%'||V_NGUOI_GUI_BT||'%' AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                           )

                )DO GROUP BY DO.DONTRUNGID
           ),
       kq as (SELECT v.ID,
                        ( 'số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                                            end)
                                        --|| chr(10)|| NVL(k.Ten,' ')
                                        ) KQXXGDT
                            FROM GDTTT_VuAn v
                            left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID
                            where v.GQD_LOAIKETQUA = 1 and trim(v.XXGDTTT_SOQD) is not null
                ),

  va as (SELECT ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,GQD_KETQUA,GQD_NgayPhatHanhCV,SOTHULYXXGDT,NGAYTHULYXXGDT FROM GDTTT_VuAn) 

  select a.*
            from (
                Select g.CountAll,ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
                d.NGUOITAO NguoiNhap
                ,DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,d.DONGKHIEUNAI)DONGKHIEUNAI
                ,decode(D.LOAIDON,1,'<i>Người đứng đơn:</i>',3,'<i>Người đứng đơn:</i>','<i>Người gửi:</i>')
                ||'<b>'||DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,9,d.CV_TENDONVI,d.DONGKHIEUNAI)||'</b>' DONGKHIEUNAI_CC
                ,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
                d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL
                ,LAD.LOAIDON_TEN_VT HinhThuc --case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
                ,decode(D.LOAIDON,6,'Ngày công văn',9,'Ngày công văn',5,'Ngày VB',4,'Ngày QĐKN','Ngày trên đơn')LBL_HINHTHUC_CC
                ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
                End) Diachigui
                ,d.CV_SO,d.NGAYGHITRENDON
                ,DECODE(D.LOAIDON,4,d.NGAY_HSKN,5,d.CV_NGAY,d.NGAYGHITRENDON)NGAYGHITRENDON_CC
                ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
                ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(vToaAnID,1,'BA/QĐ: ',6,'BA: '))||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
                ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
                ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
                , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
                , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN)) Infor_PT
                ,NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU 
                ,d.BAQD_SO_PT,d.BAQD_SO_ST
                ,d.NGUOIKHANGNGHI,d.GHICHU ||decode (d.CD_TRANGTHAI,3,'<i></br>Lý do trả lại đơn:</i> '||tralai.ghichu,'')  as GHICHU
                ,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
                ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
                ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
                ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển' when 1 then  'Đã chuyển' when 2 then  'Đã nhận' when 3 then  'Bị trả lại' else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
                ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
                ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH
                ,d.CD_SOTOTRINH||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
                ,d.THAMPHANID
                ,(Case vIsThuLy when 1  then
                (1+(Select Count(t.ID) from GDTTT_DON t where t.ISTHULY<>1 and  (t.DONTRUNGID=d.ID Or ( t.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID or ID=d.DonTrungID) And d.DontrungID>0)))
                      and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                      and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                      and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                      and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(t.CD_SOCV) = lower(vSoCongVan) Or lower(t.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                      and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(t.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(t.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
                    ))      
                Else g.SODONTRUNG End) SODON
                ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
                ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
                ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET   
                ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
                ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
                ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
                ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL                 
--      ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
--          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
--          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
--                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
--                  and 1=case when vLoaiCVID=0 then 1 
--                     when vLoaiCVID=-1 and cv.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
--                     when (cv.LOAICONGVAN=vLoaiCVID Or cv.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
--         ) arrCongvan
            ,decode(d.LOAIDON,1,'',(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',
                DECODE(TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001',NULL,' ngày '||TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) 
            ))) arrCongvan
            ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
            WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
            and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
    --                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                        and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                        and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end

         ) arrDonID
        ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH|| ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')  || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

            , case when d.CD_LOAI= 0 --and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,5)=3 then '<b> Xử lý khác ngày '||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||':</b> <span style="color:#000000;">'||to_char(va.GQD_KETQUA)||'</span>' --add by anhvh 11/11/2019
                            when NVL(va.GQD_LOAIKETQUA,5)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,5)
                                          , 5, decode(d.CD_TRANGTHAI,2,'Đang giải quyết','') 
                                          , 2, u'X\1ebfp \0111\01a1n' 
                                          , 1,decode(d.loaidon,8,'Không chấp nhận khiếu nại',10,'Không chấp nhận khiếu nại',u'Kh\00e1ng ngh\1ecb')
                                          , 0,decode(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',u'Tr\1ea3 l\1eddi \0111\01a1n') 
                                          ,4,'Thông báo VKS đang giải quyết'
                                          )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    || Decode (va.GQD_LOAIKETQUA ,1,'<br/>KQXXGDT: ' || kq.KQXXGDT,'')   

                                    ) end   
               else '' end KQGQNoiBo
              ,SUBSTR(MM.CV_TRALOI_NOIDUNG,0,150) CV_TRALOI_NOIDUNG --MM.CV_TRALOI_NOIDUNG --DECODE(d.DONTRUNGID,NULL,MM.CV_TRALOI_NOIDUNG,d.CV_TRALOI_NOIDUNG)CV_TRALOI_NOIDUNG
              ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME 
                ---văn thư đến-----
              ,vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,DECODE(vt.TRANG_THAI_XLY,3,null,4,'Dữ liệu từ VBĐ') TRANG_THAI_XLY_NAME
              ,vbd.NGUOI_GUI_BT,vbd.DIACHI_GUI_BT,to_char(vbd.NGAY_DEN,'dd/MM/yyyy')NGAY_DEN,to_char(vbd.NGAY_BT,'dd/MM/YYYY')NGAY_BT
               ,DECODE(vbd.LOAI_VB
                                 ,1,'Số <b>BA/QĐ: '||vbd.SO_BAQD_DON||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'))||' '||TA.Ma_Ten ||'</b>'
                                 ,4,'Số <b>BA/QĐ: '||vbd.SO_BAQD_DON||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'))||' '||TA.Ma_Ten ||'</b>'
                                 ,'Số CV: <b>'||vbd.SO_CV||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_CV,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_CV,'dd/MM/yyyy'))||'</b> Cơ quan/Đơn vị chuyển: <b>'||' '||vbd.DONVICHUYEN_CV ||'</b>'
                                 ) THONGTIN_VBD 
              ,decode(pbvt.TEN,null,null,'<i>Đơn vị tiếp nhận:</i><b style="color:#0da520" > Văn thư</b><br />') DONVITIEPNHAN                   
              ,vbd.SODEN,decode(vbd.NGUON_DEN,1,'Bưu điện',2,'Tiếp công dân',3,'Trực tiếp')NGUON_DEN
               ----manhnd canh bao an thoi hieu
                ,case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU = 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU != 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU = 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                      when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU != 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0
                        then '(Hết thời hiệu giải quyết)'
                    else ''
               end THOIHIEU
               ,(SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y WHERE y.DONID = d.ID AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = d.ID)) AS YCBS
               ,decode(d.LOAI_GDTTTT,1,'giám đốc thẩm',2,'tái thẩm','') LOAIGDTT
     from GDTTT_DON d 
           -- hien thi ly do tra lai don
       left join GDTTT_DON_CHUYEN_HISTORY tralai on d.id = tralai.donid
       LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=vToaAnID)LAD ON LAD.LOAIDON_ID=d.LOAIDON
       LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
       --anhvh add 28-29/05/2020 (đơn chuyển tòa án khác,và ngoài tòa án) lấy kết quả khi thêm mới một đơn trùng,
       --trường hợp list tại danh sách, khi thêm mới một đơn trùng và chưa nhập kết quả thì sẽ hiển thị 1 kết quả của những đơn đã có kết quả
       --(đơn chuyển nội bộ)lấy kết quả khi thêm mới đơn trùng,xử lý trường hợp VUVIECID is null thì lấy 1 VUVIECID mới nhất của nhóm đơn đó,
       --ví dụ thêm mới một đơn vào trong nhóm đơn mà trong nhóm đơn đó đã map vào vụ án thì đơn mới đó sẽ có cùng mã vụ án.
        LEFT JOIN MM ON MM.DONTRUNGID=DECODE(D.DONTRUNGID,NULL,D.ID,0,D.ID,D.DONTRUNGID)
     -----Ket qua xx giam doc tham 
     LEFT JOIN kq ON kq.ID = DECODE(D.VUVIECID,NULL,MM.VUVIECID,D.VUVIECID) 
     ----------
     LEFT JOIN va ON va.ID = DECODE(D.VUVIECID,NULL,MM.VUVIECID,D.VUVIECID) -- Decode này là trường hợp khi thêm mới một đơn mà có VUVIECID is null thì sẽ tìm VUVIECID để thay thế
     -----
     LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
     inner join
        --    (SELECT TT.SODONTRUNG,RTRIM(SUBSTR(TT.ID,0,INSTR(TT.ID,',',1,1)),',') ID 
        --                FROM (   
        --                      Select Count(*) SODONTRUNG,DD.DTID,
        --                            LISTAGG (DD.ID, ',') WITHIN GROUP (ORDER BY CASE WHEN DD.visthuly=1 THEN DD.ID END 
        --                            ,CASE WHEN DD.visthuly!=1 THEN DD.ID END DESC)||','ID
        --                            from (select dtk.ID
        --                                        ,DECODE(dtk.DONTRUNGID,NULL,dtk.ID,0,dtk.ID,dtk.DONTRUNGID)DTID
        --                                        ,DECODE(dtk.isthuly,NULL,0,dtk.isthuly)visthuly
    g on g.ID=d.ID 
            left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
            left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
            left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
            left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
            left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
            left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
            left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
            left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
            left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
            left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID 
              ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
            where d.TOAANID= vToaAnID 
             And 1=(Case when vIsThuLy=-1 then 1 
                        when vIsThuLy=1  and d.ISTHULY=1  then 1 -- TLM 
                        when vIsThuLy=3  and d.ISTHULY=1 
                                         and (vNgayNhapTu is not null and  vNgayNhapDen is not null) 
                                         and PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(d.id)>1 then 1 -- TLM trùng
                        when vIsThuLy=4  and d.ISTHULY=1 and  NVL(d.THAMPHANID,0) > 0  then 1 -- TLM đã phan cong
                        when vIsThuLy=5  and d.ISTHULY=1 and  NVL(d.THAMPHANID,0) = 0   then 1 -- TLM chua phan cong
                        when vIsThuLy=2  and d.ISTHULY=2 then 1 
                        Else 0 End)     
            and 
            1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD 
                                             Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                             Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end  
           -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end  
           --anhvh 12/02/2020
           AND (vLoaiAn=0
                OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
              )
--                                                   and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
--                                                    and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end   
--                                                    and (vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%' 
--                                                                             Or lower(d.BAQD_SO_PT) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                                                                             Or lower(d.BAQD_SO_ST) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                                                                             Or lower(d.KN_SOQD) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%') 
--                                                    and  (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
--                                                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
--                                                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
--                                                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
--                                                    
            and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                      And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                    )
                    Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                    Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                        And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                    )
                 )


            and
            1=case when vNguoiGui || ' '=' ' then 1 when lower(DECODE(d.LOAIDON,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
            and
            1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
            and
            1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
            and
            1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
            and
            1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
            and
            1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
            and
            1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
            and
            1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
            and
            1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
            and
            1=case when vSoCongVan || ' '=' ' then 1 when ((lower(d.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(d.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(d.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )  and d.isthuly = 1) then 1 else 0 end
            and
            1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
           and
            1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
            and
            1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
             and
            1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
            and
            1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
           -- and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
            AND (vNguoiNhap IS NULL OR upper(vNguoiNhap) like '%'||upper(d.nguoitao)||'%')
            -- and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
             --anhvh 13/02/2020
            AND (vNoiChuyen=-1
                 OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                 OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                 )
            and  1=case when vTrangthai=-1 then 1 
                  when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 
                  when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
            and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
                OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
                OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
                 when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                        (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
                when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
               when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1
                else 0 end)   
            and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
            and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
            and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
            and 1=case when vNgayThulyDen is null then 1 when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end
            and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
            and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
            and 1=case when vChidao=-1 then 1 
                        when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 -- Có ý kiến chỉ đạo
                        when  vChidao=1 and NVL(d.CHIDAO_COKHONG,0)=0 then 1 -- Không có ý kiến chỉ đạo
                        when vChidao>1 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
            and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
            and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
            and 1=case when curr_thamphan_id=0 then 1 when d.THAMPHANID=curr_thamphan_id then 1 else 0 end
            and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
            and 1=case when vLoaiCVID=0 then 1 
            when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
            when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
            and  ( ( (vNgayNhapTu is null or d.NGAYTAO>=vNgayNhapTu) AND (vNgayNhapDen is null or d.NGAYTAO<=vNgayNhapDen) )
                Or  (visthuly=1 and(vNgayNhapTu is null or d.TL_NGAY>=vNgayNhapTu) and (vNgayNhapDen is null or d.TL_NGAY <= vNgayNhapDen) )
              )
--                                                     and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
--                                                    and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
--                                                    Or (
--                                                         1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
--                                                         and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end
--                                                        )
--                                                    )
            and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
            and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
             when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
             when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
             when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
             And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                  when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
            -------anhvh add 22/10/2020 vanthu den
              AND (V_DONVI_CHUYEN_ID IS NULL 
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                  ) 
              AND ( V_TRANGTHAICHUYEN IS NULL
                      OR(
                         (V_TRANGTHAICHUYEN=3 AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
                      )
                      OR(V_TRANGTHAICHUYEN=4  
                       AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID)
                      )
                  )
              AND ( V_LOAI_VB IS NULL
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                            INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                            WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=V_LOAI_VB AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                  )  
               AND ( V_SODEN_TU IS NULL
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                            INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                            WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=V_SODEN_TU AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                  )    
              AND ( V_SODEN_DEN IS NULL
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                            INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                            WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=V_SODEN_DEN AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                  ) 
               AND ( V_NGAY_FROM IS NULL
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                            INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                            WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
                  )  
                AND ( V_NGAY_TO IS NULL
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                            INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                            WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
                  )  
               AND ( V_NGUOI_GUI_BT IS NULL
                  OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||V_NGUOI_GUI_BT||'%' AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
                   )    
    ) a where a.stt>=MinIndex and a.stt<=MaxIndex ;

    ------------Truong hop nay thuong dung cho toi cao CW-------------
     ---ddlPhanloaiDdon.SelectedValue == "2" là tất cả dung cho cap cao,toi cao it dung
    ELSIf vIsDonGoc=0 then   
        PKG_GDTTT_HCTP_APP.DON_SEARCH_TOTAL(
            V_NDBD_VALUE,V_NDBD_TEXT,
            V_DONVI_CHUYEN_ID,V_TRANGTHAICHUYEN,V_LOAI_VB,V_SODEN_TU,V_SODEN_DEN,V_NGAY_FROM,V_NGAY_TO,V_NGUOI_GUI_BT,
            V_ID_USER,VTOAANID,VTOARABAQD,VSOBAQD,VNGAYBAQD,VNGUOIGUI,VSOCMND,VTUNGAY,VDENNGAY,VHINHTHUCDON,
            VSOHIEUDON,VDIACHITINH,VDIACHIHUYEN,VDIACHICT,VSOCONGVAN,VNGAYCONGVAN,VTRALOI,VNGUOINHAP,VNOICHUYEN,VTRANGTHAI,VCD_DONVIID,
            VCD_TA_TRANGTHAI,VCD_TENDONVI,VNGAYCHUYENTU,VNGAYCHUYENDEN,VARRSELECTID,VISTHULY,VPHANLOAIXULY,VNGAYTHULYTU,VNGAYTHULYDEN,
            VSOTHULY,VCHIDAO,VTRAIGIAM,VTBQUAHAN,VNGAYQUAHAN,VTHAMPHANID,VTHAMTRAVIENID,VLOAICVID,VNGAYNHAPTU,VNGAYNHAPDEN,VISDONGOC,
            VISTUHINH,VLOAIAN,VCVPC_SO,VCVPC_NGAY,VCVPC_TENCQ,VGUITOICA_TA,VLOAI_GDTTT,PAGEINDEX,PAGESIZE,V_CURSOR);
         LOOP 
            FETCH V_CURSOR 
           INTO   TotalItem;
            EXIT WHEN V_CURSOR%NOTFOUND;
      END LOOP;    
      CLOSE V_CURSOR;  
       --------------------------- 
        OPEN curReturn FOR
   select /*GSCM.PKG_GDTTT_HCTP_APP.DON_SEARCH (Danh sach Don HCTP) */ a.*,TotalItem as CountAll from (
      Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID
      ,d.MADON
      ,decode(D.LOAIDON,6,'<i>Mã CV</i>:',9,'<i>Mã CV</i>:',5,'<i>Mã VB</i>:','<i>Mã đơn</i>:')||d.MADON MADON_CC
      ,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON
      , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  

      ,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap
      --,d.DONGKHIEUNAI
      ,DECODE(d.LOAIDON,9,d.CV_TENDONVI,6,d.CV_TENDONVI,d.DONGKHIEUNAI) DONGKHIEUNAI
      ,decode(D.LOAIDON,1,'<i>Người đứng đơn:</i>',3,'<i>Người đứng đơn:</i>','<i>Người gửi:</i>')
          ||'<b>'||DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,9,d.CV_TENDONVI,d.DONGKHIEUNAI)||'</b>' DONGKHIEUNAI_CC
      ,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL
      ,LAD.LOAIDON_TEN_VT HinhThuc --case d.LOAIDON when 1 then 'Đơn' when 2 then 'Công văn' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,decode(D.LOAIDON,6,'Ngày công văn',9,'Ngày công văn',5,'Ngày VB',4,'Ngày QĐKN','Ngày trên đơn')LBL_HINHTHUC_CC
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN || hv.MA_TEN
      End) DIACHIGUI
      ,d.CV_SO,d.NGAYGHITRENDON
       ,DECODE(D.LOAIDON,4,d.NGAY_HSKN,5,d.CV_NGAY,d.NGAYGHITRENDON)NGAYGHITRENDON_CC
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,'BA/QĐ: ')||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END) BAQD
      ,decode(D.LOAIDON,5,null,'<i>Số </i><b>'||(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,'BA: ')||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) END ))||'</b>' BAQD_CC
      ,d.CV_TENDONVI
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,DECODE(D.LOAIDON,5,NULL,'<i>Ngày: <b>'||to_char((Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END),'dd/MM/yyyy')||'</b></i>') BAQD_NGAYBA_CC
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
      ,decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST|| decode(d.BAQD_NGAYBA_ST,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')))||' '|| txxST.MA_TEN)) Infor_ST
      ,decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||decode(d.BAQD_NGAYBA_PT,null,'',(' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')))||' '|| txxPT.MA_TEN)) Infor_PT
      ,NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU 
      ,d.BAQD_SO_PT,d.BAQD_SO_ST
      ,d.NGUOIKHANGNGHI,d.GHICHU ||decode (d.CD_TRANGTHAI,3,'<i></br>Lý do trả lại đơn:</i> '||tralai.ghichu,'')  as GHICHU
      ,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                            when 1 then  'Đã chuyển'
                            when 2 then  'Đã nhận' 
                            when 3 then  'Bị trả lại' 
                            else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH
      ,d.CD_NGAYTOTRINH
      ,d.CD_SOTOTRINH||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
      ,d.THAMPHANID

      ,(Case d.CD_LOAI when 0 then 
      (Case vIsDonGoc when 0 then 1 else
      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         + (Case when d.DONTRUNGID>0 then 
            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
         ) End)
              Else 
              (Case vIsDonGoc when 0 then 1 else
              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
              End)
              End)SODON
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
       ,Decode(d.CD_LOAI,3,'Trả lại đơn',4,'Xếp đơn','Chuyển đơn') GIAIQUYET      

      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block'
      when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
     ,(Case  when va.NGAYTHULYXXGDT is not null 
                    and (to_char(va.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')
                    and NVL(va.IsVienTruongKN,0) = 0 then 'block' 
                        Else 'none' End) IsThulyXX 
        , va.SOTHULYXXGDT
        , va.NGAYTHULYXXGDT  
--      ,(SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
--          FROM GDTTT_DON cv  WHERE cv.LOAIDON =3 and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
--          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
--                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
--                   and 1=case when vLoaiCVID=0 then 1 
--                     when vLoaiCVID=-1 and cv.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
--                     when (cv.LOAICONGVAN=vLoaiCVID Or cv.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
--         ) arrCongvan
        ,decode(d.LOAIDON,1,'',(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',
                DECODE(TO_CHAR(d.CV_NGAY,'dd/MM/yyyy'),'01/01/0001',NULL,' ngày '||TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) 
            ))) arrCongvan
         ,
         (SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
                  and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
     ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

           , d.PHANLOAIXULY
           , NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
              ---------anhvh_kqgq 09/01/2023;13/03/2024------------------------
              ----GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
              ----D.cd_loai:0 nội bộ
               ,CASE  WHEN D.cd_loai= 0 AND nvl(D.vuviecid, 0)>0  THEN
                   CASE WHEN va.LOAIAN =1 THEN -- hinh su
                          CASE WHEN  va.GQD_LOAIKETQUA=0 OR va.GQD_LOAIKETQUA=1 THEN
                                   decode(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',TLD.TLDKN||KN.TLDKN||kq.KQXXGDT) 
                            WHEN va.GQD_LOAIKETQUA=2
                                 THEN 'Xếp đơn <b>'||decode(va.GDQ_SO,null,null,' số ') || to_char(va.GDQ_SO)||decode(va.GDQ_NGAY,null,null,' ngày ')||to_char(va.GDQ_NGAY,'dd/MM/yyyy')||'</b>'
                            WHEN va.GQD_LOAIKETQUA=3 THEN
                                 'Xử lý khác <b>'||decode(va.GDQ_SO,null,null,' số ')||to_char(va.GDQ_SO)||decode(va.GQD_NgayPhatHanhCV,null,null,' ngày ')||to_char(va.GQD_NgayPhatHanhCV,'dd/MM/yyyy')||'</b>'
                            WHEN va.GQD_LOAIKETQUA=4 THEN
                                 'Thông báo VKS đang giải quyết'
                             WHEN va.GQD_LOAIKETQUA IS NULL THEN
                                  decode(d.CD_TRANGTHAI,2,'Đang giải quyết','') 
                           END 
                    ELSE  --dan su mo rong
                    CASE WHEN va.GQD_LOAIKETQUA IS NOT NULL THEN
                                DECODE(d.loaidon,8,'Chấp nhận khiếu nại',10,'Chấp nhận khiếu nại',
                                        XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS
                                        ||TLD_DS.TLDKN||KN_DS.TLDKN||TO_CHAR(kq.KQXXGDT))
                              WHEN va.GQD_LOAIKETQUA IS NULL
                             THEN  decode(d.CD_TRANGTHAI,2,'Đang giải quyết','') 
                          END 
                     END   
             END
             KQGQNoiBo
             ------------------------------------------------------------
              ,d.CV_TRALOI_NOIDUNG
               ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME 
                  ---văn thư đến-----
              ,vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,DECODE(vt.TRANG_THAI_XLY,3,null,4,'Dữ liệu từ VBĐ') TRANG_THAI_XLY_NAME
              ,decode(vbd.LOAI_VB,1,'<i>Người đứng đơn: </i><b>'||vbd.NGUOIDUNGDON,3,'<i>Người đứng đơn: </i><b>'||vbd.NGUOIDUNGDON,'<i>Người gửi:</i><b>'||vbd.NGUOI_GUI_BT)NGUOI_GUI_BT
              ,decode(vbd.LOAI_VB,1,vbd.DIACHI_NDD,3,vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT)DIACHI_GUI_BT,to_char(vbd.NGAY_DEN,'dd/MM/yyyy')NGAY_DEN,to_char(vbd.NGAY_BT,'dd/MM/YYYY')NGAY_BT
             ,DECODE(vbd.LOAI_VB
                                 ,1,'Số <b>BA/QĐ: '||vbd.SO_BAQD_DON||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'))||' '||TA.Ma_Ten ||'</b>'
                                 ,4,'Số <b>BA/QĐ: '||vbd.SO_BAQD_DON||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_BAQD_DON,'dd/MM/yyyy'))||' '||TA.Ma_Ten ||'</b>'
                                 ,5,'Số <b>VB: '||vbd.SO_VB||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_VB,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_VB,'dd/MM/yyyy'))||' '||vbd.NGUOI_GUI_BT ||'</b>'
                                 ,'Số CV: <b>'||vbd.SO_CV||'</b> Ngày: <b>'||decode(to_char(vbd.NGAY_CV,'dd/MM/yyyy'),'01/01/0001','',to_char(vbd.NGAY_CV,'dd/MM/yyyy'))||'</b> Cơ quan/Đơn vị chuyển: <b>'||' '||vbd.DONVICHUYEN_CV ||'</b>'
                                 ) THONGTIN_VBD 
              ,decode(pbvt.TEN,null,null,'<i>Đơn vị tiếp nhận:</i><b style="color:#0da520" > Văn thư</b><br />') DONVITIEPNHAN                   
              ,vbd.SODEN,decode(vbd.NGUON_DEN,1,'Bưu điện',2,'Tiếp công dân',3,'Trực tiếp')NGUON_DEN
              ----manhnd canh bao an thoi hieu
               ,case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU = 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU != 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU = 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                      when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0
                        and d.BAQD_CAPXETXU != 2
                        then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'
                     when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 
                        and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0
                        then '(Hết thời hiệu giải quyết)'
                    else ''
               end THOIHIEU,
          (case d.LOAI_GDTTTT when 1 then 'Giám đốc thẩm'
                            when 2 then  'Tái thẩm'
                            when 3 then  'Chưa xác định' 

                            else ' '   end ) TRANGTHAILOAI_GDTTTT,
                            d.NGUOIGUI_DIENTHOAI
                ,(SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y WHERE y.DONID = d.ID AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = d.ID)) AS YCBS
                ,decode(d.LOAI_GDTTTT,1,'giám đốc thẩm',2,'tái thẩm','') LOAIGDTT,THA.HOAN_THA

    from GDTTT_DON d  
        -- hien thi ly do tra lai don
      left join GDTTT_DON_CHUYEN_HISTORY tralai on d.id = tralai.donid
      LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=vToaAnID)LAD ON LAD.LOAIDON_ID=d.LOAIDON
      left join (select ID,LOAIAN,GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN  from GDTTT_VuAn) va on va.ID = d.VuViecID
       LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
        -----Ket qua xx giam doc tham 
     LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||
                        ( 'số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                                                                            end)
                                        --|| '. KQ: '|| chr(10)|| NVL(k.Ten,' ')
                                        ) KQXXGDT
                            FROM GDTTT_VuAn v
                            left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID
                            where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 )
                ) kq ON kq.ID = D.VUVIECID 
         --anhvh_kqgq 16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su,decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
             LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN 
                        FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3
                        )TLD ON TLD.DONID=D.ID
             LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN 
                        FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4
                        )KN ON KN.DONID=D.ID
             --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
             LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN 
                         FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1--= 1 đang dùng,0 xóa
                        )TLD_DS ON TLD_DS.DONID=D.ID
             LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN 
                        FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1
                       )KN_DS ON KN_DS.DONID=D.ID        
             LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS 
                        FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1
                       )XLK_DS ON XLK_DS.DONID=D.ID          
             LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS 
                        FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1
                       )XD_DS ON XD_DS.DONID=D.ID    
            LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS 
                        FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1
                       )VKSGQ_DS ON VKSGQ_DS.DONID=D.ID  
      -----------------------    
      ---hoan thi hanh an anhvh_tha----
     LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA
              FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID 
     -----------------------
     LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
        ------anhvh_ndbd--add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
         LEFT JOIN (SELECT  cc.DONID,
                      upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU
                      FROM GDTTT_DON_DUONGSU_CC cc  
                      INNER JOIN GDTTT_DON cd on cd.id=cc.DONID 
                      WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)
                      GROUP BY cc.DONID
               )nds ON nds.DONID= d.id  
         LEFT JOIN (SELECT  cc.DONID,
                      upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU
                      FROM GDTTT_DON_DUONGSU_CC cc  
                      INNER JOIN GDTTT_DON cd on cd.id=cc.DONID 
                      WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)
                      GROUP BY cc.DONID
               )bds ON bds.DONID= d.id    
           LEFT JOIN (SELECT  cc.DONID,
                      upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU
                      FROM GDTTT_DON_DUONGSU_CC cc  
                      INNER JOIN GDTTT_DON cd on cd.id=cc.DONID 
                      WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'
                      GROUP BY cc.DONID
               )bcs ON bcs.DONID= d.id          
      where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
        And 1=(Case when vIsThuLy=-1 then 1 
                    when vIsThuLy=1  and d.ISTHULY=1  then 1 -- TLM 
                    when vIsThuLy=3  and d.ISTHULY=1 
                                     and (vNgayNhapTu is not null and  vNgayNhapDen is not null)  
                                     and PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(d.id)>1 then 1 -- TLM trùng
                    when vIsThuLy=4  and d.ISTHULY=1 and  NVL(d.THAMPHANID,0) > 0  then 1 -- TLM đã phan cong
                    when vIsThuLy=5  and d.ISTHULY=1 and  NVL(d.THAMPHANID,0) = 0   then 1 -- TLM chua phan cong
                    when vIsThuLy=2 and d.ISTHULY=2 then 1 
                    Else 0 End)       
        and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
       -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
       --anhvh 12/02/2020
        AND (vLoaiAn=0
            OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
            OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
          )
--        and (vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%' 
--              Or lower(d.BAQD_SO_PT) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                Or lower(d.BAQD_SO_ST) like  lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%'
--                Or lower(d.KN_SOQD) like lower(decode(INSTR(vSoBAQD,'0'),1,regexp_replace(vSoBAQD,'0','',1,1),vSoBAQD)) || '%') 
--       and  (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
--                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
--                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
--                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 

        and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             )

        and  1=case when vNguoiGui || ' '=' ' then 1 when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
         and
         1=case when vSoCongVan || ' '=' ' then 1 when ((lower(d.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(d.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(d.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )  and d.isthuly = 1) then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
       and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and

        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end

        --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
        --anhvh 13/02/2020
        AND (vNoiChuyen=-1
             OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
             OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
             )
        and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
            OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
            OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
            when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)      
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1 when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 
                    when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 -- Có ý kiến chỉ đạo
                    when  vChidao=1 and NVL(d.CHIDAO_COKHONG,0)=0 then 1 -- Không có ý kiến chỉ đạo
                    when vChidao>1 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
        and 1=case when curr_thamphan_id=0 then 1 when d.THAMPHANID=curr_thamphan_id then 1 else 0 end

         and  ( ( (vNgayNhapTu is null or d.NGAYTAO>=vNgayNhapTu) AND (vNgayNhapDen is null or d.NGAYTAO<=vNgayNhapDen) )
            Or  (visthuly=1 and(vNgayNhapTu is null or d.TL_NGAY>=vNgayNhapTu) and (vNgayNhapDen is null or d.TL_NGAY <= vNgayNhapDen) )
          )
--        and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
--        and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
--        Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
--        and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))

        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                 and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                  and 1=case when vLoaiCVID=0 then 1 
                   when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                  when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                  And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
           ----anhvh_ndbd add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
                      AND ((TRIM(V_NDBD_TEXT) IS NULL)
                        OR(V_NDBD_VALUE ='0' AND nds.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(nds.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        OR(V_NDBD_VALUE ='1' AND bds.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(bds.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        OR(V_NDBD_VALUE='2' AND bcs.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(bcs.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        )  
         -------anhvh add 22/10/2020 vanthu den
          AND (V_DONVI_CHUYEN_ID IS NULL 
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              ) 
--          AND ( V_TRANGTHAICHUYEN IS NULL
--              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND TRANG_THAI_XLY=V_TRANGTHAICHUYEN))
--              )
            AND ( V_TRANGTHAICHUYEN IS NULL
                      OR(
                         (V_TRANGTHAICHUYEN=3 AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3  AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
                      )
                      OR(V_TRANGTHAICHUYEN=4  
                       AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3  AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID)
                      )
                  )
          AND ( V_LOAI_VB IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=V_LOAI_VB  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
           AND ( V_SODEN_TU IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=V_SODEN_TU  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )    
          AND ( V_SODEN_DEN IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=V_SODEN_DEN  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              ) 
           AND ( V_NGAY_FROM IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS')  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
            AND ( V_NGAY_TO IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS')  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
           AND ( V_NGUOI_GUI_BT IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                    WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||V_NGUOI_GUI_BT||'%' AND  cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
               ) 
          AND (vLOAI_GDTTT=0
            OR d.LOAI_GDTTTT= vLOAI_GDTTT )
          -----------------
        ) a where a.stt>=MinIndex and a.stt<=MaxIndex;
End if;
END DON_SEARCH;
PROCEDURE DON_SEARCH_TOTAL
( 
    V_NDBD_VALUE VARCHAR2,
    V_NDBD_TEXT VARCHAR2,
    --van thu don den----
    V_DONVI_CHUYEN_ID in  VARCHAR2,
    V_TRANGTHAICHUYEN in	VARCHAR2,
    V_LOAI_VB	in	VARCHAR2,
    V_SODEN_TU	in	VARCHAR2,
    V_SODEN_DEN	in	VARCHAR2,
    V_NGAY_FROM	in VARCHAR2,
    V_NGAY_TO	in VARCHAR2,
    V_NGUOI_GUI_BT	in	VARCHAR2,
    --van thu don den end----
    v_ID_USER VARCHAR2,
    vToaAnID in number,
    vToaRaBAQD in number,
    vSoBAQD in varchar2,
    vNgayBAQD in varchar2,
    vNguoiGui in varchar2,
    vSoCMND in varchar2,
    vTuNgay in date,
    vDenNgay in date,
    vHinhThucDon in number,
    vSoHieuDon in varchar2,
    vDiaChiTinh in number,
    vDiaChiHuyen in number,
    vDiaChiCT in varchar2,
    vSoCongVan in varchar2,
    vNgayCongVan in varchar2,
    vTraLoi in number,
    vNguoiNhap in varchar2,
    vNoiChuyen in number,
    vTrangthai in number,
    vCD_DONVIID in number,
    vCD_TA_TRANGTHAI in number,
    vCD_TENDONVI in varchar2,
    vNgaychuyenTu in date,
    vNgaychuyenDen in date,
    vArrSelectID in varchar2,
    vIsThuLy in number,
    vPhanloaixuly in number,
    vNgayThulyTu in date,
    vNgayThulyDen in date,
    vSoThuly in varchar2,
    vChidao in number,
    vTraigiam in number,
    vTBQuahan in number,
    vNgayQuahan in date,
    vThamphanID in number,
    vThamtravienID in number,
    vLoaiCVID in number,
    vNgayNhapTu in date,
    vNgayNhapDen in date,
    vIsDonGoc in number,
    vIsTuHinh in number,
    vLoaiAn in number,
    vCVPC_So in varchar2,
    vCVPC_Ngay in varchar2,
    vCVPC_TenCQ in varchar2,
    vGuitoiCA_TA in number,
    vLOAI_GDTTT in number,
    PageIndex	in	int,
    PageSize	in	int,
    curReturn OUT sys_refcursor
)
is
    TotalItem number;MinIndex	number;MaxIndex	number;
    ma_chucvu varchar2(10);curr_thamphan_id number:=0;vvloaian VARCHAR2(150);
    V_CANBOID number;v_phongban number;
    --v_table T_GDTTT_DON_HCTP;
BEGIN
   --v_table := T_GDTTT_DON_HCTP();  

 Select /*GSCM.PKG_GDTTT_HCTP_APP.DON_SEARCH (Danh sach Don HCTP) */ Count(d.ID)into TotalItem 
    from GDTTT_DON d
      LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
      left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
        -----
     LEFT JOIN (
             SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
             )LA ON LA.ID=D.BAQD_LOAIAN
     -----
        left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
        left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
        left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
        left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
        left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         ----van thu den anhvh 19/10/2020--    
            left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id
            LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID
            LEFT JOIN DM_PHONGBAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID
            LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON
        ------anhvh_ndbd--add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
         LEFT JOIN (SELECT  cc.DONID,
                      upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU
                      FROM GDTTT_DON_DUONGSU_CC cc  
                      INNER JOIN GDTTT_DON cd on cd.id=cc.DONID 
                      WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)
                      GROUP BY cc.DONID
               )nds ON nds.DONID= d.id  
         LEFT JOIN (SELECT  cc.DONID,
                      upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU
                      FROM GDTTT_DON_DUONGSU_CC cc  
                      INNER JOIN GDTTT_DON cd on cd.id=cc.DONID 
                      WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)
                      GROUP BY cc.DONID
               )bds ON bds.DONID= d.id    
           LEFT JOIN (SELECT  cc.DONID,
                      upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU
                      FROM GDTTT_DON_DUONGSU_CC cc  
                      INNER JOIN GDTTT_DON cd on cd.id=cc.DONID 
                      WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'
                      GROUP BY cc.DONID
               )bcs ON bcs.DONID= d.id          
    where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
          And 1=(Case when vIsThuLy=-1 then 1 
                    when vIsThuLy=1  and d.ISTHULY=1  then 1 -- TLM 
                    when vIsThuLy=3  and d.ISTHULY=1
                                     and (vNgayNhapTu is not null and  vNgayNhapDen is not null)  
                                     and PKG_GDTTT_BAOCAO_APP.CHECK_TLM_TRUNG(d.id)>1 then 1 -- TLM trùng
                    when vIsThuLy=4  and d.ISTHULY=1 and  NVL(d.THAMPHANID,0) > 0  then 1 -- TLM đã phan cong
                    when vIsThuLy=5  and d.ISTHULY=1 and  NVL(d.THAMPHANID,0) = 0   then 1 -- TLM chua phan cong
                    when vIsThuLy=2 and d.ISTHULY=2 then 1 
                    Else 0 End)       
        and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end 
       -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
       --anhvh 12/02/2020
        AND (vLoaiAn=0
            OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
            OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
          )
        and (  ((vSoBAQD || ' '=' '  Or lower(d.BAQD_SO) like lower(vSoBAQD) || '%' ) 
                  And (vNgayBAQD || ' '=' ' Or  to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD)
                )
                Or((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_PT) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD )
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.BAQD_SO_ST) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD) 
                )
                Or ((vSoBAQD || ' '=' ' Or lower(d.KN_SOQD) like  lower(vSoBAQD) || '%')
                    And (vNgayBAQD || ' '=' ' Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) 
                )
             )    
        and  1=case when vNguoiGui || ' '=' ' then 1 when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,decode(vToaAnID,6,d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI))) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
        and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
        and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
         and
         1=case when vSoCongVan || ' '=' ' then 1 when ((lower(d.CD_SOCV) =lower(vSoCongVan) And vNoiChuyen=2) Or(lower(d.CD_SOCV) =lower(vSoCongVan) And vCD_TENDONVI='CVPC') Or (lower(d.CD_SOTOTRINH) = lower(vSoCongVan) And vCD_TENDONVI='TTR' )  and d.isthuly = 1) then 1 else 0 end
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vNoiChuyen=2) Or (to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan  And vCD_TENDONVI='CVPC') Or (to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan And vCD_TENDONVI='TTR') then 1 else 0 end
       and
        1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
        and
        1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
         and

        1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
        and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end

        --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
        --anhvh 13/02/2020
        AND (vNoiChuyen=-1
             OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
             OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
             )
        and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
        and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
            when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI) 
            OR (vCD_TA_TRANGTHAI=3 and NVL(CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID)) --lanhnt thêm trạng thái đơn
            OR (vCD_TA_TRANGTHAI=4 and CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=D.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID))))) then 1
            when (vNoiChuyen=1 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TK_DONVIID=vCD_DONVIID) Or
                                    (vCD_DONVIID=-1 And d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH'))))) then 1
            when (vNoiChuyen=2 and lower(d.CD_NTA_TENDONVI) like '%' || lower(vCD_TENDONVI) || '%') then 1 
           when (vNoiChuyen>2 and d.CD_LOAI=vNoiChuyen) then 1 else 0 end)      
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= d.TL_NGAY then 1 else 0 end
        and 1=case when vNgayThulyDen is null then 1 when d.TL_NGAY <= vNgayThulyDen then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vChidao=-1 then 1 
                    when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 -- Có ý kiến chỉ đạo
                    when  vChidao=1 and NVL(d.CHIDAO_COKHONG,0)=0 then 1 -- Không có ý kiến chỉ đạo
                    when vChidao>1 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
          and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
        and 1=case when curr_thamphan_id=0 then 1 when d.THAMPHANID=curr_thamphan_id then 1 else 0 end
        and  (      ( (vNgayNhapTu is null or d.NGAYTAO>=vNgayNhapTu)    AND (vNgayNhapDen is null or d.NGAYTAO<=vNgayNhapDen) )
                Or  (visthuly=1 and(vNgayNhapTu is null or d.TL_NGAY>=vNgayNhapTu) and (vNgayNhapDen is null or d.TL_NGAY <= vNgayNhapDen) )
              )
--                (1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
--                Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
--               and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end)

        and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                 when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                 when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                 when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                 and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                  and 1=case when vLoaiCVID=0 then 1 
                   when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                  when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                  And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                      when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
               ----anhvh_ndbd add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
                      AND ((TRIM(V_NDBD_TEXT) IS NULL)
                        OR(V_NDBD_VALUE ='0' AND nds.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(nds.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        OR(V_NDBD_VALUE ='1' AND bds.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(bds.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        OR(V_NDBD_VALUE='2' AND bcs.TENDUONGSU LIKE '%'||upper(TRIM(V_NDBD_TEXT))||'%')--UPPER(bcs.TENDUONGSU) LIKE '%'||upper(V_NDBD_TEXT)||'%'
                        )  
         -------anhvh add 22/10/2020 vanthu den
          AND (V_DONVI_CHUYEN_ID IS NULL 
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              ) 
--          AND ( V_TRANGTHAICHUYEN IS NULL
--              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID AND TRANG_THAI_XLY=V_TRANGTHAICHUYEN))
--              )
            AND ( V_TRANGTHAICHUYEN IS NULL
                      OR(
                         (V_TRANGTHAICHUYEN=3 AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID) )
                      )
                      OR(V_TRANGTHAICHUYEN=4  
                       AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3 AND DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID)
                      )               
                  )
          AND ( V_LOAI_VB IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=V_LOAI_VB AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )  
           AND ( V_SODEN_TU IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=V_SODEN_TU AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              )    
          AND ( V_SODEN_DEN IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=V_SODEN_DEN AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
              ) 
           AND ( V_NGAY_FROM IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE(V_NGAY_FROM||' 00:00:00','dd/MM/yyyy HH24:MI:SS')  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
              )  
            AND ( V_NGAY_TO IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                        INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                        WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE(V_NGAY_TO||' 23:59:59','dd/MM/yyyy HH24:MI:SS') AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID ))
              )  
           AND ( V_NGUOI_GUI_BT IS NULL
              OR(EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn
                    INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  
                    WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||V_NGUOI_GUI_BT||'%'  AND cn.DONVI_CHUYEN_ID=V_DONVI_CHUYEN_ID))
               )    

       AND (vLOAI_GDTTT=0
            OR d.LOAI_GDTTTT= vLOAI_GDTTT )
      ;
    OPEN curReturn FOR
    SELECT TotalItem AS TotalItem FROM DUAL;
END;
END PKG_GDTTT_HCTP_APP;
