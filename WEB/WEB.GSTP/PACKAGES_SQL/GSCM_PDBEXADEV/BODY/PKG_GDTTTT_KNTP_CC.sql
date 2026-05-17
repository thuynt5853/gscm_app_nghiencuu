--------------------------------------------------------
--  DDL for Package Body PKG_GDTTTT_KNTP_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTTT_KNTP_CC" AS

  PROCEDURE  GDTTTT_KNTP_SEARCH
        ( 
          v_ID_USER VARCHAR2,
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
          
          vNgayThulyTu in date,
          vNgayThulyDen in date,
          vSoThuly in varchar2, 
        
          vTrangthai in number,
        
          vKetquathuly in number,
        
          isTTMuonHS in number,
          LoaiAnDB in number,
          vNoidungKN in varchar2,
          
          v_SodonTLM        in number,
          v_loaingaysearch in number,
          v_NgaySearch_Tu in date,
          v_NgaySearch_Den in date,
          
          PageIndex	in	int,
          PageSize	in	int,
          curReturn OUT sys_refcursor
        )
    IS
         TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
          vvngaythulyden date;vvloaian VARCHAR2(150);
          temp_sobanan nvarchar2(50);
          --------------------------
          v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
          LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;
          -----------------------
          v_table_all T_TINHTRANG; vNgayThulyDen_all date;
          LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE;
          ----------------
           vvTuNgay date;vvDenNgay date;V_CANBOID number;ma_chucvu_user VARCHAR2(150);
    BEGIN
           -----
          SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
          -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
          v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
          -------------------------
          ---anhvh add 25/09/2020 check dữ liệu theo PCA
          SELECT NSD.CANBOID INTO V_CANBOID FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;
           -----------------------------------------------------------------------------
          MinIndex := PageSize*(PageIndex - 1) + 1;
          MaxIndex := PageIndex*PageSize ;

           OPEN curReturn FOR
             SELECT TT.* FROM ( 
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
                               , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                               ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                               ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                               --,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                               ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                         --manhnd
                              , case when BAQD_CAPXETXU = 4 
                                                then decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:')|| NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                                     '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                                     '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||
                                                      decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                                '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten))||
                                                      decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                            '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten))
                                     when BAQD_CAPXETXU = 3  then
                                                     decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:')||NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                                     '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                                     '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||
                                                      decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                      '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten))

                                     when BAQD_CAPXETXU = 2 
                                                then decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:')|| NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                                     '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                                     '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)
                                     else
                                                    decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:') || NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                                    ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                                    ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                                     end InforBA
                              --
                                , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                                 --,qhpl.TENQHPL QHPLDN
                                 ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                                       when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                                    end as QHPNDN_Report
                                ,tp.HOTEN as TENPCA
                                ,ttv.HOTEN TENTHAMTRAVIEN
                                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                                    end  NGAYPHANCONGTTV
                                , ld.HOTEN as TENLANHDAO   
                                , cv.Ten ChucVuLanhDao,decode(cv.Ma,'041','LĐP','042','LĐP',cv.Ma) MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                                , NVL(v.GQD_LOAIKETQUA,4) KQ_GQD_ID
                                --anhvh edit
                                , DECODE(v.GQD_LOAIKETQUA,3,decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                                                        , 2,'Xếp đơn' 
                                                        , 1, 'Không chấp nhận khiếu nại'
                                                        , 0,'Chấp nhận khiếu nại') KQ_GQD--,4,'Giải quyết khác'

                                --DECODE(NVL(v.GQD_LOAIKETQUA,3), 3, '' , 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' ) KQ_GQD
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
                                 ,decode(v.THAMTRAVIENID,null, v.TENTHAMTRAVIEN,ttv.hoten) PHANCONGTTV
                                 ,v.TRUONGHOPTHULY
                                 ,CASE  WHEN (KNTC.LOAIKNTC LIKE '%1%' AND KNTC.LOAIKNTC LIKE '%2%') THEN 'Khiếu nại và Tố cáo'
                                        WHEN (KNTC.LOAIKNTC NOT LIKE '%1%' AND KNTC.LOAIKNTC LIKE '%2%') THEN 'Tố cáo'
                                        ELSE 'Khiếu nại'
                                        END LOAIKNTC
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
                              left join HD1 ON HD1.VUANID=v.ID
                              left join HD2 ON HD2.VUANID=v.ID
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
                              --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                                LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                         AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                            SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                            WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                            AND C.TOAANID=vToaAnID AND C.HIEULUC=1 
                                            AND C.ID=D.CHIDAO_LANHDAOID 
                                             )
                                          GROUP BY d.VuViecID
                                          )AQH_F ON AQH_F.VuViecID=V.ID

                              ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                              LEFT JOIN (
                                SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                              || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                        , ',<br/>')
                                    WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                                    FROM GDTTT_DON CV  
                                    WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1 AND CV.LOAIDON IN (8,10)
                                    GROUP BY CV.VUVIECID
                                )DD ON DD.VUVIECID=v.ID
                                ----- Loai Khieu nai Or To Cao
                              LEFT JOIN (
                                    SELECT D.VUVIECID,LISTAGG(D.LOAIKNTC, ',') WITHIN GROUP (ORDER BY D.LOAIKNTC DESC) LOAIKNTC FROM GDTTT_DON D
                                                    WHERE D.CD_TRANGTHAI=2 AND D.ISTHULY=1 AND D.LOAIDON IN (8,10) group by D.vuviecid 
                                    )KNTC ON KNTC.VUVIECID = V.ID
                                -----
                              where  v.TRUONGHOPTHULY in (8,10) -- Đơn khiếu nại tư pháp 
                                  and v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
                                  and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                              -----------------------
                                  and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                                  and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
                                  ----------------------
                                   AND (  (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                                    OR (UPPER(trim(v.BiDon)) like '%' || UPPER(trim(vNguyendon)) || '%') 
                                                    OR exists(select id from gdttt_vuan_duongsu ds where ds.VUANID = v.id and (ds.HS_BICANDAUVU = 1 or ds.HS_ISBICAO = 1) 
                                                                                    and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                              )

                                                    ))

                                         OR (NVL(v.LoaiAN,0)<>1 AND  trim(vNguyendon) || ' '!=' ' 
                                                AND (UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%')
                                                        OR exists(select id from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'NGUYENDON'
                                                                                    and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vNguyendon)) || '%')  
                                                                 )
                                                )
                                         OR (trim(vNguyendon) || ' '=' '
                                         OR UPPER(v.TENVUAN) like '%' || UPPER(vNguyendon) || '%'  
                                         )
                                      )            
                                  ----------------------
                                  and ( vBidon is null 
                                        or vBidon = '' 
                                        or UPPER(v.BIDON) like '%' || UPPER(vBidon) || '%'
                                        OR exists(select id from gdttt_vuan_duongsu ds where ds.VUANID = v.id and ds.TUCACHTOTUNG = 'BIDON'
                                                                                    and (UPPER(trim(ds.TENDUONGSU)) like '%' || UPPER(trim(vBidon)) || '%')  
                                                              )
                                            )
                                  and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.arrnguoikhieunai) like '%' || UPPER(vNguoiGui) || '%') 
                                  --anhvh add 25/12/2019
                                  and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                                         or  (vloaian = v.LOAIAN and vloaian!=0) 
                                    )
                                  and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien)
                                  and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                                   ---------------------------------------
                                  and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             

                                   -- Đã có hồ sơ
                                  and ( isTTMuonHS = 2
                                        or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                                        or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                                         -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) 
                                          ))
                                  -------liên quan đến tham số ngày---------------------
                                 and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
                                      )                    
                                   and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                                                   or(vKetquathuly =4)
                                                                )   
                                      )  

                               -- Kết quả thụ lý
                              and ( vKetquathuly =-1 
                                    or (vKetquathuly = 4  and  v.gqd_loaiketqua is null)
                                    or (vKetquathuly = 5  and v.gqd_loaiketqua in (0,1,2,3)) -- có kết quả
                                    -- Cap nhan khieu nai
                                    or (vKetquathuly = 0  AND  V.GQD_LOAIKETQUA=0)
                                     -- Khong chap nhan khieu nai
                                     or (vKetquathuly = 1 AND v.GQD_LOAIKETQUA=1)
                                    --- xếp đơn
                                    or (vKetquathuly = 2  AND v.GQD_LOAIKETQUA=2)
                                    --- Giai quyet khac
                                    or (vKetquathuly = 3  AND v.GQD_LOAIKETQUA=3)
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
                                    or(LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                               )
                             --Noi dung Khieu nai
                             and ( vNoidungKN is null or vNoidungKN = '' or UPPER(v.QHPL_TEXT) like '%' || UPPER(vNoidungKN) || '%')             

                            ---------------
                             and (v_SodonTLM = 0 
                                    or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                                    or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                                        (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                            where a.VuViecID = v.id and  cdon =1))
                                    or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                                        (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                            where a.VuViecID = v.id and  cdon >1))
                                  )
                           AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                                    --Ngay Cong van
                                    Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or (to_char(VA.GQD_NGACVS,'dd/MM/yyyy') != '01/01/0001' and VA.GQD_NGACVS is not null and VA.GQD_NGACVS >= v_NgaySearch_Tu ))          
                                                             and (v_NgaySearch_Den is null Or ( to_char(VA.GQD_NGACVS,'dd/MM/yyyy') != '01/01/0001' and VA.GQD_NGACVS is not null and VA.GQD_NGACVS < v_NgaySearch_Den )) 
                                    )
                                    --Ngay Phat hanh 
                                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or  (to_char(v.GQD_NGAYPHATHANHCV,'dd/MM/yyyy') != '01/01/0001' and v.GQD_NGAYPHATHANHCV is not null and v.GQD_NGAYPHATHANHCV >= v_NgaySearch_Tu )) 
                                                             and (v_NgaySearch_Den is null Or ( to_char(v.GQD_NGAYPHATHANHCV,'dd/MM/yyyy') != '01/01/0001' and v.GQD_NGAYPHATHANHCV is not null and v.GQD_NGAYPHATHANHCV < v_NgaySearch_Den ))
                                    )
                                     --Ngay phan TTV
                                   Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or (TRIM(V.TenThamTRaVien) IS NOT NULL 
                                                                                                and v.NGAYTTVNHAN_THS is not null
                                                                                                and to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') != '01/01/0001'
                                                                                                and v.NGAYTTVNHAN_THS >= v_NgaySearch_Tu                                   
                                                                                            )
                                                                    ) 
                                                            and (v_NgaySearch_Den is null Or (TRIM(V.TenThamTRaVien) IS NOT NULL 
                                                                                                and v.NGAYTTVNHAN_THS is not null
                                                                                                and to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') != '01/01/0001'
                                                                                                and v.NGAYTTVNHAN_THS < v_NgaySearch_Den                                   
                                                                                            )
                                                                            )
                                    )
                                )

                       )a where a.stt>=MinIndex and a.stt<=MaxIndex
               )TT;

  END GDTTTT_KNTP_SEARCH;

  FUNCTION  GDTTT_KNTP_SEARCH_PRINT( 
          v_ID_USER VARCHAR2,
          v_colume  in varchar2,
          v_asc_desc in varchar2,
          vToaAnID in number,
          vPhongBanID  in number,
          vToaRaBAQD in number,
          vSoBAQD in varchar2,
          vNgayBAQD in varchar2,
          vNguoiGui in varchar2,
          vCoquanchuyendon in varchar2,
          vLoaiAn in number,
          vThamtravien in number,
          vLanhdao in number,
          vNgayThulyTu in date,
          vNgayThulyDen in date,
          vSoThuly in varchar2, 
          vTrangthai in number,
          vKetquathuly in number,
          isTTMuonHS in number,
          LoaiAnDB in number,
          vNoidungKN in varchar2,
          v_SodonTLM   in number,
          v_loaingaysearch in number,
          v_NgaySearch_Tu in date,
          v_NgaySearch_Den in date
        )
    RETURN SYS_REFCURSOR
    IS 
         TotalItem number;  MinIndex	number;  MaxIndex	number;vvvNgayThulyTu date;vvvNgayThulyDen date;
          vvngaythulyden date;vvloaian VARCHAR2(150);
          temp_sobanan nvarchar2(50);
          --------------------------
          V_CURSOR sys_refcursor; v_table_tp T_TINHTRANG; curr_thamphan_id number:=0;ma_chucvu varchar2(10); vTrangthai_s varchar2(150);
          LOAIAN_ID VARCHAR2(150);LOAIAN_TEN VARCHAR2(150);VUANID NUMBER;LANHDAOID NUMBER;TINHTRANGID NUMBER;NGAYTRA DATE; TOTRINH_ID NUMBER;NGAYTRINH DATE;
          -----------------------
          v_table_all T_TINHTRANG; vNgayThulyDen_all date;
          LOAIAN_ID_ALL VARCHAR2(150);LOAIAN_TEN_ALL VARCHAR2(150);VUANID_ALL NUMBER;LANHDAOID_ALL NUMBER;TINHTRANGID_ALL NUMBER;NGAYTRA_ALL DATE;
          ----------------
           vvTuNgay date;vvDenNgay date;V_CANBOID number;ma_chucvu_user VARCHAR2(150);
          V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;CountAll_S number:=0;vvKetquathuly varchar2(250);vLoaiAn_name varchar2(250);V_BIDON_CHECK varchar2(250);
          vKQGiaiQuyet varchar2(100); vKQSo varchar2(100); vKQNgay varchar2(200);
    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
           -----
          SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;
          -- vvTuNgay:=to_date('01/01/2019 00:00:00','dd/MM/yyyy  hh24:mi:ss');vvDenNgay:=to_date('31/12/2019 23:59:59','dd/MM/yyyy  hh24:mi:ss');
          v_table_tp := T_TINHTRANG();  v_table_all := T_TINHTRANG(); 
          -------------------------
          ---anhvh add 25/09/2020 check dữ liệu theo PCA
          SELECT NSD.CANBOID INTO V_CANBOID FROM QT_NGUOISUDUNG NSD WHERE ID=v_ID_USER;

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
                               , v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                               ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                               ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                               --,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                               ,DECODE(v.TRUONGHOPTHULY,1,'<b>Kháng nghị của VKS</b>',2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
                        ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                        ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                        ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
                         --manhnd
                              , case when BAQD_CAPXETXU = 4 
                                                then decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:')|| NVL(v.SO_QDGDT, NVL(v.SO_QDGDT, 'null')) || 
                                                     '<br/>'|| decode (to_char(v.NGAYQD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYQD,'dd/MM/yyyy'))||
                                                     '<br/>'|| DM_CanBo_TenToaVT(tqd.Ma_Ten)||
                                                      decode (v.SOANPHUCTHAM,null,'',' ','','<br/><br/>'||v.SOANPHUCTHAM||'<br/>'||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')||
                                                                '<br/>'||DM_CanBo_TenToaVT(txx.Ma_Ten))||
                                                      decode (v.SoAnSoTham,null,'',' ','','<br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                            '<br/>'||DM_CanBo_TenToaVT(tst.Ma_Ten))
                                     when BAQD_CAPXETXU = 3  then
                                                     decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:')||NVL(v.SOANPHUCTHAM, NVL(v.SOANPHUCTHAM, 'null')) || 
                                                     '<br/>'|| decode (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))||
                                                     '<br/> '|| DM_CanBo_TenToaVT(txx.Ma_Ten)||
                                                      decode (v.SoAnSoTham,null,'',' ','','<br/><br/>'||v.SoAnSoTham||'<br/>'||to_char(v.NgayXuSoTham,'dd/MM/yyyy')||
                                                      '<br/> '||DM_CanBo_TenToaVT(tst.Ma_Ten))

                                     when BAQD_CAPXETXU = 2 
                                                then decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:')|| NVL(v.SoAnSoTham, NVL(v.SoAnSoTham, 'null')) || 
                                                     '<br/>'|| decode (to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NgayXuSoTham,'dd/MM/yyyy'))||
                                                     '<br/>'|| DM_CanBo_TenToaVT(tst.Ma_Ten)
                                     else
                                                    decode(v.BAQD_LOAIQDBA,2,'QĐ số:',3,'CV số:',4,'TB số:') || NVL(v.SOANPHUCTHAM, NVL(v.SoAnSoTham, ''))
                                                    ||'<br/>'|| decode(to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'),null,to_char(v.NgayXuSoTham,'dd/MM/yyyy'),'01/01/0001','',to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy'))
                                                    ||'<br/> '|| DM_CanBo_TenToaVT(NVL(txx.Ma_Ten, tst.Ma_Ten ))        
                                     end InforBA
                              --
                                , decode(Trim(v.QHPL_TEXT),null,qhpl.TENQHPL,v.QHPL_TEXT) QHPLDN
                                 --,qhpl.TENQHPL QHPLDN
                                 ,case when NguyenDon is not null then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(NguyenDon ||' - ')))
                                       when NguyenDon is null and BiDon is not null  then NVL(qhpl.TENQHPL, Replace(v.TenVuAn,(BiDon ||' - ')))
                                    end as QHPNDN_Report
                                ,tp.HOTEN as TENPCA
                                ,ttv.HOTEN TENTHAMTRAVIEN
                                , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                                         when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                                    end  NGAYPHANCONGTTV
                                , ld.HOTEN as TENLANHDAO   
                                , cv.Ten ChucVuLanhDao,decode(cv.Ma,'041','LĐP','042','LĐP',cv.Ma) MaChucVuLD  , v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO, v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA   
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
                                , NVL(v.GQD_LOAIKETQUA,3) KQ_GQD_ID
                                --anhvh edit
                                , DECODE(v.GQD_LOAIKETQUA,3,decode(LENGTH(NVL(v.GDQ_SO,'')),0,v.GQD_KETQUA, 'TB số: '||v.GDQ_SO||'<br/>Ngày: '||to_char(v.GDQ_NGAY,'dd/MM/yyyy')||'<br/> Ngày phát hành: '||to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') )
                                                        , 2,'Xếp đơn' 
                                                        , 1, 'Không chấp nhận khiếu nại'
                                                        , 0,'Chấp nhận khiếu nại') KQ_GQD
                                --DECODE(NVL(v.GQD_LOAIKETQUA,3), 3, '' , 2,u'X\1ebfp \0111\01a1n' , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' ) KQ_GQD
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
                                 ,decode(v.THAMTRAVIENID,null, v.TENTHAMTRAVIEN,ttv.hoten) PHANCONGTTV
                                 ,v.TRUONGHOPTHULY
                                 ,CASE  WHEN (KNTC.LOAIKNTC LIKE '%1%' AND KNTC.LOAIKNTC LIKE '%2%') THEN 'Khiếu nại và Tố cáo'
                                        WHEN (KNTC.LOAIKNTC NOT LIKE '%1%' AND KNTC.LOAIKNTC LIKE '%2%') THEN 'Tố cáo'
                                        ELSE 'Khiếu nại'
                                        END LOAIKNTC
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
                              left join HD1 ON HD1.VUANID=v.ID
                              left join HD2 ON HD2.VUANID=v.ID
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
                              --anhvh edit-30/03/2020 thêm cột theo ý kiến của chú Hào lấy theo 9.3
                                LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546))
                                         AND EXISTS (--chỉ lấy chánh án và phó chánh an
                                            SELECT C.ID,C.HOTEN FROM DM_CANBO C
                                            WHERE EXISTS(SELECT dt.ID, dt.ten FROM dm_dataitem dt WHERE dt.ma IN ('CA', 'PCA')  AND dt.groupid =13 AND dt.ID=C.chucvuid)
                                            AND C.TOAANID=vToaAnID AND C.HIEULUC=1 
                                            AND C.ID=D.CHIDAO_LANHDAOID 
                                             )
                                          GROUP BY d.VuViecID
                                          )AQH_F ON AQH_F.VuViecID=V.ID

                              ---lấy danh sách thụ lý đơn anhvh add 31/03/2020        
                              LEFT JOIN (
                                SELECT CV.VUVIECID,LISTAGG(CASE WHEN LENGTH(NVL(CV.TL_SO, ''))>0 THEN ('Số ' || CV.TL_SO ) ELSE '' END
                                              || CASE WHEN LENGTH(NVL(CV.TL_NGAY, ''))>0 THEN (' - ' || TO_CHAR(CV.TL_NGAY,'dd/MM/yyyy') ) ELSE '' END                         
                                        , ',<br/>')
                                    WITHIN GROUP (ORDER BY CV.TL_NGAY DESC, CV.NGAYTAO DESC)LISTHULYDON            
                                    FROM GDTTT_DON CV  
                                    WHERE  CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1 AND CV.LOAIDON IN (8,10)
                                    GROUP BY CV.VUVIECID
                                )DD ON DD.VUVIECID=v.ID
                                ----- Loai Khieu nai Or To Cao
                              LEFT JOIN (
                                    SELECT D.VUVIECID,LISTAGG(D.LOAIKNTC, ',') WITHIN GROUP (ORDER BY D.LOAIKNTC DESC) LOAIKNTC FROM GDTTT_DON D
                                                    WHERE D.CD_TRANGTHAI=2 AND D.ISTHULY=1 AND D.LOAIDON IN (8,10) group by D.vuviecid 
                                    )KNTC ON KNTC.VUVIECID = V.ID
                                -----
                              where  v.TRUONGHOPTHULY in (8,10) -- Đơn khiếu nại tư pháp 
                                  and v.TOAANID=vToaAnID and ((v.PhongBanID=vPhongBanID) OR (vPhongBanID=0 or vPhongBanID is null))--anhvh  OR (vPhongBanID=0 or vPhongBanID is null)
                                  and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                              -----------------------
                                  and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                                  and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)

                                  ----------------------

                                  and ( vNguoiGui is null or vNguoiGui = '' or UPPER(v.arrnguoikhieunai) like '%' || UPPER(vNguoiGui) || '%') 
                                  --anhvh add 25/12/2019
                                  and ( (vloaian = 0 AND ((instr(','||vvloaian||',',','||v.LOAIAN||',')>0 and curr_thamphan_id=0 and vPhongBanID=0) or (curr_thamphan_id!=0 or vPhongBanID!=0) ))
                                         or  (vloaian = v.LOAIAN and vloaian!=0) 
                                    )
                                  and ( vThamtravien = 0 or  v.THAMTRAVIENID=vThamtravien)
                                  and ( vLanhdao = 0 or  v.LANHDAOVUID=vLanhdao)
                                   ---------------------------------------
                                  and ( vSoThuly is null or vSoThuly = '' or UPPER(v.SOTHULYDON) like '%' || UPPER(vSoThuly) || '%')             

                                   -- Đã có hồ sơ
                                  and ( isTTMuonHS = 2
                                        or (isTTMuonHS = 1 and EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 )) )
                                        or (isTTMuonHS = 0 and NOT EXISTS (select ID from GDTTT_QUANLYHS where v.ID = VUANID and ( NGAYNHAN is not null or LOAI = 3 ) ) 
                                         -- AND ((NVL(V.TRANGTHAIID,0) NOT IN (13,14,15,16,18) AND NVL(v.GQD_LOAIKETQUA,5)= 5) OR NVL(v.GQD_LOAIKETQUA,5) != 5 ) 
                                          ))
                                  -------liên quan đến tham số ngày---------------------
                                 and ( vNgayThulyTu is null or(v.NGAYTAO>=vNgayThulyTu) 
                                      )                    
                                   and ( vngaythulyden is null or(   (vKetquathuly !=4 and v.NGAYTAO<=vvngaythulyden)
                                                                   or(vKetquathuly =4)
                                                                )   
                                      )  

                               -- Kết quả thụ lý
                              and ( vKetquathuly =-1
                                    or (vKetquathuly = 4  and  v.gqd_loaiketqua is null)
                                    or (vKetquathuly = 5  and v.gqd_loaiketqua in (0,1,2,3)) -- có kết quả
                                    -- Cap nhan khieu nai
                                    or (vKetquathuly = 0  AND  V.GQD_LOAIKETQUA=0)
                                     -- Khong chap nhan khieu nai
                                     or (vKetquathuly = 1 AND v.GQD_LOAIKETQUA=1)
                                    --- xếp đơn
                                    or (vKetquathuly = 2  AND v.GQD_LOAIKETQUA=2)
                                     --- Giai quyet khac
                                    or (vKetquathuly = 3  AND v.GQD_LOAIKETQUA=3)
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
                                    or(LoaiAnDB = 3  AND AQH_F.VuViecID IS NOT NULL)
                               )
                             --Noi dung Khieu nai
                             and ( vNoidungKN is null or vNoidungKN = '' or UPPER(v.QHPL_TEXT) like '%' || UPPER(vNoidungKN) || '%')             

                            ---------------
                             and (v_SodonTLM = 0 
                                    or (v_SodonTLM = 1 and not EXISTS (select id from gdttt_don d where d.VuViecID = v.id and d.cd_trangthai = 2 and d.isthuly=1))
                                    or (v_SodonTLM = 2 and EXISTS (select a.cdon from  
                                                                        (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                            where a.VuViecID = v.id and  cdon =1))
                                    or (v_SodonTLM = 3 and EXISTS (select a.cdon from  
                                                                        (select d.VuViecID, count(d.id) cdon from gdttt_don d where d.cd_trangthai = 2 and d.isthuly=1 group by d.VuViecID) a  
                                                                            where a.VuViecID = v.id and  cdon >1))
                                  )
                           AND ((v_NgaySearch_Tu is null and v_NgaySearch_Den is null)
                                    --Ngay Cong van
                                    Or (v_loaingaysearch = 1 and  (v_NgaySearch_Tu is null Or (to_char(VA.GQD_NGACVS,'dd/MM/yyyy') != '01/01/0001' and VA.GQD_NGACVS is not null and VA.GQD_NGACVS >= v_NgaySearch_Tu ))          
                                                             and (v_NgaySearch_Den is null Or ( to_char(VA.GQD_NGACVS,'dd/MM/yyyy') != '01/01/0001' and VA.GQD_NGACVS is not null and VA.GQD_NGACVS < v_NgaySearch_Den )) 
                                    )
                                    --Ngay Phat hanh 
                                    Or (v_loaingaysearch = 2 and (v_NgaySearch_Tu is null Or  (to_char(v.GQD_NGAYPHATHANHCV,'dd/MM/yyyy') != '01/01/0001' and v.GQD_NGAYPHATHANHCV is not null and v.GQD_NGAYPHATHANHCV >= v_NgaySearch_Tu )) 
                                                             and (v_NgaySearch_Den is null Or ( to_char(v.GQD_NGAYPHATHANHCV,'dd/MM/yyyy') != '01/01/0001' and v.GQD_NGAYPHATHANHCV is not null and v.GQD_NGAYPHATHANHCV < v_NgaySearch_Den ))
                                    )
                                     --Ngay phan TTV
                                   Or (v_loaingaysearch = 3 and (v_NgaySearch_Tu is null Or (TRIM(V.TenThamTRaVien) IS NOT NULL 
                                                                                                and v.NGAYTTVNHAN_THS is not null
                                                                                                and to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') != '01/01/0001'
                                                                                                and v.NGAYTTVNHAN_THS >= v_NgaySearch_Tu                                   
                                                                                            )
                                                                    ) 
                                                            and (v_NgaySearch_Den is null Or (TRIM(V.TenThamTRaVien) IS NOT NULL 
                                                                                                and v.NGAYTTVNHAN_THS is not null
                                                                                                and to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') != '01/01/0001'
                                                                                                and v.NGAYTTVNHAN_THS < v_NgaySearch_Den                                   
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
                   DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPNDN_Report||'</td>          
                    ');
              else
                   DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
                   <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPLDN||'</td>');
              end if;

              DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.LOAIKNTC||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||replace(item.NGUOIKHIEUNAI,',',',<br style="mso-data-placement:same-cell;" />')||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.CV93||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.PHANCONGTTV||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENPCA||'</td>
                 ');

                 if (item.KQ_GQD_ID = 0) then
                    vKQGiaiQuyet := 'Chấp nhận khiếu nại';
                 elsif (item.KQ_GQD_ID = 1) then
                    vKQGiaiQuyet := 'Không Chấp nhận khiếu nại';
                 elsif  (item.KQ_GQD_ID = 2) then
                     vKQGiaiQuyet := 'Xếp đơn';
                 else
                      vKQGiaiQuyet := '';
                 end if;

                if (item.GDQ_NGAY is not null) then
                    vKQNgay := '<br style="mso-data-placement:same-cell;" /> Số:'||item.GDQ_SO
                        ||'<br style="mso-data-placement:same-cell;" />Ngày:'||item.GDQ_NGAY;
                 else
                    vKQNgay := '';
                 end if; 

            DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'       
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| vKQGiaiQuyet || vKQNgay||'</td>
                 ');

                 DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,'     

                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                </tr>
            ');
         END LOOP;      
        --------------------------------   
        -------TẠO BÁO CÁO
        SELECT DECODE(vKetquathuly,4,'chưa có kết quả giải quyết',5,'đã có kết quả giải quyết',null) into vvKetquathuly from dual;
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <div style="mso-element: footer" id="f1">
            <w:sdt sdtdocpart="t"
            docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
            <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
            style="mso-element:field-begin"></span><span
            style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
            </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
            style="mso-no-proof:yes;display:none"></span><!--[if supportFields]><span
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
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||to_char(v_NgaySearch_Tu,'dd/MM/yyyy')||'  đến ngày '||to_char(v_NgaySearch_Den,'dd/MM/yyyy')||')</i>
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
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tòa án</td>
                 '); 

             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nội dung khiếu nại</td>
              <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Hình thức khiếu nại</td>
              ');   

             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Người khiếu nại</td>
               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Án quốc hội, có ý kiến lãnh đạo đảng nhà nước</td>
                ');
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thẩm tra viên</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phó Chánh án</td>
                 ');     
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                  <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kết quả giải quyết</td>
                 '); 

               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
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
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                 ');
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                <td style="width: 80pt"></td>
                 ');
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'      
                <td style="width: 80pt"></td>
                <td style="width: 120pt"></td>
            </tr>
        </table>
      ');
 --------------------------------      
      OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;
  END GDTTT_KNTP_SEARCH_PRINT;
END PKG_GDTTTT_KNTP_CC;

/
