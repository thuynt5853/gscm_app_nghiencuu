--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_VUAN_INBC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_VUAN_INBC" AS

FUNCTION GDTTTT_VUAN_GQD_SEARCH
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

  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vLoaiNgay in number,
  vGQD_TuNgay in date,
  vGQD_DenNgay in date,

  vKetquathuly in number,
  vKetquaxetxu in number,  
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  vTypeTB in number,
  v_LoaiGDT in number,
  PageIndex	in	int,
  PageSize	in	int
)RETURN SYS_REFCURSOR
IS 
  TotalItem number; V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;  
  CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  vvGQD_DenNgay date;vvngaythulyden date;
  vvvGQD_TuNgay date;vvvNgayThulyTu date;TuNgay_char varchar2(500);
   vGQD_DenNgay_themgio date; vvngaythulyden_themgio date;
BEGIN
  DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
  -----
   SELECT DECODE(vGQD_DenNgay,null,DECODE(vngaythulyden,NULL,sysdate,vngaythulyden),vGQD_DenNgay),DECODE(vngaythulyden,null,DECODE(vGQD_DenNgay,NULL,sysdate,vGQD_DenNgay),vngaythulyden) into vGQD_DenNgay_themgio,vvngaythulyden_themgio from dual;
    vvGQD_DenNgay := to_date(to_char(vGQD_DenNgay_themgio,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS' );
    vvngaythulyden := to_date(to_char(vvngaythulyden_themgio,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS' );

  --dung cho bao cao
  SELECT DECODE(vGQD_TuNgay,null,DECODE(vNgayThulyTu,NULL,NULL,vNgayThulyTu),vGQD_TuNgay),DECODE(vNgayThulyTu,null,DECODE(vGQD_TuNgay,NULL,NULL,vGQD_TuNgay),vNgayThulyTu) into vvvGQD_TuNgay,vvvNgayThulyTu from dual;
  SELECT DECODE(vvvGQD_TuNgay,NULL,NULL,' từ ngày '||to_char(vvvGQD_TuNgay,'dd/MM/yyyy') ) into TuNgay_char from dual;
  -----
  FOR item IN (
     select a.*
          ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
        from ( Select   Count(v.ID) OVER () as CountAll,ROW_NUMBER() OVER (ORDER BY v.GDQ_NGAY  desc, v.GDQ_SO  desc, v.GQD_NgayPhatHanhCV desc,v.NGAYTHULYDON desc) STT
                ,DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  ,v.ID vuanid
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81
                  --
                 ,DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                , v.LoaiAn, v.ID,v.MAVUAN,PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
--                , v.SOANPHUCTHAM
--                , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
--                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
--                    end  NGAYXUPHUCTHAM  
--                , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
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
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                , NVL(v.THAMTRAVIENID, 0) THAMTRAVIENID
                , ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ten,'') ChucVuLanhDao, NVL(cv.Ma,'') MaChucVuLD       
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                , v.TRANGTHAIID, tt.TENTINHTRANG
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO 
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 4, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3,'Xử lý khác',GQD_KETQUA) KQ_GQD,v.GQD_KETQUA
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',4,'KDTM',5,'LĐ',6,'HC',3,'HNGD')
                         ||' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')
                  end LoaiKN
                , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , NVL(tt.GiaiDoan, 0) GiaiDoan
                  -------------------------------
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',1) NgayTPDuyet
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',2) NgayTrinhTP
                , GDTTT_ToTrinh_GetYKien(v.Id, 'TP',1) YKienTP
                , (v.SOANPHUCTHAM || chr(10) 
                || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                    end) as TTBANANPT
              ---------------------------
                  , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                   , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
               --hien thi lich su cac ttv duoc phan cong---
                , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
               ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS    
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3  ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
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

              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
               LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                          WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                          END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID         
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where              
              v.TOAANID=vToaAnID and 
              --anhvh check hctp cap cao 06/04/2021
                 (   (  ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null )) and vPhongBanID!=13)--anhvh  OR (vPhongBanID=0 or vPhongBanID is null);vPhongBanID=13 văn phòng thuộc CCHCM
                      or (v.PhongBanID in (14,15,16) and vPhongBanID=13)
                  )
                  and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp
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
              ----------------------
              and ( vloaian = 0 or  vloaian = v.LOAIAN )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( vThamphan = 0 or v.THAMPHANID=vThamphan Or (vThamphan = -1 and NVL(v.THAMPHANID,0) = 0))
               ----------------------------------
               ------Ket qua giai quyet don Dan sư mo rọng----------------------------
 
              
               ------Ket qua giai quyet don Dan sư mo rọng----------------------------
              and ( 
              vKetquathuly = 3
                   OR (v.LOAIAN != 1 and vKetquathuly = 4 
                                    and v.ngaytao <= vvGQD_DenNgay
                                    and( 
                                        ( vLoaiNgay=0 and (
                                                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
                                                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vvGQD_DenNgay and GQD_NGAYPHATHANHCV >=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                        
                                                        )
                                              )  
                                         OR 
                                         (vLoaiNgay=1 and  (
                                                            
                                                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
                                                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GQD_NGAYPHATHANHCV >=vvGQD_DenNgay 
                                                                                        and vuanid = v.id
                                                                                        )
                                                            
                                                            )

                                          )    
                                          OR(vLoaiNgay=2 and (
                                                              
                                                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
                                                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GDQ_NGAY >=vvGQD_DenNgay 
                                                                                        and vuanid = v.id
                                                                                        )
                                                              
                                                            )
                                          )  
                                    )         
                   )
                 or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and vuanid = v.id ) 
                                                                                        ) -- có kết quả
                or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )
                                                        and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA in (1,2,3,4) 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )  
                                                                ) -- Chỉ là trả lời đơn 
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
                                                          and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA in (0,2,3,4) 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id)
                                                                                        
                                                         ) --khang nghị CA + VKS
                or ( v.LOAIAN != 1 and vKetquathuly = 2 and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                            and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA in (1,2,0,4) 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id 
                                                                                        )
                                                            ) --- xếp đơn
                or ( v.LOAIAN != 1 and vKetquathuly = 6 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                                             and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA in (1,2,0,4) 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id )                           
                                                            ) -- xử lý khác               
                or ( v.LOAIAN != 1 and vKetquathuly = 8  and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        ) 
                                                                                        
                                                             and Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA in (1,2,3,0) 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id)
                                                            ) ---VKS đang giải quyết
                or ( v.LOAIAN != 1 and vKetquathuly = 7 
                                     and Exists(select 'X' from GDTTT_VUAN_KETQUA  where  TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        )
                                     and Exists (SELECT 'x' FROM GDTTT_DON vd 
                                                        WHERE vd.ISTHULY = 1 
                                                            and vd.VUVIECID = V.ID 
                                                            and vd.cd_trangthai = 2
                                                            and vd.id not in (Select DONID from GDTTT_VUAN_KETQUA_DON where TRANGTHAI = 1) )
                                         
                                      
                                            )--7 Đã có KQ nhưng vẫn còn đơn TLM                                                
                or ( v.LOAIAN != 1 and vKetquathuly = 11  
                        and  NVL(v.isvientruongkn,0) = 0
                        and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 0 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                        and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 1 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                        
                        ) --11 Trả lời đơn + Kháng nghị(CA)
                or ( v.LOAIAN != 1 and vKetquathuly = 12  
                                and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 0 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 2 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                
                                ) --12 Trả lời đơn + Xếp đơn
                 or ( v.LOAIAN != 1 and vKetquathuly = 13  
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                            where  GQD_LOAIKETQUA = 0 
                                            and TRANGTHAI != 0
                                            and vuanid = v.id
                                            )
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                where  GQD_LOAIKETQUA = 3 
                                                                and TRANGTHAI != 0
                                                                and vuanid = v.id
                                                                )
                                            
                                            )--13 Trả lời đơn + Xử lý khác
                 or ( v.LOAIAN != 1 and vKetquathuly = 14  
                            and  NVL(v.isvientruongkn,0) = 0 
                                 
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 1 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 2 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                    
                                    )--14 Kháng nghị (CA) + Xếp đơn
                 or ( v.LOAIAN != 1 and vKetquathuly = 15  
                               
                                and  NVL(v.isvientruongkn,0) = 0 
                                and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 1 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                    and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 4 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                
                                )--15 Kháng nghị (CA) + Xử lý khác
                ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                    or (v.LOAIAN = 1 and vKetquathuly = 4 
                                     and v.ngaytao <= vvGQD_DenNgay
                                     and(  
                                                ( vLoaiNgay=0 and  
                                                            (  v.gqd_loaiketqua is null
                                                                    or (v.gqd_loaiketqua is not null and VA.GQD_NGACVS>=vvGQD_DenNgay)
                                                                 )
                                                    )
    
                                             OR (vLoaiNgay=1 and  (  (v.gqd_loaiketqua is null) or 
                                                                   (v.GQD_NGAYPHATHANHCV>vvGQD_DenNgay)
                                                               )
    
                                              )    
                                              OR(vLoaiNgay=2 and  (  (v.gqd_loaiketqua is null) or 
                                                                     (v.GDQ_NGAY>vvGQD_DenNgay)
                                                                  )
                                              )                 
                                            )        
                       )
                    or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                            AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                    or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                    or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 
                               and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)
                        ) --khang nghị CA
                --or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                    or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                    or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua = 3) -- xử lý khác
                    or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                -------------Ket thuc ap dung cho an Hinh su------------------------------------------------
                )   
             
                ---Loại ngày-------------------------------
                AND( vKetquathuly = 3
                        OR(vKetquathuly != 3 and  v.LOAIAN != 1
                            and 
                            (
                                (vLoaiNgay=0  
                                    and ( vKetquathuly=4 
                                            or (vKetquathuly!=4 
                                                    and(
                                                        (Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                            )
                                                        OR (Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                            )
                                                        OR ( Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 2
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                                )
                                                        OR ( Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                                )
                                                        OR ( Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                                )
                                                  )
                                            )
                                        )
                                    )
                          
                                OR (vLoaiNgay = 1 and      
                                        ( vKetquathuly=4 
                                            or (vKetquathuly!=4 
                                                and(
                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GQD_NGAYPHATHANHCV <=vvGQD_DenNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where TRANGTHAI != 0 
                                                                                        and GQD_NGAYPHATHANHCV >=vGQD_TuNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                    )
                                                )
                                            )
                                                   
                                    )
                                OR (vLoaiNgay = 2 and 
                                        ( vKetquathuly=4 
                                            or (vKetquathuly!=4 
                                                    and(
                                                        Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GDQ_NGAY <=vvGQD_DenNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where TRANGTHAI != 0 
                                                                                        and GDQ_NGAY >=vGQD_TuNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null)                                                        
                                                    )
                                                )
                                            )
                                    )
                                 ) 
                            ) 
                         ---------Ap dung cho an Hinh su do dang luu rieng------------------------------
                        OR (vKetquathuly != 3 and v.LOAIAN = 1 and
                                ( vLoaiNgay=0 and (
                                                        (vKetquathuly=4) 
                                                        or (vKetquathuly!=4 AND ((VA.GQD_NGACVS>=vGQD_TuNgay AND vGQD_TuNgay IS NOT NULL) OR vGQD_TuNgay IS NULL)
                                                                           AND (VA.GQD_NGACVS<=vvGQD_DenNgay)
                                                            ) 
                                                        or (vKetquathuly!=4 AND v.gqd_loaiketqua is not null and VA.GQD_NGACVS is null and v.GQD_NGAYPHATHANHCV is null )
                                                     )
                                     )           
                                 OR (vLoaiNgay=1 AND (   (vKetquathuly!=4 AND ((v.GQD_NGAYPHATHANHCV>=vGQD_TuNgay AND vGQD_TuNgay IS NOT NULL) OR vGQD_TuNgay IS NULL)
                                                                       AND ((v.GQD_NGAYPHATHANHCV<=vGQD_DenNgay AND vGQD_DenNgay IS NOT NULL) OR vGQD_DenNgay IS NULL)   
                                                          )
                                                        OR (vKetquathuly=4) 
                                                     )   
                                    ) 
                                 OR (vLoaiNgay=2 AND (   (vKetquathuly!=4 AND ((v.GDQ_NGAY>=vGQD_TuNgay AND vGQD_TuNgay IS NOT NULL) OR vGQD_TuNgay IS NULL)
                                                                     AND ((v.GDQ_NGAY<=vGQD_DenNgay AND vGQD_DenNgay IS NOT NULL) OR vGQD_DenNgay IS NULL)  
        
                                                         )
                                                        OR (vKetquathuly=4) 
                                                     ) 
                                    )
                            ) 
                        ----------------------------------------------------
                        
                   )       
               --------------------------------
             
             
             
             
                AND (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0)
                ----------------------------------
                and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu))
                and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO <=vngaythulyden)
                                                or(vKetquathuly =4)
                                            )
                     )                       
                and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              --Kết quả xét xử
             and ( vKetquaxetxu = 0
                or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                          AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GetLastXX(v.ID, 0)=0)
                or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0)
                or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                        or (LoaiAnDB = 4  and NVL(v.ISANTRAODOICV,0)=1)
                 )

                  --duongph 21/03/2022
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                             or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
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
               --------------------Thông báo
              and ( vTypeTB = 0 
                or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt
                or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don
                or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2
                )
         )a  
       )
    LOOP
     -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(replace(item.LisThuLyDon,'-',''),';',', <br style="mso-data-placement:same-cell;"/>')||item.TONGDON||item.SoCV81||item.arrCHIDAOID||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br style="mso-data-placement:same-cell;"/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br style="mso-data-placement:same-cell;"/>'||item.BIDON;
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br style="mso-data-placement:same-cell;"/>')||'</td>
             ');
            if(vKetquathuly=4)then 
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
             ');
              elsif(vKetquathuly=5)then 
                DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                     <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">');
                 FOR item_kq IN (SELECT * from  GDTTT_VUAN_KETQUA where TRANGTHAI = 1 and vuanid = item.vuanid) 
                   LOOP  
                        if item_kq.GQD_LOAIKETQUA = 0 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Trả lời đơn </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy')|| '<br/>' );
                        elsif item_kq.GQD_LOAIKETQUA = 1 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Kháng nghị </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy') || '<br/>');
                        elsif item_kq.GQD_LOAIKETQUA = 2 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Xếp đơn </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy') || '<br />');
                        elsif item_kq.GQD_LOAIKETQUA = 3 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Xử lý khác </b> Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy')|| '<br/>' );
                         elsif item_kq.GQD_LOAIKETQUA = 4 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>VKS giải quyết </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy') || '<br/>');
                        end if;
                   END LOOP;
             
                    DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'</td>  ');
                
             ELSE
                  DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
                    
                 ');
                 
                 DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                     <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">');
                 FOR item_kq IN (SELECT * from  GDTTT_VUAN_KETQUA where TRANGTHAI = 1 and vuanid = item.vuanid) 
                   LOOP  
                         if item_kq.GQD_LOAIKETQUA = 0 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Trả lời đơn </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy')|| '<br/>' );
                        elsif item_kq.GQD_LOAIKETQUA = 1 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Kháng nghị </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy') || '<br/>');
                        elsif item_kq.GQD_LOAIKETQUA = 2 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Xếp đơn </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy') || '<br />');
                        elsif item_kq.GQD_LOAIKETQUA = 3 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>Xử lý khác </b> Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy')|| '<br/>' );
                         elsif item_kq.GQD_LOAIKETQUA = 4 then
                            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'<b>VKS giải quyết </b>Số:'|| item_kq.GDQ_SO || ' Ngày: ' || to_char(item_kq.GDQ_NGAY,'dd/MM/yyyy') || '<br/>');
                        end if;
                   END LOOP;
             
                    DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'</td>  ');
             
             
             end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
        ');
  END LOOP;
  -------TẠO BÁO CÁO
    SELECT DECODE(vKetquathuly,4,'chưa có kết quả giải quyết',5,'đã có kết quả giải quyết',null) into vvKetquathuly from dual;
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
                <td colspan="13" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>TỔNG HỢP DANH SÁCH ÁN '||upper(vvKetquathuly)||'</b>
                    <br style="mso-data-placement:same-cell;"/>
                    <i style="font-size: 12pt;">(Số liệu tính'||TuNgay_char||' đến ngày '||to_char(vvngaythulyden,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số - Ngày 
                    <br style="mso-data-placement:same-cell;"/>
                    thụ lý </td>
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
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
                ');  
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
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
                <td style="width: 80pt"></td>
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
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                 ');
              if(vKetquathuly=4)then    
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
               elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                 ');
               ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
               end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
            </tr>
        </table>
      ');
     OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_GQD_SEARCH;


FUNCTION  GDTTTT_QLTOTRINH_VUAN_SEARCH
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
                  --anhvh
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
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                --, NVL(qhpl.TENQHPL, Replace(TenVuAn,(NguyenDon ||' - '))) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,'TTV: ' || ttv.HOTEN || '<br/>PVT: '||ld.HOTEN ||'<br/>TP: '|| tp.HOTEN  as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                 ----------anhvh 12/10/2019 
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
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
               ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
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
               ----anhvh
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phía dưới
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV<=VVA.GDQ_NGAY)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL AND VVA.GQD_NGAYPHATHANHCV>VVA.GDQ_NGAY)  THEN  VVA.GDQ_NGAY 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID 
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
              --anhvh add 25/12/2019
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              -- Tờ trình lãnh đạo anhvh 02/11/2019
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
                <td colspan="13" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>TỔNG HỢP DANH SÁCH TỜ TRÌNH '||upper(vvisTTYKienKLTotrinh)||'</b>
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
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số tờ trình '||vvisTTYKienKLTotrinh||' là: '||CountAll_S||'</td>
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
END GDTTTT_QLTOTRINH_VUAN_SEARCH;

