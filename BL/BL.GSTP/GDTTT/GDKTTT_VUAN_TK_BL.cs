using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;


using System.Globalization;
namespace BL.GSTP
{
    public class GDKTTT_VUAN_TK_BL
    {
        public bool GDKTTT_VUAN_TK_INS_UPD(GDKTT_VUAN_TK obj, string LOAITK)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TK.GDKTTT_VUAN_TK_INS_UPD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TYPE_TK"].Value = LOAITK;
            comm.Parameters["V_VUAN_ID"].Value = obj.VUANID;
            comm.Parameters["V_GIATRI_TK"].Value = obj.GIATRI_TK;
            comm.Parameters["V_NOIDUNG_TK"].Value = obj.NOIDUNG_TK;
            comm.Parameters["V_GHICHU"].Value = obj.GHICHU;
            comm.Parameters["V_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["V_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["V_NGUOISUA"].Value = obj.NGUOISUA;
            comm.Parameters["V_NGAYSUA"].Value = obj.NGAYSUA;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                String msg_ = ex.Message;
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public DataTable GDKTTT_VUAN_TK_GETBYID(string v_TYPETK,decimal v_VUANID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_TYPE_TK",v_TYPETK),
                new OracleParameter("V_VUAN_ID",v_VUANID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_TK.GDKTTT_VUAN_TK_GETBYID", prm);
        }

        public bool GDKTTT_VUAN_TK_DEL(string v_TYPETK, decimal v_VUANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_TK.GDKTTT_VUAN_TK_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TYPE_TK"].Value = v_TYPETK;
            comm.Parameters["V_VUAN_ID"].Value = v_VUANID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }
        public DataTable GDKTTT_VUAN_GET_ALL_ANLE()
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_TK.GDKTTT_VUAN_GET_ALL_ANLE", prm);
        }

    }
}