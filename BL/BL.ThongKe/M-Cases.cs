using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.Text;
using System.Data;
using BL.THONGKE.Manager;
using BL.THONGKE.Info;
using BL.THONGKE;
using System.Web.UI.WebControls;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
namespace BL.THONGKE
{
    public class M_Cases
    {

        public bool Case_Update(Cases obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CASE_ID"].Value = obj.CASE_ID;
            comm.Parameters["v_CASE_NAME"].Value = obj.CASE_NAME;
            comm.Parameters["v_STYLES"].Value = obj.STYLES;
            comm.Parameters["v_OPTIONS"].Value = obj.OPTIONS;
            comm.Parameters["V_DESCRIPTIONS"].Value = obj.DESCRIPTIONS;
            comm.Parameters["V_PARENT_ID"].Value = obj.PARENT_ID;            
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
        public void Cases_Sort_Order(int News_id, int order)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASE_SORT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CASE_ID"].Value = News_id;
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
        public bool Case_Insert(Cases obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CASE_ID"].Value = obj.CASE_ID;
            comm.Parameters["v_CASE_NAME"].Value = obj.CASE_NAME;          
            comm.Parameters["v_STYLES"].Value = obj.STYLES;
            comm.Parameters["v_OPTIONS"].Value = obj.OPTIONS;
            comm.Parameters["V_DESCRIPTIONS"].Value = obj.DESCRIPTIONS;
            comm.Parameters["V_PARENT_ID"].Value = obj.PARENT_ID;
            comm.Parameters["V_ORDERS"].Value = obj.ORDERS;
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
        public List<Cases> Cases_Of_Civil_Instances(Int32 _TYPE_CASES_OF, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_CIVIL.TC_CASES_OF_CIVI_INSTANCES", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Civil_Appeals(Int32 _TYPE_CASES_OF, String _COURT_EXTID,Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CIVIL_APPEALS.TC_CASES_OF_CIVIL_APPEAL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Civil_Special(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CIVIL_SPECIAL.TC_CASES_OF_CIV_SPEC", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Marriges_Instances(Int32 _TYPE_CASES_OF, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_MARRIGES.TC_CASES_OF_MAR", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Marriges_App(Int32 _TYPE_CASES_OF, String _COURT_EXTID,Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_MARRIGES_APPEAL.TC_CASES_OF_MAR_APPEAL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Admin_Instances(Int32 _TYPE_CASES_OF,Int32 _TYPES,Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_ADMIN.TC_CASES_OF_ADMIN_INSTANCES", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Sanctions_Instances(Int32 _TYPE_CASES_OF,Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_SANCTIONS_INSTANCES7A.TC_CASES_OF_SANCT_INSTANCES", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Probation1H(Int32 _TYPE_CASES_OF, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_PROBATION1H.TC_CASES_OF_PROB", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Probation1I(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_PROBATION1I.TC_CASES_OF_PROB1I", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Delegation9A(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_DELEGATION9A.TC_CASES_OF_DELEG9A", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Admin_Appeals(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ADMIN_APPEALS.TC_CASES_OF_ADMIN_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Emergency9F(Int32 _TYPE_CASES_OF,String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_EMERGENCY9F.TC_CASES_OF_EMER9F", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Violate_9G(Int32 _TYPE_CASES_OF,String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_VIOLATES9G.TC_CASES_OF_VIOL9G", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Economics_Instances(Int32 _TYPE_CASES_OF, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_ECONOMIC.TC_CASES_OF_ECONO_INSTANCES", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Bankruptcys_Instances(Int32 _TYPE_CASES_OF, Int32 _TYPES,Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_BANKRUPTCYS_INSTANCES4E.TC_CASES_OF_BANK_INSTANCES", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Bankruptcys_Code(Int32 _TYPE_CASES_OF,Int32 _CASES_ID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_BANKRUPTCYS_INSTANCES4E.TC_CASES_OF_BANK_CODE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_CASES_ID"].Value = _CASES_ID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Bankruptcys_Appeals(Int32 _TYPE_CASES_OF,String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_BANKRUPTCYS_APPEALS4F.TC_CASES_OF_BANK_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Accused_9H(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_9H.TC_CASES_OF_ACC9H_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Accused_8D(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ACCUSED_8D.TC_CASES_OF_ACC8D_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Economics_Appeals(Int32 _TYPE_CASES_OF,String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_ECONOMIC_APPEAL.TC_CASES_OF_ECONO_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Labor_Instances(Int32 _TYPE_CASES_OF, Int32 _TYPES,Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_LABOR.TC_CASES_OF_LABOR_INSTANCES", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Labor_Appeals(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LABOR_APPEAL.TC_CASES_OF_LABOR_APP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Letters_8C(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LETTERS_HTCWTW_8C.TC_CASES_OF_LETTERS_8C", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_Of_Letters_8B(Int32 _TYPE_CASES_OF, String _COURT_EXTID, Int32 _TYPES, Int32 _OPTIONS, Int32 _COURT_ID, Int32 _REPORT_TIME_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_LETTERS_HTCW_8B.TC_CASES_OF_LETTERS_8B", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE_CASES_OF"].Value = _TYPE_CASES_OF;
            comm.Parameters["V_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["v_TYPES"].Value = _TYPES;
            comm.Parameters["v_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["V_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public void Cases_Check_Admin_Instances_Parrent(Int32 _TYPES,Int32 V_PARRENTID, ref Int32 ID_SHOWS, Int32 id_reporttime, Int32 id_courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_JUDGE_ADMIN.TC_ADMIN_CHECK_PARENT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_SHOWS"].Direction = ParameterDirection.Output;
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
        public void Cases_Check_Sanctions_Instances_Parrent(Int32 _TYPES, Int32 V_PARRENTID, ref Int32 ID_SHOWS, Int32 id_reporttime, Int32 id_courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_SANCTIONS_INSTANCES7A.TC_SANCT_CHECK_PARENT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_SHOWS"].Direction = ParameterDirection.Output;
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
        public void Cases_Check_Probation1H_Parrent(Int32 _TYPES, Int32 V_PARRENTID, ref Int32 ID_SHOWS, Int32 id_reporttime, Int32 id_courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_PROBATION1H.TC_PROB_CHECK_PARENT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_SHOWS"].Direction = ParameterDirection.Output;
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
        ///------------------------------------------------------------
        public List<Cases> Cases_List_Exports(Int32 Styles)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_LIST_EXPORTS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_STYLES"].Value = Styles;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Cases_List(Int32 Styles, Int16 options, Int32 id_parent)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_STYLES"].Value = Styles;
            comm.Parameters["v_OPTIONS"].Value = options;
            comm.Parameters["v_PARENT_ID"].Value = id_parent;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public Cases Cases_List_Check_ID_Parent(Int16 Styles, Int32 id_V)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_LIST_CHECK_ID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_STYLES"].Value = Styles;
            comm.Parameters["V_ID"].Value = id_V;
            try
            {
                return Database.Bind_Object_Reader<Cases>(comm);
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
        public Cases Cases_List_Check_ID(Int32 id_V)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.CASES_LIST_OBJECT_ID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;           
            comm.Parameters["V_ID"].Value = id_V;
            try
            {
                return Database.Bind_Object_Reader<Cases>(comm);
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
        public void Cases_Delete_second(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_CASES where PARENT_ID IN(" + _Value_List_Delete + ")", conn);
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
        public void Cases_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_CASES where ID IN(" + _Value_List_Delete + ")", conn);
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
        public List<Cases> Categorise_List_Grid(String _OPTIONS, String _STYLES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_LIST_TREE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_OPTIONS"].Value = _OPTIONS;
            comm.Parameters["V_STYLES"].Value = _STYLES;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public List<Cases> Bind_Drop_Tree_New(int Ortherid, String _STYLES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.TC_CASES_DROP_TREE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID"].Value = Ortherid;
            comm.Parameters["V_STYLES"].Value = _STYLES;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Cases>(comm);
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
        public void Caser_Update_Action(int Cate_id)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_CASE.CASES_UPDATE_ACTION", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = Cate_id;
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
