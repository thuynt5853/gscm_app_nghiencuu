--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_DON_APP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_DON_APP" AS
PROCEDURE GDTTTT_VUAN_QLHS_SEARCH
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
  vSophieunhan in number,
  hs_tungay in date,
  hs_denngay in date,
  vSoThuly in varchar2,   
  vKetquathuly in number,   
  isTTMuonHS in number,
  vLoaiphieu in varchar2,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
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
    where v.TOAANID=vToaAnID and (vPhongBanID=0 or v.PhongBanID=vPhongBanID)
          and 1=case when vToaRaBAQD=0 then 1 when v.TOAPHUCTHAMID=vToaRaBAQD then 1 else 0 end
          and 1=case when vSoBAQD || ' '=' ' then 1 when (lower(v.SOANPHUCTHAM) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end
          and 1=case when vNgayBAQD || ' '=' ' then 1 when (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end      

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

          and 1=case when vLoaiAn=0 and v.LoaiAn<>7  then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end

          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         

           -- vKetquathuly =3--> tat ca, =4-->chua co kqgq, <3--> da co kqgq
          and 1=case when vKetquathuly=3 then 1 
                     when vKetquathuly=4 
                          and ( (NVL(v.GQD_LOAIKETQUA,4) = vKetquathuly ) 
                          and v.TrangThaiID not in (13,14,16,18) 
                          ) then 1
                     when vKetquathuly=5 and NVL(v.GQD_LOAIKETQUA,5) <5 then 1
                     when vKetquathuly<3 and  NVL(v.GQD_LOAIKETQUA,5)=vKetquathuly then 1  end

          -------------------------------------------------                  
         /*
          and 1= case   when isTTMuonHS =2 then 1
                        when isTTMuonHS<2 and NVL(v.IsHoSo,0)=isTTMuonHS then 1
                end


          ------------------------------------------- 
          and 1=( case when hs_tungay is null and hs_denngay is null then 1
                            when (hs_tungay is not null or hs_denngay is not null) and  isTTMuonHS=1
                                and GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay)>0 
                            then 1
                             when ( hs_denngay is not null) and  isTTMuonHS=0
                             and  (v.NGAYTHULYDON<hs_denngay) then 1
                      end )
             */
            and (vSophieunhan = 0 
                   or (vSophieunhan > 0 and isTTMuonHS =1 and exists(select id from GDTTT_QUANLYHS where SOPHIEU = vSophieunhan and loai = 3 and VUANID = v.id))
                    or (vSophieunhan > 0 and isTTMuonHS =3 and exists(select id from GDTTT_QUANLYHS where SOPHIEU = vSophieunhan and loai = 0 and VUANID = v.id))
                ) 
            and (isTTMuonHS =2  -- tất cả 
                    or (isTTMuonHS =1 and  EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and (hs_tungay is not null or hs_denngay is not null) and GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay)>0 ) -- đã có hồ sơ trong khoảng từ ngày đến ngày
                    or (isTTMuonHS =1 and  EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and hs_tungay is null and hs_denngay is null) -- đã có hồ sơ
                    or (isTTMuonHS =0 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and (hs_tungay is null or hs_denngay is null)) -- chưa có hồ sơ
                    or (isTTMuonHS =3 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and hs_tungay is null and hs_denngay is null and EXISTS(SELECT id FROM GDTTT_QUANLYHS WHERE vuanid = v.id and LOAI =0))-- chưa có hồ sơ và đã có phiếu mượn
                    or (isTTMuonHS =3 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and (hs_tungay is not null or hs_denngay is not null) and GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay)>0 and EXISTS(SELECT id FROM GDTTT_QUANLYHS WHERE vuanid = v.id and LOAI =0))
                    or (isTTMuonHS =4 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI =0) )-- chưa có hồ sơ và chưa có phiếu mượn
                    )
            and (vLoaiphieu is null or EXISTS( select hs.id from GDTTT_QUANLYHS hs where hs.loai = vLoaiphieu and  hs.vuanid = v.id))
             ---Đơn xin ân giảm,vụ án tử hình
                AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
                    OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
                AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
                    OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
                    OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
                  )
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
                      --
--                , v.SOANPHUCTHAM
--                , case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
--                         when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
--                    end  NGAYXUPHUCTHAM  
--
--                , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
                ,decode(NVL(v.QHPL_THONGKEID,0),0
                                            ,decode(Trim(v.QHPL_TEXT),null
                                                                    ,qhpl.TenQHPL,v.QHPL_TEXT)
                                                                    ,TD.DIEU ||'.'|| TD.TENTOIDANH) QHPLDN
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

             where v.TOAANID=vToaAnID and (vPhongBanID=0 or v.PhongBanID=vPhongBanID)
                 and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                      -----------------------
                and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)       

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

                and 1=case when vLoaiAn=0  and v.LoaiAn<>7  then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
                and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
                and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
                and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
                -----------------------------------------------  
               /* and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
                and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
               */ and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
                ----------------------------------------------- 
                -- vKetquathuly =3--> tat ca, =4-->chua co kqgq, <3--> da co kqgq
                and 1=case when vKetquathuly=3 then 1 
                           when vKetquathuly=4 
                                and ((NVL(v.GQD_LOAIKETQUA,4) = vKetquathuly ) and v.TrangThaiID  not in (13,14,16,18) ) then 1
                           when vKetquathuly=5 and NVL(v.GQD_LOAIKETQUA,5) <5 then 1
                           when vKetquathuly<3 and  NVL(v.GQD_LOAIKETQUA,5)=vKetquathuly then 1 
                end                
                -----------------------------------------------    
               /*
                and 1= case when isTTMuonHS =2 then 1
                            when isTTMuonHS<2 and NVL(v.IsHoSo,0)=isTTMuonHS then 1
                end    

                and 1=( case when hs_tungay is null and hs_denngay is null then 1
                            when (hs_tungay is not null or hs_denngay is not null) and  isTTMuonHS=1
                                  and GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay)>0 
                                 then 1
                            when ( hs_denngay is not null) and  isTTMuonHS=0
                                 and  (v.NGAYTHULYDON<hs_denngay) then 1
                      end )
                      */
                and (vSophieunhan = 0 
                    or (vSophieunhan > 0 and isTTMuonHS =1 and exists(select id from GDTTT_QUANLYHS where SOPHIEU = vSophieunhan and loai = 3 and VUANID = v.id))
                    or (vSophieunhan > 0 and isTTMuonHS =3 and exists(select id from GDTTT_QUANLYHS where SOPHIEU = vSophieunhan and loai = 0 and VUANID = v.id))
                )  
                and (isTTMuonHS =2  -- tất cả 
                    or (isTTMuonHS =1 and  EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and (hs_tungay is not null or hs_denngay is not null) and GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay)>0 ) -- đã có hồ sơ trong khoảng từ ngày đến ngày
                    or (isTTMuonHS =1 and  EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and hs_tungay is null and hs_denngay is null) -- đã có hồ sơ
                    or (isTTMuonHS =0 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and (hs_tungay is null or hs_denngay is null)) -- chưa có hồ sơ
                    or (isTTMuonHS =3 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and hs_tungay is null and hs_denngay is null and EXISTS(SELECT id FROM GDTTT_QUANLYHS WHERE vuanid = v.id and LOAI =0))-- chưa có hồ sơ và đã có phiếu mượn
                    or (isTTMuonHS =3 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and (hs_tungay is not null or hs_denngay is not null) and GDTTT_QuanLyHS_SearchByTime(v.ID,isTTMuonHS, hs_tungay, hs_denngay)>0 and EXISTS(SELECT id FROM GDTTT_QUANLYHS WHERE vuanid = v.id and LOAI =0))
                    or (isTTMuonHS =4 and  not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI = 3) and not EXISTS(SELECT hs.id FROM GDTTT_QUANLYHS hs WHERE hs.vuanid = v.id and hs.LOAI =0) )-- chưa có hồ sơ và chưa có phiếu mượn
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
                and (vLoaiphieu is null or EXISTS( select hs.id from GDTTT_QUANLYHS hs where hs.loai = vLoaiphieu and  hs.vuanid = v.id))
                ------------------------------------------------ 

       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END GDTTTT_VUAN_QLHS_SEARCH;

