using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.AHS;
using BL.GSTP.ALD;
using BL.GSTP.APS;
using BL.GSTP.DONCHOXULY;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.DONCHOXULY.Popup
{
    public partial class pGhepDonAHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonID = 0;
        private const decimal ROOT = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
                if (DonID > 0)
                {
                    AddLoaiAn();
                    LoadDropTinh();
                    LoadData();
                    LoadCombobox();

                    btnGhepDon.Visible = false;

                    //LoadGrid();
                }
                else
                {
                    Response.Redirect("/Login.aspx");
                }
            }
        }

        private void LoadData()
        {
            DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
            DON_GUINHAN dgn = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();
            ddlLoaiAn.SelectedValue = dgn.LOAIAN.ToString();

            //Thông tin vụ việc
            txtNgayNhan.Text = dgn.NGAYDAUBUUDIEN.HasValue ? dgn.NGAYDAUBUUDIEN.Value.ToString("dd/MM/yyyy") : "";
            txtQuanhephapluat.Text = dgn.QHPL;
            txtNDKK.Text = dgn.NOIDUNGKHOIKIEN;

            //Check loại đơn
            if (dgn.LOAIVANBAN == 2) // Đơn kháng cáo
            {
                pnDonKhac.Visible = false;
                pnDataKCKN.Visible = true;

                //Thông tin đơn kháng cáo
                txtNoiDungKC.Text = dgn.NOIDUNGKHANGCAO;
                txtSoQDBA.Text = dgn.SO_BAQD;
                txtNgayQDBA.Text = dgn.NGAY_BAQD.HasValue ? dgn.NGAY_BAQD.Value.ToString("dd/MM/yyyy") : "";

                //Load data drop down list toà án
                List<DM_TOAAN> lst = dt.DM_TOAAN.OrderBy(x => x.ARRTHUTU).ToList();
                ddlToaRaQDBA.DataSource = lst;
                ddlToaRaQDBA.DataTextField = "TEN";
                ddlToaRaQDBA.DataValueField = "ID";
                ddlToaRaQDBA.DataBind();
                ddlToaRaQDBA.SelectedValue = dgn.TOAAN_BAQD.ToString();

                //DDL loại đơn
                ddlLoaidon.Items.Clear();
                ddlLoaidon.Items.Insert(0, new ListItem("Đơn kháng cáo", "7"));

                //Load data list check box yêu cầu kháng cáo
                DM_DATAITEM_BL dtItemBL = new DM_DATAITEM_BL();
                DataTable tbl = dtItemBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.YEUCAUKCHINHSU);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    chkYeuCauKC.DataSource = tbl;
                    chkYeuCauKC.DataTextField = "TEN";
                    chkYeuCauKC.DataValueField = "ID";
                    chkYeuCauKC.DataBind();
                }

                //Tên người kháng cáo
                DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == dgn.ID && x.NGUOIKHANGCAO == 1).FirstOrDefault();
                if(nguoiKhangCao != null)
                {
                    ddlTenNguoiKC.Items.Insert(0, new ListItem(nguoiKhangCao.HOTEN, nguoiKhangCao.ID.ToString()));
                }
            }
            else //Đơn khác
            {
                pnDonKhangCao.Visible = false;
                pnDataKCKN.Visible = false;

                //Thông tin đơn khác
                List<DM_DATAITEM> listTT = dt.DM_DATAITEM.Where(x => x.GROUPID == 25)
                    .OrderBy(x => x.TEN)
                    .ToList();
                ddlDK_TCTT.DataSource = listTT;
                ddlDK_TCTT.DataTextField = "TEN";
                ddlDK_TCTT.DataValueField = "ID";
                ddlDK_TCTT.DataBind();
                ddlDK_TCTT.Items.Insert(0, new ListItem("--Chọn--", "0"));
                ddlDK_TCTT.Items.Insert(1, new ListItem("Bị can, bị cáo", "1"));

                //DDL loại đơn
                ddlLoaidon.Items.Clear();
                ddlLoaidon.Items.Insert(0, new ListItem("Đơn khác", "8"));

                DON_GUINHAN_DUONGSU nguoiDungDon = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == dgn.ID && x.NGUOIKHANGCAO == 2).FirstOrDefault();
                if(nguoiDungDon != null)
                {
                    ddlDK_NguoiDungDon.SelectedValue = nguoiDungDon.LOAIDUONGSU.ToString();
                    txtDK_HoTen.Text = nguoiDungDon.HOTEN;
                    txtDK_SoCMND.Text = nguoiDungDon.SOCMND;
                    txtDK_NamSinh.Text = nguoiDungDon.NAMSINH.ToString();
                    
                    if(nguoiDungDon.GIOITINH.ToString() == "0")
                    {
                        ddlDK_GioiTinh.SelectedValue = "0";
                    }
                    else if(nguoiDungDon.GIOITINH.ToString() == "1")
                    {
                        ddlDK_GioiTinh.SelectedValue = "1";
                    }
                    else
                    {
                        ddlDK_GioiTinh.SelectedValue = "99";
                    }

                    if (nguoiDungDon.TAMTRUTINHID != null)
                    {
                        ddlDK_TamTru_Tinh.SelectedValue = nguoiDungDon.TAMTRUTINHID.ToString();
                        LoadDropTamTru_Huyen();
                        if (nguoiDungDon.TAMTRUID != null)
                        {
                            ddlDK_TamTru_Huyen.SelectedValue = nguoiDungDon.TAMTRUID.ToString();
                        }
                    }
                    txtDK_DiaChiChiTiet.Text = nguoiDungDon.TAMTRUCHITIET;
                    txtDK_Email.Text = nguoiDungDon.EMAIL;
                    txtDK_DienThoai.Text = nguoiDungDon.DIENTHOAI;
                    if (nguoiDungDon.MASOTHUE != null)
                    {
                        txtDK_MaSoThue.Text = nguoiDungDon.MASOTHUE;
                    }
                    if (nguoiDungDon.NDD_TAMTRUTINHID != null)
                    {
                        ddlDK_NDD_Tinh.SelectedValue = nguoiDungDon.NDD_TAMTRUTINHID.ToString();
                        LoadDropNDD_Huyen();
                        if (nguoiDungDon.NDD_TAMTRUHUYENID != null)
                        {
                            ddlDK_NDD_Huyen.SelectedValue = nguoiDungDon.NDD_TAMTRUHUYENID.ToString();
                        }
                    }
                    txtDK_NDD_DiaChiChiTiet.Text = nguoiDungDon.NDD_TAMTRUCHITIET;
                    txtDK_NguoiDaiDien.Text = nguoiDungDon.NDD_NGUOIDAIDIEN;
                    txtDK_ChucVu.Text = nguoiDungDon.NDD_CHUCVU;
                }
            }
        }

        private void LoadGrid()
        {
            DON_CHO_XU_LY_BL obj = new DON_CHO_XU_LY_BL();
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            DataTable tbl = obj.Get_Don_ChoXuLy_GhepDon_AHS(Session["CAP_XET_XU"] + "", Session[ENUM_SESSION.SESSION_DONVIID] + "", txtTenVuViec.Text.Trim(), txtMaVuViec.Text.Trim(), txtBiCanBiCao.Text.Trim(), txtSoCMND.Text.Trim(), txtNamSinh.Text.Trim(), txtSoThuLy.Text.Trim(), txtNgayThuLyTu.Text.Trim(), txtNgayThuLyDen.Text.Trim(), txtDon_SoBAQD.Text.Trim(), txtDon_NgayBAQDTu.Text.Trim(), txtDon_NgayBAQDDen.Text.Trim(), pageindex, page_size);
            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = page_size;
            dgList.DataSource = tbl;
            dgList.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "hideLoading", "hideLoading();", true);
        }

        private void LoadCombobox()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            ddlCanbonhandon.Items.Clear();

            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlCanbonhandon.DataSource = oCBDT;
            ddlCanbonhandon.DataTextField = "MA_TEN";
            ddlCanbonhandon.DataValueField = "ID";
            ddlCanbonhandon.DataBind();
            //Set mặc định cán bộ login
            try
            {
                string strCBID = Session[ENUM_SESSION.SESSION_CANBOID] + "";
                if (strCBID != "") ddlCanbonhandon.SelectedValue = strCBID;
            }
            catch { }
            ddlThamphankynhandon.Items.Clear();
            ddlThamphankynhandon.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphankynhandon.DataTextField = "MA_TEN";
            ddlThamphankynhandon.DataValueField = "ID";
            ddlThamphankynhandon.DataBind();
            ddlThamphankynhandon.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
            //Load Quan hệ pháp luật
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            ddlQuanhephapluat.Items.Clear();
            ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBY2GROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAU, ENUM_DANHMUC.QUANHEPL_TRANHCHAP);
            ddlQuanhephapluat.DataTextField = "TEN";
            ddlQuanhephapluat.DataValueField = "ID";
            ddlQuanhephapluat.DataBind();

            //Load QHPL Thống kê.
            ddlQHPLTK.Items.Clear();
            ddlQHPLTK.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.DANSU && x.ENABLE == 1).OrderBy(y => y.ARRTHUTU).ToList();
            ddlQHPLTK.DataTextField = "CASE_NAME";
            ddlQHPLTK.DataValueField = "ID";
            ddlQHPLTK.DataBind();
            ddlQHPLTK.Items.Insert(0, new ListItem("--Chọn QHPL dùng thống kê--", "0"));
        }

        private bool CheckValidDonKhac()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            //Check phần thông tin đơn khác
            if (ddlDK_TCTT.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn tư cách tham gia tố tụng.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlDK_TCTT.ClientID);
                return false;
            }
            if (txtDK_HoTen.Text == "")
            {
                lstMsgB.Text = "Bạn chưa họ tên người đứng đơn.";
                txtDK_HoTen.Focus();
                return false;
            }
            if (txtDK_NamSinh.Text != "")
            {
                if (txtDK_NamSinh.Text.Trim().Length < 4)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn phải là số gồm 04 chữ số. Hãy kiểm tra lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
                int namsinh = Convert.ToInt32(txtDK_NamSinh.Text);
                if (namsinh == 0)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn phải lớn hơn 0. Hãy kiểm tra lại.";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
                else if (namsinh > dNgayNhan.Year)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn không thể lớn hơn năm của ngày nhận đơn. Hãy kiểm tra lại!";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
                else if (namsinh > DateTime.Now.Year)
                {
                    lstMsgB.Text = "Năm sinh của người đứng đơn không thể lớn hơn năm hiện tại. Hãy kiểm tra lại!";
                    Cls_Comon.SetFocus(this, this.GetType(), txtDK_NamSinh.ClientID);
                    return false;
                }
            }
            if (!chkDK_CMNDND.Checked)
            {
                if (string.IsNullOrEmpty(txtDK_SoCMND.Text))
                {
                    lstMsgB.Text = "Bạn chưa nhập Số CMND.";
                    txtDK_SoCMND.Focus();
                    return false;
                }
            }
            return true;
        }

        private bool CheckValidKhangCao()
        {
            if (txtQuanhephapluat.Text == null || txtQuanhephapluat.Text == "")
            {
                lstMsgB.Text = "Chưa nhập quan hệ pháp luật.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtQuanhephapluat.Text.Trim().Length >= 500)
            {
                lstMsgB.Text = "Quan hệ pháp luật nhập quá dài.";
                txtQuanhephapluat.Focus();
                return false;
            }
            if (txtNgayNhan.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày nhận đơn.";
                txtNgayNhan.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayNhan.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày nhận đơn theo định dạng dd/MM/yyyy.";
                txtNgayNhan.Focus();
                return false;
            }
            DateTime dNgayNhan = DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateTime.Now)
            {
                lstMsgB.Text = "Ngày nhận đơn không được lớn hơn ngày hiện tại.";
                txtNgayNhan.Focus();
                return false;
            }
            if (ddlQHPLTK.SelectedIndex == 0)
            {
                lstMsgB.Text = "Bạn chưa chọn quan hệ pháp luật dùng thống kê.";
                Cls_Comon.SetFocus(this, this.GetType(), ddlQHPLTK.ClientID);
                return false;
            }
            //Check phần thông tin đơn kháng cáo
            if (txtSoQDBA.Text == "")
            {
                lstMsgB.Text = "Chưa nhập số Quyết định/Bản án.";
                txtSoQDBA.Focus();
                return false;
            }
            if (ddlTenNguoiKC.Items.Count < 0 || ddlTenNguoiKC.SelectedValue == "0")
            {
                lstMsgB.Text = "Chưa chọn tên người kháng cáo.";
                ddlTenNguoiKC.Focus();
                return false;
            }
            if (txtNgayKC.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập ngày kháng cáo.";
                txtNgayKC.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtNgayKC.Text) == false)
            {
                lstMsgB.Text = "Bạn phải nhập ngày kháng cáo theo định dạng dd/MM/yyyy.";
                txtNgayKC.Focus();
                return false;
            }
            DateTime dNgayKC = DateTime.Parse(this.txtNgayKC.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayKC > DateTime.Now)
            {
                lstMsgB.Text = "Ngày kháng cáo không được lớn hơn ngày hiện tại.";
                txtNgayKC.Focus();
                return false;
            }
            bool isSelected = false;
            foreach (ListItem item in chkYeuCauKC.Items)
            {
                if (item.Selected)
                {
                    isSelected = true;
                    break;
                }
            }
            if (!isSelected)
            {
                lstMsgB.Text = "Bạn chưa chọn yêu cầu kháng cáo!";
                return false;
            }

            return true;
        }

        private bool SaveDataGhepDonKhac()
        {
            try
            {
                if (!CheckValidDonKhac()) return false;

                if (hddID_DON.Text == "")
                {
                    lstMsgB.Text = "Chưa ghép đơn! Không thể Lưu";
                    return false;
                }
                else
                {
                    //Thêm thông tin dương sự
                    if (ddlDK_TCTT.SelectedValue == "1") //AHS_BICANBICAO
                    {
                        AHS_BICANBICAO ahs = new AHS_BICANBICAO();
                        ahs.VUANID = Convert.ToDecimal(hddID_DON.Text);
                        ahs.BICANDAUVU = 0;
                        ahs.HOTEN = txtDK_HoTen.Text;
                        if(txtDK_NgaySinh.Text.Trim() != "")
                        {
                            ahs.NGAYSINH = Convert.ToDateTime(txtDK_NgaySinh.Text);
                        }
                        ahs.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                        ahs.SOCMND = txtDK_SoCMND.Text;
                        ahs.TAMTRU = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                        ahs.TAMTRU_HUYEN = Convert.ToDecimal(ddlDK_TamTru_Huyen.SelectedValue);
                        ahs.TAMTRUCHITIET = txtDK_DiaChiChiTiet.Text;
                        ahs.QUOCTICHID = 2;
                        ahs.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                        ahs.NGAYTAO = DateTime.Now;
                        ahs.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        ahs.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.AHS_BICANBICAO.Add(ahs);
                        dt.SaveChanges();

                        //Thêm thông tin vụ việc vào bảng DON_KHAC
                        DON_KHAC dk = new DON_KHAC();

                        dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                        dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                        dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                        dk.LOAIDON = 8;
                        dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                        if (dk.NGAYVIETDON.ToString() != "")
                        {
                            dk.NGAYVIETDON = Convert.ToDateTime(txtNgayViet.Text.Trim());
                        }
                        if (dk.NGAYNHANDON.ToString() != "")
                        {
                            dk.NGAYNHANDON = Convert.ToDateTime(txtNgayNhan.Text.Trim());
                        }
                        dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                        dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                        dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                        dk.DUONGSUID = ahs.ID;
                        dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                        dk.ISDUONGSU = 1;

                        dt.DON_KHAC.Add(dk);
                        dt.SaveChanges();
                    }
                    else //AHS_NGUOITHAMGIATOTUNG
                    {
                        AHS_NGUOITHAMGIATOTUNG tgtt = new AHS_NGUOITHAMGIATOTUNG();
                        tgtt.VUANID = Convert.ToDecimal(hddID_DON.Text);
                        tgtt.HOTEN = txtDK_HoTen.Text;
                        if (txtDK_NgaySinh.Text.Trim() != "")
                        {
                            tgtt.NGAYSINH = Convert.ToDateTime(txtDK_NgaySinh.Text);
                        }
                        tgtt.NAMSINH = Convert.ToDecimal(txtDK_NamSinh.Text);
                        tgtt.NDD_CMND = txtDK_SoCMND.Text;
                        tgtt.DIACHIID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
                        tgtt.DIACHICHITIET = txtDK_DiaChiChiTiet.Text;
                        tgtt.GIOITINH = Convert.ToDecimal(ddlDK_GioiTinh.SelectedValue);
                        tgtt.NDD_HOTEN = txtDK_NguoiDaiDien.Text;
                        tgtt.NDD_CHUCVU = txtDK_ChucVu.Text;
                        tgtt.NDD_EMAIL = txtDK_Email.Text;
                        tgtt.NDD_MOBILE = txtDK_DienThoai.Text;
                        tgtt.NGAYSUA = DateTime.Now;
                        tgtt.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        // insert toa_gq_id
                        tgtt.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.AHS_NGUOITHAMGIATOTUNG.Add(tgtt);
                        dt.SaveChanges();

                        //AHS_NGUOITHAMGIATOTUNG_TUCACH
                        AHS_NGUOITHAMGIATOTUNG_TUCACH tgtt_tc = new AHS_NGUOITHAMGIATOTUNG_TUCACH();
                        tgtt_tc.NGUOIID = tgtt.ID;
                        tgtt_tc.TUCACHID = Convert.ToDecimal(ddlDK_TCTT.SelectedValue);

                        dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Add(tgtt_tc);
                        dt.SaveChanges();

                        //Thêm thông tin vụ việc vào bảng DON_KHAC
                        DON_KHAC dk = new DON_KHAC();

                        dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                        dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                        dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                        dk.LOAIDON = 8;
                        dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                        if (dk.NGAYVIETDON.ToString() != "")
                        {
                            dk.NGAYVIETDON = Convert.ToDateTime(txtNgayViet.Text.Trim());
                        }
                        if (dk.NGAYNHANDON.ToString() != "")
                        {
                            dk.NGAYNHANDON = Convert.ToDateTime(txtNgayNhan.Text.Trim());
                        }
                        dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                        dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                        dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                        dk.DUONGSUID = tgtt.ID;
                        dk.NOIDUNGDON = txtDK_NoiDungDon.Text;
                        dk.ISDUONGSU = 0;

                        dt.DON_KHAC.Add(dk);
                        dt.SaveChanges();
                    }
                }
                lstMsgB.Text = "";
                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }

        private bool SaveDataGhepDonKhangCao()
        {
            try
            {
                if (!CheckValidKhangCao()) return false;

                if (hddID_DON.Text == "")
                {
                    lstMsgB.Text = "Chưa ghép đơn! Không thể Lưu";
                    return false;
                }
                else
                {
                    //Thêm thông tin vụ việc vào bảng DON_KHAC
                    DON_KHAC dk = new DON_KHAC();

                    dk.DONID = Convert.ToDecimal(hddID_DON.Text);
                    dk.LOAIANID = Convert.ToDecimal(ddlLoaiAn.SelectedValue);
                    dk.TOAANID = Convert.ToDecimal(hddID_TOAAN.Text);
                    dk.LOAIDON = 7;
                    dk.HINHTHUCNHAN = Convert.ToDecimal(ddlHinhthucnhandon.SelectedValue);
                    if (dk.NGAYVIETDON.ToString() != "")
                    {
                        dk.NGAYVIETDON = Convert.ToDateTime(txtNgayViet.Text.Trim());
                    }
                    if (dk.NGAYNHANDON.ToString() != "")
                    {
                        dk.NGAYNHANDON = Convert.ToDateTime(txtNgayNhan.Text.Trim());
                    }
                    dk.CANBONHANDONID = Convert.ToDecimal(ddlCanbonhandon.SelectedValue);
                    dk.THAMPHANKYNHANDON = Convert.ToDecimal(ddlThamphankynhandon.SelectedValue);
                    dk.NOIDUNGKHOIKIEN = txtNDKK.Text;
                    dk.DUONGSUID = Convert.ToDecimal(ddlTenNguoiKC.SelectedValue);
                    dk.NOIDUNGDON = txtNoiDungKC.Text;
                    if(rdbLoaiNguoiKC.SelectedValue == "0")
                    {
                        dk.ISDUONGSU = 1;
                    }
                    else
                    {
                        dk.ISDUONGSU = 0;
                    }
                    dk.NGAYKHANGCAO = Convert.ToDateTime(txtNgayKC.Text.Trim());
                    dk.LOAIKHANGCAO = Convert.ToDecimal(rdLoaiKC.SelectedValue);
                    dk.SOQDBA = txtSoQDBA.Text;
                    dk.ISQUAHAN = Convert.ToDecimal(rdNgayKCQuaHan.SelectedValue);
                    if (txtNgayQDBA.Text.Trim() != "")
                    {
                        dk.NGAYQDBA = Convert.ToDateTime(txtNgayQDBA.Text);
                    }
                    dk.TOAANRAQDID = Convert.ToDecimal(ddlToaRaQDBA.SelectedValue);

                    dt.DON_KHAC.Add(dk);
                    dt.SaveChanges();

                    if (hddFilePath_KC.Value != "")
                    {
                        DON_KHAC_FILE oKCFile = new DON_KHAC_FILE();
                        string strFilePath = hddFilePath_KC.Value.Replace("/", "\\");
                        byte[] buff = null;
                        using (FileStream fs = File.OpenRead(strFilePath))
                        {
                            BinaryReader br = new BinaryReader(fs);
                            FileInfo oF = new FileInfo(strFilePath);
                            long numBytes = oF.Length;
                            buff = br.ReadBytes((int)numBytes);
                            oKCFile.NOIDUNGFILE = buff;
                            oKCFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                            oKCFile.KIEUFILE = oF.Extension;
                            oKCFile.DONKHAC_ID = dk.ID;

                            dt.DON_KHAC_FILE.Add(oKCFile);
                            dt.SaveChanges();
                        }
                    }

                    //Thêm danh sách yêu cầu KC
                    foreach (ListItem item in chkYeuCauKC.Items)
                    {
                        if (item.Selected)
                        {
                            DON_KHAC_YEUCAU obj = new DON_KHAC_YEUCAU();
                            obj.DONKHACID = Convert.ToInt32(dk.ID);
                            obj.YEUCAUID = Convert.ToInt32(item.Value);
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            obj.NGAYTAO = DateTime.Now;
                            dt.DON_KHAC_YEUCAU.Add(obj);
                            dt.SaveChanges();
                        }
                    }
                }
                lstMsgB.Text = "";
                return true;
            }
            catch (Exception ex)
            {
                lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
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

        private void LoadListBiCan(decimal VuAnID)
        {
            ddlTenNguoiKC.Items.Clear();
            AHS_BICANBICAO_BL oBL = new AHS_BICANBICAO_BL();
            ddlTenNguoiKC.DataSource = oBL.AHS_BICANBICAO_GetListByVuAn(VuAnID);
            ddlTenNguoiKC.DataTextField = "ArrBiCao";
            ddlTenNguoiKC.DataValueField = "ID";
            ddlTenNguoiKC.DataBind();
        }

        private void LoadListNguoiBiKhangCao(decimal VuAnID)
        {
            lbNguoiBiKC.Items.Clear();
            List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).OrderBy(x => x.HOTEN).ToList<AHS_BICANBICAO>();
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);
            if (listBiCan != null && loai == 1)
            {
                int count_item = listBiCan.Count;
                if (count_item > 0)
                {
                    lbNguoiBiKC.DataSource = listBiCan;
                    lbNguoiBiKC.DataTextField = "HOTEN";
                    lbNguoiBiKC.DataValueField = "ID";
                    lbNguoiBiKC.DataBind();
                }
            }
            else
                lbNguoiBiKC.Items.Add(new ListItem("--- Chọn ---", "0"));
        }

        private void LoadListNguoiThamGiaToTung(decimal VuAnID)
        {
            ddlTenNguoiKC.Items.Clear();
            List<AHS_NGUOITHAMGIATOTUNG> lst = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == VuAnID).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_NGUOITHAMGIATOTUNG item in lst)
                    ddlTenNguoiKC.Items.Add(new ListItem(item.HOTEN, item.ID.ToString()));
            }
        }

        #region "Set giá trị tỉnh huyện mặc định
        private void LoadDropTinh()
        {
            List<DM_HANHCHINH> lstTinh = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == ROOT).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstTinh != null && lstTinh.Count > 0)
            {
                ddlDK_NDD_Tinh.DataSource = lstTinh;
                ddlDK_NDD_Tinh.DataTextField = "TEN";
                ddlDK_NDD_Tinh.DataValueField = "ID";
                ddlDK_NDD_Tinh.DataBind();

                ddlDK_TamTru_Tinh.DataSource = lstTinh;
                ddlDK_TamTru_Tinh.DataTextField = "TEN";
                ddlDK_TamTru_Tinh.DataValueField = "ID";
                ddlDK_TamTru_Tinh.DataBind();
            }

            ddlDK_NDD_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));
            ddlDK_TamTru_Tinh.Items.Insert(0, new ListItem("---Chọn---", "0"));

            LoadDropNDD_Huyen();
            LoadDropTamTru_Huyen();
        }
        private void LoadDropNDD_Huyen()
        {
            ddlDK_NDD_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlDK_NDD_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlDK_NDD_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlDK_NDD_Huyen.DataSource = lstHuyen;
                ddlDK_NDD_Huyen.DataTextField = "TEN";
                ddlDK_NDD_Huyen.DataValueField = "ID";
                ddlDK_NDD_Huyen.DataBind();
            }
            ddlDK_NDD_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LoadDropTamTru_Huyen()
        {
            ddlDK_TamTru_Huyen.Items.Clear();
            decimal TinhID = Convert.ToDecimal(ddlDK_TamTru_Tinh.SelectedValue);
            if (TinhID == 0)
            {
                ddlDK_TamTru_Huyen.Items.Add(new ListItem("---Chọn---", "0"));
                return;
            }
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null && lstHuyen.Count > 0)
            {
                ddlDK_TamTru_Huyen.DataSource = lstHuyen;
                ddlDK_TamTru_Huyen.DataTextField = "TEN";
                ddlDK_TamTru_Huyen.DataValueField = "ID";
                ddlDK_TamTru_Huyen.DataBind();
            }
            ddlDK_TamTru_Huyen.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        #endregion

        //EVENT
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        #endregion

        protected void AsyncFileUpLoadKhangCao_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            if (AsyncFileUpLoadKhangCao.HasFile)
            {
                string strFileName = AsyncFileUpLoadKhangCao.FileName;
                string path = Server.MapPath("~/TempUpload/") + strFileName;
                AsyncFileUpLoadKhangCao.SaveAs(path);

                path = path.Replace("\\", "/");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath_KC.ClientID + "\").value = '" + path + "';", true);
            }
        }
        
        protected void ddlDK_TamTru_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropTamTru_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlDK_TamTru_Huyen.ClientID);
            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }
        
        protected void ddlDK_NDD_Tinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropNDD_Huyen();
                Cls_Comon.SetFocus(this, this.GetType(), ddlDK_NDD_Huyen.ClientID);

            }
            catch (Exception ex) { lstMsgB.Text = ex.Message; }
        }

        protected void ddlDK_NguoiDungDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlDK_NguoiDungDon.SelectedValue == "1")
            {
                pnDK_CaNhan.Visible = true;
                pnDK_ToChuc.Visible = false;
            }
            else
            {
                pnDK_CaNhan.Visible = false;
                pnDK_ToChuc.Visible = true;
            }
        }

        protected void GhepDon_Click(object sender, EventArgs e)
        {
            btnGhepDon.Enabled = true;
            btnGhepDon.CssClass = "disable_btn";

            int count = 0;

            decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            DON_GUINHAN checkLA = dt.DON_GUINHAN.Where(x => x.ID == ID_DGN).FirstOrDefault();

            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox checkGD = (CheckBox)item.FindControl("checkGhepDon");
                HiddenField IDVuViec = (HiddenField)item.FindControl("hddIdVuViec");
                decimal ID_DON = Convert.ToDecimal(IDVuViec.Value);

                if (checkGD.Checked)
                {
                    //Load thông tin vụ việc
                    AHS_VUAN ahs = dt.AHS_VUAN.Where(x => x.ID == ID_DON).FirstOrDefault();

                    hddID_DON.Text = ahs.ID.ToString();
                    hddID_TOAAN.Text = ahs.TOAANID.ToString();
                    hddGIAIDOAN.Text = ahs.MAGIAIDOAN.ToString();

                    btnLuu.Enabled = true;
                    btnLuu.CssClass = "buttoninput";

                    if (checkLA.LOAIVANBAN == 2)
                    {
                        //Load data grid thông tin kháng cáo
                        AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
                        DataTable oDT = oBL.AHS_SOTHAM_KCaoKNghi_GETLIST(ID_DON);
                        dgDataKCKN.DataSource = oDT;
                        dgDataKCKN.DataBind();

                        AHS_SOTHAM_BANAN banAn = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == ID_DON).FirstOrDefault();
                        DON_GUINHAN_DUONGSU nguoiKhangCao = dt.DON_GUINHAN_DUONGSU.Where(x => x.ID_DON == ID_DGN && x.NGUOIKHANGCAO == 1).FirstOrDefault();

                        List<AHS_BICANBICAO> listBiCan = dt.AHS_BICANBICAO.Where(x => x.VUANID == ID_DON).ToList();
                        bool checkBC = false;
                        foreach (var itemBC in listBiCan)
                        {
                            if(nguoiKhangCao != null)
                            {
                                if (itemBC.HOTEN.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkBC = true;
                                    break;
                                }
                            }
                        }

                        List<AHS_NGUOITHAMGIATOTUNG> listTGTT = dt.AHS_NGUOITHAMGIATOTUNG.Where(x => x.VUANID == ID_DON).ToList();
                        bool checkTGTT = false;
                        foreach (var itemTGTT in listTGTT)
                        {
                            if(nguoiKhangCao != null)
                            {
                                if (itemTGTT.HOTEN.Trim() == nguoiKhangCao.HOTEN.Trim())
                                {
                                    checkTGTT = true;
                                    break;
                                }
                            }
                        }

                        //Nếu như thông tin kháng cáo trùng với thông tin vụ án
                        if(banAn != null)
                        {
                            if (banAn.SOBANAN == txtSoQDBA.Text && banAn.NGAYBANAN.Value.ToString("dd/MM/yyyy").Trim() == txtNgayQDBA.Text)
                            {
                                if (checkBC || checkTGTT)
                                {
                                    LoadListBiCan(ID_DON);
                                    LoadListNguoiBiKhangCao(ID_DON);
                                    LoadListNguoiThamGiaToTung(ID_DON);

                                    btnLuu.Enabled = true;
                                    btnLuu.CssClass = "buttoninput";

                                    rdbLoaiNguoiKC_SelectedIndexChanged(sender, e);
                                }
                            }
                            else
                            {
                                lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ án. Hãy chọn vụ án khác!";
                                btnLuu.Enabled = false;
                                btnLuu.CssClass = "disable_btn";
                                break;
                            }
                        }
                        else
                        {
                            lblMess.Text = "Thông tin kháng cáo không trùng khớp với thông tin vụ việc. Hãy chọn vụ việc khác!";
                            btnLuu.Enabled = false;
                            btnLuu.CssClass = "disable_btn";
                            break;
                        }
                    }

                    lblMess.Text = "";

                    count++;
                }
                if (count == 0)
                {
                    //Thông báo
                    lblMess.Text = "Bạn chưa chọn vụ án để ghép!";

                    btnLuu.Enabled = false;
                    btnLuu.CssClass = "disable_btn";
                }
            }
        }

        protected void Luu_Click(object sender, EventArgs e)
        {
            decimal ID_DGN = Convert.ToDecimal(Request.QueryString["ID"].ToString());
            DON_GUINHAN checkLA = dt.DON_GUINHAN.Where(x => x.ID == ID_DGN).FirstOrDefault();
            if(checkLA.TRANGTHAI != 5)
            {
                //Đơn kháng cáo
                if (checkLA.LOAIVANBAN == 2)
                {
                    if (SaveDataGhepDonKhangCao())
                    {
                        //Cập nhận trạng thái DON_GUINHAN
                        checkLA.TRANGTHAI = 3;
                        dt.SaveChanges();

                        DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                        ls.THAOTAC = 1;
                        ls.NGAYTAO = DateTime.Now;
                        ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        ls.ID_VBDH = checkLA.ID_VBDH;

                        dt.DON_GUINHAN_LICHSU.Add(ls);
                        dt.SaveChanges();

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lưu thông tin đơn thành công!');window.close(); window.opener.location.reload(); ", true);
                    }
                }
                //Đơn khác
                else if (checkLA.LOAIVANBAN == 3)
                {
                    if (SaveDataGhepDonKhac())
                    {
                        //Cập nhận trạng thái DON_GUINHAN
                        checkLA.TRANGTHAI = 3;
                        dt.SaveChanges();

                        DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                        ls.THAOTAC = 1;
                        ls.NGAYTAO = DateTime.Now;
                        ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        ls.ID_VBDH = checkLA.ID_VBDH;

                        dt.DON_GUINHAN_LICHSU.Add(ls);
                        dt.SaveChanges();

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Lưu thông tin đơn thành công!');window.close(); window.opener.location.reload(); ", true);
                    }
                }
            }
            else
            {
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đơn đã được thu hồi, không thể tiếp tục xử lý!')", true);
            }
        }

        protected void TimKiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadGrid();

            btnGhepDon.Visible = true;

            pnData.Visible = true;
        }

        protected void checkGhepDon_CheckedChanged(object sender, EventArgs e)
        {
            int count = 0;
            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox checkGD = (CheckBox)item.FindControl("checkGhepDon");
                HiddenField IDVuViec = (HiddenField)item.FindControl("hddIdVuViec");
                decimal ID_DON = Convert.ToDecimal(IDVuViec.Value);

                if (checkGD.Checked)
                {
                    count++;
                    if (count == 1)
                    {
                        checkGD.Checked = true;
                        lblMess.Text = "";
                    }
                    else
                    {
                        checkGD.Checked = false;
                        lblMess.Text = "Chỉ được chọn một vụ việc để ghép đơn!";
                        break;
                    }
                }
            }
        }

        protected void rdbLoaiNguoiKC_SelectedIndexChanged(object sender, EventArgs e)
        {
            int loai = Convert.ToInt16(rdbLoaiNguoiKC.SelectedValue);

            if (hddID_DON.Text.Trim() != "")
            {
                decimal ID_VUAN = Convert.ToDecimal(hddID_DON.Text.Trim());
                switch (loai)
                {
                    case 0:
                        LoadListBiCan(ID_VUAN);
                        lbNguoiBiKC.Visible = false;
                        plNguoiBiKC.Visible = false;
                        break;
                    case 1:
                        LoadListNguoiThamGiaToTung(ID_VUAN);
                        LoadListNguoiBiKhangCao(ID_VUAN);
                        lbNguoiBiKC.Visible = true;
                        plNguoiBiKC.Visible = true;
                        break;
                }
            }
            else
            {
                switch (loai)
                {
                    case 0:
                        lbNguoiBiKC.Visible = false;
                        plNguoiBiKC.Visible = false;
                        break;
                    case 1:
                        lbNguoiBiKC.Visible = true;
                        plNguoiBiKC.Visible = true;
                        break;
                }
            }
        }
    }
}