FUNCTION  GDTTTT_VUAN_SEARCH
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
  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    -----
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
  -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
  v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
  -------------------------
    IF(vThamphan = -1)THEN
--  Chua phan cong Tham phan
        curr_thamphan_id := -1;
    ELSE 
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
    END IF;
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
        IF(vPhongBanID=0 and  vThamphan != -1) THEN
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
   IF(V_CONLAI_='0')THEN     
   FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
        ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
        select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                from (
                Select  COUNT(1) OVER () as CountAll,
                ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                  ) STT   
                  , DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81,
                  --
                  DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                   , v.ID, v.LoaiAn,v.MAVUAN, PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon  , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                   ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                   ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                   ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                  , NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, '')) SOANPHUCTHAM                
                     ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                     ,NVL(txx.Ma_Ten, tst.Ma_Ten ) ToaXX ,DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten )) TOAXX_VietTat 
                    ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
--                     ,qhpl.TENQHPL QHPLDN
                        ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                               when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                            end as QHPNDN_Report
                    ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                        end  NGAYPHANCONGTTV
                    , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                    , DECODE(v.GQD_LOAIKETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                    ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                        WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                        else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
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
                    ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS
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
                    , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                    ,PKG_GDTTT_BAOCAO_APP.GDTTT_SODEN_DON_GETTHULYBYVUAN(v.ID) SOTIEPNHAN
                 from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
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
                      --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
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
                      ----
                      where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                      and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                        and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
                      AND(( V.ISVIENTRUONGKN is null AND  vKetquathuly >= 0) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 4) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
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
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
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
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
                       and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
                          )                    
                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                                       or(vKetquathuly =4)
                                                    )   
                          )  
                       -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                      AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvngaythulyden )   )
                       --///////////////////////////////////////////////////
                   -- Kết quả thụ lý (convert code cũ)
                        and ( vKetquathuly = 3 
                        or (vKetquathuly = 4 and  (    (v.gqd_loaiketqua is null)
                                                    or (v.GQD_LOAIKETQUA is not null and VA.GQD_NGACVS>=vvngaythulyden and vNgayThulyTu is null)--anhvh add 26/12/2019-- vNgayThulyTu is null áp dụng cho lấy dữ liệu cũ còn lại
                                                   )    
                           )
                        or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả
                        or (vKetquathuly = 0 AND  V.GQD_LOAIKETQUA=0)
                         -- trả lời đơn
                        or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                         or (
                            (vKetquathuly = 1  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 
                                              --and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null) 
                                        ) 
                             or (vKetquathuly = 1 and v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 and v.nguoikhangnghi IN (9, 1143)) 
                            )--khang nghị CA 

                        or (vKetquathuly = 2  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=2
                            ) --- xếp đơn
                        or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                        or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) ---giải quyết khác
                        or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                        )  
                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
               ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                ------------------------------
                 and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
                 and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp     
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                            or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                            ) 
                 and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))

                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                    --Ngay Ban an
                     Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
                         --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null) 
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )
           )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>');
        IF (vToaAnID != 1)THEN
        DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SUBSTR(item.SOTIEPNHAN,1,INSTR(item.SOTIEPNHAN,'-')-1) ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SUBSTR(item.SOTIEPNHAN,INSTR(item.SOTIEPNHAN,'-')+1)||'</td>');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'         
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(replace(item.LisThuLyDon,'-',''),';',', <br style="mso-data-placement:same-cell;"/>')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGAYXUPHUCTHAM||'</td>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br style="mso-data-placement:same-cell;" />')||'</td>
             ');
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
             ');
             end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
        ');
  END LOOP;
   ELSE
        --///////////////////////////////////////////////////////////////////////////////
       --////////////////Còn lại='1'////////////////////////////////////////////////////////
       --///////////////////////////////////////////////////////////////////////////////
         vvvNgayThulyTu:=NULL;vvvNgayThulyDen:=vNgayThulyTu;
    FOR item IN (  
        SELECT TSS.* FROM (SELECT  COUNT(1) OVER () as CountAll, ROW_NUMBER() OVER 
       (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END DESC ) STT
        --(ORDER BY TTS.ID) STT
       ,TTS.* FROM ( 
               SELECT  TT.* FROM ( 
               WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
              ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
               select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                      SELECT  V.NGAYTHULYDON NGAYTHULYDONS, 
                   DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81,
                  --
                  DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                   , v.ID, v.LoaiAn,v.MAVUAN, PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon  , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                   , v.NGUYENDON,v.BIDON
                   ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                  , NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, '')) SOANPHUCTHAM                
                    , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))  and (Length(NVL(v.NgayXuSoTham,''))=0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))   and (Length(NVL(v.NgayXuSoTham,''))> 0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy')<>'01/01/0001')) then to_char(v.NgayXuSoTham,'dd/MM/yyyy')
                           when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')                      
                        end  NGAYXUPHUCTHAM  
                     ,NVL(txx.Ma_Ten, tst.Ma_Ten ) ToaXX ,DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten )) TOAXX_VietTat 
                    ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
