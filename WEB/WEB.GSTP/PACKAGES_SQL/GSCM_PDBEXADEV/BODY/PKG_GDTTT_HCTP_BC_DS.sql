--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_BC_DS
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_BC_DS" AS
PROCEDURE DS_CHUYEN_NGOAI_TOA 
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
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
)
IS 
  V_TABLE T_DT_NTA_PHIEUCHUYEN;
  V_TENPHONGBANGUI varchar2(500);V_TENDONVI varchar2(500);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(500);V_CD_NGUOIKY varchar2(250);V_CD_NGAYCV varchar2(250);V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTOTRINH varchar2(500);V_CD_NGAYTOTRINH varchar2(250);V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
  V_NGUOIGUI clob;V_TL_SO_TEMP varchar2(500); V_TENTHAMPHAN varchar2(500);
  V_TT NUMBER;V_SODON_TONG NUMBER;V_TENPHONGBANNHAN VARCHAR2(500);V_COUNT NUMBER;V_GHICHU clob;
  V_QD_NGUOIKN varchar2(500):=NULL;
  V_COUNT_PB NUMBER;V_DEM_ROW NUMBER:=0;V_COUNT_DEM_ROW NUMBER:=0;V_DEM_TEXT clob;
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_DEM_TEXT,true);
 v_table := T_DT_NTA_PHIEUCHUYEN();
 -------
 IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
 END IF;
 --------
  FOR item IN (
          Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID
  ,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON
   , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  

  ,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,     
      d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn'
                     when 2 then 'Công văn' 
                     when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
       ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                            when 1 then  'Đã chuyển'
                            when 2 then  'Đã nhận' 
                            when 3 then  'Bị trả lại' 
                            else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH

       ,(SoCVC.SOVB || SoCVCN.SOVB) as CD_SOCV
       ,Decode(SoCVC.NGAYVB,null,SoCVCN.NGAYVB,SoCVC.NGAYVB) as CD_NGAYCV
       ,(SoCVC.NGUOIKY || SoCVCN.NGUOIKY)as CD_NGUOIKY
      ,Decode(SOTT.SOVB,null,SOTT_TLL.SOVB,SOTT.SOVB) as CD_SOTOTRINH
      ,Decode(SOTT.NGAYVB,null,SOTT_TLL.NGAYVB,SOTT.NGAYVB) as CD_NGAYTOTRINH
      ,Decode(SOTT.SOVB,null,SOTT_TLL.SOVB,SOTT.SOVB) ||' - '||TO_CHAR(Decode(SOTT.NGAYVB,null,SOTT_TLL.NGAYVB,SOTT.NGAYVB),'dd/MM/yyyy')  as TOTRINH_SONGAY

      ,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 
      (Case vIsDonGoc when 0 then 1 else
      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         + (Case when d.DONTRUNGID>0 then 
            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
         ) End)
              Else 
              (Case vIsDonGoc when 0 then 1 else
              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
              End)
              End)SODON
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block'
      when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL
        ,decode(d.LOAIDON,1,'',(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',  ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')))) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
     ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

           , d.PHANLOAIXULY
           , NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
           , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,4)=3 then ''
                            when NVL(va.GQD_LOAIKETQUA,4)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
               ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,d.NGAYTAO,d.NOIDUNGDON 
            from GDTTT_DON d
                 --Thong tin So Cong Van chuyen Ngoai Toa   
               LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id 
              LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id
              LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SOTT on SOTT.donid = d.id
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SOTT_TLL on SOTT_TLL.donid = d.id

              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                  And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD
                                                        Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                        Or d.BAQD_TOAANID_ST=vToaRaBAQD then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
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

                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
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

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
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
                and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
                Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
                and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                    when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                    when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                    when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                    and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                    and 1=case when vLoaiCVID=0 then 1 
                    when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                    when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                    And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                    when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
        )
        LOOP
           V_NGUOIGUI:=item.DONGKHIEUNAI;
            IF(item.ARRCONGVAN IS NOT NULL)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||REPLACE(item.ARRCONGVAN,'; )','')||')';
            ELSIF(item.LOAIDON=2)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Công văn số '||item.CV_SO||' ngày '||to_char(item.CV_NGAY,'dd/MM/yyyy')||')';
            END IF;
            v_table.extend;
                v_table(v_table.count) := R_DT_NTA_PHIEUCHUYEN(
                 NULL,NULL,item.NOICHUYEN,NULL,NULL,
                 NULL,NULL,NULL,NULL,V_NGUOIGUI,
                 NULL,item.Diachigui,NULL,item.GHICHU,NULL,
                 NULL,NULL,NULL,item.NOIDUNGDON,NULL,
                 NULL,NULL,NULL,NULL,NULL,
                 NULL,NULL,item.SODON,item.CD_SOCV,to_char(item.CD_NGAYCV,'dd/MM/yyyy'),
                 NULL
                );
        END LOOP;
     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:=' Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy');
      elsif(vNgayNhapTu is null)then    
        vvNgayNhapTu:='';
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy');
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:='';
      end if;
    ----
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
    ----
    SELECT COUNT(*) INTO V_COUNT_PB FROM (SELECT PA.TENDONVINHAN FROM TABLE(V_TABLE)PA GROUP BY PA.TENDONVINHAN)PS;
    ----
   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
   <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
   ');
    FOR item_s IN (
                 SELECT PA.TENDONVINHAN FROM (SELECT PS.TENDONVINHAN FROM TABLE(V_TABLE)PS ORDER BY PS.NGAYTAO DESC)PA
                 GROUP BY PA.TENDONVINHAN
    )
     LOOP
    SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.TENDONVINHAN=item_s.TENDONVINHAN AND PA.CD_SOCV IS NOT NULL ;    
    -------
    IF(V_COUNT>0)THEN
       SELECT 
