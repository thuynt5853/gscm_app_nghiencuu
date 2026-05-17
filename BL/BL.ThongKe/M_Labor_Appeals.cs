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
    public class M_Labor_Appeals
    {
        public Judge_Labor Labor_App_Return(String _COURT_EXTID, Int32 _TYPES, Int32 RetimeID, Int32 COURTS_ID, Int32 _CASE_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_RETURN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_ReTimeID"].Value = RetimeID;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["V_COURTS_ID"].Value = COURTS_ID;
            comm.Parameters["V_CASE_ID"].Value = _CASE_ID;
            try
            {
                return Database.Bind_Object_Reader<Judge_Labor>(comm);
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
        public List<Judge_Labor> Labor_App_Check_List(String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 v_CASES_IDs)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_CHECK_COLUM2", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_CASES_ID"].Value = v_CASES_IDs;
            try
            {
                return Database.Bind_List_Reader<Judge_Labor>(comm);
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
        public List<Judge_Labor> Labor_App_List_Full(String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_LIST_FULL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_COURT_ID"].Value = Courts_ID;
            comm.Parameters["v_REPORT_TIME_ID"].Value = Time_ID;
            try
            {
                return Database.Bind_List_Reader<Judge_Labor>(comm);
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
        public void Labor_Appeals_Delete(String _COURT_EXTID, String _TYPES, String _Value_List_Delete, Int32 id_ReportTime, Int32 id_courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_DELETE_LABOR_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["P_CASES_ID"].Value = _Value_List_Delete;
            comm.Parameters["v_COURT_ID"].Value = id_courts;
            comm.Parameters["v_REPORT_TIME_ID"].Value = id_ReportTime;
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
        public List<Judge_Labor> Labor_Appeals_List(String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_LIST", conn);
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
                return Database.Bind_List_Reader<Judge_Labor>(comm);
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
        public void Cases_Check_Labor_Appeals_Parrent(String _COURT_EXTID, Int32 _TYPES, Int32 V_PARRENTID, ref Int32 ID_SHOWS, Int32 id_reporttime, Int32 id_courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_CHECK_PARENT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_SHOWS"].Direction = ParameterDirection.Output;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["V_ID_PARENTS"].Value = V_PARRENTID;
            comm.Parameters["V_REPORT_TIME"].Value = id_reporttime;
            comm.Parameters["V_COURTS"].Value = id_courts;
            try
            {
                comm.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                ID_SHOWS = Convert.ToInt32(comm.Parameters["V_SHOWS"].Value);
                conn.Close();
            }
        }
        public List<Judge_Report> Labor_Return_list_Text(ref Int32 _TotalRecord, String _COURT_EXTID, Int32 _TYPES, Int32 RetimeID, Int32 COURTS_ID, Int32 _Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_RETURN_LIST_TEXT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("V_TotalRecord", OracleDbType.Decimal).Direction = ParameterDirection.Output;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Varchar2).Value = _COURT_EXTID;
            comm.Parameters.Add("v_TYPES", OracleDbType.Decimal).Value = _TYPES;
            comm.Parameters.Add("v_ReTimeID", OracleDbType.Decimal).Value = RetimeID;
            comm.Parameters.Add("V_COURTS_ID", OracleDbType.Decimal).Value = COURTS_ID;
            comm.Parameters.Add("v_Options", OracleDbType.Decimal).Value = _Options;
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
                _TotalRecord = Convert.ToInt32(comm.Parameters["V_TotalRecord"].Value.ToString());
                conn.Close();
            }
        }
        public List<Judge_Labor> Labor_Appeals_Return_list(String _COURT_EXTID, Int32 _TYPES, Int32 RetimeID, Int32 COURTS_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_RETURN_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_ReTimeID"].Value = RetimeID;
            comm.Parameters["V_COURTS_ID"].Value = COURTS_ID;
            comm.Parameters["v_Options"].Value = Options;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Judge_Labor>(comm);
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
        public List<Judge_Report> Labor_Appeals_Export(int _COURT_ID, String v_COURT_NAME, int _COURT_EXTID, String _CASES_ID, int _TYPES_OF, int Time_ID, int Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_EXP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_COURT_ID", OracleDbType.Decimal).Value = _COURT_ID;
            comm.Parameters.Add("v_COURT_NAME", OracleDbType.NVarchar2).Value = v_COURT_NAME;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Decimal).Value = _COURT_EXTID;
            comm.Parameters.Add("P_CASES_ID", OracleDbType.Varchar2).Value = _CASES_ID;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = _TYPES_OF;
            comm.Parameters.Add("v_REPORT_TIME_ID", OracleDbType.Decimal).Value = Time_ID;
            comm.Parameters.Add("v_REPORT_TIME_ID2", OracleDbType.Decimal).Value = Time_ID2;
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
        public List<Judge_Report> labor_App_Export_Court_ExtID(int _COURT_ID, String v_COURT_NAME, int _COURT_EXTID, String _CASES_ID, int _TYPES_OF, int Time_ID, int Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_LABOR_APP_COURT_EXP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.RefCursor).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("v_COURT_ID", OracleDbType.Decimal).Value = _COURT_ID;
            comm.Parameters.Add("v_COURT_NAME", OracleDbType.NVarchar2).Value = v_COURT_NAME;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Decimal).Value = _COURT_EXTID;
            comm.Parameters.Add("P_CASES_ID", OracleDbType.Varchar2).Value = _CASES_ID;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = _TYPES_OF;
            comm.Parameters.Add("v_REPORT_TIME_ID", OracleDbType.Decimal).Value = Time_ID;
            comm.Parameters.Add("v_REPORT_TIME_ID2", OracleDbType.Decimal).Value = Time_ID2;
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
        public List<Judge_Report> Judge_Export_TD(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP.TC_LABO_DETAIL_TD", conn);
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
        public List<Judge_Report> Judge_Export_Detail_District(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP.TC_LABO_DETAIL_DISTRICT", conn);
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
        public List<Judge_Report> Judge_Export_Detail_District_CW(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP.TC_LABO_DETAIL_DIS_CW", conn);
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
        public List<Judge_Report> Judge_Export_Total_District(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP.TC_LABO_TOTAL_DISTRICT", conn);
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
        public List<Judge_Report> Judge_Export_Total_District_01(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP.TC_LABO_TOTAL_DIS_01", conn);
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
        //export bao cao
        public List<Judge_Report> Judge_Export_TD_TH(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP_TH.TC_LABO_DETAIL_TD", conn);
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

        public List<Judge_Report> Judge_Export_Total_District_63_TH(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP_TH.TC_LABO_TOTAL_DIS_63", conn);
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

        public List<Judge_Report> Judge_Export_Total_District_Cxx_Th(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP_TH.TC_LABO_TOTAL_DISTRICT_CXX", conn);
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

        public List<Judge_Report> Judge_Export_Detail_District_TH(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL_EXP_TH.TC_LABO_DETAIL_DISTRICT", conn);
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
