using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.UTTP
{
    public class UYTHACTUPHAP_BL
    {
        public DataTable UYTHACTUPHAP_DEN_GETLIST(decimal vQuocGia, decimal vLoaiTimKiem,decimal vKetQuaUT,string vTuNgay,string vDenNgay,decimal vNguoiThucHienUT,string vNoidung,decimal vDonvi,decimal vPageIndex, decimal vPageSize=20)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vQuocGia",vQuocGia),
                                                                        new OracleParameter("vLoaiTimKiem",vLoaiTimKiem),
                                                                         new OracleParameter("vKetQuaUT",vKetQuaUT),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vNguoiThucHienUT",vNguoiThucHienUT),
                                                                        new OracleParameter("vNoidung",vNoidung),
                                                                        new OracleParameter("vDonvi",vDonvi),
                                                                        new OracleParameter("vPageIndex",vPageIndex),
                                                                        new OracleParameter("vPageSize",vPageSize),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("UYTHACTUPHAP_DEN_GETLIST", parameters);
            return tbl;
        }
        public DataTable GETUTTP_DI(string vDuongSu, string vSoThuLy, string vNgayThuLy, string vCapXetXu, string vLoaiAn, string vThuKy, string vThamPhan, string vVanBanUT, string vDonViUT, string vQuocGiaUT,string vloaiTimKiem, string vTuNgay, string vDenNgay, string vKetQuaUT,decimal vDonVi)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vDuongSu",vDuongSu),
                        new OracleParameter("vSoThuLy",vSoThuLy),
                        new OracleParameter("vNgayThuLy",vNgayThuLy),
                        new OracleParameter("vCapXetXu",vCapXetXu),
                        new OracleParameter("vLoaiAn",vLoaiAn),
                        new OracleParameter("vThuKy",vThuKy),
                        new OracleParameter("vThamPhan", vThamPhan),
                        new OracleParameter("vVanBanUT",vVanBanUT),
                        new OracleParameter("vDonViUT",vDonViUT),
                        new OracleParameter("vQuocGiaUT",vQuocGiaUT),
                        new OracleParameter("vloaiTimKiem",vloaiTimKiem),
                        new OracleParameter("vTuNgay",vTuNgay),
                        new OracleParameter("vDenNgay",vDenNgay),
                        new OracleParameter("vKetQuaUT",vKetQuaUT),
                        new OracleParameter("vDonVi", vDonVi),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("UYTHACTUPHAP.GETUTTP_DI", parameters);
            return tbl;
        }

        public DataTable GETUTTP_DI_INDANHSACH(string vDuongSu, string vSoThuLy, string vNgayThuLy, string vCapXetXu, string vLoaiAn, string vThuKy, string vThamPhan, string vVanBanUT, string vDonViUT, string vQuocGiaUT, string vloaiTimKiem, string vTuNgay, string vDenNgay, string vKetQuaUT, decimal vDonVi)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDuongSu",vDuongSu),
                        new OracleParameter("vSoThuLy",vSoThuLy),
                        new OracleParameter("vNgayThuLy",vNgayThuLy),
                        new OracleParameter("vCapXetXu",vCapXetXu),
                        new OracleParameter("vLoaiAn",vLoaiAn),
                        new OracleParameter("vThuKy",vThuKy),
                        new OracleParameter("vThamPhan", vThamPhan),
                        new OracleParameter("vVanBanUT",vVanBanUT),
                        new OracleParameter("vDonViUT",vDonViUT),
                        new OracleParameter("vQuocGiaUT",vQuocGiaUT),
                        new OracleParameter("vloaiTimKiem",vloaiTimKiem),
                        new OracleParameter("vTuNgay",vTuNgay),
                        new OracleParameter("vDenNgay",vDenNgay),
                        new OracleParameter("vKetQuaUT",vKetQuaUT),
                        new OracleParameter("vDonVi", vDonVi)
                         
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("UYTHACTUPHAP.GETUTTP_DI_INDANHSACH", parameters);
            return tbl;
        }

        public DataTable GETTHAMPHANTONGDAT(decimal vDonVi)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vDonVi", vDonVi),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("UYTHACTUPHAP.GETTHAMPHANTONGDAT", parameters);
            return tbl;
        }
        public DataTable GETTHUKYTONGDAT(decimal vDonVi)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("vDonVi", vDonVi),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("UYTHACTUPHAP.GETTHUKYTONGDAT", parameters);
            return tbl;
        }

        public DataTable UYTHACTUPHAP_DEN_INDANHSACH(decimal vQuocGia, decimal vLoaiTimKiem, decimal vKetQuaUT, string vTuNgay, string vDenNgay, decimal vNguoiThucHienUT)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                                                                        new OracleParameter("vQuocGia",vQuocGia),
                                                                        new OracleParameter("vLoaiTimKiem",vLoaiTimKiem),
                                                                         new OracleParameter("vKetQuaUT",vKetQuaUT),
                                                                        new OracleParameter("vTuNgay",vTuNgay),
                                                                        new OracleParameter("vDenNgay",vDenNgay),
                                                                        new OracleParameter("vNguoiThucHienUT",vNguoiThucHienUT)
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("UYTHACTUPHAP.UYTHACTUPHAP_DEN_INDANHSACH", parameters);
            return tbl;
        }
    }
}