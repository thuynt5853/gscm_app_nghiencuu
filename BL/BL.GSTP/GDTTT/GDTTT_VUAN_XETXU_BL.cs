using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_VUAN_XETXU_BL
    {       
        public DataTable XetXuGDTTT_GetByVuAnID(decimal vVuAnVuViec)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnVuViec),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_VUAN_XX_GetByVuAnID", parameters);
            return tbl;
        }
    }
}