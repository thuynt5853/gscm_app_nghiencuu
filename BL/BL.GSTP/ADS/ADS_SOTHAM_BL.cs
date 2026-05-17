using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class ADS_SOTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable ADS_SOTHAM_THULY_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_THULY_GETLIST", parameters);
            return tbl;
        }
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
        public decimal CheckSoBATheoLoaiAn(decimal donviID, string loaian, string so, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            //if (ngay.Month > 11)
            //{
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            //else
            //{
            //vFromDate = DateTime.Parse("01/12/" + (ngay.Year - 1), cul, DateTimeStyles.NoCurrentDateDefault);
            //vToDate = DateTime.Parse("30/11/" + (ngay.Year), cul, DateTimeStyles.NoCurrentDateDefault);
            //}
            OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoBA",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_CheckSoBA", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return Convert.ToDecimal(tbl.Rows[0][0]);
            else return 0;
        }

        public decimal GETSoBANEWTheoLoaiAn(decimal donviID, string loaian, DateTime ngay)
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
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_GETSoBA_NEW", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public decimal CheckSoTLTheoLoaiAn(decimal donviID, string loaian, string so, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            decimal v_thanhnien = 0;
            List<string> loaiAnPTQDKs = new List<string>()
            {
                "ADS_PTQDK",
                "AHS_PTQDK",
                "AHN_PTQDK",
                "AHC_PTQDK",
                "ALD_PTQDK",
                "AKT_PTQDK",
                "APS_PTQDK",
                "XLHC_PTQDK"
            };
            if (loaiAnPTQDKs.Contains(loaian))
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",v_thanhnien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_CheckSoThuLy", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                    return Convert.ToDecimal(tbl.Rows[0][0]);
                else return 0;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",v_thanhnien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_CheckSoThuLy", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                    return Convert.ToDecimal(tbl.Rows[0][0]);
                else return 0;
            }
               
        }

        public decimal GET_STL_NEW(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            decimal v_thanhnien = 0;
            List<string> loaiAnPTQDKs = new List<string>()
            {
                "ADS_PTQDK",
                "AHS_PTQDK",
                "AHN_PTQDK",
                "AHC_PTQDK",
                "ALD_PTQDK",
                "AKT_PTQDK",
                "APS_PTQDK",
                "APS_PTQDK",
                "XLHC_PTQDK"
            };
            if (loaiAnPTQDKs.Contains(loaian))
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",v_thanhnien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_STL_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("V_THANHNIEN",v_thanhnien),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STL_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
        }

        public decimal CheckSoTBTLTheoLoaiAn_V2(decimal donviID, string loaian, string so, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = new DateTime(ngay.Year, 1, 1, 0, 0, 0);
            vToDate = new DateTime(ngay.Year, 12, 31, 23, 59, 59);

            List<string> loaiAnPTQDKs = new List<string>()
            {
                "ADS_PTQDK",
                "AHS_PTQDK",
                "AHN_PTQDK",
                "AHC_PTQDK",
                "ALD_PTQDK",
                "AKT_PTQDK",
                "APS_PTQDK",
                "APS_PTQDK"
            };
            if (loaiAnPTQDKs.Contains(loaian))
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_CheckSoThongBaoThuLy", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                    return Convert.ToDecimal(tbl.Rows[0][0]);
                else return 0;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_CheckSoThongBaoThuLy_V2", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                    return Convert.ToDecimal(tbl.Rows[0][0]);
                else return 0;
            }

        }

        public decimal CheckSoTBTLTheoLoaiAn(decimal donviID, string loaian, string so, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            List<string> loaiAnPTQDKs = new List<string>()
            {
                "ADS_PTQDK",
                "AHS_PTQDK",
                "AHN_PTQDK",
                "AHC_PTQDK",
                "ALD_PTQDK",
                "AKT_PTQDK",
                "APS_PTQDK",
                "APS_PTQDK"
            };
            if (loaiAnPTQDKs.Contains(loaian))
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_CheckSoThongBaoThuLy", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                    return Convert.ToDecimal(tbl.Rows[0][0]);
                else return 0;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("vSoThuLy",so),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_CheckSoThongBaoThuLy", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                    return Convert.ToDecimal(tbl.Rows[0][0]);
                else return 0;
            }

        }

        public decimal GET_STBTL_NEW(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            List<string> loaiAnPTQDKs = new List<string>()
            {
                "ADS_PTQDK",
                "AHS_PTQDK",
                "AHN_PTQDK",
                "AHC_PTQDK",
                "ALD_PTQDK",
                "AKT_PTQDK",
                "APS_PTQDK",
                "APS_PTQDK"
            };
            if (loaiAnPTQDKs.Contains(loaian))
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_STBTL_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STBTL_GETMAXTT", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
                } else
                {
                    return 0;
                }
                
            }

        }

        public decimal GET_STBTL_NEW_V2(decimal donviID, string loaian, DateTime ngay)
        {
            if (ngay == null)
                ngay = DateTime.Now;
            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + ngay.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            List<string> loaiAnPTQDKs = new List<string>()
            {
                "ADS_PTQDK",
                "AHS_PTQDK",
                "AHN_PTQDK",
                "AHC_PTQDK",
                "ALD_PTQDK",
                "AKT_PTQDK",
                "APS_PTQDK",
                "APS_PTQDK"
            };
            if (loaiAnPTQDKs.Contains(loaian))
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_GS.QLA_ST_PT_STBTL_GETMAXTT", parameters);
                return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("vLoaiAn",loaian),
                                                                   new OracleParameter("vdonviID",donviID),
                                                                   new OracleParameter("vFromDate",vFromDate),
                                                                   new OracleParameter("vToDate",vToDate),
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_QLCS.QLA_ST_PT_STBTL_GETMAXTT_V2", parameters);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
                }
                else
                {
                    return 0;
                }
            }

        }

        public decimal CheckSoQDTheoLoaiAn(decimal donviID, string loaian, string so, DateTime ngay)
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
                                                                   new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QLA_ST_PT_CheckSoQD", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return Convert.ToDecimal(tbl.Rows[0][0]);
            else return 0;
        }

        public decimal THULY_GETNEWTT(decimal donviID)
        {

            DateTime vFromDate;
            DateTime vToDate;
            vFromDate = DateTime.Parse("01/01/" + DateTime.Now.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            vToDate = DateTime.Parse("31/12/" + DateTime.Now.Year, cul, DateTimeStyles.NoCurrentDateDefault);
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",donviID),
                                                                          new OracleParameter("vFromDate",vFromDate),
                                                                          new OracleParameter("vToDate",vToDate),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_THULY_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;

        }

        public DataTable ADS_SOTHAM_HOAGIAI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_HOAGIAI_GETLIST", parameters);
            return tbl;
        }

        public DataTable ADS_SOTHAM_TGTT_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_TGTT_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_BANAN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_BANAN_DIEULUAT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_BANAN_DIEULUAT_GET", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_BANAN_ANPHI_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_BANAN_ANPHI_GET", parameters);
            return tbl;
        }

        public DataTable ADS_SOTHAM_KHANGCAO_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_KHANGCAO_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_KHANGNGHI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_KHANGNGHI_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_KCaoKNghi_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_KCaoKNghi_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_ST_KCKN_TINHTRANG_GETLIST(decimal vDonID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vDonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_ST_KCKN_TINHTRANG_GETLIST", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_BANAN_TGTT_GET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("ADS_SOTHAM_BANAN_TGTT_GET", parameters);
            return tbl;
        }
        public DataTable ADS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.ADS_SOTHAM_QUYETDINH_KHONGKETTHUC_GETLIST", parameters);
            return tbl;
        }
    }
}