--                 DECODE(V_BC_SoCV,NULL,PA.CD_SOCV,V_BC_SoCV)CD_SOCV
--                ,DECODE(V_BC_NGAYDK,NULL,PA.CD_NGAYCV,V_BC_NGAYDK)CD_NGAYCV
--                ,DECODE(V_BC_Nguoiky,NULL,PA.NGUOIKY,V_BC_Nguoiky)NGUOIKY
                PA.CD_SOCV CD_SOCV
                ,PA.CD_NGAYCV CD_NGAYCV
                ,PA.NGUOIKY NGUOIKY
            INTO  V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY
            FROM TABLE(V_TABLE)PA WHERE PA.TENDONVINHAN=item_s.TENDONVINHAN AND PA.CD_SOCV IS NOT NULL  ORDER BY PA.NGAYTAO DESC
            FETCH FIRST 1 ROWS ONLY;
        END IF;
     -----  
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="6" style="text-align: center; vertical-align: middle; font-size: 14pt;">DANH SÁCH
                        <br />
                        Đơn chuyển '||item_s.TENDONVINHAN||'
                        <br />
                        <span style="font-size: 14pt; font-weight: normal; font-style: italic;">Kèm theo Công văn số '||V_CD_SOCV||' ngày '||V_CD_NGAYCV||' của Tòa án nhân dân tối cao</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;height: 48px;">TT</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Họ tên người gửi</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa phương</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Nội dung</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số lượng</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                </tr>
               ');
               V_TT:=0;
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA WHERE PA.TENDONVINHAN=item_s.TENDONVINHAN
                         ORDER BY PA.NGAYTAO DESC
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 V_DEM_ROW:=V_DEM_ROW+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.NGUOIGUI||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.DIACHIGUI||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.NOIDUNG||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.SODON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.GHICHU||'</td>
                </tr>
                ');   
                 END LOOP;
                 ---tính những dòng ngắt trang khi kết suất ra excel
                 V_DEM_ROW:=V_DEM_ROW+7;--là 5 dòng head và 2 footer cho mỗi một đơn vị
                 V_COUNT_DEM_ROW:=V_COUNT_DEM_ROW+1;
                 IF(V_COUNT_DEM_ROW<V_COUNT_PB) THEN
                     DBMS_LOB.APPEND(V_DEM_TEXT,V_DEM_ROW||',');
                 END IF;
                --------------------------------------------------
                SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA WHERE PA.TENDONVINHAN=item_s.TENDONVINHAN;
                ----
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr>
                    <td colspan="6" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top; text-align: center;">Tổng số:<span style="font-weight: bold;"> '||V_SODON_TONG||'</span></td>
                    <td colspan="4"></td>
                </tr>
           ');
           END LOOP;

       DBMS_LOB.APPEND(V_EXPORT_TEXT,'          
                <tr style="height: 0px;">
                    <td style="width: 30px"></td>
                    <td style="width: 190px"></td>
                    <td style="width: 153px"></td>
                    <td style="width: 315px"></td>
                    <td style="width: 49px"></td>
                    <td style="width: 221px"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT,RTRIM(V_DEM_TEXT,',') INSERT_PAGE_BREAK FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);dbms_lob.freetemporary(V_DEM_TEXT);
END DS_CHUYEN_NGOAI_TOA;
PROCEDURE DS_CHUYEN_TOA_AN_KHAC
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
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
)
IS 
  V_TENPHONGBANGUI varchar2(500);V_TENDONVI varchar2(500);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number; V_TABLE T_DT_NOIBO_DANHSACH;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(500);V_CD_NGUOIKY varchar2(250);V_CD_NGAYCV varchar2(250);V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTOTRINH varchar2(500);V_CD_NGAYTOTRINH varchar2(250);V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
  V_NGUOIGUI clob;V_TL_SO_TEMP varchar2(500); V_TENTHAMPHAN varchar2(500);
  V_TT NUMBER;V_SODON_TONG NUMBER;V_TENPHONGBANNHAN VARCHAR2(500);V_COUNT NUMBER;V_GHICHU clob;
  V_QD_NGUOIKN varchar2(500):=NULL;
  V_COUNT_PB NUMBER;V_DEM_ROW NUMBER:=0;V_COUNT_DEM_ROW NUMBER:=0;V_DEM_TEXT clob;
  V_SOBA varchar2(500);V_NGAYBA varchar2(500);V_SOQD varchar2(500);V_NGAYQD varchar2(500);V_TOAXX varchar2(2000);
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_DEM_TEXT,true);
 v_table := T_DT_NOIBO_DANHSACH();
 -------
 IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
 END IF;
  FOR item IN (
          Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID
  ,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON
   , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  

  ,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,
      d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn'
                     when 2 then 'Công văn' 
                     when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
       ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                            when 1 then  'Đã chuyển'
                            when 2 then  'Đã nhận' 
                            when 3 then  'Bị trả lại' 
                            else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH
        ,(SoCVC.SOVB || SoCVCN.SOVB ||SoCVCTK.SOVB) as CD_SOCV
        ,(SoCVC.NGAYVB ||SoCVCN.NGAYVB || SoCVCTK.NGAYVB)  as CD_NGAYCV
                    
       ,(SoCVC.NGUOIKY || SoCVCN.NGUOIKY||SoCVCTK.NGUOIKY)as CD_NGUOIKY
       ,Decode(SOTT.SOVB,null,SOTT_TLL.SOVB,SOTT.SOVB) as CD_SOTOTRINH
       ,Decode(SOTT.NGAYVB,null,SOTT_TLL.NGAYVB,SOTT.NGAYVB) as CD_NGAYTOTRINH
       ,Decode(SOTT.SOVB,null,SOTT_TLL.SOVB,SOTT.SOVB) ||' - '||TO_CHAR(Decode(SOTT.NGAYVB,null,SOTT_TLL.NGAYVB,SOTT.NGAYVB),'dd/MM/yyyy')  as TOTRINH_SONGAY
      ,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 
      (Case vIsDonGoc when 0 then 1 else
      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         + (Case when d.DONTRUNGID>0 then 
            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
         ) End)
              Else 
              (Case vIsDonGoc when 0 then 1 else
              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
              End)
              End)SODON
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block'
      when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

        ,decode(d.LOAIDON,1,'',(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',  ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')))) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
     ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

           , d.PHANLOAIXULY
           , NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
           , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,4)=3 then ''
                            when NVL(va.GQD_LOAIKETQUA,4)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
               ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,d.NGAYTAO 
            from GDTTT_DON d
                --Thong tin So Cong Van chuyen Tao khac
               LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id 
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id 
               LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id 
             
              LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SOTT on SOTT.donid = d.id
                LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so 
                            left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SOTT_TLL on SOTT_TLL.donid = d.id

              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                  And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                And 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD 
                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD
                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD 
                                                    then 1 else 0 end  
               -- and 1=case when vLoaiAn=0 then 1 when dtk.BAQD_LOAIAN=vLoaiAn then 1 else 0 end  
               --anhvh 12/02/2020
               AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
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
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
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

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
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
                and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
                Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
                and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                    when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                    when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                    when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                    and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                    and 1=case when vLoaiCVID=0 then 1 
                    when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                    when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                    And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                    when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
        )
        LOOP
           V_NGUOIGUI:=item.DONGKHIEUNAI;
            IF(item.ARRCONGVAN IS NOT NULL)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||REPLACE(item.ARRCONGVAN,'; )','')||')';
            ELSIF(item.LOAIDON=2)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Công văn số '||item.CV_SO||' ngày '||to_char(item.CV_NGAY,'dd/MM/yyyy')||')';
            END IF;
             IF(LENGTH(item.TL_SO)=1)THEN
                 V_TL_SO_TEMP:='0'||item.TL_SO;
                 ELSIF(LENGTH(item.TL_SO)>1)THEN
                 V_TL_SO_TEMP:=item.TL_SO;
                END IF;
            ----
            SELECT decode(item.TENTHAMPHAN,NULL,NULL,'Thẩm phán '||item.TENTHAMPHAN) INTO V_TENTHAMPHAN FROM DUAL;
