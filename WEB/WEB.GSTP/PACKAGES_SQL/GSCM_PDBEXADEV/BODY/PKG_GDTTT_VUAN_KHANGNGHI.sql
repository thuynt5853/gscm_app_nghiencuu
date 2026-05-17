--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_KHANGNGHI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_KHANGNGHI" AS

FUNCTION CHECK_VUAN_LUUSO(vToaAnID in number, vPhongbanID in number, vLoaiSO  in varchar2, vVUANID in number, vDonVi in number)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
        SELECT 
               CASE WHEN EXISTS(SELECT 'x' FROM SOPHATHANH_VUAN a 
                                INNER JOIN SOPHATHANH_VUGIAMDOC s on s.id = a.SOPHATHANH_ID
                                LEFT JOIN GDTTT_VUAN d on d.id =a.VUANID
                                WHERE s.ToaAnID = vToaAnID AND s.PhongbanID = vPhongbanID AND s.MASO = vLoaiSO AND a.VUANID = vVUANID and ISDONVI = vDonVi
                                ) 
                 THEN 1 
                 ELSE 0 
               END 
               INTO V_COUNT
            FROM dual ;
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;  
END CHECK_VUAN_LUUSO;

FUNCTION CHECK_VUAN_SOVANBAN(vToaAnID in number, vPhongbanID in number, vLoaiSO  in varchar2, vSoVB in varchar2, vNgayVB in varchar2)RETURN NUMBER AS
    V_COUNT NUMBER;
    vYear  varchar2(10);
BEGIN
     vYear := substr(vNgayVB,instr(vNgayVB,'/',1,2)+1);
        SELECT 
               CASE WHEN EXISTS(SELECT 'x' FROM SOPHATHANH_VUGIAMDOC a 
                                WHERE a.ToaAnID = vToaAnID AND a.PhongbanID = vPhongbanID AND a.MASO = vLoaiSO AND a.SOVB = vSoVB
                                    AND a.NGAYVB between TO_DATE(Cast((vYear) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vYear) as varchar2(4))||'-12-31','YYYY-MM-DD')                                    
                                )    
           THEN 1 
                 ELSE 0 
               END 
               INTO V_COUNT
        FROM dual ;  

        IF (NVL(V_COUNT,0)>0)THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
END CHECK_VUAN_SOVANBAN;

FUNCTION SOVANBAN_VUAN_INSERT(v_ToaAnID in number, v_PhongbanID in number, v_ISDONVI in number, v_ThamphanID IN VARCHAR2, v_MASO IN VARCHAR2,
    v_SOVB IN VARCHAR2, v_NGAYVB IN VARCHAR2, v_NGUOIKY IN VARCHAR2, v_CHUCVU IN VARCHAR2, V_NGUOITAO IN VARCHAR2)RETURN NUMBER AS
    vPHATHANHID NUMBER;
BEGIN
SAVEPOINT P1;     
        vPHATHANHID:= SOPHATHANH_VUGIAMDOC_SEQ.NEXTVAL;
        INSERT INTO SOPHATHANH_VUGIAMDOC (ID,TOAANID,PHONGBANID,ISDONVI,ThamphanID,MASO,SOVB,NGAYVB,NGUOIKY,CHUCVU,NGUOITAO,NGAYTAO)
        VALUES (vPHATHANHID,v_ToaAnID,v_PhongbanID,v_ISDONVI,v_ThamphanID,v_MASO,v_SOVB,to_date(v_NGAYVB,'dd/MM/yyyy'),v_NGUOIKY,v_CHUCVU,V_NGUOITAO,SYSDATE);
       RETURN vPHATHANHID;    
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;
END SOVANBAN_VUAN_INSERT;

FUNCTION SOPHATHANH_VUAN_INSERT(v_PHATHANHID IN NUMBER, v_VUANID IN NUMBER, V_NGUOITAO IN VARCHAR2)RETURN NUMBER AS
BEGIN
SAVEPOINT P1;     
        Insert Into SOPHATHANH_VUAN (ID,SOPHATHANH_ID,VUANID,NGUOITAO,NGAYTAO)
        VALUES (SOPHATHANH_VUAN_SEQ.nextval,v_PHATHANHID,v_VUANID,V_NGUOITAO,SYSDATE);
        RETURN 1;
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOPHATHANH_VUAN_INSERT;

FUNCTION CHECK_SOTOTRINH_VUAN(vToaAnID in number, vPhongbanID in number, vVuanID in varchar2, vMASO in varchar2)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
      select count(s.id) into V_COUNT 
        from SOPHATHANH_VUGIAMDOC s 
        left join  SOPHATHANH_VUAN sd on s.id = sd.SOPHATHANH_ID 
        left join GDTTT_VUAN D ON D.ID=SD.VUANID
        where  s.TOAANID=vToaAnID and s.PHONGBANID = vPhongbanID and s.trangthai = 1 and upper(s.MASO)  = upper(vMASO) and sd.VUANID = vVuanID;
        
        IF (NVL(V_COUNT,0)>0)THEN
            RETURN V_COUNT;
        ELSE
            RETURN 0;
        END IF;
END CHECK_SOTOTRINH_VUAN;

PROCEDURE GET_SOTOTRINH_SOVB_VUAN(vToaAnID in number, vPhongbanID in number, vLoaiso in varchar2, vSOVB in varchar2, vYear in number, curReturn OUT sys_refcursor)
IS 
BEGIN
    OPEN curReturn FOR
        select s.* 
        from SOPHATHANH_VUGIAMDOC s 
        where s.TOAANID=vToaAnID and s.PHONGBANID = vPhongbanID and s.trangthai = 1 and s.MASO = vLoaiso and s.SOVB = vSOVB
        and s.NGAYVB between TO_DATE(Cast((vYear) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vYear) as varchar2(4))||'-12-31','YYYY-MM-DD');
        
END GET_SOTOTRINH_SOVB_VUAN;

FUNCTION CHECK_SOTOTRINH_VUAN_TLL
( 
    vToaAnID in number,
    vPhongbanID in number,
    vVuanid in varchar2
)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
    select count(s.id) into V_COUNT 
    from SOPHATHANH_VUGIAMDOC s 
    left join  SOPHATHANH_VUAN sd on s.id = sd.SOPHATHANH_ID
    LEFT JOIN GDTTT_VUAN D on d.id=sd.VUANID
    where s.TOAANID=vToaAnID and s.PHONGBANID = vPhongbanID and s.trangthai = 1 and upper(s.MASO) = 'SOTT_TLL' and sd.VUANID = vVuanid;
      
    IF (NVL(V_COUNT,0)>0)THEN
        RETURN V_COUNT;
    ELSE
        RETURN 0;
    END IF;
END CHECK_SOTOTRINH_VUAN_TLL;

PROCEDURE GET_SOVB_VUAN(vMASO in varchar2, vToaAnID in number, vPhongbanID in number, vVuanID in number, curReturn OUT sys_refcursor) IS 
BEGIN
      OPEN curReturn FOR
            select s.SOVB, s.NGAYVB, s.NGUOIKY, s.MASO
            from SOPHATHANH_VUGIAMDOC s
            left join SOPHATHANH_VUAN sd on s.id = sd.SOPHATHANH_ID
            where s.TOAANID=vToaAnID and s.PHONGBANID = vPhongbanID and s.trangthai = 1 and upper(s.MASO) = upper(vMASO) and sd.VUANID = vVuanID
            group by s.SOVB, s.NGAYVB, s.NGUOIKY, s.MASO;

END GET_SOVB_VUAN;

PROCEDURE GET_THAMPHAN_VUAN(vToaAnID in number, vPhongbanID in number, vLoaiSO  in varchar2, arrVuanID  in varchar2, v_SOTOTRINH in varchar2,
    v_NGAYTOTRINH in varchar2, curReturn OUT sys_refcursor) IS 
BEGIN
  OPEN curReturn FOR
      select DISTINCT d.thamphanid , cb.hoten 
      from GDTTT_VUAN d
      left JOIN dm_canbo cb on cb.id =d.thamphanid
      where d.id in(select sd.VUANID 
                    from SOPHATHANH_VUGIAMDOC s 
                    left join SOPHATHANH_VUAN sd on s.id = sd.SOPHATHANH_ID
                    where s.TOAANID=vToaAnID and s.PHONGBANID = vPhongbanID and INSTR(','||vLoaiSO||',',','||s.MASO||',') > 0
                    and ','||arrVuanID||',' like  '%,'||sd.VUANID||',%' and lower(s.SOVB) = lower(v_SOTOTRINH) 
                    and s.NGAYVB = to_date(v_NGAYTOTRINH,'dd/MM/yyyy') and s.trangthai = 1 and d.thamphanid is not null);
END GET_THAMPHAN_VUAN;

PROCEDURE QLSOVB_GETMAXTT_VUAN(vdonviID in number, vPhongbanid in number, vYear in number, vLoaiso in varchar2, curReturn OUT sys_refcursor) IS 
    vY number;
    vMaxSoDon number;
    vMaxSoVuAn number;
BEGIN
    vY:=vYear;

    select Max(to_number(regexp_replace(tt.SOVB, '[^0-9]'))) SOVB into vMaxSoVuAn
    from (select lower(DECODE(INSTR(SOVB,'/'), 0, decode(INSTR(SOVB,'0'),1,regexp_replace(SOVB,'0','',1,1),SOVB),
                    decode(INSTR(SOVB,'0'),1,SUBSTR(regexp_replace(SOVB,'0','',1,1),1,instr(regexp_replace(SOVB,'0','',1,1),'/')-1),SUBSTR(SOVB,1,instr(SOVB,'/')-1)))) SOVB
            from sophathanh_vugiamdoc d
            Where d.TOAANID=vdonviID and d.PHONGBANID=vPhongbanid AND d.MASO = vLoaiso and trim(d.SOVB) is not null 
            and d.NGAYVB between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
          ) tt;
    
    select  Max(to_number(regexp_replace(tt.SOVB, '[^0-9]'))) SOVB into vMaxSoDon
    from (select lower(DECODE(INSTR(SOVB,'/'),0,decode(INSTR(SOVB,'0'),1,regexp_replace(SOVB,'0','',1,1),SOVB),
                    decode(INSTR(SOVB,'0'),1,SUBSTR(regexp_replace(SOVB,'0','',1,1),1,instr(regexp_replace(SOVB,'0','',1,1),'/')-1),SUBSTR(SOVB,1,instr(SOVB,'/')-1)))) SOVB
            from QUANLY_SOPHATHANH d
            Where d.TOAANID=vdonviID and d.PHONGBANID=vPhongbanid AND d.MASO = vLoaiso and trim(d.SOVB) is not null
            and d.NGAYVB between TO_DATE(Cast((vY) as varchar2(4))||'-01-01','YYYY-MM-DD') and TO_DATE(Cast((vY) as varchar2(4))||'-12-31','YYYY-MM-DD')
    )tt;
    
    if NVL(vMaxSoVuAn, 0) > NVL(vMaxSoDon, 0) then
        OPEN curReturn FOR SELECT NVL(vMaxSoVuAn, 0) FROM dual;
    else
        OPEN curReturn FOR SELECT NVL(vMaxSoDon, 0) FROM dual;
    end if;
END QLSOVB_GETMAXTT_VUAN;

FUNCTION CHECK_SOVB_VUAN(V_MASO in varchar2, vToaAnID in number, vPhongbanID in number, vVuanid in varchar2)RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
      select count(s.id) into V_COUNT  
      from SOPHATHANH_VUGIAMDOC s 
      left join SOPHATHANH_VUAN sd on s.id = sd.SOPHATHANH_ID 
      where s.TOAANID=vToaAnID and s.PHONGBANID = vPhongbanID 
      and s.trangthai = 1 and upper(s.MASO) = upper(V_MASO) and sd.VUANID = vVuanid;
      
        IF (NVL(V_COUNT,0) > 0) THEN
            RETURN V_COUNT;
        ELSE
            RETURN 0;
        END IF;  
END CHECK_SOVB_VUAN;

FUNCTION GET_GDTTT_VUAN_THONGTIN_CHUYEN_NEXTVAL RETURN NUMBER AS
    vPHATHANHID NUMBER;
BEGIN
    vPHATHANHID:= GDTTT_VUAN_THONGTIN_CHUYEN_SEQ.NEXTVAL;
    RETURN vPHATHANHID;
END GET_GDTTT_VUAN_THONGTIN_CHUYEN_NEXTVAL;

FUNCTION GET_GDTTT_VUAN_CHITIET_CHUYEN_NEXTVAL RETURN NUMBER AS
    vPHATHANHID NUMBER;
BEGIN
    vPHATHANHID:= GDTTT_VUAN_CHITIET_CHUYEN_SEQ.NEXTVAL;
    RETURN vPHATHANHID;
END GET_GDTTT_VUAN_CHITIET_CHUYEN_NEXTVAL;

PROCEDURE GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2,
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  
  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
)
IS 
  TotalItem number;VUANIDS number;vvtt_denngay date;
  MinIndex	number;vvloaian VARCHAR2(150);
  MaxIndex	number;
   --------------------------
  V_CURSOR sys_refcursor;v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(50);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL  DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
BEGIN
v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvtt_denngay from dual;
 -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------

  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                , NVL(v.TongDon,0 ) as TongDon
                --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ----manhnd-----------
                ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                , PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon      ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                , decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                 ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN Decode(v.TOAANID,1,tts.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) 
                                                                ELSE Decode(v.TOAANID,1,tt.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(v.GQD_LOAIKETQUA , 4, decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                        ,818,'CA TANDTC'
                                                                                                        ,819,'CA TANDCC tại Hà Nội'
                                                                                                        ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                        ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                        ,'VKS'))
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
               , DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
                , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV, totrinh.ykien, sph.SOVB, to_char(sph.NGAYVB,'dd/MM/yyyy') AS NGAYVB
                ,NVL2(ctc.ID, 'Đã chuyển', 'Chưa chuyển') AS trang_thai_chuyen, to_char(ctc.NGAYCHUYEN,'dd/MM/yyyy') as NGAYCHUYEN, ctc.NGUOICHUYEN
                ,DECODE(ctc.TRANGTHAI, 1, 'Chưa nhận', 2, 'Đã nhận', '') AS trang_thai_nhan, to_char(ctc.NGAYNHAN,'dd/MM/yyyy') as NGAYNHAN, ctc.NGUOINHAN, tptc.hoten AS THAMPHANTC_TEN
              from GDTTT_VUAN v 
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              --huynt
              LEFT JOIN (SELECT sp.VUANID, spgd.SOVB, spgd.NGAYVB, spgd.MASO, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 0 --văn bản của vụ giám đốc
                        ) sph ON v.ID = sph.VUANID
              LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
              LEFT JOIN DM_CANBO tptc ON tptc.id = ctc.THAMPHANID
              
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
                and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
                and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)  
                AND ((NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )
                                        ))
                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                    AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                     )
                                    )
                             OR trim(vNguyendon) || ' '=' ')      
              and ( vBidon is null 
                        or vBidon = '' 
                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')))
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0))
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              AND (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0)
              and ( tt_tungay is null or EXISTS(select ID from GDTTT_TOTRINH TT where v.ID = TT.VUANID AND TT.NGAYTRINH  >=tt_tungay )
                    )                    
                and ( tt_denngay is null OR (    (isTTToTrinh != 0 and EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH <= vvtt_denngay) )
                                               or(isTTToTrinh=0)
                                            )
                  )  
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and ( NOT EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH <vvtt_denngay)
                                             OR EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH >= vvtt_denngay)
                                            )
                    )
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT where v.ID = TT.VUANID )


                       )                               
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,vvtt_denngay)>0
                       )   
                  )
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (NVL(v.THAMTRAVIENID,0) = 0 AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    ) 
                or (vtrangthai = 2 AND (NVL(v.THAMTRAVIENID,0) != 0 OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) )--AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) 
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
          and ( isTTYKienKLTotrinh = 2
                or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                )      
               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0
                    or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                    )
                ------------------------------------
               AND (vIsDangKyBC=2
                            OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )  ) 
                            OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)   ) )
                        ) 
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            
              )
              -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) ))           
                 and ( vKetquathuly = 3
                        OR (v.LOAIAN != 1 and vKetquathuly = 4 and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id))        
                           
                        or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id)) -- có kết quả
                                                    
                        or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn  
                        or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 
                                                    and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS                                                                 
                        or ( v.LOAIAN != 1 and vKetquathuly = 1  and  NVL(v.isvientruongkn,0) = 0
                                                         and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --khang nghị CA
                        or ( v.LOAIAN != 1 and vKetquathuly = -1  and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                         ) --khang nghị CA + VKS                                                         
                        or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --- xếp đơn
                        or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) -- xử lý khác               
                        or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )                                                            
                                                            ) ---VKS đang giải quyết                    
                     ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                        or (v.LOAIAN = 1 and vKetquathuly = 7 and (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0))
                        or (v.LOAIAN = 1 and vKetquathuly = 4  and v.gqd_loaiketqua is null)
                        or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                                AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                        or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                        or (v.LOAIAN = 1 and vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                       or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS        
                        or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                        or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                        or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                        or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết                                
                    )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------
             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
            AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0),
                                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                  or (vLoaiAnDB_TH = 6  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<180
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2 or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)) 
              and (vSoVB is null or (sph.SOVB =vSoVB and sph.MASO = vLoaiSoVB)) and (vNgayVB is null or (sph.NGAYVB = vNgayVB and sph.MASO = vLoaiSoVB))
              and (vTrangThaiChuyen is null or ((vTrangThaiChuyen = 0 and ctc.ID is null) or (vTrangThaiChuyen = 1 and ctc.ID is not null)))
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_SEARCH;

