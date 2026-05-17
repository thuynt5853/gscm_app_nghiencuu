using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Web;

namespace BL.GSTP.APS
{
    public class APS_NGUOITHAMGIATOTUNG_BL 
    {
        public void SO_DK_RETURN(string v_ptst, ref Decimal V_DK_APS, String VTOAANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TOANCAU_STPT_EXT.SO_DK_PS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DK_PS"].Direction = ParameterDirection.Output;
            comm.Parameters["VTOAANID"].Value = VTOAANID;
            comm.Parameters["V_CXX"].Value = v_ptst;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch
            {
                tran.Rollback();
            }
            finally
            {
                V_DK_APS = Convert.ToDecimal(comm.Parameters["V_DK_PS"].Value);
                conn.Close();
            }
        }
        public void SO_DK_KCKNQDK_RETURN(string v_stpt, ref Decimal V_DK_PS, String VTOAANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT_APS_GS.SO_DK_KCKN_PS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DK_PS"].Direction = ParameterDirection.Output;
            comm.Parameters["VTOAANID"].Value = VTOAANID;
            comm.Parameters["V_CXX"].Value = v_stpt;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch
            {
                tran.Rollback();
            }
            finally
            {
                V_DK_PS = Convert.ToDecimal(comm.Parameters["V_DK_PS"].Value);
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
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TOANCAU_STPT_EXT.GXN_PS_NBC", parameters);
            return tbl;
        }
    }
}
