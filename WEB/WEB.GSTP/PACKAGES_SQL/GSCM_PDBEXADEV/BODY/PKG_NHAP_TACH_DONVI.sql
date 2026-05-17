--------------------------------------------------------
--  DDL for Package Body PKG_NHAP_TACH_DONVI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_NHAP_TACH_DONVI" AS



PROCEDURE GDTTT_DANHSACH_VUAN_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,  
  vLoaiAn in number,    
  vKetquathuly in number,  
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
BEGIN
 
  -----------------------------------
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
    where v.TOAANID=vToaAnID and (vPhongBanID=0 or v.PhongBanID=vPhongBanID)         
         and ( vLoaiAn=0 OR v.LOAIAN=vLoaiAn) 
         ------Ket qua giai quyet don Dan sư mo rọng----------------------------
                  and ( 
                          vKetquathuly = 3
                            OR (v.LOAIAN != 1 and vKetquathuly = 4 and Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
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
                                                                                                    where  GQD_LOAIKETQUA in (1,3,0,4) 
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
                                or (v.LOAIAN = 1 and vKetquathuly = 4 and  v.gqd_loaiketqua is null     
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
                             --------Ket qua xet xu------------------
                            Or (vKetquathuly = 16 and NVL(v.XXGDTTT_KETQUAID,0)=0 and NVL(v.XXGDTTT_ISKETQUA,0)= 0 
                                                and v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))
                            OR (vKetquathuly = 17 and v.TrangThaiId >= 14 and NVL(v.XXGDTTT_ISKETQUA,0)> 0)
                    ) 
          -------------------------------------------------                  
         
        ;
   OPEN curReturn FOR
     select a.*, TotalItem as CountAll
        ,'' arrDONID
         , '' AS arrCV81ID        
          , '' AS arrCHIDAOID
			from (
            Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                , NVL(v.TongDon,0 ) as TongDon
                ,DECODE(AQH.VuViecID,NULL,0,1) SoCV81--, NVL(v.IsAnQuocHoi, 0) as SoCV81 
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,DECODE(AQH.VuViecID,NULL,0,1) IsAnQuocHoi--, NVL(v.IsAnQuocHoi, 0) IsAnQuocHoi
                , v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                 ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                 ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
                ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
                ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
                ,DECODE(v.BAQD_CAPXETXU,4,tqd.Ma_Ten,2,tst.Ma_Ten,txx.Ma_Ten) ToaXX
               
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

                 ,decode(Trim(v.QHPL_TEXT),null,decode(Trim(qhpl.TenQHPL),null,TD.DIEU ||'.'|| TD.TENTOIDANH
                                                                              ,qhpl.TenQHPL)
                                                ,v.QHPL_TEXT) QHPLDN                                                   
--                 , NVL(qhpl.TENQHPL, Replace(TenVuAn,(NguyenDon ||' - '))) QHPLDN
                ,tp.HOTEN as TENTHAMPHAN
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
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY

                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 5, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              ,GQD_KETQUA) KQ_GQD

                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')
                  end LoaiKN  

                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  

                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy  

                ,GDTTT_HOSO_SEARCH(V.ID,0) NgayMuonHS
                --,to_char(mhs.ngaytao,'dd/mm/yyyy') NgayMuonHS
                ,decode(hs.loai,0,'',3,hs.sophieu) SOPHIEUMUON --mhs.sophieu SOPHIEUMUON
                ,GDTTT_HOSO_SEARCH(V.ID,3) NgayNhanHS
                --,to_char(nhs.ngaytao,'dd/mm/yyyy') NgayNhanHS
                ,decode(hs.loai,3,'',0,hs.sophieu) SOPHIEUNHAN

                -------------------------------
                ,DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, NVL(v.HoSoID,0), v.NGAYTTVNHAN_THS
                , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')
                    end  NgayTTVNhanHS

                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                 , NVL(tt.GiaiDoan,0) GiaiDoanTrinh
                --------------------------------
                , case when (Length(NVL(v.NGAYVUGDNHAN_THS,''))=0 or (to_char(v.NGAYVUGDNHAN_THS,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYVUGDNHAN_THS,'')) >0 then to_char(v.NGAYVUGDNHAN_THS,'dd/MM/yyyy')
                 end  NGAYVUGDNHAN_THS 
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',1) NgayTPDuyet

                , GDTTT_ToTrinh_GetYKien(v.Id, 'TP',1) YKienTP
                  , (v.SOANPHUCTHAM || chr(10) 
                || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                    end) as TTBANANPT
                --, GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay) CheckHoSo
                ----------------------------
                , v.SOTHULYXXGDT,  NVL(v.LoaiAn, 0) LoaiAn
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                 ,case when length(NVL(v.XXGDTTT_SOQD,''))>0 then 'Số '|| v.XXGDTTT_SOQD
                when length(NVL(v.XXGDTTT_SOQD,''))=0 then '' end  as XXGDTTT_SOQD
                  , NVL(kq.Ten,' ') KetQuaXXGDT
        
                   , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then 'Ngày '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                            end  XXGDTTT_NGAYQD
                  , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                            end  NGAYXUGIAMDOCTHAM
                  , (v.XXGDTTT_SOQD 
                    ||  (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                            end)
                     || chr(10)|| NVL(kq.Ten,' ')
                    ) as ThongTinKQ_XXGDTTT    
                 ,DECODE(tk_al.GIATRI_TK,1,'<br/>Áp dụng án lệ số: '|| tk_al.NOIDUNG_TK,'') as inforAnLe   
                    
                 , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
                 , PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon 
                 ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1) cThulymoi
                 
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
              left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v.ID and tk_al.TYPE_TK = 'ADAL'
              
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_BOLUAT_TOIDANH td on v.QHPL_THONGKEID = td.id
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
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID

              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 or Loai=0) hs on hs.ID = NVL(v.HoSoID,0) --and v.id = hs.vuanid

             where v.TOAANID=vToaAnID and (vPhongBanID=0 or v.PhongBanID=vPhongBanID)
                  and ( vLoaiAn=0 OR v.LOAIAN=vLoaiAn)
                        ------Ket qua giai quyet don Dan sư mo rọng----------------------------
                  and ( 
                          vKetquathuly = 3
                            OR (v.LOAIAN != 1 and vKetquathuly = 4 and Not Exists(select 'X' from GDTTT_VUAN_KETQUA where TRANGTHAI != 0 and vuanid = v.id)
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
                                                                                                    where  GQD_LOAIKETQUA in (1,3,0,4) 
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
                                or (v.LOAIAN = 1 and vKetquathuly = 4 and  v.gqd_loaiketqua is null     
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
                            --------Ket qua xet xu------------------
                            Or (vKetquathuly = 16 and NVL(v.XXGDTTT_KETQUAID,0)=0 
                                                and NVL(v.XXGDTTT_ISKETQUA,0)= 0
                                                and  v.NGAYTHULYXXGDT is not null 
                                                and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001')
                                                )
                            OR (vKetquathuly = 17   and v.TrangThaiId >= 14 
                                                    and NVL(v.XXGDTTT_ISKETQUA,0)> 0
                                                    and  Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                                    where  GQD_LOAIKETQUA = 1 
                                                                                                    and TRANGTHAI != 0
                                                                                                    and vuanid = v.id
                                                                                                    )
                                                    and  Not Exists(select 'X' from GDTTT_VUAN_KETQUA 
                                                                                                    where  GQD_LOAIKETQUA in (0,2,3,4) 
                                                                                                    and TRANGTHAI != 0 
                                                                                                    and vuanid = v.id)
                                                )
                    )
                    
                ------------------------------------------------ 

       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTT_DANHSACH_VUAN_SEARCH;


PROCEDURE GDTTT_DANHSACH_VUAN_NHAN
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vLoaiAn in number, 
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
  ArrSapXep_AnQuocHoi varchar2(250);
BEGIN
  Select ID into ArrSapXep_AnQuocHoi from DM_DATAITEM where ID=1023;
  -----------------------------------
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
    where v.TOAANID=vToaAnID 
        and (vPhongBanID=0 or v.PhongBanID=vPhongBanID)
        and (vLoaiAn=0 or v.LoaiAn=vLoaiAn)
        and  EXISTS(select 'X' from GDTTT_VUAN_NHAPTACH_DONVI cn where (',' || lower(cn.DANHSACH)|| ',')  like ('%,' || lower(v.id)|| ',%') )
        ;
   OPEN curReturn FOR
     select a.*, TotalItem as CountAll 
           ,'' arrDONID
         , '' AS arrCV81ID        
          , '' AS arrCHIDAOID
			from (
            Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                , NVL(v.TongDon,0 ) as TongDon
                ,DECODE(AQH.VuViecID,NULL,0,1) SoCV81--, NVL(v.IsAnQuocHoi, 0) as SoCV81 
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao
                ,DECODE(AQH.VuViecID,NULL,0,1) IsAnQuocHoi--, NVL(v.IsAnQuocHoi, 0) IsAnQuocHoi
                , v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                 ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                 ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
                ,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
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

                 ,decode(Trim(v.QHPL_TEXT),null,decode(Trim(qhpl.TenQHPL),null,TD.DIEU ||'.'|| TD.TENTOIDANH
                                                                              ,qhpl.TenQHPL)
                                                ,v.QHPL_TEXT) QHPLDN                                                   
                ,tp.HOTEN as TENTHAMPHAN
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
                , v.GDQ_SO , NVL(v.GQD_SoCV , '') GQD_SoCV
                , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY

                , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID  
                , DECODE(NVL(v.GQD_LOAIKETQUA,5), 5, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              ,GQD_KETQUA) KQ_GQD

                , NVL(v.IsVienTruongKN,0) IsVienTruongKN
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, 'VKS')
                  end LoaiKN  

                , case when (Length(NVL(v.GQD_NgayPhatHanhCV,''))=0 or (to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_NgayPhatHanhCV,'')) >0 then to_char(v.GQD_NgayPhatHanhCV,'dd/MM/yyyy')
                    end  GQD_NgayPhatHanhCV  

                , NVL(v.GQD_IsHoanTHA, 0) GQD_IsHoanTHA,NVL( v.GQD_HoanTHA_So ,'') GQD_HoanTHA_So
                , case when (Length(NVL(v.GQD_HoanTHA_Ngay,''))=0 or (to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GQD_HoanTHA_Ngay,'')) >0 then to_char(v.GQD_HoanTHA_Ngay,'dd/MM/yyyy')
                    end  GQD_HoanTHA_Ngay  
                , NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy  
                -------------------------------
                --,(select to_char(max(mhs.NGAYTAO),'dd/MM/yyyy') from GDTTT_QUANLYHS mhs where mhs.vuanid = v.id and mhs.loai = 0) NgayMuonHS
                --,(select to_char(max(nhs.NGAYTAO),'dd/MM/yyyy') from GDTTT_QUANLYHS nhs where nhs.vuanid = v.id and nhs.loai = 3) NgayNhanHS
                ,GDTTT_HOSO_SEARCH(V.ID,0) NgayMuonHS
                --,to_char(mhs.ngaytao,'dd/mm/yyyy') NgayMuonHS
                ,decode(hs.loai,0,'',3,hs.sophieu) SOPHIEUMUON --mhs.sophieu SOPHIEUMUON
                ,GDTTT_HOSO_SEARCH(V.ID,3) NgayNhanHS
                --,to_char(nhs.ngaytao,'dd/mm/yyyy') NgayNhanHS
                ,decode(hs.loai,3,'',0,hs.sophieu) SOPHIEUNHAN

                -------------------------------
                ,DECODE(length(trim(cohs.NgayTao)),null, NVL(v.IsHoSo,0),1) IsHoSo, NVL(v.HoSoID,0), v.NGAYTTVNHAN_THS
                , case when (Length(NVL(hs.NgayTao,''))=0 or (to_char(hs.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(hs.NgayTao,'')) >0 then to_char(hs.NgayTao,'dd/MM/yyyy')
                    end  NgayTTVNhanHS

                , NVL(v.IsToTrinh,0) IsToTrinh
                , NVL(v.ISANTRAODOICV,0)  ISANTRAODOICV
                 , NVL(tt.GiaiDoan,0) GiaiDoanTrinh
                --------------------------------
                , case when (Length(NVL(v.NGAYVUGDNHAN_THS,''))=0 or (to_char(v.NGAYVUGDNHAN_THS,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYVUGDNHAN_THS,'')) >0 then to_char(v.NGAYVUGDNHAN_THS,'dd/MM/yyyy')
                 end  NGAYVUGDNHAN_THS 
                , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'TP',1) NgayTPDuyet

                , GDTTT_ToTrinh_GetYKien(v.Id, 'TP',1) YKienTP
                  , (v.SOANPHUCTHAM || chr(10) 
                || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                    end) as TTBANANPT
                --, GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay) CheckHoSo
                ----------------------------
                , v.SOTHULYXXGDT,  NVL(v.LoaiAn, 0) LoaiAn
                , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
                ,case when length(NVL(v.XXGDTTT_SOQD,''))>0 then 'Số '|| v.XXGDTTT_SOQD
                        when length(NVL(v.XXGDTTT_SOQD,''))=0 then '' end  as XXGDTTT_SOQD                   
               , NVL(kq.Ten,' ') KetQuaXXGDT
        
                   , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then 'Ngày '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                            end  XXGDTTT_NGAYQD
                  , case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')
                            end  NGAYXUGIAMDOCTHAM
                  , (v.XXGDTTT_SOQD 
                    ||  (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then ''
                                 when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy'))
                            end)
                     || chr(10)|| NVL(kq.Ten,' ')
                    ) as ThongTinKQ_XXGDTTT    
                 ,DECODE(tk_al.GIATRI_TK,1,'<br/>Áp dụng án lệ số: '|| tk_al.NOIDUNG_TK,'') as inforAnLe        
                    
                    
                    
                 , case when NVL(v.LoaiAn, 0)<>1 then ''
                        else (SELECT LISTAGG(cast(dt.So as varchar2(10))
                                            ||case when (Length(NVL(dt.Ngay,''))=0 
                                                        or (to_char(dt.Ngay,'dd/MM/yyyy') ='01/01/0001')) then ''
                                                   when Length(NVL(dt.Ngay,'')) >0 then ' - '||to_char(dt.Ngay,'dd/MM/yyyy')
                                              end , ',<br/>')
                             WITHIN GROUP (ORDER BY dt.So asc, dt.Ngay asc) FROM GDTTT_DON_TRALOI dt  
                             WHERE  dt.VuAnID=v.ID and dt.TypeTB=3)
                        end as AHS_ThongTinGQD
                 , PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon 
                 ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1) cThulymoi
              from GDTTT_VUAN v 
              left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
              left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
              left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
              left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
              left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v.ID and tk_al.TYPE_TK = 'ADAL'
              
              left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
              left join DM_BOLUAT_TOIDANH td on v.QHPL_THONGKEID = td.id
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
              --anhvh--án quốc hội gồm công văn 8.1 và 9.3
              LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                         WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                         GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID

              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 ORDER BY ngaytao desc  FETCH FIRST 1 ROW ONLY) cohs on cohs.VUANID = v.ID
              left join (Select ID, NgayTao,VUANID,sophieu,loai from GDTTT_QUanLyHS where Loai=3 or Loai=0) hs on hs.ID = NVL(v.HoSoID,0) --and v.id = hs.vuanid
              -- lay ra thông tin phiếu mượn gần nhất
              --left join (Select VUANID,sophieu, NgayTao from GDTTT_QUanLyHS where Loai=0) mhs on v.id = mhs.VUANID
              -- lay ra thông tin phiếu nhận gần nhất
              --left join (Select VUANID,sophieu, NgayTao from GDTTT_QUanLyHS where Loai=3) nhs on v.id = nhs.VUANID 
        
             where v.TOAANID=vToaAnID 
                and (vPhongBanID=0 or v.PhongBanID=vPhongBanID)
                and (vLoaiAn=0 or v.LoaiAn=vLoaiAn)
                      -----------------------
                and  EXISTS(select 'X' from GDTTT_VUAN_NHAPTACH_DONVI cn where (',' || lower(cn.DANHSACH)|| ',')  like ('%,' || lower(v.id)|| ',%') )
         
                ------------------------------------------------ 
                
              
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTT_DANHSACH_VUAN_NHAN;



