using BL.GSTP.BANGSETGET;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;


namespace BL.GSTP
{
    public class VALIDATE_TAIKHOAN_BL
    {
        public bool VALIDATE_TAIKHOAN_INSERT(VALIDATE_TAIKHOAN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VALIDATE_TAIKHOAN.VALIDATE_TAIKHOAN_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_NGAY_THAY_DOI_MK"].Value = obj.NGAY_THAY_DOI_MK;
            comm.Parameters["V_MATKHAU_OLD"].Value = obj.MATKHAU_OLD;
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
    }
}