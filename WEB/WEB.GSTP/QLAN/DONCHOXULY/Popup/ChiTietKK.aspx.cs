using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.DONCHOXULY.Popup
{
    public partial class ChiTietKK : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
                if (DonID > 0)
                {
                    AddNguonDen();
                    AddLoaiVanBan();
                    AddNguoiKhoiKien();
                    AddNguoiBiKien();
                    AddLoaiAn();
                    LoadData();
                }
                else
                {
                    Response.Redirect("/Login.aspx");
                }
            }
        }

        //Load thông tin đơn khởi kiện
        private void LoadData()
        {
            lblHoTenNKK.Text = "Họ tên:";
            lblHoTenNBK.Text = "Họ tên:";

            DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();
            //Thông tin bì thư
            ddlNguonDen.SelectedValue = dgn.NGUONDEN.ToString();
            if(dgn.DV_NHAN != null && dgn.DV_NHAN != 0)
            {
                DM_PHONGBAN donViNhan = dt.DM_PHONGBAN.Where(x => x.ID == dgn.DV_NHAN).FirstOrDefault();
                txtDonViNhan.Text = donViNhan.TENPHONGBAN;
            }           
            ddlLoaiVanBan.SelectedValue = dgn.LOAIVANBAN.ToString();
            DM_TOAAN donViGiaiQuyet = dt.DM_TOAAN.Where(x => x.ID == dgn.DV_GIAIQUYET).FirstOrDefault();
            if (donViGiaiQuyet != null)
            {
                txtDonViGiaiQuyet.Text = donViGiaiQuyet.TEN;
            }
            txtSoDen.Text = dgn.SODEN.ToString();
            txtNguoiNhan.Text = dgn.NGUOINHAN;
            txtNgayDen.Text = dgn.NGAYDEN.HasValue ? dgn.NGAYDEN.Value.ToString("dd/MM/yyyy") : "";
            txtNgayGiao.Text = dgn.NGAYGIAO.HasValue ? dgn.NGAYGIAO.Value.ToString("dd/MM/yyyy") : "";
            txtNguoiGui.Text = dgn.NGUOIGUI;
            if (dgn.DCGUI != null && dgn.DCGUI != 0)
            {
                DM_HANHCHINH diaChiGui = dt.DM_HANHCHINH.Where(x => x.ID == dgn.DCGUI).FirstOrDefault();
                txtDiaChiGui.Text = diaChiGui.MA_TEN;
            }
            txtDiaChiGuiChiTiet.Text = dgn.DCGUI_CHITIET;
            txtGhiChu.Text = dgn.GHICHU;

            DON_GUINHAN_DUONGSU nguyenDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && x.TUCACHTOTUNG.Equals("NGUYENDON")).FirstOrDefault();
            //Thông tin người khởi kiện
            if (nguyenDon != null)
            {
                ddlNguoiKhoiKien.SelectedValue = nguyenDon.LOAIDUONGSU.ToString();
                txtHoTenNguoiKhoiKien.Text = nguyenDon.HOTEN;
                txtSoChungMinhNguoiKhoiKien.Text = nguyenDon.SOCMND;
                if (nguyenDon.GIOITINH == 0)
                {
                    txtGioiTinhNguoiKhoiKien.Text = "Nữ";
                }
                else if(nguyenDon.GIOITINH == 1)
                {
                    txtGioiTinhNguoiKhoiKien.Text = "Nam";
                }
                else
                {
                    txtGioiTinhNguoiKhoiKien.Text = "";
                }
                txtNamSinhNguoiKhoiKien.Text = nguyenDon.NAMSINH.ToString();
                if (nguyenDon.TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.TAMTRUTINHID).FirstOrDefault();
                    txtNoiCuTruNguoiKhoiKien.Text = tinhCuTruNguyenDon.TEN;
                }
                if (nguyenDon.TAMTRUID != null)
                {
                    DM_HANHCHINH huyenCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.TAMTRUID).FirstOrDefault();
                    txtQuanHuyenNguoiKhoiKien.Text = huyenCuTruNguyenDon.TEN;
                }
                txtDiaChiChiTietNguoiKhoiKien.Text = nguyenDon.TAMTRUCHITIET;
                txtEmail.Text = nguyenDon.EMAIL;
                txtDienThoai.Text = nguyenDon.DIENTHOAI;
                txtNoiDungKhoiKien.Text = dgn.NOIDUNGKHOIKIEN;
                if (dgn.LOAIAN != null && dgn.LOAIAN != 0)
                {
                    ddlLoaiAn.SelectedValue = dgn.LOAIAN.ToString();
                }
                else
                {
                    ddlLoaiAn.Items.Clear();
                }
                txtSoLuongDon.Text = dgn.SLDON.ToString();

                if (nguyenDon.NDD_TAMTRUHUYENID != null)
                {
                    DM_HANHCHINH huyenCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.NDD_TAMTRUHUYENID).FirstOrDefault();
                    txtND_NDD_Huyen.Text = huyenCuTruNguyenDon.TEN;
                }
                if (nguyenDon.NDD_TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.NDD_TAMTRUTINHID).FirstOrDefault();
                    txtND_NDD_Tinh.Text = tinhCuTruNguyenDon.TEN;
                }
                txtND_NDD_DCChiTiet.Text = nguyenDon.NDD_TAMTRUCHITIET;
                txtND_NDD_NguoiDaiDien.Text = nguyenDon.NDD_NGUOIDAIDIEN;
                txtND_NDD_ChucVu.Text = nguyenDon.NDD_CHUCVU;
                txtMaSoThueNKK.Text = nguyenDon.MASOTHUE;

                if (nguyenDon.LOAIDUONGSU == 1)
                {
                    pnNDCaNhan.Visible = true;
                    lblHoTenNKK.Text = "Họ tên:";
                }
                else if(nguyenDon.LOAIDUONGSU == 2)
                {
                    pnNDToChuc.Visible = true;
                    lblHoTenNKK.Text = "Tên cơ quan:";
                }
                else if(nguyenDon.LOAIDUONGSU == 3)
                {
                    pnNDToChuc.Visible = true;
                    lblHoTenNKK.Text = "Tên tổ chức:";
                }
            }

            DON_GUINHAN_DUONGSU biDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && x.TUCACHTOTUNG.Equals("BIDON")).FirstOrDefault();
            //Thông tin người bị kiện
            if(biDon != null)
            {
                ddlNguoiBiKien.SelectedValue = biDon.LOAIDUONGSU.ToString();
                txtHoTenNguoiBiKien.Text = biDon.HOTEN;
                txtSoChungMinhNguoiBiKien.Text = biDon.SOCMND;
                if (biDon.GIOITINH == 0)
                {
                    txtGioiTinhNguoiBiKien.Text = "Nữ";
                }
                else if(biDon.GIOITINH == 1)
                {
                    txtGioiTinhNguoiBiKien.Text = "Nam";
                }else
{
                    txtGioiTinhNguoiBiKien.Text = "";
                }
                txtNamSinhNguoiBiKien.Text = biDon.NAMSINH.ToString();
                if(biDon.TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruBiDon = dt.DM_HANHCHINH.Where(x => x.ID == biDon.TAMTRUTINHID).FirstOrDefault();
                    txtNoiCuTruNguoiBiKien.Text = tinhCuTruBiDon.TEN;
                }
                if(biDon.TAMTRUID != null)
                {
                    DM_HANHCHINH huyenCuTruBiDon = dt.DM_HANHCHINH.Where(x => x.ID == biDon.TAMTRUID).FirstOrDefault();
                    txtQuanHuyenNguoiBiKien.Text = huyenCuTruBiDon.TEN;
                }                
                txtDiaChiChiTietNguoiBiKien.Text = biDon.TAMTRUCHITIET;

                if (biDon.NDD_TAMTRUHUYENID != null)
                {
                    DM_HANHCHINH huyenCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == biDon.NDD_TAMTRUHUYENID).FirstOrDefault();
                    txtBD_NDD_Huyen.Text = huyenCuTruNguyenDon.TEN;
                }
                if (biDon.NDD_TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == biDon.NDD_TAMTRUTINHID).FirstOrDefault();
                    txtBD_NDD_Tinh.Text = tinhCuTruNguyenDon.TEN;
                }
                txtBD_NDD_DCChiTiet.Text = biDon.NDD_TAMTRUCHITIET;
                txtBD_NDD_NguoiDaiDien.Text = biDon.NDD_NGUOIDAIDIEN;
                txtBD_NDD_ChucVu.Text = biDon.NDD_CHUCVU;
                txtMaSoThueNBK.Text = biDon.MASOTHUE;

                if (biDon.LOAIDUONGSU == 1)
                {
                    pnBDCaNhan.Visible = true;
                    lblHoTenNBK.Text = "Họ tên:";
                }
                else if(biDon.LOAIDUONGSU == 2)
                {
                    pnBDToChuc.Visible = true;
                    lblHoTenNBK.Text = "Tên cơ quan:";
                }
                else if (biDon.LOAIDUONGSU == 3)
                {
                    pnBDToChuc.Visible = true;
                    lblHoTenNBK.Text = "Tên tổ chức:";
                }
            }
        }

        //Add value drop down list
        private void AddNguonDen()
        {
            ddlNguonDen.Items.Insert(0, new ListItem("Bưu điện", "1"));
            ddlNguonDen.Items.Insert(1, new ListItem("Tiếp công dân", "2"));
            ddlNguonDen.Items.Insert(2, new ListItem("Trực tiếp", "3"));
        }
        private void AddLoaiVanBan()
        {
            ddlLoaiVanBan.Items.Insert(0, new ListItem("Đơn khởi kiện", "1"));
            ddlLoaiVanBan.Items.Insert(1, new ListItem("Đơn kháng cáo", "2"));
            ddlLoaiVanBan.Items.Insert(2, new ListItem("Đơn khác", "3"));
        }
        private void AddNguoiKhoiKien()
        {
            ddlNguoiKhoiKien.Items.Insert(0, new ListItem("Cá nhân", "1"));
            ddlNguoiKhoiKien.Items.Insert(1, new ListItem("Cơ quan", "2"));
            ddlNguoiKhoiKien.Items.Insert(2, new ListItem("Tổ chức", "3"));
        }
        private void AddNguoiBiKien()
        {
            ddlNguoiBiKien.Items.Insert(0, new ListItem("Cá nhân", "1"));
            ddlNguoiBiKien.Items.Insert(1, new ListItem("Cơ quan", "2"));
            ddlNguoiBiKien.Items.Insert(2, new ListItem("Tổ chức", "3"));
        }
        private void AddLoaiAn()
        {
            ddlLoaiAn.Items.Insert(0, new ListItem("Hình sự", "1"));
            ddlLoaiAn.Items.Insert(1, new ListItem("Dân sự", "2"));
            ddlLoaiAn.Items.Insert(2, new ListItem("Hôn nhân và gia đình", "3"));
            ddlLoaiAn.Items.Insert(3, new ListItem("Kinh doanh, thương mại", "4"));
            ddlLoaiAn.Items.Insert(4, new ListItem("Lao động", "5"));
            ddlLoaiAn.Items.Insert(5, new ListItem("Hành chính", "6"));
            ddlLoaiAn.Items.Insert(6, new ListItem("Phá sản", "7"));
        }
    }
}