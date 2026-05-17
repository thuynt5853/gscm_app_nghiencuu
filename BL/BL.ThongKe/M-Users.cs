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
    public class M_Users
    {
        public bool Users_Change_Password(String v_User, String v_PassWord)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USERS_CHANGE_PASSWORD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_USERNAME"].Value = v_User;
            comm.Parameters["V_PASSWORD"].Value = Security.EncryptPass("!acnvnsoft@", v_PassWord);
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
        public bool Users_Update_Info(Users obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USERS_UPDATE_INFO", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;       
            comm.Parameters["V_FULLNAME"].Value = obj.FULLNAME;
            comm.Parameters["V_SEX"].Value = obj.SEX;                   
            comm.Parameters["V_ID_DEPARTMENT"].Value = obj.ID_DEPARTMENT;
            comm.Parameters["V_ADDRESS"].Value = obj.ADDRESS;
            comm.Parameters["V_PHONE"].Value = obj.PHONE;
            comm.Parameters["V_MOBILE"].Value = obj.MOBILE;
            comm.Parameters["V_EMAIL"].Value = obj.EMAIL;           
            comm.Parameters["V_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["V_ID_PARTS"].Value = obj.ID_PARTS;           
            comm.Parameters["V_ID_UPDATE"].Value = obj.ID;
            comm.Parameters["V_ID_BIRTHDAY"].Value = obj.BIRTHDAY;              
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
        public Users Get_Users_Check(String _users)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USERS_GET", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_USERNAME"].Value = _users;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;

            try
            {
                return Database.Bind_Object_Reader<Users>(comm);

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
        public Users Get_Users_Login(string _users, string _Password)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USER_LOGIN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_Password"].Value = Security.EncryptPass("!acnvnsoft@", _Password);
            comm.Parameters["v_Users"].Value = _users;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_Object_Reader<Users>(comm);               

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
        public bool Users_Insert(Users obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USERS_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_USERNAME"].Value = obj.USERNAME;
            comm.Parameters["V_PASSWORD"].Value = obj.PASSWORD;
            comm.Parameters["V_FULLNAME"].Value = obj.FULLNAME;
            comm.Parameters["V_SEX"].Value = obj.SEX;          
            comm.Parameters["V_ID_JOBTITLE"].Value = obj.ID_JOBTITLE;
            comm.Parameters["V_ID_DEPARTMENT"].Value = obj.ID_DEPARTMENT;
            comm.Parameters["V_ADDRESS"].Value = obj.ADDRESS;
            comm.Parameters["V_PHONE"].Value = obj.PHONE;
            comm.Parameters["V_MOBILE"].Value = obj.MOBILE;
            comm.Parameters["V_EMAIL"].Value = obj.EMAIL;
            comm.Parameters["V_ID_PERMISSION"].Value = obj.ID_PERMISSION;
            comm.Parameters["V_ID_COURT"].Value = obj.ID_COURT;
            comm.Parameters["V_CREATE_DATE"].Value = obj.CREATE_DATE;
            comm.Parameters["V_ENABLE"].Value = obj.ENABLE;
            comm.Parameters["V_STATUS"].Value = obj.STATUS;
            comm.Parameters["V_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["V_ID_PARTS"].Value = obj.ID_PARTS;
            comm.Parameters["v_BIRTHDAY"].Value = obj.BIRTHDAY;                        
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
        public bool Users_Update(Users obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USERS_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_USERNAME"].Value = obj.USERNAME;
            comm.Parameters["V_PASSWORD"].Value = obj.PASSWORD;
            comm.Parameters["V_FULLNAME"].Value = obj.FULLNAME;
            comm.Parameters["V_SEX"].Value = obj.SEX;         
            comm.Parameters["V_ID_JOBTITLE"].Value = obj.ID_JOBTITLE;
            comm.Parameters["V_ID_DEPARTMENT"].Value = obj.ID_DEPARTMENT;
            comm.Parameters["V_ADDRESS"].Value = obj.ADDRESS;
            comm.Parameters["V_PHONE"].Value = obj.PHONE;
            comm.Parameters["V_MOBILE"].Value = obj.MOBILE;
            comm.Parameters["V_EMAIL"].Value = obj.EMAIL;
            comm.Parameters["V_ID_PERMISSION"].Value = obj.ID_PERMISSION;
            comm.Parameters["V_ID_COURT"].Value = obj.ID_COURT;
            comm.Parameters["V_CREATE_DATE"].Value = obj.CREATE_DATE;
            comm.Parameters["V_ENABLE"].Value = obj.ENABLE;
            comm.Parameters["V_STATUS"].Value = obj.STATUS;
            comm.Parameters["V_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["V_ID_PARTS"].Value = obj.ID_PARTS;            
            comm.Parameters["V_ID_UPDATE"].Value = obj.ID;
            comm.Parameters["v_BIRTHDAY"].Value = obj.BIRTHDAY;            
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
        public List<Users> User_List(int PageIndex, String sevalue, String _Option, String id_levels, String id_Users, Int32 _NumberIndex)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USER_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_PageIndex"].Value = PageIndex;
            comm.Parameters["v_values"].Value = sevalue;
            comm.Parameters["v_Option"].Value = _Option;
            comm.Parameters["v_Id_Level"].Value = id_levels;
            comm.Parameters["v_Id_User"].Value = id_Users;
            comm.Parameters["V_NumberIndex"].Value = _NumberIndex;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Users>(comm);
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
        public void Users_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USERS_DELETE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = _Value_List_Delete;
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
        public void Users_Action(String User_id)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_USER.TC_USER_ACTION", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_Users_Name"].Value = User_id;           
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