FUNCTION  GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_PRINT
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,

  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,

  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,

  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvisTTYKienKLTotrinh varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;
   v_ghichu varchar2(2000);vCOUNT_NGAYTT NUMBER;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
   -----
   SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
   -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,tt_denngay) into vtt_denngay from dual;
 v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------

  FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                , NVL(v.TongDon,0 ) as TongDon
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,'TTV: ' || ttv.HOTEN || '<br/>PVT: '||ld.HOTEN ||'<br/>TP: '|| tp.HOTEN  as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS         
              from GDTTT_VUAN v
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID 
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              --huynt
              LEFT JOIN (SELECT sp.VUANID, spgd.SOVB, spgd.NGAYVB, spgd.MASO, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 0 --văn bản của vụ giám đốc
                        ) sph ON v.ID = sph.VUANID
              LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
              ----
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
                and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                  -----------------------
              and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%'   or UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
              and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
               ----------------------
               AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                          )

                                ))

                     OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                            AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                             )
                            )
                     OR trim(vNguyendon) || ' '=' '

                  )            
              ----------------------
              and ( vBidon is null 
                    or vBidon = '' 
                    or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                          )
                        )
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT
                                                     where v.ID = TT.VUANID 
                                                     AND ((TT.NGAYTRINH  >=tt_tungay AND tt_tungay IS NOT NULL) OR (tt_tungay IS NULL )) 
                                                     AND ((TT.NGAYTRINH <= tt_denngay AND tt_denngay IS NOT NULL) OR(tt_denngay IS NULL))
                                                   )
                       )                               
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,tt_denngay)>0
                       )   
                  )    
--                /*
--                  Trang thai =1/2 -->chua/da pc TTV + chua co KQ giai quyet
--                  Trang thai =3 --> co ho so + chua co to trinh + chua co KQ GQ don
--                */
--            -- Trạng thái thụ lý 
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )--anhvh   
                or (vtrangthai = 2 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    ) --anhvh 
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
          and ( isTTYKienKLTotrinh = 2
                or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                )      
               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0
                    or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                    )
                ------------------------------------
                AND (vIsDangKyBC=2
                    OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and TINHTRANGID = vtrangthai) )
                    OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and TINHTRANGID = vtrangthai) )
                )
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            

              )
               -------liên quan đến tham số ngày---------------------
                and ( tt_tungay is null or(v.NGAYTAO>=tt_tungay) 
                  )                    
                and ( tt_denngay is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                               or(vKetquathuly =4)
                                            )   
                  )  
               
                --///////////////////////////////////////////////////
                -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) ))
  ------------------------------------------             
                 and ( vKetquathuly = 3
                        OR (v.LOAIAN != 1 and vKetquathuly = 4 and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id))        
                           
                        or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id)) -- có kết quả
                                                    
                        or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn  
                        or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 
                                                    and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS                                                                 
                        or ( v.LOAIAN != 1 and vKetquathuly = 1  and  NVL(v.isvientruongkn,0) = 0
                                                         and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --khang nghị CA
                        or ( v.LOAIAN != 1 and vKetquathuly = -1  and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                         ) --khang nghị CA + VKS
                                                         
                        or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --- xếp đơn
                        or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) -- xử lý khác               
                        or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        ) 
                                                            
                                                            ) ---VKS đang giải quyết
                        
                        
                     ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                        or (v.LOAIAN = 1 and vKetquathuly = 7 and (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0))
                        or (v.LOAIAN = 1 and vKetquathuly = 4  and v.gqd_loaiketqua is null)
                        or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                                AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                        or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                        or (v.LOAIAN = 1 and vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                       or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS        
                        or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                        or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                        or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                        or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết                                
                    )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------   
                          
             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
             AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2 or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha))
              and (vSoVB is null or (sph.SOVB =vSoVB and sph.MASO = vLoaiSoVB)) and (vNgayVB is null or (sph.NGAYVB = vNgayVB and sph.MASO = vLoaiSoVB))
              and (vTrangThaiChuyen is null or ((vTrangThaiChuyen = 0 and ctc.ID is null) or (vTrangThaiChuyen = 1 and ctc.ID is not null)))
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
--          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
--                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br/>')||'</td>
--             ');
            if(vKetquathuly=4)then 
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
             ');
             elsif(vKetquathuly=5)then 
                DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
             ');
             ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
             ');
             end if;
             IF(ITEM.TRANGTHAIID!=2 AND ITEM.GiaiDoanTrinh=2)THEN--ITEM.TRANGTHAIID=2 phân công thẩm tra viên
                SELECT COUNT(*) INTO vCOUNT_NGAYTT FROM TABLE(v_table_all) TI  WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID);
                IF(vCOUNT_NGAYTT>0)THEN
                       SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                          select TI.NGAYTRINH FROM TABLE(v_table_all) TI  WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                        )TTI WHERE rownum=1;
                  ELSE
                       SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                       SELECT TI.NGAYTRINH  FROM GDTTT_TOTRINH TI WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID OR TI.CAPTRINHTIEP=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                      )TTI WHERE rownum=1;
                  END IF;
             ELSE
                 IF(ITEM.TRANGTHAIID=2 )THEN
                    vNgayTrinh:=ITEM.NGAYPHANCONGTTV|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV;
                 ELSIF(ITEM.TRANGTHAIID!=15 )THEN --THULY_XETXU_GDT
                    IF(ITEM.KQ_GQD_ID<= 2)THEN
                      IF(ITEM.LOAIAN=01)THEN
                       if( ITEM.KQ_GQD_ID!=0) THEN
                       vNgayTrinh:=ITEM.AHS_ThongTinGQD;
                       ELSE
                         vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                       END IF;  
                     ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                     END IF;
                    ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                    END IF;
                 ELSE
                      vNgayTrinh:=ITEM.NGAYTHULYXXGDT; 
                 END IF;   
             END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||item.TenTinhTrang||'<b>'||item.LoaiKN||'</b><br style="mso-data-placement:same-cell;"/> Ngày '||vNgayTrinh||'</td>
            </tr>
        ');
  END LOOP;
    -------TẠO BÁO CÁO
      IF(vThamtravien!=0)THEN
        SELECT II.TEN||': '||CB.HOTEN INTO vvThamtravien FROM DM_CANBO CB 
        INNER JOIN (select i.ID, i.TEN from DM_DATAITEM i where i.GROUPID=12)II ON II.ID=CB.CHUCDANHID
        WHERE CB.ID=vThamtravien;
     END IF;
    SELECT DECODE(isTTYKienKLTotrinh,0,'chưa duyệt',1,'đã duyệt',null) into vvisTTYKienKLTotrinh from dual;
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
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
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="13" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="13" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>TỔNG HỢP DANH SÁCH VỤ ÁN '||upper(vvisTTYKienKLTotrinh)||'</b>
                    <br style="mso-data-placement:same-cell;"/>
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            ');
            IF(vThamtravien!=0)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">'||vvThamtravien||'</td>
            </tr>
            ');
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số vụ án '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số - Ngày 
                    <br style="mso-data-placement:same-cell;"/>
                    thụ lý </td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số án
                    <br style="mso-data-placement:same-cell;"/>
                    ngày xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
--             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
--                ');  
             if(vKetquathuly=4)then 
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 ');  
             elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
                 '); 
             ELSE
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 ');  
                 end if;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <!--td style="width: 80pt"></td-->
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 120pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
             end if;
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
--                <td style="width: 120pt"></td>
--                 ');
              if(vKetquathuly=4)then    
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                 ');
               elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                 ');
               ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                 ');
               end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                <td style="width: 80pt"></td>
            </tr>
        </table>
      ');

 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_PRINT;

FUNCTION GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BC_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,

  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,

  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvisTTYKienKLTotrinh varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;
   v_ghichu varchar2(2000);
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
   -----
   SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
   -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,tt_denngay) into vtt_denngay from dual;
 v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------
--    isYKienKLToTrinh == 11 && isBuocTT == 1    

if (isTTYKienKLToTrinh = 11 and vKetquathuly = 4) then
    FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT 
                , NVL(v.TongDon,0 ) as TongDon
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --
                , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 5, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))
                              , 4,'VKS đang giải quyết') KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS          
              from GDTTT_VUAN v 
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
              LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                        FROM GDTTT_VUAN_DS_KN KN
                        LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                        LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                        GROUP BY KN.VUANID
                    )HSKN ON HSKN.VUANID=V.ID
             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                        FROM GDTTT_VUAN_DUONGSU DS
                        WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                        GROUP BY DS.VUANID
                )ND ON ND.VUANID=V.ID     
             LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                        FROM GDTTT_VUAN_DUONGSU DS
                        WHERE DS.TUCACHTOTUNG='BIDON' 
                        GROUP BY DS.VUANID
                )BD ON BD.VUANID=V.ID     
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
              and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
              -----------------------
              and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%'   or UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
              and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
               ----------------------
               AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                          )

                                ))

                     OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                            AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                             )
                            )
                     OR trim(vNguyendon) || ' '=' '

                  )            
              ----------------------
              and ( vBidon is null 
                    or vBidon = '' 
                    or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                          )
                        )
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT
                                                     where v.ID = TT.VUANID 
                                                     AND ((TT.NGAYTRINH  >=tt_tungay AND tt_tungay IS NOT NULL) OR (tt_tungay IS NULL )) 
                                                     AND ((TT.NGAYTRINH <= tt_denngay AND tt_denngay IS NOT NULL) OR(tt_denngay IS NULL))
                                                   )
                       )
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,tt_denngay)>0
                       )   
                  ) 
--                /*
--                  Trang thai =1/2 -->chua/da pc TTV + chua co KQ giai quyet
--                  Trang thai =3 --> co ho so + chua co to trinh + chua co KQ GQ don
--                */
--            -- Trạng thái thụ lý 
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    ) 
                or (vtrangthai = 2 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
          and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and loaiykien = 1 and TINHTRANGID >= 7) -- dã có ý kiến KN từ PCA, CA, TTP
               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0 or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep)))
                ------------------------------------
                AND (vIsDangKyBC=2
                    OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and TINHTRANGID = vtrangthai) )
                    OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and TINHTRANGID = vtrangthai) )
                )
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            

              )
               -------liên quan đến tham số ngày---------------------
                and ( tt_tungay is null or(v.NGAYTAO>=tt_tungay) 
                  )                    
                and ( tt_denngay is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                               or(vKetquathuly =4)
                                            )   
                  )  
              
                --///////////////////////////////////////////////////
                -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) ))
       ------------------------------------------             
                 and ( vKetquathuly = 3
                        OR (v.LOAIAN != 1 and vKetquathuly = 4 and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id))        
                           
                        or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id)) -- có kết quả
                                                    
                        or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn  
                        or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 
                                                    and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS                                                                 
                        or ( v.LOAIAN != 1 and vKetquathuly = 1  and  NVL(v.isvientruongkn,0) = 0
                                                         and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --khang nghị CA
                        or ( v.LOAIAN != 1 and vKetquathuly = -1  and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                         ) --khang nghị CA + VKS
                                                         
                        or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --- xếp đơn
                        or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) -- xử lý khác               
                        or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        ) 
                                                            
                                                            ) ---VKS đang giải quyết
                        
                        
                     ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                        or (v.LOAIAN = 1 and vKetquathuly = 7 and (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0))
                        or (v.LOAIAN = 1 and vKetquathuly = 4  and v.gqd_loaiketqua is null)
                        or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                                AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                        or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                        or (v.LOAIAN = 1 and vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                       or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS        
                        or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                        or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                        or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                        or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết                                
                    )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------   
                          

             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
             AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2
                        or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                ) 
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br style="mso-data-placement:same-cell;"/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br style="mso-data-placement:same-cell;"/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
         if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;


             IF(ITEM.TRANGTHAIID!=2 AND ITEM.GiaiDoanTrinh=2)THEN--ITEM.TRANGTHAIID=2 phân công thẩm tra viên
                  SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                   SELECT TI.NGAYTRINH  FROM GDTTT_TOTRINH TI WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID OR TI.CAPTRINHTIEP=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                  )TTI WHERE rownum=1;
             ELSE
                 IF(ITEM.TRANGTHAIID=2 )THEN
                    vNgayTrinh:=ITEM.NGAYPHANCONGTTV|| '<br style="mso-data-placement:same-cell;"/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV;
                 ELSIF(ITEM.TRANGTHAIID!=15 )THEN --THULY_XETXU_GDT
                    IF(ITEM.KQ_GQD_ID<= 2)THEN
                      IF(ITEM.LOAIAN=01)THEN
                       if( ITEM.KQ_GQD_ID!=0) THEN
                       vNgayTrinh:=ITEM.AHS_ThongTinGQD;
                       ELSE
                         vNgayTrinh:=ITEM.GDQ_NGAY|| '<br style="mso-data-placement:same-cell;"/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                       END IF;  
                     ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br style="mso-data-placement:same-cell;"/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                     END IF;
                    ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br style="mso-data-placement:same-cell;"/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                    END IF;
                 ELSE
                      vNgayTrinh:=ITEM.NGAYTHULYXXGDT; 
                 END IF;   
             END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
            v_ghichu := null;
            select g.ghichu into v_ghichu  from(
                     select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
                    ' '||
                    REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án','')||
                    decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP ')) ||
                    (select hoten from DM_CANBO  where id = lanhdaoid) ||

                    ';'||
                    to_char(NGAYTRA,'dd/MM/yyyy')||
                    decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,'Chánh án',' TP ')) ||
                    (select hoten from DM_CANBO  where id = lanhdaoid) || 
                    decode(loaiykien,1,' duyệt KN ',0,'duyệt TLĐ ',loaiykien)||
                    decode(loaiykien,null,' '||YKIEN,null)                
                    , '; ' ) WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id AND SS.TINHTRANGID>=7
                                                                     and ss.ID >=(SELECT MIN(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id  AND S.TINHTRANGID>=7 and s.LoaiYkien = 1)  
                                                          ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;   
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||v_ghichu||'</td>');
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'                
            </tr>
        ');
  END LOOP;

elsif (isTTYKienKLToTrinh = 10 and vKetquathuly = 4) then
    FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT 
                , NVL(v.TongDon,0 ) as TongDon
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 5, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))
                              , 4,'VKS đang giải quyết') KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS          
              from GDTTT_VUAN v 
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
              and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
              -----------------------
              and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%'   or UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
              and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
               ----------------------
               AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                          )
                                ))
                     OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                            AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                             )
                            )
                     OR trim(vNguyendon) || ' '=' '
                  )
              ----------------------
              and ( vBidon is null 
                    or vBidon = '' 
                    or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                          )
                        )
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT
                                                     where v.ID = TT.VUANID 
                                                     AND ((TT.NGAYTRINH  >=tt_tungay AND tt_tungay IS NOT NULL) OR (tt_tungay IS NULL )) 
                                                     AND ((TT.NGAYTRINH <= tt_denngay AND tt_denngay IS NOT NULL) OR(tt_denngay IS NULL))
                                                   )
                       )                               
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,tt_denngay)>0
                       )   
                  )    
