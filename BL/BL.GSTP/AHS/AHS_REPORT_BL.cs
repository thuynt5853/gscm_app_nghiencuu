using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class AHS_REPORT_BL
    {
        public DataTable DTReport_AHS_By_VuAnID_GiaiDoan(decimal in_VUANID, decimal in_MAGIAIDOAN, string Procedure)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("in_VUANID",in_VUANID),
                                                                        new OracleParameter("in_MAGIAIDOAN",in_MAGIAIDOAN),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = new DataTable();
            try
            {
                string sql = "PKG_GSTP_REPORT_HS." + Procedure;
                tbl = Cls_Comon.GetTableByProcedurePaging(sql, parameters);
            }
            catch { }
            return tbl;
        }
        public DataTable DTReport_AHS_By_VuAnID(decimal in_VUANID, string Procedure)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                     new OracleParameter("in_VUANID",in_VUANID),
                                                                     new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = new DataTable();
            try
            {
                string sql = "PKG_GSTP_REPORT_HS." + Procedure;
                tbl = Cls_Comon.GetTableByProcedurePaging(sql, parameters);
            }
            catch { }
            return tbl;
        }
        public DataTable AHS_GETHINHPHAT_BICAO_ST(decimal BANANID, decimal BICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("BANANID",BANANID),
                                                                        new OracleParameter("BICAOID",BICAOID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_HS.AHS_GETHINHPHAT_BICAO_ST", parameters);
            return tbl;
        }
        public DataTable AHS_GETHINHPHAT_BICAO_PT(decimal BANANID, decimal BICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("BANANID",BANANID),
                                                                        new OracleParameter("BICAOID",BICAOID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_HS.AHS_GETHINHPHAT_BICAO_PT", parameters);
            return tbl;
        }
        public DataTable AHS_GETTOIDANH_BICAO_VKS(decimal BOLUATID, decimal BICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("BOLUATID",BOLUATID),
                                                                        new OracleParameter("BICAOID",BICAOID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_HS.AHS_GETTOIDANH_BICAO_VKS", parameters);
            return tbl;
        }
        public DataTable AHS_GETTOIDANH_BICAO_ST(decimal BOLUATID, decimal BANANID, decimal BICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("BOLUATID",BOLUATID),
                                                                        new OracleParameter("BANANID",BANANID),
                                                                        new OracleParameter("BICAOID",BICAOID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_HS.AHS_GETTOIDANH_BICAO_ST", parameters);
            return tbl;
        }
        public DataTable AHS_GETDIEUKHOAN_BICAO_ST(decimal BOLUATID, decimal BANANID, decimal BICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vBoLuatID",BOLUATID),
                                                                        new OracleParameter("vBanAnID",BANANID),
                                                                        new OracleParameter("vBiCaoID",BICAOID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_HS.AHS_GETDIEUKHOAN_BICAO_ST", parameters);
            return tbl;
        }
        public DataTable AHS_GETDIEUKHOAN_BICAO_PT(decimal BOLUATID, decimal BANANID, decimal BICAOID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vBoLuatID",BOLUATID),
                                                                        new OracleParameter("vBanAnID",BANANID),
                                                                        new OracleParameter("vBiCaoID",BICAOID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_HS.AHS_GETDIEUKHOAN_BICAO_PT", parameters);
            return tbl;
        }
    }
}