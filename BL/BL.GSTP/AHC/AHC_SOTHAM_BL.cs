using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHC
{
    public class AHC_SOTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable AHC_SOTHAM_THULY_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_THULY_GETLIST", parameters);
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_THULY_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }
        public DataTable AHC_SOTHAM_HOAGIAI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_HOAGIAI_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_BANAN_DIEULUAT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_BANAN_DIEULUAT_GET", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_BANAN_ANPHI_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_BANAN_ANPHI_GET", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_KHANGCAO_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_KHANGCAO_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_KHANGNGHI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_KHANGNGHI_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_KCaoKNghi_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_KCAOKNGHI_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_ST_KCKN_TINHTRANG_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_ST_KCKN_TINHTRANG_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_BANAN_TGTT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_BANAN_TGTT_GET", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_BANAN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHC_SOTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable AHC_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHC_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST", parameters);
            return tbl;
        }
        //get thêm số quyết định hc tamnc
        public decimal GET_SQD_NEW(decimal donviID, string loaian, DateTime ngay, decimal loaiQDID)
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
                                                                   new OracleParameter("vLoaiQD",loaiQDID),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_GetSoQDnew", parameters);
            string maxSQD = tbl.Rows[0][0].ToString();

            if (maxSQD.IndexOf("/") > 0)
                maxSQD = maxSQD.Substring(0, maxSQD.Trim().IndexOf("/"));
            //else if (maxSQD.IndexOf("/") == -1)
            //    maxSQD = "0";

            return Convert.ToDecimal(maxSQD) + 1;
        }

        //Check số QĐ theo loại án tamnc
        public decimal CHECK_SQDTheoLoaiAn(decimal donviID, string loaian, string so, DateTime ngay, decimal loaiQDID)
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
                                                                   new OracleParameter("vSoQD",so),
                                                                   new OracleParameter("vLoaiQD",loaiQDID),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_CheckSoQD", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return Convert.ToDecimal(tbl.Rows[0][0]);
            else return 0;
        }
    }
}