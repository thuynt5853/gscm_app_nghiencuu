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
    public class THA_CVDON_THULY_BL
    {
        public DataTable GetThuLyByBiAnID(decimal vuanid, decimal bianid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vu_an_id", vuanid),
                                                                    new OracleParameter("bi_an_id", bianid),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_CVDON_THULY_GetByBiAn", parameters);
            return tbl;
        }
      
        
    }
}