FUNCTION CREATE_MA_NHAPTACH_RANDOM
(
  V_MALANCHUYEN OUT VARCHAR2
) 
RETURN VARCHAR2
AS
    V_COUNTS_MALC NUMBER;V_MA_LC VARCHAR2(255):=NULL;
BEGIN
    SELECT  DBMS_RANDOM.STRING('x',10) INTO V_MA_LC FROM DUAL;
    SELECT CASE  
              WHEN  EXISTS (SELECT 1 FROM GDTTT_VUAN_NHAPTACH_DONVI NT WHERE  NT.MALANCHUYEN = V_MA_LC)  THEN 1  ELSE 0 END 
           INTO V_COUNTS_MALC FROM DUAL;

    -----------
    IF(V_COUNTS_MALC=1)THEN
         V_MALANCHUYEN:=PKG_NHAP_TACH_DONVI.CREATE_MA_NHAPTACH_RANDOM(V_MALANCHUYEN);
    ELSIF(V_COUNTS_MALC=0)THEN
         V_MALANCHUYEN:=V_MA_LC;     
    END IF;
  RETURN V_MALANCHUYEN;
END CREATE_MA_NHAPTACH_RANDOM; 

PROCEDURE NHAP_TACH_DONVI_IN
(
    V_KetQuaQG IN NUMBER,
    V_TOAANID IN NUMBER,
    V_DONVIMOI IN NUMBER,
    V_DONVICU IN NUMBER,
    V_LYDO IN VARCHAR2,
    V_GHICHU IN VARCHAR2,
    V_DANHSACH IN VARCHAR2,
    V_NGUOITAO IN VARCHAR2,
    V_TAIKHOANTAO IN VARCHAR2
)
AS
    V_MA_CHUYEN VARCHAR2(255):=NULL;   
    vVuAn_id  NUMBER;
    vCheck NUMBER;
    vGhiChu varchar2(2000):=null;
    vName_phongban  VARCHAR2(255):=NULL;  
