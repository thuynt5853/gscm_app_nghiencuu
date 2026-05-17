
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_BICANBICAO_NC_BL
    {
        
        public DataTable AHS_CHECK_BICAN_CHUAXACTHUC(decimal vuanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vuanid)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.AHS_CHECK_BICAN_CHUAXACTHUC", parameters);
            return tbl;
        }
        public DataTable AHS_TOIDANH_CHINH_GETBYBICAN(decimal bi_can_id, decimal vuanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                          new OracleParameter("bi_can_id",bi_can_id)
                                                                        , new OracleParameter("vu_an_id",vuanid)
                                                                        , new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.AHS_TOIDANH_CHINH_GETBYBICAN", parameters);
            return tbl;
        }
        public bool AHS_BICAN_HISTORY_INSERT(string HIS_NGUOISUA, string HIS_TAIKHOANSUA, string HIS_BICAN, decimal BICANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("DLQGC06_AHS.AHS_BICAN_HISTORY_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["HIS_NGUOISUA"].Value = HIS_NGUOISUA;
            comm.Parameters["HIS_TAIKHOANSUA"].Value = HIS_TAIKHOANSUA;
            comm.Parameters["HIS_BICAN"].Value = HIS_BICAN;
            comm.Parameters["BICANID"].Value = BICANID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch(Exception ex)
            {
                
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable AHS_BICAN_HISTORY_GETLIST(decimal vBiCanId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("V_BICANID",vBiCanId),
                                        new OracleParameter("curreturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.AHS_BICAN_HISTORY_GETLIST", parameters);
            return dbl;
        }
        public bool AHS_SOTHAM_BANAN_BICAO_UPDATE_NGAYHIEULUC(decimal biCaoId, DateTime vNgayHieuLuc)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("DLQGC06_AHS.AHS_SOTHAM_BANAN_BICAO_UPDATE_NGAYHIEULUC", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["vbicaoid"].Value = biCaoId;
            comm.Parameters["vNgayHieuLuc"].Value = vNgayHieuLuc == DateTime.MinValue ? (object)DBNull.Value : vNgayHieuLuc;

            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception e)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        
        public DataTable AHS_ST_BANAN_BICAO_GetByVuAnID(int vu_an_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.AHS_ST_BANAN_BICAO_GetByVuAnID", parameters);
            return dbl;
        }

        public DataTable AHS_BICAO_GETALL_BY_VUANID_SEARCH(decimal vu_an_id, string textsearch, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        new OracleParameter("textsearch", textsearch),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.AHS_BICAO_GETALL_BY_VUANID_SEARCH", parameters);
            return tbl;
        }
        public DataTable AHS_BICAO_GETALL_BY_VUANID(decimal vu_an_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                        //new OracleParameter("curr_bicao_id",curr_bicao_id),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.AHS_BICAO_GETALL_BY_VUANID", parameters);
            return tbl;
        }


        #region xu ly man hinh dong bo c06
        public DataTable C06_AHS_SOTHAM_SEARCH_CHUADONGBO(decimal vBiCanId)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                        new OracleParameter("vBiCanId",vBiCanId),
                                        new OracleParameter("curreturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                        };

            DataTable dbl = Cls_Comon.GetTableByProcedurePaging("DLQGC06_AHS.ahs_bibicao_c06_get_by_bicanid", parameters);
            return dbl;
        }
        #endregion
    }
}