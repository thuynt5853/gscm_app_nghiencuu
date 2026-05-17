using BL.GSTP;
using BL.GSTP.APS;
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

namespace WEB.GSTP.QLAN.APS.Hoso.Popup
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
                    txtDuongSu_NguoiThamGiaToTung.Text = strSearch;
                    Session["textsearch"] = "";
                }
                LoadCombobox();
                Load_VuAnGoc();
                Load_Data();
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            }
        }

        private void Load_VuAnGoc()
        {
            APS_DON_BL oBL = new APS_DON_BL();

            APS_DON donGoc = dt.APS_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

            DataTable oDT = oBL.APS_DON_SEARCH(Session["CAP_XET_XU"] + "", donGoc.TOAANID.ToString(), "", "", donGoc.MAVUVIEC, "", donGoc.MAGIAIDOAN.ToString(), donGoc.TOAANID.ToString(), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0,0, "", 1,  1, 1);
            dgVuAnGoc.PageSize = 1;
            dgVuAnGoc.DataSource = oDT;
            dgVuAnGoc.DataBind();
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            txtTenViec.Text = "";
            txtMaViec.Text = "";
            ddlLoaiHinhDoanhNghiep.SelectedIndex = 0;
            txtDuongSu_NguoiThamGiaToTung.Text = "";
            ddlCapXetXu.SelectedIndex = 0;
            ddlToaAnXetXu.SelectedIndex = 0;
            ddlTinhTrangThuLy.SelectedValue = "";
            txtTuNgayThuly.Text = "";
            txtDenNgayThuLy.Text = "";
            txtSoThuLy.Text = "";
            ddlTinhTrangGQ.SelectedValue = "";
            txtTuNgayTinhTrangGQ.Text = "";
            txtDenNgayTinhTrangGQ.Text = "";
            ddlThamphan.SelectedIndex = 0;
            ddlThoiHanGQ.SelectedValue = "";
            txtSoQD.Text = "";
            txtNgayQD.Text = "";
            ddlThuKy.SelectedIndex = 0;
            ddlGQDon.SelectedValue = "";
            ddlUyThacTuPhap.SelectedValue = "";
            ddlPTRutKinhNghiem.SelectedValue = "";
        }

        private void Load_Data()
        {
            decimal vchecktk = 0;
            APS_DON_BL oBL = new APS_DON_BL();
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;

            string vDonViID = Convert.ToString(Session[ENUM_SESSION.SESSION_DONVIID]),
                    LoaiHinhDoanhNghiep = ddlLoaiHinhDoanhNghiep.SelectedValue,
                    CapXetXu = ddlCapXetXu.SelectedValue,
                    ToaXetXu = ddlToaAnXetXu.SelectedValue,
                    TinhTrangThuLy = ddlTinhTrangThuLy.SelectedValue,
                    TinhTrangGQ = ddlTinhTrangGQ.SelectedValue,
                    ThamPhan = ddlThamphan.SelectedValue,
                    ThoiHanGQ = ddlThoiHanGQ.SelectedValue,
                    ThuKy = ddlThuKy.SelectedValue,
                    GQDon = ddlGQDon.SelectedValue,
                    UyThacTuPhap = ddlUyThacTuPhap.SelectedValue,
                    PTRutKinhNghiem = ddlPTRutKinhNghiem.SelectedValue;
            string tuNgayThuLy = txtTuNgayThuly.Text.Trim(), denNgayThuLy = txtDenNgayThuLy.Text.Trim();
            string tuNgayTinhTrangGQ = txtTuNgayTinhTrangGQ.Text.Trim(), denNgayTinhTrangGQ = txtDenNgayTinhTrangGQ.Text.Trim();
            string ngayQD = txtNgayQD.Text.Trim();
            string tenViec = txtTenViec.Text,
                   maViec = txtMaViec.Text,
                   duongSu_NguoiThamGiaToTung = txtDuongSu_NguoiThamGiaToTung.Text,
                   soThuLy = txtSoThuLy.Text,
                   soQD = txtSoQD.Text;

            DataTable oDT = oBL.APS_DON_CON_SEARCH(DonGocID, Session["CAP_XET_XU"] + "", vDonViID, tenViec, LoaiHinhDoanhNghiep, maViec, duongSu_NguoiThamGiaToTung, "2", "640", TinhTrangThuLy, tuNgayThuLy, denNgayThuLy, soThuLy, TinhTrangGQ, tuNgayTinhTrangGQ, denNgayTinhTrangGQ, ThamPhan, ThoiHanGQ, soQD, ngayQD, ThuKy, GQDon, UyThacTuPhap, PTRutKinhNghiem, vchecktk, pageindex, page_size);

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

        private void LoadCombobox()
        {
            //Load Quan hệ pháp luật
            /* DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
             ddlQuanhephapluat.DataSource = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.QUANHEPL_YEUCAUPS);
             ddlQuanhephapluat.DataTextField = "TEN";
             ddlQuanhephapluat.DataValueField = "ID";
             ddlQuanhephapluat.DataBind();
             ddlQuanhephapluat.Items.Insert(0, new ListItem("-- Tất cả --", "0"));*/
            //--------------------
            LoadDropThamphan();

            // duongph 23/03/2022
            //Loại hình doanh nghiệp
            ddlLoaiHinhDoanhNghiep.Items.Clear();
            ddlLoaiHinhDoanhNghiep.DataSource = dt.DM_QHPL_TK.Where(x => x.STYLES == ENUM_QHPLTK.PHASAN).OrderBy(y => y.ARRTHUTU).ToList();
            ddlLoaiHinhDoanhNghiep.DataTextField = "CASE_NAME";
            ddlLoaiHinhDoanhNghiep.DataValueField = "ID";
            ddlLoaiHinhDoanhNghiep.DataBind();
            ddlLoaiHinhDoanhNghiep.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            //Cấp xét xử
            ddlCapXetXu.Items.Clear();
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                ddlCapXetXu.Items.Add(new ListItem("-- Tất cả --", ""));
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                ddlCapXetXu.Items.Add(new ListItem("-- Tất cả --", ""));
                ddlCapXetXu.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                ddlCapXetXu.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //Tòa án xét xử
            LoadDropToaAnXetXu();
            LoadDropThuKy();
        }

        private void LoadDropToaAnXetXu()
        {
            ddlToaAnXetXu.Items.Clear();
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            ddlToaAnXetXu.DataSource = oBL.DM_TOAAN_GETBY_PAREN_CHECK(Session[ENUM_SESSION.SESSION_CANBOID] + "", ddlCapXetXu.SelectedValue, Session[ENUM_SESSION.SESSION_DONVIID] + "", Session["CAP_XET_XU"] + "");
            ddlToaAnXetXu.DataTextField = "arrTEN";
            ddlToaAnXetXu.DataValueField = "ID";
            ddlToaAnXetXu.DataBind();
            if (Session[ENUM_SESSION.SESSION_DONVIID] + "" != "")
            {
                ddlToaAnXetXu.SelectedValue = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            }
            LoadDropThuKy();
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
                decimal LoginDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                DataTable tbl = objBL.DM_CANBO_GETBYDONVI_CHUCDANH(LoginDonViID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = tbl;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("-- Tất cả --", ""));
            }
        }

        protected void LoadDropThuKy()
        {
            DM_CANBO_BL objBL = new DM_CANBO_BL();
            DataTable tbl = null;
            if (ddlToaAnXetXu.SelectedValue != "")
                tbl = objBL.GET_ThuKy_TTVS(ddlToaAnXetXu.SelectedValue, null);
            ddlThuKy.DataSource = tbl;
            ddlThuKy.DataTextField = "MA_TEN";
            ddlThuKy.DataValueField = "ID";
            ddlThuKy.DataBind();
            ddlThuKy.Items.Insert(0, new ListItem("-- Chọn --", ""));
        }

        protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCombobox();
        }

        protected void ddlCapXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropToaAnXetXu();
            LoadDropThamphan();
            LoadDropThuKy();
        }

        protected void ddlToaAnXetXu_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropThamphan();
            LoadDropThuKy();
            Load_Data();
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

        protected void cmdNhapan_Click(object sender, EventArgs e)
        {
            decimal vuAnConID = 0, count = 0;
            ADS_SOTHAM_THULY oNSD = new ADS_SOTHAM_THULY();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    count++;
                    vuAnConID = Convert.ToDecimal(Item.Cells[0].Text);
                    oNSD = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
                }
            }
            if (vuAnConID == 0)
            {
                lbtthongbao.Text = "Bạn chưa chọn vụ án!";
                return;
            }
            else if (count > 1)
            {
                lbtthongbao.Text = "Bạn chỉ chọn một vụ án!";
                return;
            }
            else
            {
                try
                {
                    APS_DON donCon = dt.APS_DON.Where(x => x.ID == vuAnConID).FirstOrDefault();

                    //Tạo bản ghi DON_NHAPTACH
                    DON_NHAPTACH donNhap = new DON_NHAPTACH();
                    donNhap.DONID = donCon.ID;
                    donNhap.LOAIANID = 7; //APS
                    donNhap.MAVUVIEC = donCon.MAVUVIEC;
                    donNhap.NGUOITAO = donCon.NGUOITAO;
                    donNhap.NGAYTAO = donCon.NGAYTAO;
                    donNhap.VUANGOCID = DonGocID;
                    donNhap.IS_TACHAN = 0;
                    //Lấy chuỗi danh sách đương sự
                    List<APS_DON_DUONGSU> dsDuongSu = dt.APS_DON_DUONGSU.Where(x => x.DONID == vuAnConID).ToList();
                    string jsonDuongSu = ",";
                    foreach (var item in dsDuongSu)
                    {
                        jsonDuongSu += item.TENDUONGSU + ",";
                    }
                    //Lấy thông tin donNhap.THONGTIN_VUVIEC
                    APS_DON_BL oBL = new APS_DON_BL();
                    DataTable objVuViec = oBL.APS_DON_SEARCH(Session["CAP_XET_XU"] + "", donCon.TOAANID.ToString(), "", "", donCon.MAVUVIEC, "", donCon.MAGIAIDOAN.ToString(), donCon.TOAANID.ToString(), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0,0, "", 1, 1, 1);

                    objVuViec.Columns.Remove("STT");
                    objVuViec.Columns.Remove("COUNTALL");
                    //Thay đổi dữ liệu cột HOTENBICAN
                    objVuViec.Rows[0]["HOTENBICAN"] = jsonDuongSu;
                    //Chuyển dữ liệu obj sang json
                    string jsonVuViec = JsonConvert.SerializeObject(objVuViec);
                    donNhap.THONGTIN_VUVIEC = jsonVuViec;
                    //Lấy ds thẩm phán
                    List<APS_DON_THAMPHAN> dsThamPhan = dt.APS_DON_THAMPHAN.Where(x => x.DONID == vuAnConID).ToList();
                    string jsonThamPhan = ",";
                    foreach (var item in dsThamPhan)
                    {
                        jsonThamPhan += item.CANBOID + ",";
                    }
                    //Lấy ds thư kí
                    List<APS_SOTHAM_HDXX> dsSoThamHDXX = dt.APS_SOTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
                    List<APS_PHUCTHAM_HDXX> dsPhucThamHDXX = dt.APS_PHUCTHAM_HDXX.Where(x => x.DONID == vuAnConID && x.MAVAITRO == "THUKY").ToList();
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
                    APS_SOTHAM_THULY thuLy = dt.APS_SOTHAM_THULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
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
                    APS_DON donGoc = dt.APS_DON.Where(x => x.ID == DonGocID).FirstOrDefault();

                    string taiKhoanXoa = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    string nguoiXoa = Session[ENUM_SESSION.SESSION_USERID].ToString();
                    //Án phá sản
                    string tenChucNang = "Nhập án Phá sản từ " + donCon.MAVUVIEC + " đến " + donGoc.MAVUVIEC;
                    string hanhDong = "Nhập án";
                    //Lấy thông tin nội dung (json)
                    DataTable objNoiDung = oBL.APS_DON_SEARCH(Session["CAP_XET_XU"] + "", donCon.TOAANID.ToString(), "", "", donCon.MAVUVIEC, "", donCon.MAGIAIDOAN.ToString(), donCon.TOAANID.ToString(), "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0,0, "", 1, 1, 1);
                    objNoiDung.Columns.Remove("STT");
                    objNoiDung.Columns.Remove("COUNTALL");
                    string jsonString = JsonConvert.SerializeObject(objNoiDung);

                    //Dùng chung ADS_DON_BL thay loại án
                    ADS_DON_BL adsBL = new ADS_DON_BL();
                    adsBL.HISTORY_ALLDATA_BY_VUANID(vuAnConID, 7, nguoiXoa, taiKhoanXoa, tenChucNang, hanhDong, jsonString);

                    //Cập nhật DONID của các bảng liên quan:
                    APS_DON_BL update = new APS_DON_BL();
                    update.CAPNHAT_DON_GOC_ID(DonGocID, vuAnConID);

                    //Tạo bản ghi DON_CHITIET & DON_DUONGSU_CHITIET từ vụ việc con
                    DON_CHITIET donCT = new DON_CHITIET();
                    donCT.DONID = DonGocID;
                    donCT.LOAIANID = 7; //APS
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

                    dt.DON_CHITIET.Add(donCT);
                    dt.SaveChanges();

                    //UPDATE ADS_DON_XULY SET DON_XULYID = v_DonGocID, DONID = NULL, DONCHITIETID = (id đơn chi tiết vừa mới tạo bên trên) WHERE DONID = v_DonConID;
                    APS_DON_XULY donXL = dt.APS_DON_XULY.Where(x => x.DONID == vuAnConID).FirstOrDefault();
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
                            dsCT.LOAIAN = 7; //APS
                            dsCT.DONCHITIETID = donCT.ID;
                            dsCT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            dsCT.NGAYTAO = DateTime.Now;
                            dsCT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                            dsCT.NGAYSUA = DateTime.Now;

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
                    dt.APS_DON.Remove(donCon);
                    dt.SaveChanges();

                    Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");
                }
                catch (Exception ex)
                {
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "OnClose()");//lbtthongbao.Text = "Có lỗi khi nhập án: " + ex.Message;
                }
            }
        }
    }
}