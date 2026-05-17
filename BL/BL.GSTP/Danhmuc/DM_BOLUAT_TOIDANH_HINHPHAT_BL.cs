using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_BOLUAT_TOIDANH_HINHPHAT_BL
    {
        public DataTable GetByToiDanhID(Decimal toidanhID)
        {
            OracleParameter[] parameters = new OracleParameter[] {    new OracleParameter("CurrToiDanhID",toidanhID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BL_TD_HP_GETBYTOIDANHID", parameters);
            return tbl;
        }
        
        
    }
}