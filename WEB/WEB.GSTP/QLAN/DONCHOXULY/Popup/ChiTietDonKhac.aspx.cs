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
    public partial class ChiTietDonKhac : System.Web.UI.Page
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
                    AddGiaiDoan();
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
            lblHoTen.Text = "Họ tên:";

            DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();
            //Thông tin bì thư
            ddlNguonDen.SelectedValue = dgn.NGUONDEN.ToString();
            if (dgn.DV_NHAN != null && dgn.DV_NHAN != 0)
            {
                DM_PHONGBAN donViNhan = dt.DM_PHONGBAN.Where(x => x.ID == dgn.DV_NHAN).FirstOrDefault();
                if (donViNhan != null)
                {
                    txtDonViNhan.Text = donViNhan.TENPHONGBAN;
                }
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
            if(dgn.DCGUI != null && dgn.DCGUI != 0)
            {
                DM_HANHCHINH diaChiGui = dt.DM_HANHCHINH.Where(x => x.ID == dgn.DCGUI).FirstOrDefault();
                txtDiaChiGui.Text = diaChiGui.MA_TEN;
            }           
            txtDiaChiGuiChiTiet.Text = dgn.DCGUI_CHITIET;
            txtGhiChu.Text = dgn.GHICHU;

            DON_GUINHAN_DUONGSU nguyenDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && x.NGUOIKHANGCAO == 2).FirstOrDefault();
            DON_GUINHAN_DUONGSU nguoiKhoiKien = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && (x.TUCACHTOTUNG == "NGUYENDON" || x.TUCACHTOTUNG == "TGTTHS_01")).FirstOrDefault();
            //Thông tin đơn
            if(nguyenDon != null)
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
                if(nguyenDon.TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.TAMTRUTINHID).FirstOrDefault();
                    txtNoiCuTruNguoiKhoiKien.Text = tinhCuTruNguyenDon.TEN;
                }
                if(nguyenDon.TAMTRUID != null)
                {
                    DM_HANHCHINH huyenCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.TAMTRUID).FirstOrDefault();
                    txtQuanHuyenNguoiKhoiKien.Text = huyenCuTruNguyenDon.TEN;
                }                
                txtDiaChiChiTietNguoiKhoiKien.Text = nguyenDon.TAMTRUCHITIET;
                txtEmail.Text = nguyenDon.EMAIL;
                txtDienThoai.Text = nguyenDon.DIENTHOAI;
                txtNoiDungKhoiKien.Text = dgn.NOIDUNGKHANGCAO;
                txtSoLuongDon.Text = dgn.SLDON.ToString();
                if(nguoiKhoiKien != null)
                {
                    txtNguoiKhoiKien.Text = nguoiKhoiKien.HOTEN;
                }

                if (nguyenDon.NDD_TAMTRUHUYENID != null)
                {
                    DM_HANHCHINH huyenCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.NDD_TAMTRUHUYENID).FirstOrDefault();
                    txtNDD_Huyen.Text = huyenCuTruNguyenDon.TEN;
                }
                if (nguyenDon.NDD_TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguyenDon.NDD_TAMTRUTINHID).FirstOrDefault();
                    txtNDD_Tinh.Text = tinhCuTruNguyenDon.TEN;
                }
                txtNDD_DCChiTiet.Text = nguyenDon.NDD_TAMTRUCHITIET;
                txtNDD_NguoiDaiDien.Text = nguyenDon.NDD_NGUOIDAIDIEN;
                txtNDD_ChucVu.Text = nguyenDon.NDD_CHUCVU;
                if (nguyenDon.MASOTHUE != "0" && nguyenDon != null)
                {
                    txtMaSoThue.Text = nguyenDon.MASOTHUE;
                }

                if (nguyenDon.LOAIDUONGSU == 1)
                {
                    pnCaNhan.Visible = true;
                    lblHoTen.Text = "Họ tên:";
                }
                else if(nguyenDon.LOAIDUONGSU == 2)
                {
                    pnToChuc.Visible = true;
                    lblHoTen.Text = "Tên cơ quan:";
                }
                else if (nguyenDon.LOAIDUONGSU == 3)
                {
                    pnToChuc.Visible = true;
                    lblHoTen.Text = "Tên tổ chức:";
                }
            }

            //Thông tin người vụ án
            if (dgn.LOAIAN != null && dgn.LOAIAN != 0)
            {
                ddlLoaiAn.SelectedValue = dgn.LOAIAN.ToString();
            }
            else
            {
                ddlLoaiAn.Items.Clear();
            }

            if(dgn.CAPXETXU.ToString() == "2")
            {
                ddlGiaiDoan.SelectedValue = "2";
            }
            else if (dgn.CAPXETXU.ToString() == "3")
            {
                ddlGiaiDoan.SelectedValue = "3";
            }
            else if (dgn.CAPXETXU.ToString() == "4")
            {
                ddlGiaiDoan.SelectedValue = "4";
            }
            else
            {
                ddlGiaiDoan.SelectedValue = "0";
            }

            txtSoThuLy.Text = dgn.SOTHULY;
            txtNgayThuLy.Text = dgn.NGAYTHULY.HasValue ? dgn.NGAYTHULY.Value.ToString("dd/MM/yyyy") : "";
            txtTenVuAn.Text = dgn.TENVUAN;
            DON_GUINHAN_DUONGSU biDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && (x.TUCACHTOTUNG.Equals("BIDON") || x.TUCACHTOTUNG.Equals("BICAO"))).FirstOrDefault();
            if (biDon != null)
            {
                txtNguoiBiKien.Text = biDon.HOTEN;
            }            
            txtQuanHePhapLuat.Text = dgn.QHPL;

            if (dgn.LOAIAN == 1)
            {
                DM_BOLUAT_TOIDANH toiDanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == dgn.TOIDANHID).FirstOrDefault();
                if (toiDanh != null)
                {
                    txtToiDanh.Text = toiDanh.TENTOIDANH;
                }
                pnToiDanh.Visible = true;
                lblNguyenDon.Text = "Bị hại:";
                lblBiDon.Text = "Bị cáo:";
            }
            else if (dgn.LOAIAN == 6)
            {
                pnQHPL.Visible = true;
                lblNguyenDon.Text = "Người khởi kiện:";
                lblBiDon.Text = "Người bị kiện:";
            }
            else
            {
                pnQHPL.Visible = true;
                lblNguyenDon.Text = "Nguyên đơn:";
                lblBiDon.Text = "Bị đơn:";
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
        private void AddGiaiDoan()
        {
            ddlGiaiDoan.Items.Insert(0, new ListItem("", "0"));
            ddlGiaiDoan.Items.Insert(1, new ListItem("Sơ thẩm", "2"));
            ddlGiaiDoan.Items.Insert(2, new ListItem("Phúc thẩm", "3"));
            ddlGiaiDoan.Items.Insert(3, new ListItem("Giám đốc thẩm, tái thẩm", "4"));
        }
    }
}