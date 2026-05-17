using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
namespace BL.GSTP.Danhmuc
{
    public class DM_QHPL_TK_BL
    {
        GSTPContext dt = new GSTPContext();
        public String CurrConnectionString = ENUM_CONNECTION.GSTP;
        public DataTable GetByStyle(decimal CurrStyle)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("CurrStyles",CurrStyle),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_QHPL_TK_GetByStyle", parameters);
            return tbl;
        }


        public DataTable GDTTT_QHPL_GetByLoaiAn_Paging(string textsearch,int tinhtrang, int loai, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("textsearch",textsearch),
                                                                       
                                                                        new OracleParameter("tinhtrang",tinhtrang),
                                                                         new OracleParameter("loai_an",loai),new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize",PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_QHPL_GetByLoaiAn", parameters);
            return tbl;
        }
        public DataTable GDTTT_QHPL_TK_GetByLoaiAn(int tinhtrang, int loai,String loai_an_name)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("loai_an_name",loai_an_name),
                new OracleParameter("loai_an",loai),
                new OracleParameter("tinhtrang",tinhtrang),                                                                    
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("GDTTT_QHPL_TK_GetByLoaiAn", parameters);
            return tbl;
        }

        
    }
}