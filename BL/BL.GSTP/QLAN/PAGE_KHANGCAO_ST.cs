using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System.Data;

namespace BL.GSTP.QLAN
{
    public class PAGE_KHANGCAO_ST
    {
        // Load bản án để kháng cáo
        public DataTable DANHSACH_KHANGCAO_BANAN(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_PAGE_KHANGCAO_ST.DANHSACH_KHANGCAO_BANAN", parameters);
            return tbl;
        }

        // Load quyết định để kháng cáo(quyết định gây kết thúc)
        public DataTable DANHSACH_KHANGCAO_QUYETDINH(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_PAGE_KHANGCAO_ST.DANHSACH_KHANGCAO_QUYETDINH", parameters);
            return tbl;
        }

        // Load quyết định khác để kháng cáo (quyết định không gây kết thúc)
        public DataTable DANHSACH_KHANGCAO_QUYETDINH_KHAC(string vLOAIAN, decimal vDONID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_LOAD_PAGE_KHANGCAO_ST.DANHSACH_KHANGCAO_QUYETDINH_KHAC", parameters);
            return tbl;
        }

        // Load quyết định bị can khác để kháng cáo (quyết định không gây kết thúc)
        public DataTable DANHSACH_KHANGCAO_QUYETDINH_BICAN(string vLOAIAN, decimal vDONID,string VBICANID)
        {

            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("VLOAIAN",vLOAIAN),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("VBICANID",VBICANID),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_AHS_GS.DANHSACH_KHANGCAO_QUYETDINHTDC_BICAN", parameters);
            return tbl;
        }
    }
}