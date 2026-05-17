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
    public class M_ReportTimes
    {
        public void ReportTime_Action(Int32 id_ReportTime)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORTTIME_ACTION", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_REPORT_ID"].Value = id_ReportTime;
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
        public bool ReportTimes_Update(Report_Times obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_TIME_ID"].Value = obj.TIME_ID;
            comm.Parameters["v_TIME_NAME"].Value = obj.TIME_NAME;
            comm.Parameters["v_TIME_FROM"].Value = obj.TIME_FROM;
            comm.Parameters["v_TIME_TO"].Value = obj.TIME_TO;  
            comm.Parameters["v_ID_Update"].Value = obj.ID;
            comm.Parameters["v_INDEX_SORT"].Value = obj.INDEX_SORT;           
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
        public Report_Times ReportTimes_Check_Send(Int32 v_ReTimeID_, Int32 V_COURTS_ID_, Int32 V_TYPE_OF_, Int32 V_CHECK_, Int32 V_TYPES_REPORT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_CHECK_REPORT_TIMES_SENDS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_ReTimeID"].Value = v_ReTimeID_;
            comm.Parameters["V_COURTS_ID"].Value = V_COURTS_ID_;
            comm.Parameters["V_TYPE_OF"].Value = V_TYPE_OF_;
            comm.Parameters["V_CHECK"].Value = V_CHECK_;
            comm.Parameters["V_TYPES_REPORT"].Value = V_TYPES_REPORT;            
            try
            {
                return Database.Bind_Object_Reader<Report_Times>(comm);
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
        public bool Report_Times_Insert(Report_Times obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_TIME_ID"].Value = obj.TIME_ID;
            comm.Parameters["v_TIME_NAME"].Value = obj.TIME_NAME;
            comm.Parameters["v_TIME_FROM"].Value = obj.TIME_FROM;
            comm.Parameters["v_TIME_TO"].Value = obj.TIME_TO;
            comm.Parameters["v_INDEX_SORT"].Value = obj.INDEX_SORT;
            comm.Parameters["v_TYPES_REPORT"].Value = obj.TYPES_REPORT;  
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
        public List<Report_Times> Report_Times_List_Options(Int32 v_ID_Courts, Int32 v_OPTIONS, Int32 V_TYPE_OF, Int32 V_TYPES_REPORT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_LIST_OPTIONS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_ID_COURTS"].Value = v_ID_Courts;
            comm.Parameters["v_OPTIONS"].Value = v_OPTIONS;
            comm.Parameters["V_TYPE_OF"].Value = V_TYPE_OF;
            comm.Parameters["V_TYPES_REPORT"].Value = V_TYPES_REPORT;
            try
            {
                return Database.Bind_List_Reader<Report_Times>(comm);
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
        public Report_Times Report_Time_From_To(Int32 Time_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIME_FROM_TO", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_TimeID"].Value = Time_ID;
            try
            {
                return Database.Bind_Object_Reader<Report_Times>(comm);
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
        public void Report_Time_Sort_Order(int News_id, int order)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_SORT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_REPORT_ID"].Value = News_id;
            comm.Parameters["v_INDEX_SORT"].Value = order;
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
        public List<Report_Times> Report_Times_List(ref String V_LAST_ID_TIME_NAME, ref String V_LAST_TIME_NAME, ref DateTime V_LAST_MONTH_FROM, ref DateTime V_LAST_MONTH_TO,ref Decimal V_LAST_INDEX_SORT,Int32 V_TYPES_REPORT, String values, String Indexs, int PageIndex)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_TYPES_REPORT"].Value = V_TYPES_REPORT;
            comm.Parameters["v_PageIndex"].Value = PageIndex;               
            comm.Parameters["v_values"].Value = values; 
            comm.Parameters["v_Indexs"].Value = Indexs;
            comm.Parameters["V_LAST_ID_TIME_NAME"].Direction = ParameterDirection.Output;
            comm.Parameters["V_LAST_TIME_NAME"].Direction = ParameterDirection.Output;
            comm.Parameters["V_LAST_MONTH_FROM"].Direction = ParameterDirection.Output;
            comm.Parameters["V_LAST_MONTH_TO"].Direction = ParameterDirection.Output;
            comm.Parameters["V_LAST_INDEX_SORT"].Direction = ParameterDirection.Output;          
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
 
            try
            {
                return Database.Bind_List_Reader<Report_Times>(comm);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                V_LAST_ID_TIME_NAME = Convert.ToString(comm.Parameters["V_LAST_ID_TIME_NAME"].Value);
                V_LAST_TIME_NAME = Convert.ToString(comm.Parameters["V_LAST_TIME_NAME"].Value);
                V_LAST_MONTH_FROM = Convert.ToDateTime(comm.Parameters["V_LAST_MONTH_FROM"].Value);
                V_LAST_MONTH_TO = Convert.ToDateTime(comm.Parameters["V_LAST_MONTH_TO"].Value);
                V_LAST_INDEX_SORT = Convert.ToDecimal(comm.Parameters["V_LAST_INDEX_SORT"].Value);
                conn.Close();
            }
        }
        public List<Report_Times> Report_Times_List_Statistics(Int32 V_TYPES_REPORT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_REPORT_TIMES.TC_REPORT_TIMES_LIST_TK", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_TYPES_REPORT"].Value = V_TYPES_REPORT;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Report_Times>(comm);
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
        public void ReportTimes_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_REPORT_TIMES where ID IN(" + _Value_List_Delete + ")", conn);
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
