--------------------------------------------------------
--  DDL for Package Body PKG_VGDKT_BAOCAO_VA
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VGDKT_BAOCAO_VA" AS
FUNCTION GDTTTT_VUAN_SEARCH_BC9
( 
  V_CONLAI_ in varchar2,
  v_colume  in varchar2,
  v_asc_desc in varchar2,
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2,
  vNguoiGui in varchar2,
  vCoquanchuyendon in varchar2,
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamtravien in number,
  vLanhdao in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vTraloidon in varchar2,
  vLoaiCVID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vTrangthai in number,
  vCapTrinhTiep in number,
  vIsDangKyBC in number,

  vKetquathuly in number,
  vKetquaxetxu in number,  

  isTTMuonHS in number,
  isTTToTrinh in number,
  isTTYKienKLTotrinh in number,
  isBuocTT in number,
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  IsHoanTHA in number,
  vTypeTB in number,
  vTypeHDTP in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number; 
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;V_SOANPHUCTHAM  VARCHAR2(255);
  ----------------
  v_arrCongvan VARCHAR2(500);v_count_cv NUMBER;v_count_yk NUMBER;V_YKien VARCHAR2(1000);
  v_colspan VARCHAR2(250);
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
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
         ------------------------
  if (vSoBAQD || ' ') <> ' ' then  
    temp_sobanan := Replace(Replace(Replace(lower(vSoBAQD), ' ', ''), '_',''), '-','');
  else 
    temp_sobanan := vSoBAQD;
  end if;
    -----Thẩm phán---------------
        IF(vPhongBanID=0) THEN
               PKG_GDTTT_BAOCAO_APP.GDTTTT_QLTOTRINH_TP(
                                              vThamphan,vToaAnID,0,vLoaiAn,--vThamphanID,vToaAnID,vPhongBanID,vLoaiAn
                                              null,vNgayThulyDen,--tt_tungay,tt_denngay
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
                                  null,vNgayThulyDen,--tt_tungay,tt_denngayto_date
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
       ---------------------------------
   FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                    Select  COUNT(1) OVER () as CountAll,
                    ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                      ) STT   
                      , NVL(v.TongDon,0 ) as TongDon 
                      ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                      ,DECODE(AQH_F.VuViecID,NULL,NULL,'X')CV93
                      ,NVL(v.IsAnChiDao, 0) as IsAnChiDao 
                       , v.ID, v.LoaiAn,v.MAVUAN,DD.LISTHULYDON  
                        ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1 and CD_TRANGTHAI = 2) cThulymoi
                       , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON
                       ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                 --manhnd
                      , case when BAQD_CAPXETXU = 4 
                                        then NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>'||
                                              decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                        '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>')||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                    '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)')
                             when BAQD_CAPXETXU = 3  then
                                             NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                             '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>'||
                                              decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                              '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>')

                             when BAQD_CAPXETXU = 2 
                                        then NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                             '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                             '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)||'<i>('|| decode(v.loaian,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>'
                             else
                                            NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                            ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                            ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                             end InforBA
                      --

                         ,qhpl.TENQHPL QHPLDN
                         ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                        ,tp.HOTEN as TENTHAMPHAN
                        ,ttv.HOTEN TENTHAMTRAVIEN
                        , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                            end  NGAYPHANCONGTTV
                        , ld.HOTEN as TENLANHDAO   

                        , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
                         ----------anhvh 12/10/2019 
                        ,CASE WHEN  (vtrangthai >=4 OR vtrangthai=-1) THEN TA.TINHTRANGID ELSE v.TRANGTHAIID END TRANGTHAIID
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1)  THEN tts.TenTinhTrang ELSE tt.TenTinhTRang END TenTinhTrang
                        ,CASE WHEN   (vtrangthai >=4 OR vtrangthai=-1) AND vKetquathuly =4  THEN tts.GiaiDoan ELSE NVL(tt.GiaiDoan,0) END GiaiDoanTrinh
                         ---------
                        ,case when  NVL(v.GQD_LOAIKETQUA,3)<> 1 then v.QUATRINH_GHICHU
                            when NVL(v.GQD_LOAIKETQUA,3) =1 then (u'Kháng nghị '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))  end QUATRINH_GHICHU
                        , v.GDQ_SO 
                        , case  when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')  end  GDQ_NGAY
                          , case when NVL(v.LoaiAn, 0)<>1 then ''
                                else (SELECT LISTAGG(cast(dt.So as varchar2(10))||case when (Length(NVL(dt.Ngay,''))=0   or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                                                       when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')  end , ',<br/>'
                                                     )
                                       WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                                       WHERE  dt.VuAnID=v.ID and dt.TypeTB=3
                                     )
                                end as AHS_ThongTinGQD
                        , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                        --anhvh edit
                        , DECODE(v.GQD_LOAIKETQUA,3,v.GQD_KETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                        ,CASE WHEN v.GQD_LOAIKETQUA=3 or v.GQD_LOAIKETQUA=4 THEN DECODE(v.GQD_LOAIKETQUA,3,'XLK ',4,'VKS đang giải quyết ')||v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'Xếp đơn')
                         || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                         end KQ_GQDS
                        , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                        , case when NVL(v.GQD_LOAIKETQUA,3)<> 1 then ''
                                when NVL(v.GQD_LOAIKETQUA,3)=1 
                                     then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')  end LoaiKN   
                        , NVL(v.GQD_SoCV , '') GQD_SoCV
                        , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') end  GQD_NgayPhatHanhCV  
                        , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                        , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')   end  GQD_HoanTHA_Ngay  
                        , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy 
                        -------------------------------
                        , NVL(v.IsHoSo,0) IsHoSo, NVL(v.HoSoID,0)
                        , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')  end  NgayTTVNhanHS
                        , v.NGAYTTVNHAN_THS,NVL(v.IsToTrinh,0) IsToTrinh , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV , v.SOTHULYXXGDT
                        , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')  end  NGAYTHULYXXGDT
                        , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')  end  XXGDTTT_NGAYVKSTRAHS
                        , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
                         , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')  end  XXGDTTT_NGAYHOAN
                        , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN,v.XXGDTTT_SOQD
                         , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') end  XXGDTTT_NGAYQD
                        , case when (Length(NVL(v.NGAYXUGIAMDOCTHAM,''))=0 or (to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                       when Length(NVL(v.NGAYXUGIAMDOCTHAM,'')) >0 then to_char(v.NGAYXUGIAMDOCTHAM,'dd/MM/yyyy')   end  NGAYXUGIAMDOCTHAM
                        , NVL(kq.Ten,' ') KetQuaXXGDT, NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                        , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy') end  NGAYRUTKN,HD1.HOIDONGXX,HD2.TEN_CHUTOA
                         ,TTVSS.PHANCONGTTV
                         ,v.TRUONGHOPTHULY
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
                      left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on ld.ID = decode (NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
                      left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
                      left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
                      ----anhvh
                      left join HD1 ON HD1.VUANID=v.ID
                      left join HD2 ON HD2.VUANID=v.ID
                      LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
                      LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
                      --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
                      LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                      --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                        LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                 AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                    SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                    WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                    AND C.TOAANID=1 AND C.HIEULUC=1 
                                    AND C.ID=D.CHIDAO_LANHDAOID 
                                     )
                                  GROUP BY d.VuViecID
                                  )AQH_F ON AQH_F.VuViecID=V.ID
                   ----anhvh add 31/03/2020 lấy tất cả thẩm tra viên đã được phân công
                   LEFT JOIN (
                        SELECT TTVS.VUANID,LISTAGG(TTVS.HOTEN, '<br/>') WITHIN GROUP (ORDER BY TTVS.STT  DESC)PHANCONGTTV
                          FROM (
                               SELECT TT.VUANID,TT.HOTEN,TT.STT FROM (
                                    SELECT VV.ID VUANID,'<b>'||TO_CHAR(TTV.HOTEN)|| DECODE(VV.XXGDT_NGAYPHANCONGTTV,null,DECODE(VV.NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.NGAYPHANCONGTTV,'dd/MM/yyyy')||')'),DECODE(VV.XXGDT_NGAYPHANCONGTTV,NULL,NULL,' ('||To_char(VV.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')||')'))||'</b>' HOTEN,1 STT FROM GDTTT_VUAN VV 
                                    LEFT JOIN DM_CANBO TTV ON DECODE(VV.XXGDT_THAMTRAVIENID,null,VV.THAMTRAVIENID,VV.XXGDT_THAMTRAVIENID)=TTV.ID
                                 UNION ALL    
                                 -- Can lay dung Lich su cua giai doan
                                   SELECT SS.VUANID,SS.HOTEN,SS.STT FROM (
                                        SELECT A.VUANID,'<i>'||TO_CHAR(b.HOTEN)||' ('||To_char(DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY),'dd/MM/yyyy')||')</i>'HOTEN,0 STT FROM GDTTT_VUAN_PHANCONGCB_HISTORY A
                                        LEFT JOIN GDTTT_VUAN VS ON VS.ID=A.VUANID
                                        INNER JOIN DM_CanBo b on a.CanBoID = b.ID
                                        WHERE a.Loai=1 
                                        ORDER BY DECODE(a.TUNGAY,NULL,VS.NGAYPHANCONGTTV,a.TUNGAY) DESC
                                    )SS
                                )TT GROUP BY TT.VUANID,TT.HOTEN,TT.STT
                            )TTVS GROUP BY TTVS.VUANID
                         )TTVSS ON TTVSS.VUANID=V.ID
                      ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                      LEFT JOIN (
                        SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                      || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                , ',<br/>')
                            WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                            FROM GDTTT_DON CV  
                            WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1
                            GROUP BY CV.VUVIECID
                        )DD ON DD.VUVIECID=v.ID
                        -----
                        where  v.TOAANID=vToaAnID 
                            And (NVL(vPhongBanID,0)=0 Or v.PhongBanID=vPhongBanID)
                            And NVL(V.ISVIENTRUONGKN,0) = 0
                            And (NVL(vloaian,0) = 0 Or vloaian = v.LOAIAN) 
                            -- Đã có kết quả đến ngày 
                            And v.NGAYTAO<=vvngaythulyden 
                            And v.gqd_loaiketqua in (0,1,2,3,4) 
                            And VA.GQD_NGACVS <=vvngaythulyden  
                            AND VA.GQD_NGACVS IS NOT NULL
               )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
    SELECT DECODE(SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1),NULL,SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,1)-1),SUBSTR(item.SOANPHUCTHAM,0,INSTR(item.SOANPHUCTHAM, '/',1,2)-1)) INTO V_SOANPHUCTHAM FROM DUAL;
    SELECT COUNT(*) INTO v_count_cv FROM GDTTT_DON D WHERE D.VUVIECID=item.ID AND  (d.CV_SO is not null or d.CV_TENDONVI is not null);
    IF(v_count_cv>0)THEN
        SELECT ( Case d.LOAIDON when 3 then (' - Công văn số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')||' của '|| TO_CHAR(d.CV_TENDONVI)) else '' End) 
        INTO v_arrCongvan FROM GDTTT_DON D WHERE D.VUVIECID=item.ID AND (d.CV_SO is not null or d.CV_TENDONVI is not null)
        FETCH FIRST 1 ROWS ONLY;
    END IF;
   -----------------
        SELECT count(*) into v_count_yk  FROM GDTTT_TOTRINH t
        inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
        left join GDTTT_DM_TINHTRANG ct on ct.ID = t.CAPTRINHTIEP
        left join DM_CANBO c on c.ID=t.LANHDAOID
        WHere t.VUANID=item.ID--1187938--4583--1183805 
         AND ((t.NGAYTRINH<=vNgayThulyDen and vNgayThulyDen IS NOT NULL)
                  OR (t.NGAYTRINH<=SYSDATE AND vNgayThulyDen IS NULL))
        FETCH FIRST 1 ROWS ONLY;
    IF(v_count_yk>0)THEN
          SELECT REPLACE(RTRIM(TT.YKien,': '),'Trả lời đơn','TLD') INTO V_YKien
            FROM (
            SELECT '- '||d.TENTINHTRANG||'<br/> '||DECODE(c.chucvuid,74,'PCA',c.HOTEN) 
            ||' duyệt '
            ||'ngày '|| to_char(t.NgayTrinh,'dd/MM/yyyy') 
            || ': '||DECODE(NVL(t.YKien, ''),NULL,Decode(NVL(t.LoaiYKien,11), 0, 'Trả lời đơn',1,'Kháng nghị', 3,'Xếp đơn'
                                               , 10,'Nghiên cứu lại, xác minh, bổ sung', 11, '' )
                                               ,NVL(t.YKien, '')) YKien
            FROM GDTTT_TOTRINH t
            inner join GDTTT_DM_TINHTRANG d on d.ID=t.TINHTRANGID
            left join GDTTT_DM_TINHTRANG ct on ct.ID = t.CAPTRINHTIEP
            left join DM_CANBO c on c.ID=t.LANHDAOID
            WHere t.VUANID=item.ID--1187938--4583--1183805 
            AND ((t.NGAYTRINH<=vNgayThulyDen and vNgayThulyDen IS NOT NULL)
                  OR (t.NGAYTRINH<=SYSDATE AND vNgayThulyDen IS NULL))
            order by t.NGAYTRINH desc,d.ThuTu desc
            FETCH FIRST 1 ROWS ONLY
         )TT;
     END IF;
    -----------------
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>               
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_SOANPHUCTHAM||'<br />'||SUBSTR(item.SOANPHUCTHAM,INSTR(item.SOANPHUCTHAM, '/',-1))||'<br/>'||item.NGAYXUPHUCTHAM||'</td>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||V_BIDON_CHECK||'</td>          
                ');
          else
               DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                ');
          end if;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_arrCongvan||'</td> 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>

            </tr>
        ');
  END LOOP;
    -------TẠO BÁO CÁO
    SELECT DECODE(vLoaiAn,01,'Tội danh','Quan hệ pháp luật') INTO vLoaiAn_name FROM DUAL;
    SELECT DECODE(vLoaiAn,01,'8','9') INTO v_colspan FROM DUAL;
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
                <td colspan="'||v_colspan||'" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH ÁN QUỐC HỘI ĐÃ GIẢI QUYẾT</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vNgayThulyTu,'dd/MM/yyyy')||'  đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="'||v_colspan||'" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;background-color:#e1dfdf;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br />
                    số và ngày</td>
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
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Công văn số và ngày</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
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
                <td style="width: 100pt"></td>
                 ');
             if(vLoaiAn=01)THEN
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                <td style="width: 150pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                 ');
             else
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 100pt"></td>
                <td style="width: 80pt"></td>
                 ');
             end if;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            </tr>
        </table>
      ');
      --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_SEARCH_BC9;


