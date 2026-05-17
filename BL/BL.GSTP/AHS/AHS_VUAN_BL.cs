using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using DAL.GSTP;
using System.Text;
using BL.GSTP.BANGSETGET.AHS;
using BL.GSTP.BANGSETGET;

namespace BL.GSTP
{
    public class AHS_VUAN_BL
    {
        GSTPContext dt = new GSTPContext();
        public DataTable GetLastHsVuAnNotComlete(decimal toa_an_id, string nguoitao)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("toa_an_id",toa_an_id)
                , new OracleParameter("nguoi_tao",nguoitao)
                , new OracleParameter("curReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("AHS_VuAn_GetLastNotComleteHoSo", prm);
        }
        public DataTable SearchTopByToaAn(decimal SoLuong, string Textsearch, int ToaAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("SoLuong",SoLuong)
                , new OracleParameter("TextKey",Textsearch)
                , new OracleParameter("currToaAnID",ToaAnID)
                , new OracleParameter("CurReturn",OracleDbType.RefCursor,ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("DM_VKS_SearchTop", prm);
        }
        public decimal GETNEWTT(decimal ToaAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vdonviID",ToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_VuAn_GETMAXTT", parameters);
            return Convert.ToDecimal(tbl.Rows[0][0]) + 1;
        }
        public DataTable GetAllPaging(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id, string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI, decimal vchecktk, decimal V_CHECK_PTQDK, string V_VAITROTHAMPHAN_ID, decimal V_AN_KET_THUC, decimal PageIndex, decimal PageSize, decimal isThanhNien, decimal isHTXX, decimal isGDTaoHS)
        {
            v_ten_vu_an = v_ten_vu_an.Trim().Normalize(NormalizationForm.FormC);
            v_toidanh = v_toidanh.Trim().Normalize(NormalizationForm.FormC);
            v_ma_vu_an = v_ma_vu_an.Trim().Normalize(NormalizationForm.FormC);
            v_bi_can = v_bi_can.Trim().Normalize(NormalizationForm.FormC);
            v_QD_TAMGIAM = v_QD_TAMGIAM.Trim().Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Trim().Normalize(NormalizationForm.FormC);
            if (V_CHECK_PTQDK == 0)
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("vchecktk",vchecktk),
                        new OracleParameter("V_THANHNIEN",isThanhNien),
                        new OracleParameter("v_HINHTHUCXX",isHTXX),
                        new OracleParameter("v_GDTaoHS",isGDTaoHS),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_AHS_STPT_DS.AHS_VUAN_SEARCH_TURNING", parameters);
                return tbl;
            }
            else
            {
                OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("vchecktk",vchecktk),
                        new OracleParameter("V_THANHNIEN",isThanhNien),
                        new OracleParameter("v_HINHTHUCXX",isHTXX),
                        new OracleParameter("v_GDTaoHS",isGDTaoHS),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITROTHAMPHAN_ID),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
                DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_AHS_GS.AHS_VUAN_GETALLPAGING", parameters);
                return tbl;
            }
        }
        public DataTable GetAllPaging_Search_All(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id,
                                                string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY,
                                                string V_DENNGAY, string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id, string V_VAITRO_THAMPHAN,
                                                string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI, string V_LOAIAN_ID, decimal V_AN_KET_THUC, decimal PageIndex, decimal PageSize)
        {
            v_ten_vu_an = v_ten_vu_an.Normalize(NormalizationForm.FormC);
            v_toidanh = v_toidanh.Normalize(NormalizationForm.FormC);
            v_ma_vu_an = v_ma_vu_an.Normalize(NormalizationForm.FormC);
            v_bi_can = v_bi_can.Normalize(NormalizationForm.FormC);
            v_QD_TAMGIAM = v_QD_TAMGIAM.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITRO_THAMPHAN),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("V_AN_KET_THUC",V_AN_KET_THUC), // VPNT- Đinh Hoàng Sơn - thêm điều kiện lọc Vụ án đã giải quyết xong từ toà cũ -19-9-2025
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("HS_DS_EXT_SEARCH_ALL", parameters);
            return tbl;
        }
        public DataTable GetAllPaging_GIAOHS_VKS(string V_DON_ID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_DON_ID",V_DON_ID),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_SEARCH_ALL.HS_DS_GIAO_HOSO_VKS", parameters);
            return tbl;
        }

        public DataTable GetAllPaging_PCTP_Print_VKS(string V_DON_ID, decimal V_DONVIID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_DON_ID",V_DON_ID),
                        new OracleParameter("V_DONVIID",V_DONVIID)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_SEARCH_ALL.HS_DS_AN_CHUYENVKS", parameters);
            return tbl;
        }

        public DataTable HS_DS_AN_DATHULY(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id,
        string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_KETQUA,
        string v_so_qd, string v_ngay_qd, string v_thamphan_id, string V_VAITRO_THAMPHAN, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, string V_UTTPDI,
        string V_LOAIAN_ID, decimal PageIndex, decimal PageSize)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("V_VAITRO_THAMPHAN",V_VAITRO_THAMPHAN),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("V_UTTP",V_UTTPDI),
                        new OracleParameter("V_LOAIAN_ID",V_LOAIAN_ID),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };

            DataTable tbl = Cls_Comon.GetTableByProcedurePaging_baocao("PKG_STPT_SEARCH_ALL.HS_DS_AN_DATHULY", parameters);
            return tbl;
        }


        public DataTable GetAllPaging_PCTP(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id, string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, decimal PageIndex, decimal PageSize)
        {
            v_ten_vu_an = v_ten_vu_an.Normalize(NormalizationForm.FormC);
            v_toidanh = v_toidanh.Normalize(NormalizationForm.FormC);
            v_ma_vu_an = v_ma_vu_an.Normalize(NormalizationForm.FormC);
            v_bi_can = v_bi_can.Normalize(NormalizationForm.FormC);
            v_QD_TAMGIAM = v_QD_TAMGIAM.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_PCTP_HS.AHS_VUAN_GETALLPAGING", parameters);
            return tbl;
        }
        public DataTable GetAllPaging_PCTP_Print(string V_CAP_XET_XU_LOGIN, string v_ten_vu_an, string v_toidanh, string v_ma_vu_an, string v_bi_can, string v_Capxx, string v_toaan_id, string v_TINHTRANG_THULY, string v_SOTHULY, string V_NGAYTHULY_TU, string V_NGAYTHULY_DEN, string v_TINHTRANG_GIAIQUYET, string V_TUNGAY, string V_DENNGAY, string v_KETQUA, string v_so_qd, string v_ngay_qd, string v_thamphan_id, string v_thuky_id, string v_THOIHAN_GQ, string v_QD_TAMGIAM, decimal PageIndex, decimal PageSize)
        {
            v_ten_vu_an = v_ten_vu_an.Normalize(NormalizationForm.FormC);
            v_toidanh = v_toidanh.Normalize(NormalizationForm.FormC);
            v_ma_vu_an = v_ma_vu_an.Normalize(NormalizationForm.FormC);
            v_bi_can = v_bi_can.Normalize(NormalizationForm.FormC);
            v_QD_TAMGIAM = v_QD_TAMGIAM.Normalize(NormalizationForm.FormC);
            v_so_qd = v_so_qd.Normalize(NormalizationForm.FormC);
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("v_cursor",OracleDbType.RefCursor, ParameterDirection.ReturnValue),
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("v_ten_vu_an",v_ten_vu_an),
                        new OracleParameter("v_toidanh",v_toidanh),
                        new OracleParameter("v_ma_vu_an",v_ma_vu_an),
                        new OracleParameter("v_bi_can",v_bi_can),
                        new OracleParameter("v_Capxx",v_Capxx),
                        new OracleParameter("v_toaan_id", v_toaan_id),
                        new OracleParameter("v_TINHTRANG_THULY",v_TINHTRANG_THULY),
                        new OracleParameter("V_NGAYTHULY_TU",V_NGAYTHULY_TU),
                        new OracleParameter("V_NGAYTHULY_DEN",V_NGAYTHULY_DEN),
                        new OracleParameter("v_SOTHULY",v_SOTHULY),
                        new OracleParameter("v_TINHTRANG_GIAIQUYET",v_TINHTRANG_GIAIQUYET),
                        new OracleParameter("V_TUNGAY",V_TUNGAY),
                        new OracleParameter("V_DENNGAY",V_DENNGAY),
                        new OracleParameter("v_KETQUA", v_KETQUA),
                        new OracleParameter("v_so_qd", v_so_qd),
                        new OracleParameter("v_ngay_qd", v_ngay_qd),
                        new OracleParameter("v_thamphan_id",v_thamphan_id),
                        new OracleParameter("v_thuky_id",v_thuky_id),
                        new OracleParameter("v_THOIHAN_GQ",v_THOIHAN_GQ),
                        new OracleParameter("v_QD_TAMGIAM",v_QD_TAMGIAM),
                        new OracleParameter("Page_Index",PageIndex),
                        new OracleParameter("Page_Size",PageSize)
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_PCTP_HS.AHS_VUAN_GETALLPAGING_PRINT", parameters);
            return tbl;
        }
        public int UpdateGiaiDoanVuAn(Decimal VUANID, int GiaiDoanVuAn, String NguoiSua)
        {
            int retval = 0;
            GSTPContext dt = new GSTPContext();
            if (VUANID > 0)
            {
                AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == VUANID).Single<AHS_VUAN>();
                if (obj != null)
                {
                    obj.MAGIAIDOAN = GiaiDoanVuAn;
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = NguoiSua;
                    dt.SaveChanges();
                    retval = 1;
                }
            }
            return retval;
        }
        public DataTable AHS_VUAN_GETTOAANBYVUAN(decimal vVuAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("vVuAnID",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("AHS_VUAN_GETTOAANBYVUAN", prm);
        }
        public DataTable GetThongTin(decimal vVuAnID)
        {
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("curr_vuan_id",vVuAnID),
                new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output)
            };
            return Cls_Comon.GetTableByProcedurePaging("AHS_VuAn_GetThongTin", prm);
        }
        public DataTable AHS_FILE_TONGDAT(decimal vAnID)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vAnID",vAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_FILE_TONGDAT", parameters);
            return tbl;
        }
        public DataTable AHS_TONGDAT_GETLIST(decimal vVuAnID, decimal vToaAnID)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_TONGDAT_GETLIST", parameters);
            return tbl;
        }
        public DataTable AHS_TONGDAT_DOITUONG_GETBY(decimal vVuAnID, decimal vToaAnID, decimal vBieuMauID, decimal vIsOnlyNKK)
        {

            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVuAnID),
                                                                        new OracleParameter("vToaAnID",vToaAnID),
                                                                        new OracleParameter("vBieuMauID",vBieuMauID),
                                                                        new OracleParameter("vIsOnlyNKK",vIsOnlyNKK),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("AHS_TONGDAT_DOITUONG_GETBY", parameters);
            return tbl;
        }
        public bool DELETE_ALLDATA_BY_VUANID(string in_VUANID)
        {
            try
            {
                OracleParameter[] parameters = new OracleParameter[] { new OracleParameter("in_VUANID", in_VUANID) };
                decimal dbl = Cls_Comon.ExcuteProcResult("PKG_GSTP_DELETE.DELETE_DATA_AHS_BY_VUANID", parameters);
                return dbl == 1 ? true : false;
            }
            catch { return false; }
        }
        public bool PHANCONGTP_INS_UP(String V_TRANGTHAI, String V_THAMPHANGQ_ID, String V_VUANID, String V_SOQD, String V_NGAYQD, String V_THULY, String V_NGAYPHANCONGTP, String V_THAM_PHAN_ID, String V_NGAYPHANCONGLD, String V_PHANCONGLD_ID, String V_CAPXX, String V_NGUOITAO, ref Decimal V_COUNTS, ref String V_THONGBAO
            ,String V_TOA_GIAIQUYET_ID)
        {
            OracleConnection conn = Cls_Comon.OpenConnection();
            OracleCommand comm = new OracleCommand("PKG_PCTP_HS.PCTP_INS_UP", conn);
            comm.CommandType = CommandType.StoredProcedure;
            comm.CommandTimeout = 60; // timeout 60 giây
            OracleCommandBuilder.DeriveParameters(comm);
            OracleTransaction tran = conn.BeginTransaction();
            comm.Transaction = tran;
            comm.Parameters["V_TRANGTHAI"].Value = V_TRANGTHAI;
            comm.Parameters["V_THAMPHANGQ_ID"].Value = V_THAMPHANGQ_ID;
            comm.Parameters["V_VUANID"].Value = V_VUANID;
            comm.Parameters["V_SOQD"].Value = V_SOQD;
            comm.Parameters["V_NGAYQD"].Value = V_NGAYQD;
            comm.Parameters["V_THULY"].Value = V_THULY;
            comm.Parameters["V_NGAYPHANCONGTP"].Value = V_NGAYPHANCONGTP;
            comm.Parameters["V_THAM_PHAN_ID"].Value = V_THAM_PHAN_ID;
            comm.Parameters["V_NGAYPHANCONGLD"].Value = V_NGAYPHANCONGLD;
            comm.Parameters["V_PHANCONGLD_ID"].Value = V_PHANCONGLD_ID;
            comm.Parameters["V_CAPXX"].Value = V_CAPXX;
            comm.Parameters["V_NGUOITAO"].Value = V_NGUOITAO;
            comm.Parameters["V_TOA_GIAIQUYET_ID"].Value = V_TOA_GIAIQUYET_ID;
            comm.Parameters["V_COUNTS"].Direction = ParameterDirection.Output;
            comm.Parameters["V_THONGBAO"].Direction = ParameterDirection.Output;
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
                V_COUNTS = Convert.ToDecimal(comm.Parameters["V_COUNTS"].Value.ToString());
                V_THONGBAO = Convert.ToString(comm.Parameters["V_THONGBAO"].Value.ToString());
                conn.Close();
            }
        }
        public bool Check_ThuLy(decimal VuAnID, decimal vHTC)
        {
            if (vHTC == 0)
            {
                AHS_PHUCTHAM_THULY ObjThuLy = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (ObjThuLy != null)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                AHS_SOTHAM_THULY ObjThuLy = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).FirstOrDefault();
                if (ObjThuLy != null)
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }


        }

        public DataTable DATAVUAN_BY_VUANID_NGUOITAO(decimal vVUANID, string in_Nguoitao)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                                                                        new OracleParameter("vVuAnID",vVUANID),
                                                                        new OracleParameter("vNguoiTao",in_Nguoitao),
                                                                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                                                                      };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_STPT.Get_VUAN_by_VUANID_NGUOITAO", parameters);
            return tbl;
        }

        public DataTable DON_QUAHAN_CHITIET(string V_CAP_XET_XU_LOGIN, string V_TOAAN_ID, string V_TK_QUAHAN_ID, string V_DS_DONID, decimal PAGE_INDEX, decimal PAGE_SIZE)
        {
            OracleParameter[] parameters = new OracleParameter[] {
                        new OracleParameter("V_CAP_XET_XU_LOGIN",V_CAP_XET_XU_LOGIN),
                        new OracleParameter("V_TOAAN_ID",V_TOAAN_ID),
                        new OracleParameter("V_TK_QUAHAN_ID",V_TK_QUAHAN_ID),
                        new OracleParameter("V_DS_DONID",V_DS_DONID),
                        new OracleParameter("PAGE_INDEX",PAGE_INDEX),
                        new OracleParameter("PAGE_SIZE", PAGE_SIZE),
                        new OracleParameter("curReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                        };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("PKG_AHS_STPT_DS_TKQUAHAN.AHS_DON_QUAHAN_CHITIET", parameters);
            return tbl;
        }
    }

}