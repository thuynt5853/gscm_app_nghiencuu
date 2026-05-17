using BL.GSTP.BANGSETGET.APS;
using BL.GSTP.BANGSETGET;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;

namespace BL.GSTP.APS
{
    public class APS_DON_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        /*public DataTable APS_DON_SEARCH(decimal vdonviID, string vMaVuViec, string vTenVuViec, DateTime? vNgayNhanTu, DateTime? vNgayNhanDen, decimal vLoaiQuanHe, decimal vQuanHePLID, decimal vSoThuTu, string vDuongSu, decimal vTrangThai, decimal vHinhThucNhanDon, decimal thamphan_id,decimal vThuKyID, decimal PhanCongTP, string V_UTTPDI, decimal vchecktk, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",vdonviID),
                                                                        new OracleParameter("vMaVuViec",vMaVuViec),
                                                                        new OracleParameter("vTenVuViec",vTenVuViec),
                                                                        new OracleParameter("vNgayNhanTu",vNgayNhanTu),
                                                                        new OracleParameter("vNgayNhanDen",vNgayNhanDen),
                                                                        new OracleParameter("vLoaiQuanHe",vLoaiQuanHe),
                                                                        new OracleParameter("vQuanHePLID",vQuanHePLID),
                                                                        new OracleParameter("vSoThuTu",vSoThuTu),
                                                                        new OracleParameter("vDuongSu",vDuongSu),
                                                                        new OracleParameter("vTrangThai",vTrangThai),
                                                                        new OracleParameter("vHinhThucNhanDon",vHinhThucNhanDon),
                                                                        new OracleParameter("thamphan_id",thamphan_id),
                                                                        new OracleParameter("vThuKyID",vThuKyID),
                                                                        new OracleParameter("PhanCongTP",PhanCongTP),
                                                                        new OracleParameter("V_UTTP",V_UTTPDI),
                                                                        new OracleParameter("vchecktk",vchecktk),
                                                                        new OracleParameter("Page_Index",PageIndex),
                                                                        new OracleParameter("Page_Size",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_APS_STPT_DS.APS_DON_SEARCH", parameters);
            return tbl;
        }*/
        public DataTable APS_DON_SEARCH(string CapXetXuLogin, string vDonViID, string vTenViec, string vLoaiHinhDoanhNghiep, string vMaViec, string vDuongSu_NguoiThamGiaToTung,
            string vCapXetXu, string vToaXetXu, string vTinhTrangThuLy, string vTuNgayThuLy, string vDenNgayThuLy,
            string vSoThuLy, string vTinhTrangGQ, string vTuNgayTinhTrangGQ, string vDenNgayTinhTrangGQ,
            string vThamPhan, string vThoiHanGQ, string vSoQD, string vNgayQD, string vThuKy, string vGQDon,
            string vUyThacTuPhap, string vPTRutKinhNghiem, decimal vchecktk, decimal V_CHECK_PTQDK, string V_VAITROTHAMPHAN_ID, decimal V_MA_THONG_BAO, decimal PageIndex, decimal PageSize)

