--------------------------------------------------------
--  DDL for Package Body PKG_GDTTT_HCTP_TINH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_GDTTT_HCTP_TINH" AS
FUNCTION TBL_GIAYXACNHAN_TINH
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
  PageIndex in  int,
  PageSize  in  int
) RETURN T_NOIBO_GIAYXACNHAN
IS 
  V_EXPORT_TEXT clob;V_TABLE T_NOIBO_GIAYXACNHAN;
  V_LOAIDON8_1 NUMBER:=0;V_ID NUMBER;
  V_CAPCHAID NUMBER;
  V_DIACHICOQUAN  varchar2(1000);
  V_NOIDUNG varchar2(2000);
  V_GIOITINH varchar2(250);
  V_GIOITINHHOA varchar2(250);
  V_CD_SOCV varchar2(250);
  V_CD_NGUOIKY varchar2(250);
  v_loaiBAQD varchar2(250);V_BASO varchar2(250); V_NGAYBA  varchar2(250);  V_TOAXX  varchar2(500); v_Loaidon varchar2(500); v_NguonDen  varchar2(500);
  v_CAPXX  varchar2(500);v_LOAIAN_TEXT  varchar2(250); v_BIDANH  varchar2(250); 
  v_loai_gdt  varchar2(250);
  V_COUNT NUMBER;
  V_NGUOIGUI_DONGKHIEUNAI VARCHAR2(2500);
  V_NGUOIGUI_DONGKHIEUNAI_DIACHI VARCHAR2(2500);
