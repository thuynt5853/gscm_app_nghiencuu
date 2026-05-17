--------------------------------------------------------
--  DDL for Package Body PKG_THA
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_THA" AS

PROCEDURE  THA_THULY_GETLIST 
( vBiAnID in number,
    vVUANID  in number,
	curReturn OUT sys_refcursor
)
IS 
 CheckBanAnST number;
 CheckPhanCongTP number;
 CheckNguoiTienHanhTT number;
BEGIN

  OPEN curReturn FOR  
     Select t.ID,t.BIANID,t.VUANID,t.TOAANID,t.MATHULY,decode(NVL(t.TRUONGHOPTHULY,0),0,'Thụ lý mới','Thụ lý mới do Ủy thác') TRUONGHOPTHULY,t.NGAYTHULY,t.SOTHULY,
                t.THOIHAN_THANG,t.THOIHAN_NGAY,t.THOIHANTUNGAY,t.THOIHANDENNGAY,
                t.GHICHU,t.NGAYTAO,t.NGUOITAO,t.NGAYSUA,t.NGUOISUA,t.TT   
    From THA_THULY t
    Where t.BIANID=vBiAnID and t.VUANID = vVUANID
    ORder by t.NGAYTHULY desc; 
END THA_THULY_GETLIST;

  PROCEDURE GetBiAnTrongTHA
(
    toa_an_id in number
   , ma_bi_an in nvarchar2, ten_bi_an in nvarchar2
   , ma_vu_an in nvarchar2, ten_vu_an in nvarchar2
   , so_ban_an in varchar2, ngay_ban_an in date
	 , PageIndex	in	number
	 , PageSize	in	number
	 , curReturn    OUT   sys_refcursor)
