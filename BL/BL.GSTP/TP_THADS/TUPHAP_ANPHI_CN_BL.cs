using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.TP_THADS
{
    public class TUPHAP_ANPHI_CN_BL
    {
        public bool TUPHAP_ANPHI_CN_INS_UP(TUPHAP_ANPHI_CN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_CN.TUPHAP_ANPHI_CN_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TUPHAP_ANPHI_ID"].Value = obj.TUPHAP_ANPHI_ID;           
            comm.Parameters["V_NGUOI_TAO"].Value = obj.NGUOI_TAO;
            comm.Parameters["V_TRANG_THAI"].Value = obj.TRANG_THAI;
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
                conn.Close();
            }
        }
        public DataTable TUPHAP_ANPHI_CN_GET_ID(decimal V_TUPHAP_ANPHI_ID)
        {
            OracleParameter[] parameters = new OracleParameter[]
               {
                new OracleParameter("V_TUPHAP_ANPHI_ID",V_TUPHAP_ANPHI_ID),
                new OracleParameter("ITEMS_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output)
               };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI_CN.TUPHAP_ANPHI_CN_GET_ID", parameters);
            return tbl;
        }
    }
}