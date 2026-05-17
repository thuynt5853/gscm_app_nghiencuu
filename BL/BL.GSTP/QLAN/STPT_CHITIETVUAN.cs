using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Globalization;

namespace BL.GSTP.QLAN
{
    public class STPT_CHITIETVUAN
    {
        public DataTable AHS_STPT_CHITIETVUAN_DANHSACHBICAO(decimal vCAPXETXU, decimal vDONID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vCAPXETXU),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("PageIndex",PageIndex),
                                                                    new OracleParameter("PageSize", PageSize),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_CHITIETVUAN_DANHSACHBICAO.AHS_STPT_CHITIETVUAN_DANHSACHBICAO", parameters);
            return tbl;
        }

        public DataTable AHS_STPT_CHITIETVUAN_DANHSACHKHANGCAO(decimal vCAPXETXU, decimal vDONID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vCAPXETXU),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("PageIndex",PageIndex),
                                                                    new OracleParameter("PageSize", PageSize),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_CHITIETVUAN_DANHSACHBICAO.AHS_STPT_CHITIETVUAN_DANHSACHKHANGCAO", parameters);
            return tbl;
        }

        public DataTable AHS_STPT_CHITIETVUAN_DANHSACHKHANGNGHI(decimal vCAPXETXU, decimal vDONID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {  new OracleParameter("vDONID",vCAPXETXU),
                                                                    new OracleParameter("vDONID",vDONID),
                                                                    new OracleParameter("PageIndex",PageIndex),
                                                                    new OracleParameter("PageSize", PageSize),
                                                                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_CHITIETVUAN_DANHSACHBICAO.AHS_STPT_CHITIETVUAN_DANHSACHKHANGNGHI", parameters);
            return tbl;
        }
    }
}