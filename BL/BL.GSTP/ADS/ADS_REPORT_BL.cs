using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class ADS_REPORT_BL
    {
        public DataTable DTReport_ADS_By_VuAnID_GiaiDoan(decimal in_DONID, decimal in_MAGIAIDOAN, string Procedure)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("in_DONID",in_DONID),
                                                                        new OracleParameter("in_MAGIAIDOAN",in_MAGIAIDOAN),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = new DataTable();
            try
            {
                string sql = "PKG_GSTP_REPORT_DS." + Procedure;
                tbl = Cls_Comon.GetTableByProcedurePaging(sql, parameters);
            }
            catch { }
            return tbl;
        }
        public DataTable ADS_REPORT_BM15(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM15", parameters);
            return tbl;
        }

        public DataTable ADS_REPORT_BM16(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM16", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM17(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM17", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM18(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM18", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM19(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM19", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM20(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM20", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM21(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM21", parameters);
            return tbl;
        }

        public DataTable ADS_REPORT_BM22(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM22", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM25(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM25", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM26(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM26", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM27(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM27", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM29(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM29", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM30(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM30", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM41(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM41", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM42(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM42", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM43(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM43", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM44(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM44", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM45(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM45", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_BM46(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_BM46", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_ThamPhan(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_ThamPhan", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_HoiThamND(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_HoiThamND", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_GETNGUYENDON(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_GETNGUYENDON", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_GETBIDON(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_GETBIDON", parameters);
            return tbl;
        }
        public DataTable ADS_REPORT_NGUOICOQUYENNVLQ(decimal vDonID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDonID",vDonID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GSTP_REPORT_DS.ADS_REPORT_NGUOICOQUYENNVLQ", parameters);
            return tbl;
        }
    }
}