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
   public class M_Violates1L
    {
        public bool Violates1L_Insert_Update(Sanctions_Inst obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_VIOL_INSERT_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
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
            comm.Parameters["v_COLUMN_22"].Value = obj.COLUMN_22;
            comm.Parameters["v_COLUMN_23"].Value = obj.COLUMN_23;
            comm.Parameters["v_COLUMN_24"].Value = obj.COLUMN_24;
            comm.Parameters["v_COLUMN_25"].Value = obj.COLUMN_25;
            comm.Parameters["v_COLUMN_26"].Value = obj.COLUMN_26;
            comm.Parameters["v_COLUMN_27"].Value = obj.COLUMN_27;
            comm.Parameters["v_COLUMN_28"].Value = obj.COLUMN_28;
            comm.Parameters["v_COLUMN_29"].Value = obj.COLUMN_29;
            comm.Parameters["v_COLUMN_30"].Value = obj.COLUMN_30;
            comm.Parameters["v_COLUMN_31"].Value = obj.COLUMN_31;
            comm.Parameters["v_COLUMN_32"].Value = obj.COLUMN_32;
            comm.Parameters["v_COLUMN_33"].Value = obj.COLUMN_33;
            comm.Parameters["v_COLUMN_34"].Value = obj.COLUMN_34;
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
                conn.Close();
            }
        }
        public List<Sanctions_Inst> Violates1L_List_Full(Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_VIOL_LIST_FULL", conn);
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
        public Decimal Violates1L_Return_CountCheck(String _COURT_EXTID, Int32 _TYPES_OF, String _COURT_ID, String Time_ID)
        {
            //Hàm trả về một giá trị
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_VIOL_OF", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.Parameters.Add("", OracleDbType.Decimal).Direction = ParameterDirection.ReturnValue;
            comm.Parameters.Add("V_COURT_EXTID", OracleDbType.Varchar2).Value = _COURT_EXTID;
            comm.Parameters.Add("v_TYPES_OF", OracleDbType.Decimal).Value = _TYPES_OF;
            comm.Parameters.Add("v_COURT_ID", OracleDbType.Varchar2).Value = _COURT_ID;
            comm.Parameters.Add("v_REPORT_TIME_ID", OracleDbType.Varchar2).Value = Time_ID;
            comm.ExecuteNonQuery();
            try
            {
                return Convert.ToDecimal(comm.Parameters[0].Value.ToString());
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
        public List<Sanctions_Inst> Violates1L_List(String _COURT_EXTID, Int32 _TYPES, Int32 Courts_ID, Int32 Time_ID, Int16 Options)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_VIOL_LIST", conn);
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
        public void Violates1L_Delete(String _COURT_EXTID, String _TYPES, String _Value_List_Delete, Int32 id_ReportTime, Int32 id_courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_DELETE_VIOL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["P_ID"].Value = _Value_List_Delete;
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
        public List<Judge_Report> Violates1L_Export(String _COURT_EXTID, String v_COURT_NAME, String _ID, Int32 _TYPES_OF, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_VIOL_EXP", conn);
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
        public List<Judge_Report> Violates1L_Export_Court_ExtID(String _COURT_EXTID, String v_COURT_NAME, String _ID, Int32 _TYPES_OF, String _COURT_ID, String Time_ID, String Time_ID2)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L.TC_VIOL_COURT_EXP", conn);
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
        public List<Judge_Report> Judge_Export_Detail_All(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP.TC_PROB_DETAIL_ALL", conn);
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
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP.TC_PROB_TOTAL_DISTRICT", conn);
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
        public List<Judge_Report> Judge_Export_Total_All_63(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP.TC_PROB_TOTAL_63", conn);
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
        public List<Judge_Report> Judge_Export_Total_District_63(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP.TC_PROB_TOTAL_DIS_63", conn);
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
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP.TC_PROB_TOTAL_DIS_01", conn);
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
        //bc tinh huyen       
        public List<Judge_Report> Judge_Export_Total_District_TH(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP_TH.TC_VIO1L_TOTAL_DISTRICT", conn);
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
        public List<Judge_Report> Judge_Export_Total_District_TH_63(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP_TH.TC_VIO1L_TOTAL_DISTRICT_63", conn);
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
        public List<Judge_Report> Judge_Export_Total_District_TH_CXX(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP_TH.TC_VIO1L_TOTAL_CXX", conn);
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
        public List<Judge_Report> Judge_Export_Total_District_TH_CXX_01(String v_TYPE_COURT, Int32 v_TYPES_OF, String v_Names, String v_list_court, String v_list_criminal, DateTime v_from, DateTime v_to, Int16 v_Options, Int16 owis, Int32 th)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES1L_EXP_TH.TC_VIO1L_TOTAL_CXX_01", conn);
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