FUNCTION GDTTTT_VUAN_SEARCH_BC12
( 
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
   V_CURSOR sys_refcursor;
    v_table T_GDT_CHITIEU_01; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number;
    vTenPhongban varchar2(100);
    v_DenNgay date;
    v_TuNgay date;
    v_first_day date;
    v_last_day date;
    v_month_tu number;
    v_month_den  number;
    v_count  number default 0;
	BEGIN
    if (vPhongBanID >0) then
        select TENPHONGBAN into vTenPhongban from  DM_PHONGBAN where id = vPhongBanID;
    end if;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;

     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_GDT_CHITIEU_01();
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <th colspan="3" style="text-align: center; vertical-align: middle; height: 25px;">TÒA ÁN NHÂN DÂN TỐI CAO
                    </th>
                    <th colspan="10" style="text-align: center; vertical-align: middle; font-size: 14pt;">THỐNG KÊ CHỈ TIÊU</th>
                    <th colspan="4" style="text-align: center; vertical-align: middle;"></th>
                </tr>
                <tr>
                    <th colspan="3" style="text-align: center; vertical-align: top; height: 20px; font-weight: bold;">'||upper(vTenPhongban)||'</th>
                    <td colspan="10" style="text-align: center; vertical-align: top; font-style: italic;">Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||'</td>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-style: italic;"></td>
                </tr>
                <tr style="mso-yfti-irow:2; height:8.5pt; mso-height-rule:exactly">
                    <td colspan="17" style="padding:0cm 0cm 0cm 0cm;height:8.5pt;mso-height-rule: exactly">
                        <table cellpadding="0" cellspacing="0" align="left">
                            <tr style="height: 1pt; mso-height-rule: exactly">
                                <td style="width: 90px; height: 1px; mso-height-rule: exactly"></td>
                                <td style="border-top: 0px solid #000000;">
                                    <span style="color: #ffffff;">------------</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
             <tr style="">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;height: 100px;">STT</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">HỌ VÀ TÊN</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 12</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 01</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 02</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 03</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 04</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 05</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 06</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 07</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 08</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 09</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 10</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">THÁNG 11</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CỘNG</th>
            </tr>

           ');
            SELECT R_GDT_CHITIEU_01( row_number() over (order by ch.ID),ttv.ID,ttv.HOTEN,ldv.HOTEN,ldv.ID,
                                      NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NuLL
                                      ) 
                BULK COLLECT INTO v_table
                FROM GDTTT_CACVU_CAUHINH ch 
                INNER JOIN DM_CANBO ttv ON ttv.ID= ch.THAMTRAVIENID
                INNER JOIN DM_CANBO ldv ON ldv.ID= ch.LANHDAOID
                WHERE ttv.PHONGBANID=vPhongBanID and ch.PHONGBANID=vPhongBanID
                AND ((ch.LANHDAOID=vLanhDaoID AND vLanhDaoID !=0) OR vLanhDaoID=0);
       -------------------------------------------------- 
    FOR item IN (
        SELECT 
            T.STT, 
            T.CANBOID
        FROM  TABLE(v_table) T 
       ) LOOP
                -- Lấy tháng từ đến tháng đến
                SELECT to_number(to_char(vTuNgay, 'MM')) into v_month_tu FROM DUAL;
                SELECT to_number(to_char(vDenNgay, 'MM')) into v_month_den FROM DUAL;
                if (v_month_tu = 12) then
                    v_month_tu:= 1;
                end if;
                v_count :=0;
            FOR vmonth in v_month_tu..v_month_den 
                 LOOP
                   if (v_count = 0) then
                         -- Đẩy dữ liệu vào tháng 12 năm trước
                         if (to_number(to_char(vTuNgay, 'MM')) = 12) then
                            -- ngay dau tien cua thang
                            SELECT TRUNC (v_TuNgay, 'MONTH') into v_first_day FROM DUAL;
                            -- ngày cuối cùng của tháng 
                            SELECT TRUNC (LAST_DAY (v_TuNgay)) into v_last_day FROM DUAL;
                            Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                                Where v.TOAANID=vToaAnID 
                                    and v.PHONGBANID=vPhongBanID
                                    And v.THAMTRAVIENID=item.CANBOID
                                    And v.ngaytao <=v_DenNgay
                                    And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,v_first_day,v_last_day)>0 ;
                             -- án giam đốc đã xử trong thang 12--
                            Select Count(v.ID) into vCount2 From GDTTT_VUAN v
                                    Where v.TOAANID=vToaAnID
                                    and v.PHONGBANID=vPhongBanID 
                                    And v.THAMTRAVIENID=item.CANBOID
                                    And v.ngaytao <= v_DenNgay
                                    And ((EXISTS(select 'X' from gdttt_vuan_xetxugdttt where VUANID = v.ID and NGAYMOPT between v_first_day and v_last_day) 
                                                            AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                                    Or (ISRUTKN = 1 and NGAYRUTKN  between v_first_day and v_last_day)); 
                            v_table(item.STT).COLUMN_12:=vCount1+vCount2;
                         end if;

                        --Neu tu ngay la thang 12 thì tăng lên để lấy từ tháng 1
                         if (to_number(to_char(vTuNgay, 'MM')) = 12) then
                                -- ngay dau tien cua thang
                                v_TuNgay:=   ADD_MONTHS (vTuNgay, 1);
                                SELECT TRUNC (v_TuNgay, 'MONTH') into v_first_day FROM DUAL;
                                -- ngày cuối cùng của tháng 
                                SELECT TRUNC (LAST_DAY (v_TuNgay)) into v_last_day FROM DUAL;
                         else
                               -- ngay dau tien cua thang
                                SELECT TRUNC (vTuNgay, 'MONTH') into v_first_day FROM DUAL;
                                -- ngày cuối cùng của tháng 
                                SELECT TRUNC (LAST_DAY (vTuNgay)) into v_last_day FROM DUAL;
                          end if;
                    else
                      -- từ ngày tăng thêm v_count tháng
                        v_TuNgay:=   ADD_MONTHS (vTuNgay, v_count);
                       -- ngay dau tien cua thang
                        SELECT TRUNC (v_TuNgay, 'MONTH') into v_first_day FROM DUAL;
                        -- ngày cuối cùng của tháng 
                        SELECT TRUNC (LAST_DAY (v_TuNgay)) into v_last_day FROM DUAL;

                    end if;
                    -- Có tờ trình trong tháng
                    Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID 
                            and v.PHONGBANID=vPhongBanID
                            And v.THAMTRAVIENID=item.CANBOID
                            And v.ngaytao <=v_DenNgay
                            And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,v_first_day,v_last_day)>0 ;
                     -- án giam đốc đã xử trong thang--
                    Select Count(v.ID) into vCount2 From GDTTT_VUAN v
                            Where v.TOAANID=vToaAnID
                            and v.PHONGBANID=vPhongBanID 
                            And v.THAMTRAVIENID=item.CANBOID
                            And v.ngaytao <= v_DenNgay
                            And ((EXISTS(select 'X' from gdttt_vuan_xetxugdttt where VUANID = v.ID and NGAYMOPT between v_first_day and v_last_day) 
                                                    AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                            Or (ISRUTKN = 1 and NGAYRUTKN  between v_first_day and v_last_day)); 



                    -- Đẩy dữ liệu vào các cột khác trong tháng từ 1 den 11
                    if vmonth = 1 then
                        v_table(item.STT).COLUMN_1:=vCount1+vCount2;
                    elsif vmonth = 2 then
                        v_table(item.STT).COLUMN_2:=vCount1+vCount2;
                    elsif vmonth = 3 then
                        v_table(item.STT).COLUMN_3:=vCount1+vCount2;
                    elsif vmonth = 4 then
                        v_table(item.STT).COLUMN_4:=vCount1+vCount2;
                    elsif vmonth = 5 then
                        v_table(item.STT).COLUMN_5:=vCount1+vCount2;
                    elsif vmonth = 6 then
                        v_table(item.STT).COLUMN_6:=vCount1+vCount2;
                    elsif vmonth = 7 then
                        v_table(item.STT).COLUMN_7:=vCount1+vCount2;
                    elsif vmonth = 8 then
                        v_table(item.STT).COLUMN_8:=vCount1+vCount2;
                    elsif vmonth = 9 then
                        v_table(item.STT).COLUMN_9:=vCount1+vCount2;
                    elsif vmonth = 10 then
                        v_table(item.STT).COLUMN_10:=vCount1+vCount2;
                    elsif vmonth = 11 then
                        v_table(item.STT).COLUMN_11:=vCount1+vCount2;
                    end if;

                    v_count := v_count + 1;

               END LOOP;
                --cộng
                v_table(item.STT).COLUMN_13:= NVL(v_table(item.STT).COLUMN_1,0)+NVL(v_table(item.STT).COLUMN_2,0)+NVL(v_table(item.STT).COLUMN_3,0)
                                        +NVL(v_table(item.STT).COLUMN_4,0)+NVL(v_table(item.STT).COLUMN_5,0)+NVL(v_table(item.STT).COLUMN_6,0)
                                        + NVL(v_table(item.STT).COLUMN_7,0)+NVL(v_table(item.STT).COLUMN_8,0)+NVL(v_table(item.STT).COLUMN_9,0) 
                                        + NVL(v_table(item.STT).COLUMN_10,0)+NVL(v_table(item.STT).COLUMN_11,0)+NVL(v_table(item.STT).COLUMN_12,0);
     END LOOP;
     --in lãnh đạo
      FOR item_ld IN (
                     SELECT JM.LANHDAOID,JM.TENLANHDAO,SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12 
                     ,SUM(JM.COLUMN_13) COLUMN_13
                     FROM TABLE(v_table) JM
                     GROUP BY JM.LANHDAOID,JM.TENLANHDAO 
                     ORDER BY JM.TENLANHDAO
                )
      LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:5px; font-weight:bold;" colspan="2">'||item_ld.TENLANHDAO||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"></td>

                </tr>
       ');
       --in thẩm tra viên
       v_dem:=0;
           FOR item_ttv IN (
           SELECT JM.* FROM TABLE(v_table) JM
                        WHERE JM.LANHDAOID=item_ld.LANHDAOID 
                        ORDER BY JM.HOTEN
           )
         LOOP
           v_dem:=v_dem+1;
           DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <tr>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||v_dem||'</td>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:5px;">'||item_ttv.HOTEN||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_12||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_1||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_2||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_3||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_4||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_5||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_6||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_7||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_8||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_9||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_10||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_11||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ttv.COLUMN_13||'</td>

                </tr>
       ');
         END LOOP;
      END LOOP;
      ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                     ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                     FROM TABLE(v_table) JM
                )
      LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:2px; font-weight:bold;height:30px;" colspan="2">Cộng</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_12||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_1||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_10||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_11||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_13||'</td>

                </tr>
       ');
      END LOOP;

     Select Count(v.ID) into vCount From GDTTT_VUAN v
                        Where v.TOAANID=vToaAnID
                        and v.PHONGBANID=vPhongBanID 
                        And v.ngaytao <= v_DenNgay
                        And ISRUTKN = 1 
                        and NGAYRUTKN  between v_TuNgay and v_DenNgay;
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                    <th colspan="14" style="text-align: left; vertical-align: middle; height: 20px;"><i>Ghi chú: Có '||vCount||' vụ Rút kháng nghị trong kỳ thống kê</i></th>
                </tr>');
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 47px"></td>
                <td style="width: 180px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>

            </tr>
   </table>
    ');  
    --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
 --------------------------------      
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC12;