--                /*
--                  Trang thai =1/2 -->chua/da pc TTV + chua co KQ giai quyet
--                  Trang thai =3 --> co ho so + chua co to trinh + chua co KQ GQ don
--                */
--            -- Trạng thái thụ lý 
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )  
                or (vtrangthai = 2 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
            and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL  and loaiykien = 0 and TINHTRANGID >= 6) -- dã có ý kiến trả lời đơn từ cấp TP, PCA, CA,TTP

               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0 or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep)))
                ------------------------------------
                AND (vIsDangKyBC=2
                    OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and TINHTRANGID = vtrangthai) )
                    OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and TINHTRANGID = vtrangthai) )
                )
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            

              )
               -------liên quan đến tham số ngày---------------------
                and ( tt_tungay is null or(v.NGAYTAO>=tt_tungay) 
                  )                    
                and ( tt_denngay is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                               or(vKetquathuly =4)
                                            )   
                  )  
                -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvngaythulyden )   )
                --///////////////////////////////////////////////////
                -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) ))
                 -- Kết quả thụ lý (convert code cũ)
             and ( vKetquathuly = 3 
                or (vKetquathuly = 4 and  v.gqd_loaiketqua is null ) -- chưa có kết quả and v.gqd_loaiketqua is null --add anhvh vKetquathuly = 4
                or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả               
                or (vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                or (vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                or (vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                )   
             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
             AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2
                        or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                ) 
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br style="mso-data-placement:same-cell;"/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br style="mso-data-placement:same-cell;"/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;

             IF(ITEM.TRANGTHAIID!=2 AND ITEM.GiaiDoanTrinh=2)THEN--ITEM.TRANGTHAIID=2 phân công thẩm tra viên
                  SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                   SELECT TI.NGAYTRINH  FROM GDTTT_TOTRINH TI WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID OR TI.CAPTRINHTIEP=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                  )TTI WHERE rownum=1;
             ELSE
                 IF(ITEM.TRANGTHAIID=2 )THEN
                    vNgayTrinh:=ITEM.NGAYPHANCONGTTV|| '<br style="mso-data-placement:same-cell;"/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV;
                 ELSIF(ITEM.TRANGTHAIID!=15 )THEN --THULY_XETXU_GDT
                    IF(ITEM.KQ_GQD_ID<= 2)THEN
                      IF(ITEM.LOAIAN=01)THEN
                       if( ITEM.KQ_GQD_ID!=0) THEN
                       vNgayTrinh:=ITEM.AHS_ThongTinGQD;
                       ELSE
                         vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                       END IF;  
                     ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                     END IF;
                    ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                    END IF;
                 ELSE
                      vNgayTrinh:=ITEM.NGAYTHULYXXGDT; 
                 END IF;   
             END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
            v_ghichu := null;
            select g.ghichu into v_ghichu  from(
                     select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
                    ' '||
                    decode(TINHTRANGID,9,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),17,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),REPLACE(REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),'Thẩm phán',''))||
                    decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                    (select hoten from DM_CANBO  where id = lanhdaoid) 
                    ||'; '||

                        to_char(NGAYTRA,'dd/MM/yyyy')||
                        decode(NGAYTRA, null,'',decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '))) ||
                        decode(NGAYTRA, null,'',(select hoten from DM_CANBO  where id = lanhdaoid)) || 
                        decode(loaiykien,1,' duyệt KN ',0,' duyệt TLĐ ',loaiykien)||
                        decode(loaiykien,null,' '||YKIEN,null)                 
                        , '; '
                        )
                     WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id AND SS.TINHTRANGID>=6 
                                                        and ss.ID >=(SELECT MIN(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id  AND S.TINHTRANGID>=6 and s.LoaiYkien = 0)   
                                                          ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;   
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||v_ghichu||'</td>');
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'                
            </tr>
        ');
  END LOOP;

end if; 

    -------TẠO BÁO CÁO
    IF(vThamtravien!=0)THEN
        SELECT II.TEN||': '||CB.HOTEN INTO vvThamtravien FROM DM_CANBO CB 
        INNER JOIN (select i.ID, i.TEN from DM_DATAITEM i where i.GROUPID=12)II ON II.ID=CB.CHUCDANHID
        WHERE CB.ID=vThamtravien;
     END IF;
--    SELECT DECODE(isTTYKienKLTotrinh,0,'chưa duyệt',1,'đã duyệt',null) into vvisTTYKienKLTotrinh from dual;
--    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
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
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="13" style="height: 0pt;"></td>
            </tr>
            <tr>');
            IF (isTTYKienKLToTrinh = 10) THEN
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                    <td colspan="17" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>TỜ TRÌNH ĐÃ DUYỆT TRẢ LỜI ĐƠN</b>');
            ELSE 
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                        <td colspan="7" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>TỜ TRÌNH ĐÃ DUYỆT KHÁNG NGHỊ</b>');
            END IF;

            IF (tt_tungay is not null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br style="mso-data-placement:same-cell;"/>
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is null and tt_denngay is not null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br style="mso-data-placement:same-cell;"/>
                        <i style="font-size: 12pt;">(Số liệu đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            elsif (tt_tungay is not null and tt_denngay is null) then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br style="mso-data-placement:same-cell;"/>
                        <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            else
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <br style="mso-data-placement:same-cell;"/>
                        <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>
                    </td>
                </tr>
                ');
            end if;



            IF(vThamtravien!=0)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">'||vvThamtravien||'</td>
            </tr>
            ');
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="7" style="height: 15pt; text-align: left;">Tổng số tờ trình '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br style="mso-data-placement:same-cell;"/>
                    số q </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;

            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td> 
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
             end if;

              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 350pt"></td>
            </tr>
        </table>
      ');      


 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BC_SEARCH;

PROCEDURE QUANLYSOVB_VUANKN
( 
    vToaAnID in number,
    vPhongbanID in number,
    vISDONVI in number,
    vUSERID in varchar2,
    vLoaiSO  in varchar2,
    vSoVB in varchar2,
    vNgayVB in varchar2,
    vNgayVB_den in varchar2,
    vLoaiAn in number,
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
              select a.*
              from (Select ROW_NUMBER() OVER (ORDER BY svb.NGAYVB desc ,svb.SOVB desc) STT, sd.soluongdon,sd.ARR_DON_IDS, COUNT(*) OVER () as CountAll, 
                                       svb.id, sd.ID as SOPHATHANH_VUAN_ID, sd.MAVUAN, svb.MASO,lvb.TEN AS TENSO,svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB,svb.NGUOIKY,
                                       Decode(svb.ISDONVI,1,Decode(NVL(tptt.trangthai,0),0,'Chưa chuyển','Đã chuyển') ) trangthai,
                                       svb.NGAYTAO,svb.NGUOITAO,svb.NGUOISUA,svb.NGAYSUA,
                                       null infordon
                    from SOPHATHANH_vugiamdoc svb
                    left join (select sv.ID, sv.SOPHATHANH_ID, va.MAVUAN, count(*) soluongdon , LISTAGG(TO_CHAR(donID), ',')  WITHIN GROUP (ORDER BY donID desc) as ARR_DON_IDS
                                from SOPHATHANH_VUAN sv
                                join GDTTT_VUAN va on sv.VUANID = va.ID
                                group by sv.ID, sv.SOPHATHANH_ID, va.MAVUAN
                              ) sd on svb.id = sd.SOPHATHANH_ID 
                    left join DM_DATAITEM lvb on lvb.ma = svb.MASO and lvb.HIEULUC=1
                    left join (Select dvb.SOPHATHANH_ID,count(dc.ID) trangthai 
                                From SOPHATHANH_VUAN dvb 
                                left join GDTTT_VUAN_CHITIET_CHUYEN dc on dvb.VUANID = dc.VUANID
                                Where  dc.TRANGTHAI  not in (1, 2)
                                group by dvb.SOPHATHANH_ID
                            ) tptt on svb.id = tptt.SOPHATHANH_ID
                where svb.TOAANID=vToaAnID and svb.PHONGBANID = vPhongbanID and svb.ISDONVI = vISDONVI
                    and (vUSERID is null or svb.THAMPHANID = vUSERID) and svb.MASO  = vLoaiSO
                    and (vSoVB is null or vSoVB = '' or lower(svb.SOVB)=lower(vSoVB)) and svb.TRANGTHAI = 1
                    and svb.NGAYVB between TO_DATE(vNgayVB||' 00:00:00','dd/MM/yyyy HH24:MI:SS') and TO_DATE(vNgayVB_den||' 23:59:59','dd/MM/yyyy HH24:MI:SS')                                      
             ) a         
             where a.stt>=MinIndex and a.stt<=MaxIndex ;
END QUANLYSOVB_VUANKN;

PROCEDURE VAKN_CVCHUYEN_CHECK
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
)
IS 
vY number;
BEGIN

OPEN curReturn FOR  
  Select count(dc.ID) vcheck
  From SOPHATHANH_VUAN dvb
  left join SOPHATHANH_vugiamdoc svb on svb.id = dvb.SOPHATHANH_ID
  left join GDTTT_VUAN_CHITIET_CHUYEN dc on dvb.VUANID = dc.VUANID
  Where dvb.SOPHATHANH_ID=vSOPHATHANH_ID and dc.TRANGTHAI in (1,2) and dvb.TRANGTHAI = 1;
END VAKN_CVCHUYEN_CHECK;

PROCEDURE SUAVANBANVAKN_SEARCH
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
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,
    dvb.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,
    d.NGAYNHANDON,d.LOAIDON,
    NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
    d.NGUOITAO NguoiNhap,
    Decode(d.loaidon,4,'Viện kiểm sát nhân dân tối cao',D.DONGKHIEUNAI) as DONGKHIEUNAI,
    d.NGUOISUA,
    d.NGAYSUA,d.NGAYTAO NgayNhap,
    TL_NGAY,TL_SO,
    svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB,svb.NGUOIKY || '-'||svb.Chucvu  NGUOIKY,
    d.CV_SO,d.NGAYGHITRENDON,
    (Case d.BAQD_LOAIQDBA 
        When 1 then d.KN_SOQD 
        Else d.BAQD_SO 
    END) BAQD_SO,
    (Case d.BAQD_LOAIQDBA 
        When 1 then ('QĐ: ' || d.KN_SOQD) 
        Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(d.ToaAnID,1,'BA/QĐ: ',6,'BA: '))
            ||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) 
    END) BAQD,
    d.CV_TENDONVI,
    (Case d.BAQD_LOAIQDBA 
        When 1 then d.KN_NGAY 
        Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) 
    END) BAQD_NGAYBA,
    (Case d.BAQD_LOAIQDBA 
        When 1 then i.TEN 
        Else txx.Ma_Ten 
    END) TOAXX, 
    DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat,
    NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU,
    d.BAQD_SO_PT,d.BAQD_SO_ST,
    d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH,
    d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,
    d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,
    d.CHIDAO_COKHONG, d.CHIDAO_NOIDUNG,c.HOTEN TENTHAMPHAN,d.CD_SOTOTRINH,
    (case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN,
    (Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB,
    (Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK,
    (Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK,
    (Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK,
    (Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI,
    (Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL,
    (case d.CD_TRANGTHAI 
        when 0 then 'Chưa chuyển' 
        when 1 then  'Đã chuyển' 
        when 2 then  'Đã nhận' 
        when 3 then  'Bị trả lại' 
    else 'Chưa chuyển'
    end ) TRANGTHAICHUYEN,
    (SELECT RTRIM(
        XMLAGG(
            XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ')
            .EXTRACT('//text()') ORDER BY cv.NGAYTAO desc
            ).GetClobVal(),',') 
    FROM GDTTT_DON cv 
    WHERE cv.LOAIDON =3 
        and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( 
        select ID from GDTTT_DON 
        where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) 
        And d.DontrungID>0)))
        ) arrCongvan,
    (Case when d.ISTHULY=2 And d.CD_LOAI=0 then
        (SELECT RTRIM(
            XMLAGG(
            XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') 
            || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' 
            || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ')
            .EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
        FROM GDTTT_DON cv  
        left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID 
        WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( 
            select ID from GDTTT_DON 
            where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
        And cv.ID<d.ID) 
    End) arrTTTL,
    case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
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
              else '' end  KQGQNoiBo,
    lvb.ten TenSOVB,
    svb.MASO MaSOVB
    --,svb.SOVB GXNSO,svb.NGAYVB GXNNGAY, decode (svb.SOVB,null,'none','block') IsGXN
    ,'' GXNSO,'' GXNNGAY,'none' IsGXN
    from SOPHATHANH_VUAN dvb
        left join sophathanh_vugiamdoc svb on svb.id = dvb.SOPHATHANH_ID
        left join DM_DATAITEM lvb on lvb.ma = svb.MASO and ((svb.TOAANID = 1 and lvb.ma = 'QLSO_HCTP_TC') OR lvb.ma = 'QLSO')
        left join GDTTT_VUAN va on dvb.VUANID = va.id
        left join GDTTT_DON d on va.ID = d.VUVIECID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join  DM_TOAAN txx on va.TOAANID=txx.ID
        left join DM_CANBO c on va.THAMPHANID=c.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=va.NGUOITAO
        left join DM_DATAITEM i on va.NGUOIKHANGNGHI=i.ID
        left join GDTTT_VUAN_CHITIET_CHUYEN ctc on va.ID = ctc.VUANID
     where svb.ID = vSOPHATHANH_ID and (ctc.TRANGTHAI is null or ctc.TRANGTHAI not in (1, 2))
        order by va.NGAYTAO desc
     ) a;


END SUAVANBANVAKN_SEARCH;

FUNCTION SOVANBANVAKN_UPDATE
(  
    v_SOPHATHANH_ID in number,
    v_NGAYVB    IN VARCHAR2,
    v_NGUOIKY  IN VARCHAR2,
    v_CHUCVU  IN VARCHAR2,
    V_NGUOISUA IN VARCHAR2
)RETURN NUMBER AS
    vMaSo varchar2(50);
BEGIN
    SAVEPOINT P1;
    --Update--------
    UPDATE SOPHATHANH_vugiamdoc 
                SET 
                NGAYVB = to_date(v_NGAYVB,'dd/MM/yyyy'),
                NGUOIKY  = v_NGUOIKY,
                CHUCVU   = v_CHUCVU,
                NGUOISUA = V_NGUOISUA,
                NGAYSUA  = SYSDATE
                WHERE ID = v_SOPHATHANH_ID;
        RETURN 1;
        
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBANVAKN_UPDATE;

FUNCTION SOVANBANVAKN_DEL_ONE
(   v_ID  in number,
    v_SOPHATHANH_VUGIAMDOC_ID in number
)RETURN NUMBER AS
 vCount number;
BEGIN
    SAVEPOINT P1;
    DELETE SOPHATHANH_VUAN WHERE ID = v_ID and SOPHATHANH_ID = v_SOPHATHANH_VUGIAMDOC_ID;
        
    select count(1) into vCount from SOPHATHANH_VUAN where SOPHATHANH_ID = v_SOPHATHANH_VUGIAMDOC_ID;
    
    if vCount = 0 then 
        DELETE SOPHATHANH_vugiamdoc WHERE ID = v_SOPHATHANH_VUGIAMDOC_ID;
    end if;
    RETURN 1;
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBANVAKN_DEL_ONE;

FUNCTION SOVANBANVAKN_DEL_ALL
(  
    v_SOPHATHANH_ID in number
)RETURN NUMBER AS
 vMaSo varchar2(50);
BEGIN

    SAVEPOINT P1;
    DELETE SOPHATHANH_VUAN WHERE SOPHATHANH_ID = v_SOPHATHANH_ID;
    DELETE SOPHATHANH_vugiamdoc WHERE ID = v_SOPHATHANH_ID;
    RETURN 1;
	--
EXCEPTION
WHEN OTHERS THEN
	--SET SERVEROUTPUT ON
	DBMS_OUTPUT.PUT_LINE ('ERROR ALD: ' || SUBSTR(SQLERRM, 1, 4000));
	ROLLBACK TO SAVEPOINT P1;
	RETURN 0;	
END SOVANBANVAKN_DEL_ALL;

PROCEDURE GDTTTT_QLTOTRINH_VAKN_INPHIEU_CHUYEN
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2,
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  
  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
)
IS 
  TotalItem number;VUANIDS number;vvtt_denngay date;
  MinIndex	number;vvloaian VARCHAR2(150);
  MaxIndex	number;
   --------------------------
  V_CURSOR sys_refcursor;v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(50);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL  DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
BEGIN
v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvtt_denngay from dual;
 -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------

  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                , NVL(v.TongDon,0 ) as TongDon
                --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ----manhnd-----------
                ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                , PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon      ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                , decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                 ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN Decode(v.TOAANID,1,tts.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) 
                                                                ELSE Decode(v.TOAANID,1,tt.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(v.GQD_LOAIKETQUA , 4, decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                        ,818,'CA TANDTC'
                                                                                                        ,819,'CA TANDCC tại Hà Nội'
                                                                                                        ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                        ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                        ,'VKS'))
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
               , DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
                , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV, totrinh.ykien, sph.SOVB as SOCV, sph.NGAYVB as NGAYCV, sph.NGUOIKY, pb.TENPHONGBAN as NOICHUYEN
              from GDTTT_VUAN v 
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              --huynt
              LEFT JOIN (SELECT sp.VUANID, spgd.SOVB, spgd.NGAYVB, spgd.NGUOIKY, spgd.MASO, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 0 --văn bản của vụ giám đốc
                        ) sph ON v.ID = sph.VUANID
              LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
              LEFT JOIN DM_PHONGBAN pb on ctc.PHONGBANNHANID = pb.ID
              
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
                and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
                and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)  
                AND ((NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )
                                        ))
                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                    AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                     )
                                    )
                             OR trim(vNguyendon) || ' '=' ')      
              and ( vBidon is null 
                        or vBidon = '' 
                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')))
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0))
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              AND (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0)
              and ( tt_tungay is null or EXISTS(select ID from GDTTT_TOTRINH TT where v.ID = TT.VUANID AND TT.NGAYTRINH  >=tt_tungay )
                    )                    
                and ( tt_denngay is null OR (    (isTTToTrinh != 0 and EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH <= vvtt_denngay) )
                                               or(isTTToTrinh=0)
                                            )
                  )  
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and ( NOT EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH <vvtt_denngay)
                                             OR EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH >= vvtt_denngay)
                                            )
                    )
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT where v.ID = TT.VUANID )


                       )                               
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,vvtt_denngay)>0
                       )   
                  )
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (NVL(v.THAMTRAVIENID,0) = 0 AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    ) 
                or (vtrangthai = 2 AND (NVL(v.THAMTRAVIENID,0) != 0 OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) )--AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) 
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
          and ( isTTYKienKLTotrinh = 2
                or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                )      
               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0
                    or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                    )
                ------------------------------------
               AND (vIsDangKyBC=2
                            OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )  ) 
                            OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)   ) )
                        ) 
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            
              )
              -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) ))           
                 and ( vKetquathuly = 3
                        OR (v.LOAIAN != 1 and vKetquathuly = 4 and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id))        
                           
                        or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id)) -- có kết quả
                                                    
                        or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn  
                        or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 
                                                    and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS                                                                 
                        or ( v.LOAIAN != 1 and vKetquathuly = 1  and  NVL(v.isvientruongkn,0) = 0
                                                         and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --khang nghị CA
                        or ( v.LOAIAN != 1 and vKetquathuly = -1  and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                         ) --khang nghị CA + VKS                                                         
                        or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --- xếp đơn
                        or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) -- xử lý khác               
                        or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )                                                            
                                                            ) ---VKS đang giải quyết                    
                     ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                        or (v.LOAIAN = 1 and vKetquathuly = 7 and (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0))
                        or (v.LOAIAN = 1 and vKetquathuly = 4  and v.gqd_loaiketqua is null)
                        or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                                AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                        or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                        or (v.LOAIAN = 1 and vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                       or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS        
                        or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                        or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                        or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                        or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết                                
                    )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------
             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
            AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0),
                                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                  or (vLoaiAnDB_TH = 6  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<180
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2 or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha))
              and (vSoVB is null or (sph.SOVB =vSoVB and sph.MASO = vLoaiSoVB)) and (vNgayVB is null or (sph.NGAYVB = vNgayVB and sph.MASO = vLoaiSoVB))
              and (vTrangThaiChuyen is null or ((vTrangThaiChuyen = 0 and ctc.ID is null) or (vTrangThaiChuyen = 1 and ctc.ID is not null)))
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTTT_QLTOTRINH_VAKN_INPHIEU_CHUYEN;