AS
	TotalItem number;
  MinIndex	number;
  MaxIndex	number;
 -- TrangThai_v  number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;
    -- TrangThai_v := TrangThai;    
		--1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total    
    select  count(a.VuAn) into TotalItem
                from (
                          (
                            ------lay ds vu an , bi can theo an so tham
                            SELECT DISTINCT  a.ID IDVuAnHeThong, a.MaVuAn, a.TenVuAn                     
                                 , bc.ID BiAnID, bc.MaBiCan MaBiAn, bc.HoTen TenBiAn  
                                 , a.MaGiaiDoan
                                 , DECODE(a.MaGiaiDoan, 1, 'Hồ sơ' , 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec
                                 , st.SoBanAn, st.NgayBanAn, st.NgayHieuLucST NgayHieuLuc
                                 , THAVuAn.id VuAnID ,  a.ID as VuAn
                            from (select ID, MaVuAn, TenVuAn, ToaPhucThamID, MaGiaiDoan from AHS_VuAn 
                                  where ( MaGiaiDoan ='2' or MaGiaiDoan ='3') and ToaAnID= toa_an_id
                                       and 1=(CASE WHEN ma_vu_an='' THEN 1 
                                                   WHEN (LOWER(MaVuAn) LIKE  ('%' || LOWER(ma_vu_an) || '%')) THEN 1 END)                        
                                       and 1=(CASE WHEN ten_vu_an='' THEN 1 
                                                   WHEN (LOWER(TENVUAN) LIKE  ('%' || LOWER(ten_vu_an) || '%')) THEN 1 END)
                                  ) a
                                  inner join ( select a.ID BanAnID, a.VuAnID, a.NgayBanAn, (a.NgayBanAn+14) NgayHieuLucST, a.SoBanAn
                                               from AHS_SoTham_BanAn a
                                               left join AHS_PHUCTHAM_BANAN ptba on ptba.vuanid = a.VuAnID
                                               left join ahs_phuctham_quyetdinh_vuan ptqd on ptqd.vuanid = a.vuanid
                                               where 1=(CASE WHEN so_ban_an='' THEN 1 
                                                            WHEN (LOWER(a.SoBanAn) = so_ban_an) THEN 1 END)    
                                                     and (1=(CASE WHEN ngay_ban_an is NULL THEN 1 
                                                                  WHEN a.NgayBanAn = ngay_ban_an THEN 1 Else 0 END))
                                                     and (a.NgayBanAn <= CURRENT_DATE-31 or ptba.id is not null or ptqd.quyetdinhid = 79
                                                     or ptqd.quyetdinhid = 80 or ptqd.quyetdinhid = 127 or ptqd.quyetdinhid = 128
                                                     or ptqd.quyetdinhid = 203 or ptqd.quyetdinhid = 205 or ptqd.quyetdinhid = 324)
                                               ) st on st.VuAnID = a.ID
                                  left join THA_VUAN THAVuAn on a.ID = thavuan.idvuanhethong            
                                  inner join (select BanAnID, BiCaoID from AHS_SOTHAM_BANAN_BICAO)stbc on stbc.BanAnID= st.BanAnID
                                  inner join (
                                select idkckn,
                                CONCAT(CONCAT(LISTAGG(KC1ID, ',') WITHIN GROUP (ORDER BY KC1ID), LISTAGG(KC2ID, ',') WITHIN GROUP (ORDER BY KC2ID)),LISTAGG(KNID, ',') WITHIN GROUP (ORDER BY KNID)) as KCKN,
                                ','||LISTAGG(BAPT, ',') WITHIN GROUP (ORDER BY BAPT)|| ',' as bapt,
                                ','||LISTAGG(ketquaphuctham, ',') WITHIN GROUP (ORDER BY BAPT)|| ',' as kqpt,
                                ','||LISTAGG(rutkc1tinhtrang, ',') WITHIN GROUP (ORDER BY rutkc1tinhtrang)|| ',' as rutkc1tinhtrang,
                                ','||LISTAGG(rutkc2tinhtrang, ',') WITHIN GROUP (ORDER BY rutkc2tinhtrang)|| ',' as rutkc2tinhtrang,
                                ','||LISTAGG(rutkntinhtrang, ',') WITHIN GROUP (ORDER BY rutkntinhtrang)|| ',' as rutkntinhtrang,
                                ','||LISTAGG(NgayKhangCao1, ',') WITHIN GROUP (ORDER BY NgayKhangCao1)|| ',' as NgayKhangCao1,
                                ','||LISTAGG(NgayKhangCao2, ',') WITHIN GROUP (ORDER BY NgayKhangCao2)|| ',' as NgayKhangCao2,
                                ','||LISTAGG(NgayKhangNghi, ',') WITHIN GROUP (ORDER BY NgayKhangNghi)|| ',' as NgayKhangNghi,
                                ','||LISTAGG(IsQuaHan1, ',') WITHIN GROUP (ORDER BY IsQuaHan1)|| ',' as IsQuaHan1,
                                ','||LISTAGG(IsQuaHan2, ',') WITHIN GROUP (ORDER BY IsQuaHan2)|| ',' as IsQuaHan2,
                                ','||LISTAGG(GQ_ISCHAPNHAN1, ',') WITHIN GROUP (ORDER BY GQ_ISCHAPNHAN1)|| ',' as GQ_ISCHAPNHAN1,
                                ','||LISTAGG(GQ_ISCHAPNHAN2, ',') WITHIN GROUP (ORDER BY GQ_ISCHAPNHAN2)|| ',' as GQ_ISCHAPNHAN2,
                                ','||LISTAGG(QuyetDinhID, ',') WITHIN GROUP (ORDER BY QuyetDinhID)|| ',' as QuyetDinhID
                            from(
                                select bc.id as idkckn , kc1.id as KC1ID , kc2.id as KC2ID , kqpt.ketquaphucthamid as ketquaphuctham , kn.id as KNID, bapt.id as BAPT ,vuan.toaanid as toaanid
                                , rkcst1.tinhtrang as rutkc1tinhtrang , rkcst2.tinhtrang as rutkc2tinhtrang , rknst.tinhtrang as rutkntinhtrang
                                ,kc1.NgayKhangCao as NgayKhangCao1 ,kc2.NgayKhangCao as NgayKhangCao2 , kc1.IsQuaHan as IsQuaHan1 , kc2.IsQuaHan as IsQuaHan2
                                ,kc1.GQ_ISCHAPNHAN as GQ_ISCHAPNHAN1 , kc2.GQ_ISCHAPNHAN as GQ_ISCHAPNHAN2, kn.NgayKn as NgayKhangNghi
                                ,ptqd.quyetdinhid as QuyetDinhID
                                from ahs_bicanbicao bc
                                left join ahs_sotham_khangcao kc1 on kc1.nguoikcloai = 0 and kc1.nguoikcid = bc.id
                                left join ahs_sotham_khangcao kc2 on kc1.nguoikcloai = 1 and kc2.dsnguoibikc like '%'||bc.id||','||'%'
                                left join ahs_sotham_khangnghi kn on kn.dsnguoibikn like '%'||bc.id||','||'%'  
                                left join ahs_phuctham_banan_bicao bapt on bapt.bicaoid = bc.id
                                left join ahs_sotham_rutkhangcao rkcst1 on rkcst1.khangcaoid = kc1.id
                                left join ahs_sotham_rutkhangcao rkcst2 on rkcst2.khangcaoid = kc2.id
                                left join ahs_sotham_rutkhangnghi rknst on rknst.khangnghiid = kn.id
                                left join ahs_vuan vuan on vuan.id = bc.vuanid
                                left join ahs_phuctham_quyetdinh_vuan ptqd on ptqd.vuanid = bc.vuanid

                                left join (
                                    Select ptbc.bicaoid as bicaoid , ptba.ketquaphucthamid as ketquaphucthamid  from ahs_phuctham_banan_bicao ptbc
                                    left join ahs_phuctham_banan ptba on ptba.id = ptbc.bananid
                                )kqpt on kqpt.bicaoid = bc.id 

                                where vuan.toaanid = toa_an_id)GROUP BY idkckn 
                            )BCKCKN on ((kckn is null ) or (bapt is not null and bapt not like ('%,,%') and kckn is not null 
                            and  kqpt not like ('%,3,%') and kqpt not like ('%,4,%') and kqpt not like ('%,22,%')
                                and  kqpt not like ('%,46,%') and  kqpt not like ('%,47,%') 
                                and  kqpt not like '%,48,%' and  kqpt not like '%,49,%') 
                            or (QuyetDinhID not like ('%,,%') and kckn is not null and (QuyetDinhID like ('%,79,%')
                                or QuyetDinhID like ('%,80,%') or QuyetDinhID like ('%,127,%')
                                or QuyetDinhID like ('%,128,%') or QuyetDinhID like '%,203,%' or QuyetDinhID like ('%,205,%')
                                or QuyetDinhID like ('%,324,%')))
                            or ( kckn is not null and (rutkc1tinhtrang like ('%,2,%') or rutkc1tinhtrang like ('%,1,%')) ) 
                            or ( kckn is not null and (rutkc2tinhtrang like ('%,2,%') or rutkc2tinhtrang like ('%,1,%')) )
                            or ( kckn is not null and (rutkntinhtrang like ('%,2,%') or rutkntinhtrang like ('%,1,%')) )
                            or (( kckn is not null and IsQuaHan1 like ('%,1,%') and GQ_ISCHAPNHAN1 like ('%,1,%') ) 
                            or ( kckn is not null and IsQuaHan2 like ('%,1,%') and GQ_ISCHAPNHAN2 like ('%,1,%') )) 
                            )

                            and BCKCKN.idkckn = stbc.BiCaoID
                                  inner join (select ID , VuAnID, MaBiCan, HoTen from AHS_BiCanBiCao bc
                                where 1=(CASE WHEN ten_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.HOTEN) LIKE  ('%' || LOWER(ten_bi_an) || '%')) THEN 1 END)
                                            or (1=(CASE WHEN ma_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.MABICAN) LIKE  ('%' || LOWER(ma_bi_an) || '%')) THEN 1 END))) bc on bc.VuAnID= a.ID and stbc.BiCaoID = bc.ID
                                  left join (select  BanAnID, VuAnID, NgayKN from  AHS_SoTham_KhangNghi) kn on st.BanAnID = kn.BanAnID
                                  left join ahs_sotham_quyetdinh_bican qdbc on qdbc.bicanid = bc.id
                                  left join (select ID, VuAnID, NgayKhangCao, NguoiKCID,SoQDBA, GQ_ISCHAPNHAN, IsQuaHan
                                             from AHS_SoTham_KhangCao) kc on a.ID = kc.VuAnID 
                                                                          and kc.SoQDBA= st.BanAnID and kc.NguoiKCID = bc.ID
                            where  (qdbc.loaiqdid is null or ( qdbc.loaiqdid != 3 and qdbc.loaiqdid != 4))
                          )
                          union all
                          (
                              -------------lay ds cac bi can co thi hanh an phuc tham
                           select a.ID IDVuAnHeThong, a.MaVuAn, a.TenVuAn
                               , bcpt.BiCAoID BiAnID, bc.MaBiCan MaBiAn, bc.HoTen TenBiAn
                               , a.MaGiaiDoan
                               , DECODE(a.MaGiaiDoan, 1, 'Hồ sơ' , 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec
                               , pt.SoBanAn, pt.NgayBanAn, pt.NgayBanAn NgayHieuLuc
                               , THAVuAn.id VuAnID , a.ID as VuAn
                           from (select ID, MaVuAn, TenVuAn,  MaGiaiDoan from AHS_VuAn 
                                 where TOAPHUCTHAMID=toa_an_id And MAGIAIDOAN=3
                                      and 1=(CASE WHEN ma_vu_an='' THEN 1 
                                                  WHEN (LOWER(MaVuAn) LIKE  ('%' || LOWER(ma_vu_an) || '%')) THEN 1 END)                        
                                      and 1=(CASE WHEN ten_vu_an='' THEN 1 
                                                  WHEN (LOWER(TENVUAN) LIKE  ('%' || LOWER(ten_vu_an) || '%')) THEN 1 END)
                                ) a
                            inner join ( select ID BanAnPTID, VuAnId, NgayBanAn, NgayMoPhienToa , SoBanAn from AHS_PhucTHam_BanAn
                                        where 1=(CASE WHEN so_ban_an='' THEN 1 
                                                            WHEN (LOWER(SoBanAn) = so_ban_an) THEN 1 END)    
                                                     and (1=(CASE WHEN ngay_ban_an is NULL THEN 1 
                                                                  WHEN NgayBanAn = ngay_ban_an THEN 1 Else 0 END))
                                                     and NgayBanAn <= CURRENT_DATE-31
                                       ) pt on a.ID = pt.VuAnID
                            inner join (select BanAnID, BiCaoID from AHS_PhucTham_BanAn_BiCao) bcpt on bcpt.BanAnID = pt.BanAnPTID
                            left join THA_VUAN THAVuAn on a.ID = thavuan.idvuanhethong   
                            inner join (select ID , VuAnID, MaBiCan, HoTen from AHS_BiCanBiCao bc
                                where 1=(CASE WHEN ten_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.HOTEN) LIKE  ('%' || LOWER(ten_bi_an) || '%')) THEN 1 END)
                                            or (1=(CASE WHEN ma_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.MABICAN) LIKE  ('%' || LOWER(ma_bi_an) || '%')) THEN 1 END)) ) bc on bcpt.BiCaoID = bc.ID and a.ID = bc.VuAnID
                          ) 
            ) a ;
   --------------------------------   
   OPEN curReturn FOR 
        select  a.* , TotalItem as CountAll 
        from (
                select ROW_NUMBER() OVER (ORDER BY a.NgayHieuLuc desc) stt, a.* 
                from (
                          (
                            ------lay ds vu an , bi can theo an so tham
                            SELECT DISTINCT  a.ID IDVuAnHeThong, a.MaVuAn, a.TenVuAn                     
                                 , bc.ID BiAnID, bc.MaBiCan MaBiAn, bc.HoTen TenBiAn  
                                 , a.MaGiaiDoan
                                 , DECODE(a.MaGiaiDoan, 1, 'Hồ sơ' , 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec
                                 , st.SoBanAn, st.NgayBanAn, st.NgayHieuLucST NgayHieuLuc
                                 , THAVuAn.id VuAnID
                            from (select ID, MaVuAn, TenVuAn, ToaPhucThamID, MaGiaiDoan from AHS_VuAn 
                                  where ( MaGiaiDoan ='2' or MaGiaiDoan ='3') and ToaAnID= toa_an_id
                                       and 1=(CASE WHEN ma_vu_an='' THEN 1 
                                                   WHEN (LOWER(MaVuAn) LIKE  ('%' || LOWER(ma_vu_an) || '%')) THEN 1 END)                        
                                       and 1=(CASE WHEN ten_vu_an='' THEN 1 
                                                   WHEN (LOWER(TENVUAN) LIKE  ('%' || LOWER(ten_vu_an) || '%')) THEN 1 END)
                                  ) a
                                  inner join ( select a.ID BanAnID, a.VuAnID, a.NgayBanAn, (a.NgayBanAn+14) NgayHieuLucST, a.SoBanAn
                                               from AHS_SoTham_BanAn a
                                               left join AHS_PHUCTHAM_BANAN ptba on ptba.vuanid = a.VuAnID
                                               left join ahs_phuctham_quyetdinh_vuan ptqd on ptqd.vuanid = a.vuanid
                                               where 1=(CASE WHEN so_ban_an='' THEN 1 
                                                            WHEN (LOWER(a.SoBanAn) = so_ban_an) THEN 1 END)    
                                                     and (1=(CASE WHEN ngay_ban_an is NULL THEN 1 
                                                                  WHEN a.NgayBanAn = ngay_ban_an THEN 1 Else 0 END))
                                                     and (a.NgayBanAn <= CURRENT_DATE-31 or ptba.id is not null or ptqd.quyetdinhid = 79
                                                     or ptqd.quyetdinhid = 80 or ptqd.quyetdinhid = 127 or ptqd.quyetdinhid = 128
                                                     or ptqd.quyetdinhid = 203 or ptqd.quyetdinhid = 205 or ptqd.quyetdinhid = 324)
                                               ) st on st.VuAnID = a.ID
                                  left join THA_VUAN THAVuAn on a.ID = thavuan.idvuanhethong            
                                  inner join (select BanAnID, BiCaoID from AHS_SOTHAM_BANAN_BICAO)stbc on stbc.BanAnID= st.BanAnID
                                  inner join (
                                select idkckn,
                                CONCAT(CONCAT(LISTAGG(KC1ID, ',') WITHIN GROUP (ORDER BY KC1ID), LISTAGG(KC2ID, ',') WITHIN GROUP (ORDER BY KC2ID)),LISTAGG(KNID, ',') WITHIN GROUP (ORDER BY KNID)) as KCKN,
                                ','||LISTAGG(BAPT, ',') WITHIN GROUP (ORDER BY BAPT)|| ',' as bapt,
                                ','||LISTAGG(ketquaphuctham, ',') WITHIN GROUP (ORDER BY BAPT)|| ',' as kqpt,
                                ','||LISTAGG(rutkc1tinhtrang, ',') WITHIN GROUP (ORDER BY rutkc1tinhtrang)|| ',' as rutkc1tinhtrang,
                                ','||LISTAGG(rutkc2tinhtrang, ',') WITHIN GROUP (ORDER BY rutkc2tinhtrang)|| ',' as rutkc2tinhtrang,
                                ','||LISTAGG(rutkntinhtrang, ',') WITHIN GROUP (ORDER BY rutkntinhtrang)|| ',' as rutkntinhtrang,
                                ','||LISTAGG(NgayKhangCao1, ',') WITHIN GROUP (ORDER BY NgayKhangCao1)|| ',' as NgayKhangCao1,
                                ','||LISTAGG(NgayKhangCao2, ',') WITHIN GROUP (ORDER BY NgayKhangCao2)|| ',' as NgayKhangCao2,
                                ','||LISTAGG(NgayKhangNghi, ',') WITHIN GROUP (ORDER BY NgayKhangNghi)|| ',' as NgayKhangNghi,
                                ','||LISTAGG(IsQuaHan1, ',') WITHIN GROUP (ORDER BY IsQuaHan1)|| ',' as IsQuaHan1,
                                ','||LISTAGG(IsQuaHan2, ',') WITHIN GROUP (ORDER BY IsQuaHan2)|| ',' as IsQuaHan2,
                                ','||LISTAGG(GQ_ISCHAPNHAN1, ',') WITHIN GROUP (ORDER BY GQ_ISCHAPNHAN1)|| ',' as GQ_ISCHAPNHAN1,
                                ','||LISTAGG(GQ_ISCHAPNHAN2, ',') WITHIN GROUP (ORDER BY GQ_ISCHAPNHAN2)|| ',' as GQ_ISCHAPNHAN2,
                                ','||LISTAGG(QuyetDinhID, ',') WITHIN GROUP (ORDER BY QuyetDinhID)|| ',' as QuyetDinhID
                            from(
                                select bc.id as idkckn , kc1.id as KC1ID , kc2.id as KC2ID , kqpt.ketquaphucthamid as ketquaphuctham , kn.id as KNID, bapt.id as BAPT ,vuan.toaanid as toaanid
                                , rkcst1.tinhtrang as rutkc1tinhtrang , rkcst2.tinhtrang as rutkc2tinhtrang , rknst.tinhtrang as rutkntinhtrang
                                ,kc1.NgayKhangCao as NgayKhangCao1 ,kc2.NgayKhangCao as NgayKhangCao2 , kc1.IsQuaHan as IsQuaHan1 , kc2.IsQuaHan as IsQuaHan2
                                ,kc1.GQ_ISCHAPNHAN as GQ_ISCHAPNHAN1 , kc2.GQ_ISCHAPNHAN as GQ_ISCHAPNHAN2, kn.NgayKn as NgayKhangNghi
                                ,ptqd.quyetdinhid as QuyetDinhID
                                from ahs_bicanbicao bc
                                left join ahs_sotham_khangcao kc1 on kc1.nguoikcloai = 0 and kc1.nguoikcid = bc.id
                                left join ahs_sotham_khangcao kc2 on kc1.nguoikcloai = 1 and kc2.dsnguoibikc like '%'||bc.id||','||'%'
                                left join ahs_sotham_khangnghi kn on kn.dsnguoibikn like '%'||bc.id||','||'%'  
                                left join ahs_phuctham_banan_bicao bapt on bapt.bicaoid = bc.id
                                left join ahs_sotham_rutkhangcao rkcst1 on rkcst1.khangcaoid = kc1.id
                                left join ahs_sotham_rutkhangcao rkcst2 on rkcst2.khangcaoid = kc2.id
                                left join ahs_sotham_rutkhangnghi rknst on rknst.khangnghiid = kn.id
                                left join ahs_vuan vuan on vuan.id = bc.vuanid
                                left join ahs_phuctham_quyetdinh_vuan ptqd on ptqd.vuanid = bc.vuanid
                                left join (
                                    Select ptbc.bicaoid as bicaoid , ptba.ketquaphucthamid as ketquaphucthamid  from ahs_phuctham_banan_bicao ptbc
                                    left join ahs_phuctham_banan ptba on ptba.id = ptbc.bananid
                                )kqpt on kqpt.bicaoid = bc.id 

                                where vuan.toaanid = toa_an_id)GROUP BY idkckn 
                            )BCKCKN on ((kckn is null ) or (bapt is not null and bapt not like ('%,,%') and kckn is not null 
                            and  kqpt not like ('%,3,%') and kqpt not like ('%,4,%') and kqpt not like ('%,22,%')
                                and  kqpt not like ('%,46,%') and  kqpt not like ('%,47,%') 
                                and  kqpt not like '%,48,%' and  kqpt not like '%,49,%') 
                            or (QuyetDinhID not like ('%,,%') and kckn is not null and (QuyetDinhID like ('%,79,%')
                                or QuyetDinhID like ('%,80,%') or QuyetDinhID like ('%,127,%')
                                or QuyetDinhID like ('%,128,%') or QuyetDinhID like '%,203,%' or QuyetDinhID like ('%,205,%')
                                or QuyetDinhID like ('%,324,%')))
                            or ( kckn is not null and (rutkc1tinhtrang like ('%,2,%') or rutkc1tinhtrang like ('%,1,%')) ) 
                            or ( kckn is not null and (rutkc2tinhtrang like ('%,2,%') or rutkc2tinhtrang like ('%,1,%')) )
                            or ( kckn is not null and (rutkntinhtrang like ('%,2,%') or rutkntinhtrang like ('%,1,%')) )
                            or (( kckn is not null and IsQuaHan1 like ('%,1,%') and GQ_ISCHAPNHAN1 like ('%,1,%') ) 
                            or ( kckn is not null and IsQuaHan2 like ('%,1,%') and GQ_ISCHAPNHAN2 like ('%,1,%') )) 
                            )

                            and BCKCKN.idkckn = stbc.BiCaoID
                                  inner join (select ID , VuAnID, MaBiCan, HoTen from AHS_BiCanBiCao bc
                                where 1=(CASE WHEN ten_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.HOTEN) LIKE  ('%' || LOWER(ten_bi_an) || '%')) THEN 1 END)
                                            or (1=(CASE WHEN ma_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.MABICAN) LIKE  ('%' || LOWER(ma_bi_an) || '%')) THEN 1 END))) bc on bc.VuAnID= a.ID and stbc.BiCaoID = bc.ID
                                  left join (select  BanAnID, VuAnID, NgayKN from  AHS_SoTham_KhangNghi) kn on st.BanAnID = kn.BanAnID
                                  left join ahs_sotham_quyetdinh_bican qdbc on qdbc.bicanid = bc.id
                                  left join (select ID, VuAnID, NgayKhangCao, NguoiKCID,SoQDBA, GQ_ISCHAPNHAN, IsQuaHan
                                             from AHS_SoTham_KhangCao) kc on a.ID = kc.VuAnID 
                                                                          and kc.SoQDBA= st.BanAnID and kc.NguoiKCID = bc.ID
                            where  (qdbc.loaiqdid is null or ( qdbc.loaiqdid != 3 and qdbc.loaiqdid != 4))
                          )
                          union all
                          (
                              -------------lay ds cac bi can co thi hanh an phuc tham
                           select a.ID IDVuAnHeThong, a.MaVuAn, a.TenVuAn
                               , bcpt.BiCAoID BiAnID, bc.MaBiCan MaBiAn, bc.HoTen TenBiAn
                               , a.MaGiaiDoan
                               , DECODE(a.MaGiaiDoan, 1, 'Hồ sơ' , 2, 'Sơ thẩm', 3, 'Phúc thẩm', 4, 'Thụ lý Giám đốc thẩm' ,'')  GiaiDoanVuViec
                               , pt.SoBanAn, pt.NgayBanAn, pt.NgayBanAn NgayHieuLuc
                               , THAVuAn.id VuAnID
                           from (select ID, MaVuAn, TenVuAn,  MaGiaiDoan from AHS_VuAn 
                                 where TOAPHUCTHAMID=toa_an_id And MAGIAIDOAN=3
                                      and 1=(CASE WHEN ma_vu_an='' THEN 1 
                                                  WHEN (LOWER(MaVuAn) LIKE  ('%' || LOWER(ma_vu_an) || '%')) THEN 1 END)                        
                                      and 1=(CASE WHEN ten_vu_an='' THEN 1 
                                                  WHEN (LOWER(TENVUAN) LIKE  ('%' || LOWER(ten_vu_an) || '%')) THEN 1 END)
                                ) a
                            inner join ( select ID BanAnPTID, VuAnId, NgayBanAn, NgayMoPhienToa , SoBanAn from AHS_PhucTHam_BanAn
                                        where 1=(CASE WHEN so_ban_an='' THEN 1 
                                                            WHEN (LOWER(SoBanAn) = so_ban_an) THEN 1 END)    
                                                     and (1=(CASE WHEN ngay_ban_an is NULL THEN 1 
                                                                  WHEN NgayBanAn = ngay_ban_an THEN 1 Else 0 END))
                                                     and NgayBanAn <= CURRENT_DATE-31
                                       ) pt on a.ID = pt.VuAnID
                            inner join (select BanAnID, BiCaoID from AHS_PhucTham_BanAn_BiCao) bcpt on bcpt.BanAnID = pt.BanAnPTID
                            left join THA_VUAN THAVuAn on a.ID = thavuan.idvuanhethong   
                            inner join (select ID , VuAnID, MaBiCan, HoTen from AHS_BiCanBiCao bc
                                where 1=(CASE WHEN ten_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.HOTEN) LIKE  ('%' || LOWER(ten_bi_an) || '%')) THEN 1 END)
                                            or (1=(CASE WHEN ma_bi_an='' THEN 1 
                                                      WHEN (LOWER(bc.MABICAN) LIKE  ('%' || LOWER(ma_bi_an) || '%')) THEN 1 END)) ) bc on bcpt.BiCaoID = bc.ID and a.ID = bc.VuAnID
                          ) 
                ) a
            ) a WHERE a.stt>=MinIndex  AND a.stt<=MaxIndex;
