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
using System.IO;


namespace BL.THONGKE
{
  public class M_Delegation9A
    {
        public List<Sanctions_Inst> Delegation9A_List_Full(String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A.TC_DELEG9A_LIST_FULL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
            try
            {
                return Database.Bind_List_Reader<Sanctions_Inst>(comm);
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
        public List<Sanctions_Inst> Delegation9A_List_Full(Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A.TC_DELEG9A_LIST_FULL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
            try
            {
                return Database.Bind_List_Reader<Sanctions_Inst>(comm);
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
        public List<Sanctions_Inst> Delegation9A_Return_list(Int32 _TYPES, Int32 RetimeID, Int32 COURTS_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A.TC_DELEG9A_RETURN_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_ReTimeID"].Value = RetimeID;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURTS_ID"].Value = COURTS_ID;
            comm.Parameters["v_Options"].Value = Options;
            try
            {
                return Database.Bind_List_Reader<Sanctions_Inst>(comm);
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
        public List<Sanctions_Inst> Delegation9A_List(String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A.TC_DELEG9A_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_Options"].Value = Options;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
            try
            {
                return Database.Bind_List_Reader<Sanctions_Inst>(comm);
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
        public List<Judge_Report> Delegation9A_Export(String _COURT_EXTID, String v_COURT_NAME, String _CASES_ID, Int32 _TYPES_OF, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A.TC_DELEG9A_EXP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Varchar2).Value = _COURT_EXTID;
            comm.Parameters.Add("v_COURT_NAME", OracleDbType.NVarchar2).Value = v_COURT_NAME;
            comm.Parameters.Add("P_CASES_ID", OracleDbType.Varchar2).Value = _CASES_ID;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = _TYPES_OF;
            comm.Parameters.Add("v_COURT_ID", OracleDbType.Varchar2).Value = _COURT_ID;
            comm.Parameters.Add("v_REPORT_TIME_ID", OracleDbType.Varchar2).Value = Time_ID;
			comm.Parameters.Add("v_REPORT_TIME_ID2", OracleDbType.Varchar2).Value = Time_ID2;
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

        // bao cao

        public List<Judge_Report> Judge_Export_TD(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A_EXP.TC_DELEG9A_DETAIL_TD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_TYPE_COURT", OracleDbType.Varchar2).Value = v_TYPE_COURT;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = v_TYPES_OF;
            comm.Parameters.Add("v_Names", OracleDbType.Varchar2).Value = v_Names;
            comm.Parameters.Add("v_list_court", OracleDbType.Clob).Value = v_list_court;
            comm.Parameters.Add("v_list_criminal", OracleDbType.Varchar2).Value = v_list_criminal;
            comm.Parameters.Add("v_from", OracleDbType.Date).Value = v_from;
            comm.Parameters.Add("v_to", OracleDbType.Date).Value = v_to;
            comm.Parameters.Add("v_Options", OracleDbType.Decimal).Value = v_Options;
            comm.Parameters.Add("v_owis", OracleDbType.Decimal).Value = owis;
            comm.Parameters.Add("v_th", OracleDbType.Decimal).Value = th;
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
        public List<Judge_Report> Judge_TOTAL_63(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A_EXP.TC_DELEG9A_TOTAL_63", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_TYPE_COURT", OracleDbType.Varchar2).Value = v_TYPE_COURT;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = v_TYPES_OF;
            comm.Parameters.Add("v_Names", OracleDbType.Varchar2).Value = v_Names;
            comm.Parameters.Add("v_list_court", OracleDbType.Clob).Value = v_list_court;
            comm.Parameters.Add("v_list_criminal", OracleDbType.Varchar2).Value = v_list_criminal;
            comm.Parameters.Add("v_from", OracleDbType.Date).Value = v_from;
            comm.Parameters.Add("v_to", OracleDbType.Date).Value = v_to;
            comm.Parameters.Add("v_Options", OracleDbType.Decimal).Value = v_Options;
            comm.Parameters.Add("v_owis", OracleDbType.Decimal).Value = owis;
            comm.Parameters.Add("v_th", OracleDbType.Decimal).Value = th;
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

        public List<Judge_Report> Judge_Detail_All_01(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A_EXP.TC_DELE9A_DETAIL_ALL_01", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_TYPE_COURT", OracleDbType.Varchar2).Value = v_TYPE_COURT;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = v_TYPES_OF;
            comm.Parameters.Add("v_Names", OracleDbType.Varchar2).Value = v_Names;
            comm.Parameters.Add("v_list_court", OracleDbType.Clob).Value = v_list_court;
            comm.Parameters.Add("v_list_criminal", OracleDbType.Varchar2).Value = v_list_criminal;
            comm.Parameters.Add("v_from", OracleDbType.Date).Value = v_from;
            comm.Parameters.Add("v_to", OracleDbType.Date).Value = v_to;
            comm.Parameters.Add("v_Options", OracleDbType.Decimal).Value = v_Options;
            comm.Parameters.Add("v_owis", OracleDbType.Decimal).Value = owis;
            comm.Parameters.Add("v_th", OracleDbType.Decimal).Value = th;
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
