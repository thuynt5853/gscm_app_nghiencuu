using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_SOTHAM_BIENPHAPNGANCHAN_BL
    {

        public DataTable GetByVuAnID(Decimal vu_an_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("ma_group_data", ENUM_DANHMUC.BIENPHAPNGANCHAN),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_BienPhapNC_GetByVuAnID", parameters);
            return tbl;
        }
        public DataTable GetAllBiCanBiGiamGiu(Decimal vu_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("ma_group_data", ENUM_DANHMUC.BIENPHAPNGANCHAN),
                                                                       
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_STBPNC_GetAllBiCanGiamGiu", parameters);
            return tbl;
        }
        

    }

}