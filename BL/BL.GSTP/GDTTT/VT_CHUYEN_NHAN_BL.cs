using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;
namespace BL.GSTP.GDTTT
{
    public class VT_CHUYEN_NHAN_BL
    {
        public bool VT_CHUYEN_INS(VT_CHUYEN_NHAN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_CHUYEN_INS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_VANBANDEN_ID"].Value = obj.VANBANDEN_ID;
            comm.Parameters["V_DONVI_CHUYEN_ID"].Value = obj.DONVI_CHUYEN_ID;
            comm.Parameters["V_CANBO_CHUYEN_ID"].Value = obj.CANBO_CHUYEN_ID;
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
        public void VT_HUY_CHUYEN(string V_VANBANDEN_ID,ref String V_CANBO_NHAN_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_HUY_CHUYEN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_CANBO_NHAN_ID"].Direction = ParameterDirection.Output;
            comm.Parameters["V_VANBANDEN_ID"].Value = V_VANBANDEN_ID;
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
                V_CANBO_NHAN_ID = Convert.ToString(comm.Parameters["V_CANBO_NHAN_ID"].Value);
                conn.Close();
            }
        }
        public bool VT_NHAN_INS_UP(Decimal V_TOAANID,VT_CHUYEN_NHAN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_NHAN_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_VANBANDEN_ID"].Value = obj.VANBANDEN_ID;
            comm.Parameters["V_CANBO_NHAN_ID"].Value = obj.CANBO_NHAN_ID;
            comm.Parameters["V_USERNAME_NHAN"].Value = obj.USERNAME_NHAN;
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
        public bool VT_HUY_NHAN(string V_VANBANDEN_ID, ref String V_TRANG_THAI_XLY)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_HUY_NHAN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TRANG_THAI_XLY"].Direction = ParameterDirection.Output;
            comm.Parameters["V_VANBANDEN_ID"].Value = V_VANBANDEN_ID;
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
                V_TRANG_THAI_XLY = Convert.ToString(comm.Parameters["V_TRANG_THAI_XLY"].Value);
                conn.Close();
            }
        }
        public bool VT_HUY_NHAN_IN_DELETE_HCTP(string V_VANBANDEN_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_HUY_NHAN_IN_DELETE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_VANBANDEN_ID"].Value = V_VANBANDEN_ID;
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
        public bool TRANGTHAI_XULY_UP(String V_GDTTT_DON_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.VT_DAXULY_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_GDTTT_DON_ID"].Value = V_GDTTT_DON_ID;
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
        public DataTable GET_VANTHUDEN(decimal vVANTHUDENID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_ID",vVANTHUDENID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.VT_VANBANDEN_BY_ID", prm);
        }

        public DataTable GET_VANBAN_CHUYENNHAN(decimal vDonID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("V_DonID",vDonID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.VT_CHUYEN_NHAN_BY_DONID", prm);
        }

        public DataTable VT_CHUYENNHAN_BY_VANBANDEN_ID(Decimal V_VANBANDEN_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                 new OracleParameter("V_VANBANDEN_ID",V_VANBANDEN_ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_VANTHU_DEN.VT_CHUYENNHAN_BY_VANBANDEN_ID", parameters);
            return tbl;
        }

        public bool TRANG_THAI_XLY_UP(Decimal V_ID, Decimal V_TRANG_THAI_XLY)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_VANTHU_DEN.TRANG_THAI_XLY_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = V_ID;
            comm.Parameters["V_TRANG_THAI_XLY"].Value = V_TRANG_THAI_XLY;
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
    }
}