using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;

namespace BL.GSTP.Quantri
{
    public class TuPhap_NguoiSuDung_BL
    {
        public DataTable CheckLogin( string vUserName, string vUserPass)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("user_name",vUserName),
                                                                        new OracleParameter("user_password",vUserPass),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TuPhap_NguoiDung_CheckLogin", parameters);
            return tbl;
        }
        
    }
}