using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;


namespace BL.GSTP
{
    public class QT_NHOMNGUOIDUNG_BL
    {
        public DataTable QT_NHOMNGUOIDUNG_SEARCH(decimal donviID,string strSearch)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_donvi",donviID),
                                                                          new OracleParameter("tennhom",strSearch),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NHOMNGUOIDUNG_SEARCH", parameters);
            return tbl;
        }
        public DataTable QT_NHOMNGUOIDUNG_SEARCHBY(string LOAITOA, string strSearch)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vLOAITOA",LOAITOA),
                                                                          new OracleParameter("tennhom",strSearch),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NHOMNGUOIDUNG_SEARCHBY", parameters);
            return tbl;
        }
    }
}