PROCEDURE VUAN_PHANCONGTTV
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
  vQHPLID in number,
  vQHPLDNID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number, 

  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_GIAIDOAN in number,
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
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
        --left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        --left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        --left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        --left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
          ------------------
--          and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
--          and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end
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

          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
            and 1=case when vTrangthai=0  and (NVL(v.THAMTRAVIENID,0)=0 and NVL(v.XXGDT_THAMTRAVIENID,0)=0) and v.gqd_loaiketqua is null then 1
                     when vTrangthai=1 and (NVL(v.THAMTRAVIENID,0)>0 or NVL(v.XXGDT_THAMTRAVIENID,0)>0 ) then 1 
                     else 0 end
        ---Đơn xin ân giảm,vụ án tử hình
        AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
            OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
        AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
            OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )         

                     ;
   OPEN curReturn FOR
     select a.*, TotalItem as CountAll 
			from (
      Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc, v.SoThuLyDon DESC) STT
          ,v.ID,v.MAVUAN
          ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON

          --,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
          , v.SOANPHUCTHAM || chr(10) ||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') TTBANANPT 
            ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
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

         , NVL(v.IsVienTruongKN,0) IsVienTruongKN
          ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
          ,v.NGUOIKHIEUNAI          
          , txx.Ma_Ten ToaXX 
          --,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
          ,decode(Trim(v.QHPL_THONGKEID),null,decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT), TD.DIEU ||'.'|| TD.TENTOIDANH) QHPLDN

          , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
              end  NGAYPHANCONGTTV
          , case when (Length(NVL(v.NGAYTTVNHAN_THS,''))=0 or (to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYTTVNHAN_THS,'')) >0 then to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy')
              end  NGAYTTVNHAN_THS


          , case when (Length(NVL(v.NGAYPHANCONGLD,''))=0 or (to_char(v.NGAYPHANCONGLD,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYPHANCONGLD,'')) >0 then to_char(v.NGAYPHANCONGLD,'dd/MM/yyyy')
              end  NGAYPHANCONGLD
          ,v.LANHDAOVUID,decode(v.XXGDT_LANHDAOVUID,null,ld.HOTEN,ldxx.HOTEN) TENLANHDAO

          ,v.GHICHU,v.NGUOITAO,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
          ,v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
          ,tt.TENTINHTRANG
           , GDTTT_PCCB_GetAllByType(v.ID, 1,1) PhanCongTTV
           , GDTTT_PCCB_GetAllByType(v.ID, 1,2) PhanCongTTV_GDT
          , GDTTT_PCCB_GetAllByType(v.ID, 2,1) PhanCongLD
          , GDTTT_PCCB_GetAllByType(v.ID, 2,2) PhanCongLD_GDT
          ,v.THAMTRAVIENID,ttv.HOTEN as TENTHAMTRAVIEN
          ,v.XXGDT_THAMTRAVIENID,ttvxx.HOTEN as TENTHAMTRAVIEN_GDT
          ,decode (to_char(v.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy'),'01/01/0001','',to_char(v.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')) XXGDT_NGAYPHANCONGTTV
          ,NVL(v.XXGDT_LANHDAOVUID,0) XXGDT_LANHDAOVUID,ldxx.HOTEN as TENLANHDAO_GDT
          ,decode (to_char(v.XXGDT_NGAYPHANCONGLD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.XXGDT_NGAYPHANCONGLD,'dd/MM/yyyy')) XXGDT_NGAYPHANCONGLD
       from GDTTT_VUAN v 
        left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
        left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        left join DM_BOLUAT_TOIDANH td on v.QHPL_THONGKEID = td.id
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        left join DM_CANBO ttvxx on v.XXGDT_THAMTRAVIENID=ttvxx.ID
        left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
        left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
        left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
        ----lấy tên đương sự được khiếu nại  --anhvh add 03/06/2021
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
         -------               
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
          -------------------
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
          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
             and 1=case when vTrangthai=0  and (NVL(v.THAMTRAVIENID,0)=0 and NVL(v.XXGDT_THAMTRAVIENID,0)=0) and v.gqd_loaiketqua is null then 1
                     when vTrangthai=1 and (NVL(v.THAMTRAVIENID,0)>0 or NVL(v.XXGDT_THAMTRAVIENID,0)>0 ) then 1 
                     else 0 end
        --Đơn xin ân giảm,vụ án tử hình
         AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
            OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
         AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
            OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
        --Tim kiem TTV theo giai doan Giai quyet don hoặc xet xu GĐT
        And (v_GIAIDOAN = 0 
            or  (v_GIAIDOAN = 2 and EXISTS(select id from GDTTT_VUAN_PHANCONGCB_HISTORY where GIAIDOANGQ= 2 and v.id = VUANID))
            or  v_GIAIDOAN = 1
        )
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END VUAN_PHANCONGTTV;


PROCEDURE VUAN_PHANCONGTP
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
  vQHPLID in number,
  vQHPLDNID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number, 

  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_GIAIDOAN in number,
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
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
        --left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        --left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        --left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        --left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
          ------------------
--          and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
--          and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end
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
          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1  else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
            and 1=case when vTrangthai=0  and (NVL(v.THAMTRAVIENID,0)=0 and NVL(v.XXGDT_THAMTRAVIENID,0)=0) and v.gqd_loaiketqua is null then 1
                     when vTrangthai=1 and (NVL(v.THAMTRAVIENID,0)>0 or NVL(v.XXGDT_THAMTRAVIENID,0)>0 ) then 1 
                     else 0 end

        ---Đơn xin ân giảm,vụ án tử hình
        AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
            OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
        AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
            OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )         

