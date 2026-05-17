using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;

namespace BL.GSTP.THA
{
    public class THA_BANGIAO_MAPPING_BL
    {
        /// <summary>
        /// Thêm cấu hình VUAN_BANGIAO_MAPPING
        /// </summary>
        /// <param name="dmvuanbgGS"></param>
        public void ADD(BANGSETGET.THI_HANH_AN_BANGIAO_MAPPING dmvuanbgGS)
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
                new OracleParameter("p_GHICHU", OracleDbType.Varchar2) { Value = (object)dmvuanbgGS.GHICHU ?? DBNull.Value }
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_ADD", connection);
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
        public void EDIT(BANGSETGET.THI_HANH_AN_BANGIAO_MAPPING dmvuanbgGS)
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
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_EDIT", connection);
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
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_DELETE", connection);
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
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_CHANGE_STATUS", connection);
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
        /// Nhận bàn giao THI_HANH_AN_BANGIAO_MAPPING_NHAN
        /// </summary>
        /// <param name="dmtachnhapGS"></param>
        public void NHAN(decimal? id, decimal? vuViecId, decimal? toaAnNhanId)
        {
            OracleParameter[] parameters = new OracleParameter[]
            {
                new OracleParameter("p_ID", id),
                new OracleParameter("p_VUVIECID", vuViecId),
                new OracleParameter("p_TOAANNHANID", toaAnNhanId),
            };
            OracleConnection connection = Cls_Comon.OpenConnection();
            OracleCommand command = new OracleCommand("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_NHAN", connection);

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
                case ENUM_LOAIAN.AN_HINHSU:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
                default:
                    tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
                    break;
            }
            return tbl;
        }

        /// <summary>
        /// Lấy danh sách có thể bàn giao
        /// </summary>
        /// <param name="loaian"></param>
        /// <param name="vTrangthai"></param>
        /// <param name="toaan_ID"></param>
        /// <param name="ma_bi_an"></param>
        /// <param name="ten_bi_an"></param>
        /// <param name="ma_vu_an"></param>
        /// <param name="ten_vu_an"></param>
        /// <param name="so_ban_an"></param>
        /// <param name="ngaybanan"></param>
        /// <param name="trangthai"></param>
        /// <param name="socmnd"></param>
        /// <param name="tungay"></param>
        /// <param name="denngay"></param>
        /// <returns></returns>
        public DataTable THA_DS_BANGIAO(Decimal loaian, string vTrangthai, Decimal toaan_ID, string ma_bi_an, string ten_bi_an, string ma_vu_an, string ten_vu_an, string so_ban_an, DateTime? ngaybanan, decimal trangthai, decimal trangthaigq, string socmnd, string tungay, string denngay)
        {
            if (ngaybanan == DateTime.MinValue) ngaybanan = null;
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("p_LOAIAN",loaian),
                                                                        new OracleParameter("p_TRANGTHAI",vTrangthai),
                                                                        new OracleParameter("toa_an_id",toaan_ID),
                                                                        new OracleParameter("ma_bi_an",ma_bi_an),
                                                                        new OracleParameter("ten_bi_an",ten_bi_an),
                                                                        new OracleParameter("ma_vu_an",ma_vu_an),
                                                                        new OracleParameter("ten_vu_an",ten_vu_an),
                                                                        new OracleParameter("so_ban_an",so_ban_an),
                                                                        new OracleParameter("ngay_ban_an",ngaybanan),
                                                                        new OracleParameter("trangthai",trangthai),
                                                                        new OracleParameter("trangthaigq",trangthaigq),
                                                                        new OracleParameter("SOCMND",socmnd),
                                                                        new OracleParameter("V_TUNGAY",tungay),
                                                                        new OracleParameter("V_DENNGAY",denngay),
                                                                        new OracleParameter("p_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GET_AN_BAN_GIAO", parameters);
            return tbl;
        }

