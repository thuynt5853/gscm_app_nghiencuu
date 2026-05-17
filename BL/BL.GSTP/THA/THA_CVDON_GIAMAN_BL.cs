using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;


namespace BL.GSTP.THA
{
    public class THA_CVDON_GIAMAN_BL
    {
        public DataTable GetAllByBiAn(decimal bianid)
        {
            OracleParameter[] parameters = new OracleParameter[] {

                                                                        new OracleParameter("BiAnID", bianid),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_GIAMAN_GETPAGE",parameters);
            return tbl;
        }

    }
}