using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_BIEUMAU_BL
    {
       
        public DataTable DM_BIEUMAU_GETALL( string textsearch, decimal loaivuviec, decimal hieuluc, decimal PageIndex, decimal PageSize) {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                                      
                                                                        new OracleParameter("CURR_TXTSEARCH",textsearch),
                                                                        new OracleParameter("CURR_LOAIVUVIEC",loaivuviec),
                                                                          new OracleParameter("CURR_TRANGTHAI",hieuluc),
                                                                        new OracleParameter("PAGEINDEX",PageIndex),
                                                                        new OracleParameter("PAGESIZE",PageSize),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BIEUMAU_GETALL", parameters);
            return tbl;
        }
        public DataTable DM_BIEUMAU_GETBY(decimal loaivuviec, decimal hieuluc, decimal vGiaidoan)
        {
            OracleParameter[] parameters = new OracleParameter[] {                                                                       
                                                                        new OracleParameter("CURR_LOAIVUVIEC",loaivuviec),
                                                                          new OracleParameter("CURR_TRANGTHAI",hieuluc),
                                                                        new OracleParameter("vGiaidoan",vGiaidoan),
                                                                        new OracleParameter("return_page",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BIEUMAU_GETBY", parameters);
            return tbl;
        }
    }
}