--            Manhnd bỏ do Mai bé yêu cầu không hiển thị dòng "đơn không có nội dung GDT,TT"
--            IF(item.ISNOTGDTTT=1) THEN
--              V_GHICHU:=item.GHICHU||' - (đơn không có nội dung GDT,TT)';
--            ELSE
--              V_GHICHU:=item.GHICHU; 
--            END IF;
            V_GHICHU:=item.GHICHU; 
            IF(item.BAQD_LOAIQDBA!='0')THEN--QD
                V_QD_NGUOIKN:=item.TOAXX;
                V_SOBA:=NULL;V_NGAYBA:=NULL;
                V_SOQD:=item.BAQD_SO;V_NGAYQD:=TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy');
                 V_TOAXX:=NULL;
            else -----------------------------BA
                V_QD_NGUOIKN:=NULL;
                V_SOBA:=item.BAQD_SO;V_NGAYBA:=TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy');
                V_SOQD:=NULL;V_NGAYQD:=NULL;V_TOAXX:=item.TOAXX;
            END IF;
            ----
            v_table.extend;
                v_table(v_table.count) := R_DT_NOIBO_DANHSACH(
                item.STT,V_NGUOIGUI,item.DIACHIGUI,V_SOBA,V_NGAYBA,
                V_TOAXX,V_SOQD,V_NGAYQD,V_QD_NGUOIKN,item.SODON,
                V_GHICHU,NULL,item.NOICHUYEN,item.CD_SOTOTRINH,NULL,
                NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,to_char(item.TL_NGAY,'dd/MM/yyyy'),
                to_char(item.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,item.CD_NGUOIKY,NULL,
                item.BAQD_LOAIAN,TO_CHAR(item.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,item.NGAYTAO,item.CD_SOCV,              
                to_char(to_date(item.CD_NGAYCV,'dd-MON-yy'),'dd/MM/yyyy')
                );
        END LOOP;
     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:=' Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy');
      elsif(vNgayNhapTu is null)then    
        vvNgayNhapTu:='';
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy');
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:='';
      end if;
    ----
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
    ----
    SELECT COUNT(*) INTO V_COUNT_PB FROM (SELECT PA.TENPHONGBANNHAN FROM TABLE(V_TABLE)PA GROUP BY PA.TENPHONGBANNHAN)PS;
    ---
   DBMS_LOB.APPEND(V_EXPORT_TEXT,'
   <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
   ');
    FOR item_s IN (
                 SELECT PA.TENPHONGBANNHAN FROM TABLE(V_TABLE)PA
                 LEFT JOIN DM_TOAAN TA ON TA.MA_TEN=PA.TENPHONGBANNHAN
                 GROUP BY PA.TENPHONGBANNHAN,TA.SOCAP
                 ORDER BY TA.SOCAP
    )
     LOOP
    SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN AND PA.CD_SOCV IS NOT NULL ;    
    -------
    IF(V_COUNT>0)THEN
       SELECT 
--             DECODE(V_BC_SoCV,NULL,PA.SOTOTRINH,V_BC_SoCV)CD_SOCV
--            ,DECODE(V_BC_NGAYDK,NULL,PA.NGAYTOTRINH,V_BC_NGAYDK)CD_NGAYCV
--            ,DECODE(V_BC_Nguoiky,NULL,PA.NGUOIKY,V_BC_Nguoiky)NGUOIKY
--                 DECODE(V_BC_SoCV,NULL,PA.CD_SOCV,V_BC_SoCV)CD_SOCV
--                ,DECODE(V_BC_NGAYDK,NULL,PA.CD_NGAYCV,V_BC_NGAYDK)CD_NGAYCV
--                ,DECODE(V_BC_Nguoiky,NULL,PA.NGUOIKY,V_BC_Nguoiky)NGUOIKY
                 PA.CD_SOCV CD_SOCV
                ,PA.CD_NGAYCV CD_NGAYCV
                ,PA.NGUOIKY NGUOIKY
                ,PA.TENTHAMPHAN
            INTO  V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_TENTHAMPHAN
            FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN AND PA.CD_SOCV IS NOT NULL  ORDER BY PA.NGAYTAO DESC
            FETCH FIRST 1 ROWS ONLY;
        END IF;
     -----  
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center; font-weight: bold;">
                    <td colspan="11" style="text-align: center; vertical-align: middle; font-size: 14pt;">DANH SÁCH
                        <br />
                        Đơn chuyển '||item_s.TENPHONGBANNHAN||'
                        <br />
                        <span style="font-size: 14pt; font-weight: normal; font-style: italic;">Kèm theo Công văn số '||V_CD_SOCV||' ngày '||V_CD_NGAYCV||' của Tòa án nhân dân tối cao</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="11" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Họ tên người gửi</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa phương</td>
                    <td colspan="6" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 30px;">Khiếu nại</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số lượng</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 30px;">Bản án/QĐ</td>
                    <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">QĐ kháng nghị</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 40px;">Số</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa XX</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người KN</td>
                </tr>
               ');
               V_TT:=0;
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN
                         ORDER BY PA.NGAYTAO DESC
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 V_DEM_ROW:=V_DEM_ROW+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.NGUOIGUI||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.DIAPHUONG||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_SO||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.BA_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_TOAXX||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.QD_SO||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.QD_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.QD_NGUOIKN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.SODON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.GHICHU||'</td>
                </tr>
                ');   
                 END LOOP;
                 ---tính những dòng ngắt trang khi kết suất ra excel
                 V_DEM_ROW:=V_DEM_ROW+11;--là 7 dòng head và 4 footer cho mỗi một đơn vị
                 V_COUNT_DEM_ROW:=V_COUNT_DEM_ROW+1;
                 IF(V_COUNT_DEM_ROW<V_COUNT_PB) THEN
                     DBMS_LOB.APPEND(V_DEM_TEXT,V_DEM_ROW||',');
                 END IF;
                 --------------------------------------------------
                SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA WHERE PA.TENPHONGBANNHAN=item_s.TENPHONGBANNHAN;
                ----
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr>
                    <td colspan="11" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top;text-align: right;">Tổng số:<span style="font-weight: bold;"> '||V_SODON_TONG||'</span></td>
                    <td colspan="1" style="vertical-align: top; text-align: left; font-weight: bold;"></td>
                    <td colspan="5" style="vertical-align: top;"></td>
                    <td colspan="3"></td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top;"><span style="font-weight: bold;">Xác nhận</span>
                    </td>
                    <td colspan="9" style="vertical-align: bottom;"></td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top; height:90px;">
                        <span style="font-style: italic;">(Ký ghi rõ họ tên)</span>
                    </td>
                    <td colspan="9" style="vertical-align: bottom;"></td>
                </tr>
           ');
           END LOOP;
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'          
                 <tr style="height: 0px;">
                    <td style="width: 30px"></td>
                    <td style="width: 195px"></td>
                    <td style="width: 123px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 79px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 70px"></td>
                    <td style="width: 49px"></td>
                    <td style="width: 172px"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT,RTRIM(V_DEM_TEXT,',') INSERT_PAGE_BREAK FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);dbms_lob.freetemporary(V_DEM_TEXT);
END DS_CHUYEN_TOA_AN_KHAC;

PROCEDURE DON_SEARCH_DS_DON_TRUNG
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
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
)
IS 
  V_TENPHONGBANGUI varchar2(500);V_TENDONVI varchar2(500);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);
  MININDEX	number;V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250);VVNGAYNHAPDEN varchar2(250);
  MAXINDEX	number; V_TABLE T_DT_NOIBO_DANHSACH_DONTRUNG_CC;V_BAQD_LOAIAN_NAME clob;V_NOICHUYEN clob;
  V_CD_SOCV varchar2(500);V_CD_NGUOIKY varchar2(250);V_CD_NGAYCV varchar2(250);V_ID NUMBER;V_CAPCHAID NUMBER;
  V_CD_SOTOTRINH varchar2(500);V_CD_NGAYTOTRINH varchar2(250);V_SOCV_TEMP varchar2(500);V_CD_NGUOIKY_TEMP varchar2(500);
  V_NGUOIGUI clob;V_TL_SO_TEMP varchar2(500); V_TENTHAMPHAN varchar2(500);
  V_TT NUMBER;V_SODON_TONG NUMBER;V_TENPHONGBANNHAN VARCHAR2(500);V_COUNT NUMBER;V_GHICHU clob;
  V_QD_NGUOIKN varchar2(500):=NULL;
  V_SOBA varchar2(500);V_NGAYBA varchar2(500);V_SOQD varchar2(500);V_NGAYQD varchar2(500);V_TOAXX varchar2(2000);
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_DT_NOIBO_DANHSACH_DONTRUNG_CC();
 -------
 IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
       SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
 END IF;
 --------

  FOR item IN (
          Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID
  ,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON
   , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  

  ,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,
      DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,d.DONGKHIEUNAI)DONGKHIEUNAI,
      d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO,
      (SoCVC.SOVB || SoCVCN.SOVB) as CD_SOCV,
       Decode(SoCVC.NGAYVB,null,SoCVCN.NGAYVB,SoCVC.NGAYVB) as CD_NGAYCV,
      (SoCVC.NGUOIKY || SoCVCN.NGUOIKY)as CD_NGUOIKY, 

      d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn'
                     when 2 then 'Công văn' 
                     when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
       ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                            when 1 then  'Đã chuyển'
                            when 2 then  'Đã nhận' 
                            when 3 then  'Bị trả lại' 
                            else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH

      ,d.CD_SOTOTRINH
      ,d.CD_NGAYTOTRINH
      ,d.CD_SOTOTRINH||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
      ,d.THAMPHANID
