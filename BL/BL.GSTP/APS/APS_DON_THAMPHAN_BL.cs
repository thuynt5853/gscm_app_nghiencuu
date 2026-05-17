using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.APS
{
    public class APS_DON_THAMPHAN_BL
    {
        public DataTable APS_DON_THAMPHAN_GETBY(decimal vDONID, string vMaVaiTro)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vDONID",vDONID),
                                                                         new OracleParameter("vMaVaiTro",vMaVaiTro),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("APS_DON_THAMPHAN_GETBY", parameters);
            return tbl;
        }
    }
}