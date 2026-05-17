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
    public class M_Chapters
    {
        public bool Chapters_Update(Chapters obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CHAPTERS_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CHAPTER_ID"].Value = obj.CHAPTER_ID;
            comm.Parameters["v_CHAPER_NAME"].Value = obj.CHAPER_NAME;
            comm.Parameters["v_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["v_ID_Update"].Value = obj.ID;
            comm.Parameters["v_TIMES"].Value = obj.TIMES;
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
        public bool Chapters_Insert(Chapters obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CHAPTERS_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CHAPTER_ID"].Value = obj.CHAPTER_ID;
            comm.Parameters["v_CHAPER_NAME"].Value = obj.CHAPER_NAME;            
            comm.Parameters["v_DESCRIPTION"].Value = obj.DESCRIPTION;
            comm.Parameters["v_TIMES"].Value = obj.TIMES;    
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
        public List<Chapters> Chapters_List(Int16 Times)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CHAPTERS_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);           
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_TIMES"].Value = Times;
            try
            {
                return Database.Bind_List_Reader<Chapters>(comm);
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
        public void Chapters_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_CHAPTERS where ID IN(" + _Value_List_Delete + ")", conn);
            comm.CommandType = CommandType.Text;
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            try
            {
                M_Criminals M_object = new M_Criminals();
                M_object.Criminals_Delete_Chapters(_Value_List_Delete);
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
