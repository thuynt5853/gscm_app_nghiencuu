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
    public partial class ChiTietKC : System.Web.UI.Page
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
                    AddLoaiAn();
                    AddCapXetXu();
                    AddNguoiKhangCao();
                    LoadData();
                }
                else
                {
                    Response.Redirect("/Login.aspx");
                }
            }
        }

        //Load thông tin đơn kháng cáo
        private void LoadData()
        {
            lblHoTen.Text = "Họ tên:";

            DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();
            //Thông tin bì thư
            ddlNguonDen.SelectedValue = dgn.NGUONDEN.ToString();
            if(dgn.DV_NHAN != null && dgn.DV_NHAN != 0)
            {
                DM_PHONGBAN donViNhan = dt.DM_PHONGBAN.Where(x => x.ID == dgn.DV_NHAN).FirstOrDefault();
                if(donViNhan != null)
                {
                    txtDonViNhan.Text = donViNhan.TENPHONGBAN;
                }
            }
            ddlLoaiVanBan.SelectedValue = dgn.LOAIVANBAN.ToString();
            DM_TOAAN donViGiaiQuyet = dt.DM_TOAAN.Where(x => x.ID == dgn.DV_GIAIQUYET).FirstOrDefault();
            if(donViGiaiQuyet != null)
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

            //Thông tin bản án/ quyết định
            if (dgn.LOAIAN != null && dgn.LOAIAN != 0)
            {
                ddlLoaiAn.SelectedValue = dgn.LOAIAN.ToString();
            }
            else
            {
                ddlLoaiAn.Items.Clear();
            }
            txtNgayBAQD.Text = dgn.NGAY_BAQD.HasValue ? dgn.NGAY_BAQD.Value.ToString("dd/MM/yyyy") : "";
            txtSoBAQD.Text = dgn.SO_BAQD;

            if (dgn.CAPXETXU.ToString() == "2")
            {
                ddlCapXetXu.SelectedValue = "2";
            }
            else if (dgn.CAPXETXU.ToString() == "3")
            {
                ddlCapXetXu.SelectedValue = "3";
            }
            else if (dgn.CAPXETXU.ToString() == "4")
            {
                ddlCapXetXu.SelectedValue = "4";
            }
            else
            {
                ddlCapXetXu.SelectedValue = "0";
            }

            if (dgn.TOAAN_BAQD != null)
            {
                DM_TOAAN toaAnBAQD = dt.DM_TOAAN.Where(x => x.ID == dgn.TOAAN_BAQD).FirstOrDefault();
                txtToaRaBAQD.Text = toaAnBAQD.TEN;
            }            
            txtTenVuAn.Text = dgn.TENVUAN;
            
            DON_GUINHAN_DUONGSU nguyenDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && (x.TUCACHTOTUNG.Equals("NGUYENDON") || x.TUCACHTOTUNG.Equals("TGTTHS_01"))).FirstOrDefault();
            if (nguyenDon != null)
            {
                txtNguyenDon.Text = nguyenDon.HOTEN;
            }
            DON_GUINHAN_DUONGSU biDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && (x.TUCACHTOTUNG.Equals("BIDON") || x.TUCACHTOTUNG.Equals("BICAO"))).FirstOrDefault();
            if (biDon != null)
            {
                txtBiDon.Text = biDon.HOTEN;
            }

            txtQuanHePhapLuat.Text = dgn.QHPL;

            //Thông tin đơn kháng cáo
            DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == DonID && x.NGUOIKHANGCAO == 1).FirstOrDefault();
            if(nguoiKhangCao != null)
            {
                ddlNguoiKhangCao.SelectedValue = nguoiKhangCao.LOAIDUONGSU.ToString();
                txtHoTenNguoiKhangCao.Text = nguoiKhangCao.HOTEN;
                txtSoChungMinhNguoiKhangCao.Text = nguoiKhangCao.SOCMND;

                DM_DATAITEM tuCachToTung = dt.DM_DATAITEM.Where(x => x.MA == nguoiKhangCao.TUCACHTOTUNG).FirstOrDefault();
                if(tuCachToTung != null)
                {
                    txtTCTT.Text = tuCachToTung.TEN;
                }

                if (nguoiKhangCao.GIOITINH == 0)
                {
                    txtGioiTinhNguoiKhangCao.Text = "Nữ";
                }
                else if(nguoiKhangCao.GIOITINH == 1)
                {
                    txtGioiTinhNguoiKhangCao.Text = "Nam";
                }
                else
                {
                    txtGioiTinhNguoiKhangCao.Text = "";
                }
                txtNamSinhNguoiKhangCao.Text = nguoiKhangCao.NAMSINH.ToString();
                if (nguoiKhangCao.TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTru = dt.DM_HANHCHINH.Where(x => x.ID == nguoiKhangCao.TAMTRUTINHID).FirstOrDefault();
                    txtNoiCuTruNguoiKhangCao.Text = tinhCuTru.TEN;
                }
                if (nguoiKhangCao.TAMTRUID != null)
                {
                    DM_HANHCHINH huyenCuTru = dt.DM_HANHCHINH.Where(x => x.ID == nguoiKhangCao.TAMTRUID).FirstOrDefault();
                    txtQuanHuyenNguoiKhangCao.Text = huyenCuTru.TEN;
                }
                txtDiaChiChiTietNguoiKhangCao.Text = nguoiKhangCao.TAMTRUCHITIET;
                txtEmail.Text = nguoiKhangCao.EMAIL;
                txtDienThoai.Text = nguoiKhangCao.DIENTHOAI;
                txtNoiDungKhangCao.Text = dgn.NOIDUNGKHANGCAO;
                txtSoLuongDon.Text = dgn.SLDON.ToString();

                if (nguoiKhangCao.NDD_TAMTRUHUYENID != null)
                {
                    DM_HANHCHINH huyenCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguoiKhangCao.NDD_TAMTRUHUYENID).FirstOrDefault();
                    txtNDD_Huyen.Text = huyenCuTruNguyenDon.TEN;
                }
                if (nguoiKhangCao.NDD_TAMTRUTINHID != null)
                {
                    DM_HANHCHINH tinhCuTruNguyenDon = dt.DM_HANHCHINH.Where(x => x.ID == nguoiKhangCao.NDD_TAMTRUTINHID).FirstOrDefault();
                    txtNDD_Tinh.Text = tinhCuTruNguyenDon.TEN;
                }
                txtNDD_DCChiTiet.Text = nguoiKhangCao.NDD_TAMTRUCHITIET;
                txtNDD_NguoiDaiDien.Text = nguoiKhangCao.NDD_NGUOIDAIDIEN;
                txtNDD_ChucVu.Text = nguoiKhangCao.NDD_CHUCVU;
                if (nguoiKhangCao.MASOTHUE != "0" && nguoiKhangCao != null)
                {
                    txtMaSoThue.Text = nguoiKhangCao.MASOTHUE;
                }

                if (nguoiKhangCao.LOAIDUONGSU == 1)
                {
                    pnCaNhan.Visible = true;
                    lblHoTen.Text = "Họ tên:";
                }
                else if(nguoiKhangCao.LOAIDUONGSU == 2)
                {
                    pnToChuc.Visible = true;
                    lblHoTen.Text = "Tên cơ quan:";
                }
                else if (nguoiKhangCao.LOAIDUONGSU == 3)
                {
                    pnToChuc.Visible = true;
                    lblHoTen.Text = "Tên tổ chức:";
                }
            }

            if(dgn.LOAIAN == 1)
            {
                DM_BOLUAT_TOIDANH toiDanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == dgn.TOIDANHID).FirstOrDefault();
                if(toiDanh != null)
                {
                    txtToiDanh.Text = toiDanh.TENTOIDANH;
                }
                pnToiDanh.Visible = true;
                lblNguyenDon.Text = "Bị hại:";
                lblBiDon.Text = "Bị cáo:";
            }
            else if(dgn.LOAIAN == 6)
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
        private void AddCapXetXu()
        {
            ddlCapXetXu.Items.Insert(0, new ListItem("", "0"));
            ddlCapXetXu.Items.Insert(1, new ListItem("Sơ thẩm", "2"));
            ddlCapXetXu.Items.Insert(2, new ListItem("Phúc thẩm", "3"));
            ddlCapXetXu.Items.Insert(3, new ListItem("Giám đốc thẩm, tái thẩm", "4"));
        }
        private void AddNguoiKhangCao()
        {
            ddlNguoiKhangCao.Items.Insert(0, new ListItem("Cá nhân", "1"));
            ddlNguoiKhangCao.Items.Insert(1, new ListItem("Cơ quan", "2"));
            ddlNguoiKhangCao.Items.Insert(2, new ListItem("Tổ chức", "3"));
        }
    }
}