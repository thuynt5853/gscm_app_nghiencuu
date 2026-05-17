using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
namespace BL.GSTP.ADS
{
    public class STPT_BAOCAO_BL
    {
        public DataTable Tong_hop_so_lieu_xx(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, string V_CAP_XET_XU_LOGIN, string v_toaan_id, string V_TUNGAY, string V_DENNGAY, string V_LOAIAN_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_BC.THSL_XX", parameters);
            return tbl;
        }
        //Thongke_HCTP
        public DataTable Thongke_HCTP(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, decimal donviID, string MaChucDanh, string V_TUNGAY, string V_DENNGAY, string V_LOAIAN_ID, string V_CAP_XET_XU_LOGIN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("vDonViID",donviID),
                        new OracleParameter("vChucDanh",MaChucDanh),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_BC.Thongke_HCTP", parameters);
            return tbl;
        }

        public DataTable Thongke_TTP(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, decimal vdonviID, decimal vThamphanId, string V_TUNGAY, string V_DENNGAY, string V_CAP_XET_XU_LOGIN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("vDonViID",vdonviID),
                        new OracleParameter("vThamphanId",vThamphanId),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_BC.Thongke_TTP", parameters);
            return tbl;
        }

        public DataTable Thongke_TLA(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, decimal vdonviID, string vLoaiAnId, string vtenloaian, string V_TUNGAY, string V_DENNGAY, string V_CAP_XET_XU_LOGIN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("vDonViID",vdonviID),
                        new OracleParameter("vLoaiAnId",vLoaiAnId),
                        new OracleParameter("vtenloaian",vtenloaian),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_BC.Thongke_TLA", parameters);
            return tbl;
        }

        public DataTable TL_XX_TRINHTU_PT_EXPORT(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, string V_CAP_XET_XU_LOGIN, string v_toaan_id, string V_TUNGAY, string V_DENNGAY, string V_LOAIAN_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_BC.TL_XX_TRINHTU_PT", parameters);
            return tbl;
        }
        // VNPT 27-01-2026
        public DataTable TK_CACTOA_CHUYENTRACH(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, string V_CAP_XET_XU_LOGIN, string v_toaan_id, string V_TUNGAY, string V_DENNGAY, decimal vPhongBanId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_PHONGBAN_ID",OracleDbType.Decimal) { Value = vPhongBanId }
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAOCAOTHONGKE.TK_CACTOA_CHUYENTRACH", parameters);
            return tbl;
        }
        public DataTable TK_CACTOA_CHUYENTRACH_THEO_THAMPHAN(string V_CANBO_TK_ID, string V_LANHDAO_TK_ID, string V_CAP_XET_XU_LOGIN, string v_toaan_id, string V_TUNGAY, string V_DENNGAY, decimal vThamphanId, decimal vPhongBanId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CANBO_TK_ID",V_CANBO_TK_ID),
                        new OracleParameter("V_LANHDAO_TK_ID",V_LANHDAO_TK_ID),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("V_THAMPHAN_ID",OracleDbType.Decimal) { Value = vThamphanId },
                        new OracleParameter("V_PHONGBAN_ID",OracleDbType.Decimal) { Value = vPhongBanId }
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAOCAOTHONGKE.TK_CACTOA_CHUYENTRACH_TP", parameters);
            return tbl;
        }
        // Thống kê số liệu các loại án theo thẩm phán VNPT //vnpt_8/1/2026
        public DataTable TK_LOAIAN_THAMPHAN(string v_toaan_id, string V_TUNGAY, string V_DENNGAY, string V_CANBO_ID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor", OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("P_TOAAN_ID", OracleDbType.Varchar2) { Value = v_toaan_id },
                new OracleParameter("P_TUNGAY", OracleDbType.Varchar2) { Value = V_TUNGAY },
                new OracleParameter("P_DENNGAY", OracleDbType.Varchar2) { Value = V_DENNGAY },
                new OracleParameter("P_CANBO_ID", OracleDbType.Decimal) { Value = string.IsNullOrEmpty(V_CANBO_ID) ? 0 : Convert.ToDecimal(V_CANBO_ID) }
            };

            return Cls_Comon.GetTableByProcedurePaging(
                "PKG_BAOCAOTHONGKE.TK_LOAIAN_THAMPHAN_CURSOR",
                parameters
            );
        }
        // Báo cáo tổng hợp  - trả về HTML (TEXT_REPORT)
        public DataTable TK_TONG_HOP_FULL(string v_toaan_id, string V_TUNGAY, string V_DENNGAY, decimal? vThamPhanId, decimal? vPhongBanId)
        {
            string sql = "SELECT PKG_BAOCAOTHONGKE.TK_BAO_CAO_TONG_HOP_FULL(:P_TOAAN_ID, :P_TUNGAY, :P_DENNGAY, :P_THAMPHAN_ID, :P_PHONGBAN_ID) AS TEXT_REPORT FROM DUAL";
            List<OracleParameter> parameters = new List<OracleParameter>
            {
                new OracleParameter("P_TOAAN_ID", v_toaan_id),
                new OracleParameter("P_TUNGAY", V_TUNGAY),
                new OracleParameter("P_DENNGAY", V_DENNGAY),
                new OracleParameter("P_THAMPHAN_ID", OracleDbType.Decimal) { Value = (object)vThamPhanId ?? DBNull.Value },
                new OracleParameter("P_PHONGBAN_ID", OracleDbType.Decimal) { Value = (object)vPhongBanId ?? DBNull.Value }
            };
            return Cls_Comon.GetTableToSQL(sql, parameters);
        }

        //END VNPT

        //
        //Bao cao tinh hinh nhap lieu 
        public DataTable Tong_hop_so_lieu_nhaplieu(decimal v_curr_id, string v_TINHTRANG_THULY, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_TOAANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", v_curr_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_TOAANID",v_TOAANID)
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_ALL.NHAPLIEU_HS_DS_EXT_ALL", parameters);
            return tbl;
        }
        public DataTable Tong_hop_so_lieu_nhaplieu2(decimal v_curr_id, string v_TINHTRANG_THULY, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_TOAANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", v_curr_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_TOAANID",v_TOAANID)
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_ALL.NHAPLIEU_HS_DS_EXT_ALL_V2", parameters);
            return tbl;
        }
        public DataTable Tong_hop_so_lieu_nhaplieu_TC(decimal v_curr_id, string v_TINHTRANG_THULY, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_TOAANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("vDonViID", v_curr_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_TOAANID",v_TOAANID)
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_SEARCH_ALL.NHAPLIEU_HS_DS_EXT_ALL_V2_TOICAO", parameters);
            return tbl;
        }
    }
}