--                     ,qhpl.TENQHPL QHPLDN
                     ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                    ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                        end  NGAYPHANCONGTTV
                    , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                    , DECODE(v.GQD_LOAIKETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                    ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
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
                    ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS
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
                    , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                    ,PKG_GDTTT_BAOCAO_APP.GDTTT_SODEN_DON_GETTHULYBYVUAN(v.ID) SOTIEPNHAN
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
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
                      --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
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
                      ----
                      where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                      and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                        and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
                     AND(( V.ISVIENTRUONGKN is null AND  vKetquathuly >= 0) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 4) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
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
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
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
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
                      and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
                          )                    
                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                                       or(vKetquathuly =4)
                                                    )   
                          )  
                       -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                      AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvngaythulyden )   )
                       --///////////////////////////////////////////////////
                   -- Kết quả thụ lý (convert code cũ)
                        and ( vKetquathuly = 3 
                        or (vKetquathuly = 4 and  (    (v.gqd_loaiketqua is null)
                                                    or (v.GQD_LOAIKETQUA is not null and VA.GQD_NGACVS>=vvngaythulyden and vNgayThulyTu is null)--anhvh add 26/12/2019-- vNgayThulyTu is null áp dụng cho lấy dữ liệu cũ còn lại
                                                   )    
                           )
                        or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả
                        or (vKetquathuly = 0 AND  V.GQD_LOAIKETQUA=0)
                         -- trả lời đơn
                        or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                         or (
                            (vKetquathuly = 1  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 
                                              --and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null) 
                                        ) 
                             or (vKetquathuly = 1 and v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 and v.nguoikhangnghi IN (9, 1143)) 
                            )--khang nghị CA 

                        or (vKetquathuly = 2  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=2
                            ) --- xếp đơn
                        or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                        or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) ---giải quyết khác
                        or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                        )  
                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                ------------------------------
                 and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                            or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                            ) 
                 and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))

                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                    --Ngay Ban an
                     Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
                         --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )
               )a 
       )TT
UNION ALL
      --////////////////cộng với cũ còn lại////////////////////////////////////////////////////////    
    SELECT TT.* FROM ( 
           WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                   SELECT  V.NGAYTHULYDON NGAYTHULYDONS, 
                   DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81,
                  --
                  DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                   , v.ID, v.LoaiAn,v.MAVUAN, PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon  , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                  , NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, '')) SOANPHUCTHAM                
                    , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))  and (Length(NVL(v.NgayXuSoTham,''))=0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))   and (Length(NVL(v.NgayXuSoTham,''))> 0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy')<>'01/01/0001')) then to_char(v.NgayXuSoTham,'dd/MM/yyyy')
                           when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')                      
                        end  NGAYXUPHUCTHAM  
                     ,NVL(txx.Ma_Ten, tst.Ma_Ten ) ToaXX ,DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten )) TOAXX_VietTat 
                    ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
--                     ,qhpl.TENQHPL QHPLDN
                     ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                    ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                        end  NGAYPHANCONGTTV
                    , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                     , DECODE(v.GQD_LOAIKETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                    ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                          WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                        else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
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
                    ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS
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
                    , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                    ,PKG_GDTTT_BAOCAO_APP.GDTTT_SODEN_DON_GETTHULYBYVUAN(v.ID) SOTIEPNHAN
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
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
                      --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
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
                      ----
                      where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                      and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                        and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
                      AND(( V.ISVIENTRUONGKN is null AND  vKetquathuly >= 0) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 4) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
                      and ( (vtrangthai = 0 )
                        or (vtrangthai = 1 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL ) 
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            )--anhvh                
                        or (vtrangthai = 2 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                           --AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            ) --anhvh 
                        or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )
                        or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                        or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                        or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                        or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                        or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
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
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
                      and ( vvvNgayThulyTu is null or(v.NGAYTAO>=vvvNgayThulyTu) 
                          )                    
                       and ( vvvNgayThulyDen is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvvNgayThulyDen)
                                                       or(vKetquathuly =4)
                                                    )   
                          )  
                       -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                      AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvvNgayThulyDen )   )
                       --///////////////////////////////////////////////////
                   -- Kết quả thụ lý (convert code cũ)
                       AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvvNgayThulyDen) )
                      --////////////////
                        and ( vKetquathuly = 3 
                        or (vKetquathuly = 4 and (v.gqd_loaiketqua is null))
                        or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả
                        or (vKetquathuly = 0 AND  V.GQD_LOAIKETQUA=0)
                         -- trả lời đơn
                        or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                         or (
                            (vKetquathuly = 1  AND (VA.GQD_NGACVS >=vvvNgayThulyTu) AND (VA.GQD_NGACVS <=vvvNgayThulyDen)
                                              AND  v.NGAYTAO<=vvvNgayThulyDen AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 
                                              --and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null) 
                                        ) 
                             or (vKetquathuly = 1 and v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 and v.nguoikhangnghi IN (9, 1143)) 
                            )--khang nghị CA 

                        or (vKetquathuly = 2  AND v.GQD_LOAIKETQUA=2
                            ) --- xếp đơn
                        or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                        or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) ---giải quyết khác
                        or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                        )  
                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                ------------------------------
                 and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                            or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                            ) 
                 and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))

                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                    --Ngay Ban an
                     Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
                         --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )
               )a 
             )TT WHERE V_CONLAI_='1'
          )TTS
       )TSS 
    -----------------------------------
    )
   LOOP
     -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>');
        IF (vToaAnID != 1)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SUBSTR(item.SOTIEPNHAN,1,INSTR(item.SOTIEPNHAN,'-')-1) ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SUBSTR(item.SOTIEPNHAN,INSTR(item.SOTIEPNHAN,'-')+1)||'</td>');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(replace(item.LisThuLyDon,'-',''),';',', <br style="mso-data-placement:same-cell;" />')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGAYXUPHUCTHAM||'</td>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br style="mso-data-placement:same-cell;" />')||'</td>
             ');
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
             ');
             end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
        ');
   END LOOP;
   end if;     
    -------TẠO BÁO CÁO
    SELECT DECODE(vKetquathuly,4,'chưa có kết quả giải quyết',5,'đã có kết quả giải quyết',null) into vvKetquathuly from dual;
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
                <td colspan="13" style="line-height: 100%; font-size: 14pt; text-align:center;"><b>TỔNG HỢP DANH SÁCH ÁN '||upper(vvKetquathuly)||'</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vNgayThulyTu,'dd/MM/yyyy')||'  đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>');
        IF (vToaAnID != 1)THEN     
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số 
                    <br style="mso-data-placement:same-cell;"/> tiếp nhận</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày
                    <br style="mso-data-placement:same-cell;"/> tiếp nhận</td>');
        END IF;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số - Ngày 
                    <br style="mso-data-placement:same-cell;"/>
                    thụ lý </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số Bản án</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày Bản án</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án xử</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vLoaiAn_name||'</td>
                 '); 
        IF(vLoaiAn=01)THEN
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
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
                ');  
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
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
                <td style="width: 20pt"></td>');
        IF (vToaAnID != 1)THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="width: 60pt"></td>
                <td style="width: 80pt"></td>');
        END IF;
        DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                <td style="width: 80pt"></td>
                <td style="width: 60pt"></td>
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
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                 ');
              if(vKetquathuly=4)then    
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
               elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                 ');
               ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
               end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
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
END GDTTTT_VUAN_SEARCH;


FUNCTION  VUAN_TRACUU_SEARCH_PRINT
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
  v_SodonTLM        in number,
  v_LoaiGDT       in number,
  v_QHPL_TD      in varchar2,

  v_loaingaysearch in number,
  v_NgaySearch_Tu in date,
  v_NgaySearch_Den in date,

  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
  vvngaythulyden date;vvloaian VARCHAR2(150);vvLoaidon number;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  ----------------------
  v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
  LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;ISCAPTRINHTIEP NUMBER;THUTU_CAPTRINH NUMBER;
  -----------------------
  v_table_all T_TINHTRANG; vNgayThulyDen_all date;
  LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE; TOTRINH_ID_ALL NUMBER;NGAYTRINH_ALL DATE;ISCAPTRINHTIEP_ALL NUMBER;THUTU_CAPTRINH_ALL NUMBER;
  ----------------
   vvTuNgay date;vvDenNgay date;
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
   IF(V_CONLAI_='0')THEN     
   FOR item IN (
        WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
        ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
        select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                from (
                Select  COUNT(1) OVER () as CountAll,
                ROW_NUMBER() OVER (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END, CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN V.NGAYTHULYDON END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN ttv.HOTEN END DESC
                                  ) STT   
                  , DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81,
                  --
                  DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                   , v.ID, v.LoaiAn,v.MAVUAN, PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon  , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                   ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                   ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                   ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                  , NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, '')) SOANPHUCTHAM                
                    , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))  and (Length(NVL(v.NgayXuSoTham,''))=0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))   and (Length(NVL(v.NgayXuSoTham,''))> 0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy')<>'01/01/0001')) then to_char(v.NgayXuSoTham,'dd/MM/yyyy')
                           when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')                      
                        end  NGAYXUPHUCTHAM  
                     ,NVL(txx.Ma_Ten, tst.Ma_Ten ) ToaXX ,DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten )) TOAXX_VietTat 
                    ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
--                     ,qhpl.TENQHPL QHPLDN
                     ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                    ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                        end  NGAYPHANCONGTTV
                    , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                    , DECODE(v.GQD_LOAIKETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                    ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                        WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                        else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
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
                    ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS
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
                    , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                 from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
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
                      --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
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
                      ----
                      where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
                          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                      -----------------------
                          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%'   or UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
                      ----------------------
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
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                      and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                        and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
                      AND(( V.ISVIENTRUONGKN is null AND  vKetquathuly >= 0) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 4) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
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
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
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
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
                       and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
                          )                    
                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                                       or(vKetquathuly =4)
                                                    )   
                          )  
                       -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                      AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvngaythulyden )   )
                       --///////////////////////////////////////////////////
                   -- Kết quả thụ lý (convert code cũ)
                        and ( vKetquathuly = 3 
                        or (vKetquathuly = 4 and  (    (v.gqd_loaiketqua is null)
                                                    or (v.GQD_LOAIKETQUA is not null and VA.GQD_NGACVS>=vvngaythulyden and vNgayThulyTu is null)--anhvh add 26/12/2019-- vNgayThulyTu is null áp dụng cho lấy dữ liệu cũ còn lại
                                                   )    
                           )
                        or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả
                        or (vKetquathuly = 0 AND  V.GQD_LOAIKETQUA=0)
                         -- trả lời đơn
                        or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                         or (
                            (vKetquathuly = 1  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 
                                              --and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null) 
                                        ) 
                             or (vKetquathuly = 1 and v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 and v.nguoikhangnghi IN (9, 1143)) 
                            )--khang nghị CA 

                        or (vKetquathuly = 2  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=2
                            ) --- xếp đơn
                        or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                        or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) ---giải quyết khác
                        or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                        )  
                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
               ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                ------------------------------
                 and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                            or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                            ) 
                 and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))

                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                    --Ngay Ban an
                     Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
                         --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null) 
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )
           )a
       )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(replace(item.LisThuLyDon,'-',''),';',', <br style="mso-data-placement:same-cell;"/>')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGAYXUPHUCTHAM||'</td>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br style="mso-data-placement:same-cell;" />')||'</td>
             ');
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
             ');
             end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
        ');
  END LOOP;
   ELSE
        --///////////////////////////////////////////////////////////////////////////////
       --////////////////Còn lại='1'////////////////////////////////////////////////////////
       --///////////////////////////////////////////////////////////////////////////////
         vvvNgayThulyTu:=NULL;vvvNgayThulyDen:=vNgayThulyTu;
    FOR item IN (  
        SELECT TSS.* FROM (SELECT  COUNT(1) OVER () as CountAll, ROW_NUMBER() OVER 
       (ORDER BY CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'NGAYTHULYDON' THEN TTS.NGAYTHULYDONS END DESC,CASE WHEN V_ASC_DESC = 'ASC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END,CASE WHEN V_ASC_DESC = 'DESC' AND V_COLUME = 'TENTHAMTRAVIEN' THEN TTS.TENTHAMTRAVIEN END DESC ) STT
        --(ORDER BY TTS.ID) STT
       ,TTS.* FROM ( 
               SELECT  TT.* FROM ( 
               WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
              ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
               select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                      SELECT  V.NGAYTHULYDON NGAYTHULYDONS, 
                   DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81,
                  --
                  DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                   , v.ID, v.LoaiAn,v.MAVUAN, PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon  , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON 
                   , v.NGUYENDON,v.BIDON
                   ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                  , NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, '')) SOANPHUCTHAM                
                    , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))  and (Length(NVL(v.NgayXuSoTham,''))=0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))   and (Length(NVL(v.NgayXuSoTham,''))> 0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy')<>'01/01/0001')) then to_char(v.NgayXuSoTham,'dd/MM/yyyy')
                           when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')                      
                        end  NGAYXUPHUCTHAM  
                     ,NVL(txx.Ma_Ten, tst.Ma_Ten ) ToaXX ,DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten )) TOAXX_VietTat 
                    ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
