using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP
{
    public class GIAI_DOAN_BL
    {
        public bool GAIDOAN_UPDATE(String V_LOAI_AN, decimal V_VUAN_DONID, decimal V_MAGIAIDOAN, decimal V_TOAANID,
                                            decimal V_TOAPHUCTHAMID, decimal V_TOACAPCAOID, decimal V_TOANTOICAOID, decimal V_PHONGBANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_VUAN_DONID"].Value = V_VUAN_DONID;
            comm.Parameters["V_MAGIAIDOAN"].Value = V_MAGIAIDOAN;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_TOAPHUCTHAMID"].Value = V_TOAPHUCTHAMID;
            comm.Parameters["V_TOACAPCAOID"].Value = V_TOACAPCAOID;
            comm.Parameters["V_TOANTOICAOID"].Value = V_TOANTOICAOID;
            comm.Parameters["V_PHONGBANID"].Value = V_PHONGBANID;
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
        public bool GAIDOAN_INSERT_UPDATE(String V_LOAI_AN, decimal V_VUAN_DONID, decimal V_MAGIAIDOAN, decimal V_TOAANID,
                                            decimal V_TOAPHUCTHAMID, decimal V_TOACAPCAOID, decimal V_TOANTOICAOID, decimal V_PHONGBANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_IN_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_VUAN_DONID"].Value = V_VUAN_DONID;
            comm.Parameters["V_MAGIAIDOAN"].Value = V_MAGIAIDOAN;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_TOAPHUCTHAMID"].Value = V_TOAPHUCTHAMID;
            comm.Parameters["V_TOACAPCAOID"].Value = V_TOACAPCAOID;
            comm.Parameters["V_TOANTOICAOID"].Value = V_TOANTOICAOID;
            comm.Parameters["V_PHONGBANID"].Value = V_PHONGBANID;
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
        
        public bool GAIDOAN_INSERT_UPDATE_V2(String V_LOAI_AN, decimal V_VUAN_DONID, decimal V_MAGIAIDOAN, decimal V_TOAANID,
            decimal V_TOAPHUCTHAMID, decimal V_TOACAPCAOID, decimal V_TOANTOICAOID, decimal V_PHONGBANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_IN_UP_V2", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_VUAN_DONID"].Value = V_VUAN_DONID;
            comm.Parameters["V_MAGIAIDOAN"].Value = V_MAGIAIDOAN;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_TOAPHUCTHAMID"].Value = V_TOAPHUCTHAMID;
            comm.Parameters["V_TOACAPCAOID"].Value = V_TOACAPCAOID;
            comm.Parameters["V_TOANTOICAOID"].Value = V_TOANTOICAOID;
            comm.Parameters["V_PHONGBANID"].Value = V_PHONGBANID;
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
        public bool GAIDOAN_INSERT_UPDATE_XXLAI_PHUCTHAM(String V_LOAI_AN, decimal V_VUAN_DONID, decimal V_MAGIAIDOAN, decimal V_TOAANID,
                                            decimal V_TOAPHUCTHAMID, decimal V_TOACAPCAOID, decimal V_TOANTOICAOID, decimal V_PHONGBANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_IN_UP_XXLAI_PHUCTHAM", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_VUAN_DONID"].Value = V_VUAN_DONID;
            comm.Parameters["V_MAGIAIDOAN"].Value = V_MAGIAIDOAN;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_TOAPHUCTHAMID"].Value = V_TOAPHUCTHAMID;
            comm.Parameters["V_TOACAPCAOID"].Value = V_TOACAPCAOID;
            comm.Parameters["V_TOANTOICAOID"].Value = V_TOANTOICAOID;
            comm.Parameters["V_PHONGBANID"].Value = V_PHONGBANID;
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

        public bool GAIDOAN_INSERT_UPDATE_XXLAI_SOTHAM(String V_LOAI_AN, decimal V_VUAN_DONID, decimal V_MAGIAIDOAN, decimal V_TOAANID,
                                            decimal V_TOAPHUCTHAMID, decimal V_TOACAPCAOID, decimal V_TOANTOICAOID, decimal V_PHONGBANID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_IN_UP_XXLAI_SOTHAM", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_VUAN_DONID"].Value = V_VUAN_DONID;
            comm.Parameters["V_MAGIAIDOAN"].Value = V_MAGIAIDOAN;
            comm.Parameters["V_TOAANID"].Value = V_TOAANID;
            comm.Parameters["V_TOAPHUCTHAMID"].Value = V_TOAPHUCTHAMID;
            comm.Parameters["V_TOACAPCAOID"].Value = V_TOACAPCAOID;
            comm.Parameters["V_TOANTOICAOID"].Value = V_TOANTOICAOID;
            comm.Parameters["V_PHONGBANID"].Value = V_PHONGBANID;
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

        public void GIAIDOAN_DELETES(String V_LOAI_AN, Decimal V_VUAN_DONID,Decimal V_MAGIAIDOAN)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            
            // OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_DELETE", conn);
            OracleCommand comm = new OracleCommand("PKG_STPT.GAIDOAN_DELETE_V2", conn);

            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAI_AN"].Value = V_LOAI_AN;
            comm.Parameters["V_VUAN_DONID"].Value = V_VUAN_DONID;
            comm.Parameters["V_MAGIAIDOAN"].Value = V_MAGIAIDOAN;
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
    }
}