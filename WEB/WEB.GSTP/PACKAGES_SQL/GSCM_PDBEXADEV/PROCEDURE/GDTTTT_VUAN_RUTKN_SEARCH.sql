create or replace NONEDITIONABLE PROCEDURE        "GDTTTT_VUAN_RUTKN_SEARCH" 
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
  
  LoaiAnDB in number,
  IsHoanTHA in number,
  
  vIsRutKN in number,
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
             where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
                      and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                      and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                      and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)                     

                      and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
                      and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end

                      and 1=case when vLoaiAn=0 and v.LoaiAn<>7  then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
                      and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
                      and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
                      and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end

                      and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
                      and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
                      and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         

                      -----------Vu an co GQD = Khang Nghi f co kq xet xu--------------------------
                      and v.TrangThaiID in (14, 15)
                      /*and (v.TrangThaiID =14 or  NVL(v.GQD_LOAIKETQUA,3) =1) 
                          and NVL(v.XXGDTTT_KETQUAID, 0)=0*/
                      and 1= case when vIsRutKN =0 then 1 
                                  when vIsRutKN>0 and NVL(v.IsRutKN,0) =1 then 1
                                  end
                      -----------------------------------------------
                       and 1= case when LoaiAnDB = 0 then 1
                            when LoaiAnDB=1 and NVL(v.IsAnQuocHoi,0)=1 then 1 
                            when LoaiAnDB=2 and NVL(v.IsAnChiDao,0)=1 then 1 
                            when LoaiAnDB=4 and NVL(v.ISANTRAODOICV,0)=1 then 1 
                            when LoaiAnDB =3 and 1=(case when ( v.LOAIAN=1 and (sysdate-v.NGAYXUPHUCTHAM-365-90)>0) then 1 
                                                         when ( v.LOAIAN>1 and (sysdate-v.NGAYXUPHUCTHAM-3*365-90)>0) then 1 
                                                     else 0 end) then 1
                        end
                      -----------------------------------------------
                      and 1= case when IsHoanTHA =2 then 1
                                  when IsHoanTHA<2 and NVL(v.GQD_IsHoanTHA,0)= IsHoanTHA then 1  end
                    ;
  ----------------------------------------------

         OPEN curReturn FOR
           select a.*, TotalItem as CountAll 
                --,(Select count(d.ID) from GDTTT_DON d where d.VUVIECID=v.ID and d.CD_TRANGTHAI=2) TongDon
                ,(SELECT LISTAGG(cast(dt.ID as varchar2(10)), ',')
                     WITHIN GROUP (ORDER BY dt.NGAYTAO desc) FROM GDTTT_DON dt 
                     WHERE  dt.VUVIECID=a.ID and dt.CD_TRANGTHAI=2) arrDONID

               , case a.SoCV81 when 0 then ''
                       else (SELECT LISTAGG(cast(dt.ID as varchar2(10)), ',')
                            WITHIN GROUP (ORDER BY dt.NGAYTAO desc) FROM GDTTT_DON dt  
                            WHERE  dt.VUVIECID=a.ID  and  dt.LOAICONGVAN in (Select ID from DM_DATAITEM where ArrSapXep like (ArrSapXep_AnQuocHoi||'/%'))) 
                  END AS arrCV81ID        

                , case a.IsAnChiDao when 0 then ''
                      ELSE (SELECT LISTAGG(cast(dt.ID as varchar2(10)), ',')
                            WITHIN GROUP (ORDER BY dt.NGAYTAO desc) FROM GDTTT_DON dt 
                            WHERE  dt.VUVIECID=a.ID  and  dt.CHIDAO_COKHONG=1)
                  END AS arrCHIDAOID
            from (
                  Select ROW_NUMBER() OVER (ORDER BY v.NGAYTHULYDON desc) STT
                      , NVL(v.TongDon,0 ) as TongDon
                      ,DECODE(AQH.VuViecID,NULL,0,1) as SoCV81 
                      , NVL(v.IsAnChiDao, 0) as IsAnChiDao

                      ,v.ID,v.MAVUAN,v.SOTHULYDON,to_char(v.NGAYTHULYDON,'dd/MM/yyyy')NGAYTHULYDON
                      ,v.NGUYENDON,v.BIDON,NVL(v.ARRNGUOIKHIEUNAI,v.NGUOIKHIEUNAI) NGUOIKHIEUNAI
--                      ,v.SOANPHUCTHAM,to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') NGAYXUPHUCTHAM
--
--                      , txx.Ma_Ten ToaXX ,DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
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
                      ,qhpl.TENQHPL QHPLDN,tp.HOTEN as TENTHAMPHAN
                      ,ttv.HOTEN as TENTHAMTRAVIEN
                      , case when (Length(NVL(v.NGAYPHANCONGTTV,''))=0 or (to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYPHANCONGTTV,'')) >0 then to_char(v.NGAYPHANCONGTTV,'dd/MM/yyyy')
                          end  NGAYPHANCONGTTV

                       , NVL(ld.HOTEN,'') as TENLANHDAO, NVL(cv.Ten,'') ChucVuLanhDao, NVL(cv.Ma,'') MaChucVuLD          
                      ,v.GHICHU,v.NGUOITAO ,to_char(v.NGAYTAO,'dd/MM/yyyy HH24:MI') NGAYTAO
                      ,v.NGUOISUA,to_char(v.NGAYSUA,'dd/MM/yyyy HH24:MI') NGAYSUA
                      ,v.TRANGTHAIID, tt.TENTINHTRANG
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
                              , 3,GQD_KETQUA
                              , 4,'VKS đang giải quyết') KQ_GQD
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
                      ,NVL( v.GQD_HoanTHA_TenNguoiKy ,'') GQD_HoanTHA_TenNguoiKy   
                      -------------------------------
                      , NVL(v.IsHoSo,0) IsHoSo, v.NGAYTTVNHAN_THS
                      , NVL(v.IsToTrinh,0) IsToTrinh  
                      , NVL(v.IsRutKN,0) IsRutKN , NVL(v.SORUTKN, '') SORUTKN
                      , case when (Length(NVL(v.NGAYRUTKN,''))=0 or (to_char(v.NGAYRUTKN,'dd/MM/yyyy') ='01/01/0001')) then ''
                               when Length(NVL(v.NGAYRUTKN,'')) >0 then to_char(v.NGAYRUTKN,'dd/MM/yyyy')
                          end  NGAYRUTKN 
                      , GDTTT_ToTrinh_GetMaxNgayTrinh(v.ID, 'LDVU',0) NgayTrinhLDVu
                      ,GDTTT_ToTrinh_TraToTrinh(v.ID, 'LDVU',0) TraToTrinh
                       , (v.SOANPHUCTHAM || chr(10) 
                            || case when (Length(NVL(v.NGAYXUPHUCTHAM,''))=0 or (to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') ='01/01/0001')) then ''
                                     when Length(NVL(v.NGAYXUPHUCTHAM,'')) >0 then to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy')
                                end) as TTBANANPT, tptc.hoten AS THAMPHANTC_TEN
                    from GDTTT_VUAN v 
                    left join DM_TOAAN txx on v.TOAPHUCTHAMID=txx.ID
                    left join (select ID, Ma_Ten from DM_TOAAN) tst on v.TOAANSOTHAM=tst.ID
                    left join (select ID, Ma_Ten from DM_TOAAN) tqd on v.TOAQDID=tqd.ID
                    left join GDTTT_DM_QHPL qhpl on v.QHPL_DINHNGHIAID=qhpl.ID
                    left join DM_CANBO tp on v.THAMPHANID=tp.ID
                    left join DM_CANBO ttv on v.THAMTRAVIENID=ttv.ID
                    left join DM_CANBO ld on v.LANHDAOVUID=ld.ID
                     left join DM_DataITem cv on ld.ChucVuID = cv.ID
                    left join GDTTT_DM_TINHTRANG tt on tt.ID=v.TRANGTHAIID
                      --anhvh--án quốc hội gồm công văn 8.1 và 9.3
                      LEFT JOIN (select D.VuViecID from GDTTT_DON d 
                                 WHERE d.LOAICONGVAN in(Select I.ID from DM_DATAITEM I where (I.ID=546 OR I.CAPCHAID=546 OR I.ID = 1023 OR I.CAPCHAID=1023))
                                 GROUP BY d.VuViecID)AQH ON AQH.VuViecID=V.ID
                    
                    --03/12/2025 lấy thông tin TPTC đc phân công vụ án có ý kiến kháng nghị
                    LEFT JOIN GDTTT_VUAN_CHITIET_CHUYEN ctc on v.ID = ctc.VUANID and ctc.TRANGTHAI = 2 and NVL(ctc.THAMPHANID, 0) <> 0 -- ctc.TRANGTHAI = 2 là HCTP đã nhận vụ án kháng nghị
                    LEFT JOIN DM_CANBO tptc ON tptc.id = ctc.THAMPHANID
                    
                   where v.TOAANID=vToaAnID and v.PhongBanID=vPhongBanID
                       and ( vToaRaBAQD = 0 or v.TOAQDID = vToaRaBAQD or v.TOAPHUCTHAMID = vToaRaBAQD  or v.ToaAnSoTham =vToaRaBAQD)
                        and ( vSoBAQD is null or vSoBAQD = '' or UPPER(v.SO_QDGDT) like '%' || UPPER(vSoBAQD) || '%' or  UPPER(v.SoAnPhucTham) like '%' || UPPER(vSoBAQD) || '%'  or UPPER(v.SoAnSoTham) like '%' || UPPER(vSoBAQD) || '%')   
                        and ( vNgayBAQD is null or vNgayBAQD = '' or to_char(v.NGAYQD,'dd/MM/yyyy') = vNgayBAQD or to_char(v.NGAYXUPHUCTHAM,'dd/MM/yyyy') = vNgayBAQD  or to_char(v.NgayXuSoTham,'dd/MM/yyyy') = vNgayBAQD)                     

                      and 1=case when vNguyendon || ' '=' ' then 1 when (lower(v.NGUYENDON) like '%' || lower(vNguyendon) || '%') then 1 else 0 end
                      and 1=case when vBidon || ' '=' ' then 1 when (lower(v.BIDON) like '%' || lower(vBidon) || '%') then 1 else 0 end

                      and 1=case when vLoaiAn=0 and v.LoaiAn<>7  then 1 when v.LOAIAN=vLoaiAn then 1 else 0 end
                      and 1=case when vThamtravien=0 then 1 when v.THAMTRAVIENID=vThamtravien then 1 else 0 end
                      and 1=case when vLanhdao=0 then 1 when v.LANHDAOVUID=vLanhdao then 1 else 0 end
                      and 1=case when vThamphan=0 then 1 when v.THAMPHANID=vThamphan then 1 else 0 end

                      and  1=case when vNgayThulyTu is null then 1 when vNgayThulyTu <= v.NGAYTHULYDON then 1 else 0 end
                      and 1=case when vNgayThulyDen is null then 1 when v.NGAYTHULYDON <= vNgayThulyDen then 1 else 0 end
                      and 1=case when vSoThuly || ' '=' ' then 1 when lower(v.SOTHULYDON) like '%' || lower(vSoThuly) || '%' then 1 else 0 end         

                      -----------Vu an co GQD = Khang Nghi e co kq xet xu--------------------------
                      and v.TrangThaiID in (14, 15)
                      /*and (v.TrangThaiID =14 or  NVL(v.GQD_LOAIKETQUA,5) =1) 
                          and NVL(v.XXGDTTT_KETQUAID, 0)=0*/
                      and 1= case when vIsRutKN =0 then 1 
                                  when vIsRutKN>0 and NVL(v.IsRutKN,0) =1 then 1
                                  end
                      -----------------------------------------------
                        and 1= case when LoaiAnDB = 0 then 1
                            when LoaiAnDB=1 and NVL(v.IsAnQuocHoi,0)=1 then 1 
                            when LoaiAnDB=2 and NVL(v.IsAnChiDao,0)=1 then 1 
                            when LoaiAnDB=4 and NVL(v.ISANTRAODOICV,0)=1 then 1 
                            when LoaiAnDB =3 and 1=(case when ( v.LOAIAN=1 and (sysdate-v.NGAYXUPHUCTHAM-365-90)>0) then 1 
                                                         when ( v.LOAIAN>1 and (sysdate-v.NGAYXUPHUCTHAM-3*365-90)>0) then 1 
                                                     else 0 end) then 1
                        end
                      -----------------------------------------------
                      and 1= case when IsHoanTHA =2 then 1
                                  when IsHoanTHA<2 and NVL(v.GQD_IsHoanTHA,0)= IsHoanTHA then 1  end   

             )a where a.stt>=MinIndex and a.stt<=MaxIndex;

END GDTTTT_VuAn_RutKN_Search;