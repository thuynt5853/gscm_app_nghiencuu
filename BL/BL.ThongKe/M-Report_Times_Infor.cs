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
    public class M_ReportTimes_Infor
    {
        public Report_Times_Infor Report_Times_Infor_List(Int32 v_COURT_ID, Int32 v_REPORT_TIME_ID, Int32 v_TYPE_OF)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_INFOR_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_ID_REPORT_TIME"].Value = v_REPORT_TIME_ID;
            comm.Parameters["v_ID_COURTS"].Value = v_COURT_ID;
            comm.Parameters["v_TYPE_OF"].Value = v_TYPE_OF;
            try
            {
                return Database.Bind_Object_Reader<Report_Times_Infor>(comm);
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
        public List<Report_Times_Infor> M_Report_List_Exports_Statistics_De_New(Int32 v_REPORT_TIME_ID, String V_TYPES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_STATI_NEW", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE"].Value = V_TYPES;
            comm.Parameters["V_ID_REPORT_TIME"].Value = v_REPORT_TIME_ID;  

            try
            {
                return Database.Bind_List_Reader<Report_Times_Infor>(comm);
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
        public List<Report_Times_Infor> Report_Times_Infor_List_Couts_New(Int32 v_COURT_ID, Int32 V_ID_REPORT_TIMES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIME_LIST_NEWSS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;           
            comm.Parameters["v_ID_COURTS"].Value = v_COURT_ID;
            comm.Parameters["V_ID_REPORT_TIME"].Value = V_ID_REPORT_TIMES;  
          
            try
            {
                return Database.Bind_List_Reader<Report_Times_Infor>(comm);
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
        public bool Report_Times_Infor_Update(Report_Times_Infor obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_INFORS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_USER_WRITE"].Value = obj.USER_WRITE;
            comm.Parameters["v_USER_SIGNER"].Value = obj.USER_SIGNER;
            comm.Parameters["v_DATETIME_ACTIVE"].Value = obj.DATETIME_ACTIVE;
            comm.Parameters["v_ID_REPORT_TIME"].Value = obj.ID_REPORT_TIME;
            comm.Parameters["v_ID_COURTS"].Value = obj.ID_COURTS;
            comm.Parameters["v_TYPE_OF"].Value = obj.TYPE_OF;
            comm.Parameters["v_ACTIVE_REPORT"].Value = obj.ACTIVE_REPORT;
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
        public bool Report_Times_Infor_Update_Active_Send(Report_Times_Infor obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("VI_REPORT_INFOR_ACTIVE_SEND", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID_REPORT_TIME"].Value = obj.ID_REPORT_TIME;
            comm.Parameters["v_ID_COURTS"].Value = obj.ID_COURTS;
            comm.Parameters["v_TYPE_OF"].Value = obj.TYPE_OF;
            comm.Parameters["v_ACTIVE_SEND"].Value = obj.ACTIVE_SEND;
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
        public bool Report_Times_Infor_return(Int32 v_ID_REPORT_TIME, Int32 v_ID_COURTS, Int32 v_TYPE_OF)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_RETURN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID_REPORT_TIME"].Value = v_ID_REPORT_TIME;
            comm.Parameters["v_ID_COURTS"].Value = v_ID_COURTS;
            comm.Parameters["v_TYPE_OF"].Value = v_TYPE_OF;
            comm.Parameters["v_ACTIVE_REPORT"].Value = 0;
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