        /// <summary>
        /// Lấy danh sách chờ nhận
        /// </summary>
        /// <param name="toaAnId"></param>
        /// <param name="biAnMa"></param>
        /// <param name="biAnTen"></param>
        /// <param name="maVuViec"></param>
        /// <param name="tenVuAn"></param>
        /// <param name="soBanAn"></param>
        /// <param name="ngayBanAn"></param>
        /// <param name="trangThaiGiaiQuyet"></param>
        /// <param name="cmnd"></param>
        /// <param name="tuNgay"></param>
        /// <param name="denNgay"></param>
        /// <param name="trangThai"></param>
        /// <returns></returns>
        public DataTable GETS_CHONHAN(decimal toaAnId, string biAnMa, string biAnTen, string maVuViec, string tenVuAn, string soBanAn, 
             DateTime? ngayBanAn, int? trangThaiGiaiQuyet, string cmnd, string tuNgay, string denNgay, string trangThai)
        {
            maVuViec = maVuViec.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_TOAANID",toaAnId),
                new OracleParameter("p_MA_BI_AN",biAnMa),
                new OracleParameter("p_TEN_BI_AN",biAnTen),
                new OracleParameter("p_MA_VU_AN",maVuViec),
                new OracleParameter("p_TEN_VU_AN",tenVuAn),
                new OracleParameter("p_SO_BAN_AN",soBanAn),
                new OracleParameter("p_NGAY_BAN_AN",ngayBanAn),
                new OracleParameter("p_TRANGTHAI_GQ",trangThaiGiaiQuyet),
                new OracleParameter("p_SOCMND",cmnd),
                new OracleParameter("p_TUNGAY",tuNgay),
                new OracleParameter("p_DENNGAY",denNgay),
                new OracleParameter("p_TRANGTHAI",trangThai),
                new OracleParameter("p_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN", parameters);
            return tbl;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="toaAnId"></param>
        /// <param name="biAnMa"></param>
        /// <param name="biAnTen"></param>
        /// <param name="maVuViec"></param>
        /// <param name="tenVuAn"></param>
        /// <param name="soBanAn"></param>
        /// <param name="ngayBanAn"></param>
        /// <param name="trangThaiGiaiQuyet"></param>
        /// <param name="tinhtrangQd"></param>
        /// <param name="cmnd"></param>
        /// <param name="tuNgay"></param>
        /// <param name="denNgay"></param>
        /// <param name="trangThai"></param>
        /// <returns></returns>
        public DataTable GETS_CHONHAN_THA(decimal toaAnId, string biAnMa, string biAnTen, string maVuViec, string tenVuAn, string soBanAn, 
             DateTime? ngayBanAn, int? trangThaiGiaiQuyet, int? tinhtrangQd, string cmnd, string tuNgay, string denNgay, string trangThai)
        {
            maVuViec = maVuViec.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("p_TOAANID",toaAnId),
                new OracleParameter("p_MA_BI_AN",biAnMa),
                new OracleParameter("p_TEN_BI_AN",biAnTen),
                new OracleParameter("p_MA_VU_AN",maVuViec),
                new OracleParameter("p_TEN_VU_AN",tenVuAn),
                new OracleParameter("p_SO_BAN_AN",soBanAn),
                new OracleParameter("p_NGAY_BAN_AN",ngayBanAn),
                new OracleParameter("p_TRANGTHAI_GQ",trangThaiGiaiQuyet),
                new OracleParameter("p_TINHTRANG_QD",tinhtrangQd),
                new OracleParameter("p_SOCMND",cmnd),
                new OracleParameter("p_TUNGAY",tuNgay),
                new OracleParameter("p_DENNGAY",denNgay),
                new OracleParameter("p_TRANGTHAI",trangThai),
                new OracleParameter("p_CURSOR",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_BAN_GIAO_THI_HANH_AN.THI_HANH_AN_BANGIAO_MAPPING_GETS_CHONHAN_THA", parameters);
            return tbl;
        }
    }
}