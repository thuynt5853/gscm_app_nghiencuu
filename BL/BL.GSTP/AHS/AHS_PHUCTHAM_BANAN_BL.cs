using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_PHUCTHAM_BANAN_BL
    {
        public decimal GetNewTT(decimal toaan_id, decimal vuan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("toaan_id", toaan_id)
                                                                        , new OracleParameter("vuan_id", vuan_id)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PhucTham_BanAn_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public DataTable GetDsBiCaoByVuAn(int vu_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PT_BANAN_BICAO_GetByVuAnID", parameters);
            return tbl;
        }

    }
}