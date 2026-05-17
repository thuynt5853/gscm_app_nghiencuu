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
    public class M_Departments
    {
        public bool Departments_Update(Departments obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_DEPARTMENT_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID_DEPARTMENT"].Value = obj.ID_DEPARTMENT;
            comm.Parameters["v_DEPARTMENT_NAME"].Value = obj.DEPARTMENT_NAME;
            comm.Parameters["v_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["v_ID_Update"].Value = obj.ID;
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
        public void Departments_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From VI_DEPARTMENTS where ID IN(" + _Value_List_Delete + ")", conn);
            comm.CommandType = CommandType.Text;
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            try
            {
                M_Parts M_Object = new M_Parts();
                M_Object.Parts_Delete_Departments(_Value_List_Delete);               
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
        public List<Departments> Departments_List()
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_DEPARTMENT_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);            
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;            
            try
            {
                return Database.Bind_List_Reader<Departments>(comm);
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
        public bool Departments_Insert(Departments obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_DEPARTMENT_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID_DEPARTMENT"].Value = obj.ID_DEPARTMENT;
            comm.Parameters["v_DEPARTMENT_NAME"].Value = obj.DEPARTMENT_NAME;            
            comm.Parameters["v_DESCRIPTION"].Value = obj.DESCRIPTION;
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