BEGIN
     V_MA_CHUYEN := PKG_NHAP_TACH_DONVI.CREATE_MA_NHAPTACH_RANDOM(V_MA_CHUYEN);
      SAVEPOINT P1;
      
       INSERT INTO GDTTT_VUAN_NHAPTACH_DONVI 
                VALUES (V_MA_CHUYEN,V_TOAANID,V_DONVIMOI,V_DONVICU,V_LYDO,V_GHICHU,V_DANHSACH,SYSDATE,V_NGUOITAO,V_TAIKHOANTAO);
     --thuc hien chuyen du lieu
        vCheck := INSTR(V_DANHSACH, ',');
--        Chuyen nhieu vu an
        IF (vCheck > 0) then
            FOR item IN ( SELECT
                        REGEXP_SUBSTR (
                          V_DANHSACH,
                          '[^,]+', 1, level) AS VUANID
                        FROM dual
                        CONNECT BY REGEXP_SUBSTR (
                          V_DANHSACH,
                          '[^,]+', 1, level) IS NOT NULL )
            LOOP 
                 vVuAn_id := item.VUANID;
               --Chuyen don kem tham phan GDTTT_DON_CHUYEN
                FOR iTemDon in(
                    SELECT D.ID  FROM GDTTT_DON D WHERE D.VUVIECID = vVuAn_id)
                LOOP
                    UPDATE GDTTT_DON_CHUYEN SET PHONGBANNHANID = V_DONVIMOI WHERE PHONGBANNHANID = V_DONVICU AND DONID = iTemDon.ID;
                END LOOP;
                
         ----Cap nhat lai don vi moi--------------------
             select ghichu into vGhiChu from GDTTT_VUAN where ID = vVuAn_id;
             select TENPHONGBAN into vName_phongban from DM_PHONGBAN where ID = V_DONVICU;
