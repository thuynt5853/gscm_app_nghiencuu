using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET.NHAPTACH_AN;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.AHN.Hoso.Popup
{
    public partial class pNhapAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonGocID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            DonGocID = Convert.ToDecimal(Request.QueryString["DonID"].ToString());
            if (!IsPostBack)
            {
                string strSearch = Session["textsearch"] + "";
                if (strSearch != "")
                {
                    txtTENDUONGSU.Text = strSearch;
                    Session["textsearch"] = "";
                }
                LoadDropToaAn();
                LoadCombobox();
                SetGetSessionTK(false);
                Load_VuAnGoc();
                Load_Data();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            }
        }

        private void Load_VuAnGoc()
        {
            AHN_DON_BL oBL = new AHN_DON_BL();

            AHN_DON donGoc = dt.AHN_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

            DataTable oDT = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donGoc.MAVUVIEC, "", "", donGoc.TOAANID.ToString(),
                                            "", "", "", "", "", "", "", "", "", "",
                                            "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 0, 1, 1);
            dgVuAnGoc.PageSize = 1;
            dgVuAnGoc.DataSource = oDT;
            dgVuAnGoc.DataBind();
        }

        private void SetGetSessionTK(bool isSet)
        {
            if (!isSet)
            {
                DropTINHTRANG_GIAIQUYET.SelectedValue = Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] + "";
                DropTHOIHAN_GQ.SelectedValue = Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] + "";
                dropCapxx.SelectedValue = Session[TK_CANHBAO.CAPXX] + "";
                DropTINHTRANG_THULY.SelectedValue = Session[TK_CANHBAO.TINHTRANG_THULY] + "";
                txtTuNgay.Text = Session[TK_CANHBAO.TUNGAY] + "";
                drop_BIENPHAPGQ.SelectedValue = Session[TK_CANHBAO.GQDON] + "";
            }
        }

        void ClearSession_TK()
        {
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
            Session[TK_CANHBAO.GQDON] = "";
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }

        protected void clear_form_search()
        {
            ClearSession_TK();
            txtTenVuViec.Text = string.Empty;
            txt_QHPL.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtTENDUONGSU.Text = string.Empty;
            dropCapxx.SelectedValue = string.Empty;
            DropTINHTRANG_THULY.SelectedValue = string.Empty;
            txt_NGAYTHULY_TU.Text = string.Empty;
            txt_NGAYTHULY_DEN.Text = string.Empty;
            txtSOTHULY.Text = string.Empty;
            DropTINHTRANG_GIAIQUYET.SelectedValue = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            Drop_KETQUA.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            txt_NgayQD.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;
            DropTHOIHAN_GQ.SelectedValue = string.Empty;
            drop_BIENPHAPGQ.SelectedValue = string.Empty;
            dropUTTP.SelectedValue = string.Empty;
            Drop_PT_RKINHNGHIEM.SelectedValue = string.Empty;
            Drop_Loaidon.SelectedValue = string.Empty;
        }

        private void LoadDropToaAn()
        {
            DropToaAn.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            DropToaAn.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", dropCapxx.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            DropToaAn.DataTextField = "arrTEN";
            DropToaAn.DataValueField = "ID";
            DropToaAn.DataBind();
            if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
            {
                DropToaAn.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            }

        }

        private void LoadCombobox()
        {
            //--------------------
            dropCapxx.Items.Clear();
            //edit by anhvh 21/02/2020
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------
            LoadDropThamphan();
            LoadDrop_TTV_TK();
        }

        void LoadDropThamphan()
        {
            Boolean IsLoadAll = true;
            ddlThamphan.Items.Clear();
            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            // Kiểm tra nếu user login là thẩm phán thì chỉ load 1 user
            // nếu là chánh án, phó chánh án hoặc khác thẩm phán thì load all
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault<DM_CANBO>();
            if (oCB != null)
            {
                // Kiểm tra chức danh có là thẩm phán hay không
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA.Contains("TP"))
                    {
                        ddlThamphan.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                        IsLoadAll = false;
                    }
                }
                // Kiểm tra chức vụ có là Chánh án hoặc phó chánh án hay không
                if (oCB.CHUCVUID != null && oCB.CHUCVUID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCVUID).FirstOrDefault();
                    if (oCD.MA.Contains("CA"))
                    {
                        IsLoadAll = true;
                    }
                }
            }
            if (IsLoadAll)
            {
                DM_CANBO_BL objBL = new DM_CANBO_BL();
                //decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal LoginDonViID = 0;
                if (DropToaAn.SelectedValue != "")
                {
                    LoginDonViID = Convert.ToDecimal(DropToaAn.SelectedValue);
                }
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }

        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAn();
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            // Load_Data();
        }

        protected void DropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDrop_TTV_TK();
            Load_Data();
        }

        protected void LoadDrop_TTV_TK()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (DropToaAn.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(DropToaAn.SelectedValue, null);
            ddlHTND_Thuky.DataSource = tbl;
            ddlHTND_Thuky.DataTextField = "MA_TEN";
            ddlHTND_Thuky.DataValueField = "ID";
            ddlHTND_Thuky.DataBind();
            ddlHTND_Thuky.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }

        private void Load_Data()
        {
            decimal vchecktk = 0;
            AHN_DON_BL oBL = new AHN_DON_BL();
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0,
                trangThaiVuAn = 0;
            DataTable oDT = oBL.DON_CON_SEARCH(DonGocID, Session["CAP_XET_XU"] + "", txtTenVuViec.Text.Trim(), txt_QHPL.Text.Trim(), txtMaVuViec.Text.Trim(), txtTENDUONGSU.Text.Trim(), dropCapxx.SelectedValue, DropToaAn.SelectedValue,
                                            DropTINHTRANG_THULY.SelectedValue, txtSOTHULY.Text.Trim(), txt_NGAYTHULY_TU.Text, txt_NGAYTHULY_DEN.Text, ddlThamphan.SelectedValue, DropTINHTRANG_GIAIQUYET.SelectedValue, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), Drop_KETQUA.SelectedValue, txtSoQD.Text.Trim(),
                                            txt_NgayQD.Text.Trim(), ddlHTND_Thuky.SelectedValue, DropTHOIHAN_GQ.SelectedValue, Drop_Loaidon.SelectedValue, Drop_PT_RKINHNGHIEM.SelectedValue, drop_BIENPHAPGQ.SelectedValue, dropUTTP.SelectedValue, vchecktk, trangThaiVuAn, pageindex, page_size);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
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
            dgList.DataSource = oDT;
            dgList.DataBind();
        }

        void PhanLoaiLai_DonKK(MenuPermission oPer, decimal IDVuViec)
        {
            String MaLoaiVuAn = ENUM_LOAIAN.AN_DANSU;
            DAL.DKK.DKKContextContainer dt = new DAL.DKK.DKKContextContainer();
            DAL.DKK.DONKK_DON obj = dt.DONKK_DON.Where(x => x.VUANID == IDVuViec
                                                         && x.MALOAIVUAN == MaLoaiVuAn).Single<DAL.DKK.DONKK_DON>();
            if (obj != null)
            {
                obj.VUANID = 0;
                obj.TRANGTHAI = 0;//da gui don nhung chua phan loai
                obj.MALOAIVUAN = MaLoaiVuAn;
                obj.NGAYSUA = DateTime.Now;
            }
            dt.SaveChanges();
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        private bool CheckValidQĐ()
        {

            if (Cls_Comon.IsValidDate(txtNgayquyetdinh.Text) == false)
            {
                lbthongbao.Text = "Chưa nhập ngày quyết định hoặc theo định dạng (dd/MM/yyyy)!";
                txtNgayquyetdinh.Focus();
                return false;
            }

            int lengthSQD = txtSoquyetdinh.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                txtSoquyetdinh.Focus();
                return false;
            }
            return true;
        }
        protected void cmdNhapan_Click(object sender, EventArgs e)
        {
            decimal vuAnConID = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    vuAnConID = Convert.ToDecimal(Item.Cells[0].Text);
                }
            }
            if (vuAnConID == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn vụ án!";
                return;
            }
            else
            {
                txtNgayquyetdinh.Text = DateTime.Now.ToString("dd/MM/yyyy");
                txtSoquyetdinh.Text = "";
                txtNguoiKy.Text = "";
                lbthongbao.Text = "";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "hienPopup();", true);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValidQĐ())
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "ShowPopup", "hienPopup();", true);
                    return;
                }
                else
                {
                    //Tạo quyết định nhập án
                    DON_NHAPTACH_QUYETDINH QDNA = new DON_NHAPTACH_QUYETDINH();
                    QDNA.NGAYQD = DateTime.Parse(this.txtNgayquyetdinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    QDNA.SOQD = txtSoquyetdinh.Text.Trim();
                    QDNA.NGUOIKY = txtNguoiKy.Text.Trim();
                    QDNA.NGAYTAO = new DateTime();
                    QDNA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    DataExtensions.Insert(QDNA);

                    List<decimal> ds_vuAnConID = new List<decimal>();
                    foreach (DataGridItem Item in dgList.Items)
                    {

                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {
                            ds_vuAnConID.Add(Convert.ToDecimal(Item.Cells[0].Text));
                        }
                    }
                    if (ds_vuAnConID.Count > 0)
                    {
                        foreach (decimal vuAnConID in ds_vuAnConID)
                        {
                            try
                            {
                                AHN_DON donCon = dt.AHN_DON.Where(x => x.ID == vuAnConID).FirstOrDefault();

                                //Tạo bản ghi DON_NHAPTACH
                                DON_NHAPTACH donNhap = new DON_NHAPTACH();
                                donNhap.DONID = donCon.ID;
                                donNhap.LOAIANID = 3; //AHN
                                donNhap.MAVUVIEC = donCon.MAVUVIEC;
                                donNhap.NGUOITAO = donCon.NGUOITAO;
                                donNhap.NGAYTAO = donCon.NGAYTAO;
                                donNhap.VUANGOCID = DonGocID;
                                donNhap.IS_TACHAN = 0;
                                donNhap.QUYETDINHID = QDNA.ID;
                                //Lấy chuỗi danh sách đương sự
                                List<AHN_DON_DUONGSU> dsDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vuAnConID).ToList();
                                string jsonDuongSu = ",";
                                foreach (var item in dsDuongSu)
                                {
                                    jsonDuongSu += item.TENDUONGSU + ",";
                                }
                                //Lấy thông tin donNhap.THONGTIN_VUVIEC
                                AHN_DON_BL oBL = new AHN_DON_BL();
                                DataTable objVuViec = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
                                                                "", "", "", "", "", "", "", "", "", "",
                                                                "", "", "", "", "", "", "", 0, 0, 0, "", 1, 1, 0, 1, 1);
                                objVuViec.Columns.Remove("STT");
                                objVuViec.Columns.Remove("COUNTALL");
                                //Thay đổi dữ liệu cột HOTENBICAN
                                objVuViec.Rows[0]["HOTENBICAN"] = jsonDuongSu;
                                //Chuyển dữ liệu obj sang json
                                string jsonVuViec = JsonConvert.SerializeObject(objVuViec);
                                donNhap.THONGTIN_VUVIEC = jsonVuViec;
                                //Lấy ds thẩm phán
                                List<AHN_DON_THAMPHAN> dsThamPhan = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == vuAnConID).ToList();
                                string jsonThamPhan = ",";
                                foreach (var item in dsThamPhan)
                                {
                                    jsonThamPhan += item.CANBOID + ",";
                                }
                                //Lấy ds thư kí
                                List<AHN_SOTHAM_HDXX> dsSoThamHDXX = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
                                List<AHN_PHUCTHAM_HDXX> dsPhucThamHDXX = dt.AHN_PHUCTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
                                string jsonThuKy = ",";
                                foreach (var item in dsSoThamHDXX)
                                {
                                    jsonThuKy += item.CANBOID + ",";
                                }
                                foreach (var item in dsPhucThamHDXX)
                                {
                                    jsonThuKy += item.CANBOID + ",";
                                }
                                //Lấy thông tin thụ lý
                                AHN_SOTHAM_THULY thuLy = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
                                int ttTL = 0;
                                string ngayTL = "", soTL = "";
                                if (thuLy != null)
                                {
                                    ttTL = 1;
                                    ngayTL = String.Format("{0:dd/MM/yyyy}", thuLy.NGAYTHULY);
                                    soTL = thuLy.SOTHULY;
                                }
                                else
                                {
                                    ttTL = 2;
                                }
                                //Lấy thông tin donNhap.THONGTIN_TIMKIEM
                                Object ttTimKiem = new
                                {
                                    TENVUVIEC = donCon.TENVUVIEC,
                                    QHPL = donCon.QUANHEPHAPLUAT_NAME,
                                    MAVUVIEC = donCon.MAVUVIEC,
                                    DUONGSU = jsonDuongSu,
                                    CAPXETXU = donCon.MAGIAIDOAN,
                                    TOAANID = donCon.TOAANID,
                                    TINHTRANGTHULY = ttTL,
                                    NGAYTHULY = ngayTL,
                                    SOTHULY = soTL,
                                    THAMPHANID = jsonThamPhan,
                                    THUKYID = jsonThuKy,
                                    LOAIDON = donCon.LOAIDON
                                };
                                //Chuyển dữ liệu obj sang json
                                string jsonTimKiem = JsonConvert.SerializeObject(ttTimKiem);
                                donNhap.THONGTIN_TIMKIEM = jsonTimKiem;

                                dt.DON_NHAPTACH.Add(donNhap);
                                dt.SaveChanges();

                                //Add thông tin bảng HISTORY_DELETE_HOSO_AN_SOTHAM
                                AHN_DON donGoc = dt.AHN_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

                    string taiKhoanXoa = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    string nguoiXoa = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    //Án dân sự
                    string tenChucNang = "Nhập án Hôn nhân, gia đình từ " + donCon.MAVUVIEC + " đến " + donGoc.MAVUVIEC;
                    string hanhDong = "Nhập án";
                    //Lấy thông tin nội dung (json)
                    DataTable objNoiDung = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
                                                    "", "", "", "", "", "", "", "", "", "",
                                                    "", "", "", "", "", "", "", 0, 0,0, "", 1, 1, 0, 1, 1);
                    objNoiDung.Columns.Remove("STT");
                    objNoiDung.Columns.Remove("COUNTALL");
                    string jsonString = JsonConvert.SerializeObject(objNoiDung);

                                //Dùng chung ADS_DON_BL thay loại án
                                ADS_DON_BL adsBL = new ADS_DON_BL();
                                adsBL.HISTORY_ALLDATA_BY_VUANID(vuAnConID, 3, nguoiXoa, taiKhoanXoa, tenChucNang, hanhDong, jsonString);

                                //Cập nhật DONID của các bảng liên quan:
                                AHN_DON_BL update = new AHN_DON_BL();
                                update.CAPNHAT_DON_GOC_ID(DonGocID, vuAnConID);

                    //Tạo bản ghi DON_CHITIET & DON_DUONGSU_CHITIET từ vụ việc con
                    DON_CHITIET donCT = new DON_CHITIET();
                    donCT.DONID = DonGocID;
                    donCT.LOAIANID = 3; //AHN
                    donCT.TOAANID = donCon.TOAANID;
                    donCT.HINHTHUCNHANDON = donCon.HINHTHUCNHANDON;
                    donCT.NGAYVIETDON = donCon.NGAYVIETDON;
                    donCT.NGAYNHANDON = donCon.NGAYNHANDON;
                    donCT.CANBONHANDONID = donCon.CANBONHANDONID;
                    donCT.THAMPHANKYNHANDON = donCon.THAMPHANKYNHANDON;
                    donCT.YEUTONUOCNGOAI = donCon.YEUTONUOCNGOAI;
                    donCT.LOAIDON = donCon.LOAIDON;
                    donCT.USERTT_EMAIL = donCon.USERTT_EMAIL;
                    donCT.USERTT_ID = donCon.USERTT_ID;
                    donCT.USERTT_NGAYGUI = donCon.USERTT_NGAYGUI;
                    donCT.USERTT_NGAYTAO = donCon.USERTT_NGAYTAO;
                    donCT.USERTT_NGAYBOSUNG = donCon.USERTT_NGAYBOSUNG;
                    donCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    donCT.NGAYTAO = DateTime.Now;
                    donCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    donCT.NGAYSUA = DateTime.Now;
                    donCT.NOIDUNGKHOIKIEN = donCon.NOIDUNGKHOIKIEN;
                    donCT.DONKKID = null;
                    donCT.GHICHU = "";
                    donCT.TTGQ = null;
                    donCT.NOIDUNGTTGQ = "";
                    donCT.DONGUINHANID = null;
                    
                    if (donCT.TOA_GIAIQUYET_ID == null)
                        donCT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    dt.DON_CHITIET.Add(donCT);
                    dt.SaveChanges();

                                //UPDATE ADS_DON_XULY SET DON_XULYID = v_DonGocID, DONID = NULL, DONCHITIETID = (id đơn chi tiết vừa mới tạo bên trên) WHERE DONID = v_DonConID;
                                AHN_DON_XULY donXL = dt.AHN_DON_XULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
                                if (donXL != null)
                                {
                                    donXL.DONID = null;
                                    donXL.DON_CHITIETID = donCT.ID;
                                    donXL.DON_XULYID = DonGocID;
                                }

                                //Danh sách đương sự của vụ việc con được nhập
                                foreach (var item in dsDuongSu)
                                {
                                    if ((item.ISDONCHITIET == null || item.ISDONCHITIET == 0) || (item.ISDAIDIEN == 1))
                                    {
                                        //Cập nhật thông tin của đương sự đại diện cho đơn con được nhập ADS_DON_DUONGSU
                                        item.DONID = DonGocID;
                                        item.ISDAIDIEN_DONCHITIET = item.ISDAIDIEN;
                                        item.ISDONCHITIET = 1;
                                        item.ISDAIDIEN = 0;

                            //Thêm đương sự chi tiết DON_DUONGSU_CHITIET
                            DON_DUONGSU_CHITIET dsCT = new DON_DUONGSU_CHITIET();
                            dsCT.DUONGSUID = item.ID;
                            dsCT.DONID = DonGocID;
                            dsCT.LOAIAN = 3; //AHN
                            dsCT.DONCHITIETID = donCT.ID;
                            dsCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            dsCT.NGAYTAO = DateTime.Now;
                            dsCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            dsCT.NGAYSUA = DateTime.Now;
                            
                            if (dsCT.TOA_GIAIQUYET_ID == null)
                                dsCT.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            dt.DON_DUONGSU_CHITIET.Add(dsCT);
                            dt.SaveChanges();
                        }
                        else
                        {
                            //Cập nhật thông tin của đương sự đại diện cho đơn chi tiết của đơn con con được nhập ADS_DON_DUONGSU
                            item.DONID = DonGocID;
                            item.ISDAIDIEN = 0;
                        }
                    }

                                //Xoá bản ghi vụ việc con ADS_DON
                                dt.AHN_DON.Remove(donCon);
                                dt.SaveChanges();

                                Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
                            }
                            catch (Exception ex)
                            {
                                DataExtensions.Delete(QDNA);
                                lbtthongbao.Text = "Có lỗi khi nhập án: " + ex.Message;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        //protected void cmdNhapan_Click(object sender, EventArgs e)
        //{
        //    decimal vuAnConID = 0, count = 0;
        //    AHN_SOTHAM_THULY oNSD = new AHN_SOTHAM_THULY();
        //    foreach (DataGridItem Item in dgList.Items)
        //    {
        //        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
        //        if (chkChon.Checked)
        //        {
        //            count++;
        //            vuAnConID = Convert.ToDecimal(Item.Cells[0].Text);
        //            oNSD = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
        //        }
        //    }
        //    if (vuAnConID == 0)
        //    {
        //        lbtthongbao.Text = "Bạn chưa chọn vụ án!";
        //        return;
        //    }
        //    else if (count > 1)
        //    {
        //        lbtthongbao.Text = "Bạn chỉ chọn một vụ án!";
        //        return;
        //    }
        //    else
        //    {
        //        try
        //        {
        //            AHN_DON donCon = dt.AHN_DON.Where(x => x.ID == vuAnConID).FirstOrDefault();

        //            //Tạo bản ghi DON_NHAPTACH
        //            DON_NHAPTACH donNhap = new DON_NHAPTACH();
        //            donNhap.DONID = donCon.ID;
        //            donNhap.LOAIANID = 3; //AHN
        //            donNhap.MAVUVIEC = donCon.MAVUVIEC;
        //            donNhap.NGUOITAO = donCon.NGUOITAO;
        //            donNhap.NGAYTAO = donCon.NGAYTAO;
        //            donNhap.VUANGOCID = DonGocID;
        //            donNhap.IS_TACHAN = 0;
        //            //Lấy chuỗi danh sách đương sự
        //            List<AHN_DON_DUONGSU> dsDuongSu = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vuAnConID).ToList();
        //            string jsonDuongSu = ",";
        //            foreach (var item in dsDuongSu)
        //            {
        //                jsonDuongSu += item.TENDUONGSU + ",";
        //            }
        //            //Lấy thông tin donNhap.THONGTIN_VUVIEC
        //            AHN_DON_BL oBL = new AHN_DON_BL();
        //            DataTable objVuViec = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
        //                                            "", "", "", "", "", "", "", "", "", "",
        //                                            "", "", "", "", "", "", "", 0,0, 0, "", 1, 1, 1, 1);
        //            objVuViec.Columns.Remove("STT");
        //            objVuViec.Columns.Remove("COUNTALL");
        //            //Thay đổi dữ liệu cột HOTENBICAN
        //            objVuViec.Rows[0]["HOTENBICAN"] = jsonDuongSu;
        //            //Chuyển dữ liệu obj sang json
        //            string jsonVuViec = JsonConvert.SerializeObject(objVuViec);
        //            donNhap.THONGTIN_VUVIEC = jsonVuViec;
        //            //Lấy ds thẩm phán
        //            List<AHN_DON_THAMPHAN> dsThamPhan = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == vuAnConID).ToList();
        //            string jsonThamPhan = ",";
        //            foreach (var item in dsThamPhan)
        //            {
        //                jsonThamPhan += item.CANBOID + ",";
        //            }
        //            //Lấy ds thư kí
        //            List<AHN_SOTHAM_HDXX> dsSoThamHDXX = dt.AHN_SOTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
        //            List<AHN_PHUCTHAM_HDXX> dsPhucThamHDXX = dt.AHN_PHUCTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
        //            string jsonThuKy = ",";
        //            foreach (var item in dsSoThamHDXX)
        //            {
        //                jsonThuKy += item.CANBOID + ",";
        //            }
        //            foreach (var item in dsPhucThamHDXX)
        //            {
        //                jsonThuKy += item.CANBOID + ",";
        //            }
        //            //Lấy thông tin thụ lý
        //            AHN_SOTHAM_THULY thuLy = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
        //            int ttTL = 0;
        //            string ngayTL = "", soTL = "";
        //            if (thuLy != null)
        //            {
        //                ttTL = 1;
        //                ngayTL = String.Format("{0:dd/MM/yyyy}", thuLy.NGAYTHULY);
        //                soTL = thuLy.SOTHULY;
        //            }
        //            else
        //            {
        //                ttTL = 2;
        //            }
        //            //Lấy thông tin donNhap.THONGTIN_TIMKIEM
        //            Object ttTimKiem = new
        //            {
        //                TENVUVIEC = donCon.TENVUVIEC,
        //                QHPL = donCon.QUANHEPHAPLUAT_NAME,
        //                MAVUVIEC = donCon.MAVUVIEC,
        //                DUONGSU = jsonDuongSu,
        //                CAPXETXU = donCon.MAGIAIDOAN,
        //                TOAANID = donCon.TOAANID,
        //                TINHTRANGTHULY = ttTL,
        //                NGAYTHULY = ngayTL,
        //                SOTHULY = soTL,
        //                THAMPHANID = jsonThamPhan,
        //                THUKYID = jsonThuKy,
        //                LOAIDON = donCon.LOAIDON
        //            };
        //            //Chuyển dữ liệu obj sang json
        //            string jsonTimKiem = JsonConvert.SerializeObject(ttTimKiem);
        //            donNhap.THONGTIN_TIMKIEM = jsonTimKiem;

        //            dt.DON_NHAPTACH.Add(donNhap);
        //            dt.SaveChanges();

        //            //Add thông tin bảng HISTORY_DELETE_HOSO_AN_SOTHAM
        //            AHN_DON donGoc = dt.AHN_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

        //            string taiKhoanXoa = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //            string nguoiXoa = Session[ENUM_SESSION.SESSION_USERID].ToString();
        //            //Án dân sự
        //            string tenChucNang = "Nhập án Hôn nhân, gia đình từ " + donCon.MAVUVIEC + " đến " + donGoc.MAVUVIEC;
        //            string hanhDong = "Nhập án";
        //            //Lấy thông tin nội dung (json)
        //            DataTable objNoiDung = oBL.DON_SEARCH(Session["CAP_XET_XU"] + "", "", "", donCon.MAVUVIEC, "", "", donCon.TOAANID.ToString(),
        //                                            "", "", "", "", "", "", "", "", "", "",
        //                                            "", "", "", "", "", "", "", 0, 0,0, "", 1, 1, 1, 1);
        //            objNoiDung.Columns.Remove("STT");
        //            objNoiDung.Columns.Remove("COUNTALL");
        //            string jsonString = JsonConvert.SerializeObject(objNoiDung);

        //            //Dùng chung ADS_DON_BL thay loại án
        //            ADS_DON_BL adsBL = new ADS_DON_BL();
        //            adsBL.HISTORY_ALLDATA_BY_VUANID(vuAnConID, 3, nguoiXoa, taiKhoanXoa, tenChucNang, hanhDong, jsonString);

        //            //Cập nhật DONID của các bảng liên quan:
        //            AHN_DON_BL update = new AHN_DON_BL();
        //            update.CAPNHAT_DON_GOC_ID(DonGocID, vuAnConID);

        //            //Tạo bản ghi DON_CHITIET & DON_DUONGSU_CHITIET từ vụ việc con
        //            DON_CHITIET donCT = new DON_CHITIET();
        //            donCT.DONID = DonGocID;
        //            donCT.LOAIANID = 3; //AHN
        //            donCT.TOAANID = donCon.TOAANID;
        //            donCT.HINHTHUCNHANDON = donCon.HINHTHUCNHANDON;
        //            donCT.NGAYVIETDON = donCon.NGAYVIETDON;
        //            donCT.NGAYNHANDON = donCon.NGAYNHANDON;
        //            donCT.CANBONHANDONID = donCon.CANBONHANDONID;
        //            donCT.THAMPHANKYNHANDON = donCon.THAMPHANKYNHANDON;
        //            donCT.YEUTONUOCNGOAI = donCon.YEUTONUOCNGOAI;
        //            donCT.LOAIDON = donCon.LOAIDON;
        //            donCT.USERTT_EMAIL = donCon.USERTT_EMAIL;
        //            donCT.USERTT_ID = donCon.USERTT_ID;
        //            donCT.USERTT_NGAYGUI = donCon.USERTT_NGAYGUI;
        //            donCT.USERTT_NGAYTAO = donCon.USERTT_NGAYTAO;
        //            donCT.USERTT_NGAYBOSUNG = donCon.USERTT_NGAYBOSUNG;
        //            donCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //            donCT.NGAYTAO = DateTime.Now;
        //            donCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //            donCT.NGAYSUA = DateTime.Now;
        //            donCT.NOIDUNGKHOIKIEN = donCon.NOIDUNGKHOIKIEN;
        //            donCT.DONKKID = null;
        //            donCT.GHICHU = "";
        //            donCT.TTGQ = null;
        //            donCT.NOIDUNGTTGQ = "";
        //            donCT.DONGUINHANID = null;

        //            dt.DON_CHITIET.Add(donCT);
        //            dt.SaveChanges();

        //            //UPDATE ADS_DON_XULY SET DON_XULYID = v_DonGocID, DONID = NULL, DONCHITIETID = (id đơn chi tiết vừa mới tạo bên trên) WHERE DONID = v_DonConID;
        //            AHN_DON_XULY donXL = dt.AHN_DON_XULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
        //            if (donXL != null)
        //            {
        //                donXL.DONID = null;
        //                donXL.DON_CHITIETID = donCT.ID;
        //                donXL.DON_XULYID = DonGocID;
        //            }

        //            //Danh sách đương sự của vụ việc con được nhập
        //            foreach (var item in dsDuongSu)
        //            {
        //                if ((item.ISDONCHITIET == null || item.ISDONCHITIET == 0) || (item.ISDAIDIEN == 1))
        //                {
        //                    //Cập nhật thông tin của đương sự đại diện cho đơn con được nhập ADS_DON_DUONGSU
        //                    item.DONID = DonGocID;
        //                    item.ISDAIDIEN_DONCHITIET = item.ISDAIDIEN;
        //                    item.ISDONCHITIET = 1;
        //                    item.ISDAIDIEN = 0;

        //                    //Thêm đương sự chi tiết DON_DUONGSU_CHITIET
        //                    DON_DUONGSU_CHITIET dsCT = new DON_DUONGSU_CHITIET();
        //                    dsCT.DUONGSUID = item.ID;
        //                    dsCT.DONID = DonGocID;
        //                    dsCT.LOAIAN = 3; //AHN
        //                    dsCT.DONCHITIETID = donCT.ID;
        //                    dsCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //                    dsCT.NGAYTAO = DateTime.Now;
        //                    dsCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
        //                    dsCT.NGAYSUA = DateTime.Now;

        //                    dt.DON_DUONGSU_CHITIET.Add(dsCT);
        //                    dt.SaveChanges();
        //                }
        //                else
        //                {
        //                    //Cập nhật thông tin của đương sự đại diện cho đơn chi tiết của đơn con con được nhập ADS_DON_DUONGSU
        //                    item.DONID = DonGocID;
        //                    item.ISDAIDIEN = 0;
        //                }
        //            }

        //            //Xoá bản ghi vụ việc con ADS_DON
        //            dt.AHN_DON.Remove(donCon);
        //            dt.SaveChanges();

        //            Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
        //        }
        //        catch (Exception ex)
        //        {
        //            Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");//lbtthongbao.Text = "Có lỗi khi nhập án: " + ex.Message;
        //        }
        //    }
        //}
    }
}