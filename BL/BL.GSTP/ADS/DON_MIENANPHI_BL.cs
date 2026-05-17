using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.ADS
{
    public class DON_MIENANPHI_BL
    {

        public decimal UPSERT_DON_MIENANPHI(decimal ID, decimal ANPHI_ID, decimal DONID, int LOAIAN, string LYDO, string NGUOITAO, 
                DateTime? NGAYTAO, string NGUOISUA, DateTime? NGAYSUA, string SOTHONGBAO, DateTime? NGAYTHONGBAO, string STB_PHU
            ) {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_MIENANPHI.UPSERT_MIENANPHI", conn);

            decimal idReturn = 0;

            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["N_ID"].Value = ID;
            comm.Parameters["N_ANPHI_ID"].Value = ANPHI_ID;
            comm.Parameters["N_DONID"].Value = DONID;
            comm.Parameters["N_LOAIAN"].Value = LOAIAN;
            comm.Parameters["V_LYDO"].Value = LYDO;
            comm.Parameters["V_NGUOITAO"].Value = NGUOITAO;
            comm.Parameters["D_NGAYTAO"].Value = NGAYTAO;
            comm.Parameters["V_NGUOISUA"].Value = NGUOISUA;
            comm.Parameters["D_NGAYSUA"].Value = NGAYSUA;
            comm.Parameters["N_SOTHONGBAO"].Value = SOTHONGBAO;
            comm.Parameters["D_NGAYTHONGBAO"].Value = NGAYTHONGBAO;
            comm.Parameters["V_STB_PHU"].Value = STB_PHU;
            comm.Parameters["OUT_ID"].Direction = ParameterDirection.Output;
            //----------
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                idReturn = Convert.ToDecimal(comm.Parameters["OUT_ID"].Value.ToString());
                return idReturn;
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return idReturn;
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

        public DataTable GET_DON_MIENANPHI_BY_ID(decimal ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("N_ID", ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_MIENANPHI.GET_DON_MIENANPHI_BY_ID", parameters);
            return tbl;
        }

        public DataTable GET_DON_MIENANPHI_BY_ANPHI_ID(decimal ANPHI_ID, int LOAIAN)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("N_ANPHI_ID", ANPHI_ID),
                        new OracleParameter("N_LOAIAN", LOAIAN),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_MIENANPHI.GET_DON_MIENANPHI_BY_ANPHI_ID", parameters);
            return tbl;
        }

        public void DELETE_DON_MIENANPHI_BY_ID(decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_MIENANPHI.DELETE_MIENANPHI_BY_ID", conn);

            decimal idReturn = 0;

            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["N_ID"].Value = ID;
            //----------
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
            }
            catch (Exception ex)
            {
                tran.Rollback();
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }

    }
}