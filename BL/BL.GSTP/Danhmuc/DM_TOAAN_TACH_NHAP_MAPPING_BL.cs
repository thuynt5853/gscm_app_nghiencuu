using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;

namespace BL.GSTP.Danhmuc
{
    public class DM_TOAAN_TACH_NHAP_MAPPING_BL
    {
        /// <summary>
        /// Lấy dữ liệu mapping theo Id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public DataTable GETS_BY_ID(decimal id)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("P_ID", id),
                new OracleParameter("P_CURSOR", OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TACH_NHAP.DM_TOAAN_MAPPING_GET_BY_ID", parameters);
            return tbl;
        }

        /// <summary>
        /// Lấy danh sách mapping theo ToToaAnId
        /// </summary>
        /// <param name="toaanid"></param>
        /// <returns></returns>
        public DataTable GETS_BY_TOTOAANTID(decimal toaanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("P_TOTOAANID", toaanid),
                new OracleParameter("P_CURSOR", OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TACH_NHAP.DM_TOAAN_MAPPING_GETS_BY_TOTOAANID", parameters);
            return tbl;
        }

        /// <summary>
        /// Lấy danh sách mapping theo ToaAnId
        /// </summary>
        /// <param name="toaanid"></param>
        /// <returns></returns>
        public DataTable GETS_BY_TOAANTID(decimal toaanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("P_TOAANID", toaanid),
                new OracleParameter("P_CURSOR", OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TACH_NHAP.DM_TOAAN_MAPPING_GETS_BY_TOAANID", parameters);
            return tbl;
        }
        public DataTable GETS_BY_TOAAN_ID(decimal toaanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("V_TOAANID", toaanid),
                new OracleParameter("V_CURSOR", OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TACH_NHAP.GETS_BY_TOAANID", parameters);
            return tbl;
        }
        /// <summary>
        /// Lấy danh sách toa an cung cap theo ToaAnId
        /// </summary>
        /// <param name="toaanid"></param>
        /// <returns></returns>
        public DataTable GETS_SAME_LEVEL_TOAANTID(decimal toaanid)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("P_TOAANID", toaanid),
                new OracleParameter("P_CURSOR", OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_TACH_NHAP.DM_TOAAN_MAPPING_GETS_SAME_LEVEL", parameters);
            return tbl;
        }

        /// <summary>
        /// Thêm cấu hình Nhập - Tách
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void ADD(BANGSETGET.DM_TOAAN_TACH_NHAP_MAPPING_GS dmtachnhapGS)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_toaanid", dmtachnhapGS.TOAANID),
                new OracleParameter("v_loai", dmtachnhapGS.LOAI),
                new OracleParameter("v_totoaanid", dmtachnhapGS.TOTOAANID),
                new OracleParameter("v_ngayhieuluc", dmtachnhapGS.NGAYHIEULUC),
                new OracleParameter("v_ghichu", dmtachnhapGS.GHICHU),
                new OracleParameter("v_ngaytao", dmtachnhapGS.NGAYTAO),
                new OracleParameter("v_nguoitao", dmtachnhapGS.NGUOITAO)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_TACH_NHAP.DM_TOAAN_MAPPING_ADD", connection);
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

        /// <summary>
        /// Chinh sua cấu hình Nhập - Tách
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void EDIT(BANGSETGET.DM_TOAAN_TACH_NHAP_MAPPING_GS dmtachnhapGS)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", OracleDbType.Int32) { Value = (object)dmtachnhapGS.ID ?? DBNull.Value },
                new OracleParameter("p_TOAANID", OracleDbType.Int32) { Value = (object)dmtachnhapGS.TOAANID ?? DBNull.Value },
                new OracleParameter("p_TOTOAANID", OracleDbType.Int32) { Value = (object)dmtachnhapGS.TOTOAANID ?? DBNull.Value },
                new OracleParameter("p_NGAYHIEULUC", OracleDbType.Date) { Value = (object)dmtachnhapGS.NGAYHIEULUC ?? DBNull.Value },
                new OracleParameter("p_GHICHU", OracleDbType.Varchar2) { Value = (object)dmtachnhapGS.GHICHU ?? DBNull.Value }
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_TACH_NHAP.DM_TOAAN_MAPPING_EDIT", connection);
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

        /// <summary>
        /// Xoa cấu hình Nhập - Tách
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void DELETE(decimal id)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("v_id", id)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_TACH_NHAP.DM_TOAAN_MAPPING_DELETE", connection);
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

        public DataTable GetByCapChaID(Decimal CapChaID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("vCapChaID",CapChaID),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_TOAAN_GETBYCAPCHAID", parameters);
            return tbl;
        }
    }
}