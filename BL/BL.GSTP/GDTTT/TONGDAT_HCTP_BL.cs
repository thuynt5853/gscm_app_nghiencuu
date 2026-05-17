using BL.GSTP.BANGSETGET;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP.TONGDAT
{
    public class TONGDAT_HCTP_BL
    {
        public decimal TONGDAT_HCTP_INS_UPD(TONGDAT_HCTP obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_PHATHANH.TONGDAT_HCTP_INS_UPD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_DON_ID"].Value = obj.DON_ID;
            comm.Parameters["v_LOAIVANBAN"].Value = obj.LOAIVB;
            comm.Parameters["v_TENVANBAN"].Value = obj.TENVANBAN;
            comm.Parameters["v_SOVB"].Value = obj.SOVB;
            comm.Parameters["v_NGAYVB"].Value = obj.NGAYVB;
            comm.Parameters["v_NGUOIKY"].Value = obj.NGUOIKY;
            comm.Parameters["v_DONVIPHATHANH_ID"].Value = obj.DONVIPHATHANH_ID;
            comm.Parameters["v_DONVIPHATHANH"].Value = obj.DONVIPHATHANH;
            comm.Parameters["v_TOAANID"].Value = obj.TOAANID;
            comm.Parameters["v_NGAYTHUHOI"].Value = obj.NGAYTHUHOI;
            comm.Parameters["v_LYDOTHUHOI"].Value = obj.LYDOTHUHOI;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["v_NGAYSUA"].Value = obj.NGAYSUA;
            comm.Parameters["v_NGUOISUA"].Value = obj.NGUOISUA;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return Convert.ToDecimal(comm.Parameters["vID"].Value.ToString());
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return 0;
            }
            finally
            {
                conn.Close();
            }
        }

        public decimal TONGDAT_HCTP_NOINHAN_INS_UPD(TONGDAT_HCTP_NOINHAN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_PHATHANH.TONGDAT_HCTP_NOINHAN_INS_UPD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = obj.ID;
            comm.Parameters["v_TONGDAT_HCTP_ID"].Value = obj.TONGDAT_HCTP_ID;
            comm.Parameters["v_NOINHAN_ID"].Value = obj.NOINHAN_ID;
            comm.Parameters["v_NOINHAN"].Value = obj.NOINHAN;
            comm.Parameters["v_DOITUONG"].Value = obj.DOITUONG;
            comm.Parameters["v_TUCACHTOTUNG"].Value = obj.TUCACHTOTUNG;
            comm.Parameters["v_DIACHI"].Value = obj.DIACHI;
            comm.Parameters["v_TRANGTHAI"].Value = obj.TRANGTHAI;
            comm.Parameters["v_LYDO"].Value = obj.LYDO;
            comm.Parameters["v_NGAYGUI"].Value = obj.NGAYGUI;
            comm.Parameters["v_NGAYPHATHANH"].Value = obj.NGAYPHATHANH;
            comm.Parameters["v_NGAYNHAN"].Value = obj.NGAYNHAN;
            comm.Parameters["v_HINHTHUCGUI"].Value = obj.HINHTHUCGUI;
            comm.Parameters["v_PHATHANHLAI_ID"].Value = obj.PHATHANHLAI_ID;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return Convert.ToDecimal(comm.Parameters["vID"].Value.ToString());
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return 0;
            }
            finally
            {
                conn.Close();
            }
        }

        public DataTable TONGDAT_HCTP_GETBYID(decimal ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_ID",ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_HCTP_PHATHANH.TONGDAT_HCTP_GETBYID", prm);
        }

        public DataTable TONGDAT_HCTP_NOINHAN_GETBYID(decimal ID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_ID",ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_HCTP_PHATHANH.TONGDAT_HCTP_NOINHAN_GETBYID", prm);
        }

        public bool TONGDAT_HCTP_DEL(decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_PHATHANH.TONGDAT_HCTP_DEL", conn);
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
        public DataTable GDTTT_HCTP_PHATHANH_CONGVAN_SEARCH(decimal vToaAnID, string vNguoiGui, string vSoBAQD, string vNgayBAQD, decimal vToaRaBAQD, decimal vLoaiAn, string vTrangThai_PH, decimal vNoiChuyen, decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, string V_LOAI_VB, decimal V_SO_TU, decimal V_SO_DEN, string V_NGAY_FROM, string V_NGAY_TO, decimal vIsThuLy, int PageIndex, int PageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vTrangThai_PH",vTrangThai_PH),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                new OracleParameter("V_LOAI_VB",V_LOAI_VB),
                new OracleParameter("V_SO_TU",V_SO_TU),
                new OracleParameter("V_SO_DEN",V_SO_DEN),
                new OracleParameter("V_NGAY_FROM",V_NGAY_FROM),
                new OracleParameter("V_NGAY_TO",V_NGAY_TO),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_PHATHANH.GDTTT_HCTP_PHATHANH_CONGVAN_SEARCH", prm);
        }
        public DataTable GDTTT_HCTP_PHATHANH_TOTRINH_SEARCH(decimal vToaAnID, string vNguoiGui, string vSoBAQD, string vNgayBAQD, decimal vToaRaBAQD, decimal vLoaiAn, string vTrangThai_PH, decimal vNoiChuyen, decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, string V_LOAI_VB, decimal V_SO_TU, decimal V_SO_DEN, string V_NGAY_FROM, string V_NGAY_TO, decimal vIsThuLy, int PageIndex, int PageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vTrangThai_PH",vTrangThai_PH),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                new OracleParameter("V_LOAI_VB",V_LOAI_VB),
                new OracleParameter("V_SO_TU",V_SO_TU),
                new OracleParameter("V_SO_DEN",V_SO_DEN),
                new OracleParameter("V_NGAY_FROM",V_NGAY_FROM),
                new OracleParameter("V_NGAY_TO",V_NGAY_TO),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_PHATHANH.GDTTT_HCTP_PHATHANH_TOTRINH_SEARCH", prm);
        }
        public DataTable GDTTT_HCTP_PHATHANH_DON_SEARCH(decimal vToaAnID, string vNguoiGui, string vSoBAQD, string vNgayBAQD, decimal vToaRaBAQD, decimal vLoaiAn, string vTrangThai_PH, decimal vNoiChuyen, decimal vCD_DONVIID, decimal vCD_TA_TRANGTHAI, string vCD_TENDONVI, string V_LOAI_VB, decimal V_SO_TU, decimal V_SO_DEN, string V_NGAY_FROM, string V_NGAY_TO, decimal vIsThuLy, int PageIndex, int PageSize)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vToaAnID",vToaAnID),
                new OracleParameter("vNguoiGui",vNguoiGui),
                new OracleParameter("vSoBAQD",vSoBAQD),
                new OracleParameter("vNgayBAQD",vNgayBAQD),
                new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                new OracleParameter("vLoaiAn",vLoaiAn),
                new OracleParameter("vTrangThai_PH",vTrangThai_PH),
                new OracleParameter("vNoiChuyen",vNoiChuyen),
                new OracleParameter("vCD_DONVIID",vCD_DONVIID),
                new OracleParameter("vCD_TA_TRANGTHAI",vCD_TA_TRANGTHAI),
                new OracleParameter("vCD_TENDONVI",vCD_TENDONVI),
                new OracleParameter("V_LOAI_VB",V_LOAI_VB),
                new OracleParameter("V_SO_TU",V_SO_TU),
                new OracleParameter("V_SO_DEN",V_SO_DEN),
                new OracleParameter("V_NGAY_FROM",V_NGAY_FROM),
                new OracleParameter("V_NGAY_TO",V_NGAY_TO),
                new OracleParameter("vIsThuLy",vIsThuLy),
                new OracleParameter("PageIndex",PageIndex),
                new OracleParameter("PageSize",PageSize),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_PHATHANH.GDTTT_HCTP_PHATHANH_DON_SEARCH", prm);
        }
        public bool TONGDAT_HCTP_FILE_UPD(decimal v_ID, string v_TENFILE, string v_FILE_URL)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_PHATHANH.TONGDAT_HCTP_FILE_UPD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = v_ID;
            comm.Parameters["v_TENFILE"].Value = v_TENFILE;
            comm.Parameters["v_FILE_URL"].Value = v_FILE_URL;
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

        public bool TONGDAT_HCTP_NOINHAN_PHATHANH_UPD(decimal v_ID, DateTime v_NGAYPHATHANH)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_PHATHANH.TONGDAT_HCTP_NOINHAN_PHATHANH_UPD", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = v_ID;
            comm.Parameters["v_NGAYPHATHANH"].Value = v_NGAYPHATHANH;
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

        public bool TONGDAT_HCTP_NOINHAN_TRAKETQUA(decimal v_ID, decimal? v_TRANGTHAI, DateTime v_NGAYNHAN, string v_LYDO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_HCTP_PHATHANH.TONGDAT_HCTP_NOINHAN_TRAKETQUA", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_ID"].Value = v_ID;
            comm.Parameters["v_NGAYNHAN"].Value = v_NGAYNHAN;
            comm.Parameters["v_TRANGTHAI"].Value = v_TRANGTHAI;
            comm.Parameters["v_LYDO"].Value = v_LYDO;
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
        public DataTable GET_VAN_BAN_PHAT_HANH(decimal vID, decimal vLoaiVB)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                new OracleParameter("vLoaiVB",vLoaiVB),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_PHATHANH.GET_VAN_BAN_PHAT_HANH", prm);
        }
        public DataTable GET_VBPH_NOINHAN_DOITUONG(decimal vID, decimal vLoaiVB)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vID",vID),
                new OracleParameter("vLoaiVB",vLoaiVB),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_PHATHANH.GET_VBPH_NOINHAN_DOITUONG", prm);
        }
        public DataTable GET_VBPH_NOINHAN_DOITUONG_EDIT(decimal v_TONGDAT_HCTP_ID, decimal v_NOINHAN_ID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_TONGDAT_HCTP_ID",v_TONGDAT_HCTP_ID),
                new OracleParameter("v_NOINHAN_ID",v_NOINHAN_ID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_HCTP_PHATHANH.GET_VBPH_NOINHAN_DOITUONG_EDIT", prm);
        }
        public decimal THUHOI_TONGDAT_HCTP(decimal vID, DateTime vNgayThuHoi, string vLyDo, string vNguoiSua)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_HCTP_PHATHANH.THUHOI_TONGDAT_HCTP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = vID;
            comm.Parameters["vNgayThuHoi"].Value = vNgayThuHoi;
            comm.Parameters["vLyDo"].Value = vLyDo;
            comm.Parameters["vNguoiSua"].Value = vNguoiSua;
            try
            {
                comm.ExecuteNonQuery();
                tran.Commit();
                return Convert.ToDecimal(comm.Parameters["vCount"].Value.ToString());
            }
            catch (Exception ex)
            {
                tran.Rollback();
                return 0;
            }
            finally
            {
                conn.Close();
            }
        }
    }
}