FUNCTION GDTTTT_VUAN_SEARCH_BC14
( 
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
     V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_15; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number;
    v_DenNgay date;
    v_TuNgay date;
    v_TenPhongban varchar2(100);
    v_TenLoaian  varchar2(100);
    v_TenToaAn   varchar2(100);
    v_itemDV T_BC_VGDKT_15;
BEGIN
    if (vPhongBanID >0) then
        select TENPHONGBAN into v_TenPhongban from  DM_PHONGBAN where id = vPhongBanID;
    end if;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;

     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_BC_VGDKT_15();
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <th colspan="3" style="text-align: center; vertical-align: middle; height: 25px;">TÒA ÁN NHÂN DÂN TỐI CAO
                    </th>
                    <th colspan="21" style="text-align: center; vertical-align: middle; font-size: 14pt;">THỐNG KÊ THỤ LÝ VÀ GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GIÁM ĐỐC THẨM TÁI THẨM</th>

                </tr>
                <tr>
                    <th colspan="3" style="text-align: center; vertical-align: top; height: 20px; font-weight: bold;">'||upper(v_TenPhongban)||'</th>
                    <td colspan="21" style="text-align: center; vertical-align: top; font-style: italic;">Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||'</td>

                </tr>
                <tr style="mso-yfti-irow:2; height:8.5pt; mso-height-rule:exactly">
                    <td colspan="24" style="padding:0cm 0cm 0cm 0cm;height:8.5pt;mso-height-rule: exactly">
                        <table cellpadding="0" cellspacing="0" align="left">
                            <tr style="height: 1pt; mso-height-rule: exactly">
                                <td style="width: 90px; height: 1px; mso-height-rule: exactly"></td>
                                <td style="border-top: 0px solid #000000;">
                                    <span style="color: #ffffff;">------------</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
             <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">LOẠI ÁN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Đơn vị</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 28px;" colspan="3">Tổng số đơn đã nhận</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="4">Số đơn thuộc thẩm quyền phải giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="6">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Còn lại</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Đã trình</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Còn lại đang nghiên cứu</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">Đang rút hồ sơ</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;" rowspan="2">Tổng số</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đơn không thuộc thẩm quyền hoặc trùng lặp</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đơn còn lại chưa xử lý</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Cũ còn lại</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Mới thụ lý</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" height:100px; colspan="2">Tổng số</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" height:100px; colspan="2">Trả lời đơn</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" height:100px; colspan="2">Kháng nghị</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Xử lý khác</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;"rowspan="2">Cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;"rowspan="2">Tổng số</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;"rowspan="2">Có kiến kiến của Đại biểu QH, Đoàn ĐBQH</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;></td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;>Cộng</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Có kiến kiến của Đại biểu QH, Đoàn ĐBQH </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Có kiến kiến của Đại biểu QH, Đoàn ĐBQH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Có kiến kiến của Đại biểu QH, Đoàn ĐBQH</td> 
            </tr>
           ');
--           select v.LOAIAN,d.donvi from gdttt_vuan v 
--                INNER JOIN (select dv.id,decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) donvi from gdttt_vuan dv where decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) in (4,5,6,7) 
--                            And dv.PhongBanID = 4) d 
--                    on d.id = v.id
--                    group by v.LOAIAN,d.donvi
--                    order by v.LOAIAN;

            SELECT R_BC_VGDKT_15(row_number() over (order by v.loaian),v.Loaian,d.donvi,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                      NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                                      ) 
                BULK COLLECT INTO v_table
                    from gdttt_vuan v 
                            INNER JOIN (select dv.id,decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) donvi from gdttt_vuan dv where decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) in (4,5,6,7) 
                                        And dv.PhongBanID = vPhongBanID) d 
                                on d.id = v.id
                                group by v.LOAIAN,d.donvi
                                order by v.LOAIAN;
                    --from gdttt_vuan v where v.PhongBanID = vPhongBanID group by v.loaian;
       ------------------------------------------------ 
        FOR item IN (
            SELECT T.STT, T.LOAIAN,T.COLUMN_1 DONVI
            FROM  TABLE(v_table) T 
           ) LOOP

               --Cot 2 Tổng số = thụ lý mới + đã thụ lý
                  Select sum(dc.SOLUONGDON) into vCount1
                    from GDTTT_DON_CHUYEN dc
                         inner join GDTTT_DON d on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And ((item.DONVI != 7 
                                and Exists (Select 'X' from GDTTT_DON d1 where 
                                                            decode(d1.BAQD_CAPXETXU,4,d1.BAQD_TOAANID,3,d1.BAQD_TOAANID_PT,2,d1.BAQD_TOAANID_ST,d1.BAQD_TOAANID_PT)= item.DONVI
                                                            and d1.id = dc.DONID)
                                    )
                            Or (item.DONVI = 7 and Exists (Select 'X' from GDTTT_DON d1 where 
                                                            decode(d1.BAQD_CAPXETXU,4,d1.BAQD_TOAANID,3,d1.BAQD_TOAANID_PT,2,d1.BAQD_TOAANID_ST,d1.BAQD_TOAANID_PT) not in (4,5,6)
                                                            and d1.id = dc.DONID)
                                )
                            )
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay;
                     v_table(item.STT).COLUMN_2:=vCount1;
               --Cot 3 Đơn không thuộc thẩm quyền hoặc trùng lặp
               -- 3.1 Không thuộc thẩm quyền  = số đơn bị trả lại
              Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 3
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And ((item.DONVI != 7 and decode(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,2,d.BAQD_TOAANID_ST,d.BAQD_TOAANID_PT) = item.DONVI)
                            Or (item.DONVI = 7 and decode(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,2,d.BAQD_TOAANID_ST,d.BAQD_TOAANID_PT) not in (4,5,6)))
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay
                        And upper(dc.GHICHU) like '%KHÔNG THUỘC THẨM QUYỀN%' ;
                -- 3.2 Đơn trùng lặp = số đơn trùng đã nhận                        
                Select sum(dc.SOLUONGDON) into vCount2
                    from GDTTT_DON_CHUYEN dc
                         inner join GDTTT_DON d on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And ((item.DONVI != 7 
                                and Exists (Select 'X' from GDTTT_DON d1 where 
                                                            decode(d1.BAQD_CAPXETXU,4,d1.BAQD_TOAANID,3,d1.BAQD_TOAANID_PT,2,d1.BAQD_TOAANID_ST,d1.BAQD_TOAANID_PT)= item.DONVI
                                                            and d1.id = dc.DONID)
                                    )
                            Or (item.DONVI = 7 and Exists (Select 'X' from GDTTT_DON d1 where 
                                                            decode(d1.BAQD_CAPXETXU,4,d1.BAQD_TOAANID,3,d1.BAQD_TOAANID_PT,2,d1.BAQD_TOAANID_ST,d1.BAQD_TOAANID_PT) not in (4,5,6)
                                                            and d1.id = dc.DONID)
                                )
                            )
                        And Exists (Select 'X' from GDTTT_DON d2 where d2.isthuly = 2 and d2.id = dc.DONID )
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay;

                     v_table(item.STT).COLUMN_3:=vCount1 + vCount2;
               --Cot 4 Đơn còn lại chưa xử lý
               Select Count(d.ID) into vCount1
                    from GDTTT_DON d
                         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID 
                    Where d.CD_TRANGTHAI = 2
                        And d.CD_TA_DONVIID = vPhongBanID
                        And d.BAQD_LOAIAN = item.LOAIAN
                        And ((item.DONVI != 7 and decode(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,2,d.BAQD_TOAANID_ST,d.BAQD_TOAANID_PT) = item.DONVI)
                            Or (item.DONVI = 7 and decode(d.BAQD_CAPXETXU,4,d.BAQD_TOAANID,3,d.BAQD_TOAANID_PT,2,d.BAQD_TOAANID_ST,d.BAQD_TOAANID_PT) not in (4,5,6)))
                        And (NVL(d.ISThuLy, 0)=1 
                            Or (NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1 and Count_DonID_TLMoiChuyenCung(d.ID)>0) ) 
                        And  v_TuNgay <= dc.NGAYNHAN 
                        And dc.NGAYNHAN <= v_DenNgay
                        And NVL(d.vuviecid,0) = 0;
                        -- = 0 do đơn đã nhận thì mặc định là đã xử lý
                 v_table(item.STT).COLUMN_4:=0;       
               --Cot 5 Cũ còn lại phải giải quyết
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And v.GDQ_NGAY>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao < v_TuNgay;
                v_table(item.STT).COLUMN_5:=vCount1;
               --Cot 6 Mới thụ lý Phải giải quyết
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And NVL(v.ISVIENTRUONGKN,0) != 1
                    And v.ngaytao between v_TuNgay And v_DenNgay;
                v_table(item.STT).COLUMN_6:=vCount1;
               --Cot 7 Cộng - Tổng số
                v_table(item.STT).COLUMN_7:=NVL(v_table(item.STT).COLUMN_5,0) + NVL(v_table(item.STT).COLUMN_6,0);
               --Cột 8 Có kiến nghị của ĐBQH - Tổng số
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                     And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And v.GDQ_NGAY>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) != 1
                    And v.ngaytao < v_TuNgay
                    And  EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) ;
                Select Count(v.ID) into vCount2 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And NVL(v.ISVIENTRUONGKN,0) != 1
                    And v.ngaytao between v_TuNgay And v_DenNgay
                    And  EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) ;
                  v_table(item.STT).COLUMN_8:=vCount1+vCount2;              
               --Cột 9 Tổng số - Trả lời đơn
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA = 0 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_9:=vCount1;          
               --Cột 10 Có kiến nghị - Trả lời đơn
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA = 0 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao <= v_DenNgay
                    And  EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) ;
                 v_table(item.STT).COLUMN_10:=vCount1; 
               --Cột 11 Tổng số - Kháng nghị
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA = 1 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_11:=vCount1;  
               --Cột 12 Có kiến nghị - Kháng nghị
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA = 1 And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao <= v_DenNgay
                    And  EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) ;
                 v_table(item.STT).COLUMN_12:=vCount1; 
               --Cột 13 Xử lý khác
               Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (2,3,4)  
                    And ((v.GDQ_NGAY is not null and v.GDQ_NGAY between v_TuNgay And v_DenNgay) 
                            Or (v.GQD_NGAYPHATHANHCV  is not null and v.GQD_NGAYPHATHANHCV between v_TuNgay And v_DenNgay) )
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao <= v_DenNgay;

                 v_table(item.STT).COLUMN_13:=vCount1;  
               --Cột 14 Cộng
                v_table(item.STT).COLUMN_14:=NVL(v_table(item.STT).COLUMN_9,0) +NVL(v_table(item.STT).COLUMN_11,0) +NVL(v_table(item.STT).COLUMN_13,0); 
               --Cột 15 Tổng số - Còn lại
               v_table(item.STT).COLUMN_15:= NVL(v_table(item.STT).COLUMN_7,0) - NVL(v_table(item.STT).COLUMN_14,0);

                -- có kiến nghị - của giải quyết khác
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA in (2,3,4)  And v.GDQ_NGAY between v_TuNgay And v_DenNgay)
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And v.ngaytao <= v_DenNgay
                    And  EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) ;
               --Cột 16 Có kiến nghị - Còn lại
               v_table(item.STT).COLUMN_16:= NVL(v_table(item.STT).COLUMN_8,0) - NVL(v_table(item.STT).COLUMN_10,0) - NVL(v_table(item.STT).COLUMN_12,0) - vCount1;
               --Cột 17 Đã trình
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA in (0,1,2,3,4)  And v.GDQ_NGAY > v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,v_TuNgay,v_DenNgay)>0 
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_17:=vCount1;  
               --Cột 18 Còn lại đang nghiên cứu
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA in (0,1,2,3,4)  And v.GDQ_NGAY > v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,v_TuNgay,v_DenNgay) = 0 
                    And EXISTS (select 'X' from GDTTT_QUANLYHS where v.ID = VUANID and NGAYTAO is not null And LOAI = 3  And NGAYTAO <= v_DenNgay) 
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_18:=vCount1;
               --Cột 19 Đang rút hồ sơ = Chưa có hồ sơ
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA in (0,1,2,3,4)  And v.GDQ_NGAY > v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And PKG_GDTTT_BAOCAO_APP.GDTTT_QLTOTRINH_CHECKFIRSTTT(v.ID,v_TuNgay,v_DenNgay)=0 
                    And NOT EXISTS (select 'X' from GDTTT_QUANLYHS where v.ID = VUANID and NGAYTAO is not null And LOAI = 3 And NGAYTAO <= v_DenNgay)
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_19:=vCount1;

        END LOOP;
    --in thẩm tra viên

        FOR item_loaian IN (
           SELECT JM.Loaian FROM TABLE(v_table) JM
                            GROUP BY JM.Loaian
                            ORDER BY JM.Loaian
               )
             LOOP
               -- Lấy ra tên loại án
             select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'HNGD',4,'KDTM',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;

            -- in theo Đơn vị 4: CC HN; 5: CC DN; 6: CC HCM; 7 khác
            FOR item_DV IN (
                   SELECT DV.* FROM TABLE(v_table) DV WHERE DV.LOAIAN = item_loaian.LOAIAN
                                    ORDER BY DV.COLUMN_1)
            LOOP
                if (item_DV.COLUMN_1 = 4) then
                    v_TenToaAn:='TACC HN';
                elsif (item_DV.COLUMN_1 = 5) then
                    v_TenToaAn:='TACC ĐN';
                elsif (item_DV.COLUMN_1 = 6) then
                    v_TenToaAn:='TACC HCM';
                else
                    v_TenToaAn:='ĐƠN VỊ KHÁC';
                end if;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>');
                 if (item_DV.COLUMN_1 = 4) then
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:5px;" rowspan="5">'||v_TenLoaian||'</td>');
                 end if;

                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;">'||v_TenToaAn||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_2||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_3||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_4||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_5||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_6||'</td>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_7||'</th>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_8||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_9||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_10||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_11||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_12||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_13||'</td>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_14||'</th>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_15||'</th>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_16||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_17||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_18||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_19||'</td>
                   ');

                DBMS_LOB.APPEND(V_EXPORT_TEXT,'</tr>');
            END LOOP;
        -- Tổng theo Loai An
            FOR count_loaian IN (
                         SELECT SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                         SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                         SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                         ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                         ,SUM(JM.COLUMN_16) COLUMN_16,SUM(JM.COLUMN_17) COLUMN_17,SUM(JM.COLUMN_18) COLUMN_18,SUM(JM.COLUMN_19) COLUMN_19
                         FROM TABLE(v_table) JM where JM.Loaian = item_loaian.Loaian
                        )
                LOOP
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                   <tr>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: left;padding:2px; height:20px;">Cộng</td>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_2||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_3||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_4||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_5||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_6||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_7||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_8||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_9||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_10||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_11||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_12||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_13||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_14||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_15||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_16||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_17||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_18||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_19||'</th>
                        </tr>
               ');
            END LOOP;

      END LOOP;
      ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                     ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                     ,SUM(JM.COLUMN_16) COLUMN_16,SUM(JM.COLUMN_17) COLUMN_17,SUM(JM.COLUMN_18) COLUMN_18,SUM(JM.COLUMN_19) COLUMN_19
                     FROM TABLE(v_table) JM
                )
      LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;padding:2px;height:20px;" colspan="2">Cộng</td>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_10||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_11||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_12||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_13||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_14||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_15||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_16||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_17||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_18||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_19||'</th>
                </tr>
       ');
      END LOOP;

    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="text-align: left;">
                    <td colspan="13" >
                        <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: left; border-collapse: collapse;">
                            <tr style="text-align: center;">
                            <th colspan="2"  style="text-align: left; vertical-align: middle; height: 20px;">Đã trình và phát hành:</th>
                            <td></td>
                            </tr>');
     ---Đã trình và phát hành  = đã có KQ + đa trình từ TP trở lên       
    FOR item_loaian IN (
           SELECT JM.Loaian FROM TABLE(v_table) JM
                            GROUP BY JM.Loaian
                            ORDER BY JM.Loaian
               )
             LOOP
        -- Lấy ra tên loại án
             select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'Hôn nhân và Gia đình',4,'Kinh doanh thương mại',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;
        -- Lấy ra tỷ lệ = (Cộng (đã giải quyết) + Còn lại Đang trình) / Tổng số phải giải quyết * 100%
         FOR count_loaian IN (
                         SELECT SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_14) COLUMN_14, SUM(JM.COLUMN_17) COLUMN_17
                         FROM TABLE(v_table) JM where JM.Loaian = item_loaian.Loaian
                        )
                LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                        <td colspan="2"  style="text-align: right; vertical-align: middle; height: 20px;"> - '||v_TenLoaian||': </td>
                        <td style="text-align: left; vertical-align: middle; height: 20px;"> '|| TRUNC(((count_loaian.COLUMN_17 + count_loaian.COLUMN_14)/count_loaian.COLUMN_7)*100,2)||'% </td>
                    </tr>'); 
          END LOOP;          
    END LOOP;
    -- Trung bình 
    FOR count_loaian IN (
                         SELECT SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_14) COLUMN_14, SUM(JM.COLUMN_17) COLUMN_17
                         FROM TABLE(v_table) JM
                        )
                LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                        <td colspan="2"  style="text-align: right; vertical-align: middle; height: 20px;"> - Trung bình: </td>
                        <td style="text-align: left; vertical-align: middle; height: 20px;"> '|| TRUNC(((count_loaian.COLUMN_17 + count_loaian.COLUMN_14)/count_loaian.COLUMN_7)*100,2)||'% </td>
                    </tr>');
    END LOOP;
    -- Đã giải quyết dứt điểm (Phát hành) = Đã có KQ
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                        <th colspan="2" style="text-align: left; vertical-align: middle; height: 20px;">Đã giải quyết dứt điểm (Phát hành): </th> 
                        <td></td>
                </tr>');
    FOR item_loaian IN (
           SELECT JM.Loaian FROM TABLE(v_table) JM
                            GROUP BY JM.Loaian
                            ORDER BY JM.Loaian
               )
             LOOP
               -- Lấy ra tên loại án
             select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'Hôn nhân và Gia đình',4,'Kinh doanh thương mại',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;
         -- Lấy ra tỷ lệ
         FOR count_loaian IN (
                         SELECT SUM(JM.COLUMN_14) COLUMN_14, SUM(JM.COLUMN_7) COLUMN_7
                         FROM TABLE(v_table) JM where JM.Loaian = item_loaian.Loaian
                        )
                LOOP
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                            <td colspan="2" style="text-align: right; vertical-align: middle; height: 20px;"> - '||v_TenLoaian||': </td>
                            <td style="text-align: left; vertical-align: middle; height: 20px;"> '|| TRUNC((count_loaian.COLUMN_14/count_loaian.COLUMN_7)*100,2)||'% </td>
                        </tr>'); 
          END LOOP;     
    END LOOP;
         -- Trung bình 
    FOR count_loaian IN (
                         SELECT SUM(JM.COLUMN_14) COLUMN_14, SUM(JM.COLUMN_7) COLUMN_7
                         FROM TABLE(v_table) JM
                        )
                LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
                        <td colspan="2" style="text-align: right; vertical-align: middle; height: 20px;"> - Trung bình: </td>
                        <td style="text-align: left; vertical-align: middle; height: 20px;"> '|| TRUNC((count_loaian.COLUMN_14/count_loaian.COLUMN_7)*100,2)||'% </td>
                    </tr>');
    END LOOP;            


    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        </table>
                    </td>');
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'                  
                    <td colspan="8" style="vertical-align: top;">
                         <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;vertical-align: top;">
                            <tr style="text-align: center;">
                            <td style="text-align: center; vertical-align: middle; height: 20px;"><i>Hà Nội, ngày<span style="color:#ffffff;">......</span>tháng<span style="color:#ffffff;">......</span>năm '||to_char(sysdate, 'yyyy')||'</i></td>
                            </tr><tr style="text-align: center;">
                            <th style="text-align: center; vertical-align: middle; height: 20px;">KT.VỤ TRƯỞNG</th>
                            </tr><tr style="text-align: center;">
                            <th style="text-align: center; vertical-align: middle; height: 20px;">PHÓ VỤ TRƯỞNG</th>
                            </tr>
                        </table>
                    </td>
                </tr>');



    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 70px"></td>
                <td style="width: 180px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>

            </tr>
   </table>
    ');  

 --------------------------------


      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC14;
