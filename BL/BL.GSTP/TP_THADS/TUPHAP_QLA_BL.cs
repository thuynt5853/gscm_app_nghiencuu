using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;

namespace BL.GSTP.TP_THADS
{
    public class TUPHAP_QLA_BL
    {
        public void CHECK_TRANGTHAI_THULY(decimal V_ID, String V_LOAI_AN)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_QLA.CHECK_ENABLE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = V_ID;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
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
                conn.Close();
            }
        }
        public void CHECK_ENABLE_THULY(decimal V_DONID, String V_LOAI_AN)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_QLA.CHECK_ENABLE_THULY", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DONID"].Value = V_DONID;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
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
                conn.Close();
            }
        }
        public DataTable GET_ENABLE_ANPHI(decimal V_ANPHI_ID, String V_LOAI_AN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_ANPHI_ID",V_ANPHI_ID),
                        new OracleParameter("V_LOAI_AN",V_LOAI_AN),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_QLA.GET_ENABLE_ANPHI", parameters);
            return tbl;
        }
    }
}