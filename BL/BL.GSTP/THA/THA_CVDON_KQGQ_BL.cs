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
    public class THA_CVDON_KQGQ_BL
    {
        public DataTable GetAllPaging(decimal vuanid, decimal bianid, decimal tinhtrang, int PageIndex, int PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                    new OracleParameter("vu_an_id", vuanid),
                                                                    new OracleParameter("bi_an_id", bianid),
                                                                    new OracleParameter("tinh_trang_gq", tinhtrang),
                                                                      new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                 };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_CVDon_KQGD_GetAllPaging", parameters);
            return tbl;
        }
    }
}