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
    public class THA_THULY_BL
    {
        public DataTable THA_THULY_GETLIST(decimal vBiAnID, decimal vVUANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                            new OracleParameter("vBiAnID",vBiAnID),
                                            new OracleParameter("vVUANID",vVUANID),
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA.THA_THULY_GETLIST", parameters);
            return tbl;
        }
        //public decimal GetNewThuTu(decimal ToaAnID)
        //{
        //    OracleParameter[] parameters = new OracleParameter[] {
        //                                    new OracleParameter("dToaAnID",ToaAnID),
        //                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
        //                                    };
        //    DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_THULY_GETMAXTT", parameters);
        //    return Convert.ToDecimal(tbl.Rows[0][0]);
        //}
        public decimal GetNewThuTu()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_GET_MATHULY_TUSINH", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]);
        }
        public decimal GetMABIANTuSinh()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                            new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_GET_MABIAN_TUSINH", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]);
        }
    }
}