BEGIN
       DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);v_table := T_NOIBO_GIAYXACNHAN();
       -------
       IF(vLoaiCVID!=-1 AND vLoaiCVID!=0) THEN
           SELECT DT.ID,DT.CAPCHAID INTO V_ID,V_CAPCHAID FROM DM_DATAITEM DT WHERE DT.ID=vLoaiCVID; 
           IF(V_ID=1023 or V_CAPCHAID=1023) then
            V_LOAIDON8_1:=1;
           end if;
        END IF;
        select GHICHU into v_BIDANH from QT_NGUOISUDUNG where id=v_ID_USER;

  FOR item IN (
           Select   D.ID,d.CV_TENDONVI
                    ,decode(d.BAQD_CAPXETXU,2,d.BAQD_SO_ST,3,d.BAQD_SO_PT, d.BAQD_SO) BAQD_SO
                    ,d.CV_DIACHI CVDIACHI,d.CV_TRAIGIAMHIENTAI,decode(d.BAQD_CAPXETXU,2,d.BAQD_NGAYBA_ST,3,BAQD_NGAYBA_PT,d.BAQD_NGAYBA) BAQD_NGAYBA
                    ,(Case d.BAQD_LOAIQDBA When 1 then i.TEN Else txx.Ma_Ten END) TOAXX
                    ,d.NOIDUNGDON,d.GHICHU,d.CV_SO,d.CV_NGAY,d.DUNGDONLA,d.NGUOIGUI_GIOITINH
                    ,Decode(d.loaidon,2,d.CV_TENDONVI,4,KS.TEN,6,d.CV_TENDONVI,9,d.CV_TENDONVI,NVL(d.NGUOIGUI_HOTEN,d.DONGKHIEUNAI)) DONGKHIEUNAI
                    ,d.LOAICONGVAN
                    ,(Case when d.NGUOIGUI_HUYENID=981 then NGUOIGUI_DIACHI
                    Else (case when d.LOAIDON NOT IN (6,9) then d.NGUOIGUI_DIACHI ||(case when (d.NGUOIGUI_DIACHI || ' ')=' '  then ' ' Else ', ' End) || h.MA_TEN 
                    else d.CV_DIACHI ||(case when (d.CV_DIACHI || ' ')=' '  then ' ' Else ', ' End) || hv.MA_TEN  End)
                    End) Diachigui  --lanhnt
                    ,d.NGAYGHITRENDON,NVL(d.BAQD_LOAIQDBA,0) BAQD_LOAIQDBA,d.KN_SOQD,d.KN_NGAY
                    ,(case d.CD_LOAI when 0 then cast(pb.TENPHONGBAN as nvarchar2(250))
                    when 1 then cast(tk.MA_TEN as nvarchar2(250)) when 2 then  cast(d.CD_NTA_TENDONVI as nvarchar2(250))
                    when 3 then  cast('Trả lại đơn' as nvarchar2(250))
                    when 4 then  cast('Không chuyển' as nvarchar2(250))  end ) NOICHUYEN
                    ,D.CD_SOCV,D.CD_NGAYCV
                    ,d.BAQD_TOAANID
                    ,decode(d.BAQD_CAPXETXU,2,TAS.MA_TEN,3,TAP.MA_TEN,TAG.MA_TEN) BAQD_TOAAN_NAME
                    ,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME, VTD.NGUON_DEN, VTD.NGAY_BT
                    ,D.LOAIDON,D.NGAYNHANDON,D.BAQD_LOAIAN,D.LOAI_GDTTTT,D.BAQD_CAPXETXU,D.BAQD_SO_PT,D.BAQD_NGAYBA_PT
                    ,TAG.MA_TEN BAQD_TENTOA,TAP.MA_TEN BAQD_TENTOA_PT,TAS.MA_TEN BAQD_TENTOA_ST,D.BAQD_TOAANID_PT,D.BAQD_SO_ST,D.BAQD_NGAYBA_ST,D.BAQD_TOAANID_ST
                     ,null NGUOIGUI_DONGKHIEUNAI,null NGUOIGUI_DONGKHIEUNAI_DIACHI
                    ,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,sph.NGUOIKY GXNNGUOIKY , decode (sph.SOVB,null,'none','block') IsGXN
            from GDTTT_DON d
             --Thong tin Giay xac nhận
               LEFT JOIN(select so.*,sd.donid  from  SOPHATHANH_DON sd 
                                LEFT JOIN QUANLY_SOPHATHANH so on so.id = sd.SOPHATHANH_ID 
                                    where 
                                    (so.maso = 'SoGXN' or so.maso = 'SoGXN_DV') -- GTEL - ĐỨC PHẠM 20-09-2025 sửa đoạn này không chỉ fix giá trị tòa án nữa mà OR cho tất cả loại tòa
                                    --( (so.maso = 'SoGXN' AND vToaAnID = 4)  
                                            -- OR(so.maso = 'SoGXN_DV' AND vToaAnID != 4)
                                         -- )--29/10/2024
                                         and so.trangthai = 1)sph on sph.donid = d.id
              LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAG ON TAG.ID = D.BAQD_TOAANID
              LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAP ON TAP.ID = D.BAQD_TOAANID_PT
              LEFT JOIN (SELECT ID,MA_TEN FROM DM_TOAAN) TAS ON TAS.ID = D.BAQD_TOAANID_ST
              left join (select ID, GQD_LOAIKETQUA, GDQ_SO,GDQ_NGAY from GDTTT_VuAn) va on va.ID = d.VuViecID
              LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN
              LEFT JOIN (
                     SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU
                     )LA ON LA.ID=D.BAQD_LOAIAN
              LEFT JOIN (
                     SELECT CN.GDTTT_DON_ID,VT.NGUON_DEN,VT.MABD,VT.NGAY_BT from VT_CHUYEN_NHAN  CN 
                                    inner join (select * from VT_VANBANDEN) VT on  CN.VANBANDEN_ID = VT.ID
                        ) VTD on D.ID = VTD.GDTTT_DON_ID
                left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID
                left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID  --lanhnt
                left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID
                left join (select ID,MA_TEN from DM_TOAAN) txx on d.BAQD_TOAANID=txx.ID
                left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID
                left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID
                left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO
                left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID
                WHERE (INSTR(VARRSELECTID,','||D.ID||',')>0)
                ORDER BY d.NGAYTAO DESC
        )
        LOOP
           SELECT COUNT(*) INTO V_COUNT FROM GDTTT_DON_NGUOIKN DKN WHERE DKN.DONID=item.ID;
           V_NGUOIGUI_DONGKHIEUNAI:='';V_NGUOIGUI_DONGKHIEUNAI_DIACHI:='';
            IF(V_COUNT>0)THEN
             SELECT LISTAGG(DECODE(DKN.GIOITINH,0, ' bà ', 1, ' ông ', ' ') || DKN.HOTEN, ',') WITHIN GROUP (ORDER BY DKN.ID DESC)
                    ,LISTAGG(DECODE(DKN.GIOITINH,0, ' - Bà ', 1, ' - Ông ', ' - ') || DKN.HOTEN || ', ' || 'địa chỉ: ' || DKN.DIACHI, ';' || CHR(10)) WITHIN GROUP (ORDER BY DKN.ID DESC)
                    INTO V_NGUOIGUI_DONGKHIEUNAI,V_NGUOIGUI_DONGKHIEUNAI_DIACHI
             FROM GDTTT_DON_NGUOIKN DKN
             WHERE DKN.DONID=item.ID
             GROUP BY DKN.DONID;
            END IF; 
            IF(vToaAnID != 4) THEN --29/10/2024
                IF(item.DUNGDONLA=1)then
               if(item.NGUOIGUI_GIOITINH=1)then
                  V_GIOITINH:='ông';
                  V_GIOITINHHOA:='Ông';
                else
                   V_GIOITINH:='bà';
                  V_GIOITINHHOA:='Bà';
               end if;
              elsif(item.DUNGDONLA=2)then 
               V_GIOITINH:='Các ông, bà';
             end if;
           end if;  
             -------
              V_DIACHICOQUAN:=item.CVDIACHI;
              ---
                if (item.LOAIDON in (7)) then
                    v_Loaidon := 'thông báo';
                 elsif (item.LOAIDON in (6,9)) then
                    v_Loaidon := 'công văn kiến nghị';
                 else 
                    v_Loaidon := 'đơn đề nghị';
                 end if;
                 ---
                V_NOIDUNG:='';  
             if (item.LOAIDON in (3,9)) then
                if(item.CV_SO is not null)then
                    V_NOIDUNG:=V_NOIDUNG ||' (theo công văn số '||item.CV_SO;
                     if(item.CV_NGAY is not null)then                  
                        V_NOIDUNG:=V_NOIDUNG ||' ngày '||TO_char(item.CV_NGAY,'dd/MM/yyyy');
                    end if;
                    if(item.CV_TENDONVI is not null) then
                     V_NOIDUNG:=V_NOIDUNG||' của '||item.CV_TENDONVI;
                    end if;

                    V_NOIDUNG:=V_NOIDUNG||')';

                end if;
             end if;

                  if (item.NGUON_DEN = 1) then
                        v_NguonDen := 'gửi qua dịch vụ bưu chính chuyển đến';
                  else
                        v_NguonDen := 'nộp trực tiếp';
                  end if;

               if (item.BAQD_CAPXETXU = 3) then
                    v_CAPXX := 'phúc thẩm';
                 elsif (item.BAQD_CAPXETXU = 2) then
                    v_CAPXX := 'sơ thẩm';
                 else 
                    v_CAPXX := '';
                 end if;

              if (item.BAQD_LOAIAN = 1)then
                v_LOAIAN_TEXT := 'HS';
              elsif (item.BAQD_LOAIAN = 2)then
                v_LOAIAN_TEXT := 'DS';
              elsif (item.BAQD_LOAIAN = 3)then
                v_LOAIAN_TEXT := 'HNGD';
              elsif (item.BAQD_LOAIAN = 4)then
                v_LOAIAN_TEXT := 'KDTM';
              elsif (item.BAQD_LOAIAN = 5)then
                v_LOAIAN_TEXT := 'LD';
              elsif (item.BAQD_LOAIAN = 6)then
                v_LOAIAN_TEXT := 'HC';
              elsif (item.BAQD_LOAIAN = 7)then
                v_LOAIAN_TEXT := 'PS';
              end if;

              if (item.LOAI_GDTTTT = '1')then
                    v_loai_gdt:= 'giám đốc thẩm';
              elsif (item.LOAI_GDTTTT = '2')then
                    v_loai_gdt:= 'tái thẩm';
              else
                    v_loai_gdt:= '';
              end if;

              if (item.BAQD_LOAIQDBA = 0)then
                    v_loaiBAQD:= 'Bản án';
              else
                    v_loaiBAQD:= 'Quyết định';
              end if;

                v_table.extend;
                v_table(v_table.count) := R_NOIBO_GIAYXACNHAN(
                v_Loaidon,item.DUNGDONLA,item.NGUOIGUI_GIOITINH,v_NguonDen,to_char(item.NGAYGHITRENDON,'dd/MM/yyyy'), item.DONGKHIEUNAI,V_GIOITINHHOA,item.Diachigui,to_char(item.NGAYNHANDON,'dd/MM/yyyy'),item.CV_SO,to_char(item.CV_NGAY,'dd/MM/yyyy'),
                V_NOIDUNG,item.CV_TENDONVI,V_DIACHICOQUAN,v_LOAIAN_TEXT,item.BAQD_LOAIAN_NAME,
                v_loai_gdt,v_loaiBAQD,v_CAPXX,item.BAQD_SO, TO_char(item.BAQD_NGAYBA,'dd/MM/yyyy'),item.BAQD_TOAAN_NAME,
                V_NGUOIGUI_DONGKHIEUNAI, V_NGUOIGUI_DONGKHIEUNAI_DIACHI,
                item.GXNSO,item.GXNNGAY,item.GXNNGUOIKY);
        END LOOP;
        RETURN V_TABLE;
