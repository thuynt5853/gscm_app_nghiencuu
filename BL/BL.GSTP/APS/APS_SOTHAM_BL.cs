using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.APS
{
    public class APS_SOTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable APS_SOTHAM_THULY_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_THULY_GETLIST", parameters);
            return tbl;
        }
        public decimal THULY_GETNEWTT(decimal donviID)
        {

            DateTime vFromDate;
            DateTime vToDate;
            if (DateTime.Now.Month > 11)
            {
                vFromDate = DateTime.Parse("01/12/" + DateTime.Now.Year, cul, DateTimeStyles.NoCurrentDateDefault);
                vToDate = DateTime.Parse("30/11/" + (DateTime.Now.Year + 1), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                vFromDate = DateTime.Parse("01/12/" + (DateTime.Now.Year - 1), cul, DateTimeStyles.NoCurrentDateDefault);
                vToDate = DateTime.Parse("30/11/" + (DateTime.Now.Year), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                          new OracleParameter("vFromDate",vFromDate),
                                                                          new OracleParameter("vToDate",vToDate),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_THULY_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public DataTable APS_SOTHAM_HOAGIAI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_HOAGIAI_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_BANAN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_BANAN_DIEULUAT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_BANAN_DIEULUAT_GET", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_BANAN_ANPHI_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_BANAN_ANPHI_GET", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_KHANGCAO_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_KHANGCAO_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_KHANGNGHI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_KHANGNGHI_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_KCaoKNghi_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_KCaoKNghi_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_ST_KCKN_TINHTRANG_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_ST_KCKN_TINHTRANG_GETLIST", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_BANAN_TGTT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_SOTHAM_BANAN_TGTT_GET", parameters);
            return tbl;
        }
        public DataTable APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.APS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST", parameters);
            return tbl;
        }
    }
}