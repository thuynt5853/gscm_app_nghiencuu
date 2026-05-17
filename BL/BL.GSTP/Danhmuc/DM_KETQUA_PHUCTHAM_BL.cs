using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_KETQUA_PHUCTHAM_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable DM_KETQUA_PHUCTHAM_GETLISTALL()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_KETQUA_PHUCTHAM_GETLISTALL", parameters);
            return tbl;
        }
        public DataTable DM_KETQUA_PHUCTHAM_SEARCH(string TextKey, int curPageIndex, int pageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                 new OracleParameter("TextKey",TextKey),
                new OracleParameter("CurrPageIndex",curPageIndex),
                new OracleParameter("PageSize",pageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_KETQUA_PHUCTHAM_SEARCH", prm);
        }
        
    }
}