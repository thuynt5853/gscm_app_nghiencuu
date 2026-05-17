using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Data;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;

namespace BL.THONGKE
{
  public class M_Export_Permissions
    {
        public List<Functions> Function_List_Per(Int32 _ID_PARENT, String _USERNAME)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_EXPORT_PERMISSIONS.TC_FUNC_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_ID_PARENT"].Value = _ID_PARENT;
            comm.Parameters["V_USERNAME"].Value = _USERNAME;
            try
            {
                return Database.Bind_List_Reader<Functions>(comm);
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
        public List<Functions> Function_List_Per_District_Provin(String V_TYPEUSERS, Int32 _ID_PARENT, String _USERNAME)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_EXPORT_PERMISSIONS.TC_FUNC_LIST_DISTRICT_PROVIN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_TYPEUSERS"].Value = V_TYPEUSERS;
            comm.Parameters["V_ID_PARENT"].Value = _ID_PARENT;
            comm.Parameters["V_USERNAME"].Value = _USERNAME;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;

            try
            {
                return Database.Bind_List_Reader<Functions>(comm);
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
        public Functions Function_List_ID(Int32 _ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_EXPORT_PERMISSIONS.TC_FUNC_LIST_ID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_ID"].Value = _ID;
            try
            {
                return Database.Bind_Object_Reader<Functions>(comm);
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
    }
}
