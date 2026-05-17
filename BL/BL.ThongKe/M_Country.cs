using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Data;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using BL.THONGKE;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;


namespace BL.THONGKE
{
    public class M_Country
    {
        public List<Country> Country_List()
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.TC_COUNTRY_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;           
            try
            {
                return Database.Bind_List_Reader<Country>(comm);
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
        public List<Country> Country_List_Page(String _ID,String _KEYS_NAME, String _COUNTRY_NAME, String _COUNTRY_NAME_VN, Int32 _NumberIndex, Int32 _PageIndex)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.TC_COUNTRY_LIST_PAGE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID"].Value = _ID;
            comm.Parameters["V_KEYS_NAME"].Value = _KEYS_NAME;
            comm.Parameters["V_COUNTRY_NAME"].Value = _COUNTRY_NAME;
            comm.Parameters["V_COUNTRY_NAME_VN"].Value = _COUNTRY_NAME_VN;
            comm.Parameters["V_NumberIndex"].Value = _NumberIndex;
            comm.Parameters["v_PageIndex"].Value = _PageIndex;      
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Country>(comm);
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
        public bool CountrNation_Delete(string _V_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.DELETE_COUNTRY", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = _V_ID;          
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
        public bool Room_Staffs_Insert_Update(Country obj, ref Int32 Value_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.COUNTRY_INST_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_KEYS_NAME"].Value = obj.KEYS_NAME;
            comm.Parameters["V_COUNTRY_NAME"].Value = obj.COUNTRY_NAME;
            comm.Parameters["V_COUNTRY_NAME_VN"].Value = obj.COUNTRY_NAME_VN;   
            comm.Parameters["v_Value_ID"].Direction = ParameterDirection.Output;
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
                Value_ID = Convert.ToInt32(comm.Parameters["v_Value_ID"].Value);
                conn.Close();
            }
        }
        public Country Country_Listt_ID(int _ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.COUNTRY_LIST_ID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID"].Value = _ID;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_Object_Reader<Country>(comm);
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

        public List<Country> Country_Destination_List(Int32 _ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.COUNTRY_DESTINATION_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID_PLUGIN"].Value = _ID;          
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Country>(comm);
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
        public List<Country> Country_Sorce_List(Int32 _ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COUNTRY.COUNTRY_SOURCE_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID_PLUGIN"].Value = _ID;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Country>(comm);
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
