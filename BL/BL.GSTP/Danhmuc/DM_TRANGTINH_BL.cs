using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

using System.Globalization;

namespace BL.GSTP.Danhmuc
{
    public class DM_TRANGTINH_BL
    {
        //CHuoi connection den DB Donkhoikien
        public String GSTPConnectionString = ENUM_CONNECTION.GSTP;
        public String  GetNoiDungByMaTrang(string ma_trang)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("ma_trang",ma_trang),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(GSTPConnectionString, "DM_TRANGTINH_GetByMaTrang", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
                return tbl.Rows[0]["NoiDung"] + "";
            else
                return "";
        }
        public DataTable GetAllPaging( decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {                                                                     
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(GSTPConnectionString, "DM_TrangTinh_GetAllPaging", parameters);
            return tbl;
        } 
    }
}