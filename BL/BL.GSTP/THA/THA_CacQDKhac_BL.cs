using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.THA
{
    public class THA_CacQDKhac_BL
    {
        public DataTable GetDataTHA_CACQDKHAC(decimal BiAnID,decimal VuAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {

                                                                        new OracleParameter("BiAnID", BiAnID),
                                                                        new OracleParameter("VuAnID", VuAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_CACQDKHAC_GETPAGE", parameters);
            return tbl;
        }
    }
}