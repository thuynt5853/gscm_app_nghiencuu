using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;

namespace BL.GSTP.THA
{
    public class THA_BIEUMAU_BL
    {
        public bool DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(decimal v_vuanID, decimal v_bianID, string v_listBM)
        {
            try
            {

                OracleParameter[] parameters = new OracleParameter[]
                {
                    new OracleParameter("v_vuanID", v_vuanID),
                    new OracleParameter("v_bianID", v_bianID),
                    new OracleParameter("v_listBM", v_listBM),
                };
                OracleConnection connection = Cls_Comon.OpenConnection();
                OracleCommand command = new OracleCommand("PKG_THA_BIEUMAU.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH", connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 60; // timeout 60 giây
                command.Parameters.AddRange(parameters);
                OracleTransaction transaction = connection.BeginTransaction();
                try
                {
                    command.ExecuteNonQuery();
                    transaction.Commit();
                    return true;
                }
                catch
                {
                    transaction.Rollback();
                    return false;
                }
                finally
                {
                    connection.Close();
                }
            }
            catch (Exception ex) { return false; }
        }
    }
}