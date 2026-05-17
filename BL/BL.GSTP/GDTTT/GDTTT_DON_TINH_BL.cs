using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_DON_TINH_BL
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable GDTTT_DON_SEARCH_GIAY_XAC_NHAN(String V_BC_NGAYDK, String V_BC_Nguoiky, String V_BC_SoCV, String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
            string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
            decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen,
            string vDiaChiCT, string vSoCongVan, string vNgayCongVan,
            decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
            decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
            , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
            decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_BC_NGAYDK",V_BC_NGAYDK),
                new OracleParameter("V_BC_Nguoiky",V_BC_Nguoiky),
                new OracleParameter("V_BC_SoCV",V_BC_SoCV),
                new OracleParameter("v_ID_USER",v_ID_USER),

                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                         new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                                                                        new OracleParameter("vSoBAQD",vSoBAQD),
                                                                        new OracleParameter("vNgayBAQD",vNgayBAQD),
                                                                        new OracleParameter("vNguoiGui",vNguoiGui),
                                                                        new OracleParameter("vSoCMND",vSoCMND),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vHinhThucDon",vHinhThucDon),
                                                                        new OracleParameter("vSoHieuDon",vSoHieuDon),
                                                                        new OracleParameter("vDiaChiTinh",vDiaChiTinh),
                                                                        new OracleParameter("vDiaChiHuyen",vDiaChiHuyen),
                                                                        new OracleParameter("vDiaChiCT",vDiaChiCT),
                                                                        new OracleParameter("vSoCongVan",vSoCongVan),
                                                                        new OracleParameter("vNgayCongVan",vNgayCongVan),
                                                                        new OracleParameter("vTraLoi",vTraLoi),
                                                                        new OracleParameter("vNguoiNhap",vNguoiNhap),
                                                                         new OracleParameter("vNoiChuyen",vNoiChuyen),
                                                                           new OracleParameter("vTrangthai",vTrangthai),
                                                                            new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                                                                             new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                                                                              new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                                                                               new OracleParameter("vNgaychuyenTu",vNgaychuyenTu),
                                                                                new OracleParameter("vNgaychuyenDen",vNgaychuyenDen),
                                                                                new OracleParameter("vArrSelectID",vArrSelectID),
                                                                                new OracleParameter("vIsThuLy",vIsThuLy),
                                                                                new OracleParameter("vPhanloaixuly",vPhanloaixuly),
                                                                                new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                                                                                new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                                                                                new OracleParameter("vSoThuly",vSoThuly),
                                                                                 new OracleParameter("vChidao",vChidao),
                                                                                  new OracleParameter("vTraigiam",vTraigiam),
                                                                                   new OracleParameter("vTBQuahan",vTBQuahan),
                                                                                   new OracleParameter("vNgayQuahan",vNgayQuahan),
                                                                                    new OracleParameter("vThamphanID",vThamphanID),
                                                                                   new OracleParameter("vThamtravienID",vThamtravienID),
                                                                                     new OracleParameter("vLoaiCVID",vLoaiCVID),
                                                                                       new OracleParameter("vNgayNhapTu",vNgayNhapTu),
                                                                                     new OracleParameter("vNgayNhapDen",vNgayNhapDen),
                                                                                      new OracleParameter("vIsDonGoc",vIsDonGoc),
                                                                                       new OracleParameter("vIsTuHinh",vIsTuHinh),
                                                                                       new OracleParameter("vLoaiAn",vLoaiAn),
                                                                                        new OracleParameter("vCVPC_So",vCVPC_So),
                                                                                       new OracleParameter("vCVPC_Ngay",vCVPC_Ngay),
                                                                                       new OracleParameter("vCVPC_TenCQ",vCVPC_TenCQ),
                                                                                       new OracleParameter("vGuitoiCA_TA",vGuitoiCA_TA),
                                                                                 new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            String sql_input_test =
"V_BC_NGAYDK :=" + V_BC_NGAYDK + " ;" +
"V_BC_Nguoiky :=" + V_BC_Nguoiky + " ;" +
"V_BC_SoCV :=" + V_BC_SoCV + " ;" +
"v_ID_USER :=" + v_ID_USER + " ;" +
"vToaAnID :=" + vToaAnID + " ;" +
"vToaRaBAQD :=" + vToaRaBAQD + " ;" +
"vSoBAQD :=" + vSoBAQD + " ;" +
"vNgayBAQD :=" + vNgayBAQD + " ;" +
"vNguoiGui :=" + vNguoiGui + " ;" +
"vSoCMND :=" + vSoCMND + " ;" +
"vTuNgay :=" + vTuNgay + " ;" +
"vDenNgay :=" + vDenNgay + " ;" +
"vHinhThucDon :=" + vHinhThucDon + " ;" +
"vSoHieuDon :=" + vSoHieuDon + " ;" +
"vDiaChiTinh :=" + vDiaChiTinh + " ;" +
"vDiaChiHuyen :=" + vDiaChiHuyen + " ;" +
"vDiaChiCT :=" + vDiaChiCT + " ;" +
"vSoCongVan :=" + vSoCongVan + " ;" +
"vNgayCongVan :=" + vNgayCongVan + " ;" +
"vTraLoi :=" + vTraLoi + " ;" +
"vNguoiNhap :=" + vNguoiNhap + " ;" +
"vNoiChuyen :=" + vNoiChuyen + " ;" +
"vTrangthai :=" + vTrangthai + " ;" +
"vCD_DONVIID :=" + vCD_DONVIID + " ;" +
"vCD_TA_TRANGTHAI :=" + vCD_TA_TRANGTHAI + " ;" +
"vCD_TENDONVI :=" + vCD_TENDONVI + " ;" +
"vNgaychuyenTu :=" + vNgaychuyenTu + " ;" +
"vNgaychuyenDen :=" + vNgaychuyenDen + " ;" +
"vArrSelectID :=" + vArrSelectID + " ;" +
"vIsThuLy :=" + vIsThuLy + " ;" +
"vPhanloaixuly :=" + vPhanloaixuly + " ;" +
"vNgayThulyTu :=" + vNgayThulyTu + " ;" +
"vNgayThulyDen :=" + vNgayThulyDen + " ;" +
"vSoThuly :=" + vSoThuly + " ;" +
"vChidao :=" + vChidao + " ;" +
"vTraigiam :=" + vTraigiam + " ;" +
"vTBQuahan :=" + vTBQuahan + " ;" +
"vNgayQuahan :=" + vNgayQuahan + " ;" +
"vThamphanID :=" + vThamphanID + " ;" +
"vThamtravienID :=" + vThamtravienID + " ;" +
"vLoaiCVID :=" + vLoaiCVID + " ;" +
"vNgayNhapTu :=" + vNgayNhapTu + " ;" +
"vNgayNhapDen :=" + vNgayNhapDen + " ;" +
"vIsDonGoc :=" + vIsDonGoc + " ;" +
"vIsTuHinh :=" + vIsTuHinh + " ;" +
"vLoaiAn :=" + vLoaiAn + " ;" +
"vCVPC_So :=" + vCVPC_So + " ;" +
"vCVPC_Ngay :=" + vCVPC_Ngay + " ;" +
"vCVPC_TenCQ :=" + vCVPC_TenCQ + " ;" +
"vGuitoiCA_TA :=" + vGuitoiCA_TA + " ;" +
"PageIndex :=" + PageIndex + " ;" +
"PageSize :=" + PageSize + " ;";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_TINH.DON_SEARCH_GIAYXACNHAN_TINH", parameters);
            return tbl;
        }
        public DataTable GDTTT_DON_SEARCH(decimal V_GET_LIS_ID, String V_NDBD_VALUE, String V_NDBD_TEXT, String V_DONVI_CHUYEN_ID, String V_TRANGTHAICHUYEN, String V_LOAI_VB, String V_SODEN_TU, String V_SODEN_DEN, String V_NGAY_FROM, String V_NGAY_TO, String V_NGUOI_GUI_BT,
           String v_ID_USER, decimal vToaAnID, decimal vToaRaBAQD, string vSoBAQD,
           string vNgayBAQD, string vNguoiGui, string vSoCMND, DateTime? vTuNgay, DateTime? vDenNgay,
           decimal vHinhThucDon, string vSoHieuDon, decimal vDiaChiTinh, decimal vDiaChiHuyen, string vDiaChiCT,
           string vLoaiSoVB, string vSoVanBan, string vNgayVanBan,
           decimal vTraLoi, string vNguoiNhap, decimal vNoiChuyen, decimal vTrangthai,
           decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, DateTime? vNgaychuyenTu, DateTime? vNgaychuyenDen, string vArrSelectID, decimal vIsThuLy, decimal vPhanloaixuly
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen, string vSoThuly, decimal vChidao, decimal vTraigiam, decimal vTBQuahan, DateTime? vNgayQuahan, decimal vThamphanID,
           decimal vThamtravienID, decimal vLoaiCVID, DateTime? vNgayNhapTu, DateTime? vNgayNhapDen, decimal vIsDonGoc, decimal vIsTuHinh, decimal vLoaiAn, string vCVPC_So, string vCVPC_Ngay, string vCVPC_TenCQ, decimal vGuitoiCA_TA, decimal vLOAI_GDTTT, decimal PageIndex, decimal PageSize)
        {
            try
            {
                Decimal MinIndex = PageSize * (PageIndex - 1) + 1;
                Decimal MaxIndex = PageIndex * PageSize;
                String SQL = "select  a.*,a.TotalItem CountAll from ( " +
                "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,Count(d.ID) OVER()TotalItem,d.ID ";

                SQL += ",d.MADON,d.LOAIDON,NULL MADON_CC,d.SOHIEUDON,d.NGUOIGUI_HOTEN,d.SOTHUTUDON" +
                    ",d.NGAYNHANDON NGAYNHANDONS, NULL NGAYNHANDON,d.BAQD_NGAYBA,NULL NgayBA_PT" +
                    ",d.BAQD_LOAIQDBA,null BAQD_LOAIQDBA_NAME,d.NGUOITAO NguoiNhap,d.CV_TENDONVI,d.DONGKHIEUNAI" +
                    ",KS.TEN, NULL DONGKHIEUNAI_CC,d.ISNOTGDTTT,d.NGUOISUA,d.NGAYSUA" +
                    ",d.NGAYTAO NgayNhap,D.TL_NGAY,D.TL_SO,d.CD_SOCV,d.CD_NGAYCV,d.CD_NGUOIKY,d.ISSHOWFULL" +
                    //--case d.LOAIDON  -  DM_LOAIDON
                    ",LAD.LOAIDON_TEN_VT HinhThuc,NULL LBL_HINHTHUC_CC" +
                    ",d.NGUOIGUI_HUYENID,d.NGUOIGUI_DIACHI,h.MA_TEN MA_TEN_H,hv.MA_TEN MA_TEN_HV,NULL DIACHIGUI" +
                    ",d.CV_SO,d.CV_NGAY" +
                    ",d.NGAYGHITRENDON,d.SO_HSKN,d.NGAY_HSKN, null NGAYGHITRENDON_CC" +
                    ",d.KN_SOQD,d.BAQD_CAPXETXU,d.BAQD_SO_PT,d.BAQD_SO_ST,d.BAQD_SO,d.BAQD_SO BAQD,NULL BAQD_CC" +
                    ",d.KN_NGAY,d.BAQD_NGAYBA_ST,d.BAQD_NGAYBA_PT,NULL BAQD_NGAYBA_CC" +
                    ",i.TEN TEN_I, txx.Ma_Ten TOAXX" +
                    ",txxST.MA_TEN MA_TEN_XXST,txxPT.MA_TEN MA_TEN_XXPT,NULL Infor_ST,NULL Infor_PT" +
                    ",d.NGUOIKHANGNGHI,d.CD_TRANGTHAI,tralai.ghichu GHICHU_TRALAI,d.GHICHU" +
                    ",d.DUNGDONLA,d.NGUOIGUI_GIOITINH,d.CD_TA_LYDO_ISBAQD,d.CD_TA_LYDO_ISXACNHAN,d.CD_TA_LYDO_ISKHAC,d.CV_DIACHI CVDIACHI" +
                    ",d.CD_TA_LYDO_KHAC,d.CHIDAO_COKHONG,d.CHIDAO_NOIDUNG" +
                    ",d.CD_LOAI,D.vuviecid,pb.TENPHONGBAN,d.CD_TA_DONVIID,gqkn.HOTEN,gqkn.CHUCVU" +
                    ",tk.MA_TEN MA_TEN_TK,d.CD_NTA_TENDONVI,NULL NOICHUYEN" +
                    //ISTHULY 1 Thụ lý mới,2 Đã thụ lý
                    ",D.TOAANID,D.ISTHULY,TTC.TRANGTHAICHUYEN" +
                    ",DC.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_DC,DC_HIS.TRANGTHAICHUYEN_TP TRANGTHAICHUYEN_TP_HIS,DC.TRANGTHAICHUYEN_TP" +
                    ",DC.NGAYCHUYEN NGAYCHUYEN_DC,DTL_NC.NGAYCHUYEN" +
                    ",d.BAQD_LOAIAN,d.CD_TRALAI_LYDOID,d.CD_TRALAI_YEUCAU" +
                    ",d.NOIDUNGTOMTAT" +
                    ",d.CD_TRALAI_LYDOKHAC,TB1_SO,TB1_NGAY" +
                    ",TB2_SO,TB2_NGAY,nsd.GHICHU BIDANH,SoTT.SOVB CD_SOTOTRINH,SoTT.NGAYVB CD_NGAYTOTRINH,c.HOTEN TENTHAMPHAN" +
                    ",QLS.SOVB,QLS.NGAYVB,NULL THAMPHAN_SONGAY,NULL TOTRINH_SONGAY,d.THAMPHANID" +
                    ",1 SODON,NULL TONG_SODON,NULL ARR_DON_IDS,d.ARR_DON_ID,d.CD_TA_TRANGTHAI,va.SOTHULYXXGDT,va.NGAYTHULYXXGDT,va.IsVienTruongKN" +
                    ",null IsShowNB,null IsShowTK,null GIAIQUYET" +
                    ",d.DONTRUNGID,null IsShowDDK,null IsShowCDDK,'Thụ lý mới' lb_thuly,null IsShowTLMOI,null IsShowTLMOI_TRUNG_TP,null IsShowDATL,null IsThulyXX,NULL arrCongvan, null arrDonID" +
                    ",NULL arrTTTL,NULL arrTTTL_TL,d.PHANLOAIXULY,va.GQD_LOAIKETQUA,va.LOAIAN " +
                    ",TLD.TLDKN||KN.TLDKN||kq.KQXXGDT KQGQ_HINHSU_EX" +
                    ",XLK_DS.XLK_XD_VKS||XD_DS.XLK_XD_VKS||VKSGQ_DS.XLK_XD_VKS||TLD_DS.TLDKN||KN_DS.TLDKN||kq.KQXXGDT KQGQ_DANSU_EX" +
                    ",va.GDQ_SO,va.GDQ_NGAY,va.GQD_NgayPhatHanhCV,kq.KQXXGDT" +
                    ",null KQGQNoiBo " +
                    ",d.CV_TRALOI_NOIDUNG,LA.LOAI_AN_TEN BAQD_LOAIAN_NAME,null BAQD_CAPXETXU_NAME " +
                    // ---văn thư đến-----
                    ",vt.VANBANDEN_ID,vt.CANBO_NHAN_ID,vt.TRANG_THAI_XLY,null TRANG_THAI_XLY_NAME" +
                    ",vbd.LOAI_VB,vbd.NGUOIDUNGDON,vbd.NGUOI_GUI_BT,vbd.NGUOI_GUI_BT NGUOI_GUI_BT_S" +
                    ",vbd.DIACHI_NDD,vbd.DIACHI_GUI_BT" +
                    ",vbd.NGAY_DEN NGAY_DEN_S,vbd.NGAY_BT NGAY_BT_S,NULL NGAY_DEN,NULL NGAY_BT" +
                    ",vbd.SO_BAQD_DON,vbd.NGAY_BAQD_DON,TA.Ma_Ten MA_TEN_TA,vbd.SO_VB,vbd.NGAY_VB,vbd.SO_CV,vbd.NGAY_CV,vbd.DONVICHUYEN_CV,NULL THONGTIN_VBD" +
                    ",pbvt.TEN TEN_PBVT,vbd.SODEN,vbd.NGUON_DEN NGUON_DEN_S,NULL NGUON_DEN,NULL DONVITIEPNHAN" +
                    ",d.LOAI_GDTTTT,d.NGUOIGUI_DIENTHOAI,NULL TRANGTHAILOAI_GDTTTT,NULL YCBS" +
                    ",THA.HOAN_THA,sph.SOVB GXNSO,sph.NGAYVB GXNNGAY,gxndv.SOVB GXNSODV" +
                    ",gxndv.NGAYVB GXNNGAYDV,null LOAIGDTT,null IsGXN,null IsGXNDV,NULL THOIHIEU" +
                     /*
                      ",(SoCVC.SOVB || SoCVCTK.SOVB ||  SoCVCN.SOVB ||  SoTralaidon.SOVB)  SVB_SOCV  " + 
                      ",(SoCVC.NGAYVB || SoCVCTK.NGAYVB ||  SoCVCN.NGAYVB ||  SoTralaidon.NGAYVB)  SVB_NGAYCV" +
                      ",(SoCVC.NGUOIKY || SoCVCTK.NGUOIKY ||  SoCVCN.NGUOIKY ||  SoTralaidon.NGUOIKY)  SVB_NGUOIKY " +
                      */
                     ",SoCVC.SOVB  SVB_SOCV  " +
                     ",SoCVC.NGAYVB  SVB_NGAYCV" +
                     ",SoCVC.NGUOIKY  SVB_NGUOIKY " +
                     ",NULL IS_SHOW_TP,SoTT_TLL.SOVB TLL_SOVB, SoTT_TLL.NGAYVB TLL_NGAYVB,SoTTXX.SOVB TXX_SOVB, SoTTXX.NGAYVB TXX_NGAYVB"
                     ;
                //",NULL SQL_01,NULL SQL_02,NULL SQL_03";
                if (PageSize == 0 && V_GET_LIS_ID == 1)//25/09/2024 PageSize == 0 không phân trang,V_GET_LIS_ID == 1 chỉ lấy id phục vụ cho báo cáo
                {
                    SQL = "select RTRIM(XMLAGG(XMLELEMENT(E,a.ID,',').EXTRACT('//text()') ORDER BY a.ID).GetClobVal(),',') AS LIST_ID from ( " +
                        "Select ROW_NUMBER() OVER (ORDER BY d.NGAYTAO desc) STT,d.ID";
                }
                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON nút tổng số đơn
                {
                    SQL = "select COUNT(*)TONG_SODON from ( " +
                     "select d.id ";
                }

                SQL += " from GDTTT_DON d ";

                if (PageSize == 0 && V_GET_LIS_ID == 2)//05/04/2025 TONG_SODON
                {
                    SQL += " LEFT JOIN GDTTT_DON DD ON (D.ID=DD.ID OR (DD.CD_TA_TRANGTHAI IN (2,3) AND (DD.ARR_DON_ID=D.ID or (dd.ARR_DON_ID in (Select ARR_DON_ID from GDTTT_DON where ID=D.ID and ARR_DON_ID>0 )) ))) ";
                }

                SQL += "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN')sph on sph.donid = d.id " +
                    "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoGXN_DV')gxndv on gxndv.donid = d.id   " +
           /*
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCTK')SoCVCTK on SoCVCTK.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVC')SoCVC on SoCVC.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoCVCN')SoCVCN on SoCVCN.donid = d.id   " +
          "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTralaidon')SoTralaidon on SoTralaidon.donid = d.id   " +
          */
           "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoCVC','SoCVCN','SoCVCTK','SoTralaidon'))SoCVC on SoCVC.donid = d.id   " +

            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT')SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTTXX')SoTTXX on SoTTXX.donid = d.id " +
            "LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso = 'SoTT_TLL')SoTT_TLL on SoTT_TLL.donid = d.id " +

            //"LEFT JOIN ( select sd.donid,so.* from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID where so.maso in ('SoTT','SoTTXX','SoTT_TLL'))SoTT on SoTT.donid = d.id " +
            "LEFT JOIN ( Select Sd.Donid,so.Sovb,so.Ngayvb  From  QUANLY_SOPHATHANH so Left Join  SOPHATHANH_DON sd On so.id = sd.SOPHATHANH_ID Where  so.Maso = 'TBTP' And so.Trangthai=1)QLS On QLS.donid=d.id " +
            //-- hien thi ly do tra lai don chi lay 1 gia tri moi nhat
            "left join (SELECT v.DONID,v.id,v.GHICHU FROM GDTTT_DON_CHUYEN_HISTORY v inner join ( SELECT TT.DONID,TT.ID FROM (  SELECT DONID,FIRST_VALUE(ID) OVER (PARTITION BY DONID ORDER BY NGAYTRA DESC) ID FROM  GDTTT_DON_CHUYEN_HISTORY)TT  GROUP BY TT.DONID,TT.ID)t on t.id=v.id where v.PHONGBANCHUYENID=1)tralai on d.id = tralai.donid " +//30/09/2024 v.PHONGBANCHUYENID=1 chỉ những đơn bị trả lại từ thầm phán, không lấy những đơn bị trả lại từ các vụ
            "LEFT JOIN (SELECT ld.LOAIDON_ID,ld.LOAIDON_TEN,ld.LOAIDON_TEN_VT,ld.TOAAN_ID FROM DM_LOAIDON ld WHERE ld.TOAAN_ID=" + 1 + ")LAD ON LAD.LOAIDON_ID=d.LOAIDON " +
            "left join (select ID,LOAIAN,GQD_LOAIKETQUA,GDQ_SO,GDQ_NGAY,XXGDTTT_SOQD,XXGDTTT_NGAYQD,GQD_NgayPhatHanhCV,SOTHULYXXGDT, NGAYTHULYXXGDT,IsVienTruongKN from GDTTT_VuAn ) va on va.ID = d.VuViecID " +
            "LEFT JOIN DM_VKS KS ON KS.ID=D.DONVICHUYEN_HSKN " +
            //--Ket qua xx giam doc tham 
            "LEFT JOIN (SELECT v.ID,'<br/>KQXXGDT: '||( 'Số '||v.XXGDTTT_SOQD || (case when (Length(NVL(v.XXGDTTT_NGAYQD,''))=0 or (to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') ='01/01/0001')) then '' when Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 then (' - '||to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy')) end)|| '<br/> ND: '|| chr(10)|| NVL(k.Ten,' ')) KQXXGDT FROM GDTTT_VuAn v left join DM_DAtaItem k on k.ID = v.XXGDTTT_KETQUAID where v.GQD_LOAIKETQUA = 1 and (trim(v.XXGDTTT_SOQD) is not null Or Length(NVL(v.XXGDTTT_NGAYQD,'')) >0 ) ) kq ON kq.ID = D.VUVIECID " +
            //--16/01/2024--decode(rdbLoai,1,'TYPETB=4 khang nghi','TYPETB=3 Trả lời đơn') hinh su
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_DON_TRALOI TK  WHERE TK.TYPETB=3)TLD ON TLD.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_DON_TRALOI TK   WHERE TK.TYPETB=4)KN ON KN.DONID=D.ID " +
            //--decode(rdbLoai,1,'khang nghi',0,'Trả lời đơn') dan su
            // --dùng cho dân sự ----va.GQD_LOAIKETQUA=GDTTT_VUAN_KETQUA_DON.LOAI,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'      
            "LEFT JOIN (SELECT TK.DONID,'Trả lời đơn '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=0 AND TK.TRANGTHAI=1)TLD_DS ON TLD_DS.DONID=D.ID " + //-- 1 đang dùng,0 xóa
            "LEFT JOIN (SELECT TK.DONID,'Kháng nghị '||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy'))|| DECODE(TK.NOIDUNGKHANGNGHI,NULL,NULL,'<br/> Nội dung kháng nghị: '||TK.NOIDUNGKHANGNGHI) TLDKN FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=1 AND TK.TRANGTHAI=1)KN_DS ON KN_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xử lý khác'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=3 AND TK.TRANGTHAI=1)XLK_DS ON XLK_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'Xếp đơn'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)XD_DS ON XD_DS.DONID=D.ID " +
            "LEFT JOIN (SELECT TK.DONID,'VKS đang GQ'||DECODE(TK.SO,NULL,NULL,'số '||TK.SO)|| DECODE(TK.NGAY,NULL,NULL,' - '||to_char(TK.NGAY,'dd/MM/yyyy')) XLK_XD_VKS FROM GDTTT_VUAN_KETQUA_DON TK WHERE TK.LOAI=2 AND TK.TRANGTHAI=1)VKSGQ_DS ON VKSGQ_DS.DONID=D.ID " +
            //--hoan thi hanh an tha----
            "LEFT JOIN(SELECT VA.ID,DECODE(VA.GQD_ISHOANTHA,0,null,1,'<b>Hoãn thi hành án </b> Số: '||va.GQD_HOANTHA_SO||' - '||to_char(va.GQD_HOANTHA_NGAY,'dd/MM/yyyy'))HOAN_THA FROM GDTTT_VUAN VA)THA ON THA.ID=D.VUVIECID " +
            // -----------------------
            " LEFT JOIN (SELECT LA.ID,LA.LOAI_AN_TEN FROM DM_LOAIAN LA ORDER BY LA.THUTU)LA ON LA.ID=D.BAQD_LOAIAN " +
            "left join (select id,MA_TEN from DM_HANHCHINH) h on d.NGUOIGUI_HUYENID=h.ID " +
            "left join (select id,MA_TEN from DM_HANHCHINH) hv on d.CV_HUYENID=hv.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) tk on d.CD_TK_DONVIID=tk.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txx on decode(d.BAQD_CAPXETXU,2,d.BAQD_TOAANID_ST,3,d.BAQD_TOAANID_PT,d.BAQD_TOAANID)=txx.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxPT on d.BAQD_TOAANID_PT = txxPT.ID " +
            "left join (select ID,MA_TEN from DM_TOAAN) txxST on d.BAQD_TOAANID_ST = txxST.ID " +
            "left join (select ID,TENPHONGBAN from DM_PHONGBAN) pb on d.CD_TA_DONVIID=pb.ID " +
            "left join (select cb.ID,cb.HOTEN,cv.TEN CHUCVU from DM_CANBO cb left join DM_DATAITEM cv  on cv.ID=cb.CHUCVUID) gqkn on d.CANBO_ID_GIAIQUYET_KN=gqkn.ID " +

            "left join (select ID,HOTEN from DM_CANBO) c on d.THAMPHANID=c.ID " +
            "left join (select USERNAME,GHICHU from QT_NGUOISUDUNG) nsd on nsd.USERNAME=d.NGUOITAO " +
            "left join (select id, TEN from DM_DATAITEM) i on d.NGUOIKHANGNGHI=i.ID " +
            // --van thu den 19/10/2020--    
            "left join VT_CHUYEN_NHAN vt on vt.GDTTT_DON_ID=d.id " +
            "LEFT JOIN VT_VANBANDEN vbd on vbd.id=vt.VANBANDEN_ID " +
            "LEFT JOIN DM_TOAAN pbvt ON pbvt.ID=VT.DONVI_CHUYEN_ID " +
            "LEFT JOIN DM_TOAAN TA ON TA.ID=vbd.TOAAN_BAQD_DON " +
            // --add 02/01/2024 Nguyên đơn, người khởi kiện 0; Bị đơn, bị kiện 1; Bị cáo:2----------- 
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='NGUYENDON' and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)nds ON nds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE cc.tucachtotung='BIDON'and cd.BAQD_LOAIAN in(2,3,4,5,6,7)GROUP BY cc.DONID)bds ON bds.DONID= d.id " +
            "LEFT JOIN (SELECT  cc.DONID,upper(LISTAGG(cc.TENDUONGSU, ',') WITHIN GROUP (ORDER BY cc.TENDUONGSU)) TENDUONGSU FROM GDTTT_DON_DUONGSU_CC cc  INNER JOIN GDTTT_DON cd on cd.id=cc.DONID WHERE  cd.BAQD_LOAIAN =1 and cc.tucachtotung='BIDON'GROUP BY cc.DONID)bcs ON bcs.DONID= d.id " +
            //--lấy trạng thái chuyển luồng thụ lý mới thẩm phán
            "LEFT JOIN (SELECT tc.donid,tc.TRANGTHAI,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển : '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN tc where tc.PHONGBANNHANID=102)DC ON DC.donid=d.id " +
            "LEFT JOIN (SELECT tc.donid,'<i><b> <span  style=" + '"' + "color: #0e7eee;" + '"' + ">'||decode(tc.TRANGTHAI,1,'Chưa nhận',2,'Đã nhận',3,'Trả lại',4,'Đã chuyển')||'</span>'|| '<span >: Thẩm phán</b></i> </span><br />' TRANGTHAICHUYEN_TP,'<br/><i>Ngày chuyển: '||to_char(NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN_HISTORY tc where tc.PHONGBANNHANID=102)DC_HIS ON DC_HIS.donid=d.id " +
            // --lấy trạng thái chuyển luồng đã thụ lý
            "LEFT JOIN (SELECT DD.ID,DECODE(DD.CD_TRANGTHAI,0,'Chưa chuyển',1,'Đã chuyển',2,'Đã nhận',3,'Bị trả lại','Chưa chuyển')TRANGTHAICHUYEN FROM GDTTT_DON DD)TTC ON TTC.ID=D.ID " +
            "LEFT JOIN (SELECT dvc.DONID,dvc.TRANGTHAI,dvc.PHONGBANNHANID,'<br/><i>Ngày chuyển : '||to_char(dvc.NGAYCHUYEN,'dd/MM/yyyy hh24:mi:ss')||'</i><br/>' NGAYCHUYEN FROM GDTTT_DON_CHUYEN dvc)DTL_NC ON DTL_NC.DONID=d.ID AND DTL_NC.PHONGBANNHANID=D.CD_TA_DONVIID " +
            " where d.TOAANID=" + vToaAnID + " " +
            " AND NVL(d.CD_TA_TRANGTHAI,0) IN (0,1)";//--19/03/2024 là một trường hợp khác để group những đơn không đủ điều kiện lại
                if (vIsThuLy != -1)
                {
                    if (vIsThuLy == 1)
                    {
                        if (vToaAnID == 1)
                        {
                            SQL += " AND d.ISTHULY=1 AND d.LOAIDON != 4";//---Don thu ly moi khong bao gom Ho so khang nghi
                        }
                        else
                        {
                            SQL += " AND d.ISTHULY=1";//---01/11/2024 Don thu ly moi dùng cho các tòa cấp cao
                        }
                    }
                    if (vIsThuLy == 2)
                    {
                        SQL += " AND (d.ISTHULY=2)";
                    }
                    if (vIsThuLy == 3)//& vNgayNhapTu != null & vNgayNhapDen != null
                    {
                        SQL += " AND (d.ISTHULY=1 and d.ARR_DON_ID>0)";
                    }
                    if (vIsThuLy == 4)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) > 0)";//-- TLM đã phan cong
                    }
                    if (vIsThuLy == 5)
                    {
                        SQL += " AND (d.ISTHULY=1 and NVL(d.THAMPHANID,0) = 0)";//-- TLM chua phan cong
                    }
                    if (vIsThuLy == 6)
                    {
                        SQL += " AND (d.ISTHULY=1 and (d.ARR_DON_ID is null or d.ARR_DON_ID = 0) AND d.LOAIDON != 4)";//-- TLM 
                    }
                }
                if (vLoaiAn != 0)
                {
                    if (vLoaiAn == 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN IS NULL)";
                    }
                    if (vLoaiAn != 55)
                    {
                        SQL += " AND (d.BAQD_LOAIAN=" + vLoaiAn + ")";
                    }
                }

                //DuyTM - 03/04/2025 - Yêu cầu tìm chính xác theo Số BA/QD 
                if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (" +
                                 "( " + " ( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD == 0)
                {
                    SQL += " AND ( " +
                                 " LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')" +
                                 " OR " + " LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD == 0)
                {
                    SQL += " AND (TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" +
                        " OR TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')";
                }
                else if (vSoBAQD != "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + " AND TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "'" + ")" +
                                 ")";
                }
                else if (vSoBAQD != "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                                 "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND " + "( LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "')||'/%'" + " OR LOWER(D.BAQD_SO) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_PT) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND " + " ( LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.BAQD_SO_ST) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 " OR (" + " ( LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "')|| '/%'" + " OR LOWER(D.KN_SOQD) LIKE LOWER('" + vSoBAQD + "') )" + ")" +
                                 ")";

                }
                else if (vSoBAQD == "" && vNgayBAQD != "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (" +
                            "(d.BAQD_TOAANID = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_PT = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_PT,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (d.BAQD_TOAANID_ST = " + vToaRaBAQD + "AND TO_CHAR(D.BAQD_NGAYBA_ST,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            " OR (TO_CHAR(D.KN_NGAY,'dd/MM/yyyy')='" + vNgayBAQD + "')" +
                            ")";
                }
                else if (vSoBAQD == "" && vNgayBAQD == "" && vToaRaBAQD != 0)
                {
                    SQL += " AND (d.BAQD_TOAANID = " + vToaRaBAQD + " Or d.BAQD_TOAANID_PT = " + vToaRaBAQD + " Or d.BAQD_TOAANID_ST = " + vToaRaBAQD + ")";
                }

                if (vNguoiGui != "")
                {
                    vNguoiGui = vNguoiGui.Replace("'", "`");
                    if (vToaAnID == 6)
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.NGUOIGUI_HOTEN )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                    else
                    {
                        SQL += " AND (" +
                               "REPLACE(LOWER(DECODE(D.LOAIDON,4,KS.TEN,6,D.CV_TENDONVI,D.DONGKHIEUNAI )),'''','`') LIKE '%' || LOWER('" + vNguoiGui + "') || '%'" +
                               ") ";
                    }
                }
                if (vSoCMND != "")
                {
                    SQL += " AND (D.NGUOIGUI_CMND LIKE '%'||'" + vSoCMND + "'||'%')";
                }
                if (vTuNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON >=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vTuNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vDenNgay != null)
                {
                    SQL += " AND (D.NGAYNHANDON <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vDenNgay) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vHinhThucDon != 0)
                {
                    SQL += " AND (D.LOAIDON = " + vHinhThucDon + ")";
                }
                if (vSoHieuDon != "")
                {
                    SQL += " AND (D.MADON ='" + vSoHieuDon + "' OR D.SOHIEUDON='" + vSoHieuDon + "')";
                }
                if (vDiaChiTinh != 0)
                {
                    SQL += " AND (D.NGUOIGUI_TINHID =" + vDiaChiTinh + ")";
                }
                if (vDiaChiHuyen != 0)
                {
                    SQL += " AND (D.NGUOIGUI_HUYENID =" + vDiaChiHuyen + ")";
                }

                if (vNoiChuyen == 2)
                {
                    if (vCD_TENDONVI != "")
                    {
                        SQL += " AND (lower(replace(d.CD_NTA_TENDONVI,' ')) like '%' || LOWER(replace('" + vCD_TENDONVI + "',' ' )) || '%')";
                    }
                }

                if (vSoVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where b.SOTHONGBAO = '" + vSoVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                                                "where so.maso = '" + vLoaiSoVB + "' " +
                                                " AND so.SOVB ='" + vSoVanBan + "'" +
                                                " AND sd.donid =  D.id)";
                    }

                }
                if (vNgayVanBan != "")
                {
                    if (vLoaiSoVB == "YCBS")
                    {
                        SQL += "AND EXISTS (select 'X' From GDTTT_DON_YEUCAU_BOSUNG b " +
                                               "where TO_CHAR(b.NGAYTHONGBAO,'dd/MM/yyyy') = '" + vNgayVanBan + "' " +
                                               " AND b.DONID =  D.id)";
                    }
                    else
                    {
                        SQL += "AND EXISTS (select 'X' from QUANLY_SOPHATHANH so left join SOPHATHANH_DON sd on so.id = sd.SOPHATHANH_ID " +
                        "where so.maso = '" + vLoaiSoVB + "' " +
                        " AND TO_CHAR(so.NGAYVB,'dd/MM/yyyy') ='" + vNgayVanBan + "'" +
                        " AND sd.donid =  D.id)";
                    }
                }
                if (vCVPC_So != "")
                {
                    SQL += " AND (LOWER(D.CV_SO) LIKE '%' || LOWER('" + vCVPC_So + "') || '%')";
                }
                if (vCVPC_Ngay != "")
                {
                    SQL += " AND (to_char(d.CV_NGAY,'dd/MM/yyyy')='" + vCVPC_Ngay + "')";
                }
                if (vCVPC_TenCQ != "")
                {
                    SQL += " AND (lower(d.CV_TENDONVI) like '%' || LOWER('" + vCVPC_TenCQ + "') || '%')";
                }
                if (vTraLoi != 0)
                {
                    SQL += " AND (d.TRALOIDON=" + vTraLoi + ")";
                }
                if (vNguoiNhap != "")
                {
                    SQL += " AND (LOWER('" + vNguoiNhap + "') like ('%,' || lower(d.nguoitao)|| ',%') )";
                }
                if (vNoiChuyen != -1)
                {
                    if (vNoiChuyen != -2)
                    {
                        SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                    }
                    if (vNoiChuyen == -2)
                    {
                        SQL += " AND ( d.CD_LOAI IN(1,2) )";
                    }
                }
                if (vTrangthai != -1)
                {
                    if (vToaAnID == 1)
                    {   //Dong de anh Hoàng anh xem lại luong vi de nhu cu Tìm kiem tai HCTP dang sai 
                        //if (vTrangthai == 1)
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI in(1,2,4) OR  DTL_NC.TRANGTHAI in(1,2,4) )";
                        //}
                        //else if (vTrangthai == 3)
                        //{
                        //    SQL += " AND ( d.CD_TRANGTHAI in (3,4) AND tralai.ghichu IS NOT NULL )";//30/09/2024
                        //}
                        //else if (vTrangthai == 2)//da chuyen va da nhan 04/10/2024
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI = 2 OR  DTL_NC.TRANGTHAI=2)";
                        //}
                        //else if (vTrangthai == 0)//chưa chuyển
                        //{
                        //    SQL += " AND ( DC.TRANGTHAI IS NULL OR  DTL_NC.TRANGTHAI IS NULL )";
                        //}

                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                    else //các tòa cấp cao 23/10/2024
                    {
                        if (vTrangthai == 1)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(1,2)"; // đã chuyên
                        }
                        else if (vTrangthai == 3)
                        {
                            SQL += " AND d.CD_TRANGTHAI in(3,4)";//bi tra lai
                        }
                        else if (vTrangthai == 2)//da chuyen va da nhan
                        {
                            SQL += " AND d.CD_TRANGTHAI = 2";
                        }
                        else if (vTrangthai == 0)//chưa chuyển
                        {
                            SQL += " AND (d.CD_TRANGTHAI = 0 OR d.CD_TRANGTHAI is null)";
                        }
                    }
                }
                if (vNoiChuyen == 0)
                {
                    if (vCD_DONVIID > 0)
                    {
                        SQL += " AND (d.CD_TA_DONVIID=" + vCD_DONVIID + ")";
                    }
                    if (vCD_TA_TRANGTHAI != -1)
                    {
                        if (vCD_TA_TRANGTHAI >= 0)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=" + vCD_TA_TRANGTHAI + ")";
                        }
                        if (vCD_TA_TRANGTHAI == 3) //--lanhnt thêm trạng thái đơn
                        {
                            SQL += " AND (NVL(d.CD_TA_TRANGTHAI,0) !=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID))";
                        }
                        if (vCD_TA_TRANGTHAI == 4)
                        {
                            SQL += " AND (d.CD_TA_TRANGTHAI=1 and EXISTS(SELECT 'X' FROM GDTTT_DON_YEUCAU_BOSUNG WHERE DONID=d.ID AND NGAYTHONGBAO < add_months(trunc(sysdate), -1) AND LANTHU = (select max(LANTHU) from GDTTT_DON_YEUCAU_BOSUNG WHERE DONID = d.ID)))";
                        }
                    }
                }
                if (vNoiChuyen == 1)
                {
                    if (vCD_DONVIID != 0)
                    {
                        if (vCD_DONVIID > 0)
                        {
                            SQL += " AND (d.CD_TK_DONVIID=" + vCD_DONVIID + ")";
                        }
                        if (vCD_DONVIID == -1)
                        {
                            SQL += " AND (d.CD_TK_DONVIID in (Select ID from DM_TOAAN where LOAITOA in ('CAPHUYEN','CAPTINH')))";
                        }
                    }

                }

                if (vNoiChuyen > 2)
                {
                    SQL += " AND (d.CD_LOAI=" + vNoiChuyen + ")";
                }
                if (vNgaychuyenTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.CD_NGAYXULY)";
                }
                if (vNgaychuyenDen != null)
                {
                    SQL += " AND (d.CD_NGAYXULY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgaychuyenTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayThulyTu != null)
                {
                    SQL += " AND (to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyTu) + "','dd/MM/yyyy HH24:MI:SS') <= d.TL_NGAY)";
                }
                if (vNgayThulyDen != null)
                {
                    SQL += " AND (d.TL_NGAY <= to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayThulyDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vSoThuly != "")
                {
                    SQL += " AND (lower(d.TL_SO) like '%' || LOWER('" + vSoThuly + "') || '%') AND d.ISTHULY=1";
                }
                if (vArrSelectID != "")
                {
                    SQL += " AND ('" + vArrSelectID + "' like '%,' || Cast(d.ID as varchar2(10)) || ',%')";
                }
                if (vChidao != -1)
                {
                    if (vChidao == 0)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)>0)";//-- Có ý kiến chỉ đạo
                    }
                    if (vChidao == 1)
                    {
                        SQL += " AND (NVL(d.CHIDAO_COKHONG,0)=0)";//-- Không có ý kiến chỉ đạo
                    }
                    if (vChidao > 1)
                    {
                        SQL += " AND (d.CHIDAO_LANHDAOID=vChidao)";
                    }
                }
                if (vTraigiam != -1)
                {
                    SQL += " AND (NVL(d.CV_ISTRAIGIAM,0)=" + vTraigiam + ")";
                }
                if (vPhanloaixuly != 0)
                {
                    SQL += " AND (d.PHANLOAIXULY=" + vPhanloaixuly + ")";
                }
                if (vTBQuahan != 0)
                {
                    SQL += " AND (d.TB1_NGAY<(to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayQuahan) + "','yy/MM/yyyy HH24:MI:SS') - 30))";
                }
                Decimal curr_thamphan_id = 0;
                Decimal v_ID_USER_NUM = Convert.ToDecimal(v_ID_USER);
                QT_NGUOISUDUNG oND = dt.QT_NGUOISUDUNG.Where(x => x.ID == v_ID_USER_NUM).FirstOrDefault();
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oND.CANBOID).FirstOrDefault();
                DM_DATAITEM oItem = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                curr_thamphan_id = vThamphanID;
                if (oItem != null)
                {
                    if (oItem.MA == "PCA" || oItem.MA == "CA")
                    {
                        if (oND.CANBOID == vThamphanID)
                        {
                            curr_thamphan_id = 0;
                        }
                        else
                        {
                            curr_thamphan_id = vThamphanID;
                        }
                    }
                }
                if (curr_thamphan_id != 0)
                {
                    SQL += " AND (d.THAMPHANID=" + curr_thamphan_id + ")";
                }
                if (vNgayNhapTu != null)
                {
                    SQL += " AND (d.NGAYTAO>=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapTu) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vNgayNhapDen != null)
                {
                    SQL += " AND (d.NGAYTAO<=to_date('" + String.Format("{0:dd/MM/yyyy HH:mm:ss}", vNgayNhapDen) + "','dd/MM/yyyy HH24:MI:SS') )";
                }
                if (vIsTuHinh != 0)
                {
                    if (vIsTuHinh == 1)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=0)";
                    }
                    if (vIsTuHinh == 2)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1)";
                    }
                    if (vIsTuHinh == 3)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_ANGIAM,0)=1)";
                    }
                    if (vIsTuHinh == 4)
                    {
                        SQL += " AND (NVL(d.ISANTUHINH,0)=1 and NVL(d.ISTH_KEUOAN,0)=1)";
                    }
                }
                if (vThamtravienID != 0)
                {
                    SQL += " AND (d.GQ_THAMTRAVIENID=" + vThamtravienID + ")";
                }
                if (vLoaiCVID != 0)
                {
                    if (vLoaiCVID == -1)
                    {
                        SQL += " AND (d.LOAICONGVAN not in (Select ID from DM_DATAITEM where ID=1023 Or CAPCHAID=1023))";
                    }
                    else
                    {
                        SQL += " AND (d.LOAICONGVAN=" + vLoaiCVID + " Or d.LOAICONGVAN in (Select ID from DM_DATAITEM where CAPCHAID=" + vLoaiCVID + "))";
                    }
                }
                if (vGuitoiCA_TA != 0)
                {
                    if (vGuitoiCA_TA == 0)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=0)";
                    }
                    if (vGuitoiCA_TA == 1)
                    {
                        SQL += " AND (d.CD_TK_NOIGUI=1)";
                    }
                }
                if (V_NDBD_TEXT != "")
                {
                    if (V_NDBD_VALUE == "0")
                    {
                        SQL += " AND (nds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "1")
                    {
                        SQL += " AND (bds.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                    if (V_NDBD_VALUE == "2")
                    {
                        SQL += " AND (bcs.TENDUONGSU LIKE '%'||upper(TRIM('" + V_NDBD_TEXT + "'))||'%')";
                    }
                }
                if (V_DONVI_CHUYEN_ID != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=d.ID";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_TRANGTHAICHUYEN != "")
                {
                    if (V_TRANGTHAICHUYEN == "3")
                    {
                        SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                    if (V_TRANGTHAICHUYEN == "4")
                    {
                        SQL += " AND (NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3";
                        if (V_DONVI_CHUYEN_ID != "")
                        {
                            SQL += " AND  DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                        }
                        SQL += "))";
                    }
                }
                if (V_LOAI_VB != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.LOAI_VB=" + V_LOAI_VB;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_TU != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN>=" + V_SODEN_TU;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_SODEN_DEN != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.SODEN<=" + V_SODEN_DEN;
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_FROM != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN>=TO_DATE('" + V_NGAY_FROM + " 00:00:00','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGAY_TO != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGAY_DEN<=TO_DATE('" + V_NGAY_TO + " 23:59:59','dd/MM/yyyy HH24:MI:SS')";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (V_NGUOI_GUI_BT != "")
                {
                    SQL += " AND (EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN cn INNER JOIN VT_VANBANDEN vbd on vbd.id=cn.VANBANDEN_ID  WHERE cn.GDTTT_DON_ID=d.ID AND vbd.NGUOI_GUI_BT LIKE '%'||'" + V_NGUOI_GUI_BT + "'||'%' ";
                    if (V_DONVI_CHUYEN_ID != "")
                    {
                        SQL += " AND  cn.DONVI_CHUYEN_ID=" + V_DONVI_CHUYEN_ID;
                    }
                    SQL += "))";
                }
                if (MaxIndex == 0)
                {
                    SQL += ") a ";
                }
                else
                {
                    SQL += ") a where a.stt>=" + MinIndex + " and a.stt<=" + MaxIndex;
                }
                //-------------------
                DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
                if (tbl != null && tbl.Rows.Count > 0 && V_GET_LIS_ID == 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        row["NOIDUNGTOMTAT"] = Convert.ToString(row["NOIDUNGTOMTAT"]).Trim();
                        row["IS_SHOW_TP"] = "none";
                        int rs = 0;
                        String _date1 = String.Format("{0:dd/MM/yyyy}", row["NGAYNHAP"]);
                        String _date2 = "10/06/2024";
                        if (row["NGAYNHAP"] + "" != "")
                        {
                            rs = DateTime.Compare(DateTime.Parse(_date1, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Parse(_date2, cul, DateTimeStyles.NoCurrentDateDefault));
                            //rs = 0; date1 = date2;rs > 0; date1 > date2;rs < 0; date1 < date2;
                        }
                        if (rs > 0)
                        {
                            row["IS_SHOW_TP"] = "block";
                        }
                        ////////////////////
                        row["MADON_CC"] = "<i>Mã đơn</i>:" + row["MADON"] + "";
                        row["LBL_HINHTHUC_CC"] = "Ngày trên đơn";
                        String n_dd = "<i>Người gửi:</i>";
                        if (row["LOAIDON"] + "" == "1" || row["LOAIDON"] + "" == "3")
                        {
                            n_dd = "<i>Người đứng đơn:</i>";
                        }
                        //-------------------
                        row["NGAYGHITRENDON_CC"] = row["NGAYGHITRENDON"] + "";


                        if (row["LOAIDON"] + "" == "4")
                        {
                            row["LBL_HINHTHUC_CC"] = "Ngày QĐKN";
                            row["NGAYGHITRENDON_CC"] = row["NGAY_HSKN"] + "";
                            row["HinhThuc"] = row["HinhThuc"] + " (Số KN " + row["SO_HSKN"] + " ngày " + String.Format("{0:dd/MM/yyyy}", row["NGAY_HSKN"]) + ")";

                            row["CD_SOTOTRINH"] = row["TXX_SOVB"];
                            row["CD_NGAYTOTRINH"] = row["TXX_NGAYVB"];

                        }
                        else
                        {
                            if (row["ISTHULY"] + "" == "1" && Convert.ToDecimal(row["ARR_DON_ID"]) > 0)
                            {
                                row["CD_SOTOTRINH"] = row["TLL_SOVB"];
                                row["CD_NGAYTOTRINH"] = row["TLL_NGAYVB"];
                            }
                        }
                        //-------------------
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["MADON_CC"] = "<i>Mã VB</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày VB";
                            row["NGAYGHITRENDON_CC"] = row["CV_NGAY"] + "";
                        }
                        //------------------
                        if (row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["MADON_CC"] = "<i>Mã CV</i>:" + row["MADON"] + "";
                            row["LBL_HINHTHUC_CC"] = "Ngày công văn";
                        }
                        if (row["DONGKHIEUNAI"] + "" == "")
                        {
                            if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                            {
                                row["DONGKHIEUNAI"] = row["CV_TENDONVI"] + "";
                            }
                            if (row["LOAIDON"] + "" == "4")
                            {
                                row["DONGKHIEUNAI"] = row["TEN"] + "";
                            }
                            else
                            {
                                row["DONGKHIEUNAI"] = row["NGUOIGUI_HOTEN"] + "";
                            }
                        }
                        String dkn = "<b>" + row["DONGKHIEUNAI"] + "</b>";
                        if (row["LOAIDON"].ToString() == "6") //GTEL-DUCPH 02-10-2025 xử lý cho Công Văn đề nghị GDT,TT lấy theo CV_TENDONVI
                        {
                            row["DONGKHIEUNAI_CC"] = n_dd + "<b>" + row["CV_TENDONVI"] + "</b>";
                        }
                        else
                        {
                            row["DONGKHIEUNAI_CC"] = n_dd + dkn;
                        }
                        //------------------
                        row["NGAYNHANDON"] = String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAYNHANDONS"]) == "01/01/0001")
                        {
                            row["NGAYNHANDON"] = "";
                        }
                        row["NgayBA_PT"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]);
                        if (String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) == "01/01/0001")
                        {
                            row["NgayBA_PT"] = "";
                        }
                        if (row["BAQD_LOAIQDBA"] + "" == "")
                        {
                            row["BAQD_LOAIQDBA"] = "0";
                        }
                        if (row["BAQD_CAPXETXU"] + "" == "")
                        {
                            row["BAQD_CAPXETXU"] = "0";
                        }

                        if (row["LOAIDON"] + "" == "2" || row["LOAIDON"] + "" == "6" || row["LOAIDON"] + "" == "9")
                        {
                            row["DIACHIGUI"] = "" + row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }
                        else
                        {
                            if (row["NGUOIGUI_HUYENID"] + "" == "981")
                            {
                                row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"];
                            }
                            if (row["NGUOIGUI_HUYENID"] + "" != "981")
                            {
                                if (row["NGUOIGUI_DIACHI"] + "" == "")
                                {
                                    row["DIACHIGUI"] = "" + row["MA_TEN_H"];
                                }
                                if (row["NGUOIGUI_DIACHI"] + "" != "")
                                {
                                    row["DIACHIGUI"] = "" + row["NGUOIGUI_DIACHI"] + ", " + row["MA_TEN_H"];
                                }
                            }
                        }
                        if (row["CVDIACHI"] + "" != "")
                        {
                            row["CVDIACHI"] = row["CVDIACHI"] + ", " + row["MA_TEN_HV"];
                        }

                        String lbl_BAQD_CC = "QĐ: ";
                        String lbl_baqd = "QĐ: ";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA"]) + "</b>";
                        if (row["BAQD_LOAIQDBA"] + "" == "1")
                        {
                            row["BAQD_SO"] = row["KN_SOQD"] + "";
                            row["BAQD"] = lbl_baqd + row["KN_SOQD"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["KN_SOQD"] + "";
                            row["BAQD_NGAYBA"] = row["KN_NGAY"];
                            row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["KN_NGAY"]);
                            row["TOAXX"] = row["TEN_I"];
                        }



                        if (row["TOAANID"] + "" == "1")
                        {
                            row["BAQD_LOAIQDBA_NAME"] = "BA/QĐ";
                        }
                        else
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "1")
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Quyết định";
                            }
                            {
                                row["BAQD_LOAIQDBA_NAME"] = "Bản án";
                            }
                        }
                        if (row["BAQD_LOAIQDBA"] + "" != "1")
                        {
                            if (row["BAQD_LOAIQDBA"] + "" == "0")
                            {
                                lbl_baqd = "BA/QĐ: ";
                                lbl_BAQD_CC = "BA: ";
                            }
                            row["BAQD"] = lbl_baqd + row["BAQD_SO"] + "";
                            row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO"] + "";
                            if (row["BAQD_CAPXETXU"] + "" == "2")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_ST"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_ST"] + "";
                                row["BAQD_CC"] = lbl_BAQD_CC + row["BAQD_SO_ST"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_ST"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                                row["BAQD_CAPXETXU_NAME"] = "sơ thẩm";

                            }
                            if (row["BAQD_CAPXETXU"] + "" == "3")
                            {
                                row["BAQD_SO"] = row["BAQD_SO_PT"] + "";
                                row["BAQD"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_CC"] = lbl_baqd + row["BAQD_SO_PT"] + "";
                                row["BAQD_NGAYBA"] = row["BAQD_NGAYBA_PT"];
                                row["BAQD_NGAYBA_CC"] = String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                                row["BAQD_CAPXETXU_NAME"] = "Phúc thẩm";
                            }
                        }
                        row["BAQD_CC"] = "<i>Số </i><b>" + row["BAQD_CC"] + "</b>";
                        row["BAQD_NGAYBA_CC"] = "<i>Ngày </i><b>" + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_CC"]) + "</b>";
                        if (row["LOAIDON"] + "" == "5")
                        {
                            row["BAQD_CC"] = "";
                            row["BAQD_NGAYBA_CC"] = "";
                        }
                        if (row["BAQD_SO_ST"] + "" != "")
                        {
                            row["Infor_ST"] = "BA: " + row["BAQD_SO_ST"];
                            if (row["BAQD_NGAYBA_ST"] + "" != "")
                            {
                                row["Infor_ST"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_ST"]);
                            }
                            row["Infor_ST"] += " " + row["MA_TEN_XXST"] + "";
                        }
                        if (row["BAQD_SO_PT"] + "" != "")
                        {
                            row["Infor_PT"] = "BA: " + row["BAQD_SO_PT"];
                            if (row["BAQD_NGAYBA_PT"] + "" != "")
                            {
                                row["Infor_PT"] += " ngày: " + String.Format("{0:dd/MM/yyyy}", row["BAQD_NGAYBA_PT"]);
                            }
                            row["Infor_PT"] += " " + row["MA_TEN_XXPT"] + "";
                        }
                        if ((row["CD_TRANGTHAI"] + "" == "3" || row["CD_TRANGTHAI"] + "" == "4") && row["GHICHU_TRALAI"] + "" != "")
                        {
                            row["GHICHU"] += "<i></br>Lý do trả lại đơn:</i> " + row["GHICHU_TRALAI"];
                        }
                        //------------------------------------------
                        row["IsShowNB"] = "none";
                        row["IsShowTK"] = "block";
                        if (row["CD_LOAI"] + "" == "0")
                        {
                            if (row["CD_TA_DONVIID"] + "" == "102" && (row["LOAIDON"] + "" == "8" || row["LOAIDON"] + "" == "10"))
                            {
                                if (row["CHUCVU"] + "" != "")
                                    row["NOICHUYEN"] = row["CHUCVU"] + " " + row["HOTEN"];
                                else
                                    row["NOICHUYEN"] = "Thẩm phán " + row["HOTEN"];
                            }
                            else
                            {
                                row["NOICHUYEN"] = row["TENPHONGBAN"] + "";
                            }
                            row["IsShowNB"] = "block";
                            row["IsShowTK"] = "none";

                        }
                        if (row["CD_LOAI"] + "" == "1")
                        {
                            row["NOICHUYEN"] = row["MA_TEN_TK"] + "";
                        }
                        if (row["CD_LOAI"] + "" == "2")
                        {
                            row["NOICHUYEN"] = row["CD_NTA_TENDONVI"] + "";
                        }
                        row["GIAIQUYET"] = "Chuyển đơn";
                        if (row["CD_LOAI"] + "" == "3")
                        {
                            row["NOICHUYEN"] = "Trả lại đơn";
                            row["GIAIQUYET"] = "Trả lại đơn";
                        }
                        if (row["CD_LOAI"] + "" == "4")
                        {
                            row["NOICHUYEN"] = "Không chuyển";
                            row["GIAIQUYET"] = "Xếp đơn";
                        }
                        //------------------------------------
                        if (row["TOAANID"] + "" == "1")
                        {
                            if (row["ISTHULY"] + "" == "1")
                            {
                                row["TRANGTHAICHUYEN"] = "Đơn vị giải quyết";
                            }
                        }
                        if (row["LOAIDON"] + "" == "4")
                            row["lb_thuly"] = "Thụ lý xét xử";
                        else
                            row["lb_thuly"] = "Thụ lý mới";

                        row["IsShowTLMOI"] = "none";
                        if (row["ISTHULY"] + "" == "1")
                        {
                            if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                            {
                                if (row["TRANGTHAICHUYEN_TP_HIS"] + "" == "")
                                {
                                    row["TRANGTHAICHUYEN_TP"] = "<b><i><span style=" + '"' + "color:#0e7eee" + '"' + "> Chưa chuyển:</span> Thẩm phán</i></b><br/>";
                                }
                            }
                            row["NGAYCHUYEN"] = row["NGAYCHUYEN_DC"] + "";
                            row["IsShowTLMOI"] = "block";
                        }
                        //Don du dieu kien chua xac dinh thu ly
                        if (row["ISTHULY"] + "" == "" && row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowTLMOI"] = "block";
                        }
                        //hien thi ten la thu ly lai
                        row["IsShowTLMOI_TRUNG_TP"] = "none";
                        if (row["IsShowTLMOI"] + "" == "block")
                        {
                            if (row["arr_don_id"] + "" != "")
                            {
                                if (Convert.ToDecimal(row["arr_don_id"]) > 0)
                                {
                                    row["IsShowTLMOI_TRUNG_TP"] = "block";
                                    row["IsShowTLMOI"] = "none";
                                }
                            }
                        }
                        row["IsShowDATL"] = "none";
                        if (row["ISTHULY"] + "" == "2")
                        {
                            row["IsShowDATL"] = "block";
                        }
                        if (row["TRANGTHAICHUYEN_TP_DC"] + "" == "")
                        {
                            row["TRANGTHAICHUYEN_TP"] += row["TRANGTHAICHUYEN_TP_HIS"] + "";
                        }
                        //-----------------------
                        if (row["TENTHAMPHAN"] + "" != "")
                        {
                            row["THAMPHAN_SONGAY"] = "<i>Thẩm phán: </i><b>" + row["TENTHAMPHAN"] + "</b>" +
                                "(" + row["CD_SOTOTRINH"] + "/TTr-TANDTC-VP - " + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"])
                                + "<b>;</b> " + row["SOVB"] + "/TB-TANDTC-VP</b> - " + String.Format("{0:dd/MM/yyyy}", row["NGAYVB"])
                                + ")<br/>";
                        }
                        row["TOTRINH_SONGAY"] = row["CD_SOTOTRINH"] + String.Format("{0:dd/MM/yyyy}", row["CD_NGAYTOTRINH"]);
                        //--------------------
                        row["IsShowDDK"] = "none";
                        row["IsShowCDDK"] = "none";
                        if (row["CD_TA_TRANGTHAI"] + "" == "0")
                        {
                            row["IsShowDDK"] = "block";
                        }
                        if (row["CD_TA_TRANGTHAI"] + "" == "1")
                        {
                            row["IsShowCDDK"] = "block";
                        }

                        row["IsThulyXX"] = "none";
                        if (row["NGAYTHULYXXGDT"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["NGAYTHULYXXGDT"]) != "01/01/0001" && (row["IsVienTruongKN"] + "" == "0" || row["IsVienTruongKN"] + "" == ""))
                        {
                            row["IsThulyXX"] = "block";
                        }
                        row["arrCongvan"] = "";
                        if (row["LOAIDON"] + "" != "1")
                        {
                            row["arrCongvan"] = row["CV_TENDONVI"] + "";
                            if (row["CV_SO"] + "" != "")
                            {
                                row["arrCongvan"] += " chuyển đến theo CV/PC số " + row["CV_SO"] + "";
                            }
                            if (row["CV_NGAY"] + "" != "" && String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]) != "01/01/0001")
                            {
                                row["arrCongvan"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["CV_NGAY"]);
                            }
                        }
                        //----------------------------
                        if (row["TRANG_THAI_XLY"] + "" == "4")
                        {
                            row["TRANG_THAI_XLY_NAME"] = "Dữ liệu từ VBĐ";
                        }
                        if(row["LOAIDON"] + "" == "6")  
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["CV_TENDONVI"] + "";
                        }
                        else {
                            row["NGUOI_GUI_BT"] = "<i>Người gửi:</i><b>" + row["NGUOI_GUI_BT"] + "";
                        }
                        
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "3")
                        {
                            row["NGUOI_GUI_BT"] = "<i>Người đứng đơn: </i><b>" + row["NGUOIDUNGDON"] + "";
                            row["DIACHI_GUI_BT"] = row["DIACHI_NDD"] + "";
                        }
                        /////////-----------------------
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_DEN_S"]) != "01/01/0001")
                        {
                            row["NGAY_DEN"] = "";
                        }
                        if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BT_S"]) != "01/01/0001")
                        {
                            row["NGAY_BT"] = "";
                        }
                        //-------------------------------
                        if (row["LOAI_VB"] + "" == "1" || row["LOAI_VB"] + "" == "4")
                        {
                            String V_NGAY_BAQD_DON = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]) != "01/01/0001")
                            {
                                V_NGAY_BAQD_DON = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_BAQD_DON"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>BA/QĐ: " + row["SO_BAQD_DON"] + V_NGAY_BAQD_DON + row["MA_TEN_TA"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" == "5")
                        {
                            String V_NGAY_VB = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]) != "01/01/0001")
                            {
                                V_NGAY_VB = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_VB"]);
                            }
                            row["THONGTIN_VBD"] = "Số <b>VB: " + row["SO_VB"] + V_NGAY_VB + row["NGUOI_GUI_BT_S"] + "</b>";
                        }
                        if (row["LOAI_VB"] + "" != "1" && row["LOAI_VB"] + "" != "4" && row["LOAI_VB"] + "" != "5")
                        {
                            String V_NGAY_CV = "";
                            if (String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]) != "01/01/0001")
                            {
                                V_NGAY_CV = "</b> Ngày: <b>" + String.Format("{0:dd/MM/yyyy}", row["NGAY_CV"]);
                            }
                            row["THONGTIN_VBD"] = "Số CV: <b> " + row["SO_CV"] + V_NGAY_CV + "</b> Cơ quan/Đơn vị chuyển: <b>" + row["DONVICHUYEN_CV"] + "</b>";
                        }
                        //-----------------------------------
                        if (row["TEN_PBVT"] + "" != "")
                        {
                            row["DONVITIEPNHAN"] = "<i>Đơn vị tiếp nhận:</i><b style=" + '"' + "color:#0da520" + '"' + " > Văn thư</b><br />";
                        }
                        //--------------------------------
                        if (row["NGUON_DEN_S"] + "" == "1")
                        {
                            row["NGUON_DEN"] = "Bưu điện";
                        }
                        if (row["NGUON_DEN_S"] + "" == "2")
                        {
                            row["NGUON_DEN"] = "Tiếp công dân";
                        }
                        if (row["NGUON_DEN_S"] + "" == "3")
                        {
                            row["NGUON_DEN"] = "Trực tiếp";
                        }
                        //////////////////////////
                        if (row["LOAI_GDTTTT"] + "" == "1")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Giám đốc thẩm";
                            row["LOAIGDTT"] = "Giám đốc thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "2")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Tái thẩm";
                            row["LOAIGDTT"] = "Tái thẩm";
                        }
                        if (row["LOAI_GDTTTT"] + "" == "3")
                        {
                            row["TRANGTHAILOAI_GDTTTT"] = "Chưa xác định";
                        }
                        //////////////////////////
                        SQL = "SELECT (SELECT 'Thông báo YCBS lần ' || y.LANTHU || ': Số ' || y.SOTHONGBAO || ' ngày ' || TO_CHAR(y.NGAYTHONGBAO,'dd/MM/yyyy') FROM GDTTT_DON_YEUCAU_BOSUNG y " +
                            "WHERE y.DONID = " + row["ID"] + " AND y.LANTHU IN ( SELECT MAX(LANTHU) FROM GDTTT_DON_YEUCAU_BOSUNG  WHERE DONID = " + row["ID"] + ")" +
                            ") AS YCBS FROM DUAL";
                        DataTable tbl_YCBS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_YCBS != null && tbl_YCBS.Rows.Count > 0)
                        {
                            row["YCBS"] = tbl_YCBS.Rows[0]["YCBS"];
                        }
                        ///////////////////////////////////
                        row["IsGXN"] = "block";
                        if (row["GXNSO"] + "" == "")
                        {
                            row["IsGXN"] = "none";
                        }
                        row["IsGXNDV"] = "block";
                        if (row["GXNSODV"] + "" == "")
                        {
                            row["IsGXNDV"] = "none";
                        }
                        ///////////////////////////////////
                        SQL = "SELECT case when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <= 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 60 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU = 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 30 " +
                            " AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) > 0 " +
                            " AND d.BAQD_CAPXETXU != 2 " +
                            "then '(Thời hiệu còn '|| PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) || ' ngày)'" +
                            "when PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,3,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) <0 and PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU_BY_YEAR(d.BAQD_LOAIAN,decode(d.BAQD_CAPXETXU,4,d.BAQD_NGAYBA,3,d.BAQD_NGAYBA_PT,d.BAQD_NGAYBA_ST),d.TL_NGAY,0,5,Decode(d.ISTH_ANGIAM,1,1,Decode(d.ISTH_KEUOAN,1,1,0))) < 0 " +
                            "then '(Hết thời hiệu giải quyết) ' " +
                            "else '' " +
                            "end THOIHIEU FROM GDTTT_DON D WHERE D.ID=" + row["ID"];
                        DataTable tbl_THOIHIEU = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_THOIHIEU != null && tbl_THOIHIEU.Rows.Count > 0)
                        {
                            row["THOIHIEU"] = tbl_THOIHIEU.Rows[0]["THOIHIEU"];
                        }
                        /////----------------
                        SQL = "SELECT DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)ARR_DON_IDS " +
                              "FROM GDTTT_DON cv " +
                              "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ") " +
                              "GROUP BY DECODE(CV.ARR_DON_ID,0,CV.ID,CV.ARR_DON_ID)";
                        DataTable tbl_ARRS = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_ARRS != null && tbl_ARRS.Rows.Count > 0)
                        {
                            row["ARR_DON_IDS"] = tbl_ARRS.Rows[0]["ARR_DON_IDS"];

                        }
                        SQL = "SELECT COUNT(*)TONG_SODON " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  (CV.ARR_DON_ID=" + row["ID"] + " OR (CV.ARR_DON_ID IN (Select ARR_DON_ID from GDTTT_DON where ID=" + row["ID"] + " and ARR_DON_ID>0)) ))";
                        /////----------------
                        DataTable tbl_tong = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_tong != null && tbl_tong.Rows.Count > 0)
                        {
                            row["TONG_SODON"] = tbl_tong.Rows[0]["TONG_SODON"];
                        }
                        if (row["TONG_SODON"] + "" == "")
                        {
                            row["TONG_SODON"] = "1";
                        }
                        //----------------
                        SQL = "SELECT LISTAGG(TO_CHAR(cv.ID), ',') WITHIN GROUP (ORDER BY cv.ARR_DON_ID DESC) arrDonID " +
                             "FROM GDTTT_DON cv " +
                             "where CV.ID = " + row["ID"] + " or (cv.CD_TA_TRANGTHAI  in (2,3) and  CV.ARR_DON_ID=" + row["ID"] + ")";
                        DataTable tbl_arr = Cls_Comon.GetTableToSQL(SQL);
                        if (tbl_arr != null && tbl_arr.Rows.Count > 0)
                        {
                            row["arrDonID"] = tbl_arr.Rows[0]["arrDonID"];
                        }
                        //--------
                        //GQD_LOAIKETQUA,0,Trả lời đơn,1,Kháng nghị,2,'Xếp đơn:',3,'Xử lý khác:',4,'VKS đang giải quyết'
                        //D.cd_loai:0 nội bộ
                        if (row["cd_loai"] + "" == "0" && row["vuviecid"] + "" != "" && row["vuviecid"] + "" != "0")
                        {
                            if (row["LOAIAN"] + "" == "1")//-- hinh su
                            {
                                if (row["GQD_LOAIKETQUA"] + "" == "0")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "1")
                                {
                                    if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                    {
                                        row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                        if (row["GDQ_SO"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                        }
                                        if (row["GDQ_NGAY"] + "" != "")
                                        {
                                            row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                        }
                                        row["KQGQNoiBo"] += "</b>";
                                    }
                                    else
                                    {
                                        row["KQGQNoiBo"] = row["KQGQ_HINHSU_EX"] + "";
                                    }
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "2")
                                {
                                    row["KQGQNoiBo"] = "Xếp đơn <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GDQ_NGAY"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "3")
                                {
                                    row["KQGQNoiBo"] = "Xử lý khác <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "4")
                                {
                                    row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                    if (row["GDQ_SO"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                    }
                                    if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                    {
                                        row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                    }
                                    row["KQGQNoiBo"] += "</b>";
                                }
                                if (row["GQD_LOAIKETQUA"] + "" == "")
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                            else//--dan su mo rong
                            {
                                if (row["GQD_LOAIKETQUA"] + "" != "")
                                {
                                    if (row["KQGQ_DANSU_EX"] + "" == "")
                                    {
                                        //xử lý trong trường hợp Nhat Anh chưa insert dữ liệu--
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Trả lời đơn <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] = "Kháng nghị <b>";
                                                if (row["GDQ_SO"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                                }
                                                if (row["GDQ_NGAY"] + "" != "")
                                                {
                                                    row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                                }
                                                row["KQGQNoiBo"] += "</b>";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] = "Xếp đơn  <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GDQ_NGAY"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GDQ_NGAY"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] = "Xử lý khác <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] = "Thông báo VKS đang giải quyết <b>";
                                            if (row["GDQ_SO"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " số " + row["GDQ_SO"] + "";
                                            }
                                            if (row["GQD_NgayPhatHanhCV"] + "" != "")
                                            {
                                                row["KQGQNoiBo"] += " ngày " + String.Format("{0:dd/MM/yyyy}", row["GQD_NgayPhatHanhCV"]);
                                            }
                                            row["KQGQNoiBo"] += "</b>";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                    else
                                    {
                                        if (row["GQD_LOAIKETQUA"] + "" == "0")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "1")
                                        {
                                            if (row["loaidon"] + "" == "8" || row["loaidon"] + "" == "10")
                                            {
                                                row["KQGQNoiBo"] = "Không chấp nhận khiếu nại <b>";
                                                row["KQGQNoiBo"] += "</b>";
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                            else
                                            {
                                                row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                            }
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "2")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "3")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "4")
                                        {
                                            row["KQGQNoiBo"] += row["KQGQ_DANSU_EX"] + "";
                                        }
                                        if (row["GQD_LOAIKETQUA"] + "" == "5")
                                        {
                                            if (row["CD_TRANGTHAI"] + "" == "2")
                                            {
                                                row["KQGQNoiBo"] = "Đang giải quyết";
                                            }
                                        }

                                    }
                                }
                                else
                                {
                                    if (row["CD_TRANGTHAI"] + "" == "2")
                                    {
                                        row["KQGQNoiBo"] = "Đang giải quyết";
                                    }
                                }
                            }
                        }
                    }
                }
                return tbl;
            }
            catch (Exception ex)
            {
                DataTable tbl = new DataTable();
                tbl.Columns.Add("SQL", typeof(string));
                DataRow _row = tbl.NewRow();
                _row["SQL"] = ex.Message;
                tbl.Rows.Add(_row);
                return tbl;
            }
        }

    }
}