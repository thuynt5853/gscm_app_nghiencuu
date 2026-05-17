using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_PHUCTHAM_BL
    {
        public DataTable AHS_PHUCTHAM_HDXX_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVuAnID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PHUCTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_QD_BICAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PT_QD_BICAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_QD_VUAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PT_QD_VUAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PHUCTHAM_BANAN_CHITIET(decimal vVUANID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVUANID",vVUANID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PHUCTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable AHS_PT_KCQUAHAN(decimal DonViID, string MaVuAn, string TenVuAn, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuAn",MaVuAn),
                new OracleParameter("vTenVuAn",TenVuAn),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PT_KCQUAHAN", parameter);
            return tbl;
        }
        public DataTable AHS_RUTKN(decimal DonViID, string MaVuAn, string TenVuAn, string SoQD_BA, string TenBiCanBiCao, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuAn",MaVuAn),
                new OracleParameter("vTenVuAn",TenVuAn),
                new OracleParameter("vSoQD_BA",SoQD_BA),
                new OracleParameter("vTenBiCanBiCao",TenBiCanBiCao),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_RUTKN", parameter);
            return tbl;
        }
        public DataTable AHS_PT_KCKN_TinhTrang_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vVUANID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_HS.AHS_PT_KCKN_TinhTrang_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_BAQD_VUAN_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHS_PT_BAQD_VUAN_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_PT_QD_VUAN_KHONGKETTHUC_GETLIST(decimal vVuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHS_PT_QD_VUAN_GETLIST", parameters);
            return tbl;
        }
    }
}