using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.DLQGC06;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Xml.Serialization;
using System.Collections.Generic;
using System.IO;
using System.Configuration;
using Newtonsoft.Json;

namespace WEB.GSTP.QLAN.C06
{
    public partial class DongBoDLDCQG : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private String VuViecTemp = "VuViecIDTemp";
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);

            if (!IsPostBack)
            {
                string strSearch = Session["textsearch"] + "";
                if (strSearch != "")
                {
                    txtBiCan.Text = strSearch;
                    Session["textsearch"] = "";
                }
                Session[VuViecTemp] = "";
                LoadDropToaAn();
                LoadCombobox();
                LoadLoaiAn();
                SetGetSessionTK(false);

            }
        }


        // GTEL-HUNGNQ 06-10-2025 thêm check all cho các án
        protected void chkChonAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;

            // xử lý lấy danh sách theo loại án
            string loaiAn = ddlLoaiAn.SelectedValue;
            switch (loaiAn)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    foreach (GridViewRow Item in gvDanhSach.Rows)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        chk.Checked = chkAll.Checked;
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    foreach (DataGridItem Item in adsDgList_All.Items)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        chk.Checked = chkAll.Checked;
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    foreach (DataGridItem Item in ahcDgList_All.Items)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        chk.Checked = chkAll.Checked;
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    foreach (DataGridItem Item in aldDgList_All.Items)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        chk.Checked = chkAll.Checked;
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    foreach (DataGridItem Item in aktDgList_All.Items)
                    {
                        CheckBox chk = (CheckBox)Item.FindControl("chkChon");
                        chk.Checked = chkAll.Checked;
                    }
                    break;
                default: return;
            }
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            decimal ID = Convert.ToDecimal(chk.ToolTip);
            foreach (DataGridItem Item in dgList.Items)
            {
            }
        }

        private void LoadLoaiAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
            ////ddlLoaiAn.Items.Add(new ListItem("Dân sự mở rộng", "2,3,4,5,6"));
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
            //ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN));
            //ddlLoaiAn.Items.Add(new ListItem("Xử lý hành chính", ENUM_LOAIVUVIEC_NUMBER.BPXLHC));
            ////ddlLoaiAn.Items.Insert(0, new ListItem("Tất cả", ""));
            //ddlLoaiAn.SelectedValue = "1";
        }

        private void SetGetSessionTK(bool isSet)
        {
            if (isSet)
            {
                Session[TK_CANHBAO.TENVUVIEC] = txtTenVuViec.Text.Trim();
                Session[TK_CANHBAO.TOIDANH] = txt_toidanh.Text.Trim();
                Session[TK_CANHBAO.MANVUVIEC] = txtMaVuViec.Text.Trim();
                Session[TK_CANHBAO.BiCan] = txtBiCan.Text.Trim();
                Session[TK_CANHBAO.CAPXX] = dropCapxx.SelectedValue;
                Session[TK_CANHBAO.TOAAN] = DropToaAn.SelectedValue;
                //Session[TK_CANHBAO.SOCCCD] = txtCCCD_SO.Text.Trim();
                //Session[TK_CANHBAO.NGAYTHULY_TU] = txt_NGAYTHULY_TU.Text;
                //Session[TK_CANHBAO.NGAYTHULY_DEN] = txt_NGAYTHULY_DEN.Text;
                Session[TK_CANHBAO.TUNGAY] = txtTuNgay.Text;
                Session[TK_CANHBAO.DENNGAY] = txtDenNgay.Text.Trim();
                Session[TK_CANHBAO.SOQD] = txtSoQD.Text.Trim();
                Session[TK_CANHBAO.THAMPHAN] = ddlThamphan.SelectedValue;
                Session[TK_CANHBAO.THUKY] = ddlHTND_Thuky.SelectedValue;
                Session[TK_CANHBAO.LOAIAN] = ddlLoaiAn.SelectedValue;

                string vArrSelectID = "";
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        if (vArrSelectID == "") vArrSelectID = chkChon.ToolTip;
                        else vArrSelectID = vArrSelectID + ";" + chkChon.ToolTip;
                    }
                }
                Session[TK_CANHBAO.ARRSELECTID] = vArrSelectID;
            }
        }

        private void ClearSession_TK()
        {
            Session[TK_CANHBAO.TENVUVIEC] = "";
            Session[TK_CANHBAO.TOIDANH] = "";
            Session[TK_CANHBAO.MANVUVIEC] = "";
            Session[TK_CANHBAO.BiCan] = "";
            Session[TK_CANHBAO.CAPXX] = "";
            Session[TK_CANHBAO.TOAAN] = "";
            Session[TK_CANHBAO.TINHTRANG_THULY] = "";
            Session[TK_CANHBAO.SOTHULY] = "";
            Session[TK_CANHBAO.NGAYTHULY_TU] = "";
            Session[TK_CANHBAO.NGAYTHULY_DEN] = "";
            Session[TK_CANHBAO.TINHTRANG_GIAIQUYET] = "";
            Session[TK_CANHBAO.TUNGAY] = "";
            Session[TK_CANHBAO.DENNGAY] = "";
            Session[TK_CANHBAO.KETQUA] = "";
            Session[TK_CANHBAO.SOQD] = "";
            Session[TK_CANHBAO.NGAYQD] = "";
            Session[TK_CANHBAO.THAMPHAN] = "";
            Session[TK_CANHBAO.THUKY] = "";
            Session[TK_CANHBAO.THOIHAN_GQ_GIAIQUYET] = "";
            Session[TK_CANHBAO.TAMGIAM] = "";
            Session[TK_CANHBAO.UTTP] = "";
            Session[TK_CANHBAO.LOAIAN] = "";
            Session[SS_TK.ARRSELECTID] = "";
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            clear_form_search();
        }

        protected void clear_form_search()
        {
            ClearSession_TK();
            ddlLoaiAn.SelectedValue = "1";
            txtTenVuViec.Text = string.Empty;
            txt_toidanh.Text = string.Empty;
            txtMaVuViec.Text = string.Empty;
            txtBiCan.Text = string.Empty;
            txt_NGAYGUI_TU.Text = string.Empty;
            txt_NGAYGUI_DEN.Text = string.Empty;
            txtCCCD_SO.Text = string.Empty;
            txtTuNgay.Text = string.Empty;
            txtDenNgay.Text = string.Empty;
            ddlThamphan.SelectedValue = string.Empty;
            txtSoQD.Text = string.Empty;
            ddlHTND_Thuky.SelectedValue = string.Empty;

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
            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            //--------------------
            LoadDropThamphan();
            LoadDrop_TTV_TK();
        }

        private void LoadDropThamphan()
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

        private void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("-- Tất cả --", "0"));
            foreach (DataRow row in tbl.Rows)
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void ddlTrangthaiDongBo_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize2.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void dropPageSize2_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize2.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {

        }
        protected void dgList_DaDB_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_BL oBL = new DLQGC06_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");


                if (rowView["ID"] + "" != "")
                {
                    string vDongBoID = (rowView["ID"] + "").ToString();

                    // Hủy chuyển
                    // Lấy dữ liệu từ DB
                    DataTable tbl = oBL.GetDulieuChon_DaDongBO(vDongBoID);
                    if (tbl.Rows.Count > 0)
                    {
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataRow row = tbl.Rows[0];
                        if (row["TRANG_THAI_DONGBO"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                        {
                            //Neu thu hoi thi khong cho huy chuyen
                            if (row["TRANGTHAIBANGHI"] + "" == "2")
                                lbtHuyChuyen.Visible = false;
                            else
                                lbtHuyChuyen.Visible = true;
                        }
                    }
                    //Xem lich su chuyen khi có nhiều hơn 1 bản ghi
                    DataTable tblView = oBL.GetDulieu_LichSuChuyen(vDongBoID);
                    if (tblView.Rows.Count > 1)
                        lbtView.Visible = true;
                    else
                        lbtView.Visible = false;
                }
            }
        }

        protected void dgList_DaDB_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(CurrID, out success, out fail);

                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo.aspx?vid=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }

        protected void dgList_ThuHoi_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_BL oBL = new DLQGC06_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");


                if (rowView["ID"] + "" != "")
                {
                    string vDongBoID = (rowView["ID"] + "").ToString();

                    //Xem lich su chuyen khi có nhiều hơn 1 bản ghi
                    DataTable tblView = oBL.GetDulieu_LichSuChuyen(vDongBoID);
                    if (tblView.Rows.Count > 1)
                        lbtView.Visible = true;
                    else
                        lbtView.Visible = false;
                }
            }
        }
        protected void dgList_ThuHoi_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "GuiLai":
                    string CurrID = e.CommandArgument.ToString();
                    GuiLai(CurrID);
                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo.aspx?vid=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
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
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
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

        #endregion "Phân trang"

        void ExportToXml(List<C06_TOAAN_TINHTRANGHONNHAN> objL)
        {
            XmlSerializer serializer = new XmlSerializer(typeof(List<C06_TOAAN_TINHTRANGHONNHAN>));
            using (FileStream fs = new FileStream("TinhTrangHonNhan.xml", FileMode.Create))
            {
                serializer.Serialize(fs, objL);
                // Ghi XML
            }
        }
        public string ExportAndSignXml(List<C06_TOAAN_TINHTRANGHONNHAN> objL, string certIdentifier)
        {
            // Đọc thư mục lưu file từ web.config
            string folderPath = ConfigurationManager.AppSettings["SignedXmlFolder"];
            if (string.IsNullOrEmpty(folderPath))
                throw new Exception("Chưa cấu hình đường dẫn lưu file trong web.config (SignedXmlFolder)");

            // Tạo thư mục nếu chưa có
            if (!Directory.Exists(folderPath))
                Directory.CreateDirectory(folderPath);

            // Tạo tên file có đuôi thời gian
            string timeStamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
            string rawFileName = $"TinhTrangHonNhan_{timeStamp}.xml";
            string signedFileName = $"TinhTrangHonNhan_{timeStamp}_Signed.xml";

            string rawXmlPath = Path.Combine(folderPath, rawFileName);
            string signedXmlPath = Path.Combine(folderPath, signedFileName);

            // 1. Ghi XML chưa ký
            XmlSerializer serializer = new XmlSerializer(typeof(List<C06_TOAAN_TINHTRANGHONNHAN>));
            using (FileStream fs = new FileStream(rawXmlPath, FileMode.Create))
            {
                serializer.Serialize(fs, objL);
            }

            // 2. Ký file XML
            XmlSignerWithHSM signer = new XmlSignerWithHSM();
            signer.Sign(rawXmlPath, signedXmlPath, certIdentifier);

            // ✅ Trả về đường dẫn tới file đã ký
            return signedXmlPath;
        }

        #region CN: 13/09/2025
        //Viết hàm Load_Data mới comment hàm cũ lại
        void Load_Data()
        {
            dataGridAllVisible(false); // ẩn hết các grid
            DLQGC06_BL obj = new DLQGC06_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
                pageindex = Convert.ToInt32(hddPageIndex.Value),
                count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;
            if (ddlTrangthaiDongBo.SelectedValue == "2")
            {
                pn_thuhoi.Visible = true;
                btnHuyChuyen.Visible = true;
            }
            else
            {
                pn_thuhoi.Visible = false;
                btnHuyChuyen.Visible = false;
            }

            DataTable tbl = null;
            // xử lý lấy danh sách theo loại án
            string loaiAn = ddlLoaiAn.SelectedValue;
            switch (loaiAn)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    loadDataHinhSu();
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    loadDataDanSu();
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    loadDataHanhChinh();
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    loadDataLaoDong();
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    loadDataKinhTe();
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH:
                    loadDataHNGD(page_size, pageindex, count_all, tbl, v_LOAIBAQD, v_BAQD_id, v_KHANGCAOQH);
                    break;
                default: return;
            }
        }
        void loadDataDanSu()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC06_ADS_BL obj = new DLQGC06_ADS_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;
            DataTable tbl = new DataTable();
            if (syncStatus == "3")
            {
                //Bị thu hồi
                tbl = obj.GetADSPaging_Search_All_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else if (syncStatus == "2")
            {
                //Đã đồng bộ
                tbl = obj.GetADSPaging_Search_All_DaDongBO(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else
            {
                //Chua dong bo
                tbl = obj.GeADSPaging_Search_ChuaDongBo(ddlLoaiAn.SelectedValue,
                            null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            adsDgList_All.Visible = true;
            adsDgList_All.DataSource = tbl;
            adsDgList_All.PageSize = page_size;
            adsDgList_All.DataBind();
        }
        void loadDataHanhChinh()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC06_AHC_BL obj = new DLQGC06_AHC_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;
            DataTable tbl = new DataTable();
            if (syncStatus == "3")
            {
                //Bị thu hồi
                tbl = obj.GetAHCPaging_Search_All_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else if (syncStatus == "2")
            {
                //Đã đồng bộ
                tbl = obj.GetAHCPaging_Search_All_DaDongBO(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else
            {
                //Chua dong bo
                tbl = obj.GeAHCPaging_Search_ChuaDongBo(ddlLoaiAn.SelectedValue,
                            null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            if (syncStatus == "2") pn_thuhoi.Visible = true;
            else pn_thuhoi.Visible = false;
            ahcDgList_All.Visible = true;
            ahcDgList_All.DataSource = tbl;
            ahcDgList_All.PageSize = page_size;
            ahcDgList_All.DataBind();
        }
        void loadDataLaoDong()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC06_ALD_BL obj = new DLQGC06_ALD_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;
            DataTable tbl = new DataTable();
            if (syncStatus == "3")
            {
                //Bị thu hồi
                tbl = obj.GetALDPaging_Search_All_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else if (syncStatus == "2")
            {
                //Đã đồng bộ
                tbl = obj.GetALDPaging_Search_All_DaDongBO(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else
            {
                //Chua dong bo
                tbl = obj.GeALDPaging_Search_ChuaDongBo(ddlLoaiAn.SelectedValue,
                            null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            if (syncStatus == "2") pn_thuhoi.Visible = true;
            else pn_thuhoi.Visible = false;
            aldDgList_All.Visible = true;
            aldDgList_All.DataSource = tbl;
            aldDgList_All.PageSize = page_size;
            aldDgList_All.DataBind();
        }
        void loadDataKinhTe()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC06_AKT_BL obj = new DLQGC06_AKT_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;
            DataTable tbl = new DataTable();
            if (syncStatus == "3")
            {
                //Bị thu hồi
                tbl = obj.GetAKTPaging_Search_All_ThuHoi(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else if (syncStatus == "2")
            {
                //Đã đồng bộ
                tbl = obj.GetAKTPaging_Search_All_DaDongBO(ddlLoaiAn.SelectedValue, null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else
            {
                //Chua dong bo
                tbl = obj.GeAKTPaging_Search_ChuaDongBo(ddlLoaiAn.SelectedValue,
                            null, null, null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            if (syncStatus == "2") pn_thuhoi.Visible = true;
            else pn_thuhoi.Visible = false;
            aktDgList_All.Visible = true;
            aktDgList_All.DataSource = tbl;
            aktDgList_All.PageSize = page_size;
            aktDgList_All.DataBind();
        }
        void loadDataHinhSu()
        {
            dataGridAllVisible(false);
            string syncStatus = ddlTrangthaiDongBo.SelectedValue;
            DLQGC06_AHS_BL obj = new DLQGC06_AHS_BL();
            int page_size = Convert.ToInt32(dropPageSize.SelectedValue),
               pageindex = Convert.ToInt32(hddPageIndex.Value),
               count_all = 0;
            string v_LOAIBAQD = null;
            string v_BAQD_id = null;
            string v_KHANGCAOQH = null;
            DataTable tbl = new DataTable();
            if (syncStatus == "3")
            {
                //Bị thu hồi
                tbl = obj.C06_AHS_SOTHAM_SEARCH_THUHOI
                            (ddlLoaiAn.SelectedValue,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
                // lấy thêm thông tin hình phạt tổng hợp
                tbl.Columns.Add("HINHPHAT_CHINH", typeof(string));
                if (tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        decimal biCanId = Convert.ToDecimal(row["BICAOID"].ToString());
                        DataTable hinhPhatTH = obj.C06_AHS_HINHPHAT_TONGHOP_GETBYID(biCanId);
                        foreach (DataRow hpRow in hinhPhatTH.Rows)
                        {
                            if (row["CAPXX_MA"].ToString() == "SO_THAM")
                            {

                                string tenHinhPhat = hpRow["HINHPHAT_ST"].ToString();
                                if (!string.IsNullOrEmpty(tenHinhPhat)) row["HINHPHAT_CHINH"] = tenHinhPhat;
                            }
                            else
                            {
                                string tenHinhPhat = hpRow["HINHPHAT_PT"].ToString();
                                if (!string.IsNullOrEmpty(tenHinhPhat)) row["HINHPHAT_CHINH"] = tenHinhPhat;
                            }
                        }

                    }
                }
            }
            else if (syncStatus == "2")
            {
                //Đã đồng bộ
                tbl = obj.C06_AHS_SOTHAM_SEARCH_DADONGBO
                           (ddlLoaiAn.SelectedValue,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
                // lấy thêm thông tin hình phạt tổng hợp
                tbl.Columns.Add("HINHPHAT_CHINH", typeof(string));
                if (tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        decimal biCanId = Convert.ToDecimal(row["BICAOID"].ToString());
                        DataTable hinhPhatTH = obj.C06_AHS_HINHPHAT_TONGHOP_GETBYID(biCanId);
                        foreach (DataRow hpRow in hinhPhatTH.Rows)
                        {
                            if (row["CAPXX_MA"].ToString() == "SO_THAM")
                            {

                                string tenHinhPhat = hpRow["HINHPHAT_ST"].ToString();
                                if (!string.IsNullOrEmpty(tenHinhPhat)) row["HINHPHAT_CHINH"] = tenHinhPhat;
                            }
                            else
                            {
                                string tenHinhPhat = hpRow["HINHPHAT_PT"].ToString();
                                if (!string.IsNullOrEmpty(tenHinhPhat)) row["HINHPHAT_CHINH"] = tenHinhPhat;
                            }
                        }

                    }
                }
            }
            else
            {
                //Chua dong bo
                tbl = obj.C06_AHS_SOTHAM_SEARCH_CHUADONGBO
                            (ddlLoaiAn.SelectedValue,
                            null,
                             DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
                // lấy thêm thông tin hình phạt tổng hợp
                tbl.Columns.Add("HINHPHAT_CHINH", typeof(string));
                if (tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        decimal biCanId = Convert.ToDecimal(row["BICAOID"].ToString());
                        DataTable hinhPhatTH = obj.C06_AHS_HINHPHAT_TONGHOP_GETBYID(biCanId);
                        foreach (DataRow hpRow in hinhPhatTH.Rows)
                        {
                            if (row["CAPXX_MA"].ToString() == "SO_THAM")
                            {

                                string tenHinhPhat = hpRow["HINHPHAT_ST"].ToString();
                                if (!string.IsNullOrEmpty(tenHinhPhat)) row["HINHPHAT_CHINH"] = tenHinhPhat;
                            }
                            else
                            {
                                string tenHinhPhat = hpRow["HINHPHAT_PT"].ToString();
                                if (!string.IsNullOrEmpty(tenHinhPhat)) row["HINHPHAT_CHINH"] = tenHinhPhat;
                            }
                        }

                    }
                }
            }

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            visibleDataGridAhs(syncStatus, page_size, tbl);
            //Xử lý logic lấy dữ liệu ở đây
        }
        void loadDataHNGD(int page_size, int pageindex, int count_all, DataTable tbl, string v_LOAIBAQD, string v_BAQD_id, string v_KHANGCAOQH)
        {
            ///Giữ nguyên logic của Hôn nhân gia đình chỉ tách hàm ra thôi
            DLQGC06_BL obj = new DLQGC06_BL();

            if (ddlTrangthaiDongBo.SelectedValue == "3")
            {
                //Bị thu hồi
                tbl = obj.GetAllPaging_Search_All_ThuHoi
                            (ddlLoaiAn.SelectedValue, v_LOAIBAQD, v_BAQD_id, v_KHANGCAOQH
                             , DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);
            }
            else if (ddlTrangthaiDongBo.SelectedValue == "2")
            {
                //Đã đồng bộ
                tbl = obj.GetAllPaging_Search_All_DaDongBO
                           (ddlLoaiAn.SelectedValue, v_LOAIBAQD, v_BAQD_id, v_KHANGCAOQH
                            , DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                           , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                           , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                           , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                           , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                           , pageindex, page_size);
            }
            else
            {
                //Chua dong bo
                tbl = obj.GetAllPaging_Search_All
                            (ddlLoaiAn.SelectedValue, v_LOAIBAQD, v_BAQD_id, v_KHANGCAOQH
                             , DropToaAn.SelectedValue, dropCapxx.SelectedValue, txtTenVuViec.Text.Trim(), txt_toidanh.Text.Trim()
                            , txtMaVuViec.Text.Trim(), txtBiCan.Text.Trim(), txtCCCD_SO.Text.Trim()
                            , txtSoQD.Text.Trim(), txtTuNgay.Text, txtDenNgay.Text.Trim()
                            , ddlThamphan.SelectedValue, ddlHTND_Thuky.SelectedValue
                            , ddlTrangthaiDongBo.SelectedValue, txt_NGAYGUI_TU.Text, txt_NGAYGUI_DEN.Text
                            , pageindex, page_size);


            }

            if (tbl.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"

                count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion "Xác định số lượng trang"
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }


            if (ddlTrangthaiDongBo.SelectedValue == "1")
            {
                //Chưa đồng bộ
                dgList_DaDB.Visible = dgList_Thuhoi.Visible = false;
                btnGuiDLC06.Visible = true;
                pn_thuhoi.Visible = false;
                //Load du lieu ban ghi chua dong bo
                dgList.Visible = true;
                dgList.PageSize = page_size;
                dgList.DataSource = tbl;
                dgList.DataBind();
            }
            else if (ddlTrangthaiDongBo.SelectedValue == "2")
            {
                //Đã đồng bộ
                btnGuiDLC06.Visible = false;
                //Tạm đóng khong cho dung nut thu hoi
                pn_thuhoi.Visible = true;
                //An chua dong bo va thu hoi
                dgList.Visible = dgList_Thuhoi.Visible = false;
                //Load du lieu ban ghi da dong bo
                dgList_DaDB.Visible = true;
                dgList_DaDB.PageSize = page_size;
                dgList_DaDB.DataSource = tbl;
                dgList_DaDB.DataBind();

            }
            else
            {
                // Bị Thu hồi
                btnGuiDLC06.Visible = false;
                dgList.Visible = dgList_DaDB.Visible = false;
                pn_thuhoi.Visible = false;
                //Load du lieu ban ghi bị thu hồi
                dgList_Thuhoi.Visible = true;
                dgList_Thuhoi.PageSize = page_size;
                dgList_Thuhoi.DataSource = tbl;
                dgList_Thuhoi.DataBind();

            }
        }
        void dataGridAllVisible(bool isVisible)
        {
            //ahsDgList_DB.Visible = ahsDgList_TH.Visible = ahsDgList_CDB.Visible = isVisible;
            dgList.Visible = dgList_DaDB.Visible = dgList_Thuhoi.Visible = isVisible;
            gvDanhSach.Visible = adsDgList_All.Visible = ahcDgList_All.Visible = aldDgList_All.Visible = aktDgList_All.Visible = isVisible;
        }
        void visibleDataGridAhs(string status, int page_size, DataTable tbl)
        {
            //if (status == "1")
            //{
            //    //Chưa đồng bộ
            //    ahsDgList_DB.Visible = ahsDgList_TH.Visible = false;
            //    btnGuiDLC06.Visible = true;
            //    pn_thuhoi.Visible = false;
            //    //Load du lieu ban ghi chua dong bo
            //    ahsDgList_CDB.Visible = true;
            //    ahsDgList_CDB.PageSize = page_size;
            //    ahsDgList_CDB.DataSource = tbl;
            //    ahsDgList_CDB.DataBind();
            //}
            //else if (status == "2")
            //{
            //    //Đã đồng bộ
            //    btnGuiDLC06.Visible = false;
            //    //Tạm đóng khong cho dung nut thu hoi
            //    pn_thuhoi.Visible = true;
            //    //An chua dong bo va thu hoi
            //    ahsDgList_CDB.Visible = ahsDgList_TH.Visible = false;
            //    //Load du lieu ban ghi da dong bo
            //    ahsDgList_DB.Visible = true;
            //    ahsDgList_DB.PageSize = page_size;
            //    ahsDgList_DB.DataSource = tbl;
            //    ahsDgList_DB.DataBind();

            //}
            //else
            //{
            //    // Bị Thu hồi
            //    btnGuiDLC06.Visible = false;
            //    ahsDgList_CDB.Visible = ahsDgList_DB.Visible = false;
            //    pn_thuhoi.Visible = false;
            //    //Load du lieu ban ghi bị thu hồi
            //    ahsDgList_TH.Visible = true;
            //    ahsDgList_TH.PageSize = page_size;
            //    ahsDgList_TH.DataSource = tbl;
            //    ahsDgList_TH.DataBind();

            //}
            if (status == "2") pn_thuhoi.Visible = true;
            else pn_thuhoi.Visible = false;
            gvDanhSach.Visible = true;
            gvDanhSach.DataSource = tbl;
            gvDanhSach.PageSize = page_size;
            gvDanhSach.DataBind();
        }
        protected void ahsDgList_CDB_ItemCommand(object source, DataGridCommandEventArgs e)
        {

        }
        protected void ahsDgList_CDB_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            // Kiểm tra loại item (DataItem mới thực sự là data)
            //if (e.Item.ItemType == ListItemType.Item ||
            //    e.Item.ItemType == ListItemType.AlternatingItem)
            //{
            //    // Lấy data gốc từ DataRowView
            //    DataRowView row = (DataRowView)e.Item.DataItem;
            //    string value = row["ColumnName"].ToString();

            //    // Ví dụ: set text cho một label trong grid
            //    Label lbl = (Label)e.Item.FindControl("lblStatus");
            //    if (lbl != null)
            //    {
            //        lbl.Text = value == "1" ? "Active" : "Inactive";
            //    }
        }
        protected void ahsDgList_DB_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(CurrID, out success, out fail);
                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string[] split = IDview.Split(',');
                    decimal biCanId = Convert.ToDecimal(split[0]);
                    decimal vuAnId = Convert.ToDecimal(split[1]);

                    string capxx = split[2];
                    decimal id = Convert.ToDecimal(split[3]);
                    string url = $"/QLAN/C06/pToiDanh.aspx?aID={vuAnId}&bID={biCanId}&capxx={capxx}&ID={id}";
                    string script = $"PopupCenter('{url}', 'Tội Danh', 950, 450);";
                    //string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo.aspx?vid=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script, true);
                    break;
            }
        }
        protected void ahsDgList_DB_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_AHS_BL oBL = new DLQGC06_AHS_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");


                if (rowView["C06_AHS_ID"] + "" != "")
                {
                    string vDongBoID = (rowView["C06_AHS_ID"] + "").ToString();

                    // Hủy chuyển
                    // Lấy dữ liệu từ DB
                    DataTable tbl = oBL.GetDulieuChon_DaDongBO(vDongBoID);
                    if (tbl.Rows.Count > 0)
                    {
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataRow row = tbl.Rows[0];
                        if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                        {
                            if (row["TRANGTHAIAHS"] + "" == "THU_HOI")
                                lbtHuyChuyen.Visible = false;
                            else
                                lbtHuyChuyen.Visible = true;
                        }
                    }
                    //Xem lich su chuyen khi có nhiều hơn 1 bản ghi
                    //DataTable tblView = oBL.GetDulieu_LichSuChuyen(vDongBoID);
                    //if (tblView.Rows.Count > 1)
                    //  lbtView.Visible = true;
                    //else
                    //  lbtView.Visible = false;
                }
            }
            //DLQGC06_BL oBL = new DLQGC06_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;


                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");


                lbtView.Visible = true;
            }
        }
        protected void ahsDgList_ThuHoi_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "GuiLai":
                    string CurrID = e.CommandArgument.ToString();
                    GuiLai(CurrID);
                    break;
                case "View": // không xử lý View để sau
                    //string IDview = e.CommandArgument.ToString();
                    //string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo.aspx?vid=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                    //System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }

        protected void ahsDgList_ThuHoi_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            //DLQGC06_BL oBL = new DLQGC06_BL();
            //if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            //{
            //    DataRowView rowView = (DataRowView)e.Item.DataItem;

            //    LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
            //    LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");


            //    if (rowView["ID"] + "" != "")
            //    {
            //        string vDongBoID = (rowView["ID"] + "").ToString();

            //        //Xem lich su chuyen khi có nhiều hơn 1 bản ghi
            //        DataTable tblView = oBL.GetDulieu_LichSuChuyen(vDongBoID);
            //        if (tblView.Rows.Count > 1)
            //            lbtView.Visible = true;
            //        else
            //            lbtView.Visible = false;
            //    }
            //}
        }
        protected void btnThuHoi_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            string loaiAn = ddlLoaiAn.SelectedValue;
            if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH) // Nếu chọn là HNGD giữ nguyên logic
            {
                DLQGC06_BL oBL = new DLQGC06_BL();
                decimal vCount = 0;
                foreach (DataGridItem Item in dgList_DaDB.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string vDongBoID = chkChon.ToolTip;

                        // Lấy dữ liệu từ DB
                        DataTable tbl = oBL.GetDulieuChon_DaDongBO(vDongBoID);
                        if (tbl.Rows.Count > 0)
                        {
                            //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi

                            DataRow row = tbl.Rows[0];
                            string vTrangThaiDongBo = row["TRANG_THAI_DONGBO"] + "";
                            if (vTrangThaiDongBo == "1")
                            {
                                C06_TOAAN_TINHTRANGHONNHAN obj = new C06_TOAAN_TINHTRANGHONNHAN
                                {
                                    LOAIAN_ID = row["LOAIAN_ID"] + "",
                                    LOAI_AN_TEN = row["LOAI_AN_TEN"] + "",
                                    LOAI_BAQD = row["LOAIBAQD"] + "",
                                    MAVUVIEC = row["MavuAn"] + "",
                                    TenVuAn = row["TenVuAn"] + "",
                                    DONID = row["DONID"] + "",
                                    BAQD_ID = row["BAQD_ID"] + "",
                                    SO_BAN_AN = row["SO_BAN_AN"] + "",
                                    NGAY_RA_BAN_AN = row["NGAY_RA_BAN_AN"] + "",
                                    NGAY_HIEU_LUC_BA = row["NGAY_HIEU_LUC_BA"] + "",
                                    DON_VI_RA_BAN_AN_ID = row["DON_VI_RA_BAN_AN_ID"] + "",
                                    DON_VI_RA_BAN_AN_TEN = row["DON_VI_RA_BAN_AN_TEN"] + "",
                                    NGAY_NHAN_NGUYEN_DON = row["NGAY_NHAN_NGUYEN_DON"] + "",
                                    NGUYENDON_ID = row["NGUYENDON_ID"] + "",
                                    BIDON_ID = row["BIDON_ID"] + "",
                                    THULY = row["THULY"] + "",
                                    NGAY_NHAN_BI_DON = row["NGAY_NHAN_BI_DON"] + "",
                                    HO_TEN_NGUYEN_DON = row["HO_TEN_NGUYEN_DON"] + "",
                                    SO_GIAY_TO_NGUYEN_DON = row["SO_GIAY_TO_NGUYEN_DON"] + "",
                                    NGAY_SINH_NGUYEN_DON = row["NGAY_SINH_NGUYEN_DON"] + "",
                                    QUOC_TICH_NGUYEN_DON = row["QUOC_TICH_NGUYEN_DON"] + "",
                                    HO_TEN_BI_DON = row["HO_TEN_BI_DON"] + "",
                                    SO_GIAY_TO_BI_DON = row["SO_GIAY_TO_BI_DON"] + "",
                                    NGAY_SINH_BI_DON = row["NGAY_SINH_BI_DON"] + "",
                                    QUOC_TICH_BI_DON = row["QUOC_TICH_BI_DON"] + "",
                                    TRANG_THAI_TTHN = row["TRANG_THAI_TTHN"] + "",
                                    trangThaiBanGhi = "2",
                                    ghiChu = "Thu hồi với lý do :" + txtLyDoThuHoi.Text,
                                    CAPXX = row["CAPXX"] + "",
                                    KHANGCAOQH = row["KHANGCAOQH"] + "",
                                    TRANG_THAI_DONGBO = "0",
                                    NGAYGUI = DateTime.Now,
                                    TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    STATUS = "1",
                                    trangThaiXacThucNguyenDon = row["trangThaiXacThucNguyenDon"] + "",
                                    trangThaiXacThucBiDon = row["trangThaiXacThucBiDon"] + "",
                                    maDinhDanhBanAn = row["maDinhDanhBanAn"] + "",
                                    loaiViec = row["loaiViec"] + ""
                                };
                                //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                                if (oBL.ThuHoi_C06_TOAAN_TINHTRANGHONNHAN(vDongBoID))
                                {
                                    //Insert bản ghi mới là thu hồi
                                    //Add các doi tuong vao mang de thuc hien insert
                                    if (oBL.InsertC06_TOAAN_TINHTRANGHONNHAN(obj))
                                    {
                                        vCount = vCount + 1;
                                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                                    }
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);

                                }

                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);

                            }


                        }

                    }
                }
                if (vCount > 0)
                {
                    txtLyDoThuHoi.Text = "";
                    hddPageIndex.Value = "1";
                    Load_Data();
                }
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            {
                DLQGC06_ADS_BL oBL = new DLQGC06_ADS_BL();
                decimal vCount = 0;
                foreach (DataGridItem Item in adsDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');
                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        string vAdsId = array[4];
                        // Lấy dữ liệu từ DB
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataTable tbl = oBL.C06_ADS_SEARCH_BY_ID(vAdsId); // lấy bản ghi chưa đồng bộ sang jobshared
                        if (tbl.Rows.Count > 0)
                        {
                            DataRow row = tbl.Rows[0];
                            string vTrangThaiDongBo = row["TRANGTHAIJOBSHARE"] + "";
                            if (vTrangThaiDongBo == "1")
                            {
                                //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                                if (oBL.ThuHoi_C06_TOAAN_DANSU(vAdsId, "Thu hồi với lý do :" + txtLyDoThuHoi.Text, "1"))
                                {
                                    //Insert bản ghi mới là thu hồi
                                    //Add các doi tuong vao mang de thuc hien insert
                                    //if (oBL.C06_TOAAN_DANSU_INSERT(model))
                                    //{
                                    //    vCount = vCount + 1;
                                    //}

                                    var VUANID = Convert.ToDecimal(row["VUANID"].ToString());
                                    var DUONGSUID = Convert.ToDecimal(row["DUONGSUID"].ToString());

                                    vCount = vCount + 1;
                                    oBL.C06_ADS_ADD_HISTORY(Convert.ToDecimal(vAdsId), txtLyDoThuHoi.Text, JsonConvert.SerializeObject(tbl, Formatting.Indented), username, VUANID, DUONGSUID, "Thu hồi"); //Insert dữ liệu vào bảng history
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                                }
                            }
                            else // Nếu chưa đồng bộ thì hủy chuyển
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);
                        }

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                    }
                    if (vCount > 0)
                    {
                        txtLyDoThuHoi.Text = "";
                        hddPageIndex.Value = "1";
                    }
                }
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            {
                DLQGC06_AHC_BL oBL = new DLQGC06_AHC_BL();
                decimal vCount = 0;
                foreach (DataGridItem Item in ahcDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');
                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        string vAhcId = array[4];
                        // Lấy dữ liệu từ DB
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataTable tbl = oBL.C06_AHC_SEARCH_BY_ID(vAhcId); // lấy bản ghi chưa đồng bộ sang jobshared
                        if (tbl.Rows.Count > 0)
                        {
                            DataRow row = tbl.Rows[0];
                            string vTrangThaiDongBo = row["TRANGTHAIJOBSHARE"] + "";
                            if (vTrangThaiDongBo == "1")
                            {
                                //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                                if (oBL.ThuHoi_C06_TOAAN_HANHCHINH(vAhcId, "Thu hồi với lý do :" + txtLyDoThuHoi.Text, "1"))
                                {
                                    var VUANID = Convert.ToDecimal(row["VUANID"].ToString());
                                    var DUONGSUID = Convert.ToDecimal(row["DUONGSUID"].ToString());

                                    //Insert bản ghi mới là thu hồi
                                    //Add các doi tuong vao mang de thuc hien insert
                                    //if (oBL.C06_TOAAN_HANHCHINH_INSERT(obj))
                                    //{
                                    //    vCount = vCount + 1;
                                    //}
                                    vCount = vCount + 1;
                                    oBL.C06_AHC_ADD_HISTORY(Convert.ToDecimal(vAhcId), txtLyDoThuHoi.Text, JsonConvert.SerializeObject(tbl, Formatting.Indented), username, VUANID, DUONGSUID, "Thu hồi"); //Insert dữ liệu vào bảng history
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                                }
                            }
                            else // Nếu chưa đồng bộ thì hủy chuyển
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);

                        }

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                    }
                    if (vCount > 0)
                    {
                        txtLyDoThuHoi.Text = "";
                        hddPageIndex.Value = "1";

                    }
                }
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            {
                DLQGC06_ALD_BL oBL = new DLQGC06_ALD_BL();
                decimal vCount = 0;
                foreach (DataGridItem Item in aldDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');
                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        string vAdsId = array[4];
                        // Lấy dữ liệu từ DB
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataTable tbl = oBL.C06_ALD_SEARCH_BY_ID(vAdsId); // lấy bản ghi chưa đồng bộ sang jobshared
                        if (tbl.Rows.Count > 0)
                        {
                            DataRow row = tbl.Rows[0];
                            string vTrangThaiDongBo = row["TRANGTHAIJOBSHARE"] + "";
                            if (vTrangThaiDongBo == "1")
                            {
                                //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                                if (oBL.ThuHoi_C06_TOAAN_LAODONG(vAdsId, "Thu hồi với lý do :" + txtLyDoThuHoi.Text, "1"))
                                {
                                    var VUANID = Convert.ToDecimal(row["VUANID"].ToString());
                                    var DUONGSUID = Convert.ToDecimal(row["DUONGSUID"].ToString());

                                    //Insert bản ghi mới là thu hồi
                                    //Add các doi tuong vao mang de thuc hien insert
                                    //if (oBL.C06_TOAAN_LAODONG_INSERT(obj))
                                    //{
                                    //    vCount = vCount + 1;
                                    //}

                                    vCount = vCount + 1;
                                    oBL.C06_ALD_ADD_HISTORY(Convert.ToDecimal(vAdsId), txtLyDoThuHoi.Text, JsonConvert.SerializeObject(tbl, Formatting.Indented), username, VUANID, DUONGSUID, "Thu hồi"); //Insert dữ liệu vào bảng history
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);

                                }
                            }
                            else // Nếu chưa đồng bộ thì hủy chuyển
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);

                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);

                        }

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                    }
                    if (vCount > 0)
                    {
                        txtLyDoThuHoi.Text = "";
                        hddPageIndex.Value = "1";

                    }
                }
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            {
                DLQGC06_AKT_BL oBL = new DLQGC06_AKT_BL();
                decimal vCount = 0;
                foreach (DataGridItem Item in aktDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');
                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        string vAdsId = array[4];
                        // Lấy dữ liệu từ DB
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataTable tbl = oBL.C06_AKT_SEARCH_BY_ID(vAdsId); // lấy bản ghi chưa đồng bộ sang jobshared
                        if (tbl.Rows.Count > 0)
                        {
                            DataRow row = tbl.Rows[0];
                            string vTrangThaiDongBo = row["TRANGTHAIJOBSHARE"] + "";
                            if (vTrangThaiDongBo == "1")
                            {
                                //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                                if (oBL.ThuHoi_C06_TOAAN_KDTM(vAdsId, "Thu hồi với lý do :" + txtLyDoThuHoi.Text, "1"))
                                {
                                    var VUANID = Convert.ToDecimal(row["VUANID"].ToString());
                                    var DUONGSUID = Convert.ToDecimal(row["DUONGSUID"].ToString());

                                    //Insert bản ghi mới là thu hồi
                                    //Add các doi tuong vao mang de thuc hien insert
                                    //if (oBL.C06_TOAAN_KDTM_INSERT(obj))
                                    //{
                                    //    vCount = vCount + 1;
                                    //}

                                    vCount = vCount + 1;
                                    oBL.C06_AKT_ADD_HISTORY(Convert.ToDecimal(vAdsId), txtLyDoThuHoi.Text, JsonConvert.SerializeObject(tbl, Formatting.Indented), username, VUANID, DUONGSUID, "Thu hồi"); //Insert dữ liệu vào bảng history
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);

                                }
                            }
                            else // Nếu chưa đồng bộ thì hủy chuyển
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);

                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);

                        }

                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                    }
                    if (vCount > 0)
                    {
                        txtLyDoThuHoi.Text = "";
                        hddPageIndex.Value = "1";

                    }
                }
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU) //Nếu chọn là Án Hình Sự
            {
                DLQGC06_AHS_BL oBL = new DLQGC06_AHS_BL();
                decimal vCount = 0;
                foreach (GridViewRow Item in gvDanhSach.Rows)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                        string vRowString = chkChon.ToolTip;
                        string vAHSID = vRowString.Split(',')[3];
                        // Lấy dữ liệu từ DB
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataTable tbl = oBL.GetDulieuChon_DaDongBO(vAHSID); // lấy bản ghi chưa đồng bộ sang jobshared
                        if (tbl.Rows.Count > 0)
                        {
                            DataRow row = tbl.Rows[0];
                            string vTrangThaiDongBo = row["TRANGTHAIJOBSHARE"] + "";
                            if (vTrangThaiDongBo == "1")
                            {//Nếu đã đồng bộ thì cho thu hồi

                                //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0 -- có bản ghi mới thay thế và trangthaiahs = 'THU_HOI'
                                if (oBL.ThuHoi_C06_TOAAN_HINHSU(vAHSID, "Thu hồi với lý do :" + txtLyDoThuHoi.Text, Convert.ToDecimal(row["bicanid"].ToString()),
                                    Convert.ToDecimal(row["vuanid"].ToString()), Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                                {
                                    C06_TOAAN_HINHSU_MODEL oldObj = new C06_TOAAN_HINHSU_MODEL()
                                    {
                                        SOBANANORQD = row["sobananorqd"].ToString(),
                                        NGAYRABANAN = row["ngayrabanan"].ToString(),
                                        MADONVIRABANAN = row["madonvirabanan"].ToString(),
                                        TENDONVIRABANAN = row["tendonvirabanan"].ToString(),
                                        BQD = row["bqd"].ToString(),
                                        DSTOIDANH = row["dstoidanh"].ToString(),
                                        MAHINHPHATCHINH = row["mahinhphatchinh"].ToString(),
                                        TENHINHPHATCHINH = row["tenhinhphatchinh"].ToString(),
                                        THAMSOHINHPHATCHINH = row["thamsohinhphatchinh"].ToString(),
                                        DSHINHPHATBOSUNG = row["dshinhphatbosung"].ToString(),
                                        NGAYHIEULUCBA = row["ngayhieulucba"].ToString(),
                                        HOTENBICAO = row["hotenbicao"].ToString(),
                                        SOGIAYTOBICAO = row["sogiaytobicao"].ToString(),
                                        NGAYSINHBICAO = row["NGAYSINHBICAO"].ToString(),
                                        MAQUOCTICHBICAO = row["maquoctichbicao"].ToString(),
                                        TENQUOCTICHBICAO = row["tenquoctichbicao"].ToString(),
                                        MATHANHPHOTINHBICAO = row["mathanhphotinhbicao"].ToString(),
                                        TENTHANHPHOTINHBICAO = row["tenthanhphotinhbicao"].ToString(),
                                        MAQUANHUYENBICAO = row["maquanhuyenbicao"].ToString(),
                                        TENQUANHUYENBICAO = row["tenquanhuyenbicao"].ToString(),
                                        MAPHUONGXABICAO = row["maphuongxabicao"].ToString(),
                                        TENPHUONGXABICAO = row["tenphuongxabicao"].ToString(),
                                        DIACHIBICAO = row["diachibicao"].ToString(),
                                        GHICHU = "Thu hồi với lý do :" + txtLyDoThuHoi.Text,
                                        CAPXX = row["CAPXX"].ToString(),
                                        VUANID = Convert.ToDecimal(row["vuanid"].ToString()),
                                        BICANID = Convert.ToDecimal(row["bicanid"].ToString()),
                                        TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        TENVUAN = row["tenvuan"].ToString(),
                                        THULY = row["thuly"].ToString(),
                                        HinhPhatTh = tbl.Rows[0]["HINHPHAT_TH"].ToString(),
                                        ToiDanhTH = tbl.Rows[0]["TOIDANH_TH"].ToString(),
                                        ThamPhan = tbl.Rows[0]["THAMPHAN"].ToString(),
                                        TRANGTHAIAHS = tbl.Rows[0]["TRANGTHAIAHS"].ToString()
                                    };

                                    oBL.C06_AHS_ADD_HISTORY(Convert.ToDecimal(vAHSID), txtLyDoThuHoi.Text, JsonConvert.SerializeObject(oldObj), username
                                        , Convert.ToDecimal(row["bicanid"].ToString()), Convert.ToDecimal(row["vuanid"].ToString()), "Thu Hồi"); //Insert dữ liệu vào bảng history
                                    vCount = vCount + 1;
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                                }
                            }
                            else // Nếu chưa đồng bộ thì hủy chuyển
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);
                            }
                        }
                    }
                    if (vCount > 0)
                    {
                        txtLyDoThuHoi.Text = "";
                        hddPageIndex.Value = "1";

                    }
                }
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi " + vCount + " thành công!');", true);
                Load_Data();
            }

        }
        protected void btnGuiDLC06_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            string loaiAn = ddlLoaiAn.SelectedValue;
            decimal vCount = 0;
            if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH) // Nếu là HNGD giữ nguyên logic cũ
            {
                DLQGC06_BL oBL = new DLQGC06_BL();
                //List<C06_TOAAN_TINHTRANGHONNHAN> objLs = new List<C06_TOAAN_TINHTRANGHONNHAN>();

                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');

                        if (array.Length >= 3)
                        {
                            string loaian = array[0];
                            string loaiBaQd = array[1];
                            string BAQD_id = array[2];
                            string isKHANGCAOQH = array[3];

                            // Lấy dữ liệu từ DB
                            DataTable tbl = oBL.GetAllPaging_Search_All
                                (loaian, loaiBaQd, BAQD_id, isKHANGCAOQH
                                , DropToaAn.SelectedValue, null, null, null
                                , null, null, null
                                , null, null, null
                                , ddlThamphan.SelectedValue, null
                                , null, null, null
                                , 1, 20);

                            if (tbl.Rows.Count > 0)
                            {
                                //Kiem tra xem duong su da duoc Lam sach chua, neu chua thi bat phải xac thuc

                                DataRow row = tbl.Rows[0];

                                string vND_XACTHUC_DLDCQG = row["ND_XACTHUC_DLDCQG"] + "";
                                string vBD_XACTHUC_DLDCQG = row["BD_XACTHUC_DLDCQG"] + "";
                                string vMaDongBO = oBL.GetRandomMaDongBo();
                                if (vND_XACTHUC_DLDCQG == "1" && vBD_XACTHUC_DLDCQG == "1")
                                {
                                    C06_TOAAN_TINHTRANGHONNHAN obj = new C06_TOAAN_TINHTRANGHONNHAN
                                    {
                                        LOAIAN_ID = row["LOAIAN_ID"] + "",
                                        LOAI_AN_TEN = row["LOAI_AN_TEN"] + "",
                                        LOAI_BAQD = row["LOAIBAQD"] + "",
                                        MAVUVIEC = row["MavuAn"] + "",
                                        TenVuAn = row["TenVuAn"] + "",
                                        DONID = row["DONID"] + "",
                                        BAQD_ID = row["BAQD_ID"] + "",
                                        SO_BAN_AN = row["SO_BAN_AN"] + "",
                                        NGAY_RA_BAN_AN = row["NGAY_RA_BAN_AN"] + "",
                                        NGAY_HIEU_LUC_BA = row["NGAY_HIEU_LUC_BA"] + "",
                                        DON_VI_RA_BAN_AN_ID = row["DON_VI_RA_BAN_AN_ID"] + "",
                                        DON_VI_RA_BAN_AN_TEN = row["DON_VI_RA_BAN_AN_TEN"] + "",
                                        NGAY_NHAN_NGUYEN_DON = row["NGAY_NHAN_NGUYEN_DON"] + "",
                                        NGAY_NHAN_BI_DON = row["NGAY_NHAN_BI_DON"] + "",
                                        NGUYENDON_ID = row["NGUYENDON_ID"] + "",
                                        BIDON_ID = row["BIDON_ID"] + "",
                                        THULY = row["THULY"] + "",
                                        HO_TEN_NGUYEN_DON = row["HO_TEN_NGUYEN_DON"] + "",
                                        SO_GIAY_TO_NGUYEN_DON = row["SO_GIAY_TO_NGUYEN_DON"] + "",
                                        NGAY_SINH_NGUYEN_DON = row["NGAY_SINH_NGUYEN_DON"] + "",
                                        QUOC_TICH_NGUYEN_DON = row["QUOC_TICH_NGUYEN_DON"] + "",
                                        HO_TEN_BI_DON = row["HO_TEN_BI_DON"] + "",
                                        SO_GIAY_TO_BI_DON = row["SO_GIAY_TO_BI_DON"] + "",
                                        NGAY_SINH_BI_DON = row["NGAY_SINH_BI_DON"] + "",
                                        QUOC_TICH_BI_DON = row["QUOC_TICH_BI_DON"] + "",
                                        TRANG_THAI_TTHN = row["TRANG_THAI_TTHN"] + "",
                                        trangThaiBanGhi = row["trangThaiBanGhi"] + "",
                                        ghiChu = row["ghiChu"] + "",
                                        CAPXX = row["CAPXX"] + "",
                                        KHANGCAOQH = row["KHANGCAOQH"] + "",
                                        TRANG_THAI_DONGBO = "0",
                                        NGAYGUI = DateTime.Now,
                                        TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        STATUS = "1",
                                        trangThaiXacThucNguyenDon = vND_XACTHUC_DLDCQG,
                                        trangThaiXacThucBiDon = vBD_XACTHUC_DLDCQG,
                                        maDinhDanhBanAn = vMaDongBO,
                                        GIOI_TINH_NGUYEN_DON = row["GIOI_TINH_NGUYENDON"] + "",
                                        SO_CMND_NGUYEN_DON = row["SO_CMND_NGUYEN_DON"] + "",
                                        GIOI_TINH_BI_DON = row["GIOI_TINH_BI_DON"] + "",
                                        SO_CMND_BI_DON = row["SO_CMND_BI_DON"] + "",
                                        maDonViNhanBanAn = row["maDonViNhanBanAn"] + "",
                                        tenDonViNhanBanAn = row["tenDonViNhanBanAn"] + "",
                                        soGiayCNKH = row["soGiayCNKH"] + "",
                                        loaiViec = "1"

                                    };
                                    //Kiem tra ngay hieu luc cua ban an với án 
                                    if (row["NGAY_HIEU_LUC_BA"] + "" == "" && row["CAPXX"] + "" == "Sơ Thẩm")
                                    {
                                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Nhập ngày hiệu lực của BA/QD trước khi đồng bộ');", true);
                                        if (vCount > 0)
                                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
                                        break;
                                    }
                                    else
                                    {
                                        //Add các doi tuong vao mang de thuc hien insert
                                        if (oBL.InsertC06_TOAAN_TINHTRANGHONNHAN(obj))
                                        {
                                            vCount = vCount + 1;
                                        }
                                    }
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bạn cần xác thực thông tin của Đương sự!');", true);
                                }


                            }
                        }
                    }
                }
                hddPageIndex.Value = "1";
                Load_Data();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
            }
            // Án dân sự
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            {
                DLQGC06_ADS_BL adsBl = new DLQGC06_ADS_BL();
                foreach (DataGridItem Item in adsDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');

                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        DataTable tbl = adsBl.C06_ADS_DUONGSU_CDB_GETBY(vDuongSuId, capxx, sobananorqd, loaiBanAnQd);
                        if (tbl.Rows.Count > 0)
                        {
                            var model = new C06_TOAAN_DANSU()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIADS = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            adsBl.C06_TOAAN_DANSU_INSERT(model);
                            //dt.C06_TOAAN_DANSU.Add(model);
                            //dt.SaveChanges();
                            vCount = vCount + 1;
                        }
                    }
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            {
                DLQGC06_AHC_BL ahcBl = new DLQGC06_AHC_BL();
                foreach (DataGridItem Item in ahcDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');


                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        DataTable tbl = ahcBl.C06_AHC_DUONGSU_CDB_GETBY(vDuongSuId, capxx, sobananorqd, loaiBanAnQd);
                        if (tbl.Rows.Count > 0)
                        {
                            var model = new C06_TOAAN_HANHCHINH()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIAHC = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            ahcBl.C06_TOAAN_HANHCHINH_INSERT(model);
                            //dt.C06_TOAAN_HANHCHINH.Add(model);
                            //dt.SaveChanges();
                            vCount = vCount + 1;
                        }
                    }
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            {
                DLQGC06_ALD_BL aldBl = new DLQGC06_ALD_BL();
                foreach (DataGridItem Item in aldDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');


                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        DataTable tbl = aldBl.C06_ALD_DUONGSU_CDB_GETBY(vDuongSuId, capxx, sobananorqd, loaiBanAnQd);
                        if (tbl.Rows.Count > 0)
                        {
                            var model = new C06_TOAAN_LAODONG()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIALD = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            aldBl.C06_TOAAN_LAODONG_INSERT(model);
                            vCount = vCount + 1;
                        }
                    }
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            {
                DLQGC06_AKT_BL aktBl = new DLQGC06_AKT_BL();
                foreach (DataGridItem Item in aktDgList_All.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon != null && chkChon.Checked)
                    {
                        string input = chkChon.ToolTip;
                        string[] array = input.Split(',');


                        decimal vDuongSuId = Convert.ToDecimal(array[0]);
                        string capxx = array[1];
                        string loaiBanAnQd = array[2];
                        string sobananorqd = array[3];
                        DataTable tbl = aktBl.C06_AKT_DUONGSU_CDB_GETBY(vDuongSuId, capxx, sobananorqd, loaiBanAnQd);
                        if (tbl.Rows.Count > 0)
                        {
                            var model = new C06_TOAAN_KDTM()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIAKDTM = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            aktBl.C06_TOAAN_KDTM_INSERT(model);
                            vCount = vCount + 1;
                        }
                    }
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)
            {
                DLQGC06_AHS_BL ahsBl = new DLQGC06_AHS_BL();
                List<string> biCanIds = new List<string>();
                foreach (GridViewRow Item in gvDanhSach.Rows)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");

                    if (chkChon != null && chkChon.Checked)
                    {
                        string input = chkChon.ToolTip;
                        string bicanInfo = input.Trim();
                        string[] split = bicanInfo.Split(',');

                        decimal vBiCanId = Convert.ToDecimal(split[0]);
                        string capxx = split[1];
                        string loaiBanAnQd = split[2];
                        DataTable tbl = ahsBl.C06_AHS_BICAN_GETBYID(vBiCanId, capxx, loaiBanAnQd);
                        if (tbl.Rows.Count > 0)
                        {
                            var model = new C06_TOAAN_HINHSU_MODEL()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                BQD = tbl.Rows[0]["BQD"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENBICAO = tbl.Rows[0]["HOTENBICAO"].ToString(),
                                SOGIAYTOBICAO = tbl.Rows[0]["SOGIAYTOBICAO"].ToString(),
                                NGAYSINHBICAO = tbl.Rows[0]["NGAYSINHBICAO"].ToString(),
                                MAQUOCTICHBICAO = tbl.Rows[0]["MAQUOCTICHBICAO"].ToString(),
                                TENQUOCTICHBICAO = tbl.Rows[0]["TENQUOCTICHBICAO"].ToString(),
                                MATHANHPHOTINHBICAO = tbl.Rows[0]["MATHANHPHOTINHBICAO"].ToString(),
                                TENTHANHPHOTINHBICAO = tbl.Rows[0]["TENTHANHPHOTINHBICAO"].ToString(),
                                MAQUANHUYENBICAO = tbl.Rows[0]["MAQUANHUYENBICAO"].ToString(),
                                TENQUANHUYENBICAO = tbl.Rows[0]["TENQUANHUYENBICAO"].ToString(),
                                MAPHUONGXABICAO = tbl.Rows[0]["MAPHUONGXABICAO"].ToString(),
                                TENPHUONGXABICAO = tbl.Rows[0]["TENPHUONGXABICAO"].ToString(),
                                DIACHIBICAO = tbl.Rows[0]["DIACHIBICAO"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                BICANID = vBiCanId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX"].ToString(),
                                HinhPhatTh = tbl.Rows[0]["HINHPHAT_TH"].ToString(),
                                ToiDanhTH = tbl.Rows[0]["TOIDANH_TH"].ToString(),
                                ThamPhan = tbl.Rows[0]["THAMPHAN"].ToString()
                            };
                            DataTable toiDanh = ahsBl.c06_ahs_dongbo_get_toidanh(vBiCanId, capxx, loaiBanAnQd);

                            if (toiDanh.Rows.Count > 0)
                            {
                                List<ToiDanhModel> toiDanhs = new List<ToiDanhModel>();
                                foreach (DataRow row in toiDanh.Rows)
                                {
                                    var item = new ToiDanhModel()
                                    {
                                        maToiDanh = row["ID"].ToString(),
                                        tenToiDanh = row["TENTOIDANH"].ToString()
                                    };
                                    // Lấy danh sách hình phạt
                                    DataTable dsHinhPhatTbl = ahsBl.c06_ahs_toidanh_hinhphat_getbyid(vBiCanId,
                                        Convert.ToDecimal(item.maToiDanh), capxx, loaiBanAnQd, "1");
                                    List<HinhPhatModel> dsHinhPhats = new List<HinhPhatModel>();
                                    if (dsHinhPhatTbl.Rows.Count > 0)
                                    {
                                        foreach (DataRow hp in dsHinhPhatTbl.Rows)
                                        {
                                            var hinhPhatItem = new HinhPhatModel()
                                            {
                                                maHinhPhat = hp["MAHINHPHAT"].ToString(),
                                                tenHinhPhat = hp["TENHINHPHAT"].ToString(),
                                                thamSoHinhPhat = thamSoHinhPhat(hp),
                                                hinhPhatChinh = hp["ISCHANGE"].ToString() == "0" ? 1 : 0 // Nếu ISCHANGE = "0" là hpc; "1" là hpbs
                                            };
                                            dsHinhPhats.Add(hinhPhatItem);
                                        }
                                    }
                                    item.dSachHinhPhat = dsHinhPhats;
                                    toiDanhs.Add(item);
                                }
                                string toiDanhJson = JsonConvert.SerializeObject(toiDanhs, Formatting.None);
                                model.DSTOIDANH = toiDanhJson;
                            }
                            //DataTable hpc = ahsBl.c06_ahs_hinhphat_getbyid(vBiCanId, capxx, loaiBanAnQd, "1"); //Lấy hình phạt chính
                            //if (hpc.Rows.Count > 0)
                            //{
                            //    model.MAHINHPHATCHINH = hpc.Rows[0]["MAHINHPHAT"].ToString();
                            //    model.TENHINHPHATCHINH = hpc.Rows[0]["TENHINHPHAT"].ToString();
                            //    model.THAMSOHINHPHATCHINH = thamSoHinhPhat(hpc.Rows[0]);
                            //}
                            //DataTable hpbs = ahsBl.c06_ahs_hinhphat_getbyid(vBiCanId, capxx, loaiBanAnQd, "0"); // Lấy hình phạt bổ sung
                            //var dsHinhPhatBoSung = new List<HinhPhatModel>();
                            //if (hpbs.Rows.Count > 0)
                            //{
                            //    foreach (DataRow row in hpbs.Rows)
                            //    {
                            //        var item = new HinhPhatModel()
                            //        {
                            //            maHinhPhat = row["MAHINHPHAT"].ToString(),
                            //            tenHinhPhat = row["TENHINHPHAT"].ToString(),
                            //            thamSoHinhPhat = thamSoHinhPhat(row)
                            //        };
                            //        dsHinhPhatBoSung.Add(item);
                            //    }
                            //}
                            //if (dsHinhPhatBoSung.Count > 0)
                            //    model.DSHINHPHATBOSUNG = JsonConvert.SerializeObject(dsHinhPhatBoSung, Formatting.Indented);
                            // THực hiện insert bản ghi
                            ahsBl.C06_TOAAN_HINHSU_INSERT(model); // Thêm mới cho trường hợp Gửi Đồng Bộ
                            vCount = vCount + 1;
                        }

                    }
                }

                hddPageIndex.Value = "1";
                Load_Data();

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert(' Đẩy thành công " + vCount + " bản ghi');", true);
            }

            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void btnHuyChuyenC06_Click(object sender, EventArgs e)
        {
            // xử lý lấy danh sách theo loại án
            decimal vCountSuccess = 0;
            decimal vCountFail = 0; ;
            string loaiAn = ddlLoaiAn.SelectedValue;
            switch (loaiAn)
            {
                case ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU:
                    foreach (GridViewRow Item in gvDanhSach.Rows)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null && chkChon.Checked)
                        {
                            string input = chkChon.ToolTip;
                            string[] array = input.Split(',');
                            decimal vDuongSuId = Convert.ToDecimal(array[0]);
                            string capxx = array[1];
                            string loaiBanAnQd = array[2];
                            string idDongBo = array[3];
                            decimal success = 0;
                            decimal fail = 0;
                            HuyChuyen(idDongBo, out success, out fail);
                            vCountSuccess = vCountSuccess + success;
                            vCountFail = vCountFail + fail;
                        }
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_DANSU:
                    foreach (DataGridItem Item in adsDgList_All.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null && chkChon.Checked)
                        {
                            string input = chkChon.ToolTip;
                            string[] array = input.Split(',');
                            decimal vDuongSuId = Convert.ToDecimal(array[0]);
                            string capxx = array[1];
                            string loaiBanAnQd = array[2];
                            string sobananorqd = array[3];
                            string idDongBo = array[4];
                            decimal success = 0;
                            decimal fail = 0;
                            HuyChuyen(idDongBo, out success, out fail);
                            vCountSuccess = vCountSuccess + success;
                            vCountFail = vCountFail + fail;
                        }
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH:
                    foreach (DataGridItem Item in ahcDgList_All.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null && chkChon.Checked)
                        {
                            string input = chkChon.ToolTip;
                            string[] array = input.Split(',');
                            decimal vDuongSuId = Convert.ToDecimal(array[0]);
                            string capxx = array[1];
                            string loaiBanAnQd = array[2];
                            string sobananorqd = array[3];
                            string idDongBo = array[4];
                            decimal success = 0;
                            decimal fail = 0;
                            HuyChuyen(idDongBo, out success, out fail);
                            vCountSuccess = vCountSuccess + success;
                            vCountFail = vCountFail + fail;
                        }
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG:
                    foreach (DataGridItem Item in aldDgList_All.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null && chkChon.Checked)
                        {
                            string input = chkChon.ToolTip;
                            string[] array = input.Split(',');
                            decimal vDuongSuId = Convert.ToDecimal(array[0]);
                            string capxx = array[1];
                            string loaiBanAnQd = array[2];
                            string sobananorqd = array[3];
                            string idDongBo = array[4];
                            decimal success = 0;
                            decimal fail = 0;
                            HuyChuyen(idDongBo, out success, out fail);
                            vCountSuccess = vCountSuccess + success;
                            vCountFail = vCountFail + fail;
                        }
                    }
                    break;
                case ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI:
                    foreach (DataGridItem Item in aktDgList_All.Items)
                    {
                        CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                        if (chkChon != null && chkChon.Checked)
                        {
                            string input = chkChon.ToolTip;
                            string[] array = input.Split(',');
                            decimal vDuongSuId = Convert.ToDecimal(array[0]);
                            string capxx = array[1];
                            string loaiBanAnQd = array[2];
                            string sobananorqd = array[3];
                            string idDongBo = array[4];
                            decimal success = 0;
                            decimal fail = 0;
                            HuyChuyen(idDongBo, out success, out fail);
                            vCountSuccess = vCountSuccess + success;
                            vCountFail = vCountFail + fail;
                        }
                    }
                    break;
                default: return;
            }
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + vCountSuccess + " bản ghi thành công và " + vCountFail + " bản ghi thất bại');", true);
            hddPageIndex.Value = "1";
            Load_Data();
        }

        private string thamSoHinhPhat(DataRow row)
        {
            string soNam = row["TG_NAM"].ToString();
            string soThang = row["TG_THANG"].ToString();
            string soNgay = row["TG_NGAY"].ToString();
            string soTien = row["SH_VALUE"].ToString();
            return string.Format("Số Năm: {0}, Số Tháng: {1},  Số ngày: {2}, Số tiền phạt: {3}", getSo(soNam), getSo(soThang), getSo(soNgay), getSoTien(soTien));
        }
        private string getSo(string so)
        {
            if (string.IsNullOrEmpty(so)) return "0";
            return so;
        }
        private string getSoTien(string soTien)
        {
            if (string.IsNullOrEmpty(soTien)) return "0";
            return Convert.ToDecimal(soTien).ToString("N0");

        }
        protected void GuiLai(string vDongBoID)
        {
            string loaiAn = ddlLoaiAn.SelectedValue;
            decimal vCount = 0;
            if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH) // Nếu là HNGD giữ nguyên logic cũ
            {
                DLQGC06_BL oBL = new DLQGC06_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.GetDulieuChon_DaDongBO(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Đẩy lại bản ghi moi
                    DataRow row = tbl.Rows[0];
                    C06_TOAAN_TINHTRANGHONNHAN obj = new C06_TOAAN_TINHTRANGHONNHAN
                    {
                        LOAIAN_ID = row["LOAIAN_ID"] + "",
                        LOAI_AN_TEN = row["LOAI_AN_TEN"] + "",
                        LOAI_BAQD = row["LOAIBAQD"] + "",
                        MAVUVIEC = row["MavuAn"] + "",
                        TenVuAn = row["TenVuAn"] + "",
                        DONID = row["DONID"] + "",
                        BAQD_ID = row["BAQD_ID"] + "",
                        SO_BAN_AN = row["SO_BAN_AN"] + "",
                        NGAY_RA_BAN_AN = row["NGAY_RA_BAN_AN"] + "",
                        NGAY_HIEU_LUC_BA = row["NGAY_HIEU_LUC_BA"] + "",
                        DON_VI_RA_BAN_AN_ID = row["DON_VI_RA_BAN_AN_ID"] + "",
                        DON_VI_RA_BAN_AN_TEN = row["DON_VI_RA_BAN_AN_TEN"] + "",
                        NGAY_NHAN_NGUYEN_DON = row["NGAY_NHAN_NGUYEN_DON"] + "",
                        NGUYENDON_ID = row["NGUYENDON_ID"] + "",
                        BIDON_ID = row["BIDON_ID"] + "",
                        THULY = row["THULY"] + "",
                        NGAY_NHAN_BI_DON = row["NGAY_NHAN_BI_DON"] + "",
                        HO_TEN_NGUYEN_DON = row["HO_TEN_NGUYEN_DON"] + "",
                        SO_GIAY_TO_NGUYEN_DON = row["SO_GIAY_TO_NGUYEN_DON"] + "",
                        NGAY_SINH_NGUYEN_DON = row["NGAY_SINH_NGUYEN_DON"] + "",
                        QUOC_TICH_NGUYEN_DON = row["QUOC_TICH_NGUYEN_DON"] + "",
                        HO_TEN_BI_DON = row["HO_TEN_BI_DON"] + "",
                        SO_GIAY_TO_BI_DON = row["SO_GIAY_TO_BI_DON"] + "",
                        NGAY_SINH_BI_DON = row["NGAY_SINH_BI_DON"] + "",
                        QUOC_TICH_BI_DON = row["QUOC_TICH_BI_DON"] + "",
                        TRANG_THAI_TTHN = row["TRANG_THAI_TTHN"] + "",
                        trangThaiBanGhi = "1",// Gưi lại luôn là Them moi
                        ghiChu = "Thêm mới",
                        CAPXX = row["CAPXX"] + "",
                        KHANGCAOQH = row["KHANGCAOQH"] + "",
                        TRANG_THAI_DONGBO = "0",
                        NGAYGUI = DateTime.Now,
                        TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                        STATUS = "1",
                        trangThaiXacThucNguyenDon = row["trangThaiXacThucNguyenDon"] + "",
                        trangThaiXacThucBiDon = row["trangThaiXacThucBiDon"] + "",
                        maDinhDanhBanAn = row["maDinhDanhBanAn"] + "",
                        loaiViec = row["loaiViec"] + ""
                    };

                    //cập nhật STATUS = 0
                    if (oBL.ThuHoi_C06_TOAAN_TINHTRANGHONNHAN(vDongBoID))
                    {
                        //Insert bản ghi mới 
                        //Add các doi tuong vao mang de thuc hien insert
                        if (oBL.InsertC06_TOAAN_TINHTRANGHONNHAN(obj))
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);

                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);

                    }

                }
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            {
                DLQGC06_ADS_BL adsBL = new DLQGC06_ADS_BL();
                DataTable tbl = adsBL.C06_ADS_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                    if (adsBL.ThuHoi_C06_TOAAN_DANSU(vDongBoID, "", "0"))
                    {
                        DataTable tblGuiLai = adsBL.C06_ADS_DUONGSU_GUILAI(vDongBoID);
                        if (tblGuiLai.Rows.Count > 0)
                        {
                            var obj = new C06_TOAAN_DANSU()
                            {
                                SOBANANORQD = tblGuiLai.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tblGuiLai.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tblGuiLai.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tblGuiLai.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tblGuiLai.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tblGuiLai.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tblGuiLai.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tblGuiLai.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tblGuiLai.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tblGuiLai.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tblGuiLai.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tblGuiLai.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tblGuiLai.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tblGuiLai.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tblGuiLai.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tblGuiLai.Rows[0]["TENVUAN"].ToString(),
                                THULY = tblGuiLai.Rows[0]["THULY"].ToString(),
                                DUONGSUID = Convert.ToDecimal(tblGuiLai.Rows[0]["DUONGSUID"].ToString()),
                                VUANID = Convert.ToDecimal(tblGuiLai.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIADS = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                GHICHU = "Thêm mới do gửi lại",
                                MAQUANHEPHAPLUAT = tblGuiLai.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tblGuiLai.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tblGuiLai.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tblGuiLai.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tblGuiLai.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tblGuiLai.Rows[0]["LOAIBAQD"].ToString(),
                            };
                            //Insert bản ghi mới là thu hồi
                            //Add các doi tuong vao mang de thuc hien insert
                            //dt.C06_TOAAN_DANSU.Add(obj);
                            if (adsBL.C06_TOAAN_DANSU_INSERT(obj))
                            {
                                vCount = vCount + 1;
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);

                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);

                        }
                    }
                }
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            {
                DLQGC06_AHC_BL ahcBL = new DLQGC06_AHC_BL();
                DataTable tbl = ahcBL.C06_AHC_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                    if (ahcBL.ThuHoi_C06_TOAAN_HANHCHINH(vDongBoID, "", "0"))
                    {
                        DataTable tblGuiLai = ahcBL.c06_ahc_duongsu_guilai(vDongBoID);
                        if (tblGuiLai.Rows.Count > 0)
                        {
                            var obj = new C06_TOAAN_HANHCHINH()
                            {
                                SOBANANORQD = tblGuiLai.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tblGuiLai.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tblGuiLai.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tblGuiLai.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tblGuiLai.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tblGuiLai.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tblGuiLai.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tblGuiLai.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tblGuiLai.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tblGuiLai.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tblGuiLai.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tblGuiLai.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tblGuiLai.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tblGuiLai.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tblGuiLai.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tblGuiLai.Rows[0]["TENVUAN"].ToString(),
                                THULY = tblGuiLai.Rows[0]["THULY"].ToString(),
                                DUONGSUID = Convert.ToDecimal(tblGuiLai.Rows[0]["DUONGSUID"].ToString()),
                                VUANID = Convert.ToDecimal(tblGuiLai.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIAHC = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                GHICHU = "Thêm mới do gửi lại",
                                MAQUANHEPHAPLUAT = tblGuiLai.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tblGuiLai.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tblGuiLai.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tblGuiLai.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tblGuiLai.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tblGuiLai.Rows[0]["LOAIBAQD"].ToString(),
                            };
                            //Insert bản ghi mới là thu hồi
                            //Add các doi tuong vao mang de thuc hien insert
                            //dt.C06_TOAAN_HANHCHINH.Add(obj);
                            if (ahcBL.C06_TOAAN_HANHCHINH_INSERT(obj))
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);

                        }
                    }
                }
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            {
                DLQGC06_ALD_BL aldBL = new DLQGC06_ALD_BL();
                DataTable tbl = aldBL.C06_ALD_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                    if (aldBL.ThuHoi_C06_TOAAN_LAODONG(vDongBoID, "", "0"))
                    {
                        DataTable tblGuiLai = aldBL.C06_ALD_DUONGSU_GUILAI(vDongBoID);
                        if (tblGuiLai.Rows.Count > 0)
                        {
                            var obj = new C06_TOAAN_LAODONG()
                            {
                                SOBANANORQD = tblGuiLai.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tblGuiLai.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tblGuiLai.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tblGuiLai.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tblGuiLai.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tblGuiLai.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tblGuiLai.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tblGuiLai.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tblGuiLai.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tblGuiLai.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tblGuiLai.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tblGuiLai.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tblGuiLai.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tblGuiLai.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tblGuiLai.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tblGuiLai.Rows[0]["TENVUAN"].ToString(),
                                THULY = tblGuiLai.Rows[0]["THULY"].ToString(),
                                DUONGSUID = Convert.ToDecimal(tblGuiLai.Rows[0]["DUONGSUID"].ToString()),
                                VUANID = Convert.ToDecimal(tblGuiLai.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIALD = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                GHICHU = "Thêm mới do gửi lại",
                                MAQUANHEPHAPLUAT = tblGuiLai.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tblGuiLai.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tblGuiLai.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tblGuiLai.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tblGuiLai.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tblGuiLai.Rows[0]["LOAIBAQD"].ToString(),
                            };
                            //Insert bản ghi mới là thu hồi
                            //Add các doi tuong vao mang de thuc hien insert
                            //dt.C06_TOAAN_LAODONG.Add(obj);
                            if (aldBL.C06_TOAAN_LAODONG_INSERT(obj))
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);

                        }
                    }
                }
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            {
                DLQGC06_AKT_BL aktBL = new DLQGC06_AKT_BL();
                DataTable tbl = aktBL.C06_AKT_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                    if (aktBL.ThuHoi_C06_TOAAN_KDTM(vDongBoID, "", "0"))
                    {
                        DataTable tblGuiLai = aktBL.C06_AKT_DUONGSU_GUILAI(vDongBoID);
                        if (tblGuiLai.Rows.Count > 0)
                        {
                            var obj = new C06_TOAAN_KDTM()
                            {
                                SOBANANORQD = tblGuiLai.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tblGuiLai.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tblGuiLai.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tblGuiLai.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tblGuiLai.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tblGuiLai.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tblGuiLai.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tblGuiLai.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tblGuiLai.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tblGuiLai.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tblGuiLai.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tblGuiLai.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tblGuiLai.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tblGuiLai.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tblGuiLai.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tblGuiLai.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tblGuiLai.Rows[0]["TENVUAN"].ToString(),
                                THULY = tblGuiLai.Rows[0]["THULY"].ToString(),
                                DUONGSUID = Convert.ToDecimal(tblGuiLai.Rows[0]["DUONGSUID"].ToString()),
                                VUANID = Convert.ToDecimal(tblGuiLai.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIAKDTM = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                GHICHU = "Thêm mới do gửi lại",
                                MAQUANHEPHAPLUAT = tblGuiLai.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tblGuiLai.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tblGuiLai.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tblGuiLai.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tblGuiLai.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tblGuiLai.Rows[0]["LOAIBAQD"].ToString(),
                            };
                            //dt.C06_TOAAN_KDTM.Add(obj);
                            //Insert bản ghi mới là thu hồi
                            //Add các doi tuong vao mang de thuc hien insert
                            if (aktBL.C06_TOAAN_KDTM_INSERT(obj))
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                            }
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                        }
                    }
                }
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }
            else if (loaiAn == ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU) // Nếu là AHS xử lý ở đây
            {
                DLQGC06_AHS_BL ahsBL = new DLQGC06_AHS_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = ahsBL.GetDulieuChon_DaDongBO(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Đẩy lại bản ghi moi

                    DataRow row = tbl.Rows[0];
                    C06_TOAAN_HINHSU_MODEL oldObj = new C06_TOAAN_HINHSU_MODEL()
                    {
                        SOBANANORQD = row["sobananorqd"].ToString(),
                        NGAYRABANAN = row["ngayrabanan"].ToString(),
                        MADONVIRABANAN = row["madonvirabanan"].ToString(),
                        TENDONVIRABANAN = row["tendonvirabanan"].ToString(),
                        BQD = row["bqd"].ToString(),
                        DSTOIDANH = row["dstoidanh"].ToString(),
                        MAHINHPHATCHINH = row["mahinhphatchinh"].ToString(),
                        TENHINHPHATCHINH = row["tenhinhphatchinh"].ToString(),
                        THAMSOHINHPHATCHINH = row["thamsohinhphatchinh"].ToString(),
                        DSHINHPHATBOSUNG = row["dshinhphatbosung"].ToString(),
                        NGAYHIEULUCBA = row["ngayhieulucba"].ToString(),
                        HOTENBICAO = row["hotenbicao"].ToString(),
                        SOGIAYTOBICAO = row["sogiaytobicao"].ToString(),
                        NGAYSINHBICAO = row["NGAYSINHBICAO"].ToString(),
                        MAQUOCTICHBICAO = row["maquoctichbicao"].ToString(),
                        TENQUOCTICHBICAO = row["tenquoctichbicao"].ToString(),
                        MATHANHPHOTINHBICAO = row["mathanhphotinhbicao"].ToString(),
                        TENTHANHPHOTINHBICAO = row["tenthanhphotinhbicao"].ToString(),
                        MAQUANHUYENBICAO = row["maquanhuyenbicao"].ToString(),
                        TENQUANHUYENBICAO = row["tenquanhuyenbicao"].ToString(),
                        MAPHUONGXABICAO = row["maphuongxabicao"].ToString(),
                        TENPHUONGXABICAO = row["tenphuongxabicao"].ToString(),
                        DIACHIBICAO = row["diachibicao"].ToString(),
                        GHICHU = "",
                        VUANID = Convert.ToDecimal(row["vuanid"].ToString()),
                        BICANID = Convert.ToDecimal(row["bicanid"].ToString()),
                        TAIKHOANGUI = row["TAIKHOANGUI"].ToString(),
                        TENVUAN = row["tenvuan"].ToString(),
                        THULY = row["thuly"].ToString(),
                        CAPXX = row["CAPXX"].ToString(),
                        HinhPhatTh = tbl.Rows[0]["HINHPHAT_TH"].ToString(),
                        ToiDanhTH = tbl.Rows[0]["TOIDANH_TH"].ToString(),
                        ThamPhan = tbl.Rows[0]["THAMPHAN"].ToString(),
                        TRANGTHAIAHS = tbl.Rows[0]["TRANGTHAIAHS"].ToString()
                    };

                    //cập nhật STATUS = 0
                    if (ahsBL.ThuHoi_C06_TOAAN_HINHSU_GUILAI(vDongBoID, ""))
                    {
                        //Insert bản ghi mới 
                        //Add các doi tuong vao mang de thuc hien insert
                        DataTable tblNewBiCan = ahsBL.C06_AHS_BICAN_GETBYID(oldObj.BICANID, oldObj.CAPXX, oldObj.BQD);
                        if (tblNewBiCan.Rows.Count > 0)
                        {
                            var model = new C06_TOAAN_HINHSU_MODEL()
                            {
                                SOBANANORQD = tblNewBiCan.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tblNewBiCan.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tblNewBiCan.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                BQD = tblNewBiCan.Rows[0]["BQD"].ToString(),
                                NGAYHIEULUCBA = tblNewBiCan.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENBICAO = tblNewBiCan.Rows[0]["HOTENBICAO"].ToString(),
                                SOGIAYTOBICAO = tblNewBiCan.Rows[0]["SOGIAYTOBICAO"].ToString(),
                                NGAYSINHBICAO = tblNewBiCan.Rows[0]["NGAYSINHBICAO"].ToString(),
                                MAQUOCTICHBICAO = tblNewBiCan.Rows[0]["MAQUOCTICHBICAO"].ToString(),
                                TENQUOCTICHBICAO = tblNewBiCan.Rows[0]["TENQUOCTICHBICAO"].ToString(),
                                MATHANHPHOTINHBICAO = tblNewBiCan.Rows[0]["MATHANHPHOTINHBICAO"].ToString(),
                                TENTHANHPHOTINHBICAO = tblNewBiCan.Rows[0]["TENTHANHPHOTINHBICAO"].ToString(),
                                MAQUANHUYENBICAO = tblNewBiCan.Rows[0]["MAQUANHUYENBICAO"].ToString(),
                                TENQUANHUYENBICAO = tblNewBiCan.Rows[0]["TENQUANHUYENBICAO"].ToString(),
                                MAPHUONGXABICAO = tblNewBiCan.Rows[0]["MAPHUONGXABICAO"].ToString(),
                                TENPHUONGXABICAO = tblNewBiCan.Rows[0]["TENPHUONGXABICAO"].ToString(),
                                DIACHIBICAO = tblNewBiCan.Rows[0]["DIACHIBICAO"].ToString(),
                                TENVUAN = tblNewBiCan.Rows[0]["TENVUAN"].ToString(),
                                THULY = tblNewBiCan.Rows[0]["THULY"].ToString(),
                                BICANID = oldObj.BICANID,
                                VUANID = oldObj.VUANID,
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                CAPXX = tblNewBiCan.Rows[0]["CAPXX"].ToString(),
                                HinhPhatTh = tblNewBiCan.Rows[0]["HINHPHAT_TH"].ToString(),
                                ToiDanhTH = tblNewBiCan.Rows[0]["TOIDANH_TH"].ToString(),
                                ThamPhan = tblNewBiCan.Rows[0]["THAMPHAN"].ToString()
                            };
                            DataTable toiDanh = ahsBL.c06_ahs_dongbo_get_toidanh(oldObj.BICANID, oldObj.CAPXX, oldObj.BQD);

                            if (toiDanh.Rows.Count > 0)
                            {
                                List<ToiDanhModel> toiDanhs = new List<ToiDanhModel>();
                                foreach (DataRow rowToiDanh in toiDanh.Rows)
                                {
                                    var item = new ToiDanhModel()
                                    {
                                        maToiDanh = rowToiDanh["ID"].ToString(),
                                        tenToiDanh = rowToiDanh["TENTOIDANH"].ToString()
                                    };
                                    // Lấy danh sách hình phạt
                                    DataTable dsHinhPhatTbl = ahsBL.c06_ahs_toidanh_hinhphat_getbyid(oldObj.BICANID,
                                        Convert.ToDecimal(item.maToiDanh), oldObj.CAPXX, oldObj.BQD, "1");
                                    List<HinhPhatModel> dsHinhPhats = new List<HinhPhatModel>();
                                    if (dsHinhPhatTbl.Rows.Count > 0)
                                    {
                                        foreach (DataRow hp in dsHinhPhatTbl.Rows)
                                        {
                                            var hinhPhatItem = new HinhPhatModel()
                                            {
                                                maHinhPhat = hp["MAHINHPHAT"].ToString(),
                                                tenHinhPhat = hp["TENHINHPHAT"].ToString(),
                                                thamSoHinhPhat = thamSoHinhPhat(hp),
                                                hinhPhatChinh = hp["ISCHANGE"].ToString() == "0" ? 1 : 0 // Nếu ISCHANGE = "0" là hpc; "1" là hpbs
                                            };
                                            dsHinhPhats.Add(hinhPhatItem);
                                        }
                                    }
                                    item.dSachHinhPhat = dsHinhPhats;
                                    toiDanhs.Add(item);
                                }
                                string toiDanhJson = JsonConvert.SerializeObject(toiDanhs, Formatting.None);
                                model.DSTOIDANH = toiDanhJson;
                            }
                            
                            // THực hiện insert bản ghi với thông tin mới 
                            if (ahsBL.C06_TOAAN_HINHSU_INSERT_GUILAI(model))
                            {
                                var json = new JavaScriptSerializer().Serialize(oldObj);
                                var vLichSu = ahsBL.C06_AHS_ADD_HISTORY(Convert.ToDecimal(vDongBoID), "Gửi lại", json,
                                    Session[ENUM_SESSION.SESSION_USERNAME] + "", Convert.ToDecimal(row["bicanid"].ToString()), Convert.ToDecimal(row["vuanid"].ToString()), "Gửi lại");
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);

                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                            }
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                    }

                }
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }

        }
        protected void HuyChuyen(string vDongBoID, out decimal vCountSuccess, out decimal vCountFail)
        {
            vCountSuccess = 0;
            vCountFail = 0;
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH) // Nếu là HNGD giữ nguyên logic cũ
            {
                //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
                DLQGC06_BL oBL = new DLQGC06_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.GetDulieuChon_DaDongBO(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                    DataRow row = tbl.Rows[0];
                    if (row["TRANG_THAI_DONGBO"] + "" == "1")
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang Dữ liệu dân cư quốc gia, không được thu hồi!');", true);
                    }
                    else
                    {
                        //Kiểm tra lại nếu bản ghi do Thu hoi gửi lại thì khi Huy chuyen phải cập nhật lại bản ghi trước đó
                        string loaiAn = row["LOAIAN_ID"] + "";
                        string LoaiBAQD = row["LOAIBAQD"] + "";
                        string idBaQD = row["BAQD_ID"] + "";
                        DataTable tblThuHoi = oBL.GetDulieuChon_ThuHoiGanNhat(loaiAn, LoaiBAQD, idBaQD);
                        if (tblThuHoi.Rows.Count > 0)
                        {
                            DataRow rowb = tblThuHoi.Rows[0];
                            string vIDThuHoi = rowb["ID"] + "";
                            //Cập nhật lại trạng thái bản ghi gần nhất thu hồi
                            oBL.C06_KhoiPhucBanGhiThuHoi(vIDThuHoi);
                            //Xóa dữ liệu khi Hủy chuyen
                            oBL.DeleteC06_TOAAN_TINHTRANGHONNHAN(vDongBoID);
                            //Thong bao thu hoi thanh cong
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đã Hủy chuyển thành công!');", true);
                            hddPageIndex.Value = "1";
                            Load_Data();
                        }
                        else
                        {

                            C06_TOAAN_TINHTRANGHONNHAN obj = new C06_TOAAN_TINHTRANGHONNHAN
                            {
                                LOAIAN_ID = row["LOAIAN_ID"] + "",
                                LOAI_AN_TEN = row["LOAI_AN_TEN"] + "",
                                LOAI_BAQD = row["LOAIBAQD"] + "",
                                MAVUVIEC = row["MavuAn"] + "",
                                TenVuAn = row["TenVuAn"] + "",
                                DONID = row["DONID"] + "",
                                BAQD_ID = row["BAQD_ID"] + "",
                                SO_BAN_AN = row["SO_BAN_AN"] + "",
                                NGAY_RA_BAN_AN = row["NGAY_RA_BAN_AN"] + "",
                                NGAY_HIEU_LUC_BA = row["NGAY_HIEU_LUC_BA"] + "",
                                DON_VI_RA_BAN_AN_ID = row["DON_VI_RA_BAN_AN_ID"] + "",
                                DON_VI_RA_BAN_AN_TEN = row["DON_VI_RA_BAN_AN_TEN"] + "",
                                NGAY_NHAN_NGUYEN_DON = row["NGAY_NHAN_NGUYEN_DON"] + "",
                                NGUYENDON_ID = row["NGUYENDON_ID"] + "",
                                BIDON_ID = row["BIDON_ID"] + "",
                                THULY = row["THULY"] + "",
                                NGAY_NHAN_BI_DON = row["NGAY_NHAN_BI_DON"] + "",
                                HO_TEN_NGUYEN_DON = row["HO_TEN_NGUYEN_DON"] + "",
                                SO_GIAY_TO_NGUYEN_DON = row["SO_GIAY_TO_NGUYEN_DON"] + "",
                                NGAY_SINH_NGUYEN_DON = row["NGAY_SINH_NGUYEN_DON"] + "",
                                QUOC_TICH_NGUYEN_DON = row["QUOC_TICH_NGUYEN_DON"] + "",
                                HO_TEN_BI_DON = row["HO_TEN_BI_DON"] + "",
                                SO_GIAY_TO_BI_DON = row["SO_GIAY_TO_BI_DON"] + "",
                                NGAY_SINH_BI_DON = row["NGAY_SINH_BI_DON"] + "",
                                QUOC_TICH_BI_DON = row["QUOC_TICH_BI_DON"] + "",
                                TRANG_THAI_TTHN = row["TRANG_THAI_TTHN"] + "",
                                trangThaiBanGhi = row["trangThaiBanGhi"] + "",
                                ghiChu = row["ghiChu"] + "",
                                CAPXX = row["CAPXX"] + "",
                                KHANGCAOQH = row["KHANGCAOQH"] + "",
                                TRANG_THAI_DONGBO = row["TRANG_THAI_DONGBO"] + "",
                                NGAYGUI = Convert.ToDateTime(row["NGAYGUI"]),
                                TAIKHOANGUI = row["TAIKHOANGUI"] + "",
                                STATUS = row["status"] + "",
                                trangThaiXacThucNguyenDon = row["trangThaiXacThucNguyenDon"] + "",
                                trangThaiXacThucBiDon = row["trangThaiXacThucBiDon"] + "",
                                maDinhDanhBanAn = row["maDinhDanhBanAn"] + "",
                                loaiViec = row["loaiViec"] + ""
                            };

                            //Dữ liệu chưa đồng bộ thì được xóa
                            if (oBL.DeleteC06_TOAAN_TINHTRANGHONNHAN(vDongBoID))
                            {
                                //Luu thong tin truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(obj);
                                var vLichSu = oBL.HistoryDeleteC06_TOAAN_TINHTRANGHONNHAN(vDongBoID, "Hủy chuyển khi chưa đồng bộ sang C06", json, Session[ENUM_SESSION.SESSION_USERNAME] + "");
                                //Thong bao thu hoi thanh cong
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đã Hủy chuyển thành công!');", true);
                                hddPageIndex.Value = "1";
                                Load_Data();
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                            }
                        }
                    }
                }
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC_NUMBER.AN_DANSU)
            {
                //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
                DLQGC06_ADS_BL oBL = new DLQGC06_ADS_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.C06_ADS_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                    DataRow row = tbl.Rows[0];
                    if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                    {
                        vCountFail++;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
                    }
                    else
                    {
                        //Kiểm tra lại nếu bản ghi do Thu hoi gửi lại thì khi Huy chuyen phải cập nhật lại bản ghi trước đó
                        decimal vDuongSuId = Convert.ToDecimal(row["DUONGSUID"] + "");
                        DataTable tblThuHoi = oBL.GETDULIEUCHON_THUHOIGANNHAT(vDuongSuId);
                        if (tblThuHoi.Rows.Count > 0)
                        {
                            DataRow rowb = tblThuHoi.Rows[0];
                            string vIDThuHoi = rowb["C06_ID"] + "";
                            //Cập nhật lại trạng thái bản ghi gần nhất thu hồi
                            oBL.C06_KhoiPhucBanGhiThuHoi(vIDThuHoi);
                            //Xóa dữ liệu khi Hủy chuyen
                            oBL.XoaC06_TOAAN_DANSU(vDongBoID);
                            //Thong bao thu hoi thanh cong
                            vCountSuccess++;
                        }
                        else
                        {
                            C06_TOAAN_DANSU obj = new C06_TOAAN_DANSU()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIADS = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            //Dữ liệu chưa đồng bộ thì được xóa
                            if (oBL.XoaC06_TOAAN_DANSU(vDongBoID))
                            {
                                //Luu thong tin truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(obj);
                                oBL.C06_ADS_ADD_HISTORY(Convert.ToDecimal(vDongBoID), "Hủy chuyển khi chưa đồng bộ sang C06", json, Session[ENUM_SESSION.SESSION_USERNAME] + "", obj.VUANID.Value, obj.DUONGSUID.Value, "Hủy chuyển");

                                //Thong bao thu hoi thanh cong
                                vCountSuccess++;
                            }
                            else
                            {
                                vCountFail++;
                            }
                        }
                    }
                }
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH)
            {
                //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
                DLQGC06_AHC_BL oBL = new DLQGC06_AHC_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.C06_AHC_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                    DataRow row = tbl.Rows[0];
                    if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                    {
                        vCountFail++;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
                    }
                    else
                    {
                        //Kiểm tra lại nếu bản ghi do Thu hoi gửi lại thì khi Huy chuyen phải cập nhật lại bản ghi trước đó
                        decimal vDuongSuId = Convert.ToDecimal(row["DUONGSUID"] + "");
                        string capxx = row["CAPXX_MA"] + "";
                        string loaiBanAnQd = row["LOAIBAQD"] + "";

                        DataTable tblThuHoi = oBL.GETDULIEUCHON_THUHOIGANNHAT(vDuongSuId);
                        if (tblThuHoi.Rows.Count > 0)
                        {
                            DataRow rowb = tblThuHoi.Rows[0];
                            string vIDThuHoi = rowb["C06_ID"] + "";
                            //Cập nhật lại trạng thái bản ghi gần nhất thu hồi
                            oBL.C06_KhoiPhucBanGhiThuHoi(vIDThuHoi);
                            //Xóa dữ liệu khi Hủy chuyen
                            oBL.XoaC06_TOAAN_HANHCHINH(vDongBoID);
                            //Thong bao thu hoi thanh cong
                            vCountSuccess++;
                        }
                        else
                        {
                            C06_TOAAN_HANHCHINH obj = new C06_TOAAN_HANHCHINH()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIAHC = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            //Dữ liệu chưa đồng bộ thì được xóa
                            if (oBL.XoaC06_TOAAN_HANHCHINH(vDongBoID))
                            {
                                //Luu thong tin truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(obj);
                                oBL.C06_AHC_ADD_HISTORY(Convert.ToDecimal(vDongBoID), "Hủy chuyển khi chưa đồng bộ sang C06", json, Session[ENUM_SESSION.SESSION_USERNAME] + "", obj.VUANID.Value, obj.DUONGSUID.Value, "Hủy chuyển");

                                //Thong bao thu hoi thanh cong
                                vCountSuccess++;
                            }
                            else
                            {
                                vCountFail++;
                            }
                        }
                    }
                }
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG)
            {
                //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
                DLQGC06_ALD_BL oBL = new DLQGC06_ALD_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.C06_ALD_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                    DataRow row = tbl.Rows[0];
                    if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                    {
                        vCountFail++;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
                    }
                    else
                    {
                        //Kiểm tra lại nếu bản ghi do Thu hoi gửi lại thì khi Huy chuyen phải cập nhật lại bản ghi trước đó
                        decimal vDuongSuId = Convert.ToDecimal(row["DUONGSUID"] + "");
                        string capxx = row["CAPXX_MA"] + "";
                        string loaiBanAnQd = row["LOAIBAQD"] + "";

                        DataTable tblThuHoi = oBL.GETDULIEUCHON_THUHOIGANNHAT(vDuongSuId);
                        if (tblThuHoi.Rows.Count > 0)
                        {
                            DataRow rowb = tblThuHoi.Rows[0];
                            string vIDThuHoi = row["C06_ID"] + "";
                            //Cập nhật lại trạng thái bản ghi gần nhất thu hồi
                            oBL.C06_KhoiPhucBanGhiThuHoi(vIDThuHoi);
                            //Xóa dữ liệu khi Hủy chuyen
                            oBL.XoaC06_TOAAN_LAODONG(vDongBoID);
                            //Thong bao thu hoi thanh cong
                            vCountSuccess++;
                        }
                        else
                        {
                            C06_TOAAN_LAODONG obj = new C06_TOAAN_LAODONG()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIALD = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            //Dữ liệu chưa đồng bộ thì được xóa
                            if (oBL.XoaC06_TOAAN_LAODONG(vDongBoID))
                            {
                                //Luu thong tin truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(obj);
                                oBL.C06_ALD_ADD_HISTORY(Convert.ToDecimal(vDongBoID), "Hủy chuyển khi chưa đồng bộ sang C06", json, Session[ENUM_SESSION.SESSION_USERNAME] + "", obj.VUANID.Value, obj.DUONGSUID.Value, "Hủy chuyển");
                                //Thong bao thu hoi thanh cong
                                vCountSuccess++;
                            }
                            else
                            {
                                vCountFail++;
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                            }
                        }
                    }
                }
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI)
            {
                //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
                DLQGC06_AKT_BL oBL = new DLQGC06_AKT_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.C06_AKT_SEARCH_BY_ID(vDongBoID);
                if (tbl.Rows.Count > 0)
                {
                    //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                    DataRow row = tbl.Rows[0];
                    if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                    {
                        vCountFail++;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
                    }
                    else
                    {
                        //Kiểm tra lại nếu bản ghi do Thu hoi gửi lại thì khi Huy chuyen phải cập nhật lại bản ghi trước đó
                        decimal vDuongSuId = Convert.ToDecimal(row["DUONGSUID"] + "");
                        string capxx = row["CAPXX_MA"] + "";
                        string loaiBanAnQd = row["LOAIBAQD"] + "";

                        DataTable tblThuHoi = oBL.GETDULIEUCHON_THUHOIGANNHAT(vDuongSuId);
                        if (tblThuHoi.Rows.Count > 0)
                        {
                            DataRow rowb = tblThuHoi.Rows[0];
                            string vIDThuHoi = rowb["C06_ID"] + "";
                            //Cập nhật lại trạng thái bản ghi gần nhất thu hồi
                            oBL.C06_KhoiPhucBanGhiThuHoi(vIDThuHoi);
                            //Xóa dữ liệu khi Hủy chuyen
                            oBL.XoaC06_TOAAN_KDTM(vDongBoID);
                            //Thong bao thu hoi thanh cong
                            vCountSuccess++;
                        }
                        else
                        {
                            C06_TOAAN_KDTM obj = new C06_TOAAN_KDTM()
                            {
                                SOBANANORQD = tbl.Rows[0]["SOBANANORQD"].ToString(),
                                NGAYRABANAN = tbl.Rows[0]["NGAYRABANAN"].ToString(),
                                MADONVIRABANAN = tbl.Rows[0]["MADONVIRABANAN"].ToString(),
                                TENDONVIRABANAN = tbl.Rows[0]["TENDONVIRABANAN"].ToString(),
                                NGAYHIEULUCBA = tbl.Rows[0]["NGAYHIEULUCBA"].ToString(),
                                HOTENDUONGSU = tbl.Rows[0]["HOTENDUONGSU"].ToString(),
                                SOGIAYTODUONGSU = tbl.Rows[0]["SOGIAYTODUONGSU"].ToString(),
                                NGAYSINHDUONGSU = tbl.Rows[0]["NGAYSINHDUONGSU"].ToString(),
                                MAQUOCTICHDUONGSU = tbl.Rows[0]["MAQUOCTICHDUONGSU"].ToString(),
                                TENQUOCTICHDUONGSU = tbl.Rows[0]["TENQUOCTICHDUONGSU"].ToString(),
                                MATHANHPHOTINHDUONGSU = tbl.Rows[0]["MATHANHPHOTINHDUONGSU"].ToString(),
                                TENTHANHPHOTINHDUONGSU = tbl.Rows[0]["TENTHANHPHOTINHDUONGSU"].ToString(),
                                MAQUANHUYENDUONGSU = tbl.Rows[0]["MAQUANHUYENDUONGSU"].ToString(),
                                TENQUANHUYENDUONGSU = tbl.Rows[0]["TENQUANHUYENDUONGSU"].ToString(),
                                MAPHUONGXADUONGSU = tbl.Rows[0]["MAPHUONGXADUONGSU"].ToString(),
                                TENPHUONGXADUONGSU = tbl.Rows[0]["TENPHUONGXADUONGSU"].ToString(),
                                DIACHIDUONGSU = tbl.Rows[0]["DIACHIDUONGSU"].ToString(),
                                TENVUAN = tbl.Rows[0]["TENVUAN"].ToString(),
                                THULY = tbl.Rows[0]["THULY"].ToString(),
                                DUONGSUID = vDuongSuId,
                                VUANID = Convert.ToDecimal(tbl.Rows[0]["VUANID"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                                NGAYGUI = DateTime.Now,
                                TRANGTHAIAKDTM = "HIEU_LUC",
                                TRANGTHAIJOBSHARE = "0",
                                STATUS = "1",
                                MAQUANHEPHAPLUAT = tbl.Rows[0]["MAQUANHEPHAPLUAT"].ToString(),
                                TENQUANHEPHAPLUAT = tbl.Rows[0]["TENQUANHEPHAPLUAT"].ToString(),
                                MATUCACHTOTUNG = tbl.Rows[0]["MATUCACHTOTUNG"].ToString(),
                                TENTUCACHTOTUNG = tbl.Rows[0]["TENTUCACHTOTUNG"].ToString(),
                                CAPXX = tbl.Rows[0]["CAPXX_MA"].ToString(),
                                LOAIBAQD = tbl.Rows[0]["LOAIBAQD"].ToString(),
                            };

                            //Dữ liệu chưa đồng bộ thì được xóa
                            if (oBL.XoaC06_TOAAN_KDTM(vDongBoID))
                            {
                                //Luu thong tin truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(obj);
                                var vLichSu = oBL.C06_AKT_ADD_HISTORY(Convert.ToDecimal(vDongBoID), "Hủy chuyển khi chưa đồng bộ sang C06", json, Session[ENUM_SESSION.SESSION_USERNAME] + "", obj.VUANID.Value, obj.DUONGSUID.Value, "Hủy chuyển");
                                //Thong bao thu hoi thanh cong
                                vCountSuccess++;
                            }
                            else
                            {
                                vCountFail++;
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                            }
                        }
                    }
                }
            }
            if (ddlLoaiAn.SelectedValue == ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU)
            {
                //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
                DLQGC06_AHS_BL oBL = new DLQGC06_AHS_BL();
                // Lấy dữ liệu từ DB
                DataTable tbl = oBL.GetDulieuChon_DaDongBO(vDongBoID); // trong logic đã xử lý lấy dữ liệu chưa chuyển sang jobshared
                if (tbl.Rows.Count > 0)
                {
                    DataRow row = tbl.Rows[0];
                    if (row["trangthaijobshare"] + "" == "1") // Kiem tra xem đã đồng bộ sang jobshared chưa nếu đồng bộ thì không cho phép hủy chuyển
                    {
                        vCountFail++;
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
                    }
                    else
                    {
                        //Kiểm tra lại nếu bản ghi do Thu hoi gửi lại thì khi Huy chuyen phải cập nhật lại bản ghi trước đó
                        //string loaiAn = row["LOAIAN_ID"] + "";
                        //string LoaiBAQD = row["LOAIBAQD"] + "";
                        //string idBaQD = row["BAQD_ID"] + "";
                        DataTable tblThuHoi = oBL.C06_AHS_GetDulieuChon_ThuHoiGanNhat(Convert.ToDecimal(row["BICANID"].ToString()));
                        if (tblThuHoi.Rows.Count > 0)
                        {
                            DataRow rowb = tblThuHoi.Rows[0];
                            string vIDThuHoi = rowb["ID"] + "";
                            //Cập nhật lại trạng thái bản ghi gần nhất thu hồi
                            oBL.C06_AHS_KhoiPhucBanGhiThuHoi(vIDThuHoi);
                            //Xóa dữ liệu khi Hủy chuyen
                            oBL.DeleteC06_TOAAN_HINHSU(Convert.ToDecimal(vDongBoID));
                            //Thong bao thu hoi thanh cong
                            vCountSuccess++;

                        }
                        else
                        {

                            C06_TOAAN_HINHSU_MODEL obj = new C06_TOAAN_HINHSU_MODEL()
                            {
                                SOBANANORQD = row["sobananorqd"].ToString(),
                                NGAYRABANAN = row["ngayrabanan"].ToString(),
                                MADONVIRABANAN = row["madonvirabanan"].ToString(),
                                TENDONVIRABANAN = row["tendonvirabanan"].ToString(),
                                BQD = row["bqd"].ToString(),
                                DSTOIDANH = row["dstoidanh"].ToString(),
                                MAHINHPHATCHINH = row["mahinhphatchinh"].ToString(),
                                TENHINHPHATCHINH = row["tenhinhphatchinh"].ToString(),
                                THAMSOHINHPHATCHINH = row["thamsohinhphatchinh"].ToString(),
                                DSHINHPHATBOSUNG = row["dshinhphatbosung"].ToString(),
                                NGAYHIEULUCBA = row["ngayhieulucba"].ToString(),
                                HOTENBICAO = row["hotenbicao"].ToString(),
                                SOGIAYTOBICAO = row["sogiaytobicao"].ToString(),
                                NGAYSINHBICAO = row["NGAYSINHBICAO"].ToString(),
                                MAQUOCTICHBICAO = row["maquoctichbicao"].ToString(),
                                TENQUOCTICHBICAO = row["tenquoctichbicao"].ToString(),
                                MATHANHPHOTINHBICAO = row["mathanhphotinhbicao"].ToString(),
                                TENTHANHPHOTINHBICAO = row["tenthanhphotinhbicao"].ToString(),
                                MAQUANHUYENBICAO = row["maquanhuyenbicao"].ToString(),
                                TENQUANHUYENBICAO = row["tenquanhuyenbicao"].ToString(),
                                MAPHUONGXABICAO = row["maphuongxabicao"].ToString(),
                                TENPHUONGXABICAO = row["tenphuongxabicao"].ToString(),
                                DIACHIBICAO = row["diachibicao"].ToString(),
                                GHICHU = row["GHICHU"].ToString(),
                                VUANID = Convert.ToDecimal(row["vuanid"].ToString()),
                                BICANID = Convert.ToDecimal(row["bicanid"].ToString()),
                                TAIKHOANGUI = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                TENVUAN = row["tenvuan"].ToString(),
                                THULY = row["thuly"].ToString(),
                                CAPXX = row["CAPXX"].ToString(),
                                HinhPhatTh = tbl.Rows[0]["HINHPHAT_TH"].ToString(),
                                ToiDanhTH = tbl.Rows[0]["TOIDANH_TH"].ToString(),
                                ThamPhan = tbl.Rows[0]["THAMPHAN"].ToString(),
                                TRANGTHAIAHS = tbl.Rows[0]["TRANGTHAIAHS"].ToString()

                            };

                            //Dữ liệu chưa đồng bộ thì được xóa
                            if (oBL.DeleteC06_TOAAN_HINHSU(Convert.ToDecimal(vDongBoID)))
                            {
                                //Luu thong tin truoc khi xoa                            
                                var json = new JavaScriptSerializer().Serialize(obj);
                                var vLichSu = oBL.C06_AHS_ADD_HISTORY(Convert.ToDecimal(vDongBoID), "Hủy chuyển khi chưa đồng bộ sang C06", json,
                                    Session[ENUM_SESSION.SESSION_USERNAME] + "", Convert.ToDecimal(row["bicanid"].ToString()), Convert.ToDecimal(row["vuanid"].ToString()), "Hủy Chuyển");
                                vCountSuccess++;

                            }
                            else
                            {
                                vCountFail++;
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Huyer chuyển không thành công!');", true);
                            }
                        }
                    }
                }
            }
        }

        //Chuyển sang sử dụng GridView Chung cho 3 loại trạng thái
        protected void gvDanhSach_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string trangThai = DataBinder.Eval(e.Row.DataItem, "MA_TRANGTHAIBANGHI")?.ToString();
                string Id = DataBinder.Eval(e.Row.DataItem, "C06_AHS_ID")?.ToString();
                var lbtView = e.Row.FindControl("lbtView") as LinkButton;
                var lbtHuyChuyen = e.Row.FindControl("lbtHuyChuyen") as LinkButton;
                var lbtGuiLai = e.Row.FindControl("lbtGuiLai") as LinkButton;

                if (trangThai == "CDB") // Chưa đồng bộ
                {

                }
                else if (trangThai == "DDB") // Đã đồng bộ
                {
                    if (lbtView != null) lbtView.Visible = true;
                    if (lbtHuyChuyen != null)
                    {
                        //GTEL-HUNGNQ 24-10-25 thêm ẩn hiện theo trạng thái jobshare của hủy chuyển
                        DLQGC06_AHS_BL obl = new DLQGC06_AHS_BL();
                        // Lấy danh sách hình phạt
                        DataTable ahsDongBoTbl = obl.c06_toaan_hinhsu_getbyid(Convert.ToDecimal(Id));
                        if (ahsDongBoTbl.Rows[0]["TRANGTHAIJOBSHARE"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                            lbtHuyChuyen.Visible = true;
                        //END GTEL-HUNGNQ 24-10-25 thêm ẩn hiện theo trạng thái jobshare của hủy chuyển
                    }
                }
                else if (trangThai == "TH") // Thu hồi
                {
                    if (lbtGuiLai != null) lbtGuiLai.Visible = true;
                }
            }
        }
        protected void gvList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "View")
            {
                string IDview = e.CommandArgument.ToString();
                string[] split = IDview.Split(',');
                decimal biCanId = Convert.ToDecimal(split[0]);
                decimal vuAnId = Convert.ToDecimal(split[1]);

                string capxx = split[2];
                decimal id = Convert.ToDecimal(split[3]);
                string url = $"/QLAN/C06/pToiDanh.aspx?aID={vuAnId}&bID={biCanId}&capxx={capxx}&ID={id}";
                string script = $"PopupCenter('{url}', 'Tội Danh', 950, 450);";
                //string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo.aspx?vid=" + IDview.ToString() + "','Lịch sử đồng bộ',950,450);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), script, true);
                //string id = e.CommandArgument.ToString();
                // TODO: Code xử lý xem chi tiết
            }
            else if (e.CommandName == "HuyChuyen")
            {
                string id = e.CommandArgument.ToString();
                string CurrID = e.CommandArgument.ToString();
                decimal success = 0;
                decimal fail = 0;
                HuyChuyen(CurrID, out success, out fail);
                if (success > 0)
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + success + " bản ghi thành công');", true);
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + fail + " bản ghi thất bại');", true);
                }
                hddPageIndex.Value = "1";
                Load_Data();
                // TODO: Code xử lý sửa bản ghi
            }
            else if (e.CommandName == "GuiLai")
            {
                string id = e.CommandArgument.ToString();
                string CurrID = e.CommandArgument.ToString();
                GuiLai(CurrID);
                // TODO: Code xử lý xóa bản ghi
            }
            else if (e.CommandName == "History")
            {
                string IDview = e.CommandArgument.ToString();
                string[] split = IDview.Split(',');
                string biCanId = split[0];
                string vuAnId = split[1];
                string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo_Khac.aspx?bId=" + biCanId + "&vaId=" + vuAnId + "&vloaian=" + ddlLoaiAn.SelectedValue + "','Lịch sử đồng bộ',950,450);";
                System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);

                // TODO: Code xử lý xem chi tiết
            }
        }
        protected string GetSyncStatus(object trangThai, object ngayGui, object nguoiGui, object ngayThuHoi, object nguoiThuHoi)
        {
            if (trangThai == null) return string.Empty;
            string status = trangThai.ToString();

            if (status == "DDB")
            {
                return $"<b>Đã đồng bộ</b><br/>Ngày gửi: {ngayGui.ToString()}<br/>Người gửi: {nguoiGui}";
            }
            else if (status == "TH")
            {
                return $"<b>Thu hồi</b><br/>Ngày thu hồi: {ngayThuHoi.ToString()}<br/>Người thu hồi: {nguoiThuHoi}";
            }
            else
            {
                return $"<b>Chưa đồng bộ</b>";
            }
        }
        #endregion

        #region GTEL-HUNGNQ: adsDgList cho án dân sự
        protected void adsDgList_All_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "GuiLai":
                    string id = e.CommandArgument.ToString();
                    GuiLai(id);
                    break;
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(CurrID, out success, out fail);
                    if (success > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + success + " bản ghi thành công');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + fail + " bản ghi thất bại');", true);
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo_Khac.aspx?vid=" + IDview.ToString() + "&vloaian=" + ddlLoaiAn.SelectedValue + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }
        protected void adsDgList_All_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_ADS_BL oBL = new DLQGC06_ADS_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");

                if (rowView["C06_ID"] + "" != "")
                {
                    string vDongBoID = (rowView["C06_ID"] + "").ToString();

                    // Hủy chuyển
                    // Lấy dữ liệu từ DB
                    DataTable tbl = oBL.C06_ADS_SEARCH_BY_ID(vDongBoID);
                    if (tbl.Rows.Count > 0)
                    {
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataRow row = tbl.Rows[0];
                        if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                        {
                            if (row["TRANGTHAIADS"] + "" == "THU_HOI")
                                lbtHuyChuyen.Visible = false;
                            else
                                lbtHuyChuyen.Visible = true;
                        }
                    }
                }
            }
        }
        #endregion
        #region GTEL-HUNGNQ: ahcDgList cho án hành chính
        protected void ahcDgList_All_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "GuiLai":
                    string id = e.CommandArgument.ToString();
                    GuiLai(id);
                    break;
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(CurrID, out success, out fail);
                    if (success > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + success + " bản ghi thành công');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + fail + " bản ghi thất bại');", true);
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo_Khac.aspx?vid=" + IDview.ToString() + "&vloaian=" + ddlLoaiAn.SelectedValue + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }
        protected void ahcDgList_All_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_AHC_BL oBL = new DLQGC06_AHC_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");

                if (rowView["C06_ID"] + "" != "")
                {
                    string vDongBoID = (rowView["C06_ID"] + "").ToString();

                    // Hủy chuyển
                    // Lấy dữ liệu từ DB
                    DataTable tbl = oBL.C06_AHC_SEARCH_BY_ID(vDongBoID);
                    if (tbl.Rows.Count > 0)
                    {
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataRow row = tbl.Rows[0];
                        if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                        {
                            if (row["TRANGTHAIAHC"] + "" == "THU_HOI")
                                lbtHuyChuyen.Visible = false;
                            else
                                lbtHuyChuyen.Visible = true;
                        }
                    }
                }
            }
        }
        #endregion
        #region GTEL-HUNGNQ: aldDgList cho án lao động
        protected void aldDgList_All_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "GuiLai":
                    string id = e.CommandArgument.ToString();
                    GuiLai(id);
                    break;
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(CurrID, out success, out fail);
                    if (success > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + success + " bản ghi thành công');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + fail + " bản ghi thất bại');", true);
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo_Khac.aspx?vid=" + IDview.ToString() + "&vloaian=" + ddlLoaiAn.SelectedValue + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }
        protected void aldDgList_All_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_ALD_BL oBL = new DLQGC06_ALD_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");

                if (rowView["C06_ID"] + "" != "")
                {
                    string vDongBoID = (rowView["C06_ID"] + "").ToString();

                    // Hủy chuyển
                    // Lấy dữ liệu từ DB
                    DataTable tbl = oBL.C06_ALD_SEARCH_BY_ID(vDongBoID);
                    if (tbl.Rows.Count > 0)
                    {
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataRow row = tbl.Rows[0];
                        if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                        {
                            if (row["TRANGTHAIALD"] + "" == "THU_HOI")
                                lbtHuyChuyen.Visible = false;
                            else
                                lbtHuyChuyen.Visible = true;
                        }
                    }
                }
            }
        }
        #endregion
        #region GTEL-HUNGNQ: aktDgList cho án kinh tế
        protected void aktDgList_All_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "GuiLai":
                    string id = e.CommandArgument.ToString();
                    GuiLai(id);
                    break;
                case "HuyChuyen":
                    string CurrID = e.CommandArgument.ToString();
                    decimal success = 0;
                    decimal fail = 0;
                    HuyChuyen(CurrID, out success, out fail);
                    if (success > 0)
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + success + " bản ghi thành công');", true);
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển " + fail + " bản ghi thất bại');", true);
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
                case "View":
                    string IDview = e.CommandArgument.ToString();
                    string StrMsg = "PopupCenter('/QLAN/C06/LichSuDongBo_Khac.aspx?vid=" + IDview.ToString() + "&vloaian=" + ddlLoaiAn.SelectedValue + "','Lịch sử đồng bộ',950,450);";
                    System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
                    break;
            }
        }
        protected void aktDgList_All_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            DLQGC06_AKT_BL oBL = new DLQGC06_AKT_BL();
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtView = (LinkButton)e.Item.FindControl("lbtView");

                if (rowView["C06_ID"] + "" != "")
                {
                    string vDongBoID = (rowView["C06_ID"] + "").ToString();

                    // Hủy chuyển
                    // Lấy dữ liệu từ DB
                    DataTable tbl = oBL.C06_AKT_SEARCH_BY_ID(vDongBoID);
                    if (tbl.Rows.Count > 0)
                    {
                        //Kiem tra xem đã đồng bộ sang jobshared chưa nếu chưa cho phép thu hồi
                        DataRow row = tbl.Rows[0];
                        if (row["TRANGTHAIJOBSHARE"] + "" == "1")
                        {
                            lbtHuyChuyen.Visible = false;
                        }
                        else
                        {
                            if (row["TRANGTHAIAKDTM"] + "" == "THU_HOI")
                                lbtHuyChuyen.Visible = false;
                            else
                                lbtHuyChuyen.Visible = true;
                        }
                    }
                }
            }
        }
        #endregion
    }
}