--             Neu vu an chua co ket qua thi PHONGBANGQ (don vi giai quyet)  và PHONGBANID (don vi tao vu an) sẽ la mot  
               IF (V_KetQuaQG = 4) THEN
                     if (LENGTH(vGhiChu)>0) then
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI, PHONGBANGQ = V_DONVIMOI, GHICHU = GHICHU||'<br>Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     else 
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI, PHONGBANGQ = V_DONVIMOI, GHICHU = 'Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     end if;
                ELSE
                   
                     if (LENGTH(vGhiChu)>0) then
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI,GHICHU = GHICHU||'<br>Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     else 
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI,GHICHU = 'Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     end if;
                END IF;
                
            END LOOP;
        ELSE
--        Chuyen mot vu an
           vVuAn_id:= V_DANHSACH;
            --Chuyen don kem tham phan GDTTT_DON_CHUYEN
            FOR iTemDon in(
                SELECT D.ID  FROM GDTTT_DON D WHERE D.VUVIECID = vVuAn_id)
            LOOP
                UPDATE GDTTT_DON_CHUYEN SET PHONGBANNHANID = V_DONVIMOI WHERE PHONGBANNHANID = V_DONVICU AND DONID = iTemDon.ID;
            END LOOP;
                  
                 ----Cap nhat lai don vi moi--------------------
                 select ghichu into vGhiChu from GDTTT_VUAN where ID = vVuAn_id;
                 select TENPHONGBAN into vName_phongban from DM_PHONGBAN where ID = V_DONVICU;
                 
