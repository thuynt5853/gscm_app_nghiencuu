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
    public class M_Courts
    {
        public List<Courts> Court_List_Option_Users(String Levels)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_OPTIONS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_LEVEL"].Value = Levels;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Option_Users_Add(String Levels)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_OPTIONS_USER", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_LEVEL"].Value = Levels;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_Ext_List_Option(String _COURT_ID_CW,String _LEVEL)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_EXT_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_LEVEL"].Value = _LEVEL;
            comm.Parameters["V_COURT_ID_CW"].Value = _COURT_ID_CW;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Exports(String VI_TYPE, Int32 VI_ID_REPORT_TIME, Int32 VI_TYPE_OF, Int32 VI_OPTIONS, Int32 VI_PARENT,String v_typecourts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_EXPORTS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_TYPECOURTS"].Value = v_typecourts;
            comm.Parameters["VI_TYPE"].Value = VI_TYPE;
            comm.Parameters["VI_ID_REPORT_TIME"].Value = VI_ID_REPORT_TIME;
            comm.Parameters["VI_TYPE_OF"].Value = VI_TYPE_OF;
            comm.Parameters["VI_OPTIONS"].Value = VI_OPTIONS;
            comm.Parameters["VI_PARENT"].Value = VI_PARENT;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Tinh(Int32 ID_PARENT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_TINH", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID_PARENT"].Value = ID_PARENT;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Type(Int32 ID_Others)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_TYPE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_ID_Other"].Value = ID_Others;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;            
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public Courts Court_List_Search_Tinh(Int32 ID_COURTSS)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_FINT_TINH", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["V_ID_COURTS"].Value = ID_COURTSS;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_Object_Reader<Courts>(comm);
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
        public bool Courts_Update(Courts obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURT_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;           
            comm.Parameters["v_COURT_NAME"].Value = obj.COURT_NAME;           
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
        public bool Courts_Insert(Courts obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURT_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_COURT_ID"].Value = obj.COURT_ID;            
            comm.Parameters["v_COURT_NAME"].Value = obj.COURT_NAME;
            comm.Parameters["v_TYPE"].Value = obj.TYPE;
            comm.Parameters["v_USER_TYPE"].Value = obj.USER_TYPE;
            comm.Parameters["v_PARENT_ID"].Value = obj.PARENT_ID;  
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
        public bool Courts_ext_Insert(String _COURT_ID,Int32 _COURT_ID_CW)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURT_EXT_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["P_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["v_COURT_ID_CW"].Value = _COURT_ID_CW;
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
        public bool Courts_Emu_Insert(String _COURT_ID, Int32 _EMULA_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURT_EMU_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["P_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["v_EMULA_ID"].Value = _EMULA_ID;
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
        public bool Courts_Update_Full(Courts obj)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURT_UPDATE_FULL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_COURT_ID"].Value = obj.COURT_ID;
            comm.Parameters["v_COURT_NAME"].Value = obj.COURT_NAME;
            comm.Parameters["v_TYPE"].Value = obj.TYPE;
            comm.Parameters["v_USER_TYPE"].Value = obj.USER_TYPE;
            comm.Parameters["v_PARENT_ID"].Value = obj.PARENT_ID;
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
        public List<Courts> Court_List_Options(String Levels)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_OPTIONS_ORTHER", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_LEVEL"].Value = Levels;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Options_QS(Int32 v_typecourts,String Levels)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_OPTIONS_QS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_typecourts"].Value = v_typecourts;
            comm.Parameters["v_LEVEL"].Value = Levels;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
          
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> List_Court_EXT(Int32 _ADD_DES,String _COURT_ID_CW)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_LIST_COURTS_EXT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_ADD_DES"].Value = _ADD_DES;
            comm.Parameters["V_COURT_ID_CW"].Value = _COURT_ID_CW;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> List_Court_EMU(Int32 _ADD_DES, String _EMULA_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_LIST_COURTS_EMU", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_ADD_DES"].Value = _ADD_DES;
            comm.Parameters["v_EMULA_ID"].Value = _EMULA_ID;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Options_Huyen()
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_HUYEN_ORTHER", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;           
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Options_Huyen_QS(Int32 v_typecourts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_HUYEN_QS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["v_typecourts"].Value = v_typecourts;
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Id_Not_All(Int32 PARENT_COURT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_PARENT_IDS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_PARENT_COURT"].Value = PARENT_COURT;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Id_Not_All_CW(Int32 ID_COURT)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_PARENT_IDS_CW", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_ID_COURT"].Value = ID_COURT;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public Courts Court_List_Objecs(Int32 v_ID_Courts)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_OBJECT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_ID_COURT"].Value = v_ID_Courts;
            try
            {
                return Database.Bind_Object_Reader<Courts>(comm);
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
        public List<Courts> Courts_List(String values, String Indexs)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURT_LIST", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);           
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;            
            comm.Parameters["v_values"].Value = values;
            comm.Parameters["v_Indexs"].Value = Indexs;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public void Courts_Delete(string _Value_List_Delete)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("Delete From TC_COURTS where ID IN(" + _Value_List_Delete + ") OR PARENT_ID IN (" + _Value_List_Delete + ")", conn);
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
        public List<Courts> Report_Times_Infor_List_Couts_New_Count(Int32 v_REPORT_TIME_ID, String V_TYPES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_STATI_COUNT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE"].Value = V_TYPES;
            comm.Parameters["V_ID_REPORT_TIME"].Value = v_REPORT_TIME_ID;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Report_Times_Infor_List_Couts_Not_New(Int32 v_REPORT_TIME_ID, String V_TYPES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_NOT_NEW", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE"].Value = V_TYPES;
            comm.Parameters["V_ID_REPORT_TIME"].Value = v_REPORT_TIME_ID;

            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> List_Couts_All_For_Type(String V_TYPES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_TYPE_ALL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE"].Value = V_TYPES;          
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Report_Times_Infor_List_Couts_New_District(String v_REPORT_TIME_ID, String V_TYPES)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_STATI_DISTRICT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE"].Value = V_TYPES;
            comm.Parameters["V_ID_REPORT_TIME"].Value = v_REPORT_TIME_ID;  

            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Report_Times_Infor_List_Couts_Parents(String v_REPORT_TIME_ID, String V_TYPES, Int32 _PARENT_ID)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_STATI_LIST_PARENT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["V_TYPE"].Value = V_TYPES;
            comm.Parameters["V_ID_REPORT_TIME"].Value = v_REPORT_TIME_ID;
            comm.Parameters["V_PARENT_ID"].Value = _PARENT_ID;

            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
        public List<Courts> Court_List_Option_QSQK(String Levels)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_CATEGORY_COURT.TC_COURTS_LIST_QSQK", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            comm.Parameters["ITEMS_CURSOR"].Direction = ParameterDirection.Output;
            comm.Parameters["v_LEVEL"].Value = Levels;
            try
            {
                return Database.Bind_List_Reader<Courts>(comm);
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
