create or replace NONEDITIONABLE PROCEDURE        "GDTTT_VUAN_XETXU_SEARCH" 
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
  
  vTrangthai in number,
  vKetquaxetxu in number,  
  vThamquyenxx in number,
  
  vNgayXX_Tu in date,
  vNgayXX_Den in date,
  vSoKhangNghi in varchar2,
  vNgayKhangNghi in date,
  vVIENTRUONGKN_NGUOIKY  in number,
  v_LoaiGDT in number,
  v_QUAHAN_LUATDINH in number,
  v_Apdung_AnLe     in number,
  PageIndex	in	int,
  PageSize	in	int,  
	curReturn OUT sys_refcursor
)
IS 
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
  vvngaythulyden date;
BEGIN
  MinIndex := PageSize*(PageIndex - 1) + 1;
  MaxIndex := PageIndex*PageSize ;
  SELECT DECODE(vngaythulyden,null,sysdate,to_date(to_char(vngaythulyden,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy HH24:MI:SS')) into vvngaythulyden from dual;

    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
        left join GDTTT_VUAN_THONGKE tk_qh on tk_qh.VUANID = v.ID and tk_qh.TYPE_TK = 'QHLD'
        left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v.ID and tk_al.TYPE_TK = 'ADAL'
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID  and v.LoaiAn<>7
          and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)                     

--          and 1=case when trim(vNguyendon) || ' '=' ' then 1 
--                     when (lower(trim(v.NGUYENDON)) like '%' || lower(trim(vNguyendon)) || '%') then 1 else 0 end
--          and 1=case when vBidon || ' '=' ' then 1 
--                     when (lower(trim(v.BIDON)) like '%' || lower(trim(vBidon)) || '%') then 1 else 0 end
            ----------------------
              AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
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
                     or UPPER(v.TENVUAN) like '%' || UPPER(vNguyendon) || '%'  
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
          and 1=case when vLoaiAn=0 then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
          and  (vThamtravien=0 or v.THAMTRAVIENID=vThamtravien or v.XXGDT_THAMTRAVIENID = vThamtravien)
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end

          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NgayThuLyXXGDT then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NgayThuLyXXGDT <= vvngaythulyden then 1 else 0 end

          and 1=case when vSoThuly || ' '=' ' then 1 
                     when lower(v.SOTHULYXXGDT) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
          ---------------------------------------
          and  (v.TRANGTHAIID=14 or v.TrangThaiId = 15) 
          and NVL(v.IsRutKN,0)=0  ---manhnd bo ngay 28/5/2021 do Rut KN van cần phai ra QD dinh chi
          and 1=case when vTrangthai=-1 then 1
                     ---chua thu ly xx----
                     when vTrangthai=2 and v.TrangThaiId = 14 and v.THAMQUYENXXGDT = vToaAnID then 1

                     ---da thu ly xx 12 co ket qua
                     when vTrangthai=0 --and v.TrangThaiId = 15
                       and (NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0
                             or (v.XXGDTTT_KETQUAID>0 
                                  and (v.XXGDTTT_NGAYQD > vvngaythulyden))
                            ) 
                         and (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))   
                        then 1 

                      ----da xet xu-------------
                     when vTrangthai=1 and v.TrangThaiId >= 14
                           and NVL(v.XXGDTTT_ISKETQUA,0)>0 then 1 else 0 
                end
               --duongph 22/02/2022
            and (v_LoaiGDT = 4 
                or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                 or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                )
          ---------Ket qua xet xu GDTTT-----------------------------
          and 1= case when vKetquaxetxu =0 then 1
                      when vKetquaxetxu =-1 and (NVL(v.XXGDTTT_KETQUAID,0) =0) then 1
                      when vKetquaxetxu>0  and (NVL(v.XXGDTTT_KETQUAID,0) = vKetquaxetxu) then 1
                 end  
          and 1= case when vThamquyenxx =0 then 1
                      when vThamquyenxx >0 and NVL(v.THAMQUYENXXGDT,0) = vThamquyenxx then 1
                  end
          ------------------------------------------
          and  1=case when vNgayXX_Tu is null then 1 
                      when v.TrangThaiID >= 14  and vNgayXX_Tu <= v.XXGDTTT_NGAYQD then 1 else 0 end
          and 1=case when vNgayXX_Den is null then 1 
                     when v.TrangThaiID >= 14  and v.XXGDTTT_NGAYQD <= vNgayXX_Den then 1 else 0 end
          and (vSoKhangNghi = 0 or (v.VIENTRUONGKN_SO = vSoKhangNghi and v.ISVIENTRUONGKN = 1)or (v.GDQ_SO = vSoKhangNghi and v.GQD_LOAIKETQUA = 1))
          and (vNgayKhangNghi is null or vNgayKhangNghi = ''
                or (to_date(v.VIENTRUONGKN_NGAY,'dd/MM/yyyy') = to_date(vNgayKhangNghi,'dd/MM/yyyy') and v.ISVIENTRUONGKN = 1) 
                or (to_date(v.GDQ_NGAY,'dd/MM/yyyy') = to_date(vNgayKhangNghi,'dd/MM/yyyy') and v.GQD_LOAIKETQUA = 1)
                )
           and (vVIENTRUONGKN_NGUOIKY = 0 
                Or (vVIENTRUONGKN_NGUOIKY  not in (44,55,66,0) and v.VIENTRUONGKN_NGUOIKY = vVIENTRUONGKN_NGUOIKY)
                Or (vVIENTRUONGKN_NGUOIKY = 66 and NVL(v.ISVIENTRUONGKN,0) = 0 and v.GQD_LOAIKETQUA = 1)
                Or (vVIENTRUONGKN_NGUOIKY = 55 and NVL(v.ISVIENTRUONGKN,0) = 0 and v.GQD_LOAIKETQUA = 1)
                Or (vVIENTRUONGKN_NGUOIKY = 44 and NVL(v.ISVIENTRUONGKN,0) = 0 and v.GQD_LOAIKETQUA = 1)
                )
--        Qua han luat dinh
          and (v_QUAHAN_LUATDINH = -1
                Or (v_QUAHAN_LUATDINH = 0 and NVL(tk_qh.NOIDUNG_TK,0)= 0)
                Or (v_QUAHAN_LUATDINH > 0 and NVL(tk_qh.NOIDUNG_TK,0) = v_QUAHAN_LUATDINH)
                )  
--        Ap dung an le
         and (v_Apdung_AnLe = -1
                Or (v_Apdung_AnLe = 0 and NVL(tk_al.GIATRI_TK,0) =0 )
                Or (v_Apdung_AnLe > 0 and NVL(tk_al.GIATRI_TK,0) = v_Apdung_AnLe)
                )
       ;
  OPEN curReturn FOR
     select a.*, TotalItem as CountAll 
			from (
      Select ROW_NUMBER() OVER (ORDER BY v.XXGDTTT_NGAYQD desc,v.NGAYTHULYDON desc) STT
          ,v.ID,v.MAVUAN
          ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
          ------------------------------------------          
--          ,v.NGUYENDON,v.BIDON
--            ,v.NGUOIKHIEUNAI
          ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
          ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
          ,DECODE(v.TRUONGHOPTHULY,1,Decode(v.VIENTRUONGKN_NGUOIKY,818,'<b>Kháng nghị của CA TANDTC</b>'
                                                                  ,819,'<b>Kháng nghị của CA TANDCC tại Hà Nội</b>'
																	,820,'<b>Kháng nghị của CA TANDCC tại Đà Nẵng</b>'
																	,821,'<b>Kháng nghị của CA TANDCC tại Hồ Chí Minh</b>'
                                                                  ,1,'<b>Kháng nghị của VKSTC</b>'
                                                                  ,4,'<b>Kháng nghị của VKSCC Hà Nội</b>'
                                                                  ,5,'<b>Kháng nghị của VKSCC Đà Nẵng</b>'
                                                                  ,6,'<b>Kháng nghị của VKSCC Hồ Chí Minh</b>')
                                ,2,'<b>Rút Hồ sơ đoàn kiểm tra</b>',3,'<b>Chủ động GĐT qua Bản án</b>',NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI)) NGUOIKHIEUNAI
          ,v.VIENTRUONGKN_NGUOIKY
--          ,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
--          ,txx.Ma_Ten ToaXX, DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
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

           , decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT) QHPLDN
