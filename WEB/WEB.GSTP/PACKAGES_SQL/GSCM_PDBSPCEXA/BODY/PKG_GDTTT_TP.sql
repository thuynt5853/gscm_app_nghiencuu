--------------------------------------------------------
--  File created - Thursday-March-21-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_TP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_TP" AS
PROCEDURE DANHSACHDONTHEOID
( 
  varrID in varchar2,
  curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV
      ,d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,BAQD_NGAYBA,
      DM_CanBo_TenToaVT((Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END)) TOAXX
     ,DECODE(d.Toaanid,1,'',(SELECT ld.LOAIDON_TEN FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=d.Toaanid and ld.LOAIDON_ID = D.LOAIDON)) HINHTHUCDON
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
     ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250))           
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))
          end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'               
          when 1 then  'Đã chuyển'
          when 2 then  'Đã nhận'
          when 3 then  'Bị trả lại'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG      
      ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) else '' End) arrCongvan
       ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
      ,d.CV_TENDONVI,d.CV_SO,d.CV_NGAY,d.CHIDAO_NOIDUNG,ld.HOTEN TENLANHDAO
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
       left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
       left join DM_CANBO c on d.THAMPHANID=c.ID
       left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
       left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
       left join DM_CANBO ld on d.CHIDAO_LANHDAOID=ld.ID
      where DECODE(d.ARR_DON_ID,0,d.ID,d.ARR_DON_ID)=varrID--varrID like ('%,' || cast(d.ID as varchar2(10)) || ',%')
    Order by d.Ngaytao desc;    
END DANHSACHDONTHEOID;
PROCEDURE DANHSACHDONTRUNG
( 
  vID in number,
	curReturn OUT sys_refcursor
)
IS 
BEGIN
  OPEN curReturn FOR
   Select d.ID,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.NGAYNHANDON,SOLUONGDON SODON,d.BAQD_LOAIQDBA,d.BAQD_SO,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,d.CD_SOCV,d.CD_NGAYCV
      ,d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN Diachigui,d.CV_SO,d.NGAYGHITRENDON
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.BAQD_SO) Else ('BA: ' || d.BAQD_SO) END) BAQD
      ,BAQD_NGAYBA,
      DM_CanBo_TenToaVT((Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END)) TOAXX
      ,DECODE(d.Toaanid,1,'',(SELECT ld.LOAIDON_TEN FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=d.Toaanid and ld.LOAIDON_ID = D.LOAIDON)) HINHTHUCDON
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
     ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250))           
          when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))
          end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'               
          when 1 then  'Đã chuyển'
          when 2 then  'Đã nhận'
          when 3 then  'Bị trả lại'
         else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,d.CD_SOTOTRINH,d.CD_NGAYTOTRINH,d.CV_TRALOI_NOIDUNG
      ,( Case d.LOAIDON when 3 then (TO_CHAR(d.CV_TENDONVI) || ' chuyển đến theo CV/PC số ' || d.CV_SO || ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')) else '' End) arrCongvan
       ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block' when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
    from GDTTT_DON d
      left join DM_HANHCHINH h on d.NGUOIGUI_HUYENID=h.ID
       left join DM_TOAAN tk on d.CD_TK_DONVIID=tk.ID
       left join DM_TOAAN txx on d.BAQD_TOAANID=txx.ID
        left join DM_PHONGBAN pb on d.CD_TA_DONVIID=pb.ID
        left join DM_CANBO c on d.THAMPHANID=c.ID
        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=d.NGUOITAO
        left join DM_DATAITEM i on d.NGUOIKHANGNGHI=i.ID
    where  (d.ID = vID and (Select COunt(x.ID) from GDTTT_DON x where x.ARR_DON_ID=vID)>0)Or (d.ARR_DON_ID=vID Or  d.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID and ARR_DON_ID>0)
    Or  d.ID in (Select ARR_DON_ID from GDTTT_DON where ID=vID  and ARR_DON_ID>0))
    Order by d.Ngaytao desc;    
END DANHSACHDONTRUNG;
END PKG_GDTTT_TP;

/
