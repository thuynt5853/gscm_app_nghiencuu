using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;


using System.Globalization;
namespace BL.GSTP.GDTTT
{
    public class GDTTT_VUAN_KETQUA_DON_BL
    {
        public bool GDTTT_VUAN_KETQUA_DON_INS_UPD(GDTTT_VUAN_KETQUA_DON obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_VUAN_KETQUA_ID"].Value = obj.VUAN_KETQUA_ID;
            comm.Parameters["V_DONID"].Value = obj.DONID;
            comm.Parameters["V_SO"].Value = obj.SO;
            comm.Parameters["V_NGAY"].Value = obj.NGAY;
            comm.Parameters["V_NGUOIKY"].Value = obj.NGUOIKY;
            comm.Parameters["V_NGUOINHAN"].Value = obj.NGUOINHAN;
            comm.Parameters["V_DIACHINHAN"].Value = obj.DIACHINHAN;
            comm.Parameters["V_LOAI"].Value = obj.LOAI;
            comm.Parameters["V_DUONGSU_ID"].Value = obj.DUONGSU_ID;
            comm.Parameters["V_TYPETB"].Value = obj.TYPETB;
            comm.Parameters["V_GHICHU"].Value = obj.GHICHU;
            comm.Parameters["V_NOIDUNGKHANGNGHI"].Value = obj.NOIDUNGKHANGNGHI;
            comm.Parameters["V_NGAYPHATHANH"].Value = obj.NGAYPHATHANH;
            comm.Parameters["V_TRANGTHAI"].Value = obj.TRANGTHAI;
            comm.Parameters["V_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["V_THAMQUYENXXGDT"].Value = obj.THAMQUYENXXGDT;
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

        public DataTable GDTTT_VUAN_KETQUA_DON_GETBYID(decimal V_ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_ID",V_ID),
                //new OracleParameter("V_DONID",v_DONID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_GETBYID", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_DON_GETBYDONID(decimal V_DONID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_DONID",V_DONID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_GETBYDONID", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_DON_GETBYVUANKETQUAID(decimal V_VUAN_KETQUA_ID, decimal V_DONID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_VUAN_KETQUA_ID",V_VUAN_KETQUA_ID),
                new OracleParameter("V_DONID",V_DONID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_GETBYVUANKETQUAID", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_DON_GETBYVUANID(decimal V_VUANID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_VUANID",V_VUANID),
                //new OracleParameter("V_DONID",v_DONID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_GETBYVUANID", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ(decimal V_VUANID, decimal V_TYPETB, decimal? V_TRANGTHAI)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_VUANID",V_VUANID),
                new OracleParameter("V_TYPETB",V_TYPETB),
                new OracleParameter("V_TRANGTHAI",V_TRANGTHAI),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_CHECKLOAIKQ", prm);
        }

        

        public DataTable GDTTT_VUAN_KETQUA_DON_UP_TT(decimal V_ID, decimal V_TRANGTHAI)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("v_ID",V_ID),
                new OracleParameter("v_TRANGTHAI",V_TRANGTHAI)
                 //new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_UP_TT", prm);
        }

        public DataTable GDTTT_VUAN_KETQUA_DON_DSGiaiQuyetDon(decimal vVuAnID, decimal vType)
        {
            OracleParameter[] prm = new OracleParameter[]
            {   new OracleParameter("V_VUANID",vVuAnID),
                new OracleParameter("V_TYPETB",vType),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_DSGiaiQuyetDon", prm);
        }

        public bool GDTTT_VUAN_KETQUA_DON_DEL(decimal V_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_KETQUA_DON.GDTTT_VUAN_KETQUA_DON_DEL", conn);
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