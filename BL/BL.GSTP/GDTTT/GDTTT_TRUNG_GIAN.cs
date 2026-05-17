using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.GDTTT
{
    public class GDTTT_TRUNG_GIAN
    {
        public bool HOSO_CHUYEN_DON(ref Int32 V_COUNT_RE, String V_GUID, String V_MA_HO_SO,String V_TOA_AN_CHUYEN, String V_NGUOI_CHUYEN, String V_TOA_AN_NHAN)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_TRUNG_GIAN.SP_INSERT_GDTTT_DON", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_COUNT_RE"].Direction = ParameterDirection.Output;
            comm.Parameters["V_GUID"].Value = V_GUID;
            comm.Parameters["V_MA_HO_SO"].Value = V_MA_HO_SO;
            comm.Parameters["V_TOA_AN_CHUYEN"].Value = V_TOA_AN_CHUYEN;
            comm.Parameters["V_NGUOI_CHUYEN"].Value = V_NGUOI_CHUYEN;
            comm.Parameters["V_TOA_AN_NHAN"].Value = V_TOA_AN_NHAN;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                V_COUNT_RE = Convert.ToInt32(comm.Parameters["V_COUNT_RE"].Value.ToString());
                conn.Close();
            }
        }
        public bool HOSO_THU_HOI_DON(ref Int32 V_COUNT_RE, String V_MA_HO_SO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_TRUNG_GIAN.SP_THUHOI_GDTTT_DON", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_COUNT_RE"].Direction = ParameterDirection.Output;
            comm.Parameters["V_MA_HO_SO"].Value = V_MA_HO_SO;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                V_COUNT_RE = Convert.ToInt32(comm.Parameters["V_COUNT_RE"].Value.ToString());
                conn.Close();
            }
        }

    }
}