--                     ,qhpl.TENQHPL QHPLDN
                     ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                    ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                        end  NGAYPHANCONGTTV
                    , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                    , DECODE(v.GQD_LOAIKETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                    ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                            WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                            else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
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
                    ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS
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
                    , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
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
                      --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
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
                      ----
                      where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                      and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                        and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
                     AND(( V.ISVIENTRUONGKN is null AND  vKetquathuly >= 0) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 4) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
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
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
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
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
                      and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
                          )                    
                       and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                                       or(vKetquathuly =4)
                                                    )   
                          )  
                       -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                      AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvngaythulyden )   )
                       --///////////////////////////////////////////////////
                   -- Kết quả thụ lý (convert code cũ)
                        and ( vKetquathuly = 3 
                        or (vKetquathuly = 4 and  (    (v.gqd_loaiketqua is null)
                                                    or (v.GQD_LOAIKETQUA is not null and VA.GQD_NGACVS>=vvngaythulyden and vNgayThulyTu is null)--anhvh add 26/12/2019-- vNgayThulyTu is null áp dụng cho lấy dữ liệu cũ còn lại
                                                   )    
                           )
                        or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả
                        or (vKetquathuly = 0 AND  V.GQD_LOAIKETQUA=0)
                         -- trả lời đơn
                        or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                         or (
                            (vKetquathuly = 1  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 
                                              --and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null) 
                                        ) 
                             or (vKetquathuly = 1 and v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 and v.nguoikhangnghi IN (9, 1143)) 
                            )--khang nghị CA 

                        or (vKetquathuly = 2  AND (VA.GQD_NGACVS >=vNgayThulyTu) AND (VA.GQD_NGACVS <=vvngaythulyden)
                                              AND  v.NGAYTAO<=vvngaythulyden AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=2
                            ) --- xếp đơn
                        or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                        or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) ---giải quyết khác
                        or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                        )  
                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                ------------------------------
                 and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                            or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                            ) 
                 and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))

                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                    --Ngay Ban an
                     Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
                         --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )
               )a 
       )TT
UNION ALL
      --////////////////cộng với cũ còn lại////////////////////////////////////////////////////////    
    SELECT TT.* FROM ( 
           WITH HD1 as (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,'<br/><span style="">Hội đồng: <b> 5</b></span>','')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID, hd.TYPEHD)
          ,HD2 as (select hd.VUANID,DECODE(hd.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||hd.TENCANBO||'</b></span>')TEN_CHUTOA,hd.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd WHERE hd.ISCHUTOA=1)
          select a.* ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
                    from (
                   SELECT  V.NGAYTHULYDON NGAYTHULYDONS, 
                   DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81,
                  --
                  DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                   , v.ID, v.LoaiAn,v.MAVUAN, PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon  , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON , v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                  , NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, '')) SOANPHUCTHAM                
                    , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))  and (Length(NVL(v.NgayXuSoTham,''))=0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') ='01/01/0001')) then ''
                           when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001'))   and (Length(NVL(v.NgayXuSoTham,''))> 0  or (to_char(v.NgayXuSoTham,'dd/MM/yyyy')<>'01/01/0001')) then to_char(v.NgayXuSoTham,'dd/MM/yyyy')
                           when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')                      
                        end  NGAYXUPHUCTHAM  
                     ,NVL(txx.Ma_Ten, tst.Ma_Ten ) ToaXX ,DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten )) TOAXX_VietTat 
                    ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
