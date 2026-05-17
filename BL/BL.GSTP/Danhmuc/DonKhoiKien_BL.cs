using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;


namespace BL.GSTP.Danhmuc
{
   
    public class DonKhoiKien_BL
    {
        public String CurrConnectionString = "DKKConnection";
        public DataTable GetAllTinTucPaging(decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_TINTUC_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable GetAllCMByCapChaID(Decimal capcha)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                       new OracleParameter("cap_cha_id", capcha),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DonKK_ChuyenMuc_GetByCapCha", parameters);
            return tbl;
        }
        public DataTable GetAllUserPaging(string textsearch, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {      new OracleParameter("searchKey", textsearch),
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DONKK_USERS_GetAllPaging", parameters);
            return tbl;
        }
        public DataTable GetAllTrangTinhPaging(decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging(CurrConnectionString, "DM_TrangTinh_GetAllPaging", parameters);
            return tbl;
        }
    }
}