PROCEDURE GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_BTP_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2,
  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,
  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  
  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in number,
  vTrangThaiPC in number,
  
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
)
IS 
  TotalItem number;VUANIDS number;vvtt_denngay date;
  MinIndex	number;vvloaian VARCHAR2(150);
  MaxIndex	number;
   --------------------------
  V_CURSOR sys_refcursor;v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(50);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH  DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL  DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
BEGIN
v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvtt_denngay from dual;
 -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------

  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
   OPEN curReturn FOR
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                , NVL(v.TongDon,0 ) as TongDon
                --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ----manhnd-----------
                ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                , PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon      ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                , decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                 ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN Decode(v.TOAANID,1,tts.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) 
                                                                ELSE Decode(v.TOAANID,1,tt.TenTinhTrang,Replace(tts.TENTINHTRANG,'Vụ Trưởng','Trưởng Phòng')) END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(v.GQD_LOAIKETQUA , 4, decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                        ,818,'CA TANDTC'
                                                                                                        ,819,'CA TANDCC tại Hà Nội'
                                                                                                        ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                        ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                        ,'VKS'))
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
               , DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
                , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV, totrinh.ykien, sph.SOVB, to_char(sph.NGAYVB,'dd/MM/yyyy') AS NGAYVB, sphtb.SOVB SO_TB, to_char(sphtb.NGAYVB,'dd/MM/yyyy') NGAY_TB, sphtb.NGUOIKY_TB, sphtb.CHUCVU_TB
                ,NVL2(ctc.ID, 'Đã chuyển', 'Chưa chuyển') AS trang_thai_chuyen, to_char(ctc.NGAYCHUYEN,'dd/MM/yyyy') as NGAYCHUYEN, ctc.NGUOICHUYEN
                ,DECODE(ctc.TRANGTHAI, 1, 'Chưa nhận', 2, 'Đã nhận', '') AS trang_thai_nhan, to_char(ctc.NGAYNHAN,'dd/MM/yyyy') as NGAYNHAN, ctc.NGUOINHAN
                ,DECODE(ctc.TRANGTHAICHUYENTP, 1, 'Đã chuyển', 'Chưa chuyển') AS trang_thai_chuyen_tp, to_char(ctc.NGAYCHUYENTP,'dd/MM/yyyy') as NGAYCHUYENTP
                ,cb.hoten AS thamphan_ten, cb.ID as THAMPHANID, sphCV.SOVB SoCV, to_char(sphCV.NGAYVB,'dd/MM/yyyy') NgayCV, pb.TENPHONGBAN as NOICHUYEN
              from GDTTT_VUAN v 
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID

              LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 --văn bản của hành chính tư pháp
                         WHERE spgd.MASO = 'SoTT'
                        ) sph ON v.ID = sph.VUANID
              LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI, spgd.NGUOIKY NGUOIKY_TB, spgd.CHUCVU CHUCVU_TB
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 --văn bản của hành chính tư pháp
                         WHERE spgd.MASO = 'TBTP'
                        ) sphtb ON v.ID = sphtb.VUANID
              LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 0 --văn bản của vụ giám đốc
                         WHERE spgd.MASO = 'SoCV'
                        ) sphCV ON v.ID = sphCV.VUANID
              JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
              LEFT JOIN DM_CANBO cb ON cb.id = ctc.THAMPHANID
              LEFT JOIN DM_PHONGBAN pb on ctc.PHONGBANNHANID = pb.ID
              
              where v.TOAANID=vToaAnID --and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
                and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
                and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)  
                AND ((NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                  )
                                        ))
                             OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                    AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                            OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                     )
                                    )
                             OR trim(vNguyendon) || ' '=' ')      
              and ( vBidon is null 
                        or vBidon = '' 
                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                        OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                        and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')))
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0))
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              AND (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0)
              and ( tt_tungay is null or EXISTS(select ID from GDTTT_TOTRINH TT where v.ID = TT.VUANID AND TT.NGAYTRINH  >=tt_tungay )
                    )                    
                and ( tt_denngay is null OR (    (isTTToTrinh != 0 and EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH <= vvtt_denngay) )
                                               or(isTTToTrinh=0)
                                            )
                  )  
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and ( NOT EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH <vvtt_denngay)
                                             OR EXISTS(select ID from GDTTT_TOTRINH TT  where v.ID = TT.VUANID  AND TT.NGAYTRINH >= vvtt_denngay)
                                            )
                    )
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT where v.ID = TT.VUANID )


                       )                               
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,vvtt_denngay)>0
                       )   
                  )
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (NVL(v.THAMTRAVIENID,0) = 0 AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    ) 
                or (vtrangthai = 2 AND (NVL(v.THAMTRAVIENID,0) != 0 OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) )--AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) 
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
          and ( isTTYKienKLTotrinh = 2
                or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                )      
               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0
                    or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                    )
                ------------------------------------
               AND (vIsDangKyBC=2
                            OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )  ) 
                            OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)   ) )
                        ) 
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            
              )
              -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) ))           
                 and ( vKetquathuly = 3
                        OR (v.LOAIAN != 1 and vKetquathuly = 4 and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id))        
                           
                        or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id)) -- có kết quả
                                                    
                        or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn  
                        or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 
                                                    and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS                                                                 
                        or ( v.LOAIAN != 1 and vKetquathuly = 1  and  NVL(v.isvientruongkn,0) = 0
                                                         and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --khang nghị CA
                        or ( v.LOAIAN != 1 and vKetquathuly = -1  and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                         ) --khang nghị CA + VKS                                                         
                        or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --- xếp đơn
                        or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) -- xử lý khác               
                        or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )                                                            
                                                            ) ---VKS đang giải quyết                    
                     ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                        or (v.LOAIAN = 1 and vKetquathuly = 7 and (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0))
                        or (v.LOAIAN = 1 and vKetquathuly = 4  and v.gqd_loaiketqua is null)
                        or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                                AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                        or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                        or (v.LOAIAN = 1 and vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                       or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS        
                        or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                        or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                        or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                        or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết                                
                    )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------
             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
            AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0),
                                                            DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                            v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                  or (vLoaiAnDB_TH = 6  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<180
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2 or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha))
              and (vSoVB is null or (vLoaiSoVB = 'SoCV' and sphCV.MASO = vLoaiSoVB and sphCV.SOVB =vSoVB) or ((sph.SOVB =vSoVB and sph.MASO = vLoaiSoVB) OR (sphtb.SOVB =vSoVB and sphtb.MASO = vLoaiSoVB)))
              and (vNgayVB is null or (vLoaiSoVB = 'SoCV' and sphCV.MASO = vLoaiSoVB and sphCV.NGAYVB =vNgayVB) or ((sph.NGAYVB = vNgayVB and sph.MASO = vLoaiSoVB) OR (sphtb.NGAYVB = vNgayVB and sphtb.MASO = vLoaiSoVB)))
              and (NVL(vTrangThaiChuyen,0) = 0 or (NVL(vTrangThaiChuyen,0)=1 and ctc.TRANGTHAI = vTrangThaiChuyen) --HCTP chưa nhận vụ án
                    or (NVL(vTrangThaiChuyen,0)=2 and ctc.TRANGTHAI = vTrangThaiChuyen) --HCTP đã nhận vụ án
                    or (NVL(vTrangThaiChuyen,0)=3 and ctc.TRANGTHAICHUYENTP = 0) --chưa chuyển thẩm phán
                    or (NVL(vTrangThaiChuyen,0)=4 and ctc.TRANGTHAICHUYENTP = 1)) --đã chuyển thẩm phán
              and (NVL(vTrangThaiPC,0)=0 
                    or (NVL(vTrangThaiPC,0)=1 and NVL(ctc.THAMPHANID,0)=0) --chưa phân công thẩm phán
                    or (NVL(vTrangThaiPC,0)=2 and NVL(ctc.THAMPHANID,0)>0)) --đã phân công thẩm phán
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTTT_QLTOTRINH_VUAN_KHANG_NGHI_BTP_SEARCH;

FUNCTION GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BTP_PRINT
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,

  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,

  tt_tungay in date,
  tt_denngay in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,

  vKetquathuly in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,

  vLoaiSoVB in varchar2,
  vSoVB in varchar2,
  vNgayVB in date,
  vTrangThaiChuyen in varchar2,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvisTTYKienKLTotrinh varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;
   v_ghichu varchar2(2000);vCOUNT_NGAYTT NUMBER;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
   -----
   SELECT DECODE(tt_denngay,null,sysdate,to_date(to_char(tt_denngay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
   -------------------------
  SELECT DECODE(tt_denngay,null,sysdate,tt_denngay) into vtt_denngay from dual;
 v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
  if(vThamphan !=0 and vThamphan is not null) then
          select b.Ma  into ma_chucvu  from DM_CanBo a left join DM_DataItem b on a.ChucVuID = b.ID where a.Id = vThamphan;
           if  (ma_chucvu='PCA' OR ma_chucvu='CA')then 
               curr_thamphan_id:=0;
                ---------lấy loại án khi thẩm phán chọn ô tổng (nghĩa là không xác định được loại án) của form login sẽ lấy những loại án theo năm truyền vào
                       SELECT  LISTAGG(TTS.LOAIAN_ID, ',') WITHIN GROUP (ORDER BY TTS.LOAIAN_ID) INTO vvloaian  FROM (
                                    SELECT LA.LOAIAN_ID,LA.LOAIAN_TEN FROM  (
                                    SELECT DECODE(TT.COL_LOAIAN,'ISHINHSU',1,'ISDANSU',2,'ISHNGD',3,'ISKDTM',4,'ISLAODONG',5,'ISHANHCHINH',6)LOAIAN_ID,
                                    DECODE(TT.COL_LOAIAN,'ISHINHSU','HÌNH SỰ','ISDANSU','DÂN SỰ','ISHNGD','HÔN NHÂN VÀ GIA ĐÌNH','ISKDTM','KINH DOANH, THƯƠNG MẠI','ISLAODONG','LAO ĐỘNG','ISHANHCHINH','HÀNH CHÍNH')LOAIAN_TEN
                                    FROM (
                                            SELECT * FROM (SELECT PB.ISHINHSU,PB.ISDANSU, PB.ISHNGD,PB.ISKDTM,PB.ISHANHCHINH,PB.ISLAODONG FROM DM_CanBo 
                                            PB WHERE PB.Id = vThamphan
                                         )
                                    UNPIVOT --chuyển từ cột thành dòng
                                    (CHECK_LOAIAN for COL_LOAIAN in (ISHINHSU, ISDANSU, ISHNGD, ISKDTM,ISHANHCHINH,ISLAODONG) )
                                    )TT WHERE CHECK_LOAIAN=1 
                                )LA   WHERE LA.LOAIAN_ID IS NOT NULL  
                               GROUP BY LA.LOAIAN_ID,LA.LOAIAN_TEN 
                 )TTS;
                       -----------------------------------------------
            ELSE
                curr_thamphan_id:= vThamphan;
            end if;
      else
      curr_thamphan_id:=0;
  end if;
         -----Bao cao TTP,HDTP,CA,PCA---------------
         IF(vTrangthai=-1)THEN
            vTrangthai_s:='7,8,9,17';
         ELSE
         vTrangthai_s:=vTrangthai;
         END IF;
  -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,tt_denngay,--tt_tungay,tt_denngay
                                              V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                        INTO   LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_tp.extend;
                         v_table_tp(v_table_tp.count) := R_TINHTRANG(
                                     LOAIAN_ID,LOAIAN_TEN,VUANID,LANHDAOID,TINHTRANGID,NGAYTRA,TOTRINH_ID,NGAYTRINH,ISCAPTRINHTIEP,THUTU_CAPTRINH
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
         END IF;
       ----------------------------------------tạo du lieu cac cap trinh chuyển vào bảng 
                  PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_ALL(
                                  vToaAnID,vPhongBanID,vLoaiAn,--vToaAnID,vPhongBanID,vLoaiAn
                                  null,tt_denngay,--tt_tungay,tt_denngayto_date
                                  V_CURSOR);
                  LOOP 
                  FETCH V_CURSOR 
                       INTO   LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL;
                        EXIT WHEN V_CURSOR%NOTFOUND;
                         v_table_all.extend;
                         v_table_all(v_table_all.count) := R_TINHTRANG(
                                     LOAIAN_ID_ALL,LOAIAN_TEN_ALL,VUANID_ALL,LANHDAOID_ALL,TINHTRANGID_ALL,NGAYTRA_ALL,TOTRINH_ID_ALL,NGAYTRINH_ALL,ISCAPTRINHTIEP_ALL,THUTU_CAPTRINH_ALL
                                    );
                  END LOOP;    
                  CLOSE V_CURSOR;  
        -----------------------------------------------------------------------------

  FOR item IN (
      select a.*
			from (
            Select  Count(v.ID) OVER () as CountAll ,ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                , NVL(v.TongDon,0 ) as TongDon
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                      , case when v.BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when v.BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when v.BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,'TTV: ' || ttv.HOTEN || '<br/>PVT: '||ld.HOTEN ||'<br/>TP: '|| tp.HOTEN  as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                 ---------
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))) KQ_GQD
                ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS              
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, ' (CA)', 1, 'VKS')
                  end LoaiKN  
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                ------------------------
                , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 , NVL(v.LoaiAn, 0) LoaiAn
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
              ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS         
              from GDTTT_VUAN v
              inner join GDTTT_DON gd on v.id = gd.vuviecid and gd.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
              inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                            from GDTTT_TOTRINH totr 
                            join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                            join DM_CANBO cb on totr.LANHDAOID = cb.ID
                            join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                            where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                          ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
                      LEFT JOIN (SELECT  KN.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BICAO
                                FROM GDTTT_VUAN_DS_KN KN
                                LEFT JOIN GDTTT_VUAN_DUONGSU DS ON DS.ID=KN.BICAOID
                                LEFT JOIN GDTTT_VUAN_DUONGSU DSS ON DSS.ID=KN.NGUOIKHIEUNAIID
                                GROUP BY KN.VUANID
                            )HSKN ON HSKN.VUANID=V.ID
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  NGUYENDON_ND
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='NGUYENDON' 
                                GROUP BY DS.VUANID
                        )ND ON ND.VUANID=V.ID     
                     LEFT JOIN (SELECT  DS.VUANID,LISTAGG(DS.TENDUONGSU, '<br/>') WITHIN GROUP (ORDER BY DS.TENDUONGSU  DESC)  BIDON_BD
                                FROM GDTTT_VUAN_DUONGSU DS
                                WHERE DS.TUCACHTOTUNG='BIDON' 
                                GROUP BY DS.VUANID
                        )BD ON BD.VUANID=V.ID     
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID 
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              --thông tin số cv, chuyển vụ án
              LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 --văn bản của hành chính tư pháp
                         WHERE spgd.MASO = 'SoTT'
                        ) sph ON v.ID = sph.VUANID
              LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 --văn bản của hành chính tư pháp
                         WHERE spgd.MASO = 'TBTP'
                        ) sphtb ON v.ID = sphtb.VUANID
              LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI 
                         FROM SOPHATHANH_VUAN sp
                         JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 0 --văn bản của vụ giám đốc
                         WHERE spgd.MASO = 'SoCV'
                        ) sphCV ON v.ID = sphCV.VUANID
              JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
              ----
              where v.TOAANID=vToaAnID --and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))
                and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                  -----------------------
              and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%'   or UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
              and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
               ----------------------
               AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                          )

                                ))

                     OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                            AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                             )
                            )
                     OR trim(vNguyendon) || ' '=' '

                  )            
              ----------------------
              and ( vBidon is null 
                    or vBidon = '' 
                    or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                    OR exists(select 'X' from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                          )
                        )
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              and ( isTTToTrinh = 2 
                    or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                    or (isTTToTrinh = 1 and EXISTS(select ID from GDTTT_TOTRINH TT
                                                     where v.ID = TT.VUANID 
                                                     AND ((TT.NGAYTRINH  >=tt_tungay AND tt_tungay IS NOT NULL) OR (tt_tungay IS NULL )) 
                                                     AND ((TT.NGAYTRINH <= tt_denngay AND tt_denngay IS NOT NULL) OR(tt_denngay IS NULL))
                                                   )
                       )                               
                    or (isTTToTrinh = -1 and PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,tt_tungay,tt_denngay)>0
                       )   
                  )    
