
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

namespace BL.GSTP.ADS
{
    public class ADS_NGUOITHAMGIATOTUNG_BL
    {


        public DataTable GetAllPaging(int vu_an_id, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vu_an_id",vu_an_id),
                                                                         new OracleParameter("PageIndex",PageIndex),
                                                                        new OracleParameter("PageSize", PageSize),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_NguoiTGTT_GetByVuAnID", parameters);
            return tbl;
        }
        public bool ADS_NGUOI_DAIDIEN_INS_UP(Decimal NGUOI_TGTT_ID, String BICAO_ID, ref String V_CHECK)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_EXT.NGUOI_DD_INS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_CHECK"].Direction = ParameterDirection.Output;
            comm.Parameters["V_NGUOI_TGTT_ID"].Value = NGUOI_TGTT_ID;
            comm.Parameters["P_BICAO_ID"].Value = BICAO_ID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                V_CHECK = Convert.ToString(comm.Parameters["V_CHECK"].Value);
                conn.Close();
            }
        }
        public DataTable GET_NTGTT_BCBC(decimal NGUOITGTT_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("V_NGUOITGTT_ID",NGUOITGTT_ID),
                                                             
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT_EXT.GET_BCBC_NGUOITGTT", parameters);
            return tbl;
        }


        public void SO_DK_RETURN(string v_stpt,  ref Decimal V_DK_DS, String VTOAANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TOANCAU_STPT_EXT.SO_DK_DS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DK_DS"].Direction = ParameterDirection.Output;
            comm.Parameters["VTOAANID"].Value = VTOAANID;
            comm.Parameters["V_CXX"].Value = v_stpt;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch(Exception e)
            {
                tran.Rollback();
            }
            finally
            {
                V_DK_DS = Convert.ToDecimal(comm.Parameters["V_DK_DS"].Value);
                conn.Close();
            }
        }



        public void SO_DK_PHUCTHAMKCKN_RETURN(string v_stpt, ref Decimal V_DK_DS, String VTOAANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_ADS_GS.SO_DK_KCKN_DS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DK_DS"].Direction = ParameterDirection.Output;
            comm.Parameters["VTOAANID"].Value = VTOAANID;
            comm.Parameters["V_CXX"].Value = v_stpt;
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
                V_DK_DS = Convert.ToDecimal(comm.Parameters["V_DK_DS"].Value);
                conn.Close();
            }
        }

        public DataTable GET_BC_GIAYXX_NBC(string v_ptst, String vArrSelectID, String VTOAANID, String VCAPXX)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.ReturnValue ),
                new OracleParameter("vCXX",v_ptst),
                new OracleParameter("vArrLuatSuID",vArrSelectID),
                new OracleParameter("VTOAANID",VTOAANID),
                new OracleParameter("VCAPXX",VCAPXX)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TOANCAU_STPT_EXT.GXN_DS_NBC", parameters);
            return tbl;
        }

    }
}