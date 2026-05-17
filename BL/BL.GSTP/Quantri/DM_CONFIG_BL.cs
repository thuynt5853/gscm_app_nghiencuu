using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;


namespace BL.GSTP
{
    public class DM_CONFIG_BL
    {
        public String CurrConnectionString = ENUM_CONNECTION.GSTP;
        public DataTable GetAllPaging(decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DM_CONFIG_GETALLPAGING", parameters);
            return tbl;
        }
    }
}