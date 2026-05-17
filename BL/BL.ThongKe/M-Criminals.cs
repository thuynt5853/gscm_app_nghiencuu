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
    public class M_Criminals
    {
        public List<Criminals> Criminals_List_OfChapters(String _LIST_CHAPTER)
        {

            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_LIST_OF_CHAP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);           
            comm.Parameters["V_LIST_CHAPTER"].Value = _LIST_CHAPTER;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Criminals>(comm);
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
        public bool Criminals_Update(Criminals obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_CRIMINALS_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CRIMINAL_ID"].Value = obj.CRIMINAL_ID;
            comm.Parameters["v_CRIMINAL_NAME"].Value = obj.CRIMINAL_NAME;
            comm.Parameters["v_CHAPTER_ID"].Value = obj.CHAPTER_ID;
            comm.Parameters["v_YOUTH"].Value = obj.YOUTH;
            comm.Parameters["v_DEATH"].Value = obj.DEATH;
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
        public bool Criminals_Insert(Criminals obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_CRIMINALS_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CRIMINAL_ID"].Value = obj.CRIMINAL_ID;
            comm.Parameters["v_CRIMINAL_NAME"].Value = obj.CRIMINAL_NAME;
            comm.Parameters["v_CHAPTER_ID"].Value = obj.CHAPTER_ID;
            comm.Parameters["v_YOUTH"].Value = obj.YOUTH;
            comm.Parameters["v_DEATH"].Value = obj.DEATH;  
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
        public List<Criminals> Criminals_List(Int32 Chapter_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_CRIMINALS_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);           
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_CHAPTERS"].Value = Chapter_ID;
            try
            {
                return Database.Bind_List_Reader<Criminals>(comm);
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
        public List<Criminals> Criminals_Of_Judge(Int32 _TYPES, Int32 ReportTime_ID,Int32 Court_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_CRIMINAL.TC_CASES_OF", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);           
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["V_REPORT_TIME_ID"].Value = ReportTime_ID;
            comm.Parameters["V_COURTS_ID"].Value = Court_ID;            
            try
            {
                return Database.Bind_List_Reader<Criminals>(comm);
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
        public List<Criminals> Criminals_Of_Youth(Int32 ReportTime_ID, Int32 Court_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("VI_CRIMINALS_OF_YOUTHS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_REPORT_TIME_ID"].Value = ReportTime_ID;
            comm.Parameters["V_COURTS_ID"].Value = Court_ID;
            try
            {
                return Database.Bind_List_Reader<Criminals>(comm);
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
        public List<Criminals> Criminals_Of_Appeals(String _COURT_EXTID, Int32 _TYPES, Int32 ReportTime_ID, Int32 Court_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CRIMINAL_APPEAL.TC_CRIMINAL_APP_CASES_OF", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["V_REPORT_TIME_ID"].Value = ReportTime_ID;
            comm.Parameters["V_COURTS_ID"].Value = Court_ID;
            try
            {
                return Database.Bind_List_Reader<Criminals>(comm);
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
        public Criminals Criminals_Name(Int32 Criminal_ID)
         {
             OracleConnection conn = Database.Connection();
             OracleCommand comm = new OracleCommand("PKG_CATEGORY_CRIMINALS.TC_CRIMINALS_NAME", conn);
             comm.CommandType = CommandType.StoredProcedure;
             OracleCommandBuilder.DeriveParameters(comm);
             comm.Parameters["v_CRIMINAL_ID"].Value = Criminal_ID;
             comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
             try
             {
                 return Database.Bind_Object_Reader<Criminals>(comm);
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
        public void Criminals_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_CRIMINALS where ID IN(" + _Value_List_Delete + ")", conn);
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
        public void Criminals_Delete_Chapters(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From VI_CRIMINALS where CHAPTER_ID IN(" + _Value_List_Delete + ")", conn);
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
