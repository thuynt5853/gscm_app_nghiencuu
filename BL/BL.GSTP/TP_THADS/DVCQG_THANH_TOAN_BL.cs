using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.TP_THADS
{
    public class DVCQG_THANH_TOAN_BL
    {
        public bool DVCQG_THANH_TOAN_INSERT_UPDATE(decimal _TONGDAT_ID, String _MALOAIVUVIEC)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_IN_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TONGDAT_ID"].Value = _TONGDAT_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
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
        public bool DVCQG_THANH_TOAN_UP_TONGDAT(decimal _TONGDAT_ID, decimal _DUONGSUID, String _MALOAIVUVIEC)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_UP_TONGDAT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TONGDAT_ID"].Value = _TONGDAT_ID;
            comm.Parameters["V_DUONGSUID"].Value = _DUONGSUID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
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
        public bool DVCQG_THANH_TOAN_UP_TONGDAT_RE(String _TONGDAT_ID, decimal V_DONID, String _MALOAIVUVIEC)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_UP_TONGDAT_RE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TONGDAT_ID"].Value = _TONGDAT_ID;
            comm.Parameters["V_DONID"].Value = V_DONID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
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
        public bool DVCQG_THANH_TOAN_UP_ANPHI(decimal _ANPHI_ID, String _MALOAIVUVIEC)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
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
        public bool DVCQG_THANH_TOAN_UP_FROM_THADS(decimal _ANPHI_ID, String _MALOAIVUVIEC)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_UP_FROM_THADS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
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
        public bool DVCQG_THANH_TOAN_INSERT_ANPHI(decimal _MAGIAIDOAN, decimal _DONID, decimal _DONXULY_ID, decimal _ANPHI_ID, String _MALOAIVUVIEC, string V_DS_IDS)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_IN_ANPHI", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;

            comm.Parameters["V_MAGIAIDOAN"].Value = _MAGIAIDOAN;
            comm.Parameters["V_DONID"].Value = _DONID;
            comm.Parameters["V_DONXULY_ID"].Value = _DONXULY_ID;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
            comm.Parameters["V_DS_IDS"].Value = V_DS_IDS;
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
        public DataTable CHECK_THANH_TOAN_IN_ANPHI(decimal V_MAGIAIDOAN, decimal V_DONID, decimal V_DONXULY_ID, decimal V_ANPHI_ID, String V_MALOAIVUVIEC, string V_DS_IDS)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_MAGIAIDOAN",V_MAGIAIDOAN),
                new OracleParameter("V_DONID",V_DONID),
                new OracleParameter("V_DONXULY_ID",V_DONXULY_ID),
                new OracleParameter("V_ANPHI_ID",V_ANPHI_ID),
                new OracleParameter("V_MALOAIVUVIEC",V_MALOAIVUVIEC),
                new OracleParameter("V_DS_IDS",V_DS_IDS),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG_APP.CHECK_THANH_TOAN_IN_ANPHI", parameters);
            return tbl;
        }
        public void DVCQG_TT_REMOVE_TONGDAT(decimal _TONGDAT_ID, String _MALOAIVUVIEC, ref decimal V_VALUE)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.TT_REMOVE_TONGDAT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TONGDAT_ID"].Value = _TONGDAT_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
            comm.Parameters["V_VALUE"].Direction = ParameterDirection.Output;
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
                V_VALUE = Convert.ToDecimal(comm.Parameters["V_VALUE"].Value.ToString());
                conn.Close();
            }
        }
        public void DVCQG_THANH_TOAN_DELETE_XULY(decimal _DONXULY_ID, String _MALOAIVUVIEC, ref decimal V_VALUE)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_DELETE_XLY", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_DONXULY_ID"].Value = _DONXULY_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
            comm.Parameters["V_VALUE"].Direction = ParameterDirection.Output;
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
                V_VALUE = Convert.ToDecimal(comm.Parameters["V_VALUE"].Value.ToString());
                conn.Close();
            }
        }
        public void DVCQG_THANH_TOAN_DELETE_ANPHI(decimal _ANPHI_ID, String _MALOAIVUVIEC, ref decimal V_VALUE)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DVCQG_APP.THANH_TOAN_DELETE_ANPHI", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
            comm.Parameters["V_VALUE"].Direction = ParameterDirection.Output;
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
                V_VALUE = Convert.ToDecimal(comm.Parameters["V_VALUE"].Value.ToString());
                conn.Close();
            }
        }
        public void CHECK_DELETE_ANPHI(decimal _ANPHI_ID, String _MALOAIVUVIEC, ref decimal V_VALUE)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.CHECK_DELETE_ANPHI", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
            comm.Parameters["V_MALOAIVUVIEC"].Value = _MALOAIVUVIEC;
            comm.Parameters["V_VALUE"].Direction = ParameterDirection.Output;
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
                V_VALUE = Convert.ToDecimal(comm.Parameters["V_VALUE"].Value.ToString());
                conn.Close();
            }
        }
        public string DVCQG_THANH_TOAN_SEARCH(decimal _MAGIAIDOAN, decimal _DONXULY_ID, decimal _ANPHI_ID, String _MALOAIVUVIEC)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_MAGIAIDOAN", _MAGIAIDOAN),
            new OracleParameter("V_DONXULY_ID",_DONXULY_ID),
            new OracleParameter("V_ANPHI_ID",_ANPHI_ID),
                new OracleParameter("V_MALOAIVUVIEC",_MALOAIVUVIEC),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string V_MA_THONGBAO = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG.THANH_TOAN_SEARCH", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                V_MA_THONGBAO = tbl.Rows[0]["MA_THONGBAO"].ToString();
            }
            return V_MA_THONGBAO;
        }

        public string DVCQG_THANH_TOAN_SEARCH_KC(decimal _MAGIAIDOAN, decimal _DONXULY_ID, String _MALOAIVUVIEC)
        {
            OracleParameter[] parameters = new OracleParameter[] {
            new OracleParameter("V_MAGIAIDOAN", _MAGIAIDOAN),
            new OracleParameter("V_DONXULY_ID",_DONXULY_ID),
                new OracleParameter("V_MALOAIVUVIEC",_MALOAIVUVIEC),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            string V_MA_THONGBAO = "";
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DVCQG.THANH_TOAN_SEARCH_KC", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                V_MA_THONGBAO = tbl.Rows[0]["MA_THONGBAO"].ToString();
            }
            return V_MA_THONGBAO;
        }
        public bool INSERT_DATA_DUONGSU_AHN_FORM(decimal _DONID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.INSERT_DATA_DUONGSU_AHN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _DONID;
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
        public void DELETE_DATA_DUONGSU_AHN_FORM(decimal _ANPHI_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.DELETE_DATA_DUONGSU_AHN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
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
        public bool INSERT_DATA_DUONGSU_AHC_FORM(decimal _DONID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.INSERT_DATA_DUONGSU_AHC", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _DONID;
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

        public void DELETE_DATA_DUONGSU_AHC_FORM(decimal _ANPHI_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.DELETE_DATA_DUONGSU_AHC", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
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

        /// <summary>
        /// thêm hàm để insert nhiều đương sự của án dân sự
        /// </summary>
        /// <param name="_DONID"></param>
        /// <returns></returns>
        public bool INSERT_DATA_DUONGSU_ADS_FORM(decimal _DONID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.INSERT_DATA_DUONGSU_ADS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _DONID;
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
        public void DELETE_DATA_DUONGSU_ADS_FORM(decimal _ANPHI_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.DELETE_DATA_DUONGSU_ADS", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
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

        /// <summary>
        /// thêm hàm để insert nhiều đương sự của ÁN KINH TẾ
        /// </summary>
        /// <param name="V_MA_THONGBAO"></param>
        /// <returns></returns>
        public bool INSERT_DATA_DUONGSU_AKT_FORM(decimal _DONID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.INSERT_DATA_DUONGSU_AKT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _DONID;
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
        public void DELETE_DATA_DUONGSU_AKT_FORM(decimal _ANPHI_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.DELETE_DATA_DUONGSU_AKT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
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
        public DataTable GET_THANH_TOAN_BY_MA(string V_MA_THONGBAO)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_MA_THONGBAO",V_MA_THONGBAO),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TUPHAP_ANPHI_DVCQG.GET_THANH_TOAN_BY_MA", parameters);
            return tbl;
        }
        public bool INSERT_DATA_DUONGSU_ALD_FORM(decimal _DONID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.INSERT_DATA_DUONGSU_ALD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _DONID;
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
        public void DELETE_DATA_DUONGSU_ALD_FORM(decimal _ANPHI_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_TUPHAP_ANPHI_DVCQG.DELETE_DATA_DUONGSU_ALD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ANPHI_ID"].Value = _ANPHI_ID;
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