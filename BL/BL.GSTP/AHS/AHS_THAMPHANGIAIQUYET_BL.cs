using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class AHS_THAMPHANGIAIQUYET_BL
    {
        public DataTable AHS_THAMPHANGIAIQUYET_GETBY(decimal vVUANID, string vMaVaiTro)
        {
       
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVUANID",vVUANID),
                                                                         new OracleParameter("vMaVaiTro",vMaVaiTro),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_THAMPHANGIAIQUYET_GETBY", parameters);
            return tbl;
        }
    }
}