--                     ,qhpl.TENQHPL QHPLDN
                     ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                    ,tp.HOTEN as TENTHAMPHAN
                    , ttv.HOTEN as TENTHAMTRAVIEN
                    , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                             when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                        end  NGAYPHANCONGTTV
                    , ld.HOTEN as TENLANHDAO   , cv.Ten ChucVuLanhDao   , cv.Ma MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                     , DECODE(v.GQD_LOAIKETQUA, 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n',v.GQD_KETQUA ) KQ_GQD
                    ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                          WHEN NVL(v.GQD_LOAIKETQUA,5) = 5 then null
                        else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
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
                    ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS
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
                    , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                      from GDTTT_VUAN v 
                      left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                      left join DM_TOAAN tst on v.ToaAnSoTham=tst.ID
                      left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                      left join DM_CANBO tp on v.THAMPHANID=tp.ID
                      left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                      left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                      left join DM_DataITem cv on ld.ChucVuID = cv.ID
                      left join GDTTT_DM_TINHTRANG tt on tt.ID= NVL(v.TRANGTHAIID,1)
                      left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
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
                      --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
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
                      ----
                      where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
                      and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.NGUOIKHIEUNAI) like '%' || UPPER(vNguoiGui) || '%') 
                      --anhvh add 25/12/2019
                      and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                             or  (vloaian = v.LOAIAN and vloaian!=0) 
                        )
                      and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
                      and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                      and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--                      and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
                      AND(( V.ISVIENTRUONGKN is null AND  vKetquathuly >= 0) OR ( vKetquathuly <0 OR vKetquathuly=3) )    
                       ---------------------------------------
                       and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             
                       and (  vTraloidon = '2' or vTraloidon is null 
                            or (vTraloidon='1' and NVL(v.ISTHONGBAOCV,0)>0)  ----có công văn trả lời
                            or (vTraloidon = '0' and NVL(v.ISTHONGBAOCV,0)=0)-- không cần công văn trả lời 
                            )
                       -- Đã có hồ sơ
                      and ( isTTMuonHS = 2
                            or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                            or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                             -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 4) OR NVL(v.GQD_LOAIKETQUA,5) != 4 ) 
                              ))
                      -- Tờ trình lãnh đạo
                      and ( isTTToTrinh = 2 
                            or (isTTToTrinh = 1 and EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID)
                               --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA WHERE V.ID=PA.VUANID) -- anhvh test
                             )
                            or (isTTToTrinh = 0 and NOT EXISTS (select ID from GDTTT_TOTRINH where v.ID = VUANID))
                            )
                      -- Trạng thái thụ lý 
                      and ( (vtrangthai = 0 )
                        or (vtrangthai = 1 AND (v.THAMTRAVIENID IS NULL AND TRIM(V.TenThamTRaVien) IS NULL ) 
                                           AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            )--anhvh                
                        or (vtrangthai = 2 AND (v.THAMTRAVIENID IS NOT NULL OR TRIM(V.TenThamTRaVien) IS NOT NULL)  
                                           --AND ((NVL(v.TrangthaiID,0) not in (13,14,15,16,18) AND vPhongBanID!=0) OR vPhongBanID=0 )--đối với thẩm phán thì không check trường hợp trên, chỉ check đối với các vụ
                            ) --anhvh 
                        or (vtrangthai = 3 and v.THAMTRAVIENID  IS NOT NULL and v.THAMTRAVIENID != 0 and NOT EXISTS(SELECT 'X' FROM GDTTT_TOTRINH WHERE v.ID = VUANID) )
                        or (vtrangthai in (6,7,8,17) AND  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) ) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)))
                        or (vtrangthai =9 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18)) )--Báo cáo Tổ Thẩm phán
                        or (vtrangthai = 4 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (4 ,100))  AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Phó vụ trưởng + phó chánh tòa (100)
                        or (vtrangthai = 5 and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and TINHTRANGID IN (5 ,101)) AND (NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18))) -- Vụ trưởng + chánh tòa (101)
                        or (vtrangthai = 10 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID and loaiykien = 10) )-- Nghiên cứu, xác minh, bổ sung
                        or (vtrangthai = 11 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai)  )
                                            --AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =11 AND V.ID=PA.VUANID)
                        )  --Trình dự thảo trả lời đơn
                        or (vtrangthai = 12 and EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID  and (TINHTRANGID = vtrangthai or CAPTRINHTIEP=vtrangthai) )
                                           -- AND EXISTS(SELECT 'X' FROM TABLE(v_table_all) PA  WHERE PA.TINHTRANGID =12 AND V.ID=PA.VUANID)
                        )--Trình dự thảo kháng nghị
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
                       --///////////////////////////////////////////////////
                      -------liên quan đến tham số ngày---------------------
                      and ( vvvNgayThulyTu is null or(v.NGAYTAO>=vvvNgayThulyTu) 
                          )                    
                       and ( vvvNgayThulyDen is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvvNgayThulyDen)
                                                       or(vKetquathuly =4)
                                                    )   
                          )  
                       -- vết tách ra trường hợp này để kiểm soát vKetquathuly=4 chưa có kết quả
                      AND (vKetquathuly!=4 OR (vKetquathuly=4 AND v.NGAYTAO<=vvvNgayThulyDen )   )
                       --///////////////////////////////////////////////////
                   -- Kết quả thụ lý (convert code cũ)
                       AND (v.GQD_LOAIKETQUA IS NULL OR (v.GQD_LOAIKETQUA IS NOT NULL and VA.GQD_NGACVS>=vvvNgayThulyDen) )
                      --////////////////
                        and ( vKetquathuly = 3 
                        or (vKetquathuly = 4 and (v.gqd_loaiketqua is null))
                        or (vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)) -- có kết quả
                        or (vKetquathuly = 0 AND  V.GQD_LOAIKETQUA=0)
                         -- trả lời đơn
                        or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                         or (
                            (vKetquathuly = 1  AND (VA.GQD_NGACVS >=vvvNgayThulyTu) AND (VA.GQD_NGACVS <=vvvNgayThulyDen)
                                              AND  v.NGAYTAO<=vvvNgayThulyDen AND v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 
                                              --and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null) 
                                        ) 
                             or (vKetquathuly = 1 and v.GQD_LOAIKETQUA is not null AND v.GQD_LOAIKETQUA=1 and v.nguoikhangnghi IN (9, 1143)) 
                            )--khang nghị CA 

                        or (vKetquathuly = 2  AND v.GQD_LOAIKETQUA=2
                            ) --- xếp đơn
                        or (vKetquathuly = -2 and v.gqd_loaiketqua = 1 and (v.nguoikhangnghi = 10 or v.isvientruongkn =1)) --khang nghị VKS
                        or (vKetquathuly = 6 and v.gqd_loaiketqua= 3) ---giải quyết khác
                        or (vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                        )  
                    --Cấp trình tiếp   
                     and (vCapTrinhTiep = 0
                            or (vCapTrinhTiep <> 0 and EXISTS(select 'X' from gdttt_totrinh WHERE  v.ID = vuanid and captrinhtiep = vCapTrinhTiep))
                            )
                      --Kết quả xét xử
                     and ( vKetquaxetxu = 0
                        or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                                  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)=0)
                        or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                        or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                 --------------------Thông báo
                  and ( vTypeTB = 0 
                        or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                        or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt

                        or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                        or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don

                        or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                        or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2

                        )
                  ------------------Hoãn THA
                and ( ishoantha = 2
                                or (ishoantha != 2 and NVL(gqd_ishoantha, 0) = ishoantha)
                     ) 
                 AND (vTypeHDTP=0
                      OR (vTypeHDTP=1 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=1)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=2 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND HD.TypeHD=2)  AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)
                      OR (vTypeHDTP=3 AND  EXISTS(select 'X' FROM GDTTT_VuAn_XXGDTT_HoiDong HD where HD.VuAnID =v.ID AND NVL(HD.IsChuToa,0)=1) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GETLASTXX(v.ID, 0)>0)     
                 )
                 --Loại công văn anhvh
                AND (vLoaiCVID=0
                        OR (vLoaiCVID>0 AND  EXISTS(select 'X' from GDTTT_DON d 
                                                            where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where TEM.ID=vLoaiCVID OR TEM.CAPCHAID=vLoaiCVID)
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY d.VuViecID) 
                            )
                        OR  (vLoaiCVID=-1 AND EXISTS(select 'X' FROM GDTTT_DON D 
                                                            WHERE D.LOAICONGVAN NOT IN (Select TEM.ID from DM_DATAITEM TEM where TEM.ID=1023 Or TEM.CAPCHAID=1023) 
                                                            AND d.VuViecID = v.ID AND NVL(d.VuViecID, 0)>0 
                                                            GROUP BY D.VuViecID)  --Tất cả trừ 8.1
                            )
                    )
                ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                ------------------------------
                 and (v_SodonTLM = 0 
                        or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                        or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon =1))
                        or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                            (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                where a.VuViecID = v.id and  cdon >1))
                      )
                 and (v_LoaiGDT = 4 
                            or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                            or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                            or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                            or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                            ) 
                 and (v_QHPL_TD is null  
                    Or (lower(qhpl.TENQHPL) like '%' || lower(v_QHPL_TD) || '%')
                    Or (lower(v.TenVuAn) like '%' || lower(v_QHPL_TD) || '%'))

                AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                    --Ngay Ban an
                     Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or  ((to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD >= v_NgaySearch_Tu )
                                                                                    Or(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM >= v_NgaySearch_Tu ) 
                                                                                    Or(to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham >= v_NgaySearch_Tu )
                                                                                  )
                                                                ) 
                                             and (v_NgaySearch_Den is null Or ( ( to_char(v.NGAYQD,'dd/MM/yyyy') != '01/01/0001' and v.NGAYQD is not null and v.NGAYQD < v_NgaySearch_Den )
                                                                                    Or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') != '01/01/0001' and v.NGAYXUPHUCTHAM is not null and v.NGAYXUPHUCTHAM < v_NgaySearch_Den)
                                                                                    Or (to_char(v.NgayXuSoTham,'dd/MM/yyyy') != '01/01/0001' and v.NgayXuSoTham is not null and v.NgayXuSoTham < v_NgaySearch_Den)
                                                                                    )
                                                                )
                        )
                        --Ngay Ho So
                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO >= v_NgaySearch_Tu
                                                                                                                        )
                                                                                )
                                                        ) 
                                             and (v_NgaySearch_Den is null Or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS 
                                                                                                                            where v.ID = VUANID 
                                                                                                                                and LOAI = 3 
                                                                                                                                and NGAYTAO is not null
                                                                                                                                and to_char(NGAYTAO,'dd/MM/yyyy') != '01/01/0001'
                                                                                                                                and NGAYTAO < v_NgaySearch_Den
                                                                                                                        )
                                                                             )
                                                                )
                        )
                         --Ngay phan TTV
                       Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV >= v_NgaySearch_Tu                                   
                                                                                )
                                                        ) 
                                                and (v_NgaySearch_Den is null Or ((TRIM(V.TenThamTRaVien) IS NOT NULL Or v.ThamTraVienId is not null)
                                                                                    and v.NGAYPHANCONGTTV is not null
                                                                                    and to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') != '01/01/0001'
                                                                                    and v.NGAYPHANCONGTTV < v_NgaySearch_Den                                   
                                                                                )
                                                                )
                        )
                    )
               )a 
             )TT WHERE V_CONLAI_='1'
          )TTS
       )TSS 
    -----------------------------------
    )
   LOOP
     -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(replace(item.LisThuLyDon,'-',''),';',', <br style="mso-data-placement:same-cell;" />')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGAYXUPHUCTHAM||'</td>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br style="mso-data-placement:same-cell;" />')||'</td>
             ');
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.KQ_GQDS||'</td>
             ');
             end if;
             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
            </tr>
        ');
   END LOOP;
   end if;     
    -------TẠO BÁO CÁO
    SELECT DECODE(vKetquathuly,4,'chưa có kết quả giải quyết',5,'đã có kết quả giải quyết',null) into vvKetquathuly from dual;
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
                <td colspan="13" style="line-height: 100%; font-size: 14pt; text-align:center;"><b>TỔNG HỢP DANH SÁCH ÁN '||upper(vvKetquathuly)||'</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vNgayThulyTu,'dd/MM/yyyy')||'  đến ngày '||to_char(vNgayThulyDen,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số án '||vvKetquathuly||' là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số - Ngày 
                    <br style="mso-data-placement:same-cell;" />
                    thụ lý </td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số Bản án</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày Bản án</td>
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
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
                ');  
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
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
                <td style="width: 80pt"></td>
                <td style="width: 60pt"></td>
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
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                 ');
              if(vKetquathuly=4)then    
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
               elsif(vKetquathuly=5)then
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                 ');
               ELSE
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
               end if;
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
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
END VUAN_TRACUU_SEARCH_PRINT;



FUNCTION  GDTTTT_DON_GIAONHAN_THS_PRINT
( 
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
  vNgaychuyenTu in date,
  vNgaychuyenDen in date,
  vArrSelectID in varchar2,
  vIsThuLy in number,
  vPhanloaixuly in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2,
  vPhancongTTV in number,
  vloaian in number,-- them loai an
  IsGhepVuAn in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  PageIndex	in	int,
  PageSize	in	int
)
RETURN SYS_REFCURSOR
IS 
  TotalItem number;  MinIndex	number;  MaxIndex	number;vNgayTrinh VARCHAR2(150);vvThamtravien VARCHAR2(150):=NULL;
  vtt_denngay date;vvloaian VARCHAR2(150);vvngaythulyden date;
  temp_sobanan nvarchar2(50);
  ----------------------
  V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;
  ----------------------
  vvTuNgay date;vvDenNgay date;
BEGIN
   DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
--   -----
--   SELECT DECODE(vDenNgay,null,sysdate,to_date(to_char(vDenNgay,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
--   -------------------------
--  SELECT DECODE(vDenNgay,null,sysdate,vDenNgay) into vtt_denngay from dual;
  ----------------------------------------------------------------- SELECT  COUNT(1) OVER () as CountAll, ROW_NUMBER() OVER      


  FOR item IN (
      select a.*, Count(a.ID) OVER () as CountAll 
            , case when length(NVL(a.arrCongvan, ''))>0 then (' (' || a.arrCongvan || ')') else '' end as CV_NguoiKhieuNai
        from( Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
                  , d.ID  
                  ,dc.ID as DCID 
                  , NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                              then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                        else 0 end,0) DonThuLyMoi_ID
                  ,d.MADON,d.NGUOIGUI_HOTEN, NVL(d.VuviecID,0) VuViecID
                  ,d.SOTHUTUDON,d.NGAYNHANDON

                  , NVL(d.ISTHULY,0) IsThuLy
                  , (case NVL(d.ISTHULY,0) when 1 then u'Th\1ee5 l\00fd m\1edbi' else u'\0110\00e3 th\1ee5 l\00fd' end) TrangThaiThuLy
                  ,d.BAQD_LOAIQDBA
                  ,to_char((Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END),'dd/MM/yyyy') BAQD_NGAYBA
                  ,DECODE(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT,d.BAQD_SO) BAQD_SO
                  --,d.BAQD_SO, d.BAQD_NGAYBA
                  , d.BAQD_CAPXETXU
                   , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                                     when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                                end  NgayBA_PT  
                  ,d.BAQD_LOAIAN, d.BAQD_TOAANID
                  ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD

                  , va.NGUYENDON ,va.BIDON 
                  , cf.TenQHPL
                  ,d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI
                  ,d.NGAYTAO NgayNhap 
                    ,case when (Length(NVL(d.NgayTao,''))=0 or (to_char(d.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.NgayTao,'')) >0 then to_char(d.NgayTao,'dd/MM/yyyy')
                    end  NgayTaoStr 
                  ,d.TL_NGAY ,d.TL_SO,d.ISSHOWFULL
                  , case when (Length(NVL(d.TL_NGAY,''))=0 or (to_char(d.TL_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                     when Length(NVL(d.TL_NGAY,'')) >0 then to_char(d.TL_NGAY,'dd/MM/yyyy')
                                end  TL_NGAY_TEXT 
                  ,d.LOAIDON
                  ,case d.LOAIDON when 1 then 'Đơn' 
                                  when 2 then 'Đơn tố cáo' 
                                  when 3 then 'Đơn + Công văn' end as HinhThuc
                  ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO
                  , case when (Length(NVL(d.NGAYGHITRENDON,''))=0 or (to_char(d.NGAYGHITRENDON,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.NGAYGHITRENDON,'')) >0 then to_char(d.NGAYGHITRENDON,'dd/MM/yyyy')
                    end  NGAYGHITRENDON

                  , txx.Ma_Ten ToaXX 
                  ,DECODE(d.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-GĐT)</i>',
                                         2,DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-ST)</i>',
                                         DM_CanBo_TenToaVT(txx.Ma_Ten)||'<i>('|| decode(d.BAQD_LOAIAN,1,'HS',2,'DS',3,'HNGĐ',4,'KDTM',5,'LĐ',6,'HC')||'-PT)</i>') TOAXX_VietTat
                  ,d.NGUOIKHANGNGHI,d.GHICHU||decode(d.ISTH_ANGIAM,1,'<b><i>(...Xin ân giảm)</i></b>',null)GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH

                  ,d.CV_TENDONVI
                  ,d.CV_NGAY,d.CV_DIACHI CVDIACHI

                  ,d.CD_SOCV,d.CD_NGUOIKY
                  ,case when (Length(NVL(d.CD_NGAYCV,''))=0 or (to_char(d.CD_NGAYCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.CD_NGAYCV,'')) >0 then to_char(d.CD_NGAYCV,'dd/MM/yyyy')
                    end  CD_NGAYCV  

                  ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC, d.CD_TA_LYDO_KHAC
                  ,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU
                  ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                      when 1 then cast(tk.MA_TEN as nvarchar2(250))           
                      when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                      when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                      when 4 then  cast('Không chuyển' as nvarchar2(250))
                      end ) NOICHUYEN
                  ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                      when 1 then 'Đã chuyển'           
                      when 2 then  'Đã chuyển và chưa nhận'
                      when 3 then  'Đã chuyển và đã nhận'
                      when 4 then  'Bị trả lại'
                      end ) TRANGTHAICHUYEN

                  , d.CHIDAO_THOIHAN ,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
                  , va.THAMTRAVIENID,(Select HOTEN from DM_CANBO where ID=va.THAMTRAVIENID) TENTHAMTRAVIEN
                  , va.LANHDAOVUID,(Select HOTEN from DM_CANBO where ID=va.LANHDAOVUID) TENLANHDAOVU 
                  , va.THAMPHANID,(Select HOTEN from DM_CANBO where ID=va.THAMPHANID) TENTHAMPHAN
                  , NVL(va.ID, 0) VuAnID, NVL(va.TOAPHUCTHAMID, 0) IsMapVuAn
                  ,(case NVL(va.TRANGTHAIID, 3) when 3 then 0 else 1 end) as IsKetQuaGQDon 

                  , NVL(va.SOTHULYDON,0) VA_SoThuLy, va.NGAYTHULYDON VA_NgayThuLy
                  , NVL(va.SOANPHUCTHAM,'') VA_SoBA, va.NGAYXUPHUCTHAM VA_NgayBA
                  , NVL(va.TOAPHUCTHAMID,0) VA_ToaPT, NVL(va.QHPL_DINHNGHIAID,0) VA_QHPL

                  ,dc.ARRDONTRUNG, dc.SOLUONGDON SODON

                  ,(SELECT LISTAGG(TO_CHAR(cv.CV_TENDONVI) 
                                  || ' chuyển đến theo CV/PC số ' || cv.CV_SO 
                                  || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'), '; ')
                     WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE cv.LOAIDON=3 
                        and  (',' || dc.ARRDONTRUNG || ',') like ('%,' || cast(cv.ID as varchar2(10)) || ',%')
                     ) arrCongvan

                   , d.PHANLOAIXULY
                  ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 
                    then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Theo số TL: ') || cv.TL_SO
                    || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy')
                    || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
                       FROM GDTTT_DON cv  
                       WHERE cv.ISTHULY=1 And cv.ID<d.ID
                              And (cv.ID = d.ID or cv.DONTRUNGID=d.ID 
                                 Or ( cv.ID in ( select ID from GDTTT_DON 
                                                where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0 )))
                       )  End) arrTTTL
                   --,decode(ths.NGAYNHAN,null,sysdate(),ths.NGAYNHAN) NGAYGIAOTHS
                    ,ths.NGAYNHAN NGAYNHANTHS
                    ,ths.NGUOICHUYEN_ID
                    ,(Select HOTEN from DM_CANBO where ID=ths.NGUOICHUYEN_ID) TENTTVGIAO
                    ,(Select HOTEN from DM_CANBO where ID=ths.NGUOINHAN_ID) TENTTVNHAN
                    ,ths.NGUOINHAN_ID
                    ,ths.GHICHU GHICHUTHS, ths.id ths_ID
                from GDTTT_DON d
--                     inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
                     left join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
                     left join GDTTT_VuAn va on d.VUVIECID = va.ID
                     left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
                     left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
                     left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
                     left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
                     left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
                     left join GDTTT_DON_GIAONHAN_THS ths on d.id =  ths.DONID

                where d.TOAANID=vToaAnID  

               And 1=(Case when vIsThuLy=-1 then 1 
                           when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                          when vIsThuLy=1 
                            and (NVL(d.ISThuLy, 0)=1 
                                  or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                                  then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                            else 0 end,0)>0)  then 1
                      Else 0 End) 
                and (vToaRaBAQD = 0 or d.BAQD_TOAANID=vToaRaBAQD)
                and (IsGhepVuAn=2 or (IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 ) 
                                  or (IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 )
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
                and (vNguoiGui || ' '=' ' or lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%')
                and (vSoCMND || ' '=' ' or d.NGUOIGUI_CMND like '%' || vSoCMND || '%' )

                and (vHinhThucDon=0 or d.LOAIDON=vHinhThucDon)
                and (vSoHieuDon || ' '=' ' or d.MADON =vSoHieuDon)
                and (vDiaChiTinh=0 or d.NGUOIGUI_TINHID=vDiaChiTinh)
                and (vDiaChiHuyen=0 or d.NGUOIGUI_HUYENID=vDiaChiHuyen)
                and (vDiaChiCT || ' '=' ' or lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%')     
                and (vSoCongVan || ' '=' ' or lower(d.CD_SOCV) like  lower(vSoCongVan))     
                and (vNgayCongVan || ' '=' ' or to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan)
                and (vTraLoi=0 or d.TRALOIDON=vTraLoi)
                and (vNguoiNhap || ' '=' ' or lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%'))
                and d.CD_TA_DONVIID=vCD_DONVIID 
                and d.CD_LOAI=0  

                and (vTuNgay is null or vTuNgay <= dc.NGAYNHAN)
                and (vDenNgay is null or dc.NGAYNHAN <= vDenNgay)
                and  (vNgaychuyenTu is null or vNgaychuyenTu <= dc.NGAYCHUYEN)
                and (vNgaychuyenDen is null or dc.NGAYCHUYEN <= vNgaychuyenDen)    

                and (vSoThuly || ' '=' ' or lower(d.TL_SO) like  lower(vSoThuly))
                and (vArrSelectID  || ' '=' ' or vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%')
                and (vPhanloaixuly=0 or d.PHANLOAIXULY=vPhanloaixuly)
                and  d.CD_TRANGTHAI=vTrangthai 
                and (vPhancongTTV=0 or (vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV))
                    -- them loai an
                and (vloaian  = 0 or vloaian >0 and NVL(d.BAQD_LOAIAN,0) = vloaian)
                 --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
                    AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                        OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                        OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
                      )
                ) a
     )
    LOOP
    -------TẠO DỮ LIỆU CỦA BÁO CÁO
      CountAll_S:=item.CountAll;

      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.CD_SOCV||'<br/>'||item.CD_NGAYCV||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TL_SO||'<br/>'||item.TL_NGAY_TEXT||'<br/>'||item.TRANGTHAITHULY||'<br/>'||item.arrTTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.DONGKHIEUNAI||'<br/>'||item.arrCongvan||'<br /><i>(Ngày VP xử lý: '||item.NgayTaoStr||')</i></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.Diachigui||'</td>                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BAQD_SO||'<br/>'||item.BAQD_NGAYBA||'<br/>'||item.TOAXX_VietTat||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.GHICHU||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTTVGIAO||'</td>
                <td style="text-align: center; vertical-align: bottom; border: 0.1pt solid #000000;">'||item.TENTTVNHAN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYNHANTHS,'dd/MM/yyyy')||'</td>
            </tr>
        ');
  END LOOP;
    -------TẠO BÁO CÁO

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
                <td colspan="13" style="line-height: 100%; font-size: 14pt"><b>DANH SÁCH ĐƠN GIAO TTV </b>
                    <br />');
        if (vtungay is not null and vdenngay is not null) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'            
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vtungay,'dd/MM/yyyy')||'  đến ngày '||to_char(vdenngay,'dd/MM/yyyy')||')</i>');
        elsif (vtungay is null and vdenngay is not null) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'            
                    <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(vdenngay,'dd/MM/yyyy')||')</i>');
        elsif (vtungay is not null and vdenngay is null) THEN
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'            
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(vtungay,'dd/MM/yyyy')||'  đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>');
        else 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'            
                    <i style="font-size: 12pt;">(Số liệu tính đến ngày '||to_char(sysdate,'dd/MM/yyyy')||')</i>');
        end if;           

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'       
                </td>
            </tr>
            ');
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số đơn là: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"> Số<br />
                                            CV chuyển</td>
                 <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số<br />
                                            thụ lý </td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người đề nghị, kiến nghị, thông báo</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Địa chỉ</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thông tin BA/QĐ đề nghị GĐT,TT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người Giao</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người Nhận</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày Nhận</td>
            </tr>
            ');  
--       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <tr style="height: 1pt;">
                <td style="width: 20pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                <td style="width: 120pt"></td>
                 ');
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                 ');
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
END GDTTTT_DON_GIAONHAN_THS_PRINT;


FUNCTION  GDTTTT_QLTOTRINH_BC_SEARCH
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
                  --anhvh
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

                , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                 ----------anhvh 12/10/2019 
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
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
         ----lấy tên đương sự được khiếu nại --anhvh add 29/05/2021
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
               --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
               ----anhvh
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
              --anhvh add 25/12/2019
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--              and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              -- Tờ trình lãnh đạo anhvh 02/11/2019
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
          and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID 
                                                            and NGAYTRA IS NOT NULL 
--                                                            and ((TINHTRANGID = vtrangthai AND vtrangthai!=0) OR vtrangthai=0) 
                                                            and loaiykien = 1
                                                            and TINHTRANGID >= 7
                                                             ) -- dã có ý kiến KN từ PCA, CA, TTP


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
                  --anhvh
                ,DECODE(AQH.VuViecID,NULL,0,1)SoCV81--NVL(v.IsAnQuocHoi, 0) as SoCV81,
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,(SOANPHUCTHAM || chr(10)||DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))) TTBANANPT
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
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ma,'') MaChucVuLD  
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                 ----------anhvh 12/10/2019 
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
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_CANBO tp on v.THAMPHANID=tp.ID
              left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
              left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
              left join DM_DataITem cv on ld.ChucVuID = cv.ID
              left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID

               --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
               ----anhvh
              LEFT JOIN TABLE(v_table_all) TA ON TA.VUANID=V.ID
              LEFT JOIN GDTTT_DM_TINHTRANG tts on tts.ID= TA.TINHTRANGID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
              --anhvh add 25/12/2019
              and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                     or  (vloaian = v.LOAIAN and vloaian!=0) 
                )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( curr_thamphan_id = 0 or v.THAMPHANID=curr_thamphan_id Or (curr_thamphan_id = -1 and NVL(v.THAMPHANID,0) = 0) )
