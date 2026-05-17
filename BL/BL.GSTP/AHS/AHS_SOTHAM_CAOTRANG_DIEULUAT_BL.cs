using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_SOTHAM_CAOTRANG_DIEULUAT_BL
    {
        public DataTable GetAllPaging(decimal bi_can_id, decimal vuanid, decimal bo_luat_id,decimal loai_bo_luat
									, string curr_textsearch, decimal PageIndex, decimal PageSize )
        {
            //if (ngay_ban_hanh == DateTime.MinValue) ngay_ban_hanh = null;
            OracleParameter[] parameters = new OracleParameter[] {
																		  new OracleParameter("bi_can_id",bi_can_id)
																		, new OracleParameter("vu_an_id",vuanid)				
                                                                        , new OracleParameter("bo_luat_id",bo_luat_id)
                                                                        , new OracleParameter("loai_bo_luat", loai_bo_luat)
                                                                        , new OracleParameter("curr_textsearch",curr_textsearch)

																		//, new OracleParameter("ngay_ban_hanh",ngay_ban_hanh)
																		
                                                                        , new OracleParameter("PageIndex",PageIndex)
                                                                        , new OracleParameter("PageSize", PageSize)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SoThamCaoTrang_Luat_GetAll", parameters);
            return tbl;
        }
        
        public DataTable GetAllToiDanhByBiCan(decimal bi_can_id, decimal vuanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("vu_an_id",vuanid)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_STToiDanh_GetByBiCan", parameters);
            return tbl;
        }

        public DataTable AHS_GetAllToiDanh()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                         new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DMBoLuat_TD_HS_GetToiDanh", parameters);
            return tbl;
        }

        public DataTable GetAllByBiCaoID(decimal bi_can_id, decimal VuAnID,  decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("vu_an_id",VuAnID)
                                                                        , new OracleParameter("PageIndex",PageIndex)
                                                                        , new OracleParameter("PageSize", PageSize)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_CT_Luat_GetByBiCao", parameters);
            return tbl;
        }

        
        public DataTable GetByVuAnID(decimal vu_an_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_ST_CAOTRANG_LUAT_GetByAnID", parameters);
            return tbl;
        }
        public DataTable CountToiDanhByBiCao(decimal vu_an_id, decimal bi_cao_id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("bi_cao_id",bi_cao_id),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_STToiDanh_CountByBiCao", parameters);
            return tbl;
        }

        public DataTable GetToiDanh_To_TDC(decimal bi_can_id, decimal vuanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("vu_an_id",vuanid)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_SOTHAMCAOTRANG_LUAT_GETTOIDANH_TO_ISMAIN", parameters);
            return tbl;
        }
    }
}