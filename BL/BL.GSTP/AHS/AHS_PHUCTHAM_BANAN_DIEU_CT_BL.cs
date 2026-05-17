using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_PHUCTHAM_BANAN_DIEU_CT_BL
    {
        public DataTable GetAllPaging(decimal bi_can_id, decimal ban_an_id
                                    , decimal bo_luat_id,string curr_textsearch
                                    , decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("ban_an_id",ban_an_id)
                                                                        , new OracleParameter("bo_luat_id",bo_luat_id)
                                                                        , new OracleParameter("curr_textsearch",curr_textsearch)

                                                                        , new OracleParameter("PageIndex",PageIndex)
                                                                        , new OracleParameter("PageSize", PageSize)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BanAnPT_DieuCT_GetAll", parameters);
            return tbl;
        }

        public DataTable GetAllHinhPhatByDK(decimal ban_an_id, decimal bi_can_id, decimal toi_danh_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("ban_an_id",ban_an_id)
                                                                        , new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("toi_danh_id",toi_danh_id)
                                                                        ,new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                  };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_BanAnPT_GetFullHinhPhat", parameters);
            return tbl;
        }
    }
}