--      ,(Case d.CD_LOAI when 0 then 
--      (Case vIsDonGoc when 0 then 1 else
--      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
--                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
--                )
--         + (Case when d.DONTRUNGID>0 then 
--            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
--                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
--                )
--         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
--         ) End)
--              Else 
--              (Case vIsDonGoc when 0 then 1 else
--              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
--                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
--                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
--                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
--              End)
--              End)SODON
        , (SELECT COUNT(*) FROM GDTTT_DON cv 
			where CV.ID =  d.id
				or (cv.CD_TA_TRANGTHAI  in (2,3) 
						and  (CV.ARR_DON_ID= d.id
								OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID= d.id and ARR_DON_ID>0)) )) ) As SODON      
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block'
      when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

            ,decode(d.LOAIDON,1,'',(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',  ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')))) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
     ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

           , d.PHANLOAIXULY
           , NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
           , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,4)=3 then ''
                            when NVL(va.GQD_LOAIKETQUA,4)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
               ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,d.NGAYTAO
            from GDTTT_DON d
          --Thong tin So Cong Van chuyen Noi Bo 
              LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id 
              LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id

              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
              LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                  And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                And 1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD 
                                                    Or d.BAQD_TOAANID_PT=vToaRaBAQD
                                                    Or d.BAQD_TOAANID_ST=vToaRaBAQD 
                                                    then 1 else 0 end  
               -- and 1=case when vLoaiAn=0 then 1 when dtk.BAQD_LOAIAN=vLoaiAn then 1 else 0 end  
               --anhvh 12/02/2020
               AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )
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
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(DECODE(D.LOAIDON,4,KS.TEN,6,d.CV_TENDONVI,d.DONGKHIEUNAI)) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
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

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
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
                and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
                Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
                and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                    when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                    when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                    when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                    and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                    and 1=case when vLoaiCVID=0 then 1 
                    when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                    when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                    And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                    when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
        )
        LOOP
           V_NGUOIGUI:=item.DONGKHIEUNAI;
            IF(item.ARRCONGVAN IS NOT NULL)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Do ' ||REPLACE(item.ARRCONGVAN,'; )','')||')';
            ELSIF(item.LOAIDON=2)THEN
               V_NGUOIGUI:= V_NGUOIGUI||' (Công văn số '||item.CV_SO||' ngày '||to_char(item.CV_NGAY,'dd/MM/yyyy')||')';
            END IF;
             IF(LENGTH(item.TL_SO)=1)THEN
                 V_TL_SO_TEMP:='0'||item.TL_SO;
                 ELSIF(LENGTH(item.TL_SO)>1)THEN
                 V_TL_SO_TEMP:=item.TL_SO;
                END IF;
            ----
            SELECT decode(item.TENTHAMPHAN,NULL,NULL,'Thẩm phán '||item.TENTHAMPHAN) INTO V_TENTHAMPHAN FROM DUAL;