--          ,qhpl.TENQHPL QHPLDN
          ,tp.HOTEN as TENTHAMPHAN
           , case when NguyenDon is not null then NVL(decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT), Replace(v.TenVuAn,(NguyenDon ||' - ')))
                       when NguyenDon is null and BiDon is not null  then NVL(decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT), Replace(v.TenVuAn,(BiDon ||' - ')))
                    end as QHPNDN_Report
          ,'TTV: '||Decode(ttvxx.HOTEN,null,ttv.HOTEN,ttvxx.HOTEN) ||'<br/>' || NVL(cv.Ma,'PVT') || ':' || ldxx.HOTEN || '<br/>TP: '|| tp.HOTEN  as TENTHAMTRAVIEN
          , NVL(ld.HOTEN,'') as TENLANHDAO,  NVL(cv.Ma,'') MaChucVuLD   

          , v.TrangThaiID, tt.TENTINHTRANG ,v.GHICHU
          , case when  NVL(v.GQD_LOAIKETQUA,5)<> 1 then v.QUATRINH_GHICHU
                       when NVL(v.GQD_LOAIKETQUA,5) =1
                            then (u'Kh\00e1ng ngh\1ecb '||DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                                    ,818,'CA TANDTC'
                                                                                                                    ,819,'CA TANDCC tại Hà Nội'
                                                                                                                    ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                                    ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                                    ,'VKS')))
                  end QUATRINH_GHICHU
          ,to_char(v.vientruongkn_ngay,'dd/MM/yyyy') vientruongkn_ngay,v.vientruongkn_so 
          ------------------------------------------
          , NVL(v.GQD_LOAIKETQUA,5) KQ_GQD_ID, NVL(v.GQD_SoCV , '') GQD_SoCV
          --Neu CA khang nghi thi lay v.GDQ_So nguoc lai VienKS khang nghi thi lay vientruongkn_so
          ,DECODE( NVL(v.IsVienTruongKN,0),0,v.GDQ_So,v.vientruongkn_so) GDQ_SO   
          --v.GDQ_SO      
          , case when (Length(NVL(v.GDQ_NGAY,''))=0 or (to_char(v.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.GDQ_NGAY,'')) >0 then to_char(v.GDQ_NGAY,'dd/MM/yyyy')
                    end  GDQ_NGAY
          , case when NVL(v.GQD_LOAIKETQUA,5) > 0 then (u'S\1ed1 '|| DECODE( NVL(v.IsVienTruongKN,0),0,v.GDQ_So,v.vientruongkn_so) || u' Ng\00e0y ' || DECODE( NVL(v.IsVienTruongKN,0),0,to_char(v.GDQ_Ngay,'dd/MM/yyyy'),to_char(v.vientruongkn_ngay,'dd/MM/yyyy')))
                 when NVL(v.GQD_LOAIKETQUA,5) = 0 then u' ' 
            end  LoaiKQ_GiaiQuyetDon

          , NVL(v.IsVienTruongKN,0) IsVienTruongKN          
         , DECODE(NVL(v.GQD_LOAIKETQUA,5), 5, ''
                             , 2,u'X\1ebfp \0111\01a1n'
                              , 1, u'Kh\00e1ng ngh\1ecb'
                              , 0,u'Tr\1ea3 l\1eddi \0111\01a1n'
                              , 3, cast(v.GQD_KETQUA as varchar2(250))
                              , 4,'VKS đang giải quyết') KQ_GQD
                , case when NVL(v.GQD_LOAIKETQUA,5)<> 1 then ''
                        when NVL(v.GQD_LOAIKETQUA,5)=1 
                             then DECODE( NVL(v.IsVienTruongKN,0), 0, '(CA)', 1, Decode(v.VIENTRUONGKN_NGUOIKY
                                                                                                ,818,'CA TANDTC'
                                                                                                ,819,'CA TANDCC tại Hà Nội'
                                                                                                ,820,'CA TANDCC tại Đà Nẵng'
                                                                                                ,821,'CA TANDCC tại Hồ Chí Minh'
                                                                                                ,'VKS'))
                  end LoaiKN  
          --------------------------------
          , v.SOTHULYXXGDT
            , case when (Length(NVL(v.NGAYTHULYXXGDT,''))=0 or (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.NGAYTHULYXXGDT,'')) >0 then to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy')
                    end  NGAYTHULYXXGDT
         , v.THAMQUYENXXGDT
          , case when (Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,''))=0 or (to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.XXGDTTT_NGAYVKSTRAHS,'')) >0 then to_char(v.XXGDTTT_NGAYVKSTRAHS,'dd/MM/yyyy')
                    end  XXGDTTT_NGAYVKSTRAHS
          --------------
          , NVL(v.XXGDTTT_ISHOANPT, 0) XXGDTTT_ISHOANPT 
           , case when (Length(NVL(v.XXGDTTT_NGAYHOAN,''))=0 or (to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(v.XXGDTTT_NGAYHOAN,'')) >0 then to_char(v.XXGDTTT_NGAYHOAN,'dd/MM/yyyy')
                    end  XXGDTTT_NGAYHOAN
          , NVL(v.XXGDTTT_LYDOHOAN, '') XXGDTTT_LYDOHOAN
          --------------
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

           ------------------------------------------
          , NVL(v.TongDon,0 ) as TongDon
                , NVL(v.IsAnQuocHoi, 0) as SoCV81 
                , NVL(v.IsAnChiDao, 0) as IsAnChiDao,HD1.HOIDONGXX,HD2.TEN_CHUTOA 
          ,v.XXGDT_THAMTRAVIENID,ttvxx.HOTEN as TENTHAMTRAVIEN_GDT, v.XXGDT_NGAYPHANCONGTTV,v.XXGDT_NGAYPHANCONGLD
          ,ldxx.HOTEN as TENLANHDAO_GDT
          ,DECODE(tk_qh.GIATRI_TK,1,'<br/>Qua hạn luật định do Khách quan',2,'<br/>Qua hạn luật định do Chủ quan','') as inforQuahan, tptc.hoten AS THAMPHANTC_TEN
          ,DECODE(tk_al.GIATRI_TK,1,'<br/>Áp dụng án lệ số: '|| tk_al.NOIDUNG_TK,'') as inforAnLe
      from GDTTT_VUAN v
         left join GDTTT_VUAN_THONGKE tk_qh on tk_qh.VUANID = v.ID and tk_qh.TYPE_TK = 'QHLD'
         left join GDTTT_VUAN_THONGKE tk_al on tk_al.VUANID = v.ID and tk_al.TYPE_TK = 'ADAL'
         left join (select ID, Ma_Ten from DM_TOAAN) txx on v.TOAPHUCTHAMID=txx.ID
         left join (select ID, Ma_Ten from DM_TOAAN) tst on v.TOAANSOTHAM=tst.ID
         left join (select ID, Ma_Ten from DM_TOAAN) tqd on v.TOAQDID=tqd.ID
         left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
         left join DM_CANBO tp on v.THAMPHANID=tp.ID
         left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
         left join DM_CANBO ttvxx on v.XXGDT_THAMTRAVIENID=ttvxx.ID
         left join DM_CANBO ld on ld.ID = decode(NVL(v.XXGDT_LANHDAOVUID,0),0,v.LANHDAOVUID,v.XXGDT_LANHDAOVUID)
         --left join DM_CANBO ttvxx on v.XXGDT_THAMTRAVIENID=ttvxx.ID
         left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
         left join DM_DataITem cv on ld.ChucVuID = cv.ID
         left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
         left join DM_DAtaItem kq on kq.ID = v.XXGDTTT_KETQUAID
         left join (select hd.VUANID,DECODE(hd.TYPEHD,1,'<br/><span style="">Hội đồng: <b> Toàn thể</b></span>',2,DECODE(vToaAnID,1,'<br/><span style="">Hội đồng: <b> 5</b></span>','<br/><span style="">Hội đồng: <b> 3</b></span>'),'')HOIDONGXX from GDTTT_VUAN_XXGDTT_HOIDONG hd GROUP BY hd.VUANID,hd.TYPEHD)HD1 ON HD1.VUANID=v.ID
         left join (select hd1.VUANID,DECODE(HD1.TENCANBO,NULL,NULL,'<br/><span style="">Chủ tọa: <b>'||HD1.TENCANBO||'</b></span>')TEN_CHUTOA,HD1.CANBOID from GDTTT_VUAN_XXGDTT_HOIDONG hd1 WHERE HD1.ISCHUTOA=1)HD2 ON HD2.VUANID=v.ID
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
        
            --03/12/2025 lấy thông tin TPTC đc phân công vụ án có ý kiến kháng nghị
            LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and ctc.TRANGTHAI = 2 and NVL(ctc.THAMPHANID, 0) <> 0 -- ctc.TRANGTHAI = 2 là HCTP đã nhận vụ án kháng nghị
            LEFT JOIN DM_CANBO tptc ON tptc.id = ctc.THAMPHANID

          where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID and v.LoaiAn<>7
          and NVL(v.truonghopthuly,0) not in (8,10) -- Đơn khiếu nại tư pháp 
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                      -----------------------
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)             
          ---------------------------------------