--             Neu vu an chua co ket qua thi PHONGBANGQ (don vi giai quyet)  và PHONGBANID (don vi tao vu an) sẽ la mot  t  
               IF (V_KetQuaQG = 4) THEN
                     if (LENGTH(vGhiChu)>0) then
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI, PHONGBANGQ = V_DONVIMOI, GHICHU = GHICHU||'<br>Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     else 
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI, PHONGBANGQ = V_DONVIMOI, GHICHU = 'Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     end if;
                ELSE
                   
                     if (LENGTH(vGhiChu)>0) then
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI,GHICHU = GHICHU||'<br>Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     else 
                        UPDATE GDTTT_VUAN SET PHONGBANID = V_DONVIMOI,GHICHU = 'Chuyển từ '||vName_phongban||' sang'  WHERE ID = vVuAn_id;
                     end if;
                END IF;
                
        END IF;
     
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK TO SAVEPOINT P1;     
    
END NHAP_TACH_DONVI_IN;

PROCEDURE   DM_TOAAN_GET_GDTTT
(
  vAdmin in number,
  vdonviID in number,
  vloaitoa in varchar2,
	curReturn    OUT       sys_refcursor
)
IS 
var_arrsx  nvarchar2(250);
BEGIN
if vdonviID>0 then
 select t.ARRSAPXEP into var_arrsx from DM_TOAAN t where t.ID=vdonviID;
else
  var_arrsx:='0';
end if;
 OPEN curReturn FOR 
    Select t.ID,t.MA,t.TEN,REPLACE(
                           -- REPLACE(
                                REPLACE(t.MA_TEN,'thành phố','TP')
                                --,'cấp cao','CC')
                                ,'Tòa án nhân dân','TAND') MA_TEN       
    from DM_TOAAN t
    Where (vAdmin = 1 Or  (vAdmin != 1 and t.id = vdonviID)) 
    and  ((vLoaitoa is null and t.LOAITOA in ('TOICAO','CAPCAO')) Or  (t.LOAITOA = vLoaitoa))
    and t.hieuluc = 1
    and (t.ARRSAPXEP like (var_arrsx ||'/%') or t.ARRSAPXEP=var_arrsx )
    Order by t.ARRTHUTU;

END DM_TOAAN_GET_GDTTT;






END PKG_NHAP_TACH_DONVI;

/
