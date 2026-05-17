using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_LICHSU_THSL_BL
    {
       
        public DataTable DM_LICHSU_THSL_GETALL(Int32 _COURT_ID, Int32 _REPORT_TIME_ID, decimal PageIndex, decimal PageSize) {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                                      
                                                                        new OracleParameter("COURT_ID",_COURT_ID),
                                                                        new OracleParameter("REPORT_TIME_ID",_REPORT_TIME_ID),
                                                                        new OracleParameter("PAGEINDEX",PageIndex),
                                                                        new OracleParameter("PAGESIZE",PageSize),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_LICHSU_THSL_GETALL", parameters);
            return tbl;
        }
    }
}