using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_BICAN_NHANTHAN_BL
    {
        public DataTable GetByVuAn_BiAnID(Decimal vu_an_id, Decimal bi_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_bian_id",bi_an_id),
                                                                        new OracleParameter("curr_vuan_id", vu_an_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BC_NHANTHAN_GETBYBIAN", parameters);
            return tbl;
        }
        public DataTable AHS_BC_NHANTHAN_GetByLoaiQH(Decimal vu_an_id, Decimal bi_an_id, int loai_qh)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_bian_id",bi_an_id),
                                                                        new OracleParameter("curr_vuan_id", vu_an_id),
                                                                          new OracleParameter("loai_qh", loai_qh),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BC_NHANTHAN_GetByLoaiQH", parameters);
            return tbl;
        }
    }
}