FUNCTION GDTTTT_VUAN_SEARCH_BC15
( 
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date,
    vLanhDaoID number
)
RETURN SYS_REFCURSOR
IS 
   V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_15; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number;
    v_DenNgay date;
    v_TuNgay date;
    v_TenPhongban varchar2(100);
    v_TenLoaian  varchar2(100);
BEGIN
    if (vPhongBanID >0) then
        select TENPHONGBAN into v_TenPhongban from  DM_PHONGBAN where id = vPhongBanID;
    end if;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;

     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_BC_VGDKT_15();
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <th colspan="3" style="text-align: center; vertical-align: middle; height: 25px;">TÒA ÁN NHÂN DÂN TỐI CAO
                    </th>
                    <th colspan="21" style="text-align: center; vertical-align: middle; font-size: 14pt;">THỐNG KÊ THỤ LÝ, XÉT XỬ GĐT,TT CỦA HỘI ĐỒNG THẨM PHÁN</th>

                </tr>
                <tr>
                    <th colspan="3" style="text-align: center; vertical-align: top; height: 20px; font-weight: bold;">'||upper(v_TenPhongban)||'</th>
                    <td colspan="21" style="text-align: center; vertical-align: top; font-style: italic;">Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||'</td>

                </tr>
                <tr style="mso-yfti-irow:2; height:8.5pt; mso-height-rule:exactly">
                    <td colspan="24" style="padding:0cm 0cm 0cm 0cm;height:8.5pt;mso-height-rule: exactly">
                        <table cellpadding="0" cellspacing="0" align="left">
                            <tr style="height: 1pt; mso-height-rule: exactly">
                                <td style="width: 90px; height: 1px; mso-height-rule: exactly"></td>
                                <td style="border-top: 0px solid #000000;">
                                    <span style="color: #ffffff;">------------</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
             <tr style="">
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">LOẠI ÁN</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 28px;" colspan="2">CŨ CÒN LẠI</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">THỤ LÝ MỚI</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">TỔNG SỐ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">RÚT KHÁNG NGHỊ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">ĐÃ XỬ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">CÒN LẠI</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="9">KẾT QUẢ XÉT XỬ</th>
                <th style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">KHÔNG CHẤP NHẬN KHÁNG NGHỊ</th>
            </tr>
            <tr style="">
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;">CA KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CA KN </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CA KN </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CA KN </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CA KN </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CA KN </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>

                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy bản án, quyết định phúc thẩm, giữ nguyên bản án, quyết định sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy quyết định của giám đốc thẩm,bản án quyết định phúc thẩm,giữ nguyên bản án,quyết định sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Hủy bản án, quyết định có hiệu lực pháp luật và đình chỉ giải quyết vụ án</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Sửa toàn bộ bản án, quyết định của Tòa án đã có hiệu lực pháp luật</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Sửa một phần bản án, quyết định của Tòa án đã có hiệu lực pháp luật</td>

                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CA KN </td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">VT KN</td>

            </tr>
           ');
            SELECT R_BC_VGDKT_15(row_number() over (order by v.loaian),v.loaian,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                      NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                                      ) 
                BULK COLLECT INTO v_table
                    from gdttt_vuan v where v.PhongBanID = vPhongBanID group by v.loaian;

       ------------------------------------------------ 
    FOR item IN (
        SELECT  
            T.STT,T.LOAIAN
        FROM  TABLE(v_table) T 
       ) LOOP

                --Cot 1 Cũ con lai CA KN
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT < v_TuNgay)
                    And (NVL(v.XXGDTTT_ISKETQUA,0) = 0
                        Or (NVL(v.XXGDTTT_ISKETQUA,0)>0 and v.NGAYTHULYXXGDT is not null and v.NGAYTHULYXXGDT >= v_TuNgay) )
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0; -- CAKN
                    --And v.ngaytao < v_TuNgay;

               v_table(item.STT).COLUMN_1:=vCount1;

                --Cot 2  Cũ con lai VT KN
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT < v_TuNgay)
                    and (NVL(v.XXGDTTT_ISKETQUA,0)=0
                        Or(NVL(v.XXGDTTT_ISKETQUA,0)>0 and v.NGAYTHULYXXGDT is not null and  v.NGAYTHULYXXGDT >= v_TuNgay)) 
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 1; -- VTKN
                    --And v.ngaytao <v_TuNgay;

                 v_table(item.STT).COLUMN_2:=vCount1;

                --Cot 3 Thu ly moi CA KN-- 
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and (v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay))
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0 -- CAKN
                    And v.ngaytao <= v_DenNgay;
                v_table(item.STT).COLUMN_3:=vCount1;

                --Cot 4 Thu ly moi VT KN--
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT between v_TuNgay and v_DenNgay)
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 1 -- VTKN
                    And v.ngaytao <= v_DenNgay;
                v_table(item.STT).COLUMN_4:=vCount1; 

                 -- cot 5 Tổng số CA KN
                v_table(item.STT).COLUMN_5:= NVL(v_table(item.STT).COLUMN_1,0) + NVL(v_table(item.STT).COLUMN_3,0); 
                -- Cột 6 Tổng số VT KN
                v_table(item.STT).COLUMN_6:= NVL(v_table(item.STT).COLUMN_2,0) + NVL(v_table(item.STT).COLUMN_4,0); 

                --Cot 7 Rut KN của  CA KN--  
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT <=v_DenNgay)
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0 -- CAKN
                    and NVL(v.IsRutKN,0) =1
                    and v.NGAYRUTKN between v_TuNgay and v_DenNgay
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_7:=vCount1;  

                  --Cot 8 Rut KN của  VT KN--  
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001') and v.NGAYTHULYXXGDT <= v_DenNgay)
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 1 -- VTKN
                    and NVL(v.IsRutKN,0) =1
                    and v.NGAYRUTKN between v_TuNgay and v_DenNgay
                    And v.ngaytao <= v_DenNgay;

                 v_table(item.STT).COLUMN_8:=vCount1; 

                 --Cot 9 CA KN đã xử
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0 -- CAKN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_9:=vCount1; 

                 --Cot 10 VT KN đã xử
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 1 -- VT KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_10:=vCount1; 

                 --Cot 11 CA KN Còn lại
                v_table(item.STT).COLUMN_11:=NVL(v_table(item.STT).COLUMN_5,0) - NVL(v_table(item.STT).COLUMN_7,0) - NVL(v_table(item.STT).COLUMN_9,0); 

                 --Cot 12 VT KN Còn lại
                v_table(item.STT).COLUMN_12:=NVL(v_table(item.STT).COLUMN_6,0) - NVL(v_table(item.STT).COLUMN_8,0) - NVL(v_table(item.STT).COLUMN_10,0); 

                 -- Cot 13 Giao ST lại <=> Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục sơ thẩm
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID in (1327,1377,1371,1374)
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_13:=vCount1; 
                 -- Cot 14 Giao PT lại <=> Hủy bản án, quyết định có hiệu lực pháp luật để xét xử lại theo thủ tục phúc thẩm
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID in (1328,1370,1372)
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_14:=vCount1;
                 -- COt 15 Hủy bản án, quyết định phúc thẩm, giữ nguyên bản án, quyết định sơ thẩm
                 Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID in (1323,1373)

                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_15:=vCount1;
                 -- COt 16 Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định sơ thẩm 
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID = 1324
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_16:=vCount1;
                 -- COt 17 Hủy quyết định giám đốc thẩm, giữ nguyên bản án, quyết định phúc thẩm 
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID in (1325,1369)
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_17:=0;

                 -- COt 18 Hủy quyết định của giám đốc thẩm,bản án quyết định phúc thẩm,giữ nguyên bản án,quyết định sơ thẩm 
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID = 1326
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_18:=vCount1;

                  -- COt 19 Hủy bản án, quyết định có hiệu lực pháp luật và đình chỉ giải quyết vụ án 
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID = 1322
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_19:=vCount1;

                -- COt 20 Sửa toàn bộ bản án, quyết định của Tòa án đã có hiệu lực pháp luật 
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID in (1319,1376)
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_20:=vCount1;

                  -- COt 21 Sửa một phần bản án, quyết định của Tòa án đã có hiệu lực pháp luật 1330
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID = 1330
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_21:=vCount1;



                 -- COt 22 CA Không chấp nhận KN 
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 0 -- CAKN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID = 1318
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_22:=vCount1;

                 -- COt 23 VT Không chấp nhận KN 
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID 
                    And v.LOAIAN=item.LOAIAN
                    And v.GQD_LOAIKETQUA = 1 -- KN
                    And NVL(v.ISVIENTRUONGKN,0) = 1 -- CAKN
                    And EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and NGAYMOPT between v_TuNgay and v_DenNgay) 
                    And v.XXGDTTT_KETQUAID = 1318
                    And v.ngaytao <= v_DenNgay;
                 v_table(item.STT).COLUMN_23:=vCount1;


     END LOOP;
    --in thẩm tra viên

    FOR item_loaian IN (
           SELECT JM.* FROM TABLE(v_table) JM
                        ORDER BY JM.Loaian
           )
         LOOP
           -- Lấy ra tên loại án
           select  DECODE(item_loaian.Loaian,1,'Hình sự',2,'Dân sự',3,'HNGD',4,'KDTM',5,'Lao động',6,'Hành chính') into v_TenLoaian from dual;

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr> 
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:5px;">'||v_TenLoaian||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_1||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_2||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_3||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_4||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_5||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_6||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_7||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_8||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_9||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_10||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_11||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_12||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_13||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_14||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_15||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_16||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_17||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_18||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_19||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_20||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_21||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_22||'</td>
                    <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_loaian.COLUMN_23||'</td>
                </tr>
       ');

      END LOOP;
      ---in tong cong 
      FOR item_ld IN (
                     SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                     SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                     SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                     ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                     ,SUM(JM.COLUMN_16) COLUMN_16,SUM(JM.COLUMN_17) COLUMN_17,SUM(JM.COLUMN_18) COLUMN_18
                     ,SUM(JM.COLUMN_19) COLUMN_19,SUM(JM.COLUMN_20) COLUMN_20,SUM(JM.COLUMN_21) COLUMN_21,SUM(JM.COLUMN_22) COLUMN_22,SUM(JM.COLUMN_23) COLUMN_23
                     FROM TABLE(v_table) JM
                )
      LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <tr>
                    <td style="border: 1pt solid Black; text-align: left; vertical-align: middle;padding:2px; font-weight:bold;height:30px;">Cộng</td>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_1||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_2||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_3||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_4||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_5||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_6||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_7||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_8||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_9||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_10||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_11||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_12||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_13||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_14||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_15||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_16||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_17||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_18||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_19||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_20||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_21||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_22||'</th>
                    <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_ld.COLUMN_23||'</th>
                </tr>
       ');
      END LOOP;

