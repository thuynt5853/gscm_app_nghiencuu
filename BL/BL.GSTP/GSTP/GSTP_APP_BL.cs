using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
namespace BL.GSTP.GSTP
{
    public class GSTP_APP_BL
    {
        public DataTable Get_TongHop_TP(String _COURT_ID, String _TYPE, Int32 PageIndex,Int32 PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                new OracleParameter("V_COURT_ID",_COURT_ID),
                new OracleParameter("V_TYPE",_TYPE),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GET_PUBLIC_APP.PUBLIC_COURT_DETAIL", parameters);
            return tbl;
        }
        public DataTable Get_TP_CongBBA(String VV_STAFFS, String V_DATE_FROM, String V_DATE_TO)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                 new OracleParameter("VV_STAFFS",VV_STAFFS),
                 new OracleParameter("V_DATE_TO",V_DATE_TO)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GET_PUBLIC_APP.PUBLIC_JUDGE_COUNT_FOUR", parameters);
            return tbl;
        }
        public DataTable Get_Tong_CongBBA(String _COURT_ID, String _STAFFS)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                 new OracleParameter("V_COURT_ID",_COURT_ID),
                 new OracleParameter("V_STAFFS",_STAFFS)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GET_PUBLIC_APP.PUBLIC_GSTP_HOME", parameters);
            return tbl;
        }
        public DataTable Get_cap_cbba(String _COURT_ID)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                 new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                 new OracleParameter("V_COURT_ID",_COURT_ID)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GET_PUBLIC_APP.COUNT_OF_TYPE", parameters);
            return tbl;
        }
    }
}