using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_HINHPHAT_BL
    {
        //public DataTable GetAllByNhom(string textsearch, int hieuluc, int nhom)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                                               new OracleParameter("curr_textsearch",textsearch),
        //                                                                new OracleParameter("curr_trangthai",hieuluc),
        //                                                                 new OracleParameter("curr_nhom",nhom),
        //                                                                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                                              };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_HinhPhat_GetAllByNhom", parameters);
        //    return tbl;
        //}
        public DataTable GetAllPaging(int nhomhinhphat, string textsearch, int hieuluc, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("curr_nhomhinhphat",nhomhinhphat),
                                                                        new OracleParameter("curr_textsearch",textsearch),
                                                                        new OracleParameter("curr_trangthai",hieuluc),

                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                   };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_HinhPhat_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable GetByNhomHP(Decimal nhomhinhphat)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("group_id",nhomhinhphat),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                   };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_HinhPhat_GetAllByGroupHP", parameters);
            return tbl;
        }

        


    }
}