END GetBiAnTrongTHA;

PROCEDURE GetBiAnNgoaiTHA 
(
    toa_an_id in number
   ,  ma_bi_an in nvarchar2, ten_bi_an in nvarchar2
   , ma_vu_an in nvarchar2, ten_vu_an in nvarchar2
   , so_ban_an in varchar2, ngay_ban_an in date
	 , PageIndex	in	number
	 , PageSize	in	number
	 , curReturn    OUT   sys_refcursor
)
AS
    TotalItem number;
  MinIndex	number;
  MaxIndex	number;
 -- TrangThai_v  number;
BEGIN	
    MinIndex := PageSize*(PageIndex - 1) + 1;
    MaxIndex := PageIndex*PageSize ;   

   select count (a.ID) into TotalItem
   from (select ID, BA_MaVuAn, BA_TEnVuAn, BA_ST_So, BA_ST_NGayBanAn, BA_ST_NGayHieuLuc
                      from THA_VuAn where IsHeThong=0 and ToaAnID= toa_an_id
                            and (ma_vu_an = '' OR ma_vu_an is null OR (LOWER(BA_MaVuAn) LIKE  ('%' || LOWER(ma_vu_an) || '%')) ) 
                            and (ten_vu_an='' OR ten_vu_an is null OR (LOWER(BA_TENVUAN) LIKE  ('%' || LOWER(ten_vu_an) || '%')) )
                      ) a
        inner join (select Id, VuAnID , b.HoTen, b.MABICAN from THA_BiAn b
                     where 
                            (ma_bi_an='' Or  ma_bi_an is null OR (LOWER(b.MABICAN) LIKE  ('%' || LOWER(ma_bi_an) || '%')) )                        
                            and ( ten_bi_an='' OR ten_bi_an is null OR (LOWER(b.HOTEN) LIKE  ('%' || LOWER(ten_bi_an) || '%')) )
                    ) b on a.ID = b.VuAnID
                    where (so_ban_an='' Or so_ban_an is null Or
                               (LOWER(a.BA_ST_So) = so_ban_an) )    
                  and (ngay_ban_an is NULL Or
                                a.BA_ST_NGayBanAn = ngay_ban_an) ;
   ---------------------------------------------
    OPEN curReturn FOR 
        select a.* , TotalItem as CountAll 
        from ( select ROW_NUMBER() OVER (ORDER BY a.BA_ST_NGayHieuLuc desc) stt
                  , a.ID VuAnID,a.IDVuAnHeThong,  a.BA_MaVuAn MaVuAn, a.BA_TEnVuAn TenVuAn, a.BA_NGayVuAn NgayVuAn
                  , b.ID BiAnId, b.MaBiCan MaBiAn, b.HoTen TenBiAn
                  , '0' MaGiaiDoan, '' GiaiDoanVuViec
                  , a.BA_ST_So SoBanAn, a.BA_ST_NGayBanAn NgayBanAn, a.BA_ST_NGayHieuLuc NgayHieuLuc
                from (select ID, BA_MaVuAn, BA_TEnVuAn, BA_ST_So, BA_ST_NGayBanAn, BA_ST_NGayHieuLuc, BA_NGayVuAn,IDVuAnHeThong
                      from THA_VuAn where IsHeThong=0  and ToaAnID= toa_an_id
                        and (ma_vu_an = '' OR ma_vu_an is null OR (LOWER(BA_MaVuAn) LIKE  ('%' || LOWER(ma_vu_an) || '%')) ) 
                        and (ten_vu_an='' OR ten_vu_an is null OR (LOWER(BA_TENVUAN) LIKE  ('%' || LOWER(ten_vu_an) || '%')) )
                      ) a 
                  inner join (select Id, MaBiCan, b.HoTen, VuAnID from THA_BiAn b
                              where 
                                    (ma_bi_an='' Or  ma_bi_an is null OR (LOWER(b.MABICAN) LIKE  ('%' || LOWER(ma_bi_an) || '%')) )                        
                                    and ( ten_bi_an='' OR ten_bi_an is null OR (LOWER(b.HOTEN) LIKE  ('%' || LOWER(ten_bi_an) || '%')) )
                              ) b on a.ID = b.VuAnID
                where (so_ban_an='' Or so_ban_an is null Or
                               (LOWER(a.BA_ST_So) = so_ban_an) )    
                  and (ngay_ban_an is NULL Or
                                a.BA_ST_NGayBanAn = ngay_ban_an)
             ) a WHERE a.stt>=MinIndex  AND a.stt<=MaxIndex;                       

end GetBiAnNgoaiTHA;

END PKG_THA;