--    DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>
--                    <th colspan="22" style="text-align: left; vertical-align: middle; height: 20px;"><i>Ghi chú: Có '||vCount||' vụ Rút kháng nghị trong kỳ thống kê</i></th>
--                </tr>');
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">
                <td style="width: 180px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
            </tr>
   </table>
    ');
     --------------------------------    
   DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                 <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 14pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td style="vertical-align: top;text-align:left;font-size: 10pt;"> NLBC:'||TO_CHAR(sysdate,'dd/MM/yyyy HH24:MI:SS')||'</td>
                        <td>
                        </td>
                    </tr>
                </table>
                    ');   
     OPEN v_cursor FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN v_cursor;   
END GDTTTT_VUAN_SEARCH_BC15;


FUNCTION GDTTTT_VUAN_SEARCH_BC16
( 
    vToaAnID in number,
    vPhongBanID  in number,
    vTuNgay in date,
    vDenNgay in date
)
RETURN SYS_REFCURSOR
IS 
     V_CURSOR sys_refcursor;
    v_table T_BC_VGDKT_15; V_EXPORT_TEXT CLOB; v_dem NUMBER:=0;
    vCount number; vCount1 number; vCount2 number;
    v_DenNgay date;
    v_TuNgay date;
    v_TenPhongban varchar2(100);
    v_TenLoaian  varchar2(100);
    v_TenToaAn   varchar2(100);
    v_itemDV T_BC_VGDKT_15;