and (vThamphan=0 or (v.THAMPHANID=vThamphan and vThamphan>0) or (v.THAMPHANID is null and vThamphan=-1))
                     ;
   OPEN curReturn FOR
     select a.*, TotalItem as CountAll 
			from (
      Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc, v.SoThuLyDon DESC) STT
          ,v.ID,v.MAVUAN
          ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON

          --,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
          , v.SOANPHUCTHAM || chr(10) ||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') TTBANANPT 
            ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
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

         , NVL(v.IsVienTruongKN,0) IsVienTruongKN
          ,DECODE(v.NGUYENDON,NULL,ND.NGUYENDON_ND,v.NGUYENDON) NGUYENDON
                       ,decode(v.loaian,1,DECODE(v.BIDON,NULL,HSKN.BICAO,v.BIDON),DECODE(v.BIDON,NULL,BD.BIDON_BD,v.BIDON)) BIDON
          ,v.NGUOIKHIEUNAI          
          , txx.Ma_Ten ToaXX 
          --,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
          ,decode(Trim(v.QHPL_THONGKEID),null,decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT), TD.DIEU ||'.'|| TD.TENTOIDANH) QHPLDN

          , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
              end  NGAYPHANCONGTTV
          , case when (Length(NVL(v.NGAYTTVNHAN_THS,''))=0 or (to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYTTVNHAN_THS,'')) >0 then to_char(v.NGAYTTVNHAN_THS,'dd/MM/yyyy')
              end  NGAYTTVNHAN_THS


          , case when (Length(NVL(v.NGAYPHANCONGLD,''))=0 or (to_char(v.NGAYPHANCONGLD,'dd/MM/yyyy') ='01/01/0001')) then ''
                   when Length(NVL(v.NGAYPHANCONGLD,'')) >0 then to_char(v.NGAYPHANCONGLD,'dd/MM/yyyy')
              end  NGAYPHANCONGLD
          ,v.LANHDAOVUID,decode(v.XXGDT_LANHDAOVUID,null,ld.HOTEN,ldxx.HOTEN) TENLANHDAO
            ,v.THAMPHANID,ld.HOTEN TENTHAMPHAN
          ,v.GHICHU,v.NGUOITAO,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
          ,v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
          ,tt.TENTINHTRANG
           , GDTTT_PCCB_GetAllByType(v.ID, 1,1) PhanCongTTV
           , GDTTT_PCCB_GetAllByType(v.ID, 1,2) PhanCongTTV_GDT
          , GDTTT_PCCB_GetAllByType(v.ID, 2,1) PhanCongLD
          , GDTTT_PCCB_GetAllByType(v.ID, 2,2) PhanCongLD_GDT
          ,v.THAMTRAVIENID,ttv.HOTEN as TENTHAMTRAVIEN
          ,v.XXGDT_THAMTRAVIENID,ttvxx.HOTEN as TENTHAMTRAVIEN_GDT
          ,decode (to_char(v.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy'),'01/01/0001','',to_char(v.XXGDT_NGAYPHANCONGTTV,'dd/MM/yyyy')) XXGDT_NGAYPHANCONGTTV
          ,NVL(v.XXGDT_LANHDAOVUID,0) XXGDT_LANHDAOVUID,ldxx.HOTEN as TENLANHDAO_GDT
          ,decode (to_char(v.XXGDT_NGAYPHANCONGLD,'dd/MM/yyyy'),'01/01/0001','',to_char(v.XXGDT_NGAYPHANCONGLD,'dd/MM/yyyy')) XXGDT_NGAYPHANCONGLD
       from GDTTT_VUAN v 
        left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
        left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        left join DM_BOLUAT_TOIDANH td on v.QHPL_THONGKEID = td.id
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        left join DM_CANBO ttvxx on v.XXGDT_THAMTRAVIENID=ttvxx.ID
        left join DM_CANBO ld on v.THAMPHANID=ld.ID
        left join DM_CANBO ldxx on v.XXGDT_LANHDAOVUID=ldxx.ID
        left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
        ----lấy tên đương sự được khiếu nại  --anhvh add 03/06/2021
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
         -------               
       where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)
          -------------------
--          and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
--          and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end
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

          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
          and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
             and 1=case when vTrangthai=0  and (NVL(v.THAMTRAVIENID,0)=0 and NVL(v.XXGDT_THAMTRAVIENID,0)=0) and v.gqd_loaiketqua is null then 1
                     when vTrangthai=1 and (NVL(v.THAMTRAVIENID,0)>0 or NVL(v.XXGDT_THAMTRAVIENID,0)>0 ) then 1 
                     else 0 end

        --Đơn xin ân giảm,vụ án tử hình
         AND (v_ISXINANGIAM=0 --trường hợp loại bỏ không phân quyền xin ân giảm 
            OR(v_ISXINANGIAM=1 AND  (V.ISXINANGIAM =1 OR V.ISXINANGIAM=2))--trường hợp được phân quyền xin ân giảm hoặc xin ân giảm + giám đốc thẩm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
         AND  (v_GDT_ISXINANGIAM=0--trường hợp loại bỏ không phân quyền GĐT + xin ân giảm
            OR(v_GDT_ISXINANGIAM=1 AND  (V.ISXINANGIAM IS NULL OR V.ISXINANGIAM = 0 or v.ISXINANGIAM = 2))--được phân quyền gđt hoặc xin ân giảm
            OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--trường hợp loại bỏ khi check cả hai(xin ân giảm và gđt+xin ân giảm) 
          )
        --Tim kiem TTV theo giai doan Giai quyet don hoặc xet xu GĐT
        And (v_GIAIDOAN = 0 
            or  (v_GIAIDOAN = 2 and EXISTS(select id from GDTTT_VUAN_PHANCONGCB_HISTORY where GIAIDOANGQ= 2 and v.id = VUANID))
            or  v_GIAIDOAN = 1
        )
        and (vThamphan=0 or (v.THAMPHANID=vThamphan and vThamphan>0) or (v.THAMPHANID is null and vThamphan=-1))
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END VUAN_PHANCONGTP;


PROCEDURE DON_GIAIQUYET_SEARCH
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
  vGiaoTHS in number,
  IsGhepVuAn in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
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

    Select Count(d.ID)into TotalItem 
    from GDTTT_DON d
         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
         left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID

    where  d.TOAANID=vToaAnID 
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 
        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end
         and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end        
         and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end       
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        --1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        1=case when vTuNgay is null then 1 when vTuNgay <= dc.NGAYNHAN then 1 else 0 end
        and
        --1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        1=case when vDenNgay is null then 1 when dc.NGAYNHAN <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and
        --1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
         1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end

        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and d.CD_TA_DONVIID=vCD_DONVIID and d.CD_LOAI=0     
        --and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        --and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dc.NGAYCHUYEN then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dc.NGAYCHUYEN  <= vNgaychuyenDen then 1 else 0 end
       -- and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like lower(vSoThuly) then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 

        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
                    end
            -- them loai an
--        and 1 = case when vloaian  = 0 then 1
--                     when vloaian >0 and NVL(va.LOAIAN,0) = vloaian then 1
--                end
          and 1 = case when vloaian  = 0 then 1
                        when NVL(d.BAQD_LOAIAN,0) = vloaian then 1
                        end
         --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
            AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
              )
            and (vGiaoTHS = 0 
                or (vGiaoTHS =1 and EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =2 and NOT EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =3 and EXISTS (select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                or (vGiaoTHS =4 and NOT EXISTS(select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                )
            ;

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
        , case when length(NVL(a.arrCongvan, ''))>0 then (' (' || a.arrCongvan || ')') else '' end as CV_NguoiKhieuNai
  from (
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      , d.ID ,dc.ID as DCID 
      , NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                  then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
            else 0 end,0) DonThuLyMoi_ID
      ,d.MADON,d.NGUOIGUI_HOTEN, NVL(d.VuviecID,0) VuViecID
      ,d.SOTHUTUDON,d.NGAYNHANDON

      , NVL(d.ISTHULY,0) IsThuLy
      , (case NVL(d.ISTHULY,0) when 1 then u'Th\1ee5 l\00fd m\1edbi' else u'\0110\00e3 th\1ee5 l\00fd' end) TrangThaiThuLy
--      ,d.BAQD_LOAIQDBA,d.BAQD_SO, d.BAQD_NGAYBA, d.BAQD_CAPXETXU       
      ,d.BAQD_LOAIAN
--      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
--     , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
--                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
--                    end  NgayBA_PT 
      ,decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT, d.BAQD_TOAANID) BAQD_TOAANID
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(va.BAQD_CAPXETXU,2,('BA: ' || va.SOANSOTHAM),3,('BA: ' || va.SOANPHUCTHAM), ('BA: ' || va.SO_QDGDT)) END) VA_BAQD_SO
        ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(va.BAQD_CAPXETXU,2,va.NGAYXUSOTHAM,3,va.NGAYXUPHUCTHAM,va.NGAYQD) END) VA_BAQD_NGAYBA      
--      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
--      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,NVL(d.BAQD_CAPXETXU,4) BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

      , va.NGUYENDON ,va.BIDON , decode (Trim(va.QHPL_TEXT),null,cf.TenQHPL,va.QHPL_TEXT) TenQHPL
      ,d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI
      ,d.NGAYTAO NgayNhap 
        ,case when (Length(NVL(d.NgayTao,''))=0 or (to_char(d.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.NgayTao,'')) >0 then to_char(d.NgayTao,'dd/MM/yyyy')
        end  NgayTaoStr 
      ,TL_NGAY ,TL_SO,d.ISSHOWFULL
      , case when (Length(NVL(d.TL_NGAY,''))=0 or (to_char(d.TL_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.TL_NGAY,'')) >0 then to_char(d.TL_NGAY,'dd/MM/yyyy')
                    end  TL_NGAY_TEXT 
      ,d.LOAIDON
      ,case d.LOAIDON when 1 then 'Đơn' 
                      when 2 then 'Đơn tố cáo' 
                      when 3 then 'Đơn + Công văn' end as HinhThuc
      ,DECODE(D.TOAANID,1,'',LAD.LOAIDON_TEN) HINHTHUCDON
      ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO
      , case when (Length(NVL(d.NGAYGHITRENDON,''))=0 or (to_char(d.NGAYGHITRENDON,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.NGAYGHITRENDON,'')) >0 then to_char(d.NGAYGHITRENDON,'dd/MM/yyyy')
        end  NGAYGHITRENDON

      , txx.Ma_Ten ToaXX 
      --,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
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
      , NVL(va.ID, 0) VuAnID
      --, NVL(va.TOAPHUCTHAMID, 0) IsMapVuAn
      , Decode(va.BAQD_CAPXETXU,2,NVL(va.TOAANSOTHAM, 0),3,NVL(va.TOAPHUCTHAMID, 0),NVL(va.TOAQDID, 0)) IsMapVuAn
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
                                    where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           )  End) arrTTTL
        --Lịch sử chuyển nhận đơn Manhnd đang viet chưa xong
--        ,(select GHICHU from GDTTT_DON_CHUYEN where DONID = d.id) GHICHU_HIS 
        ,'' TT_DON
    from GDTTT_DON d

         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
         left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
         left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
         left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
         left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=vToaAnID)LAD ON LAD.LOAIDON_ID=d.LOAIDON
    where d.TOAANID=vToaAnID  
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 
        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end

        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end        
         and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end         
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        --1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        1=case when vTuNgay is null then 1 when vTuNgay <= dc.NGAYNHAN then 1 else 0 end
        and
        --1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        1=case when vDenNgay is null then 1 when dc.NGAYNHAN <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and 1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end      
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and d.CD_TA_DONVIID=vCD_DONVIID and d.CD_LOAI=0     
        --and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        --and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end   
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dc.NGAYCHUYEN then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dc.NGAYCHUYEN <= vNgaychuyenDen then 1 else 0 end      

        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like  lower(vSoThuly)  then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 

        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
            end
            -- them loai an
        and 1 = case when vloaian  = 0 then 1
                     when vloaian >0 and NVL(d.BAQD_LOAIAN,0) = vloaian then 1
            end
         --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
            AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
              )
         and (vGiaoTHS = 0 
                or (vGiaoTHS =1 and EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =2 and NOT EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =3 and EXISTS (select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                or (vGiaoTHS =4 and NOT EXISTS(select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                )
        ) a
        where a.stt>=MinIndex and a.stt<=MaxIndex;
END DON_GIAIQUYET_SEARCH;

PROCEDURE DON_GIAIQUYET_SEARCH_HISTORY
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
  vGiaoTHS in number,
  IsGhepVuAn in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
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

    Select Count(d.ID)into TotalItem 
    from GDTTT_DON d
--         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
        inner join GDTTT_DON_CHUYEN_HISTORY dc on dc.DONID=d.ID

         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
         left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID

    where  d.TOAANID=vToaAnID 
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 
        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end
         and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end        
         and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end       
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        --1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        1=case when vTuNgay is null then 1 when vTuNgay <= dc.NGAYNHAN then 1 else 0 end
        and
        --1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        1=case when vDenNgay is null then 1 when dc.NGAYNHAN <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and
        --1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
         1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end

        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and d.CD_TA_DONVIID=vCD_DONVIID and d.CD_LOAI=0     
        --and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        --and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dc.NGAYCHUYEN then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dc.NGAYCHUYEN  <= vNgaychuyenDen then 1 else 0 end
       -- and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like lower(vSoThuly) then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 
--        and ((vTrangthai = 3 and (EXISTS( select 'X' from GDTTT_DON_CHUYEN_HISTORY h where h.donid = d.id) 
--                                or d.CD_TRANGTHAI=3)
--                ) 
--             or (vTrangthai != 3 and  d.CD_TRANGTHAI=vTrangthai ))       
        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
                    end
            -- them loai an
--        and 1 = case when vloaian  = 0 then 1
--                     when vloaian >0 and NVL(va.LOAIAN,0) = vloaian then 1
--                end
          and 1 = case when vloaian  = 0 then 1
                        when NVL(d.BAQD_LOAIAN,0) = vloaian then 1
                        end
         --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
            AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
              )
            and (vGiaoTHS = 0 
                or (vGiaoTHS =1 and EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =2 and NOT EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =3 and EXISTS (select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                or (vGiaoTHS =4 and NOT EXISTS(select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                )
            ;

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
        , case when length(NVL(a.arrCongvan, ''))>0 then (' (' || a.arrCongvan || ')') else '' end as CV_NguoiKhieuNai
  from (
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      , d.ID ,dc.ID as DCID 
      , NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                  then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
            else 0 end,0) DonThuLyMoi_ID
      ,d.MADON,d.NGUOIGUI_HOTEN, NVL(d.VuviecID,0) VuViecID
      ,d.SOTHUTUDON,d.NGAYNHANDON

      , NVL(d.ISTHULY,0) IsThuLy
      , (case NVL(d.ISTHULY,0) when 1 then u'Th\1ee5 l\00fd m\1edbi' else u'\0110\00e3 th\1ee5 l\00fd' end) TrangThaiThuLy
--      ,d.BAQD_LOAIQDBA,d.BAQD_SO, d.BAQD_NGAYBA, d.BAQD_CAPXETXU       
      ,d.BAQD_LOAIAN
--      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
--     , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
--                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
--                    end  NgayBA_PT 
      ,decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT, d.BAQD_TOAANID) BAQD_TOAANID
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD
   
       ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA

        ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(va.BAQD_CAPXETXU,2,('BA: ' || va.SOANSOTHAM),3,('BA: ' || va.SOANPHUCTHAM), ('BA: ' || va.SO_QDGDT)) END) VA_BAQD_SO
        ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(va.BAQD_CAPXETXU,2,va.NGAYXUSOTHAM,3,va.NGAYXUPHUCTHAM,va.NGAYQD) END) VA_BAQD_NGAYBA  
--      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
--      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
        , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,NVL(d.BAQD_CAPXETXU,4) BAQD_CAPXETXU
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

      , va.NGUYENDON ,va.BIDON , cf.TenQHPL
      ,d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI
      ,d.NGAYTAO NgayNhap 
        ,case when (Length(NVL(d.NgayTao,''))=0 or (to_char(d.NgayTao,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.NgayTao,'')) >0 then to_char(d.NgayTao,'dd/MM/yyyy')
        end  NgayTaoStr 
      ,TL_NGAY ,TL_SO,d.ISSHOWFULL
      , case when (Length(NVL(d.TL_NGAY,''))=0 or (to_char(d.TL_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.TL_NGAY,'')) >0 then to_char(d.TL_NGAY,'dd/MM/yyyy')
                    end  TL_NGAY_TEXT 
      ,d.LOAIDON
      ,case d.LOAIDON when 1 then 'Đơn' 
                      when 2 then 'Đơn tố cáo' 
                      when 3 then 'Đơn + Công văn' end as HinhThuc
      ,DECODE(D.TOAANID,1,'',LAD.LOAIDON_TEN) HINHTHUCDON
      ,d.NGUOIGUI_DIACHI || ' ' || h.MA_TEN Diachigui,d.CV_SO
      , case when (Length(NVL(d.NGAYGHITRENDON,''))=0 or (to_char(d.NGAYGHITRENDON,'dd/MM/yyyy') ='01/01/0001')) then ''
             when Length(NVL(d.NGAYGHITRENDON,'')) >0 then to_char(d.NGAYGHITRENDON,'dd/MM/yyyy')
        end  NGAYGHITRENDON

      , txx.Ma_Ten ToaXX 
      --,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
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
      , NVL(va.ID, 0) VuAnID
      --, NVL(va.TOAPHUCTHAMID, 0) IsMapVuAn
      , Decode(va.BAQD_CAPXETXU,2,NVL(va.TOAANSOTHAM, 0),3,NVL(va.TOAPHUCTHAMID, 0),NVL(va.TOAQDID, 0)) IsMapVuAn
      ,(case NVL(va.TRANGTHAIID, 3) when 3 then 0 else 1 end) as IsKetQuaGQDon 

      , NVL(va.SOTHULYDON,0) VA_SoThuLy, va.NGAYTHULYDON VA_NgayThuLy
      , NVL(va.SOANPHUCTHAM,'') VA_SoBA, va.NGAYXUPHUCTHAM VA_NgayBA
      , NVL(va.TOAPHUCTHAMID,0) VA_ToaPT, NVL(va.QHPL_DINHNGHIAID,0) VA_QHPL
      ,dc.ARRDONTRUNG, dc.SOLUONGDON SODON

      , (SELECT LISTAGG(TO_CHAR(cv.CV_TENDONVI) 
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
                                    where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           )  End) arrTTTL
        --Lịch sử chuyển nhận đơn Manhnd đang viet chưa xong
        ,dc.ghichu GHICHU_HIS 
        ,'' TT_DON
    from GDTTT_DON d
--         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         inner join GDTTT_DON_CHUYEN_HISTORY dc on dc.DONID=d.ID
--         left join ( select * from GDTTT_DON_CHUYEN_HISTORY) h on h.donid = d.id
         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
         left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
         left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
         left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
         left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
         LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=vToaAnID)LAD ON LAD.LOAIDON_ID=d.LOAIDON

    where d.TOAANID=vToaAnID  
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 
        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end

        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end        
         and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end         
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        --1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        1=case when vTuNgay is null then 1 when vTuNgay <= dc.NGAYNHAN then 1 else 0 end
        and
        --1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        1=case when vDenNgay is null then 1 when dc.NGAYNHAN <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and 1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end      
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
        and d.CD_TA_DONVIID=vCD_DONVIID and d.CD_LOAI=0     
        --and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        --and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end   
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dc.NGAYCHUYEN then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dc.NGAYCHUYEN <= vNgaychuyenDen then 1 else 0 end      

        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like  lower(vSoThuly)  then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 
--        and ((vTrangthai = 3 and (EXISTS( select 'X' from GDTTT_DON_CHUYEN_HISTORY h where h.donid = d.id)
--                                or d.CD_TRANGTHAI=3)) 
--            or (vTrangthai != 3 and  d.CD_TRANGTHAI=vTrangthai ))         
        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
            end
            -- them loai an
        and 1 = case when vloaian  = 0 then 1
                     when vloaian >0 and NVL(d.BAQD_LOAIAN,0) = vloaian then 1
            end
         --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
            AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
              )
         and (vGiaoTHS = 0 
                or (vGiaoTHS =1 and EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =2 and NOT EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =3 and EXISTS (select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                or (vGiaoTHS =4 and NOT EXISTS(select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                )
        ) a
        where a.stt>=MinIndex and a.stt<=MaxIndex;
END DON_GIAIQUYET_SEARCH_HISTORY;


PROCEDURE DON_GDTTT_GIAONHAN_THS
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
  vGiaoTHS in number,
  IsGhepVuAn in number,
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
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

    Select Count(d.ID)into TotalItem 
    from GDTTT_DON d
--         inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         left join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
         left join GDTTT_VuAn va on d.VUVIECID = va.ID
         left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
         left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
         left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
          left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
         left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID

    where  d.TOAANID=vToaAnID 
       And 1=(Case when vIsThuLy=-1 then 1 
                   when vIsThuLy=2 and NVL(d.ISTHULY,0)=2 then 1 
                  when vIsThuLy=1 
                    and (NVL(d.ISThuLy, 0)=1 
                          or  NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                                          then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
                                    else 0 end,0)>0)  then 1
              Else 0 End) 

        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end

        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end        
         and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end      

        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        --1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        1=case when vTuNgay is null then 1 when vTuNgay <= dc.NGAYNHAN then 1 else 0 end
        and
        --1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        1=case when vDenNgay is null then 1 when dc.NGAYNHAN <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and
        --1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like '%' || lower(vSoCongVan) || '%' then 1 else 0 end
         1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end

        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
--        and d.CD_TA_DONVIID=vCD_DONVIID 
        and d.CD_LOAI=0     
        --and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        --and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dc.NGAYCHUYEN then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dc.NGAYCHUYEN  <= vNgaychuyenDen then 1 else 0 end
       -- and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like '%' || lower(vSoThuly) || '%' then 1 else 0 end
        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like lower(vSoThuly) then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 
        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
                    end
            -- them loai an
--        and 1 = case when vloaian  = 0 then 1
--                     when vloaian >0 and NVL(va.LOAIAN,0) = vloaian then 1
--                end
          and 1 = case when vloaian  = 0 then 1
                        when NVL(d.BAQD_LOAIAN,0) = vloaian then 1
                        end
         --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
            AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
              )
            and (vGiaoTHS = 0 
                or (vGiaoTHS =1 and EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =2 and NOT EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =3 and EXISTS (select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                or (vGiaoTHS =4 and NOT EXISTS(select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                )
            ;

  OPEN curReturn FOR
  select a.*, TotalItem as CountAll 
        , case when length(NVL(a.arrCongvan, ''))>0 then (' (' || a.arrCongvan || ')') else '' end as CV_NguoiKhieuNai
  from (
  Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT
      , d.ID  ,dc.ID as DCID 
      , NVL(case when NVL(d.IsThuLy, 0) =2 and NVL(dc.SoLuongDon,0)>1
                  then GDTTT_GetDonID_TLMoiChuyenCung(d.ID)
            else 0 end,0) DonThuLyMoi_ID
      ,d.MADON,d.NGUOIGUI_HOTEN, NVL(d.VuviecID,0) VuViecID
      ,d.SOTHUTUDON,d.NGAYNHANDON

      , NVL(d.ISTHULY,0) IsThuLy
      , (case NVL(d.ISTHULY,0) when 1 then u'Th\1ee5 l\00fd m\1edbi' else u'\0110\00e3 th\1ee5 l\00fd' end) TrangThaiThuLy
      ,d.BAQD_LOAIQDBA, NVL(d.BAQD_CAPXETXU,4) BAQD_CAPXETXU
--       , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
--                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
--                    end  NgayBA_PT  
      ,d.BAQD_LOAIAN
     ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) NgayBA_PT
     ,decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT, d.BAQD_TOAANID) BAQD_TOAANID
      ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD_SO
       ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA

       , decode(d.BAQD_SO_ST,null,'',('BA:'||d.BAQD_SO_ST||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')||' '|| txxST.MA_TEN)) Infor_ST
        , decode(d.BAQD_SO_PT,null,'',('BA:'||d.BAQD_SO_PT||' ngày: '||TO_CHAR(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')||' '|| txxPT.MA_TEN)) Infor_PT
        ,d.BAQD_SO_PT,d.BAQD_SO_ST

      , va.NGUYENDON ,va.BIDON , cf.TenQHPL
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
      , NVL(va.THAMTRAVIENID,0) THAMTRAVIENID,(Select HOTEN from DM_CANBO where ID=va.THAMTRAVIENID) TENTHAMTRAVIEN
      , va.LANHDAOVUID,(Select HOTEN from DM_CANBO where ID=va.LANHDAOVUID) TENLANHDAOVU 
      , va.THAMPHANID,(Select HOTEN from DM_CANBO where ID=va.THAMPHANID) TENTHAMPHAN
      , NVL(va.ID, 0) VuAnID
       --, NVL(va.TOAPHUCTHAMID, 0) IsMapVuAn
      , Decode(va.BAQD_CAPXETXU,2,NVL(va.TOAANSOTHAM, 0),3,NVL(va.TOAPHUCTHAMID, 0),NVL(va.TOAQDID, 0)) IsMapVuAn
      ,(case NVL(va.TRANGTHAIID, 3) when 3 then 0 else 1 end) as IsKetQuaGQDon 

      , NVL(va.SOTHULYDON,0) VA_SoThuLy, va.NGAYTHULYDON VA_NgayThuLy
      , NVL(va.SOANPHUCTHAM,'') VA_SoBA, va.NGAYXUPHUCTHAM VA_NgayBA
      , NVL(va.TOAPHUCTHAMID,0) VA_ToaPT, NVL(va.QHPL_DINHNGHIAID,0) VA_QHPL
      ,dc.ARRDONTRUNG
--      , dc.SOLUONGDON SODON
        ,'1' SODON
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
        ,to_char(ths.NGAYNHAN,'dd/MM/yyyy') NGAYNHANTHS,ths.NGUOICHUYEN_ID,ths.NGUOINHAN_ID,ths.GHICHU GHICHUTHS, ths.id ths_ID

    from GDTTT_DON d
--      inner join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
        left join GDTTT_DON_CHUYEN dc on dc.DONID=d.ID
        left join GDTTT_VuAn va on d.VUVIECID = va.ID
        left join GDTTT_DM_QHPL cf on cf.ID = va.QHPL_DINHNGHIAID
        left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
        left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
        left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID
        left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID
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

        and 1=case when IsGhepVuAn=2 then 1 
                   when IsGhepVuAn =1 and NVL(d.VuViecID,0)>0 then 1 
                   when IsGhepVuAn=0 and NVL(d.VuViecID,0)=0 then 1 else 0 end

        and 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end        
         and 1=case when vSoBAQD || ' '=' ' then 1 when 
                                        (lower(d.BAQD_SO) like '%' || lower(vSoBAQD) || '%' 
                                        Or lower(d.BAQD_SO_PT) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.BAQD_SO_ST) like '%' || lower(vSoBAQD) || '%'
                                        Or lower(d.KN_SOQD) like '%' || lower(vSoBAQD) || '%') then 1 else 0 end         
        and  1=case when vNgayBAQD || ' '=' ' then 1 when 
                                                (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')=vNgayBAQD
                                                Or to_char(d.BAQD_NGAYBA_PT,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.BAQD_NGAYBA_ST,'dd/MM/yyyy')=vNgayBAQD 
                                                Or to_char(d.KN_NGAY,'dd/MM/yyyy')=vNgayBAQD) then 1 else 0 end           
        and
        1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
        and
        1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
        and
        --1=case when vTuNgay is null then 1 when vTuNgay <= d.CD_NgayXuLy then 1 else 0 end
        1=case when vTuNgay is null then 1 when vTuNgay <= dc.NGAYNHAN then 1 else 0 end
        and
        --1=case when vDenNgay is null then 1 when d.CD_NgayXuLy <= vDenNgay then 1 else 0 end
        1=case when vDenNgay is null then 1 when dc.NGAYNHAN <= vDenNgay then 1 else 0 end
        and
        1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
        and
        1=case when vSoHieuDon || ' '=' ' then 1 when d.MADON =vSoHieuDon  then 1 else 0 end
        and
        1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
        and
        1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
        and
        1=case when vDiaChiCT || ' '=' ' then 1 when lower(d.NGUOIGUI_DIACHI) like '%' || lower(vDiaChiCT) || '%' then 1 else 0 end       
        and 1=case when vSoCongVan || ' '=' ' then 1 when lower(d.CD_SOCV) like  lower(vSoCongVan)  then 1 else 0 end      
        and
        1=case when vNgayCongVan || ' '=' ' then 1 when to_char(d.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
        and
        1=case when vTraLoi=0 then 1 when d.TRALOIDON=vTraLoi then 1 else 0 end
        and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(d.nguoitao)|| ',%') then 1 else 0 end
--        and d.CD_TA_DONVIID=vCD_DONVIID 
        and d.CD_LOAI=0     
        --and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= d.CD_NGAYXULY then 1 else 0 end
        --and 1=case when vNgaychuyenDen is null then 1 when d.CD_NGAYXULY <= vNgaychuyenDen then 1 else 0 end   
        and  1=case when vNgaychuyenTu is null then 1 when vNgaychuyenTu <= dc.NGAYCHUYEN then 1 else 0 end
        and 1=case when vNgaychuyenDen is null then 1 when dc.NGAYCHUYEN <= vNgaychuyenDen then 1 else 0 end      

        and 1=case when vSoThuly || ' '=' ' then 1 when lower(d.TL_SO) like  lower(vSoThuly)  then 1 else 0 end
        and 1=case when vArrSelectID  || ' '=' ' then 1 when vArrSelectID like '%,' || Cast(d.ID as varchar2(10)) || ',%' then 1 else 0 end
        and 1=case when vPhanloaixuly=0 then 1 when d.PHANLOAIXULY=vPhanloaixuly then 1 else 0 end
        and  d.CD_TRANGTHAI=vTrangthai 
        and 1= case when vPhancongTTV=0 then 1
                    when vPhancongTTV>0 and NVL(va.THAMTRAVIENID,0) = vPhancongTTV then 1
            end
            -- them loai an
        and 1 = case when vloaian  = 0 then 1
                     when vloaian >0 and NVL(d.BAQD_LOAIAN,0) = vloaian then 1
            end
         --anhvh add trường hợp có đơn xin ân giảm vụ án tử hình  
            AND (v_ISXINANGIAM=0 --không được phân quyền <=>chị Minh
                OR(v_ISXINANGIAM=1 AND d.ISANTUHINH=1)--anh Hiển
                OR(v_ISXINANGIAM=1 AND v_GDT_ISXINANGIAM=1)--lãnh đạo
              )
         and (vGiaoTHS = 0 
                or (vGiaoTHS =1 and EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =2 and NOT EXISTS( select 'X' from GDTTT_DON_GIAONHAN_THS where donid = d.id))
                or (vGiaoTHS =3 and EXISTS (select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                or (vGiaoTHS =4 and NOT EXISTS(select 'X' from GDTTT_VUAN where id = d.vuviecid and NGAYTTVNHAN_THS is not null and  to_char(NGAYTTVNHAN_THS,'dd/MM/yyyy')!='03/01/0001'))
                )
        ) a
        where a.stt>=MinIndex and a.stt<=MaxIndex;
END DON_GDTTT_GIAONHAN_THS;

PROCEDURE  GDTTT_GIAONHAN_THS_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_DONID in number,
    v_NGUOICHUYEN_ID in number,
    v_NGUOINHAN_ID in number,
    v_NGAYCHUYEN in date,
    v_NGAYNHAN in date,
    v_TRANGTHAI in number,
    v_GHICHU     in varchar2
)
IS 
vcheck number;
vvuanid number;
BEGIN
        if (v_id >0) then
            update GDTTT_DON_GIAONHAN_THS
                    set
                        DONID = v_DONID,
                        NGUOICHUYEN_ID     = v_NGUOICHUYEN_ID,
                        NGUOINHAN_ID   = v_NGUOINHAN_ID,
                        NGAYCHUYEN   =   v_NGAYCHUYEN,
                        NGAYNHAN = v_NGAYNHAN,
                        TRANGTHAI = 1,
                        GHICHU  =  v_GHICHU,
                        NGAYSUA = sysdate
                    where id = v_id ;   
        else
            -- thêm thông tin giao nhận THS
            insert into GDTTT_DON_GIAONHAN_THS 
                (id,DONID,NGUOICHUYEN_ID,NGUOINHAN_ID,NGAYCHUYEN,NGAYNHAN,TRANGTHAI,GHICHU,ngaytao)
                values (GDTTT_DON_GIAONHAN_THS_SEQ.nextval,v_DONID,v_NGUOICHUYEN_ID,v_NGUOINHAN_ID,v_NGAYCHUYEN,v_NGAYNHAN,1,v_GHICHU,sysdate);


                select vuviecid into vvuanid from gdttt_don d where d.id = v_DONID;
                if (vvuanid > 0)then
                --Thêm Ngày giao THS cho TTV nếu Vụ an chưa có ngay nay 
                   select count(*) into vcheck from gdttt_vuan v 
                            where v.id = vvuanid and v.NGAYTTVNHAN_THS is null;
                    if (vcheck = 1) then
                        update gdttt_vuan set NGAYTTVNHAN_THS = v_NGAYNHAN 
                                        where id = vvuanid and NGAYTTVNHAN_THS is null;
                    end if;

--                -- Thêm TTV nếu Vụ án chưa có TTV
--                    select count(*) into vcheck from gdttt_vuan v 
--                            where v.id = vvuanid and (v.THAMTRAVIENID is null OR v.THAMTRAVIENID = 0);
--                     if (vcheck = 1) then
--                        update gdttt_vuan set THAMTRAVIENID = v_NGUOINHAN_ID 
--                                        where id = vvuanid and (THAMTRAVIENID is null OR THAMTRAVIENID = 0);
--                    end if;
                end if;

        end if;

End GDTTT_GIAONHAN_THS_UP_IN;

PROCEDURE  GDTTT_GIAONHAN_THS_DEL
( 
    v_id  in number DEFAULT 0
)
IS 
BEGIN
        if (v_id >0) then
            DELETE GDTTT_DON_GIAONHAN_THS where id = v_id ;   
        end if;

End GDTTT_GIAONHAN_THS_DEL;


PROCEDURE VUAN_PHANCONG_THAMPHAN_SEARCH
( 
  vToaAnID in number,
  vPhongBanID  in number,
  vToaRaBAQD in number,
  vSoBAQD in varchar2,
  vNgayBAQD in varchar2, 
  vNguyendon in varchar2,
  vBidon in varchar2,
  vLoaiAn in number,
  vThamphan in number,
  vQHPLID in number,
  vQHPLDNID in number,
  vNgayThulyTu in date,
  vNgayThulyDen in date,
  vSoThuly in varchar2, 
  vTrangthai in number, 
  v_ISXINANGIAM in number,
  v_GDT_ISXINANGIAM in number,
  v_GIAIDOAN in number,
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
    Select Count(v.ID)into TotalItem     
    from GDTTT_VUAN v 
        --left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        --left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        --left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
        --left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
       where v.TOAANID=vToaAnID 
          and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                      -----------------------
          and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
          and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)        
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
          and 1=case when vLoaiAn=0 then 1 when NVL(v.LOAIAN,0)=vLoaiAn then 1 else 0 end
          and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end
          and 1=case when vQHPLID=0 then 1 when v.QHPL_THONGKEID=vQHPLID then 1 else 0 end
          and 1=case when vQHPLDNID=0 then 1 when v.QHPL_DINHNGHIAID=vQHPLDNID then 1 else 0 end
          and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
          and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
          and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         
          and ((vTrangthai=0  and NVL(v.THAMPHANID,0)=0) Or  ( vTrangthai=1 and NVL(v.THAMPHANID,0)>0))
          and (vPhongBanID  = 0 or  v.phongbanid = vPhongBanID)
          and (v.gqd_loaiketqua is null or (v.gqd_loaiketqua = 1 and NVL(v.XXGDTTT_ISKETQUA,0) = 0 and v.THAMQUYENXXGDT = 1)) 
                     ;
   OPEN curReturn FOR
     select a.*,'' arrDONID, TotalItem as CountAll 
			from (
      Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc, v.SoThuLyDon DESC) STT
          ,v.ID,v.MAVUAN, NVL(v.TongDon,0 ) as TongDon 
          ,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON

          --,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
          , v.SOANPHUCTHAM || chr(10) ||to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') TTBANANPT 
            ,DECODE(v.BAQD_CAPXETXU,4,v.so_qdgdt,3,v.SOANPHUCTHAM,2,v.SOANSOTHAM,v.SOANPHUCTHAM) SOANPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,to_char(v.NGAYQD,'dd/MM/yyyy'),2,to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy'),to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')) NGAYXUPHUCTHAM
            ,DECODE(v.BAQD_CAPXETXU,4,DM_CanBo_TenToaVT(tqd.Ma_Ten),2,DM_CanBo_TenToaVT(tst.Ma_Ten),DM_CanBo_TenToaVT(txx.Ma_Ten)) TOAXX_VietTat
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

         , NVL(v.IsVienTruongKN,0) IsVienTruongKN
          ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
          , txx.Ma_Ten ToaXX 
          --,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
          --,qhpl.TENQHPL QHPLDN
          ,decode(Trim(v.QHPL_THONGKEID),null,decode (Trim(v.QHPL_TEXT),null,qhpl.TenQHPL,v.QHPL_TEXT), TD.DIEU ||'.'|| TD.TENTOIDANH) QHPLDN

          , case when (Length(NVL(v.NGAYPHANCONGTP,''))='' or (to_char(v.NGAYPHANCONGTP,'dd/MM/yyyy') ='01/01/0001')) then null
                 when Length(NVL(v.NGAYPHANCONGTP,'')) >0 then to_char(v.NGAYPHANCONGTP,'dd/MM/yyyy')
              end  NGAYPHANCONGTP

            , v.THAMPHANID,decode(NVL(v.THAMPHANID,0),0,null, 'TP: '||tp.HOTEN) as TenThamPhan
            , GDTTT_PCTP_GetAll(v.ID,1) PhanCongTP
            , GDTTT_PCTP_GetAll(v.ID,2) PhanCongTP_GDT
          ,v.GHICHU,v.NGUOITAO,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
          ,v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
          ,tt.TENTINHTRANG
          ,(SELECT a.CD_SOTOTRINH 
                from (select ROW_NUMBER() OVER (ORDER BY d.CD_NGAYTOTRINH asc) STT, d.CD_SOTOTRINH,CD_NGAYTOTRINH
                    from GDTTT_DON d
                    where d.VUVIECID= v.id AND d.CD_TRANGTHAI=2 AND d.ISTHULY=1
                    ) a where a.STT<=1) CD_SOTOTRINH
            ,(SELECT  decode(a.CD_NGAYTOTRINH,null,null,to_char(a.CD_NGAYTOTRINH,'dd/MM/yyyy')) 
                from (select ROW_NUMBER() OVER (ORDER BY d.CD_NGAYTOTRINH asc) STT, d.CD_SOTOTRINH,CD_NGAYTOTRINH
                    from GDTTT_DON d
                    where d.VUVIECID= v.id AND d.CD_TRANGTHAI=2 AND d.ISTHULY=1
                    ) a where a.STT<=1) CD_NGAYTOTRINH
            , PKG_GDTTT_BAOCAO_APP.GDTTT_Don_GetThuLyByVuAn(v.ID) LisThuLyDon 
            ,(select count(id) from gdttt_don d where d.VUVIECID = v.id and d.isthuly= 1) cThulymoi
       from GDTTT_VUAN v 
        left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
        left join DM_TOAAN tst on v.TOAANSOTHAM=tst.ID
        left join DM_TOAAN tqd on v.TOAQDID=tqd.ID
        left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
        left join DM_BOLUAT_TOIDANH td on v.QHPL_THONGKEID = td.id
        --left join DM_CANBO tp on v.THAMPHANID=tp.ID
        left join DM_CANBO tp on v.thamphanid=tp.ID
        left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID

       where v.TOAANID=vToaAnID 
          and (vToaRaBAQD=0 or v.TOAPHUCTHAMID=vToaRaBAQD Or v.TOAANSOTHAM = vToaRaBAQD Or v.TOAQDID = vToaRaBAQD)
          and (vSoBAQD || ' '=' '   or lower(v.SO_QDGDT) like '%' || lower(vSoBAQD) || '%'
                                    or lower(v.SOANPHUCTHAM) like '%' || lower(vSoBAQD) || '%'
                                    or lower(v.SOANSOTHAM) like '%' || lower(vSoBAQD) || '%')
          and (vNgayBAQD || ' '=' ' or (to_char(v.NGAYQD,'dd/MM/yyyy')=vNgayBAQD)
                                    or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')=vNgayBAQD)
                                    or (to_char(v.NGAYXUSOTHAM,'dd/MM/yyyy')=vNgayBAQD))   

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
          and ( vLoaiAn=0 or NVL(v.LOAIAN,0)=vLoaiAn)
          and (vThamphan=0 or v.THAMPHANID=vThamphan)
          and (vQHPLID=0 or v.QHPL_THONGKEID=vQHPLID )
          and (vQHPLDNID=0 or v.QHPL_DINHNGHIAID=vQHPLDNID)
          and  (vNgayThulyTu is null or vNgayThulyTu <= v.NGAYTHULYDON)
          and (vNgayThulyDen is null or v.NGAYTHULYDON <= vNgayThulyDen )
          and (vSoThuly || ' '=' ' or lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' )       
          and ((vTrangthai=0  and NVL(v.THAMPHANID,0)=0) Or  ( vTrangthai=1 and NVL(v.THAMPHANID,0)>0))
          and (vPhongBanID  = 0 or  v.phongbanid = vPhongBanID)
          and (v.gqd_loaiketqua is null or (v.gqd_loaiketqua = 1 and NVL(v.XXGDTTT_ISKETQUA,0) = 0 and v.THAMQUYENXXGDT = 1)) 
       )a where a.stt>=MinIndex and a.stt<=MaxIndex;
END VUAN_PHANCONG_THAMPHAN_SEARCH;

PROCEDURE  VUAN_THAMPHAN_HISTORY_BY_ID
( 
    v_id  in number DEFAULT 0,  
    curReturn OUT sys_refcursor  
)
IS 
BEGIN
        if (v_id >0) then
            OPEN curReturn FOR 
                SELECT * FROM GDTTT_VUAN_PHANCONG_THAMPHAN_HISTORY where VUANID = v_id ; 
        end if;

End VUAN_THAMPHAN_HISTORY_BY_ID;

PROCEDURE  VUAN_THAMPHAN_HISTORY_UP_IN
( 
    v_id  in number DEFAULT 0,
    v_THAMPHAN_ID_OLD in number,
    v_TUNGAY in date,
    v_THAMPHAN_ID_NEW in number,
    v_DENNGAY in date,
    v_VUANID in number,
    V_DONID  in number,
    v_LYDO     in varchar2,
    v_GIAIDOAN in number,
    v_NGUOISUA in number,
    v_SOTT      in varchar2,
    v_NGAYTOTRINH in date

)
IS 
 vCD_SOTT_old varchar2(50);
 vCD_NGAYTT_old date;
 vCount_Don number;
 v_LYDO_new  varchar2(1000);
BEGIN

         if (v_VUANID>0 and v_THAMPHAN_ID_new >0) then
                select count(*) into vCount_Don  FROM GDTTT_DON 
                                WHERE VUVIECID= v_VUANID;
                 if (vCount_Don>0) then
                    v_LYDO_new := v_LYDO;
                 else
                    v_LYDO_new := v_LYDO || ' Số Tờ Trình:'||v_SOTT||'-'||to_char(v_NGAYTOTRINH,'dd/MM/yyyy');
                 end if;

             --Insert lich su Tham phan cua Vu an
            insert into GDTTT_VUAN_PHANCONG_THAMPHAN_HISTORY 
                (id,THAMPHAN_ID,TUNGAY,DENNGAY,VUANID,LYDO,GIAIDOAN,NGUOISUA,NGAYSUA)
                values (GDTTT_VUAN_PHANCONG_THAMPHAN_HISTORY_SEQ.nextval,v_THAMPHAN_ID_old,v_TUNGAY,v_DENNGAY,v_VUANID,v_LYDO_new,V_GIAIDOAN,v_NGUOISUA,sysdate);
            --Insert lich su don
            -- lay ra cac don thu ly moi đã ghep voi Vuan nay có Thamphanid khác với TP mới cần thay đổi
                FOR item IN (
                        select ID,CD_SOTOTRINH, CD_NGAYTOTRINH FROM GDTTT_DON CV 
                                WHERE CV.VUVIECID= v_VUANID AND CV.CD_TRANGTHAI=2 AND CV.ISTHULY=1 and CV.THAMPHANID != v_THAMPHAN_ID_new
                       ) LOOP

                    --insert lịch sử đơn
                    insert into GDTTT_DON_PHANCONG_THAMPHAN_HISTORY 
                        (id,THAMPHAN_ID,SOTT,NGAYTT,TUNGAY,DONID,VUANID,LYDO,NGUOISUA,NGAYSUA)
                    values (GDTTT_DON_PHANCONG_THAMPHAN_HISTORY_SEQ.nextval,v_THAMPHAN_ID_old,item.CD_SOTOTRINH,item.CD_NGAYTOTRINH,v_TUNGAY,item.ID,v_VUANID,v_LYDO,v_NGUOISUA,sysdate);

                    -- update lại to trinh moi của Đơn voi những đơn khác với TP mới
                    update GDTTT_DON
                            set 
                                CD_SOTOTRINH = v_SOTT,
                                CD_NGAYTOTRINH = v_NGAYTOTRINH,
                                THAMPHANID = v_THAMPHAN_ID_new
                            WHERE ID = ITEM.ID AND VUVIECID = v_VUANID AND ISTHULY = 1;      

                    --update lai Thẩm phán 
                        UPDATE GDTTT_PCTP_CHITIET
                                SET 
                                    CANBOID = v_THAMPHAN_ID_new,
                                    NGAYPHANCONGTP = v_DENNGAY
                                WHERE DONID = ITEM.ID;
                 END LOOP;

         ELSE
            IF (v_THAMPHAN_ID_new >0 and V_DONID >0) then

                     select CD_SOTOTRINH into vCD_SOTT_old FROM GDTTT_DON 
                                    WHERE ID= V_DONID;
                     select CD_NGAYTOTRINH into vCD_NGAYTT_old FROM GDTTT_DON 
                                    WHERE ID= V_DONID; 

                    --insert lịch sử đơn
                    insert into GDTTT_DON_PHANCONG_THAMPHAN_HISTORY 
                        (id,THAMPHAN_ID,SOTT,NGAYTT,TUNGAY,DONID,VUANID,LYDO,NGUOISUA,NGAYSUA)
                    values (GDTTT_VUAN_PHANCONG_THAMPHAN_HISTORY_SEQ.nextval,v_THAMPHAN_ID_old,vCD_SOTT_old,vCD_NGAYTT_old,v_TUNGAY,V_DONID,v_VUANID,v_LYDO,v_NGUOISUA,sysdate);

             end if;    
         end if;

End VUAN_THAMPHAN_HISTORY_UP_IN;

PROCEDURE  VUAN_THAMPHAN_HISTORY_DEL
( 
    v_id  in number DEFAULT 0

)
IS 
BEGIN
        if (v_id >0) then
            DELETE GDTTT_VUAN_PHANCONG_THAMPHAN_HISTORY where id = v_id ; 
        end if;

End VUAN_THAMPHAN_HISTORY_DEL;


END PKG_GDTTT_DON_APP;