--              and ( curr_thamphan_id = 0 or (curr_thamphan_id = 20325 and v.ghichu like '%Hoàng Anh%') or ( curr_thamphan_id != 20235 and v.THAMPHANID=curr_thamphan_id ))
              and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              -- Tờ trình lãnh đạo anhvh 02/11/2019
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
          and  EXISTS(select ID from GDTTT_TOTRINH where v.ID = VUANID 
                                                            and NGAYTRA IS NOT NULL 
                                                            and loaiykien = 0
                                                            and TINHTRANGID >= 6
                                                             ) -- dã có ý kiến trả lời đơn từ cấp TP, PCA, CA,TTP


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
END GDTTTT_QLTOTRINH_BC_SEARCH;


FUNCTION GDTTTT_VUAN_GQD_BC_SEARCH
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

  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 

  vLoaiNgay in number,
  vGQD_TuNgay in date,
  vGQD_DenNgay in date,

  vKetquathuly in number,
  vKetquaxetxu in number,  
  LoaiAnDB in number,
  vLoaiAnDB_TH in varchar2,
  vTypeTB in number,
  vThoihieu in number,
  PageIndex	in	int,
  PageSize	in	int
)RETURN SYS_REFCURSOR
IS 
  TotalItem number; V_CURSOR sys_refcursor;V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;  
  CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(2000);
  vvGQD_DenNgay date;vvngaythulyden date;
  vvvGQD_TuNgay date;vvvNgayThulyTu date;TuNgay_char varchar2(500);
  v_ghichu varchar2(2000);
