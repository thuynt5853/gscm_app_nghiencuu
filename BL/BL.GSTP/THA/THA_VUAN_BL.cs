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
    public class THA_VUAN_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable GetLastThaVuAnNotComlete(decimal toa_an_id, string nguoitao)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("toa_an_id",toa_an_id)
                , new OracleParameter("nguoi_tao",nguoitao)
                , new OracleParameter("curReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("THA_VuAn_GetLastNotComleteHoSo", prm);
        }

        public decimal GETNEWTT(decimal ToaAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",ToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_VuAn_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public DataTable GetAllToiDanhByBiCan(decimal bi_can_id, decimal vuanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("vu_an_id",vuanid)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_STToiDanh_GetByBiCan", parameters);
            return tbl;
        }

        public DataTable GetAllPaging(decimal bi_can_id, decimal vuanid, decimal bo_luat_id, decimal loai_bo_luat
                                    , string curr_textsearch, decimal PageIndex, decimal PageSize)
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("THA_SoThamCaoTrang_Luat_GetAll", parameters);
            return tbl;
        }

        public bool EXIST_PHATTIEN_AHS(decimal vuAnID, decimal biAnID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_THA_GS.CHECK_EXIST_PHATTIEN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_RESULT"].Direction = ParameterDirection.Output;
            comm.Parameters["v_VUANID"].Value = vuAnID;
            comm.Parameters["v_BIANID"].Value = biAnID;
            decimal rsCount = 0;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch (Exception e)
            {
                tran.Rollback();
            }
            finally
            {
                rsCount = Convert.ToDecimal(comm.Parameters["v_RESULT"].Value);
                conn.Close();

            }
            return rsCount > 0 ? true : false;
        }

        public DataTable THA_GETCHITIET_BANGIAO(decimal v_VUVIECID, decimal v_TOAANNHANID, String v_VUVIECLOAI)
        {
            //if (ngay_ban_hanh == DateTime.MinValue) ngay_ban_hanh = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("v_VUVIECID",v_VUVIECID)
                                                                        , new OracleParameter("v_TOAANNHANID",v_TOAANNHANID)
                                                                        , new OracleParameter("v_VUVIECLOAI",v_VUVIECLOAI)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_THA_GS.THA_GETCHITIET_BANGIAO", parameters);
            return tbl;
        }
    }
}