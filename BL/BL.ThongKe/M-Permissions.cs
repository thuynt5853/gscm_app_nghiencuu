using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Data;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE
{
    public class M_Permissions
    {
        public void Permissions_Actions(Int32 ID_Actions)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_PERMISSIONS_ENABLE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID_PERMISSIONS"].Value = ID_Actions;
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
        public List<Permissions> Permissions_List()
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_PERMISSIONS_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;           
            try
            {
                return Database.Bind_List_Reader<Permissions>(comm);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        public List<Permissions> Permissions_Options()
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_PERMISSIONS_LIST_OPTION", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Permissions>(comm);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        public bool Permissions_Update(Permissions obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_PERMISSIONS_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_PERMISSION_NAME"].Value = obj.PERMISSION_NAME;
            comm.Parameters["v_UPDATE_ID"].Value = obj.ID;
            comm.Parameters["V_CREATE_DATE"].Value = obj.CREATE_DATE;
            comm.Parameters["V_CREATE_USER"].Value = obj.CREATE_USER;
            comm.Parameters["V_DESCRIPTION"].Value = obj.DESCRIPTION;            
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
        public bool Permissions_Insert(Permissions obj, ref Int32 Value_ID_Permission, ref Int32 V_COUNT_PERM_NAME)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_PERMISSIONS_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_PERMISSION_NAME"].Value = obj.PERMISSION_NAME;
            comm.Parameters["V_ENABLE"].Value = obj.ENABLE;
            comm.Parameters["V_CREATE_DATE"].Value = obj.CREATE_DATE;
            comm.Parameters["V_CREATE_USER"].Value = obj.CREATE_USER;
            comm.Parameters["V_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["v_Value_ID"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COUNT_PERM_NAME"].Direction = ParameterDirection.Output;
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
                Value_ID_Permission = Convert.ToInt32(comm.Parameters["v_Value_ID"].Value.ToString());
                V_COUNT_PERM_NAME = Convert.ToInt32(comm.Parameters["V_COUNT_PERM_NAME"].Value.ToString());
                conn.Close();
            }
        }
        public void Permissions_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_PERMISSIONS where ID IN(" + _Value_List_Delete + ")", conn);
            comm.CommandType = CommandType.Text;
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
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
