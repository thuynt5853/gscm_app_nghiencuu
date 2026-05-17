using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

namespace BL.GSTP.AHS
{
    public class AHS_PHUCTHAM_BICANBICAO_BL
    {
        public DataTable GetAllBiCanPhucTham(decimal vuan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vuan_id),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_PT_BiCao_GetAll", parameters);
            return tbl;
        }
        public DataTable Get_congthuc(decimal VUAN_ID,string HIEULUCTUNGAY)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("VVUAN_ID",VUAN_ID),
                                                                        new OracleParameter("VHIEULUCTUNGAY",HIEULUCTUNGAY),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.GET_CT_TAMGIAM", parameters);
            return tbl;
        }
        public DataTable GetAllBiCan_bihai_PhucTham(decimal vuan_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vuan_id),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_EXT.AHS_PT_BiCao_GetAll", parameters);
            return tbl;
        }

    }
}



