using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Globalization;

namespace BL.GSTP.AHS
{
    public class AHS_PHUCTHAM_THULY_BL
    {
        public DataTable GetByVuAnID(decimal vu_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PHUCTHAM_THULY_GetByVuAn", parameters);
            return tbl;
        }

        public DataTable GetToiDanhByBiCanId(decimal vu_an_id, decimal bi_can_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("bi_can_id", bi_can_id),
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_THULYPT_TOIDANH_GETBYBICAN", parameters);
            return tbl;
        }
        public decimal GETNEWTT(decimal ToaAnID, DateTime NgayThuLy)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayThuLy.Year;
            int Month_TL = NgayThuLy.Month;
            if (Month_TL==12 )
            {
                tungay = DateTime.Parse(("1/12/" +Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + (Year_TL+1)), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                tungay = DateTime.Parse(("1/12/" + (Year_TL-1)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" +Year_TL ), cul, DateTimeStyles.NoCurrentDateDefault);
            }

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("toa_an_id",ToaAnID),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PHUCTHAM_THULY_GETMAXTT", parameters);
            Decimal MaxTT = 0;
            if (tbl != null && tbl.Rows.Count > 0)
                MaxTT = String.IsNullOrEmpty(tbl.Rows[0]["CountAll"] + "") ? 1 : Convert.ToDecimal(tbl.Rows[0]["CountAll"]) + 1;
            else
                MaxTT = 1;
            return MaxTT;
        }
        public Boolean CheckExistSoThuLy(decimal thulyid,string sothuly, DateTime NgayThuLy)
        {
            CultureInfo cul = new CultureInfo("vi-VN");
            DateTime tungay, denngay;
            int Year_TL = NgayThuLy.Year;
            int Month_TL = NgayThuLy.Month;
            if (Month_TL == 12)
            {
                tungay = DateTime.Parse(("1/12/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + (Year_TL + 1)), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            else
            {
                tungay = DateTime.Parse(("1/12/" + (Year_TL - 1)), cul, DateTimeStyles.NoCurrentDateDefault);
                denngay = DateTime.Parse(("30/11/" + Year_TL), cul, DateTimeStyles.NoCurrentDateDefault);
            }

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("thulyid",thulyid),
                                                                           new OracleParameter("so_thu_ly",sothuly),
                                                                        new OracleParameter("tu_ngay", tungay),
                                                                        new OracleParameter("den_ngay",denngay),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PT_ThuLy_CheckExistSoThuLy", parameters);
            if (tbl != null && tbl.Rows.Count > 0) return true;
            else return false;
        }
    }
}