--                /*
--                  Trang thai =1/2 -->chua/da pc TTV + chua co KQ giai quyet
--                  Trang thai =3 --> co ho so + chua co to trinh + chua co KQ GQ don
--                */
--            -- Trạng thái thụ lý 
              and ( (vtrangthai = 0 )
                or (vtrangthai = 1 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL) 
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    )--anhvh   
                or (vtrangthai = 2 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                   AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                    ) --anhvh 
                or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )                
                or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  ) )  --Trình dự thảo trả lời đơn
                or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ))--Trình dự thảo kháng nghị
                or (vtrangthai = 13 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 0) or v.gqd_loaiketqua = 0)) --Trả lời đơn
                or (vtrangthai = 14 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 1) or v.gqd_loaiketqua = 1)) --Kháng nghị
                or (vtrangthai = 15 and v.NGAYTHULYXXGDT IS NOT NULL)-- Thụ lý xét xử GDTTT
                or (vtrangthai = 16 and (EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 3) or v.gqd_loaiketqua = 2))  -- xếp đơn
                or (vtrangthai = -1 and EXISTS(select 'x' from GDTTT_TOTRINH TR  where  TR.VUANID=v.ID and (instr(','||vTrangthai_s||',',','||TR.TINHTRANGID||',')>0 OR instr(','||vTrangthai_s||',',','||TR.CAPTRINHTIEP||',')>0) ) --7 Trình Phó Chánh án giá trị đầu tiên của bộ '7,8,9,17'
                                    and NVL(v.TrangthaiID,0) not in (13,14,15,16,18) )
             )
             -- ý kiến tờ trình
          and ( isTTYKienKLTotrinh = 2
                or (isTTYKienKLTotrinh = 0 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL  and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) --chưa có ý kiến
                or (isTTYKienKLTotrinh = 1  and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) ) -- dã có ý kiến             
                or (isTTYKienKLTotrinh = 3 and NOT EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) ) and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and TINHTRANGID = vtrangthai and NVL(CAPTRINHTIEP, 0) IN (4, 5, 6, 7, 8, 9, 17)))-- dã có ý ki?n và yêu c?u trình ti?p
                or (isTTYKienKLTotrinh = 10 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 0)) -- dã có ý kiến TLD 
                or (isTTYKienKLTotrinh = 11 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) and loaiykien = 1)) -- dã có ý kiến KN
                or (isTTYKienKLTotrinh = 12 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 3)) -- dã có ý kiến Xep don
                or (isTTYKienKLTotrinh = 13 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NGAYTRA IS NOT NULL and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0)  and loaiykien = 10)) -- dã có ý kiến XM,BS 
                )      
               --Cấp trình tiếp   
               AND (vCapTrinhTiep = 0
                    or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                    )
                ------------------------------------
                AND (vIsDangKyBC=2
                    OR(vIsDangKyBC=1 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NOT NULL  and TINHTRANGID = vtrangthai) )
                    OR(vIsDangKyBC=0 AND EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and NgayDK IS NULL  and TINHTRANGID = vtrangthai) )
                )
           -- Bước giải quyết
         and ( (isBuocTT = 0)
               OR (isBuocTT = 1 AND (    ( vPhongBanID!=0 
                                            AND  EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  
                                                        WHERE PA.VUANID=V.ID AND ((instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) )
                                                                             AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) ) 
                                                        ) 
                                         )
                                      OR ( vPhongBanID=0 --tương đương trường hợp thẩm phán =0 là chánh án và phó chánh án
                                           AND  EXISTS(SELECT 'X' FROM TABLE(v_table_tp) PA 
                                                      WHERE PA.VUANID=V.ID AND ( (instr(','||vTrangthai_s||',',','||PA.TINHTRANGID||',')>0 AND instr(','||vTrangthai_s||',',',0,')=0) OR (instr(','||vTrangthai_s||',',',0,')>0) ) 
                                                                           AND ((PA.NGAYTRA IS NOT NULL AND isTTYKienKLTotrinh>=1 AND isTTYKienKLTotrinh!=2) OR (isTTYKienKLTotrinh=2) OR (isTTYKienKLTotrinh=0 AND PA.NGAYTRA IS NULL) )  
                                                      )                                                                 
                                          )  
                                     ) 
                   )                                                              
                OR (isBuocTT = 2  AND ( (vPhongBanID!=0
                                            AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                      WHERE V.ID=TT.VUANID AND (   (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)  --instr(','||vTrangthai_s||',',',0,')=0 tương đương vTrangthai_s!=0 nếu vTrangthai_s là number
                                                                                OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) ) AND instr(','||vTrangthai_s||',',',0,')=0)    
                                                                                )   
                                                       )                                                          
                                         )
                                        OR (vPhongBanID=0 
                                        AND EXISTS(SELECT 'X' FROM GDTTT_TOTRINH TT
                                                   WHERE V.ID=TT.VUANID AND (  (TT.ID>(SELECT MIN(TTS.ID) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 ) 
                                                                                       AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0) ) 
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0 
                                                                                 )  
                                                                             OR (TT.NGAYTRINH>(SELECT MIN(TTS.NGAYTRINH) FROM GDTTT_TOTRINH TTS  WHERE V.ID=TTS.VUANID AND (instr(','||vTrangthai_s||',',','||TTS.TINHTRANGID||',')>0 )
                                                                                               AND ((TTS.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)   )
                                                                                  AND instr(','||vTrangthai_s||',',',0,')=0
                                                                                )    
                                                                            )
                                                                        AND ((TT.LANHDAOID=curr_thamphan_id and curr_thamphan_id!=0) OR curr_thamphan_id=0)
                                                  )
                                           )
                                      )    
                   )                                                                                                            

              )
               -------liên quan đến tham số ngày---------------------
                and ( tt_tungay is null or(v.NGAYTAO>=tt_tungay) 
                  )                    
                and ( tt_denngay is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                               or(vKetquathuly =4)
                                            )   
                  )  
               
                -- Đã có hồ sơ
              and ( isTTMuonHS = 2
                    or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                    or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) ))
  ------------------------------------------             
                 and ( vKetquathuly = 3
                        OR (v.LOAIAN != 1 and vKetquathuly = 4 and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id))        
                           
                        or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                where TRANGTHAI != 0 and vuanid = v.id)) -- có kết quả
                                                    
                        or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn  
                        or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 
                                                    and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS                                                                 
                        or ( v.LOAIAN != 1 and vKetquathuly = 1  and  NVL(v.isvientruongkn,0) = 0
                                                         and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --khang nghị CA
                        or ( v.LOAIAN != 1 and vKetquathuly = -1  and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                         ) --khang nghị CA + VKS
                                                         
                        or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) --- xếp đơn
                        or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            ) -- xử lý khác               
                        or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        ) 
                                                            
                                                            ) ---VKS đang giải quyết                        
                        
                     ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                        or (v.LOAIAN = 1 and vKetquathuly = 7 and (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0))
                        or (v.LOAIAN = 1 and vKetquathuly = 4  and v.gqd_loaiketqua is null)
                        or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                                AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                        or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                        or (v.LOAIAN = 1 and vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                       or (v.LOAIAN = 1 and vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS        
                        or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)) --khang nghị CA
                        or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                        or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua= 3) --- Giải quyết khác
                        or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết                                
                    )    
                          -------------Ket thuc ap dung cho an Hinh su------------------------------------------------   
                          
             -- Thuộc án
                and ( LoaiAnDB = 0
                        or (LoaiAnDB = 1 
                              --án quốc hội gồm công văn 8.1 và 9.3
                                AND EXISTS(select 'X' from GDTTT_DON d 
                                                    where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                    AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                    GROUP BY d.VuViecID) 

                        )
                        or (LoaiAnDB = 2 and NVL(v.IsAnChiDao,0)=1)
                        or (LoaiAnDB = 4 and NVL(v.ISANTRAODOICV,0)=1)
                 )
            --Án thời hiệu
             AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<=0)
                  or (vLoaiAnDB_TH = 1  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<30 
                    )
                  or (vLoaiAnDB_TH = 2  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<60
                    )
                  or (vLoaiAnDB_TH = 3  AND  v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), v.NGAYXUPHUCTHAM, v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                    )
                ) 
              ------------------Hoãn THA
              and ( ishoantha = 2 or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha))
              and (vSoVB is null or (vLoaiSoVB = 'SoCV' and sphCV.MASO = vLoaiSoVB and sphCV.SOVB =vSoVB) or ((sph.SOVB =vSoVB and sph.MASO = vLoaiSoVB) OR (sphtb.SOVB =vSoVB and sphtb.MASO = vLoaiSoVB)))
              and (vNgayVB is null or (vLoaiSoVB = 'SoCV' and sphCV.MASO = vLoaiSoVB and sphCV.NGAYVB =vNgayVB) or ((sph.NGAYVB = vNgayVB and sph.MASO = vLoaiSoVB) OR (sphtb.NGAYVB = vNgayVB and sphtb.MASO = vLoaiSoVB)))
              and (vTrangThaiChuyen is null or ctc.TRANGTHAI = vTrangThaiChuyen) 
            )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULYDON||'<br/>'||item.NGAYTHULYDON||'</td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br/>'||item.BIDON;
                ELSE
                 V_BIDON_CHECK:=replace(item.NGUYENDON||item.BIDON,',','');
                END IF;
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
            if(vKetquathuly=4)then 
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
             ');
             elsif(vKetquathuly=5)then 
                DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
             ');
             ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
             ');
             end if;
             IF(ITEM.TRANGTHAIID!=2 AND ITEM.GiaiDoanTrinh=2)THEN--ITEM.TRANGTHAIID=2 phân công thẩm tra viên
                SELECT COUNT(*) INTO vCOUNT_NGAYTT FROM TABLE(v_table_all) TI  WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID);
                IF(vCOUNT_NGAYTT>0)THEN
                       SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                          select TI.NGAYTRINH FROM TABLE(v_table_all) TI  WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                        )TTI WHERE rownum=1;
                  ELSE
                       SELECT TO_CHAR(TTI.NGAYTRINH,'dd/MM/yyyy') INTO vNgayTrinh FROM (
                       SELECT TI.NGAYTRINH  FROM GDTTT_TOTRINH TI WHERE TI.VUANID=ITEM.ID AND (TI.TINHTRANGID=ITEM.TRANGTHAIID OR TI.CAPTRINHTIEP=ITEM.TRANGTHAIID) ORDER BY TI.NGAYTRINH desc
                      )TTI WHERE rownum=1;
                  END IF;
             ELSE
                 IF(ITEM.TRANGTHAIID=2 )THEN
                    vNgayTrinh:=ITEM.NGAYPHANCONGTTV|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV;
                 ELSIF(ITEM.TRANGTHAIID!=15 )THEN --THULY_XETXU_GDT
                    IF(ITEM.KQ_GQD_ID<= 2)THEN
                      IF(ITEM.LOAIAN=01)THEN
                       if( ITEM.KQ_GQD_ID!=0) THEN
                       vNgayTrinh:=ITEM.AHS_ThongTinGQD;
                       ELSE
                         vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                       END IF;  
                     ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                     END IF;
                    ELSE
                      vNgayTrinh:=ITEM.GDQ_NGAY|| '<br/> Ngày phát hành '|| ITEM.GQD_NgayPhatHanhCV; 
                    END IF;
                 ELSE
                      vNgayTrinh:=ITEM.NGAYTHULYXXGDT; 
                 END IF;   
             END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||item.TenTinhTrang||'<b>'||item.LoaiKN||'</b><br style="mso-data-placement:same-cell;"/> Ngày '||vNgayTrinh||'</td>
            </tr>
        ');
  END LOOP;
    -------TẠO BÁO CÁO
      IF(vThamtravien!=0)THEN
        SELECT II.TEN||': '||CB.HOTEN INTO vvThamtravien FROM DM_CANBO CB 
        INNER JOIN (select i.ID, i.TEN from DM_DATAITEM i where i.GROUPID=12)II ON II.ID=CB.CHUCDANHID
        WHERE CB.ID=vThamtravien;
     END IF;
    SELECT DECODE(isTTYKienKLTotrinh,0,'chưa duyệt',1,'đã duyệt',null) into vvisTTYKienKLTotrinh from dual;
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    -----------
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
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="13" style="height: 0pt;"></td>
            </tr>
            <tr>
                <td colspan="13" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>TỔNG HỢP DANH SÁCH VỤ ÁN '||upper(vvisTTYKienKLTotrinh)||'</b>
                    <br style="mso-data-placement:same-cell;"/>
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(tt_tungay,'dd/MM/yyyy')||'  đến ngày '||to_char(tt_denngay,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            ');
            IF(vThamtravien!=0)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
              <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">'||vvThamtravien||'</td>
            </tr>
            ');
            END IF;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số vụ án '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <!--td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số - Ngày 
                    <br style="mso-data-placement:same-cell;"/>
                    thụ lý </td-->
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số án
                    <br style="mso-data-placement:same-cell;"/>
                    ngày xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
            if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị cáo</td>             
            ');   
            ELSE
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn/ Người khởi kiện</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn/ Người bị kiện</td>
               ');   
            END IF;
--             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
--                ');  
             if(vKetquathuly=4)then 
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 ');  
             elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
                 '); 
             ELSE
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 ');  
                 end if;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
            ');  
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <!--td style="width: 80pt"></td-->
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 120pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
             end if;
--            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
--                <td style="width: 120pt"></td>
--                 ');
              if(vKetquathuly=4)then    
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                 ');
               elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                 ');
               ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 60pt"></td>
                <td style="width: 60pt"></td>
                 ');
               end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                <td style="width: 80pt"></td>
            </tr>
        </table>
      ');

 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_QLTOTRINH_VUAN_KHANGNGHI_BTP_PRINT;

PROCEDURE GDTTTT_QLTOTRINH_VAKN_BTP_TTRINH_PHANCONG
( 
  V_BC_NGAYDK VARCHAR2,
  V_BC_Nguoiky VARCHAR2,
  V_BC_SoCV VARCHAR2,
  v_ID_USER VARCHAR2,
  ----------------
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
  VLOAISOVB in varchar2,
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
  vPhongBanID in number,
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
)
IS 
  V_TENPHONGBANGUI varchar2(250);V_TENDONVI varchar2(250);V_COUNT NUMBER;V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number; V_TABLE T_DON_SEARCH;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(250);V_CD_NGUOIKY varchar2(250);V_NGUOIKY_CHUCVU  varchar2(250);
  V_CD_NGAYCV date;V_LOAIDON8_1 clob;V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTOTRINH varchar2(250);V_CD_NGAYTOTRINH DATE;V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_DON_SEARCH();
 -------
 IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
       IF(V_ID=1023 or V_CAPCHAID=1023) then
         V_LOAIDON8_1 := ' (do Đại biểu quốc hội, Các Cơ quan của Quốc hội, Đoàn đại biểu Quốc hội chuyển đến)';
       end if;
 END IF;
 --------
  FOR item IN (
          Select (case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                  when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                  when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                  when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
             ,D.ID,D.BAQD_LOAIAN,LA.LOAI_AN_TEN,D.NGAYTAO              
              ,SOTTXX.SOVB||SOTT_TLL.SOVB||SOTT.SOVB as CD_SOTOTRINH
              ,SOTTXX.NGAYVB||SOTT_TLL.NGAYVB||SOTT.NGAYVB as CD_NGAYTOTRINH
             ,SOTTXX.NGUOIKY||SOTT_TLL.NGUOIKY||SOTT.NGUOIKY as CD_NGUOIKY
              ,SOTTXX.CHUCVU||SOTT_TLL.CHUCVU||SOTT.CHUCVU as CD_NGUOIKY_CHUCVU
           ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
             WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
              and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                      and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                      and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                      and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                        and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
             ) arrDonID
            from GDTTT_DON d
            inner join GDTTT_VUAN v on v.id = d.vuviecid and d.ISTPB3= 1 --lấy đơn thuộc thẩm quyền thẩm phấn B3
            inner join (select totr.LOAIYKIEN, totr.vuanid, totr.ykien, ROW_NUMBER() OVER (PARTITION BY VUANID ORDER BY totr.NGAYTRINH DESC NULLS LAST, totr.ID DESC NULLS LAST) rn 
                        from GDTTT_TOTRINH totr 
                        join GDTTT_DM_TINHTRANG titr on totr.TINHTRANGID = titr.id and titr.MA = '06' --trình thẩm phán
                        join DM_CANBO cb on totr.LANHDAOID = cb.ID
                        join DM_DATAITEM item on cb.CHUCDANHID = item.ID and item.MA= 'TPBAC3'
                        where totr.LOAIYKIEN = 1 --LOAIYKIEN=1 là kháng nghị
                       ) totrinh on totrinh.vuanid = v.id and totrinh.rn = 1
            JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
              
            LEFT JOIN (SELECT sp.VUANID, spgd.MASO, spgd.SOVB, spgd.NGAYVB, spgd.ISDONVI, spgd.NGUOIKY, spgd.CHUCVU 
                        FROM SOPHATHANH_VUAN sp
                        JOIN SOPHATHANH_VUGIAMDOC spgd ON sp.SOPHATHANH_ID = spgd.ID AND spgd.ISDONVI = 1 --văn bản của hành chính tư pháp
                        WHERE spgd.MASO = 'SoTT' and spgd.TOAANID = vToaAnID and spgd.PHONGBANID = vPhongBanID
                       ) SOTT ON v.ID = SOTT.VUANID
            LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SOTTXX on SOTTXX.donid = d.id             
            LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SOTT_TLL on SOTT_TLL.donid = d.id
                            
            left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
            -----
            LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on d.BAQD_TOAANID=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
              
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or  d.BAQD_TOAANID_PT=vToaRaBAQD
                                                         Or  d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end

                AND (vLoaiAn=0 OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0) OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL))
                and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                        (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                        Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                        Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end 
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
                and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
                and 1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end    
                AND (VSOCONGVAN IS NULL 
                         OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where b.SOTHONGBAO =VSOCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND so.SOVB =VSOCONGVAN  AND sd.donid =  D.id)
                            )
                   )
                 AND (VNGAYCONGVAN IS NULL 
                       OR (VLOAISOVB='YCBS' AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b 
                                                            where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') =VNGAYCONGVAN  AND b.DONID =  D.id) 
                            )
                          OR(VLOAISOVB !='YCBS' AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID 
                                    where so.maso =  VLOAISOVB AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') =VNGAYCONGVAN  AND sd.donid =  D.id)
                            )
                   )
               and
                1=case when vCVPC_So || ' '=' ' then 1 when lower(d.CV_SO) like '%' || lower(vCVPC_So) || '%' then 1 else 0 end
                and
                1=case when vCVPC_Ngay || ' '=' ' then 1 when to_char(d.CV_NGAY,'dd/MM/yyyy')=vCVPC_Ngay then 1 else 0 end
                 and

                1=case when vCVPC_TenCQ || ' '=' ' then 1 when lower(d.CV_TENDONVI) like '%' || lower(vCVPC_TenCQ) || '%' then 1 else 0 end
                and 1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
                and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end

                AND (vNoiChuyen=-1
                     OR(d.CD_LOAI=vNoiChuyen AND vNoiChuyen!=-1 AND vNoiChuyen!=-2)
                     OR(d.CD_LOAI IN(1,2) AND vNoiChuyen=-2)
                     )
                and  1=case when vTrangthai=-1 then 1 when vTrangthai=1 and   d.CD_TRANGTHAI in (1,2) then 1 when d.CD_TRANGTHAI=vTrangthai then 1 else 0 end
                and  (1=case when (vNoiChuyen=-1 OR vNoiChuyen=-2) then 1 
                    when (vNoiChuyen=0 and (vCD_DONVIID=0 Or (vCD_DONVIID>0 And d.CD_TA_DONVIID=vCD_DONVIID)) and (vCD_TA_TRANGTHAI=-1 Or (vCD_TA_TRANGTHAI>=0 and CD_TA_TRANGTHAI=vCD_TA_TRANGTHAI))) then 1
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
                and 1=case when vChidao=-1 then 1 when  vChidao=0 and NVL(d.CHIDAO_COKHONG,0)>0 then 1 when vChidao>0 and d.CHIDAO_LANHDAOID=vChidao then 1 else 0 end
                and 1=case when vTraigiam=-1 then 1 when NVL(d.CV_ISTRAIGIAM,0)=vTraigiam then 1 else 0 end
                and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
                and 1=case when vTBQuahan=0 then 1 when d.TB1_NGAY<( vNgayQuahan - 30 ) then 1 else 0 end
                and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
                and ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
                    Or (1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
                and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                    when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                    when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                    when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                and 1=case when vLoaiCVID=0 then 1 
                    when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                    when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                and 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                    when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
        )
        LOOP
           V_CD_SOTOTRINH:=ITEM.CD_SOTOTRINH;
           V_CD_NGAYTOTRINH:=ITEM.CD_NGAYTOTRINH;
           V_CD_NGUOIKY_TEMP:=ITEM.CD_NGUOIKY;
             ---------    
                v_table.extend;
                v_table(v_table.count) := R_DON_SEARCH(
                ITEM.ID,ITEM.NOICHUYEN,ITEM.BAQD_LOAIAN,ITEM.LOAI_AN_TEN,null, null,
                V_CD_NGUOIKY_TEMP,ITEM.CD_NGUOIKY_CHUCVU,ITEM.NGAYTAO
                ,V_CD_SOTOTRINH,V_CD_NGAYTOTRINH);
        END LOOP;

     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:='Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy')||' ';
      elsif(vNgayNhapTu is null)then  
             vvNgayNhapTu:=null;
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy')||' ';
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:=null;   
      end if;
     ----------
    SELECT count(*)into V_COUNT FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     if(V_COUNT>0)then   
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     end if;
     ----------
     SELECT LISTAGG(TT.NOICHUYEN,',') WITHIN GROUP (ORDER BY TT.NOICHUYEN DESC) INTO V_NOICHUYEN
     FROM (
         SELECT PA.NOICHUYEN  FROM TABLE(V_TABLE)PA
         GROUP BY PA.NOICHUYEN
         )TT;
     -------------
     SELECT LISTAGG(TT.BAQD_LOAIAN_NAME,', ') WITHIN GROUP (ORDER BY TT.BAQD_LOAIAN) INTO V_BAQD_LOAIAN_NAME
     FROM (
         SELECT PA.BAQD_LOAIAN,PA.BAQD_LOAIAN_NAME
         FROM TABLE(V_TABLE)PA WHERE PA.BAQD_LOAIAN IS NOT NULL
         GROUP BY PA.BAQD_LOAIAN,PA.BAQD_LOAIAN_NAME
     )TT;
     -------------
     select count(*) into V_COUNT FROM TABLE(V_TABLE)PA  WHERE PA.CD_SOTOTRINH IS NOT NULL;
     if(V_COUNT>0)then
         SELECT PA.CD_SOTOTRINH,PA.CD_NGAYTOTRINH,PA.CD_NGUOIKY,PA.CD_NGUOIKY_CHUCVU 
         INTO V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_NGUOIKY_CHUCVU  FROM TABLE(V_TABLE)PA  WHERE PA.CD_SOTOTRINH IS NOT NULL ORDER BY PA.NGAYTAO desc
         FETCH FIRST 1 ROWS ONLY;
     end if;
      -----
    SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,regexp_replace(HC.TEN,'thành phố|Thành phố ','') INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
     WHERE TA.ID=vToaAnID;
    ------------------------
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
      -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="text-align: center; vertical-align: top; font-size: 11pt">'||V_TENDONVI||' </td>
                    <th style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                <tr style="text-align: center;">
                    <td style="vertical-align: top;font-size: 11pt">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px;">
                                <th style="text-align: right;width: 15px; "><span>V</span></th>
                                <th style="border-bottom: 1px solid #000000;text-align: left;">
                                    <span>ĂN PHÒN</span>
                                </th>
                                <th style="text-align: left;"><span>G</span></th>
                            </tr>
                        </table>
                    </td>
                    <td style="vertical-align: top;">
                        <table cellpadding="0" cellspacing="0">
                            <tr style="height: 1pt; padding-bottom: 3px; font-size: 13pt">
                                <th style="width: 30px; text-align: right;"><span>Đ</span></th>
                                <th style="border-bottom: 1px solid #000000; text-align: left;">
                                    <span>ộc lập - Tự do - Hạnh ph</span>
                                </th>
                                <th style="text-align: left;"><span>úc</span></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 13pt">Số: '||V_CD_SOCV||'/TTr-'||V_DONVI_CV||'-VP</td>
                    <td style="font-size: 12pt;font-style:italic"><span style="color: #ffffff;">......</span>'||V_TENDONVI_HC||', ngày <span>'||to_char(V_CD_NGAYCV,'dd')||'</span> tháng <span>'||to_char(V_CD_NGAYCV,'MM')||'</span> năm <span>'||to_char(V_CD_NGAYCV,'yyyy')||'</span></td>
                </tr>
                <tr style="padding-top: 3px; font-size: 12pt;">
                    <td></td>
                    <td></td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 650pt;"></td>
                    <td style="width: 750pt"></td>
                </tr>
            </table>
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-bottom:4px;">
                    TỜ TRÌNH 
               </p>     
               <p style="font-size: 14pt; text-align: center;line-height: 100%;font-weight:bold;margin-top:3px;">
                 Về việc thụ lý đơn và phân công Thẩm phán giải quyết đơn đề nghị<br/>
                    xem xét lại quyết định, bản án đã có hiệu lực pháp luật<br/>
                    theo trình tự giám đốc thẩm, tái thẩm<br/>
             </p>
              <p style="font-size: 14pt; text-align: center;line-height: 100%;margin-top:28pt;">
                    Kính trình: Đồng chí Chánh án '||V_TENDONVI_FULL||'
               </p>  
            <p style="font-size: 14pt; text-align: justify;margin-top:28pt;"><span style="color:white;">............</span>  '||vvNgayNhapTu||vvNgayNhapDen||REPLACE(V_TENPHONGBANGUI,'TANDTC',NULL)||' '||V_TENDONVI_FULL||' nhận và thụ lý các đơn đề nghị, kiến nghị, thông báo của công dân, tổ chức gửi '||V_TENDONVI_FULL||V_LOAIDON8_1||' đề nghị xem xét lại quyết định, bản án <b> '||V_BAQD_LOAIAN_NAME||' </b> đã có hiệu lực pháp luật theo trình tự giám đốc thẩm và dự kiến phân công các Thẩm phán giải quyết đơn (có danh sách kèm theo). </p>
            <p style="font-size: 14pt; text-align: justify"><span style="color:white;">............</span> '||V_TENPHONGBANGUI||' báo cáo và kính đề nghị đồng chí Chánh án '||V_TENDONVI_FULL||' xem xét, cho ý kiến về việc phân công Thẩm phán '||V_TENDONVI_FULL||' giải quyết đơn.</p> 
               <p style="font-size: 14pt; text-align: left;line-height: 100%;">
                 <span style="color:white;">............</span>Kính trình Đồng chí./.
               </p> 
             ');
            -----------
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td style="vertical-align: top;">
                        <p style="font-size: 12pt; text-align: left; line-height: 105%;">
                            <i><b>Nơi nhận:</b></i><br/>
                            - Như kính trình;<br />
                            - Lưu: HCTP.<br />

                        </p>
                    </td>
                    <td>
                         <p style="font-size:13pt;">');
                  IF(lower(V_NGUOIKY_CHUCVU) = 'chánh văn phòng' ) then
                      DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                                <strong>CHÁNH VĂN PHÒNG<br /><br /><br /><br /><br /><br />
                                
                                </strong>');
                  ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'   
                            <strong>KT. CHÁNH VĂN PHÒNG<br /><br /><br /><br /><br />
                                PHÓ CHÁNH VĂN PHÒNG<br />
                            </strong>');
                   END IF;    
                   
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'                                
                        </p>
                        <br /> <br /><br /> <br />
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                         <p style="font-size:13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                    </td>
                </tr>
                <tr style="height: 0px;">
                    <td style="width: 500pt"></td>
                    <td style="width: 500pt;"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END GDTTTT_QLTOTRINH_VAKN_BTP_TTRINH_PHANCONG;

