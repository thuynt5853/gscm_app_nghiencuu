using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.ADS
{
    public class ADS_PHUCTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable ADS_PHUCTHAM_THULY_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_THULY_GETLIST", parameters);
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_THULY_GETMAXTT", parameters);
            string maxSQD = tbl.Rows[0][0].ToString();
            if (maxSQD.IndexOf("/") > 0)
                maxSQD = maxSQD.Substring(0, maxSQD.Trim().IndexOf("/"));
            else if (maxSQD.IndexOf("/") == -1)
                maxSQD = "0";

            return Convert.ToDecimal(maxSQD) + 1;

        }
        public DataTable ADS_PHUCTHAM_TGTT_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_TGTT_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_PHUCTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }

        public DataTable ADS_KCKNQDK_PHUCTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.ADS_KCKNQDK_PHUCTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_PHUCTHAM_HOAGIAI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_HOAGIAI_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_PHUCTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.ADS_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_PHUCTHAM_BANAN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PHUCTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable ADS_PT_KCQUAHAN(decimal DonViID, string MaVuViec, string TenVuViec, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_PT_KCQUAHAN", parameter);
            return tbl;
        }
        public DataTable ADS_RUTKN(decimal DonViID, string MaVuViec, string TenVuViec,string SoQD_BA,string TenDuongSu, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
        {
            OracleParameter[] parameter = new OracleParameter[]
            {
                new OracleParameter("vDonViID",DonViID),
                new OracleParameter("vMaVuViec",MaVuViec),
                new OracleParameter("vTenVuViec",TenVuViec),
                new OracleParameter("vSoQD_BA",SoQD_BA),
                new OracleParameter("vTenDuongSu",TenDuongSu),
                new OracleParameter("vTuNgay",TuNgay),
                new OracleParameter("vDenNgay",DenNgay),
                new OracleParameter("vTrangThai",TrangThai),
                new OracleParameter("vPageIndex",PageIndex),
                new OracleParameter("vPageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_RUTKN", parameter);
            return tbl;
        }
        public DataTable ADS_PHUCTHAM_BANANQUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.ADS_PHUCTHAM_BANANQUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_PHUCTHAMKCKNQDK_BANANQUYETDINH_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_ADS_GS.ADS_PHUCTHAMQDK_BANANQUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_PHUCTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.ADS_PHUCTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
    }
}