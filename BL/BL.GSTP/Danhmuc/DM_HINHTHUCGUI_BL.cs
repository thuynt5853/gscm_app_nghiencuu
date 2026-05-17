using BL.GSTP.BANGSETGET;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.Danhmuc
{
    public class DM_HINHTHUCGUI_BL
    {
        public DataTable GETALL_PAGING(decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DM_HINHTHUCGUI.GETALL_PAGING", parameters);
            return tbl;
        }
        public DataTable GETALL_CHECK_UNIQUE()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DM_HINHTHUCGUI.GETALL_CHECK_UNIQUE", parameters);
            return tbl;
        }
        public bool DM_HINHTHUCGUI_INSERT_UPDATE(DM_HINHTHUCGUI obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DM_HINHTHUCGUI.DM_HINHTHUCGUI_INSERT_UPDATE", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_TEN_HINHTHUCGUI"].Value = obj.TEN_HINHTHUCGUI;
            comm.Parameters["v_HIEULUC"].Value = obj.HIEULUC;
            comm.Parameters["v_CO_GUI_VBDH"].Value = obj.CO_GUI_VBDH;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["v_GIATRI"].Value = obj.GIATRI;
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

        public bool DM_HINHTHUCGUI_DEL(decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_DM_HINHTHUCGUI.DM_HINHTHUCGUI_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = ID;
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

        public DataTable DM_HINHTHUCGUI_GETBYID(decimal ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_DM_HINHTHUCGUI.DM_HINHTHUCGUI_GETBYID", prm);
        }

        public DataTable GETALL_ISHIEULUC()
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DM_HINHTHUCGUI.GETALL_ISHIEULUC", parameters);
            return tbl;
        }

        public decimal DM_HINHTHUCGUI_GETBYGIATRI(decimal? giaTri)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vGiaTri",giaTri),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_DM_HINHTHUCGUI.DM_HINHTHUCGUI_GETBYGIATRI", prm);
            return Convert.ToDecimal(tbl.Rows[0]["CO_GUI_VBDH"]);
        }
    }
}