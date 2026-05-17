using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_BOLUAT_BL
    {
        public DataTable DM_BOLUAT_GetAllPaging(string textsearch, int hieuluc, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("curr_textsearch",textsearch),
                                                                        new OracleParameter("curr_trangthai",hieuluc),                                    
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable SearchTopByLoai( int soluong, string textsearch,int loaiboluat)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("SoLuong", soluong),
                                                                        new OracleParameter("TextKey", textsearch),
                                                                        new OracleParameter("LoaiBoLuat",loaiboluat),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_BoLuat_SearchTop", parameters);
            return tbl;
        }

    }
}