--            IF(item.ISNOTGDTTT=1) THEN
--              V_GHICHU:=item.GHICHU||' - (đơn không có nội dung GDT,TT)';
--            ELSE
              V_GHICHU:=item.GHICHU; 
--            END IF;
            ----
             IF(item.BAQD_LOAIQDBA!='0')THEN--QD
                V_QD_NGUOIKN:=item.TOAXX;
                V_SOBA:=NULL;V_NGAYBA:=NULL;
                V_SOQD:=item.BAQD_SO;V_NGAYQD:=TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy');
                V_TOAXX:=NULL;
            else -----------------------------BA
                V_QD_NGUOIKN:=NULL;
                V_SOBA:=item.BAQD_SO;V_NGAYBA:=TO_CHAR(item.BAQD_NGAYBA,'dd/MM/yyyy');
                V_SOQD:=NULL;V_NGAYQD:=NULL;V_TOAXX:=item.TOAXX;
            END IF;
            ----
            v_table.extend;
                v_table(v_table.count) := R_DT_NOIBO_DANHSACH_DONTRUNG_CC(
                item.STT,V_NGUOIGUI,item.DIACHIGUI,V_SOBA,V_NGAYBA,
                V_TOAXX,V_SOQD,V_NGAYQD,V_QD_NGUOIKN,item.SODON,
                V_GHICHU,NULL,item.NOICHUYEN,item.CD_SOTOTRINH,NULL,
                NULL,NULL,V_TENTHAMPHAN,V_TL_SO_TEMP,to_char(item.TL_NGAY,'dd/MM/yyyy'),
                to_char(item.NGAYNHANDON,'dd/MM/yyyy'),NULL,NULL,item.CD_NGUOIKY,NULL,
                item.BAQD_LOAIAN,TO_CHAR(item.CD_NGAYTOTRINH,'dd/MM/yyyy'),NULL,item.NGAYTAO,item.CD_SOCV,
                to_char(item.CD_NGAYCV,'dd/MM/yyyy'),ITEM.SOHIEUDON
                );
        END LOOP;
 --------
     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:=' Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy');
      elsif(vNgayNhapTu is null)then    
        vvNgayNhapTu:='';
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy');
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:='';
      end if;
    ----
      SELECT count(*)into V_COUNT FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     if(V_COUNT>0)then   
     SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
        INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
        WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
     end if;
    ----
    SELECT COUNT(*) INTO V_COUNT FROM TABLE(V_TABLE)PA WHERE PA.CD_SOCV IS NOT NULL ;    
    -------
    IF(V_COUNT>0)THEN
       SELECT 
             DECODE(PA.CD_SOCV,NULL,V_BC_SoCV,PA.CD_SOCV)CD_SOCV
            ,DECODE(PA.CD_NGAYCV,NULL,V_BC_NGAYDK,PA.CD_NGAYCV)CD_NGAYCV
            ,DECODE(PA.NGUOIKY,NULL,V_BC_Nguoiky,PA.NGUOIKY)NGUOIKY
            ,PA.TENTHAMPHAN
        INTO  V_CD_SOCV,V_CD_NGAYCV,V_CD_NGUOIKY,V_TENTHAMPHAN
        FROM TABLE(V_TABLE)PA WHERE PA.CD_SOCV IS NOT NULL  ORDER BY PA.NGAYTAO DESC
        FETCH FIRST 1 ROWS ONLY;
    END IF;
    -----  
    SELECT SUM(PA.SODON) INTO V_SODON_TONG FROM TABLE(V_TABLE)PA;
    SELECT PA.TENPHONGBANNHAN INTO V_TENPHONGBANNHAN FROM TABLE(V_TABLE)PA  FETCH FIRST 1 ROWS ONLY;
    -----
     SELECT UPPER(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao','TANDCC')),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL FROM DM_TOAAN TA WHERE TA.ID=vToaAnID;
    -------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
                <tr>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-size: 12pt">'||V_TENDONVI||'</td>
                    <td colspan="2"></td>
                    <th colspan="5" style="text-align: center; vertical-align: top; font-size: 12pt;">DANH SÁCH	</th>
                </tr>
                <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 12pt; text-decoration: underline;">VĂN PHÒNG</th>
                    <td colspan="2" style="color: #ffffff;">_</td>
                    <th colspan="5" style="vertical-align: top; font-size: 12pt;">Đơn chuyển '||V_TENPHONGBANNHAN||'</th>
                </tr>
                <tr style="text-align: center;">
                    <td colspan="4" style="vertical-align: top; font-size: 12pt;">Số: '||V_CD_SOCV||'/'||V_DONVI_CV||' - VP</td>
                    <td colspan="2"></td>
                    <th colspan="5" style="vertical-align: top; font-size: 12pt;">Ngày <span>'||to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'dd')||'</span> tháng <span>'||to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'MM')||'</span> năm <span>'||to_char(to_date(V_CD_NGAYCV,'dd/MM/yyyy'),'yyyy')||'</span></th>
                </tr>
                <tr>
                    <td colspan="11" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>');

                    IF(vToaAnID IN (4,5,6)) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số đơn</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày vào sổ</td>');
                    END IF;

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Họ tên người gửi</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa phương</td>
                    <td colspan="6" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 30px;">Khiếu nại</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số lượng</td>
                    <td rowspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ghi chú</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 30px;">Bản án/QĐ</td>
                    <td colspan="3" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">QĐ kháng nghị</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 40px;">Số</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Tòa XX</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Người KN</td>
                </tr>
               ');
               V_TT:=0;
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA ORDER BY PA.NGAYTAO DESC
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>');

                    IF(vToaAnID IN (4,5,6)) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.SOHIEUDON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.NGAYNHANDON||'</td>');
                    END IF;

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.NGUOIGUI||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.DIAPHUONG||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_SO||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.BA_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.BA_TOAXX||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.QD_SO||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.QD_NGAY||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.QD_NGUOIKN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.SODON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.GHICHU||'</td>
                </tr>
                ');   
                 END LOOP;
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr>
                    <td colspan="11" style="height: 10px;"></td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top; font-style: italic;height:41px;">Tổng số:</td>
                    <td colspan="1" style="vertical-align: top; text-align: left; font-weight: bold;">'||V_SODON_TONG||'</td>
                    <td colspan="5" style="vertical-align: top;"><span style="font-weight: bold;">Xác nhận của '||V_TENPHONGBANNHAN||'</span>
                        </td>
                    <td colspan="3">
                            <span style="font-size: 13pt font-weight: bold;vertical-align: bottom;"><b>KT. CHÁNH VĂN PHÒNG</b></span>
                    </td>
                </tr>
                <tr align="center" style="text-align: center;">
                    <td colspan="2" style="vertical-align: top; font-style: italic;"></td>
                    <td colspan="1" style="vertical-align: top; text-align: left; font-weight: bold;"></td>
                    <td colspan="5" style="vertical-align: top;"><span style="font-weight: bold;"><span style="font-style: italic">(Ký ghi rõ họ tên)</span></td>
                    <td colspan="3"
                            <span tyle="font-size: 13pt;font-weight: bold;vertical-align: top;"><b> PHÓ CHÁNH VĂN PHÒNG</b></span>
                    </td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold;">
                    <td colspan="8" style="vertical-align: top;"></td>
                    <td colspan="3" style="vertical-align: bottom; height: 140px;">
                        <p style="font-size: 13pt;"><strong>'||V_CD_NGUOIKY||'</strong></p>
                    </td>
                </tr>
                 <tr style="height: 0px;">
                    <td style="width: 30px"></td>');

                    IF(vToaAnID IN (4,5,6)) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td style="width: 38px"></td>
                    <td style="width: 70px"></td>');
                    END IF;

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <td style="width: 190px"></td>
                    <td style="width: 119px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 90px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 80px"></td>
                    <td style="width: 49px"></td>
                    <td style="width: 175px"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END DON_SEARCH_DS_DON_TRUNG;