BEGIN
  DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
  -----
  SELECT DECODE(vGQD_DenNgay,null,DECODE(vngaythulyden,NULL,sysdate,vngaythulyden),vGQD_DenNgay),DECODE(vngaythulyden,null,DECODE(vGQD_DenNgay,NULL,sysdate,vGQD_DenNgay),vngaythulyden) into vvGQD_DenNgay,vvngaythulyden from dual;
  --dung cho bao cao
  SELECT DECODE(vGQD_TuNgay,null,DECODE(vNgayThulyTu,NULL,NULL,vNgayThulyTu),vGQD_TuNgay),DECODE(vNgayThulyTu,null,DECODE(vGQD_TuNgay,NULL,NULL,vGQD_TuNgay),vNgayThulyTu) into vvvGQD_TuNgay,vvvNgayThulyTu from dual;
  SELECT DECODE(vvvGQD_TuNgay,NULL,NULL,' từ ngày '||to_char(vvvGQD_TuNgay,'dd/MM/yyyy') ) into TuNgay_char from dual;
  -----
  FOR item IN (
     select a.*
          ,'' arrDONID , '' arrCV81ID   , '' arrCHIDAOID
        from ( Select   Count(v.ID) OVER () as CountAll,ROW_NUMBER() OVER (ORDER BY v.GQD_NgayPhatHanhCV desc, v.GDQ_NGAY desc, v.NGAYTHULYDON desc) STT
                ,DECODE(v.TongDon,NULL,'','<br/>Số đơn '||v.TongDon) as TongDon 
                  --anhvh
                  ,DECODE(AQH.VuViecID,NULL,'','<br/>Án Quốc hội ')SoCV81
                  --
                 ,DECODE(v.IsAnChiDao,'NULL','','0','','<br/>Án chỉ đạo ') as IsAnChiDao 
                , v.LoaiAn, v.ID,v.MAVUAN,PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                ,Decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI

                ,(SELECT LISTAGG(TO_CHAR(cv.CV_TENDONVI) 
                                  || ' chuyển đến theo CV/PC số ' || cv.CV_SO 
                                  || ' ngày ' || TO_CHAR(cv.CV_NGAY,'dd/MM/yyyy'), '; ')
                     WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE cv.LOAIDON=3 
                                                                                        and cv.cd_trangthai = 2 
                                                                                        and cv.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM where  TEM.ID=546 OR TEM.CAPCHAID=546 OR TEM.ID = 1023 OR TEM.CAPCHAID=1023)
                                                                                        and cv.vuviecid = v.id 
                     ) arrCongvan


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
                ,decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
                ,case when NguyenDon is not null then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                           when NguyenDon is null and BiDon is not null  then decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT)
                        end as QHPNDN_Report
                , NVL(v.THAMTRAVIENID, 0) THAMTRAVIENID
                , ttv.HOTEN as TENTHAMTRAVIEN
                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                    end  NGAYPHANCONGTTV
                  , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ten,'') ChucVuLanhDao, NVL(cv.Ma,'') MaChucVuLD       
                , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                , v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                , v.TRANGTHAIID, tt.TENTINHTRANG
                , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS'))
                  end QUATRINH_GHICHU
                ----------------------------------
                , v.GDQ_SO 
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 5, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3,GQD_KETQUA
                              , 4,'VKS đang giải quyết') KQ_GQD,v.GQD_KETQUA
                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                ,CASE WHEN v.GQD_LOAIKETQUA in (3,4) THEN v.GQD_KETQUA
                     else DECODE(v.GQD_LOAIKETQUA,0,'TLĐ',1,'KN',2,'XĐ')||'-'||DECODE(v.LoaiAn,1,'HS',2,'DS',3,'KDTM',4,'LĐ',5,'HC')
                     || ' Số: '||translate(v.GDQ_SO using nchar_cs)|| ' Ngày: '||to_char(V.GDQ_NGAY,'dd/MM/yyyy')
                     end KQ_GQDS
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')
                  end LoaiKN
                , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  
                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                -------------------------------
                , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                , NVL(tt.GiaiDoan, 0) GiaiDoan
                  -------------------------------
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',1) NgayTPDuyet
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',2) NgayTrinhTP
                , GDTTT_ToTrinh_GetYKien(v.Id, 'TP',1) YKienTP
                , (v.SOANPHUCTHAM || chr(10) 
                || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                    end) as TTBANANPT
              ---------------------------
                  , v.SOTHULYXXGDT
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
                --manhnd--hien thi lich su cac ttv duoc phan cong---
                , GDTTT_HISTORY_TTV(v.ID, 1) PhanCongTTV
                ,GDTTT_HOSO_SEARCH(V.ID,3) NgayTTVNhanHS   
              from GDTTT_VUAN v 
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
              --left join (Select ID, NgayTao from GDTTT_QUanLyHS where Loai=3) hs on hs.ID = NVL(v.HoSoID,0)
              --anhvh add 21/11/2019 check ngày của vụ và ngày công văn dùng cho việc truy vấn phí dưới
              LEFT JOIN (SELECT VVA.ID,CASE WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GQD_NGAYPHATHANHCV 
                                  WHEN ( VVA.GQD_NGAYPHATHANHCV IS  NULL AND VVA.GDQ_NGAY IS NOT NULL)  THEN  VVA.GDQ_NGAY 
                                  WHEN (VVA.GQD_NGAYPHATHANHCV IS NOT NULL AND VVA.GDQ_NGAY IS NULL) THEN  VVA.GQD_NGAYPHATHANHCV 
                                  END GQD_NGACVS FROM GDTTT_VUAN VVA)VA ON VA.ID=V.ID
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
              ----
              where 
               v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
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
              and ( vloaian = 0 or  vloaian = v.LOAIAN )
              and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien Or (vThamtravien = -1 and NVL(v.THAMTRAVIENID,0) = 0))
              and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
              and ( vThamphan = 0 or v.THAMPHANID=vThamphan Or (vThamphan = -1 and NVL(v.THAMPHANID,0) = 0))
               ----------------------------------
              ------Ket qua giai quyet don Dan sư mo rọng----------------------------
              and ( 
              vKetquathuly = 3
                   OR (v.LOAIAN != 1 and vKetquathuly = 4 and 
                                    ( 
                                        ( vLoaiNgay=0 and (
                                                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
                                                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vvGQD_DenNgay and GQD_NGAYPHATHANHCV >=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                        
                                                        )
                                              )  
                                         OR 
                                         (vLoaiNgay=1 and  (
                                                            
                                                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
                                                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GQD_NGAYPHATHANHCV >=vvGQD_DenNgay 
                                                                                        and vuanid = v.id
                                                                                        )
                                                            
                                                            )

                                          )    
                                          OR(vLoaiNgay=2 and (
                                                              
                                                            Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
                                                            OR Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GDQ_NGAY >=vvGQD_DenNgay 
                                                                                        and vuanid = v.id
                                                                                        )
                                                              
                                                            )
                                          )  
                                    )         
                   )
                or ( v.LOAIAN != 1 and vKetquathuly = 5 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and vuanid = v.id ) 
                                                                                        ) -- có kết quả
                or ( v.LOAIAN != 1 and vKetquathuly = 0 and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and vuanid = v.id
                                                                                        )) -- trả lời đơn
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
                or ( v.LOAIAN != 1 and vKetquathuly = 7 and (Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0
                                                                                        and vuanid = v.id
                                                                                        ) 
                                            )
                                      --and exists (Select 'x' from GDTTT_VUAN_KETQUA_DON WHERE DONID NOT IN (SELECT ID FROM GDTTT_DON WHERE VUVIECID = V.ID))  
                                            )--7 Đã có KQ nhưng vẫn còn đơn TLM                                             
                or ( v.LOAIAN != 1 and vKetquathuly = 11  
                        and  NVL(v.isvientruongkn,0) = 0
                        and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 0 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                        and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 1 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                        
                        ) --11 Trả lời đơn + Kháng nghị(CA)
                or ( v.LOAIAN != 1 and vKetquathuly = 12  
                                and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 0 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 2 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                
                                ) --12 Trả lời đơn + Xếp đơn
                 or ( v.LOAIAN != 1 and vKetquathuly = 13  
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                            where  GQD_LOAIKETQUA = 0 
                                            and TRANGTHAI != 0
                                            and vuanid = v.id
                                            )
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                where  GQD_LOAIKETQUA = 3 
                                                                and TRANGTHAI != 0
                                                                and vuanid = v.id
                                                                )
                                            
                                            )--13 Trả lời đơn + Xử lý khác
                 or ( v.LOAIAN != 1 and vKetquathuly = 14  
                            and  NVL(v.isvientruongkn,0) = 0 
                                 
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 1 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                            and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 2 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                    
                                    )--14 Kháng nghị (CA) + Xếp đơn
                 or ( v.LOAIAN != 1 and vKetquathuly = 15  
                               
                                and  NVL(v.isvientruongkn,0) = 0 
                                and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 1 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                    and Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                            where  GQD_LOAIKETQUA = 4 
                                                            and TRANGTHAI != 0
                                                            and vuanid = v.id
                                                            )
                                
                                )--15 Kháng nghị (CA) + Xử lý khác
                ---------Ap dung cho an Hinh su do dang luu rieng------------------------------------------
                    or (v.LOAIAN = 1 and vKetquathuly = 4 
                                     and(  
                                                ( vLoaiNgay=0 and  
                                                            (  v.gqd_loaiketqua is null
                                                                    or (v.gqd_loaiketqua is not null and VA.GQD_NGACVS>=vvGQD_DenNgay)
                                                                 )
                                                    )
    
                                             OR (vLoaiNgay=1 and  (  (v.gqd_loaiketqua is null) or 
                                                                   (v.GQD_NGAYPHATHANHCV>vvGQD_DenNgay)
                                                               )
    
                                              )    
                                              OR(vLoaiNgay=2 and  (  (v.gqd_loaiketqua is null) or 
                                                                     (v.GDQ_NGAY>vvGQD_DenNgay)
                                                                  )
                                              )                 
                                            )        
                       )
                    or (v.LOAIAN = 1 and vKetquathuly = 5 and v.gqd_loaiketqua in (0,1,2,3,4)
                            AND v.TrangThaiID  in (13,14,15,16,18,19)) -- có kết quả
                    or (v.LOAIAN = 1 and vKetquathuly = 0 and v.gqd_loaiketqua = 0) -- trả lời đơn
                    or (v.LOAIAN = 1 and vKetquathuly = 1  and v.gqd_loaiketqua = 1 
                               and (v.nguoikhangnghi IN (9, 1143) or isvientruongkn is null)
                        ) --khang nghị CA
                --or (vKetquathuly = -1 and v.gqd_loaiketqua = 1) --khang nghị CA + VKS
                    or (v.LOAIAN = 1 and vKetquathuly = 2 and v.gqd_loaiketqua= 2) --- xếp đơn
                    or (v.LOAIAN = 1 and vKetquathuly = 6 and v.gqd_loaiketqua = 3) -- xử lý khác
                    or (v.LOAIAN = 1 and vKetquathuly = 8  and v.gqd_loaiketqua= 4) ---VKS đang giải quyết
                -------------Ket thuc ap dung cho an Hinh su------------------------------------------------
                )   
             
                ---Loại ngày-------------------------------
                AND( vKetquathuly = 3
                        OR(vKetquathuly != 3 and  v.LOAIAN != 1
                            and 
                            (
                                (vLoaiNgay=0  
                                    and ( vKetquathuly=4 
                                            or (vKetquathuly!=4 
                                                    and(
                                                        (Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 0 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                            )
                                                        OR (Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 1 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                            )
                                                        OR ( Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 2 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 2
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                                )
                                                        OR ( Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 3 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                                )
                                                        OR ( Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY <=vvGQD_DenNgay Or GQD_NGAYPHATHANHCV <=vvGQD_DenNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where GQD_LOAIKETQUA = 4 
                                                                                        and TRANGTHAI != 0 
                                                                                        and (GDQ_NGAY >=vGQD_TuNgay Or GQD_NGAYPHATHANHCV >=vGQD_TuNgay)
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                                )
                                                  )
                                            )
                                        )
                                    )
                          
                                OR (vLoaiNgay = 1 and      
                                        ( vKetquathuly=4 
                                            or (vKetquathuly!=4 
                                                and(
                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GQD_NGAYPHATHANHCV <=vvGQD_DenNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where TRANGTHAI != 0 
                                                                                        and GQD_NGAYPHATHANHCV >=vGQD_TuNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null) 
                                                    )
                                                )
                                            )
                                                   
                                    )
                                OR (vLoaiNgay = 2 and 
                                        ( vKetquathuly=4 
                                            or (vKetquathuly!=4 
                                                    and(
                                                        Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where  TRANGTHAI != 0 
                                                                                        and GDQ_NGAY <=vvGQD_DenNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                AND( 
                                                                    Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                        where TRANGTHAI != 0 
                                                                                        and GDQ_NGAY >=vGQD_TuNgay
                                                                                        and vuanid = v.id
                                                                                        )
                                                                        OR vGQD_TuNgay is null)                                                        
                                                    )
                                                )
                                            )
                                    )
                                 ) 
                            ) 
                         ---------Ap dung cho an Hinh su do dang luu rieng------------------------------
                        OR (vKetquathuly != 3 and v.LOAIAN = 1 and
                                ( vLoaiNgay=0 and (
                                                        (vKetquathuly=4) 
                                                        or (vKetquathuly!=4 AND ((VA.GQD_NGACVS>=vGQD_TuNgay AND vGQD_TuNgay IS NOT NULL) OR vGQD_TuNgay IS NULL)
                                                                           AND (VA.GQD_NGACVS<=vvGQD_DenNgay)
                                                            ) 
                                                        or (vKetquathuly!=4 AND v.gqd_loaiketqua is not null and VA.GQD_NGACVS is null and v.GQD_NGAYPHATHANHCV is null )
                                                     )
                                     )           
                                 OR (vLoaiNgay=1 AND (   (vKetquathuly!=4 AND ((v.GQD_NGAYPHATHANHCV>=vGQD_TuNgay AND vGQD_TuNgay IS NOT NULL) OR vGQD_TuNgay IS NULL)
                                                                       AND ((v.GQD_NGAYPHATHANHCV<=vGQD_DenNgay AND vGQD_DenNgay IS NOT NULL) OR vGQD_DenNgay IS NULL)   
                                                          )
                                                        OR (vKetquathuly=4) 
                                                     )   
                                    ) 
                                 OR (vLoaiNgay=2 AND (   (vKetquathuly!=4 AND ((v.GDQ_NGAY>=vGQD_TuNgay AND vGQD_TuNgay IS NOT NULL) OR vGQD_TuNgay IS NULL)
                                                                     AND ((v.GDQ_NGAY<=vGQD_DenNgay AND vGQD_DenNgay IS NOT NULL) OR vGQD_DenNgay IS NULL)  
        
                                                         )
                                                        OR (vKetquathuly=4) 
                                                     ) 
                                    )
                            ) 
                        ----------------------------------------------------
                        
                   )
                

               
             
               AND (V.ISVIENTRUONGKN is null OR V.ISVIENTRUONGKN = 0)
                ----------------------------------
                and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu))
                and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO <=vngaythulyden)
                                                or(vKetquathuly =4)
                                            )
                     )                       
                and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%') 
              --Kết quả xét xử
             and ( vKetquaxetxu = 0
                or (vKetquaxetxu = -1 --and NOT EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) 
                          AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GetLastXX(v.ID, 0)=0)
                or (vKetquaxetxu = -2 and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID) AND PKG_GDTTT_BAOCAO_APP.GDTTT_XXGDTTT_GetLastXX(v.ID, 0)>0)
                or (vKetquaxetxu NOT IN (0, -1, -2)  and EXISTS(select 'X' from gdttt_vuan_xetxugdttt where v.ID = VUANID and KETQUAID = vKetquaxetxu))
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
                        or (LoaiAnDB = 4  and NVL(v.ISANTRAODOICV,0)=1)
                 )
               --Án thời hiệu
            AND ( vLoaiAnDB_TH IS NULL
                  or (vLoaiAnDB_TH = 0 AND v.gqd_loaiketqua is null 
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(NVL(v.LoaiAn,0),decode(v.NGAYXUPHUCTHAM,null,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM), v.NGAYTHULYDON, NVL(v.ThuLyLai_VuAnId, 0),vThoihieu,Decode(v.ISXINANGIAM,1,1,Decode(v.ISXINANGIAM,2,1,0)))<=0)
                  or (vLoaiAnDB_TH = 1 AND v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(NVL(v.LoaiAn,0),decode(v.NGAYXUPHUCTHAM,null,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM), v.NGAYTHULYDON, NVL(v.ThuLyLai_VuAnId, 0),vThoihieu,Decode(v.ISXINANGIAM,1,1,Decode(v.ISXINANGIAM,2,1,0)))<30 
                    )
                 or (vLoaiAnDB_TH = 2 AND v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(NVL(v.LoaiAn,0),decode(v.NGAYXUPHUCTHAM,null,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM), v.NGAYTHULYDON, NVL(v.ThuLyLai_VuAnId, 0),vThoihieu,Decode(v.ISXINANGIAM,1,1,Decode(v.ISXINANGIAM,2,1,0)))<60
                    )
                 or (vLoaiAnDB_TH = 3 AND v.gqd_loaiketqua is null
                    and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(NVL(v.LoaiAn,0),decode(v.NGAYXUPHUCTHAM,null,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM), v.NGAYTHULYDON, NVL(v.ThuLyLai_VuAnId, 0),vThoihieu,Decode(v.ISXINANGIAM,1,1,Decode(v.ISXINANGIAM,2,1,0)))<90
                    )
                ) 

               --------------------Thông báo
              and ( vTypeTB = 0 
                or (vTypeTB =1 and GDTTT_TB_CountTB(v.ID, 1)=0)-- chua co tb tt
                or (vTypeTB =2 and GDTTT_TB_CountTB(v.ID, 1)>0) -- da co tb tt
                or (vTypeTB =3 and GDTTT_TB_CountTB(v.ID, 2)=0)-- chua co tb TLdon
                or (vTypeTB =4 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co tb TL don
                or (vTypeTB =5 and (select NVL(count(ID),0) from GDTTT_DON_TRALOI where VuAnId=v.ID)=0)--chua co ca 2
                or (vTypeTB =6 and GDTTT_TB_CountTB(v.ID, 1)>0 and GDTTT_TB_CountTB(v.ID, 2)>0)-- da co ca 2
                )
         )a  
       )
    LOOP
     -------TẠO DỮ LIỆU CỦA BÁO CÁO
    CountAll_S:=item.CountAll;
      DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
         <tr style="font-size: 11pt;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOANPHUCTHAM||'<br style="mso-data-placement:same-cell;"/>'||item.NGAYXUPHUCTHAM||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TOAXX_VietTat||'</td>                
        ');  
        if(vLoaiAn=01)THEN--vLoaiAn=01 là hình sự
                IF(item.NGUYENDON=item.BIDON)THEN
                  V_BIDON_CHECK:=item.NGUYENDON;
                ELSIF(item.NGUYENDON!=item.BIDON AND item.NGUYENDON !='' AND item.BIDON!='') THEN
                  V_BIDON_CHECK:=item.NGUYENDON||', <br style="mso-data-placement:same-cell;"/>'||item.BIDON;
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||to_char(item.NGAYTTVNHAN_THS,'dd/MM/yyyy')||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NgayTTVNhanHS||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.arrCongvan||'</td>
             ');

             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenThamTraVien||'</td>');
             v_ghichu := null;
             IF (ITEM.ISTOTRINH = 1)THEN
                select g.ghichu into v_ghichu  from(
                         select vuanid, LISTAGG(to_char(NGAYTRINH,'dd/MM/yyyy')||
                        ' '||
                       decode(TINHTRANGID,9,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),17,REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),REPLACE(REPLACE(REPLACE((select TENTINHTRANG from GDTTT_DM_TINHTRANG where id = TINHTRANGID),'Phó Chánh án',''),'Chánh án',''),'Thẩm phán',''))||
                        decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                        (select hoten from DM_CANBO  where id = lanhdaoid) ||

                        '; '||
                        to_char(NGAYTRA,'dd/MM/yyyy')||
                        decode(TINHTRANGID,7,' PCA ',8,' Chánh án ',6,' TP ',12,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP '),11,decode((select chucvuid from DM_CANBO  where id = lanhdaoid),74,' PCA ',45,' Chánh án ',' TP ')) ||
                        (select hoten from DM_CANBO  where id = lanhdaoid) || 
                        decode(loaiykien,1,' duyệt KN ',0,' duyệt TLĐ ',loaiykien)||
                        decode(loaiykien,null,' '||YKIEN,null)                 
                        , '; ' ) WITHIN GROUP( ORDER BY  NGAYTRA ) AS GHICHU  
                                    from  (SELECT SS.* FROM GDTTT_TOTRINH SS WHERE  SS.VUANID = item.id
                                                                         and ss.ID =(SELECT Max(ID) FROM GDTTT_TOTRINH S WHERE  S.VUANID = item.id)  
                                                              ORDER BY SS.NGAYTRINH ASC) a group by vuanid) g;
                    DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">- '||v_ghichu||'</td>');
                ELSE
                    DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'    
                        <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>');
                END IF;



             DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
            </tr>
        ');
  END LOOP;
  -------TẠO BÁO CÁO
    SELECT DECODE(vKetquathuly,4,'chưa có kết quả giải quyết',5,'đã có kết quả giải quyết',null) into vvKetquathuly from dual;
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
                <td colspan="13" style="line-height: 100%; font-size: 14pt;text-align:center;"><b>DANH SÁCH ÁN SẮP HẾT THỜI HIỆU '||vThoihieu||' NĂM '||upper(vvKetquathuly)||'</b>
                    <br style="mso-data-placement:same-cell;"/>
                    <i style="font-size: 12pt;">(Số liệu tính'||TuNgay_char||' đến ngày '||to_char(vvngaythulyden,'dd/MM/yyyy')||')</i>
                </td>
            </tr>
            <tr>
                <td colspan="13" style="height: 15pt; text-align: left;">Tổng số: '||CountAll_S||'</td>
            </tr>
            <tr style="font-weight:bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bản án
                    <br style="mso-data-placement:same-cell;"/>
                    số ngày</td>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận THS</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày nhận HS</td>
                 ');  


                  DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">CV chuyển đơn</td>
                '); 

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
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 120pt"></td>
                 '); 
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');

              DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 160pt"></td>
            </tr>
        </table>
      ');
     OPEN V_CURSOR FOR
--      SELECT curr_thamphan_id curr_thamphan_idS FROM DUAL;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;     
END GDTTTT_VUAN_GQD_BC_SEARCH;

END PKG_GDTTT_VUAN_INBC;

/
