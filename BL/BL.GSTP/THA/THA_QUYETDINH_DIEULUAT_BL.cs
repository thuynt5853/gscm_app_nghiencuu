using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.THA
{
    public class THA_QUYETDINH_DIEULUAT_BL
    {

        public DataTable GetAllPaging(decimal bi_can_id, decimal VuAnID, decimal bo_luat_id
                                     , string curr_textsearch
                                    , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("p_vuanId",VuAnID)
                                                                        , new OracleParameter("bo_luat_id",bo_luat_id)
                                                                        , new OracleParameter("curr_textsearch",curr_textsearch)


                                                                        , new OracleParameter("PageIndex",PageIndex)
                                                                        , new OracleParameter("PageSize", PageSize)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_DIEULUAT.THA_BANANST_DIEUCT_GETALL", parameters);
            return tbl;
        }

        public DataTable GETALL_DIEULUAT_PT_PAGING(decimal bi_can_id, decimal vu_an_id
                                    , decimal bo_luat_id, string curr_textsearch
                                    , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("vu_an_id",vu_an_id)
                                                                        , new OracleParameter("bo_luat_id",bo_luat_id)
                                                                        , new OracleParameter("curr_textsearch",curr_textsearch)

                                                                        , new OracleParameter("PageIndex",PageIndex)
                                                                        , new OracleParameter("PageSize", PageSize)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_DIEULUAT.GETALL_DIEULUAT_PT_PAGING", parameters);
            return tbl;
        }

        public DataTable TongHopToiDanhSoTham(decimal ban_an_id, decimal bi_can_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                      new OracleParameter("CurrVuAnID",ban_an_id)
                                                                      , new OracleParameter("CurrBiCanID", bi_can_id)
                                                                      ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_DIEULUAT.THA_TONGHOPTOIDANHSOTHAM", parameters);
            return tbl;
        }
    }
}