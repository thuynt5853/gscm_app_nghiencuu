using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_TOAAN_TACH_NHAP_HISTORY_BL
    {

        public void ADD(BANGSETGET.DM_TOAAN_TACH_NHAP_HISTORY_GS dmtachnhapGS)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_toaanid", dmtachnhapGS.TOAANID),
                new OracleParameter("v_totoaanid", dmtachnhapGS.TOTOAANID),
                new OracleParameter("v_hieuluc", dmtachnhapGS.HIEULUC),
                new OracleParameter("v_ngayhieuluc", dmtachnhapGS.NGAYHIEULUC),
                new OracleParameter("v_ngayhethieuluc", dmtachnhapGS.NGAYHETHIEULUC),
                new OracleParameter("v_loai", dmtachnhapGS.LOAI),
                new OracleParameter("v_ngaytao", dmtachnhapGS.NGAYTAO),
                new OracleParameter("v_nguoitao", dmtachnhapGS.NGUOITAO),
                new OracleParameter("v_hanhdong", dmtachnhapGS.HANHDONG)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_TACH_NHAP.DM_TOAAN_HISTORY_ADD", connection);
            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters);
            OracleTransaction transaction = connection.BeginTransaction();
            try
            {
                command.ExecuteNonQuery();
                transaction.Commit();
            }
            catch
            {
                transaction.Rollback();
            }
            finally
            {
                connection.Close();
            }
        }


    }
}