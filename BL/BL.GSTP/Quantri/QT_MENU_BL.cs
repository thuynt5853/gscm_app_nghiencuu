using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;
using System.Runtime.Caching;


namespace BL.GSTP
{
    public class QT_MENU_BL
    {
        public DataTable QT_NHOMNGUOIDUNG_MENU_GETBY(decimal ChuongtrinhID, decimal NhomID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"QT_NHOMNGUOIDUNG_MENU_GETBY_{ChuongtrinhID}_{NhomID}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vChuongtrinhID",ChuongtrinhID),
                                                                          new OracleParameter("vNhomID",NhomID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };

                tbl = Cls_Comon.GetTableByProcedurePaging("QT_NHOMNGUOIDUNG_MENU_GETBY", parameters);
                // Lưu cache trong 120 phút               
                //double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_c"]);
                double vTime = 5;
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }
            return tbl;
        }
        public DataTable QT_NHOMNGUOIDUNG_MENU_GETBY_NOCACHE(decimal ChuongtrinhID, decimal NhomID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vChuongtrinhID",ChuongtrinhID),
                                                                          new OracleParameter("vNhomID",NhomID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("QT_NHOMNGUOIDUNG_MENU_GETBY", parameters);
            return tbl;
        }
        public bool QT_NHOMNGUOIDUNG_HOME_IN_UPDATE(QT_NHOMNGUOIDUNG_HOME obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_QUANTRI.QT_NHOM_HOME_IN_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_CHUONGTRINHID"].Value = obj.CHUONGTRINHID;
            comm.Parameters["v_NHOMID"].Value = obj.NHOMID;
            comm.Parameters["v_XEM"].Value = obj.XEM;
            comm.Parameters["v_XEM_ALL"].Value =obj.XEM_ALL;
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
        public bool QT_NHOMNGUOIDUNG_ISHOME_IN_UPDATE(QT_NHOMNGUOIDUNG_ISHOME obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_QUANTRI.QT_NHOM_ISHOME_IN_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_NHOMID"].Value = obj.NHOMID;
            comm.Parameters["v_VIEW_TK"].Value = obj.VIEW_TK;
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
        public DataTable Qt_Nhom_Home_Get_List(Decimal v_CHUONGTRINHID, Decimal v_NHOMID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"QT_NHOM_HOME_GET_{v_CHUONGTRINHID}_{v_NHOMID}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            //if (tbl == null) // Nếu chưa có cache
            //{ 
                OracleParameter[] parameters = new OracleParameter[]
                {
                new OracleParameter("v_CHUONGTRINHID",v_CHUONGTRINHID),
                new OracleParameter("v_NHOMID",v_NHOMID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QUANTRI.QT_NHOM_HOME_GET", parameters);
                // Lưu cache trong 120 phút
            //    double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_c"]);
            //    cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            //}
            return tbl;
        }
        public DataTable Qt_Nhom_ISHome_Get_List(Decimal v_NHOMID)
        {
            // Tạo key duy nhất cho cache
            string cacheKey = $"QT_NHOM_ISHOME_GET_{v_NHOMID}";

            // Sử dụng MemoryCache
            ObjectCache cache = MemoryCache.Default;
            DataTable tbl = cache.Get(cacheKey) as DataTable;

            if (tbl == null) // Nếu chưa có cache
            {
                OracleParameter[] parameters = new OracleParameter[]
                {
                new OracleParameter("v_NHOMID",v_NHOMID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                };
                tbl = Cls_Comon.GetTableByProcedurePaging("PKG_QUANTRI.QT_NHOM_ISHOME_GET", parameters);
                // Lưu cache trong 120 phút
                //double vTime = Convert.ToDouble(System.Configuration.ConfigurationManager.AppSettings["KeyCache_c"]);
                double vTime = 5;
                cache.Set(cacheKey, tbl, DateTimeOffset.Now.AddMinutes(vTime));
            }


            return tbl;
        }
    }
}