PROCEDURE DS_DON_CHUA_DU_DK
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
  PageIndex	in	int,
  PageSize	in	int,
  curReturn OUT sys_refcursor
)
IS 
  V_TENPHONGBANGUI varchar2(500);V_TENDONVI varchar2(500);VVNGAYNHAPDEN varchar2(250);
  V_EXPORT_TEXT clob; VVNGAYNHAPTU varchar2(250); V_TABLE T_DT_TRALAI;V_TT NUMBER;
  V_CD_TA_LYDO_ISBAQD VARCHAR2(250);V_CD_TA_LYDO_ISXACNHAN VARCHAR2(250);V_TB1_NGAY VARCHAR2(250);
BEGIN
 DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_DT_TRALAI();

    FOR item IN (
          Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID
  ,d.MADON,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON,d.NGAYNHANDON
   , case when (Length(NVL(d.BAQD_NGAYBA,''))=0 or (to_char(d.BAQD_NGAYBA,'dd/MM/yyyy') ='01/01/0001')) then ''
                         when Length(NVL(d.BAQD_NGAYBA,'')) >0 then to_char(d.BAQD_NGAYBA,'dd/MM/yyyy')
                    end  NgayBA_PT  

  ,d.LOAIDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,
      d.NGUOITAO NguoiNhap,d.DONGKHIEUNAI,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA,
      d.NGAYTAO NgayNhap,TL_NGAY,TL_SO
      ,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY

      ,d.ISSHOWFULL,
      case d.LOAIDON when 1 then 'Đơn'
                     when 2 then 'Công văn' 
                     when 3 then 'Đơn + Công văn' end as HinhThuc
      ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
      Else d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN
      End) Diachigui
      ,d.CV_SO,d.NGAYGHITRENDON
       ,(Case d.BAQD_LOAIQDBA When 1 then d.KN_SOQD Else decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) END) BAQD_SO
      ,(Case d.BAQD_LOAIQDBA When 1 then ('QĐ: ' || d.KN_SOQD) Else decode(d.BAQD_CAPXETXU,2,('BA: ' || d.BAQD_SO_ST),3,('BA: ' || d.BAQD_SO_PT), ('BA: ' || d.BAQD_SO)) END) BAQD
      ,d.CV_TENDONVI,(Case d.BAQD_LOAIQDBA When 1 then d.KN_NGAY Else decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) END) BAQD_NGAYBA
      ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
      , DM_CanBo_TenToaVT(txx.Ma_Ten) TOAXX_VietTat
       ,d.NGUOIKHANGNGHI,d.GHICHU,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
      ,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_NGAY,d.CV_DIACHI CVDIACHI,d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG
      ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
          when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
          when 3 then  cast('Trả lại đơn' as nvarchar2(250))
          when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
      ,(case d.CD_TRANGTHAI when 0 then 'Chưa chuyển'
                            when 1 then  'Đã chuyển'
                            when 2 then  'Đã nhận' 
                            when 3 then  'Bị trả lại' 
                            else 'Chưa chuyển'   end ) TRANGTHAICHUYEN
      ,d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU,c.HOTEN TENTHAMPHAN,TRIM(d.NOIDUNGTOMTAT) NOIDUNGTOMTAT,d.CD_TRALAI_LYDOKHAC
      ,TB1_SO,TB1_NGAY,TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,d.CD_SOTOTRINH
      ,d.CD_NGAYTOTRINH
      ,d.CD_SOTOTRINH||' - '||TO_CHAR(d.CD_NGAYTOTRINH,'dd/MM/yyyy') TOTRINH_SONGAY
      ,d.THAMPHANID
      ,(Case d.CD_LOAI when 0 then 
      (Case vIsDonGoc when 0 then 1 else
      (1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         + (Case when d.DONTRUNGID>0 then 
            (Select Count(t.ID) from GDTTT_DON t where t.ID<>d.ID And ( t.DONTRUNGID=d.DONTRUNGID Or t.ID=d.DONTRUNGID) and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                  and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end
                )
         Else 0 End)+(Select Count(ID) from GDTTT_DON_BOSUNG where DONID=d.ID)
         ) End)
              Else 
              (Case vIsDonGoc when 0 then 1 else
              1+(Select Count(t.ID) from GDTTT_DON t where t.DONTRUNGID=d.ID 
                          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= t.NGAYTAO then 1 else 0 end
                          and 1=case when vNgayNhapDen is null then 1 when t.NGAYTAO <= vNgayNhapDen then 1 else 0 end
                          and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(t.nguoitao)|| ',%') then 1 else 0 end)
              End)
              End)SODON
      ,(Case d.CD_LOAI when 0 then 'block' Else 'none' End) IsShowNB
      ,(Case d.CD_LOAI when 0 then 'none' Else 'block' End) IsShowTK
      ,(Case d.CD_TA_TRANGTHAI when 0 then 'block' Else 'none' End) IsShowDDK
      ,(Case d.CD_TA_TRANGTHAI when 1 then 'block' Else 'none' End) IsShowCDDK
      ,(Case when d.ISTHULY=1 then 'block'
      when (d.CD_TA_TRANGTHAI=0 and d.ISTHULY is null) then 'block' Else 'none' End) IsShowTLMOI
      ,(Case d.ISTHULY when 2 then 'block' Else 'none' End) IsShowDATL

        ,decode(d.LOAIDON,1,'',(NVL(d.CV_TENDONVI,'') || decode(d.CV_SO,null,null, ' chuyển đến theo CV/PC số ' || d.CV_SO) ||  decode(NVL(d.CV_NGAY,''),'','',  ' ngày ' || TO_CHAR(d.CV_NGAY,'dd/MM/yyyy')))) arrCongvan
         ,(SELECT LISTAGG(TO_CHAR(cv.ID), ',')
         WITHIN GROUP (ORDER BY cv.NGAYTAO desc) FROM GDTTT_DON cv  WHERE (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
          and  1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= cv.NGAYTAO then 1 else 0 end
--                  and 1=case when vNgayNhapDen is null then 1 when cv.NGAYTAO <= vNgayNhapDen then 1 else 0 end  
                  and 1=case when vNguoiNhap || ' '=' ' then 1 when  lower(vNguoiNhap) like ('%,' || lower(cv.nguoitao)|| ',%') then 1 else 0 end
                  and 1=case when vSoCongVan || ' '=' ' then 1 when (lower(cv.CD_SOCV) = lower(vSoCongVan) Or lower(cv.CD_SOTOTRINH) = lower(vSoCongVan) ) then 1 else 0 end
                    and 1=case when vNgayCongVan || ' '=' ' then 1 when to_char(cv.CD_NGAYCV,'dd/MM/yyyy')=vNgayCongVan Or to_char(cv.CD_NGAYTOTRINH,'dd/MM/yyyy')=vNgayCongVan then 1 else 0 end
         ) arrDonID
     ,(Case when d.ISTHULY=2 And d.CD_LOAI=0 then (SELECT RTRIM(XMLAGG(XMLELEMENT(E,TO_CHAR('Số: ') || cv.TL_SO || ' - ' || to_char(cv.TL_NGAY,'dd/MM/yyyy') || TO_CHAR(' Thẩm phán: ') || ctp.HOTEN || ' (' || cv.CD_SOTOTRINH || '/TTr-TANDTC-VP)' ,'  ').EXTRACT('//text()') ORDER BY cv.NGAYTAO desc).GetClobVal(),',') 
           FROM GDTTT_DON cv  left join DM_CANBO ctp on cv.THAMPHANID=ctp.ID  WHERE cv.ISTHULY=1 And (cv.ID = d.ID or cv.DONTRUNGID=d.ID Or ( cv.ID in ( select ID from GDTTT_DON where (DONTRUNGID=d.DONTRUNGID Or ID=d.DONTRUNGID) And d.DontrungID>0)))
           And cv.ID<d.ID)  End) arrTTTL

           , d.PHANLOAIXULY
           , NVL(va.GQD_LOAIKETQUA,4) GQD_LOAIKETQUA
           , case when d.CD_LOAI= 0 and NVL(d.VuViecId, 0)>0
                  then case when NVL(va.GQD_LOAIKETQUA,4)=3 then ''
                            when NVL(va.GQD_LOAIKETQUA,4)<>3 
                              then (DECODE(NVL(va.GQD_LOAIKETQUA,4)
                                          , 4, 'Đang giải quyết'                            
                                          , 2, u'X\1ebfp \0111\01a1n'
                                          , 1, u'Kh\00e1ng ngh\1ecb', 0,u'Tr\1ea3 l\1eddi \0111\01a1n' )

                                    || case when Length(NVL(va.GDQ_SO, ''))>0 then ' số '||va.GDQ_SO
                                            else '' end 
                                    || case when (Length(NVL(va.GDQ_NGAY,''))=0 
                                                  or (to_char(va.GDQ_NGAY,'dd/MM/yyyy') ='01/01/0001')) then ''
                                            when Length(NVL(va.GDQ_NGAY,'')) >0 
                                                  then ' ngày ' || to_char(va.GDQ_NGAY,'dd/MM/yyyy') end 
                                    ) end                      
              else '' end  KQGQNoiBo,d.CV_TRALOI_NOIDUNG
               ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,d.NGAYTAO 
            from GDTTT_DON d
              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
                -----
             LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
             -----
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                where d.TOAANID=vToaAnID and 1=(Case when vIsDonGoc=0 then 1  when vIsDonGoc=1 And NVL(d.DONTRUNGID,0)=0 then 1  Else 0 End)
                  And 1=(Case when vIsThuLy=-1 then 1 when vIsThuLy=1  and d.ISTHULY=1  then 1  when vIsThuLy=2 and d.ISTHULY=2 then 1 Else 0 End)       
                and  1=case when vToaRaBAQD=0 then 1 when d.BAQD_TOAANID=vToaRaBAQD 
                                                         Or d.BAQD_TOAANID_PT=vToaRaBAQD 
                                                         Or d.BAQD_TOAANID_ST=vToaRaBAQD 
                                                            then 1 else 0 end
               -- and 1=case when vLoaiAn=0 then 1 when d.BAQD_LOAIAN=vLoaiAn then 1 else 0 end   
               --anhvh 12/02/2020
                AND (vLoaiAn=0
                    OR(d.BAQD_LOAIAN=vLoaiAn and vLoaiAn!=55 and vLoaiAn!=0)
                    OR(vLoaiAn=55 AND d.BAQD_LOAIAN IS NULL)
                  )

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
                and  1=case when vNguoiGui || ' '=' ' then 1 when lower(d.DONGKHIEUNAI) like '%' || lower(vNguoiGui) || '%' then 1 else 0 end
                and  1=case when vSoCMND || ' '=' ' then 1 when d.NGUOIGUI_CMND like '%' || vSoCMND || '%' then 1 else 0 end
                and  1=case when vTuNgay is null then 1 when vTuNgay <= d.NGAYNHANDON then 1 else 0 end
                and 1=case when vDenNgay is null then 1 when d.NGAYNHANDON <= vDenNgay then 1 else 0 end
                and 1=case when vHinhThucDon=0 then 1 when d.LOAIDON=vHinhThucDon then 1 else 0 end
                and 1=case when vSoHieuDon || ' '=' ' then 1 when (d.MADON =vSoHieuDon Or d.SOHIEUDON=vSoHieuDon) then 1 else 0 end
                and 1=case when vDiaChiTinh=0 then 1 when d.NGUOIGUI_TINHID=vDiaChiTinh then 1 else 0 end
                and 1=case when vDiaChiHuyen=0 then 1 when d.NGUOIGUI_HUYENID=vDiaChiHuyen then 1 else 0 end
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

                --and 1=case when vNoiChuyen=-1 then 1 when d.CD_LOAI=vNoiChuyen then 1 else 0 end
                --anhvh 13/02/2020
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
                and  ((1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.NGAYTAO then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.NGAYTAO <= vNgayNhapDen then 1 else 0 end)
                Or  ( 1=case when vNgayNhapTu is null then 1 when vNgayNhapTu <= d.TL_NGAY then 1 else 0 end
                and 1=case when vNgayNhapDen is null then 1 when d.TL_NGAY <= vNgayNhapDen then 1 else 0 end))
                and 1=case when vIsTuHinh=0 then 1 when vIsTuHinh=1 and NVL(d.ISANTUHINH,0)=0 then 1 
                    when vIsTuHinh=2 and NVL(d.ISANTUHINH,0)=1 then 1
                    when vIsTuHinh=3 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1 then 1
                    when vIsTuHinh=4 and NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1 then 1  else 0 end
                    and 1=case when vThamtravienID=0 then 1 when d.GQ_THAMTRAVIENID=vThamtravienID then 1 else 0 end
                    and 1=case when vLoaiCVID=0 then 1 
                    when vLoaiCVID=-1 and d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023) then 1
                    when (d.LOAICONGVAN=vLoaiCVID Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=vLoaiCVID)) then 1 else 0 end
                    And 1= case when vGuitoiCA_TA=-1 then 1 when vGuitoiCA_TA=0 and d.CD_TK_NOIGUI=0 then 1
                    when vGuitoiCA_TA=1 and d.CD_TK_NOIGUI=1 then 1 else 0 end
        )
        LOOP
            SELECT DECODE(item.CD_TA_LYDO_ISBAQD,'1','X',NULL)
            ,DECODE(item.CD_TA_LYDO_ISXACNHAN,'1','X',NULL)
            INTO V_CD_TA_LYDO_ISBAQD,V_CD_TA_LYDO_ISXACNHAN FROM DUAL;
            v_table.extend;
                v_table(v_table.count) := R_DT_TRALAI(
                NULL,item.MADON,item.DONGKHIEUNAI,item.DIACHIGUI,item.TB1_SO,to_char(item.TB1_NGAY,'dd/MM/yyyy')
                ,V_CD_TA_LYDO_ISBAQD,V_CD_TA_LYDO_ISXACNHAN,NULL,item.CD_TA_LYDO_KHAC,to_char(item.TL_NGAY,'dd/MM/yyyy'),item.NGAYTAO
                );
        END LOOP;

     --Truy vấn tạo dữ liệu báo cáo-------
       if(vNgayNhapTu is not null)then
        vvNgayNhapTu:=' Từ ngày '||to_char(vNgayNhapTu,'dd/MM/yyyy');
      elsif(vNgayNhapTu is null)then    
        vvNgayNhapTu:='';
      end if;
      -------
       if(vNgayNhapDen is not null)then
        vvNgayNhapDen:=' đến ngày '||to_char(vNgayNhapDen,'dd/MM/yyyy');
      elsif(vNgayNhapDen is null)then
        vvNgayNhapDen:='';
      end if;
    ----------
    SELECT PB.TENPHONGBAN,TA.TEN INTO V_TENPHONGBANGUI,V_TENDONVI FROM DM_PHONGBAN PB
    INNER JOIN DM_TOAAN TA ON TA.ID=PB.TOAANID
    WHERE PB.ID=(SELECT NSD.PHONGBANID FROM  QT_NGUOISUDUNG NSD WHERE NSD.ID=v_ID_USER);
    ----
       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
                 <tr align="center" style="text-align: center;">
                    <th colspan="10">DANH SÁCH ĐƠN CHƯA ĐỦ KIỀU KIỆN</th>
                </tr>
                <tr>
                    <td colspan="10" style="height: 23px;"></td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TT</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Mã đơn</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Đương sự</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Địa chỉ</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Số TBBS</td>
                    <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Ngày ra TBBS</td>
                    <td colspan="4" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 30px;">Bổ sung</td>
                </tr>
                <tr align="center" style="text-align: center; font-weight: bold">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; height: 93px;">Bản án/ Quyết định</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Xác nhận</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">TB giải quyết của TACC</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">Lý do khác</td>
                </tr>
               ');
               V_TT:=0;
               FOR item IN(
                         SELECT PA.* FROM TABLE(V_TABLE)PA ORDER BY PA.NGAYTAO DESC
                         )
                 LOOP
                 V_TT:=V_TT+1;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||V_TT||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black; mso-number-format:\@;">'||item.MADON||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.DUONGSU||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.DIACHI||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;mso-number-format:\@;">'||item.SOTBBS||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.NGAYTBBS||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.ISBAQD||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.ISXACNHAN||'</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">'||item.TBGQTACC||'</td>
                    <td style="text-align: left; vertical-align: middle; border: 0.1pt solid Black;">'||item.LYDOKHAC||'</td>
                </tr>
                ');   
                 END LOOP;
               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                 <tr style="height: 0px;">
                    <td style="width: 32px"></td>
                    <td style="width: 76px"></td>
                    <td style="width: 108px"></td>
                    <td style="width: 270px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 70px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 165px"></td>
                </tr>
            </table>
            ');
    OPEN curReturn FOR
       SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
END DS_DON_CHUA_DU_DK;

END PKG_GDTTT_HCTP_BC_DS;

/
