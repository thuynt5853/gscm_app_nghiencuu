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
   public class M_Accused_1P
    {
        public List<Judge_Accused> Accused_1P_List_Return(ref Int32 _COUNT_RE, String _COLUMN_2, String _COLUMN_5, String _COLUMN_6, String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P.TC_ACC1P_RETURN_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_COUNT_RE"].Direction = ParameterDirection.Output;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_COLUMN_2"].Value = _COLUMN_2;
            comm.Parameters["v_COLUMN_5"].Value = _COLUMN_5;
            comm.Parameters["v_COLUMN_6"].Value = _COLUMN_6;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
            try
            {
                return Database.Bind_List_Reader<Judge_Accused>(comm);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                _COUNT_RE = Convert.ToInt32(comm.Parameters["v_COUNT_RE"].Value.ToString());
                conn.Close();
            }
        }
        public bool Accused_1P_Insert_Update(ref Int32 _COUNT_RE, Judge_Accused obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P.TC_ACC1P_INSERT_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_COUNT_RE"].Direction = ParameterDirection.Output;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_TYPES"].Value = obj.TYPES;
            comm.Parameters["v_COURT_ID"].Value = obj.COURT_ID;
            comm.Parameters["v_COURT_EXTID"].Value = obj.COURT_EXTID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = obj.REPORT_TIME_ID;
            comm.Parameters["v_CASE_ID"].Value = obj.CASES_ID;
            comm.Parameters["v_COLUMN_1"].Value = obj.COLUMN_1;
            comm.Parameters["v_COLUMN_2"].Value = obj.COLUMN_2;
            comm.Parameters["v_COLUMN_3"].Value = obj.COLUMN_3;
            comm.Parameters["v_COLUMN_4"].Value = obj.COLUMN_4;
            comm.Parameters["v_COLUMN_5"].Value = obj.COLUMN_5;
            comm.Parameters["v_COLUMN_6"].Value = obj.COLUMN_6;
            comm.Parameters["v_COLUMN_7"].Value = obj.COLUMN_7;
            comm.Parameters["v_COLUMN_8"].Value = obj.COLUMN_8;
            comm.Parameters["v_COLUMN_9"].Value = obj.COLUMN_9;
            comm.Parameters["v_COLUMN_10"].Value = obj.COLUMN_10;
            comm.Parameters["v_COLUMN_11"].Value = obj.COLUMN_11;
            comm.Parameters["v_COLUMN_12"].Value = obj.COLUMN_12;
            comm.Parameters["v_COLUMN_13"].Value = obj.COLUMN_13;
            comm.Parameters["v_COLUMN_14"].Value = obj.COLUMN_14;
            comm.Parameters["v_COLUMN_15"].Value = obj.COLUMN_15;
            comm.Parameters["v_COLUMN_16"].Value = obj.COLUMN_16;
            comm.Parameters["v_COLUMN_17"].Value = obj.COLUMN_17;
            comm.Parameters["v_COLUMN_18"].Value = obj.COLUMN_18;
            comm.Parameters["v_COLUMN_19"].Value = obj.COLUMN_19;
            comm.Parameters["v_COLUMN_20"].Value = obj.COLUMN_20;
            comm.Parameters["v_COLUMN_21"].Value = obj.COLUMN_21;
            comm.Parameters["V_CREATE_DATE"].Value = obj.CREATE_DATE;
            comm.Parameters["V_CREATE_USER"].Value = obj.CREATE_USER;
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
                _COUNT_RE = Convert.ToInt32(comm.Parameters["v_COUNT_RE"].Value.ToString());
                conn.Close();
            }
        }
        public bool Accused_1P_Insert_Return(DateTime _CREATE_DATE, String _CREATE_USER, ref Int32 v_ID, String _COLUMN_2, String _COLUMN_5, String _COLUMN_6, String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P.TC_ACC1P_INSERT_RETURN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Direction = ParameterDirection.Output;
            comm.Parameters["v_COLUMN_2"].Value = _COLUMN_2;
            comm.Parameters["v_COLUMN_5"].Value = _COLUMN_5;
            comm.Parameters["v_COLUMN_6"].Value = _COLUMN_6;
            comm.Parameters["V_CREATE_DATE"].Value = _CREATE_DATE;
            comm.Parameters["V_CREATE_USER"].Value = _CREATE_USER;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
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
                v_ID = Convert.ToInt32(comm.Parameters["v_ID"].Value.ToString());
                conn.Close();
            }
        }
        public bool Accused_1P_Insert_Previous(DateTime _CREATE_DATE, String _CREATE_USER, String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P.TC_ACC1P_INSERT_PREVIOUS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_CREATE_DATE"].Value = _CREATE_DATE;
            comm.Parameters["V_CREATE_USER"].Value = _CREATE_USER;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
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
        public List<Judge_Report> Accused_1P_Export(String _COURT_EXTID, String v_COURT_NAME, String _ID, Int32 _TYPES_OF, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P.TC_ACC1P_EXP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Varchar2).Value = _COURT_EXTID;
            comm.Parameters.Add("v_COURT_NAME", OracleDbType.NVarchar2).Value = v_COURT_NAME;
            comm.Parameters.Add("P_ID", OracleDbType.Varchar2).Value = _ID;
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
        public List<Judge_Report> Accused_1P_Export_Court_ExtID(String _COURT_EXTID, String v_COURT_NAME, String _ID, Int32 _TYPES_OF, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P.TC_ACC1P_COURT_EXP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Varchar2).Value = _COURT_EXTID;
            comm.Parameters.Add("v_COURT_NAME", OracleDbType.NVarchar2).Value = v_COURT_NAME;
            comm.Parameters.Add("P_ID", OracleDbType.Varchar2).Value = _ID;
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
        //export bao cao
        public List<Judge_Report> Judge_Export_Detail_District(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P_EXP.TC_ACC1P_DETAIL_DISTRICT", conn);
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
        public List<Judge_Report> Judge_Export_District(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P_EXP.TC_ACC1P_DISTRICT", conn);
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
        public List<Judge_Report> Judge_Export_Provin(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P_EXP.TC_ACC1P_PROVIN", conn);
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
        public List<Judge_Report> Judge_Export_Detail_CW(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P_EXP.TC_ACC1P_DETAIL_CW", conn);
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
        //export bao cao TH
        public List<Judge_Report> Judge_Export_Detail_TH(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_1P_EXP_TH.TC_ACC1P_DETAIL", conn);
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
