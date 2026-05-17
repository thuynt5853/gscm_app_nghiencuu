using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.XLHC
{
    public class XLHC_DON_HOANMIEN_BL
    {

        public decimal UPSERT_HOANMIEN_SOTHAM_HDXX(decimal ID, decimal DONID, string MAVAITRO, decimal CANBOID, string HOTEN, DateTime? NGAYPHANCONG,
                DateTime? NGAYNHANPHANCONG, DateTime? NGAYTHAMGIA, DateTime? NGAYKETTHUC, decimal? NGUOIPHANCONGID, decimal? DUKHUYET,
                string NGUOITAO, DateTime? NGAYTAO, string NGUOISUA, DateTime? NGAYSUA, decimal LOAIAN, decimal DON_XIN_HOAN_MIEN_ID, decimal TOA_GIAIQUYET_ID
            )
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_BPXLHC.UPSERT_HOANMIEN_SOTHAM_HDXX", conn);

            decimal idReturn = 0;

            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["N_ID"].Value = ID;
            comm.Parameters["N_DONID"].Value = DONID;
            comm.Parameters["V_MAVAITRO"].Value = MAVAITRO;
            comm.Parameters["N_CANBOID"].Value = CANBOID;
            comm.Parameters["V_HOTEN"].Value = HOTEN;
            comm.Parameters["D_NGAYPHANCONG"].Value = NGAYPHANCONG;
            comm.Parameters["D_NGAYNHANPHANCONG"].Value = NGAYNHANPHANCONG;
            comm.Parameters["D_NGAYTHAMGIA"].Value = NGAYTHAMGIA;
            comm.Parameters["D_NGAYKETTHUC"].Value = NGAYKETTHUC;
            comm.Parameters["N_NGUOIPHANCONGID"].Value = NGUOIPHANCONGID;
            comm.Parameters["N_DUKHUYET"].Value = DUKHUYET;
            comm.Parameters["V_NGUOITAO"].Value = NGUOITAO;
            comm.Parameters["D_NGAYTAO"].Value = NGAYTAO;
            comm.Parameters["V_NGUOISUA"].Value = NGUOISUA;
            comm.Parameters["D_NGAYSUA"].Value = NGAYSUA;
            comm.Parameters["N_LOAIAN"].Value = LOAIAN;
            comm.Parameters["N_DON_XIN_HOAN_MIEN_ID"].Value = DON_XIN_HOAN_MIEN_ID;
            comm.Parameters["N_TOA_GIAIQUYET_ID"].Value = TOA_GIAIQUYET_ID;
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

        public DataTable GET_HOANMIEN_SOTHAM_HDXX_BY_ID(decimal ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("N_ID", ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_HOANMIEN_SOTHAM_HDXX_BY_ID", parameters);
            return tbl;
        }

        public DataTable GET_HOANMIEN_SOTHAM_HDXX_BY_DON_HOANMIEN(decimal DON_HOANMIEN_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("P_DON_HOANMIEN_ID", DON_HOANMIEN_ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_HOANMIEN_SOTHAM_HDXX_BY_DON_HOANMIEN", parameters);
            return tbl;
        }
        
        public DataTable GET_HOANMIEN_SOTHAM_HDXX_BY_CONDITION(decimal DONID, decimal DON_HOANMIEN_ID, decimal CANBOID, decimal LOAIAN, decimal ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("P_DON_ID", DONID),
                new OracleParameter("P_DON_HOANMIEN_ID", DON_HOANMIEN_ID),
                new OracleParameter("P_CANBO_ID", CANBOID),
                new OracleParameter("P_LOAIAN", LOAIAN),
                new OracleParameter("P_ID", ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_HOANMIEN_SOTHAM_HDXX_BY_CONDITION", parameters);
            return tbl;
        }

        public DataTable GET_HOANMIEN_SOTHAM_HDXX_BY_DON_VAITRO(decimal DONID, decimal DON_XIN_HOAN_MIEN_ID, string MAVAITRO, decimal LOAIAN, decimal ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("N_DONID", DONID),
                new OracleParameter("N_DON_HOANMIEN_ID", DON_XIN_HOAN_MIEN_ID),
                new OracleParameter("V_MAVAITRO", MAVAITRO),
                new OracleParameter("N_LOAIAN", LOAIAN),
                new OracleParameter("N_ID", ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_HOANMIEN_SOTHAM_HDXX_BY_DON_VAITRO", parameters);
            return tbl;
        }

        public void DELETE_HOANMIEN_SOTHAM_HDXX_BY_ID(decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_BPXLHC.DELETE_HOANMIEN_SOTHAM_HDXX_BY_ID", conn);

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

        public DataTable GET_DONXINHOANMIEN_THULY_BY_HOAN_MIEN_ID(decimal DON_XIN_HOAN_MIEN_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("N_DON_XIN_HOAN_MIEN_ID", DON_XIN_HOAN_MIEN_ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_DONXINHOANMIEN_THULY_BY_HOAN_MIEN_ID", parameters);
            return tbl;
        }

        public DataTable GET_DONXINHOANMIEN_THULY_BY_DONID_HOAN_MIEN_ID(decimal DONID, decimal LOAIAN, decimal DON_XIN_HOAN_MIEN_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("N_DONID", DONID),
                new OracleParameter("N_LOAIAN", LOAIAN),
                new OracleParameter("N_DON_XIN_HOAN_MIEN_ID", DON_XIN_HOAN_MIEN_ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_DONXINHOANMIEN_THULY_BY_DONID_HOAN_MIEN_ID", parameters);
            return tbl;
        }

        public DataTable GET_DONXINHOANMIEN_THULY_BY_SOTHULY_ID(decimal SOTHULY, decimal LOAIAN, decimal ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("N_SOTHULY", SOTHULY),
                new OracleParameter("N_LOAIAN", LOAIAN),
                new OracleParameter("N_ID", ID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_DONXINHOANMIEN_THULY_BY_SOTHULY_ID", parameters);
            return tbl;
        }

        public DataTable GET_DONXINHOANMIEN_THULY_BY_SOTHULY_NGAYTHULY(decimal LOAIAN, DateTime D_NGAYTHULY_START, DateTime D_NGAYTHULY_END)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("N_LOAIAN", LOAIAN),
                new OracleParameter("D_NGAYTHULY_START", D_NGAYTHULY_START),
                new OracleParameter("D_NGAYTHULY_END", D_NGAYTHULY_END),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_DONXINHOANMIEN_THULY_BY_SOTHULY_NGAYTHULY", parameters);
            return tbl;
        }

        public decimal UPSERT_DONXINHOANMIEN_THULY(decimal N_ID, decimal N_LOAIAN, decimal N_DONID, decimal? N_TOAANID, decimal N_DON_XIN_HOAN_MIEN_ID,
            decimal N_SOTHULY, DateTime? D_NGAYTHULY, decimal N_NGUOITHULYID, DateTime? D_NGAYTAO, DateTime? D_NGAYSUA, string V_NGUOITAO, string V_NGUOISUA
            )
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_BPXLHC.UPSERT_DONXINHOANMIEN_THULY", conn);

            decimal idReturn = 0;

            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["N_ID"].Value = N_ID;
            comm.Parameters["N_LOAIAN"].Value = N_LOAIAN;
            comm.Parameters["N_DONID"].Value = N_DONID;
            comm.Parameters["N_TOAANID"].Value = N_TOAANID;
            comm.Parameters["N_DON_XIN_HOAN_MIEN_ID"].Value = N_DON_XIN_HOAN_MIEN_ID;
            comm.Parameters["N_SOTHULY"].Value = N_SOTHULY;
            comm.Parameters["D_NGAYTHULY"].Value = D_NGAYTHULY;
            comm.Parameters["N_NGUOITHULYID"].Value = N_NGUOITHULYID;
            comm.Parameters["D_NGAYTAO"].Value = D_NGAYTAO;
            comm.Parameters["D_NGAYSUA"].Value = D_NGAYSUA;
            comm.Parameters["V_NGUOITAO"].Value = V_NGUOITAO;
            comm.Parameters["V_NGUOISUA"].Value = V_NGUOISUA;
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

        public DataTable GET_XLHC_DON_GIAIDOAN_BY_DONID(decimal? N_VUANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("N_VUANID", N_VUANID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BPXLHC.GET_XLHC_DON_GIAIDOAN_BY_DONID", parameters);
            return tbl;
        }


        public void DELETE_DONXINHOANMIEN_THULY_BY_ID(decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_BPXLHC.DELETE_DONXINHOANMIEN_THULY_BY_ID", conn);

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