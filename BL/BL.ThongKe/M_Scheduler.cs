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
using Oracle.ManagedDataAccess.Client;using Oracle.ManagedDataAccess.Types;


namespace BL.THONGKE
{
    public class M_Scheduler
    {
       public bool ReportInsert_Scheduler(Int32 _COURT_ID,Int32 _COURT_EXTID,Int32 _ISDONVITRUCTHUOC, Int32 _REPORT_TIME_ID, Int32 _ID_BAOCAO)
        {
            OracleConnection conn = Database.Connection();
            OracleCommand comm = new OracleCommand("PKG_SCHEDULER.REPORT_INSERT_NOTE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["in_COURT_ID"].Value = _COURT_ID;
            comm.Parameters["in_COURT_EXTID"].Value = _COURT_EXTID;
            comm.Parameters["in_ISDONVITRUCTHUOC"].Value = _ISDONVITRUCTHUOC;
            comm.Parameters["in_REPORT_TIME_ID"].Value = _REPORT_TIME_ID;
            comm.Parameters["in_ID_BAOCAO"].Value = _ID_BAOCAO;
            try
            {
                //System.Threading.Thread.Sleep(100000);
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                throw ex;
                //return false;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}