        {
            vTenViec = vTenViec.Normalize(NormalizationForm.FormC);
            vMaViec = vMaViec.Normalize(NormalizationForm.FormC);
            vDuongSu_NguoiThamGiaToTung = vDuongSu_NguoiThamGiaToTung.Normalize(NormalizationForm.FormC);
            vSoThuLy = vSoThuLy.Normalize(NormalizationForm.FormC);
            vThamPhan = vThamPhan.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vThuKy = vThuKy.Normalize(NormalizationForm.FormC);
            decimal V_CHECK_HOAGIAI = 0;
            decimal V_TRANGTHAIVUAN = 0;
            if (V_CHECK_PTQDK == 0)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_CAP_XET_XU_LOGIN",CapXetXuLogin),
                new OracleParameter("vdonviID",vDonViID),
                new OracleParameter("vTenViec",vTenViec),
                new OracleParameter("vLoaiHinhDoanhNghiep",vLoaiHinhDoanhNghiep),
                new OracleParameter("vMaViec",vMaViec),
                new OracleParameter("vDuongSu_NguoiThamGiaToTung",vDuongSu_NguoiThamGiaToTung),
                new OracleParameter("vCapXetXu",vCapXetXu),
                new OracleParameter("vToaXetXu",vToaXetXu),
                new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                new OracleParameter("vSoThuLy",vSoThuLy),
                new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                new OracleParameter("vTuNgayTinhTrangGQ",vTuNgayTinhTrangGQ),
                new OracleParameter("vDenNgayTinhTrangGQ",vDenNgayTinhTrangGQ),
                new OracleParameter("vThamPhan",vThamPhan),
                new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                new OracleParameter("vSoQD",vSoQD),
                new OracleParameter("vNgayQD",vNgayQD),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vGQDon",vGQDon),
                new OracleParameter("vUyThacTuPhap",vUyThacTuPhap),
                new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                new OracleParameter("vchecktk",vchecktk),
                new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
                new OracleParameter("V_MA_THONG_BAO",V_MA_THONG_BAO),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_APS_STPT_DS.APS_DON_SEARCH", parameters);
                //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("VT_PKG_APS_STPT_DS.APS_DON_SEARCH", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_CapXetXuLogin",CapXetXuLogin),
                new OracleParameter("vdonviID",vDonViID),
                new OracleParameter("vTenViec",vTenViec),
                new OracleParameter("vLoaiHinhDoanhNghiep",vLoaiHinhDoanhNghiep),
                new OracleParameter("vMaViec",vMaViec),
                new OracleParameter("vDuongSu_NguoiThamGiaToTung",vDuongSu_NguoiThamGiaToTung),
                new OracleParameter("vCapXetXu",vCapXetXu),
                new OracleParameter("vToaXetXu",vToaXetXu),
                new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                new OracleParameter("vSoThuLy",vSoThuLy),
                new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                new OracleParameter("vTuNgayTinhTrangGQ",vTuNgayTinhTrangGQ),
                new OracleParameter("vDenNgayTinhTrangGQ",vDenNgayTinhTrangGQ),
                new OracleParameter("vThamPhan",vThamPhan),
                new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                new OracleParameter("vSoQD",vSoQD),
                new OracleParameter("vNgayQD",vNgayQD),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vGQDon",vGQDon),
                new OracleParameter("vUyThacTuPhap",vUyThacTuPhap),
                new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                new OracleParameter("vchecktk",vchecktk),
                new OracleParameter("V_TRANGTHAIVUAN",V_TRANGTHAIVUAN),
               new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_APS_GS.APS_DON_SEARCH", parameters);

                return tbl;
            }
        }


        public DataTable APS_DON_SEARCH_V2(string CapXetXuLogin, string vDonViID, string vTenViec, string vLoaiHinhDoanhNghiep, string vMaViec, string vDuongSu_NguoiThamGiaToTung,
            string vCapXetXu, string vToaXetXu, string vTinhTrangThuLy, string vTuNgayThuLy, string vDenNgayThuLy,
            string vSoThuLy, string vTinhTrangGQ, string vTuNgayTinhTrangGQ, string vDenNgayTinhTrangGQ,
            string vThamPhan, string vThoiHanGQ, string vSoQD, string vNgayQD, string vThuKy, string vGQDon,
            string vUyThacTuPhap, string vPTRutKinhNghiem, decimal vchecktk, decimal V_CHECK_PTQDK, string V_VAITROTHAMPHAN_ID, decimal V_MA_THONG_BAO, decimal PageIndex, decimal PageSize)

        {
            vTenViec = vTenViec.Normalize(NormalizationForm.FormC);
            vMaViec = vMaViec.Normalize(NormalizationForm.FormC);
            vDuongSu_NguoiThamGiaToTung = vDuongSu_NguoiThamGiaToTung.Normalize(NormalizationForm.FormC);
            vSoThuLy = vSoThuLy.Normalize(NormalizationForm.FormC);
            vThamPhan = vThamPhan.Normalize(NormalizationForm.FormC);
            vSoQD = vSoQD.Normalize(NormalizationForm.FormC);
            vThuKy = vThuKy.Normalize(NormalizationForm.FormC);
            decimal V_CHECK_HOAGIAI = 0;
            decimal V_TRANGTHAIVUAN = 0;
            if (V_CHECK_PTQDK == 0)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_CAP_XET_XU_LOGIN",CapXetXuLogin),
                new OracleParameter("vdonviID",vDonViID),
                new OracleParameter("vTenViec",vTenViec),
                new OracleParameter("vLoaiHinhDoanhNghiep",vLoaiHinhDoanhNghiep),
                new OracleParameter("vMaViec",vMaViec),
                new OracleParameter("vDuongSu_NguoiThamGiaToTung",vDuongSu_NguoiThamGiaToTung),
                new OracleParameter("vCapXetXu",vCapXetXu),
                new OracleParameter("vToaXetXu",vToaXetXu),
                new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                new OracleParameter("vSoThuLy",vSoThuLy),
                new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                new OracleParameter("vTuNgayTinhTrangGQ",vTuNgayTinhTrangGQ),
                new OracleParameter("vDenNgayTinhTrangGQ",vDenNgayTinhTrangGQ),
                new OracleParameter("vThamPhan",vThamPhan),
                new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                new OracleParameter("vSoQD",vSoQD),
                new OracleParameter("vNgayQD",vNgayQD),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vGQDon",vGQDon),
                new OracleParameter("vUyThacTuPhap",vUyThacTuPhap),
                new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                new OracleParameter("vchecktk",vchecktk),
                new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
                new OracleParameter("V_MA_THONG_BAO",V_MA_THONG_BAO),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_APS_STPT_DS.APS_DON_SEARCH_V2", parameters);
                //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("VT_PKG_APS_STPT_DS.APS_DON_SEARCH", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_CapXetXuLogin",CapXetXuLogin),
                new OracleParameter("vdonviID",vDonViID),
                new OracleParameter("vTenViec",vTenViec),
                new OracleParameter("vLoaiHinhDoanhNghiep",vLoaiHinhDoanhNghiep),
                new OracleParameter("vMaViec",vMaViec),
                new OracleParameter("vDuongSu_NguoiThamGiaToTung",vDuongSu_NguoiThamGiaToTung),
                new OracleParameter("vCapXetXu",vCapXetXu),
                new OracleParameter("vToaXetXu",vToaXetXu),
                new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                new OracleParameter("vSoThuLy",vSoThuLy),
                new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                new OracleParameter("vTuNgayTinhTrangGQ",vTuNgayTinhTrangGQ),
                new OracleParameter("vDenNgayTinhTrangGQ",vDenNgayTinhTrangGQ),
                new OracleParameter("vThamPhan",vThamPhan),
                new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                new OracleParameter("vSoQD",vSoQD),
                new OracleParameter("vNgayQD",vNgayQD),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vGQDon",vGQDon),
                new OracleParameter("vUyThacTuPhap",vUyThacTuPhap),
                new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                new OracleParameter("vchecktk",vchecktk),
                new OracleParameter("V_TRANGTHAIVUAN",V_TRANGTHAIVUAN),
               new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                new OracleParameter("V_CHECK_HOAGIAI",V_CHECK_HOAGIAI),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_APS_GS.APS_DON_SEARCH_V2", parameters);

                return tbl;
            }
        }

        public decimal GETNEWTT(decimal donviID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public decimal CHECKSTT_APS(decimal donviID, decimal vMaGiaiDoan, decimal vNam, decimal vLoaiFile, decimal vSTT, string vSTB_Phu, decimal vID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                        new OracleParameter("vMaGiaiDoan",vMaGiaiDoan),
                                                                        new OracleParameter("vNam",vNam),
                                                                        new OracleParameter("vLoaiFile",vLoaiFile),
                                                                        new OracleParameter("vSTT",vSTT),
                                                                        new OracleParameter("vSTB_Phu",vSTB_Phu),
                                                                        new OracleParameter("vID",vID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_PS.APS_FILE_CHECKSTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]);

        }

        public DataTable APS_DON_TGTT_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_TGTT_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_DON_BanGiaoTaiLieu_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDONID",vDONID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_BGTL_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_DON_BGTT_GETINFO(decimal vDONID, string NguoiGiao, decimal NguoiNhan, string NgayBanGiao)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("vNguoiGiao",NguoiGiao),
                                                                        new OracleParameter("vNguoiNhan",NguoiNhan),
                                                                        new OracleParameter("vNgayBanGiao",NgayBanGiao),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_BGTT_GETINFO", parameters);
            return tbl;
        }
        public DataTable APS_DON_GETTOAANBYVUVIEC(decimal vDonID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDONID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("APS_DON_GETTOAANBYVUVIEC", prm);
        }
        public DataTable APS_TONGDAT_DOITUONG_GETBY(decimal vDONID, decimal vTOAANID, decimal vBIEUMAUID, decimal vIsOnlyNKK)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vTOAANID",vTOAANID),
                                                                          new OracleParameter("vBIEUMAUID",vBIEUMAUID),
                                                                          new OracleParameter("vIsOnlyNKK",vIsOnlyNKK),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_TONGDAT_DOITUONG_GETBY", parameters);
            return tbl;
        }
        public DataTable APS_TONGDAT_GETLIST(decimal vDONID, decimal vToaAnID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_TONGDAT_GETLIST", parameters);
            return tbl;
        }
        public decimal GETFILENEWTT(decimal donviID, decimal vMaGiaiDoan, decimal vNam, decimal vLoaiFile)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                         new OracleParameter("vMaGiaiDoan",vMaGiaiDoan),
                                                                          new OracleParameter("vNam",vNam),
                                                                           new OracleParameter("vLoaiFile",vLoaiFile),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_FILE_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }

        public DataTable APS_FILE_TONGDAT(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_FILE_TONGDAT", parameters);
            return tbl;
        }
        public bool DELETE_ALLDATA_BY_VUANID(string donID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("in_VUANID", donID) };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GSTP_DELETE.DELETE_DATA_APS_BY_VUANID", parameters);
                return dbl == 1 ? true : false;
            }
            catch { return false; }
        }
        //Tamnc đã có thụ lý ko hủy được 
        public bool Check_ThuLy(decimal DonID)
        {
            APS_DON _don = dt.APS_DON.Where(x => x.ID == DonID).FirstOrDefault();
            if (_don != null)
            {
                if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || _don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO)
                {
                    APS_SOTHAM_THULY ObjThuLy = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {
                    APS_PHUCTHAM_THULY ObjThuLy = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
                else if (_don.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {
                    APS_KCKNQDK_PHUCTHAM_THULY ObjThuLy = DataExtensions.GetAllByDonId<APS_KCKNQDK_PHUCTHAM_THULY>(DonID).FirstOrDefault();
                    return ObjThuLy != null;
                }
            }
            return false;
        }
        public DataTable APS_ANPHI_GETBYDONID(decimal donID, int tinhTrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("V_TINHTRANG",tinhTrang),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_ANPHI_GETBYDONID", parameters);
            return tbl;
        }

        public DataTable APS_ANPHI_GETBYDONID_V2(decimal donID, int tinhTrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrDonID",donID),
                                                                        new OracleParameter("V_TINHTRANG",tinhTrang),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_APS.APS_DON_ANPHI_GETBYDONID_V2", parameters);
            return tbl;
        }

        public DataTable APS_DON_CON_SEARCH(decimal donIdGoc, string CapXetXuLogin, string vDonViID, string vTenViec, string vLoaiHinhDoanhNghiep, string vMaViec, string vDuongSu_NguoiThamGiaToTung,
           string vCapXetXu, string vToaXetXu, string vTinhTrangThuLy, string vTuNgayThuLy, string vDenNgayThuLy,
           string vSoThuLy, string vTinhTrangGQ, string vTuNgayTinhTrangGQ, string vDenNgayTinhTrangGQ,
           string vThamPhan, string vThoiHanGQ, string vSoQD, string vNgayQD, string vThuKy, string vGQDon,
           string vUyThacTuPhap, string vPTRutKinhNghiem, decimal vchecktk, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_DONID_GOC",donIdGoc),
                new OracleParameter("v_CapXetXuLogin",CapXetXuLogin),
                new OracleParameter("vdonviID",vDonViID),
                new OracleParameter("vTenViec",vTenViec),
                new OracleParameter("vLoaiHinhDoanhNghiep",vLoaiHinhDoanhNghiep),
                new OracleParameter("vMaViec",vMaViec),
                new OracleParameter("vDuongSu_NguoiThamGiaToTung",vDuongSu_NguoiThamGiaToTung),
                new OracleParameter("vCapXetXu",vCapXetXu),
                new OracleParameter("vToaXetXu",vToaXetXu),
                new OracleParameter("vTinhTrangThuLy",vTinhTrangThuLy),
                new OracleParameter("vTuNgayThuLy",vTuNgayThuLy),
                new OracleParameter("vDenNgayThuLy",vDenNgayThuLy),
                new OracleParameter("vSoThuLy",vSoThuLy),
                new OracleParameter("vTinhTrangGQ",vTinhTrangGQ),
                new OracleParameter("vTuNgayTinhTrangGQ",vTuNgayTinhTrangGQ),
                new OracleParameter("vDenNgayTinhTrangGQ",vDenNgayTinhTrangGQ),
                new OracleParameter("vThamPhan",vThamPhan),
                new OracleParameter("vThoiHanGQ",vThoiHanGQ),
                new OracleParameter("vSoQD",vSoQD),
                new OracleParameter("vNgayQD",vNgayQD),
                new OracleParameter("vThuKy",vThuKy),
                new OracleParameter("vGQDon",vGQDon),
                new OracleParameter("vUyThacTuPhap",vUyThacTuPhap),
                new OracleParameter("vPTRutKinhNghiem",vPTRutKinhNghiem),
                new OracleParameter("vchecktk",vchecktk),
                new OracleParameter("Page_Index",PageIndex),
                new OracleParameter("Page_Size",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            //DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_PS.APS_DON_SEARCH", parameters);
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("VT_PKG_STPT_DS.APS_DON_CON_SEARCH", parameters);
            return tbl;
        }

        public DataTable DON_NHAPTACH_SEARCH(string V_CAP_XET_XU_LOGIN, string V_TEN_VU_AN, string V_QHPL, string V_MA_VU_AN, string V_TENDUONGSU, string V_CAPXX, string V_TOAAN_ID, string V_TINHTRANG_THULY, string V_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string V_THAMPHAN_ID, string V_THUKY_ID, string V_LOAIDON, decimal trangThaiVuAn, decimal loaiAnID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TEN_VU_AN",V_TEN_VU_AN),
                        new OracleParameter("V_QHPL",V_QHPL),
                        new OracleParameter("V_MA_VU_AN",V_MA_VU_AN),
                        new OracleParameter("V_TENDUONGSU",V_TENDUONGSU),
                        new OracleParameter("V_CAPXX",V_CAPXX),
                        new OracleParameter("V_TOAAN_ID", V_TOAAN_ID),
                        new OracleParameter("V_TINHTRANG_THULY",V_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("V_SOTHULY",V_SOTHULY),
                        new OracleParameter("V_THAMPHAN_ID",V_THAMPHAN_ID),
                        new OracleParameter("V_THUKY_ID",V_THUKY_ID),
                        new OracleParameter("V_LOAIDON",V_LOAIDON),
                        new OracleParameter("V_TRANGTHAIVUAN",trangThaiVuAn),
                        new OracleParameter("V_LOAIANID", loaiAnID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_NHAP_TACH.ADS_DON_SEARCH", parameters);
            return tbl;
        }

        public void CAPNHAT_DON_GOC_ID(decimal donGocID, decimal donConID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_DonGocID",donGocID),
                        new OracleParameter("v_DonConID",donConID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            Cls_Comon.GetTableByProcedurePaging("PKG_STPT_NHAPAN.APS_UPDATE", parameters);
        }
        
        public decimal GET_STB_XLDon_NEW_V2(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                new OracleParameter("vdonviID",donviID),
                new OracleParameter("vFromDate",vFromDate),
                new OracleParameter("vToDate",vToDate),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STB_XLDON_GETMAXTT_V2", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
    }
}