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
   public class M_Send_Unsents
    {
        public List<Judge_Report> Send_Unsents_Export(String v_TYPE_COURT, String v_TYPES_OF, String v_list_court, String V_ID_REPORT_TIME, String v_ACTIVE_REPORT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_SEND_UNSENT_EXP.TC_SEND_UNSENT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_TYPE_COURT", OracleDbType.Varchar2).Value = v_TYPE_COURT;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Varchar2).Value = v_TYPES_OF;
            comm.Parameters.Add("v_list_court", OracleDbType.Clob).Value = v_list_court;
            comm.Parameters.Add("V_ID_REPORT_TIME", OracleDbType.Varchar2).Value = V_ID_REPORT_TIME;
            comm.Parameters.Add("v_ACTIVE_REPORT", OracleDbType.Varchar2).Value = v_ACTIVE_REPORT;
            try
            {
                return Database.Bind_List_Reader<Judge_Report>(comm);
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
        public List<Judge_Report> Send_Unsents_Export_CW(String v_TYPE_COURT, String v_TYPES_OF, String v_list_court, String V_ID_REPORT_TIME, String v_ACTIVE_REPORT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_SEND_UNSENT_EXP.TC_SEND_UNSENT_CW", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_TYPE_COURT", OracleDbType.Varchar2).Value = v_TYPE_COURT;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Varchar2).Value = v_TYPES_OF;
            comm.Parameters.Add("v_list_court", OracleDbType.Clob).Value = v_list_court;
            comm.Parameters.Add("V_ID_REPORT_TIME", OracleDbType.Varchar2).Value = V_ID_REPORT_TIME;
            comm.Parameters.Add("v_ACTIVE_REPORT", OracleDbType.Varchar2).Value = v_ACTIVE_REPORT;
            try
            {
                return Database.Bind_List_Reader<Judge_Report>(comm);
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
        public List<Judge_Report> Send_Unsents_Export_TW(String v_TYPE_COURT, String v_TYPES_OF, String v_list_court, String V_ID_REPORT_TIME, String v_ACTIVE_REPORT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_SEND_UNSENT_EXP.TC_SEND_UNSENT_TW", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_TYPE_COURT", OracleDbType.Varchar2).Value = v_TYPE_COURT;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Varchar2).Value = v_TYPES_OF;
            comm.Parameters.Add("v_list_court", OracleDbType.Clob).Value = v_list_court;
            comm.Parameters.Add("V_ID_REPORT_TIME", OracleDbType.Varchar2).Value = V_ID_REPORT_TIME;
            comm.Parameters.Add("v_ACTIVE_REPORT", OracleDbType.Varchar2).Value = v_ACTIVE_REPORT;
            try
            {
                return Database.Bind_List_Reader<Judge_Report>(comm);
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