--          and 1=case when trim(vNguyendon) || ' '=' ' then 1 
--                     when (lower(trim(v.NGUYENDON)) like '%' || lower(trim(vNguyendon)) || '%') then 1 else 0 end
--          and 1=case when vBidon || ' '=' ' then 1 
--                     when (lower(trim(v.BIDON)) like '%' || lower(trim(vBidon)) || '%') then 1 else 0 end 

          ----------------------
              AND (    (NVL(v.LoaiAN,0)=1  AND trim(vNguyendon) || ' '!=' ' AND ((UPPER(trim(v.NGUYENDON)) like '%' || UPPER(trim(vNguyendon)) || '%') 
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
                     or UPPER(v.TENVUAN) like '%' || UPPER(vNguyendon) || '%'  
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
          and 1=case when vLoaiAn=0 then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
          ---------------------------------------
          and  (vThamtravien=0 or v.THAMTRAVIENID=vThamtravien or v.XXGDT_THAMTRAVIENID = vThamtravien)
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
          ---------------------------------------          
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NgayThuLyXXGDT then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NgayThuLyXXGDT <= vvngaythulyden then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYXXGDT) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
          ---------------------------------------
          and  (v.TRANGTHAIID=14 or v.TrangThaiId = 15) 
          and (vToaAnID !=1 Or (NVL(v.IsRutKN,0)=0 and vToaAnID =1)) --manhnd bo ngay 28/5/2021 do Rut KN van cần phai ra QD dinh chi
          and 1=case when vTrangthai=-1 then 1
                     ---chua thu ly xx----
                     when vTrangthai=2 and v.TrangThaiId = 14  and v.THAMQUYENXXGDT = vToaAnID then 1

                     ---da thu lyxx và chưa co ket qua
                     when vTrangthai=0-- and v.TrangThaiId = 15
                        and ((NVL(v.XXGDTTT_ISKETQUA,0)=0 and NVL(v.XXGDTTT_KETQUAID,0)=0)
                             or (v.XXGDTTT_KETQUAID>0 
                                  and (v.XXGDTTT_NGAYQD >vvngaythulyden))
                            )
                         and (v.NGAYTHULYXXGDT is not null and (to_char(v.NGAYTHULYXXGDT,'dd/MM/yyyy') !='01/01/0001'))   
                      then 1 

                      ----da xet xu-------------
                     when vTrangthai=1 and v.TrangThaiId >= 14
                           and NVL(v.XXGDTTT_ISKETQUA,0)>0 then 1 else 0 
                end
                --duongph 22/02/2022
            and (v_LoaiGDT = 4 
                or (v_LoaiGDT = 0 and (v.TRUONGHOPTHULY = 0 or v.TRUONGHOPTHULY is null) )
                or (v_LoaiGDT in (1,2,3) and v.TRUONGHOPTHULY = v_LoaiGDT)
                 or (v_LoaiGDT in (5) and  v.LOAI_GDTTTT = 1 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn GDT
                or (v_LoaiGDT in (6) and  v.LOAI_GDTTTT = 2 and NVL(v.TRUONGHOPTHULY,0) = 0) -- đơn Tai tham
                )
          ---------Ket qua xet xu GDTTT-----------------------------
          and 1= case when vKetquaxetxu =0 then 1
                      when vKetquaxetxu =-1 and (NVL(v.XXGDTTT_KETQUAID,0) =0) then 1
                      when vKetquaxetxu>0  and (NVL(v.XXGDTTT_KETQUAID,0) = vKetquaxetxu) then 1
                 end               
          and 1= case when vThamquyenxx =0 then 1
                      when vThamquyenxx >0 and NVL(v.THAMQUYENXXGDT,0) = vThamquyenxx then 1
                  end

          ------------------------------------------        
          and  1=case when vNgayXX_Tu is null then 1 
                      when v.TrangThaiID >= 14 and vNgayXX_Tu <= v.XXGDTTT_NGAYQD then 1 else 0 end
          and 1=case when vNgayXX_Den is null then 1 
                     when v.TrangThaiID >= 14  and v.XXGDTTT_NGAYQD <= vNgayXX_Den then 1 else 0 end
          and (vSoKhangNghi = 0 or (v.VIENTRUONGKN_SO = vSoKhangNghi and v.ISVIENTRUONGKN = 1)or (v.GDQ_SO = vSoKhangNghi and v.GQD_LOAIKETQUA = 1))
          and (vNgayKhangNghi is null or vNgayKhangNghi = ''
                or (to_date(v.VIENTRUONGKN_NGAY,'dd/MM/yyyy') = to_date(vNgayKhangNghi,'dd/MM/yyyy') and v.ISVIENTRUONGKN = 1) 
                or (to_date(v.GDQ_NGAY,'dd/MM/yyyy') = to_date(vNgayKhangNghi,'dd/MM/yyyy') and v.GQD_LOAIKETQUA = 1)
                )
            and (vVIENTRUONGKN_NGUOIKY = 0 
                Or (vVIENTRUONGKN_NGUOIKY  not in (44,55,66,0) and v.VIENTRUONGKN_NGUOIKY = vVIENTRUONGKN_NGUOIKY)
                Or (vVIENTRUONGKN_NGUOIKY = 66 and NVL(v.ISVIENTRUONGKN,0) = 0 and v.GQD_LOAIKETQUA = 1)
                Or (vVIENTRUONGKN_NGUOIKY = 55 and NVL(v.ISVIENTRUONGKN,0) = 0 and v.GQD_LOAIKETQUA = 1)
                Or (vVIENTRUONGKN_NGUOIKY = 44 and NVL(v.ISVIENTRUONGKN,0) = 0 and v.GQD_LOAIKETQUA = 1)
                )
--        Qua han luat dinh
          and (v_QUAHAN_LUATDINH = -1
                Or (v_QUAHAN_LUATDINH = 0 and NVL(tk_qh.NOIDUNG_TK,0)= 0)
                Or (v_QUAHAN_LUATDINH > 0 and NVL(tk_qh.NOIDUNG_TK,0) = v_QUAHAN_LUATDINH)
                )  
--        Ap dung an le
         and (v_Apdung_AnLe = -1
                Or (v_Apdung_AnLe = 0 and NVL(tk_al.GIATRI_TK,0) = 0)
                Or (v_Apdung_AnLe > 0 and NVL(tk_al.GIATRI_TK,0) = v_Apdung_AnLe)
                )
      )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTT_VUAN_XETXU_SEARCH;