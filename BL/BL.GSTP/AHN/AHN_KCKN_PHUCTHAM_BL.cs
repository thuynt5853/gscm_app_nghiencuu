using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHN
{
    public class AHN_KCKN_PHUCTHAM_BL
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        public DataTable AHN_PHUCTHAM_THULY_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_KCKN_PHUCTHAM_THULY_GETLIST", parameters);
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_KCKN_PHUCTHAM_THULY_GETMAXTT", parameters);
            string maxSQD = tbl.Rows[0][0].ToString();
            if (maxSQD.IndexOf("/") > 0)
                maxSQD = maxSQD.Substring(0, maxSQD.Trim().IndexOf("/"));
            else if (maxSQD.IndexOf("/") == -1)
                maxSQD = "0";

            return Convert.ToDecimal(maxSQD) + 1;

        }
        //public DataTable AHN_PHUCTHAM_TGTT_GETLIST(decimal vDONID)
        //{

        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                                new OracleParameter("vDONID",vDONID),
        //                                                                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PHUCTHAM_TGTT_GETLIST", parameters);
        //    return tbl;
        //}


        public DataTable AHN_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_KCKNQDK_PHUCTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHN_PHUCTHAMKCKNQDK_BANANQUYETDINH_GETLIST(decimal vDONID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_PHUCTHAMQDK_BANANQUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHN_PHUCTHAM_KCKN_TGTT_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_PHUCTHAM_KCKN_TGTT_GETLIST", parameters);
            return tbl;
        }
        //public DataTable AHN_PHUCTHAM_HDXX_GETLIST(decimal vDONID)
        //{

        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                                new OracleParameter("vDONID",vDONID),
        //                                                                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PHUCTHAM_HDXX_GETLIST", parameters);
        //    return tbl;
        //}

        public DataTable AHN_KCKNQDK_PHUCTHAM_HDXX_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_KCKNQDK_PHUCTHAM_HDXX_GETLIST", parameters);
            return tbl;
        }

        public DataTable AHN_PHUCTHAM_HOAGIAI_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PHUCTHAM_HOAGIAI_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHN_PHUCTHAM_QUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PHUCTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHN_PHUCTHAM_BANAN_CHITIET(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PHUCTHAM_BANAN_CHITIET", parameters);
            return tbl;
        }
        public DataTable AHN_PT_KCQUAHAN(decimal DonViID, string MaVuViec, string TenVuViec, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_PT_KCQUAHAN", parameter);
            return tbl;
        }
        public DataTable AHN_RUTKN(decimal DonViID, string MaVuViec, string TenVuViec,string SoQD_BA,string TenDuongSu, DateTime? TuNgay, DateTime? DenNgay, decimal TrangThai, int PageIndex, int PageSize)
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHN_RUTKN", parameter);
            return tbl;
        }
        public DataTable AHN_PHUCTHAM_BANANQUYETDINH_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHN_PHUCTHAM_BANANQUYETDINH_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHN_PHUCTHAM_QUYETDINH_KHONGKETTHUC_GETLIST(decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_BAQD.AHN_PHUCTHAM_QUYETDINH_GETLIST", parameters);
            return tbl;
        }


        public DataTable AHN_KCKN_DON_THAMPHAN_GETBY(decimal vDONID, string vMaVaiTro)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vMaVaiTro",vMaVaiTro),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_KCKN_DON_THAMPHAN_GETBY", parameters);
            return tbl;
        }
        public DataTable AHN_DM_QUYETDINH_VUAN_PT()
        {

            OracleParameter[] parameters = new OracleParameter[] {new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHN_GS.AHN_DM_QUYETDINH_VUAN_PTQDK", parameters);
            return tbl;
        }
    }
}