using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;


using System.Globalization;
namespace BL.GSTP
{
    public class GDTTT_VUAN_KETQUA_BL
    {
        public bool GDTTT_VUAN_KETQUA_INS_UPD(GDTTT_VUAN_KETQUA obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_VUANID"].Value = obj.VUANID;
            comm.Parameters["V_TRANGTHAI"].Value = obj.TRANGTHAI;
            comm.Parameters["V_NOIDUNGKHANGNGHI"].Value = obj.NOIDUNGKHANGNGHI;
            comm.Parameters["V_TOAAN_ID"].Value = obj.TOAAN_ID;
            comm.Parameters["V_CAPNHATVUAN"].Value = obj.CAPNHATVUAN;
            comm.Parameters["V_NGUOIKHANGNGHI"].Value = obj.NGUOIKHANGNGHI;
            comm.Parameters["V_GQD_LOAIKETQUA"].Value = obj.GQD_LOAIKETQUA;
            comm.Parameters["V_GQD_KETQUA"].Value = obj.GQD_KETQUA;
            comm.Parameters["V_GDQ_SO"].Value = obj.GDQ_SO;
            comm.Parameters["V_GDQ_NGAY"].Value = obj.GDQ_NGAY;
            comm.Parameters["V_GDQ_NGUOIKY"].Value = obj.GDQ_NGUOIKY;
            comm.Parameters["V_THAMQUYENXXGDT"].Value = obj.THAMQUYENXXGDT;
            comm.Parameters["V_QUATRINH_GHICHU"].Value = obj.QUATRINH_GHICHU;
            comm.Parameters["V_GQD_GHICHU"].Value = obj.GQD_GHICHU;
            comm.Parameters["V_GQD_ISHOANTHA"].Value = obj.GQD_ISHOANTHA;
            comm.Parameters["V_GQD_HOANTHA_NGUOIKYID"].Value = obj.GQD_HOANTHA_NGUOIKYID;
            comm.Parameters["V_GQD_HOANTHA_NGAY"].Value = obj.GQD_HOANTHA_NGAY;
            comm.Parameters["V_GQD_HOANTHA_SO"].Value = obj.GQD_HOANTHA_SO;
            comm.Parameters["V_GQD_NGAYPHATHANHCV"].Value = obj.GQD_NGAYPHATHANHCV;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                String msg_ = ex.Message;
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public bool GDTTT_VUAN_KETQUA_INSERT(GDTTT_VUAN_KETQUA obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_INSERT", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_VUANID"].Value = obj.VUANID;
            comm.Parameters["V_TRANGTHAI"].Value = obj.TRANGTHAI;
            comm.Parameters["V_NOIDUNGKHANGNGHI"].Value = obj.NOIDUNGKHANGNGHI;
            comm.Parameters["V_TOAAN_ID"].Value = obj.TOAAN_ID;
            comm.Parameters["V_CAPNHATVUAN"].Value = obj.CAPNHATVUAN;
            comm.Parameters["V_NGUOIKHANGNGHI"].Value = obj.NGUOIKHANGNGHI;
            comm.Parameters["V_GQD_LOAIKETQUA"].Value = obj.GQD_LOAIKETQUA;
            comm.Parameters["V_GQD_KETQUA"].Value = obj.GQD_KETQUA;
            comm.Parameters["V_GDQ_SO"].Value = obj.GDQ_SO;
            comm.Parameters["V_GDQ_NGAY"].Value = obj.GDQ_NGAY;
            comm.Parameters["V_GDQ_NGUOIKY"].Value = obj.GDQ_NGUOIKY;
            comm.Parameters["V_THAMQUYENXXGDT"].Value = obj.THAMQUYENXXGDT;
            comm.Parameters["V_QUATRINH_GHICHU"].Value = obj.QUATRINH_GHICHU;
            comm.Parameters["V_GQD_GHICHU"].Value = obj.GQD_GHICHU;
            comm.Parameters["V_GQD_ISHOANTHA"].Value = obj.GQD_ISHOANTHA;
            comm.Parameters["V_GQD_HOANTHA_NGUOIKYID"].Value = obj.GQD_HOANTHA_NGUOIKYID;
            comm.Parameters["V_GQD_HOANTHA_NGAY"].Value = obj.GQD_HOANTHA_NGAY;
            comm.Parameters["V_GQD_HOANTHA_SO"].Value = obj.GQD_HOANTHA_SO;
            comm.Parameters["V_GQD_NGAYPHATHANHCV"].Value = obj.GQD_NGAYPHATHANHCV;
            comm.Parameters["V_NGAYTAO"].Value = obj.NGAYTAO;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
            {
                String msg_ = ex.Message;
                tran.Rollback();
                return false;
            }
            finally
            {
                conn.Close();
            }
        }

        public DataTable GDTTT_VUAN_KETQUA_GETBYID(decimal V_ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_ID",V_ID),
                //new OracleParameter("V_DONID",v_DONID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_GETBYID", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_GETBYVUANID(decimal V_ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_VUANID",V_ID),
                //new OracleParameter("V_DONID",v_DONID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_GETBYVUANID", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_CAPNHATVUAN(decimal V_ID, decimal V_CAPNHATVUAN)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("v_ID",V_ID),
                new OracleParameter("v_CAPNHATVUAN",V_CAPNHATVUAN)
                 //new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_CAPNHATVUAN", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_UP_TT(decimal V_ID, decimal V_TRANGTHAI)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("v_ID",V_ID),
                new OracleParameter("v_TRANGTHAI",V_TRANGTHAI)
                 //new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_UP_TT", prm);
        }

        public bool GDTTT_VUAN_KETQUA_DEL(decimal V_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_KETQUA.GDTTT_VUAN_KETQUA_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = V_ID;
            //comm.Parameters["V_DONID"].Value = v_DONID;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return true;
            }
            catch (Exception ex)
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