BEGIN
    if (vPhongBanID >0) then
        select TENPHONGBAN into v_TenPhongban from  DM_PHONGBAN where id = vPhongBanID;
    end if;
    SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into v_DenNgay from dual;
    SELECT DECODE(vTuNgay,null,null,to_date(to_char(vTuNgay,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy HH24:MI:SS')) into v_TuNgay from dual;

     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
      v_table := T_BC_VGDKT_15();
     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                <tr style="text-align: center;">
                    <th colspan="5" style="text-align: center; vertical-align: middle; height: 25px;">TÒA ÁN NHÂN DÂN TỐI CAO
                    </th>
                    <th colspan="16" style="text-align: center; vertical-align: middle; font-size: 14pt;">THỐNG KÊ TÌNH HÌNH THỤ LÝ VÀ GIẢI QUYẾT ÁN QUỐC HỘI</th>

                </tr>
                <tr>
                    <th colspan="5" style="text-align: center; vertical-align: top; height: 20px; font-weight: bold;">'||upper(v_TenPhongban)||'</th>
                    <td colspan="16" style="text-align: center; vertical-align: top; font-style: italic;">Từ ngày '||TO_CHAR(vTuNgay,'dd/MM/yyyy')||' - Đến ngày '||TO_CHAR(vDenNgay,'dd/MM/yyyy')||'</td>

                </tr>
                <tr style="mso-yfti-irow:2; height:8.5pt; mso-height-rule:exactly">
                    <td colspan="21" style="padding:0cm 0cm 0cm 0cm;height:8.5pt;mso-height-rule: exactly">
                        <table cellpadding="0" cellspacing="0" align="left">
                            <tr style="height: 1pt; mso-height-rule: exactly">
                                <td style="width: 90px; height: 1px; mso-height-rule: exactly"></td>
                                <td style="border-top: 0px solid #000000;">
                                    <span style="color: #ffffff;">------------</span>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
             <tr>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">ĐƠN VỊ</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 28px;" colspan="5">SỐ ĐƠN THỤ LÝ</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">TRẢ LỜI ĐƠN</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">KHÁNG NGHỊ</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">CÒN LẠI</td>
            </tr>
            <tr>

                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;">TỔNG CỘNG</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ĐẠI BIỂU QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ỦY BAN TƯ PHÁP</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC CỦA QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC Ở TW</td>

                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;">TỔNG CỘNG</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ĐẠI BIỂU QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ỦY BAN TƯ PHÁP</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC CỦA QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC Ở TW</td>

                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;">TỔNG CỘNG</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ĐẠI BIỂU QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ỦY BAN TƯ PHÁP</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC CỦA QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC Ở TW</td>

                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 100px;">TỔNG CỘNG</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ĐẠI BIỂU QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">ỦY BAN TƯ PHÁP</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC CỦA QH</td>
                <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">CƠ QUAN KHÁC Ở TW</td>
            </tr>
           ');

            SELECT R_BC_VGDKT_15(row_number() over (order by d.donvi),d.donvi,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                                      NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
                                      ) 
                BULK COLLECT INTO v_table
                    from gdttt_vuan v 
                            INNER JOIN (select dv.id,decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) donvi from gdttt_vuan dv where decode(dv.BAQD_CAPXETXU,4,dv.TOAQDID,3,dv.TOAPHUCTHAMID,2,dv.TOAANSOTHAM,dv.TOAPHUCTHAMID) in (4,5,6,7) 
                                        And dv.PhongBanID = vPhongBanID) d 
                                on d.id = v.id
                                group by d.donvi
                                order by d.donvi;
                    --from gdttt_vuan v where v.PhongBanID = vPhongBanID group by v.loaian;


       ------------------------------------------------ 
        FOR item IN (
            SELECT T.STT, T.LOAIAN DONVI
            FROM  TABLE(v_table) T 
           ) LOOP

               --Cot 2 Tổng số = thụ lý mới + cũ con lai
                Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                     v_table(item.STT).COLUMN_1:=vCount1;
               --Cot 3 Đai Bieu QH
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) --- Đại biểu quốc hội
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_2:=vCount1;
                  --Cot 4 Ủy ban tư pháp
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) --- Ủy ban tư pháp 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_3:=vCount1; 
                --Cot 5 Co quan khác của QH
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_4:=vCount1;
                  --Cot 6 Co quan khác ở TW
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS>v_TuNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_5:=vCount1; 

                ---------Tra loi don = TLD + XĐ + XLK + VKS---------------------
                  --Cot 7 Tong cong
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (0,2,3,4) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)  
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_6:=vCount1;  

                   --Cot 8 Đại biểu QH
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (0,2,3,4) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_7:=vCount1;   
                 --Cot 9 Ủy Ban Tư pháp 
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (0,2,3,4) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_8:=vCount1;   

                  --Cot 10 Cơ quan khác của QH
                   Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (0,2,3,4) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_9:=vCount1;   
                  --Cot 11 CƠ quan khác ở TW
                   Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (0,2,3,4) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_10:=vCount1;   

                  --Cot 12 Tổng Kháng nghị
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA = 1 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)  
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_11:=vCount1;  
                  --Cot 13 Đại biểu QH
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (1) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_12:=vCount1;   
                  --Cot 14 Ủy ban tư pháp
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (1) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_13:=vCount1;   
                  --Cot 15 Cơ quan khác của QH 
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (1) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_14:=vCount1;
                  --Cot 16 CƠ quan khác ở TW
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And v.GQD_LOAIKETQUA in (1) 
                    And VA.GQD_NGACVS between v_TuNgay And v_DenNgay
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                      And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546) 
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID)   
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_15:=vCount1;

                  --Cot 17 Tong Con lai
                    Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS> v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_16:=vCount1; 
                  --Cot 18 Đại biểu QH
                  Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS> v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_17:=vCount1; 
                  --Cot 19 Ủy ban tư pháp
                       Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS> v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_18:=vCount1; 
                  --Cot 20 Cơ quan khác của QH 
                       Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS> v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_19:=vCount1; 
                  --Cot 21 CƠ quan khác ở TW
                       Select Count(v.ID) into vCount1 From GDTTT_VUAN v
                            LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
                    Where v.TOAANID=vToaAnID 
                    and v.PHONGBANID=vPhongBanID
                    And ((item.DONVI != 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) = item.DONVI)
                        Or (item.DONVI = 7 and decode(v.BAQD_CAPXETXU,4,TOAQDID,3,TOAPHUCTHAMID,2,TOAANSOTHAM,TOAPHUCTHAMID) not in (4,5,6)))
                    And (v.GQD_LOAIKETQUA is null Or (v.GQD_LOAIKETQUA is not null And VA.GQD_NGACVS> v_DenNgay))
                    And NVL(v.ISVIENTRUONGKN,0) = 0
                    And EXISTS(select 'X' from GDTTT_DON d 
                                where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546)
                                AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                GROUP BY d.VuViecID) 
                    And v.ngaytao <= v_DenNgay;
                    v_table(item.STT).COLUMN_20:=vCount1; 

        END LOOP;
    --in thẩm tra viên


        FOR item_DV IN (
                   SELECT DV.* FROM TABLE(v_table) DV ORDER BY DV.LOAIAN)
            LOOP
                if (item_DV.LOAIAN = 4) then
                    v_TenToaAn:='TACC HN';
                elsif (item_DV.LOAIAN = 5) then
                    v_TenToaAn:='TACC ĐN';
                elsif (item_DV.LOAIAN = 6) then
                    v_TenToaAn:='TACC HCM';
                else
                    v_TenToaAn:='ĐƠN VỊ KHÁC';
                end if;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' <tr>');

                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                                <th style="border: 1pt solid Black; text-align: left; vertical-align: middle;">'||v_TenToaAn||'</th>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_1||'</th>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_2||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_3||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_4||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_5||'</td>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_6||'</th>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_7||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_8||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_9||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_10||'</td>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_11||'</th>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_12||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_13||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_14||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_15||'</td>
                                <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_16||'</th>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_17||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_18||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_19||'</td>
                                <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item_DV.COLUMN_20||'</td>
                   ');

                DBMS_LOB.APPEND(V_EXPORT_TEXT,'</tr>');
            END LOOP;
        -- Tổng 
            FOR count_loaian IN (
                         SELECT SUM(JM.COLUMN_1) COLUMN_1,SUM(JM.COLUMN_2) COLUMN_2,SUM(JM.COLUMN_3) COLUMN_3,SUM(JM.COLUMN_4) COLUMN_4,
                         SUM(JM.COLUMN_5) COLUMN_5,SUM(JM.COLUMN_6) COLUMN_6,SUM(JM.COLUMN_7) COLUMN_7,SUM(JM.COLUMN_8) COLUMN_8,
                         SUM(JM.COLUMN_9) COLUMN_9,SUM(JM.COLUMN_10) COLUMN_10,SUM(JM.COLUMN_11) COLUMN_11,SUM(JM.COLUMN_12) COLUMN_12
                         ,SUM(JM.COLUMN_13) COLUMN_13 ,SUM(JM.COLUMN_14) COLUMN_14 ,SUM(JM.COLUMN_15) COLUMN_15 
                         ,SUM(JM.COLUMN_16) COLUMN_16,SUM(JM.COLUMN_17) COLUMN_17,SUM(JM.COLUMN_18) COLUMN_18,SUM(JM.COLUMN_19) COLUMN_19,SUM(JM.COLUMN_20) COLUMN_20
                         FROM TABLE(v_table) JM 
                        )
                LOOP
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                   <tr>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: left;padding:2px; height:20px;">Cộng</td>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_1||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_2||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_3||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_4||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_5||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_6||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_7||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_8||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_9||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_10||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_11||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_12||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_13||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_14||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_15||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_16||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_17||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_18||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_19||'</th>
                            <th style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||count_loaian.COLUMN_20||'</th>
                        </tr>
               ');
            END LOOP;

    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        <tr style="height: 0px;">    
                <td style="width: 180px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
                <td style="width: 70px"></td>
            </tr>
   </table>
    ');  
 --------------------------------
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END GDTTTT_VUAN_SEARCH_BC16;
END PKG_VGDKT_BAOCAO_VA;

/
