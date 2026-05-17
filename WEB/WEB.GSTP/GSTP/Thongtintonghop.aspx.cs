using BL.GSTP;
using BL.GSTP.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP
{
    public partial class Thongtintonghop : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadThamPhanInfo();
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadThamPhanInfo()
        {
            decimal ThamPhanID = string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_GSTP] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
            // Thông tin chung
            DM_CANBO_BL bl_CanBo = new DM_CANBO_BL();
            DataTable tblThongTinChung = bl_CanBo.DM_CANBO_GETINFOBYID(ThamPhanID);
            if (tblThongTinChung != null && tblThongTinChung.Rows.Count > 0)
            {
                DataRow row = tblThongTinChung.Rows[0];
                txtTen.Text = row["HOTEN"] + "";
                txtGioiTinh.Text = row["GioiTinh"] + "";
                txtNgaySinh.Text = row["NGAYSINH"] + "" == "" ? "" : ((DateTime)row["NGAYSINH"]).ToString("dd/MM/yyyy");
                txtQD.Text = row["QDBONHIEM"] + "";
                txtDonVi.Text = row["TENTOAAN"].ToString();
                txtChucDanh.Text = row["ChucDanh"].ToString();
            }
            else
            {
                txtTen.Text = txtGioiTinh.Text = txtNgaySinh.Text = txtQD.Text = txtDonVi.Text = txtChucDanh.Text = "";
            }
            // Hoạt động xét xử
            GSTP_BL bl = new GSTP_BL();
            DataTable tPInfo = bl.GSTP_THONGTIN_CHITIET_TP(ThamPhanID);
            if (tPInfo != null && tPInfo.Rows.Count > 0)
            {
                #region Số lượng
                DataRow row = tPInfo.Rows[0];
                decimal PhanCong_GiaiQuyet_SL = Convert.ToDecimal(row["V_AN_PHANCONG_GIAIQUYET"])
                        , HDXX_SL = Convert.ToDecimal(row["V_AN_THANHVIEN_HDXX"])
                        , DaGiaiQuyet_SL = Convert.ToDecimal(row["V_AN_DA_GIAIQUYET"])
                        , KCKN_SL = Convert.ToDecimal(row["V_AN_KHANGNGHI_KHANGCAO"])
                        , ThoiHan_TamGiam_SL = Convert.ToDecimal(row["V_AN_VIPHAM_THOIHAN_TAMGIAM"])
                        , AnHuy_SL = Convert.ToDecimal(row["V_AN_HUY"])
                        , AnHuy_ChuQuan_SL = Convert.ToDecimal(row["V_AN_HUY_CHUQUAN"])
                        , AnSua_SL = Convert.ToDecimal(row["V_AN_SUA"])
                        , AnSua_ChuQuan_SL = Convert.ToDecimal(row["V_AN_SUA_CHUQUAN"])
                        , AnTreo_SL = Convert.ToDecimal(row["V_AN_APDUNG_ANTREO"])
                        , AnBPTT_SL = Convert.ToDecimal(row["V_AN_APDUNG_BPTT"])
                        , AnTDC_SL = Convert.ToDecimal(row["V_AN_TAMDINHCHI"])
                        , AnDC_SL = Convert.ToDecimal(row["V_AN_DINHCHI"])
                        , An_QuaHan_SL = Convert.ToDecimal(row["V_AN_QUAHAN"])
                        , AnRutKN_SL = Convert.ToDecimal(row["V_AN_RUTKINHNGHIEM"])
                        , AnHoaGiai_SL = Convert.ToDecimal(row["V_AN_HOAGIAI_DOITHOAI_THANH"])
                        , AnLe_SL = Convert.ToDecimal(row["V_AN_APDUNG_ANLE"])
                        , An_VKS_ChuaTra_SL = Convert.ToDecimal(row["V_AN_HOSO_VKS_CHUA_TRA"]);

                lblPhanCong_GiaiQuyet_SL.Text = PhanCong_GiaiQuyet_SL.ToString("#,0.##", cul);
                lbl_HDXX_SL.Text = HDXX_SL.ToString("#,0.##", cul);
                lblDaGiaiQuyet_SL.Text = DaGiaiQuyet_SL.ToString("#,0.##", cul);
                lblKCKN_SL.Text = KCKN_SL.ToString("#,0.##", cul);
                lblThoiHan_TamGiam_SL.Text = ThoiHan_TamGiam_SL.ToString("#,0.##", cul);
                lblAnHuy_SL.Text = AnHuy_SL.ToString("#,0.##", cul);
                lblAnHuy_ChuQuan_SL.Text = AnHuy_ChuQuan_SL.ToString("#,0.##", cul);
                lblAnSua_SL.Text = AnSua_SL.ToString("#,0.##", cul);
                lblAnSua_ChuQuan_SL.Text = AnSua_ChuQuan_SL.ToString("#,0.##", cul);
                lblAnTreo_SL.Text = AnTreo_SL.ToString("#,0.##", cul);
                lblAnBPTT_SL.Text = AnBPTT_SL.ToString("#,0.##", cul);
                lblAnTDC_SL.Text = AnTDC_SL.ToString("#,0.##", cul);
                lblAnDC_SL.Text = AnDC_SL.ToString("#,0.##", cul);
                lblAn_QuaHan_SL.Text = An_QuaHan_SL.ToString("#,0.##", cul);
                lblAnRutKN_SL.Text = AnRutKN_SL.ToString("#,0.##", cul);
                lblAnHoaGiai_SL.Text = AnHoaGiai_SL.ToString("#,0.##", cul);
                lblAnLe_SL.Text = AnLe_SL.ToString("#,0.##", cul);
                lblAn_VKS_ChuaTra_SL.Text = An_VKS_ChuaTra_SL.ToString("#,0.##", cul);
                #endregion
                #region Định mức
                // Phần này sẽ được lấy ở danh mục tòa án sau khi bổ sung các thông tin ĐỊNH MỨC
                row = tPInfo.Rows[1];
                decimal PhanCong_GiaiQuyet_DM = Convert.ToDecimal(row["V_AN_PHANCONG_GIAIQUYET"])
                        , HDXX_DM = Convert.ToDecimal(row["V_AN_THANHVIEN_HDXX"])
                        , DaGiaiQuyet_DM = Convert.ToDecimal(row["V_AN_DA_GIAIQUYET"])
                        , KCKN_DM = Convert.ToDecimal(row["V_AN_KHANGNGHI_KHANGCAO"])
                        , ThoiHan_TamGiam_DM = Convert.ToDecimal(row["V_AN_VIPHAM_THOIHAN_TAMGIAM"])
                        , AnHuy_DM = Convert.ToDecimal(row["V_AN_HUY"])
                        , AnHuy_ChuQuan_DM = Convert.ToDecimal(row["V_AN_HUY_CHUQUAN"])
                        , AnSua_DM = Convert.ToDecimal(row["V_AN_SUA"])
                        , AnSua_ChuQuan_DM = Convert.ToDecimal(row["V_AN_SUA_CHUQUAN"])
                        , AnTreo_DM = Convert.ToDecimal(row["V_AN_APDUNG_ANTREO"])
                        , AnBPTT_DM = Convert.ToDecimal(row["V_AN_APDUNG_BPTT"])
                        , AnTDC_DM = Convert.ToDecimal(row["V_AN_TAMDINHCHI"])
                        , AnDC_DM = Convert.ToDecimal(row["V_AN_DINHCHI"])
                        , An_QuaHan_DM = Convert.ToDecimal(row["V_AN_QUAHAN"])
                        , AnRutKN_DM = Convert.ToDecimal(row["V_AN_RUTKINHNGHIEM"])
                        , AnHoaGiai_DM = Convert.ToDecimal(row["V_AN_HOAGIAI_DOITHOAI_THANH"])
                        , AnLe_DM = Convert.ToDecimal(row["V_AN_APDUNG_ANLE"])
                        , An_VKS_ChuaTra_DM = Convert.ToDecimal(row["V_AN_HOSO_VKS_CHUA_TRA"]);

                lblPhanCong_GiaiQuyet_DM.Text = PhanCong_GiaiQuyet_DM.ToString("#,0.##", cul);
                lbl_HDXX_DM.Text = HDXX_DM.ToString("#,0.##", cul);
                lblDaGiaiQuyet_DM.Text = DaGiaiQuyet_DM.ToString("#,0.##", cul);
                lblKCKN_DM.Text = KCKN_DM.ToString("#,0.##", cul);
                lblThoiHan_TamGiam_DM.Text = ThoiHan_TamGiam_DM.ToString("#,0.##", cul);
                lblAnHuy_DM.Text = AnHuy_DM.ToString("#,0.##", cul);
                lblAnHuy_ChuQuan_DM.Text = AnHuy_ChuQuan_DM.ToString("#,0.##", cul);
                lblAnSua_DM.Text = AnSua_DM.ToString("#,0.##", cul);
                lblAnSua_ChuQuan_DM.Text = AnSua_ChuQuan_DM.ToString("#,0.##", cul);
                lblAnTreo_DM.Text = AnTreo_DM.ToString("#,0.##", cul);
                lblAnBPTT_DM.Text = AnBPTT_DM.ToString("#,0.##", cul);
                lblAnTDC_DM.Text = AnTDC_DM.ToString("#,0.##", cul);
                lblAnDC_DM.Text = AnDC_DM.ToString("#,0.##", cul);
                lblAn_QuaHan_DM.Text = An_QuaHan_DM.ToString("#,0.##", cul);
                lblAnRutKN_DM.Text = AnRutKN_DM.ToString("#,0.##", cul);
                lblAnHoaGiai_DM.Text = AnHoaGiai_DM.ToString("#,0.##", cul);
                lblAnLe_DM.Text = AnLe_DM.ToString("#,0.##", cul);
                lblAn_VKS_ChuaTra_DM.Text = An_VKS_ChuaTra_DM.ToString("#,0.##", cul);
                #endregion
                #region Tỷ lệ
                // Không tính tỷ lệ
                lblPhanCong_GiaiQuyet_TyLe.Text = "";
                lbl_HDXX_TyLe.Text = "";
                lblAn_VKS_ChuaTra_TyLe.Text = "";
                // Tính tỉnh lệ theo số lượng án được phân công
                lblDaGiaiQuyet_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (DaGiaiQuyet_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnBPTT_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (AnBPTT_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnTDC_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (AnTDC_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnDC_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (AnDC_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAn_QuaHan_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (An_QuaHan_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnHoaGiai_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (AnHoaGiai_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnLe_TyLe.Text = PhanCong_GiaiQuyet_SL == 0 ? "0" : (AnLe_SL / PhanCong_GiaiQuyet_SL * 100).ToString("#,0.##", cul);
                // Tính tỷ lệ theo tổng số vụ án đã giải quyết
                lblKCKN_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (KCKN_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblThoiHan_TamGiam_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (ThoiHan_TamGiam_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnHuy_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (AnHuy_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnHuy_ChuQuan_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (AnHuy_ChuQuan_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnSua_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (AnSua_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnSua_ChuQuan_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (AnSua_ChuQuan_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnTreo_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (AnTreo_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                lblAnRutKN_TyLe.Text = DaGiaiQuyet_SL == 0 ? "0" : (AnRutKN_SL / DaGiaiQuyet_SL * 100).ToString("#,0.##", cul);
                #endregion
                #region Phần công bố bản án
                // phần công bố bản án số lượng
                decimal BAQD_DaCongBo_SL = 0
                        , BAQD_CongBoCham_SL = 0
                        , BAQD_DinhChinh_SL = 0
                        , BAQD_GoXuong_SL = 0
                        , BAQD_YKien_PhanHoi_SL = 0;

                lblBAQD_DaCongBo_SL.Text = BAQD_DaCongBo_SL.ToString("#,0.##", cul);
                lblBAQD_CongBoCham_SL.Text = BAQD_CongBoCham_SL.ToString("#,0.##", cul);
                lblBAQD_DinhChinh_SL.Text = BAQD_DinhChinh_SL.ToString("#,0.##", cul);
                lblBAQD_GoXuong_SL.Text = BAQD_GoXuong_SL.ToString("#,0.##", cul);
                lblBAQD_YKien_PhanHoi_SL.Text = BAQD_YKien_PhanHoi_SL.ToString("#,0.##", cul);
                // phần công bố bản án định mức
                decimal BAQD_DaCongBo_DM = 0
                        , BAQD_CongBoCham_DM = 0
                        , BAQD_DinhChinh_DM = 0
                        , BAQD_GoXuong_DM = 0
                        , BAQD_YKien_PhanHoi_DM = 0;

                lblBAQD_DaCongBo_DM.Text = BAQD_DaCongBo_DM.ToString("#,0.##", cul);
                lblBAQD_CongBoCham_DM.Text = BAQD_CongBoCham_DM.ToString("#,0.##", cul);
                lblBAQD_DinhChinh_DM.Text = BAQD_DinhChinh_DM.ToString("#,0.##", cul);
                lblBAQD_GoXuong_DM.Text = BAQD_GoXuong_DM.ToString("#,0.##", cul);
                lblBAQD_YKien_PhanHoi_DM.Text = BAQD_YKien_PhanHoi_DM.ToString("#,0.##", cul);
                // phần công bố bản án tỷ lệ
                lblBAQD_DaCongBo_TyLe.Text = BAQD_DaCongBo_DM == 0 ? "0" : (BAQD_DaCongBo_SL / BAQD_DaCongBo_DM * 100).ToString("#,0.##", cul);
                lblBAQD_CongBoCham_TyLe.Text = BAQD_CongBoCham_DM == 0 ? "0" : (BAQD_CongBoCham_SL / BAQD_CongBoCham_DM * 100).ToString("#,0.##", cul);
                lblBAQD_DinhChinh_TyLe.Text = BAQD_DinhChinh_DM == 0 ? "0" : (BAQD_DinhChinh_SL / BAQD_DinhChinh_DM * 100).ToString("#,0.##", cul);
                lblBAQD_GoXuong_TyLe.Text = BAQD_GoXuong_DM == 0 ? "0" : (BAQD_GoXuong_SL / BAQD_GoXuong_DM * 100).ToString("#,0.##", cul);
                lblBAQD_YKien_PhanHoi_TyLe.Text = BAQD_YKien_PhanHoi_DM == 0 ? "0" : (BAQD_YKien_PhanHoi_SL / BAQD_YKien_PhanHoi_DM * 100).ToString("#,0.##", cul);
                #endregion
            }
        }
        protected void lbtVuAnThamGiaXetXu_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuandathamgia.aspx");
        }
        protected void LbtVuAnPhanCong_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_phancong_giaiquyet.aspx");
        }
        protected void LbtVuAnThanhVienHDXX_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_thanhvien_HDXX.aspx");
        }
        protected void LbtVuAnDaGiaiQuyet_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuandagiaiquyet.aspx");
        }
        protected void LbtVuAnKhangCaoKhangNghi_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_khangcao_khangnghi.aspx");
        }
        protected void LbtVuAnViPhamThoiHanTamGiam_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_vipham_thoihan_tamgiam.aspx");
        }
        protected void lbtVuAnHuy_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuanhuy.aspx");
        }
        protected void LbtVuAnHuy_ChuQuan_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuanhuy_chuquan.aspx");
        }
        protected void lbtVuAnSua_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuansua.aspx");
        }
        protected void LbtVuAnSua_ChuQuan_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuansua_chuquan.aspx");
        }
        protected void lbtVuAnTreo_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuantreo.aspx");
        }
        protected void lbtBienPhapTamThoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_apdung_BPKCTT.aspx");
        }
        protected void lbtAnTamDinhChi_Click1(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_tamdinhchi.aspx");
        }
        protected void lbtAnBiDinhChi_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuanbidinhchi.aspx");
        }
        protected void lbtVuAnQuaHan_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuanquahan.aspx");
        }
        protected void LbtVuAnRutKinhNghiem_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_tochuc_PTRKN.aspx");
        }
        protected void LbtVuAnHoaGiai_DoiThoai_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_hoagiai_doithoai_thanhcong.aspx");
        }
        protected void LbtVuAnApDungAnLe_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_apdung_anle.aspx");
        }
        protected void LbtVuAnVKSChuaTraHoSo_Click(object sender, EventArgs e)
        {
            Response.Redirect("HoatDongXuAn/Vuan_hoso_VKS_chuatra.aspx");
        }
        protected void lbtKhenThuong_Click(object sender, EventArgs e)
        {
            Response.Redirect("Thongtinchitietcanbo/KhenThuongKyLuat/Khenthuongkyluat.aspx");
        }
        protected void lbtKhieuNai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Thongtinchitietcanbo/KhieuNaiToCao/Khieunaitocao.aspx");
        }

    }
}