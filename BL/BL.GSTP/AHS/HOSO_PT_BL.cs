using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP
{
    public class HOSO_PT_BL
    {
        public DataTable HOSO_PT_LOAD_BYID(Decimal V_LOAIAN, String V_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                 new OracleParameter("V_LOAIAN",V_LOAIAN),
                 new OracleParameter("V_ID",V_ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.HOSO_PT_LIST_ID", parameters);
            return tbl;
        }
        public bool HOSO_PT_INS_UP(HOSO_PT obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HOSO_PT.HOSO_PT_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_ID"].Value = obj.ID;
            comm.Parameters["V_LOAIAN"].Value = obj.LOAIAN;
            comm.Parameters["V_VUANID"].Value = obj.VUANID;
            comm.Parameters["V_LOAI_CN"].Value = obj.LOAI_CN;
            comm.Parameters["V_CANBOID"].Value = obj.CANBOID;
            comm.Parameters["V_NGAY_NC"].Value = obj.NGAY_NC;
            comm.Parameters["V_DV_GUI_NHAN"].Value = obj.DV_GUI_NHAN;
            comm.Parameters["V_NGUOI_NHAN_VKS"].Value = obj.NGUOI_NHAN_VKS;
            comm.Parameters["V_GHICHU"].Value = obj.GHICHU;
            comm.Parameters["V_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["V_LOAI_DV"].Value = obj.LOAI_DV;
            comm.Parameters["V_TOAANID"].Value = obj.TOAANID;
            comm.Parameters["V_TOA_GIAIQUYET_ID"].Value = obj.TOAANID; // update toa_gq_id
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
        public DataTable Hoso_PT_List(Decimal V_LOAIAN, Decimal V_VUANID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIAN",V_LOAIAN),
                new OracleParameter("V_VUANID",V_VUANID),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize", PageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.HOSO_PT_LIST", parameters);
            return tbl;
        }
        public DataTable Hoso_PT_List_V2(Decimal V_LOAIAN, Decimal V_VUANID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIAN",V_LOAIAN),
                new OracleParameter("V_VUANID",V_VUANID),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize", PageSize),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.HOSO_PT_LIST_V2", parameters);
            return tbl;
        }
        
        public DataTable HOSO_PT_LIST_EXPORT(Decimal V_LOAIAN, Decimal V_VUANID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_LOAIAN",V_LOAIAN),
                                                                        new OracleParameter("V_VUANID",V_VUANID),
                                                                        new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_HOSO_PT.HOSO_PT_LIST_EXORT", parameters);
            return tbl;
        }
        public bool DELETE_HOSO_PT_BYID(Decimal V_LOAIAN, string V_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HOSO_PT.DELETE_HOSO_PT_ID", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_LOAIAN"].Value = V_LOAIAN;
            comm.Parameters["V_ID"].Value = V_ID;
            //----------
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
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}