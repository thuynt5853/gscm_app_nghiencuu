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
    public class THA_UYTHAC_QUYETDINH_BL
    {
        //public DataTable GetAllByBiAnID(decimal BiAn)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {

        //                                                                new OracleParameter("Curr_BiAnID", BiAn),
        //                                                                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_UYTHAC_QD_GetAll", parameters);
        //    return tbl;
        //}
        public DataTable GetAllByBiAnID(decimal BiAn)
        {
            OracleParameter[] parameters = new OracleParameter[] {

                                                                        new OracleParameter("Curr_BiAnID", BiAn),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_UYTHAC_QD_GetAll", parameters);
            return tbl;
        }
    }
}