using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.DONCHOXULY
{
    public class DON_CHO_XU_LY_BL
    {
        public DataTable Get_Don_ChoXuLy(decimal toaan_id, string NguonDen, string NguoiGuiDon, string vLoaian, string SoLuongDon, string LoaiDon, string NoiDungDon, string SoDenTu, string Den, string LoaiNgay, string TuNgay, string DenNgay, string TrangThaiXuLy, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("v_toaan_id",toaan_id),
                new OracleParameter("vNguonDen",NguonDen),
                new OracleParameter("vNguoiGuiDon",NguoiGuiDon),
                new OracleParameter("vLoaian",vLoaian),
                new OracleParameter("vSoLuongDon",SoLuongDon),
                new OracleParameter("vLoaiDon",LoaiDon),
                new OracleParameter("vNoiDungDon",NoiDungDon),
                new OracleParameter("vSoDenTu",SoDenTu),
                new OracleParameter("vDen",Den),
                new OracleParameter("vLoaiNgay",LoaiNgay),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThaiXuLy),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY", parameter);
            return tbl;
        }

        public DataTable Get_Don_ChoXuLy_LichSu(decimal donID, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonID",donID),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_LICHSU", parameter);
            return tbl;
        }

        public DataTable Get_Don_ChoXuLy_GhepDon(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string loaiAn, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, decimal loaiDon, int PageIndex, int PageSize)
        {
            DataTable tbl = new DataTable();
            if (loaiAn == "2")
            {
                tbl = Get_Don_ChoXuLy_GhepDon_ADS(V_CAP_XET_XU_LOGIN, V_TOAAN_ID, maVuViec, tenVuViec, nguoiKhoiKien, soCMND, namSinh, nguoiBiKien, noiDungKK, soThuLy, ngayThuLyTu, ngayThuLyDen, soQD, ngayBATu, ngayBADen, loaiDon, PageIndex, PageSize);
            }
            else if (loaiAn == "3")
            {
                tbl = Get_Don_ChoXuLy_GhepDon_AHN(V_CAP_XET_XU_LOGIN, V_TOAAN_ID, maVuViec, tenVuViec, nguoiKhoiKien, soCMND, namSinh, nguoiBiKien, noiDungKK, soThuLy, ngayThuLyTu, ngayThuLyDen, soQD, ngayBATu, ngayBADen, loaiDon, PageIndex, PageSize);
            }
            else if (loaiAn == "4")
            {
                tbl = Get_Don_ChoXuLy_GhepDon_AKT(V_CAP_XET_XU_LOGIN, V_TOAAN_ID, maVuViec, tenVuViec, nguoiKhoiKien, soCMND, namSinh, nguoiBiKien, noiDungKK, soThuLy, ngayThuLyTu, ngayThuLyDen, soQD, ngayBATu, ngayBADen, loaiDon, PageIndex, PageSize);
            }
            else if (loaiAn == "5")
            {
                tbl = Get_Don_ChoXuLy_GhepDon_ALD(V_CAP_XET_XU_LOGIN, V_TOAAN_ID, maVuViec, tenVuViec, nguoiKhoiKien, soCMND, namSinh, nguoiBiKien, noiDungKK, soThuLy, ngayThuLyTu, ngayThuLyDen, soQD, ngayBATu, ngayBADen, loaiDon, PageIndex, PageSize);
            }
            else if (loaiAn == "6")
            {
                tbl = Get_Don_ChoXuLy_GhepDon_AHC(V_CAP_XET_XU_LOGIN, V_TOAAN_ID, maVuViec, tenVuViec, nguoiKhoiKien, soCMND, namSinh, nguoiBiKien, noiDungKK, soThuLy, ngayThuLyTu, ngayThuLyDen, soQD, ngayBATu, ngayBADen, loaiDon, PageIndex, PageSize);
            }
            return tbl;
        }
        //AHS
        public DataTable Get_Don_ChoXuLy_GhepDon_AHS(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string tenVuAn, string maVuAn, string biCan, string soCMND, string namSinh, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("v_ten_vu_an",tenVuAn),
                new OracleParameter("v_ma_vu_an",maVuAn),
                new OracleParameter("v_bi_can",biCan),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("v_SOTHULY",soThuLy),
                new OracleParameter("V_NGAYTHULY_TU",ngayThuLyTu),
                new OracleParameter("V_NGAYTHULY_DEN",ngayThuLyDen),
                new OracleParameter("v_so_qd",soQD),
                new OracleParameter("V_NGAYBA_TU",ngayBATu),
                new OracleParameter("V_NGAYBA_DEN",ngayBADen),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_AHS", parameter);
            return tbl;
        }
        //ADS
        public DataTable Get_Don_ChoXuLy_GhepDon_ADS(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, decimal loaiDon, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("vMaVuViec",maVuViec),
                new OracleParameter("vTenVuViec",tenVuViec),
                new OracleParameter("vNguoiKhoiKien",nguoiKhoiKien),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("vNguoiBiKien",nguoiBiKien),
                new OracleParameter("vNoiDungKK",noiDungKK),
                new OracleParameter("v_SOTHULY",soThuLy),
                new OracleParameter("V_NGAYTHULY_TU",ngayThuLyTu),
                new OracleParameter("V_NGAYTHULY_DEN",ngayThuLyDen),
                new OracleParameter("v_so_qd",soQD),
                new OracleParameter("V_NGAYBA_TU",ngayBATu),
                new OracleParameter("V_NGAYBA_DEN",ngayBADen),
                new OracleParameter("v_LOAIDON", loaiDon),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_ADS", parameter);
            return tbl;
        }
        //AHN
        public DataTable Get_Don_ChoXuLy_GhepDon_AHN(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, decimal loaiDon, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("vMaVuViec",maVuViec),
                new OracleParameter("vTenVuViec",tenVuViec),
                new OracleParameter("vNguoiKhoiKien",nguoiKhoiKien),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("vNguoiBiKien",nguoiBiKien),
                new OracleParameter("vNoiDungKK",noiDungKK),
                new OracleParameter("v_SOTHULY",soThuLy),
                new OracleParameter("V_NGAYTHULY_TU",ngayThuLyTu),
                new OracleParameter("V_NGAYTHULY_DEN",ngayThuLyDen),
                new OracleParameter("v_so_qd",soQD),
                new OracleParameter("V_NGAYBA_TU",ngayBATu),
                new OracleParameter("V_NGAYBA_DEN",ngayBADen),
                new OracleParameter("v_LOAIDON", loaiDon),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_AHN", parameter);
            return tbl;
        }
        //AKT
        public DataTable Get_Don_ChoXuLy_GhepDon_AKT(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, decimal loaiDon, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("vMaVuViec",maVuViec),
                new OracleParameter("vTenVuViec",tenVuViec),
                new OracleParameter("vNguoiKhoiKien",nguoiKhoiKien),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("vNguoiBiKien",nguoiBiKien),
                new OracleParameter("vNoiDungKK",noiDungKK),
                new OracleParameter("v_SOTHULY",soThuLy),
                new OracleParameter("V_NGAYTHULY_TU",ngayThuLyTu),
                new OracleParameter("V_NGAYTHULY_DEN",ngayThuLyDen),
                new OracleParameter("v_so_qd",soQD),
                new OracleParameter("V_NGAYBA_TU",ngayBATu),
                new OracleParameter("V_NGAYBA_DEN",ngayBADen),
                new OracleParameter("v_LOAIDON", loaiDon),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_AKT", parameter);
            return tbl;
        }
        //ALD
        public DataTable Get_Don_ChoXuLy_GhepDon_ALD(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, decimal loaiDon, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("vMaVuViec",maVuViec),
                new OracleParameter("vTenVuViec",tenVuViec),
                new OracleParameter("vNguoiKhoiKien",nguoiKhoiKien),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("vNguoiBiKien",nguoiBiKien),
                new OracleParameter("vNoiDungKK",noiDungKK),
                new OracleParameter("v_SOTHULY",soThuLy),
                new OracleParameter("V_NGAYTHULY_TU",ngayThuLyTu),
                new OracleParameter("V_NGAYTHULY_DEN",ngayThuLyDen),
                new OracleParameter("v_so_qd",soQD),
                new OracleParameter("V_NGAYBA_TU",ngayBATu),
                new OracleParameter("V_NGAYBA_DEN",ngayBADen),
                new OracleParameter("v_LOAIDON", loaiDon),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_ALD", parameter);
            return tbl;
        }
        //AHC
        public DataTable Get_Don_ChoXuLy_GhepDon_AHC(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, string soThuLy, string ngayThuLyTu, string ngayThuLyDen, string soQD, string ngayBATu, string ngayBADen, decimal loaiDon, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("vMaVuViec",maVuViec),
                new OracleParameter("vTenVuViec",tenVuViec),
                new OracleParameter("vNguoiKhoiKien",nguoiKhoiKien),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("vNguoiBiKien",nguoiBiKien),
                new OracleParameter("vNoiDungKK",noiDungKK),
                new OracleParameter("v_SOTHULY",soThuLy),
                new OracleParameter("V_NGAYTHULY_TU",ngayThuLyTu),
                new OracleParameter("V_NGAYTHULY_DEN",ngayThuLyDen),
                new OracleParameter("v_so_qd",soQD),
                new OracleParameter("V_NGAYBA_TU",ngayBATu),
                new OracleParameter("V_NGAYBA_DEN",ngayBADen),
                new OracleParameter("v_LOAIDON", loaiDon),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_AHC", parameter);
            return tbl;
        }
        //APS
        public DataTable Get_Don_ChoXuLy_GhepDon_APS(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string maVuViec, string tenVuViec, string nguoiKhoiKien, string soCMND, string namSinh, string nguoiBiKien, string noiDungKK, decimal loaiDon, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                new OracleParameter("v_toaan_id",V_TOAAN_ID),
                new OracleParameter("vMaVuViec",maVuViec),
                new OracleParameter("vTenVuViec",tenVuViec),
                new OracleParameter("vNguoiKhoiKien",nguoiKhoiKien),
                new OracleParameter("vSoCMND",soCMND),
                new OracleParameter("vNamSinh",namSinh),
                new OracleParameter("vNguoiBiKien",nguoiBiKien),
                new OracleParameter("vNoiDungKK",noiDungKK),
                new OracleParameter("v_LOAIDON", loaiDon),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DONCHOXL.GET_DON_CHOXULY_GHEPDON_APS", parameter);
            return tbl;
        }
    }
}