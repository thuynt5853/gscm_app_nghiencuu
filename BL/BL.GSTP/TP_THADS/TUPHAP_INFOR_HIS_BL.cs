using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.TP_THADS
{
    public class TUPHAP_INFOR_HIS_BL
    {
        public bool TUPHAP_INFOR_HIS_INS(TUPHAP_INFOR_HIS obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_QUANTRI.TUPHAP_INFOR_HIS_INS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DONVI_THA_ID"].Value = obj.DONVI_THA_ID;
            comm.Parameters["V_USERID"].Value = obj.USERID;
            comm.Parameters["V_TEN_TK_THU_HUONG"].Value = obj.TEN_TK_THU_HUONG;
            comm.Parameters["V_TEN_DONVI"].Value = obj.TEN_DONVI;
            comm.Parameters["V_DIA_CHI"].Value = obj.DIA_CHI;
            comm.Parameters["V_DIEN_THOAI"].Value = obj.DIEN_THOAI;
            comm.Parameters["V_EMAIL"].Value = obj.EMAIL;
            comm.Parameters["V_MA_DINH_DANH"].Value = obj.MA_DINH_DANH;
            comm.Parameters["V_SO_TK"].Value = obj.SO_TK;
            comm.Parameters["V_TEN_KHO_BAC"].Value = obj.TEN_KHO_BAC;
            comm.Parameters["V_MA_KHO_BAC"].Value = obj.MA_KHO_BAC;
            comm.Parameters["V_MA_LH_THU"].Value = obj.MA_LH_THU;
            comm.Parameters["V_TEN_LH_THU"].Value = obj.TEN_LH_THU;
            comm.Parameters["V_NGUOI_SUA"].Value = obj.NGUOI_SUA;
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
    }
}