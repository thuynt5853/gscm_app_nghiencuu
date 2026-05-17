using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP.GDTTT
{
    public class TONGDAT_GDKT_BL
    {
        public DataTable VUAN_PHAT_HANH_SEARCH(String v_ID_USER, string CHK_CONLAI_, string V_COLUME, string V_ASC_DESC, decimal vToaAnID, decimal vPhongBanID, decimal vToaRaBAQD, string vSoBAQD
           , string vNgayBAQD, string vNguoiGui, string vCoquanchuyendon
           , string vNguyendon, string vBidon
           , decimal vLoaiAn, decimal vThamtravien
           , decimal vLanhdao, decimal vThamphan, decimal vQHPLID, decimal vQHPLDNID
           , decimal vTraloidon, decimal vLoaiCVID
           , DateTime? vNgayThulyTu, DateTime? vNgayThulyDen
           , string vSoThuly, decimal vTrangthai, decimal vKetquathuly, decimal vKetquaxetxu
           , int isMuonHoSo, int isToTrinh, int isYKienKLToTrinh, int isBuocTT, int LoaiAnDB, String LoaiAnDB_TH, int IsHoanTHA
           , int typetb, int isdangkybc, int captrinhtiep_id, int type_hoidongtp, decimal _ISXINANGIAM, decimal _GDT_ISXINANGIAM, decimal _SodonTLM, decimal _LoaiGDT
           , string vQHPL_TD, decimal vloaingaysearch, DateTime? vNgaySearch_Tu, DateTime? vNgaySearch_Den, string vSoVB, string vNgayVB, string vTrangThai, string vVBPH, decimal PageIndex, decimal PageSize)
        {
            if (vNgayThulyTu == DateTime.MinValue) vNgayThulyTu = null;
            if (vNgayThulyDen == DateTime.MinValue) vNgayThulyDen = null;
            OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_ID_USER",v_ID_USER),
                    new OracleParameter("V_CONLAI_",CHK_CONLAI_),
                    new OracleParameter("V_COLUME",V_COLUME),
                    new OracleParameter("V_ASC_DESC",V_ASC_DESC),
                    new OracleParameter("vToaAnID",vToaAnID),
                    new OracleParameter("vPhongBanID",vPhongBanID),
                    new OracleParameter("vToaRaBAQD",vToaRaBAQD),
                    new OracleParameter("vSoBAQD",vSoBAQD),
                    new OracleParameter("vNgayBAQD",vNgayBAQD),
                    new OracleParameter("vNguoiGui",vNguoiGui),
                    new OracleParameter("vCoquanchuyendon",vCoquanchuyendon),
                    new OracleParameter("vNguyendon",vNguyendon),
                    new OracleParameter("vBidon",vBidon),
                    new OracleParameter("vLoaiAn",vLoaiAn),
                    new OracleParameter("vThamtravien",vThamtravien),
                    new OracleParameter("vLanhdao",vLanhdao),
                    new OracleParameter("vThamphan",vThamphan),
                    new OracleParameter("vQHPLID",vQHPLID),
                    new OracleParameter("vQHPLDNID",vQHPLDNID),
                    new OracleParameter("vTraloidon",vTraloidon),
                    new OracleParameter("vLoaiCVID",vLoaiCVID),
                    new OracleParameter("vNgayThulyTu",vNgayThulyTu),
                    new OracleParameter("vNgayThulyDen",vNgayThulyDen),
                    new OracleParameter("vSoThuly",vSoThuly),
                    new OracleParameter("vTrangthai",vTrangthai),
                    new OracleParameter("vCapTrinhTiep",captrinhtiep_id),
                    new OracleParameter("vIsDangKyBC",isdangkybc),
                    new OracleParameter("vKetquathuly",vKetquathuly),
                    new OracleParameter("vKetquaxetxu",vKetquaxetxu),

                    new OracleParameter("isTTMuonHS",isMuonHoSo),
                    new OracleParameter("isTTToTrinh", isToTrinh),
                    new OracleParameter("isTTYKienKLTotrinh",isYKienKLToTrinh),
                    new OracleParameter("isBuocTT",isBuocTT),
                    new OracleParameter("LoaiAnDB",LoaiAnDB),
                    new OracleParameter("vLoaiAnDB_TH",LoaiAnDB_TH),
                    new OracleParameter("IsHoanTHA",IsHoanTHA),
                    new OracleParameter("vTypeTB",typetb),

                    new OracleParameter("vTypeHDTP",type_hoidongtp),
                    new OracleParameter("v_ISXINANGIAM",_ISXINANGIAM),
                    new OracleParameter("v_GDT_ISXINANGIAM",_GDT_ISXINANGIAM),
                    new OracleParameter("v_SodonTLM",_SodonTLM),
                    new OracleParameter("v_LoaiGDT",_LoaiGDT),
                    new OracleParameter("v_QHPL_TD",vQHPL_TD),

                    new OracleParameter("v_loaingaysearch",vloaingaysearch),
                    new OracleParameter("v_NgaySearch_Tu",vNgaySearch_Tu),
                    new OracleParameter("v_NgaySearch_Den",vNgaySearch_Den),

                    new OracleParameter("v_SoVB",vSoVB),
                    new OracleParameter("v_NgayVB",vNgayVB),
                    new OracleParameter("v_TrangThai",vTrangThai),
                    new OracleParameter("v_VBPH",vVBPH),

                    new OracleParameter("PageIndex",PageIndex),
                    new OracleParameter("PageSize",PageSize),
                    new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH_SEARCH.GDTTTT_VUAN_PHAT_HANH_SEARCH", parameters);
            return tbl;
            //
        }

        public DataTable GET_VAN_BAN_PHAT_HANH(decimal vVuAnID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_VuAn_ID",vVuAnID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_VAN_BAN_PHAT_HANH", prm);
        }

        public DataTable GET_VAN_BAN_PHAT_HANH_NOINHAN(decimal v_VuAn_ID, decimal vHoSoID, string giaiDoan)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_VuAn_ID",v_VuAn_ID),
                new OracleParameter("v_HoSo_ID",vHoSoID),
                new OracleParameter("v_GiaiDoan",giaiDoan),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_VAN_BAN_PHAT_HANH_NOINHAN", prm);
        }
        public DataTable GET_VBPH_NOINHAN_DOITUONG(decimal v_VuAn_ID, string giaiDoan, decimal? v_LoaiAn, decimal? v_ThuLy, decimal isKhangNghi)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_VuAn_ID",v_VuAn_ID),
                new OracleParameter("v_GiaiDoan",giaiDoan),
                new OracleParameter("v_LoaiAn",v_LoaiAn),
                new OracleParameter("v_ThuLy",v_ThuLy),
                new OracleParameter("v_IsKhangNghi",isKhangNghi),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_VBPH_NOINHAN_DOITUONG", prm);
        }
        public decimal TONGDAT_GDKT_UP_IN(TONGDAT_GDKT obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = obj.ID;
            comm.Parameters["v_VUAN_ID"].Value = obj.VUAN_ID;
            comm.Parameters["v_GIAIDOAN"].Value = obj.GIAIDOAN;
            comm.Parameters["v_ID_HS_TLDON"].Value = obj.ID_HS_TLDON;
            comm.Parameters["v_LOAIVB"].Value = obj.LOAIVB;
            comm.Parameters["v_LOAIANID"].Value = obj.LOAIANID;
            comm.Parameters["v_TENVANBAN"].Value = obj.TENVANBAN;
            comm.Parameters["v_SOVB"].Value = obj.SOVB;
            comm.Parameters["v_NGAYVB"].Value = obj.NGAYVB;
            comm.Parameters["v_NGUOIKY"].Value = obj.NGUOIKY;
            comm.Parameters["v_DONVIPHATHANH_ID"].Value = obj.DONVIPHATHANH_ID;
            comm.Parameters["v_DONVIPHATHANH"].Value = obj.DONVIPHATHANH;
            comm.Parameters["v_TOAANID"].Value = obj.TOAANID;
            comm.Parameters["v_NGAYTHUHOI"].Value = obj.NGAYTHUHOI;
            comm.Parameters["v_LYDOTHUHOI"].Value = obj.LYDOTHUHOI;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
            comm.Parameters["v_NGUOISUA"].Value = obj.NGUOISUA;
            comm.Parameters["v_NGAYSUA"].Value = obj.NGAYSUA;
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

        public DataTable TONGDAT_GDKT_GETBYID(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_id",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_GETBYID", prm);
        }

        public bool TONGDAT_GDKT_DEL(Decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = ID;
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
        public decimal TONGDAT_GDKT_NOINHAN_UP_IN(TONGDAT_GDKT_NOINHAN obj)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_NOINHAN_UP_IN", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = obj.ID;
            comm.Parameters["v_TONGDAT_GDKT_ID"].Value = obj.TONGDAT_GDKT_ID;
            comm.Parameters["v_DOITUONG"].Value = obj.DOITUONG;
            comm.Parameters["v_NOINHAN_ID"].Value = obj.NOINHAN_ID;
            comm.Parameters["v_NOINHAN"].Value = obj.NOINHAN;
            comm.Parameters["v_TUCACHTOTUNG"].Value = obj.TUCACHTOTUNG;
            comm.Parameters["v_DIACHI"].Value = obj.DIACHI;
            comm.Parameters["v_TRANGTHAI"].Value = obj.TRANGTHAI;
            comm.Parameters["v_LYDO"].Value = obj.LYDO;
            comm.Parameters["v_NGAYGUI"].Value = obj.NGAYGUI;
            comm.Parameters["v_NGAYPHATHANH"].Value = obj.NGAYPHATHANH;
            comm.Parameters["v_NGAYNHAN"].Value = obj.NGAYNHAN;
            comm.Parameters["v_HINHTHUCGUI"].Value = obj.HINHTHUCGUI;
            comm.Parameters["v_PHATHANHLAI_ID"].Value = obj.PHATHANHLAI_ID;
            comm.Parameters["v_NGUOITAO"].Value = obj.NGUOITAO;
            comm.Parameters["v_NGAYTAO"].Value = obj.NGAYTAO;
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

        public bool TONGDAT_GDKT_DONG_MO_KHOA(decimal vNoiNhanId, decimal vIS_SUA)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_DONG_MO_KHOA", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_NOI_NHAN_ID"].Value = vNoiNhanId;
            comm.Parameters["v_IS_SUA"].Value = vIS_SUA;
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

        public DataTable TONGDAT_GDKT_NOINHAN_GETBYID(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_id",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_NOINHAN_GETBYID", prm);
        }

        public bool TONGDAT_GDKT_NOINHAN_DEL(Decimal ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_NOINHAN_DEL", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["v_id"].Value = ID;
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
        public DataTable GET_TONGDAT_GDKT(decimal vID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_VUAN_ID",vID),
                 new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_TONGDAT_GDKT", prm);
        }
        public DataTable GET_VBPH_NOINHAN_EDIT(decimal v_TONGDAT_GDKT_ID, decimal v_Loai, decimal NoiNhanID)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_TONGDAT_GDKT_ID",v_TONGDAT_GDKT_ID),
                new OracleParameter("v_Loai",v_Loai),
                new OracleParameter("v_NOINHAN_ID",NoiNhanID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_VBPH_NOINHAN_EDIT", prm);
        }
        public bool THUHOI_TONGDAT_GDKT(decimal vID, DateTime vNgayThuHoi, string vLyDo, string vNguoiSua)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.THUHOI_TONGDAT_GDKT", conn);
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
        public DataTable GET_VAN_BAN_PHAT_HANH_CHUAGUI(decimal v_VuAn_ID, string v_LoaiVBPH)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_VuAn_ID",v_VuAn_ID),
                new OracleParameter("v_LoaiVBPH",v_LoaiVBPH),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_VAN_BAN_PHAT_HANH_CHUAGUI", prm);
        }
        public DataTable GET_VAN_BAN_PHAT_HANH_DAGUI(decimal v_VUANID, string v_LoaiVBPH, string v_TrangThai)
        {

            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("v_VUANID",v_VUANID),
                new OracleParameter("v_LoaiVBPH",v_LoaiVBPH),
                new OracleParameter("v_TrangThai",v_TrangThai),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("PKG_GDTTT_VUAN_PHATHANH.GET_VAN_BAN_PHAT_HANH_DAGUI", prm);
        }

        public bool TONGDAT_GDKT_FILE_UPD(decimal v_ID, string v_TENFILE, string v_FILE_URL)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_FILE_UPD", conn);
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

        public bool TONGDAT_GDKT_NOINHAN_PHATHANH_UPD(decimal v_ID, DateTime v_NGAYPHATHANH)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_NOINHAN_PHATHANH_UPD", conn);
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

        public bool TONGDAT_GDKT_NOINHAN_TRAKETQUA(decimal v_ID, decimal? v_TRANGTHAI, DateTime v_NGAYNHAN, string v_LYDO)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_GDTTT_VUAN_PHATHANH.TONGDAT_GDKT_NOINHAN_TRAKETQUA", conn);
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
    }
}