PROCEDURE VAKN_CHECK_CHUYEN_TPTC
(   vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
) IS 
    vY number;
BEGIN
    OPEN curReturn FOR
        Select count(dc.ID) vcheck
        From SOPHATHANH_VUAN dvb
        left join SOPHATHANH_vugiamdoc svb on svb.id = dvb.SOPHATHANH_ID
        left join GDTTT_VUAN_CHITIET_CHUYEN dc on dvb.VUANID = dc.VUANID
        Where dvb.SOPHATHANH_ID=vSOPHATHANH_ID and dc.TRANGTHAI in (1,2) and dc.TRANGTHAICHUYENTP = 1 and dvb.TRANGTHAI = 1;
END VAKN_CHECK_CHUYEN_TPTC;

PROCEDURE SUAVANBANVAKN_HCTP_SEARCH
(
    vSOPHATHANH_ID in number,   
	curReturn OUT sys_refcursor
) IS 
	TotalItem number;
    MinIndex	number;
    MaxIndex	number;
BEGIN
  OPEN curReturn FOR
    select a.*, TotalItem as CountAll 
        from (Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT, 
                dvb.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,
                d.NGAYNHANDON,d.LOAIDON, NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
                d.NGUOITAO NguoiNhap, Decode(d.loaidon,4,'Viện kiểm sát nhân dân tối cao',D.DONGKHIEUNAI) as DONGKHIEUNAI,
                d.NGUOISUA, d.NGAYSUA,d.NGAYTAO NgayNhap, TL_NGAY,TL_SO,
                svb.SOVB,to_char(svb.NGAYVB,'dd/MM/yyyy') NGAYVB,svb.NGUOIKY || '-'||svb.Chucvu  NGUOIKY,
                d.CV_SO,d.NGAYGHITRENDON, (Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else d.BAQD_SO END) BAQD_SO,
                (Case d.BAQD_LOAIQDBA 
                 When 1 then ('QĐ: ' || d.KN_SOQD) 
                 Else decode(d.BAQD_LOAIQDBA,2,'QĐ: ',0,DECODE(d.ToaAnID,1,'BA/QĐ: ',6,'BA: ')) ||decode(d.BAQD_CAPXETXU,2,(d.BAQD_SO_ST),3,(d.BAQD_SO_PT), (d.BAQD_SO)) 
                 END) BAQD, d.CV_TENDONVI,
                 (Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY 
                 Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA,
                 (Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX, 
                 DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat, NVL(d.BAQD_CAPXETXU,0) BAQD_CAPXETXU,
                 d.BAQD_SO_PT,d.BAQD_SO_ST, d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH, 
                 d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,
                 d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,
                 d.CHIDAO_COKHONG, d.CHIDAO_NOIDUNG,c.HOTEN TENTHAMPHAN,d.CD_SOTOTRINH,
                (case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                      when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                      when 3 then  cast('Trả lại đơn' as nvarchar2(250)) when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN,
                (Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB,
                (Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK,
                (Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK,
                (Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK,
                (Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI,
                (Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL,
                (case d.CD_TRANGTHAI 
                    when 0 then 'Chưa chuyển' 
                    when 1 then  'Đã chuyển' 
                    when 2 then  'Đã nhận' 
                    when 3 then  'Bị trả lại' 
                else 'Chưa chuyển'
                end ) TRANGTHAICHUYEN,
    (SELECT RTRIM(
        XMLAGG(
            XMLELEMENT(E,TO_CHAR(NVL(cv.CV_TENDONVI,'')) || ' chuyển đến theo CV/PC số ' || cv.CV_SO || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'),'; ')
            .EXTRACT('//text()') ORDER BY cv.NGAYTAO desc
            ).GetClobVal(),',') 
    FROM GDTTT_DON cv 
    WHERE cv.LOAIDON =3 
        and (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( 
        select ID from GDTTT_DON 
        where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) 
        And d.DontrungID>0)))
        ) arrCongvan,
    (Case when d.ISTHULY=2 And d.CD_LOAI=0 then
        (SELECT RTRIM(
            XMLAGG(
            XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') 
            || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || ' - ' 
            || to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy') || '/TTr-TANDTC-VP)' ,'  ')
            .EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
        FROM GDTTT_DON cv  
        left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID 
        WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( 
            select ID from GDTTT_DON 
            where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
        And cv.ID<d.ID) 
    End) arrTTTL,
    case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
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
              else '' end  KQGQNoiBo,
    lvb.ten TenSOVB,
    svb.MASO MaSOVB
    ,'' GXNSO,'' GXNNGAY,'none' IsGXN
    from SOPHATHANH_VUAN dvb
        left join sophathanh_vugiamdoc svb on svb.id = dvb.SOPHATHANH_ID
        left join DM_DATAITEM lvb on lvb.ma = svb.MASO and ((svb.TOAANID = 1 and lvb.ma = 'QLSO_HCTP_TC') OR lvb.ma = 'QLSO')
        left join GDTTT_VUAN va on dvb.VUANID = va.id
        left join GDTTT_DON d on va.ID = d.VUVIECID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join  DM_TOAAN txx on va.TOAANID=txx.ID
        left join DM_CANBO c on va.THAMPHANID=c.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=va.NGUOITAO
        left join DM_DATAITEM i on va.NGUOIKHANGNGHI=i.ID
        left join GDTTT_VUAN_CHITIET_CHUYEN ctc on va.ID = ctc.VUANID
     where svb.ID = vSOPHATHANH_ID and (ctc.TRANGTHAI is null or ctc.TRANGTHAI in (1, 2))
        order by va.NGAYTAO desc
     ) a;
END SUAVANBANVAKN_HCTP_SEARCH;

PROCEDURE VAKN_GETCHUAPCTP
(   vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    vNoiChuyen in number,
    vTrangthai in number,  
    vIsThuLy in number,
    vNguoiNhap in varchar2,
    varrLoaiAn in varchar2,
    vHinhThuc in number,
    curReturn OUT sys_refcursor
) IS 
    vvDenNgay date;
BEGIN
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvDenNgay from dual;

    OPEN curReturn FOR
        Select v.ID,d.MADON,decode(d.NGUOIGUI_HOTEN,null,d.CV_TENDONVI,d.NGUOIGUI_HOTEN) NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,'1' SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
        case when d.NGUOISUA is null then d.NGUOITAO else d.NGUOISUA end as NguoiNhap,
        case when d.NGAYSUA is null then d.NGAYTAO else d.NGAYSUA end as NgayNhap,
        case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
        ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
        ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
        ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST
        ,d.CV_TENDONVI
        , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
        ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI
        ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250)) end ) NOICHUYEN
        ,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,'' TENTHAMPHAN
        ,d.TL_SO,d.TL_NGAY
        ,d.isTPB3 as INVALID
        from GDTTT_VUAN v
        join GDTTT_DON d ON v.ID = d.VUVIECID
        join GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID      
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        where d.TOAANID=vToaAnID and NVL(ctc.THAMPHANID,0)=0 and ctc.TRANGTHAI = 2 --đã nhận
        and (( 1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vvDenNgay then 1 else 0 end)
        Or (1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vvDenNgay then 1 else 0 end))
        and d.CD_LOAI=0  and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
        and d.ISTPB3= 1 --lấy đơn thuộc thẩm quyền của TPB3
        Order by d.NGAYTAO desc;        
END VAKN_GETCHUAPCTP;

PROCEDURE VAKN_GET_THEO_KETQUA_CHIDINHID
(   vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    vNoiChuyen in number,
    vTrangthai in number,
    vIsThuLy in number,
    vNguoiNhap in varchar2,
    varrLoaiAn in varchar2,
    vHinhThuc in number,
    vKetQuaID in number,
    curReturn OUT sys_refcursor
) IS 
    vvDenNgay date;
BEGIN
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvDenNgay from dual;

    OPEN curReturn FOR
        Select ROW_NUMBER() OVER (ORDER BY k.ID) STT,
        kct.ID,d.MADON,decode(d.NGUOIGUI_HOTEN,null,d.CV_TENDONVI,d.NGUOIGUI_HOTEN) NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON,d.LOAIDON,'1' SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
        case when d.NGUOISUA is null then d.NGUOITAO else d.NGUOISUA end as NguoiNhap,
        case when d.NGAYSUA is null then d.NGAYTAO else d.NGAYSUA end as NgayNhap,
        case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
        ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
        ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
        ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST
        ,d.CV_TENDONVI
        , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
        ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI
        ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250)) end ) NOICHUYEN
        ,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,cb.hoten TENTHAMPHAN, kct.NGAYPHANCONGTP, kct.CANBOID, kct.CANBOID_SUA
        ,d.TL_SO,d.TL_NGAY
        ,d.isTPB3 as INVALID, null AS CD_SOTOTRINH, null AS CD_NGAYTOTRINH
        from GDTTT_PCTP_VAKN_CHIDINH k
        join GDTTT_PCTP_VAKN_CHIDINH_CHITIET kct on k.ID = kct.CHIDINHID
        join DM_CANBO cb on cb.ID = kct.CANBOID 
        join GDTTT_VUAN v on v.ID = kct.VUANID
        join GDTTT_DON d ON v.ID = d.VUVIECID
        join GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        where k.ID = vKetQuaID and d.TOAANID=vToaAnID and NVL(ctc.THAMPHANID,0)>0 and ctc.TRANGTHAI = 2 --đã nhận
        and (( 1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vvDenNgay then 1 else 0 end)
        Or (1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
        and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vvDenNgay then 1 else 0 end))
        and d.CD_LOAI=0  and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
        and d.ISTPB3= 1 --lấy đơn thuộc thẩm quyền của TPB3
        Order by d.NGAYTAO desc;        
END VAKN_GET_THEO_KETQUA_CHIDINHID;

FUNCTION INSERT_GDTTT_PCTP_VAKN_CHIDINH
( vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    varrLoaiAn in varchar2,
    vNguoithuchien in varchar2,
    vNguoithuchienID in number,
    vLoaithamphan varchar2
)RETURN number AS
     vKetQuaID number;
BEGIN
   /*Lưu thông tin lần phân công*/
    vKetQuaID:=GDTTT_PCTP_VAKN_CHIDINH_SEQ.nextval;
   Insert into GDTTT_PCTP_VAKN_CHIDINH (ID, NGAYPHANCONG, NGUOITHUCHIEN, TUNGAY, DENNGAY, TOAANID, NGUOITHUCHIENID, TRANGTHAI, LOAITP) 
   values (vKetQuaID, SYSDATE, vNguoithuchien, vTuNgay, vDenNgay, vToaAnID, vNguoithuchienID, 0, vLoaithamphan);

   Return vKetQuaID;
END INSERT_GDTTT_PCTP_VAKN_CHIDINH;

FUNCTION INSERT_GDTTT_PCTP_VAKN_CHIDINH_CHITIET
( vToaAnID in number,
    vChiDinhID in number,
    vVuAnID in number,
    vCanBoID in number
)RETURN number AS
     vKetQuaID number;
BEGIN
   /*Lưu thông tin lần phân công*/
    vKetQuaID:=GDTTT_PCTP_VAKN_CHIDINH_CHITIET_SEQ.nextval;    
   Insert into GDTTT_PCTP_VAKN_CHIDINH_CHITIET (ID, TOAANID, CHIDINHID, VUANID, CANBOID, NGAYPHANCONGTP) 
   values (vKetQuaID, vToaAnID, vChiDinhID, vVuAnID, vCanBoID, SYSDATE);
   
   update GDTTT_VUAN_CHITIET_CHUYEN set THAMPHANID = vCanBoID 
   where VUANID = vVuAnID and TRANGTHAI = 2; -- HCTP đã nhận mới phân công được
   
   Return vKetQuaID;
END INSERT_GDTTT_PCTP_VAKN_CHIDINH_CHITIET;

FUNCTION PHANCONGNGAUNHIEN_VAKN
( vToaAnID in number,
    vTuNgay in date,
    vDenNgay in date,
    vNguoiNhap in varchar2,
    varrLoaiAn in varchar2,
    vNguoithuchien number
)RETURN number AS
     vGroupChucDanhID number;
     vTT number;
     vRand number;
     vKetQuaID number;
     vThamphanID number;
     vLoaiAn number;
     vA number;/*Tổng số đơn đến thời điểm hiện tại*/
     vA1 number;/*Tổng số vụ án đến thời điểm hiện tại*/
     vB number;/*Tổng số thẩm phán*/
     vC number;/*Số ngày đến thời điểm hiện tại*/
     vD number;/*Số ngày nghỉ phép, công tác*/
     vE number;/*Số đơn của thẩm phán đã được phân công*/
     vE1 number;/*Số vụ án của thẩm phán đã được phân công*/
     vY number;/*Trọng số sắp xếp*/
     vCT number;/*gán đơn cho thẩm phán đã được phân công trước đây(đơn thụ lý mới lần thứ >1)*/
     vF  number;--Tổng số ngày thẩm phán không được quyền giải quyết đơn
     vN number;
     vVuAnID number; 
     vNgayPhanCongTP date;V_NGAYBONHIEM DATE;V_NGAY_GQD date;
     v_dem NUMBER:=0; --anhvh dùng để test
     vNGAY_GQD DATE; --//Thơi gian duoc phan cong giai quyet don
     vDAUKY DATE; --//Thơi gian đâu kỳ của năm hiện tại
BEGIN
  vN:=EXTRACT(YEAR FROM vDenNgay);
  if(to_char(vDenNgay,'mm')='12') then
      vN:=vN+1;
  end if;
   select a.ID into vGroupChucDanhID from DM_DATAGROUP a where a.MA='CHUCDANH';
   select SYSTIMESTAMP into vNgayPhanCongTP from dual;

   /*Lưu thông tin lần phân công*/
    vKetQuaID:=GDTTT_PCTP_VAKN_NGAUNHIEN_SEQ.nextval;
    vC:=TO_CHAR(vDenNgay, 'DDD');
    Insert into GDTTT_PCTP_VAKN_NGAUNHIEN
    VALUES(vKetQuaID,vNgayPhanCongTP,'',null,vTuNgay,vDenNgay,vToaAnID,vNguoithuchien,null,0);

   /*Lấy danh sách vụ án kháng nghị ngẫu nhiên để phân công*/
    FOR i IN (Select d.ID DONID, v.ID VUANID, d.BAQD_LOAIAN, d.BAQD_SO, d.BAQD_NGAYBA, d.BAQD_TOAANID, d.BAQD_SO_PT, d.BAQD_NGAYBA_PT, 
                    d.BAQD_TOAANID_PT, d.BAQD_SO_ST, d.BAQD_NGAYBA_ST, d.BAQD_TOAANID_ST
                FROM GDTTT_VUAN v
                LEFT JOIN GDTTT_DON d on v.ID = d.VUVIECID
                JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and NVL(ctc.THAMPHANID,0) = 0 and ctc.TRANGTHAI = 2 --HCTP đã nhận
                WHERE d.TOAANID=vToaAnID 
                and ((1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYTAO then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYTAO <= vDenNgay then 1 else 0 end)
                Or (1=case when vTuNgay is null then 1 when vTuNgay <= d.TL_NGAY then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.TL_NGAY <= vDenNgay then 1 else 0 end))
                and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
                and 1=case when varrLoaiAn || ' '=' ' then 1 when  lower(varrLoaiAn) like ('%,' || Cast(d.BAQD_LOAIAN as varchar2(2)) || ',%') then 1 else 0 end
                and d.CD_LOAI=0 and d.CD_TA_TRANGTHAI=0 and d.ISTHULY=1 
                Order by DBMS_RANDOM.VALUE)
    LOOP  
    v_dem:=v_dem+1;    
      /*Kiểm tra xem đã phân thẩm phán xử lý đơn trùng trước đó chưa*/
      vThamphanID:=NVL(vThamphanID,0);
      SELECT COUNT(b.ID) into vCT 
        FROM GDTTT_DON b
        LEFT JOIN DM_CANBO C ON C.ID = b.THAMPHANID
        JOIN GDTTT_VUAN v on b.VUVIECID = v.ID
        JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and NVL(ctc.THAMPHANID,0) = 0 and ctc.TRANGTHAI = 2 --HCTP đã nhận
        WHERE (NVL(b.THAMPHANID,0) > 0 OR NVL(v.THAMPHANID,0) > 0)
                And b.isTPB3 = 0 --Don cua tham phan tối cao
                And b.ID<>i.DONID AND v.ID <> i.VUANID
                And NVL(c.HIEULUC,0) != 0 -- =0 la nghi huu 
                And b.isthuly = 1 -- Don thu ly moi
                And b.CD_LOAI = 0 --Noi chuyen Noi bo
                    AND (C.TRANGTHAI_XETXU=1 Or (NVL(C.TRANGTHAI_XETXU,0) = 0 and NVL(b.VUVIECID,0) = 0) -- Dung xet xu nhung con Don dang giai quyet
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 1 and NVL(b.VUVIECID,0) > 0
                                and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua not in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID))
                         )
                    AND ((NVL(b.VUVIECID,0) > 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                WHERE v.gqd_loaiketqua in (0,1,2,3,4) And v.ID = b.VUVIECID)) -- Co vu an duoc phan cong nhung chua giai quyet xong
                            OR NVL(b.VUVIECID,0) = 0
                        )
                    AND ((REPLACE(REPLACE(upper(b.BAQD_SO),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO),'-'),'/')  
                                                and b.BAQD_NGAYBA=i.BAQD_NGAYBA 
                                                and  b.BAQD_TOAANID=i.BAQD_TOAANID
                                                and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_PT),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_PT),'-'),'/')  
                                                    and b.BAQD_NGAYBA_PT=i.BAQD_NGAYBA_PT 
                                                    and  b.BAQD_TOAANID_PT=i.BAQD_TOAANID_PT
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_ST),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_ST),'-'),'/')  
                                                    and b.BAQD_NGAYBA_ST=i.BAQD_NGAYBA_ST 
                                                    and  b.BAQD_TOAANID_ST=i.BAQD_TOAANID_ST
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                         )       
                        ;
      vCT:=NVL(vCT,0); 
      if(vCT>0) Then/*gán đơn cho thẩm phán đã được phân công trước đây(đơn thụ lý mới lần thứ >1)*/
        SELECT THAMPHANID into vThamphanID 
        FROM (SELECT v.THAMPHANID 
                FROM GDTTT_DON b 
                LEFT JOIN DM_CANBO C ON C.ID=b.THAMPHANID
                JOIN GDTTT_VUAN v on b.VUVIECID = v.ID
                JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and NVL(ctc.THAMPHANID,0) = 0 and ctc.TRANGTHAI = 2 --HCTP đã nhận
                WHERE (NVL(b.THAMPHANID,0) > 0 OR NVL(v.THAMPHANID,0) > 0)
                    And b.isTPB3 = 0 --Don cua tham phan tối cao
                    And b.ID<>i.DONID AND v.ID <> i.VUANID
                    And NVL(c.HIEULUC,0) != 0 -- =0 la nghi huu
                    And b.isthuly = 1 -- Don thu ly moi
                    And b.CD_LOAI = 0 --Noi chuyen Noi bo
--                  Lay ra TP dang xet xu và TP dung xet xu nhung con don dang giai quyet
                    AND (C.TRANGTHAI_XETXU=1 --anhvh add trang thai dang xet xử
--                            Dung xet xu nhung con Don dang giai quyet
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 0 and NVL(b.VUVIECID,0) = 0)
                            Or (NVL(C.TRANGTHAI_XETXU,0) = 0 
                                and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua not in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID))
                         )
                        AND ( -- Co vu an duoc phan cong nhung chua giai quyet xong
                            (NVL(b.VUVIECID,0) > 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                        WHERE v.gqd_loaiketqua in (0,1,2,3,4)
                                                            And v.ID = b.VUVIECID))
                             OR NVL(b.VUVIECID,0) = 0
                        )
                    AND ((REPLACE(REPLACE(upper(b.BAQD_SO),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO),'-'),'/')  
                                                and b.BAQD_NGAYBA=i.BAQD_NGAYBA 
                                                and  b.BAQD_TOAANID=i.BAQD_TOAANID
                                                and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_PT),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_PT),'-'),'/')  
                                                    and b.BAQD_NGAYBA_PT=i.BAQD_NGAYBA_PT 
                                                    and  b.BAQD_TOAANID_PT=i.BAQD_TOAANID_PT
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                            or 
                                                (REPLACE(REPLACE(upper(b.BAQD_SO_ST),'-'),'/')=REPLACE(REPLACE(upper(i.BAQD_SO_ST),'-'),'/')  
                                                    and b.BAQD_NGAYBA_ST=i.BAQD_NGAYBA_ST 
                                                    and  b.BAQD_TOAANID_ST=i.BAQD_TOAANID_ST
                                                    and b.BAQD_LOAIAN = i.BAQD_LOAIAN)
                                         )
        ORDER BY b.NGAYTAO desc) WHERE ROWNUM = 1;
        vThamphanID:=NVL(vThamphanID,0); 
        Insert Into GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET(ID,TOAANID,NGAUNHIENID,VUANID,CANBOID,NGAYPHANCONGTP)
        Values(GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET_SEQ.NEXTVAL,vToaAnID,vKetQuaID,i.VUANID,vThamphanID,sysdate);
            
        update GDTTT_VUAN_CHITIET_CHUYEN set THAMPHANID = vThamphanID where VUANID = i.VUANID and TRANGTHAI = 2 and NVL(THAMPHANID,0) = 0;
      Else  
      vLoaiAn:=i.BAQD_LOAIAN;
      /*Tính tổng số đơn đã phân công giải quyết*/    
      Select Count(d.ID) into vA from GDTTT_DON d  
         where d.TOAANID=vToaAnID 
            And d.isTPB3 = 0 --Don cua tham phan tối cao
                and NVL(d.THAMPHANID,0)>0 
              And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD')
              and 1=(Case When (vLoaiAn=1 and d.BAQD_LOAIAN=1) Then 1 When (vLoaiAn=2 and d.BAQD_LOAIAN=2) Then 1
               When (vLoaiAn=6 and d.BAQD_LOAIAN=6) Then 1 When (vLoaiAn in (3,4,5,7) and d.BAQD_LOAIAN  in (3,4,5,7)) Then 1 Else 0 End);
    
      /*Tính tổng số vụ án đã phân công giải quyết*/    
      Select Count(d.ID) into vA1 
        from GDTTT_DON d
        JOIN GDTTT_VUAN v on d.VUVIECID = v.ID
        JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and NVL(ctc.THAMPHANID,0) = 0 and ctc.TRANGTHAI = 2 --HCTP đã nhận
         where d.TOAANID=vToaAnID 
            And d.isTPB3 = 0 --Don cua tham phan tối cao
                and NVL(d.THAMPHANID,0)>0 
              And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD') and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD')
              and 1=(Case When (vLoaiAn=1 and d.BAQD_LOAIAN=1) Then 1 When (vLoaiAn=2 and d.BAQD_LOAIAN=2) Then 1
               When (vLoaiAn=6 and d.BAQD_LOAIAN=6) Then 1 When (vLoaiAn in (3,4,5,7) and d.BAQD_LOAIAN  in (3,4,5,7)) Then 1 Else 0 End);
       
       vA1:= NVL(vA1,0);
       vA:=NVL(vA,0);
       vA:= (vA + vA1);

      /*Tính tổng số thẩm phán*/
      Select Count(c.ID) into vB From DM_CANBO c 
        inner join (select i.ID,i.TEN from DM_DATAITEM i 
                    where i.GROUPID=vGroupChucDanhID and i.MA in ('TPTATC') --chỉ lấy thẩm phán tối cao
                    ) d1 on d1.ID=c.CHUCDANHID 
      WHere c.TOAANID=vToaAnID  And c.HIEULUC=1 AND C.TRANGTHAI_XETXU=1 --add trang thai dang xet xử
      and (NVL(c.CHUCVUID,0)<> 74 or c.id=40599)-- C.ID=40599 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
      AND NVL(c.CHUCVUID,0)<>45 --45 chức vụ chánh án
          And 1=(Case WHen (vLoaiAn=1 and c.ISHINHSU=1) Then 1
                      WHen (vLoaiAn=2 and c.ISDANSU=1) Then 1
                      WHen (vLoaiAn=3 and c.ISHNGD=1) Then 1
                      WHen (vLoaiAn=4 and c.ISKDTM=1) Then 1
                      WHen (vLoaiAn=5 and c.ISLAODONG=1) Then 1
                      WHen (vLoaiAn=6 and c.ISHANHCHINH=1) Then 1
                      WHen (vLoaiAn=7 and c.ISPHASAN=1) Then 1
          Else 0 End);          
     vB:=NVL(vB,0);
     vTT:=0;

     /*Tạo danh sách thẩm phán dùng phân công*/
      DELETE from GDTTT_PCTP_TMP where TOAANID=vToaAnID;
      FOR j in (
          Select c.ID into vB From DM_CANBO c 
          inner join (select i.ID,i.TEN from DM_DATAITEM i where i.GROUPID=vGroupChucDanhID and i.MA in ('TPTATC')) d1 on d1.ID=c.CHUCDANHID --chỉ lấy thẩm phán tối cao
          WHere c.TOAANID=vToaAnID  And c.HIEULUC=1 AND C.TRANGTHAI_XETXU=1
              and (NVL(c.CHUCVUID,0)<> 74 or c.id=40599)-- C.ID=40599 add ngoai lệ TP Dương văn Thăng vẫn được phân án     
              AND NVL(c.CHUCVUID,0)<>45 --45 chức vụ chánh án
              And 1=(Case WHen (vLoaiAn=1 and c.ISHINHSU=1) Then 1
                          WHen (vLoaiAn=2 and c.ISDANSU=1) Then 1
                          WHen (vLoaiAn=3 and c.ISHNGD=1) Then 1
                          WHen (vLoaiAn=4 and c.ISKDTM=1) Then 1
                          WHen (vLoaiAn=5 and c.ISLAODONG=1) Then 1
                          WHen (vLoaiAn=6 and c.ISHANHCHINH=1) Then 1
                          WHen (vLoaiAn=7 and c.ISPHASAN=1) Then 1
                    Else 0 End)     
          )
      LOOP  vTT:=vTT+1;

        /*Tổng số ngày nghỉ phép trong năm*/
        Select SUM(c.SONGAY) into vD From DM_CANBO_CONGTAC c 
        where TOAANID=vToaAnID AND c.CANBOID=j.ID
          and c.TUNGAY between TO_DATE(Cast((vN-1) as varchar2(4))||'-12-01','YYYY-MM-DD')
                           and TO_DATE(Cast((vN) as varchar2(4))||'-11-30','YYYY-MM-DD');
        vD:=NVL(vD,0);
        
        /*Tổng số đơn đã được phân công cho TPTC đang xét*/
        Select Count(d.ID) into vE 
        from GDTTT_DON d 
        LEFT JOIN GDTTT_PCTP_CHITIET CT ON CT.DONID=D.ID
        where d.TOAANID=vToaAnID and d.THAMPHANID=j.ID 
         And d.NGAYTAO--CT.NGAYPHANCONGTP
         between TO_DATE(Cast((vN-1) as varchar2(4)) || '-12-01T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
         And TO_DATE(Cast((vN) as varchar2(4)) ||'-11-30T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"');
         
        /*Tổng số vụ án kháng nghị đã được phân công cho TPTC đang xét*/
        Select Count(d.ID) into vE1 
        from GDTTT_DON d 
        JOIN GDTTT_VUAN v on d.VUVIECID = v.ID
        JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and ctc.TRANGTHAI = 2 --HCTP đã nhận
        where d.TOAANID=vToaAnID and ctc.THAMPHANID=j.ID 
         And d.NGAYTAO between TO_DATE(Cast((vN-1) as varchar2(4)) || '-12-01T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"')
         And TO_DATE(Cast((vN) as varchar2(4)) ||'-11-30T23:54:14Z',  'YYYY-MM-DD"T"HH24:MI:SS"Z"');
         ------------
         
        vE:=NVL(vE,0);
        vE1:=NVL(vE1,0);
        vE:=(vE+vE1);
        
        --Tổng số ngày không được quyền giải quyết đơn trong năm
        SELECT NGAY_GQD INTO vNGAY_GQD FROM DM_CANBO cb where  cb.id=j.ID;
        --Ngay thang dau ky của năm hiện tại
        vDAUKY := TO_DATE(to_char(vN - 1)||'-12-01T23:54:14Z','YYYY-MM-DD"T"HH24:MI:SS"Z"');
--      Nếu ngày phần công đúng trong kỳ năm hiện tại thì lấy theo ngày được giải quyết; Nếu trước ngày năm hiện tại mặc định không mất ngày nào   
        IF (vNGAY_GQD > vDAUKY) THEN
            SELECT TO_CHAR(NGAY_GQD, 'DDD') INTO vF FROM DM_CANBO cb where  cb.id=j.ID;
        ELSE
            vF := 1;
        END IF;

        vF:=NVL(vF,0);      
        --tính trọng số cho từng thẩm phán
--        vY:=vE-(vC-vD)*vA*1.0/(vB*vC*1.0);
         vY:=vE/(vC-vD-vF)-(vA/(vB*vC));
--        vA number;/*Tổng số đơn đến thời điểm hiện tại*/
--        vB number;/*Tổng số thẩm phán*/
--        vC number;/*Số ngày đến thời điểm hiện tại*/
--        vD number;/*Số ngày nghỉ phép, công tác*/
--        vE number;/*Số đơn của thẩm phán đã được phân công*/
--        vY number;/*Trọng số sắp xếp*/
--        vCT number;/*Trọng số sắp xếp*/
         Insert into GDTTT_PCTP_TMP 
         VALUES(vToaAnID,j.ID,vY,Cast((vE) as varchar2(10)) || '-(' || Cast((vC) as varchar2(10))||'-'|| Cast((vD) as varchar2(10)) || ')*' ||  Cast((vA) as varchar2(10)) || '*1.0/' ||  Cast((vB) as varchar2(10)) || '*' || Cast((vC) as varchar2(10)),'(VA:'||VA||')(VB:'||VB||')(VC:'||VC||')(VD:'||VD||')(VE:'||VE||')(VY:'||VY||')(id:'||j.ID||')');
      END LOOP;

      /*Lấy thẩm phán có trọng số thấp nhất*/
      Select CANBOID into vThamphanID 
      from (Select CANBOID from GDTTT_PCTP_TMP Where TOAANID=vToaAnID Order by THUTU) where rownum=1;
            
      vThamphanID:=NVL(vThamphanID,0);      
      if(vThamphanID>0) Then
        Insert Into GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET(ID,TOAANID,NGAUNHIENID,VUANID,CANBOID,NGAYPHANCONGTP)
        Values(GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET_SEQ.NEXTVAL,vToaAnID,vKetQuaID,i.VUANID,vThamphanID,sysdate);
            
        update GDTTT_VUAN_CHITIET_CHUYEN set THAMPHANID = vThamphanID where VUANID = i.VUANID and NVL(THAMPHANID,0) = 0 and TRANGTHAI = 2; --HCTP đã nhận
      End If;
     End If; 
     END LOOP;
     COMMIT;
   Return vKetQuaID;
END PHANCONGNGAUNHIEN_VAKN;

PROCEDURE GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN
( 
  vToaAnID in number,  
  vKetQuaID in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vNgayThuly in varchar2,
  vSoThuly in varchar2,
  vThamphanID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
  Select * from (
  Select ROW_NUMBER() OVER (ORDER BY cast(NVL(d.TL_SO,'0') as number)) STT, k.ID
  ,decode(d.NGUOIGUI_HOTEN,null,d.CV_TENDONVI,d.NGUOIGUI_HOTEN)NGUOIGUI_HOTEN --05/07/2024
  ,d.NGAYNHANDON,d.NGAYGHITRENDON,d.MADON
  , case d.LOAIDON when 1 then 'Đơn' when 2 then 'Đơn tố cáo' when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Select TENPHONGBAN from DM_PHONGBAN where ID=d.CD_TA_DONVIID) NOICHUYEN
       ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 0 then  (Select MA_TEN from DM_TOAAN where ID=decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID))
      Else (Select TEN from DM_DATAITEM where ID=d.NGUOIKHANGNGHI)
      END) TOAXX
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST
        ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
      ,d.CV_TENDONVI,c1.HOTEN || '(' || TO_CHAR(c1.NGAYSINH, 'DD/MM/YYYY') || ')' TENTHAMPHAN
      ,c2.HOTEN TENTHAMPHANSUA,d.NGUOIGUI_HUYENID
      ,d.NGUOIGUI_DIACHI || ' '  Diachigui,
      k.CANBOID,CANBOID_SUA,k.GHICHU
      ,d.TL_SO,d.TL_NGAY, d.CD_SOTOTRINH
      , decode(d.CD_NGAYTOTRINH,null,null,to_char(d.CD_NGAYTOTRINH,'dd/MM/yyyy')) CD_NGAYTOTRINH
      , decode(k.NGAYPHANCONGTP,null,to_char(kq.NGAYPHANCONG,'dd/MM/yyyy'),to_char(k.NGAYPHANCONGTP,'dd/MM/yyyy')) NGAYPHANCONGTP
      ,null PhanCongTP--GDTTT_PCTP_GetAll_BY_DON(K.DONID) PhanCongTP --yeu cau cua Duy, chi huong xoa di de in
      ,0 as CHECK_VUAN --(select count(id) from gdttt_vuan where id = d.VUVIECID) CHECK_VUAN
    From GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET k 
        join GDTTT_VUAN v on k.VUANID = v.ID
        Inner join GDTTT_DON d on v.ID = d.VUVIECID
        left join GDTTT_PCTP_VAKN_NGAUNHIEN kq on kq.id = k.NGAUNHIENID
        left join DM_CANBO c1 on c1.ID=k.CANBOID
        left join DM_CANBO c2 on c2.ID=k.CANBOID_SUA
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
        WHere k.NGAUNHIENID=vKetQuaID
                    and 1=case when vToaRaBAQD=0 then 1 when (d.BAQD_TOAANID=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD)
                                                    then 1 else 0 end        
                    and 1=case when vSoBAQD || ' '=' ' then 1 when ( lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                                                Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                                                Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                                                Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
                    and  1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD 
                                                            Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                            Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                            Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end              
                    and 1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                    and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
                    and 1=case when vThamphanID=0 then 1 when d.THAMPHANID=vThamphanID then 1 else 0 end
                    and  1=case when vNgayThuly || ' '=' ' then 1 when to_char(d.TL_NGAY,'dd/MM/yyyy')=vNgayThuly  then 1 else 0 end);  

END GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN;

FUNCTION CHECK_VAKN_XOA_PHANCONG_CHIDINH(vKetQuaId in number) RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
    SELECT COUNT(1) INTO V_COUNT
    FROM GDTTT_PCTP_VAKN_CHIDINH_CHITIET ct
    INNER JOIN SOPHATHANH_VUAN va on ct.VUANID = va.VUANID
    INNER JOIN SOPHATHANH_VUGIAMDOC vgd on va.SOPHATHANH_ID = vgd.ID
    WHERE ct.CHIDINHID = vKetQuaId and vgd.MASO IN ('TBTP','SoTT') and vgd.TRANGTHAI = 1 and va.TRANGTHAI = 1;
    
    IF (NVL(V_COUNT,0)>0)THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;  
END CHECK_VAKN_XOA_PHANCONG_CHIDINH;

FUNCTION CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH(vKetQuaId in number) RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
    SELECT COUNT(1) INTO V_COUNT
    FROM GDTTT_PCTP_VAKN_CHIDINH_CHITIET ct
    INNER JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on ct.VUANID = ctc.VUANID
    WHERE ct.CHIDINHID = vKetQuaId and ctc.TRANGTHAICHUYENTP = 1; -- đã chuyển thẩm phán
    
    IF (NVL(V_COUNT,0)>0)THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;  
END CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH;

FUNCTION CHECK_VAKN_XOA_PHANCONG_NGAUNHIEN(vKetQuaId in number) RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
    SELECT COUNT(1) INTO V_COUNT
    FROM GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET ct
    INNER JOIN SOPHATHANH_VUAN va on ct.VUANID = va.VUANID
    INNER JOIN SOPHATHANH_VUGIAMDOC vgd on va.SOPHATHANH_ID = vgd.ID
    WHERE ct.NGAUNHIENID = vKetQuaId and vgd.MASO IN ('TBTP','SoTT') and vgd.TRANGTHAI = 1 and va.TRANGTHAI = 1;
    
    IF (NVL(V_COUNT,0)>0)THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;  
END CHECK_VAKN_XOA_PHANCONG_NGAUNHIEN;

FUNCTION CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN(vKetQuaId in number) RETURN NUMBER AS
    V_COUNT NUMBER;
BEGIN
    SELECT COUNT(1) INTO V_COUNT
    FROM GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET ct
    INNER JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on ct.VUANID = ctc.VUANID
    WHERE ct.NGAUNHIENID = vKetQuaId and ctc.TRANGTHAICHUYENTP = 1; -- đã chuyển thẩm phán
    
    IF (NVL(V_COUNT,0)>0)THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;  
END CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN;

END PKG_GDTTT_VUAN_KHANGNGHI;

/
