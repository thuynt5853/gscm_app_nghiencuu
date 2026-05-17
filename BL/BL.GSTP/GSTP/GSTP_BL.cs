using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.GSTP
{
    public class GSTP_BL
    {
        public DataTable GetThamPhan_DangCongTac(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_DANGCONGTAC", prm);
        }
        public DataTable GetThamPhan_BoNhiemMoi(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_BONHIEMMOI", prm);
        }
        public DataTable GetThamPhan_SapHetNhiemKy(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_SAPHETNHIEMKY", prm);
        }
        public DataTable GetThamPhan_DungXetXu(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_DUNGXETXU", prm);
        }
        public DataTable GetThamPhan_AnHuy(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_ANHUY", prm);
        }
        public DataTable GetThamPhan_AnSua(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_ANSUA", prm);
        }
        public DataTable GetThamPhan_AnQuaHan(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_ANQUAHAN", prm);
        }
        public DataTable GetThamPhan_AnTreo(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_ANTREO", prm);
        }
        public DataTable GetThamPhan_AnTamDinhChi(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_ANTAMDINHCHI", prm);
        }
        public DataTable GetThamPhan_AnDinhChi(decimal vDonViID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GETTHAMPHAN_ANDINHCHI", prm);
        }
        public DataTable GetThamPhan_AnBPTT(decimal vDonViID, int vIsTrongNam, int vThang, int vNam, int vPageIndex, int vPageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("vIsTrongNam",vIsTrongNam),
                new OracleParameter("vThang",vThang),
                new OracleParameter("vNam",vNam),
                new OracleParameter("vPageIndex",vPageIndex),
                new OracleParameter("vPageSize",vPageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_ANBPTT", prm);
        }
        public DataTable GSTP_THONGTIN_CHITIET_TP(decimal TPID)
        {
            OracleParameter[] prm = new OracleParameter[]
           {
                new OracleParameter("in_THAMPHANID",TPID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
           };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_THONGTIN_CHITIET_TP", prm);
        }
        public DataTable GetDanhSachAnHuy(decimal vDonViID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANHUY", prm);
        }
        public DataTable DANHGIA_ANSUAHUY_OFTP(decimal TPID, string vTenVuAn, string vMaVuAn, string vAnSuaHuy, string vSoQDBA, string vNgayQDBA, string vLoaiAn, string vTrangThai)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vMaVuAn",vMaVuAn),
                new OracleParameter("vAnSuaHuy",vAnSuaHuy),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vTrangThai",vTrangThai),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DANHGIA_ANSUAHUY_OFTP", prm);
        }
        public DataTable DS_AN_DAGIAIQUYET_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_DAGIAIQUYET_BYTP", prm);
        }
        public DataTable DS_AN_KHANGCAO_KHANGNGHI_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_KHANGCAO_KHANGNGHI_BYTP", prm);
        }
        public DataTable DS_ANDC_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANDC_BYTP", prm);
        }
        public DataTable DS_AN_APDUNGANLE_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_APDUNGANLE_BYTP", prm);
        }
        public DataTable DS_AN_HOAGIAI_DOITHOAI_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_HOAGIAI_DOITHOAI_BYTP", prm);
        }
        public DataTable DS_ANTDC_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANTDC_BYTP", prm);
        }
        public DataTable DS_ANTREO_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANTREO_BYTP", prm);
        }
        public DataTable DS_AN_TOCHUC_PTRKN_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_TOCHUC_PTRKN_BYTP", prm);
        }
        public DataTable DS_AN_VIPHAM_TAMGIAM_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_VIPHAM_TAMGIAM_BYTP", prm);
        }
        public DataTable DS_ANSUA_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANSUA_BYTP", prm);
        }
        public DataTable DS_ANSUA_CHUQUAN_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANSUA_CHUQUAN_BYTP", prm);
        }
        public DataTable DS_ANHUY_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANHUY_BYTP", prm);
        }
        public DataTable DS_ANHUY_CHUQUAN_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANHUY_CHUQUAN_BYTP", prm);
        }
        public DataTable DS_ANBIENPHAPTAMTHOI_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANBIENPHAPTAMTHOI_BYTP", prm);
        }
        public DataTable DS_ANQUAHAN_BYTP(decimal TPID, string vTenVuAn, string vSoQDBA, DateTime? vNgayQDBA)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vTenVuAn",vTenVuAn),
                new OracleParameter("vSoQDBA",vSoQDBA),
                new OracleParameter("vNgayQDBA",vNgayQDBA),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_ANQUAHAN_BYTP", prm);
        }
        public DataTable DS_VUAN_OF_ThamPhan_BY_VAITRO_PLUS(decimal TPID, string VaiTro, string TenVuAn, DateTime? TuNgay, DateTime? DenNgay, int vGetAll)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vThamPhanID",TPID),
                new OracleParameter("vVaiTro",VaiTro),
                new OracleParameter("vTenVuAn",TenVuAn),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vGetAll",vGetAll),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_AN_OFTP_BY_VAITRO_PLUS", prm);
        }
        public DataTable DS_THAMPHAN_BYTOAAN(decimal DonViLogin, decimal DonViID, string TenThamPhan, string NgaySinh, decimal ChucDanhID, string VaiTro, DateTime? NgayPCTuNgay, DateTime? NgayPCDenNgay, string SaphetNhiemKy, string KhieuNai, string KyLuat, string AnBiHuy, string AnApDungBPTT, string AnDinhChi, string AnTamDinhChi, string AnQuaHan, string AnBiSua, string AnTreo, int PageIndex, int PageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViLogin",DonViLogin),
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vTenThamPhan",TenThamPhan),
                new OracleParameter("vNgaySinh",NgaySinh),
                new OracleParameter("vChucDanhID",ChucDanhID),
                new OracleParameter("vVaiTro",VaiTro),
                new OracleParameter("vNgayPCTuNgay",NgayPCTuNgay),
                new OracleParameter("vNgayPCDenNgay",NgayPCDenNgay),
                new OracleParameter("vSapHetNhiemKy",SaphetNhiemKy),
                new OracleParameter("vKhieuNai",KhieuNai),
                new OracleParameter("vKyLuat",KyLuat),
                new OracleParameter("vAnBiHuy",AnBiHuy),
                new OracleParameter("vAnApDungBPTT",AnApDungBPTT),
                new OracleParameter("vAnDinhChi",AnDinhChi),
                new OracleParameter("vAnTamDinhChi",AnTamDinhChi),
                new OracleParameter("vAnQuaHan",AnQuaHan),
                new OracleParameter("vAnBiSua",AnBiSua),
                new OracleParameter("vAnTreo",AnTreo),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.DS_THAMPHAN_BYTOAAN", prm);
        }
        public DataTable GDTTT_ThongKeChung(decimal DonViLoginID, DateTime vHienTai_TuNgay, DateTime vHienTai_DenNgay, DateTime vTruoc_TuNgay, DateTime vTruoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAn",DonViLoginID),
                new OracleParameter("vHienTai_TuNgay",vHienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",vHienTai_DenNgay),
                new OracleParameter("vTruoc_TuNgay",vTruoc_TuNgay),
                new OracleParameter("vTruoc_DenNgay",vTruoc_DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("GDTTT_ThongKeChung", prm);
        }
        public DataTable GSTP_HOME_THAMPHAN(decimal vDonViID, string CapToa, DateTime TuNgay, DateTime DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",vDonViID),
                new OracleParameter("inCapToa",CapToa),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_THAMPHAN", prm);
        }
        public DataTable GSTP_HOME_CongBoBAQD(decimal vDonViID, string CapToa)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",vDonViID),
                new OracleParameter("inCapToa",CapToa),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_CONGBOBAQD", prm);
        }
        public DataTable THONGKE_TP_HOMEPAGE(decimal vDonViID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("in_DonViID",vDonViID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_HOMEPAGE", prm);
        }
        public DataTable ThongKe_TP_3Nam_3TieuChi(decimal vDonViID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("in_DonViID",vDonViID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_TP_3NAM_3TIEUCHI", prm);
        }
        public DataTable THONGKE_AN_HOMEPAGE(decimal vDonViID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vDonViID",vDonViID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_AN_HOMEPAGE", prm);
        }
        public DataTable GSTP_HOME_MAP(decimal DonViLogin, DateTime HienTai_TuNgay, DateTime HienTai_DenNgay, DateTime Truoc_TuNgay, DateTime Truoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("in_DonViLogin",DonViLogin),
                new OracleParameter("inHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("inHienTai_DenNgay",HienTai_DenNgay),
                new OracleParameter("inTruoc_TuNgay",Truoc_TuNgay),
                new OracleParameter("inTruoc_DenNgay",Truoc_DenNgay),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_MAP", prm);
        }
        public DataTable THONGKE_AN_BANDO_VN(decimal DonViLogin, string CapToa, DateTime HienTai_TuNgay, DateTime HienTai_DenNgay, DateTime Truoc_TuNgay, DateTime Truoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("in_DonViLogin",DonViLogin),
                new OracleParameter("in_CAPTOA",CapToa),
                new OracleParameter("vHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",HienTai_DenNgay),
                new OracleParameter("vTruoc_TuNgay",Truoc_TuNgay),
                new OracleParameter("vTruoc_DenNgay",Truoc_DenNgay),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.THONGKE_AN_BANDO_VN", prm);
        }
        public DataTable REPORT_SOLUONG_TP(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, decimal vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string vNgayBaiNhiem, string LoaiAn_HS, string LoaiAn_DS, string LoaiAn_HC, string LoaiAn_HN, string LoaiAn_KT,
            string LoaiAn_LD, string LoaiAn_PS, string LoaiAn_XLHC, decimal vTinhTrang, decimal vGomDonViCapDuoi)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                 new OracleParameter("vNgayBaiNhiem",vNgayBaiNhiem),
                 new OracleParameter("vLoaiAn_HS",LoaiAn_HS),
                 new OracleParameter("vLoaiAn_DS",LoaiAn_DS),
                 new OracleParameter("vLoaiAn_HC",LoaiAn_HC),
                 new OracleParameter("vLoaiAn_HN",LoaiAn_HN),
                 new OracleParameter("vLoaiAn_KT",LoaiAn_KT),
                 new OracleParameter("vLoaiAn_LD",LoaiAn_LD),
                 new OracleParameter("vLoaiAn_PS",LoaiAn_PS),
                 new OracleParameter("vLoaiAn_XLHC",LoaiAn_XLHC),
                 new OracleParameter("vTinhTrang",vTinhTrang),
                 new OracleParameter("vGomDonViCapDuoi",vGomDonViCapDuoi),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANHUY(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, decimal vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string LoaiAn_HS, string LoaiAn_DS, string LoaiAn_HC, string LoaiAn_HN, string LoaiAn_KT,
            string LoaiAn_LD, string LoaiAn_PS, string LoaiAn_XLHC, decimal vGomDonViCapDuoi)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                 new OracleParameter("vLoaiAn_HS",LoaiAn_HS),
                 new OracleParameter("vLoaiAn_DS",LoaiAn_DS),
                 new OracleParameter("vLoaiAn_HC",LoaiAn_HC),
                 new OracleParameter("vLoaiAn_HN",LoaiAn_HN),
                 new OracleParameter("vLoaiAn_KT",LoaiAn_KT),
                 new OracleParameter("vLoaiAn_LD",LoaiAn_LD),
                 new OracleParameter("vLoaiAn_PS",LoaiAn_PS),
                 new OracleParameter("vLoaiAn_XLHC",LoaiAn_XLHC),
                 new OracleParameter("vGomDonViCapDuoi",vGomDonViCapDuoi),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANHUY", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANSUA(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, string vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string vLoaiAn)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                 new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANSUA", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANQUAHAN(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, string vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string vLoaiAn)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                 new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANQUAHAN", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANBPTT(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, string vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string vLoaiAn)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                 new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANBPTT", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANTREO(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, string vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem, string vNgayKetThuc)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANTREO", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANTDC(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, string vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string vLoaiAn)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANTDC", prm);
        }
        public DataTable REPORT_SOLUONG_TP_ANDC(decimal vToaAnID, string vMaTP, string vTenTP, string vDiaChi, string vGioiTinh, string vSoCMND,
            string vNgaySinh, string vSoDienThoai, decimal vChucDanh, decimal vChucVu, string vNgayNhanCT, string vNgayBoNhiem,
            string vNgayKetThuc, string vLoaiAn)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                 new OracleParameter("vMaTP",vMaTP),
                 new OracleParameter("vTenTP",vTenTP),
                 new OracleParameter("vDiaChi",vDiaChi),
                 new OracleParameter("vGioiTinh",vGioiTinh),
                 new OracleParameter("vSoCMND",vSoCMND),
                 new OracleParameter("vNgaySinh",vNgaySinh),
                 new OracleParameter("vSoDienThoai",vSoDienThoai),
                 new OracleParameter("vChucDanh",vChucDanh),
                 new OracleParameter("vChucVu",vChucVu),
                 new OracleParameter("vNgayNhanCT",vNgayNhanCT),
                 new OracleParameter("vNgayBoNhiem",vNgayBoNhiem),
                 new OracleParameter("vNgayKetThuc",vNgayKetThuc),
                 new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.REPORT_SOLUONG_TP_ANDC", prm);
        }
        public DataTable ThongKe_DS_An(string Procedure_Name, OracleParameter[] prm)
        {
            return Cls_Comon.GetTableByProcedurePaging(Procedure_Name, prm);
        }
        public DataTable FUN_GSTP_HOME_ST(decimal ToaAnID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay, DateTime Truoc_TuNgay, DateTime Truoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("inCapToa",CapToa),
                new OracleParameter("vHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",Hientai_DenNgay),
                new OracleParameter("vTruoc_TuNgay",Truoc_TuNgay),
                new OracleParameter("vTruoc_DenNgay",Truoc_DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_ST", prm);
        }
        public DataTable FUN_GSTP_HOME_PT(decimal ToaAnID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay, DateTime Truoc_TuNgay, DateTime Truoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("inCapToa",CapToa),
                new OracleParameter("vHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",Hientai_DenNgay),
                new OracleParameter("vTruoc_TuNgay",Truoc_TuNgay),
                new OracleParameter("vTruoc_DenNgay",Truoc_DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.FUN_GSTP_HOME_PT", prm);
        }
        public DataTable GSTP_HOME_ST(decimal ToaAnID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay, DateTime Truoc_TuNgay, DateTime Truoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("inCapToa",CapToa),
                new OracleParameter("vHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",Hientai_DenNgay),
                new OracleParameter("vTruoc_TuNgay",Truoc_TuNgay),
                new OracleParameter("vTruoc_DenNgay",Truoc_DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_ST", prm);
        }
        public DataTable GSTP_HOME_PT(decimal ToaAnID, string CapToa, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay, DateTime Truoc_TuNgay, DateTime Truoc_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("inCapToa",CapToa),
                new OracleParameter("vHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",Hientai_DenNgay),
                new OracleParameter("vTruoc_TuNgay",Truoc_TuNgay),
                new OracleParameter("vTruoc_DenNgay",Truoc_DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_PT", prm);
        }
        public DataTable GSTP_HOME_GDT(decimal ToaAnID, DateTime HienTai_TuNgay, DateTime Hientai_DenNgay)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("vHienTai_TuNgay",HienTai_TuNgay),
                new OracleParameter("vHienTai_DenNgay",Hientai_DenNgay),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_HOME_GDT", prm);
        }
        public DataTable GSTP_PAGE2_SOTHAM_HINHSU(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_SOTHAM_HINHSU", prm);
        }
        public DataTable GSTP_PAGE2_SOTHAM_DANSU(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_SOTHAM_DANSU", prm);
        }
        public DataTable GSTP_PAGE2_SOTHAM_HNGD(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_SOTHAM_HNGD", prm);
        }
        public DataTable GSTP_PAGE2_SOTHAM_KINHTE(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_SOTHAM_KINHTE", prm);
        }
        public DataTable GSTP_PAGE2_SOTHAM_HANHCHINH(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_SOTHAM_HANHCHINH", prm);
        }
        public DataTable GSTP_PAGE2_SOTHAM_LAODONG(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_SOTHAM_LAODONG", prm);
        }
        public DataTable GSTP_PAGE2_PHUCTHAM_HINHSU(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_PHUCTHAM_HINHSU", prm);
        }
        public DataTable GSTP_PAGE2_PHUCTHAM_DANSU(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_PHUCTHAM_DANSU", prm);
        }
        public DataTable GSTP_PAGE2_PHUCTHAM_HNGD(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_PHUCTHAM_HNGD", prm);
        }
        public DataTable GSTP_PAGE2_PHUCTHAM_KINHTE(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_PHUCTHAM_KINHTE", prm);
        }
        public DataTable GSTP_PAGE2_PHUCTHAM_HANHCHINH(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_PHUCTHAM_HANHCHINH", prm);
        }
        public DataTable GSTP_PAGE2_PHUCTHAM_LAODONG(decimal ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("inToaAnID",ToaAnID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GSTP.GSTP_PAGE2_PHUCTHAM_LAODONG", prm);
        }
    }
}