END TBL_GIAYXACNHAN_TINH;
  PROCEDURE DON_SEARCH_GIAYXACNHAN_TINH
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
) AS
  BEGIN
     OPEN curReturn FOR
       SELECT COUNT(*) OVER () as CountAll,
       PA.* FROM TABLE(PKG_GDTTT_HCTP_TINH.TBL_GIAYXACNHAN_TINH(V_BC_NGAYDK,V_BC_NGUOIKY,V_BC_SOCV,V_ID_USER,VTOAANID,VTOARABAQD,VSOBAQD,VNGAYBAQD,VNGUOIGUI,VSOCMND,VTUNGAY,VDENNGAY,VHINHTHUCDON,VSOHIEUDON,VDIACHITINH,VDIACHIHUYEN,VDIACHICT,VSOCONGVAN,VNGAYCONGVAN,VTRALOI,VNGUOINHAP,VNOICHUYEN,VTRANGTHAI,VCD_DONVIID,VCD_TA_TRANGTHAI,VCD_TENDONVI,VNGAYCHUYENTU,VNGAYCHUYENDEN,VARRSELECTID,VISTHULY,VPHANLOAIXULY,VNGAYTHULYTU,VNGAYTHULYDEN,VSOTHULY,VCHIDAO,VTRAIGIAM,VTBQUAHAN,VNGAYQUAHAN,VTHAMPHANID,VTHAMTRAVIENID,VLOAICVID,VNGAYNHAPTU,VNGAYNHAPDEN,VISDONGOC,VISTUHINH,VLOAIAN,VCVPC_SO,VCVPC_NGAY,VCVPC_TENCQ,VGUITOICA_TA,PAGEINDEX,PAGESIZE))  PA;
  END DON_SEARCH_GIAYXACNHAN_TINH;

END PKG_GDTTT_HCTP_TINH;


/
