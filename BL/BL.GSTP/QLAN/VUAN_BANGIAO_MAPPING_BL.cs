using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Text;

namespace BL.GSTP.QLAN
{
    public class VUAN_BANGIAO_MAPPING_BL
    {
        /// <summary>
        /// Thêm cấu hình VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="dmvuanbgGS"></param>
        public void ADD(BANGSETGET.VUAN_BANGIAO_MAPPING_GS dmvuanbgGS)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_TOAANGIAOID", OracleDbType.Int32) { Value = (object)dmvuanbgGS.TOAANGIAOID ?? DBNull.Value },
                new OracleParameter("p_TOAANGIAOTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TOAANGIAOTEN ?? DBNull.Value },
                new OracleParameter("p_TOAANNHANID", OracleDbType.Int32) { Value = (object)dmvuanbgGS.TOAANNHANID ?? DBNull.Value },
                new OracleParameter("p_TOAANNHANTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TOAANNHANTEN ?? DBNull.Value },
                new OracleParameter("p_VUVIECID", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECID ?? DBNull.Value },
                new OracleParameter("p_VUVIECLOAI", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECLOAI ?? DBNull.Value },
                new OracleParameter("p_VUVIECMA", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECMA ?? DBNull.Value },
                new OracleParameter("p_VUVIECTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECTEN ?? DBNull.Value },
                new OracleParameter("p_NGUOIGIAOID", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOIGIAOID ?? DBNull.Value },
                new OracleParameter("p_NGUOIGIAOTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOIGIAOTEN ?? DBNull.Value },
                new OracleParameter("p_NGUOINHANID", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOINHANID ?? DBNull.Value },
                new OracleParameter("p_NGUOINHANTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOINHANTEN ?? DBNull.Value },
                new OracleParameter("p_LYDOMA", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.LYDOMA ?? DBNull.Value },
                new OracleParameter("p_NGAYGIAO", OracleDbType.Date) { Value = (object)dmvuanbgGS.NGAYGIAO ?? DBNull.Value },
                new OracleParameter("p_ISQUYETDINHCHUYEN", OracleDbType.Int32) { Value = (object)dmvuanbgGS.ISQUYETDINHCHUYEN ?? DBNull.Value },
                new OracleParameter("p_SOQUYETDINH", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.SOQUYETDINH ?? DBNull.Value },
                new OracleParameter("p_NGAYQUYETDINH", OracleDbType.Date) { Value = (object)dmvuanbgGS.NGAYQUYETDINH ?? DBNull.Value },
                new OracleParameter("p_NGUOIKY", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOIKY ?? DBNull.Value },
                new OracleParameter("p_TRANGTHAI", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TRANGTHAI ?? DBNull.Value },
                new OracleParameter("p_GHICHU", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.GHICHU ?? DBNull.Value },
                new OracleParameter("p_TRANGTHAIGIAIQUYET", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TRANGTHAIGIAIQUYET ?? DBNull.Value }
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_ADD", connection);
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
        /// Chỉnh sửa cấu hình VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="dmvuanbgGS"></param>
        public void EDIT(BANGSETGET.VUAN_BANGIAO_MAPPING_GS dmvuanbgGS)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", OracleDbType.Int32) { Value = (object)dmvuanbgGS.ID ?? DBNull.Value },
                new OracleParameter("p_TOAANGIAOID", OracleDbType.Int32) { Value = (object)dmvuanbgGS.TOAANGIAOID ?? DBNull.Value },
                new OracleParameter("p_TOAANGIAOTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TOAANGIAOTEN ?? DBNull.Value },
                new OracleParameter("p_TOAANNHANID", OracleDbType.Int32) { Value = (object)dmvuanbgGS.TOAANNHANID ?? DBNull.Value },
                new OracleParameter("p_TOAANNHANTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TOAANNHANTEN ?? DBNull.Value },
                new OracleParameter("p_VUVIECID", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECID ?? DBNull.Value },
                new OracleParameter("p_VUVIECMA", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECMA ?? DBNull.Value },
                new OracleParameter("p_VUVIECTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.VUVIECTEN ?? DBNull.Value },
                new OracleParameter("p_NGUOIGIAOID", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOIGIAOID ?? DBNull.Value },
                new OracleParameter("p_NGUOIGIAOTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOIGIAOTEN ?? DBNull.Value },
                new OracleParameter("p_NGUOINHANID", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOINHANID ?? DBNull.Value },
                new OracleParameter("p_NGUOINHANTEN", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOINHANTEN ?? DBNull.Value },
                new OracleParameter("p_LYDOMA", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.LYDOMA ?? DBNull.Value },
                new OracleParameter("p_NGAYGIAO", OracleDbType.Date) { Value = (object)dmvuanbgGS.NGAYGIAO ?? DBNull.Value },
                new OracleParameter("p_ISQUYETDINHCHUYEN", OracleDbType.Int32) { Value = (object)dmvuanbgGS.ISQUYETDINHCHUYEN ?? DBNull.Value },
                new OracleParameter("p_SOQUYETDINH", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.SOQUYETDINH ?? DBNull.Value },
                new OracleParameter("p_NGAYQUYETDINH", OracleDbType.Date) { Value = (object)dmvuanbgGS.NGAYQUYETDINH ?? DBNull.Value },
                new OracleParameter("p_NGUOIKY", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.NGUOIKY ?? DBNull.Value },
                new OracleParameter("p_TRANGTHAI", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.TRANGTHAI ?? DBNull.Value },
                new OracleParameter("p_GHICHU", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.GHICHU ?? DBNull.Value }
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_EDIT", connection);
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
        /// Xóa cấu hình VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void DELETE(decimal? id)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", id)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_DELETE", connection);
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
        /// Thay đổi trạng thái cấu hình VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void CHANGE_STATUS(decimal? id, string trangthai)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", id),
                new OracleParameter("p_TRANGTHAI", trangthai)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_AN.VUAN_BANGIAO_MAPPING_CHANGE_STATUS", connection);
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
        /// Nhận bàn giao VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void NHAN(string loaiAnId, decimal? id, decimal? vuViecId, decimal? toaAnNhanId, DateTime? ngayNhan)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", id),
                new OracleParameter("p_VUVIECID", vuViecId),
                new OracleParameter("p_TOAANNHANID", toaAnNhanId),
                new OracleParameter("p_NGAYNHAN", ngayNhan),
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("", connection);
            switch (loaiAnId)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.AN_HINHSU:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AKDTM_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.APS_VUAN_BANGIAO_MAPPING_NHAN", connection);
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    command = new OracleCommand("PKG_BAN_GIAO_AN_BPXLHC.NHAN", connection);
                    break;
                default:
                    command = null;
                    break;
            }

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
        /// Kiểm tra thay đổi vụ án
        /// </summary>
        /// <param name="vuViecId">ID vụ việc</param>
        /// <param name="toaAnNhanId">ID tòa án nhận</param>
        /// <param name="ngayNhan">Ngày nhận án</param>
        /// <returns>Chuỗi rỗng nếu không có thay đổi, thông báo lỗi nếu có thay đổi hoặc lỗi</returns>
        public string KTTHAYDOI(string loaiAnId, decimal id)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", id),
            };

            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("", connection);

            switch (loaiAnId)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.AN_HINHSU:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.KDTM_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.APS_VUAN_BANGIAO_MAPPING_KTTHAYDOI", connection);
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    command = new OracleCommand("PKG_BAN_GIAO_AN_BPXLHC.KTTHAYDOI", connection);
                    break;
                default:
                    command = null;
                    break;
            }

            command.CommandType = CommandType.StoredProcedure;
            command.CommandTimeout = 60; // timeout 60 giây
            command.Parameters.AddRange(parameters);

            // Output parameters
            var resultParam = command.Parameters.Add("p_result", OracleDbType.Int32);
            resultParam.Direction = ParameterDirection.Output;

            var messageParam = command.Parameters.Add("p_message", OracleDbType.Varchar2, 500);
            messageParam.Direction = ParameterDirection.Output;

            // Thực thi stored procedure
            command.ExecuteNonQuery();

            // Lấy kết quả
            int result = Convert.ToInt32(resultParam.Value.ToString());
            string message = messageParam.Value != null ? messageParam.Value.ToString() : "";

            // Trả về chuỗi rỗng nếu không có thay đổi, message nếu có thay đổi
            return result == 1 ? message : "";
        }

        /// <summary>
        /// Trả lại án VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="loaiAnId"></param>
        /// <param name="id"></param>
        public void TRALAI(string loaiAnId, decimal? id)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", id)
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("", connection);
            switch (loaiAnId)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.AN_HINHSU:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.KDTM_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    command = new OracleCommand("PKG_BAN_GIAO_AN.APS_VUAN_BANGIAO_MAPPING_TRALAI", connection);
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    command = new OracleCommand("PKG_BAN_GIAO_AN_BPXLHC.TRALAI", connection);
                    break;
                default:
                    command = null;
                    break;
            }

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
        /// Lấy danh sách có thể bàn giao
        /// </summary>
        /// <param name="vToaAnID"></param>
        /// <param name="vMavuviec"></param>
        /// <param name="vThulytungay"></param>
        /// <param name="vDenngay"></param>
        /// <param name="vTinhtrangthuly"></param>
        /// <param name="vThamphangiaiquyet"></param>
        /// <param name="vTenvuan"></param>
        /// <param name="vTrangthaigiaiquyet"></param>
        /// <param name="vCapxetxu"></param>
        /// <param name="vLoaian"></param>
        /// <param name="vTrangthai"></param>
        /// <returns></returns>
        public DataTable DS_BANGIAO(decimal vToaAnID, string vMavuviec, DateTime? vThulytungay, DateTime? vDenngay, string vTinhtrangthuly, string vThamphangiaiquyet, string vTenvuan, string vTrangthaigiaiquyet, string vCapxetxu, string vLoaian, string vTrangthai)
        {

            vMavuviec = vMavuviec.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_LOAIANID",vLoaian),
                new OracleParameter("p_TOAANID",vToaAnID),
                new OracleParameter("p_MAVUVIEC",vMavuviec),
                new OracleParameter("p_THULYTUNGAY",vThulytungay),
                new OracleParameter("p_THULYDENNGAY",vDenngay),
                new OracleParameter("p_TINHTRANGTHULY",vTinhtrangthuly),
                new OracleParameter("p_THAMPHANGIAIQUYET",vThamphangiaiquyet),
                new OracleParameter("p_TENVUAN",vTenvuan),
                new OracleParameter("p_TRANGTHAIGIAIQUYET",vTrangthaigiaiquyet),
                new OracleParameter("p_CAPXETXU",vCapxetxu),
                new OracleParameter("p_TRANGTHAI",vTrangthai),
                new OracleParameter("p_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl;
            switch (vLoaian)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_HINHSU:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.KDTM_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.APS_VUAN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN_BPXLHC.GET_AN_BAN_GIAO", parameters);
                    break;
                default:
                    tbl = null;
                    break;
            }
            return tbl;
        }

        /// <summary>
        /// Lấy danh sách chờ nhận
        /// </summary>
        /// <param name="loaiAnId"></param>
        /// <param name="toaAnId"></param>
        /// <param name="maVuViec"></param>
        /// <param name="thuLyTuNgay"></param>
        /// <param name="thuLyDenNgay"></param>
        /// <param name="tinhTrangThuLy"></param>
        /// <param name="thamPhanGiaiQuyet"></param>
        /// <param name="tenVuAn"></param>
        /// <param name="trangThaiGiaiQuyet"></param>
        /// <param name="capXetXu"></param>
        /// <param name="trangThai"></param>
        /// <returns></returns>
        public DataTable GETS_CHONHAN(string loaiAnId, decimal toaAnId, string maVuViec, DateTime? thuLyTuNgay, DateTime? thuLyDenNgay, string tinhTrangThuLy, string thamPhanGiaiQuyet, string tenVuAn, string trangThaiGiaiQuyet, string capXetXu, string trangThai)
        {
            maVuViec = maVuViec.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_LOAIANID",loaiAnId),
                new OracleParameter("p_TOAANID",toaAnId),
                new OracleParameter("p_MAVUVIEC",maVuViec),
                new OracleParameter("p_THULYTUNGAY",thuLyTuNgay),
                new OracleParameter("p_THULYDENNGAY",thuLyDenNgay),
                new OracleParameter("p_TINHTRANGTHULY",tinhTrangThuLy),
                new OracleParameter("p_THAMPHANGIAIQUYET",thamPhanGiaiQuyet),
                new OracleParameter("p_TENVUAN",tenVuAn),
                new OracleParameter("p_TRANGTHAIGIAIQUYET",trangThaiGiaiQuyet),
                new OracleParameter("p_CAPXETXU",capXetXu),
                new OracleParameter("p_TRANGTHAI",trangThai),
                new OracleParameter("p_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl;
            switch (loaiAnId)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.ADS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.AN_HINHSU:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.AHS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.AHN_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.KDTM_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.ALD_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.AHC_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN.APS_VUAN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_AN_BPXLHC.GETS_CHONHAN", parameters);
                    break;
                default:
                    tbl = null;
                    break;
            }
            return tbl;
        }
    }
}